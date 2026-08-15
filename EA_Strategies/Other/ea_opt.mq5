//+------------------------------------------------------------------+
//|                                               均线策略网格系统.mq5  |
//|                                    Copyright 2025, 打工仔         |
//|                                    Version 2.52 — 对冲方向随趋势实时翻转                       |
//+------------------------------------------------------------------+
#property copyright "打工仔"
#property version   "2.52"
#property description "均线策略网格系统 - D1 EMA14入场 + 跑马灯止盈 + 对冲随趋势翻转"
#property description "入场: 天图 close > EMA14 开多 / close < EMA14 开空"
#property description "逆势加仓: 7周期(H4/H1/30M/15M/5M/3M/M1) MA10方向 → 动态间距(浮动)"
#property description "顺势加仓: 7周期MA10全部同向才允许, 固定间距"
#property description "跑马灯止盈: 篮子加权均价±动态TP(层多收紧, 逆向放宽)"
#property description "趋势转变: 自动切换魔术码, 对冲方向实时跟随D1趋势翻转"
#property description "D1趋势对冲: 顺势盈利→消化逆势亏损 → 趋势一变, 目标立即切换"
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
//+------------------------------------------------------------------+
//| 面板布局常量                                                       |
//+------------------------------------------------------------------+
#define PW              720       // 面板总宽度(加宽以容纳左右栏)
#define PD              12        // 内边距 padding
#define PG              6         // 行间距 gap
#define HDR_H           54        // 标题栏高度
#define SG              10        // 卡片间距 section_gap
#define LH              22        // 文本行高(含间距)
#define BH              28        // 按钮高度
#define EH              24        // 输入框高度
// 左栏(参数设置)宽度
#define LW              (PW*4/10 - PD)  // ~270
// 右栏(手动平仓操作)宽度
#define RW              (PW*6/10 - PD)  // ~402
#define HALF_W          ((LW - PG)/2)
#define THIRD_W         ((LW - PG*2)/3)
// 左栏卡片高度
// 状态卡: 16头+18标题+8间隔+12数据行(12×22=264)+16底 = 322
#define CH_STATUS       (16+18+8+12*LH+16)
// 参数卡: 16头+18标题+8间隔+5输入行(5×22=110)+gap(6)+按钮行(28)+gap(6)+操作行(28)+16底 = 236
#define CH_PARAMS       (16+18+8+6*LH+PG+BH+PG+BH+16)  // 参数行5->6
// 加仓控制卡: 16头+18标题+8间隔+2行按钮(2×34=68)+16底 = 126
#define CH_GRID_CTRL   (16+18+8+LH+PG + 2*(BH+PG) + 16)  // +状态行
// 左栏总高(状态卡+间距+参数卡+间距+加仓卡)
#define LEFT_COL_H      (CH_STATUS + SG + CH_PARAMS + SG + CH_GRID_CTRL)

// 右栏卡片高度
// 仓位概览卡: 16头+18标题+8间隔+LH(PnL行)+PG+BH(一键平仓)+16底
#define CH_OVERVIEW    (16+18+8+LH+PG+BH+16)
// 平仓管理卡(多/空对称): 16头+18标题+8间隔+统计行(cp_RowH+PG)+按钮行(BH+PG)+3操作行(3*(cp_RowH+PG))+16底
#define CH_ACT         (16+18+8 + cp_RowH+PG + BH+PG + 3*(cp_RowH+PG) + 16)
// 运行信息卡: 16头+18标题+8间隔+4信息行(4×22=88)+16底
#define CH_INFO         (16+18+8 + 4*LH + 16)
// 右栏总高(概览卡+间距+多单卡+间距+空单卡+间距+信息卡)
#define RIGHT_COL_H     (CH_OVERVIEW + SG + CH_ACT + SG + CH_ACT + SG + CH_INFO)

// 总高 = 标题栏 + 间距 + max(左栏, 右栏)
#define TOTAL_H   (HDR_H + SG + (LEFT_COL_H > RIGHT_COL_H ? LEFT_COL_H : RIGHT_COL_H))
// 布局参数(平仓管理区)
#define cp_LblW          90        // 标签列宽
#define cp_EW1          64        // 输入框宽(大)
#define cp_EW2          44        // 输入框宽(小)
#define cp_BtnW          36        // 抽取按钮宽
#define cp_RowH          24        // 行高
//+------------------------------------------------------------------+
//| 输入参数                                                          |
//+------------------------------------------------------------------+
input group "== 交易参数 =="
input double      InpLotSize        = 0.01;          // 手数(平投)
input int         InpMagicNumber    = 111111;        // 魔术号(阶段1)
input int         InpSlippage       = 30;            // 滑点
input group "== 入场信号(D1 EMA14) =="
input int               InpEMA_Period   = 14;          // EMA周期
input ENUM_TIMEFRAMES    InpEMA_TF       = PERIOD_D1;   // 入场信号TF
input group "== 网格MA10(多周期方向检测) =="
input int               InpMA_Period    = 10;          // MA周期
input int               InpGridWithTrend = 100;        // 顺势同向间距(点)
input group "== 止盈止损(点数) =="
input int         InpTakeProfit     = 200;           // 止盈点数(0=不启用)
input int         InpStopLoss       = 200;           // 止损点数(0=不启用)
input group "== 加仓控制 =="
input int         InpMaxGridLayers  = 10;            // 最大加仓层数
input double      InpLotIncrement   = 0.01;          // 每层手数递增
input group "== 趋势转变对冲 =="
input double      InpHedgeRatio     = 0.5;           // 盈利对冲比例(当前浮盈的多少%用于对冲旧仓)
input double      InpHedgeMinProfit  = 5.0;           // 最小启动对冲盈利($)
input double      InpHedgeMinLots    = 0.01;          // 每次最小对冲手数
input group "== 面板位置 =="
input int         InpPanelX         = 20;            // 面板X(像素)
input int         InpPanelY         = 20;            // 面板Y(像素)
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
double         g_lot           = 0.01;
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
int            g_magicPhase     = 1;   // 当前阶段: 1=111111, 2=222222
int            g_currentMagic   = 111111; // 当前魔术码
double         g_lotBase        = 0.01; // 当前阶段基础手数
int            g_gridLayer      = 0;   // 当前阶段加仓层数(0=首单)
// ── D1趋势导向对冲(顺势盈利→消化逆势亏损, 方向随趋势实时翻转) ──
int            g_hedgeOldMagic  = 0;   // 面板显示用: 最近趋势翻转前的旧魔术码
int            g_hedgeOldTrend  = 0;   // 面板显示用: 当前逆势方向(与g_trend相反)
// ── 异步平仓系统 ──
bool           g_cpAsync[2]    = {false, false};  // [0]=多单, [1]=空单
int            g_cpAsyncMode[2] = {0, 0};       // 1=全平,2=平盈利,3=平亏损,4=百分比,5=固定手数,6=按序
double         g_cpAsyncVal[2]  = {0.0, 0.0};   // mode=4时百分比, mode=5/6时手数
int            g_cpAsyncIdx[2]   = {0, 0};       // 当前处理索引
datetime       g_cpAsyncTkt[2]   = {0, 0};       // 上一单平仓时间(限速)
// ── 按序平仓方向: true=从下向上(先平开仓价最低的), false=从上向下(先平开仓价最高的) ──
bool           g_longCloseDir  = false;  // 多单默认: 从上向下(灰色)
bool           g_shortCloseDir = false;  // 空单默认: 从下向上(灰色), 点击后变红
// ── 可面板修改的运行时参数(从input初始化, 面板可改) ──
int            g_gridWithTrend  = 100;   // 顺势同向间距(点)
double         g_hedgeRatio     = 0.5;   // 盈利对冲比例
double         g_hedgeMinProfit = 5.0;   // 最小启动对冲盈利($)
int            g_maxLayers      = 10;     // 最大加仓层数
double         g_lotIncrement   = 0.01;   // 每层手数递增
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
   ObjectSetInteger(0,nm,OBJPROP_WIDTH,1);
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
      ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,C'40,42,52');
      ObjectSetInteger(0,nm,OBJPROP_BORDER_COLOR,C'70,72,85');
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
//| 收集平仓统计 (只统计本品种, 不限魔术码)                           |
//+------------------------------------------------------------------+
void CpCollectStats(ENUM_POSITION_TYPE pt, CpStats &s)
{
   s.lots = 0; s.cnt = 0; s.pnl = 0;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(PositionGetSymbol(i)=="") continue;
      if(PositionGetSymbol(i)!=_Symbol) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)!=pt) continue;
      s.lots += PositionGetDouble(POSITION_VOLUME);
      s.cnt++;
      s.pnl += PositionGetDouble(POSITION_PROFIT);
   }
}
//+------------------------------------------------------------------+
//| 异步平仓启动                                                       |
//+------------------------------------------------------------------+
void CpStartAsync(ENUM_POSITION_TYPE pt, int mode, double val)
{
   int idx = (pt==POSITION_TYPE_BUY) ? 0 : 1;
   // 先统计本品种该方向持仓
   int cnt = 0;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(PositionGetSymbol(i)=="") continue;
      if(PositionGetSymbol(i)!=_Symbol) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)!=pt) continue;
      cnt++;
   }
   if(cnt == 0)
   {
      Print("[手动平仓] 没有找到 ", _Symbol, " 的", pt==POSITION_TYPE_BUY?"多单":"空单");
      return;
   }
   g_cpAsync[idx]     = true;
   g_cpAsyncMode[idx] = mode;
   g_cpAsyncVal[idx]  = val;
   g_cpAsyncIdx[idx]  = 0;
   g_cpAsyncTkt[idx]  = 0;
   string modeStr = "";
   switch(mode)
   {
      case 1: modeStr = "全平"; break;
      case 2: modeStr = "平盈利"; break;
      case 3: modeStr = "平亏损"; break;
      case 4: modeStr = "百分比("+DoubleToString(val,1)+"%)"; break;
      case 5: modeStr = "固定手数("+DoubleToString(val,2)+")"; break;
      case 6: modeStr = "按序("+DoubleToString(val,2)+")"; break;
   }
   Print("[手动平仓] 启动异步 ", modeStr, " ", cnt, " 单 ",
         pt==POSITION_TYPE_BUY?"多单":"空单", " ", _Symbol);
}
//+------------------------------------------------------------------+
//| 手构部分平仓 (CTrade 无 PositionClosePartial)                        |
//+------------------------------------------------------------------+
bool DoPartialClose(ulong ticket, double volume, int slippage)
{
   MqlTradeRequest req;
   MqlTradeResult  res;
   ENUM_ORDER_TYPE otype;
   double price;
   ENUM_POSITION_TYPE ptype;
   ZeroMemory(req);
   ZeroMemory(res);
   req.action       = TRADE_ACTION_DEAL;
   req.position     = ticket;
   req.symbol       = _Symbol;
   req.volume       = volume;
   req.deviation    = slippage;
   req.type_filling = ORDER_FILLING_IOC;
   if(PositionSelectByTicket(ticket))
   {
      ptype = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      if(ptype == POSITION_TYPE_BUY)
      {
         otype = ORDER_TYPE_SELL;
         price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      }
      else
      {
         otype = ORDER_TYPE_BUY;
         price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      }
   }
   else
      return false;
   req.type  = otype;
   req.price = price;
   return OrderSend(req, res);
}
//+------------------------------------------------------------------+
//| 异步平仓Tick (OnTimer调用)                                         |
//+------------------------------------------------------------------+
void CpAsyncTick()
{
   CTrade cpTrade;
   cpTrade.SetExpertMagicNumber(0);  // 不限魔术码
   cpTrade.SetDeviationInPoints(30);

   for(int idx=0; idx<2; idx++)
   {
      if(!g_cpAsync[idx]) continue;
      ENUM_POSITION_TYPE pt = (idx==0) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
      int  mode = g_cpAsyncMode[idx];
      double val  = g_cpAsyncVal[idx];
      // 限速: 每500ms最多平一单
      if(TimeCurrent() - g_cpAsyncTkt[idx] < 1) continue;
      // 收集需要平仓的ticket列表
      ulong tickets[100];
      int   tcnt = 0;
      double remainLots = 0;  // 用于mode=5/6
      for(int i=PositionsTotal()-1;i>=0 && tcnt<100;i--)
      {
         if(PositionGetSymbol(i)=="") continue;
         if(PositionGetSymbol(i)!=_Symbol) continue;
         if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)!=pt) continue;
         ulong ticket = PositionGetInteger(POSITION_IDENTIFIER);
         double pnl  = PositionGetDouble(POSITION_PROFIT);
         double lots = PositionGetDouble(POSITION_VOLUME);
         bool needClose = false;
         switch(mode)
         {
            case 1: needClose = true; break;
            case 2: needClose = (pnl > 0); break;
            case 3: needClose = (pnl <= 0); break;
            case 4: // 百分比: 先全部收集, 后面统一处理
            case 5: // 固定手数: 收集直到达到目标手数
            case 6: // 按序: 按开仓价排序后收集
               needClose = true;
               break;
         }
         if(needClose)
         {
            tickets[tcnt] = ticket;
            tcnt++;
            if(mode==5 || mode==6) remainLots += lots;
         }
      }
      if(tcnt == 0)
      {
         g_cpAsync[idx] = false;
         Print("[手动平仓] ", pt==POSITION_TYPE_BUY?"多单":"空单", " 异步平仓完成");
         continue;
      }
      // mode=4: 百分比平仓 → 转换为固定手数
      if(mode == 4)
      {
         double totalLots = 0;
         for(int k=0;k<tcnt;k++)
         {
            if(PositionSelectByTicket(tickets[k]))
               totalLots += PositionGetDouble(POSITION_VOLUME);
         }
         double targetLots = totalLots * val / 100.0;
         // 改为mode=5处理
         g_cpAsyncMode[idx] = 5;
         g_cpAsyncVal[idx]  = targetLots;
         mode = 5;
         val  = targetLots;
         Print("[手动平仓] 百分比→固定手数: ", DoubleToString(targetLots,2), " 手");
      }
      // mode=5: 固定手数平仓
      if(mode == 5)
      {
         double closedLots = 0;
         for(int k=0;k<tcnt && closedLots<val;k++)
         {
            if(!PositionSelectByTicket(tickets[k])) continue;
            double lots = PositionGetDouble(POSITION_VOLUME);
            double closeLots = MathMin(lots, val - closedLots);
            if(closeLots >= PositionGetDouble(POSITION_VOLUME))
            {
               // 全平这一单
               if(cpTrade.PositionClose(tickets[k], 30))
               {
                  closedLots += lots;
                  g_cpAsyncTkt[idx] = TimeCurrent();
                  Print("[手动平仓] 固定手数 平 #", tickets[k], " 全部 ", DoubleToString(lots,2), " 手");
               }
            }
            else
            {
               // 部分平仓
               if(DoPartialClose(tickets[k], closeLots, 30))
               {
                  closedLots += closeLots;
                  g_cpAsyncTkt[idx] = TimeCurrent();
                  Print("[手动平仓] 固定手数 平 #", tickets[k], " 部分 ", DoubleToString(closeLots,2), " 手");
               }
            }
         }
         g_cpAsync[idx] = false;
         Print("[手动平仓] 固定手数平仓完成, 共平 ", DoubleToString(closedLots,2), " 手");
         continue;
      }
      // mode=6: 按序平仓 (从最早开仓的开始平)
      if(mode == 6)
      {
         // 按开仓时间排序
         ulong sorted[100];
         ArrayCopy(sorted, tickets);
         // 简单冒泡排序(按开仓时间)
         for(int a=0;a<tcnt-1;a++)
            for(int b=a+1;b<tcnt;b++)
            {
               datetime ta=0, tb=0;
               if(PositionSelectByTicket(sorted[a])) ta = (datetime)PositionGetInteger(POSITION_TIME);
               if(PositionSelectByTicket(sorted[b])) tb = (datetime)PositionGetInteger(POSITION_TIME);
               if(ta > tb) { ulong tmp=sorted[a]; sorted[a]=sorted[b]; sorted[b]=tmp; }
            }
         // 从最早的开仓开始平
         double closedLots = 0;
         for(int k=0;k<tcnt && closedLots<val;k++)
         {
            if(!PositionSelectByTicket(sorted[k])) continue;
            double lots = PositionGetDouble(POSITION_VOLUME);
            double closeLots = MathMin(lots, val - closedLots);
            if(closeLots >= lots)
            {
               if(cpTrade.PositionClose(sorted[k], 30))
               {
                  closedLots += lots;
                  g_cpAsyncTkt[idx] = TimeCurrent();
                  Print("[手动平仓] 按序 平 #", sorted[k], " 全部 ", DoubleToString(lots,2), " 手");
               }
            }
            else
            {
               if(DoPartialClose(sorted[k], closeLots, 30))
               {
                  closedLots += closeLots;
                  g_cpAsyncTkt[idx] = TimeCurrent();
                  Print("[手动平仓] 按序 平 #", sorted[k], " 部分 ", DoubleToString(closeLots,2), " 手");
               }
            }
         }
         g_cpAsync[idx] = false;
         Print("[手动平仓] 按序平仓完成, 共平 ", DoubleToString(closedLots,2), " 手");
         continue;
      }
      // mode=1/2/3: 逐单平仓
      if(mode >= 1 && mode <= 3)
      {
         ulong ticket = tickets[g_cpAsyncIdx[idx]];
         if(PositionSelectByTicket(ticket))
         {
            if(cpTrade.PositionClose(ticket, 30))
            {
               Print("[手动平仓] ", mode==1?"全平":(mode==2?"平盈利":"平亏损"),
                     " #", ticket, " ", _Symbol);
               g_cpAsyncTkt[idx] = TimeCurrent();
            }
            else
            {
               Print("[手动平仓] 平仓失败 #", ticket, " err=", cpTrade.ResultRetcode());
            }
         }
         g_cpAsyncIdx[idx]++;
         if(g_cpAsyncIdx[idx] >= tcnt)
         {
            g_cpAsync[idx] = false;
            Print("[手动平仓] ", pt==POSITION_TYPE_BUY?"多单":"空单", " 异步平仓完成");
         }
      }
   }
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
   string hedgeStr;
   string hedgeLabel;
   string targetDir;
   string st_buy;
   string st_sell;
   double nextLot;
   double cLoss;
   double l;
   color tpClr;
   int cCnt;
   bool isBuy;
   string dirTxtL;
   string dirTxtS;
   color dirClrL;
   color dirClrS;
   color hedgeClr;
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
   string sigStr;
   string spStr;
   string lossStr;
   string nxtStr;
   color sigClr;
   color spClr;
   long spread;
   string maxLayerStr;
   string incStr;
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
   BG_PANEL  = C'15,19,26';
   BD_PANEL  = C'42,53,68';
   BG_HDR    = C'22,29,42';
   BG_CARD   = C'26,33,46';
   cMute  = C'140,155,175';
   cOk    = C'78,190,140';
   cWarn  = C'245,176,68';
   cBad   = C'230,100,97';

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
   ERect(g_prefix+"c1",X,cy,LW,CH_STATUS,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c1_title","状态",LX,cy+PD,F(12),cWhite);
   ry = cy + PD + 20;
   ELbl(g_prefix+"r1_lbl","运行状态", LX,   ry+1, F(10), cMute);
   ELbl(g_prefix+"r1_val", rTxt,       LX+LW*4/10,ry+1, F(10), rClr);
   ELbl(g_prefix+"r2_lbl","趋势方向", LX,   ry+LH+1, F(10), cMute);
   ELbl(g_prefix+"r2_val", tTxt,       LX+LW*4/10,ry+LH+1, F(10), tClr);
   ELbl(g_prefix+"r3_lbl","当前持仓", LX,   ry+LH*2+1, F(10), cMute);
   ELbl(g_prefix+"r3_val", pTxt,       LX+LW*4/10,ry+LH*2+1, F(10), pClr);

   // 网格间距
   gridStr = "逆势"+IntegerToString(g_gridCounterInterval)+"点";
   if(g_gridWithTrend>0) gridStr += " / 顺势"+IntegerToString(g_gridWithTrend)+"点";
   if(g_gridCounterInterval==-1) gridStr = "全部逆向(不加仓)";
   ELbl(g_prefix+"r4_lbl","网格间距", LX,   ry+LH*3+1, F(10), cMute);
   ELbl(g_prefix+"r4_val", gridStr,     LX+LW*4/10,ry+LH*3+1, F(10), g_gridCounterInterval==-1?cBad:cOk);

   // 魔术码 + 阶段
   magicStr = IntegerToString(g_currentMagic)+" (阶段"+IntegerToString(g_magicPhase)+")";
   ELbl(g_prefix+"r5_lbl","魔术码",   LX,   ry+LH*4+1, F(10), cMute);
   ELbl(g_prefix+"r5_val", magicStr,    LX+LW*4/10,ry+LH*4+1, F(10), cWhite);

   // 层数 + 下次手数
   nextLot = g_lotBase + g_gridLayer * 0.01;
   layerStr = "层数:"+IntegerToString(g_gridLayer)+" | 下次:"+DoubleToString(nextLot,2)+"手";
   ELbl(g_prefix+"r6_lbl","加仓进度", LX,   ry+LH*5+1, F(10), cMute);
   ELbl(g_prefix+"r6_val", layerStr,    LX+LW*4/10,ry+LH*5+1, F(10), cOk);

   // 跑马灯动态止盈
   cDepth = GetCounterDepth(g_trend);
   dynTP  = InpTakeProfit - g_gridLayer*20 + cDepth*25;
   if(dynTP<50) dynTP=50; if(dynTP>400) dynTP=400;
   tpStr = "跑马灯 "+IntegerToString(dynTP)+"点 (深度"+IntegerToString(cDepth)+")";
   if(g_tp<=0) tpStr = "止盈已关闭";
   tpClr = (g_tp>0&&g_gridLayer>0) ? cOk : cMute;
   ELbl(g_prefix+"r7_lbl","动态止盈", LX,   ry+LH*6+1, F(10), cMute);
   ELbl(g_prefix+"r7_val", tpStr,       LX+LW*4/10,ry+LH*6+1, F(10), tpClr);

   // 对冲方向(D1趋势导向, 实时跟随g_trend翻转)
   hedgeLabel = "对冲方向";
   if(g_trend==0)
      { hedgeStr="无趋势,暂停对冲"; hedgeClr=cMute; }
   else
   {
      targetDir = (g_trend==1) ? "SELL" : "BUY";
      cLoss=0; cCnt=0;
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         if(PositionGetSymbol(i)=="") continue;
         if(PositionGetSymbol(i)!=_Symbol) continue;
         isBuy=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
         if((g_trend==1 && !isBuy) || (g_trend==-1 && isBuy))
         {
            l=-(PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP));
            if(l<=0) continue;
            cLoss+=l; cCnt++;
         }
      }
      hedgeLabel = "消化逆势"+targetDir;
      if(cCnt>0)
         { hedgeStr=IntegerToString(cCnt)+"单 买损$"+DoubleToString(cLoss,1); hedgeClr=cWarn; }
      else
         { hedgeStr="全部顺势 安全"; hedgeClr=cOk; }
   }
   ELbl(g_prefix+"r8_lbl",hedgeLabel,  LX,   ry+LH*7+1, F(10), cMute);
   ELbl(g_prefix+"r8_val", hedgeStr,   LX+LW*4/10,ry+LH*7+1, F(10), hedgeClr);

   // --- 新增状态行(9-12): 让左栏更高以平衡右栏 ---
   // 入场信号强度
   sigStr = "--";
   sigClr = cMute;
   if(g_trend != 0)
   {
      double emaVal[], closeArr[];
      ArrayResize(emaVal,1); ArrayResize(closeArr,1);
      if(CopyClose(_Symbol,InpEMA_TF,0,1,closeArr)>0 && CopyBuffer(g_emaHandle,0,0,1,emaVal)>0)
      {
         double diff = MathAbs(closeArr[0]-emaVal[0]) / _Point;
         sigStr = "偏离 "+DoubleToString(diff,1)+" 点";
         sigClr = (diff > g_gridWithTrend*0.5) ? cOk : (diff > g_gridWithTrend*0.25 ? cWarn : cMute);
      }
   }
   ELbl(g_prefix+"r9_lbl","入场信号", LX,   ry+LH*8+1, F(10), cMute);
   ELbl(g_prefix+"r9_val", sigStr,     LX+LW*4/10,ry+LH*8+1, F(10), sigClr);

   // 当前点差
   spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   spStr = IntegerToString((int)spread)+" 点";
   spClr = (spread <= 30) ? cOk : (spread <= 100 ? cWarn : cBad);
   ELbl(g_prefix+"r10_lbl","当前点差", LX,    ry+LH*9+1, F(10), cMute);
   ELbl(g_prefix+"r10_val", spStr,      LX+LW*4/10,ry+LH*9+1, F(10), spClr);

   // 连续亏损/加仓层数摘要
   lossStr = "层数:"+IntegerToString(g_gridLayer)+" | 间距:"+IntegerToString(g_gridCounterInterval);
   ELbl(g_prefix+"r11_lbl","网格状态", LX,    ry+LH*10+1, F(10), cMute);
   ELbl(g_prefix+"r11_val", lossStr,    LX+LW*4/10,ry+LH*10+1, F(10), (g_gridLayer>0)?cWarn:cOk);

   // 下次加仓手数
   nxtStr = DoubleToString(nextLot,2)+" 手";
   ELbl(g_prefix+"r12_lbl","下次手数", LX,    ry+LH*11+1, F(10), cMute);
   ELbl(g_prefix+"r12_val", nxtStr,    LX+LW*4/10,ry+LH*11+1, F(10), cOk);

    // 卡片2: 参数设置 (左栏, 在状态卡下方)
    cy += CH_STATUS + SG;
    ERect(g_prefix+"c2",X,cy,LW,CH_PARAMS,BG_CARD,BD_PANEL);
    ELbl(g_prefix+"c2_title","参数设置",LX,cy+PD,F(12),cWhite);
    ey = cy + PD + 22;

    // 第1行: 手数 [____]    止盈 [____] 点
    ELbl(g_prefix+"e1_l1","手 数",   LX,      ey+2,     F(10), cMute);
    EEdt(g_prefix+"e1_lot",  DoubleToString(g_lot,2),    LX+48,  ey,    60,EH);
    ELbl(g_prefix+"e1_l2","止 盈",   LX+160,  ey+2,     F(10), cMute);
    EEdt(g_prefix+"e1_tp",   IntegerToString(g_tp),      LX+200, ey,    60,EH);
    ELbl(g_prefix+"e1_u2","点",      LX+264,  ey+2,     F(9),  cMute);

    // 第2行: 止损 [____] 点    顺势间距 [____] 点
    ELbl(g_prefix+"e2_l1","止 损",   LX,      ey+LH+2,  F(10), cMute);
    EEdt(g_prefix+"e1_sl",   IntegerToString(g_sl),      LX+48,  ey+LH,60,EH);
    ELbl(g_prefix+"e2_u1","点",      LX+112,  ey+LH+2,  F(9),  cMute);
    ELbl(g_prefix+"e3_l1","顺势间距",LX+160,  ey+LH+2,  F(10), cMute);
    EEdt(g_prefix+"e3_trend",IntegerToString(g_gridWithTrend),LX+200,ey+LH,60,EH);
    ELbl(g_prefix+"e3_u1","点",      LX+264,  ey+LH+2,  F(9),  cMute);

    // 第3行: 对冲比例 [____]    最小对冲 [____]
    ELbl(g_prefix+"e4_l1","对冲比例",LX,      ey+LH*2+2,F(10), cMute);
    EEdt(g_prefix+"e4_hedge",DoubleToString(g_hedgeRatio,2),LX+48,ey+LH*2,60,EH);
    ELbl(g_prefix+"e4_l2","最小对冲",LX+160,  ey+LH*2+2,F(10), cMute);
    EEdt(g_prefix+"e5_minP",DoubleToString(g_hedgeMinProfit,1),LX+200,ey+LH*2,60,EH);

    // 第4行: 最大层数 [____]    层均递增 [____]
    ELbl(g_prefix+"e6_l1","最大层数",LX,      ey+LH*3+2,F(10), cMute);
    EEdt(g_prefix+"e6_maxL",IntegerToString(g_maxLayers),LX+48,ey+LH*3,60,EH);
    ELbl(g_prefix+"e6_l2","层均递增",LX+160,  ey+LH*3+2,F(10), cMute);
    EEdt(g_prefix+"e7_inc", DoubleToString(g_lotIncrement,2),LX+200,ey+LH*3,60,EH);

    // 操作按钮行1: 停多 | 停空 | 开多 | 开空
    {
       btnY = ey + LH*4 + PG + 2;
      qbw = (LW - PD*2 - PG*3) / 4;
      sc_buy = g_allow_buy ? C'55,75,100' : cOk;
      st_buy = g_allow_buy ? "停多" : "开多";
      sc_sell = g_allow_sell ? C'110,80,60' : cOk;
      st_sell = g_allow_sell ? "停空" : "开空";
      EBtn(g_prefix+"btn_stop_buy", st_buy, LX+PD, btnY, qbw, BH, sc_buy, cWhite);
      EBtn(g_prefix+"btn_stop_sell", st_sell, LX+PD+qbw+PG, btnY, qbw, BH, sc_sell, cWhite);
      EBtn(g_prefix+"btn_buy", "开 多", LX+PD+(qbw+PG)*2, btnY, qbw, BH, InpColorBuy, cWhite);
      EBtn(g_prefix+"btn_sell", "开 空", LX+PD+(qbw+PG)*3, btnY, qbw, BH, InpColorSell, cWhite);
   }

    // 操作按钮行2: 重置网格 | 切换阶段
    {
       btnY = ey + LH*4 + PG + BH + PG + 2;
       int qbw2 = (LW - PD*2 - PG) / 2;
       EBtn(g_prefix+"btn_reset_grid", "重置网格", LX+PD, btnY, qbw2, BH, C'70,72,85', cWhite);
       EBtn(g_prefix+"btn_switch_phase", "切换阶段", LX+PD+qbw2+PG, btnY, qbw2, BH, C'70,72,85', cWhite);
    }
   // ===== 卡片c_grid: 加仓控制 =====
   cy += CH_PARAMS + SG;
   ERect(g_prefix+"c_grid",LX,cy,LW,CH_GRID_CTRL,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c_grid_title","加仓控制",LX+PD,cy+PD,F(12),cWhite);
   // 状态行
   {
      string gs = "层数 "+IntegerToString(g_gridLayer)+"/"+IntegerToString(g_maxLayers);
      gs += " | 下次 "+DoubleToString(g_lotBase+g_gridLayer*g_lotIncrement,2)+"手";
      gs += " | 间距 "+IntegerToString(g_gridCounterInterval)+"点";
      EBtn(g_prefix+"c_grid_status", gs, LX+PD, cy+PD+22, LW-PD*2, LH, C'40,42,52', cOk);
   }
   // 按钮行1: 多单加仓 | 空单加仓
   {
      int gw1 = (LW - PD*2 - PG) / 2;
      color buyC = g_allow_grid_buy ? C'55,75,100' : cOk;
      string buyT = g_allow_grid_buy ? "停加仓多" : "启加仓多";
      color sellC = g_allow_grid_sell ? C'110,80,60' : cOk;
      string sellT = g_allow_grid_sell ? "停加仓空" : "启加仓空";
      EBtn(g_prefix+"btn_grid_buy",  buyT,  LX+PD,               cy+PD+22+LH+PG, gw1,   BH, buyC,  cWhite);
      EBtn(g_prefix+"btn_grid_sell", sellT, LX+PD+gw1+PG, cy+PD+22+LH+PG, gw1,   BH, sellC, cWhite);
   }
   // 按钮行2: 全开 | 全停
   {
      int gw2 = (LW - PD*2 - PG) / 2;
      EBtn(g_prefix+"btn_grid_all",  "加仓全开", LX+PD,               cy+PD+22+LH+PG+BH+PG, gw2, BH, C'50,90,50', cWhite);
      EBtn(g_prefix+"btn_grid_none", "加仓全停", LX+PD+gw2+PG, cy+PD+22+LH+PG+BH+PG, gw2, BH, C'90,50,50', cWhite);
   }
//      右栏: 仓位概览 + 多单平仓 + 空单平仓(对称双卡)
   rx = RX;
   cy = g_py + HDR_H + SG;

   // ===== 卡片 overview: 仓位概览 =====
   ERect(g_prefix+"c_overview",rx-PD,cy,RW_+PD*2,CH_OVERVIEW,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c_overview_title","仓位概览",rx,cy+PD,F(12),cWhite);
   by = cy + PD + 22;

   // 浮动盈亏
   totalPnL = s.buy_pnl + s.sell_pnl;
   pnlClr = (totalPnL >= 0) ? cOk : cBad;
   pnlSign = (totalPnL >= 0) ? "+" : "";
   ELbl(g_prefix+"cp_totalPnl","浮动盈亏 "+pnlSign+"$"+DoubleToString(totalPnL,2),
        rx+PD, by, F(12), pnlClr);
   by += LH + PG;

   // 一键平仓
   cbw = RW_ - PD*2;
   EBtn(g_prefix+"btn_closeAll","一键平仓全部持仓", rx+PD, by, cbw, BH, C'180,50,50', cWhite);

   // ===== 卡片c3: 多单平仓 =====
   cy += CH_OVERVIEW + SG;
   ERect(g_prefix+"c3",rx-PD,cy,RW_+PD*2,CH_ACT,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c3_title","多单平仓",rx,cy+PD,F(12),InpColorBuy);
   by = cy + PD + 22;

   // 多单统计
   buyStat = "手数 "+DoubleToString(s.buy_lot,2)+"  |  数量 "+IntegerToString(s.buy_cnt)+"  |  盈亏 $"+DoubleToString(s.buy_pnl,2);
   buyStatClr = (s.buy_pnl >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_buyStat", buyStat, rx+PD, by, F(9), buyStatClr);
   by += cp_RowH + PG;

   // 全平 | 盈 | 亏
   bw3 = (RW_ - PD*2 - PG*2) / 3;
   EBtn(g_prefix+"cp_allL","全平", rx+PD, by, bw3, BH, C'56,132,216', cWhite);
   EBtn(g_prefix+"cp_profL","平盈", rx+PD+bw3+PG, by, bw3, BH, C'78,190,140', cWhite);
   EBtn(g_prefix+"cp_lossL","平亏", rx+PD+bw3*2+PG*2, by, bw3, BH, C'230,100,97', cWhite);
   by += BH + PG;

   // 百分比平仓
   EBtn(g_prefix+"cp_perL_btn", "百分比", rx+PD, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_perL", "20", rx+PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_perL", "抽取", rx+PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'56,132,216', cWhite);
   perLVal = s.buy_lot * StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_perL",OBJPROP_TEXT)) / 100.0;
   perLClr = cMute;
   ELbl(g_prefix+"cp_perL_res", "="+DoubleToString(perLVal,2),
        rx+PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+4, by+3, F(9), perLClr);
   by += cp_RowH + PG;

   // 固定手数平仓
   EBtn(g_prefix+"cp_fixL_btn", "固定手数", rx+PD, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_fixL", "0.01", rx+PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_fixL", "抽取", rx+PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'56,132,216', cWhite);
   fixLVal = StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_fixL",OBJPROP_TEXT));
   fixLClr = cMute;
   ELbl(g_prefix+"cp_fixL_res", "="+DoubleToString(fixLVal,2),
        rx+PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+4, by+3, F(9), fixLClr);
   by += cp_RowH + PG;

   // 按序方向
   dirTxtL = g_longCloseDir ? "多↑从下向上" : "多↓从上向下";
   dirClrL = g_longCloseDir ? C'56,132,216' : C'70,72,85';
   EBtn(g_prefix+"cp_dirL", dirTxtL, rx+PD, by, cp_LblW, cp_RowH, dirClrL, cWhite);
   EEdt(g_prefix+"cp_edt_ordL", "0.01", rx+PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_ordL", "抽取", rx+PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'56,132,216', cWhite);
   ordLVal = StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_ordL",OBJPROP_TEXT));
   ordLClr = cMute;
   ELbl(g_prefix+"cp_ordL_res", "="+DoubleToString(ordLVal,2),
        rx+PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+4, by+3, F(9), ordLClr);

   // ===== 卡片c4: 空单平仓 =====
   cy += CH_ACT + SG;
   ERect(g_prefix+"c4",rx-PD,cy,RW_+PD*2,CH_ACT,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c4_title","空单平仓",rx,cy+PD,F(12),InpColorSell);
   by = cy + PD + 22;

   // 空单统计
   sellStat = "手数 "+DoubleToString(s.sell_lot,2)+"  |  数量 "+IntegerToString(s.sell_cnt)+"  |  盈亏 $"+DoubleToString(s.sell_pnl,2);
   sellStatClr = (s.sell_pnl >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_sellStat", sellStat, rx+PD, by, F(9), sellStatClr);
   by += cp_RowH + PG;

   // 全平 | 盈 | 亏
   bw3S = (RW_ - PD*2 - PG*2) / 3;
   EBtn(g_prefix+"cp_allS","全平", rx+PD, by, bw3S, BH, C'180,80,60', cWhite);
   EBtn(g_prefix+"cp_profS","平盈", rx+PD+bw3S+PG, by, bw3S, BH, C'78,190,140', cWhite);
   EBtn(g_prefix+"cp_lossS","平亏", rx+PD+bw3S*2+PG*2, by, bw3S, BH, C'230,100,97', cWhite);
   by += BH + PG;

   // 百分比平仓
   EBtn(g_prefix+"cp_perS_btn", "百分比", rx+PD, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_perS", "20", rx+PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_perS", "抽取", rx+PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'180,80,60', cWhite);
   perSVal = s.sell_lot * StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_perS",OBJPROP_TEXT)) / 100.0;
   perSClr = cMute;
   ELbl(g_prefix+"cp_perS_res", "="+DoubleToString(perSVal,2),
        rx+PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+4, by+3, F(9), perSClr);
   by += cp_RowH + PG;

   // 固定手数平仓
   EBtn(g_prefix+"cp_fixS_btn", "固定手数", rx+PD, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_fixS", "0.01", rx+PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_fixS", "抽取", rx+PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'180,80,60', cWhite);
   fixSVal = StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_fixS",OBJPROP_TEXT));
   fixSClr = cMute;
   ELbl(g_prefix+"cp_fixS_res", "="+DoubleToString(fixSVal,2),
        rx+PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+4, by+3, F(9), fixSClr);
   by += cp_RowH + PG;

   // 按序方向
   dirTxtS = g_shortCloseDir ? "空↑从下向上" : "空↓从上向下";
   dirClrS = g_shortCloseDir ? C'180,80,60' : C'70,72,85';
   EBtn(g_prefix+"cp_dirS", dirTxtS, rx+PD, by, cp_LblW, cp_RowH, dirClrS, cWhite);
   EEdt(g_prefix+"cp_edt_ordS", "0.01", rx+PD+cp_LblW+PG, by, cp_EW2, cp_RowH);
   EBtn(g_prefix+"cp_ordS", "抽取", rx+PD+cp_LblW+PG+cp_EW2+PG, by, cp_BtnW, cp_RowH, C'180,80,60', cWhite);
   ordSVal = StringToDouble(ObjectGetString(0,g_prefix+"cp_edt_ordS",OBJPROP_TEXT));
   ordSClr = cMute;
   ELbl(g_prefix+"cp_ordS_res", "="+DoubleToString(ordSVal,2),
        rx+PD+cp_LblW+PG+cp_EW2+PG+cp_BtnW+4, by+3, F(9), ordSClr);

   // ===== 卡片c_info: 运行信息 =====
   cy += CH_ACT + SG;
   ERect(g_prefix+"c_info",rx-PD,cy,RW_+PD*2,CH_INFO,BG_CARD,BD_PANEL);
   ELbl(g_prefix+"c_info_title","运行信息",rx,cy+PD,F(12),cMute);

   // 行1: 当前趋势
   string trendTxt = (g_trend==1)? "上升趋势(D1 EMA14)":
                     (g_trend==-1)? "下降趋势(D1 EMA14)": "趋势不明";
   color trendClr = (g_trend==1)? InpColorBuy: (g_trend==-1)? InpColorSell: cMute;
   ELbl(g_prefix+"info_trend","趋势: "+trendTxt, rx+PD, cy+PD+22, F(10), trendClr);

   // 行2: 开仓权限
   string dirTxt = "";
   if(g_allow_buy && g_allow_sell) dirTxt = "多空均开仓";
   else if(g_allow_buy) dirTxt = "仅多开仓";
   else if(g_allow_sell) dirTxt = "仅空开仓";
   else dirTxt = "开仓已全停";
   color dirClr = (g_allow_buy||g_allow_sell)? cOk: cBad;
   ELbl(g_prefix+"info_dir","开仓: "+dirTxt, rx+PD, cy+PD+22+LH, F(10), dirClr);

   // 行3: 加仓状态
   string gridTxt = "";
   if(g_allow_grid_buy && g_allow_grid_sell) gridTxt = "多空均加仓";
   else if(g_allow_grid_buy) gridTxt = "仅多加仓";
   else if(g_allow_grid_sell) gridTxt = "仅空加仓";
   else gridTxt = "加仓已全停";
   color gridClr = (g_allow_grid_buy||g_allow_grid_sell)? cOk: cBad;
   ELbl(g_prefix+"info_grid","加仓: "+gridTxt, rx+PD, cy+PD+22+LH*2, F(10), gridClr);

   // 行4: 对冲状态
   string hedgeTxt = (g_hedgeRatio>0)? "对冲开启(比例"+DoubleToString(g_hedgeRatio*100,0)+"%)": "对冲关闭";
   ELbl(g_prefix+"info_hedge","对冲: "+hedgeTxt, rx+PD, cy+PD+22+LH*3, F(10), cMute);

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
   GlobalVariableSet(g_prefix+"lot", g_lot);
   GlobalVariableSet(g_prefix+"tp",  g_tp);
   GlobalVariableSet(g_prefix+"sl",  g_sl);
   GlobalVariableSet(g_prefix+"trendGap",  (double)g_gridWithTrend);
   GlobalVariableSet(g_prefix+"hedgeR",    g_hedgeRatio);
   GlobalVariableSet(g_prefix+"hedgeMinP", g_hedgeMinProfit);
   GlobalVariableSet(g_prefix+"gridBuy",  (double)g_allow_grid_buy);
   GlobalVariableSet(g_prefix+"gridSell", (double)g_allow_grid_sell);
   GlobalVariableSet(g_prefix+"maxLayers", (double)g_maxLayers);
   GlobalVariableSet(g_prefix+"lotInc",    g_lotIncrement);
}
bool LoadParamsFromGV()
{
   if(!GlobalVariableCheck(g_prefix+"lot")) return false;
   if(!GlobalVariableCheck(g_prefix+"tp"))  return false;
   if(!GlobalVariableCheck(g_prefix+"sl"))  return false;
   g_lot = GlobalVariableGet(g_prefix+"lot");
   g_tp  = (int)GlobalVariableGet(g_prefix+"tp");
   g_sl  = (int)GlobalVariableGet(g_prefix+"sl");
   if(g_lot<=0) g_lot=InpLotSize;
   // 0 是合法值 = 不启用止盈/止损，不要覆盖
   // 加载面板可修改的运行时参数(如果存在)
   if(GlobalVariableCheck(g_prefix+"trendGap"))  g_gridWithTrend  = (int)GlobalVariableGet(g_prefix+"trendGap");
   if(GlobalVariableCheck(g_prefix+"hedgeR"))    g_hedgeRatio     = GlobalVariableGet(g_prefix+"hedgeR");
   if(GlobalVariableCheck(g_prefix+"hedgeMinP")) g_hedgeMinProfit = GlobalVariableGet(g_prefix+"hedgeMinP");
   if(GlobalVariableCheck(g_prefix+"gridBuy"))   g_allow_grid_buy  = (GlobalVariableGet(g_prefix+"gridBuy")>0);
   if(GlobalVariableCheck(g_prefix+"gridSell"))  g_allow_grid_sell = (GlobalVariableGet(g_prefix+"gridSell")>0);
   if(GlobalVariableCheck(g_prefix+"maxLayers")) g_maxLayers      = (int)GlobalVariableGet(g_prefix+"maxLayers");
   if(GlobalVariableCheck(g_prefix+"lotInc"))    g_lotIncrement   = GlobalVariableGet(g_prefix+"lotInc");
   return true;
}
//| 读取输入框                                                        |
//+------------------------------------------------------------------+
void ReadEdits()
{
   string t;
   double v;
   if(ObjectFind(0,g_prefix+"e1_lot")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e1_lot",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_lot=v;
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
   if(ObjectFind(0,g_prefix+"e3_trend")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e3_trend",OBJPROP_TEXT);
      v=(double)StringToInteger(t); if(v>0) g_gridWithTrend=(int)v;
   }
   if(ObjectFind(0,g_prefix+"e4_hedge")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e4_hedge",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0 && v<=1) g_hedgeRatio=v;
   }
   if(ObjectFind(0,g_prefix+"e5_minP")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e5_minP",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>=0) g_hedgeMinProfit=v;
   }
   if(ObjectFind(0,g_prefix+"e6_maxL")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e6_maxL",OBJPROP_TEXT);
      v=(double)StringToInteger(t); if(v>0) g_maxLayers=(int)v;
   }
   if(ObjectFind(0,g_prefix+"e7_inc")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e7_inc",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_lotIncrement=v;
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
      if(m_pos.Symbol()!=_Symbol || m_pos.Magic()!=g_currentMagic) continue;
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
      if(OrderGetInteger(ORDER_MAGIC)!=g_currentMagic) continue;
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
   // 基础间距 = depth*100 + 100
   int base = maxCounterDepth * 100 + 100;
   // 扣减: 比最大逆向层更小的周期如果恢复了(同向), 每层-10
   int recoverySubtract = 0;
   int startCheckIdx = 8 - maxCounterDepth; // 最大逆向层索引+1
   for(int i=startCheckIdx; i<7; i++)
   {
      int dir = GetGridMADir(i, 1);
      bool isSame = (trendDir==1 && dir==1) || (trendDir==-1 && dir==-1);
      if(isSame) recoverySubtract += 10;
   }
   int result = base - recoverySubtract;
   if(result < maxCounterDepth * 100) result = maxCounterDepth * 100; // 不低于本级基数
   return result;
}
//+------------------------------------------------------------------+
//| 获取逆向深度 (面板/止盈共用)                                          |
//+------------------------------------------------------------------+
int GetCounterDepth(const int trendDir)
{
   int maxCounterDepth;
   for(int i=0; i<7; i++)
   {
      int dir = GetGridMADir(i, 1);
      bool isCounter = (trendDir==1 && dir==-1) || (trendDir==-1 && dir==1);
      if(isCounter) return 7 - i;
   }
   return 0;
}
//+------------------------------------------------------------------+
//| 交易操作                                                          |
//+------------------------------------------------------------------+
void DoBuy()
{
   double ask;
   double lot;
   ReadEdits();
   if(!g_allow_buy){ Print("[面板]多单已暂停");return; }
   if(!CanTrade()) return;
   // 检查最大层数
   if(g_gridLayer >= g_maxLayers && g_maxLayers > 0)
   {
      Print("[网格加仓] 多单已达最大层数 ",g_maxLayers,", 停止加仓");
      return;
   }
   // 计算递增手数
   lot = g_lotBase + g_gridLayer * g_lotIncrement;
   if(lot < InpLotSize) lot = InpLotSize;
   ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   m_trade.SetExpertMagicNumber(g_currentMagic);
   if(m_trade.Buy(lot,_Symbol,ask,0,0,"EMA多"))
   {
      Print("[开多] ",_Symbol," @ ",ask," 手数:",lot,
            " 阶段:",g_magicPhase," 层数:",g_gridLayer,
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
   double bid;
   double lot;

   ReadEdits();
   if(!g_allow_sell){ Print("[面板]空单已暂停");return; }
   if(!CanTrade()) return;
   // 检查最大层数
   if(g_gridLayer >= g_maxLayers && g_maxLayers > 0)
   {
      Print("[网格加仓] 空单已达最大层数 ",g_maxLayers,", 停止加仓");
      return;
   }
   // 计算递增手数
   lot = g_lotBase + g_gridLayer * g_lotIncrement;
   if(lot < InpLotSize) lot = InpLotSize;
   bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   m_trade.SetExpertMagicNumber(g_currentMagic);
   if(m_trade.Sell(lot,_Symbol,bid,0,0,"EMA空"))
   {
      Print("[开空] ",_Symbol," @ ",bid," 手数:",lot,
            " 阶段:",g_magicPhase," 层数:",g_gridLayer,
            " SL/TP=主动监听");
      g_lastFailTime = 0; // 成功后清除失败标记
      g_gridLastSell = bid; // 更新网格参考价
      g_gridLayer++;        // 层数+1
   }
   else
      OnOrderFailed(m_trade.ResultRetcodeDescription());
}
void CloseEaOrders(const int dir, const bool only_profit, const bool only_loss)
{
   double p;
   int pt;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol||m_pos.Magic()!=g_currentMagic) continue;
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
   if(dir==POSITION_TYPE_BUY)  { g_gridLastBuy=0;  g_gridLayer=0; g_lotBase=InpLotSize; }
   if(dir==POSITION_TYPE_SELL){ g_gridLastSell=0; g_gridLayer=0; g_lotBase=InpLotSize; }
}
//+------------------------------------------------------------------+
//| 平仓所有阶段订单 (趋势转变时用)                                     |
//+------------------------------------------------------------------+
void CloseAllEaOrders()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol) continue;
      // 平掉所有本EA的订单(不管魔术码)
      if(m_pos.Magic()==InpMagicNumber || 
         (m_pos.Magic()%111111==0 && m_pos.Magic()>=111111 && m_pos.Magic()<=999999))
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
   g_lotBase=InpLotSize;
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
   g_lotBase=InpLotSize;
}
void CloseAll()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(m_pos.SelectByIndex(i)&&m_pos.Symbol()==_Symbol&&m_pos.Magic()==g_currentMagic)
         m_trade.PositionClose(m_pos.Ticket());
   g_gridLastBuy=0;
   g_gridLastSell=0;
   g_gridLayer=0;
   g_lotBase=InpLotSize;
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
//| 计算当前D1趋势方向所有持仓的总盈利(浮盈+当天已实现)                    |
//+------------------------------------------------------------------+
double GetTrendProfit()
{
   double profit = 0;
   // 浮盈: 所有顺势持仓
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol) continue;
      bool isBuy  = (m_pos.PositionType()==POSITION_TYPE_BUY);
      bool isTrend = (g_trend==1 && isBuy) || (g_trend==-1 && !isBuy);
      if(!isTrend) continue;
      profit += m_pos.Profit() + m_pos.Swap();
   }
   // 当天已实现盈利(不限魔术码, 品种匹配即可)
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   datetime todayStart = StringToTime(StringFormat("%04d.%02d.%02d", dt.year, dt.mon, dt.day));
   if(HistorySelect(todayStart, TimeCurrent()))
   {
      int total = HistoryDealsTotal();
      for(int i=total-1; i>=0; i--)
      {
         ulong dealTicket = HistoryDealGetTicket(i);
         if(dealTicket==0) continue;
         if(HistoryDealGetInteger(dealTicket, DEAL_ENTRY) != DEAL_ENTRY_OUT) continue;
         if(HistoryDealGetString(dealTicket, DEAL_SYMBOL) != _Symbol) continue;
         int dType = (int)HistoryDealGetInteger(dealTicket, DEAL_TYPE);
         if(dType==DEAL_TYPE_BUY || dType==DEAL_TYPE_SELL)
            profit += HistoryDealGetDouble(dealTicket, DEAL_PROFIT);
      }
   }
   return profit;
}
//+------------------------------------------------------------------+
//| D1 EMA14趋势导向对冲: 顺势盈利 → 平逆势亏损单                        |
//| 核心原则:                                                           |
//|   1. D1 EMA14 趋势方向是唯一裁判                                     |
//|   2. 顺势单 = 赚钱机器, 逆势单 = 待解决的问题                          |
//|   3. 趋势越强, 对冲越激进 (strengthFactor 0.8~1.8)                   |
//|   4. 从最远的逆势亏损单开始消化, 逐个击破                              |
//+------------------------------------------------------------------+
void HedgeOldPositions()
{
   double ask;
   double availableProfit;
   double bid;
   double currentLoss;
   double currentLots;
   double dist;
   double emaDeviation;
   double entry;
   double hedgeAmount;
   double hedgeLots;
   double l;
   double loss;
   double perLotLoss;
   double pt;
   double step;
   double strengthFactor;
   double trendProfit;
   double remLoss;
   int    remCnt;
   int    lastMagic;
   if(g_trend == 0) return;  // 无明确趋势, 不处理对冲
   // ── 对冲方向实时跟随D1趋势 ──
   g_hedgeOldTrend = -g_trend;  // 面板显示: 当前正在消化的逆势方向
   pt     = Pt();
   bid    = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   ask    = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   int    digits = (int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   // ── 1. 收集所有逆势亏损持仓 (方向与D1趋势相反) ──
   struct CounterPos
   {
      ulong  ticket;
      double lots;
      double entry;
      double loss;    // 当前浮亏(正数)
      double dist;    // 入场价到市场价距离(点), 负值=逆势方向
      bool   isBuy;
      int    magic;
   };
   CounterPos counter[100];
   int counterCnt = 0;
   for(int i=PositionsTotal()-1; i>=0 && counterCnt<100; i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol) continue;
      bool isBuy     = (m_pos.PositionType()==POSITION_TYPE_BUY);
      bool isCounter = (g_trend==1 && !isBuy) || (g_trend==-1 && isBuy);
      if(!isCounter) continue;
      loss = -(m_pos.Profit()+m_pos.Swap());
      if(loss <= 0) continue;  // 不亏的不需要对冲
      entry = m_pos.PriceOpen();
      dist  = isBuy ? (bid-entry)/pt : (entry-ask)/pt;
      counter[counterCnt].ticket = m_pos.Ticket();
      counter[counterCnt].lots   = m_pos.Volume();
      counter[counterCnt].entry  = entry;
      counter[counterCnt].loss   = loss;
      counter[counterCnt].dist   = dist;
      counter[counterCnt].isBuy  = isBuy;
      counter[counterCnt].magic  = (int)m_pos.Magic();
      counterCnt++;
   }
   // 没有逆势亏损单 → 清除标记, 退出
   if(counterCnt == 0)
   {
      bool hasAnyCounter = false;
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         if(!m_pos.SelectByIndex(i)) continue;
         if(m_pos.Symbol()!=_Symbol) continue;
         bool isBuy=(m_pos.PositionType()==POSITION_TYPE_BUY);
         if((g_trend==1&&!isBuy)||(g_trend==-1&&isBuy)) { hasAnyCounter=true; break; }
      }
      if(!hasAnyCounter) { g_hedgeOldMagic=0; g_hedgeOldTrend=0; }
      return;
   }
   // ── 2. 计算顺势方向总盈利 ──
   trendProfit = GetTrendProfit();
   if(trendProfit < g_hedgeMinProfit) return;
   // ── 3. D1 EMA14 趋势强度因子 ──
   double ema[1], close[1];
   strengthFactor = 1.0;
   if(CopyBuffer(g_emaHandle,0,1,1,ema)>0 &&
      CopyClose(_Symbol,PERIOD_D1,1,1,close)>0 && ema[0]>0)
   {
      emaDeviation = MathAbs((close[0]-ema[0])/ema[0]) * 100;
      strengthFactor = 0.8 + MathMin(emaDeviation / 2.5, 1.0);  // 范围 0.8~1.8
   }
   // ── 4. 排序: 距离最远(亏损最深)的逆势单优先 ──
   for(int i=0; i<counterCnt-1; i++)
      for(int j=i+1; j<counterCnt; j++)
         if(counter[j].dist < counter[i].dist)
         {
            CounterPos tmp = counter[i];
            counter[i] = counter[j];
            counter[j] = tmp;
         }
   // ── 5. 逐个消化逆势亏损单 ──
   availableProfit = trendProfit * g_hedgeRatio * strengthFactor;
   if(availableProfit < g_hedgeMinProfit) return;
   bool hedged = false;
   for(int i=0; i<counterCnt && availableProfit>=g_hedgeMinProfit; i++)
   {
      if(counter[i].ticket == 0) continue;
      if(!PositionSelectByTicket(counter[i].ticket)) continue;
      currentLoss  = -(PositionGetDouble(POSITION_PROFIT) +
                              PositionGetDouble(POSITION_SWAP));
      if(currentLoss <= 0) continue;  // 已回本, 跳过
      currentLots = PositionGetDouble(POSITION_VOLUME);
      perLotLoss  = currentLoss / currentLots;
      if(perLotLoss <= 0) continue;
      hedgeLots = availableProfit / perLotLoss;
      hedgeLots = MathMin(hedgeLots, currentLots);
      step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
      if(step <= 0) step = InpHedgeMinLots;
      hedgeLots = MathFloor(hedgeLots / step) * step;
      hedgeLots = NormalizeDouble(hedgeLots, 2);
      if(hedgeLots < InpHedgeMinLots) continue;
      hedgeAmount = hedgeLots * perLotLoss;
      if(DoPartialClose(counter[i].ticket, hedgeLots, InpSlippage))
      {
         hedged = true;
         availableProfit -= hedgeAmount;
         Print("════════════════════════════════");
         Print("[D1趋势对冲] 顺势盈利: $",DoubleToString(trendProfit,2),
               " 趋势强度: ",DoubleToString(strengthFactor,2),
               " 可用: $",DoubleToString(availableProfit+hedgeAmount,2));
         Print("  逆势单: #",counter[i].ticket," ",counter[i].isBuy?"BUY":"SELL",
               " 魔术码:",counter[i].magic,
               " 入场:",DoubleToString(counter[i].entry,digits),
               " 亏损: $",DoubleToString(currentLoss,2),
               " 距离: ",DoubleToString(counter[i].dist,1),"点");
         Print("  部分平仓: ",DoubleToString(hedgeLots,2),"/",
               DoubleToString(currentLots,2),"手 消化≈$",
               DoubleToString(hedgeAmount,2),
               " 剩余可用: $",DoubleToString(availableProfit,2));
         Print("════════════════════════════════");
      }
   }
   // ── 6. 更新面板状态标记 ──
   if(hedged)
   {
      remLoss=0; remCnt=0; lastMagic=0;
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         if(!m_pos.SelectByIndex(i)) continue;
         if(m_pos.Symbol()!=_Symbol) continue;
         bool isBuy=(m_pos.PositionType()==POSITION_TYPE_BUY);
         if((g_trend==1&&!isBuy)||(g_trend==-1&&isBuy))
         {
            l=-(m_pos.Profit()+m_pos.Swap());
            if(l<=0) continue;
            remLoss+=l; remCnt++; lastMagic=(int)m_pos.Magic();
         }
      }
      g_hedgeOldMagic = (remCnt>0) ? lastMagic : 0;
      // g_hedgeOldTrend 已在函数入口随 g_trend 实时设置
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
         if(counterInt < rawInterval * 100) counterInt = rawInterval * 100; // 不低于本级基数
      }
      // 深度不变 → 间距不变
   }
   g_gridLastBar = iTime(_Symbol,PERIOD_CURRENT,0);
   g_gridLastDepth = rawInterval;
   g_gridCounterInterval = counterInt;
   int withInt = g_gridWithTrend;
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
   double t;
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
   // ── 开多 ──
   if(k == "btn_buy")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确认开多单？\n手数: "+DoubleToString(g_lot,2)+"  品种: "+_Symbol))
         return;
      ReadEdits();
      DoBuy();
      RefreshPanel(true);
      return;
   }
   // ── 开空 ──
   if(k == "btn_sell")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确认开空单？\n手数: "+DoubleToString(g_lot,2)+"  品种: "+_Symbol))
         return;
      ReadEdits();
      DoSell();
      RefreshPanel(true);
      return;
   }
   // ── 平多 ──
   if(k == "cp_allL")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉全部多单吗？\n当前: "+
         IntegerToString(stats.buy_cnt)+" 单  "+DoubleToString(stats.buy_lot,2)+" 手"))
         return;
      CloseDir(POSITION_TYPE_BUY);
      RefreshPanel(true);
      return;
   }
   // ── 平空 ──
   if(k == "cp_allS")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉全部空单吗？\n当前: "+
         IntegerToString(stats.sell_cnt)+" 单  "+DoubleToString(stats.sell_lot,2)+" 手"))
         return;
      CloseDir(POSITION_TYPE_SELL);
      RefreshPanel(true);
      return;
   }
   // ── 一键全平 ──
   if(k == "btn_closeAll")
   {
      ResetPanelButtonState(sparam);
      int total = stats.buy_cnt + stats.sell_cnt;
      if(!ShowConfirmDialog("确定要一键全平全部持仓吗？\n当前: "+
         IntegerToString(total)+" 单  品种: "+_Symbol))
         return;
      // 异步全平多单+空单
      CpStartAsync(POSITION_TYPE_BUY, 1, 0);
      CpStartAsync(POSITION_TYPE_SELL, 1, 0);
      RefreshPanel(true);
      return;
   }
   // ── 平盈利多 ──
   if(k == "cp_profL")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉盈利多单吗？\n(仅平仓浮盈>0的多单)"))
         return;
      CpStartAsync(POSITION_TYPE_BUY, 2, 0);
      RefreshPanel(true);
      return;
   }
   // ── 平亏损多 ──
   if(k == "cp_lossL")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉亏损多单吗？\n(仅平仓浮盈<=0的多单)"))
         return;
      CpStartAsync(POSITION_TYPE_BUY, 3, 0);
      RefreshPanel(true);
      return;
   }
   // ── 平盈利空 ──
   if(k == "cp_profS")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉盈利空单吗？\n(仅平仓浮盈>0的空单)"))
         return;
      CpStartAsync(POSITION_TYPE_SELL, 2, 0);
      RefreshPanel(true);
      return;
   }
   // ── 平亏损空 ──
   if(k == "cp_lossS")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉亏损空单吗？\n(仅平仓浮盈<=0的空单)"))
         return;
      CpStartAsync(POSITION_TYPE_SELL, 3, 0);
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
      if(ss.cnt==0){ Print("[手动平仓] 没有多单"); RefreshPanel(true); return; }
      targetLots = ss.lots * pct / 100.0;
      msg = "多单百分比平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(targetLots,2)+" 手 ("+DoubleToString(pct,1)+"%)\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      CpStartAsync(POSITION_TYPE_BUY, 4, pct);
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
      if(ss.cnt==0){ Print("[手动平仓] 没有多单"); RefreshPanel(true); return; }
      msg = "多单固定手数平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(lots,2)+" 手\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      CpStartAsync(POSITION_TYPE_BUY, 5, lots);
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
      if(ss.cnt==0){ Print("[手动平仓] 没有多单"); RefreshPanel(true); return; }
      dirDesc = g_longCloseDir ? "从下向上(先平开仓价最低)" : "从上向下(先平开仓价最高)";
      msg = "多单按序平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(lots,2)+" 手\n";
      msg += "方向: "+dirDesc+"\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      CpStartAsync(POSITION_TYPE_BUY, 6, lots);
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
      if(ss.cnt==0){ Print("[手动平仓] 没有空单"); RefreshPanel(true); return; }
      targetLots = ss.lots * pct / 100.0;
      msg = "空单百分比平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(targetLots,2)+" 手 ("+DoubleToString(pct,1)+"%)\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      CpStartAsync(POSITION_TYPE_SELL, 4, pct);
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
      if(ss.cnt==0){ Print("[手动平仓] 没有空单"); RefreshPanel(true); return; }
      msg = "空单固定手数平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(lots,2)+" 手\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      CpStartAsync(POSITION_TYPE_SELL, 5, lots);
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
      if(ss.cnt==0){ Print("[手动平仓] 没有空单"); RefreshPanel(true); return; }
      dirDesc = g_shortCloseDir ? "从下向上(先平开仓价最低)" : "从上向下(先平开仓价最高)";
      msg = "空单按序平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(lots,2)+" 手\n";
      msg += "方向: "+dirDesc+"\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      CpStartAsync(POSITION_TYPE_SELL, 6, lots);
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
   // ── 重置网格 ──
   if(k == "btn_reset_grid")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要重置网格状态吗？\n将清零加仓层数，重置间距为默认值。"))
         return;
      g_gridLayer = 0;
      g_gridCounterInterval = g_gridWithTrend;
      g_gridRecoveryBars = 0;
      g_gridLastBuy = 0;
      g_gridLastSell = 0;
      g_lotBase = InpLotSize;
      Print("[面板] 网格已重置");
      RefreshPanel(true);
      return;
   }
   // ── 切换阶段 ──
   if(k == "btn_switch_phase")
   {
      ResetPanelButtonState(sparam);
      int newPhase = (g_magicPhase == 1) ? 2 : 1;
      int newMagic = (newPhase == 1) ? 111111 : 222222;
      if(!ShowConfirmDialog("确定要切换阶段吗？\n"
         "当前: 阶段"+IntegerToString(g_magicPhase)+" (魔术码"+IntegerToString(g_currentMagic)+")\n"
         "切换到: 阶段"+IntegerToString(newPhase)+" (魔术码"+IntegerToString(newMagic)+")\n\n"
         "注意: 这不会影响已有持仓，只影响后续新开单。"))
         return;
      g_magicPhase = newPhase;
      g_currentMagic = newMagic;
      g_gridLayer = 0;
      g_lotBase = InpLotSize;
      m_trade.SetExpertMagicNumber(g_currentMagic);
      Print("[面板] 已切换到阶段", newPhase, " 魔术码:", newMagic);
      RefreshPanel(true);
      return;
   }
}
//+==================================================================+
//| 生命周期                                                          |
//+==================================================================+
int OnInit()
{
   m_trade.SetExpertMagicNumber(g_currentMagic);
   m_trade.SetDeviationInPoints(InpSlippage);
   m_trade.SetTypeFillingBySymbol(_Symbol);
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
      g_lot=InpLotSize; g_tp=InpTakeProfit; g_sl=InpStopLoss;
      g_gridWithTrend  = InpGridWithTrend;
      g_hedgeRatio     = InpHedgeRatio;
      g_hedgeMinProfit = InpHedgeMinProfit;
      g_maxLayers      = InpMaxGridLayers;
      g_lotIncrement   = InpLotIncrement;
      SaveParamsToGV();
   }
   g_px=InpPanelX; g_py=InpPanelY; ClampPanelPosition(g_px,g_py);
   EventSetTimer(1);  // 1秒Timer
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,true);
   RefreshPanel(true); ChartRedraw(0);
   Print("[均线策略网格系统 v2.52] D1 EMA",InpEMA_Period," + MA10 7周期网格启动 ",_Symbol,
         " 对冲方向随D1趋势实时翻转 / 手动平仓只平本品种");
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
   Print("[v2.52 已停止]");
}
void OnTick()
{
   double oldCounterLoss;
   double newCounterLoss;
   int    oldCounterCnt;
   int    newCounterCnt;
   double oldTrendProfit;
   double newTrendProfit;
   g_trend=DetectTrend();

   // 趋势转变检测
   if(g_lastTrend!=0 && g_trend!=0 && g_trend!=g_lastTrend)
   {
      // 趋势转变: 切换魔术码阶段
      g_magicPhase++;
      if(g_magicPhase>9) g_magicPhase=1; // 循环 1-9
      g_currentMagic = g_magicPhase * 111111; // 111111, 222222, ..., 999999

      // 重置手数基数和层数
      g_lotBase = InpLotSize; // 从input参数开始
      g_gridLayer = 0;

      // ── 统计新旧逆势单 ──
      oldCounterLoss=0; newCounterLoss=0;
      oldCounterCnt=0;  newCounterCnt=0;
      oldTrendProfit=0; newTrendProfit=0;
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         if(!m_pos.SelectByIndex(i)) continue;
         if(m_pos.Symbol()!=_Symbol) continue;
         bool isBuy=(m_pos.PositionType()==POSITION_TYPE_BUY);
         double p = m_pos.Profit()+m_pos.Swap();

         // 旧趋势方向(刚变成逆势): g_lastTrend方向 → 需要被对冲
         bool wasTrend = (g_lastTrend==1 && isBuy) || (g_lastTrend==-1 && !isBuy);
         // 新趋势方向(刚变成顺势): g_trend方向 → 为对冲提供资金
         bool isTrend  = (g_trend==1 && isBuy) || (g_trend==-1 && !isBuy);

         if(wasTrend)  { if(p<0){ oldCounterLoss-=p; oldCounterCnt++; } else oldTrendProfit+=p; }
         if(isTrend)   { newTrendProfit+=p;                 if(p>0){} else{ newCounterLoss-=p; newCounterCnt++; }  } // 新方向也有亏损的话记上
      }

      Print("════════════════════════════════");
      Print("[趋势翻转] ",g_lastTrend==1?"多头 → 空头":"空头 → 多头",
            "  新魔术码:",g_currentMagic);
      Print("  对冲方向切换: 旧趋势",g_lastTrend==1?"BUY":"SELL",
            "单元(",oldCounterCnt,"单 浮亏$",DoubleToString(oldCounterLoss,1),
            ") → 现在消化");
      Print("  新趋势",g_trend==1?"BUY":"SELL",
            "单元(浮盈$",DoubleToString(newTrendProfit,1),
            ") → 为对冲提供资金");
      Print("  对冲方向已随D1趋势实时翻转!");
      Print("════════════════════════════════");

      // 对冲方向已切换, HedgeOldPositions会立即用新趋势消化旧方向逆势单
   }
   g_lastTrend = g_trend;

   CheckEntry();
   CheckTPSL();
   HedgeOldPositions();  // D1趋势导向对冲: 顺势盈利→平逆势亏损
   // 某方向全部平仓 → 重置网格参考价, 等趋势再开首单
   if(CountDir(POSITION_TYPE_BUY)==0)  g_gridLastBuy=0;
   if(CountDir(POSITION_TYPE_SELL)==0) g_gridLastSell=0;
}
void OnTimer()
{
   g_trend=DetectTrend();
   if(g_panel_open){ ReadEdits(); SaveParamsToGV(); }
   CpAsyncTick();  // 异步平仓Tick
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
