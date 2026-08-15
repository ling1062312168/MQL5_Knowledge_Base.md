//+------------------------------------------------------------------+
//|                                               均线策略网格系统.mq5  |
//|                                    Copyright 2025, 打工仔         |
//|                                    Version 2.52 — 对冲方向随趋势实时翻转 (修复版)             |
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
//| 面板布局常量 — 统一间距体系                                        |
//+------------------------------------------------------------------+
// 核心间距常量(统一命名，消除混用)
// INNER: 元素内部间距 / OUTER: 外层边距 / CARD_GAP: 卡片间间距
#define PW              720       // 面板总宽度
#define OUTER           12        // 面板外边距 (原 PD)
#define INNER           6         // 元素内部间距 (原 PG)
#define CARD_GAP        10        // 卡片间距 (原 SG)
// 基础行高
#define LH              22        // 标准文本行高
// 按钮与输入框
#define BH              28        // 按钮高度
#define EW              60        // 输入框宽度(统一)
#define EH              24        // 输入框高度
// 标题栏
#define HDR_H           54        // 标题栏高度
// 左栏宽度
#define LW              (PW*4/10 - OUTER)  // ~270
// 右栏宽度(不含边距)
#define RW              (PW*6/10 - OUTER)  // ~402
// 布局尺寸常量
#define HALF_W          ((LW - INNER)/2)
#define THIRD_W         ((LW - INNER*2)/3)
// 平仓管理区尺寸(统一)
#define cp_LblW         90        // 标签列宽
#define cp_EdW1         64        // 输入框宽(大)
#define cp_EdW2         44        // 输入框宽(小)
#define cp_BtnW         36        // 抽取按钮宽
#define cp_RowH         24        // 行高
// ===== 左栏卡片高度计算 =====
// 状态卡: 标题区(PD头+标题) + 12行数据
// 结构: [PD头16] + [标题18] + [间隔8] + [12行×LH] + [底部16]
#define CH_STATUS       (16 + 18 + 8 + 12*LH + 16)
// 参数卡: 标题区 + 5行输入 + 按钮区
// 结构: [头16] + [标题18] + [间隔8] + [5行×LH] + [gap6] + [按钮行BH] + [gap6] + [按钮行BH] + [底部16]
#define CH_PARAMS       (16 + 18 + 8 + 5*LH + INNER + BH + INNER + BH + 16)
// 加仓控制卡: 标题区 + 2行按钮 (统一用 cp_RowH=24)
// 结构: [头16] + [标题18] + [间隔8] + [2行×(cp_RowH+gap)] + [底部16] = 110
#define CH_GRID_CTRL    (16 + 18 + 8 + 2*(cp_RowH + INNER) + 16)
// 左栏总高 = 状态卡 + 间距 + 参数卡 + 间距 + 加仓卡
#define LEFT_COL_H      (CH_STATUS + CARD_GAP + CH_PARAMS + CARD_GAP + CH_GRID_CTRL)
// ===== 右栏高度 = 左栏高度（方案B：统一为1张大卡） =====
#define RIGHT_COL_H     LEFT_COL_H
// 总高 = 标题栏 + 间距 + 左栏（或右栏）
#define TOTAL_H         (HDR_H + CARD_GAP + LEFT_COL_H)
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
struct CpStats
{
   double lots;
   int    cnt;
   double pnl;
};
//+------------------------------------------------------------------+
//| 全局变量                                                          |
//+------------------------------------------------------------------+
CTrade         m_trade;
CPositionInfo  m_pos;
string         g_prefix        = "GP_";
int            g_emaHandle     = INVALID_HANDLE;
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
datetime       g_lastFailTime  = 0;
string         g_lastFailMsg   = "";
bool           g_allow_grid_buy  = true;
bool           g_allow_grid_sell = true;
double         g_gridLastBuy   = 0;
double         g_gridLastSell  = 0;
int            g_gridCounterInterval=200;
int            g_gridRecoveryBars = 0;
datetime       g_gridLastBar   = 0;
int            g_gridLastDepth  = 0;
int            g_lastTrend      = 0;
int            g_magicPhase     = 1;
int            g_currentMagic   = 111111;
double         g_lotBase        = 0.01;
int            g_gridLayer      = 0;
int            g_hedgeOldMagic  = 0;
int            g_hedgeOldTrend  = 0;
bool           g_cpAsync[2]    = {false, false};
int            g_cpAsyncMode[2] = {0, 0};
double         g_cpAsyncVal[2]  = {0.0, 0.0};
int            g_cpAsyncIdx[2]   = {0, 0};
ulong          g_cpAsyncTick[2]  = {0, 0};  // 修复: datetime → ulong (毫秒级限速)
bool           g_longCloseDir  = false;
bool           g_shortCloseDir = false;
int            g_gridWithTrend  = 100;
double         g_hedgeRatio     = 0.5;
double         g_hedgeMinProfit = 5.0;
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
//| UI 对象创建                                                        |
//+------------------------------------------------------------------+
void ERect(string nm, int x, int y, int w, int h, color bg, color bd, int cr=CORNER_LEFT_UPPER)
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
void ELbl(string nm, string txt, int x, int y, int fs, color clr, int cr=CORNER_LEFT_UPPER)
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
void EBtn(string nm, string txt, int x, int y, int w, int h, color bg, color fg, int cr=CORNER_LEFT_UPPER)
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
      ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,C'40,42,52');
      ObjectSetInteger(0,nm,OBJPROP_BORDER_COLOR,C'70,72,85');
      ObjectSetInteger(0,nm,OBJPROP_COLOR,cWhite);
      ObjectSetInteger(0,nm,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,nm,OBJPROP_BACK,false);
   }
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
        g_px + OUTER, g_py + HDR_H - BH - OUTER, 90, BH, C'56,132,216',cWhite,CORNER_LEFT_LOWER);
}
//+------------------------------------------------------------------+
//| 确认对话框                                                        |
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
//| 平仓统计                                                          |
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
   g_cpAsyncTick[idx]  = GetTickCount();
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
   Print("[手动平仓] 启动异步 ", modeStr, " ", cnt, " 单 ", pt==POSITION_TYPE_BUY?"多单":"空单", " ", _Symbol);
}
//+------------------------------------------------------------------+
//| 部分平仓                                                          |
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
//| 异步平仓Tick (修复: 使用毫秒级限速)                                  |
//+------------------------------------------------------------------+
void CpAsyncTick()
{
   CTrade cpTrade;
   cpTrade.SetExpertMagicNumber(0);
   cpTrade.SetDeviationInPoints(30);
   for(int idx=0; idx<2; idx++)
   {
      if(!g_cpAsync[idx]) continue;
      ENUM_POSITION_TYPE pt = (idx==0) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
      int  mode = g_cpAsyncMode[idx];
      double val  = g_cpAsyncVal[idx];
      // 修复: 使用毫秒级限速，每500ms最多平一单
      if(GetTickCount() - g_cpAsyncTick[idx] < 500) continue;
      ulong tickets[100];
      int   tcnt = 0;
      for(int i=PositionsTotal()-1;i>=0 && tcnt<100;i--)
      {
         if(PositionGetSymbol(i)=="") continue;
         if(PositionGetSymbol(i)!=_Symbol) continue;
         if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)!=pt) continue;
         ulong ticket = PositionGetInteger(POSITION_IDENTIFIER);
         double pnl  = PositionGetDouble(POSITION_PROFIT);
         bool needClose = false;
         switch(mode)
         {
            case 1: needClose = true; break;
            case 2: needClose = (pnl > 0); break;
            case 3: needClose = (pnl <= 0); break;
            case 4: case 5: case 6: needClose = true; break;
         }
         if(needClose)
         {
            tickets[tcnt] = ticket;
            tcnt++;
         }
      }
      if(tcnt == 0)
      {
         g_cpAsync[idx] = false;
         Print("[手动平仓] ", pt==POSITION_TYPE_BUY?"多单":"空单", " 异步平仓完成");
         continue;
      }
      if(mode == 4)  // 百分比转固定手数
      {
         double totalLots = 0;
         for(int k=0;k<tcnt;k++)
         {
            if(PositionSelectByTicket(tickets[k]))
               totalLots += PositionGetDouble(POSITION_VOLUME);
         }
         double targetLots = totalLots * val / 100.0;
         g_cpAsyncMode[idx] = 5;
         g_cpAsyncVal[idx]  = targetLots;
         mode = 5; val = targetLots;
         Print("[手动平仓] 百分比→固定手数: ", DoubleToString(targetLots,2), " 手");
      }
      if(mode == 5)  // 固定手数平仓
      {
         double closedLots = 0;
         for(int k=0;k<tcnt && closedLots<val;k++)
         {
            if(!PositionSelectByTicket(tickets[k])) continue;
            double lots = PositionGetDouble(POSITION_VOLUME);
            double closeLots = MathMin(lots, val - closedLots);
            if(DoPartialClose(tickets[k], closeLots, 30))
            {
               closedLots += closeLots;
               g_cpAsyncTick[idx] = GetTickCount();
               Print("[手动平仓] 固定手数 平 #", tickets[k], " ", closeLots>=lots?"全部":"部分", " ", DoubleToString(closeLots,2), " 手");
            }
         }
         g_cpAsync[idx] = false;
         Print("[手动平仓] 固定手数平仓完成, 共平 ", DoubleToString(closedLots,2), " 手");
         continue;
      }
      if(mode == 6)  // 按序平仓
      {
         ulong sorted[100]; ArrayCopy(sorted, tickets);
         for(int a=0;a<tcnt-1;a++)
            for(int b=a+1;b<tcnt;b++)
            {
               datetime ta=0, tb=0;
               if(PositionSelectByTicket(sorted[a])) ta = (datetime)PositionGetInteger(POSITION_TIME);
               if(PositionSelectByTicket(sorted[b])) tb = (datetime)PositionGetInteger(POSITION_TIME);
               if(ta > tb) { ulong tmp=sorted[a]; sorted[a]=sorted[b]; sorted[b]=tmp; }
            }
         double closedLots = 0;
         for(int k=0;k<tcnt && closedLots<val;k++)
         {
            if(!PositionSelectByTicket(sorted[k])) continue;
            double lots = PositionGetDouble(POSITION_VOLUME);
            double closeLots = MathMin(lots, val - closedLots);
            if(DoPartialClose(sorted[k], closeLots, 30))
            {
               closedLots += closeLots;
               g_cpAsyncTick[idx] = GetTickCount();
               Print("[手动平仓] 按序 平 #", sorted[k], " ", closeLots>=lots?"全部":"部分", " ", DoubleToString(closeLots,2), " 手");
            }
         }
         g_cpAsync[idx] = false;
         Print("[手动平仓] 按序平仓完成, 共平 ", DoubleToString(closedLots,2), " 手");
         continue;
      }
      // mode 1/2/3: 逐单平仓
      if(mode >= 1 && mode <= 3)
      {
         ulong ticket = tickets[g_cpAsyncIdx[idx]];
         if(PositionSelectByTicket(ticket))
         {
            if(cpTrade.PositionClose(ticket, 30))
            {
               Print("[手动平仓] ", mode==1?"全平":(mode==2?"平盈利":"平亏损"), " #", ticket, " ", _Symbol);
               g_cpAsyncTick[idx] = GetTickCount();
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
//| 绘制面板 — 横向双栏布局 (修复对齐问题)                              |
//+------------------------------------------------------------------+
void DrawPanel(EAStats &s)
{
   // 布局坐标计算
   int X = g_px;
   int LX = X + OUTER;                              // 左栏内容起始X
   int RX = LX + LW + CARD_GAP;                     // 右栏内容起始X (与左栏右边界隔CARD_GAP)
   int PW_ = PW - OUTER*2;                          // 可用宽度
   int RW_ = PW_ - LW - CARD_GAP;                   // 右栏可用宽度
   // 配色
   color BG_PANEL  = C'15,19,26';
   color BD_PANEL  = C'42,53,68';
   color BG_HDR    = C'22,29,42';
   color BG_CARD   = C'26,33,46';
   color cMute  = C'140,155,175';
   color cOk    = C'78,190,140';
   color cWarn  = C'245,176,68';
   color cBad   = C'230,100,97';
   // 状态文字
   string tTxt, tClr_Str;
   color tClr;
   if(g_trend==1)      { tTxt="▲ 多头"; tClr=InpColorBuy; }
   else if(g_trend==-1){ tTxt="▼ 空头"; tClr=InpColorSell; }
   else                { tTxt="-- 无信号"; tClr=cMute; }
   string pTxt="无持仓"; color pClr=cMute;
   if(s.buy_cnt>0&&s.sell_cnt>0)
      pTxt="多+空 "+IntegerToString(s.buy_cnt+s.sell_cnt)+" 单";
   else if(s.buy_cnt>0)
      { pTxt="多头 "+IntegerToString(s.buy_cnt)+" 单  "+DoubleToString(s.buy_lot,2)+" 手"; pClr=InpColorBuy; }
   else if(s.sell_cnt>0)
      { pTxt="空头 "+IntegerToString(s.sell_cnt)+" 单  "+DoubleToString(s.sell_lot,2)+" 手"; pClr=InpColorSell; }
   string rTxt; color rClr;
   if(!g_allow_buy&&!g_allow_sell){ rTxt="已暂停"; rClr=cBad; }
   else if(!g_allow_buy||!g_allow_sell){ rTxt="単边"; rClr=cWarn; }
   else if(g_trend==0){ rTxt="等待信号"; rClr=cMute; }
   else{ rTxt="正常运行"; rClr=cOk; }
   if(!g_panel_open){ DelContent(); DrawToggle(); return; }
   // 外框
   ERect(g_prefix+"panel",  X, g_py, PW, TOTAL_H, BG_PANEL, BD_PANEL);
   ERect(g_prefix+"header", X, g_py, PW, HDR_H, BG_HDR, BD_PANEL);
   ELbl(g_prefix+"title","均线策略网格系统",LX+4,g_py+10,F(15),cWhite);
   ELbl(g_prefix+"sub",_Symbol+"  |  "+EnumToString(InpEMA_TF)+" EMA"+IntegerToString(InpEMA_Period),LX+4,g_py+32,F(9),cMute);
   // ===== 左栏: 状态卡 =====
   int cy = g_py + HDR_H + CARD_GAP;
   ERect(g_prefix+"c1", X, cy, LW, CH_STATUS, BG_CARD, BD_PANEL);
   ELbl(g_prefix+"c1_title","状态",LX,cy+OUTER,F(12),cWhite);
   int ry = cy + OUTER + 20;
   // 12行状态数据 (统一行高 LH)
   ELbl(g_prefix+"r1_lbl","运行状态", LX,   ry, F(10), cMute);
   ELbl(g_prefix+"r1_val", rTxt,          LX+LW*4/10, ry, F(10), rClr);
   ELbl(g_prefix+"r2_lbl","趋势方向", LX,   ry+LH, F(10), cMute);
   ELbl(g_prefix+"r2_val", tTxt,          LX+LW*4/10, ry+LH, F(10), tClr);
   ELbl(g_prefix+"r3_lbl","当前持仓", LX,   ry+LH*2, F(10), cMute);
   ELbl(g_prefix+"r3_val", pTxt,          LX+LW*4/10, ry+LH*2, F(10), pClr);
   string gridStr = "逆势"+IntegerToString(g_gridCounterInterval)+"点";
   if(g_gridWithTrend>0) gridStr += " / 顺势"+IntegerToString(g_gridWithTrend)+"点";
   if(g_gridCounterInterval==-1) gridStr = "全部逆向(不加仓)";
   ELbl(g_prefix+"r4_lbl","网格间距", LX,   ry+LH*3, F(10), cMute);
   ELbl(g_prefix+"r4_val", gridStr,      LX+LW*4/10, ry+LH*3, F(10), g_gridCounterInterval==-1?cBad:cOk);
   string magicStr = IntegerToString(g_currentMagic)+" (阶段"+IntegerToString(g_magicPhase)+")";
   ELbl(g_prefix+"r5_lbl","魔术码",   LX,   ry+LH*4, F(10), cMute);
   ELbl(g_prefix+"r5_val", magicStr,     LX+LW*4/10, ry+LH*4, F(10), cWhite);
   double nextLot = g_lotBase + g_gridLayer * 0.01;
   string layerStr = "层数:"+IntegerToString(g_gridLayer)+" | 下次:"+DoubleToString(nextLot,2)+"手";
   ELbl(g_prefix+"r6_lbl","加仓进度", LX,   ry+LH*5, F(10), cMute);
   ELbl(g_prefix+"r6_val", layerStr,    LX+LW*4/10, ry+LH*5, F(10), cOk);
   int cDepth = GetCounterDepth(g_trend);
   int dynTP  = InpTakeProfit - g_gridLayer*20 + cDepth*25;
   if(dynTP<50) dynTP=50; if(dynTP>400) dynTP=400;
   string tpStr = "跑马灯 "+IntegerToString(dynTP)+"点 (深度"+IntegerToString(cDepth)+")";
   if(g_tp<=0) tpStr = "止盈已关闭";
   color tpClr = (g_tp>0&&g_gridLayer>0) ? cOk : cMute;
   ELbl(g_prefix+"r7_lbl","动态止盈", LX,   ry+LH*6, F(10), cMute);
   ELbl(g_prefix+"r7_val", tpStr,       LX+LW*4/10, ry+LH*6, F(10), tpClr);
   string hedgeStr, hedgeLabel; color hedgeClr;
   if(g_trend==0)
      { hedgeStr="无趋势,暂停对冲"; hedgeClr=cMute; hedgeLabel="对冲方向"; }
   else
   {
      string targetDir = (g_trend==1) ? "SELL" : "BUY";
      double cLoss=0; int cCnt=0; double l;
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         if(PositionGetSymbol(i)=="") continue;
         if(PositionGetSymbol(i)!=_Symbol) continue;
         bool isBuy=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
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
   ELbl(g_prefix+"r8_lbl",hedgeLabel,  LX,   ry+LH*7, F(10), cMute);
   ELbl(g_prefix+"r8_val", hedgeStr,    LX+LW*4/10, ry+LH*7, F(10), hedgeClr);
   // 入场信号强度
   string sigStr="--"; color sigClr=cMute;
   if(g_trend != 0)
   {
      double emaVal[1], closeArr[1];
      if(CopyClose(_Symbol,InpEMA_TF,0,1,closeArr)>0 && CopyBuffer(g_emaHandle,0,0,1,emaVal)>0)
      {
         double diff = MathAbs(closeArr[0]-emaVal[0]) / _Point;
         sigStr = "偏离 "+DoubleToString(diff,1)+" 点";
         sigClr = (diff > g_gridWithTrend*0.5) ? cOk : (diff > g_gridWithTrend*0.25 ? cWarn : cMute);
      }
   }
   ELbl(g_prefix+"r9_lbl","入场信号", LX,   ry+LH*8, F(10), cMute);
   ELbl(g_prefix+"r9_val", sigStr,     LX+LW*4/10, ry+LH*8, F(10), sigClr);
   // 当前点差
   long spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   string spStr = IntegerToString((int)spread)+" 点";
   color spClr = (spread <= 30) ? cOk : (spread <= 100 ? cWarn : cBad);
   ELbl(g_prefix+"r10_lbl","当前点差", LX,    ry+LH*9, F(10), cMute);
   ELbl(g_prefix+"r10_val", spStr,      LX+LW*4/10, ry+LH*9, F(10), spClr);
   // 网格状态摘要
   string lossStr = "层数:"+IntegerToString(g_gridLayer)+" | 间距:"+IntegerToString(g_gridCounterInterval);
   ELbl(g_prefix+"r11_lbl","网格状态", LX,    ry+LH*10, F(10), cMute);
   ELbl(g_prefix+"r11_val", lossStr,    LX+LW*4/10, ry+LH*10, F(10), (g_gridLayer>0)?cWarn:cOk);
   // 下次加仓手数
   string nxtStr = DoubleToString(nextLot,2)+" 手";
   ELbl(g_prefix+"r12_lbl","下次手数", LX,    ry+LH*11, F(10), cMute);
   ELbl(g_prefix+"r12_val", nxtStr,     LX+LW*4/10, ry+LH*11, F(10), cOk);
   // ===== 左栏: 参数设置卡 =====
   cy += CH_STATUS + CARD_GAP;
   ERect(g_prefix+"c2", X, cy, LW, CH_PARAMS, BG_CARD, BD_PANEL);
   ELbl(g_prefix+"c2_title","参数设置",LX,cy+OUTER,F(12),cWhite);
   int ey = cy + OUTER + 22;
    // 5行输入: 统一用 LH 行高, EW 宽度 (标签Y与输入框对齐, 去掉+2偏移)
    // 第1行: 手数 / 止盈
    ELbl(g_prefix+"e1_l1","手 数", LX, ey, F(10), cMute);
    EEdt(g_prefix+"e1_lot", DoubleToString(g_lot,2), LX+44, ey, EW, EH);
    ELbl(g_prefix+"e1_l2","止 盈", LX+112, ey, F(10), cMute);
    EEdt(g_prefix+"e1_tp",  IntegerToString(g_tp), LX+156, ey, EW, EH);
    ELbl(g_prefix+"e1_u2","点",    LX+220, ey, F(9), cMute);
    // 第2行: 止损
    ELbl(g_prefix+"e2_l2","止 损", LX+112, ey+LH, F(10), cMute);
    EEdt(g_prefix+"e1_sl",  IntegerToString(g_sl), LX+156, ey+LH, EW, EH);
    ELbl(g_prefix+"e2_u2","点",    LX+220, ey+LH, F(9), cMute);
    // 第3行: 顺势间距
    ELbl(g_prefix+"e3_l1","顺势间距", LX, ey+LH*2, F(10), cMute);
    EEdt(g_prefix+"e3_trend", IntegerToString(g_gridWithTrend), LX+44, ey+LH*2, EW, EH);
    ELbl(g_prefix+"e3_u1","点",    LX+108, ey+LH*2, F(9), cMute);
    // 第4行: 对冲比例
    ELbl(g_prefix+"e4_l1","对冲比例", LX, ey+LH*3, F(10), cMute);
    EEdt(g_prefix+"e4_hedge", DoubleToString(g_hedgeRatio,2), LX+44, ey+LH*3, EW, EH);
    // 第5行: 最小对冲
    ELbl(g_prefix+"e5_l1","最小对冲", LX, ey+LH*4, F(10), cMute);
    EEdt(g_prefix+"e5_minP", DoubleToString(g_hedgeMinProfit,1), LX+44, ey+LH*4, EW, EH);
    // 操作按钮行1: 停多 | 停空 | 开多 | 开空
    int btnY = ey + LH*5 + INNER;
   int qbw = (LW - OUTER*2 - INNER*3) / 4;
   color sc_buy = g_allow_buy ? C'55,75,100' : cOk;
   string st_buy = g_allow_buy ? "停多" : "开多";
   color sc_sell = g_allow_sell ? C'110,80,60' : cOk;
   string st_sell = g_allow_sell ? "停空" : "开空";
   EBtn(g_prefix+"btn_stop_buy", st_buy, LX+OUTER, btnY, qbw, BH, sc_buy, cWhite);
   EBtn(g_prefix+"btn_stop_sell", st_sell, LX+OUTER+qbw+INNER, btnY, qbw, BH, sc_sell, cWhite);
   EBtn(g_prefix+"btn_buy", "开 多", LX+OUTER+(qbw+INNER)*2, btnY, qbw, BH, InpColorBuy, cWhite);
   EBtn(g_prefix+"btn_sell", "开 空", LX+OUTER+(qbw+INNER)*3, btnY, qbw, BH, InpColorSell, cWhite);
    // 操作按钮行2: 重置网格 | 切换阶段
    int btnY2 = btnY + BH + INNER;
   int qbw2 = (LW - OUTER*2 - INNER) / 2;
   EBtn(g_prefix+"btn_reset_grid", "重置网格", LX+OUTER, btnY2, qbw2, BH, C'70,72,85', cWhite);
   EBtn(g_prefix+"btn_switch_phase", "切换阶段", LX+OUTER+qbw2+INNER, btnY2, qbw2, BH, C'70,72,85', cWhite);
    // ===== 左栏: 加仓控制卡 =====
    cy += CH_PARAMS + CARD_GAP;
    ERect(g_prefix+"c_grid", X, cy, LW, CH_GRID_CTRL, BG_CARD, BD_PANEL);
    ELbl(g_prefix+"c_grid_title","加仓控制",LX+OUTER,cy+OUTER,F(12),cWhite);
    // 按钮统一用 cp_RowH(24px)，与右侧平仓区一致
    int gw1 = (LW - OUTER*2 - INNER) / 2;
    int gwcy = cy + OUTER + 18;
    color buyC = g_allow_grid_buy ? C'55,75,100' : cOk;
    string buyT = g_allow_grid_buy ? "停加仓多" : "启加仓多";
    color sellC = g_allow_grid_sell ? C'110,80,60' : cOk;
    string sellT = g_allow_grid_sell ? "停加仓空" : "启加仓空";
    EBtn(g_prefix+"btn_grid_buy",  buyT,  LX+OUTER, gwcy, gw1, cp_RowH, buyC, cWhite);
    EBtn(g_prefix+"btn_grid_sell", sellT, LX+OUTER+gw1+INNER, gwcy, gw1, cp_RowH, sellC, cWhite);
    int gwcy2 = gwcy + cp_RowH + INNER;
    string abT = (g_allow_grid_buy && g_allow_grid_sell) ? "加仓全停" : "加仓全开";
    color abC = (g_allow_grid_buy && g_allow_grid_sell) ? C'90,50,50' : C'50,90,50';
    EBtn(g_prefix+"btn_grid_all",  abT,  LX+OUTER, gwcy2, gw1, cp_RowH, abC, cWhite);
    EBtn(g_prefix+"btn_grid_none", "加仓重置", LX+OUTER+gw1+INNER, gwcy2, gw1, cp_RowH, C'70,72,85', cWhite);
// ===== 右栏: 统一大卡（仓位概览 + 多单平仓 + 空单平仓） =====
   int rx = RX;
   int rcy = g_py + HDR_H + CARD_GAP;
   // 统一大卡：X从面板边缘起，宽度=RW，高度=LEFT_COL_H
   ERect(g_prefix+"c_right", rx, rcy, RW_, LEFT_COL_H, BG_CARD, BD_PANEL);

   // --- 仓位概览区 ---
   ELbl(g_prefix+"c_right_title1","仓位概览",rx+OUTER,rcy+OUTER,F(12),cWhite);
   int by = rcy + OUTER + 22;
   double totalPnL = s.buy_pnl + s.sell_pnl;
   color pnlClr = (totalPnL >= 0) ? cOk : cBad;
   string pnlSign = (totalPnL >= 0) ? "+" : "";
   ELbl(g_prefix+"cp_totalPnl","浮动盈亏 "+pnlSign+"$"+DoubleToString(totalPnL,2),
        rx+OUTER, by, F(12), pnlClr);
   by += LH + INNER;
   EBtn(g_prefix+"btn_closeAll","一键平仓全部持仓", rx+OUTER, by, RW_-OUTER*2, BH, C'180,50,50', cWhite);

   // --- 多单平仓区 ---
   by += BH + INNER + 4;
   ELbl(g_prefix+"c_right_title2","多单平仓",rx+OUTER,by,F(12),InpColorBuy);
   by += 20;
   string buyStat = "手数 "+DoubleToString(s.buy_lot,2)+"  |  数量 "+IntegerToString(s.buy_cnt)+"  |  盈亏 $"+DoubleToString(s.buy_pnl,2);
   color buyStatClr = (s.buy_pnl >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_buyStat", buyStat, rx+OUTER, by, F(9), buyStatClr);
   by += cp_RowH + INNER;
   int bw3 = (RW_ - OUTER*2 - INNER*2) / 3;
   EBtn(g_prefix+"cp_allL","全平", rx+OUTER, by, bw3, BH, C'56,132,216', cWhite);
   EBtn(g_prefix+"cp_profL","平盈", rx+OUTER+bw3+INNER, by, bw3, BH, C'78,190,140', cWhite);
   EBtn(g_prefix+"cp_lossL","平亏", rx+OUTER+bw3*2+INNER*2, by, bw3, BH, C'230,100,97', cWhite);
   by += BH + INNER;
   // 百分比平仓
   EBtn(g_prefix+"cp_perL_btn", "百分比", rx+OUTER, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_perL", "20", rx+OUTER+cp_LblW+INNER, by, cp_EdW2, cp_RowH);
   EBtn(g_prefix+"cp_perL", "抽取", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER, by, cp_BtnW, cp_RowH, C'56,132,216', cWhite);
   ELbl(g_prefix+"cp_perL_res", "=---", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER+cp_BtnW+4, by+3, F(9), cMute);
   by += cp_RowH + INNER;
   // 固定手数平仓
   EBtn(g_prefix+"cp_fixL_btn", "固定手数", rx+OUTER, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_fixL", "0.01", rx+OUTER+cp_LblW+INNER, by, cp_EdW2, cp_RowH);
   EBtn(g_prefix+"cp_fixL", "抽取", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER, by, cp_BtnW, cp_RowH, C'56,132,216', cWhite);
   ELbl(g_prefix+"cp_fixL_res", "=---", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER+cp_BtnW+4, by+3, F(9), cMute);
   by += cp_RowH + INNER;
   // 按序平仓
   string dirTxtL = g_longCloseDir ? "多↑从下向上" : "多↓从上向下";
   color dirClrL = g_longCloseDir ? C'56,132,216' : C'70,72,85';
   EBtn(g_prefix+"cp_dirL", dirTxtL, rx+OUTER, by, cp_LblW, cp_RowH, dirClrL, cWhite);
   EEdt(g_prefix+"cp_edt_ordL", "0.01", rx+OUTER+cp_LblW+INNER, by, cp_EdW2, cp_RowH);
   EBtn(g_prefix+"cp_ordL", "抽取", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER, by, cp_BtnW, cp_RowH, C'56,132,216', cWhite);
   ELbl(g_prefix+"cp_ordL_res", "=---", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER+cp_BtnW+4, by+3, F(9), cMute);

   // --- 空单平仓区 ---
   by += cp_RowH + INNER + 4;
   ELbl(g_prefix+"c_right_title3","空单平仓",rx+OUTER,by,F(12),InpColorSell);
   by += 20;
   string sellStat = "手数 "+DoubleToString(s.sell_lot,2)+"  |  数量 "+IntegerToString(s.sell_cnt)+"  |  盈亏 $"+DoubleToString(s.sell_pnl,2);
   color sellStatClr = (s.sell_pnl >= 0) ? cOk : cBad;
   ELbl(g_prefix+"cp_sellStat", sellStat, rx+OUTER, by, F(9), sellStatClr);
   by += cp_RowH + INNER;
   int bw3S = (RW_ - OUTER*2 - INNER*2) / 3;
   EBtn(g_prefix+"cp_allS","全平", rx+OUTER, by, bw3S, BH, C'180,80,60', cWhite);
   EBtn(g_prefix+"cp_profS","平盈", rx+OUTER+bw3S+INNER, by, bw3S, BH, C'78,190,140', cWhite);
   EBtn(g_prefix+"cp_lossS","平亏", rx+OUTER+bw3S*2+INNER*2, by, bw3S, BH, C'230,100,97', cWhite);
   by += BH + INNER;
   // 百分比平仓
   EBtn(g_prefix+"cp_perS_btn", "百分比", rx+OUTER, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_perS", "20", rx+OUTER+cp_LblW+INNER, by, cp_EdW2, cp_RowH);
   EBtn(g_prefix+"cp_perS", "抽取", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER, by, cp_BtnW, cp_RowH, C'180,80,60', cWhite);
   ELbl(g_prefix+"cp_perS_res", "=---", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER+cp_BtnW+4, by+3, F(9), cMute);
   by += cp_RowH + INNER;
   // 固定手数平仓
   EBtn(g_prefix+"cp_fixS_btn", "固定手数", rx+OUTER, by, cp_LblW, cp_RowH, C'70,72,85', cWhite);
   EEdt(g_prefix+"cp_edt_fixS", "0.01", rx+OUTER+cp_LblW+INNER, by, cp_EdW2, cp_RowH);
   EBtn(g_prefix+"cp_fixS", "抽取", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER, by, cp_BtnW, cp_RowH, C'180,80,60', cWhite);
   ELbl(g_prefix+"cp_fixS_res", "=---", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER+cp_BtnW+4, by+3, F(9), cMute);
   by += cp_RowH + INNER;
   // 按序平仓
   string dirTxtS = g_shortCloseDir ? "空↑从下向上" : "空↓从上向下";
   color dirClrS = g_shortCloseDir ? C'180,80,60' : C'70,72,85';
   EBtn(g_prefix+"cp_dirS", dirTxtS, rx+OUTER, by, cp_LblW, cp_RowH, dirClrS, cWhite);
   EEdt(g_prefix+"cp_edt_ordS", "0.01", rx+OUTER+cp_LblW+INNER, by, cp_EdW2, cp_RowH);
   EBtn(g_prefix+"cp_ordS", "抽取", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER, by, cp_BtnW, cp_RowH, C'180,80,60', cWhite);
   ELbl(g_prefix+"cp_ordS_res", "=---", rx+OUTER+cp_LblW+INNER+cp_EdW2+INNER+cp_BtnW+4, by+3, F(9), cMute);

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
//| 参数持久化                                                         |
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
   if(GlobalVariableCheck(g_prefix+"trendGap"))  g_gridWithTrend  = (int)GlobalVariableGet(g_prefix+"trendGap");
   if(GlobalVariableCheck(g_prefix+"hedgeR"))    g_hedgeRatio     = GlobalVariableGet(g_prefix+"hedgeR");
   if(GlobalVariableCheck(g_prefix+"hedgeMinP")) g_hedgeMinProfit = GlobalVariableGet(g_prefix+"hedgeMinP");
   if(GlobalVariableCheck(g_prefix+"gridBuy"))   g_allow_grid_buy  = (GlobalVariableGet(g_prefix+"gridBuy")>0);
   if(GlobalVariableCheck(g_prefix+"gridSell")) g_allow_grid_sell = (GlobalVariableGet(g_prefix+"gridSell")>0);
   return true;
}
//+------------------------------------------------------------------+
//| 读取输入框                                                        |
//+------------------------------------------------------------------+
void ReadEdits()
{
   string t; double v;
   if(ObjectFind(0,g_prefix+"e1_lot")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e1_lot",OBJPROP_TEXT);
      v=StringToDouble(t); if(v>0) g_lot=v;
   }
   if(ObjectFind(0,g_prefix+"e1_tp")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e1_tp",OBJPROP_TEXT);
      g_tp=(int)StringToInteger(t);
   }
   if(ObjectFind(0,g_prefix+"e1_sl")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e1_sl",OBJPROP_TEXT);
      g_sl=(int)StringToInteger(t);
   }
   if(ObjectFind(0,g_prefix+"e3_trend")>=0)
   {
      t=ObjectGetString(0,g_prefix+"e3_trend",OBJPROP_TEXT);
      v=(int)StringToInteger(t); if(v>0) g_gridWithTrend=(int)v;
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
double GetGridMA(int handleIdx, int shift=1)
{
   double v[1];
   if(CopyBuffer(g_maHandle[handleIdx],0,shift,1,v)<=0) return 0;
   return v[0];
}
int GetGridMADir(int handleIdx, int shift=1)
{
   double ma,cl;
   ma = GetGridMA(handleIdx, shift);
   if(ma<=0) return 0;
   ENUM_TIMEFRAMES tf = g_gridTF[handleIdx];
   cl = iClose(_Symbol,tf,shift);
   if(cl<=0) return 0;
   if(cl>ma) return 1;
   if(cl<ma) return -1;
   return 0;
}
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
//| 网格间距计算                                                       |
//+------------------------------------------------------------------+
int CalcCounterTrendInterval(const int trendDir)
{
   int maxCounterDepth = 0;
   for(int i=0; i<7; i++)
   {
      int dir = GetGridMADir(i, 1);
      bool isCounter = (trendDir==1 && dir==-1) || (trendDir==-1 && dir==1);
      if(isCounter && maxCounterDepth==0)
         maxCounterDepth = 7 - i;
   }
   if(maxCounterDepth == 0)
      return 0;
   if(maxCounterDepth == 7)
      return -1;
   int base = maxCounterDepth * 100 + 100;
   int recoverySubtract = 0;
   int startCheckIdx = 8 - maxCounterDepth;
   for(int i=startCheckIdx; i<7; i++)
   {
      int dir = GetGridMADir(i, 1);
      bool isSame = (trendDir==1 && dir==1) || (trendDir==-1 && dir==-1);
      if(isSame) recoverySubtract += 10;
   }
   int result = base - recoverySubtract;
   if(result < maxCounterDepth * 100) result = maxCounterDepth * 100;
   return result;
}
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
//| 交易操作                                                          |
//+------------------------------------------------------------------+
void DoBuy()
{
   ReadEdits();
   if(!g_allow_buy){ Print("[面板]多单已暂停");return; }
   if(!CanTrade()) return;
   double lot = g_lotBase + g_gridLayer * 0.01;
   if(lot < InpLotSize) lot = InpLotSize;
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   m_trade.SetExpertMagicNumber(g_currentMagic);
   if(m_trade.Buy(lot,_Symbol,ask,0,0,"EMA多"))
   {
      Print("[开多] ",_Symbol," @ ",ask," 手数:",lot," 阶段:",g_magicPhase," 层数:",g_gridLayer);
      g_lastFailTime = 0;
      g_gridLastBuy  = ask;
      g_gridLayer++;
   }
   else
      OnOrderFailed(m_trade.ResultRetcodeDescription());
}
void DoSell()
{
   ReadEdits();
   if(!g_allow_sell){ Print("[面板]空单已暂停");return; }
   if(!CanTrade()) return;
   double lot = g_lotBase + g_gridLayer * 0.01;
   if(lot < InpLotSize) lot = InpLotSize;
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   m_trade.SetExpertMagicNumber(g_currentMagic);
   if(m_trade.Sell(lot,_Symbol,bid,0,0,"EMA空"))
   {
      Print("[开空] ",_Symbol," @ ",bid," 手数:",lot," 阶段:",g_magicPhase," 层数:",g_gridLayer);
      g_lastFailTime = 0;
      g_gridLastSell = bid;
      g_gridLayer++;
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
   if(dir==POSITION_TYPE_BUY)  { g_gridLastBuy=0;  g_gridLayer=0; g_lotBase=InpLotSize; }
   if(dir==POSITION_TYPE_SELL){ g_gridLastSell=0; g_gridLayer=0; g_lotBase=InpLotSize; }
}
void CloseAllEaOrders()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol) continue;
      if(m_pos.Magic()==InpMagicNumber || 
         (m_pos.Magic()%111111==0 && m_pos.Magic()>=111111 && m_pos.Magic()<=999999))
      {
         m_trade.PositionClose(m_pos.Ticket());
      }
   }
}
void CloseBuy()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(m_pos.SelectByIndex(i)&&m_pos.Symbol()==_Symbol&&m_pos.Magic()==g_currentMagic
         &&m_pos.PositionType()==POSITION_TYPE_BUY) m_trade.PositionClose(m_pos.Ticket());
   g_gridLastBuy=0; g_gridLayer=0; g_lotBase=InpLotSize;
}
void CloseSell()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(m_pos.SelectByIndex(i)&&m_pos.Symbol()==_Symbol&&m_pos.Magic()==g_currentMagic
         &&m_pos.PositionType()==POSITION_TYPE_SELL) m_trade.PositionClose(m_pos.Ticket());
   g_gridLastSell=0; g_gridLayer=0; g_lotBase=InpLotSize;
}
void CloseAll()
{
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(m_pos.SelectByIndex(i)&&m_pos.Symbol()==_Symbol&&m_pos.Magic()==g_currentMagic)
         m_trade.PositionClose(m_pos.Ticket());
   g_gridLastBuy=0; g_gridLastSell=0; g_gridLayer=0; g_lotBase=InpLotSize;
}
//+------------------------------------------------------------------+
//| 跑马灯止盈止损                                                     |
//+------------------------------------------------------------------+
void CheckTPSL()
{
   double pt = Pt();
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(g_tp <= 0) return;
   int cDepth = GetCounterDepth(g_trend);
   int layers  = g_gridLayer;
   int dynTP = InpTakeProfit - layers * 20 + cDepth * 25;
   if(dynTP < 50) dynTP = 50;
   if(dynTP > 400) dynTP = 400;
   // 多单篮子
   double buyVol=0, buyWeighted=0;
   int buyCnt=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol || m_pos.Magic()!=g_currentMagic) continue;
      if(m_pos.PositionType()!=POSITION_TYPE_BUY) continue;
      buyVol+=m_pos.Volume(); buyWeighted+=m_pos.PriceOpen()*m_pos.Volume(); buyCnt++;
   }
   if(buyCnt>0 && bid >= buyWeighted/buyVol + dynTP*pt)
   {
      Print("════════════════════════════════");
      Print("[跑马灯止盈-多] 均价:",DoubleToString(buyWeighted/buyVol,_Digits),
            " 动态TP:",dynTP,"点 层数:",buyCnt," 深度:",cDepth);
      Print("════════════════════════════════");
      CloseDir(POSITION_TYPE_BUY);
   }
   // 空单篮子
   double sellVol=0, sellWeighted=0;
   int sellCnt=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol || m_pos.Magic()!=g_currentMagic) continue;
      if(m_pos.PositionType()!=POSITION_TYPE_SELL) continue;
      sellVol+=m_pos.Volume(); sellWeighted+=m_pos.PriceOpen()*m_pos.Volume(); sellCnt++;
   }
   if(sellCnt>0 && ask <= sellWeighted/sellVol - dynTP*pt)
   {
      Print("════════════════════════════════");
      Print("[跑马灯止盈-空] 均价:",DoubleToString(sellWeighted/sellVol,_Digits),
            " 动态TP:",dynTP,"点 层数:",sellCnt," 深度:",cDepth);
      Print("════════════════════════════════");
      CloseDir(POSITION_TYPE_SELL);
   }
}
//+------------------------------------------------------------------+
//| 顺势盈利计算                                                       |
//+------------------------------------------------------------------+
double GetTrendProfit()
{
   double profit = 0;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      if(!m_pos.SelectByIndex(i)) continue;
      if(m_pos.Symbol()!=_Symbol) continue;
      bool isBuy  = (m_pos.PositionType()==POSITION_TYPE_BUY);
      bool isTrend = (g_trend==1 && isBuy) || (g_trend==-1 && !isBuy);
      if(!isTrend) continue;
      profit += m_pos.Profit() + m_pos.Swap();
   }
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
//| D1趋势导向对冲                                                     |
//+------------------------------------------------------------------+
void HedgeOldPositions()
{
   if(g_trend == 0) return;
   g_hedgeOldTrend = -g_trend;
   double pt = Pt();
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   struct CounterPos
   {
      ulong  ticket;
      double lots;
      double entry;
      double loss;
      double dist;
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
      double loss = -(m_pos.Profit()+m_pos.Swap());
      if(loss <= 0) continue;
      double entry = m_pos.PriceOpen();
      double dist  = isBuy ? (bid-entry)/pt : (entry-ask)/pt;
      counter[counterCnt].ticket = m_pos.Ticket();
      counter[counterCnt].lots   = m_pos.Volume();
      counter[counterCnt].entry  = entry;
      counter[counterCnt].loss   = loss;
      counter[counterCnt].dist   = dist;
      counter[counterCnt].isBuy  = isBuy;
      counter[counterCnt].magic  = (int)m_pos.Magic();
      counterCnt++;
   }
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
   double trendProfit = GetTrendProfit();
   if(trendProfit < g_hedgeMinProfit) return;
   double ema[1], close[1];
   double strengthFactor = 1.0;
   if(CopyBuffer(g_emaHandle,0,1,1,ema)>0 &&
      CopyClose(_Symbol,PERIOD_D1,1,1,close)>0 && ema[0]>0)
   {
      double emaDeviation = MathAbs((close[0]-ema[0])/ema[0]) * 100;
      strengthFactor = 0.8 + MathMin(emaDeviation / 2.5, 1.0);
   }
   for(int i=0; i<counterCnt-1; i++)
      for(int j=i+1; j<counterCnt; j++)
         if(counter[j].dist < counter[i].dist)
         {
            CounterPos tmp = counter[i];
            counter[i] = counter[j];
            counter[j] = tmp;
         }
   double availableProfit = trendProfit * g_hedgeRatio * strengthFactor;
   if(availableProfit < g_hedgeMinProfit) return;
   bool hedged = false;
   for(int i=0; i<counterCnt && availableProfit>=g_hedgeMinProfit; i++)
   {
      if(counter[i].ticket == 0) continue;
      if(!PositionSelectByTicket(counter[i].ticket)) continue;
      double currentLoss  = -(PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP));
      if(currentLoss <= 0) continue;
      double currentLots = PositionGetDouble(POSITION_VOLUME);
      double perLotLoss  = currentLoss / currentLots;
      if(perLotLoss <= 0) continue;
      double hedgeLots = availableProfit / perLotLoss;
      hedgeLots = MathMin(hedgeLots, currentLots);
      double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
      if(step <= 0) step = InpHedgeMinLots;
      hedgeLots = MathFloor(hedgeLots / step) * step;
      hedgeLots = NormalizeDouble(hedgeLots, 2);
      if(hedgeLots < InpHedgeMinLots) continue;
      double hedgeAmount = hedgeLots * perLotLoss;
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
               " 入场:",DoubleToString(counter[i].entry,_Digits),
               " 亏损: $",DoubleToString(currentLoss,2),
               " 距离: ",DoubleToString(counter[i].dist,1),"点");
         Print("  部分平仓: ",DoubleToString(hedgeLots,2),"/",
               DoubleToString(currentLots,2),"手 消化≈$",
               DoubleToString(hedgeAmount,2),
               " 剩余可用: $",DoubleToString(availableProfit,2));
         Print("════════════════════════════════");
      }
   }
   if(hedged)
   {
      double remLoss=0; int remCnt=0; int lastMagic=0; double l;
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
   }
}
//+------------------------------------------------------------------+
//| 网格加仓检测                                                       |
//+------------------------------------------------------------------+
void CheckGrid()
{
   if(g_trend==0) return;
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double pt  = Pt();
   int rawInterval = CalcCounterTrendInterval(g_trend);
   if(rawInterval == -1)
   {
      g_gridCounterInterval = -1;
      return;
   }
   int counterInt = rawInterval;
   if(g_gridLastDepth > 0)
   {
      if(rawInterval > g_gridLastDepth)
         counterInt = g_gridCounterInterval + 100;
      else if(rawInterval < g_gridLastDepth)
      {
         int recovered = g_gridLastDepth - rawInterval;
         counterInt = g_gridCounterInterval - recovered * 10;
         if(counterInt < rawInterval * 100) counterInt = rawInterval * 100;
      }
   }
   g_gridLastBar = iTime(_Symbol,PERIOD_CURRENT,0);
   g_gridLastDepth = rawInterval;
   g_gridCounterInterval = counterInt;
   int withInt = g_gridWithTrend;
   if(g_trend==1 && g_allow_buy && g_allow_grid_buy && g_gridLastBuy>0)
   {
      if(counterInt > 0 && bid <= g_gridLastBuy - counterInt * pt)
      {
         Print("[网格加仓-逆势] 多头 间隔=",IntegerToString(counterInt),"点 价格=",DoubleToString(bid,_Digits));
         DoBuy(); return;
      }
      if(withInt > 0 && AllGridSameDir(g_trend) && ask >= g_gridLastBuy + withInt * pt)
      {
         Print("[网格加仓-顺势] 多头 7周期全同向 间隔=",IntegerToString(withInt),"点 价格=",DoubleToString(ask,_Digits));
         DoBuy(); return;
      }
   }
   if(g_trend==-1 && g_allow_sell && g_allow_grid_sell && g_gridLastSell>0)
   {
      if(counterInt > 0 && ask >= g_gridLastSell + counterInt * pt)
      {
         Print("[网格加仓-逆势] 空头 间隔=",IntegerToString(counterInt),"点 价格=",DoubleToString(ask,_Digits));
         DoSell(); return;
      }
      if(withInt > 0 && AllGridSameDir(g_trend) && bid <= g_gridLastSell - withInt * pt)
      {
         Print("[网格加仓-顺势] 空头 7周期全同向 间隔=",withInt,"点 价格=",bid);
         DoSell(); return;
      }
   }
}
//+------------------------------------------------------------------+
//| 入场检测                                                           |
//+------------------------------------------------------------------+
void CheckEntry()
{
   if(!g_allow_buy&&!g_allow_sell) return;
   if(g_trend==0) return;
   if(g_trend==1 && CountDir(POSITION_TYPE_BUY)==0)
   {
      DoBuy(); return;
   }
   if(g_trend==-1 && CountDir(POSITION_TYPE_SELL)==0)
   {
      DoSell(); return;
   }
   CheckGrid();
}
//+------------------------------------------------------------------+
//| 按钮事件处理                                                       |
//+------------------------------------------------------------------+
void HandlePanelButtonClick(const string sparam)
{
   double lots, pct, t;
   string dirDesc, msg;
   EAStats stats;
   string k = StringSubstr(sparam, StringLen(g_prefix));
   CollectStats(stats);
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
   // 停止/开启按钮
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
   if(k == "btn_buy")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确认开多单？\n手数: "+DoubleToString(g_lot,2)+"  品种: "+_Symbol))
         return;
      ReadEdits(); DoBuy(); RefreshPanel(true);
      return;
   }
   if(k == "btn_sell")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确认开空单？\n手数: "+DoubleToString(g_lot,2)+"  品种: "+_Symbol))
         return;
      ReadEdits(); DoSell(); RefreshPanel(true);
      return;
   }
   if(k == "cp_allL")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉全部多单吗？\n当前: "+
         IntegerToString(stats.buy_cnt)+" 单  "+DoubleToString(stats.buy_lot,2)+" 手"))
         return;
      CloseDir(POSITION_TYPE_BUY); RefreshPanel(true);
      return;
   }
   if(k == "cp_allS")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉全部空单吗？\n当前: "+
         IntegerToString(stats.sell_cnt)+" 单  "+DoubleToString(stats.sell_lot,2)+" 手"))
         return;
      CloseDir(POSITION_TYPE_SELL); RefreshPanel(true);
      return;
   }
   if(k == "btn_closeAll")
   {
      ResetPanelButtonState(sparam);
      int total = stats.buy_cnt + stats.sell_cnt;
      if(!ShowConfirmDialog("确定要一键全平全部持仓吗？\n当前: "+
         IntegerToString(total)+" 单  品种: "+_Symbol))
         return;
      CpStartAsync(POSITION_TYPE_BUY, 1, 0);
      CpStartAsync(POSITION_TYPE_SELL, 1, 0);
      RefreshPanel(true);
      return;
   }
   if(k == "cp_profL")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉盈利多单吗？"))
         return;
      CpStartAsync(POSITION_TYPE_BUY, 2, 0); RefreshPanel(true);
      return;
   }
   if(k == "cp_lossL")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉亏损多单吗？"))
         return;
      CpStartAsync(POSITION_TYPE_BUY, 3, 0); RefreshPanel(true);
      return;
   }
   if(k == "cp_profS")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉盈利空单吗？"))
         return;
      CpStartAsync(POSITION_TYPE_SELL, 2, 0); RefreshPanel(true);
      return;
   }
   if(k == "cp_lossS")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要平掉亏损空单吗？"))
         return;
      CpStartAsync(POSITION_TYPE_SELL, 3, 0); RefreshPanel(true);
      return;
   }
   // 百分比/固定/按序平仓 (多单)
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
      msg = "多单百分比平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(ss.lots*pct/100.0,2)+" 手 ("+DoubleToString(pct,1)+"%)\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      CpStartAsync(POSITION_TYPE_BUY, 4, pct); RefreshPanel(true);
      return;
   }
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
      CpStartAsync(POSITION_TYPE_BUY, 5, lots); RefreshPanel(true);
      return;
   }
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
      CpStartAsync(POSITION_TYPE_BUY, 6, lots); RefreshPanel(true);
      return;
   }
   if(k == "cp_dirL")
   {
      ResetPanelButtonState(sparam);
      g_longCloseDir = !g_longCloseDir;
      RefreshPanel(true);
      return;
   }
   // 百分比/固定/按序平仓 (空单)
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
      msg = "空单百分比平仓\n\n";
      msg += "当前: "+IntegerToString(ss.cnt)+" 单  "+DoubleToString(ss.lots,2)+" 手\n";
      msg += "平仓: "+DoubleToString(ss.lots*pct/100.0,2)+" 手 ("+DoubleToString(pct,1)+"%)\n";
      msg += "预估盈亏: $"+DoubleToString(ss.pnl,2);
      if(!ShowConfirmDialog(msg)) { RefreshPanel(true); return; }
      CpStartAsync(POSITION_TYPE_SELL, 4, pct); RefreshPanel(true);
      return;
   }
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
      CpStartAsync(POSITION_TYPE_SELL, 5, lots); RefreshPanel(true);
      return;
   }
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
      CpStartAsync(POSITION_TYPE_SELL, 6, lots); RefreshPanel(true);
      return;
   }
   if(k == "cp_dirS")
   {
      ResetPanelButtonState(sparam);
      g_shortCloseDir = !g_shortCloseDir;
      RefreshPanel(true);
      return;
   }
   // 加仓控制
   if(k == "btn_grid_buy")
   {
      ResetPanelButtonState(sparam);
      g_allow_grid_buy = !g_allow_grid_buy;
      Print("[面板] 多单加仓:", g_allow_grid_buy ? "已开启" : "已停止");
      RefreshPanel(true);
      return;
   }
   if(k == "btn_grid_sell")
   {
      ResetPanelButtonState(sparam);
      g_allow_grid_sell = !g_allow_grid_sell;
      Print("[面板] 空单加仓:", g_allow_grid_sell ? "已开启" : "已停止");
      RefreshPanel(true);
      return;
   }
   if(k == "btn_grid_all")
   {
      ResetPanelButtonState(sparam);
      g_allow_grid_buy = true;
      g_allow_grid_sell = true;
      Print("[面板] 多空加仓已全部开启");
      RefreshPanel(true);
      return;
   }
   if(k == "btn_grid_none")
   {
      ResetPanelButtonState(sparam);
      if(!ShowConfirmDialog("确定要重置加仓状态吗？\n网格加仓将暂停，已有持仓保留。"))
         return;
      g_allow_grid_buy  = true;
      g_allow_grid_sell = true;
      Print("[面板] 加仓已重置");
      RefreshPanel(true);
      return;
   }
   // 重置网格 / 切换阶段
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
   if(k == "btn_switch_phase")
   {
      ResetPanelButtonState(sparam);
      int newPhase = (g_magicPhase == 1) ? 2 : 1;
      int newMagic = (newPhase == 1) ? 111111 : 222222;
      if(!ShowConfirmDialog("确定要切换阶段吗？\n"
         "当前: 阶段"+IntegerToString(g_magicPhase)+" (魔术码"+IntegerToString(g_currentMagic)+")\n"
         "切换到: 阶段"+IntegerToString(newPhase)+" (魔术码"+IntegerToString(newMagic)+")"))
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
//+------------------------------------------------------------------+
//| 生命周期                                                          |
//+------------------------------------------------------------------+
int OnInit()
{
   m_trade.SetExpertMagicNumber(g_currentMagic);
   m_trade.SetDeviationInPoints(InpSlippage);
   m_trade.SetTypeFillingBySymbol(_Symbol);
   g_emaHandle=iMA(_Symbol,InpEMA_TF,InpEMA_Period,0,MODE_EMA,PRICE_CLOSE);
   if(g_emaHandle==INVALID_HANDLE){Print("EMA入场句柄创建失败");return INIT_FAILED;}
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
      SaveParamsToGV();
   }
   g_px=InpPanelX; g_py=InpPanelY; ClampPanelPosition(g_px,g_py);
   EventSetTimer(1);
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,true);
   RefreshPanel(true); ChartRedraw(0);
   Print("[均线策略网格系统 v2.52] D1 EMA",InpEMA_Period," + MA10 7周期网格启动 ",_Symbol," 对冲方向随D1趋势实时翻转 / 手动平仓只平本品种");
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
   g_trend=DetectTrend();
   // 趋势转变检测
   if(g_lastTrend!=0 && g_trend!=0 && g_trend!=g_lastTrend)
   {
      g_magicPhase++;
      if(g_magicPhase>9) g_magicPhase=1;
      g_currentMagic = g_magicPhase * 111111;
      g_lotBase = InpLotSize;
      g_gridLayer = 0;
      double oldCounterLoss=0, newCounterLoss=0;
      int oldCounterCnt=0;
      double oldTrendProfit=0, newTrendProfit=0;
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         if(!m_pos.SelectByIndex(i)) continue;
         if(m_pos.Symbol()!=_Symbol) continue;
         bool isBuy=(m_pos.PositionType()==POSITION_TYPE_BUY);
         double p = m_pos.Profit()+m_pos.Swap();
         bool wasTrend = (g_lastTrend==1 && isBuy) || (g_lastTrend==-1 && !isBuy);
         bool isTrend  = (g_trend==1 && isBuy) || (g_trend==-1 && !isBuy);
         if(wasTrend)  { if(p<0){ oldCounterLoss-=p; oldCounterCnt++; } else oldTrendProfit+=p; }
         if(isTrend)   { newTrendProfit+=p; }
      }
      Print("════════════════════════════════");
      Print("[趋势翻转] ",g_lastTrend==1?"多头 → 空头":"空头 → 多头",
            "  新魔术码:",g_currentMagic);
      Print("  对冲方向已随D1趋势实时翻转!");
      Print("════════════════════════════════");
   }
   g_lastTrend = g_trend;
   CheckEntry();
   CheckTPSL();
   HedgeOldPositions();
   if(CountDir(POSITION_TYPE_BUY)==0)  g_gridLastBuy=0;
   if(CountDir(POSITION_TYPE_SELL)==0) g_gridLastSell=0;
}
// 修复: OnTimer 只做面板刷新和异步操作，不再重复 DetectTrend
void OnTimer()
{
   // 移除重复的 DetectTrend() 调用 — g_trend 已在 OnTick 中更新
   if(g_panel_open){ ReadEdits(); SaveParamsToGV(); }
   CpAsyncTick();
   RefreshPanel(false);
}
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
      ClampPanelPosition(new_x,new_y);
      MovePanelTo(new_x,new_y);
      return;
   }
   if(id != CHARTEVENT_OBJECT_CLICK)
      return;
   if(StringFind(sparam,g_prefix,0) != 0)
      return;
   HandlePanelButtonClick(sparam);
}
//+------------------------------------------------------------------+
