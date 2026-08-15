//+------------------------------------------------------------------+
//|                 GBPUSD_H4_绿线跑马灯_AI风控.mq5                   |
//|  GBPUSD H4 自定义绿色线信号 + 跑马灯开平仓 + 1.3倍投 + 100点TP/SL  |
//|  + AI大模型打分过滤首单 + 金麒麟风格可拖拽交互面板                  |
//+------------------------------------------------------------------+
#property copyright "Custom Strategy"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Indicators\Oscilators.mqh>

//+------------------------------------------------------------------+
//| 输入参数                                                          |
//+------------------------------------------------------------------+
input group "=== 基础设置 ==="
input double   InitialLots        = 0.01;       // 初始开仓手数
input double   Multiplier         = 1.3;        // 加仓倍投倍数(跑马灯同向加仓)
input int      MaxOrders          = 100;        // 最大订单数
input long     MagicNumber        = 20260801;   // EA魔术号
input int      Slippage           = 30;         // 滑点(点)
input int      FixedTP_Points     = 100;        // 固定止盈(点数)
input int      FixedSL_Points     = 100;        // 固定止损(点数)
input int      DigitsLot          = 2;          // 手数小数位
input double   MaxLot             = 10.0;       // 最大开单手数

input group "=== 信号指标 ==="
input int      RSI_Period         = 4;          // RSI周期(绿色线默认4)
input int      GreenLine_Speed    = 16;         // 绿色线平滑参数(gi_84,默认16)
input ENUM_TIMEFRAMES SignalTF    = PERIOD_H4;  // 信号周期(默认H4)

input group "=== AI 智能风控 ==="
input bool     AI_Enabled         = false;       // AI 风控总开关
input string   AI_ApiKey          = "";          // API Key
input string   AI_ApiUrl          = "https://api.deepseek.com/chat/completions";
input string   AI_Model           = "deepseek-v4-pro";
input int      AI_TimeoutSec      = 15;          // 超时(秒)
input int      AI_ScoreThreshold  = 50;          // 打分阈值(0-100)
input bool     AI_FailOpen        = true;        // 容灾: true=放行 false=拒绝
input int      AI_CooldownMin     = 5;           // 冷却周期(分钟)
input string   AI_SystemPrompt    = "你是华尔街顶尖外汇操盘手，精通GBPUSD的H4级别趋势判断与风控，只给出0-100之间的整数分数。";
input string   AI_UserPrompt      = "我的策略是基于H4级别的RSI4与绿色线(自定义TEMA)金叉死叉跑马灯交易，固定100点止盈止损，1.3倍同向加仓。请根据以下盘面数据评估当前开仓胜率，仅返回0-100整数。";

input group "=== 面板显示 ==="
input int      PanelStartX        = 16;          // 面板初始X
input int      PanelStartY        = 18;          // 面板初始Y
input bool     AutoTrade          = true;        // EA启动后自动开启

//+------------------------------------------------------------------+
//| 全局对象                                                          |
//+------------------------------------------------------------------+
CTrade          g_trade;
CPositionInfo   g_posInfo;
CSymbolInfo     g_symInfo;
CiRSI           g_cRSI;

int             g_handle_GreenLine  = INVALID_HANDLE; // 自定义绿色线(自定义计算，不用iMA句柄方式)
datetime        g_lastSignalBarTime = 0;              // 上次H4信号K线时间
bool            g_eaEnabled        = true;
bool            g_allow_buy        = true;
bool            g_allow_sell       = true;
ENUM_TIMEFRAMES g_SignalTF         = PERIOD_H4;       // 实际运行时使用的信号周期(固定H4)

// 金麒麟风格面板全局
string          g_panel_prefix     = "GK_GreenLight_";
int             g_panel_x          = 16;
int             g_panel_y          = 18;
bool            g_panel_open       = true;
bool            g_panel_dragging   = false;
int             g_panel_drag_ox    = 0;
int             g_panel_drag_oy    = 0;
datetime        g_last_panel_refresh = 0;

// AI 风控全局
datetime        g_aiLastTime       = 0;
int             g_aiLastDecision   = 0;   // 1=放行 -1=拒绝 0=无
int             g_aiLastDirection  = 0;   // 1=多 -1=空
int             g_aiLastScore      = -1;
string          g_aiLastError      = "";
bool            g_aiEnabled_rt     = false;
string          g_aiSysPrompt_rt   = "";
string          g_aiUsrPrompt_rt   = "";

// 面板UI标识
#define EDIT_SYS   g_panel_prefix + "EDIT_SYS"
#define EDIT_USR   g_panel_prefix + "EDIT_USR"
string BTN_TOGGLE_PANEL;
string BTN_STOP_ALL;
string BTN_STOP_BUY;
string BTN_STOP_SELL;
string BTN_CLOSE_ALL_BUY;
string BTN_CLOSE_ALL_SELL;
string BTN_CLOSE_PROFIT_BUY;
string BTN_CLOSE_PROFIT_SELL;
string BTN_CLOSE_LOSS_BUY;
string BTN_CLOSE_LOSS_SELL;
string BTN_CLOSE_ALL;
string BTN_AI_ONOFF;
string BTN_AI_PREVIEW;
string BTN_RESET;

//+------------------------------------------------------------------+
//| 持仓统计结构体                                                    |
//+------------------------------------------------------------------+
struct EAStats
{
   int      buyCount;
   int      sellCount;
   double   buyLots;
   double   sellLots;
   double   buyProfit;
   double   sellProfit;
   double   buyWeighted;
   double   sellWeighted;
   double   buyAvg;
   double   sellAvg;
   double   buyLastLots;
   double   sellLastLots;
   datetime buyLastTime;
   datetime sellLastTime;
   double   totalProfit;
};

//+------------------------------------------------------------------+
//| 面板尺寸结构体                                                    |
//+------------------------------------------------------------------+
struct PanelMetrics
{
   int margin_x,margin_y,width,pad,section_gap,header_h,row_h,gap,button_h;
   int inner_w,half_w,card_status_h,card_signal_h,card_metrics_h,card_actions_h,card_ai_h;
   int font_xs,font_sm,font_md,font_lg,button_font,toggle_w,panel_h;
};

//+------------------------------------------------------------------+
//| 初始化                                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   // 品种校验：策略设计为 GBPUSD，若挂载其他品种给出警告但仍允许运行
   if(StringFind(_Symbol, "GBPUSD") < 0)
   {
      Print("警告: 当前品种为 ", _Symbol, "，本策略设计针对 GBPUSD H4，请确认是否继续");
   }
   // 周期校验：当前图表周期建议为 H4
   ENUM_TIMEFRAMES curTF = (ENUM_TIMEFRAMES)Period();
   if(curTF != PERIOD_H4)
   {
      Print("警告: 当前图表周期为 ", EnumToString(curTF), "，本策略设计针对 H4 图表");
   }
   // 强制信号周期为 H4
   g_SignalTF = PERIOD_H4;

   g_trade.SetExpertMagicNumber(MagicNumber);
   g_trade.SetDeviationInPoints(Slippage);
   g_trade.SetMarginMode();
   g_trade.SetTypeFillingBySymbol(_Symbol);

   if(!g_symInfo.Name(_Symbol)) return INIT_FAILED;

   // 初始化 RSI 对象 (信号周期 H4)
   if(!g_cRSI.Create(NULL, g_SignalTF, RSI_Period, PRICE_CLOSE))
   {
      Print("RSI对象创建失败");
      return INIT_FAILED;
   }

   // 按钮名初始化
   BTN_TOGGLE_PANEL    = g_panel_prefix + "toggle_panel";
   BTN_STOP_ALL        = g_panel_prefix + "stop_all";
   BTN_STOP_BUY        = g_panel_prefix + "stop_buy";
   BTN_STOP_SELL       = g_panel_prefix + "stop_sell";
   BTN_CLOSE_ALL_BUY   = g_panel_prefix + "close_all_buy";
   BTN_CLOSE_ALL_SELL  = g_panel_prefix + "close_all_sell";
   BTN_CLOSE_PROFIT_BUY  = g_panel_prefix + "close_profit_buy";
   BTN_CLOSE_PROFIT_SELL = g_panel_prefix + "close_profit_sell";
   BTN_CLOSE_LOSS_BUY    = g_panel_prefix + "close_loss_buy";
   BTN_CLOSE_LOSS_SELL   = g_panel_prefix + "close_loss_sell";
   BTN_CLOSE_ALL       = g_panel_prefix + "close_all_ea";
   BTN_AI_ONOFF        = g_panel_prefix + "btn_ai_onoff";
   BTN_AI_PREVIEW      = g_panel_prefix + "btn_ai_preview";
   BTN_RESET           = g_panel_prefix + "btn_reset";

   g_eaEnabled        = AutoTrade;
   g_allow_buy        = true;
   g_allow_sell       = true;
   g_aiEnabled_rt     = AI_Enabled;
   g_aiSysPrompt_rt   = AI_SystemPrompt;
   g_aiUsrPrompt_rt   = AI_UserPrompt;

   g_panel_x = PanelStartX;
   g_panel_y = PanelStartY;
   ClampPanelPosition(g_panel_x, g_panel_y);

   DeleteObjectsByPrefix(g_panel_prefix);
   ChartSetInteger(0, CHART_EVENT_OBJECT_CREATE, true);
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   EventSetTimer(2);
   RefreshPanel(true);

   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| 反初始化                                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   DeleteObjectsByPrefix(g_panel_prefix);
}

//+------------------------------------------------------------------+
//| 定时器                                                            |
//+------------------------------------------------------------------+
void OnTimer() { RefreshPanel(false); }

//+------------------------------------------------------------------+
//| 图表事件：面板拖拽 + 按钮点击 + 编辑框保存                        |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_OBJECT_ENDEDIT)
   {
      if(sparam == EDIT_SYS)
      {
         g_aiSysPrompt_rt = ObjectGetString(0, EDIT_SYS, OBJPROP_TEXT);
         Print("[AI] System Prompt 已保存");
      }
      else if(sparam == EDIT_USR)
      {
         g_aiUsrPrompt_rt = ObjectGetString(0, EDIT_USR, OBJPROP_TEXT);
         Print("[AI] User Prompt 已保存");
      }
      return;
   }

   if(id == CHARTEVENT_CLICK)
   {
      const int cx = (int)lparam, cy = (int)dparam;
      if(!g_panel_dragging)
      {
         if(IsClickOnPanelDragArea(cx, cy))
         {
            g_panel_dragging = true;
            g_panel_drag_ox = cx - g_panel_x;
            g_panel_drag_oy = cy - g_panel_y;
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
      int nx = (int)lparam - g_panel_drag_ox;
      int ny = (int)dparam - g_panel_drag_oy;
      ClampPanelPosition(nx, ny);
      MovePanelTo(nx, ny);
      return;
   }

   if(id != CHARTEVENT_OBJECT_CLICK) return;
   HandlePanelButtonClick(sparam);
}

//+------------------------------------------------------------------+
//|=====================  策略核心逻辑区  ============================|
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 计算绿色线指定周期(Shift=0/1/2)的值                               |
//| 算法沿用 20260507绿色线1.mq5，基于 gi_84=GreenLine_Speed         |
//+------------------------------------------------------------------+
bool CalcGreenLineByPeriod(const ENUM_TIMEFRAMES period, int shiftCount, double &outArr[])
{
   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   const int needBars = GreenLine_Speed + shiftCount + 20;
   int bars = CopyRates(_Symbol, period, 0, needBars, rates);
   if(bars <= GreenLine_Speed + 3) return false;

   double tmp[];
   ArrayResize(tmp, bars);
   ArraySetAsSeries(tmp, true);

   double ld_0=0,ld_8=0,ld_16=0,ld_24=0,ld_32=0,ld_40=0,ld_48=0,ld_56=0,ld_64=0,ld_72=0;
   double ld_80=0,ld_88=0,ld_96=0,ld_104=0,ld_112=0,ld_120=0,ld_128=0,ld_136=0,ld_144=0;
   double ld_152=0,ld_160=0,ld_168=0,ld_176=0,ld_184=0,ld_192=0,ld_200=0,ld_208=0;
   int gi = GreenLine_Speed;
   int startBar = bars - gi - 1;
   for(int i = startBar; i >= 0; i--)
   {
      if(ld_8 == 0.0)
      {
         ld_8 = 1.0; ld_16 = 0.0;
         ld_0 = (gi - 1 >= 5) ? gi - 1.0 : 5.0;
         ld_80 = 100.0 * ((rates[i].high + rates[i].low + rates[i].close) / 3.0);
         ld_96  = 3.0 / (gi + 2.0);
         ld_104 = 1.0 - ld_96;
      }
      else
      {
         if(ld_0 <= ld_8) ld_8 = ld_0 + 1.0; else ld_8 += 1.0;
         ld_88 = ld_80;
         ld_80 = 100.0 * ((rates[i].high + rates[i].low + rates[i].close) / 3.0);
         ld_32  = ld_80 - ld_88;
         ld_112 = ld_104 * ld_112 + ld_96 * ld_32;
         ld_120 = ld_96 * ld_112 + ld_104 * ld_120;
         ld_40  = 1.5 * ld_112 - ld_120 / 2.0;
         ld_128 = ld_104 * ld_128 + ld_96 * ld_40;
         ld_208 = ld_96 * ld_128 + ld_104 * ld_208;
         ld_48  = 1.5 * ld_128 - ld_208 / 2.0;
         ld_136 = ld_104 * ld_136 + ld_96 * ld_48;
         ld_152 = ld_96 * ld_136 + ld_104 * ld_152;
         ld_56  = 1.5 * ld_136 - ld_152 / 2.0;
         ld_160 = ld_104 * ld_160 + ld_96 * MathAbs(ld_32);
         ld_168 = ld_96 * ld_160 + ld_104 * ld_168;
         ld_64  = 1.5 * ld_160 - ld_168 / 2.0;
         ld_176 = ld_104 * ld_176 + ld_96 * ld_64;
         ld_184 = ld_96 * ld_176 + ld_104 * ld_184;
         ld_144 = 1.5 * ld_176 - ld_184 / 2.0;
         ld_192 = ld_104 * ld_192 + ld_96 * ld_144;
         ld_200 = ld_96 * ld_192 + ld_104 * ld_200;
         ld_72  = 1.5 * ld_192 - ld_200 / 2.0;
         if(ld_0 >= ld_8 && ld_80 != ld_88) ld_16 = 1.0;
         if(ld_0 == ld_8 && ld_16 == 0.0) ld_8 = 0.0;
      }
      if(ld_0 < ld_8 && ld_72 > 1e-10)
      {
         ld_24 = 50.0 * (ld_56 / ld_72 + 1.0);
         if(ld_24 > 100.0) ld_24 = 100.0;
         if(ld_24 < 0.0)   ld_24 = 0.0;
      }
      else ld_24 = 50.0;
      tmp[i] = ld_24;
   }

   const int cnt = MathMin(shiftCount + 2, bars);
   ArrayResize(outArr, cnt);
   for(int i = 0; i < cnt; i++) outArr[i] = tmp[i];
   return true;
}

//+------------------------------------------------------------------+
//| 获取信号：1=看多金叉 -1=看空死叉 0=无信号/数据不足                |
//| 沿用指标：RSI[1]>绿线[1] && RSI[2]<绿线[2] → 多；反则空           |
//+------------------------------------------------------------------+
int GetCrossSignal()
{
   // 刷新RSI
   g_cRSI.Refresh();
   double rsi0 = g_cRSI.Main(0);
   double rsi1 = g_cRSI.Main(1);
   double rsi2 = g_cRSI.Main(2);

   double gl[];
   if(!CalcGreenLineByPeriod(g_SignalTF, 3, gl)) return 0;
   if(ArraySize(gl) < 3) return 0;

   // 金叉(多): RSI[1]上穿绿线[1] 即 RSI1>GL1 且 RSI2<GL2
   if(rsi1 > gl[1] && rsi2 < gl[2]) return 1;
   // 死叉(空): RSI[1]<GL1 且 RSI2>GL2
   if(rsi1 < gl[1] && rsi2 > gl[2]) return -1;
   return 0;
}

//+------------------------------------------------------------------+
//| 获取当前最新绿色线与RSI值用于面板显示                              |
//+------------------------------------------------------------------+
void GetCurrentSignalDisplay(double &rsi0, double &rsi1, double &gl0, double &gl1, int &signal)
{
   rsi0=0; rsi1=0; gl0=50; gl1=50; signal=0;
   g_cRSI.Refresh();
   rsi0 = g_cRSI.Main(0);
   rsi1 = g_cRSI.Main(1);
   double arr[];
   if(CalcGreenLineByPeriod(g_SignalTF, 2, arr) && ArraySize(arr) >= 2)
   {
      gl0 = arr[0]; gl1 = arr[1];
   }
   signal = GetCrossSignal();
}

//+------------------------------------------------------------------+
//| 统计持仓                                                          |
//+------------------------------------------------------------------+
void CollectStats(EAStats &s)
{
   ZeroMemory(s);
   double bw = 0, sw = 0;
   datetime blt = 0, slt = 0;
   int total = (int)PositionsTotal();
   for(int i = total - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      ENUM_POSITION_TYPE pt = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double vol    = PositionGetDouble(POSITION_VOLUME);
      double prof   = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
      datetime ot   = (datetime)PositionGetInteger(POSITION_TIME);
      if(pt == POSITION_TYPE_BUY)
      {
         s.buyCount++; s.buyLots += vol; s.buyProfit += prof; bw += openP * vol;
         if(ot > blt) { blt = ot; s.buyLastLots = vol; s.buyLastTime = ot; }
      }
      else
      {
         s.sellCount++; s.sellLots += vol; s.sellProfit += prof; sw += openP * vol;
         if(ot > slt) { slt = ot; s.sellLastLots = vol; s.sellLastTime = ot; }
      }
   }
   if(s.buyLots  > 0) s.buyAvg  = bw / s.buyLots;
   if(s.sellLots > 0) s.sellAvg = sw / s.sellLots;
   s.totalProfit = s.buyProfit + s.sellProfit;
}

//+------------------------------------------------------------------+
//| 规范化手数                                                        |
//+------------------------------------------------------------------+
double NormalizeLot(double lots)
{
   double mn = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double mx = MathMin(SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX), MaxLot);
   double st = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(st <= 0) st = 0.01;
   int digits = MathMax(DigitsLot, VolumeDigits(st));
   lots = MathMax(mn, MathMin(mx, lots));
   lots = MathRound(lots / st) * st;
   return NormalizeDouble(lots, digits);
}
int VolumeDigits(const double step)
{
   string ss = DoubleToString(step, 8);
   int e = StringLen(ss) - 1;
   while(e >= 0 && StringGetCharacter(ss, e) == '0') e--;
   int d = StringFind(ss, ".");
   if(d < 0 || e <= d) return 0;
   return e - d;
}

//+------------------------------------------------------------------+
//| 交易函数                                                          |
//+------------------------------------------------------------------+
double PipDivisor() { return (_Digits == 3 || _Digits == 5) ? 10.0 : 1.0; }
double PointSize()   { return _Point * PipDivisor(); }

bool OpenBuy(double lots)
{
   lots = NormalizeLot(lots);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double tp  = ask + FixedTP_Points * PointSize();
   double sl  = ask - FixedSL_Points * PointSize();
   tp = NormalizeDouble(tp, _Digits);
   sl = NormalizeDouble(sl, _Digits);
   bool ok = g_trade.Buy(lots, _Symbol, ask, sl, tp, "跑马灯多单");
   if(!ok) Print("开多失败: ", g_trade.ResultRetcode(), " ", g_trade.ResultRetcodeDescription(), " lots=", lots);
   return ok;
}
bool OpenSell(double lots)
{
   lots = NormalizeLot(lots);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double tp  = bid - FixedTP_Points * PointSize();
   double sl  = bid + FixedSL_Points * PointSize();
   tp = NormalizeDouble(tp, _Digits);
   sl = NormalizeDouble(sl, _Digits);
   bool ok = g_trade.Sell(lots, _Symbol, bid, sl, tp, "跑马灯空单");
   if(!ok) Print("开空失败: ", g_trade.ResultRetcode(), " ", g_trade.ResultRetcodeDescription(), " lots=", lots);
   return ok;
}
void CloseAllBuy()
{
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         g_trade.PositionClose(t);
   }
}
void CloseAllSell()
{
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
         g_trade.PositionClose(t);
   }
}
void CloseAllPositions() { CloseAllBuy(); CloseAllSell(); }
void CloseProfitBuy()
{
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != POSITION_TYPE_BUY) continue;
      if(PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP) >= 0)
         g_trade.PositionClose(t);
   }
}
void CloseProfitSell()
{
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != POSITION_TYPE_SELL) continue;
      if(PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP) >= 0)
         g_trade.PositionClose(t);
   }
}
void CloseLossBuy()
{
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != POSITION_TYPE_BUY) continue;
      if(PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP) < 0)
         g_trade.PositionClose(t);
   }
}
void CloseLossSell()
{
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != POSITION_TYPE_SELL) continue;
      if(PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP) < 0)
         g_trade.PositionClose(t);
   }
}
bool IsNewSignalBar()
{
   datetime cur = iTime(_Symbol, g_SignalTF, 0);
   if(cur == 0) return false;
   if(cur != g_lastSignalBarTime) { g_lastSignalBarTime = cur; return true; }
   return false;
}

//+------------------------------------------------------------------+
//|=======================  AI 风控模块  =============================|
//+------------------------------------------------------------------+
bool IsInAICooldown(int dir)
{
   if(g_aiLastTime == 0) return false;
   if(g_aiLastDirection != dir) return false;
   return (TimeCurrent() < g_aiLastTime + (datetime)(AI_CooldownMin * 60));
}
string EscapeJson(string s)
{
   StringReplace(s, "\\", "\\\\");
   StringReplace(s, "\"", "\\\"");
   StringReplace(s, "\n", "\\n");
   StringReplace(s, "\r", "\\r");
   StringReplace(s, "\t", "\\t");
   return s;
}
void ParseUrl(string url, string &host, string &path)
{
   host = ""; path = ""; string s = url;
   int p = StringFind(s, "://", 0);
   if(p >= 0) s = StringSubstr(s, p + 3);
   int slash = StringFind(s, "/", 0);
   if(slash < 0) { host = s; path = "/"; }
   else { host = StringSubstr(s, 0, slash); path = StringSubstr(s, slash); }
}
string ExtractJsonContent(string json)
{
   int p1 = StringFind(json, "\"content\"", 0);
   if(p1 < 0) return "";
   p1 = StringFind(json, "\"", p1 + 9);
   if(p1 < 0) return "";
   int p2 = p1 + 1;
   while(p2 < StringLen(json))
   {
      if(StringGetCharacter(json, p2) == '"' && StringGetCharacter(json, p2 - 1) != '\\') break;
      p2++;
   }
   if(p2 >= StringLen(json)) return "";
   string c = StringSubstr(json, p1 + 1, p2 - p1 - 1);
   // 先反转义 \\ 再其他
   StringReplace(c, "\\\\", "\\");
   StringReplace(c, "\\n", "\n");
   StringReplace(c, "\\\"", "\"");
   return c;
}
int ExtractScore(string content)
{
   string num = "";
   for(int i = 0; i < StringLen(content); i++)
   {
      ushort c = StringGetCharacter(content, i);
      if(c >= '0' && c <= '9') num += CharToString((uchar)c);
      else if(num != "") break;
   }
   if(num == "") return -1;
   int sc = (int)StringToInteger(num);
   if(sc < 0) sc = 0; if(sc > 100) sc = 100;
   return sc;
}
string BuildAIReport(int dir, int sig, EAStats &stats)
{
   string dStr = (dir == 1 ? "BUY" : "SELL");
   string sStr = (sig == 1 ? "BullCross(RSI4>GreenLine)" : "BearCross(RSI4<GreenLine)");
   double rsi0=0,rsi1=0,gl0=0,gl1=0; int dummy;
   GetCurrentSignalDisplay(rsi0, rsi1, gl0, gl1, dummy);

   string r = StringFormat(
      "SYM=%s; TF=H4; PRICE_BID=%.5f; PRICE_ASK=%.5f; "
      "RSI4_0=%.2f; RSI4_1=%.2f; "
      "GreenLine_0=%.2f; GreenLine_1=%.2f; "
      "CROSS_SIG=%s; DIR=%s; "
      "BUY_CNT=%d; SELL_CNT=%d; "
      "BUY_LOTS=%.2f; SELL_LOTS=%.2f; "
      "BUY_PROFIT=%.2f; SELL_PROFIT=%.2f; "
      "BUY_AVG=%.5f; SELL_AVG=%.5f; "
      "TOTAL_PROFIT=%.2f; MAX_ORDERS_ALLOWED=%d; LOT_MULTIPLIER=%.2f; "
      "FIXED_TP=%dpts; FIXED_SL=%dpts",
      _Symbol,
      SymbolInfoDouble(_Symbol, SYMBOL_BID),
      SymbolInfoDouble(_Symbol, SYMBOL_ASK),
      rsi0, rsi1, gl0, gl1,
      sStr, dStr,
      stats.buyCount, stats.sellCount,
      stats.buyLots, stats.sellLots,
      stats.buyProfit, stats.sellProfit,
      stats.buyAvg, stats.sellAvg,
      stats.totalProfit, MaxOrders, Multiplier,
      FixedTP_Points, FixedSL_Points
   );
   // 多周期高低
   double h = iHigh(_Symbol, PERIOD_H4, 1);
   double l = iLow (_Symbol, PERIOD_H4, 1);
   double dh= iHigh(_Symbol, PERIOD_D1, 1);
   double dl= iLow (_Symbol, PERIOD_D1, 1);
   r += StringFormat("; H4_HL[1]=%.5f/%.5f; D1_HL[1]=%.5f/%.5f; POINT_PIP=%.6f",
                     h, l, dh, dl, PointSize());
   return r;
}
int RequestAIScore(string report, int dir)
{
   g_aiLastDirection = dir;
   string userContent = g_aiUsrPrompt_rt +
      " | DATA: " + report +
      " | TASK: 评估当前开" + (dir == 1 ? "多" : "空") + "仓胜率，仅返回0-100之间的整数，不要其他文字。";

   string payload = "{\"model\":\"" + AI_Model + "\",\"messages\":[";
   payload += "{\"role\":\"system\",\"content\":\"" + EscapeJson(g_aiSysPrompt_rt) + "\"},";
   payload += "{\"role\":\"user\",\"content\":\""   + EscapeJson(userContent)  + "\"}";
   payload += "],\"temperature\":0.3,\"max_tokens\":100}";

   string host, path;
   ParseUrl(AI_ApiUrl, host, path);
   if(host == "") { g_aiLastError = "URL解析失败"; return -1; }

   string headers = "Content-Type: application/json\r\n";
   headers += "Authorization: Bearer " + AI_ApiKey + "\r\n";

   uchar post[], result[];
   StringToCharArray(payload, post, 0, StringLen(payload));
   ArrayResize(post, ArraySize(post) - 1);

   string resultHeaders;
   int timeoutMs = AI_TimeoutSec * 1000;
   ResetLastError();
   int code = WebRequest("POST", AI_ApiUrl, headers, timeoutMs,
                         post, result, resultHeaders);
   if(code == -1)
   {
      int e = GetLastError();
      g_aiLastError = "WebRequest失败 err=" + IntegerToString(e) + " (请在MT5选项中允许" + host + ")";
      Print("[AI] ", g_aiLastError);
      return -1;
   }
   if(code != 200)
   {
      g_aiLastError = "HTTP " + IntegerToString(code) + ": " + CharArrayToString(result);
      Print("[AI] ", g_aiLastError);
      return -1;
   }
   string content = ExtractJsonContent(CharArrayToString(result));
   if(content == "") { g_aiLastError = "JSON解析失败"; return -1; }
   int sc = ExtractScore(content);
   if(sc < 0) { g_aiLastError = "无法提取评分: " + content; Print("[AI] ", g_aiLastError); return -1; }
   g_aiLastError = "";
   return sc;
}
bool AIFilter(int dir, int sig, EAStats &stats)
{
   if(!g_aiEnabled_rt) return true;
   g_aiLastDirection = dir;
   if(IsInAICooldown(dir))
   {
      bool pass = (g_aiLastDecision == 1);
      Print("[AI] 冷却期沿用上次: ", pass ? "放行" : "拒绝");
      return pass;
   }
   string report = BuildAIReport(dir, sig, stats);
   g_aiLastTime = TimeCurrent();
   int sc = RequestAIScore(report, dir);
   g_aiLastScore = sc;
   if(sc < 0) { g_aiLastDecision = AI_FailOpen ? 1 : -1; return AI_FailOpen; }
   g_aiLastDecision = (sc >= AI_ScoreThreshold) ? 1 : -1;
   Print("[AI] 评分=", sc, " 阈值=", AI_ScoreThreshold,
         " 决定=", (g_aiLastDecision == 1 ? "放行" : "拒绝"));
   return (g_aiLastDecision == 1);
}

//+------------------------------------------------------------------+
//| 跑马灯主策略逻辑(H4新K线执行)                                      |
//| 规则:                                                            |
//|  1. 新K线先判断是否有交叉信号                                     |
//|  2. 无仓 + 有信号 → AI过滤 → 开首单                              |
//|  3. 有同向仓 + 同向信号 → 1.3倍加仓(不过AI)                      |
//|  4. 有反向仓 + 反向信号 → 1.3倍加仓(不过AI)                      |
//|  5. 每单固定100点TP/SL, 单子触发后等待新信号重新入场              |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!g_eaEnabled) { RefreshPanel(false); return; }

   // 检查订单数上限保护
   EAStats stats;
   CollectStats(stats);
   if(stats.buyCount + stats.sellCount >= MaxOrders)
   {
      RefreshPanel(false);
      return;
   }

   // 新K线触发开仓逻辑
   if(IsNewSignalBar())
   {
      int sig = GetCrossSignal();
      if(sig != 0)
      {
         CollectStats(stats);
         bool isFirst = (stats.buyCount == 0 && stats.sellCount == 0);
         if(sig == 1 && g_allow_buy)
         {
            double lots = InitialLots;
            if(isFirst)
            {
               if(!AIFilter(1, sig, stats)) { Print("[AI] 首多被拒"); }
               else OpenBuy(lots);
            }
            else if(stats.buyCount > 0)
            {
               // 同向已有持仓 → 1.3倍加仓
               double baseLot = (stats.buyLastLots > 0) ? stats.buyLastLots : InitialLots;
               OpenBuy(NormalizeLot(baseLot * Multiplier));
            }
            else if(stats.sellCount > 0 && stats.buyCount == 0)
            {
               // 反向信号 + 当前为纯空仓 → 按首单逻辑开多(跑马灯反手首单过AI)
               if(!AIFilter(1, sig, stats)) { Print("[AI] 反手多被拒"); }
               else
               {
                  double baseLot = (stats.sellLastLots > 0) ? stats.sellLastLots : InitialLots;
                  OpenBuy(NormalizeLot(baseLot * Multiplier));
               }
            }
         }
         else if(sig == -1 && g_allow_sell)
         {
            if(isFirst)
            {
               if(!AIFilter(-1, sig, stats)) { Print("[AI] 首空被拒"); }
               else OpenSell(InitialLots);
            }
            else if(stats.sellCount > 0)
            {
               double baseLot = (stats.sellLastLots > 0) ? stats.sellLastLots : InitialLots;
               OpenSell(NormalizeLot(baseLot * Multiplier));
            }
            else if(stats.buyCount > 0 && stats.sellCount == 0)
            {
               if(!AIFilter(-1, sig, stats)) { Print("[AI] 反手空被拒"); }
               else
               {
                  double baseLot = (stats.buyLastLots > 0) ? stats.buyLastLots : InitialLots;
                  OpenSell(NormalizeLot(baseLot * Multiplier));
               }
            }
         }
      }
   }
   RefreshPanel(false);
}

//+------------------------------------------------------------------+
//|=======================  面板交互区  ==============================|
//+------------------------------------------------------------------+
bool ShowConfirm(const string msg)
{
   return (MessageBox(msg, "确认操作", MB_YESNO | MB_ICONQUESTION) == IDYES);
}
void ResetBtnState(const string name)
{
   if(name == "" || ObjectFind(0, name) < 0) return;
   ObjectSetInteger(0, name, OBJPROP_STATE, false);
}
void HandlePanelButtonClick(const string key)
{
   EAStats s; CollectStats(s);
   if(key == BTN_TOGGLE_PANEL)
   {
      ResetBtnState(key);
      if(g_panel_open)
         if(!ShowConfirm("确定隐藏操作面板？隐藏后左下角有展开按钮恢复。")) return;
      g_panel_open = !g_panel_open;
      g_panel_dragging = false;
      SetPanelDragHighlight(false);
      RefreshPanel(true);
      return;
   }
   if(key == BTN_STOP_ALL)
   {
      ResetBtnState(key);
      bool cur = (g_allow_buy || g_allow_sell);
      if(cur)
      {
         if(!ShowConfirm("确定停止全部交易？暂停新开单，已有持仓保留。")) return;
      }
      else if(!ShowConfirm("确定开启全部交易？")) return;
      g_allow_buy  = !cur;
      g_allow_sell = !cur;
      RefreshPanel(true);
      return;
   }
   if(key == BTN_STOP_BUY)
   {
      ResetBtnState(key);
      if(g_allow_buy)
      {
         if(!ShowConfirm("确定暂停做多？")) return;
      }
      else if(!ShowConfirm("确定开启做多？")) return;
      g_allow_buy = !g_allow_buy;
      RefreshPanel(true);
      return;
   }
   if(key == BTN_STOP_SELL)
   {
      ResetBtnState(key);
      if(g_allow_sell)
      {
         if(!ShowConfirm("确定暂停做空？")) return;
      }
      else if(!ShowConfirm("确定开启做空？")) return;
      g_allow_sell = !g_allow_sell;
      RefreshPanel(true);
      return;
   }
   if(key == BTN_CLOSE_ALL_BUY)
   {
      ResetBtnState(key);
      if(!ShowConfirm("确定平全部多单？(" + IntegerToString(s.buyCount) + "单 " + DoubleToString(s.buyLots,2) + "手)")) return;
      CloseAllBuy(); RefreshPanel(true);
      return;
   }
   if(key == BTN_CLOSE_ALL_SELL)
   {
      ResetBtnState(key);
      if(!ShowConfirm("确定平全部空单？(" + IntegerToString(s.sellCount) + "单 " + DoubleToString(s.sellLots,2) + "手)")) return;
      CloseAllSell(); RefreshPanel(true);
      return;
   }
   if(key == BTN_CLOSE_PROFIT_BUY)
   {
      ResetBtnState(key);
      if(!ShowConfirm("确定平盈利多单？")) return;
      CloseProfitBuy(); RefreshPanel(true); return;
   }
   if(key == BTN_CLOSE_PROFIT_SELL)
   {
      ResetBtnState(key);
      if(!ShowConfirm("确定平盈利空单？")) return;
      CloseProfitSell(); RefreshPanel(true); return;
   }
   if(key == BTN_CLOSE_LOSS_BUY)
   {
      ResetBtnState(key);
      if(!ShowConfirm("确定平亏损多单？")) return;
      CloseLossBuy(); RefreshPanel(true); return;
   }
   if(key == BTN_CLOSE_LOSS_SELL)
   {
      ResetBtnState(key);
      if(!ShowConfirm("确定平亏损空单？")) return;
      CloseLossSell(); RefreshPanel(true); return;
   }
   if(key == BTN_CLOSE_ALL)
   {
      ResetBtnState(key);
      if(!ShowConfirm("确定一键全平EA全部持仓？\n(" + IntegerToString(s.buyCount + s.sellCount) + "单)")) return;
      CloseAllPositions(); RefreshPanel(true);
      return;
   }
   if(key == BTN_AI_ONOFF)
   {
      ResetBtnState(key);
      g_aiEnabled_rt = !g_aiEnabled_rt;
      ObjectSetInteger(0, BTN_AI_ONOFF, OBJPROP_BGCOLOR, g_aiEnabled_rt ? clrDarkGreen : clrMaroon);
      ObjectSetString (0, BTN_AI_ONOFF, OBJPROP_TEXT,    g_aiEnabled_rt ? "AI: 开" : "AI: 关");
      Print("[AI] 风控已", g_aiEnabled_rt ? "开启" : "关闭");
      ChartRedraw(); RefreshPanel(true);
      return;
   }
   if(key == BTN_AI_PREVIEW)
   {
      ResetBtnState(key);
      int dir = 0;
      EAStats s2; CollectStats(s2);
      int sig = GetCrossSignal();
      double rsi0,rsi1,gl0,gl1; int sdummy;
      GetCurrentSignalDisplay(rsi0, rsi1, gl0, gl1, sdummy);
      if(sig == 1) dir = 1;
      else if(sig == -1) dir = -1;
      else
      {
         // 无信号时按上次方向预览
         dir = g_aiLastDirection != 0 ? g_aiLastDirection : 1;
      }
      string rep = BuildAIReport(dir, sig, s2);
      string uc = g_aiUsrPrompt_rt + " | DATA: " + rep +
         " | TASK: 评估当前开" + (dir == 1 ? "多" : "空") + "仓胜率，返回0-100整数。";
      string msg = "===== System Prompt =====\n" + g_aiSysPrompt_rt +
         "\n\n===== User Prompt =====\n" + uc +
         "\n\n===== API =====\nURL: " + AI_ApiUrl +
         "\nModel: " + AI_Model + "\nTimeout: " + IntegerToString(AI_TimeoutSec) +
         "s\nThreshold: " + IntegerToString(AI_ScoreThreshold) +
         "\nAI Status: " + (g_aiEnabled_rt ? "ON" : "OFF");
      MessageBox(msg, "AI Prompt 预览", MB_OK | MB_ICONINFORMATION);
      return;
   }
   if(key == BTN_RESET)
   {
      ResetBtnState(key);
      if(!ShowConfirm("确定重置信号K线时间标记？")) return;
      g_lastSignalBarTime = 0;
      RefreshPanel(true);
      return;
   }
}

//+------------------------------------------------------------------+
//| UI 工具函数                                                       |
//+------------------------------------------------------------------+
double UiScale()
{
   long cw = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
   long dpi = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   double s = 1.0;
   if(dpi >= 192) s = 1.08;
   else if(dpi >= 160) s = 1.04;
   else if(dpi <= 96) s = 0.98;
   if(cw <= 1280) s = MathMin(s, 0.94);
   else if(cw >= 2400) s = MathMin(MathMax(s, 1.0), 1.08);
   return MathMax(0.90, MathMin(s, 1.10));
}
double UiFontScale()
{
   long cw = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
   long dpi = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   double s = 1.0;
   if(dpi >= 192) s = 1.05;
   else if(dpi >= 160) s = 1.02;
   else if(dpi <= 96) s = 0.97;
   if(cw <= 1280) s = MathMin(s, 0.96);
   return MathMax(0.92, MathMin(s, 1.06));
}
int Spx(int v) { return (int)MathRound(v * UiScale()); }
int Sfx(int v) { return (int)MathRound(v * UiFontScale()); }
void BuildPanelMetrics(PanelMetrics &m)
{
   long cw = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
   int avail = (int)MathMax(320.0, (double)cw - Spx(36));
   m.margin_x    = g_panel_x;
   m.margin_y    = g_panel_y;
   m.width       = (int)MathMax(320.0, MathMin((double)Spx(480), (double)avail));
   m.pad         = Spx(14);
   m.section_gap = Spx(10);
   m.header_h    = Spx(56);
   m.row_h       = Spx(18);
   m.gap         = Spx(8);
   m.button_h    = Spx(28);
   m.inner_w     = m.width - m.pad * 2;
   m.half_w      = (m.inner_w - m.gap) / 2;
   m.card_status_h  = Spx(156);
   m.card_signal_h  = Spx(100);
   m.card_metrics_h = Spx(180);
   m.card_ai_h      = Spx(196);
   m.card_actions_h = m.pad * 2 + Spx(22) + m.gap + m.button_h * 6 + m.gap * 5;
   m.button_font = Sfx(9);
   m.font_xs     = Sfx(9);
   m.font_sm     = Sfx(10);
   m.font_md     = Sfx(11);
   m.font_lg     = Sfx(15);
   m.toggle_w    = (m.width <= Spx(360)) ? Spx(56) : Spx(64);
   m.panel_h = m.header_h + m.section_gap * 6 +
               m.card_status_h + m.card_signal_h + m.card_metrics_h +
               m.card_ai_h + m.card_actions_h;
}
void EnsureRect(const string n, int x, int y, int w, int h, color bg, color bd, int corner)
{
   if(ObjectFind(0, n) < 0) ObjectCreate(0, n, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, n, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, n, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, n, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, n, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, n, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, n, OBJPROP_BGCOLOR, bg);
   ObjectSetInteger(0, n, OBJPROP_COLOR, bd);
   ObjectSetInteger(0, n, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, n, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, n, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, n, OBJPROP_HIDDEN, true);
}
void EnsureLabel(const string n, const string t, int x, int y, int fs, color c, int corner, const string fnt = "Microsoft YaHei")
{
   if(ObjectFind(0, n) < 0) ObjectCreate(0, n, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, n, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, n, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, n, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, n, OBJPROP_COLOR, c);
   ObjectSetInteger(0, n, OBJPROP_FONTSIZE, fs);
   ObjectSetString (0, n, OBJPROP_FONT, fnt);
   ObjectSetString (0, n, OBJPROP_TEXT, t);
   ObjectSetInteger(0, n, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, n, OBJPROP_HIDDEN, true);
}
void EnsureBtn(const string n, const string t, int x, int y, int w, int h, color bg, color fg, int corner)
{
   if(ObjectFind(0, n) < 0) ObjectCreate(0, n, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, n, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, n, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, n, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, n, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, n, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, n, OBJPROP_COLOR, fg);
   ObjectSetInteger(0, n, OBJPROP_BGCOLOR, bg);
   ObjectSetInteger(0, n, OBJPROP_BORDER_COLOR, bg);
   ObjectSetInteger(0, n, OBJPROP_FONTSIZE, Sfx(9));
   ObjectSetString (0, n, OBJPROP_FONT, "Microsoft YaHei");
   ObjectSetString (0, n, OBJPROP_TEXT, t);
   ObjectSetInteger(0, n, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, n, OBJPROP_HIDDEN, true);
}
bool CreateEditBox(const string n, int x, int y, int w, int h, const string def)
{
   if(ObjectFind(0, n) < 0)
      if(!ObjectCreate(0, n, OBJ_EDIT, 0, 0, 0)) return false;
   ObjectSetInteger(0, n, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, n, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, n, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, n, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, n, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, n, OBJPROP_COLOR, C'244,248,252');
   ObjectSetInteger(0, n, OBJPROP_BGCOLOR, C'32,44,61');
   ObjectSetInteger(0, n, OBJPROP_BACK, false);
   ObjectSetInteger(0, n, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, n, OBJPROP_READONLY, false);
   ObjectSetInteger(0, n, OBJPROP_ALIGN, ALIGN_LEFT);
   ObjectSetString (0, n, OBJPROP_FONT, "Consolas");
   ObjectSetInteger(0, n, OBJPROP_FONTSIZE, 8);
   ObjectSetString (0, n, OBJPROP_TEXT, def);
   return true;
}
void DeletePanelContentObjects()
{
   for(int i = ObjectsTotal(0, -1, -1) - 1; i >= 0; i--)
   {
      string nm = ObjectName(0, i, -1, -1);
      if(StringFind(nm, g_panel_prefix, 0) != 0) continue;
      if(nm == BTN_TOGGLE_PANEL) continue;
      ObjectDelete(0, nm);
   }
}
void DeleteObjectsByPrefix(const string pfx)
{
   for(int i = ObjectsTotal(0, -1, -1) - 1; i >= 0; i--)
   {
      string nm = ObjectName(0, i, -1, -1);
      if(StringFind(nm, pfx, 0) == 0) ObjectDelete(0, nm);
   }
}
void ClampPanelPosition(int &px, int &py)
{
   PanelMetrics m; BuildPanelMetrics(m);
   long cw = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
   long ch = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
   int maxx = (int)cw - m.width;  if(maxx < 0) maxx = 0;
   int maxy = (int)ch - m.panel_h; if(maxy < 0) maxy = 0;
   if(px < 0) px = 0; if(py < 0) py = 0;
   if(px > maxx) px = maxx; if(py > maxy) py = maxy;
}
bool IsClickOnPanelDragArea(int cx, int cy)
{
   if(!g_panel_open) return false;
   PanelMetrics m; BuildPanelMetrics(m);
   return (cx >= g_panel_x && cx <= g_panel_x + m.width &&
           cy >= g_panel_y && cy <= g_panel_y + m.header_h);
}
void MovePanelTo(int nx, int ny)
{
   int dx = nx - g_panel_x, dy = ny - g_panel_y;
   if(dx == 0 && dy == 0) return;
   for(int i = ObjectsTotal(0, -1, -1) - 1; i >= 0; i--)
   {
      string nm = ObjectName(0, i, -1, -1);
      if(StringFind(nm, g_panel_prefix, 0) != 0) continue;
      if(nm == BTN_TOGGLE_PANEL) continue;
      int x = (int)ObjectGetInteger(0, nm, OBJPROP_XDISTANCE);
      int y = (int)ObjectGetInteger(0, nm, OBJPROP_YDISTANCE);
      ObjectSetInteger(0, nm, OBJPROP_XDISTANCE, x + dx);
      ObjectSetInteger(0, nm, OBJPROP_YDISTANCE, y + dy);
   }
   g_panel_x = nx; g_panel_y = ny; ChartRedraw(0);
}
void SetPanelDragHighlight(bool on)
{
   string pn = g_panel_prefix + "panel";
   if(ObjectFind(0, pn) < 0) return;
   ObjectSetInteger(0, pn, OBJPROP_COLOR, on ? C'66,153,225' : C'45,58,74');
   ObjectSetInteger(0, pn, OBJPROP_WIDTH, on ? 2 : 1);
}
string BoolTxt(bool e, string on, string off) { return e ? on : off; }
string Money(double v) { return DoubleToString(v, 2); }

//+------------------------------------------------------------------+
//| 面板绘制                                                          |
//+------------------------------------------------------------------+
void DrawToggleAnchor()
{
   int corner = CORNER_LEFT_LOWER;
   color accent = C'66,153,225';
   string txt = g_panel_open ? "隐藏面板" : "展开面板";
   EnsureBtn(BTN_TOGGLE_PANEL, txt, Spx(16), Spx(35), Spx(90), Spx(30), accent, clrWhite, corner);
}
void DrawPanel()
{
   if(!g_panel_open) { DrawToggleAnchor(); return; }

   PanelMetrics m; BuildPanelMetrics(m);
   const int C  = CORNER_LEFT_UPPER;
   const color PANEL_BG    = C'15,20,27';
   const color PANEL_BD    = C'45,58,74';
   const color HDR_BG      = C'20,29,40';
   const color CARD_BG     = C'24,33,45';
   const color MUTED       = C'150,164,181';
   const color OK          = C'88,199,135';
   const color WARN        = C'255,183,77';
   const color BAD         = C'239,100,97';
   const color ACCENT      = C'66,153,225';
   const color ACCENT2     = C'34,197,154';
   const color CREAM       = C'244,248,252';

   int x  = m.margin_x;
   int ix = x + m.pad;
   int ix2= ix + m.half_w + m.gap;

   EAStats s; CollectStats(s);
   double rsi0=0,rsi1=0,gl0=0,gl1=0; int csig=0;
   GetCurrentSignalDisplay(rsi0, rsi1, gl0, gl1, csig);

   const double pip = PointSize();
   double bpts = (s.buyLots  > 0) ? (SymbolInfoDouble(_Symbol, SYMBOL_BID) - s.buyAvg)  / pip : 0;
   double spts = (s.sellLots > 0) ? (s.sellAvg - SymbolInfoDouble(_Symbol, SYMBOL_ASK)) / pip : 0;
   double bal  = AccountInfoDouble(ACCOUNT_BALANCE);
   double eq   = AccountInfoDouble(ACCOUNT_EQUITY);
   double mg   = AccountInfoDouble(ACCOUNT_MARGIN);
   double mlvl = (mg > 0) ? eq / mg * 100.0 : 0;
   double spreadPts = (SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID)) / pip;

   string ws  = g_eaEnabled ? "运行中" : "EA已暂停";
   color  wc  = g_eaEnabled ? OK : BAD;
   if(!g_allow_buy && !g_allow_sell) { ws = "手动停开"; wc = WARN; }
   else if(!g_allow_buy || !g_allow_sell) { ws = "单边运行"; wc = ACCENT2; }

   string sigTxt = (csig == 1 ? "看多金叉 ↑" : csig == -1 ? "看空死叉 ↓" : "等待信号 —");
   color  sigClr = (csig == 1 ? OK : csig == -1 ? BAD : WARN);
   datetime nowv = TimeCurrent();

   string tfStr = "H4";
   if(g_SignalTF == PERIOD_H1) tfStr = "H1";
   else if(g_SignalTF == PERIOD_H4) tfStr = "H4";
   else if(g_SignalTF == PERIOD_D1) tfStr = "D1";
   else tfStr = EnumToString(g_SignalTF);

   // 主容器
   EnsureRect(g_panel_prefix + "panel",         x, g_panel_y, m.width, m.panel_h, PANEL_BG, PANEL_BD, C);
   EnsureRect(g_panel_prefix + "header",        x, g_panel_y, m.width, m.header_h, HDR_BG, PANEL_BD, C);
   EnsureLabel(g_panel_prefix + "title",       "GBPUSD 绿线跑马灯 EA", ix + Spx(6), g_panel_y + Spx(10), m.font_lg, CREAM, C);
   EnsureLabel(g_panel_prefix + "subtitle",    _Symbol + " | " + tfStr + " | TP" + IntegerToString(FixedTP_Points) + "/SL" + IntegerToString(FixedSL_Points) + " | " + AccountInfoString(ACCOUNT_CURRENCY),
               ix + Spx(6), g_panel_y + Spx(32), m.font_sm, MUTED, C);

   int y = g_panel_y + m.header_h + m.section_gap;
   // 卡1：工作状态
   EnsureRect(g_panel_prefix + "c1", x, y, m.width, m.card_status_h, CARD_BG, PANEL_BD, C);
   EnsureLabel(g_panel_prefix + "c1t", "工作状态", ix, y + m.pad - Spx(1), m.font_md, CREAM, C);
   EnsureLabel(g_panel_prefix + "c1l1", "状态：" + ws,                          ix, y + m.pad + Spx(22), m.font_sm, wc, C);
   EnsureLabel(g_panel_prefix + "c1l2", "交易：多" + BoolTxt(g_allow_buy,"开","停") + " / 空" + BoolTxt(g_allow_sell,"开","停"),
                                                                        ix, y + m.pad + Spx(42), m.font_sm, CREAM, C);
   EnsureLabel(g_panel_prefix + "c1l3", "信号：" + sigTxt,                  ix, y + m.pad + Spx(62), m.font_sm, sigClr, C);
   EnsureLabel(g_panel_prefix + "c1l4", "持仓：多" + IntegerToString(s.buyCount) + "单 / 空" + IntegerToString(s.sellCount) + "单",
                                                                        ix, y + m.pad + Spx(82), m.font_sm, CREAM, C);
   EnsureLabel(g_panel_prefix + "c1l5", "浮盈：" + Money(s.totalProfit),   ix, y + m.pad + Spx(102), m.font_sm,
                                                                        (s.totalProfit >= 0 ? OK : BAD), C);
   EnsureLabel(g_panel_prefix + "c1l6", "净值：" + Money(eq) + " | 保证金额度：" + Money(mg) + " (" + IntegerToString((int)mlvl) + "%)",
                                                                        ix, y + m.pad + Spx(122), m.font_xs, MUTED, C);

   y += m.card_status_h + m.section_gap;
   // 卡2：信号指标
   EnsureRect(g_panel_prefix + "c2", x, y, m.width, m.card_signal_h, CARD_BG, PANEL_BD, C);
   EnsureLabel(g_panel_prefix + "c2t", "H4 信号指标 (RSI" + IntegerToString(RSI_Period) + " vs 绿色线)",
               ix, y + m.pad - Spx(1), m.font_md, CREAM, C);
   EnsureLabel(g_panel_prefix + "c2l1",
               StringFormat("RSI4 当前：%.2f   上一根：%.2f", rsi0, rsi1),
               ix, y + m.pad + Spx(22), m.font_sm, C'100,200,255', C);
   EnsureLabel(g_panel_prefix + "c2l2",
               StringFormat("绿线 当前：%.2f   上一根：%.2f", gl0, gl1),
               ix, y + m.pad + Spx(42), m.font_sm, C'124,252,0', C);
   EnsureLabel(g_panel_prefix + "c2l3",
               "点差：" + DoubleToString(spreadPts, 1) + "pips   |   倍投：" + DoubleToString(Multiplier, 2) + "x   |   首单：" + DoubleToString(InitialLots,2) + "手",
               ix, y + m.pad + Spx(62), m.font_xs, MUTED, C);

   y += m.card_signal_h + m.section_gap;
   // 卡3：持仓明细
   EnsureRect(g_panel_prefix + "c3", x, y, m.width, m.card_metrics_h, CARD_BG, PANEL_BD, C);
   EnsureLabel(g_panel_prefix + "c3t", "持仓明细", ix, y + m.pad - Spx(1), m.font_md, CREAM, C);
   EnsureLabel(g_panel_prefix + "c3b1", "多单数：" + IntegerToString(s.buyCount),
               ix,      y + m.pad + Spx(22), m.font_sm, C'100,200,255', C);
   EnsureLabel(g_panel_prefix + "c3b2", "多手数：" + DoubleToString(s.buyLots, 2),
               ix,      y + m.pad + Spx(42), m.font_sm, C'100,200,255', C);
   EnsureLabel(g_panel_prefix + "c3b3", "多均价：" + DoubleToString(s.buyAvg, _Digits),
               ix,      y + m.pad + Spx(62), m.font_sm, C'100,200,255', C);
   EnsureLabel(g_panel_prefix + "c3b4", "多浮盈：" + Money(s.buyProfit) + " (" + DoubleToString(bpts,1) + "点)",
               ix,      y + m.pad + Spx(82), m.font_sm, (s.buyProfit >= 0 ? OK : BAD), C);
   EnsureLabel(g_panel_prefix + "c3s1", "空单数：" + IntegerToString(s.sellCount),
               ix2,     y + m.pad + Spx(22), m.font_sm, C'255,180,180', C);
   EnsureLabel(g_panel_prefix + "c3s2", "空手数：" + DoubleToString(s.sellLots, 2),
               ix2,     y + m.pad + Spx(42), m.font_sm, C'255,180,180', C);
   EnsureLabel(g_panel_prefix + "c3s3", "空均价：" + DoubleToString(s.sellAvg, _Digits),
               ix2,     y + m.pad + Spx(62), m.font_sm, C'255,180,180', C);
   EnsureLabel(g_panel_prefix + "c3s4", "空浮盈：" + Money(s.sellProfit) + " (" + DoubleToString(spts,1) + "点)",
               ix2,     y + m.pad + Spx(82), m.font_sm, (s.sellProfit >= 0 ? OK : BAD), C);
   EnsureLabel(g_panel_prefix + "c3last",
               "末单手数：多" + DoubleToString(s.buyLastLots,2) + " / 空" + DoubleToString(s.sellLastLots,2),
               ix, y + m.pad + Spx(108), m.font_xs, MUTED, C);
   EnsureLabel(g_panel_prefix + "c3acc",
               "账户余额：" + Money(bal) + "  " + _Symbol,
               ix, y + m.pad + Spx(128), m.font_xs, MUTED, C);

   y += m.card_metrics_h + m.section_gap;
   // 卡4：AI 风控
   EnsureRect(g_panel_prefix + "c4", x, y, m.width, m.card_ai_h, CARD_BG, PANEL_BD, C);
   EnsureLabel(g_panel_prefix + "c4t", "AI 智能风控", ix, y + m.pad - Spx(1), m.font_md, CREAM, C);

   int btx = ix;
   EnsureBtn(BTN_AI_ONOFF, g_aiEnabled_rt ? "AI: 开" : "AI: 关",
             btx, y + m.pad + Spx(18), Spx(90), m.button_h,
             g_aiEnabled_rt ? clrDarkGreen : clrMaroon, clrWhite, C);
   EnsureBtn(BTN_AI_PREVIEW, "预览Prompt",
             btx + Spx(96), y + m.pad + Spx(18), Spx(100), m.button_h,
             C'49,55,69', clrWhite, C);

   string model = (AI_Model != "" ? AI_Model : "--");
   string scoreTxt = (g_aiLastScore >= 0 ? IntegerToString(g_aiLastScore) : "--");
   color  scoreClr = (g_aiLastScore >= AI_ScoreThreshold && g_aiLastScore >= 0) ? OK :
                     (g_aiLastScore >= 0 ? BAD : MUTED);
   string lastTxt  = "上次：";
   if(g_aiLastTime == 0) lastTxt += "--";
   else
   {
      string dec = (g_aiLastDecision == 1 ? "放行" : g_aiLastDecision == -1 ? "拒绝" : "--");
      lastTxt += dec + " (" + IntegerToString((int)(TimeCurrent() - g_aiLastTime)) + "s前)";
   }
   color lastClr = (g_aiLastDecision == 1 ? OK : g_aiLastDecision == -1 ? BAD : MUTED);

   EnsureLabel(g_panel_prefix + "c4m", "模型: " + model,
               ix, y + m.pad + Spx(56), m.font_xs, MUTED, C);
   EnsureLabel(g_panel_prefix + "c4sc", "评分: " + scoreTxt + "/" + IntegerToString(AI_ScoreThreshold),
               ix, y + m.pad + Spx(72), m.font_sm, scoreClr, C);
   EnsureLabel(g_panel_prefix + "c4ls", lastTxt,
               ix, y + m.pad + Spx(90), m.font_xs, lastClr, C);
   if(g_aiLastError != "")
      EnsureLabel(g_panel_prefix + "c4er", "错误: " + g_aiLastError,
                  ix, y + m.pad + Spx(108), m.font_xs, BAD, C);

   EnsureLabel(g_panel_prefix + "c4l1", "System Prompt:",
               ix, y + m.pad + Spx(124), m.font_xs, C'200,200,220', C);
   CreateEditBox(EDIT_SYS, ix, y + m.pad + Spx(140), m.inner_w, Spx(22), g_aiSysPrompt_rt);

   y += m.card_ai_h + m.section_gap;
   // 卡5：操作按钮 (6行 2列)
   EnsureRect(g_panel_prefix + "c5", x, y, m.width, m.card_actions_h, CARD_BG, PANEL_BD, C);
   EnsureLabel(g_panel_prefix + "c5t", "操作面板", ix, y + m.pad - Spx(1), m.font_md, CREAM, C);

   int by = y + m.pad + Spx(22);
   int bw = m.half_w, bh = m.button_h;
   EnsureBtn(BTN_STOP_ALL,       BoolTxt((g_allow_buy||g_allow_sell),"一键停开","恢复开仓"),
             ix,  by, bw, bh, C'180,80,20', clrWhite, C);
   EnsureBtn(BTN_CLOSE_ALL,      "全平EA全部持仓",
             ix2, by, bw, bh, BAD, clrWhite, C);
   by += bh + m.gap;
   EnsureBtn(BTN_STOP_BUY,       "多" + BoolTxt(g_allow_buy,"开","停"),
             ix,  by, bw, bh, C'30,110,160', clrWhite, C);
   EnsureBtn(BTN_CLOSE_ALL_BUY,  "平全部多单",
             ix2, by, bw, bh, C'60,130,180', clrWhite, C);
   by += bh + m.gap;
   EnsureBtn(BTN_STOP_SELL,      "空" + BoolTxt(g_allow_sell,"开","停"),
             ix,  by, bw, bh, C'160,60,80', clrWhite, C);
   EnsureBtn(BTN_CLOSE_ALL_SELL, "平全部空单",
             ix2, by, bw, bh, C'180,80,100', clrWhite, C);
   by += bh + m.gap;
   EnsureBtn(BTN_CLOSE_PROFIT_BUY,  "平盈利多单",
             ix,  by, bw, bh, C'30,110,70', clrWhite, C);
   EnsureBtn(BTN_CLOSE_PROFIT_SELL, "平盈利空单",
             ix2, by, bw, bh, C'30,110,70', clrWhite, C);
   by += bh + m.gap;
   EnsureBtn(BTN_CLOSE_LOSS_BUY,    "平亏损多单",
             ix,  by, bw, bh, C'150,80,40', clrWhite, C);
   EnsureBtn(BTN_CLOSE_LOSS_SELL,   "平亏损空单",
             ix2, by, bw, bh, C'150,80,40', clrWhite, C);
   by += bh + m.gap;
   EnsureBtn(BTN_RESET, "重置信号K线",
             ix, by, bw, bh, C'50,60,90', clrWhite, C);
   // 第6行右侧：User Prompt 编辑框 (用户提示词可改)
   EnsureLabel(g_panel_prefix + "c5upl", "User Prompt (编辑后自动保存):",
               ix2, by - Spx(10), m.font_xs, C'200,200,220', C);
   CreateEditBox(EDIT_USR, ix2, by, bw, bh, g_aiUsrPrompt_rt);
}
void RefreshPanel(bool force)
{
   datetime now = TimeCurrent();
   if(!force && (now - g_last_panel_refresh) < 2) return;
   g_last_panel_refresh = now;
   if(!g_panel_open) { DrawToggleAnchor(); return; }
   DeletePanelContentObjects();
   DrawPanel();
}
//+------------------------------------------------------------------+
//| 文件结束                                                           |
//+------------------------------------------------------------------+
