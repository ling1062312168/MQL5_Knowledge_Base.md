//+------------------------------------------------------------------+
//|                                      账户仓位多空仓位平衡风控.mq5  |
//|                              Copyright 2025, 风控系统               |
//|                                                                  |
//|   ⚠️ 核心定位: 监控为主, 平仓辅助, 绝不开仓                         |
//|                                                                  |
//|   功能: 监测账户所有持仓, 识别多空平衡品种, 标记监控,                 |
//|         条件满足时渐进平仓, 提供手动平仓面板                         |
//|                                                                  |
//|   逻辑流程:                                                       |
//|     1. 持续监测账户所有品种的多空持仓                               |
//|     2. 识别平衡品种 (多空手数相抵, 净头寸≈0)                        |
//|     3. 账户浮亏达阈值 → 标记平衡品种 (仅加注释, 不开新单)            |
//|     4. 方向盈利达50% → 渐进平仓亏损单                               |
//|     5. 亏损平完 → 取消标记, 恢复监测                                |
//|                                                                  |
//|   ⛔ 本EA不负责: 开仓, 加仓, 锁仓开单                              |
//|                                                                  |
//|   参数: 标记阈值=-1000, 盈利解锁=50%, 最低保留=5                    |
//+------------------------------------------------------------------+
#property copyright "风控系统"
#property version   "4.01"
#property description "账户仓位多空仓位平衡风控 - 仅监控和平仓, 不开仓"
#property description "识别平衡品种 → 标记监控 → 渐进平仓 → 解锁"
#include <Trade/Trade.mqh>

//+------------------------------------------------------------------+
//| 输入参数                                                          |
//+------------------------------------------------------------------+
input group "== 标记监控参数 =="
input double      InpMonitorDrawdownUSD = 0;   // 浮亏标记阈值(0=自动监控所有平衡品种, >0=浮亏达阈值才触发)
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
#define PW              580       // 面板总宽度
#define PD              12        // 面板内边距
#define PG              8         // 行间距
#define HDR_H           48        // 标题栏高度
#define SG              8         // 卡片间距
#define LH              24        // 文本行高
#define BH              28        // 按钮高度
#define EH              24        // 输入框高度
#define BD_W            2         // 外边框宽度
#define CD_PD           10        // 卡片内边距
#define LABEL_W         85        // 标签区域宽度
#define LW              ((PW - PD*2 - PG)/2)  // 左栏宽度
#define RW              LW                     // 右栏宽度
#define MARK_COMMENT    "BRC_MARK"          // 监控标记标识 (仅为标识, 实际用数组跟踪)

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
   bool     isBalanced;   // 是否平衡 (多空手数相抵)
   bool     isMarked;     // 是否已标记监控
   int      markDirection; // 标记方向: 1=多盈利解锁, -1=空盈利解锁
   double   markBuyLoss;   // 标记时多单亏损
   double   markSellLoss;  // 标记时空单亏损
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

// ── 标记监控状态 ──
bool           g_monitoring     = false;     // 监控中标志
double         g_monitorOrigThresh = 0;      // 标记时保存的阈值
#define MONITOR_DISABLED -999999.0
double         g_monitorDrawdownUSD = -999999.0; // 当前标记阈值(运行时)
double         g_unlockRatio    = 0.50;      // 解锁比例
double         g_minHedgeProfit = 5.0;       // 最低保留盈利
bool           g_progressiveClose = false;    // 渐进平仓模式
double         g_balanceTolerance = 0.01;    // 平衡容差

// ── 标记跟踪 (用全局数组代替修改订单注释) ──
ulong          g_markedTickets[];            // 已标记的持仓ticket列表

// ── 标记监控品种列表 ──
string         g_markedSymbols[];            // 已标记品种列表
int            g_markDirections[];           // 对应标记方向
double         g_markInitialLosses[];        // 标记时的初始亏损(固定基准)

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
      // 保留折叠状态下的展开按钮
      if(nm==g_prefix+"panel_collapsed" || nm==g_prefix+"header_collapsed" ||
         nm==g_prefix+"title_collapsed" || nm==g_prefix+"btn_expand") continue;
      ObjectDelete(0,nm);
   }
}
void DrawToggle()
{
   // 折叠状态下显示展开按钮，在面板标题栏位置
   int x = g_px, y = g_py;
   int w = PW, h = HDR_H;
   ERect(g_prefix+"panel_collapsed", x, y, w, h, C'18,20,28', C'60,68,88');
   ERect(g_prefix+"header_collapsed", x, y, w, h, C'30,34,48', C'60,68,88');
   ELbl(g_prefix+"title_collapsed", "账户仓位多空仓位平衡风控 (已折叠)", x+PD+4, y+8, F(11), C'235,240,250');
   EBtn(g_prefix+"btn_expand", "▼ 展开", x+w-80, y+(h-BH)/2, 70, BH, C'56,132,216', C'235,240,250');
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
//| 判断是否为已标记监控订单 (通过全局数组跟踪)                           |
//| 注意: 此标记仅为监控标识, 不代表任何开仓/锁仓动作                     |
//+------------------------------------------------------------------+
bool IsMarkedOrder()
{
   ulong ticket = PositionGetTicket(POSITION_TICKET);
   for(int i=0; i<ArraySize(g_markedTickets); i++)
   {
      if(g_markedTickets[i] == ticket) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 标记订单为监控状态 (添加到全局数组, 不开新单)                          |
//+------------------------------------------------------------------+
void MarkPositionForMonitor(ulong ticket)
{
   if(!PositionSelectByTicket(ticket)) return;

   // 检查是否已标记
   for(int i=0; i<ArraySize(g_markedTickets); i++)
   {
      if(g_markedTickets[i] == ticket) return;
   }

   // 添加到标记列表
   int idx = ArraySize(g_markedTickets);
   ArrayResize(g_markedTickets, idx+1);
   g_markedTickets[idx] = ticket;
}

//+------------------------------------------------------------------+
//| 取消订单监控标记 (从全局数组移除)                                     |
//+------------------------------------------------------------------+
void UnmarkPositionForMonitor(ulong ticket)
{
   int newSize = 0;
   for(int i=0; i<ArraySize(g_markedTickets); i++)
   {
      if(g_markedTickets[i] != ticket)
      {
         if(newSize != i)
            g_markedTickets[newSize] = g_markedTickets[i];
         newSize++;
      }
   }
   ArrayResize(g_markedTickets, newSize);
}

//+------------------------------------------------------------------+
//| 给品种所有订单添加监控标记 (仅加数组, 不改注释)                        |
//+------------------------------------------------------------------+
void MarkSymbolForMonitor(string symbol, int markDir)
{
   int marked = 0;
   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if(IsMarkedOrder()) continue;

      MarkPositionForMonitor(ticket);
      marked++;
   }
   if(marked > 0)
      Print("[标记监控] ",symbol," 已标记 ",marked," 笔订单, 方向:",(markDir==1?"多盈利解锁":"空盈利解锁"));
}

//+------------------------------------------------------------------+
//| 取消品种所有订单监控标记                                            |
//+------------------------------------------------------------------+
void UnmarkSymbolForMonitor(string symbol)
{
   int unmarked = 0;
   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if(!IsMarkedOrder()) continue;

      UnmarkPositionForMonitor(ticket);
      unmarked++;
   }
   if(unmarked > 0)
      Print("[取消标记] ",symbol," 已取消 ",unmarked," 笔订单标记");
}

//+------------------------------------------------------------------+
//| 清理已平仓订单的标记                                                |
//+------------------------------------------------------------------+
void CleanupMarkedTickets()
{
   int removed = 0;
   int newSize = 0;
   for(int i=0; i<ArraySize(g_markedTickets); i++)
   {
      ulong ticket = g_markedTickets[i];
      bool stillExists = false;
      for(int j=(int)PositionsTotal()-1; j>=0; j--)
      {
         if(PositionGetTicket(j) == ticket) { stillExists = true; break; }
      }
      if(stillExists)
      {
         if(newSize != i) g_markedTickets[newSize] = g_markedTickets[i];
         newSize++;
      }
      else removed++;
   }
   if(removed > 0)
   {
      ArrayResize(g_markedTickets, newSize);
      Print("[清理标记] 移除 ",removed," 笔已平仓订单的标记");
   }
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
//| 全平账户所有持仓 (指定方向)                                         |
//+------------------------------------------------------------------+
void CloseAllPositionsAccount(ENUM_POSITION_TYPE posType)
{
   int count = 0;
   double totalLots = 0;
   string symbols[];
   ArrayResize(symbols, 0);

   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != posType) continue;
      string sym = PositionGetString(POSITION_SYMBOL);
      double vol = PositionGetDouble(POSITION_VOLUME);
      if(vol > 0 && ClosePosition(ticket, vol, InpSlippage))
      {
         count++;
         totalLots += vol;
         // 记录品种
         bool found = false;
         for(int j=0; j<ArraySize(symbols); j++)
            if(symbols[j] == sym) { found = true; break; }
         if(!found)
         {
            int idx = ArraySize(symbols);
            ArrayResize(symbols, idx+1);
            symbols[idx] = sym;
         }
      }
   }

   string symList = "";
   for(int j=0; j<ArraySize(symbols); j++)
   {
      if(j>0) symList += ",";
      symList += symbols[j];
   }

   Print("[账户全平] ", (posType==POSITION_TYPE_BUY?"多单":"空单"), " 共平 ", count, " 笔, ",
         DoubleToString(totalLots,2), "手, 涉及品种: ", symList);
}

//+------------------------------------------------------------------+
//| 全平账户所有持仓 (多空)                                             |
//+------------------------------------------------------------------+
void CloseAllPositionsAccountAll()
{
   int buyCount = 0, sellCount = 0;
   double buyLots = 0, sellLots = 0;
   string symbols[];
   ArrayResize(symbols, 0);

   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      double vol = PositionGetDouble(POSITION_VOLUME);
      if(vol <= 0) continue;

      string sym = PositionGetString(POSITION_SYMBOL);
      bool isBuy = ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);

      if(ClosePosition(ticket, vol, InpSlippage))
      {
         if(isBuy) { buyCount++; buyLots += vol; }
         else { sellCount++; sellLots += vol; }

         bool found = false;
         for(int j=0; j<ArraySize(symbols); j++)
            if(symbols[j] == sym) { found = true; break; }
         if(!found)
         {
            int idx = ArraySize(symbols);
            ArrayResize(symbols, idx+1);
            symbols[idx] = sym;
         }
      }
   }

   string symList = "";
   for(int j=0; j<ArraySize(symbols); j++)
   {
      if(j>0) symList += ",";
      symList += symbols[j];
   }

   Print("[账户一键全平] 多单 ", buyCount, " 笔/", DoubleToString(buyLots,2), "手, ",
         "空单 ", sellCount, " 笔/", DoubleToString(sellLots,2), "手, ",
         "涉及品种: ", symList);
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
   stats.isMarked = false;
   stats.markDirection = 0;
   stats.markBuyLoss = 0;
   stats.markSellLoss = 0;

   for(int i=(int)PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;

      bool marked = IsMarkedOrder();
      double p = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);

      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
      {
         stats.buyLots += PositionGetDouble(POSITION_VOLUME);
         stats.buyPnl += p;
         stats.buyCnt++;
         if(marked && p < 0) stats.markBuyLoss += (-p);
      }
      else
      {
         stats.sellLots += PositionGetDouble(POSITION_VOLUME);
         stats.sellPnl += p;
         stats.sellCnt++;
         if(marked && p < 0) stats.markSellLoss += (-p);
      }

      if(marked)
      {
         stats.isMarked = true;
         string comment = PositionGetString(POSITION_COMMENT);
         if(StringFind(comment, "MARK_多") >= 0) stats.markDirection = 1;
         else if(StringFind(comment, "MARK_空") >= 0) stats.markDirection = -1;
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
//| 获取所有平衡品种列表 (未标记的)                                     |
//+------------------------------------------------------------------+
int GetBalancedSymbols(SymbolStats &balancedStats[])
{
   SymbolStats allStats[];
   int totalCnt = GetAllSymbolsStats(allStats);
   int balancedCnt = 0;
   for(int i=0; i<totalCnt; i++)
   {
      if(allStats[i].isBalanced && !allStats[i].isMarked)
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
//| 检查品种是否在已标记列表中                                          |
//+------------------------------------------------------------------+
bool IsSymbolMarked(string symbol)
{
   for(int i=0; i<ArraySize(g_markedSymbols); i++)
   {
      if(g_markedSymbols[i] == symbol) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 获取标记方向                                                      |
//+------------------------------------------------------------------+
int GetMarkDirection(string symbol)
{
   for(int i=0; i<ArraySize(g_markedSymbols); i++)
   {
      if(g_markedSymbols[i] == symbol && i < ArraySize(g_markDirections))
         return g_markDirections[i];
   }
   return 0;
}

//+------------------------------------------------------------------+
//| 添加品种到标记列表                                                |
//+------------------------------------------------------------------+
void AddSymbolToMarkedList(string symbol, int direction, double initialLoss)
{
   if(IsSymbolMarked(symbol)) return;
   int idx = ArraySize(g_markedSymbols);
   ArrayResize(g_markedSymbols, idx+1);
   ArrayResize(g_markDirections, idx+1);
   ArrayResize(g_markInitialLosses, idx+1);
   g_markedSymbols[idx] = symbol;
   g_markDirections[idx] = direction;
   g_markInitialLosses[idx] = initialLoss;
}

//+------------------------------------------------------------------+
//| 从标记列表移除品种                                                |
//+------------------------------------------------------------------+
void RemoveSymbolFromMarkedList(string symbol)
{
   int newSize = 0;
   for(int i=0; i<ArraySize(g_markedSymbols); i++)
   {
      if(g_markedSymbols[i] != symbol)
      {
         if(newSize != i)
         {
            g_markedSymbols[newSize] = g_markedSymbols[i];
            if(i < ArraySize(g_markDirections))
               g_markDirections[newSize] = g_markDirections[i];
            if(i < ArraySize(g_markInitialLosses))
               g_markInitialLosses[newSize] = g_markInitialLosses[i];
         }
         newSize++;
      }
   }
   ArrayResize(g_markedSymbols, newSize);
   ArrayResize(g_markDirections, newSize);
   ArrayResize(g_markInitialLosses, newSize);
}

//+------------------------------------------------------------------+
//| 获取标记时的初始亏损                                              |
//+------------------------------------------------------------------+
double GetMarkInitialLoss(string symbol)
{
   for(int i=0; i<ArraySize(g_markedSymbols); i++)
   {
      if(g_markedSymbols[i] == symbol && i < ArraySize(g_markInitialLosses))
         return g_markInitialLosses[i];
   }
   return 0;
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
      if(!IsMarkedOrder()) continue;

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
bool ProgressiveCloseLossOrders(string symbol, int markDirection)
{
   if(!g_progressiveClose)
   {
      g_progressiveClose = true;
   }

   double directionProfit = GetDirectionProfit(symbol, markDirection);
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

   // 收集所有已标记的亏损单
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      if(!IsMarkedOrder()) continue;

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
   double finalDirectionProfit = GetDirectionProfit(symbol, markDirection);
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
      if(!IsMarkedOrder()) continue;
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
//| 重置标记监控状态                                                  |
//+------------------------------------------------------------------+
void ResetMonitorState()
{
   g_monitoring = false;
   g_monitorOrigThresh = 0;
   g_progressiveClose = false;
   ArrayResize(g_markedSymbols, 0);
   ArrayResize(g_markDirections, 0);
   ArrayResize(g_markInitialLosses, 0);
   ArrayResize(g_markedTickets, 0);  // 清理所有标记

   // 根据当前模式设置阈值
   if(InpMonitorDrawdownUSD == 0)
   {
      g_monitorDrawdownUSD = 0;  // 自动模式保持为0
      Print("[监控解锁] 自动模式, 继续监测新平衡品种");
      ObjectSetString(0, g_prefix+"e1_threshold", OBJPROP_TEXT, "自动");
   }
   else
   {
      g_monitorDrawdownUSD = MONITOR_DISABLED;
      Print("[监控解锁] 阈值模式, 需手动设置新阈值");
      ObjectSetString(0, g_prefix+"e1_threshold", OBJPROP_TEXT, "禁用");
   }
   RefreshPanel(true);
}

//+------------------------------------------------------------------+
//| 核心: 标记监控流程                                               |
//|   1. 已标记 → 检查方向盈利达50% → 渐进平仓 → 解锁                |
//|   2. 未标记 → 检测平衡品种 → 标记监控                            |
//|      - 阈值>0: 账户浮亏达阈值才触发                              |
//|      - 阈值=0: 自动监控所有平衡品种                              |
//|   ⚠️ 本函数仅做标记和平仓, 绝不开仓                               |
//+------------------------------------------------------------------+
void CheckMonitor()
{
   double totalPnl = GetTotalAccountPnl();

   // ── 已标记监控中: 检查方向盈利达50% ──
   if(g_monitoring)
   {
      bool allSymbolsUnlocked = true;

      for(int s=0; s<ArraySize(g_markedSymbols); s++)
      {
         string sym = g_markedSymbols[s];
         int markDir = g_markDirections[s];

         // 检查是否还有标记订单
         bool hasMarked = false;
         for(int i=(int)PositionsTotal()-1; i>=0; i--)
         {
            ulong t = PositionGetTicket(i);
            if(t==0) continue;
            if(!PositionSelectByTicket(t)) continue;
            if(PositionGetString(POSITION_SYMBOL) != sym) continue;
            if(IsMarkedOrder()) { hasMarked = true; break; }
         }

         if(!hasMarked)
         {
            Print("[监控检查] ",sym," 标记订单已清空");
            RemoveSymbolFromMarkedList(sym);
            continue;
         }

         // 监控多空方向盈利
         double buyProfit = GetDirectionProfit(sym, 1);
         double sellProfit = GetDirectionProfit(sym, -1);

         // 使用标记时保存的初始亏损作为固定基准
         double initialLoss = GetMarkInitialLoss(sym);
         double targetProfit = initialLoss * g_unlockRatio;

         // 如果没有保存初始亏损，用当前浮亏作为基准
         if(targetProfit <= 0)
         {
            SymbolStats curStats;
            GetSymbolStats(sym, curStats);
            if(markDir == 1 && curStats.buyPnl < 0)
               targetProfit = (-curStats.buyPnl) * g_unlockRatio;
            else if(markDir == -1 && curStats.sellPnl < 0)
               targetProfit = (-curStats.sellPnl) * g_unlockRatio;
         }

         Print("[监控检查] ",sym," 多盈利:$",DoubleToString(buyProfit,2),
               " 空盈利:$",DoubleToString(sellProfit,2),
               " 50%目标:$",DoubleToString(targetProfit,2));

         // 判断哪个方向先盈利达50%
         int triggerDir = 0;
         if(markDir == 1 && buyProfit >= targetProfit && targetProfit > 0) triggerDir = 1;
         else if(markDir == -1 && sellProfit >= targetProfit && targetProfit > 0) triggerDir = -1;

         if(triggerDir == 0)
         {
            allSymbolsUnlocked = false;
            continue;
         }

         // 触发渐进平仓 (仅平亏损单, 不开新仓)
         if(!g_progressiveClose)
         {
            Print("════════════════════════════════");
            Print("[渐进平仓] ",sym," 方向盈利达标 → 启动渐进平仓");
         }

         if(ProgressiveCloseLossOrders(sym, triggerDir))
         {
            Print("[解锁] ",sym," 渐进平仓完成 → 取消监控标记");
            UnmarkSymbolForMonitor(sym);
            RemoveSymbolFromMarkedList(sym);
         }
         else
         {
            allSymbolsUnlocked = false;
         }
      }

      if(allSymbolsUnlocked || ArraySize(g_markedSymbols) == 0)
      {
         ResetMonitorState();
      }
      return;
   }

   // ── 未标记: 检测是否需要标记监控 ──
   // 阈值=0时自动监控所有平衡品种; 阈值>0时需浮亏达标
   bool shouldMonitor = false;
   if(g_monitorDrawdownUSD == 0) shouldMonitor = true;  // 自动模式
   else if(g_monitorDrawdownUSD > 0 && totalPnl <= -g_monitorDrawdownUSD) shouldMonitor = true;

   if(!shouldMonitor) return;

   // 获取所有平衡品种 (多空手数相抵, 净头寸≈0)
   SymbolStats balancedStats[];
   int balancedCnt = GetBalancedSymbols(balancedStats);

   if(balancedCnt == 0)
   {
      if(g_monitorDrawdownUSD == 0)
         Print("[监控检测] 无平衡品种, 等待...");
      else
         Print("[监控检测] 账户浮亏达阈值但无平衡品种, 不标记监控");
      return;
   }

   g_monitorOrigThresh = g_monitorDrawdownUSD;
   g_monitoring = true;
   g_progressiveClose = false;

   Print("════════════════════════════════");
   if(g_monitorDrawdownUSD == 0)
      Print("[自动监控] 发现 ",balancedCnt," 个平衡品种, 开始标记监控");
   else
      Print("[标记监控] 账户总浮亏:$",DoubleToString(totalPnl,2)," 达阈值:$",DoubleToString(g_monitorDrawdownUSD,2));

   // 对每个平衡品种添加监控标记 (仅加注释, 不开新单)
   for(int i=0; i<balancedCnt; i++)
   {
      string sym = balancedStats[i].symbol;
      if(IsSymbolMarked(sym)) continue;

      double buyLoss = 0, sellLoss = 0;
      if(balancedStats[i].buyPnl < 0) buyLoss = -balancedStats[i].buyPnl;
      if(balancedStats[i].sellPnl < 0) sellLoss = -balancedStats[i].sellPnl;

      Print("[标记监控] ",sym," 多:",DoubleToString(balancedStats[i].buyLots,2),"手 空:",
            DoubleToString(balancedStats[i].sellLots,2),"手 净:",
            DoubleToString(balancedStats[i].netLots,4));
      Print("[标记监控] ",sym," 多浮亏:$",DoubleToString(buyLoss,2)," 空浮亏:$",DoubleToString(sellLoss,2));

      // 决定解锁方向: 亏损大的方向作为盈利解锁目标
      int markDir = 1;
      double initialLoss = buyLoss;
      if(sellLoss > buyLoss) { markDir = -1; initialLoss = sellLoss; }

      // 仅标记, 不开新单!
      MarkSymbolForMonitor(sym, markDir);
      AddSymbolToMarkedList(sym, markDir, initialLoss);
   }

   // 仅在阈值模式下调为禁用; 自动模式保持为0继续检测新平衡品种
   if(g_monitorDrawdownUSD > 0)
   {
      g_monitorDrawdownUSD = MONITOR_DISABLED;
      Print("[标记监控] 阈值已设为禁用值, 监控期间不再触发");
      ObjectSetString(0, g_prefix+"e1_threshold", OBJPROP_TEXT, "禁用");
   }
   else if(g_monitorDrawdownUSD == 0)
   {
      ObjectSetString(0, g_prefix+"e1_threshold", OBJPROP_TEXT, "自动");
   }
   Print("[标记监控] 解锁方式: 方向盈利达"+DoubleToString(g_unlockRatio*100,0)+"% → 渐进平仓 → 解锁");
   Print("════════════════════════════════");
   RefreshPanel(true);
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
      // 输入0或"自动" → 自动监控模式
      if(v == 0 || t == "自动") g_monitorDrawdownUSD = 0;
      else if(v > 0) g_monitorDrawdownUSD = v;
      else g_monitorDrawdownUSD = MONITOR_DISABLED;
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
   GlobalVariableSet(g_prefix+"thresh", g_monitorDrawdownUSD);
   GlobalVariableSet(g_prefix+"ratio", g_unlockRatio);
   GlobalVariableSet(g_prefix+"minHedge", g_minHedgeProfit);
   GlobalVariableSet(g_prefix+"tolerance", g_balanceTolerance);
}

void LoadParamsFromGV()
{
   if(GlobalVariableCheck(g_prefix+"thresh")) g_monitorDrawdownUSD = GlobalVariableGet(g_prefix+"thresh");
   if(GlobalVariableCheck(g_prefix+"ratio")) g_unlockRatio = GlobalVariableGet(g_prefix+"ratio");
   if(GlobalVariableCheck(g_prefix+"minHedge")) g_minHedgeProfit = GlobalVariableGet(g_prefix+"minHedge");
   if(GlobalVariableCheck(g_prefix+"tolerance")) g_balanceTolerance = GlobalVariableGet(g_prefix+"tolerance");
   if(g_monitorDrawdownUSD == 0) g_monitorDrawdownUSD = MONITOR_DISABLED;
}

//+------------------------------------------------------------------+
//| 面板绘制                                                          |
//+------------------------------------------------------------------+
void DrawPanel()
{
   // 展开时清理折叠状态的控件
   if(g_panel_open)
   {
      ObjectDelete(0, g_prefix+"panel_collapsed");
      ObjectDelete(0, g_prefix+"header_collapsed");
      ObjectDelete(0, g_prefix+"title_collapsed");
      ObjectDelete(0, g_prefix+"btn_expand");
   }

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

   // 监控汇总
   int totalBalanced = 0;
   int totalMarkedSymbols = ArraySize(g_markedSymbols);
   double totalBuyProfit = 0;
   double totalSellProfit = 0;
   for(int i=0; i<totalMarkedSymbols; i++)
   {
      totalBuyProfit += GetDirectionProfit(g_markedSymbols[i], 1);
      totalSellProfit += GetDirectionProfit(g_markedSymbols[i], -1);
   }
   for(int i=0; i<totalSymbols; i++)
   {
      if(allStats[i].isBalanced) totalBalanced++;
   }

   // 配色
   color BG_PANEL = C'18,20,28', BD_PANEL = C'60,68,88', BG_HDR = C'30,34,48';
   color BG_CARD = C'24,27,38', cMute = C'130,140,165';

   int X = g_px, LX = X+PD, RX = LX+LW+PG;

   // 预计算卡片高度
   int preStatusH = CD_PD*2 + 22 + 6*LH;
   int preParamH = CD_PD*2 + 22 + 4*LH;
   int preActH = preStatusH + SG + preParamH;
   int preMonH = CD_PD*2 + 22 + 24 + 5*LH + BH + CD_PD;

   // 外框 + 标题栏
   int totalH = HDR_H + SG + preStatusH + SG + preParamH + SG + preActH + SG + preMonH + CD_PD;
   if(totalH < 600) totalH = 600;
   ERect(g_prefix+"panel", X, g_py, PW, totalH, BG_PANEL, BD_PANEL);
   ERect(g_prefix+"header", X, g_py, PW, HDR_H, BG_HDR, BD_PANEL);
   ELbl(g_prefix+"title", "账户仓位多空仓位平衡风控", LX+4, g_py+8, F(14), C'235,240,250');

   // 折叠按钮 (右上角)
   int btnX = X + PW - PD - 30;
   int btnY = g_py + (HDR_H - BH) / 2;
   EBtn(g_prefix+"btn_collapse", "▼", btnX, btnY, 26, BH, C'56,132,216', C'235,240,250');

   // 账户盈亏副标题 - 明确显示仅监控
   color accPnlClr = (totalAccountPnl>=0) ? InpColorNormal : InpColorDanger;
   string accInfo = "账户盈亏:$" + DoubleToString(totalAccountPnl,2) +
                    " | 品种:" + IntegerToString(totalSymbols) +
                    " | 容差:" + DoubleToString(g_balanceTolerance,2) +
                    " | 仅监控";
   ELbl(g_prefix+"sub", accInfo, LX+4, g_py+30, F(9), accPnlClr);

   int cy = g_py + HDR_H + SG;
   int ry = 0;
   int ey = 0;
   int by = 0;
   int rx = 0;

   // ── 卡片1: 账户状态卡 ──
   int statusRows = 6;
   int statusH = CD_PD*2 + 22 + statusRows*LH;
   int labelStartX = LX+CD_PD;
   int valueStartX = LX+CD_PD+LABEL_W;
   ERect(g_prefix+"c1",LX,cy,LW,statusH,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c1_title","账户状态",LX+CD_PD,cy+CD_PD,F(11),C'235,240,250');
   ry = cy + CD_PD + 22;

   // 账户总盈亏
   ELbl(g_prefix+"r1_lbl","账户盈亏", labelStartX, ry+4, F(10), cMute);
   color accClr = (totalAccountPnl>=0) ? InpColorNormal : InpColorDanger;
   ELbl(g_prefix+"r1_val", "$"+DoubleToString(totalAccountPnl,2), valueStartX, ry+4, F(10), accClr);
   ry += LH;

   // 多单盈利
   ELbl(g_prefix+"r2_lbl","多单盈亏", labelStartX, ry+4, F(10), cMute);
   color buyProfitClr = (totalBuyProfit>=0) ? InpColorNormal : InpColorDanger;
   ELbl(g_prefix+"r2_val", "$"+DoubleToString(totalBuyProfit,2), valueStartX, ry+4, F(10), buyProfitClr);
   ry += LH;

   // 空单盈利
   ELbl(g_prefix+"r3_lbl","空单盈亏", labelStartX, ry+4, F(10), cMute);
   color sellProfitClr = (totalSellProfit>=0) ? InpColorNormal : InpColorDanger;
   ELbl(g_prefix+"r3_val", "$"+DoubleToString(totalSellProfit,2), valueStartX, ry+4, F(10), sellProfitClr);
   ry += LH;

   // 标记监控状态
   string markStatus; color markClr;
   if(g_progressiveClose){ markStatus = "渐进平仓中"; markClr = InpColorWarning; }
   else if(g_monitoring){ markStatus = "监控中("+IntegerToString(totalMarkedSymbols)+"品种)"; markClr = InpColorDanger; }
   else { markStatus = "正常监测"; markClr = InpColorNormal; }
   ELbl(g_prefix+"r4_lbl","监控状态", labelStartX, ry+4, F(10), cMute);
   ELbl(g_prefix+"r4_val", markStatus, valueStartX, ry+4, F(10), markClr);
   ry += LH;

   // 平衡品种数
   ELbl(g_prefix+"r5_lbl","平衡品种", labelStartX, ry+4, F(10), cMute);
   string balTxt = IntegerToString(totalBalanced)+"/"+IntegerToString(totalSymbols)+" 品种";
   color balClr = (totalBalanced > 0) ? InpColorWarning : cMute;
   ELbl(g_prefix+"r5_val", balTxt, valueStartX, ry+4, F(10), balClr);
   ry += LH;

   // 进度显示
   string progTxt = "等待标记";
   color progClr = cMute;
   if(g_monitoring && totalMarkedSymbols > 0)
   {
      double targetP = g_monitorOrigThresh * g_unlockRatio;
      int bestDir = (totalBuyProfit >= totalSellProfit) ? 1 : -1;
      double bestProfit = (bestDir==1) ? totalBuyProfit : totalSellProfit;
      progTxt = (bestDir==1?"多":"空")+"盈利:$"+DoubleToString(bestProfit,2)+" 50%:$"+DoubleToString(targetP,0);
      progClr = (bestProfit>=targetP)?InpColorNormal:InpColorWarning;
   }
   ELbl(g_prefix+"r6_lbl","解锁进度", labelStartX, ry+4, F(10), cMute);
   ELbl(g_prefix+"r6_val", progTxt, valueStartX, ry+4, F(10), progClr);

   // ── 卡片2: 监控参数 ──
   cy += statusH + SG;
   int paramRows = 4;
   int paramH = CD_PD*2 + 22 + paramRows*LH;
   int paramLabelX = LX+CD_PD;
   int paramInputX = LX+CD_PD+LABEL_W;
   ERect(g_prefix+"c2",LX,cy,LW,paramH,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c2_title","监控参数",LX+CD_PD,cy+CD_PD,F(11),C'235,240,250');
   ey = cy + CD_PD + 22;

   // 浮亏标记阈值
   string threshVal;
   if(g_monitorDrawdownUSD == 0) threshVal = "自动";
   else if(g_monitorDrawdownUSD < 0) threshVal = "禁用";
   else threshVal = DoubleToString(g_monitorDrawdownUSD,0);
   ELbl(g_prefix+"e1_lbl","浮亏标记$", paramLabelX, ey+4, F(10), cMute);
   EEdt(g_prefix+"e1_threshold", threshVal, paramInputX, ey+2, 80, EH);
   ey += LH;

   // 解锁比例
   ELbl(g_prefix+"e2_lbl","解锁比例%", paramLabelX, ey+4, F(10), cMute);
   EEdt(g_prefix+"e2_ratio", DoubleToString(g_unlockRatio*100,0), paramInputX, ey+2, 80, EH);
   ey += LH;

   // 最低保留
   ELbl(g_prefix+"e3_lbl","最低保留$", paramLabelX, ey+4, F(10), cMute);
   EEdt(g_prefix+"e3_minHedge", DoubleToString(g_minHedgeProfit,0), paramInputX, ey+2, 80, EH);
   ey += LH;

   // 平衡容差
   ELbl(g_prefix+"e4_lbl","平衡容差", paramLabelX, ey+4, F(10), cMute);
   EEdt(g_prefix+"e4_tolerance", DoubleToString(g_balanceTolerance,2), paramInputX, ey+2, 80, EH);

   // ── 右栏: 当前品种 + 操作卡 ──
   rx = RX;
   cy = g_py + HDR_H + SG;

   int actH = statusH + SG + paramH;
   ERect(g_prefix+"c_act",rx,cy,RW,actH,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c_act_title","当前品种:"+symbol,rx+CD_PD,cy+CD_PD,F(11),C'235,240,250');
   by = cy + CD_PD + 22;

   // 当前品种统计
   string curBuyTxt = "多:"+DoubleToString(curStats.buyLots,2)+"手 "+IntegerToString(curStats.buyCnt)+"单";
   string curSellTxt = "空:"+DoubleToString(curStats.sellLots,2)+"手 "+IntegerToString(curStats.sellCnt)+"单";
   ELbl(g_prefix+"act_buy", curBuyTxt, rx+CD_PD, by+4, F(10), InpColorInfo);
   by += LH;
   ELbl(g_prefix+"act_sell", curSellTxt, rx+CD_PD, by+4, F(10), InpColorDanger);
   by += LH;

   // 净头寸
   color netClr = (MathAbs(curStats.netLots) <= g_balanceTolerance) ? InpColorWarning :
                   (curStats.netLots>0?InpColorInfo:InpColorDanger);
   string netTxt = "净头寸:"+DoubleToString(curStats.netLots,4)+
                   " ["+(curStats.isBalanced?"平衡":"不平衡")+"]";
   ELbl(g_prefix+"act_net", netTxt, rx+CD_PD, by+4, F(10), netClr);
   by += LH;

   // 当前品种标记状态
   if(curStats.isMarked)
   {
      int markDir = GetMarkDirection(symbol);
      double buyP = GetDirectionProfit(symbol, 1);
      double sellP = GetDirectionProfit(symbol, -1);
      string hTxt = "已标记-"+(markDir==1?"多盈利":"空盈利")+"解锁";
      color hClr = InpColorWarning;
      ELbl(g_prefix+"act_hedge", hTxt, rx+CD_PD, by+4, F(10), hClr);
      by += LH;
      string hDetail = "多盈利:$"+DoubleToString(buyP,2)+" 空盈利:$"+DoubleToString(sellP,2);
      ELbl(g_prefix+"act_hedge2", hDetail, rx+CD_PD, by+4, F(9), cMute);
      by += LH;
   }

   // 操作按钮
   int bw = RW - CD_PD*2;
   if(g_monitoring)
   {
      EBtn(g_prefix+"btn_manualUnlock","手动解锁(恢复交易)", rx+CD_PD, by, bw, BH, C'50,140,80', C'235,240,250');
      by += BH + PG;
   }
   else if(ObjectFind(0,g_prefix+"btn_manualUnlock")>=0)
   {
      ObjectDelete(0, g_prefix+"btn_manualUnlock");
   }

   // 平多 / 平空 / 全平 (账户级别)
   int bw3 = (RW - CD_PD*2 - PG*2) / 3;
   EBtn(g_prefix+"btn_closeBuy","全平多(账户)", rx+CD_PD, by, bw3, BH, InpColorInfo, C'235,240,250');
   EBtn(g_prefix+"btn_closeSell","全平空(账户)", rx+CD_PD+bw3+PG, by, bw3, BH, InpColorDanger, C'235,240,250');
   EBtn(g_prefix+"btn_closeAll","一键全平(账户)", rx+CD_PD+bw3*2+PG*2, by, bw3, BH, C'180,50,50', C'235,240,250');
   by += BH + PG;

   // 提示文字
   string hintTxt;
   color hintClr;
   if(g_monitoring)
   {
      hintTxt = "标记监控中("+IntegerToString(totalMarkedSymbols)+"品种)";
      hintClr = InpColorWarning;
   }
   else if(totalAccountPnl < -g_monitorDrawdownUSD && g_monitorDrawdownUSD > 0)
   {
      hintTxt = "账户浮亏达阈值";
      hintClr = InpColorDanger;
   }
   else if(totalBalanced > 0 && g_monitorDrawdownUSD > 0)
   {
      hintTxt = "有"+IntegerToString(totalBalanced)+"个平衡品种";
      hintClr = InpColorWarning;
   }
   else
   {
      hintTxt = "正常监测中";
      hintClr = cMute;
   }
   ELbl(g_prefix+"act_hint", hintTxt, rx+CD_PD, by+4, F(9), hintClr);

   // ── 监控预警卡片 (全品种) ──
   int monY = cy + actH + SG;
   int monRows = 5;
   int monH = CD_PD*2 + 22 + 24 + monRows*LH + BH + CD_PD;
   ERect(g_prefix+"c_mon", X+PD, monY, PW-PD*2, monH, BG_CARD, BD_PANEL);
   ELbl(g_prefix+"c_mon_title","监控预警-全品种", X+PD+CD_PD, monY+CD_PD, F(11), C'235,240,250');

   // 标题行统计
   int balancedCnt2=0, unbalancedCnt2=0, warningCnt=0;
   for(int i=0; i<totalSymbols; i++)
   {
      if(allStats[i].isBalanced) balancedCnt2++;
      else unbalancedCnt2++;
      if(allStats[i].totalPnl < 0) warningCnt++;
   }
   string monTitle = "共 "+IntegerToString(totalSymbols)+" 品种 | 平衡:"+IntegerToString(balancedCnt2)+" 不平衡:"+IntegerToString(unbalancedCnt2);
   color monTitleClr = (warningCnt > 0) ? InpColorWarning : InpColorNormal;
   ELbl(g_prefix+"c_mon_sub", monTitle, X+PW-PD-CD_PD-200, monY+CD_PD, F(10), monTitleClr);

   // 表头 - 固定列位置
   int hdrY = monY + CD_PD + 22;
   int c1 = X+PD+CD_PD;
   int c2 = c1+70;
   int c3 = c2+70;
   int c4 = c3+80;
   int c5 = c4+60;
   int c6 = c5+50;
   ELbl(g_prefix+"mon_h1","品种", c1, hdrY+4, F(9), cMute);
   ELbl(g_prefix+"mon_h2","盈亏$", c2, hdrY+4, F(9), cMute);
   ELbl(g_prefix+"mon_h3","多单-单/手", c3, hdrY+4, F(9), cMute);
   ELbl(g_prefix+"mon_h4","空单-单/手", c4, hdrY+4, F(9), cMute);
   ELbl(g_prefix+"mon_h5","标记", c5, hdrY+4, F(9), cMute);
   ELbl(g_prefix+"mon_h6","状态", c6, hdrY+4, F(9), cMute);

   // 数据行
   int rowStartY = hdrY + 24;
   int maxShow = MathMin(monRows, totalSymbols);
   int startIdx = MathMax(0, MathMin(g_monitorScroll, totalSymbols - maxShow));
   g_monitorScroll = startIdx;

   // 清理多余的旧行标签
   for(int clr = maxShow; clr < monRows; clr++)
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
      int rowY = rowStartY + r * LH;

      // 品种名
      string symName = allStats[idx].symbol;
      if(StringLen(symName) > 7) symName = StringSubstr(symName, 0, 7);
      ELbl(g_prefix+"mon_s"+IntegerToString(r), symName, c1, rowY+4, F(9), C'200,210,230');

      // 盈亏
      double pnl = allStats[idx].totalPnl;
      color pnlClr = (pnl>=0) ? InpColorNormal : InpColorDanger;
      string pnlTxt = (pnl>=0 ? "+" : "") + DoubleToString(pnl,2);
      ELbl(g_prefix+"mon_p"+IntegerToString(r), pnlTxt, c2, rowY+4, F(9), pnlClr);

      // 多单
      string buyTxt = IntegerToString(allStats[idx].buyCnt)+"/"+DoubleToString(allStats[idx].buyLots,2);
      color buyClr = (allStats[idx].buyLots > 0) ? InpColorInfo : cMute;
      ELbl(g_prefix+"mon_b"+IntegerToString(r), buyTxt, c3, rowY+4, F(9), buyClr);

      // 空单
      string sellTxt = IntegerToString(allStats[idx].sellCnt)+"/"+DoubleToString(allStats[idx].sellLots,2);
      color sellClr = (allStats[idx].sellLots > 0) ? InpColorDanger : cMute;
      ELbl(g_prefix+"mon_sell"+IntegerToString(r), sellTxt, c4, rowY+4, F(9), sellClr);

      // 标记
      string hgTxt = allStats[idx].isMarked ? (allStats[idx].markDirection==1?"多":"空") : "-";
      color hgClr = allStats[idx].isMarked ? InpColorWarning : cMute;
      ELbl(g_prefix+"mon_hg"+IntegerToString(r), hgTxt, c5, rowY+4, F(9), hgClr);

      // 状态
      string statusTxt; color statusClr;
      if(allStats[idx].buyCnt == 0 && allStats[idx].sellCnt == 0)
      { statusTxt = "空仓"; statusClr = cMute; }
      else if(allStats[idx].isBalanced)
      { statusTxt = "平衡"; statusClr = InpColorWarning; }
      else
      { statusTxt = "不平衡"; statusClr = InpColorDanger; }
      ELbl(g_prefix+"mon_st"+IntegerToString(r), statusTxt, c6, rowY+4, F(9), statusClr);
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
      int pageStart = startIdx+1;
      int pageEnd = MathMin(startIdx+maxShow,totalSymbols);
      ELbl(g_prefix+"mon_page", IntegerToString(pageStart)+"-"+IntegerToString(pageEnd)+"/"+IntegerToString(totalSymbols), rightX-70, scrollY+4, F(9), cMute);
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
   int prefixLen = StringLen(g_prefix);
   int sparamLen = StringLen(sparam);
   string k = StringSubstr(sparam, prefixLen, sparamLen - prefixLen);
   string symbol = _Symbol;

   // 折叠/展开 (点击标题栏右上角按钮)
   if(k == "btn_collapse")
   {
      ResetPanelButtonState(sparam);
      g_panel_open = false;
      g_panel_dragging = false;
      SetPanelDragHighlight(false);
      RefreshPanel(true);
      return;
   }

   // 展开 (折叠状态下点击底部按钮)
   if(k == "btn_expand")
   {
      ResetPanelButtonState(sparam);
      g_panel_open = true;
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
                 + "• 监控标记保留\n"
                 + "• 方向盈利达50%时自动渐进平仓";
      if(!ShowConfirmDialog(msg)) return;

      // 取消所有监控标记
      for(int i=0; i<ArraySize(g_markedSymbols); i++)
         UnmarkSymbolForMonitor(g_markedSymbols[i]);
      ResetMonitorState();
      RefreshPanel(true);
      return;
   }

   // 全平账户所有多单
   if(k == "btn_closeBuy")
   {
      ResetPanelButtonState(sparam);
      SymbolStats allStats[];
      int totalSym = GetAllSymbolsStats(allStats);
      int totalBuyCnt = 0; double totalBuyLots = 0;
      for(int i=0; i<totalSym; i++)
      {
         totalBuyCnt += allStats[i].buyCnt;
         totalBuyLots += allStats[i].buyLots;
      }
      if(!ShowConfirmDialog("确定全平账户所有多单?\n"+DoubleToString(totalBuyLots,2)+"手 "+IntegerToString(totalBuyCnt)+"单")) return;
      CloseAllPositionsAccount(POSITION_TYPE_BUY);
      RefreshPanel(true); return;
   }

   // 全平账户所有空单
   if(k == "btn_closeSell")
   {
      ResetPanelButtonState(sparam);
      SymbolStats allStats[];
      int totalSym = GetAllSymbolsStats(allStats);
      int totalSellCnt = 0; double totalSellLots = 0;
      for(int i=0; i<totalSym; i++)
      {
         totalSellCnt += allStats[i].sellCnt;
         totalSellLots += allStats[i].sellLots;
      }
      if(!ShowConfirmDialog("确定全平账户所有空单?\n"+DoubleToString(totalSellLots,2)+"手 "+IntegerToString(totalSellCnt)+"单")) return;
      CloseAllPositionsAccount(POSITION_TYPE_SELL);
      RefreshPanel(true); return;
   }

   // 一键全平账户所有持仓
   if(k == "btn_closeAll")
   {
      ResetPanelButtonState(sparam);
      SymbolStats allStats[];
      int totalSym = GetAllSymbolsStats(allStats);
      int totalCnt = 0; double totalLots = 0;
      for(int i=0; i<totalSym; i++)
      {
         totalCnt += allStats[i].buyCnt + allStats[i].sellCnt;
         totalLots += allStats[i].buyLots + allStats[i].sellLots;
      }
      if(!ShowConfirmDialog("确定一键全平账户所有持仓?\n"+DoubleToString(totalLots,2)+"手 "+IntegerToString(totalCnt)+"单")) return;
      CloseAllPositionsAccountAll();
      RefreshPanel(true); return;
   }
}

//+------------------------------------------------------------------+
//| EA 主函数                                                          |
//+------------------------------------------------------------------+
int OnInit()
{
   g_monitorDrawdownUSD = InpMonitorDrawdownUSD;
   g_unlockRatio = InpUnlockRatio;
   g_minHedgeProfit = InpMinHedgeProfit;
   g_balanceTolerance = InpBalanceTolerance;
   g_px = InpPanelX; g_py = InpPanelY;
   LoadParamsFromGV();
   EventSetTimer(1);
   DrawPanel();
   Print("═══════════════════════════════════════════════════");
   Print("[账户仓位多空仓位平衡风控] v4.01 启动 (仅监控, 不开仓)");
   if(g_monitorDrawdownUSD == 0)
      Print("  监控模式: 自动 (监控所有平衡品种)");
   else if(g_monitorDrawdownUSD > 0)
      Print("  监控模式: 阈值模式 (浮亏达$", DoubleToString(g_monitorDrawdownUSD,1), "触发)");
   else
      Print("  监控模式: 禁用");
   Print("  解锁比例: ", DoubleToString(g_unlockRatio*100,0), "%");
   Print("  最低保留盈利: $", DoubleToString(g_minHedgeProfit,1));
   Print("  平衡容差: ", DoubleToString(g_balanceTolerance,2));
   Print("  标记注释: ", MARK_COMMENT);
   Print("  ⚠️ 本EA仅做标记/平仓, 绝不开仓/加仓!");
   Print("═══════════════════════════════════════════════════");
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   DelContent();
   ObjectDelete(0, g_prefix+"panel_collapsed");
   ObjectDelete(0, g_prefix+"header_collapsed");
   ObjectDelete(0, g_prefix+"title_collapsed");
   ObjectDelete(0, g_prefix+"btn_expand");
   EventKillTimer();
   SaveParamsToGV();
   Print("[账户仓位多空仓位平衡风控] 已停止");
}

void OnTick()
{
   CleanupMarkedTickets();  // 清理已平仓订单的标记
   CheckMonitor();
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

   // ── 图表点击: 开始拖拽 / 处理点击 ──
   if(id == CHARTEVENT_CLICK)
   {
      if(g_panel_dragging)
      {
         // 拖拽中再次点击 → 结束拖拽
         g_panel_dragging = false;
         SetPanelDragHighlight(false);
         ChartRedraw(0);
      }
      else if(IsClickOnPanelDragArea(click_x,click_y))
      {
         // 点击在面板标题栏 → 开始拖拽
         g_panel_dragging = true;
         g_panel_drag_ox = click_x - g_px;
         g_panel_drag_oy = click_y - g_py;
         SetPanelDragHighlight(true);
         ChartRedraw(0);
      }
      return;
   }

   // ── 鼠标移动: 拖拽中更新位置 ──
   if(id == CHARTEVENT_MOUSE_MOVE && g_panel_dragging)
   {
      int new_x = click_x - g_panel_drag_ox;
      int new_y = click_y - g_panel_drag_oy;
      ClampPanelPosition(new_x, new_y);
      MovePanelTo(new_x, new_y);
      return;
   }

   // ── 对象点击: 处理按钮 ──
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam != "") HandlePanelButtonClick(sparam);
   }
}
//+------------------------------------------------------------------+