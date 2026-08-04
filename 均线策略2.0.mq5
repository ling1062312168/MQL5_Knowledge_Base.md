//+------------------------------------------------------------------+
//|                                               均线策略网格系统.mq5  |
//|                                    Copyright 2025, 打工仔         |
//|                                    Version 2.53 — D1 EMA14入场 + 多周期网格                       |
//+------------------------------------------------------------------+
#property copyright "打工仔"
#property version   "2.53"
#property description "均线策略网格系统 - D1 EMA14入场 + 跑马灯止盈 + 多周期网格"
#property description "入场: 天图 close > EMA14 开多 / close < EMA14 开空"
#property description "逆势加仓: 7周期(H4/H1/30M/15M/5M/3M/M1) MA10方向 → 动态间距(浮动)"
#property description "顺势加仓: 7周期MA10全部同向才允许, 固定间距"
#property description "跑马灯止盈: 篮子加权均价±动态TP(层多收紧, 逆向放宽)"
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
//+------------------------------------------------------------------+
//| 面板布局常量                                                       |
//+------------------------------------------------------------------+
#define PW              800       // 面板总宽度(含外边框)
#define PD              12        // 面板内边距(内容距离外边框)
#define PG              6         // 行间距 gap
#define HDR_H           52        // 标题栏高度
#define SG              8         // 卡片间距 section_gap
#define LH              22        // 文本行高(含间距)
#define BH              28        // 按钮高度
#define EH              24        // 输入框高度
#define BD_W            2         // 外边框宽度
#define CD_PD           10        // 卡片内边距
// 左栏宽度
#define LW              ((PW - PD*2 - PG)/2)
// 右栏宽度
#define RW              ((PW - PD*2 - PG)/2)
#define HALF_W          ((LW - PG)/2)
#define THIRD_W         ((LW - PG*2)/3)
// 参数卡标签宽度(统一对齐)
#define LBL_W           56        // 左栏标签列宽
#define EDT_W           56        // 左栏输入框宽
// 左栏卡片高度
#define CH_STATUS       274       // 状态卡(10行数据)
#define CH_MANUAL       120       // 手动交易卡(2行输入+1行按钮)
#define CH_GRID         253       // 网格参数卡(5行输入+填充对齐)
// 左栏总高
#define LEFT_COL_H      (CH_STATUS + SG + CH_MANUAL + SG + CH_GRID)

// 右栏卡片高度
#define CH_OVERVIEW     95        // 仓位概览卡
#define CH_ACT          222       // 平仓管理卡(多/空)
#define CH_ACCOUNT      100       // 账户信息卡(3行)
#define RIGHT_COL_H     (CH_OVERVIEW + SG + CH_ACT + SG + CH_ACT + SG + CH_ACCOUNT)

#define TOTAL_H   (HDR_H + SG + PD + (LEFT_COL_H > RIGHT_COL_H ? LEFT_COL_H : RIGHT_COL_H) + PD)
// 平仓管理区
#define cp_LblW          126       // 标签按钮宽
#define cp_EW1          56        // 输入框宽(大)
#define cp_EW2          44        // 输入框宽(小)
#define cp_BtnW          40        // 抽取按钮宽
#define cp_RowH          24        // 行高
#define cp_LotW          36        // 预估手数标签宽
#define cp_AmtW          95        // 预估金额标签宽
//+------------------------------------------------------------------+
//| 输入参数                                                          |
//+------------------------------------------------------------------+
input group "== 交易参数 =="
input double      InpLotSize        = 0.01;          // 手数(平投)
input int         InpMagicNumber    = 111111;        // 魔术号
input int         InpSlippage       = 30;            // 滑点
input group "== 入场信号(D1 EMA14) =="
input int               InpEMA_Period   = 14;          // EMA周期
input ENUM_TIMEFRAMES    InpEMA_TF       = PERIOD_D1;   // 入场信号TF
input group "== 网格MA10(多周期方向检测) =="
input int               InpMA_Period    = 10;          // MA周期
input group "== 止盈止损(点数) =="
input int         InpTakeProfit     = 200;           // 止盈点数(0=不启用)
input int         InpStopLoss       = 200;           // 止损点数(0=不启用)
input group "== 加仓控制 =="
input double      InpLotIncrementBuy  = 0.01;       // 多单每层手数递增
input double      InpLotIncrementSell = 0.01;       // 空单每层手数递增
input group "== 风险防护 =="
input double      InpMaxTotalLotsBuy  = 3.0;        // 多单最大总持仓手数
input double      InpMaxTotalLotsSell = 3.0;        // 空单最大总持仓手数
input double      InpLockDrawdownUSD = 88888.0;       // 锁仓浮亏阈值($,同方向浮亏超此值锁仓停止EA)
input double      InpGridExpFactorBuy = 1.5;       // 多单逆势加仓指数间距倍数
input double      InpGridExpFactorSell = 1.5;      // 空单逆势加仓指数间距倍数
input group "== 面板位置 =="
input int         InpPanelX         = 10;            // 面板X(像素)
input int         InpPanelY         = 10;            // 面板Y(像素)
input group "== 颜色 =="
input color       InpColorBuy       = C'66,153,225'; // 买入色
input color       InpColorSell      = C'239,100,97'; // 卖出色

// 自定义颜色常量
const color cWhite = C'235,240,250';


//+------------------------------------------------------------------+
//| 结构体                                                            |
//+------------------------------------------------------------------+
struct EAStats
{
   int    buy_cnt;
   int    sell_cnt;
   double buy_lot;
   double sell_lot;
   double pnl;
   double buy_pnl;
   double sell_pnl;
   int    buy_pending;
   int    sell_pending;
};
// 平仓统计结构体
struct CpStats
{
   double lots;   // 总手数
   int    cnt;    // 总单数
   double pnl;    // 总盈亏
};
// 持仓信息结构 (按序平仓排序用, 参照平仓面板35)
struct OrderInfo
{
   ulong    ticket;
   double   openPrice;
   double   lots;
   double   profit;        // 含 swap
   ENUM_POSITION_TYPE posType;
   datetime time;
};
// 平仓模式枚举 (参照平仓面板35)
enum CLOSE_MODE
{
   CLOSE_MODE_PERCENT,    // 百分比平仓
   CLOSE_MODE_FIXED,      // 固定手数平仓
   CLOSE_MODE_TOP_DOWN,   // 从上向下(高价优先)
   CLOSE_MODE_BOTTOM_UP   // 从下向上(低价优先)
};
//+------------------------------------------------------------------+
//| 全局变量                                                          |
//+------------------------------------------------------------------+
CTrade         m_trade;
CPositionInfo  m_pos;
string         g_prefix        = "GP_";
// EMA14入场句柄 (D1, 独立)
int            g_emaHandle     = INVALID_HANDLE;
// 7个MA10句柄: [0]=H4, [1]=H1, [2]=M30, [3]=M15, [4]=M5, [5]=M3, [6]=M1
int            g_maHandle[7];
ENUM_TIMEFRAMES g_gridTF[7] = {PERIOD_H4,PERIOD_H1,PERIOD_M30,PERIOD_M15,PERIOD_M5,PERIOD_M3,PERIOD_M1};
string         g_gridTFName[7] = {"H4","H1","M30","M15","M5","M3","M1"};
bool           g_panel_open    = true;
int            g_px            = 20;
int            g_py            = 20;
bool           g_panel_dragging = false;
int            g_panel_drag_ox = 0;
int            g_panel_drag_oy = 0;
double         g_lot_manual     = 0.01; // 手动下单手数 (原g_lot)
double         g_lot_base_buy   = 0.01; // 自动网格多单初始手数
double         g_lot_base_sell  = 0.01; // 自动网格空单初始手数
int            g_tp            = 200;
int            g_sl            = 200;
int            g_trend         = 0;
datetime       g_lastRefresh   = 0;
bool           g_allow_buy     = true;
bool           g_allow_sell    = true;
datetime       g_lastFailTime  = 0;   // 上次开单失败时间（防刷屏）
string         g_lastFailMsg   = "";  // 上次失败原因
// ── 网格加仓独立开关（面板控制，与开仓开关分离）──
bool           g_allow_grid_buy  = true;  // 允许多单网格加仓
bool           g_allow_grid_sell = true;  // 允许空单网格加仓
// ── 网格加仓状态 ──
double         g_gridLastBuy   = 0;   // 多头最后入场价
double         g_gridLastSell  = 0;   // 空头最后入场价
int            g_gridCounterInterval=200; // 当前逆势间距(动态)
int            g_gridRecoveryBars = 0;   // 恢复递减计数
datetime       g_gridLastBar   = 0;   // 上根K线时间(递减计时)
int            g_gridLastDepth  = 0;   // 上次逆向深度
// ── 趋势转变 + 手数递增 ──
int            g_lastTrend      = 0;   // 上次D1趋势方向
int            g_currentMagic   = 111111; // 当前魔术码(固定使用InpMagicNumber)
int            g_manualMagic    = 999999; // 手动单魔术码(独立管理, 与自动策略隔离)
int            g_gridLayer      = 0;   // 加仓层数(0=首单)
// ── 异步批量平仓系统 (参照平仓面板35实现, 不限魔术码 + 仅本品种) ──
CTrade         g_asyncTrade;                       // 异步平仓交易对象
bool           g_isAsyncClosing        = false;     // 是否正在异步平仓
datetime       g_asyncCloseStartTime   = 0;        // 异步平仓开始时间
int            g_asyncCloseInitialCount = 0;        // 异步平仓初始持仓数
ENUM_ORDER_TYPE g_asyncCloseOrderType   = ORDER_TYPE_BUY; // 异步平仓目标方向(BUY=多单, SELL=空单)
// ── 按序平仓方向: true=从下向上(先平开仓价最低的), false=从上向下(先平开仓价最高的) ──
bool           g_longCloseDir  = false;  // 多单默认: 从上向下(灰色)
bool           g_shortCloseDir = true;   // 空单默认: 从下向上(灰色, 不显示橙色)
// ── 顺势加仓间距(常量, 不在面板体现) ──
const int      g_gridWithTrend  = 100;    // 顺势同向间距(点) - 固定常量
// ── 可面板修改的运行时参数(从input初始化, 面板可改) ──
int            g_maxLayersBuy   = 100;    // 多单最大加仓层数
int            g_maxLayersSell  = 100;    // 空单最大加仓层数
double         g_lotIncrementBuy  = 0.01;   // 多单每层手数递增
double         g_lotIncrementSell = 0.01;   // 空单每层手数递增
// ── 风险防护参数 ──
double         g_maxTotalLotsBuy  = 3.0;   // 多单最大总持仓手数
double         g_maxTotalLotsSell = 3.0;   // 空单最大总持仓手数
double         g_lockDrawdownUSD = 88888.0; // 锁仓浮亏阈值($) - 达到则完全冻结并停止EA
double         g_gridExpFactorBuy  = 1.5; // 多单逆势加仓指数间距倍数
double         g_gridExpFactorSell = 1.5; // 空单逆势加仓指数间距倍数
// ── 锁仓状态 ──
bool           g_locked         = false;  // 锁仓标志(true=完全冻结,等待人工介入)
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
//| 面板定位 & 移动                                                   |
//+------------------------------------------------------------------+
void ClampPanelPosition(int &x, int &y)
{
   long cw = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
   long ch = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
   if(x < 0) x = 0;
   if(y < 0) y = 0;
   if(x + PW > cw && cw > PW) x = (int)(cw - PW);
   if(y + TOTAL_H > ch && ch > TOTAL_H) y = (int)(ch - TOTAL_H);
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
void MovePanelTo(int nx, int ny)
{
   ClampPanelPosition(nx,ny); ShiftAll(nx-g_px, ny-g_py);
}
bool IsClickOnPanelDragArea(int cx, int cy)
{
   return (cx>=g_px && cx<=g_px+PW && cy>=g_py && cy<=g_py+HDR_H);
}
void SetPanelDragHighlight(bool on)
{
   string p = g_prefix+"panel";
   if(ObjectFind(0,p)<0) return;
   ObjectSetInteger(0,p,OBJPROP_COLOR, on?C'66,153,225':C'45,58,74');
   ObjectSetInteger(0,p,OBJPROP_WIDTH,on?2:1);
}
//+------------------------------------------------------------------+
//| Ensure 对象创建                                                    |
//+------------------------------------------------------------------+
void ERect(string nm, int x, int y, int w, int h, color bg, color bd,
           int cr=CORNER_LEFT_UPPER)
{
   if(ObjectFind(0,nm)<0) ObjectCreate(0,nm,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,nm,OBJPROP_CORNER,cr);
   ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,nm,OBJPROP_COLOR,bd);
   ObjectSetInteger(0,nm,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,nm,OBJPROP_WIDTH,BD_W);
   ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,nm,OBJPROP_BACK,false);
}
void ELbl(string nm, string txt, int x, int y, int fs, color clr,
           int cr=CORNER_LEFT_UPPER)
{
   if(ObjectFind(0,nm)<0) ObjectCreate(0,nm,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,nm,OBJPROP_CORNER,cr);
   ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,y);
   ObjectSetString(0,nm,OBJPROP_FONT,"Microsoft YaHei");
   ObjectSetInteger(0,nm,OBJPROP_FONTSIZE,F(fs));
   ObjectSetString(0,nm,OBJPROP_TEXT,txt);
   ObjectSetInteger(0,nm,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,nm,OBJPROP_BACK,false);
}
void EBtn(string nm, string txt, int x, int y, int w, int h, color bg, color fg,
           int cr=CORNER_LEFT_UPPER)
{
   if(ObjectFind(0,nm)<0) ObjectCreate(0,nm,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,nm,OBJPROP_CORNER,cr);
   ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,h);
   ObjectSetString(0,nm,OBJPROP_FONT,"Microsoft YaHei");
   ObjectSetInteger(0,nm,OBJPROP_FONTSIZE,F(10));
   ObjectSetString(0,nm,OBJPROP_TEXT,txt);
   ObjectSetInteger(0,nm,OBJPROP_COLOR,fg);
   ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,nm,OBJPROP_BORDER_COLOR,bg);
   ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,nm,OBJPROP_BACK,false);
}
void EEdt(string nm, string txt, int x, int y, int w, int h,
          int cr=CORNER_LEFT_UPPER)
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
      ObjectSetInteger(0,nm,OBJPROP_COLOR,cWhite);
      ObjectSetInteger(0,nm,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,nm,OBJPROP_BACK,false);
   }
   // 以下属性每次刷新都更新（位置/尺寸/可见性可能因拖拽/折叠改变）
   ObjectSetInteger(0,nm,OBJPROP_CORNER,cr);
   ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true);
}
//+------------------------------------------------------------------+
//| 删除 & 折叠                                                        |
//+------------------------------------------------------------------+
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
   EBtn(g_prefix+"toggle_panel",g_panel_open?"▲ 隐藏":"▼ 展开",
        PD,PD+BH,90,BH,C'56,132,216',cWhite,CORNER_LEFT_LOWER);
}
//+------------------------------------------------------------------+
//| 确认对话框 (MessageBox)                                             |
//+------------------------------------------------------------------+
bool ShowConfirmDialog(const string message)
{
   return(MessageBox(message,"确认操作",MB_YESNO|MB_ICONQUESTION)==IDYES);
}
//+------------------------------------------------------------------+
//| 按钮状态重置                                                       |
//+------------------------------------------------------------------+
void ResetPanelButtonState(const string button_name)
{
   if(button_name=="") return;
   if(ObjectFind(0,button_name)<0) return;
   ObjectSetInteger(0,button_name,OBJPROP_STATE,false);
}
//+------------------------------------------------------------------+
//| 收集平仓统计 (仅本品种, 不限魔术码 — 与实际平仓口径一致)          |
//+------------------------------------------------------------------+
void CpCollectStats(ENUM_POSITION_TYPE pt, CpStats &s)
{
   s.lots = 0; s.cnt = 0; s.pnl = 0;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)!=pt) continue;
      // 不限魔术码: 统计本图表该方向所有持仓
      s.lots += PositionGetDouble(POSITION_VOLUME);
      s.cnt++;
      s.pnl += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   }
}
//+------------------------------------------------------------------+
//| 手数步进对齐 (参照平仓面板35)                                      |
//+------------------------------------------------------------------+
double GetVolumeStep()
{
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   return (step > 0 ? step : 0.01);
}
double AlignVolumeToStep(double volume)
{
   double step = GetVolumeStep();
   return MathFloor(volume / step + 1e-9) * step;
}
int getLotDigits()
{
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(lotStep >= 0.1) return 1;
   if(lotStep >= 0.01) return 2;
   if(lotStep >= 0.001) return 3;
   return 2;
}
//+------------------------------------------------------------------+
//| 持仓过滤: 仅本品种, 不限魔术码 (用户要求)                          |
//+------------------------------------------------------------------+
bool PositionMatchesFilter(ulong positionTicket)
{
   if(!PositionSelectByTicket(positionTicket)) return false;
   if(PositionGetString(POSITION_SYMBOL) != _Symbol) return false;
   return true;  // 不限魔术码
}
//+------------------------------------------------------------------+
//| 按方向统计当前持仓数量 (异步平仓用)                                 |
//+------------------------------------------------------------------+
int CountCurrentPositionsByType(ENUM_ORDER_TYPE orderType)
{
   int count = 0;
   ENUM_POSITION_TYPE targetPosType = (orderType==ORDER_TYPE_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != targetPosType) continue;
      count++;
   }
   return count;
}
//+------------------------------------------------------------------+
//| 单仓平仓 (部分/全量): FOK→IOC 回退 + retcode 检查                  |
//| 参照平仓面板35 ClosePosition                                       |
//+------------------------------------------------------------------+
bool ClosePosition(ulong positionTicket, double volume, int slippage)
{
   if(!PositionSelectByTicket(positionTicket)) return false;
   string symbol = PositionGetString(POSITION_SYMBOL);
   ENUM_POSITION_TYPE ptype = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};
   request.action       = TRADE_ACTION_DEAL;
   request.symbol       = symbol;
   request.volume       = volume;
   request.type         = (ptype==POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
   request.price        = (request.type==ORDER_TYPE_SELL) ? SymbolInfoDouble(symbol,SYMBOL_BID) : SymbolInfoDouble(symbol,SYMBOL_ASK);
   request.deviation    = slippage;
   request.type_filling = ORDER_FILLING_FOK;
   request.type_time    = ORDER_TIME_GTC;
   request.position     = positionTicket;
   request.comment      = "面板平仓";

   if(!OrderSend(request,result) || (result.retcode!=TRADE_RETCODE_DONE && result.retcode!=TRADE_RETCODE_PLACED))
   {
      // FOK 失败, 回退到 IOC
      request.type_filling = ORDER_FILLING_IOC;
      if(!OrderSend(request,result) || (result.retcode!=TRADE_RETCODE_DONE && result.retcode!=TRADE_RETCODE_PLACED))
      {
         PrintFormat("[面板平仓] 失败 #%I64u retcode=%d lastError=%d", positionTicket, (int)result.retcode, GetLastError());
         return false;
      }
   }
   return true;
}
//+------------------------------------------------------------------+
//| 异步发送平仓请求 (OrderSendAsync, 失败回退同步)                    |
//| 参照平仓面板35 SendCloseAsyncOrSync                                |
//+------------------------------------------------------------------+
bool SendCloseAsyncOrSync(ulong positionTicket, double volume, int slippage)
{
   if(!PositionSelectByTicket(positionTicket)) return false;
   string symbol = PositionGetString(POSITION_SYMBOL);
   ENUM_POSITION_TYPE ptype = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

   MqlTradeRequest request = {};
   MqlTradeResult  asyncResult = {};
   request.action       = TRADE_ACTION_DEAL;
   request.symbol       = symbol;
   request.volume       = volume;
   request.type         = (ptype==POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
   request.price        = (request.type==ORDER_TYPE_SELL) ? SymbolInfoDouble(symbol,SYMBOL_BID) : SymbolInfoDouble(symbol,SYMBOL_ASK);
   request.deviation    = slippage;
   request.type_filling = ORDER_FILLING_IOC;
   request.type_time    = ORDER_TIME_GTC;
   request.position     = positionTicket;
   request.comment      = "异步平仓";

   if(OrderSendAsync(request, asyncResult)) return true;
   // 异步失败, 回退同步
   return ClosePosition(positionTicket, volume, slippage);
}
//+------------------------------------------------------------------+
//| 全平某方向持仓 (先收集tickets动态数组, 再从后往前平)                |
//| 参照平仓面板35 CloseAllPositions — 解决 tickets 快照过期问题        |
//+------------------------------------------------------------------+
void CloseAllPositions(ENUM_ORDER_TYPE orderType)
{
   ENUM_POSITION_TYPE targetPosType = (orderType==ORDER_TYPE_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
   int total = (int)PositionsTotal();
   // 第一次扫描: 统计数量
   int count = 0;
   for(int i=0; i<total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != targetPosType) continue;
      count++;
   }
   if(count==0) return;
   // 动态数组 (替代固定 tickets[100])
   ulong tickets[];
   ArrayResize(tickets, count);
   count = 0;
   // 第二次扫描: 收集 ticket
   for(int i=0; i<total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != targetPosType) continue;
      tickets[count++] = ticket;
   }
   // 从后往前平 (避免索引错位)
   double closedLots = 0;
   for(int i=count-1; i>=0; i--)
   {
      ulong t = tickets[i];
      if(PositionSelectByTicket(t))
      {
         double vol = PositionGetDouble(POSITION_VOLUME);
         if(ClosePosition(t, vol, 30))
            closedLots += vol;
         else
            Print("[面板平仓] 全平失败 #", t, " err=", GetLastError());
      }
   }
   Print("[面板平仓] 全平", (orderType==ORDER_TYPE_BUY)?"多单":"空单",
         " 完成, 共平 ", count, " 单 ", DoubleToString(closedLots,2), " 手");
}
//+------------------------------------------------------------------+
//| 按百分比平仓 (每单 posLots × pct% 向下取整到 lotStep)              |
//| 参照平仓面板35 ClosePositionsByPercent                             |
//+------------------------------------------------------------------+
void ClosePositionsByPercent(ENUM_ORDER_TYPE orderType, double percent)
{
   if(percent<=0 || percent>100) return;
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   ENUM_POSITION_TYPE targetPosType = (orderType==ORDER_TYPE_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
   int total = (int)PositionsTotal();
   double closedLots = 0;
   int closedCnt = 0;
   for(int i=total-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != targetPosType) continue;
      double posLots  = PositionGetDouble(POSITION_VOLUME);
      double closeLot = AlignVolumeToStep(posLots * percent / 100.0);
      if(closeLot >= minLot)
      {
         if(ClosePosition(ticket, closeLot, 30))
         { closedLots += closeLot; closedCnt++; }
      }
      else
         Print("[面板平仓] 跳过 #", ticket, " closeLot=", DoubleToString(closeLot,2),
               " < minLot=", DoubleToString(minLot,2));
   }
   Print("[面板平仓] 百分比平", (orderType==ORDER_TYPE_BUY)?"多单":"空单",
         " ", DoubleToString(percent,1), "% 完成, 共平 ",
         closedCnt, " 单 ", DoubleToString(closedLots,2), " 手");
}
//+------------------------------------------------------------------+
//| 按固定手数平仓 (每单平 min(val, posLots))                          |
//| 参照平仓面板35 ClosePositionsByFixedLots                           |
//+------------------------------------------------------------------+
void ClosePositionsByFixedLots(ENUM_ORDER_TYPE orderType, double lots)
{
   if(lots<=0) return;
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double perPositionLots = AlignVolumeToStep(lots);
   if(perPositionLots <= 0) return;
   ENUM_POSITION_TYPE targetPosType = (orderType==ORDER_TYPE_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
   int total = (int)PositionsTotal();
   double closedLots = 0;
   int closedCnt = 0;
   for(int i=total-1; i>=0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != targetPosType) continue;
      double posLots  = PositionGetDouble(POSITION_VOLUME);
      double closeLot = AlignVolumeToStep(MathMin(perPositionLots, posLots));
      if(closeLot >= minLot)
      {
         if(ClosePosition(ticket, closeLot, 30))
         { closedLots += closeLot; closedCnt++; }
      }
   }
   Print("[面板平仓] 固定手数平", (orderType==ORDER_TYPE_BUY)?"多单":"空单",
         " ", DoubleToString(perPositionLots,2), "/单 完成, 共平 ",
         closedCnt, " 单 ", DoubleToString(closedLots,2), " 手");
}
//+------------------------------------------------------------------+
//| 按开仓价顺序平仓 (由 lowToHigh 控制方向)                          |
//| 参照平仓面板35 ClosePositionsByOrder                               |
//+------------------------------------------------------------------+
void ClosePositionsByOrder(ENUM_ORDER_TYPE orderType, double lots, bool lowToHigh)
{
   if(lots<=0) return;
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double remain = AlignVolumeToStep(lots);
   ENUM_POSITION_TYPE targetPosType = (orderType==ORDER_TYPE_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
   int total = (int)PositionsTotal();
   // 第一次扫描: 统计
   int count = 0;
   for(int i=0; i<total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != targetPosType) continue;
      count++;
   }
   if(count==0) return;
   // 收集 OrderInfo
   OrderInfo entries[];
   ArrayResize(entries, count);
   count = 0;
   for(int i=0; i<total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != targetPosType) continue;
      entries[count].ticket    = ticket;
      entries[count].openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      entries[count].lots      = PositionGetDouble(POSITION_VOLUME);
      entries[count].profit   = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      entries[count].posType   = targetPosType;
      entries[count].time      = (datetime)PositionGetInteger(POSITION_TIME);
      count++;
   }
   // 排序: lowToHigh=true 升序(低价优先), false 降序(高价优先)
   for(int i=0; i<count-1; i++)
      for(int j=i+1; j<count; j++)
      {
         bool needSwap = lowToHigh ? (entries[i].openPrice > entries[j].openPrice)
                                   : (entries[i].openPrice < entries[j].openPrice);
         if(needSwap)
         {
            OrderInfo tmp = entries[i]; entries[i] = entries[j]; entries[j] = tmp;
         }
      }
   // 按序平仓到 remain
   double closedLots = 0;
   int closedCnt = 0;
   for(int k=0; k<count && remain>0; k++)
   {
      ulong ticket = entries[k].ticket;
      if(!PositionSelectByTicket(ticket)) continue;
      double closeLot = AlignVolumeToStep(MathMin(remain, entries[k].lots));
      if(closeLot >= minLot && ClosePosition(ticket, closeLot, 30))
      {
         remain      -= closeLot;
         closedLots  += closeLot;
         closedCnt++;
      }
   }
   Print("[面板平仓] 按序平", (orderType==ORDER_TYPE_BUY)?"多单":"空单",
         "(", lowToHigh?"从下向上":"从上向下", ") 完成, 共平 ",
         closedCnt, " 单 ", DoubleToString(closedLots,2), " 手 (目标 ", DoubleToString(lots,2), ")");
}
//+------------------------------------------------------------------+
//| 按盈亏平仓 (平盈利 / 平亏损)                                       |
//| onlyProfit=true: 仅平 pnl>0 的单; false: 仅平 pnl<=0 的单           |
//+------------------------------------------------------------------+
void ClosePositionsByProfit(ENUM_ORDER_TYPE orderType, bool onlyProfit)
{
   ENUM_POSITION_TYPE targetPosType = (orderType==ORDER_TYPE_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
   int total = (int)PositionsTotal();
   // 第一次扫描: 统计
   int count = 0;
   for(int i=0; i<total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != targetPosType) continue;
      double pnl = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(onlyProfit && pnl<=0) continue;
      if(!onlyProfit && pnl>0) continue;
      count++;
   }
   if(count==0)
   {
      Print("[面板平仓] 没有", onlyProfit?"盈利":"亏损", (orderType==ORDER_TYPE_BUY)?"多单":"空单");
      return;
   }
   ulong tickets[];
   ArrayResize(tickets, count);
   count = 0;
   for(int i=0; i<total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != targetPosType) continue;
      double pnl = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(onlyProfit && pnl<=0) continue;
      if(!onlyProfit && pnl>0) continue;
      tickets[count++] = ticket;
   }
   double closedLots = 0;
   for(int i=count-1; i>=0; i--)
   {
      ulong t = tickets[i];
      if(PositionSelectByTicket(t))
      {
         double vol = PositionGetDouble(POSITION_VOLUME);
         if(ClosePosition(t, vol, 30))
            closedLots += vol;
      }
   }
   Print("[面板平仓] 平", onlyProfit?"盈利":"亏损", (orderType==ORDER_TYPE_BUY)?"多单":"空单",
         " 完成, 共平 ", count, " 单 ", DoubleToString(closedLots,2), " 手");
}
//+------------------------------------------------------------------+
//| 统一平仓入口 (同步模式分发)                                         |
//| 参照平仓面板35 ClosePositions                                       |
//+------------------------------------------------------------------+
void ClosePositions(ENUM_ORDER_TYPE orderType, CLOSE_MODE mode, double value)
{
   if(value <= 0 && mode!=CLOSE_MODE_PERCENT) return;
   switch(mode)
   {
      case CLOSE_MODE_PERCENT:    ClosePositionsByPercent(orderType, value); break;
      case CLOSE_MODE_FIXED:       ClosePositionsByFixedLots(orderType, value); break;
      case CLOSE_MODE_TOP_DOWN:    ClosePositionsByOrder(orderType, value, false); break;
      case CLOSE_MODE_BOTTOM_UP:   ClosePositionsByOrder(orderType, value, true); break;
   }
}
//+------------------------------------------------------------------+
//| 启动异步批量平仓 (OnTick 持续调用 ContinueAsyncClosingOrders)       |
//| 参照平仓面板35 StartAsyncClosingOrders                             |
//+------------------------------------------------------------------+
void StartAsyncClosingOrders(ENUM_ORDER_TYPE orderType)
{
   if(g_locked){ Print("[锁仓] 已冻结, 禁止平仓操作"); return; }
   if(g_isAsyncClosing)
   {
      Print("[异步平仓] 正在进行中, 请等待完成");
      return;
   }
   int currentPositions = CountCurrentPositionsByType(orderType);
   if(currentPositions == 0)
   {
      Print("[异步平仓] 没有找到 ", _Symbol, " 的", (orderType==ORDER_TYPE_BUY)?"多单":"空单");
      return;
   }
   g_asyncCloseOrderType    = orderType;
   g_asyncCloseInitialCount = currentPositions;
   g_isAsyncClosing         = true;
   g_asyncCloseStartTime    = TimeCurrent();
   Print("[异步平仓] 开始平", (orderType==ORDER_TYPE_BUY)?"多单":"空单",
         " ", currentPositions, " 单 ", _Symbol);
}
//+------------------------------------------------------------------+
//| 继续异步批量平仓 (OnTick 调用, 每 tick 最多平 100 单)               |
//| 参照平仓面板35 ContinueAsyncClosingOrders                           |
//+------------------------------------------------------------------+
void ContinueAsyncClosingOrders()
{
   if(!g_isAsyncClosing) return;
   if(g_locked) return;  // 锁仓后冻结
   int currentPositions = CountCurrentPositionsByType(g_asyncCloseOrderType);
   if(currentPositions == 0)
   {
      int timeUsed = (int)(TimeCurrent() - g_asyncCloseStartTime);
      Print("[异步平仓] 成功平", (g_asyncCloseOrderType==ORDER_TYPE_BUY)?"多单":"空单",
            g_asyncCloseInitialCount, " 单, 用时 ", timeUsed, " 秒");
      g_isAsyncClosing         = false;
      g_asyncCloseStartTime    = 0;
      g_asyncCloseInitialCount = 0;
      return;
   }
   int batchSize = MathMin(currentPositions, 100);
   int sent = 0;
   int successCnt = 0;
   int errorCnt = 0;
   for(int j=PositionsTotal()-1; j>=0 && sent<batchSize; j--)
   {
      ulong ticket = PositionGetTicket(j);
      if(ticket==0) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      bool shouldClose = false;
      if(g_asyncCloseOrderType==ORDER_TYPE_BUY && posType==POSITION_TYPE_BUY) shouldClose = true;
      else if(g_asyncCloseOrderType==ORDER_TYPE_SELL && posType==POSITION_TYPE_SELL) shouldClose = true;
      if(!shouldClose) continue;
      // 平仓前再次验证
      if(!PositionSelectByTicket(ticket)) continue;
      if(!PositionMatchesFilter(ticket)) continue;
      double vol = PositionGetDouble(POSITION_VOLUME);
      if(vol <= 0) continue;
      // 异步平仓
      if(g_asyncTrade.PositionClose(ticket))
      {
         sent++;
         successCnt++;
         continue;
      }
      uint retcode = g_asyncTrade.ResultRetcode();
      string errorDesc = g_asyncTrade.ResultRetcodeDescription();
      // 持仓不存在, 跳过
      if(StringFind(errorDesc, "doesn't exist")>=0 || StringFind(errorDesc, "不存在")>=0)
         continue;
      errorCnt++;
      // 重报价/超时/休市 → 反向订单重试
      if(retcode==TRADE_RETCODE_REQUOTE || retcode==TRADE_RETCODE_TIMEOUT || retcode==TRADE_RETCODE_MARKET_CLOSED)
      {
         if(!PositionSelectByTicket(ticket)) continue;
         if(posType==POSITION_TYPE_BUY)
         {
            if(g_asyncTrade.Sell(vol, _Symbol, 0, 0, 0, "异步平仓"))
            { sent++; successCnt++; }
         }
         else
         {
            if(g_asyncTrade.Buy(vol, _Symbol, 0, 0, 0, "异步平仓"))
            { sent++; successCnt++; }
         }
      }
   }
   if(sent > 0)
      Print("[异步平仓] ", (g_asyncCloseOrderType==ORDER_TYPE_BUY)?"多单":"空单",
            " 本批发送 ", sent, " 成功 ", successCnt, " 错误 ", errorCnt,
            " 剩余 ", currentPositions, " 单");
}
//+------------------------------------------------------------------+
//| 计算当日已平仓盈亏 (按平仓时间过滤, 服务器时间 0 点起)                |
//+------------------------------------------------------------------+
double CalcTodayClosedProfit()
{
   datetime dayStart;
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   dt.hour = 0; dt.min = 0; dt.sec = 0;
   dayStart = StructToTime(dt);

   double total = 0;
   datetime from = dayStart;
   datetime to   = TimeCurrent() + 60;
   if(!HistorySelect(from, to)) return 0;

   int deals = HistoryDealsTotal();
   for(int i = 0; i < deals; i++)
   {
      ulong ticket = HistoryDealGetTicket(i);
      if(ticket == 0) continue;
      ENUM_DEAL_ENTRY entry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY);
      if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_OUT_BY) continue;
      if(!PositionMatchSymbol(ticket)) continue;   // 仅本品种
      datetime closeTime = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
      if(closeTime < dayStart) continue;
      double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
      double swap   = HistoryDealGetDouble(ticket, DEAL_SWAP);
      double comm   = HistoryDealGetDouble(ticket, DEAL_COMMISSION);
      total += profit + swap + comm;
   }
   return total;
}
//+------------------------------------------------------------------+
//| 计算累计已平仓盈亏 (全历史, 仅本品种)                                |
//+------------------------------------------------------------------+
double CalcTotalClosedProfit()
{
   double total = 0;
   datetime from = 0;
   datetime to   = TimeCurrent() + 60;
   if(!HistorySelect(from, to)) return 0;

   int deals = HistoryDealsTotal();
   for(int i = 0; i < deals; i++)
   {
      ulong ticket = HistoryDealGetTicket(i);
      if(ticket == 0) continue;
      ENUM_DEAL_ENTRY entry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY);
      if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_OUT_BY) continue;
      if(!PositionMatchSymbol(ticket)) continue;   // 仅本品种
      double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
      double swap   = HistoryDealGetDouble(ticket, DEAL_SWAP);
      double comm   = HistoryDealGetDouble(ticket, DEAL_COMMISSION);
      total += profit + swap + comm;
   }
   return total;
}
//+------------------------------------------------------------------+
//| 判断 deal 是否属于本品种 (复用 pp35 的 PositionMatchesFilter 思路)    |
//+------------------------------------------------------------------+
bool PositionMatchSymbol(ulong dealTicket)
{
   string sym = HistoryDealGetString(dealTicket, DEAL_SYMBOL);
   return (sym == _Symbol);
}
//+------------------------------------------------------------------+
//| 绘制面板 — 横向双栏布局                                            |
//+------------------------------------------------------------------+
void DrawPanel(EAStats &s)
{
   // ====== 全部变量声明（必须在函数体最前面） ======
   int X;
   int LX;
   int RX;
   int PW_;
   int W;
   int LW_;
   int RW_;
   color BG_PANEL;
   color BD_PANEL;
   color BG_HDR;
   color BG_CARD;
   color cMute;
   color cOk;
   color cWarn;
   color cBad;
   string tTxt;
   string pTxt;
   string rTxt;
   string sub;
   color tClr;
   color pClr;
   color rClr;
   int cy;
   int ry;
   int cDepth;
   int dynTP;
   int ey;
   int btnY;
   int qbw;
   int rx;
   int by;
   int cbw;
   int bw3;
   int bw3S;
   string gridStr;
   string magicStr;
   string layerStr;
   string tpStr;
   string st_buy;
   string st_sell;
   double nextLot;
   double inc;
   color tpClr;
   string dirTxtL;
   string dirTxtS;
   color dirClrL;
   color dirClrS;
   color sc_buy;
   color sc_sell;
   double totalPnL;
   double perLVal;
   double fixLVal;
   double ordLVal;
   double perSVal;
   double fixSVal;
   double ordSVal;
   color pnlClr;
   color buyStatClr;
   color sellStatClr;
   string pnlSign;
   string buyStat;
   string sellStat;
   color perLClr;
   color fixLClr;
   color ordLClr;
   color perSClr;
   color fixSClr;
   color ordSClr;
   double perLAmt;
   double fixLAmt;
   double ordLAmt;
   double perSAmt;
   double fixSAmt;
   double ordSAmt;
   string sigStr;
   string spStr;
   string lossStr;
   string nxtStr;
   string maxLayerStr;
   string incStr;
   string ciStr;
   color  ciClr;
   int    ay;
   double accBalance;
   double accEquity;
   color  balClr;
   color  eqtClr;
   double dayPnl;
   double usedMargin;
   double totalPnl2;
   color  dayClr;
   color  totClr;
   double clipL_fx;
   double clipL_or;
   double clipS_fx;
   double clipS_or;
   // ====== 变量赋值 & 执行语句 ======
   pClr = cWhite;
   X = g_px;
   LX = X + PD;
   RX = LX + LW + PG;
   PW_ = PW - PD*2;
   W = PW_;
   LW_ = LW;
   RW_ = W - LW_ - PG;

   // 配色
   BG_PANEL  = C'18,20,28';
   BD_PANEL  = C'60,68,88';
   BG_HDR    = C'30,34,48';
   BG_CARD   = C'24,27,38';
   cMute  = C'130,140,165';
   cOk    = C'82,204,147';
   cWarn  = C'250,180,80';
   cBad   = C'240,105,110';

   sub = _Symbol+"  |  "+EnumToString(InpEMA_TF)+" EMA"+IntegerToString(InpEMA_Period);

   if(g_trend==1)      { tTxt="▲ 多头"; tClr=InpColorBuy; }
   else if(g_trend==-1){ tTxt="▼ 空头"; tClr=InpColorSell; }
   else                { tTxt="-- 无信号"; tClr=cMute; }

   // 持仓文字
   if(s.buy_cnt>0&&s.sell_cnt>0)
      pTxt="多+空 "+IntegerToString(s.buy_cnt+s.sell_cnt)+" 单";
   else if(s.buy_cnt>0)
      { pTxt="多头 "+IntegerToString(s.buy_cnt)+" 单  "+DoubleToString(s.buy_lot,2)+" 手"; pClr=InpColorBuy; }
   else if(s.sell_cnt>0)
      { pTxt="空头 "+IntegerToString(s.sell_cnt)+" 单  "+DoubleToString(s.sell_lot,2)+" 手"; pClr=InpColorSell; }
   else
      pTxt="无持仓";

   // 运行状态
   if(!g_panel_open){ DelContent(); DrawToggle(); return; }
   // 不再每次都删除重建对象，避免闪烁
   if(!g_allow_buy&&!g_allow_sell){ rTxt="已暂停"; rClr=cBad; }
   else if(!g_allow_buy||!g_allow_sell){ rTxt="単边"; rClr=cWarn; }
   else if(g_trend==0){ rTxt="等待信号"; rClr=cMute; }
   else{ rTxt="正常运行"; rClr=cOk; }

   //       外框       
   ERect(g_prefix+"panel",  X,g_py,PW,TOTAL_H,BG_PANEL,BD_PANEL);
   ERect(g_prefix+"header", X,g_py,PW,HDR_H,BG_HDR,BD_PANEL);
   ELbl(g_prefix+"title","均线策略网格系统",LX+4,g_py+10,F(15),cWhite);
   ELbl(g_prefix+"sub",sub,LX+4,g_py+32,F(9),cMute);

   //       左栏: 状态 + 参数设置       
   cy = g_py + HDR_H + SG;

   // 卡片1: 状态 (左栏)
   ERect(g_prefix+"c1",LX,cy,LW,CH_STATUS,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c1_title","状态",LX+CD_PD,cy+CD_PD,F(12),cWhite);
   ry = cy + CD_PD + 20;
   ELbl(g_prefix+"r1_lbl","运行状态", LX+CD_PD,   ry+1, F(10), cMute);
   ELbl(g_prefix+"r1_val", rTxt,       LX+CD_PD+LW*4/10,ry+1, F(10), rClr);
   ELbl(g_prefix+"r2_lbl","趋势方向", LX+CD_PD,   ry+LH+1, F(10), cMute);
   ELbl(g_prefix+"r2_val", tTxt,       LX+CD_PD+LW*4/10,ry+LH+1, F(10), tClr);
   ELbl(g_prefix+"r3_lbl","当前持仓", LX+CD_PD,   ry+LH*2+1, F(10), cMute);
   ELbl(g_prefix+"r3_val", pTxt,       LX+CD_PD+LW*4/10,ry+LH*2+1, F(10), pClr);

   // 网格间距
   gridStr = "逆势"+IntegerToString(g_gridCounterInterval)+"点";
   if(g_gridWithTrend>0) gridStr += " / 顺势"+IntegerToString(g_gridWithTrend)+"点";
   if(g_gridCounterInterval==-1) gridStr = "全部逆向(不加仓)";
   ELbl(g_prefix+"r4_lbl","网格间距", LX+CD_PD,   ry+LH*3+1, F(10), cMute);
   ELbl(g_prefix+"r4_val", gridStr,     LX+CD_PD+LW*4/10,ry+LH*3+1, F(10), g_gridCounterInterval==-1?cBad:cOk);

   // 魔术码 (自动码/手动码)
   magicStr = "自动 "+IntegerToString(g_currentMagic)+" / 手动 "+IntegerToString(g_manualMagic);
   ELbl(g_prefix+"r5_lbl","魔术码",   LX+CD_PD,   ry+LH*4+1, F(10), cMute);
   ELbl(g_prefix+"r5_val", magicStr,    LX+CD_PD+LW*4/10,ry+LH*4+1, F(9), cWhite);

   // 层数 + 下次手数 (按当前趋势方向取对应递增手数和基础手数)
   if(g_trend == -1)
   {
      inc = g_lotIncrementSell;
      nextLot = g_lot_base_sell + g_gridLayer * inc;
   }
   else
   {
      inc = g_lotIncrementBuy;
      nextLot = g_lot_base_buy + g_gridLayer * inc;
   }
   layerStr = "层数:"+IntegerToString(g_gridLayer)+" | 下次:"+DoubleToString(nextLot,2)+"手";
   ELbl(g_prefix+"r6_lbl","加仓进度", LX+CD_PD,   ry+LH*5+1, F(10), cMute);
   ELbl(g_prefix+"r6_val", layerStr,    LX+CD_PD+LW*4/10,ry+LH*5+1, F(10), cOk);

   // 跑马灯动态止盈
   cDepth = GetCounterDepth(g_trend);
   dynTP  = InpTakeProfit - g_gridLayer*20 + cDepth*25;
   if(dynTP<50) dynTP=50; if(dynTP>400) dynTP=400;
   tpStr = "跑马灯 "+IntegerToString(dynTP)+"点 (深度"+IntegerToString(cDepth)+")";
   if(g_tp<=0) tpStr = "止盈已关闭";
   tpClr = (g_tp>0&&g_gridLayer>0) ? cOk : cMute;
   ELbl(g_prefix+"r7_lbl","动态止盈", LX+CD_PD,   ry+LH*6+1, F(10), cMute);
   ELbl(g_prefix+"r7_val", tpStr,       LX+CD_PD+LW*4/10,ry+LH*6+1, F(10), tpClr);

   // 顺势间距 (只读)
   ELbl(g_prefix+"r8_lbl","顺势间距", LX+CD_PD,   ry+LH*7+1, F(10), cMute);
   ELbl(g_prefix+"r8_val", IntegerToString(g_gridWithTrend)+"点", LX+CD_PD+LW*4/10,ry+LH*7+1, F(10), cWhite);

   // 逆势间距 (只读)
   if(g_gridCounterInterval==-1) { ciStr="全部逆向(不加仓)"; ciClr=cBad; }
   else if(g_gridCounterInterval==0) { ciStr="-"; ciClr=cMute; }
   else { ciStr=IntegerToString(g_gridCounterInterval)+"点"; ciClr=cOk; }
   ELbl(g_prefix+"r9_lbl","逆势间距", LX+CD_PD,   ry+LH*8+1, F(10), cMute);
   ELbl(g_prefix+"r9_val", ciStr,       LX+CD_PD+LW*4/10,ry+LH*8+1, F(10), ciClr);

   // 锁仓状态 (只读)
   ELbl(g_prefix+"r10_lbl","锁仓状态", LX+CD_PD,   ry+LH*9+1, F(10), cMute);
   ELbl(g_prefix+"r10_val", g_locked?"已锁仓":"正常", LX+CD_PD+LW*4/10,ry+LH*9+1, F(10), g_locked?cBad:cOk);

    // 卡片2: 手动交易 (左栏, 在状态卡下方)
    cy += CH_STATUS + SG;
    ERect(g_prefix+"c2",LX,cy,LW,CH_MANUAL,BG_CARD,BD_PANEL);
    ELbl(g_prefix+"c2_title","手动交易",LX+CD_PD,cy+CD_PD,F(12),cWhite);
    ey = cy + CD_PD + 22;

    // 第1行: [____]手动手数    [____]止盈
    EEdt(g_prefix+"e1_lot_manual",  DoubleToString(g_lot_manual,2),     LX+CD_PD+2,  ey,    EDT_W,EH);
    ELbl(g_prefix+"e1_l1","手动手数", LX+CD_PD+2+EDT_W+2,    ey+2,     F(10), cMute);
    EEdt(g_prefix+"e1_tp",   IntegerToString(g_tp),                    LX+CD_PD+LW/2+2, ey, EDT_W,EH);
    ELbl(g_prefix+"e2_l2","止盈",   LX+CD_PD+LW/2+2+EDT_W+2, ey+2,     F(10), cMute);

    // 第2行: [____]止损    [____]浮亏阈值
    EEdt(g_prefix+"e1_sl",   IntegerToString(g_sl),           LX+CD_PD+2,  ey+LH,EDT_W,EH);
    ELbl(g_prefix+"e3_l1","止损",   LX+CD_PD+2+EDT_W+2,    ey+LH+2,  F(10), cMute);
    EEdt(g_prefix+"e3_lock", DoubleToString(g_lockDrawdownUSD,0),LX+CD_PD+LW/2+2,ey+LH,EDT_W,EH);
    ELbl(g_prefix+"e3_l2","浮亏阈值",LX+CD_PD+LW/2+2+EDT_W+2,ey+LH+2,  F(10), cMute);

    // 第3行: 停多 | 停空 | 开多 | 开空
    {
       btnY = ey + LH*2 + PG;
       qbw = (LW - CD_PD*2 - PG*3) / 4;
       sc_buy = g_allow_buy ? C'55,75,100' : cOk;
       st_buy = g_allow_buy ? "停多" : "开多";
       sc_sell = g_allow_sell ? C'110,80,60' : cOk;
       st_sell = g_allow_sell ? "停空" : "开空";
       EBtn(g_prefix+"btn_stop_buy", st_buy, LX+CD_PD, btnY, qbw, BH, sc_buy, cWhite);
       EBtn(g_prefix+"btn_stop_sell", st_sell, LX+CD_PD+qbw+PG, btnY, qbw, BH, sc_sell, cWhite);
       EBtn(g_prefix+"btn_buy", "开 多", LX+CD_PD+(qbw+PG)*2, btnY, qbw, BH, InpColorBuy, cWhite);
       EBtn(g_prefix+"btn_sell", "开 空", LX+CD_PD+(qbw+PG)*3, btnY, qbw, BH, InpColorSell, cWhite);
    }

    // 卡片3: 网格参数 (左栏, 在手动交易卡下方)
    cy += CH_MANUAL + SG;
    ERect(g_prefix+"c3_grid",LX,cy,LW,CH_GRID,BG_CARD,BD_PANEL);
    ELbl(g_prefix+"c3_grid_title","网格参数",LX+CD_PD,cy+CD_PD,F(12),cWhite);
    ey = cy + CD_PD + 22;

    // 第1行: [____]多单初始手数    [____]空单初始手数
    EEdt(g_prefix+"e1_lot_buy",   DoubleToString(g_lot_base_buy,2),    LX+CD_PD+2,  ey,    EDT_W,EH);
    ELbl(g_prefix+"e1_l2","多单初始", LX+CD_PD+2+EDT_W+2,    ey+2,     F(10), cMute);
    EEdt(g_prefix+"e1_lot_sell",   DoubleToString(g_lot_base_sell,2),   LX+CD_PD+LW/2+2, ey, EDT_W,EH);
    ELbl(g_prefix+"e2_l1","空单初始", LX+CD_PD+LW/2+2+EDT_W+2, ey+2,     F(10), cMute);

    // 第2行: [____]多单最大层    [____]空单最大层
    EEdt(g_prefix+"e6_maxLB",IntegerToString(g_maxLayersBuy), LX+CD_PD+2,ey+LH,EDT_W,EH);
    ELbl(g_prefix+"e6_l1","多单最大层",LX+CD_PD+2+EDT_W+2,   ey+LH+2,F(10), cMute);
    EEdt(g_prefix+"e6_maxLS",IntegerToString(g_maxLayersSell),LX+CD_PD+LW/2+2,ey+LH,EDT_W,EH);
    ELbl(g_prefix+"e6_l2","空单最大层",LX+CD_PD+LW/2+2+EDT_W+2,ey+LH+2,F(10), cMute);

    // 第3行: [____]多单递增    [____]空单递增
    EEdt(g_prefix+"e7_incB", DoubleToString(g_lotIncrementBuy,2), LX+CD_PD+2,ey+LH*2,EDT_W,EH);
    ELbl(g_prefix+"e7_l1","多单递增",LX+CD_PD+2+EDT_W+2,     ey+LH*2+2,F(10), cMute);
    EEdt(g_prefix+"e7_incS", DoubleToString(g_lotIncrementSell,2),LX+CD_PD+LW/2+2,ey+LH*2,EDT_W,EH);
    ELbl(g_prefix+"e7_l2","空单递增",LX+CD_PD+LW/2+2+EDT_W+2,ey+LH*2+2,F(10), cMute);

    // 第4行: [____]多单总手限    [____]空单总手限
    EEdt(g_prefix+"e8_maxLB",DoubleToString(g_maxTotalLotsBuy,2), LX+CD_PD+2,ey+LH*3,EDT_W,EH);
    ELbl(g_prefix+"e8_l1","多单总手限",LX+CD_PD+2+EDT_W+2,   ey+LH*3+2,F(10), cMute);
    EEdt(g_prefix+"e8_maxLS",DoubleToString(g_maxTotalLotsSell,2),LX+CD_PD+LW/2+2,ey+LH*3,EDT_W,EH);
    ELbl(g_prefix+"e8_l2","空单总手限",LX+CD_PD+LW/2+2+EDT_W+2,ey+LH*3+2,F(10), cMute);

    // 第5行: [____]多单指数倍间距    [____]空单指数倍间距
    EEdt(g_prefix+"e10_expB", DoubleToString(g_gridExpFactorBuy,2),LX+CD_PD+2,ey+LH*4,EDT_W,EH);
    ELbl(g_prefix+"e10_l1","多单指数倍间距",LX+CD_PD+2+EDT_W+2,  ey+LH*4+2,F(10), cMute);
    EEdt(g_prefix+"e10_expS", DoubleToString(g_gridExpFactorSell,2),LX+CD_PD+LW/2+2,ey+LH*4,EDT_W,EH);
    ELbl(g_prefix+"e10_l2","空单指数倍间距",LX+CD_PD+LW/2+2+EDT_W+2,ey+LH*4+2,F(10), cMute);

    //      右栏: 仓位概览 + 多单平仓 + 空单平仓(对称双卡)
   rx = RX;
   cy = g_py + HDR_H + SG;

   // ===== 卡片 overview: 仓位概览 =====
   ERect(g_prefix+"c_overview",rx,cy,RW,CH_OVERVIEW,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c_overview_title","仓位概览",rx+CD_PD,cy+CD_PD,F(12),cWhite);
   by = cy + CD_PD + 22;

   // 浮动盈亏
   totalPnL = s.buy_pnl + s.sell_pnl;
   pnlClr = (totalPnL >= 0) ? cOk : cBad;
   pnlSign = (totalPnL >= 0) ? "+" : "";
   ELbl(g_prefix+"cp_totalPnl","浮盈 "+pnlSign+"$"+DoubleToString(totalPnL,2),
        rx+CD_PD, by, F(12), pnlClr);
   by += LH + PG;

   // 一键平仓
   cbw = RW - CD_PD*2;
   EBtn(g_prefix+"btn_closeAll","一键平仓全部持仓", rx+CD_PD, by, cbw, BH, C'180,50,50', cWhite);

   // ===== 卡片c3: 多单平仓 =====
   cy += CH_OVERVIEW + SG;
   ERect(g_prefix+"c3",rx,cy,RW,CH_ACT,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c3_title","多单平仓",rx+CD_PD,cy+CD_PD,F(12),InpColorBuy);
   by = cy + CD_PD + 22;

   // 多单统计
   buyStat = "手"+DoubleToString(s.buy_lot,2)+" | "+IntegerToString(s.buy_cnt)+"单 | $"+DoubleToString(s.buy_pnl,2);
   buyStatClr = (s.buy_pnl >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_buyStat", buyStat, rx+CD_PD, by, F(9), buyStatClr);
   by += cp_RowH + PG;

   // 全平多单 | 平盈多单 | 平亏多单
   bw3 = (RW - CD_PD*2 - PG*2) / 3;
   EBtn(g_prefix+"cp_allL","全平多单", rx+CD_PD, by, bw3, BH, C'56,132,216', cWhite);
   EBtn(g_prefix+"cp_profL","平盈多单", rx+CD_PD+bw3+PG, by, bw3, BH, C'78,190,140', cWhite);
   EBtn(g_prefix+"cp_lossL","平亏多单", rx+CD_PD+bw3*2+PG*2, by, bw3, BH, C'230,100,97', cWhite);
   by += BH + PG;

   // 多单百分比平仓
   EBtn(g_prefix+"cp_perL_btn", "多单百分比平仓", rx+CD_PD, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_perL", "20", rx+CD_PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_perL", "抽取", rx+CD_PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'56,132,216', cWhite);
   perLVal = s.buy_lot * StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_perL",OBJPROP_TEXT)) / 100.0;
   perLAmt = s.buy_pnl * StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_perL",OBJPROP_TEXT)) / 100.0;
   perLClr = (perLAmt >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_perL_lot", DoubleToString(perLVal,2)+"=", rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG, by+3, F(9), cMute);
   ELbl(g_prefix+"cp_perL_res", (perLAmt>=0?"+":"")+DoubleToString(perLAmt,2)+"$",
        rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG+cp_LotW+PG, by+3, F(9), perLClr);
   by += cp_RowH + PG;

   // 多单固定手数平仓
   EBtn(g_prefix+"cp_fixL_btn", "多单固定手数平仓", rx+CD_PD, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_fixL", "0.01", rx+CD_PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_fixL", "抽取", rx+CD_PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'56,132,216', cWhite);
   fixLVal = StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_fixL",OBJPROP_TEXT));
   {
      clipL_fx = MathMin(fixLVal, s.buy_lot);
      fixLAmt = (s.buy_lot > 0) ? s.buy_pnl * clipL_fx / s.buy_lot : 0;
   }
   fixLClr = (fixLAmt >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_fixL_lot", DoubleToString(MathMin(fixLVal,s.buy_lot),2)+"=", rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG, by+3, F(9), cMute);
   ELbl(g_prefix+"cp_fixL_res", (fixLAmt>=0?"+":"")+DoubleToString(fixLAmt,2)+"$",
        rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG+cp_LotW+PG, by+3, F(9), fixLClr);
   by += cp_RowH + PG;

   // 多单从上向下 / 多单从下向上
   dirTxtL = g_longCloseDir ? "多单从下向上" : "多单从上向下";
   dirClrL = g_longCloseDir ? C'56,132,216' : C'70,72,85';
   EBtn(g_prefix+"cp_dirL", dirTxtL, rx+CD_PD, by, cp_LblW, cp_RowH, dirClrL, cWhite);
   EEdt(g_prefix+"cp_edt_ordL", "0.01", rx+CD_PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_ordL", "抽取", rx+CD_PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'56,132,216', cWhite);
   ordLVal = StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_ordL",OBJPROP_TEXT));
   {
      clipL_or = MathMin(ordLVal, s.buy_lot);
      ordLAmt = (s.buy_lot > 0) ? s.buy_pnl * clipL_or / s.buy_lot : 0;
   }
   ordLClr = (ordLAmt >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_ordL_lot", DoubleToString(MathMin(ordLVal,s.buy_lot),2)+"=", rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG, by+3, F(9), cMute);
   ELbl(g_prefix+"cp_ordL_res", (ordLAmt>=0?"+":"")+DoubleToString(ordLAmt,2)+"$",
        rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG+cp_LotW+PG, by+3, F(9), ordLClr);

   // ===== 卡片c4: 空单平仓 =====
   cy += CH_ACT + SG;
   ERect(g_prefix+"c4",rx,cy,RW,CH_ACT,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c4_title","空单平仓",rx+CD_PD,cy+CD_PD,F(12),InpColorSell);
   by = cy + CD_PD + 22;

   // 空单统计
   sellStat = "手"+DoubleToString(s.sell_lot,2)+" | "+IntegerToString(s.sell_cnt)+"单 | $"+DoubleToString(s.sell_pnl,2);
   sellStatClr = (s.sell_pnl >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_sellStat", sellStat, rx+CD_PD, by, F(9), sellStatClr);
   by += cp_RowH + PG;

   // 全平空单 | 平盈空单 | 平亏空单
   bw3S = (RW - CD_PD*2 - PG*2) / 3;
   EBtn(g_prefix+"cp_allS","全平空单", rx+CD_PD, by, bw3S, BH, C'180,80,60', cWhite);
   EBtn(g_prefix+"cp_profS","平盈空单", rx+CD_PD+bw3S+PG, by, bw3S, BH, C'78,190,140', cWhite);
   EBtn(g_prefix+"cp_lossS","平亏空单", rx+CD_PD+bw3S*2+PG*2, by, bw3S, BH, C'230,100,97', cWhite);
   by += BH + PG;

   // 空单百分比平仓
   EBtn(g_prefix+"cp_perS_btn", "空单百分比平仓", rx+CD_PD, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_perS", "20", rx+CD_PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_perS", "抽取", rx+CD_PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'180,80,60', cWhite);
   perSVal = s.sell_lot * StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_perS",OBJPROP_TEXT)) / 100.0;
   perSAmt = s.sell_pnl * StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_perS",OBJPROP_TEXT)) / 100.0;
   perSClr = (perSAmt >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_perS_lot", DoubleToString(perSVal,2)+"=", rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG, by+3, F(9), cMute);
   ELbl(g_prefix+"cp_perS_res", (perSAmt>=0?"+":"")+DoubleToString(perSAmt,2)+"$",
        rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG+cp_LotW+PG, by+3, F(9), perSClr);
   by += cp_RowH + PG;

   // 空单固定手数平仓
   EBtn(g_prefix+"cp_fixS_btn", "空单固定手数平仓", rx+CD_PD, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_fixS", "0.01", rx+CD_PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_fixS", "抽取", rx+CD_PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'180,80,60', cWhite);
   fixSVal = StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_fixS",OBJPROP_TEXT));
   {
      clipS_fx = MathMin(fixSVal, s.sell_lot);
      fixSAmt = (s.sell_lot > 0) ? s.sell_pnl * clipS_fx / s.sell_lot : 0;
   }
   fixSClr = (fixSAmt >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_fixS_lot", DoubleToString(MathMin(fixSVal,s.sell_lot),2)+"=", rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG, by+3, F(9), cMute);
   ELbl(g_prefix+"cp_fixS_res", (fixSAmt>=0?"+":"")+DoubleToString(fixSAmt,2)+"$",
        rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG+cp_LotW+PG, by+3, F(9), fixSClr);
   by += cp_RowH + PG;

   // 空单从上向下 / 空单从下向上
   dirTxtS = g_shortCloseDir ? "空单从下向上" : "空单从上向下";
   dirClrS = C'70,72,85';  // 空单方向按钮固定灰色(不分方向)
   EBtn(g_prefix+"cp_dirS", dirTxtS, rx+CD_PD, by, cp_LblW, cp_RowH, dirClrS, cWhite);
   EEdt(g_prefix+"cp_edt_ordS", "0.01", rx+CD_PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_ordS", "抽取", rx+CD_PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'180,80,60', cWhite);
   ordSVal = StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_ordS",OBJPROP_TEXT));
   {
      clipS_or = MathMin(ordSVal, s.sell_lot);
      ordSAmt = (s.sell_lot > 0) ? s.sell_pnl * clipS_or / s.sell_lot : 0;
   }
   ordSClr = (ordSAmt >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_ordS_lot", DoubleToString(MathMin(ordSVal,s.sell_lot),2)+"=", rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG, by+3, F(9), cMute);
   ELbl(g_prefix+"cp_ordS_res", (ordSAmt>=0?"+":"")+DoubleToString(ordSAmt,2)+"$",
        rx+CD_PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+PG+cp_LotW+PG, by+3, F(9), ordSClr);

   // ===== 卡片c5: 账户信息 (右栏, 空单平仓下方) =====
   cy += CH_ACT + SG;
   ERect(g_prefix+"c5_acct",rx,cy,RW,CH_ACCOUNT,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c5_title","账户信息",rx+CD_PD,cy+CD_PD,F(12),cWhite);
   ay = cy + CD_PD + 22;

   // 第1行: 余额:1000 | 净值:1000
   accBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   accEquity  = AccountInfoDouble(ACCOUNT_EQUITY);
   balClr    = cOk;
   eqtClr    = (accEquity >= accBalance) ? cOk : cBad;
   ELbl(g_prefix+"ac_bal_lbl","余额", rx+CD_PD,           ay+2, F(10), cMute);
   ELbl(g_prefix+"ac_bal_val",DoubleToString(accBalance,2),
        rx+CD_PD+30, ay+2, F(10), balClr);
   ELbl(g_prefix+"ac_eqt_lbl","净值", rx+CD_PD+RW/2,     ay+2, F(10), cMute);
   ELbl(g_prefix+"ac_eqt_val",DoubleToString(accEquity,2),
        rx+CD_PD+RW/2+30, ay+2, F(10), eqtClr);

   // 第2行: 当天已平仓盈亏:+/-100 | 已用保证金:100
   dayPnl    = CalcTodayClosedProfit();
   usedMargin= AccountInfoDouble(ACCOUNT_MARGIN);
   dayClr    = (dayPnl   >= 0) ? cOk : cBad;
   ELbl(g_prefix+"ac_day_lbl","当天已平",
        rx+CD_PD, ay+LH+2, F(9), cMute);
   ELbl(g_prefix+"ac_day_val",(dayPnl>=0?"+":"")+DoubleToString(dayPnl,2),
        rx+CD_PD+50, ay+LH+2, F(9), dayClr);
   ELbl(g_prefix+"ac_mgn_lbl","保证金",
        rx+CD_PD+RW/2, ay+LH+2, F(9), cMute);
   ELbl(g_prefix+"ac_mgn_val",DoubleToString(usedMargin,2),
        rx+CD_PD+RW/2+45, ay+LH+2, F(9), cWhite);

   // 第3行: 累计已平仓:+1000
   totalPnl2 = CalcTotalClosedProfit();
   totClr    = (totalPnl2 >= 0) ? cOk : cBad;
   ELbl(g_prefix+"ac_tot_lbl","累计已平仓",
        rx+CD_PD, ay+2*LH+2, F(9), cMute);
   ELbl(g_prefix+"ac_tot_val",(totalPnl2>=0?"+":"")+DoubleToString(totalPnl2,2),
        rx+CD_PD+60, ay+2*LH+2, F(9), totClr);

   // 折叠按钮
   DrawToggle();
}
//+------------------------------------------------------------------+
//| 刷新                                                              |
//+------------------------------------------------------------------+
void RefreshPanel(bool force)
{
   datetime now = TimeCurrent();
   if(!force && now==g_lastRefresh) return;
   EAStats s; CollectStats(s);
   DrawPanel(s);
   if(g_panel_dragging) SetPanelDragHighlight(true);
   g_lastRefresh = now;
}
//+------------------------------------------------------------------+
//| 参数持久化 (GlobalVariable)                                        |
//+------------------------------------------------------------------+
void SaveParamsToGV()
{
   GlobalVariableSet(g_prefix+"lot_manual", g_lot_manual);
   GlobalVariableSet(g_prefix+"lot_base_buy", g_lot_base_buy);
   GlobalVariableSet(g_prefix+"lot_base_sell", g_lot_base_sell);
   GlobalVariableSet(g_prefix+"tp",  g_tp);
   GlobalVariableSet(g_prefix+"sl",  g_sl);
   GlobalVariableSet(g_prefix+"lockDD",   g_lockDrawdownUSD);
   GlobalVariableSet(g_prefix+"gridBuy",  (double)g_allow_grid_buy);
   GlobalVariableSet(g_prefix+"gridSell", (double)g_allow_grid_sell);
   GlobalVariableSet(g_prefix+"maxLayersB",(double)g_maxLayersBuy);
   GlobalVariableSet(g_prefix+"maxLayersS",(double)g_maxLayersSell);
   GlobalVariableSet(g_prefix+"lotIncB",   g_lotIncrementBuy);
   GlobalVariableSet(g_prefix+"lotIncS",   g_lotIncrementSell);
   GlobalVariableSet(g_prefix+"maxLotsB",   g_maxTotalLotsBuy);
   GlobalVariableSet(g_prefix+"maxLotsS",   g_maxTotalLotsSell);
   GlobalVariableSet(g_prefix+"expFactorB", g_gridExpFactorBuy);
   GlobalVariableSet(g_prefix+"expFactorS", g_gridExpFactorSell);
}
bool LoadParamsFromGV()
{
   if(!GlobalVariableCheck(g_prefix+"lot_manual")) return false;
   if(!GlobalVariableCheck(g_prefix+"tp"))  return false;
   if(!GlobalVariableCheck(g_prefix+"sl"))  return false;
   g_lot_manual = GlobalVariableGet(g_prefix+"lot_manual");
   g_lot_base_buy = GlobalVariableGet(g_prefix+"lot_base_buy");
   g_lot_base_sell = GlobalVariableGet(g_prefix+"lot_base_sell");
   g_tp  = (int)GlobalVariableGet(g_prefix+"tp");
   g_sl  = (int)GlobalVariableGet(g_prefix+"sl");
   if(g_lot_manual<=0) g_lot_manual=InpLotSize;
   if(g_lot_base_buy<=0) g_lot_base_buy=InpLotSize;
   if(g_lot_base_sell<=0) g_lot_base_sell=InpLotSize;
   // 0 是合法值 = 不启用止盈/止损，不要覆盖
   // 加载面板可修改的运行时参数(如果存在)
   if(GlobalVariableCheck(g_prefix+"lockDD"))    g_lockDrawdownUSD = GlobalVariableGet(g_prefix+"lockDD");
   if(GlobalVariableCheck(g_prefix+"gridBuy"))   g_allow_grid_buy  = (GlobalVariableGet(g_prefix+"gridBuy")>0);
   if(GlobalVariableCheck(g_prefix+"gridSell"))  g_allow_grid_sell = (GlobalVariableGet(g_prefix+"gridSell")>0);
   if(GlobalVariableCheck(g_prefix+"maxLayersB")) g_maxLayersBuy  = (int)GlobalVariableGet(g_prefix+"maxLayersB");
   if(GlobalVariableCheck(g_prefix+"maxLayersS")) g_maxLayersSell = (int)GlobalVariableGet(g_prefix+"maxLayersS");
   if(GlobalVariableCheck(g_prefix+"lotIncB"))   g_lotIncrementBuy  = GlobalVariableGet(g_prefix+"lotIncB");
   if(GlobalVariableCheck(g_prefix+"lotIncS"))   g_lotIncrementSell = GlobalVariableGet(g_prefix+"lotIncS");
   if(GlobalVariableCheck(g_prefix+"maxLotsB"))   g_maxTotalLotsBuy  = GlobalVariableGet(g_prefix+"maxLotsB");
   if(GlobalVariableCheck(g_prefix+"maxLotsS"))   g_maxTotalLotsSell = GlobalVariableGet(g_prefix+"maxLotsS");
   if(GlobalVariableCheck(g_prefix+"expFactorB")) g_gridExpFactorBuy  = GlobalVariableGet(g_prefix+"expFactorB");
   if(GlobalVariableCheck(g_prefix+"expFactorS")) g_gridExpFactorSell = GlobalVariableGet(g_prefix+"expFactorS");
   return true;
}
//| 读取输入框                                                        |
//+------------------------------------------------------------------+
void ReadEdits()
{
   string t;
   double v;
   if(ObjectFind(0,g_prefix+"e1_lot_manual")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e1_lot_manual",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_lot_manual=v;
   }
   if(ObjectFind(0,g_prefix+"e1_lot_buy")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e1_lot_buy",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_lot_base_buy=v;
   }
   if(ObjectFind(0,g_prefix+"e1_lot_sell")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e1_lot_sell",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_lot_base_sell=v;
   }
   if(ObjectFind(0,g_prefix+"e1_tp")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e1_tp",OBJPROP_TEXT);
      g_tp=(int)StringToInteger(t); // 0=不启用止盈
   }
   if(ObjectFind(0,g_prefix+"e1_sl")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e1_sl",OBJPROP_TEXT);
      g_sl=(int)StringToInteger(t); // 0=不启用止损
   }
   if(ObjectFind(0,g_prefix+"e3_lock")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e3_lock",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_lockDrawdownUSD=v;
   }
   if(ObjectFind(0,g_prefix+"e6_maxLB")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e6_maxLB",OBJPROP_TEXT);
      v=(double)StringToInteger(t); if(v>0) g_maxLayersBuy=(int)v;
   }
   if(ObjectFind(0,g_prefix+"e6_maxLS")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e6_maxLS",OBJPROP_TEXT);
      v=(double)StringToInteger(t); if(v>0) g_maxLayersSell=(int)v;
   }
   if(ObjectFind(0,g_prefix+"e7_incB")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e7_incB",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_lotIncrementBuy=v;
   }
   if(ObjectFind(0,g_prefix+"e7_incS")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e7_incS",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_lotIncrementSell=v;
   }
   // 风险防护参数
   if(ObjectFind(0,g_prefix+"e8_maxLB")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e8_maxLB",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_maxTotalLotsBuy=v;
   }
   if(ObjectFind(0,g_prefix+"e8_maxLS")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e8_maxLS",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_maxTotalLotsSell=v;
   }
   if(ObjectFind(0,g_prefix+"e10_expB")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e10_expB",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>=1.0) g_gridExpFactorBuy=v;
   }
   if(ObjectFind(0,g_prefix+"e10_expS")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e10_expS",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>=1.0) g_gridExpFactorSell=v;
   }
   SaveParamsToGV();
}
//+------------------------------------------------------------------+
//| 统计                                                              |
//+------------------------------------------------------------------+
void CollectStats(EAStats &s)
{
   double p;

   ZeroMemory(s);
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol) continue;
      int mg = (int)m_pos.Magic();
      if(mg!=g_currentMagic && mg!=g_manualMagic) continue;
      p=m_pos.Profit()+m_pos.Swap();
      s.pnl+=p;
      if(m_pos.PositionType()==POSITION_TYPE_BUY)
         { s.buy_cnt++; s.buy_lot+=m_pos.Volume(); s.buy_pnl+=p; }
      else
         { s.sell_cnt++; s.sell_lot+=m_pos.Volume(); s.sell_pnl+=p; }
   }
   for(int i=OrdersTotal()-1;i>=0;i--)
   {
      ulong tk=OrderGetTicket(i);
      if(tk<=0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      int omg = (int)OrderGetInteger(ORDER_MAGIC);
      if(omg!=g_currentMagic && omg!=g_manualMagic) continue;
      if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_STOP
         ||OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT)
         s.buy_pending++;
      else
         s.sell_pending++;
   }
}
int CountDir(ENUM_POSITION_TYPE dir)
{
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(m_pos.SelectByIndex(i)&&m_pos.Symbol()==_Symbol&&m_pos.Magic()==g_currentMagic
         &&m_pos.PositionType()==dir) n++;
   return n;
}
//+------------------------------------------------------------------+
//| 状态同步: 用实际持仓校正内部计数器                                   |
//| 解决外部平仓(手动/其他EA)导致的 g_gridLayer/g_gridLastBuy/Sell 失准  |
//+------------------------------------------------------------------+
void SyncStateFromPositions()
{
   int    actualBuyCnt=0, actualSellCnt=0;
   double lastBuyPrice=0, lastSellPrice=0;
   datetime lastBuyTime=0, lastSellTime=0;

   // 遍历本EA魔术码的所有持仓, 统计单数 + 找最近开仓价
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol || m_pos.Magic()!=g_currentMagic) continue;

      if(m_pos.PositionType()==POSITION_TYPE_BUY)
      {
         actualBuyCnt++;
         datetime t = (datetime)m_pos.Time();
         if(t > lastBuyTime)
         {
            lastBuyTime  = t;
            lastBuyPrice = m_pos.PriceOpen();
         }
      }
      else if(m_pos.PositionType()==POSITION_TYPE_SELL)
      {
         actualSellCnt++;
         datetime t = (datetime)m_pos.Time();
         if(t > lastSellTime)
         {
            lastSellTime  = t;
            lastSellPrice = m_pos.PriceOpen();
         }
      }
   }

   // ── 校正层数: 实际单数 - 1 (首单不算层) ──
   int totalPos = actualBuyCnt + actualSellCnt;
   int newLayer = (totalPos > 0) ? MathMax(0, totalPos - 1) : 0;

   // ── 检测变化并打印日志(只在变化时打印, 避免刷屏) ──
   if(newLayer != g_gridLayer || (actualBuyCnt==0) != (g_gridLastBuy==0) || (actualSellCnt==0) != (g_gridLastSell==0))
   {
      Print("[状态同步] 层数:", g_gridLayer, "→", newLayer,
            " 多单:", actualBuyCnt, " 空单:", actualSellCnt,
            " (检测到外部平仓, 已自动校正)");
   }

   g_gridLayer = newLayer;

   // ── 校正参考价: 用最近开仓价, 没有就清零 ──
   g_gridLastBuy  = (actualBuyCnt  > 0) ? lastBuyPrice  : 0;
   g_gridLastSell = (actualSellCnt > 0) ? lastSellPrice : 0;

   // ── 手数基数恢复: 用面板当前手数 (外部平仓后无法精确反推) ──
   if(totalPos == 0) { g_lot_base_buy = g_lot_manual; g_lot_base_sell = g_lot_manual; }
}
//+------------------------------------------------------------------+
//| 指标                                                              |
//+------------------------------------------------------------------+
double Pt(){ return SymbolInfoDouble(_Symbol,SYMBOL_POINT); }
// D1 EMA14 (入场信号)
double GetEMA(int shift=1)
{
   double v[1];
   return CopyBuffer(g_emaHandle,0,shift,1,v)>0 ? v[0] : 0;
}
int DetectTrend()
{
   double c  = iClose(_Symbol,InpEMA_TF,1);
   double ema= GetEMA(1);
   if(c<=0||ema<=0) return 0;
   if(c>ema) return 1;
   if(c<ema) return -1;
   return 0;
}
// 获取网格MA句柄的值 (handleIdx: 0=H4, 1=H1, ..., 6=M1)
double GetGridMA(int handleIdx, int shift=1)
{
   double v[1];
   if(CopyBuffer(g_maHandle[handleIdx],0,shift,1,v)<=0) return 0;
   return v[0];
}
// 获取网格MA的方向: 1=上, -1=下, 0=平
int GetGridMADir(int handleIdx, int shift=1)
{
   double ma;
   double cl;
   ma = GetGridMA(handleIdx, shift);
   if(ma<=0) return 0;
   ENUM_TIMEFRAMES tf = g_gridTF[handleIdx];
   cl = iClose(_Symbol,tf,shift);
   if(cl<=0) return 0;
   if(cl>ma) return 1;
   if(cl<ma) return -1;
   return 0;
}
// 检查7周期(H4→M1) MA是否全部与趋势同向
bool AllGridSameDir(int trendDir)
{
   for(int i=0; i<7; i++)
   {
      int dir = GetGridMADir(i, 1);
      bool isSame = (trendDir==1 && dir==1) || (trendDir==-1 && dir==-1);
      if(!isSame) return false;
   }
   return true;
}
//+------------------------------------------------------------------+
//| 市场状态检查                                                       |
//+------------------------------------------------------------------+
bool IsMarketOpen()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   // 检查周末 (周六/周日)
   if(dt.day_of_week==0 || dt.day_of_week==6) return false;
   return SymbolInfoInteger(_Symbol, SYMBOL_TRADE_MODE)==SYMBOL_TRADE_MODE_FULL;
}
bool CanTrade()
{
   string msg;
   if(!IsMarketOpen())
   {
      msg = "市场休市";
      if(TimeCurrent()-g_lastFailTime>60 || g_lastFailMsg!=msg)
      {
         Print("[交易] ",msg," - ",_Symbol," 无法开单");
         g_lastFailTime = TimeCurrent();
         g_lastFailMsg  = msg;
      }
      return false;
   }
   // 上次失败60秒内不重复报错（防刷屏）
   if(g_lastFailTime>0 && TimeCurrent()-g_lastFailTime<60)
      return false;
   return true;
}
void OnOrderFailed(const string msg)
{
   Print("[开单失败] ",msg);
   g_lastFailTime = TimeCurrent();
   g_lastFailMsg  = msg;
}
//+------------------------------------------------------------------+
//| 多周期MA10逆势间距计算 (7周期: H4/H1/M30/M15/M5/M3/M1)              |
//| 指数级间距: 基础间距 × 倍数^深度                                       |
//+------------------------------------------------------------------+
int CalcCounterTrendInterval(const int trendDir)
{
   // 从H4→M1扫描, 找到最深(最大)的逆向周期
   // 深度: M1=1, M3=2, M5=3, M15=4, M30=5, H1=6, H4=7
   int maxCounterDepth = 0;
   for(int i=0; i<7; i++)  // i=0=H4, i=1=H1, ..., i=6=M1
   {
      int dir = GetGridMADir(i, 1);
      bool isCounter = (trendDir==1 && dir==-1) || (trendDir==-1 && dir==1);
      if(isCounter && maxCounterDepth==0)
         maxCounterDepth = 7 - i;  // H4=7, M1=1
   }
   if(maxCounterDepth == 0)
      return 0;  // 全部同向 → 无逆势间距(用顺势间距)
   if(maxCounterDepth == 7)
      return -1; // 全部逆向 → 不加仓
   // 指数级间距 = 基础间距(100点) × 倍数^(深度-1)
   // 深度1: 100 × 1.5^0 = 100点
   // 深度2: 100 × 1.5^1 = 150点
   // 深度3: 100 × 1.5^2 = 225点
   // 深度4: 100 × 1.5^3 = 337点
   // 深度5: 100 × 1.5^4 = 506点
   // 深度6: 100 × 1.5^5 = 759点
   double expFactor = (trendDir==1)
      ? ((g_gridExpFactorBuy > 1.0) ? g_gridExpFactorBuy : 1.5)
      : ((g_gridExpFactorSell > 1.0) ? g_gridExpFactorSell : 1.5);
   double baseInterval = 100.0;
   double expInterval = baseInterval * MathPow(expFactor, maxCounterDepth - 1);
   // 扣减: 比最大逆向层更小的周期如果恢复了(同向), 每层-10点(最多扣减基础的30%)
   int recoverySubtract = 0;
   int startCheckIdx = 8 - maxCounterDepth; // 最大逆向层索引+1
   for(int i=startCheckIdx; i<7; i++)
   {
      int dir = GetGridMADir(i, 1);
      bool isSame = (trendDir==1 && dir==1) || (trendDir==-1 && dir==-1);
      if(isSame) recoverySubtract += 10;
   }
   int result = (int)MathRound(expInterval - recoverySubtract);
   // 不低于本级基数 (深度×100的线性值)
   int minInterval = maxCounterDepth * 100;
   if(result < minInterval) result = minInterval;
   return result;
}
//+------------------------------------------------------------------+
//| 获取逆向深度 (面板/止盈共用)                                          |
//+------------------------------------------------------------------+
int GetCounterDepth(const int trendDir)
{
   for(int i=0; i<7; i++)
   {
      int dir = GetGridMADir(i, 1);
      bool isCounter = (trendDir==1 && dir==-1) || (trendDir==-1 && dir==1);
      if(isCounter) return 7 - i;
   }
   return 0;
}
//+------------------------------------------------------------------+
//| 计算同方向总持仓手数 (当前魔术码)                                    |
//+------------------------------------------------------------------+
double GetDirTotalLots(ENUM_POSITION_TYPE dir)
{
   double total = 0;
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(m_pos.SelectByIndex(i)&&m_pos.Symbol()==_Symbol&&m_pos.Magic()==g_currentMagic
         &&m_pos.PositionType()==dir) total += m_pos.Volume();
   return total;
}
//+------------------------------------------------------------------+
//| 交易操作                                                          |
//+------------------------------------------------------------------+
void DoBuy()
{
   if(g_locked){ Print("[锁仓] 已冻结, 禁止开多");return; }
   double ask;
   double lot;
   ReadEdits();
   if(!g_allow_buy){ Print("[面板]多单已暂停");return; }
   if(!CanTrade()) return;
   // 检查最大层数 (多单)
   if(g_gridLayer >= g_maxLayersBuy && g_maxLayersBuy > 0)
   {
      Print("[网格加仓] 多单已达最大层数 ",g_maxLayersBuy,", 停止加仓");
      return;
   }
   // 检查总手数上限
   double curLots = GetDirTotalLots(POSITION_TYPE_BUY);
   double nextLot = g_lot_base_buy + g_gridLayer * g_lotIncrementBuy;
   if(nextLot < InpLotSize) nextLot = InpLotSize;
   if(g_maxTotalLotsBuy > 0 && curLots + nextLot > g_maxTotalLotsBuy)
   {
      Print("[风险防护] 多单总手数 ", DoubleToString(curLots,2), "+", DoubleToString(nextLot,2),
            " > 上限 ", DoubleToString(g_maxTotalLotsBuy,2), " 手, 停止加仓");
      return;
   }
   // 计算递增手数
   lot = nextLot;
   ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   m_trade.SetExpertMagicNumber(g_currentMagic);
   if(m_trade.Buy(lot,_Symbol,ask,0,0,"EMA多"))
   {
      Print("[开多] ",_Symbol," @ ",ask," 手数:",lot,
            " 层数:",g_gridLayer,
            " SL/TP=主动监听");
      g_lastFailTime = 0; // 成功后清除失败标记
      g_gridLastBuy  = ask; // 更新网格参考价
      g_gridLayer++;        // 层数+1
   }
   else
      OnOrderFailed(m_trade.ResultRetcodeDescription());
}
void DoSell()
{
   if(g_locked){ Print("[锁仓] 已冻结, 禁止开空");return; }
   double bid;
   double lot;

   ReadEdits();
   if(!g_allow_sell){ Print("[面板]空单已暂停");return; }
   if(!CanTrade()) return;
   // 检查最大层数 (空单)
   if(g_gridLayer >= g_maxLayersSell && g_maxLayersSell > 0)
   {
      Print("[网格加仓] 空单已达最大层数 ",g_maxLayersSell,", 停止加仓");
      return;
   }
   // 检查总手数上限
   double curLots = GetDirTotalLots(POSITION_TYPE_SELL);
   double nextLot = g_lot_base_sell + g_gridLayer * g_lotIncrementSell;
   if(nextLot < InpLotSize) nextLot = InpLotSize;
   if(g_maxTotalLotsSell > 0 && curLots + nextLot > g_maxTotalLotsSell)
   {
      Print("[风险防护] 空单总手数 ", DoubleToString(curLots,2), "+", DoubleToString(nextLot,2),
            " > 上限 ", DoubleToString(g_maxTotalLotsSell,2), " 手, 停止加仓");
      return;
   }
   // 计算递增手数
   lot = nextLot;
   bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   m_trade.SetExpertMagicNumber(g_currentMagic);
   if(m_trade.Sell(lot,_Symbol,bid,0,0,"EMA空"))
   {
      Print("[开空] ",_Symbol," @ ",bid," 手数:",lot,
            " 层数:",g_gridLayer,
            " SL/TP=主动监听");
      g_lastFailTime = 0; // 成功后清除失败标记
      g_gridLastSell = bid; // 更新网格参考价
      g_gridLayer++;        // 层数+1
   }
   else
      OnOrderFailed(m_trade.ResultRetcodeDescription());
}
//+------------------------------------------------------------------+
//| 手动开多 (独立魔术码, 不参与自动网格/止盈止损, 由面板TP/SL管理)       |
//+------------------------------------------------------------------+
void DoManualBuy()
{
   if(g_locked){ Print("[锁仓] 已冻结, 禁止手动开多");return; }
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   ReadEdits();
   double lot = g_lot_manual;
   if(lot < InpLotSize) lot = InpLotSize;
   m_trade.SetExpertMagicNumber(g_manualMagic);
   if(m_trade.Buy(lot,_Symbol,ask,0,0,"手动多"))
      Print("[手动开多] ",_Symbol," @ ",ask," 手数:",lot," 魔术码:",g_manualMagic,
            " TP=",g_tp," SL=",g_sl," (独立管理)");
   else
      OnOrderFailed(m_trade.ResultRetcodeDescription());
   m_trade.SetExpertMagicNumber(g_currentMagic); // 还原自动策略魔术码
}
//+------------------------------------------------------------------+
//| 手动开空 (独立魔术码, 不参与自动网格/止盈止损, 由面板TP/SL管理)       |
//+------------------------------------------------------------------+
void DoManualSell()
{
   if(g_locked){ Print("[锁仓] 已冻结, 禁止手动开空");return; }
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   ReadEdits();
   double lot = g_lot_manual;
   if(lot < InpLotSize) lot = InpLotSize;
   m_trade.SetExpertMagicNumber(g_manualMagic);
   if(m_trade.Sell(lot,_Symbol,bid,0,0,"手动空"))
      Print("[手动开空] ",_Symbol," @ ",bid," 手数:",lot," 魔术码:",g_manualMagic,
            " TP=",g_tp," SL=",g_sl," (独立管理)");
   else
      OnOrderFailed(m_trade.ResultRetcodeDescription());
   m_trade.SetExpertMagicNumber(g_currentMagic); // 还原自动策略魔术码
}
//+------------------------------------------------------------------+
//| 手动单TP/SL管理 (按面板输入的g_tp/g_sl, 只管理g_manualMagic)         |
//+------------------------------------------------------------------+
void ManageManualTPSL()
{
   if(g_locked) return;  // 锁仓后完全冻结, 禁止手动单TP/SL平仓
   if(g_tp <= 0 && g_sl <= 0) return;  // 面板TP/SL都为0 → 不管理
   double pt  = Pt();
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol || m_pos.Magic()!=g_manualMagic) continue;
      double open = m_pos.PriceOpen();
      double profit = m_pos.Profit() + m_pos.Swap();
      // 多单: TP=均价+g_tp点, SL=均价-g_sl点
      if(m_pos.PositionType()==POSITION_TYPE_BUY)
      {
         if(g_tp > 0 && bid >= open + g_tp*pt)
         {
            Print("[手动单TP-多] 平仓 票号:",m_pos.Ticket()," 盈利:$",DoubleToString(profit,2));
            m_trade.PositionClose(m_pos.Ticket());
            continue;
         }
         if(g_sl > 0 && bid <= open - g_sl*pt)
         {
            Print("[手动单SL-多] 平仓 票号:",m_pos.Ticket()," 亏损:$",DoubleToString(profit,2));
            m_trade.PositionClose(m_pos.Ticket());
            continue;
         }
      }
      // 空单: TP=均价-g_tp点, SL=均价+g_sl点
      if(m_pos.PositionType()==POSITION_TYPE_SELL)
      {
         if(g_tp > 0 && ask <= open - g_tp*pt)
         {
            Print("[手动单TP-空] 平仓 票号:",m_pos.Ticket()," 盈利:$",DoubleToString(profit,2));
            m_trade.PositionClose(m_pos.Ticket());
            continue;
         }
         if(g_sl > 0 && ask >= open + g_sl*pt)
         {
            Print("[手动单SL-空] 平仓 票号:",m_pos.Ticket()," 亏损:$",DoubleToString(profit,2));
            m_trade.PositionClose(m_pos.Ticket());
            continue;
         }
      }
   }
}
void CloseEaOrders(const int dir, const bool only_profit, const bool only_loss)
{
   double p;
   int pt;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol) continue;
      int mg = (int)m_pos.Magic();
      if(mg!=g_currentMagic && mg!=g_manualMagic) continue;
      pt = (int)m_pos.PositionType();
      if(dir==1  && pt!=POSITION_TYPE_BUY)  continue;
      if(dir==-1 && pt!=POSITION_TYPE_SELL) continue;
      p = m_pos.Profit()+m_pos.Swap();
      if(only_profit && p<=0) continue;
      if(only_loss  && p>=0) continue;
      m_trade.PositionClose(m_pos.Ticket());
   }
}
void CloseDir(ENUM_POSITION_TYPE dir)
{
   CloseEaOrders(dir==POSITION_TYPE_BUY?1:-1,false,false);
   // 手动点击平仓后重置层数
   if(dir==POSITION_TYPE_BUY)  { g_gridLastBuy=0;  g_gridLayer=0; g_lot_base_buy=g_lot_manual; }
   if(dir==POSITION_TYPE_SELL){ g_gridLastSell=0; g_gridLayer=0; g_lot_base_sell=g_lot_manual; }
}
//+------------------------------------------------------------------+
//| 平仓所有本EA订单                                                   |
//+------------------------------------------------------------------+
void CloseAllEaOrders()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol) continue;
      // 平掉所有本EA的订单(按魔术码识别)
      if(m_pos.Magic()==InpMagicNumber)
      {
         m_trade.PositionClose(m_pos.Ticket());
      }
   }
}
//+------------------------------------------------------------------+
//| 平多单 (面板按钮)                                                 |
//+------------------------------------------------------------------+
void CloseBuy()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(m_pos.SelectByIndex(i)&&m_pos.Symbol()==_Symbol&&m_pos.Magic()==g_currentMagic
         &&m_pos.PositionType()==POSITION_TYPE_BUY) m_trade.PositionClose(m_pos.Ticket());
   g_gridLastBuy=0;
   g_gridLayer=0;
   g_lot_base_buy=g_lot_manual;
}
//+------------------------------------------------------------------+
//| 平空单 (面板按钮)                                                 |
//+------------------------------------------------------------------+
void CloseSell()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(m_pos.SelectByIndex(i)&&m_pos.Symbol()==_Symbol&&m_pos.Magic()==g_currentMagic
         &&m_pos.PositionType()==POSITION_TYPE_SELL) m_trade.PositionClose(m_pos.Ticket());
   g_gridLastSell=0;
   g_gridLayer=0;
   g_lot_base_sell=g_lot_manual;
}
void CloseAll()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(m_pos.SelectByIndex(i)&&m_pos.Symbol()==_Symbol&&m_pos.Magic()==g_currentMagic)
         m_trade.PositionClose(m_pos.Ticket());
   g_gridLastBuy=0;
   g_gridLastSell=0;
   g_gridLayer=0;
   g_lot_base_buy=g_lot_manual;
   g_lot_base_sell=g_lot_manual;
}
//+------------------------------------------------------------------+
//| 跑马灯止盈止损 (篮子止盈+独立止损)                                    |
//| 止盈: 同方向加权均价 ± 动态TP(跑马灯浮动) → 全平该方向                |
//| 止损: 每单独立点数止损                                               |
//+------------------------------------------------------------------+
void CheckTPSL()
{
   double pt;
   double bid;
   double ask;
   double v;
   double buyVol;
   double buyWeighted;
   double sellVol;
   double sellWeighted;

   pt=Pt();
   bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   int digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   int cDepth = GetCounterDepth(g_trend);       // 当前逆向深度(0-7)
   int layers  = g_gridLayer;                    // 当前加仓层数
   // ── 跑马灯篮子止盈 ──
   if(g_tp > 0)
   {
      // 动态TP: 基础200 - 层数*20 + 逆向深度*25, 最低50, 最高400
      int dynTP = InpTakeProfit - (layers) * 20 + cDepth * 25;
      if(dynTP < 50)  dynTP = 50;
      if(dynTP > 400) dynTP = 400;
      // ── 多单篮子 ──
      buyVol=0;
      buyWeighted=0;
      int buyCnt=0;
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         if(!m_pos.SelectByIndex(i)) continue;
         if(m_pos.Symbol()!=_Symbol || m_pos.Magic()!=g_currentMagic) continue;
         if(m_pos.PositionType()!=POSITION_TYPE_BUY) continue;
         v=m_pos.Volume();
         buyVol+=v; buyWeighted+=m_pos.PriceOpen()*v; buyCnt++;
      }
      if(buyCnt>0 && bid >= buyWeighted/buyVol + dynTP*pt)
      {
         Print("════════════════════════════════");
         Print("[跑马灯止盈-多] 均价:",DoubleToString(buyWeighted/buyVol,digits),
               " 动态TP:",dynTP,"点 层数:",buyCnt," 深度:",cDepth);
         Print("════════════════════════════════");
         CloseDir(POSITION_TYPE_BUY);
      }
      // ── 空单篮子 ──
      sellVol=0;
      sellWeighted=0;
      int sellCnt=0;
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         if(!m_pos.SelectByIndex(i)) continue;
         if(m_pos.Symbol()!=_Symbol || m_pos.Magic()!=g_currentMagic) continue;
         if(m_pos.PositionType()!=POSITION_TYPE_SELL) continue;
         v=m_pos.Volume();
         sellVol+=v; sellWeighted+=m_pos.PriceOpen()*v; sellCnt++;
      }
      if(sellCnt>0 && ask <= sellWeighted/sellVol - dynTP*pt)
      {
         Print("════════════════════════════════");
         Print("[跑马灯止盈-空] 均价:",DoubleToString(sellWeighted/sellVol,digits),
               " 动态TP:",dynTP,"点 层数:",sellCnt," 深度:",cDepth);
         Print("════════════════════════════════");
         CloseDir(POSITION_TYPE_SELL);
      }
   }
}
//+------------------------------------------------------------------+
//| 计算同方向浮亏金额 (当前魔术码, 返回正数)                           |
//+------------------------------------------------------------------+
double GetDirDrawdown(ENUM_POSITION_TYPE dir)
{
   double dd = 0;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol || m_pos.Magic()!=g_currentMagic) continue;
      if(m_pos.PositionType()!=dir) continue;
      double p = m_pos.Profit() + m_pos.Swap();
      if(p < 0) dd += -p;
   }
   return dd;
}
//+------------------------------------------------------------------+
//| 锁仓检测: 同方向浮亏达阈值 → 完全冻结 + 停止EA (待人工介入)          |
//+------------------------------------------------------------------+
void CheckLock()
{
   if(g_locked) return;  // 已锁仓, 不重复检测
   if(g_lockDrawdownUSD <= 0) return;  // 阈值为0 → 不启用锁仓
   double buyDD  = GetDirDrawdown(POSITION_TYPE_BUY);
   double sellDD = GetDirDrawdown(POSITION_TYPE_SELL);
   if(buyDD >= g_lockDrawdownUSD || sellDD >= g_lockDrawdownUSD)
   {
      g_locked = true;
      Print("════════════════════════════════");
      Print("[锁仓] 浮亏达阈值 → 完全冻结, 等待人工介入");
      Print("[锁仓] 多浮亏:$", DoubleToString(buyDD,2),
            " 空浮亏:$", DoubleToString(sellDD,2),
            " 阈值:$", DoubleToString(g_lockDrawdownUSD,2));
      Print("[锁仓] 所有开仓/加仓/平仓已暂停, EA将停止运行");
      Print("════════════════════════════════");
      ExpertRemove();  // 停止EA, 等待人工介入
   }
}
//+------------------------------------------------------------------+
//| 网格加仓检测                                                       |
//+------------------------------------------------------------------+
void CheckGrid()
{
   double bid;
   double ask;
   double pt;
   int counterInt;

   if(g_trend==0) return;
   if(g_locked) return;  // 锁仓后完全冻结, 不加仓
   if(g_isAsyncClosing) return;  // 异步平仓期间禁止加仓
   bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   pt  = Pt();
   // 计算动态逆势间距
   int rawInterval = CalcCounterTrendInterval(g_trend);
   // 全部逆向 → 不加仓
   if(rawInterval == -1)
   {
      g_gridCounterInterval = -1;
      return;
   }
   counterInt  = rawInterval;
   // 浮动逻辑: 基于上次间距调整
   if(g_gridLastDepth > 0)
   {
      if(rawInterval > g_gridLastDepth)
      {
         // 逆向加深 → 间距扩大 (+100点/层)
         counterInt = g_gridCounterInterval + 100;
      }
      else if(rawInterval < g_gridLastDepth)
      {
         // 同向恢复 → 间距缩小 (-10点/恢复周期)
         int recovered = g_gridLastDepth - rawInterval;
         counterInt = g_gridCounterInterval - recovered * 10;
         int curDepth = GetCounterDepth(g_trend);
         int minBase = curDepth * 100;  // 本级线性基数: 深度×100点
         if(counterInt < minBase) counterInt = minBase;  // 不低于本级基数
      }
      // 深度不变 → 间距不变
   }
   g_gridLastBar = iTime(_Symbol,PERIOD_CURRENT,0);
   g_gridLastDepth = rawInterval;
   g_gridCounterInterval = counterInt;
   int withInt = g_gridWithTrend;
   // 注: 浮亏锁仓检测已移至 OnTick (CheckLock), 达阈值后 g_locked=true 完全冻结
   // ── 多头网格: 逆势=价格下跌, 顺势=价格上涨 ──
   if(g_trend==1 && g_allow_buy && g_allow_grid_buy && g_gridLastBuy>0)
   {
      // 逆势加仓
      if(counterInt > 0 && bid <= g_gridLastBuy - counterInt * pt)
      {
         Print("[网格加仓-逆势] 多头 间隔=",IntegerToString(counterInt),"点 价格=",DoubleToString(bid,(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS)));
         DoBuy();
         return;
      }
      // 顺势加仓: 仅当7周期MA全部同向
      if(withInt > 0 && AllGridSameDir(g_trend) && ask >= g_gridLastBuy + withInt * pt)
      {
         Print("[网格加仓-顺势] 多头 7周期全同向 间隔=",IntegerToString(withInt),"点 价格=",DoubleToString(ask,(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS)));
         DoBuy();
         return;
      }
   }
   // ── 空头网格: 逆势=价格上涨, 顺势=价格下跌 ──
   if(g_trend==-1 && g_allow_sell && g_allow_grid_sell && g_gridLastSell>0)
   {
      // 逆势加仓
      if(counterInt > 0 && ask >= g_gridLastSell + counterInt * pt)
      {
         Print("[网格加仓-逆势] 空头 间隔=",IntegerToString(counterInt),"点 价格=",DoubleToString(ask,(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS)));
         DoSell();
         return;
      }
      // 顺势加仓: 仅当7周期MA全部同向
      if(withInt > 0 && AllGridSameDir(g_trend) && bid <= g_gridLastSell - withInt * pt)
      {
         Print("[网格加仓-顺势] 空头 7周期全同向 间隔=",withInt,"点 价格=",bid);
         DoSell();
         return;
      }
   }
}
//+------------------------------------------------------------------+
//| 入场(首单+网格)                                                     |
//+------------------------------------------------------------------+
void CheckEntry()
{
   if(!g_allow_buy&&!g_allow_sell) return;
   if(g_trend==0) return;
   if(g_isAsyncClosing) return;  // 异步平仓期间禁止开新仓/加仓
   // 首单: 该方向无持仓时才开
   if(g_trend==1 && CountDir(POSITION_TYPE_BUY)==0)
   {
      DoBuy(); return;
   }
   if(g_trend==-1 && CountDir(POSITION_TYPE_SELL)==0)
   {
      DoSell(); return;
   }
   // 网格加仓
   CheckGrid();
}
//+------------------------------------------------------------------+
//| 按钮事件处理                                                       |
//+------------------------------------------------------------------+
void HandlePanelButtonClick(const string sparam)
{
   double lots;
   double pct;
   string t;
   double targetLots;
   string dirDesc;
   string k;
   string msg;

   EAStats stats;
   k = StringSubstr(sparam, StringLen(g_prefix));
   CollectStats(stats);
   // ── 折叠/展开 ──
   if(k == "toggle_panel")
   {
      ResetPanelButtonState(sparam);
      if(g_panel_open)
      {
         if(!ShowConfirmDialog("确定要隐藏操作面板吗？\n隐藏后可在左下角点击「展开」恢复。"))
            return;
      }
      g_panel_open = !g_panel_open;
      g_panel_dragging = false;
      SetPanelDragHighlight(false);
      RefreshPanel(true);
      return;
   }
   if(!g_panel_open) return;
   // ── 停止全部 ──
   if(k == "btn_stop_all")
   {
      ResetPanelButtonState(sparam);
      bool run = (g_allow_buy || g_allow_sell);
      if(run)
      {
         if(!ShowConfirmDialog("确定要停止全部交易吗？\n将暂停多空新开单，已有持仓保留。"))
            return;
      }
      else
      {
         if(!ShowConfirmDialog("确定要开启全部交易吗？"))
            return;
      }
      g_allow_buy = !run;
      g_allow_sell = !run;
      RefreshPanel(true);
      return;
   }
   // ── 停止做多 ──
   if(k == "btn_stop_buy")
   {
      ResetPanelButtonState(sparam);
      if(g_allow_buy)
      {
         if(!ShowConfirmDialog("确定要停止做多吗？\n将暂停多单开仓，已有多单保留。"))
            return;
      }
      else
      {
         if(!ShowConfirmDialog("确定要开启做多吗？"))
            return;
      }
      g_allow_buy = !g_allow_buy;
      RefreshPanel(true);
      return;
   }
   // ── 停止做空 ──
   if(k == "btn_stop_sell")
   {
      ResetPanelButtonState(sparam);
      if(g_allow_sell)
      {
         if(!ShowConfirmDialog("确定要停止做空吗？\n将暂停空单开仓，已有空单保留。"))
            return;
      }
      else
      {
         if(!ShowConfirmDialog("确定要开启做空吗？"))
            return;
      }
      g_allow_sell = !g_allow_sell;
      RefreshPanel(true);
      return;
   }
   // ── 开多 (手动单: 独立魔术码, 不受自动策略管理, 仅受面板TP/SL控制) ──
   if(k == "btn_buy")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确认开多单？\n手数: "+DoubleToString(g_lot_manual,2)+"  品种: "+_Symbol))
         return;
      ReadEdits();
      DoManualBuy();
      RefreshPanel(true);
      return;
   }
   // ── 开空 (手动单: 独立魔术码, 不受自动策略管理, 仅受面板TP/SL控制) ──
   if(k == "btn_sell")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确认开空单？\n手数: "+DoubleToString(g_lot_manual,2)+"  品种: "+_Symbol))
         return;
      ReadEdits();
      DoManualSell();
      RefreshPanel(true);
      return;
   }
   // ── 平多 (异步批量全平, 参照平仓面板35) ──
   if(k == "cp_allL")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉全部多单吗？\n当前: "+
         IntegerToString(stats.buy_cnt)+" 单  "+DoubleToString(stats.buy_lot,2)+" 手"))
         return;
      StartAsyncClosingOrders(ORDER_TYPE_BUY);
      RefreshPanel(true);
      return;
   }
   // ── 平空 (异步批量全平) ──
   if(k == "cp_allS")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉全部空单吗？\n当前: "+
         IntegerToString(stats.sell_cnt)+" 单  "+DoubleToString(stats.sell_lot,2)+" 手"))
         return;
      StartAsyncClosingOrders(ORDER_TYPE_SELL);
      RefreshPanel(true);
      return;
   }
   // ── 一键全平 (同步全平多空, 不限魔术码, 仅本品种) ──
   if(k == "btn_closeAll")
   {
      ResetPanelButtonState(sparam);
      int total = stats.buy_cnt + stats.sell_cnt;
      if(!ShowConfirmDialog("确定要一键全平全部持仓吗？\n当前: "+
         IntegerToString(total)+" 单  品种: "+_Symbol))
         return;
      CloseAllPositions(ORDER_TYPE_BUY);
      CloseAllPositions(ORDER_TYPE_SELL);
      RefreshPanel(true);
      return;
   }
   // ── 平盈利多 ──
   if(k == "cp_profL")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉盈利多单吗？\n(仅平仓浮盈>0的多单)"))
         return;
      ClosePositionsByProfit(ORDER_TYPE_BUY, true);
      RefreshPanel(true);
      return;
   }
   // ── 平亏损多 ──
   if(k == "cp_lossL")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉亏损多单吗？\n(仅平仓浮盈<=0的多单)"))
         return;
      ClosePositionsByProfit(ORDER_TYPE_BUY, false);
      RefreshPanel(true);
      return;
   }
   // ── 平盈利空 ──
   if(k == "cp_profS")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉盈利空单吗？\n(仅平仓浮盈>0的空单)"))
         return;
      ClosePositionsByProfit(ORDER_TYPE_SELL, true);
      RefreshPanel(true);
      return;
   }
   // ── 平亏损空 ──
   if(k == "cp_lossS")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉亏损空单吗？\n(仅平仓浮盈<=0的空单)"))
         return;
      ClosePositionsByProfit(ORDER_TYPE_SELL, false);
      RefreshPanel(true);
      return;
   }
   // ── 多单: 百分比平仓 按钮 ──
   if(k == "cp_perL_btn" || k == "cp_perL")
   {
      ResetPanelButtonState(g_prefix+"cp_perL");
      pct = 20.0;
      if(ObjectFind(0,g_prefix+"cp_edt_perL")>=0)
      {
         t = ObjectGetString(0,g_prefix+"cp_edt_perL",OBJPROP_TEXT);
         pct = StringToDouble(t); if(pct<=0||pct>100) pct=20.0;
      }
      CpStats ss; CpCollectStats(POSITION_TYPE_BUY, ss);
      if(ss.cnt==0){ Print("[面板平仓] 没有多单"); RefreshPanel(true); return; }
      targetLots = ss.lots * pct / 100.0;
      msg = "多单百分比平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(targetLots,2)+" 手 ("+DoubleToString(pct,1)+"%)\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      ClosePositions(ORDER_TYPE_BUY, CLOSE_MODE_PERCENT, pct);
      RefreshPanel(true);
      return;
   }
   // ── 多单: 固定手数平仓 按钮 ──
   if(k == "cp_fixL_btn" || k == "cp_fixL")
   {
      ResetPanelButtonState(g_prefix+"cp_fixL");
      lots = 0.01;
      if(ObjectFind(0,g_prefix+"cp_edt_fixL")>=0)
      {
         t = ObjectGetString(0,g_prefix+"cp_edt_fixL",OBJPROP_TEXT);
         lots = StringToDouble(t); if(lots<=0) lots=0.01;
      }
      CpStats ss; CpCollectStats(POSITION_TYPE_BUY, ss);
      if(ss.cnt==0){ Print("[面板平仓] 没有多单"); RefreshPanel(true); return; }
      msg = "多单固定手数平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "每单平仓: "+DoubleToString(lots,2)+" 手\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      ClosePositions(ORDER_TYPE_BUY, CLOSE_MODE_FIXED, lots);
      RefreshPanel(true);
      return;
   }
   // ── 多单: 按序平仓 按钮 ──
   if(k == "cp_ordL")
   {
      ResetPanelButtonState(sparam);
      lots = 0.01;
      if(ObjectFind(0,g_prefix+"cp_edt_ordL")>=0)
      {
         t = ObjectGetString(0,g_prefix+"cp_edt_ordL",OBJPROP_TEXT);
         lots = StringToDouble(t); if(lots<=0) lots=0.01;
      }
      CpStats ss; CpCollectStats(POSITION_TYPE_BUY, ss);
      if(ss.cnt==0){ Print("[面板平仓] 没有多单"); RefreshPanel(true); return; }
      dirDesc = g_longCloseDir ? "从下向上(先平开仓价最低)" : "从上向下(先平开仓价最高)";
      msg = "多单按序平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(lots,2)+" 手\n";
      msg += "方向: "+dirDesc+"\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      ClosePositions(ORDER_TYPE_BUY, g_longCloseDir?CLOSE_MODE_BOTTOM_UP:CLOSE_MODE_TOP_DOWN, lots);
      RefreshPanel(true);
      return;
   }
   // ── 多单: 方向切换按钮 ──
   if(k == "cp_dirL")
   {
      ResetPanelButtonState(sparam);
      g_longCloseDir = !g_longCloseDir;
      RefreshPanel(true);
      return;
   }
   // ── 空单: 百分比平仓 按钮 ──
   if(k == "cp_perS_btn" || k == "cp_perS")
   {
      ResetPanelButtonState(g_prefix+"cp_perS");
      pct = 20.0;
      if(ObjectFind(0,g_prefix+"cp_edt_perS")>=0)
      {
         t = ObjectGetString(0,g_prefix+"cp_edt_perS",OBJPROP_TEXT);
         pct = StringToDouble(t); if(pct<=0||pct>100) pct=20.0;
      }
      CpStats ss; CpCollectStats(POSITION_TYPE_SELL, ss);
      if(ss.cnt==0){ Print("[面板平仓] 没有空单"); RefreshPanel(true); return; }
      targetLots = ss.lots * pct / 100.0;
      msg = "空单百分比平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(targetLots,2)+" 手 ("+DoubleToString(pct,1)+"%)\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      ClosePositions(ORDER_TYPE_SELL, CLOSE_MODE_PERCENT, pct);
      RefreshPanel(true);
      return;
   }
   // ── 空单: 固定手数平仓 按钮 ──
   if(k == "cp_fixS_btn" || k == "cp_fixS")
   {
      ResetPanelButtonState(g_prefix+"cp_fixS");
      lots = 0.01;
      if(ObjectFind(0,g_prefix+"cp_edt_fixS")>=0)
      {
         t = ObjectGetString(0,g_prefix+"cp_edt_fixS",OBJPROP_TEXT);
         lots = StringToDouble(t); if(lots<=0) lots=0.01;
      }
      CpStats ss; CpCollectStats(POSITION_TYPE_SELL, ss);
      if(ss.cnt==0){ Print("[面板平仓] 没有空单"); RefreshPanel(true); return; }
      msg = "空单固定手数平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "每单平仓: "+DoubleToString(lots,2)+" 手\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      ClosePositions(ORDER_TYPE_SELL, CLOSE_MODE_FIXED, lots);
      RefreshPanel(true);
      return;
   }
   // ── 空单: 按序平仓 按钮 ──
   if(k == "cp_ordS")
   {
      ResetPanelButtonState(sparam);
      lots = 0.01;
      if(ObjectFind(0,g_prefix+"cp_edt_ordS")>=0)
      {
         t = ObjectGetString(0,g_prefix+"cp_edt_ordS",OBJPROP_TEXT);
         lots = StringToDouble(t); if(lots<=0) lots=0.01;
      }
      CpStats ss; CpCollectStats(POSITION_TYPE_SELL, ss);
      if(ss.cnt==0){ Print("[面板平仓] 没有空单"); RefreshPanel(true); return; }
      dirDesc = g_shortCloseDir ? "从下向上(先平开仓价最低)" : "从上向下(先平开仓价最高)";
      msg = "空单按序平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(lots,2)+" 手\n";
      msg += "方向: "+dirDesc+"\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      ClosePositions(ORDER_TYPE_SELL, g_shortCloseDir?CLOSE_MODE_BOTTOM_UP:CLOSE_MODE_TOP_DOWN, lots);
      RefreshPanel(true);
      return;
   }
   // ── 空单: 方向切换按钮 ──
   if(k == "cp_dirS")
   {
      ResetPanelButtonState(sparam);
      g_shortCloseDir = !g_shortCloseDir;
      RefreshPanel(true);
      return;
   }
   // ── 加仓控制: 多单 ──
   if(k == "btn_grid_buy")
   {
      ResetPanelButtonState(sparam);
      g_allow_grid_buy = !g_allow_grid_buy;
      Print("[面板] 多单加仓:", g_allow_grid_buy ? "已开启" : "已停止");
      RefreshPanel(true);
      return;
   }
   // ── 加仓控制: 空单 ──
   if(k == "btn_grid_sell")
   {
      ResetPanelButtonState(sparam);
      g_allow_grid_sell = !g_allow_grid_sell;
      Print("[面板] 空单加仓:", g_allow_grid_sell ? "已开启" : "已停止");
      RefreshPanel(true);
      return;
   }
   // ── 加仓全开 ──
   if(k == "btn_grid_all")
   {
      ResetPanelButtonState(sparam);
      g_allow_grid_buy  = true;
      g_allow_grid_sell = true;
      Print("[面板] 多空加仓已全部开启");
      RefreshPanel(true);
      return;
   }
   // ── 加仓全停 ──
   if(k == "btn_grid_none")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要停止全部加仓吗？\n网格加仓将暂停，已有持仓保留。"))
         return;
      g_allow_grid_buy  = false;
      g_allow_grid_sell = false;
      Print("[面板] 多空加仓已全部停止");
      RefreshPanel(true);
      return;
   }
}
//+==================================================================+
//| 生命周期                                                          |
//+==================================================================+
int OnInit()
{
   g_currentMagic = InpMagicNumber;  // 固定使用输入参数的魔术码, 不再自动切换
   m_trade.SetExpertMagicNumber(g_currentMagic);
   m_trade.SetDeviationInPoints(InpSlippage);
   m_trade.SetTypeFillingBySymbol(_Symbol);
   // 异步平仓交易对象 (面板平仓用, 魔术码=0 不限, 仅本品种)
   g_asyncTrade.SetExpertMagicNumber(0);
   g_asyncTrade.SetDeviationInPoints(30);
   g_asyncTrade.SetTypeFillingBySymbol(_Symbol);
   // D1 EMA14 入场句柄
   g_emaHandle=iMA(_Symbol,InpEMA_TF,InpEMA_Period,0,MODE_EMA,PRICE_CLOSE);
   if(g_emaHandle==INVALID_HANDLE){Print("EMA入场句柄创建失败");return INIT_FAILED;}
   // 7个MA10网格方向句柄: [0]=H4,[1]=H1,[2]=M30,[3]=M15,[4]=M5,[5]=M3,[6]=M1
   for(int i=0;i<7;i++) g_maHandle[i]=INVALID_HANDLE;
   for(int i=0;i<7;i++)
      g_maHandle[i]=iMA(_Symbol,g_gridTF[i],InpMA_Period,0,MODE_SMA,PRICE_CLOSE);
   for(int i=0;i<7;i++)
      if(g_maHandle[i]==INVALID_HANDLE){Print("MA10[",g_gridTFName[i],"]创建失败");return INIT_FAILED;}
   if(!LoadParamsFromGV())
   {
      g_lot_manual=InpLotSize; g_lot_base_buy=InpLotSize; g_lot_base_sell=InpLotSize;
      g_tp=InpTakeProfit; g_sl=InpStopLoss;
      g_maxLayersBuy   = 100;
      g_maxLayersSell  = 100;
      g_lotIncrementBuy  = InpLotIncrementBuy;
      g_lotIncrementSell = InpLotIncrementSell;
      g_maxTotalLotsBuy  = InpMaxTotalLotsBuy;
      g_maxTotalLotsSell = InpMaxTotalLotsSell;
      g_lockDrawdownUSD= InpLockDrawdownUSD;
      g_gridExpFactorBuy  = InpGridExpFactorBuy;
      g_gridExpFactorSell = InpGridExpFactorSell;
      SaveParamsToGV();
   }
   g_px=InpPanelX; g_py=InpPanelY; ClampPanelPosition(g_px,g_py);
   EventSetTimer(1);  // 1秒Timer
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,true);
   RefreshPanel(true); ChartRedraw(0);
   Print("[均线策略网格系统 v2.53] D1 EMA",InpEMA_Period," + MA10 7周期网格启动 ",_Symbol,
         " 四重风险防护");
   return INIT_SUCCEEDED;
}
void OnDeinit(const int reason)
{
   DelContent();
   ObjectDelete(0,g_prefix+"toggle_panel");
   if(g_emaHandle!=INVALID_HANDLE) IndicatorRelease(g_emaHandle);
   for(int i=0;i<7;i++)
      if(g_maHandle[i]!=INVALID_HANDLE) IndicatorRelease(g_maHandle[i]);
   EventKillTimer();
   Print("[v2.53 已停止]");
}
void OnTick()
{
   SyncStateFromPositions();  // 状态同步: 校正外部平仓导致的计数器失准
   g_trend=DetectTrend();
   CheckLock();  // 锁仓检测: 浮亏达阈值 → 完全冻结 + 停止EA (优先级最高)
   ContinueAsyncClosingOrders();  // 异步批量平仓 (内部检查g_locked, 锁仓后冻结)
   if(g_locked) return;  // 已锁仓 → 跳过所有自动交易逻辑

   // 趋势转变提示
   if(g_lastTrend!=0 && g_trend!=0 && g_trend!=g_lastTrend)
   {
      Print("════════════════════════════════");
      Print("[趋势翻转] ",g_lastTrend==1?"多头 → 空头":"空头 → 多头");
      Print("════════════════════════════════");
   }
   g_lastTrend = g_trend;

   CheckEntry();
   CheckTPSL();
   ManageManualTPSL();  // 手动单TP/SL独立管理(只管g_manualMagic, 与自动策略隔离)
}
void OnTimer()
{
   g_trend=DetectTrend();
   if(g_panel_open){ ReadEdits(); SaveParamsToGV(); }
   RefreshPanel(false);
}
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
{
   int click_x=(int)lparam;
   int click_y=(int)dparam;
   // ── 拖拽: 点击标题栏区域 → 开始/结束拖拽 ──
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
   // ── 拖拽: 鼠标移动跟随 ──
   if(id == CHARTEVENT_MOUSE_MOVE && g_panel_dragging)
   {
      int new_x = click_x - g_panel_drag_ox;
      int new_y = click_y - g_panel_drag_oy;
      ClampPanelPosition(new_x,new_y);
      MovePanelTo(new_x,new_y);
      return;
   }
   // ── 对象点击 → 按钮处理 ──
   if(id != CHARTEVENT_OBJECT_CLICK)
      return;
   // 只处理本EA的对象
   if(StringFind(sparam,g_prefix,0) != 0)
      return;
   HandlePanelButtonClick(sparam);
}
//+------------------------------------------------------------------+
