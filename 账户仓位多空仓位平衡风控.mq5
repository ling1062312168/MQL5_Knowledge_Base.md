//+------------------------------------------------------------------+
//|                                          账户仓位多空仓位平衡风控.mq5  |
//|                              Copyright 2025, 风控系统               |
//|   功能: 监测账户所有订单, 总浮亏达阈值触发锁仓风控                    |
//|   核心: 账户浮亏达阈值 → 平衡品种锁仓 → 方向盈利50% → 渐进平仓      |
//|   参数: 浮亏锁仓阈值=-1000, 盈利阈值=50%, 最低保留=5                |
//+------------------------------------------------------------------+
#property copyright "风控系统"
#property version   "3.00"
#property description "账户仓位多空仓位平衡风控"
#property description "账户总浮亏→平衡品种锁仓→方向盈利→渐进平仓→解锁"
#include <Trade/Trade.mqh>

//+------------------------------------------------------------------+
//| 输入参数                                                          |
//+------------------------------------------------------------------+
input group "== 锁仓风控参数 =="
input double      InpLockDrawdownUSD   = 1000.0;   // 账户浮亏锁仓阈值($,正数如1000)
input double      InpUnlockRatio       = 0.50;     // 盈利解锁比例(方向盈利达此比例即解锁)
input double      InpMinHedgeProfit    = 5.0;      // 最低保留盈利(渐进平仓时需保留此额)
input int         InpSlippage          = 30;       // 滑点
input double      InpBalanceTolerance  = 0.01;     // 平衡容差(多空手数差≤此值视为平衡)

input group "== 面板位置 =="
input int         InpPanelX            = 10;       // 面板X(像素)
input int         InpPanelY            = 10;       // 面板Y(像素)

input group "== 颜色 =="
input color       InpColorNormal       = C'82,204,147';
input color       InpColorWarning      = C'250,180,80';
input color       InpColorDanger       = C'240,105,110';
input color       InpColorInfo         = C'66,153,225';

//+------------------------------------------------------------------+
//| 面板布局常量                                                      |
//+------------------------------------------------------------------+
#define PW              520       // 面板总宽度
#define PD              12        // 面板内边距
#define PG              8         // 行间距
#define HDR_H           48        // 标题栏高度
#define SG              8         // 卡片间距
#define LH              22        // 文本行高
#define BH              28        // 按钮高度
#define EH              22        // 输入框高度
#define BD_W            2         // 外边框宽度
#define CD_PD           10        // 卡片内边距
#define LW              ((PW - PD*2 - PG)/2)  // 左栏宽度
#define RW              LW                     // 右栏宽度
#define LOCK_COMMENT    "BRC_LOCK"          // 锁仓标记注释

//+------------------------------------------------------------------+
//| 结构体                                                            |
//+------------------------------------------------------------------+
struct PositionInfo
{
   ulong    ticket;
   string   symbol;
   double   openPrice;
   double   lots;
   double   profit;
   ENUM_POSITION_TYPE posType;
};

struct SymbolStats
{
   string   symbol;
   double   buyLots;
   double   sellLots;
   double   buyPnl;
   double   sellPnl;
   double   netLots;
   double   totalPnl;
   int      buyCnt;
   int      sellCnt;
   bool     isBalanced;
   bool     isLocked;     // 是否已锁仓
   int      lockDirection; // 锁仓方向: 1=多盈利解锁, -1=空盈利解锁
   double   lockBuyLoss;   // 锁仓时多单亏损
   double   lockSellLoss;  // 锁仓时空单亏损
};

//+------------------------------------------------------------------+
//| 全局变量                                                          |
//+------------------------------------------------------------------+
CTrade         m_trade;
string         g_prefix        = "BRC_";   // Balance Risk Control 前缀
bool           g_panel_open    = true;
int            g_px            = 10;
int            g_py            = 10;
bool           g_panel_dragging = false;
int            g_panel_drag_ox = 0;
int            g_panel_drag_oy = 0;

// ── 锁仓风控状态 ──
bool           g_locked         = false;     // 锁仓标志
double         g_lockOrigThresh = 0;         // 锁仓时保存的阈值
#define LOCK_DISABLED -999999.0
double         g_lockDrawdownUSD = -999999.0; // 当前锁仓阈值(运行时)
double         g_unlockRatio    = 0.50;      // 解锁比例
double         g_minHedgeProfit = 5.0;       // 最低保留盈利
bool           g_progressiveClose = false;    // 渐进平仓模式
double         g_balanceTolerance = 0.01;    // 平衡容差

// ── 锁仓品种列表 ──
string         g_lockedSymbols[];            // 已锁仓品种列表
int            g_lockDirections[];           // 对应锁仓方向

// ── 多品种监控 ──
int            g_monitorScroll   = 0;         // 监控列表滚动偏移

//+------------------------------------------------------------------+
//| 字体缩放                                                          |
//+------------------------------------------------------------------+
double FontScale()
{
   long d = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   if(d >= 192) return 1.10;
   if(d >= 144) return 1.05;
   if(d <= 96)  return 0.95;
   return 1.0;
}
int F(const int n) { return (int)MathRound(n * FontScale()); }

//+------------------------------------------------------------------+
//| 面板工具函数                                                      |
//+------------------------------------------------------------------+
void ClampPanelPosition(int &x, int &y)
{
   long cw = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
   long ch = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
   if(x < 0) x = 0;
   if(y < 0) y = 0;
   if(x + PW > cw && cw > PW) x = (int)(cw - PW);
   if(y + 500 > ch && ch > 500) y = (int)(ch - 500);
}
void ShiftAll(int dx, int dy)
{
   if(dx == 0 && dy == 0) return;
   for(int i = ObjectsTotal(0,-1,-1)-1; i>=0; i--)
   {
      string nm = ObjectName(0,i,-1,-1);
      if(StringFind(nm,g_prefix,0)!=0) continue;
      if(nm == g_prefix+"toggle_panel") continue;
      ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,
         (int)ObjectGetInteger(0,nm,OBJPROP_XDISTANCE)+dx);
      ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,
         (int)ObjectGetInteger(0,nm,OBJPROP_YDISTANCE)+dy);
   }
   g_px += dx; g_py += dy;
}
void MovePanelTo(int nx, int ny) { ClampPanelPosition(nx,ny); ShiftAll(nx-g_px, ny-g_py); }
bool IsClickOnPanelDragArea(int cx, int cy) { return (cx>=g_px && cx<=g_px+PW && cy>=g_py && cy<=g_py+HDR_H); }
void SetPanelDragHighlight(bool on)
{
   string p = g_prefix+"panel";
   if(ObjectFind(0,p)<0) return;
   ObjectSetInteger(0,p,OBJPROP_COLOR, on?InpColorInfo:C'45,58,74');
   ObjectSetInteger(0,p,OBJPROP_WIDTH,on?2:1);
}
void ERect(string nm, int x, int y, int w, int h, color bg, color bd, int cr=CORNER_LEFT_UPPER)
{
   if(ObjectFind(0,nm)<0) ObjectCreate(0,nm,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,nm,OBJPROP_CORNER,cr); ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,y); ObjectSetInteger(0,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,h); ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,nm,OBJPROP_COLOR,bd); ObjectSetInteger(0,nm,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,nm,OBJPROP_WIDTH,BD_W); ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true); ObjectSetInteger(0,nm,OBJPROP_BACK,false);
}
void ELbl(string nm, string txt, int x, int y, int fs, color clr, int cr=CORNER_LEFT_UPPER)
{
   if(ObjectFind(0,nm)<0) ObjectCreate(0,nm,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,nm,OBJPROP_CORNER,cr); ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,y);
   ObjectSetString(0,nm,OBJPROP_FONT,"Microsoft YaHei");
   ObjectSetInteger(0,nm,OBJPROP_FONTSIZE,F(fs)); ObjectSetString(0,nm,OBJPROP_TEXT,txt);
   ObjectSetInteger(0,nm,OBJPROP_COLOR,clr); ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true); ObjectSetInteger(0,nm,OBJPROP_BACK,false);
}
void EBtn(string nm, string txt, int x, int y, int w, int h, color bg, color fg, int cr=CORNER_LEFT_UPPER)
{
   if(ObjectFind(0,nm)<0) ObjectCreate(0,nm,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,nm,OBJPROP_CORNER,cr); ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,y); ObjectSetInteger(0,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,h);
   ObjectSetString(0,nm,OBJPROP_FONT,"Microsoft YaHei");
   ObjectSetInteger(0,nm,OBJPROP_FONTSIZE,F(10)); ObjectSetString(0,nm,OBJPROP_TEXT,txt);
   ObjectSetInteger(0,nm,OBJPROP_COLOR,fg); ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,nm,OBJPROP_BORDER_COLOR,bg); ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true); ObjectSetInteger(0,nm,OBJPROP_BACK,false);
}
void EEdt(string nm, string txt, int x, int y, int w, int h, int cr=CORNER_LEFT_UPPER)
{
   bool isNew = (ObjectFind(0,nm) < 0);
   if(isNew)
   {
      ObjectCreate(0,nm,OBJ_EDIT,0,0,0);
      ObjectSetString(0,nm,OBJPROP_FONT,"Microsoft YaHei");
      ObjectSetInteger(0,nm,OBJPROP_FONTSIZE,F(10));
      ObjectSetInteger(0,nm,OBJPROP_ALIGN,ALIGN_CENTER);
      ObjectSetString(0,nm,OBJPROP_TEXT,txt);
      ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,C'34,38,52');
      ObjectSetInteger(0,nm,OBJPROP_BORDER_COLOR,C'55,62,80');
      ObjectSetInteger(0,nm,OBJPROP_COLOR,C'235,240,250');
      ObjectSetInteger(0,nm,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,nm,OBJPROP_BACK,false);
   }
   ObjectSetInteger(0,nm,OBJPROP_CORNER,cr); ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,y); ObjectSetInteger(0,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,h); ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true);
}
void DelContent()
{
   for(int i=ObjectsTotal(0,-1,-1)-1;i>=0;i--)
   {
      string nm=ObjectName(0,i,-1,-1);
      if(StringFind(nm,g_prefix,0)!=0) continue;
      if(nm==g_prefix+"toggle_panel") continue;
      ObjectDelete(0,nm);
   }
}
void DrawToggle()
{
   EBtn(g_prefix+"toggle_panel",g_panel_open?"▲ 隐藏":"▼ 展开",PD,PD+BH,90,BH,C'56,132,216',C'235,240,250',CORNER_LEFT_LOWER);
}
bool ShowConfirmDialog(const string message)
{
   return(MessageBox(message,"确认操作",MB_YESNO|MB_ICONQUESTION)==IDYES);
}
void ResetPanelButtonState(const string button_name)
{
   if(button_name=="") return;
   if(ObjectFind(0,button_name)<0) return;
   ObjectSetInteger(0,button_name,OBJPROP_STATE,false);
}

//+------------------------------------------------------------------+
//| 手数辅助函数                                                      |
//+------------------------------------------------------------------+
double GetVolumeStep(string symbol) { double s = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP); return (s > 0 ? s : 0.01); }
double AlignVolumeToStep(string symbol, double volume) { double s = GetVolumeStep(symbol); return MathFloor(volume / s + 1e-9) * s; }
double GetMinLot(string symbol) { return SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN); }

//+------------------------------------------------------------------+
//| 判断是否为锁仓订单 (通过注释标记)                                   |
//+------------------------------------------------------------------+
bool IsLockedOrder()
{
   string comment = PositionGetString(POSITION_COMMENT);
   return (StringFind(comment, LOCK_COMMENT) >= 0);
}

//+------------------------------------------------------------------+
//| 标记订单为锁仓状态                                                |
//+------------------------------------------------------------------+
void MarkPositionAsLocked(ulong ticket)
{
   if(!PositionSelectByTicket(ticket)) return;
   string comment = PositionGetString(POSITION_COMMENT);
   if(StringFind(comment, LOCK_COMMENT) >= 0) return;

   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};
   request.action = TRADE_ACTION_SLTP;
   request.position = ticket;
   request.symbol = PositionGetString(POSITION_SYMBOL);

   string newComment = LOCK_COMMENT + "_" +
      ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY?"多":"空") +
      "_" + IntegerToString((int)ticket);

   // 用订单修改方式更新注释 (MQL5通过TRADE_ACTION_MODIFY)
   request.action = TRADE_ACTION_MODIFY;
   request.comment = newComment;
   if(!OrderSend(request,result))
      Print("[锁仓标记] 订单#",ticket," 标记失败");
}

//+------------------------------------------------------------------+
//| 取消订单锁仓标记                                                  |
//+------------------------------------------------------------------+
void UnmarkPositionAsLocked(ulong ticket)
{
   if(!PositionSelectByTicket(ticket)) return;
   string comment = PositionGetString(POSITION_COMMENT);
   if(StringFind(comment, LOCK_COMMENT) < 0) return;

   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};
   request.action = TRADE_ACTION_MODIFY;
   request.position = ticket;
   request.symbol = PositionGetString(POSITION_SYMBOL);

   // 移除锁仓标记，保留其他注释
   string newComment = comment;
   int idx = StringFind(newComment, LOCK_COMMENT);
   if(idx >= 0)
   {
      // 找到标记开始位置，移除到下一个空格或结尾
      int endPos = StringLen(newComment);
      int spacePos = StringFind(newComment, " ", idx);
      if(spacePos > 0 && spacePos < endPos) endPos = spacePos;
      newComment = StringSubstr(newComment, 0, idx) +
                   StringSubstr(newComment, endPos);
      newComment = StringTrimLeft(newComment);
   }

   request.comment = newComment;
   if(!OrderSend(request,result))
      Print("[锁仓取消] 订单#",ticket," 取消标记失败");
}

//+------------------------------------------------------------------+
//| 给品种所有订单添加锁仓标记                                        |
//+------------------------------------------------------------------+
void MarkSymbolAsLocked(string symbol, int lockDir)
{
   int marked = 0;
   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if(IsLockedOrder()) continue;

      MarkPositionAsLocked(ticket);
      marked++;
   }
   if(marked > 0)
      Print("[锁仓标记] ",symbol," 已标记 ",marked," 笔订单, 方向:",(lockDir==1?"多盈利解锁":"空盈利解锁"));
}

//+------------------------------------------------------------------+
//| 取消品种所有订单锁仓标记                                          |
//+------------------------------------------------------------------+
void UnmarkSymbolAsLocked(string symbol)
{
   int unmarked = 0;
   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if(!IsLockedOrder()) continue;

      UnmarkPositionAsLocked(ticket);
      unmarked++;
   }
   if(unmarked > 0)
      Print("[锁仓取消] ",symbol," 已取消 ",unmarked," 笔订单标记");
}

//+------------------------------------------------------------------+
//| 单仓平仓                                                          |
//+------------------------------------------------------------------+
bool ClosePosition(ulong positionTicket, double volume, int slippage)
{
   if(!PositionSelectByTicket(positionTicket)) return false;
   string symbol = PositionGetString(POSITION_SYMBOL);
   ENUM_POSITION_TYPE ptype = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};
   request.action = TRADE_ACTION_DEAL; request.symbol = symbol; request.volume = volume;
   request.type = (ptype==POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
   request.price = (request.type==ORDER_TYPE_SELL) ? SymbolInfoDouble(symbol,SYMBOL_BID) : SymbolInfoDouble(symbol,SYMBOL_ASK);
   request.deviation = slippage; request.type_filling = ORDER_FILLING_FOK;
   request.type_time = ORDER_TIME_GTC; request.position = positionTicket;
   request.comment = "风控平仓";
   if(!OrderSend(request,result) || (result.retcode!=TRADE_RETCODE_DONE && result.retcode!=TRADE_RETCODE_PLACED))
   {
      request.type_filling = ORDER_FILLING_IOC;
      if(!OrderSend(request,result) || (result.retcode!=TRADE_RETCODE_DONE && result.retcode!=TRADE_RETCODE_PLACED))
      {
         PrintFormat("[风控平仓] 失败 #%I64u retcode=%d", positionTicket, (int)result.retcode);
         return false;
      }
   }
   return true;
}

//+------------------------------------------------------------------+
//| 全平指定品种持仓                                                  |
//+------------------------------------------------------------------+
void CloseAllPositionsBySymbol(string symbol, ENUM_POSITION_TYPE posType)
{
   int count = 0;
   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != posType) continue;
      double vol = PositionGetDouble(POSITION_VOLUME);
      if(vol > 0 && ClosePosition(ticket, vol, InpSlippage)) count++;
   }
   Print("[风控全平] ", symbol, " ", (posType==POSITION_TYPE_BUY?"多单":"空单"), " 平 ", count, " 笔");
}

//+------------------------------------------------------------------+
//| 统计指定品种多空持仓信息                                          |
//+------------------------------------------------------------------+
void GetSymbolStats(string symbol, SymbolStats &stats)
{
   stats.symbol = symbol;
   stats.buyLots = 0; stats.sellLots = 0;
   stats.buyPnl = 0; stats.sellPnl = 0;
   stats.buyCnt = 0; stats.sellCnt = 0;
   stats.isLocked = false;
   stats.lockDirection = 0;
   stats.lockBuyLoss = 0;
   stats.lockSellLoss = 0;

   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;

      bool locked = IsLockedOrder();
      double p = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);

      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
      {
         stats.buyLots += PositionGetDouble(POSITION_VOLUME);
         stats.buyPnl += p;
         stats.buyCnt++;
         if(locked && p < 0) stats.lockBuyLoss += (-p);
      }
      else
      {
         stats.sellLots += PositionGetDouble(POSITION_VOLUME);
         stats.sellPnl += p;
         stats.sellCnt++;
         if(locked && p < 0) stats.lockSellLoss += (-p);
      }

      if(locked)
      {
         stats.isLocked = true;
         // 从注释中解析方向
         string comment = PositionGetString(POSITION_COMMENT);
         if(StringFind(comment, "LOCK_多") >= 0) stats.lockDirection = 1;
         else if(StringFind(comment, "LOCK_空") >= 0) stats.lockDirection = -1;
      }
   }

   stats.netLots = stats.buyLots - stats.sellLots;
   stats.totalPnl = stats.buyPnl + stats.sellPnl;
   stats.isBalanced = (MathAbs(stats.netLots) <= g_balanceTolerance && (stats.buyCnt > 0 || stats.sellCnt > 0));
}

//+------------------------------------------------------------------+
//| 收集所有持仓品种的统计                                            |
//+------------------------------------------------------------------+
int GetAllSymbolsStats(SymbolStats &allStats[])
{
   string symbols[];
   ArrayResize(symbols, 0);

   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      string sym = PositionGetString(POSITION_SYMBOL);
      bool found = false;
      for(int j=0; j<ArraySize(symbols); j++)
      {
         if(symbols[j] == sym) { found = true; break; }
      }
      if(!found)
      {
         int idx = ArraySize(symbols);
         ArrayResize(symbols, idx+1);
         symbols[idx] = sym;
      }
   }

   int cnt = ArraySize(symbols);
   ArrayResize(allStats, cnt);
   for(int i=0; i<cnt; i++)
   {
      GetSymbolStats(symbols[i], allStats[i]);
   }

   // 按浮亏金额排序 (亏大的排前面)
   for(int i=0; i<cnt-1; i++)
      for(int j=i+1; j<cnt; j++)
      {
         double lossI = (allStats[i].totalPnl < 0) ? -allStats[i].totalPnl : 0;
         double lossJ = (allStats[j].totalPnl < 0) ? -allStats[j].totalPnl : 0;
         if(lossJ > lossI)
         {
            SymbolStats tmp = allStats[i]; allStats[i] = allStats[j]; allStats[j] = tmp;
         }
      }

   return cnt;
}

//+------------------------------------------------------------------+
//| 统计账户总盈亏                                                    |
//+------------------------------------------------------------------+
double GetTotalAccountPnl()
{
   double total = 0;
   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      total += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   }
   return total;
}

//+------------------------------------------------------------------+
//| 获取所有平衡品种列表                                              |
//+------------------------------------------------------------------+
int GetBalancedSymbols(SymbolStats &balancedStats[])
{
   SymbolStats allStats[];
   int totalCnt = GetAllSymbolsStats(allStats);
   int balancedCnt = 0;
   for(int i=0; i<totalCnt; i++)
   {
      if(allStats[i].isBalanced && !allStats[i].isLocked)
      {
         int idx = ArraySize(balancedStats);
         ArrayResize(balancedStats, idx+1);
         balancedStats[idx] = allStats[i];
         balancedCnt++;
      }
   }
   return balancedCnt;
}

//+------------------------------------------------------------------+
//| 检查品种是否在已锁仓列表中                                        |
//+------------------------------------------------------------------+
bool IsSymbolLocked(string symbol)
{
   for(int i=0; i<ArraySize(g_lockedSymbols); i++)
   {
      if(g_lockedSymbols[i] == symbol) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 获取锁仓方向                                                      |
//+------------------------------------------------------------------+
int GetLockDirection(string symbol)
{
   for(int i=0; i<ArraySize(g_lockedSymbols); i++)
   {
      if(g_lockedSymbols[i] == symbol && i < ArraySize(g_lockDirections))
         return g_lockDirections[i];
   }
   return 0;
}

//+------------------------------------------------------------------+
//| 添加品种到锁仓列表                                                |
//+------------------------------------------------------------------+
void AddSymbolToLockedList(string symbol, int direction)
{
   if(IsSymbolLocked(symbol)) return;
   int idx = ArraySize(g_lockedSymbols);
   ArrayResize(g_lockedSymbols, idx+1);
   ArrayResize(g_lockDirections, idx+1);
   g_lockedSymbols[idx] = symbol;
   g_lockDirections[idx] = direction;
}

//+------------------------------------------------------------------+
//| 从锁仓列表移除品种                                                |
//+------------------------------------------------------------------+
void RemoveSymbolFromLockedList(string symbol)
{
   int newSize = 0;
   for(int i=0; i<ArraySize(g_lockedSymbols); i++)
   {
      if(g_lockedSymbols[i] != symbol)
      {
         if(newSize != i)
         {
            g_lockedSymbols[newSize] = g_lockedSymbols[i];
            if(i < ArraySize(g_lockDirections))
               g_lockDirections[newSize] = g_lockDirections[i];
         }
         newSize++;
      }
   }
   ArrayResize(g_lockedSymbols, newSize);
   ArrayResize(g_lockDirections, newSize);
}

//+------------------------------------------------------------------+
//| 计算方向盈利 (多/空)                                              |
//+------------------------------------------------------------------+
double GetDirectionProfit(string symbol, int direction)
{
   double total = 0;
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if(!IsLockedOrder()) continue;

      ENUM_POSITION_TYPE ptype = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      if(direction == 1 && ptype == POSITION_TYPE_BUY)
         total += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      else if(direction == -1 && ptype == POSITION_TYPE_SELL)
         total += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   }
   return total;
}

//+------------------------------------------------------------------+
//| 渐进平仓: 用盈利方向做预算平亏损单                                |
//+------------------------------------------------------------------+
bool ProgressiveCloseLossOrders(string symbol, int lockDirection)
{
   if(!g_progressiveClose)
   {
      g_progressiveClose = true;
   }

   // 计算盈利方向的盈利作为预算
   double directionProfit = GetDirectionProfit(symbol, lockDirection);
   double budget = directionProfit - g_minHedgeProfit;

   Print("[渐进平仓] ",symbol," 方向盈利=$",DoubleToString(directionProfit,2),
         " 最低保留=$",DoubleToString(g_minHedgeProfit,2),
         " 预算=$",DoubleToString(budget,2));

   if(budget < 1.0)
   {
      Print("[渐进平仓] 预算不足 → 跳过");
      return false;
   }

   int count = 0;
   PositionInfo entries[];
   ArrayResize(entries, (int)PositionsTotal());

   // 收集所有锁仓的亏损单
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if(!IsLockedOrder()) continue;

      double p = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(p >= -0.01) continue;

      entries[count].ticket = ticket;
      entries[count].symbol = symbol;
      entries[count].openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      entries[count].lots = PositionGetDouble(POSITION_VOLUME);
      entries[count].profit = p;
      entries[count].posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      count++;
   }

   if(count==0)
   {
      Print("[渐进平仓] ",symbol," 无亏损单 → 解锁");
      return true;
   }

   // 按亏损程度排序: 多单从高价到低价(亏大优先), 空单从低价到高价
   for(int i=0; i<count-1; i++)
      for(int j=i+1; j<count; j++)
      {
         bool needSwap = false;
         if(entries[i].posType == POSITION_TYPE_BUY)
            needSwap = (entries[i].openPrice < entries[j].openPrice);
         else
            needSwap = (entries[i].openPrice > entries[j].openPrice);
         if(needSwap)
         {
            PositionInfo tmp = entries[i]; entries[i] = entries[j]; entries[j] = tmp;
         }
      }

   int closedCnt = 0;
   double totalReleased = 0;

   for(int k=0; k<count; k++)
   {
      if(budget <= 1.0) break;

      ulong ticket = entries[k].ticket;
      if(!PositionSelectByTicket(ticket)) continue;

      double realProfit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      double realLots = PositionGetDouble(POSITION_VOLUME);
      if(realProfit >= -0.01) continue;

      double lossPerLot = (-realProfit) / realLots;
      if(lossPerLot <= 0) continue;

      // 用方向盈利做"预算", 逐笔平亏损单, 每笔保留5%缓冲
      double maxLossForThis = budget * 0.95;
      double affordable = maxLossForThis / lossPerLot;
      double closeLot = MathMin(realLots, affordable);
      double minLot = GetMinLot(symbol);
      closeLot = MathFloor(closeLot / minLot) * minLot;

      if(closeLot < minLot) continue;

      double lossForClose = closeLot * lossPerLot;
      if(lossForClose > budget * 0.95)
      {
         closeLot = MathFloor(budget * 0.95 / lossPerLot / minLot) * minLot;
         if(closeLot < minLot) continue;
         lossForClose = closeLot * lossPerLot;
      }

      if(ClosePosition(ticket, closeLot, InpSlippage))
      {
         closedCnt++;
         totalReleased += lossForClose;
         budget -= lossForClose;
         Print("[渐进平仓] 平单#",closedCnt," ",symbol," ",
               (entries[k].posType==POSITION_TYPE_BUY?"多":"空"),
               " 平:",DoubleToString(closeLot,2),"手 释放亏损:$",DoubleToString(lossForClose,2));
      }
   }

   if(closedCnt > 0)
   {
      Print("[渐进平仓] ",symbol," 共平",closedCnt,"单, 释放$",DoubleToString(totalReleased,2),
            " 剩余预算$",DoubleToString(budget,2));
   }

   // 检查是否完成
   double finalDirectionProfit = GetDirectionProfit(symbol, lockDirection);
   Print("[渐进平仓] ",symbol," 方向盈利=$",DoubleToString(finalDirectionProfit,2),
         " 最低保留=$",DoubleToString(g_minHedgeProfit,2));

   if(finalDirectionProfit >= g_minHedgeProfit && closedCnt > 0)
   {
      Print("[渐进平仓] ",symbol," 方向盈利≥最低保留 → 解锁");
      return true;
   }

   // 如果所有亏损单都平完了
   int remainingLoss = 0;
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong t = PositionGetTicket(i);
      if(t==0) continue;
      if(!PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if(!IsLockedOrder()) continue;
      double p = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(p < -0.01) remainingLoss++;
   }
   if(remainingLoss == 0 && closedCnt > 0)
   {
      Print("[渐进平仓] ",symbol," 所有亏损单已平 → 解锁");
      return true;
   }

   return false;
}

//+------------------------------------------------------------------+
//| 重置锁仓状态                                                      |
//+------------------------------------------------------------------+
void ResetLockState()
{
   g_locked = false;
   g_lockOrigThresh = 0;
   g_lockDrawdownUSD = LOCK_DISABLED;
   g_progressiveClose = false;
   ArrayResize(g_lockedSymbols, 0);
   ArrayResize(g_lockDirections, 0);
   Print("[风控解锁] 阈值回到禁用值, 需手动设置新阈值");
   Print("[风控解锁] 风控系统恢复, 持续监测平衡状态");
   RefreshPanel(true);
   ObjectSetString(0, g_prefix+"e1_threshold", OBJPROP_TEXT, "禁用");
}

//+------------------------------------------------------------------+
//| 核心: 检查锁仓 (账户浮亏→平衡品种锁仓→方向盈利→渐进平仓)          |
//+------------------------------------------------------------------+
void CheckLock()
{
   double totalPnl = GetTotalAccountPnl();

   // ── 已锁仓: 解锁检测 ──
   if(g_locked)
   {
      bool allSymbolsUnlocked = true;

      for(int s=0; s<ArraySize(g_lockedSymbols); s++)
      {
         string sym = g_lockedSymbols[s];
         int lockDir = g_lockDirections[s];

         // 检查是否还有锁仓订单
         bool hasLocked = false;
         for(int i=(int)PositionsTotal()-1; i>=0; i--)
         {
            ulong t = PositionGetTicket(i);
            if(t==0) continue;
            if(!PositionSelectByTicket(t)) continue;
            if(PositionGetString(POSITION_SYMBOL) != sym) continue;
            if(IsLockedOrder()) { hasLocked = true; break; }
         }

         if(!hasLocked)
         {
            Print("[风控解锁检查] ",sym," 锁仓订单已清空");
            RemoveSymbolFromLockedList(sym);
            continue;
         }

         // 监控多空方向盈利
         double buyProfit = GetDirectionProfit(sym, 1);
         double sellProfit = GetDirectionProfit(sym, -1);
         double targetProfit = g_lockOrigThresh * g_unlockRatio;

         Print("[风控解锁检查] ",sym," 多盈利:$",DoubleToString(buyProfit,2),
               " 空盈利:$",DoubleToString(sellProfit,2),
               " 50%目标:$",DoubleToString(targetProfit,2));

         // 判断哪个方向先盈利达50%
         int triggerDir = 0;
         if(lockDir == 1 && buyProfit >= targetProfit) triggerDir = 1;
         else if(lockDir == -1 && sellProfit >= targetProfit) triggerDir = -1;

         if(triggerDir == 0)
         {
            allSymbolsUnlocked = false;
            continue;
         }

         // 触发渐进平仓
         if(!g_progressiveClose)
         {
            Print("════════════════════════════════");
            Print("[渐进平仓] ",sym," 方向盈利达标 → 启动渐进平仓");
         }

         if(ProgressiveCloseLossOrders(sym, triggerDir))
         {
            Print("[解锁] ",sym," 渐进平仓完成 → 取消锁仓标记");
            UnmarkSymbolAsLocked(sym);
            RemoveSymbolFromLockedList(sym);
         }
         else
         {
            allSymbolsUnlocked = false;
         }
      }

      if(allSymbolsUnlocked || ArraySize(g_lockedSymbols) == 0)
      {
         ResetLockState();
      }
      return;
   }

   // ── 未锁仓: 检测是否需要锁仓 ──
   if(g_lockDrawdownUSD <= 0) return;

   // 账户总浮亏达阈值才触发
   if(totalPnl > -g_lockDrawdownUSD) return;

   // 获取所有平衡品种
   SymbolStats balancedStats[];
   int balancedCnt = GetBalancedSymbols(balancedStats);

   if(balancedCnt == 0)
   {
      Print("[风控监测] 账户浮亏达阈值但无平衡品种, 不触发锁仓");
      return;
   }

   g_lockOrigThresh = g_lockDrawdownUSD;
   g_locked = true;
   g_progressiveClose = false;

   Print("════════════════════════════════");
   Print("[风控锁仓] 账户总浮亏:$",DoubleToString(totalPnl,2)," 达阈值:$",DoubleToString(g_lockDrawdownUSD,2));
   Print("[风控锁仓] 发现 ",balancedCnt," 个平衡品种, 开始锁仓");

   // 对每个平衡品种标记锁仓
   for(int i=0; i<balancedCnt; i++)
   {
      string sym = balancedStats[i].symbol;
      if(IsSymbolLocked(sym)) continue;

      double buyLoss = 0, sellLoss = 0;
      if(balancedStats[i].buyPnl < 0) buyLoss = -balancedStats[i].buyPnl;
      if(balancedStats[i].sellPnl < 0) sellLoss = -balancedStats[i].sellPnl;

      Print("[风控锁仓] ",sym," 多:",DoubleToString(balancedStats[i].buyLots,2),"手 空:",
            DoubleToString(balancedStats[i].sellLots,2),"手 净:",
            DoubleToString(balancedStats[i].netLots,4));
      Print("[风控锁仓] ",sym," 多浮亏:$",DoubleToString(buyLoss,2)," 空浮亏:$",DoubleToString(sellLoss,2));

      // 决定解锁方向: 亏损大的方向作为盈利解锁目标
      int lockDir = 1; // 默认多盈利解锁
      if(sellLoss > buyLoss) lockDir = -1; // 空亏损大则空盈利解锁

      // 标记品种所有订单为锁仓状态
      MarkSymbolAsLocked(sym, lockDir);
      AddSymbolToLockedList(sym, lockDir);
   }

   g_lockDrawdownUSD = LOCK_DISABLED;
   Print("[风控锁仓] 阈值已设为禁用值, 锁仓期间不再触发");
   Print("[风控锁仓] 解锁方式: 方向盈利达"+DoubleToString(g_unlockRatio*100,0)+"% → 渐进平仓 → 解锁");
   Print("════════════════════════════════");
   RefreshPanel(true);
   ObjectSetString(0, g_prefix+"e1_threshold", OBJPROP_TEXT, "禁用");
}

//+------------------------------------------------------------------+
//| 读取面板输入参数                                                  |
//+------------------------------------------------------------------+
void ReadEdits()
{
   string t; double v;
   if(ObjectFind(0,g_prefix+"e1_threshold")>=0)
   {
      t = ObjectGetString(0,g_prefix+"e1_threshold",OBJPROP_TEXT);
      v = StringToDouble(t);
      if(v > 0) g_lockDrawdownUSD = v;
      else g_lockDrawdownUSD = LOCK_DISABLED;
   }
   if(ObjectFind(0,g_prefix+"e2_ratio")>=0)
   {
      t = ObjectGetString(0,g_prefix+"e2_ratio",OBJPROP_TEXT);
      v = StringToDouble(t); if(v>=1) g_unlockRatio = v/100.0;
   }
   if(ObjectFind(0,g_prefix+"e3_minHedge")>=0)
   {
      t = ObjectGetString(0,g_prefix+"e3_minHedge",OBJPROP_TEXT);
      v = StringToDouble(t); if(v>=0) g_minHedgeProfit = v;
   }
   if(ObjectFind(0,g_prefix+"e4_tolerance")>=0)
   {
      t = ObjectGetString(0,g_prefix+"e4_tolerance",OBJPROP_TEXT);
      v = StringToDouble(t); if(v>=0.001) g_balanceTolerance = v;
   }
}

//+------------------------------------------------------------------+
//| 保存参数到 GlobalVariable                                         |
//+------------------------------------------------------------------+
void SaveParamsToGV()
{
   GlobalVariableSet(g_prefix+"thresh", g_lockDrawdownUSD);
   GlobalVariableSet(g_prefix+"ratio", g_unlockRatio);
   GlobalVariableSet(g_prefix+"minHedge", g_minHedgeProfit);
   GlobalVariableSet(g_prefix+"tolerance", g_balanceTolerance);
}

void LoadParamsFromGV()
{
   if(GlobalVariableCheck(g_prefix+"thresh")) g_lockDrawdownUSD = GlobalVariableGet(g_prefix+"thresh");
   if(GlobalVariableCheck(g_prefix+"ratio")) g_unlockRatio = GlobalVariableGet(g_prefix+"ratio");
   if(GlobalVariableCheck(g_prefix+"minHedge")) g_minHedgeProfit = GlobalVariableGet(g_prefix+"minHedge");
   if(GlobalVariableCheck(g_prefix+"tolerance")) g_balanceTolerance = GlobalVariableGet(g_prefix+"tolerance");
   if(g_lockDrawdownUSD == 0) g_lockDrawdownUSD = LOCK_DISABLED;
}

//+------------------------------------------------------------------+
//| 面板绘制                                                          |
//+------------------------------------------------------------------+
void DrawPanel()
{
   if(!g_panel_open) { DelContent(); DrawToggle(); return; }

   // 账户级统计
   double totalAccountPnl = GetTotalAccountPnl();

   // 所有品种统计
   SymbolStats allStats[];
   int totalSymbols = GetAllSymbolsStats(allStats);

   // 当前品种统计
   string symbol = _Symbol;
   SymbolStats curStats;
   GetSymbolStats(symbol, curStats);

   // 锁仓汇总
   int totalBalanced = 0;
   int totalLockedSymbols = ArraySize(g_lockedSymbols);
   double totalBuyProfit = 0;
   double totalSellProfit = 0;
   for(int i=0; i<totalLockedSymbols; i++)
   {
      totalBuyProfit += GetDirectionProfit(g_lockedSymbols[i], 1);
      totalSellProfit += GetDirectionProfit(g_lockedSymbols[i], -1);
   }
   for(int i=0; i<totalSymbols; i++)
   {
      if(allStats[i].isBalanced) totalBalanced++;
   }

   // 配色
   color BG_PANEL = C'18,20,28', BD_PANEL = C'60,68,88', BG_HDR = C'30,34,48';
   color BG_CARD = C'24,27,38', cMute = C'130,140,165';

   int X = g_px, LX = X+PD, RX = LX+LW+PG;

   // 外框 + 标题栏
   ERect(g_prefix+"panel", X, g_py, PW, 720, BG_PANEL, BD_PANEL);
   ERect(g_prefix+"header", X, g_py, PW, HDR_H, BG_HDR, BD_PANEL);
   ELbl(g_prefix+"title", "账户仓位多空仓位平衡风控", LX+4, g_py+8, F(14), C'235,240,250');

   // 账户盈亏副标题
   color accPnlClr = (totalAccountPnl>=0) ? InpColorNormal : InpColorDanger;
   string accInfo = "账户盈亏:$" + DoubleToString(totalAccountPnl,2) +
                    " | 品种:" + IntegerToString(totalSymbols) +
                    " | 平衡容差:" + DoubleToString(g_balanceTolerance,2);
   ELbl(g_prefix+"sub", accInfo, LX+4, g_py+30, F(9), accPnlClr);

   int cy = g_py + HDR_H + SG;
   int ry = 0;
   int ey = 0;
   int by = 0;
   int rx = 0;

   // ── 卡片1: 账户状态卡 ──
   int statusH = 170;
   ERect(g_prefix+"c1",LX,cy,LW,statusH,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c1_title","账户状态",LX+CD_PD,cy+CD_PD,F(11),C'235,240,250');
   ry = cy + CD_PD + 20;

   // 账户总盈亏
   ELbl(g_prefix+"r1_lbl","账户盈亏", LX+CD_PD, ry+1, F(10), cMute);
   color accClr = (totalAccountPnl>=0) ? InpColorNormal : InpColorDanger;
   ELbl(g_prefix+"r1_val", "$"+DoubleToString(totalAccountPnl,2), LX+CD_PD+LW*4/10, ry+1, F(10), accClr);
   ry += LH;

   // 多单盈利
   ELbl(g_prefix+"r2_lbl","多单盈亏", LX+CD_PD, ry+1, F(10), cMute);
   color buyProfitClr = (totalBuyProfit>=0) ? InpColorNormal : InpColorDanger;
   ELbl(g_prefix+"r2_val", "$"+DoubleToString(totalBuyProfit,2), LX+CD_PD+LW*4/10, ry+1, F(10), buyProfitClr);
   ry += LH;

   // 空单盈利
   ELbl(g_prefix+"r3_lbl","空单盈亏", LX+CD_PD, ry+1, F(10), cMute);
   color sellProfitClr = (totalSellProfit>=0) ? InpColorNormal : InpColorDanger;
   ELbl(g_prefix+"r3_val", "$"+DoubleToString(totalSellProfit,2), LX+CD_PD+LW*4/10, ry+1, F(10), sellProfitClr);
   ry += LH;

   // 锁仓状态
   string lockStatus; color lockClr;
   if(g_progressiveClose){ lockStatus = "渐进平仓中"; lockClr = InpColorWarning; }
   else if(g_locked){ lockStatus = "已锁仓("+IntegerToString(totalLockedSymbols)+"品种)"; lockClr = InpColorDanger; }
   else { lockStatus = "正常监测"; lockClr = InpColorNormal; }
   ELbl(g_prefix+"r4_lbl","锁仓状态", LX+CD_PD, ry+1, F(10), cMute);
   ELbl(g_prefix+"r4_val", lockStatus, LX+CD_PD+LW*4/10, ry+1, F(10), lockClr);
   ry += LH;

   // 平衡品种数
   ELbl(g_prefix+"r5_lbl","平衡品种", LX+CD_PD, ry+1, F(10), cMute);
   string balTxt = IntegerToString(totalBalanced)+"/"+IntegerToString(totalSymbols)+" 品种";
   color balClr = (totalBalanced > 0) ? InpColorWarning : cMute;
   ELbl(g_prefix+"r5_val", balTxt, LX+CD_PD+LW*4/10, ry+1, F(10), balClr);
   ry += LH;

   // 进度显示
   if(g_locked && totalLockedSymbols > 0)
   {
      double targetP = g_lockOrigThresh * g_unlockRatio;
      string progTxt; color progClr;
      int bestDir = 0; double bestProfit = -999999;
      if(totalBuyProfit >= totalSellProfit) { bestDir = 1; bestProfit = totalBuyProfit; }
      else { bestDir = -1; bestProfit = totalSellProfit; }

      progTxt = (bestDir==1?"多":"空")+"盈利:$"+DoubleToString(bestProfit,2)+" 50%目标:$"+DoubleToString(targetP,2);
      progClr = (bestProfit>=targetP)?InpColorNormal:InpColorWarning;
      ELbl(g_prefix+"r6_lbl","进度", LX+CD_PD, ry+1, F(10), cMute);
      ELbl(g_prefix+"r6_val", progTxt, LX+CD_PD+LW*4/10, ry+1, F(10), progClr);
   }

   // ── 卡片2: 风控参数 ──
   cy += statusH + SG;
   int paramH = 150;
   ERect(g_prefix+"c2",LX,cy,LW,paramH,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c2_title","风控参数",LX+CD_PD,cy+CD_PD,F(11),C'235,240,250');
   ey = cy + CD_PD + 22;

   // 浮亏锁仓阈值
   string threshVal = (g_lockDrawdownUSD <= 0) ? "禁用" : DoubleToString(g_lockDrawdownUSD,0);
   EEdt(g_prefix+"e1_threshold", threshVal, LX+CD_PD+2, ey, 60, EH);
   ELbl(g_prefix+"e1_lbl","浮亏锁仓$", LX+CD_PD+2+60+2, ey+2, F(10), cMute);
   ey += LH;

   // 解锁比例
   EEdt(g_prefix+"e2_ratio", DoubleToString(g_unlockRatio*100,0), LX+CD_PD+2, ey, 60, EH);
   ELbl(g_prefix+"e2_lbl","解锁比例%", LX+CD_PD+2+60+2, ey+2, F(10), cMute);
   ey += LH;

   // 最低保留
   EEdt(g_prefix+"e3_minHedge", DoubleToString(g_minHedgeProfit,0), LX+CD_PD+2, ey, 60, EH);
   ELbl(g_prefix+"e3_lbl","最低保留$", LX+CD_PD+2+60+2, ey+2, F(10), cMute);
   ey += LH;

   // 平衡容差
   EEdt(g_prefix+"e4_tolerance", DoubleToString(g_balanceTolerance,2), LX+CD_PD+2, ey, 60, EH);
   ELbl(g_prefix+"e4_lbl","平衡容差", LX+CD_PD+2+60+2, ey+2, F(10), cMute);

   // ── 右栏: 当前品种 + 操作卡 ──
   rx = RX;
   cy = g_py + HDR_H + SG;

   int actH = statusH + SG + paramH;
   ERect(g_prefix+"c_act",rx,cy,RW,actH,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c_act_title","当前品种:"+symbol,rx+CD_PD,cy+CD_PD,F(11),C'235,240,250');
   by = cy + CD_PD + 22;

   // 当前品种统计
   string curStat = "多:"+DoubleToString(curStats.buyLots,2)+"手 "+IntegerToString(curStats.buyCnt)+"单 | "+
                    "空:"+DoubleToString(curStats.sellLots,2)+"手 "+IntegerToString(curStats.sellCnt)+"单";
   ELbl(g_prefix+"act_cur", curStat, rx+CD_PD, by, F(10), cMute);
   by += LH;

   // 净头寸
   color netClr = (MathAbs(curStats.netLots) <= g_balanceTolerance) ? InpColorWarning :
                   (curStats.netLots>0?InpColorInfo:InpColorDanger);
   string netTxt = "净头寸:"+DoubleToString(curStats.netLots,4)+
                   " ["+(curStats.isBalanced?"平衡":"不平衡")+"]";
   ELbl(g_prefix+"act_net", netTxt, rx+CD_PD, by, F(10), netClr);
   by += LH + PG;

   // 当前品种锁仓状态
   if(curStats.isLocked)
   {
      int lockDir = GetLockDirection(symbol);
      double buyP = GetDirectionProfit(symbol, 1);
      double sellP = GetDirectionProfit(symbol, -1);
      string hTxt = "已锁仓-"+(lockDir==1?"多盈利":"空盈利")+"解锁 多盈利:$"+DoubleToString(buyP,2)+" 空盈利:$"+DoubleToString(sellP,2);
      color hClr = (lockDir==1 && buyP>0) ? InpColorNormal :
                   (lockDir==-1 && sellP>0) ? InpColorNormal : InpColorWarning;
      ELbl(g_prefix+"act_hedge", hTxt, rx+CD_PD, by, F(10), hClr);
      by += LH + PG;
   }

   // 操作按钮
   int bw = RW - CD_PD*2;
   if(g_locked)
   {
      EBtn(g_prefix+"btn_manualUnlock","手动解锁(恢复交易)", rx+CD_PD, by, bw, BH, C'50,140,80', C'235,240,250');
      by += BH + PG;
   }
   else if(ObjectFind(0,g_prefix+"btn_manualUnlock")>=0)
   {
      ObjectDelete(0, g_prefix+"btn_manualUnlock");
   }

   // 平多 / 平空 / 全平
   int bw3 = (RW - CD_PD*2 - PG*2) / 3;
   EBtn(g_prefix+"btn_closeBuy","全平多", rx+CD_PD, by, bw3, BH, InpColorInfo, C'235,240,250');
   EBtn(g_prefix+"btn_closeSell","全平空", rx+CD_PD+bw3+PG, by, bw3, BH, InpColorDanger, C'235,240,250');
   EBtn(g_prefix+"btn_closeAll","一键全平", rx+CD_PD+bw3*2+PG*2, by, bw3, BH, C'180,50,50', C'235,240,250');
   by += BH + PG;

   // 提示文字
   string hintTxt;
   color hintClr;
   if(g_locked)
   {
      hintTxt = "⚠ 已锁仓("+IntegerToString(totalLockedSymbols)+"品种): 等待方向盈利达"+DoubleToString(g_unlockRatio*100,0)+"%";
      hintClr = InpColorWarning;
   }
   else if(totalAccountPnl < -g_lockDrawdownUSD && g_lockDrawdownUSD > 0)
   {
      hintTxt = "🔥 账户浮亏达阈值, 即将锁仓!";
      hintClr = InpColorDanger;
   }
   else if(totalBalanced > 0 && g_lockDrawdownUSD > 0)
   {
      hintTxt = "⚡ 有"+IntegerToString(totalBalanced)+"个平衡品种, 浮亏:$"+DoubleToString(totalAccountPnl,1);
      hintClr = InpColorWarning;
   }
   else
   {
      hintTxt = "正常监测: 账户浮亏达阈值时锁仓平衡品种";
      hintClr = cMute;
   }
   ELbl(g_prefix+"act_hint", hintTxt, rx+CD_PD, by, F(9), hintClr);

   // ── 监控预警卡片 (全品种) ──
   int monY = cy + actH + SG;
   int monH = 200;
   ERect(g_prefix+"c_mon", X+PD, monY, PW-PD*2, monH, BG_CARD, BD_PANEL);
   ELbl(g_prefix+"c_mon_title","监控预警-全品种", X+PD+CD_PD, monY+CD_PD, F(11), C'235,240,250');

   // 标题行统计
   int balancedCnt=0, unbalancedCnt=0, warningCnt=0;
   for(int i=0; i<totalSymbols; i++)
   {
      if(allStats[i].isBalanced) balancedCnt++;
      else unbalancedCnt++;
      if(allStats[i].totalPnl < 0) warningCnt++;
   }
   string monTitle = "共 "+IntegerToString(totalSymbols)+" 品种 | 平衡:"+IntegerToString(balancedCnt)+" 不平衡:"+IntegerToString(unbalancedCnt);
   color monTitleClr = (warningCnt > 0) ? InpColorWarning : InpColorNormal;
   ELbl(g_prefix+"c_mon_sub", monTitle, X+PD+CD_PD+180, monY+CD_PD, F(10), monTitleClr);

   // 表头
   int hdrY = monY + CD_PD + 22;
   ELbl(g_prefix+"mon_h1","品种",     X+PD+CD_PD,       hdrY, F(9), cMute);
   ELbl(g_prefix+"mon_h2","浮亏$",    X+PD+CD_PD+60,    hdrY, F(9), cMute);
   ELbl(g_prefix+"mon_h3","多单-单/手", X+PD+CD_PD+110, hdrY, F(9), cMute);
   ELbl(g_prefix+"mon_h4","空单-单/手", X+PD+CD_PD+210, hdrY, F(9), cMute);
   ELbl(g_prefix+"mon_h5","锁仓",     X+PD+CD_PD+310,   hdrY, F(9), cMute);
   ELbl(g_prefix+"mon_h6","状态",     X+PD+CD_PD+370,   hdrY, F(9), cMute);

   // 数据行
   int monitorRowCount = 5;
   int rowH = (monH - CD_PD*2 - 22 - 24 - 30) / monitorRowCount;
   rowH = MathMax(rowH, 20);
   int maxShow = MathMin(monitorRowCount, totalSymbols);
   int startIdx = MathMax(0, MathMin(g_monitorScroll, totalSymbols - maxShow));
   g_monitorScroll = startIdx;

   // 清理多余的旧行标签
   for(int clr = maxShow; clr < monitorRowCount; clr++)
   {
      ObjectDelete(0, g_prefix+"mon_s"+IntegerToString(clr));
      ObjectDelete(0, g_prefix+"mon_p"+IntegerToString(clr));
      ObjectDelete(0, g_prefix+"mon_b"+IntegerToString(clr));
      ObjectDelete(0, g_prefix+"mon_sell"+IntegerToString(clr));
      ObjectDelete(0, g_prefix+"mon_hg"+IntegerToString(clr));
      ObjectDelete(0, g_prefix+"mon_st"+IntegerToString(clr));
   }

   for(int r=0; r<maxShow; r++)
   {
      int idx = startIdx + r;
      if(idx >= totalSymbols) break;
      int rowY = hdrY + 24 + r * rowH;

      // 品种名
      string symName = allStats[idx].symbol;
      if(StringLen(symName) > 8) symName = StringSubstr(symName, 0, 8);
      color symClr = C'200,210,230';
      ELbl(g_prefix+"mon_s"+IntegerToString(r), symName, X+PD+CD_PD, rowY+2, F(9), symClr);

      // 浮亏
      double pnl = allStats[idx].totalPnl;
      color pnlClr = (pnl>=0) ? InpColorNormal : InpColorDanger;
      string pnlTxt = (pnl>=0 ? "+" : "") + DoubleToString(pnl,2);
      ELbl(g_prefix+"mon_p"+IntegerToString(r), pnlTxt, X+PD+CD_PD+60, rowY+2, F(9), pnlClr);

      // 多单
      string buyTxt = IntegerToString(allStats[idx].buyCnt) + "/" + DoubleToString(allStats[idx].buyLots,2);
      color buyClr = (allStats[idx].buyLots > 0) ? InpColorInfo : cMute;
      ELbl(g_prefix+"mon_b"+IntegerToString(r), buyTxt, X+PD+CD_PD+110, rowY+2, F(9), buyClr);

      // 空单
      string sellTxt = IntegerToString(allStats[idx].sellCnt) + "/" + DoubleToString(allStats[idx].sellLots,2);
      color sellClr = (allStats[idx].sellLots > 0) ? InpColorDanger : cMute;
      ELbl(g_prefix+"mon_sell"+IntegerToString(r), sellTxt, X+PD+CD_PD+210, rowY+2, F(9), sellClr);

      // 锁仓
      string hgTxt = allStats[idx].isLocked ? (allStats[idx].lockDirection==1?"多":"空") : "-";
      color hgClr = allStats[idx].isLocked ? InpColorWarning : cMute;
      ELbl(g_prefix+"mon_hg"+IntegerToString(r), hgTxt, X+PD+CD_PD+310, rowY+2, F(9), hgClr);

      // 状态
      string statusTxt; color statusClr;
      if(allStats[idx].buyCnt == 0 && allStats[idx].sellCnt == 0)
      { statusTxt = "空仓"; statusClr = cMute; }
      else if(allStats[idx].isBalanced)
      { statusTxt = "平衡"; statusClr = InpColorWarning; }
      else
      { statusTxt = "不平衡"; statusClr = InpColorDanger; }
      ELbl(g_prefix+"mon_st"+IntegerToString(r), statusTxt, X+PD+CD_PD+370, rowY+2, F(9), statusClr);
   }

   // 滚动按钮
   if(totalSymbols > maxShow)
   {
      int scrollY = monY + monH - BH - CD_PD;
      int sbw = 80;
      int rightX = X + PW - PD - CD_PD - sbw*2 - PG;
      color btnBg = C'50,60,80';
      color btnFg = C'200,210,230';
      EBtn(g_prefix+"mon_scrollUp","上移", rightX, scrollY, sbw, BH, btnBg, btnFg);
      EBtn(g_prefix+"mon_scrollDown","下移", rightX+sbw+PG, scrollY, sbw, BH, btnBg, btnFg);
      ELbl(g_prefix+"mon_page", IntegerToString(startIdx+1)+"-"+IntegerToString(MathMin(startIdx+maxShow,totalSymbols))+"/"+IntegerToString(totalSymbols), rightX-60, scrollY+4, F(9), cMute);
   }
   else
   {
      if(ObjectFind(0,g_prefix+"mon_scrollUp")>=0) ObjectDelete(0, g_prefix+"mon_scrollUp");
      if(ObjectFind(0,g_prefix+"mon_scrollDown")>=0) ObjectDelete(0, g_prefix+"mon_scrollDown");
      if(ObjectFind(0,g_prefix+"mon_page")>=0) ObjectDelete(0, g_prefix+"mon_page");
   }
}

void RefreshPanel(bool force)
{
   static datetime lastRefresh = 0;
   if(!force && TimeCurrent()==lastRefresh) return;
   lastRefresh = TimeCurrent();
   DrawPanel();
}

//+------------------------------------------------------------------+
//| 按钮事件处理                                                      |
//+------------------------------------------------------------------+
void HandlePanelButtonClick(const string sparam)
{
   string k = StringSubstr(sparam, StringLen(g_prefix));
   string symbol = _Symbol;

   // 折叠/展开
   if(k == "toggle_panel")
   {
      ResetPanelButtonState(sparam);
      if(g_panel_open)
      { if(!ShowConfirmDialog("确定要隐藏面板吗？")) return; }
      g_panel_open = !g_panel_open;
      g_panel_dragging = false;
      SetPanelDragHighlight(false);
      RefreshPanel(true);
      return;
   }

   // ── 监控列表滚动 ──
   if(k == "mon_scrollUp")
   {
      ResetPanelButtonState(sparam);
      if(g_monitorScroll > 0) g_monitorScroll -= 1;
      RefreshPanel(true);
      return;
   }
   if(k == "mon_scrollDown")
   {
      ResetPanelButtonState(sparam);
      g_monitorScroll += 1;
      RefreshPanel(true);
      return;
   }
   if(!g_panel_open) return;

   ReadEdits();

   // 手动解锁
   if(k == "btn_manualUnlock")
   {
      ResetPanelButtonState(sparam);
      string msg = "确定要手动解锁吗？\n\n"
                 + "解锁后:\n"
                 + "• 风控系统恢复监测\n"
                 + "• 锁仓标记保留\n"
                 + "• 方向盈利达50%时自动渐进平仓";
      if(!ShowConfirmDialog(msg)) return;

      // 取消所有锁仓标记
      for(int i=0; i<ArraySize(g_lockedSymbols); i++)
         UnmarkSymbolAsLocked(g_lockedSymbols[i]);
      ResetLockState();
      RefreshPanel(true);
      return;
   }

   // 全平多单
   if(k == "btn_closeBuy")
   {
      ResetPanelButtonState(sparam);
      SymbolStats stats; GetSymbolStats(symbol, stats);
      if(!ShowConfirmDialog("确定全平 "+symbol+" 多单?\n"+DoubleToString(stats.buyLots,2)+"手 "+IntegerToString(stats.buyCnt)+"单")) return;
      CloseAllPositionsBySymbol(symbol, POSITION_TYPE_BUY);
      RefreshPanel(true); return;
   }

   // 全平空单
   if(k == "btn_closeSell")
   {
      ResetPanelButtonState(sparam);
      SymbolStats stats; GetSymbolStats(symbol, stats);
      if(!ShowConfirmDialog("确定全平 "+symbol+" 空单?\n"+DoubleToString(stats.sellLots,2)+"手 "+IntegerToString(stats.sellCnt)+"单")) return;
      CloseAllPositionsBySymbol(symbol, POSITION_TYPE_SELL);
      RefreshPanel(true); return;
   }

   // 一键全平
   if(k == "btn_closeAll")
   {
      ResetPanelButtonState(sparam);
      SymbolStats stats; GetSymbolStats(symbol, stats);
      int total = stats.buyCnt + stats.sellCnt;
      if(!ShowConfirmDialog("确定一键全平 "+symbol+" 全部 "+IntegerToString(total)+" 单?")) return;
      CloseAllPositionsBySymbol(symbol, POSITION_TYPE_BUY);
      CloseAllPositionsBySymbol(symbol, POSITION_TYPE_SELL);
      RefreshPanel(true); return;
   }
}

//+------------------------------------------------------------------+
//| EA 主函数                                                          |
//+------------------------------------------------------------------+
int OnInit()
{
   g_lockDrawdownUSD = InpLockDrawdownUSD;
   g_unlockRatio = InpUnlockRatio;
   g_minHedgeProfit = InpMinHedgeProfit;
   g_balanceTolerance = InpBalanceTolerance;
   g_px = InpPanelX; g_py = InpPanelY;
   LoadParamsFromGV();
   EventSetTimer(1);
   DrawPanel();
   Print("═══════════════════════════════════════════════════");
   Print("[账户仓位多空仓位平衡风控] v3.00 启动");
   Print("  账户浮亏锁仓阈值: $", DoubleToString(g_lockDrawdownUSD,1));
   Print("  解锁比例: ", DoubleToString(g_unlockRatio*100,0), "%");
   Print("  最低保留盈利: $", DoubleToString(g_minHedgeProfit,1));
   Print("  平衡容差: ", DoubleToString(g_balanceTolerance,2));
   Print("  锁仓标记: ", LOCK_COMMENT);
   Print("═══════════════════════════════════════════════════");
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   DelContent();
   ObjectDelete(0,g_prefix+"toggle_panel");
   EventKillTimer();
   SaveParamsToGV();
   Print("[账户仓位多空仓位平衡风控] 已停止");
}

void OnTick()
{
   CheckLock();
}

void OnTimer()
{
   if(g_panel_open) { ReadEdits(); SaveParamsToGV(); }
   RefreshPanel(false);
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   int click_x=(int)lparam;
   int click_y=(int)dparam;
   if(id == CHARTEVENT_CLICK)
   {
      if(!g_panel_dragging)
      {
         if(IsClickOnPanelDragArea(click_x,click_y))
         {
            g_panel_dragging = true;
            g_panel_drag_ox = click_x - g_px;
            g_panel_drag_oy = click_y - g_py;
            SetPanelDragHighlight(true);
            ChartRedraw(0);
         }
      }
      else
      {
         g_panel_dragging = false;
         SetPanelDragHighlight(false);
         ChartRedraw(0);
      }
      return;
   }
   if(id == CHARTEVENT_MOUSE_MOVE && g_panel_dragging)
   {
      int new_x = click_x - g_panel_drag_ox;
      int new_y = click_y - g_panel_drag_oy;
      ClampPanelPosition(new_x, new_y);
      MovePanelTo(new_x, new_y);
      return;
   }
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam != "") HandlePanelButtonClick(sparam);
   }
}
//+------------------------------------------------------------------+