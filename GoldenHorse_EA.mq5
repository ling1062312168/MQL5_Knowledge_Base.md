//+------------------------------------------------------------------+
//|                                       GoldenHorse_EA.mq5         |
//|                        金戈铁马X3D 多核对冲 战神旗舰版 2.00       |
//|  多核信号 | 自适应布林 | 马丁加仓 | 对冲交易 | 移动止盈 | 风控   |
//+------------------------------------------------------------------+
#property copyright "GoldenHorse EA"
#property link      ""
#property version   "2.00"
#property strict

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| 枚举定义                                                           |
//+------------------------------------------------------------------+
enum ENUM_TRADE_MODE
{
   MODE_CONSERVATIVE,
   MODE_STEADY,
   MODE_AGGRESSIVE,
   MODE_CUSTOM
};

enum ENUM_ADD_TYPE
{
   ADD_MARTIN,
   ADD_INCREASE,
   ADD_CUSTOM,
   ADD_FIBONACCI
};

enum ENUM_DECIMAL_PLACE
{
   DEC_2 = 2,
   DEC_3 = 3
};

enum ENUM_CLOSE_TYPE
{
   CLOSE_PROFIT,
   CLOSE_SIGNAL,
   CLOSE_HEDGE,
   CLOSE_TRAILING,
   CLOSE_ALL
};

enum ENUM_HEDGE_STATUS
{
   HEDGE_NONE,
   HEDGE_BUY_WAIT,
   HEDGE_SELL_WAIT,
   HEDGE_ACTIVE
};

enum ENUM_ADD_DIRECTION
{
   ADD_BOTH,
   ADD_TREND,
   ADD_REVERSE
};

enum ENUM_TRAILING_TYPE
{
   TRAIL_FIXED,
   TRAIL_ATR,
   TRAIL_STEP
};

enum ENUM_PROFIT_CLOSE_MODE
{
   PC_SINGLE_TARGET,
   PC_MULTI_TARGET,
   PC_DRAWDOWN
};

//+------------------------------------------------------------------+
//| Section1: 基础设置                                                 |
//+------------------------------------------------------------------+
input group    "=== 基础设置 ==="
input ENUM_TRADE_MODE     InpTradeMode      = MODE_STEADY;
input double              InpInitialLot     = 0.01;
input ENUM_DECIMAL_PLACE  InpDecimalPlace   = DEC_2;
input int                 InpMagicNumber    = 888888;
input int                 InpSlippage       = 30;
input bool                InpAllowBothDir   = true;

//+------------------------------------------------------------------+
//| Section2: 自定义开仓设置                                           |
//+------------------------------------------------------------------+
input group    "=== 自定义开仓设置 ==="
input int                 InpOpenPeriod     = 14;
input double              InpSignalStrength = 0.618;
input int                 InpConfirmBars    = 2;
input ENUM_TIMEFRAMES     InpOpenTimeFrame  = PERIOD_M5;
input int                 InpOpenIndicator  = 60;
input double              InpOpenCoeff      = 2.0;
input bool                InpUseAdaptive    = true;
input int                 InpBBM1Period     = 20;
input double              InpBBM1Dev        = 1.5;
input int                 InpBBM5Period     = 20;
input double              InpBBM5Dev        = 2.0;
input double              InpBBProximity    = 0.25;
input int                 InpOpenPeriod2    = 3;

//+------------------------------------------------------------------+
//| Section3: 自定义加仓设置                                           |
//+------------------------------------------------------------------+
input group    "=== 自定义加仓设置 ==="
input int                 InpAddDelay       = 0;
input double              InpAddCoeff        = 1.0;
input ENUM_ADD_TYPE       InpAddType         = ADD_MARTIN;
input ENUM_ADD_DIRECTION  InpAddDirection    = ADD_REVERSE;
input int                 InpAddSpacing     = 500;
input double              InpAddSpacingMult = 1.2;
input bool                InpUseSpacingATR  = false;
input double              InpATRMult        = 1.5;
input int                 InpATRPeriod      = 14;
input double              InpMartinMult     = 1.5;
input double              InpIncreaseLot    = 0.01;
input string              InpCustomLots     = "0.01,0.02,0.03,0.05,0.08,0.13,0.21,0.34,0.55,0.89";
input double              InpMaxAddLot      = 2.0;
input double              InpMaxTotalLot    = 5.0;
input int                 InpMaxAddCount    = 10;
input bool                InpUseAddFilter   = true;
input int                 InpAddFilterBars  = 1;
input bool                InpUseAddSLReset  = true;
input bool                InpUseAddTPReset  = false;

//+------------------------------------------------------------------+
//| Section4: 自定义单K线加仓限制                                      |
//+------------------------------------------------------------------+
input group    "=== 自定义单K线加仓限制 ==="
input int                 InpKDepth         = 5;
input bool                InpUseKLimit      = true;
input ENUM_TIMEFRAMES     InpKLimitTF       = PERIOD_CURRENT;

//+------------------------------------------------------------------+
//| Section5: 自定义平仓设置                                           |
//+------------------------------------------------------------------+
input group    "=== 自定义平仓设置 ==="
input ENUM_PROFIT_CLOSE_MODE InpProfitCloseMode = PC_SINGLE_TARGET;
input double              InpProfitOptCoeff  = 1.0;
input int                 InpCloseFilter     = 1;
input double              InpProfitPer001Lot = 1.0;
input string              InpMultiTargets    = "0.5,1.0,2.0";
input string              InpMultiRatios     = "0.3,0.3,0.4";
input double              InpDrawdownTrigger = 2.0;
input double              InpDrawdownPercent = 30.0;
input bool                InpUseFloatProtect = false;
input double              InpFloatProtectVal = 10000.0;
input bool                InpUseSignalClose  = true;
input int                 InpSignalCloseBar  = 2;
input bool                InpUsePartialClose = false;
input double              InpPartialRatio   = 0.5;
input bool                InpUseTimeClose   = false;
input int                 InpMaxHoldBars    = 100;
input int                 InpCloseHour      = 23;
input int                 InpCloseMinute    = 55;

//+------------------------------------------------------------------+
//| Section5b: 均价移动止盈设置                                        |
//+------------------------------------------------------------------+
input group    "=== 均价移动止盈设置 ==="
input bool                InpUseTrailing     = true;
input ENUM_TRAILING_TYPE  InpTrailingType    = TRAIL_FIXED;
input int                 InpTrailActive     = 500;
input int                 InpTrailLock       = 300;
input int                 InpTrailStep       = 50;
input double              InpTrailATRMult      = 2.0;
input bool                InpUseBreakeven    = true;
input int                 InpBreakevenDist   = 200;
input bool                InpUseStepProfit  = false;
input string              InpStepLevels       = "200,400,600,800,1000";
input string              InpStepLocks       = "100,200,300,400,500";

//+------------------------------------------------------------------+
//| Section6: 自定义时间过滤设置                                       |
//+------------------------------------------------------------------+
input group    "=== 自定义时间过滤设置 ==="
input int                 InpTimeOffset     = 0;
input bool                InpUseTradeTime   = false;
input string              InpTradeStartTime = "00:00";
input string              InpTradeEndTime   = "23:59";
input bool                InpUseBlockTime   = false;
input string              InpBlockStartTime = "00:00";
input string              InpBlockEndTime   = "00:00";
input bool                InpUseNewsFilter  = false;

//+------------------------------------------------------------------+
//| SectionPairHedge: 尾单对冲首单移动止盈                             |
//+------------------------------------------------------------------+
input group    "=== 尾单对冲首单移动止盈 ==="
input bool                InpUsePairHedge   = true;
input double              InpHedgeStartPL   = 1.5;
input double              InpHedgePullback  = 0.5;
input bool                InpHedgeBlockAdd  = false;
input int                 InpHedgeMinPos    = 2;
input bool                InpUseNetClose    = true;
input double              InpNetClosePL     = 5.0;

//+------------------------------------------------------------------+
//| Section8: 托管模式设置                                             |
//+------------------------------------------------------------------+
input group    "=== 托管模式设置 ==="
input bool                InpShowPanel      = true;
input int                 InpPanelX         = 10;
input int                 InpPanelY         = 30;
input int                 InpPanelWidth     = 420;
input int                 InpPanelHeight    = 580;

//+------------------------------------------------------------------+
//| 全局变量与实例                                                     |
//+------------------------------------------------------------------+
CTrade      g_trade;
long        g_chart_id = 0;
string      g_pfx = "GH_";
bool        g_initialized = false;
datetime    g_last_add_time = 0;
datetime    g_last_bar_time = 0;
ENUM_HEDGE_STATUS g_hedge_status = HEDGE_NONE;
double      g_hedge_peak_pl = 0;
int         g_buy_add_count = 0;
int         g_sell_add_count = 0;
double      g_last_add_spacing = 0;

double      g_today_profit = 0;
double      g_yesterday_profit = 0;
double      g_total_profit = 0;
int         g_total_trades = 0;
int         g_win_trades = 0;

double      g_buy_peak_pl = 0;
double      g_sell_peak_pl = 0;
int         g_buy_step_level = 0;
int         g_sell_step_level = 0;

double      g_drag_start_x = 0;
double      g_drag_start_y = 0;
bool        g_dragging = false;

//+------------------------------------------------------------------+
//| 工具函数                                                           |
//+------------------------------------------------------------------+
bool StrStarts(string s, string p) { return StringFind(s, p) == 0; }

string TimeToStr(datetime t)
{
   MqlDateTime dt;
   TimeToStruct(t, dt);
   return StringFormat("%02d:%02d", dt.hour, dt.min);
}

bool IsTradeTimeAllowed()
{
   if(!InpUseTradeTime && !InpUseBlockTime) return true;
   
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int cur_min = dt.hour * 60 + dt.min;
   
   int offset = InpTimeOffset * 60;
   cur_min = (cur_min + offset + 1440) % 1440;
   
   if(InpUseTradeTime)
   {
      int start_h = (int)StringToInteger(StringSubstr(InpTradeStartTime, 0, 2));
      int start_m = (int)StringToInteger(StringSubstr(InpTradeStartTime, 3, 2));
      int end_h = (int)StringToInteger(StringSubstr(InpTradeEndTime, 0, 2));
      int end_m = (int)StringToInteger(StringSubstr(InpTradeEndTime, 3, 2));
      int start_min = start_h * 60 + start_m;
      int end_min = end_h * 60 + end_m;
      
      if(start_min < end_min)
      { if(cur_min < start_min || cur_min > end_min) return false; }
      else
      { if(cur_min < start_min && cur_min > end_min) return false; }
   }
   
   if(InpUseBlockTime)
   {
      int start_h = (int)StringToInteger(StringSubstr(InpBlockStartTime, 0, 2));
      int start_m = (int)StringToInteger(StringSubstr(InpBlockStartTime, 3, 2));
      int end_h = (int)StringToInteger(StringSubstr(InpBlockEndTime, 0, 2));
      int end_m = (int)StringToInteger(StringSubstr(InpBlockEndTime, 3, 2));
      int start_min = start_h * 60 + start_m;
      int end_min = end_h * 60 + end_m;
      
      if(start_min < end_min)
      { if(cur_min >= start_min && cur_min <= end_min) return false; }
      else
      { if(cur_min >= start_min || cur_min <= end_min) return false; }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| 持仓信息结构体                                                     |
//+------------------------------------------------------------------+
struct SPositionInfo
{
   ulong   ticket;
   int     type;
   double  volume;
   double  open_price;
   double  profit;
   double  sl;
   double  tp;
   datetime open_time;
};

//+------------------------------------------------------------------+
//| 信号系统类                                                         |
//+------------------------------------------------------------------+
class CSignalSystem
{
private:
   int    m_bb_handle_m1;
   int    m_bb_handle_m5;
   int    m_ma_handle;
   int    m_rsi_handle;
   int    m_macd_handle;
   double m_bb_upper[], m_bb_middle[], m_bb_lower[];
   double m_ma_val[], m_rsi_val[];
   double m_macd_main[], m_macd_signal[];
   
public:
   CSignalSystem() : m_bb_handle_m1(INVALID_HANDLE), m_bb_handle_m5(INVALID_HANDLE),
                     m_ma_handle(INVALID_HANDLE), m_rsi_handle(INVALID_HANDLE),
                     m_macd_handle(INVALID_HANDLE) {}
   
   bool Init(string symbol)
   {
      if(InpUseAdaptive)
      {
         m_bb_handle_m1 = iBands(symbol, PERIOD_M1, InpBBM1Period, 0, InpBBM1Dev, PRICE_CLOSE);
         m_bb_handle_m5 = iBands(symbol, PERIOD_M5, InpBBM5Period, 0, InpBBM5Dev, PRICE_CLOSE);
      }
      m_ma_handle = iMA(symbol, InpOpenTimeFrame, InpOpenPeriod, 0, MODE_SMA, PRICE_CLOSE);
      m_rsi_handle = iRSI(symbol, InpOpenTimeFrame, InpOpenIndicator, PRICE_CLOSE);
      m_macd_handle = iMACD(symbol, InpOpenTimeFrame, 12, 26, 9, PRICE_CLOSE);
      
      return (m_ma_handle != INVALID_HANDLE && m_rsi_handle != INVALID_HANDLE);
   }
   
   void Deinit()
   {
      if(m_bb_handle_m1 != INVALID_HANDLE) IndicatorRelease(m_bb_handle_m1);
      if(m_bb_handle_m5 != INVALID_HANDLE) IndicatorRelease(m_bb_handle_m5);
      if(m_ma_handle != INVALID_HANDLE) IndicatorRelease(m_ma_handle);
      if(m_rsi_handle != INVALID_HANDLE) IndicatorRelease(m_rsi_handle);
      if(m_macd_handle != INVALID_HANDLE) IndicatorRelease(m_macd_handle);
   }
   
   int GetAdaptiveSignal(string symbol)
   {
      if(!InpUseAdaptive) return 0;
      
      double close_m1 = iClose(symbol, PERIOD_M1, 0);
      double close_m5 = iClose(symbol, PERIOD_M5, 0);
      
      if(CopyBuffer(m_bb_handle_m1, 0, 0, 1, m_bb_middle) > 0 &&
         CopyBuffer(m_bb_handle_m1, 1, 0, 1, m_bb_upper) > 0 &&
         CopyBuffer(m_bb_handle_m1, 2, 0, 1, m_bb_lower) > 0)
      {
         double band_m1 = m_bb_upper[0] - m_bb_lower[0];
         double dist_upper = MathAbs(close_m1 - m_bb_upper[0]);
         double dist_lower = MathAbs(close_m1 - m_bb_lower[0]);
         
         if(dist_upper < band_m1 * InpBBProximity) return -1;
         if(dist_lower < band_m1 * InpBBProximity) return 1;
      }
      
      if(CopyBuffer(m_bb_handle_m5, 0, 0, 1, m_bb_middle) > 0 &&
         CopyBuffer(m_bb_handle_m5, 1, 0, 1, m_bb_upper) > 0 &&
         CopyBuffer(m_bb_handle_m5, 2, 0, 1, m_bb_lower) > 0)
      {
         double band_m5 = m_bb_upper[0] - m_bb_lower[0];
         double dist_upper = MathAbs(close_m5 - m_bb_upper[0]);
         double dist_lower = MathAbs(close_m5 - m_bb_lower[0]);
         
         if(dist_upper < band_m5 * InpBBProximity) return -1;
         if(dist_lower < band_m5 * InpBBProximity) return 1;
      }
      
      return 0;
   }
   
   int GetMainSignal(string symbol)
   {
      if(CopyBuffer(m_ma_handle, 0, 0, 5, m_ma_val) < 3) return 0;
      if(CopyBuffer(m_rsi_handle, 0, 0, 5, m_rsi_val) < 3) return 0;
      if(CopyBuffer(m_macd_handle, 0, 0, 3, m_macd_main) < 2) return 0;
      if(CopyBuffer(m_macd_handle, 1, 0, 3, m_macd_signal) < 2) return 0;
      
      bool trend_up = (m_ma_val[0] > m_ma_val[1] && m_ma_val[1] > m_ma_val[2]);
      bool trend_down = (m_ma_val[0] < m_ma_val[1] && m_ma_val[1] < m_ma_val[2]);
      
      bool rsi_buy = (m_rsi_val[0] < 40 && m_rsi_val[0] > m_rsi_val[1]);
      bool rsi_sell = (m_rsi_val[0] > 60 && m_rsi_val[0] < m_rsi_val[1]);
      
      bool macd_buy = (m_macd_main[0] > m_macd_signal[0] && m_macd_main[1] <= m_macd_signal[1]);
      bool macd_sell = (m_macd_main[0] < m_macd_signal[0] && m_macd_main[1] >= m_macd_signal[1]);
      
      int buy_count = 0, sell_count = 0;
      for(int i = 0; i < InpConfirmBars && i < 10; i++)
      {
         double o = iOpen(symbol, PERIOD_CURRENT, i);
         double c = iClose(symbol, PERIOD_CURRENT, i);
         if(c > o) buy_count++;
         else if(c < o) sell_count++;
      }
      
      double strength = InpSignalStrength;
      
      int buy_score = 0, sell_score = 0;
      if(trend_up) buy_score++;
      if(trend_down) sell_score++;
      if(rsi_buy) buy_score++;
      if(rsi_sell) sell_score++;
      if(macd_buy) buy_score++;
      if(macd_sell) sell_score++;
      if(buy_count >= InpConfirmBars * strength) buy_score++;
      if(sell_count >= InpConfirmBars * strength) sell_score++;
      
      if(buy_score >= 3) return 1;
      if(sell_score >= 3) return -1;
      
      return 0;
   }
   
   bool GetCloseSignal(string symbol, int pos_type)
   {
      if(!InpUseSignalClose) return false;
      
      if(CopyBuffer(m_rsi_handle, 0, 0, 3, m_rsi_val) < 2) return false;
      
      int overbought = 70, oversold = 30;
      
      if(pos_type == POSITION_TYPE_BUY)
      {
         if(m_rsi_val[0] > overbought) return true;
      }
      else
      {
         if(m_rsi_val[0] < oversold) return true;
      }
      
      return false;
   }
   
   int GetSignal(string symbol)
   {
      int main_sig = GetMainSignal(symbol);
      if(main_sig != 0) return main_sig;
      
      int adaptive_sig = GetAdaptiveSignal(symbol);
      return adaptive_sig;
   }
};

//+------------------------------------------------------------------+
//| 交易引擎类                                                         |
//+------------------------------------------------------------------+
class CTradeEngine
{
private:
   string   m_symbol;
   double   m_point;
   int      m_digits;
   double   m_lot_step;
   double   m_min_lot;
   double   m_max_lot;
   
   double   m_custom_lots[];
   int      m_custom_lot_idx;
   
   double   m_fib_ratios[10];
   
public:
   CTradeEngine() : m_custom_lot_idx(0)
   {
      m_fib_ratios[0] = 1.0;
      m_fib_ratios[1] = 1.0;
      m_fib_ratios[2] = 2.0;
      m_fib_ratios[3] = 3.0;
      m_fib_ratios[4] = 5.0;
      m_fib_ratios[5] = 8.0;
      m_fib_ratios[6] = 13.0;
      m_fib_ratios[7] = 21.0;
      m_fib_ratios[8] = 34.0;
      m_fib_ratios[9] = 55.0;
   }
   
   bool Init(string symbol)
   {
      m_symbol = symbol;
      m_point = SymbolInfoDouble(symbol, SYMBOL_POINT);
      m_digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
      m_lot_step = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
      m_min_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
      m_max_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
      
      ParseCustomLots();
      
      return true;
   }
   
   void ParseCustomLots()
   {
      ArrayResize(m_custom_lots, 0);
      string parts[];
      int count = StringSplit(InpCustomLots, ',', parts);
      for(int i = 0; i < count; i++)
      {
         double lot = StringToDouble(parts[i]);
         if(lot > 0)
         {
            int size = ArraySize(m_custom_lots);
            ArrayResize(m_custom_lots, size + 1);
            m_custom_lots[size] = lot;
         }
      }
   }
   
   double NormalizeLot(double lot)
   {
      if(lot < m_min_lot) lot = m_min_lot;
      if(lot > m_max_lot) lot = m_max_lot;
      
      if(InpMaxAddLot > 0 && lot > InpMaxAddLot)
         lot = InpMaxAddLot;
      
      double multiplier = MathPow(10, (int)InpDecimalPlace);
      lot = MathFloor(lot * multiplier) / multiplier;
      
      double steps = MathRound(lot / m_lot_step);
      lot = steps * m_lot_step;
      
      return lot;
   }
   
   double GetNextLot(double initial_lot, int add_count)
   {
      double next_lot = initial_lot;
      
      switch(InpAddType)
      {
         case ADD_MARTIN:
            next_lot = initial_lot * MathPow(InpMartinMult, add_count) * InpAddCoeff;
            break;
            
         case ADD_INCREASE:
            next_lot = initial_lot + InpIncreaseLot * add_count * InpAddCoeff;
            break;
            
         case ADD_CUSTOM:
            if(add_count < ArraySize(m_custom_lots))
               next_lot = m_custom_lots[add_count] * InpAddCoeff;
            else if(ArraySize(m_custom_lots) > 0)
               next_lot = m_custom_lots[ArraySize(m_custom_lots)-1] * InpAddCoeff;
            break;
            
         case ADD_FIBONACCI:
            if(add_count < 10)
               next_lot = initial_lot * m_fib_ratios[add_count] * InpAddCoeff;
            else
               next_lot = initial_lot * 55.0 * InpAddCoeff;
            break;
      }
      
      return NormalizeLot(next_lot);
   }
   
   double GetAddSpacing(int add_count)
   {
      double spacing = InpAddSpacing * m_point;
      
      if(InpUseSpacingATR)
      {
         int atr_handle = iATR(m_symbol, PERIOD_CURRENT, InpATRPeriod, MODE_SMA, PRICE_CLOSE);
         if(atr_handle != INVALID_HANDLE)
         {
            double atr_val[];
            if(CopyBuffer(atr_handle, 0, 0, 1, atr_val) > 0)
            {
               if(atr_val[0] > 0)
                  spacing = atr_val[0] * InpATRMult;
            }
            IndicatorRelease(atr_handle);
         }
      }
      
      if(add_count > 0)
         spacing *= MathPow(InpAddSpacingMult, add_count);
      
      return spacing;
   }
   
   double GetTotalLotAll(string symbol)
   {
      return GetTotalLot(symbol, POSITION_TYPE_BUY) + GetTotalLot(symbol, POSITION_TYPE_SELL);
   }
   
   bool CheckTotalLotLimit(string symbol, double add_lot)
   {
      if(InpMaxTotalLot <= 0) return true;
      double current_total = GetTotalLotAll(symbol);
      return (current_total + add_lot <= InpMaxTotalLot);
   }
   
   void ResetAllSL(string symbol, int type)
   {
      if(!InpUseAddSLReset) return;
      
      double avg_price = GetAvgPrice(symbol, type);
      if(avg_price <= 0) return;
      
      double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
      double sl_dist = InpOpenPeriod * 10 * point;
      double new_sl = (type == POSITION_TYPE_BUY) ? avg_price - sl_dist : avg_price + sl_dist;
      
      ModifySL(symbol, type, new_sl);
   }
   
   void ResetLotIndex() { m_custom_lot_idx = 0; }
   
   bool OpenPosition(int type, double lot, int sl_points, int tp_points, string comment)
   {
      if(!IsTradeTimeAllowed()) return false;
      
      double price = (type == ORDER_TYPE_BUY) ? SymbolInfoDouble(m_symbol, SYMBOL_ASK)
                                              : SymbolInfoDouble(m_symbol, SYMBOL_BID);
      
      double sl = 0, tp = 0;
      if(sl_points > 0)
         sl = (type == ORDER_TYPE_BUY) ? price - sl_points * m_point : price + sl_points * m_point;
      if(tp_points > 0)
         tp = (type == ORDER_TYPE_BUY) ? price + tp_points * m_point : price - tp_points * m_point;
      
      lot = NormalizeLot(lot);
      
      bool result = false;
      if(type == ORDER_TYPE_BUY)
         result = g_trade.Buy(lot, m_symbol, price, sl, tp, comment);
      else
         result = g_trade.Sell(lot, m_symbol, price, sl, tp, comment);
      
      if(result)
      {
         g_last_add_time = TimeCurrent();
         g_total_trades++;
      }
      
      return result;
   }
   
   bool CanAddPosition(datetime last_time)
   {
      if(InpAddDelay <= 0) return true;
      return (TimeCurrent() - last_time >= InpAddDelay);
   }
   
   bool CheckKLineLimit(string symbol)
   {
      if(!InpUseKLimit) return true;
      
      ENUM_TIMEFRAMES tf = (InpKLimitTF == PERIOD_CURRENT) ? Period() : InpKLimitTF;
      
      int add_count = 0;
      datetime bar_time = iTime(symbol, tf, 0);
      
      for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         
         datetime open_time = (datetime)PositionGetInteger(POSITION_TIME);
         if(open_time >= bar_time)
            add_count++;
      }
      
      return (add_count < InpKDepth);
   }
   
   int GetPositions(string symbol, int type, SPositionInfo &info[])
   {
      ArrayResize(info, 0);
      int count = 0;
      
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         if(type >= 0 && (int)PositionGetInteger(POSITION_TYPE) != type) continue;
         
         SPositionInfo pi;
         pi.ticket = ticket;
         pi.type = (int)PositionGetInteger(POSITION_TYPE);
         pi.volume = PositionGetDouble(POSITION_VOLUME);
         pi.open_price = PositionGetDouble(POSITION_PRICE_OPEN);
         pi.profit = PositionGetDouble(POSITION_PROFIT);
         pi.sl = PositionGetDouble(POSITION_SL);
         pi.tp = PositionGetDouble(POSITION_TP);
         pi.open_time = (datetime)PositionGetInteger(POSITION_TIME);
         
         int size = ArraySize(info);
         ArrayResize(info, size + 1);
         info[size] = pi;
         count++;
      }
      
      return count;
   }
   
   double GetAvgPrice(string symbol, int type)
   {
      double total_price = 0, total_lot = 0;
      
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         if((int)PositionGetInteger(POSITION_TYPE) != type) continue;
         
         double lot = PositionGetDouble(POSITION_VOLUME);
         double price = PositionGetDouble(POSITION_PRICE_OPEN);
         
         total_price += price * lot;
         total_lot += lot;
      }
      
      if(total_lot <= 0) return 0;
      return total_price / total_lot;
   }
   
   double GetTotalLot(string symbol, int type)
   {
      double total = 0;
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         if(type >= 0 && (int)PositionGetInteger(POSITION_TYPE) != type) continue;
         total += PositionGetDouble(POSITION_VOLUME);
      }
      return total;
   }
   
   int GetPositionCount(string symbol, int type)
   {
      int count = 0;
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         if(type >= 0 && (int)PositionGetInteger(POSITION_TYPE) != type) continue;
         count++;
      }
      return count;
   }
   
   double GetTotalProfit(string symbol, int type = -1)
   {
      double total = 0;
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         if(type >= 0 && (int)PositionGetInteger(POSITION_TYPE) != type) continue;
         total += PositionGetDouble(POSITION_PROFIT);
      }
      return total;
   }
   
   void CloseAllPositions(string symbol, int type = -1)
   {
      for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         if(type >= 0 && (int)PositionGetInteger(POSITION_TYPE) != type) continue;
         
         g_trade.PositionClose(ticket);
      }
   }
   
   void ClosePartial(string symbol, int type, double ratio)
   {
      SPositionInfo info[];
      int count = GetPositions(symbol, type, info);
      
      if(count <= 0 || ratio <= 0) return;
      
      double total_lot = GetTotalLot(symbol, type);
      double close_lot = total_lot * ratio;
      double closed = 0;
      
      for(int i = count - 1; i >= 0 && closed < close_lot; i--)
      {
         double vol = info[i].volume;
         if(closed + vol <= close_lot)
         {
            g_trade.PositionClose(info[i].ticket);
            closed += vol;
         }
      }
   }
   
   void ClosePosition(ulong ticket)
   {
      g_trade.PositionClose(ticket);
   }
   
   bool ModifySL(string symbol, int type, double new_sl)
   {
      bool modified = false;
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         if((int)PositionGetInteger(POSITION_TYPE) != type) continue;
         
         double cur_sl = PositionGetDouble(POSITION_SL);
         if(MathAbs(new_sl - cur_sl) > m_point)
         {
            double tp = PositionGetDouble(POSITION_TP);
            if(g_trade.PositionModify(ticket, new_sl, tp))
               modified = true;
         }
      }
      return modified;
   }
};

//+------------------------------------------------------------------+
//| 风控系统类                                                         |
//+------------------------------------------------------------------+
class CRiskControl
{
private:
   double   m_peak_equity;
   double   m_buy_trail_peak;
   double   m_sell_trail_peak;
   bool     m_buy_trail_active;
   bool     m_sell_trail_active;
   double   m_buy_breakeven_price;
   double   m_sell_breakeven_price;
   
   double   m_step_levels[];
   double   m_step_locks[];
   int      m_buy_step_idx;
   int      m_sell_step_idx;
   
public:
   CRiskControl() : m_peak_equity(0), m_buy_trail_peak(0), m_sell_trail_peak(0),
                    m_buy_trail_active(false), m_sell_trail_active(false),
                    m_buy_breakeven_price(0), m_sell_breakeven_price(0),
                    m_buy_step_idx(0), m_sell_step_idx(0)
   {
      ParseStepLevels();
   }
   
   void ParseStepLevels()
   {
      ArrayResize(m_step_levels, 0);
      ArrayResize(m_step_locks, 0);
      
      string levels[];
      int lc = StringSplit(InpStepLevels, ',', levels);
      for(int i = 0; i < lc; i++)
      {
         double v = StringToDouble(levels[i]);
         if(v > 0)
         {
            int s = ArraySize(m_step_levels);
            ArrayResize(m_step_levels, s + 1);
            m_step_levels[s] = v;
         }
      }
      
      string locks[];
      int lk = StringSplit(InpStepLocks, ',', locks);
      for(int i = 0; i < lk; i++)
      {
         double v = StringToDouble(locks[i]);
         if(v > 0)
         {
            int s = ArraySize(m_step_locks);
            ArrayResize(m_step_locks, s + 1);
            m_step_locks[s] = v;
         }
      }
   }
   
   void UpdatePeakEquity()
   {
      double eq = AccountInfoDouble(ACCOUNT_EQUITY);
      if(eq > m_peak_equity) m_peak_equity = eq;
   }
   
   double GetDrawdown()
   {
      if(m_peak_equity <= 0) return 0;
      double eq = AccountInfoDouble(ACCOUNT_EQUITY);
      return (m_peak_equity - eq) / m_peak_equity * 100;
   }
   
   double GetDrawdownAmount()
   {
      if(m_peak_equity <= 0) return 0;
      return m_peak_equity - AccountInfoDouble(ACCOUNT_EQUITY);
   }
   
   bool CheckFloatProtect()
   {
      if(!InpUseFloatProtect) return false;
      
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      if(profit <= -InpFloatProtectVal)
         return true;
      return false;
   }
   
   void CheckTrailingStop(string symbol, CTradeEngine &engine, double &buy_sl, double &sell_sl)
   {
      buy_sl = 0;
      sell_sl = 0;
      
      if(!InpUseTrailing) return;
      
      double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
      double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
      
      double buy_avg = engine.GetAvgPrice(symbol, POSITION_TYPE_BUY);
      double sell_avg = engine.GetAvgPrice(symbol, POSITION_TYPE_SELL);
      double buy_lot = engine.GetTotalLot(symbol, POSITION_TYPE_BUY);
      double sell_lot = engine.GetTotalLot(symbol, POSITION_TYPE_SELL);
      
      double atr_val = 0;
      if(InpTrailingType == TRAIL_ATR)
      {
         int atr_handle = iATR(symbol, PERIOD_CURRENT, InpATRPeriod, MODE_SMA, PRICE_CLOSE);
         if(atr_handle != INVALID_HANDLE)
         {
            double atr_buf[];
            if(CopyBuffer(atr_handle, 0, 0, 1, atr_buf) > 0)
               atr_val = atr_buf[0];
            IndicatorRelease(atr_handle);
         }
      }
      
      if(buy_lot > 0 && buy_avg > 0)
      {
         double profit_points = (bid - buy_avg) / point;
         
         if(InpUseStepProfit && ArraySize(m_step_levels) > 0)
         {
            for(int i = m_buy_step_idx; i < ArraySize(m_step_levels); i++)
            {
               if(profit_points >= m_step_levels[i])
               {
                  m_buy_step_idx = i + 1;
                  if(i < ArraySize(m_step_locks))
                  {
                     double lock_price = buy_avg + m_step_locks[i] * point;
                     if(buy_sl < lock_price) buy_sl = lock_price;
                  }
               }
               else break;
            }
         }
         
         if(profit_points >= InpTrailActive)
         {
            if(!m_buy_trail_active)
            {
               m_buy_trail_active = true;
               m_buy_trail_peak = bid;
            }
            else if(bid > m_buy_trail_peak)
            {
               m_buy_trail_peak = bid;
            }
            
            double lock_dist = InpTrailLock * point;
            
            if(InpTrailingType == TRAIL_ATR && atr_val > 0)
               lock_dist = atr_val * InpTrailATRMult;
            else if(InpTrailingType == TRAIL_STEP)
               lock_dist = MathFloor(profit_points / InpTrailStep) * InpTrailStep * point;
            
            double lock_price = m_buy_trail_peak - lock_dist;
            if(lock_price > buy_avg && lock_price > buy_sl)
               buy_sl = lock_price;
         }
         else if(InpUseBreakeven && profit_points >= InpBreakevenDist)
         {
            double be_price = buy_avg + point * 5;
            if(be_price > buy_sl) buy_sl = be_price;
         }
      }
      else
      {
         m_buy_trail_active = false;
         m_buy_trail_peak = 0;
         m_buy_step_idx = 0;
      }
      
      if(sell_lot > 0 && sell_avg > 0)
      {
         double profit_points = (sell_avg - ask) / point;
         
         if(InpUseStepProfit && ArraySize(m_step_locks) > 0)
         {
            for(int i = m_sell_step_idx; i < ArraySize(m_step_levels); i++)
            {
               if(profit_points >= m_step_levels[i])
               {
                  m_sell_step_idx = i + 1;
                  if(i < ArraySize(m_step_locks))
                  {
                     double lock_price = sell_avg - m_step_locks[i] * point;
                     if(sell_sl == 0 || lock_price < sell_sl) sell_sl = lock_price;
                  }
               }
               else break;
            }
         }
         
         if(profit_points >= InpTrailActive)
         {
            if(!m_sell_trail_active)
            {
               m_sell_trail_active = true;
               m_sell_trail_peak = ask;
            }
            else if(ask < m_sell_trail_peak)
            {
               m_sell_trail_peak = ask;
            }
            
            double lock_dist = InpTrailLock * point;
            
            if(InpTrailingType == TRAIL_ATR && atr_val > 0)
               lock_dist = atr_val * InpTrailATRMult;
            else if(InpTrailingType == TRAIL_STEP)
               lock_dist = MathFloor(profit_points / InpTrailStep) * InpTrailStep * point;
            
            double lock_price = m_sell_trail_peak + lock_dist;
            if(lock_price < sell_avg && (sell_sl == 0 || lock_price < sell_sl))
               sell_sl = lock_price;
         }
         else if(InpUseBreakeven && profit_points >= InpBreakevenDist)
         {
            double be_price = sell_avg - point * 5;
            if(sell_sl == 0 || be_price < sell_sl) sell_sl = be_price;
         }
      }
      else
      {
         m_sell_trail_active = false;
         m_sell_trail_peak = 0;
         m_sell_step_idx = 0;
      }
   }
   
   void ResetTrail()
   {
      m_buy_trail_active = false;
      m_sell_trail_active = false;
      m_buy_trail_peak = 0;
      m_sell_trail_peak = 0;
   }
};

//+------------------------------------------------------------------+
//| 尾单对冲类                                                         |
//+------------------------------------------------------------------+
class CPairHedge
{
private:
   double   m_combo_peak_buy;
   double   m_combo_peak_sell;
   bool     m_buy_hedge_active;
   bool     m_sell_hedge_active;
   double   m_net_peak_pl;
   bool     m_net_hedge_active;
   
public:
   CPairHedge() : m_combo_peak_buy(0), m_combo_peak_sell(0),
                  m_buy_hedge_active(false), m_sell_hedge_active(false),
                  m_net_peak_pl(0), m_net_hedge_active(false) {}
   
   void Update(string symbol, CTradeEngine &engine)
   {
      if(!InpUsePairHedge) return;
      
      double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
      double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
      
      SPositionInfo buy_pos[];
      int buy_count = engine.GetPositions(symbol, POSITION_TYPE_BUY, buy_pos);
      
      if(buy_count >= InpHedgeMinPos)
      {
         double first_pl = (bid - buy_pos[0].open_price) / point;
         double last_pl = (bid - buy_pos[buy_count-1].open_price) / point;
         double combo_pl = first_pl + last_pl;
         
         if(combo_pl >= InpHedgeStartPL)
         {
            m_buy_hedge_active = true;
            if(combo_pl > m_combo_peak_buy) m_combo_peak_buy = combo_pl;
            
            if(m_combo_peak_buy - combo_pl >= InpHedgePullback)
            {
               engine.ClosePosition(buy_pos[0].ticket);
               engine.ClosePosition(buy_pos[buy_count-1].ticket);
               m_buy_hedge_active = false;
               m_combo_peak_buy = 0;
            }
         }
      }
      else
      {
         m_buy_hedge_active = false;
         m_combo_peak_buy = 0;
      }
      
      SPositionInfo sell_pos[];
      int sell_count = engine.GetPositions(symbol, POSITION_TYPE_SELL, sell_pos);
      
      if(sell_count >= InpHedgeMinPos)
      {
         double first_pl = (sell_pos[0].open_price - ask) / point;
         double last_pl = (sell_pos[sell_count-1].open_price - ask) / point;
         double combo_pl = first_pl + last_pl;
         
         if(combo_pl >= InpHedgeStartPL)
         {
            m_sell_hedge_active = true;
            if(combo_pl > m_combo_peak_sell) m_combo_peak_sell = combo_pl;
            
            if(m_combo_peak_sell - combo_pl >= InpHedgePullback)
            {
               engine.ClosePosition(sell_pos[0].ticket);
               engine.ClosePosition(sell_pos[sell_count-1].ticket);
               m_sell_hedge_active = false;
               m_combo_peak_sell = 0;
            }
         }
      }
      else
      {
         m_sell_hedge_active = false;
         m_combo_peak_sell = 0;
      }
   }
   
   bool IsHedgeActive() { return m_buy_hedge_active || m_sell_hedge_active; }
   bool IsBuyHedgeActive() { return m_buy_hedge_active; }
   bool IsSellHedgeActive() { return m_sell_hedge_active; }
   
   bool BlockAdd(int type)
   {
      if(!InpHedgeBlockAdd) return false;
      if(type == POSITION_TYPE_BUY && m_buy_hedge_active) return true;
      if(type == POSITION_TYPE_SELL && m_sell_hedge_active) return true;
      return false;
   }
   
   double GetComboPeak(int type)
   {
      return (type == POSITION_TYPE_BUY) ? m_combo_peak_buy : m_combo_peak_sell;
   }
   
   bool CheckNetClose(string symbol, CTradeEngine &engine)
   {
      if(!InpUseNetClose) return false;
      
      double buy_pl = engine.GetTotalProfit(symbol, POSITION_TYPE_BUY);
      double sell_pl = engine.GetTotalProfit(symbol, POSITION_TYPE_SELL);
      double net_pl = buy_pl + sell_pl;
      
      if(net_pl > m_net_peak_pl)
         m_net_peak_pl = net_pl;
      
      if(net_pl >= InpNetClosePL)
      {
         m_net_hedge_active = true;
         
         double drawdown = m_net_peak_pl - net_pl;
         double drawdown_pct = (m_net_peak_pl > 0) ? (drawdown / m_net_peak_pl * 100) : 0;
         
         if(drawdown_pct >= 10.0 || net_pl >= InpNetClosePL * 1.5)
         {
            engine.CloseAllPositions(symbol, POSITION_TYPE_BUY);
            engine.CloseAllPositions(symbol, POSITION_TYPE_SELL);
            m_net_hedge_active = false;
            m_net_peak_pl = 0;
            return true;
         }
      }
      
      int buy_count = engine.GetPositionCount(symbol, POSITION_TYPE_BUY);
      int sell_count = engine.GetPositionCount(symbol, POSITION_TYPE_SELL);
      if(buy_count == 0 && sell_count == 0)
      {
         m_net_hedge_active = false;
         m_net_peak_pl = 0;
      }
      
      return false;
   }
   
   bool CheckAvgHedgeClose(string symbol, CTradeEngine &engine)
   {
      if(!InpUsePairHedge) return false;
      
      double buy_lot = engine.GetTotalLot(symbol, POSITION_TYPE_BUY);
      double sell_lot = engine.GetTotalLot(symbol, POSITION_TYPE_SELL);
      
      if(buy_lot <= 0 || sell_lot <= 0) return false;
      
      double buy_avg = engine.GetAvgPrice(symbol, POSITION_TYPE_BUY);
      double sell_avg = engine.GetAvgPrice(symbol, POSITION_TYPE_SELL);
      double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
      double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
      
      double min_lot = MathMin(buy_lot, sell_lot);
      double hedge_profit = 0;
      
      if(sell_avg > buy_avg)
      {
         hedge_profit = (sell_avg - buy_avg) * min_lot / point;
      }
      
      if(hedge_profit >= InpHedgeStartPL * 2)
      {
         double close_lot = min_lot * 0.5;
         
         SPositionInfo buy_info[], sell_info[];
         int bc = engine.GetPositions(symbol, POSITION_TYPE_BUY, buy_info);
         int sc = engine.GetPositions(symbol, POSITION_TYPE_SELL, sell_info);
         
         double closed_buy = 0, closed_sell = 0;
         
         for(int i = bc - 1; i >= 0 && closed_buy < close_lot; i--)
         {
            double vol = buy_info[i].volume;
            if(closed_buy + vol <= close_lot)
            {
               engine.ClosePosition(buy_info[i].ticket);
               closed_buy += vol;
            }
         }
         
         for(int i = sc - 1; i >= 0 && closed_sell < close_lot; i--)
         {
            double vol = sell_info[i].volume;
            if(closed_sell + vol <= close_lot)
            {
               engine.ClosePosition(sell_info[i].ticket);
               closed_sell += vol;
            }
         }
         
         return true;
      }
      
      return false;
   }
   
   double GetNetPeakPL() { return m_net_peak_pl; }
   bool IsNetHedgeActive() { return m_net_hedge_active; }
};

//+------------------------------------------------------------------+
//| 面板类                                                            |
//+------------------------------------------------------------------+
class CInfoPanel
{
private:
   long     m_ch;
   int      m_sub;
   string   m_pfx;
   int      m_x, m_y;
   int      m_w, m_h;
   
public:
   CInfoPanel() : m_ch(0), m_sub(0), m_x(0), m_y(0), m_w(420), m_h(580) {}
   
   void SetSize(int w, int h) { m_w = w; m_h = h; }
   
   bool Create(long ch, int sub, string pfx, int x, int y)
   {
      m_ch = ch; m_sub = sub; m_pfx = pfx + "_"; m_x = x; m_y = y;
      Destroy();
      BuildPanel();
      return true;
   }
   
   void Destroy()
   {
      for(int i = (int)ObjectsTotal(m_ch, m_sub) - 1; i >= 0; i--)
      {
         string n = ObjectName(m_ch, i, m_sub);
         if(StrStarts(n, m_pfx)) ObjectDelete(m_ch, n);
      }
   }
   
   void BuildPanel()
   {
      Rect("BG", 0, 0, m_w, m_h, C'25,25,30', C'80,60,30');
      
      // 标题区
      Rect("TitleBG", 0, 0, m_w, 68, C'35,30,25', C'100,80,40');
      Label("Title1", "金戈铁马  多核对冲量化引擎", 10, 4, 300, 18, C'200,180,120', 11);
      Label("Title2", "GOLDEN CAVALRY · MULTI-CORE HEDGE · ARES FLAGSHIP v2.1", 10, 24, 400, 10, C'150,130,80', 7);
      Label("Title3", "「 金戈所向·多空俱亡  |  铁马奔腾·对冲千军 」", 10, 38, 400, 10, C'180,160,100', 8);
      Label("Symbol", _Symbol, 10, 52, 80, 10, clrSilver, 8);
      Label("Magic", "Magic " + IntegerToString(InpMagicNumber), 100, 52, 120, 10, clrSilver, 8);
      Label("Period", "周期 M" + IntegerToString(Period() / 60), 200, 52, 80, 10, clrSilver, 8);
      Label("Status", "战况: 允许交易", 300, 52, 110, 10, clrLimeGreen, 8);
      
      int ry = 74;
      Rect("ProfitBG", 4, ry, m_w - 8, 56, C'20,25,20', C'60,70,50');
      Label("TodayLbl", "今日斩获", 12, ry + 4, 60, 12, C'180,160,100', 8);
      Label("TodayVal", "0.00", 12, ry + 20, 110, 22, clrLimeGreen, 14);
      Label("YestLbl", "昨日斩获", 130, ry + 4, 60, 12, C'180,160,100', 8);
      Label("YestVal", "0.00", 130, ry + 20, 110, 22, clrLimeGreen, 14);
      Label("TotalLbl", "累计斩获", 260, ry + 4, 60, 12, C'180,160,100', 8);
      Label("TotalVal", "0.00", 260, ry + 20, 140, 22, clrLimeGreen, 14);
      
      ry += 62;
      Rect("AcctBG", 4, ry, m_w - 8, 80, C'20,20,25', C'50,50,60');
      Label("AcctTitle", "账户概览", 12, ry + 4, 80, 12, C'150,180,200', 9);
      Label("BalLbl", "余额", 12, ry + 22, 40, 10, clrSilver, 8);
      Label("BalVal", "--", 52, ry + 22, 110, 10, clrWhite, 8);
      Label("EqLbl", "净值", 170, ry + 22, 40, 10, clrSilver, 8);
      Label("EqVal", "--", 206, ry + 22, 110, 10, clrWhite, 8);
      Label("MarLbl", "可用保证金", 12, ry + 38, 70, 10, clrSilver, 8);
      Label("MarVal", "--", 82, ry + 38, 80, 10, clrWhite, 8);
      Label("MargPLbl", "保证金比例", 170, ry + 38, 60, 10, clrSilver, 8);
      Label("MargPVal", "--", 232, ry + 38, 100, 10, clrWhite, 8);
      Label("FreeLbl", "已用保证金", 12, ry + 54, 70, 10, clrSilver, 8);
      Label("FreeVal", "--", 82, ry + 54, 80, 10, clrWhite, 8);
      Label("LevLbl", "杠杆", 170, ry + 54, 40, 10, clrSilver, 8);
      Label("LevVal", "--", 206, ry + 54, 80, 10, clrWhite, 8);
      Label("TradeCntLbl", "交易次数", 290, ry + 22, 60, 10, clrSilver, 8);
      Label("TradeCntVal", "0", 350, ry + 22, 60, 10, clrWhite, 8);
      Label("WinRateLbl", "胜率", 290, ry + 38, 40, 10, clrSilver, 8);
      Label("WinRateVal", "--", 350, ry + 38, 60, 10, clrWhite, 8);
      Label("PFLLbl", "盈亏比", 290, ry + 54, 40, 10, clrSilver, 8);
      Label("PFLVal", "--", 350, ry + 54, 60, 10, clrWhite, 8);
      
      ry += 86;
      Rect("PosBG", 4, ry, m_w - 8, 86, C'25,20,20', C'60,50,50');
      Label("PosTitle", "持仓监控", 12, ry + 4, 80, 12, C'200,150,150', 9);
      Label("BuyLbl", "多单", 12, ry + 22, 30, 10, clrSilver, 8);
      Label("BuyVal", "0单/0.00手", 42, ry + 22, 90, 10, clrWhite, 8);
      Label("BuyPL", "0.00", 140, ry + 22, 80, 10, clrLimeGreen, 8);
      Label("BuyAvgLbl", "均价", 230, ry + 22, 30, 10, clrSilver, 8);
      Label("BuyAvgVal", "--", 262, ry + 22, 140, 10, clrWhite, 8);
      
      Label("SellLbl", "空单", 12, ry + 40, 30, 10, clrSilver, 8);
      Label("SellVal", "0单/0.00手", 42, ry + 40, 90, 10, clrWhite, 8);
      Label("SellPL", "0.00", 140, ry + 40, 80, 10, clrRed, 8);
      Label("SellAvgLbl", "均价", 230, ry + 40, 30, 10, clrSilver, 8);
      Label("SellAvgVal", "--", 262, ry + 40, 140, 10, clrWhite, 8);
      
      Label("TotalPLLbl", "总浮盈亏", 12, ry + 58, 50, 10, clrSilver, 8);
      Label("TotalPLVal", "0.00", 62, ry + 58, 90, 10, clrWhite, 9);
      Label("TotalLots", "0.00手", 160, ry + 58, 70, 10, clrWhite, 9);
      Label("NetPLbl", "净盈亏", 240, ry + 58, 40, 10, clrSilver, 8);
      Label("NetPVal", "0.00", 282, ry + 58, 100, 10, clrWhite, 9);
      
      Label("BuyPeakLbl", "多峰值", 12, ry + 74, 50, 10, C'180,140,140', 7);
      Label("BuyPeakVal", "0.00", 62, ry + 74, 80, 10, C'200,160,160', 7);
      Label("SellPeakLbl", "空峰值", 150, ry + 74, 50, 10, C'180,140,140', 7);
      Label("SellPeakVal", "0.00", 200, ry + 74, 80, 10, C'200,160,160', 7);
      Label("NetPeakLbl", "净峰值", 290, ry + 74, 50, 10, C'180,140,140', 7);
      Label("NetPeakVal", "0.00", 340, ry + 74, 70, 10, C'200,160,160', 7);
      
      ry += 92;
      Rect("HedgeBG", 4, ry, m_w - 8, 72, C'20,25,20', C'50,60,50');
      Label("HedgeTitle", "多核对冲 · 移动止盈战法", 12, ry + 4, 200, 12, C'150,200,150', 9);
      Label("HedgeType", GetCloseModeName(), 280, ry + 4, 130, 12, C'150,200,180', 8);
      Label("HedgeBuy", "多单对冲: 待触发", 12, ry + 22, 180, 10, clrSilver, 8);
      Label("HedgeSell", "空单对冲: 待触发", 200, ry + 22, 180, 10, clrSilver, 8);
      Label("HedgeNet", "净盈亏对冲: 待触发", 12, ry + 38, 200, 10, clrSilver, 8);
      Label("TrailType", "止盈: " + GetTrailingTypeName(), 200, ry + 38, 200, 10, C'150,200,150', 8);
      Label("HedgeRule", "兵法: 盈 " + DoubleToString(InpHedgeStartPL, 1) + " / 撤 " + 
             DoubleToString(InpHedgePullback, 1) + " / 净平 " + DoubleToString(InpNetClosePL, 1) +
             " / 止盈 " + IntegerToString(InpTrailActive) + "点",
             12, ry + 54, 400, 10, C'150,170,150', 7);
      
      ry += 78;
      Rect("AddBG", 4, ry, m_w - 8, 64, C'22,22,28', C'55,50,60');
      Label("AddTitle", "加仓监控", 12, ry + 4, 80, 12, C'200,180,140', 9);
      Label("AddTypeLbl", "方式", 12, ry + 22, 30, 10, clrSilver, 8);
      Label("AddTypeVal", GetAddTypeName(), 42, ry + 22, 120, 10, clrWhite, 8);
      Label("AddDirLbl", "方向", 170, ry + 22, 30, 10, clrSilver, 8);
      Label("AddDirVal", GetAddDirName(), 202, ry + 22, 80, 10, clrWhite, 8);
      Label("AddCountLbl", "多/空层数", 290, ry + 22, 60, 10, clrSilver, 8);
      Label("AddCountVal", "0/0", 352, ry + 22, 60, 10, clrWhite, 8);
      Label("MaxLotLbl", "最大手", 12, ry + 40, 40, 10, clrSilver, 8);
      Label("MaxLotVal", DoubleToString(InpMaxAddLot, 2), 52, ry + 40, 60, 10, clrWhite, 8);
      Label("MaxTotLbl", "总手限", 120, ry + 40, 40, 10, clrSilver, 8);
      Label("MaxTotVal", DoubleToString(InpMaxTotalLot, 2), 162, ry + 40, 60, 10, clrWhite, 8);
      Label("MaxAddLbl", "最大层数", 230, ry + 40, 50, 10, clrSilver, 8);
      Label("MaxAddVal", IntegerToString(InpMaxAddCount), 282, ry + 40, 40, 10, clrWhite, 8);
      Label("SpacingLbl", "间距", 330, ry + 40, 30, 10, clrSilver, 8);
      Label("SpacingVal", GetSpacingName(), 362, ry + 40, 50, 10, clrWhite, 8);
      
      ry += 70;
      Rect("RiskBG", 4, ry, m_w - 8, 60, C'30,20,20', C'70,40,40');
      Label("RiskTitle", "风控师令 · 全军安危", 12, ry + 4, 160, 12, C'200,150,150', 9);
      Label("RiskFloat", "全单浮盈亏: 0.00", 12, ry + 22, 140, 10, clrWhite, 8);
      Label("RiskDD", "回撤: 0.00", 160, ry + 22, 100, 10, clrWhite, 8);
      Label("RiskDDPct", "0.00%", 270, ry + 22, 70, 10, clrWhite, 8);
      Label("RiskMode", "模式: " + GetModeName(), 350, ry + 22, 60, 10, C'200,170,170', 7);
      Label("RiskTrail", "移动止盈: " + IntegerToString(InpTrailActive) + "/" + IntegerToString(InpTrailLock) +
             " / 保本: " + IntegerToString(InpBreakevenDist),
             12, ry + 40, 380, 10, C'180,140,140', 7);
      
      Rect("FooterBG", 0, m_h - 24, m_w, 24, C'30,25,20', C'80,70,40');
      Label("Footer", "金戈铁马 · 铁骑托管中 · 多核对冲风控执行 · 请勿混用同Magic", 
            10, m_h - 20, 400, 12, C'180,160,100', 8);
   }
   
   string GetAddTypeName()
   {
      switch(InpAddType)
      {
         case ADD_MARTIN:   return "马丁倍率";
         case ADD_INCREASE: return "递增手数";
         case ADD_CUSTOM:   return "自定义列表";
         case ADD_FIBONACCI:return "斐波那契";
      }
      return "未知";
   }
   
   string GetAddDirName()
   {
      switch(InpAddDirection)
      {
         case ADD_BOTH:    return "双向";
         case ADD_TREND:   return "顺势";
         case ADD_REVERSE: return "逆势";
      }
      return "未知";
   }
   
   string GetTrailingTypeName()
   {
      switch(InpTrailingType)
      {
         case TRAIL_FIXED: return "固定间距";
         case TRAIL_ATR:   return "ATR动态";
         case TRAIL_STEP:  return "阶梯式";
      }
      return "未知";
   }
   
   string GetCloseModeName()
   {
      switch(InpProfitCloseMode)
      {
         case PC_SINGLE_TARGET: return "单目标";
         case PC_MULTI_TARGET:  return "阶梯止盈";
         case PC_DRAWDOWN:      return "回撤止盈";
      }
      return "未知";
   }
   
   string GetSpacingName()
   {
      if(InpUseSpacingATR)
         return "ATR动态";
      return IntegerToString(InpAddSpacing) + "点";
   }
   
   void Update(string symbol, CTradeEngine &engine, CRiskControl &risk, CPairHedge &hedge)
   {
      double bal = AccountInfoDouble(ACCOUNT_BALANCE);
      double eq = AccountInfoDouble(ACCOUNT_EQUITY);
      double margin_free = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
      double margin_used = AccountInfoDouble(ACCOUNT_MARGIN);
      double margin_level = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int leverage = (int)AccountInfoInteger(ACCOUNT_LEVERAGE);
      
      SetText("BalVal", StringFormat("%.2f USD", bal));
      SetText("EqVal", StringFormat("%.2f", eq));
      SetText("MarVal", StringFormat("%.2f", margin_free));
      SetText("MargPVal", StringFormat("%.1f%%", margin_level));
      SetText("FreeVal", StringFormat("%.2f", margin_used));
      SetText("LevVal", "1:" + IntegerToString((int)leverage));
      
      SetText("TradeCntVal", IntegerToString(g_total_trades));
      double win_rate = (g_total_trades > 0) ? (double)g_win_trades / g_total_trades * 100 : 0;
      SetText("WinRateVal", StringFormat("%.1f%%", win_rate));
      SetColor("WinRateVal", win_rate >= 50 ? clrLimeGreen : clrRed);
      double pf = (g_total_trades - g_win_trades > 0 && g_win_trades > 0) ? 
                  (double)g_win_trades / (g_total_trades - g_win_trades) : 0;
      SetText("PFLVal", StringFormat("%.2f", pf));
      
      int buy_count = engine.GetPositionCount(symbol, POSITION_TYPE_BUY);
      int sell_count = engine.GetPositionCount(symbol, POSITION_TYPE_SELL);
      double buy_lot = engine.GetTotalLot(symbol, POSITION_TYPE_BUY);
      double sell_lot = engine.GetTotalLot(symbol, POSITION_TYPE_SELL);
      double buy_pl = engine.GetTotalProfit(symbol, POSITION_TYPE_BUY);
      double sell_pl = engine.GetTotalProfit(symbol, POSITION_TYPE_SELL);
      double buy_avg = engine.GetAvgPrice(symbol, POSITION_TYPE_BUY);
      double sell_avg = engine.GetAvgPrice(symbol, POSITION_TYPE_SELL);
      
      SetText("BuyVal", StringFormat("%d单/%.2f手", buy_count, buy_lot));
      SetColor("BuyPL", buy_pl >= 0 ? clrLimeGreen : clrRed);
      SetText("BuyPL", StringFormat("%+.2f", buy_pl));
      SetText("BuyAvgVal", buy_avg > 0 ? DoubleToString(buy_avg, _Digits) : "--");
      
      SetText("SellVal", StringFormat("%d单/%.2f手", sell_count, sell_lot));
      SetColor("SellPL", sell_pl >= 0 ? clrLimeGreen : clrRed);
      SetText("SellPL", StringFormat("%+.2f", sell_pl));
      SetText("SellAvgVal", sell_avg > 0 ? DoubleToString(sell_avg, _Digits) : "--");
      
      double total_pl = buy_pl + sell_pl;
      double total_lot = buy_lot + sell_lot;
      SetColor("TotalPLVal", total_pl >= 0 ? clrLimeGreen : clrRed);
      SetText("TotalPLVal", StringFormat("%+.2f", total_pl));
      SetText("TotalLots", StringFormat("%.2f手", total_lot));
      
      double net_pl = MathAbs(buy_lot - sell_lot) > 0.001 ? total_pl : 0;
      SetColor("NetPVal", net_pl >= 0 ? clrLimeGreen : clrRed);
      SetText("NetPVal", StringFormat("%+.2f", net_pl));
      
      SetText("BuyPeakVal", StringFormat("%+.2f", g_buy_peak_pl));
      SetText("SellPeakVal", StringFormat("%+.2f", g_sell_peak_pl));
      SetText("NetPeakVal", StringFormat("%+.2f", hedge.GetNetPeakPL()));
      
      SetText("TodayVal", StringFormat("%+.2f", g_today_profit));
      SetColor("TodayVal", g_today_profit >= 0 ? clrLimeGreen : clrRed);
      SetText("YestVal", StringFormat("%+.2f", g_yesterday_profit));
      SetColor("YestVal", g_yesterday_profit >= 0 ? clrLimeGreen : clrRed);
      SetText("TotalVal", StringFormat("%+.2f", g_total_profit));
      SetColor("TotalVal", g_total_profit >= 0 ? clrLimeGreen : clrRed);
      
      string buy_status = "多单对冲: ";
      string sell_status = "空单对冲: ";
      string net_status = "净盈亏对冲: ";
      if(buy_count >= InpHedgeMinPos)
         buy_status += hedge.IsBuyHedgeActive() ? "已激活" : "待触发";
      else
         buy_status += "持仓不足";
      if(sell_count >= InpHedgeMinPos)
         sell_status += hedge.IsSellHedgeActive() ? "已激活" : "待触发";
      else
         sell_status += "持仓不足";
      
      if(buy_count > 0 && sell_count > 0)
         net_status += hedge.IsNetHedgeActive() ? "已激活" : "待触发";
      else
         net_status += "持仓不足";
      
      SetText("HedgeBuy", buy_status);
      SetColor("HedgeBuy", hedge.IsBuyHedgeActive() ? clrLimeGreen : clrSilver);
      SetText("HedgeSell", sell_status);
      SetColor("HedgeSell", hedge.IsSellHedgeActive() ? clrLimeGreen : clrSilver);
      SetText("HedgeNet", net_status);
      SetColor("HedgeNet", hedge.IsNetHedgeActive() ? clrLimeGreen : clrSilver);
      
      SetText("AddCountVal", StringFormat("%d/%d", buy_count, sell_count));
      
      SetColor("RiskFloat", profit >= 0 ? clrLimeGreen : clrRed);
      SetText("RiskFloat", StringFormat("全单浮盈亏: %+.2f", profit));
      
      double dd_pct = risk.GetDrawdown();
      double dd_amt = risk.GetDrawdownAmount();
      SetColor("RiskDD", dd_pct > 0 ? clrRed : clrSilver);
      SetText("RiskDD", StringFormat("回撤: %.2f", dd_amt));
      SetText("RiskDDPct", StringFormat("%.2f%%", dd_pct));
      
      if(!IsTradeTimeAllowed())
      {
         SetText("Status", "战况: 时间禁交");
         SetColor("Status", clrOrange);
      }
      else if(InpUseFloatProtect && profit <= -InpFloatProtectVal * 0.5)
      {
         SetText("Status", "战况: 风控警戒");
         SetColor("Status", clrRed);
      }
      else if(buy_count > 0 || sell_count > 0)
      {
         SetText("Status", "战况: 持仓中");
         SetColor("Status", clrGold);
      }
      else
      {
         SetText("Status", "战况: 允许交易");
         SetColor("Status", clrLimeGreen);
      }
      
      ChartRedraw(m_ch);
   }
   
   void SetText(string name, string text)
   {
      ObjectSetString(m_ch, m_pfx + name, OBJPROP_TEXT, text);
   }
   
   void SetColor(string name, color c)
   {
      ObjectSetInteger(m_ch, m_pfx + name, OBJPROP_COLOR, c);
   }
   
   bool Label(string n, string t, int x, int y, int w, int h, color c, int fs)
   {
      string nm = m_pfx + n;
      if(!ObjectCreate(m_ch, nm, OBJ_LABEL, m_sub, 0, 0)) return false;
      ObjectSetInteger(m_ch, nm, OBJPROP_XDISTANCE, m_x + x);
      ObjectSetInteger(m_ch, nm, OBJPROP_YDISTANCE, m_y + y);
      ObjectSetInteger(m_ch, nm, OBJPROP_XSIZE, w);
      ObjectSetInteger(m_ch, nm, OBJPROP_YSIZE, h);
      ObjectSetInteger(m_ch, nm, OBJPROP_COLOR, c);
      ObjectSetInteger(m_ch, nm, OBJPROP_FONTSIZE, fs);
      ObjectSetInteger(m_ch, nm, OBJPROP_BACK, false);
      ObjectSetInteger(m_ch, nm, OBJPROP_SELECTABLE, false);
      ObjectSetString(m_ch, nm, OBJPROP_TEXT, t);
      return true;
   }
   
   bool Rect(string n, int x, int y, int w, int h, color bg, color bc)
   {
      string nm = m_pfx + n;
      if(!ObjectCreate(m_ch, nm, OBJ_RECTANGLE_LABEL, m_sub, 0, 0)) return false;
      ObjectSetInteger(m_ch, nm, OBJPROP_XDISTANCE, m_x + x);
      ObjectSetInteger(m_ch, nm, OBJPROP_YDISTANCE, m_y + y);
      ObjectSetInteger(m_ch, nm, OBJPROP_XSIZE, w);
      ObjectSetInteger(m_ch, nm, OBJPROP_YSIZE, h);
      ObjectSetInteger(m_ch, nm, OBJPROP_BGCOLOR, bg);
      ObjectSetInteger(m_ch, nm, OBJPROP_COLOR, bc);
      ObjectSetInteger(m_ch, nm, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(m_ch, nm, OBJPROP_BACK, false);
      return true;
   }
   
   int GetX() { return m_x; }
   int GetY() { return m_y; }
   int GetW() { return m_w; }
   int GetH() { return m_h; }
};

//+------------------------------------------------------------------+
//| 全局实例                                                           |
//+------------------------------------------------------------------+
CSignalSystem g_signal;
CTradeEngine  g_engine;
CRiskControl  g_risk;
CPairHedge    g_hedge;
CInfoPanel    g_panel;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   g_chart_id = ChartID();
   string symbol = Symbol();
   
   g_trade.SetExpertMagicNumber(InpMagicNumber);
   g_trade.SetDeviationInPoints(InpSlippage);
   g_trade.SetTypeFilling(ORDER_FILLING_IOC);
   g_trade.SetAsyncMode(false);
   
   if(!g_signal.Init(symbol))
   {
      Print("信号系统初始化失败");
      return INIT_FAILED;
   }
   
   if(!g_engine.Init(symbol))
   {
      Print("交易引擎初始化失败");
      return INIT_FAILED;
   }
   
   if(InpShowPanel)
   {
      g_panel.SetSize(InpPanelWidth, InpPanelHeight);
      g_panel.Create(g_chart_id, 0, "GH", InpPanelX, InpPanelY);
      ChartSetInteger(g_chart_id, CHART_EVENT_MOUSE_MOVE, true);
   }
   
   LoadProfitHistory();
   LoadAddCounts(symbol);
   
   g_initialized = true;
   Print("金戈铁马X3D EA v2.00 启动成功 | Magic:", InpMagicNumber, " | 模式:", GetModeName());
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   g_signal.Deinit();
   if(InpShowPanel) g_panel.Destroy();
   SaveProfitHistory();
   SaveAddCounts();
   Print("金戈铁马X3D EA 已停止");
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!g_initialized) return;
   
   string symbol = Symbol();
   
   datetime cur_bar = iTime(symbol, PERIOD_CURRENT, 0);
   bool new_bar = (cur_bar != g_last_bar_time);
   if(new_bar) g_last_bar_time = cur_bar;
   
   UpdateProfitStats();
   g_risk.UpdatePeakEquity();
   
   if(g_risk.CheckFloatProtect())
   {
      Print("浮亏全平保护触发！当前浮亏:", AccountInfoDouble(ACCOUNT_PROFIT));
      g_engine.CloseAllPositions(symbol);
      g_risk.ResetTrail();
      ResetAddCounts();
      return;
   }
   
   g_hedge.Update(symbol, g_engine);
   
   if(g_hedge.CheckNetClose(symbol, g_engine))
   {
      Print("净盈亏平仓触发！");
      g_risk.ResetTrail();
      ResetAddCounts();
      return;
   }
   
   g_hedge.CheckAvgHedgeClose(symbol, g_engine);
   
   double buy_sl = 0, sell_sl = 0;
   g_risk.CheckTrailingStop(symbol, g_engine, buy_sl, sell_sl);
   
   if(buy_sl > 0) g_engine.ModifySL(symbol, POSITION_TYPE_BUY, buy_sl);
   if(sell_sl > 0) g_engine.ModifySL(symbol, POSITION_TYPE_SELL, sell_sl);
   
   int buy_count = g_engine.GetPositionCount(symbol, POSITION_TYPE_BUY);
   int sell_count = g_engine.GetPositionCount(symbol, POSITION_TYPE_SELL);
   
   CheckTimeClose(symbol, buy_count, sell_count);
   CheckSignalClose(symbol, buy_count, sell_count);
   CheckProfitClose(symbol, buy_count, sell_count);
   
   int signal = g_signal.GetSignal(symbol);
   
   double initial_lot = GetInitialLot();
   
   if(signal > 0 && buy_count == 0 && (InpAllowBothDir || sell_count == 0))
   {
      g_engine.OpenPosition(ORDER_TYPE_BUY, initial_lot, InpOpenPeriod * 10, 0, "GH Buy");
      g_buy_add_count = 1;
      g_last_add_spacing = 0;
   }
   else if(signal < 0 && sell_count == 0 && (InpAllowBothDir || buy_count == 0))
   {
      g_engine.OpenPosition(ORDER_TYPE_SELL, initial_lot, InpOpenPeriod * 10, 0, "GH Sell");
      g_sell_add_count = 1;
      g_last_add_spacing = 0;
   }
   
   if(g_engine.CanAddPosition(g_last_add_time) && g_engine.CheckKLineLimit(symbol))
   {
      CheckAddPosition(symbol, ORDER_TYPE_BUY, buy_count, signal, initial_lot);
      CheckAddPosition(symbol, ORDER_TYPE_SELL, sell_count, signal, initial_lot);
   }
   
   if(InpShowPanel) g_panel.Update(symbol, g_engine, g_risk, g_hedge);
}

//+------------------------------------------------------------------+
//| 加仓检查                                                           |
//+------------------------------------------------------------------+
void CheckAddPosition(string symbol, int type, int count, int signal, double initial_lot)
{
   if(count <= 0) return;
   if(count >= InpMaxAddCount) return;
   if(g_hedge.BlockAdd(type)) return;
   
   if(InpAddDirection == ADD_TREND)
   {
      if(type == ORDER_TYPE_BUY && signal < 0) return;
      if(type == ORDER_TYPE_SELL && signal > 0) return;
   }
   else if(InpAddDirection == ADD_REVERSE)
   {
      if(type == ORDER_TYPE_BUY && signal > 0) return;
      if(type == ORDER_TYPE_SELL && signal < 0) return;
   }
   
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
   
   double avg_price = g_engine.GetAvgPrice(symbol, type);
   if(avg_price <= 0) return;
   
   double spacing = g_engine.GetAddSpacing(count);
   
   bool should_add = false;
   
   if(type == ORDER_TYPE_BUY)
   {
      double target = avg_price - spacing;
      if(bid <= target) should_add = true;
   }
   else
   {
      double target = avg_price + spacing;
      if(ask >= target) should_add = true;
   }
   
   if(should_add)
   {
      double next_lot = g_engine.GetNextLot(initial_lot, count);
      
      if(!g_engine.CheckTotalLotLimit(symbol, next_lot))
         return;
      
      string comment = (type == ORDER_TYPE_BUY) ? "GH Add Buy" : "GH Add Sell";
      
      if(g_engine.OpenPosition(type, next_lot, InpOpenPeriod * 10, 0, comment))
      {
         if(type == ORDER_TYPE_BUY) g_buy_add_count++;
         else g_sell_add_count++;
         
         if(InpUseAddSLReset)
            g_engine.ResetAllSL(symbol, type);
      }
   }
}

//+------------------------------------------------------------------+
//| 信号平仓检查                                                       |
//+------------------------------------------------------------------+
void CheckSignalClose(string symbol, int buy_count, int sell_count)
{
   if(!InpUseSignalClose) return;
   
   if(buy_count > 0 && g_signal.GetCloseSignal(symbol, POSITION_TYPE_BUY))
   {
      if(InpUsePartialClose)
         g_engine.ClosePartial(symbol, POSITION_TYPE_BUY, InpPartialRatio);
      else
         g_engine.CloseAllPositions(symbol, POSITION_TYPE_BUY);
      g_risk.ResetTrail();
      g_buy_add_count = 0;
   }
   
   if(sell_count > 0 && g_signal.GetCloseSignal(symbol, POSITION_TYPE_SELL))
   {
      if(InpUsePartialClose)
         g_engine.ClosePartial(symbol, POSITION_TYPE_SELL, InpPartialRatio);
      else
         g_engine.CloseAllPositions(symbol, POSITION_TYPE_SELL);
      g_risk.ResetTrail();
      g_sell_add_count = 0;
   }
}

//+------------------------------------------------------------------+
//| 盈利平仓检查                                                       |
//+------------------------------------------------------------------+
void CheckProfitClose(string symbol, int buy_count, int sell_count)
{
   if(InpProfitPer001Lot <= 0) return;
   
   SPositionInfo info[];
   
   if(InpProfitCloseMode == PC_SINGLE_TARGET)
   {
      if(buy_count > 0)
      {
         int count = g_engine.GetPositions(symbol, POSITION_TYPE_BUY, info);
         for(int i = count - 1; i >= 0; i--)
         {
            double target_profit = InpProfitPer001Lot * (info[i].volume / 0.01) * InpProfitOptCoeff;
            if(info[i].profit >= target_profit)
            {
               g_engine.ClosePosition(info[i].ticket);
               g_total_profit += info[i].profit;
               g_win_trades++;
            }
         }
      }
      
      if(sell_count > 0)
      {
         int count = g_engine.GetPositions(symbol, POSITION_TYPE_SELL, info);
         for(int i = count - 1; i >= 0; i--)
         {
            double target_profit = InpProfitPer001Lot * (info[i].volume / 0.01) * InpProfitOptCoeff;
            if(info[i].profit >= target_profit)
            {
               g_engine.ClosePosition(info[i].ticket);
               g_total_profit += info[i].profit;
               g_win_trades++;
            }
         }
      }
   }
   else if(InpProfitCloseMode == PC_MULTI_TARGET)
   {
      CheckMultiTargetClose(symbol, POSITION_TYPE_BUY);
      CheckMultiTargetClose(symbol, POSITION_TYPE_SELL);
   }
   else if(InpProfitCloseMode == PC_DRAWDOWN)
   {
      CheckDrawdownClose(symbol, POSITION_TYPE_BUY);
      CheckDrawdownClose(symbol, POSITION_TYPE_SELL);
   }
}

//+------------------------------------------------------------------+
//| 多目标阶梯平仓                                                     |
//+------------------------------------------------------------------+
void CheckMultiTargetClose(string symbol, int type)
{
   double total_lot = g_engine.GetTotalLot(symbol, type);
   if(total_lot <= 0) return;
   
   double total_pl = g_engine.GetTotalProfit(symbol, type);
   double avg_price = g_engine.GetAvgPrice(symbol, type);
   if(avg_price <= 0) return;
   
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   
   double targets[];
   double ratios[];
   
   string tparts[];
   int tc = StringSplit(InpMultiTargets, ',', tparts);
   for(int i = 0; i < tc; i++)
   {
      double v = StringToDouble(tparts[i]);
      if(v > 0)
      {
         int s = ArraySize(targets);
         ArrayResize(targets, s + 1);
         targets[s] = v;
      }
   }
   
   string rparts[];
   int rc = StringSplit(InpMultiRatios, ',', rparts);
   for(int i = 0; i < rc; i++)
   {
      double v = StringToDouble(rparts[i]);
      if(v > 0)
      {
         int s = ArraySize(ratios);
         ArrayResize(ratios, s + 1);
         ratios[s] = v;
      }
   }
   
   if(ArraySize(targets) == 0 || ArraySize(ratios) == 0) return;
   
   double profit_per_lot = total_pl / total_lot / (0.01);
   
   static int buy_target_reached = 0;
   static int sell_target_reached = 0;
   
   int reached = (type == POSITION_TYPE_BUY) ? buy_target_reached : sell_target_reached;
   
   for(int i = reached; i < ArraySize(targets) && i < ArraySize(ratios); i++)
   {
      if(profit_per_lot >= targets[i])
      {
         double close_ratio = ratios[i];
         
         if(close_ratio > 0 && close_ratio < 1.0)
         {
            g_engine.ClosePartial(symbol, type, close_ratio);
            g_win_trades++;
         }
         
         if(type == POSITION_TYPE_BUY)
            buy_target_reached = i + 1;
         else
            sell_target_reached = i + 1;
      }
      else break;
   }
   
   int pos_count = g_engine.GetPositionCount(symbol, type);
   if(pos_count == 0)
   {
      if(type == POSITION_TYPE_BUY)
         buy_target_reached = 0;
      else
         sell_target_reached = 0;
   }
}

//+------------------------------------------------------------------+
//| 盈利回撤平仓                                                       |
//+------------------------------------------------------------------+
void CheckDrawdownClose(string symbol, int type)
{
   double total_lot = g_engine.GetTotalLot(symbol, type);
   if(total_lot <= 0) return;
   
   double total_pl = g_engine.GetTotalProfit(symbol, type);
   double avg_price = g_engine.GetAvgPrice(symbol, type);
   if(avg_price <= 0) return;
   
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   double profit_per_lot = total_pl / total_lot / (0.01);
   
   double peak_pl = (type == POSITION_TYPE_BUY) ? g_buy_peak_pl : g_sell_peak_pl;
   
   if(profit_per_lot > peak_pl)
   {
      peak_pl = profit_per_lot;
      if(type == POSITION_TYPE_BUY)
         g_buy_peak_pl = peak_pl;
      else
         g_sell_peak_pl = peak_pl;
   }
   
   if(peak_pl >= InpDrawdownTrigger)
   {
      double drawdown = peak_pl - profit_per_lot;
      double drawdown_pct = (peak_pl > 0) ? (drawdown / peak_pl * 100) : 0;
      
      if(drawdown_pct >= InpDrawdownPercent)
      {
         if(InpUsePartialClose)
            g_engine.ClosePartial(symbol, type, InpPartialRatio);
         else
            g_engine.CloseAllPositions(symbol, type);
         
         g_win_trades++;
         if(type == POSITION_TYPE_BUY)
            g_buy_peak_pl = 0;
         else
            g_sell_peak_pl = 0;
         g_risk.ResetTrail();
         
         if(type == POSITION_TYPE_BUY)
            g_buy_add_count = 0;
         else
            g_sell_add_count = 0;
      }
   }
   
   int pos_count = g_engine.GetPositionCount(symbol, type);
   if(pos_count == 0)
   {
      if(type == POSITION_TYPE_BUY)
         g_buy_peak_pl = 0;
      else
         g_sell_peak_pl = 0;
   }
}

//+------------------------------------------------------------------+
//| 时间平仓检查                                                       |
//+------------------------------------------------------------------+
void CheckTimeClose(string symbol, int buy_count, int sell_count)
{
   if(!InpUseTimeClose) return;
   
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int cur_min = dt.hour * 60 + dt.min;
   int close_min = InpCloseHour * 60 + InpCloseMinute;
   
   if(MathAbs(cur_min - close_min) <= 1)
   {
      if(buy_count > 0)
      {
         g_engine.CloseAllPositions(symbol, POSITION_TYPE_BUY);
         g_buy_add_count = 0;
      }
      if(sell_count > 0)
      {
         g_engine.CloseAllPositions(symbol, POSITION_TYPE_SELL);
         g_sell_add_count = 0;
      }
      g_risk.ResetTrail();
      return;
   }
   
   if(InpMaxHoldBars > 0)
   {
      SPositionInfo info[];
      
      if(buy_count > 0)
      {
         int count = g_engine.GetPositions(symbol, POSITION_TYPE_BUY, info);
         datetime now = TimeCurrent();
         int period_sec = (int)Period() * 60;
         
         for(int i = count - 1; i >= 0; i--)
         {
            int bars_held = (int)((now - info[i].open_time) / period_sec);
            if(bars_held >= InpMaxHoldBars)
            {
               g_engine.ClosePosition(info[i].ticket);
            }
         }
      }
      
      if(sell_count > 0)
      {
         int count = g_engine.GetPositions(symbol, POSITION_TYPE_SELL, info);
         datetime now = TimeCurrent();
         int period_sec = (int)Period() * 60;
         
         for(int i = count - 1; i >= 0; i--)
         {
            int bars_held = (int)((now - info[i].open_time) / period_sec);
            if(bars_held >= InpMaxHoldBars)
            {
               g_engine.ClosePosition(info[i].ticket);
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| ChartEvent                                                         |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(!InpShowPanel) return;
   
   int x = (int)lparam;
   int y = (int)dparam;
   
   if(id == CHARTEVENT_MOUSE_MOVE)
   {
      if(g_dragging)
         DragPanel(x, y);
      return;
   }
   
   if(id == CHARTEVENT_CLICK)
   {
      if(!g_dragging)
      {
         if(IsOnPanelBorder(x, y))
         {
            g_dragging = true;
            g_drag_start_x = x - g_panel.GetX();
            g_drag_start_y = y - g_panel.GetY();
         }
      }
      else
      {
         g_dragging = false;
      }
      return;
   }
}

//+------------------------------------------------------------------+
//| 辅助函数                                                           |
//+------------------------------------------------------------------+
string GetModeName()
{
   switch(InpTradeMode)
   {
      case MODE_CONSERVATIVE: return "保守";
      case MODE_STEADY: return "稳健";
      case MODE_AGGRESSIVE: return "激进";
      case MODE_CUSTOM: return "自定义";
   }
   return "未知";
}

double GetInitialLot()
{
   double lot = InpInitialLot;
   
   switch(InpTradeMode)
   {
      case MODE_CONSERVATIVE:
         lot *= 0.5;
         break;
      case MODE_AGGRESSIVE:
         lot *= 2.0;
         break;
   }
   
   return lot;
}

void DragPanel(int x, int y)
{
   int nx = x - (int)g_drag_start_x;
   int ny = y - (int)g_drag_start_y;
   
   long cw = ChartGetInteger(g_chart_id, CHART_WIDTH_IN_PIXELS);
   long ch = ChartGetInteger(g_chart_id, CHART_HEIGHT_IN_PIXELS);
   int maxX = (int)cw - g_panel.GetW();
   int maxY = (int)ch - g_panel.GetH();
   
   if(maxX < 0) maxX = 0;
   if(maxY < 0) maxY = 0;
   if(nx < 0) nx = 0;
   if(ny < 0) ny = 0;
   if(nx > maxX) nx = maxX;
   if(ny > maxY) ny = maxY;
   
   g_panel.Destroy();
   g_panel.Create(g_chart_id, 0, "GH", nx, ny);
   g_panel.Update(Symbol(), g_engine, g_risk, g_hedge);
}

bool IsOnPanelBorder(int x, int y)
{
   int px = g_panel.GetX(), py = g_panel.GetY();
   int pw = g_panel.GetW(), ph = g_panel.GetH();
   int border = 5;
   
   return (x >= px && x <= px + pw && y >= py && y <= py + ph &&
           (x <= px + border || x >= px + pw - border ||
            y <= py + border || y >= py + ph - border));
}

void ResetAddCounts()
{
   g_buy_add_count = 0;
   g_sell_add_count = 0;
}

void LoadAddCounts(string symbol)
{
   g_buy_add_count = g_engine.GetPositionCount(symbol, POSITION_TYPE_BUY);
   g_sell_add_count = g_engine.GetPositionCount(symbol, POSITION_TYPE_SELL);
}

void SaveAddCounts()
{
}

void UpdateProfitStats()
{
   static datetime last_day = 0;
   datetime cur_day = TimeCurrent() / 86400 * 86400;
   
   if(cur_day != last_day)
   {
      g_yesterday_profit = g_today_profit;
      g_today_profit = 0;
      last_day = cur_day;
   }
   
   g_today_profit = 0;
   HistorySelect(TimeCurrent() - 86400, TimeCurrent());
   for(int i = (int)HistoryDealsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = HistoryDealGetTicket(i);
      if(ticket <= 0) continue;
      if(HistoryDealGetInteger(ticket, DEAL_MAGIC) != InpMagicNumber) continue;
      
      datetime deal_time = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
      if(deal_time >= cur_day)
      {
         g_today_profit += HistoryDealGetDouble(ticket, DEAL_PROFIT);
      }
   }
}

void LoadProfitHistory()
{
   string filename = "GoldenHorse_" + IntegerToString(InpMagicNumber) + ".dat";
   string filepath = "GoldenHorse\\" + filename;
   
   int handle = FileOpen(filepath, FILE_READ|FILE_COMMON|FILE_BIN);
   if(handle != INVALID_HANDLE)
   {
      g_total_profit = FileReadDouble(handle);
      g_total_trades = FileReadInteger(handle);
      g_win_trades = FileReadInteger(handle);
      FileClose(handle);
   }
}

void SaveProfitHistory()
{
   string filename = "GoldenHorse_" + IntegerToString(InpMagicNumber) + ".dat";
   string filepath = "GoldenHorse\\" + filename;
   
   int handle = FileOpen(filepath, FILE_WRITE|FILE_COMMON|FILE_BIN);
   if(handle != INVALID_HANDLE)
   {
      FileWriteDouble(handle, g_total_profit);
      FileWriteInteger(handle, g_total_trades);
      FileWriteInteger(handle, g_win_trades);
      FileClose(handle);
   }
}
//+------------------------------------------------------------------+
