//+------------------------------------------------------------------+
//|                                          账户仓位多空仓位平衡风控.mq5  |
//|                              Copyright 2025, 风控系统               |
//|   功能: 监测账户中每个品种的仓位平衡, 浮亏达阈值触发锁仓风控          |
//|   核心: 多空手数≈0(平衡) + 浮亏达阈值 → 反向对冲 → 渐进平仓 → 解锁   |
//|   参数: 浮亏锁仓阈值=-1000, 盈利阈值=50%, 最低保留=5                |
//+------------------------------------------------------------------+
#property copyright "风控系统"
#property version   "1.00"
#property description "账户仓位多空仓位平衡风控"
#property description "监测多空平衡 → 浮亏锁仓 → 反向对冲 → 渐进平仓 → 解锁"
#include <Trade/Trade.mqh>
//+------------------------------------------------------------------+
//| 输入参数                                                          |
//+------------------------------------------------------------------+
input group "== 锁仓风控参数 =="
input double      InpLockDrawdownUSD   = -1000.0;  // 浮亏锁仓阈值($,负数=禁用,设为正数如1000则启用)
input double      InpUnlockRatio       = 0.50;     // 盈利解锁比例(对冲盈利达锁仓阈值的此比例即解锁)
input double      InpMinHedgeProfit    = 5.0;      // 最低保留对冲盈利(渐进平仓时需保留此额)
input int         InpSlippage          = 30;       // 滑点
input int         InpLockMagic         = 888888;   // 锁仓对冲单魔术码
input bool        InpAutoDetectBalance = true;     // 自动检测多空平衡状态
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
#define THIRD_W         ((LW - PG*2)/3)

//+------------------------------------------------------------------+
//| 结构体                                                            |
//+------------------------------------------------------------------+
struct PositionInfo
{
   ulong    ticket;
   double   openPrice;
   double   lots;
   double   profit;
   ENUM_POSITION_TYPE posType;
   datetime time;
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
int            g_lockDir        = 0;         // 触发方向(1=多亏触发, -1=空亏触发, 0=双向)
#define LOCK_DISABLED -999999.0
double         g_lockDrawdownUSD = -999999.0; // 当前锁仓阈值(运行时)
double         g_unlockRatio    = 0.50;      // 解锁比例
double         g_minHedgeProfit = 5.0;       // 最低保留盈利
bool           g_progressiveClose = false;    // 渐进平仓模式
bool           g_postLockWait  = false;      // 手动解锁后等待状态
int            g_lockMagic     = 888888;     // 锁仓对冲单魔术码
double         g_balanceTolerance = 0.01;    // 平衡容差

// ── 异步平仓 ──
CTrade         g_asyncTrade;
bool           g_isAsyncClosing = false;

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
   if(y + 400 > ch && ch > 400) y = (int)(ch - 400);
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
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,h); ObjectSetString(0,nm,OBJPROP_FONT,"Microsoft YaHei");
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
double GetVolumeStep() { double s = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP); return (s > 0 ? s : 0.01); }
double AlignVolumeToStep(double volume) { double s = GetVolumeStep(); return MathFloor(volume / s + 1e-9) * s; }
double GetMinLot() { return SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN); }

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
   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      double p = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
      {
         stats.buyLots += PositionGetDouble(POSITION_VOLUME);
         stats.buyPnl += p;
         stats.buyCnt++;
      }
      else
      {
         stats.sellLots += PositionGetDouble(POSITION_VOLUME);
         stats.sellPnl += p;
         stats.sellCnt++;
      }
   }
   stats.netLots = stats.buyLots - stats.sellLots;
   stats.totalPnl = stats.buyPnl + stats.sellPnl;
   stats.isBalanced = (MathAbs(stats.netLots) <= g_balanceTolerance && (stats.buyCnt > 0 || stats.sellCnt > 0));
}

//+------------------------------------------------------------------+
//| 锁仓对冲: 开反向单锁住平衡仓位                                    |
//+------------------------------------------------------------------+
void OpenLockHedge(string symbol, ENUM_POSITION_TYPE dir, double lots)
{
   if(lots <= 0) return;
   double step = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
   double minVol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
   lots = MathFloor(lots / step) * step;
   if(lots < minVol) return;
   double price = (dir == POSITION_TYPE_BUY) ? SymbolInfoDouble(symbol,SYMBOL_ASK) : SymbolInfoDouble(symbol,SYMBOL_BID);
   string cmnt = (dir==POSITION_TYPE_BUY) ? "风控对冲多" : "风控对冲空";
   m_trade.SetExpertMagicNumber(g_lockMagic);
   bool ok = (dir==POSITION_TYPE_BUY) ? m_trade.Buy(lots,symbol,price,0,0,cmnt)
                                       : m_trade.Sell(lots,symbol,price,0,0,cmnt);
   if(ok)
      Print("[风控锁仓] 反向开",(dir==POSITION_TYPE_BUY?"多":"空")," ",symbol," @ ",DoubleToString(price,5),
            " 手数:",DoubleToString(lots,2)," 魔术码:",g_lockMagic);
   else
      Print("[风控锁仓] 开对冲失败: ",m_trade.ResultRetcodeDescription());
   m_trade.SetExpertMagicNumber(InpLockMagic);
}

//+------------------------------------------------------------------+
//| 计算指定品种锁仓对冲单盈亏                                        |
//+------------------------------------------------------------------+
double GetLockHedgeProfit(string symbol)
{
   double total = 0;
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if((int)PositionGetInteger(POSITION_MAGIC) != g_lockMagic) continue;
      total += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   }
   return total;
}

//+------------------------------------------------------------------+
//| 统计锁仓对冲单的手数                                              |
//+------------------------------------------------------------------+
void GetLockHedgeLots(string symbol, double &buyLots, double &sellLots)
{
   buyLots = 0; sellLots = 0;
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if((int)PositionGetInteger(POSITION_MAGIC) != g_lockMagic) continue;
      double vol = PositionGetDouble(POSITION_VOLUME);
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         buyLots += vol;
      else
         sellLots += vol;
   }
}

//+------------------------------------------------------------------+
//| 是否存在锁仓对冲单                                                |
//+------------------------------------------------------------------+
bool HasLockHedge(string symbol)
{
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if((int)PositionGetInteger(POSITION_MAGIC) == g_lockMagic) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 平掉指定品种所有锁仓对冲单                                        |
//+------------------------------------------------------------------+
void CloseLockHedge(string symbol)
{
   int closed = 0;
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if((int)PositionGetInteger(POSITION_MAGIC) != g_lockMagic) continue;
      double vol = PositionGetDouble(POSITION_VOLUME);
      double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(ClosePosition(ticket, vol, InpSlippage))
      {
         closed++;
         Print("[风控解锁] 平对冲单 #",ticket,
               (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY?" 多":" 空",
               " 手:",DoubleToString(vol,2)," 盈亏:$",DoubleToString(profit,2));
      }
   }
   if(closed>0) Print("[风控解锁] ",symbol," 共平对冲单 ",closed," 笔");
}

//+------------------------------------------------------------------+
//| 获取指定方向亏损总额(非锁仓单)                                    |
//+------------------------------------------------------------------+
double GetDirLossAmount(string symbol, ENUM_POSITION_TYPE posType)
{
   double loss = 0;
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != posType) continue;
      if((int)PositionGetInteger(POSITION_MAGIC) == g_lockMagic) continue;
      double p = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(p < -0.01) loss += -p;
   }
   return loss;
}

//+------------------------------------------------------------------+
//| 是否存在指定方向亏损单                                            |
//+------------------------------------------------------------------+
bool HasLossOrders(string symbol, ENUM_POSITION_TYPE posType)
{
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != posType) continue;
      if((int)PositionGetInteger(POSITION_MAGIC) == g_lockMagic) continue;
      double p = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(p < -0.01) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 渐进平仓: 用对冲盈利平亏损单                                      |
//+------------------------------------------------------------------+
bool ProgressiveCloseLossOrders(string symbol)
{
   if(!g_progressiveClose)
   {
      g_progressiveClose = true;
      ReadEdits();
   }
   double currentHedge = GetLockHedgeProfit(symbol);
   double budget = currentHedge - g_minHedgeProfit;

   Print("[渐进平仓] ",symbol," 对冲盈利=$",DoubleToString(currentHedge,2),
         " 最低保留=$",DoubleToString(g_minHedgeProfit,2),
         " 预算=$",DoubleToString(budget,2));

   if(budget < GetMinLot() * 0.01)
   {
      Print("[渐进平仓] 预算不足 → 直接解锁");
      return true;
   }

   int count = 0;
   PositionInfo entries[];
   ArrayResize(entries, (int)PositionsTotal());
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      ENUM_POSITION_TYPE pt = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      if(g_lockDir==1 && pt!=POSITION_TYPE_BUY) continue;
      if(g_lockDir==-1 && pt!=POSITION_TYPE_SELL) continue;
      if((int)PositionGetInteger(POSITION_MAGIC) == g_lockMagic) continue;
      double p = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(p >= -0.01) continue;
      entries[count].ticket = ticket;
      entries[count].openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      entries[count].lots = PositionGetDouble(POSITION_VOLUME);
      entries[count].profit = p;
      entries[count].posType = pt;
      count++;
   }
   if(count==0) { Print("[渐进平仓] 无亏损单 → 直接解锁"); return true; }

   bool highFirst = (g_lockDir == 1 || g_lockDir == 0);
   for(int i=0; i<count-1; i++)
      for(int j=i+1; j<count; j++)
      {
         bool needSwap = highFirst ? (entries[i].openPrice < entries[j].openPrice)
                                    : (entries[i].openPrice > entries[j].openPrice);
         if(needSwap) { PositionInfo tmp = entries[i]; entries[i] = entries[j]; entries[j] = tmp; }
      }

   int closedCnt = 0;
   double totalReleased = 0;
   for(int k=0; k<count; k++)
   {
      ulong ticket = entries[k].ticket;
      if(!PositionSelectByTicket(ticket)) continue;
      double realProfit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      double realLots = PositionGetDouble(POSITION_VOLUME);
      if(realProfit >= -0.01) continue;
      double lossPerLot = (-realProfit) / realLots;
      if(lossPerLot <= 0) continue;
      double affordable = budget / lossPerLot;
      double closeLot = MathMin(realLots, affordable);
      closeLot = MathFloor(closeLot / GetMinLot()) * GetMinLot();
      if(closeLot < GetMinLot())
      {
         if(closedCnt == 0) { Print("[渐进平仓] 预算不足 → 直接解锁"); return true; }
         break;
      }
      double lossForClose = closeLot * lossPerLot;
      if(lossForClose > budget * 0.95)
      {
         closeLot = MathFloor(budget * 0.95 / lossPerLot / GetMinLot()) * GetMinLot();
         if(closeLot < GetMinLot()) break;
         lossForClose = closeLot * lossPerLot;
      }
      if(ClosePosition(ticket, closeLot, InpSlippage))
      {
         closedCnt++;
         totalReleased += lossForClose;
         budget -= lossForClose;
         Print("[渐进平仓] 平单#",closedCnt," 平:",DoubleToString(closeLot,2),"手 释放亏损:$",DoubleToString(lossForClose,2));
      }
   }

   double finalHedge = GetLockHedgeProfit(symbol);
   if(finalHedge >= g_minHedgeProfit)
   {
      Print("[渐进平仓] 对冲盈利=$",DoubleToString(finalHedge,2)," ≥ 最低保留=$",DoubleToString(g_minHedgeProfit,2)," → 解锁!");
      return true;
   }
   Print("[渐进平仓] 对冲盈利=$",DoubleToString(finalHedge,2)," < 最低保留=$",DoubleToString(g_minHedgeProfit,2)," → 继续等待");
   return false;
}

//+------------------------------------------------------------------+
//| 重置锁仓状态                                                      |
//+------------------------------------------------------------------+
void ResetLockState()
{
   g_locked = false;
   g_postLockWait = false;
   g_lockOrigThresh = 0;
   g_lockDir = 0;
   g_lockDrawdownUSD = LOCK_DISABLED;
   g_progressiveClose = false;
   Print("[风控解锁] 阈值回到禁用值, 需手动设置新阈值");
   Print("[风控解锁] 风控系统恢复, 持续监测平衡状态");
   RefreshPanel(true);
   ObjectSetString(0, g_prefix+"e1_threshold", OBJPROP_TEXT, "禁用");
}

//+------------------------------------------------------------------+
//| 核心: 检查锁仓 (平衡+浮亏→对冲, 对冲盈利→渐进平仓→解锁)            |
//+------------------------------------------------------------------+
void CheckLock()
{
   string symbol = _Symbol;
   SymbolStats stats;
   GetSymbolStats(symbol, stats);

   // ── 已锁仓: 解锁检测 ──
   if(g_locked)
   {
      if(!HasLockHedge(symbol))
      {
         double totalProfit = stats.totalPnl + GetLockHedgeProfit(symbol);
         Print("[风控解锁检查] 对冲单已平仓, 总盈亏=$",DoubleToString(totalProfit,2));
         ResetLockState();
         return;
      }
      double hedgeProfit = GetLockHedgeProfit(symbol);
      double targetProfit = g_lockOrigThresh * g_unlockRatio;
      if(!g_progressiveClose && g_lockOrigThresh > 0 && hedgeProfit < targetProfit) return;

      if(!g_progressiveClose)
      {
         Print("════════════════════════════════");
         Print("[渐进平仓] ",symbol," 对冲盈利达标 → 启动渐进平仓");
         Print("[渐进平仓] 对冲盈利:$",DoubleToString(hedgeProfit,2)," 解锁目标:$",DoubleToString(targetProfit,2));
      }
      if(ProgressiveCloseLossOrders(symbol))
      {
         Print("[解锁] ",symbol," 条件满足 → 平掉对冲单 + 完整解锁");
         CloseLockHedge(symbol);
         ResetLockState();
      }
      return;
   }

   // ── 手动解锁后: 继续监控对冲盈利 ──
   if(g_postLockWait)
   {
      if(!HasLockHedge(symbol))
      {
         Print("[解锁检查] 对冲单已平仓 → 完整解锁");
         ResetLockState();
         return;
      }
      double hedgeProfit = GetLockHedgeProfit(symbol);
      double targetProfit = g_lockOrigThresh * g_unlockRatio;
      if(g_lockOrigThresh > 0 && hedgeProfit < targetProfit) return;

      if(!g_progressiveClose)
      {
         Print("════════════════════════════════");
         Print("[解锁后渐进平仓] ",symbol," 对冲盈利达标 → 启动渐进平仓");
         Print("[解锁后渐进平仓] 对冲盈利:$",DoubleToString(hedgeProfit,2)," 目标:$",DoubleToString(targetProfit,2));
      }
      if(ProgressiveCloseLossOrders(symbol))
      {
         Print("[解锁后渐进平仓] ",symbol," 完成 → 平掉对冲单 + 完整解锁");
         CloseLockHedge(symbol);
         ResetLockState();
      }
      return;
   }

   // ── 未锁仓: 检测是否需要锁仓 ──
   if(g_lockDrawdownUSD <= 0) return;

   // 核心触发: 多空平衡 + 浮亏达阈值
   if(!stats.isBalanced) return;

   double buyLoss = 0, sellLoss = 0;
   if(stats.buyPnl < 0) buyLoss = -stats.buyPnl;
   if(stats.sellPnl < 0) sellLoss = -stats.sellPnl;
   double totalLoss = buyLoss + sellLoss;

   if(totalLoss < g_lockDrawdownUSD) return;

   g_lockOrigThresh = g_lockDrawdownUSD;
   g_locked = true;
   g_progressiveClose = false;

   if(buyLoss >= g_lockOrigThresh && sellLoss >= g_lockOrigThresh) g_lockDir = 0;
   else if(buyLoss >= g_lockOrigThresh) g_lockDir = 1;
   else if(sellLoss >= g_lockOrigThresh) g_lockDir = -1;

   Print("════════════════════════════════");
   Print("[风控锁仓] ",symbol," 多空平衡 + 浮亏达阈值");
   Print("[风控锁仓] 多手:",DoubleToString(stats.buyLots,2)," 空手:",DoubleToString(stats.sellLots,2),
         " 净额:",DoubleToString(stats.netLots,4));
   Print("[风控锁仓] 多浮亏:$",DoubleToString(buyLoss,2)," 空浮亏:$",DoubleToString(sellLoss,2),
         " 阈值:$",DoubleToString(g_lockOrigThresh,2));
   Print("[风控锁仓] 触发方向:",(g_lockDir==1?"多单":(g_lockDir==-1?"空单":"双向")));

   // 触发对冲: 多亏→开空对冲, 空亏→开多对冲
   if(g_lockDir == 1 || g_lockDir == 0)
   {
      if(buyLoss > 0 && stats.buyLots > 0)
      {
         Print("[风控锁仓] 多单亏损 → 按比例开空对冲");
         double hedgeLots = MathMin(stats.buyLots, buyLoss * 0.5 / GetMinLot() * GetMinLot());
         if(hedgeLots >= GetMinLot()) OpenLockHedge(symbol, POSITION_TYPE_SELL, AlignVolumeToStep(hedgeLots));
      }
   }
   if(g_lockDir == -1 || g_lockDir == 0)
   {
      if(sellLoss > 0 && stats.sellLots > 0)
      {
         Print("[风控锁仓] 空单亏损 → 按比例开多对冲");
         double hedgeLots = MathMin(stats.sellLots, sellLoss * 0.5 / GetMinLot() * GetMinLot());
         if(hedgeLots >= GetMinLot()) OpenLockHedge(symbol, POSITION_TYPE_BUY, AlignVolumeToStep(hedgeLots));
      }
   }

   // 如果没有触发具体方向对冲, 则开反向对冲
   if(!HasLockHedge(symbol))
   {
      if(stats.netLots > 0 && stats.sellLots > 0)
         OpenLockHedge(symbol, POSITION_TYPE_BUY, stats.sellLots);
      else if(stats.netLots < 0 && stats.buyLots > 0)
         OpenLockHedge(symbol, POSITION_TYPE_SELL, stats.buyLots);
   }

   g_lockDrawdownUSD = LOCK_DISABLED;
   Print("[风控锁仓] 阈值已设为禁用值, 锁仓期间不再触发");
   Print("[风控锁仓] 解锁方式: 对冲盈利达50% → 渐进平仓 → 解锁");
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

   string symbol = _Symbol;
   SymbolStats stats;
   GetSymbolStats(symbol, stats);
   double hedgePnl = GetLockHedgeProfit(symbol);
   double hedgeBuyLots=0, hedgeSellLots=0;
   GetLockHedgeLots(symbol, hedgeBuyLots, hedgeSellLots);

   // 配色
   color BG_PANEL = C'18,20,28', BD_PANEL = C'60,68,88', BG_HDR = C'30,34,48';
   color BG_CARD = C'24,27,38', cMute = C'130,140,165';

   int X = g_px, LX = X+PD, RX = LX+LW+PG;

   // 外框 + 标题栏
   ERect(g_prefix+"panel", X, g_py, PW, 420, BG_PANEL, BD_PANEL);
   ERect(g_prefix+"header", X, g_py, PW, HDR_H, BG_HDR, BD_PANEL);
   ELbl(g_prefix+"title", "账户仓位多空仓位平衡风控", LX+4, g_py+8, F(14), C'235,240,250');
   ELbl(g_prefix+"sub", symbol+" | 平衡容差:"+DoubleToString(g_balanceTolerance,3), LX+4, g_py+30, F(9), cMute);

   int cy = g_py + HDR_H + SG;
   int ry = 0;
   int ey = 0;
   int btnY = 0;
   int rx = 0;
   string tTxt; color tClr;

   // ── 卡片1: 状态卡 ──
   int statusH = 180;
   ERect(g_prefix+"c1",LX,cy,LW,statusH,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c1_title","仓位状态",LX+CD_PD,cy+CD_PD,F(11),C'235,240,250');
   ry = cy + CD_PD + 20;

   // 多空手数
   ELbl(g_prefix+"r1_lbl","多单", LX+CD_PD, ry+1, F(10), cMute);
   ELbl(g_prefix+"r1_val", DoubleToString(stats.buyLots,2)+"手 "+IntegerToString(stats.buyCnt)+"单", LX+CD_PD+LW*4/10, ry+1, F(10), InpColorInfo);
   ry += LH;
   ELbl(g_prefix+"r2_lbl","空单", LX+CD_PD, ry+1, F(10), cMute);
   ELbl(g_prefix+"r2_val", DoubleToString(stats.sellLots,2)+"手 "+IntegerToString(stats.sellCnt)+"单", LX+CD_PD+LW*4/10, ry+1, F(10), InpColorDanger);
   ry += LH;
   ELbl(g_prefix+"r3_lbl","净头寸", LX+CD_PD, ry+1, F(10), cMute);
   color netClr = (MathAbs(stats.netLots) <= g_balanceTolerance) ? InpColorWarning : (stats.netLots>0?InpColorInfo:InpColorDanger);
   ELbl(g_prefix+"r3_val", DoubleToString(stats.netLots,4), LX+CD_PD+LW*4/10, ry+1, F(10), netClr);
   ry += LH;
   ELbl(g_prefix+"r4_lbl","多空状态", LX+CD_PD, ry+1, F(10), cMute);
   if(stats.isBalanced) { tTxt = "≈平衡 (锁仓)"; tClr = InpColorWarning; }
   else if(stats.netLots > g_balanceTolerance) { tTxt = "净多头"; tClr = InpColorInfo; }
   else if(stats.netLots < -g_balanceTolerance) { tTxt = "净空头"; tClr = InpColorDanger; }
   else { tTxt = "空仓"; tClr = cMute; }
   ELbl(g_prefix+"r4_val", tTxt, LX+CD_PD+LW*4/10, ry+1, F(10), tClr);
   ry += LH;

   // 盈亏
   double totalPnl = stats.totalPnl;
   color pnlClr = (totalPnl>=0) ? InpColorNormal : InpColorDanger;
   ELbl(g_prefix+"r5_lbl","浮动盈亏", LX+CD_PD, ry+1, F(10), cMute);
   ELbl(g_prefix+"r5_val", "$"+DoubleToString(totalPnl,2), LX+CD_PD+LW*4/10, ry+1, F(10), pnlClr);
   ry += LH;

   // 锁仓对冲单
   ELbl(g_prefix+"r6_lbl","对冲单盈亏", LX+CD_PD, ry+1, F(10), cMute);
   color hpClr = (hedgePnl>=0) ? InpColorNormal : InpColorDanger;
   string hpTxt = (hedgeBuyLots+hedgeSellLots>0) ?
      "$"+DoubleToString(hedgePnl,2)+" "+DoubleToString(hedgeBuyLots,2)+"多/"+DoubleToString(hedgeSellLots,2)+"空" : "无";
   ELbl(g_prefix+"r6_val", hpTxt, LX+CD_PD+LW*4/10, ry+1, F(10), hpClr);
   ry += LH;

   // 锁仓状态
   string lockStatus; color lockClr;
   if(g_progressiveClose){ lockStatus = "渐进平仓中"; lockClr = InpColorWarning; }
   else if(g_locked){ lockStatus = "已锁仓"; lockClr = InpColorDanger; }
   else if(g_postLockWait){ lockStatus = "锁仓等待50%"; lockClr = InpColorWarning; }
   else { lockStatus = "正常"; lockClr = InpColorNormal; }
   ELbl(g_prefix+"r7_lbl","锁仓状态", LX+CD_PD, ry+1, F(10), cMute);
   ELbl(g_prefix+"r7_val", lockStatus, LX+CD_PD+LW*4/10, ry+1, F(10), lockClr);
   ry += LH;

   // 进度显示
   if((g_locked || g_postLockWait) && HasLockHedge(symbol))
   {
      double targetP = g_lockOrigThresh * g_unlockRatio;
      string progTxt; color progClr;
      if(g_postLockWait && !g_progressiveClose)
      { progTxt = "对冲$"+DoubleToString(hedgePnl,2)+" 50%目标$"+DoubleToString(targetP,2);
         progClr = (hedgePnl>=targetP)?InpColorNormal:InpColorWarning; }
      else
      { progTxt = "对冲$"+DoubleToString(hedgePnl,2)+" 最低保留$"+DoubleToString(g_minHedgeProfit,2);
         progClr = (hedgePnl>=g_minHedgeProfit)?InpColorNormal:InpColorDanger; }
      ELbl(g_prefix+"r8_lbl","进度", LX+CD_PD, ry+1, F(10), cMute);
      ELbl(g_prefix+"r8_val", progTxt, LX+CD_PD+LW*4/10, ry+1, F(10), progClr);
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

   // ── 右栏: 操作卡 ──
   rx = RX;
   cy = g_py + HDR_H + SG;

   int actH = 250;
   ERect(g_prefix+"c_act",rx,cy,RW,actH,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c_act_title","操作",rx+CD_PD,cy+CD_PD,F(11),C'235,240,250');
   by = cy + CD_PD + 22;

   // 统计
   string statTxt = "多:"+DoubleToString(stats.buyLots,2)+"手 | 空:"+DoubleToString(stats.sellLots,2)+"手 | 净:"+DoubleToString(stats.netLots,4);
   ELbl(g_prefix+"act_stat", statTxt, rx+CD_PD, by, F(10), cMute);
   by += LH + PG;

   // 对冲单统计
   if(hedgeBuyLots+hedgeSellLots > 0)
   {
      string hTxt = "对冲多:"+DoubleToString(hedgeBuyLots,2)+"手 空:"+DoubleToString(hedgeSellLots,2)+"手 盈亏:$"+DoubleToString(hedgePnl,2);
      color hClr = (hedgePnl>=0)?InpColorNormal:InpColorDanger;
      ELbl(g_prefix+"act_hedge", hTxt, rx+CD_PD, by, F(10), hClr);
      by += LH + PG;
   }

   // 手动解锁按钮 (锁仓时显示)
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
      hintTxt = "⚠ 已锁仓: 对冲单保留, 等待盈利达50%";
      hintClr = InpColorWarning;
   }
   else if(g_postLockWait)
   {
      hintTxt = "⌛ 解锁后等待中: 对冲盈利达标即渐进平仓";
      hintClr = InpColorWarning;
   }
   else if(stats.isBalanced && g_lockDrawdownUSD > 0)
   {
      double totalLoss = (stats.buyPnl<0?-stats.buyPnl:0) + (stats.sellPnl<0?-stats.sellPnl:0);
      if(totalLoss >= g_lockDrawdownUSD)
      { hintTxt = "🔥 平衡+浮亏达阈值, 即将锁仓!"; hintClr = InpColorDanger; }
      else
      { hintTxt = "⚡ 多空平衡, 浮亏:"+DoubleToString(totalLoss,1)+"< 阈值$"+DoubleToString(g_lockDrawdownUSD,0);
         hintClr = cMute; }
   }
   else
   {
      hintTxt = "正常监测: 多空不平衡时不触发锁仓";
      hintClr = cMute;
   }
   ELbl(g_prefix+"act_hint", hintTxt, rx+CD_PD, by, F(9), hintClr);
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
   if(!g_panel_open) return;

   ReadEdits();

   // 手动解锁
   if(k == "btn_manualUnlock")
   {
      ResetPanelButtonState(sparam);
      double hedgePnl = GetLockHedgeProfit(symbol);
      double targetP = g_lockOrigThresh * g_unlockRatio;
      string msg = "确定要手动解锁吗？\n\n"
                 + "对冲盈亏: $"+DoubleToString(hedgePnl,2)+"\n"
                 + "50%目标: $"+DoubleToString(targetP,2)+"\n\n"
                 + "解锁后:\n"
                 + "• 风控系统恢复监测\n"
                 + "• 锁仓对冲单保留(魔术码"+IntegerToString(g_lockMagic)+")\n"
                 + "• 对冲盈利达50%时自动渐进平仓";
      if(!ShowConfirmDialog(msg)) return;
      g_locked = false;
      g_postLockWait = true;
      g_lockDrawdownUSD = LOCK_DISABLED;
      Print("════════════════════════════════");
      Print("[手动解锁] ",symbol," 风控恢复, 对冲单保留");
      Print("[手动解锁] 对冲盈亏:$",DoubleToString(hedgePnl,2)," 目标:$",DoubleToString(targetP,2));
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
   g_lockMagic = InpLockMagic;
   g_lockDrawdownUSD = InpLockDrawdownUSD;
   g_unlockRatio = InpUnlockRatio;
   g_minHedgeProfit = InpMinHedgeProfit;
   g_balanceTolerance = InpBalanceTolerance;
   g_px = InpPanelX; g_py = InpPanelY;
   LoadParamsFromGV();
   m_trade.SetExpertMagicNumber(InpLockMagic);
   EventSetTimer(1);
   DrawPanel();
   Print("═══════════════════════════════════════════════════");
   Print("[账户仓位多空仓位平衡风控] v1.00 启动");
   Print("  监控品种: ", _Symbol);
   Print("  浮亏锁仓阈值: $", DoubleToString(g_lockDrawdownUSD,1));
   Print("  解锁比例: ", DoubleToString(g_unlockRatio*100,0), "%");
   Print("  最低保留盈利: $", DoubleToString(g_minHedgeProfit,1));
   Print("  平衡容差: ", DoubleToString(g_balanceTolerance,2));
   Print("  锁仓对冲魔术码: ", g_lockMagic);
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