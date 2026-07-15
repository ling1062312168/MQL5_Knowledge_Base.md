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
   MODE_CONSERVATIVE,   // 保守
   MODE_STEADY,         // 稳健
   MODE_AGGRESSIVE,     // 激进
   MODE_CUSTOM          // 自定义
};

enum ENUM_ADD_TYPE
{
   ADD_MARTIN,          // 马丁倍率加仓
   ADD_INCREASE,        // 递增手数加仓
   ADD_CUSTOM           // 自定义手数列表
};

enum ENUM_DECIMAL_PLACE
{
   DEC_2 = 2,           // 2位小数
   DEC_3 = 3            // 3位小数
};

enum ENUM_HEDGE_STATUS
{
   HEDGE_NONE,          // 无对冲
   HEDGE_BUY_WAIT,      // 多单对冲待触发
   HEDGE_SELL_WAIT,     // 空单对冲待触发
   HEDGE_ACTIVE         // 对冲已激活
};

//+------------------------------------------------------------------+
//| Section1: 基础设置                                                 |
//+------------------------------------------------------------------+
input group    "=== 基础设置 ==="
input ENUM_TRADE_MODE     InpTradeMode      = MODE_STEADY;      // 交易模式
input double              InpInitialLot     = 0.01;             // 初始开仓手数
input ENUM_DECIMAL_PLACE  InpDecimalPlace   = DEC_2;            // 下单数位
input int                 InpMagicNumber    = 888888;           // 魔术数字

//+------------------------------------------------------------------+
//| Section2: 自定义开仓设置                                           |
//+------------------------------------------------------------------+
input group    "=== 自定义开仓设置 ==="
input int                 InpOpenPeriod     = 14;               // 开仓计算周期
input double              InpSignalStrength = 0.618;            // 开仓信号强度
input int                 InpConfirmBars    = 2;                // 开仓确认K线数
input ENUM_TIMEFRAMES     InpOpenTimeFrame  = PERIOD_M5;        // 开仓时间周期
input int                 InpOpenIndicator  = 60;               // 开仓计算指标
input double              InpOpenCoeff      = 2.0;              // 开仓计算系数
input bool                InpUseAdaptive    = true;             // 启用自适应入场
input int                 InpBBM1Period     = 20;               // 自适应M1布林周期
input double              InpBBM1Dev        = 1.5;              // 自适应M1布林系数
input int                 InpBBM5Period     = 20;               // 自适应M5布林周期
input double              InpBBM5Dev        = 2.0;              // 自适应M5布林系数
input double              InpBBProximity    = 0.25;             // 接近上下轨比例
input int                 InpOpenPeriod2    = 3;                // 开仓计算周期2

//+------------------------------------------------------------------+
//| Section3: 自定义加仓设置                                           |
//+------------------------------------------------------------------+
input group    "=== 自定义加仓设置 ==="
input int                 InpAddDelay       = 0;                // 加仓延迟(秒)
input double              InpAddCoeff        = 1.0;             // 加仓比例系数
input ENUM_ADD_TYPE       InpAddType         = ADD_MARTIN;      // 加仓方式
input int                 InpAddSpacing     = 500;              // 加仓间隔(点数)
input double              InpMartinMult     = 1.5;              // 马丁倍率
input double              InpIncreaseLot    = 0.01;             // 递增手数
input string              InpCustomLots     = "0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09"; // 自定义手数列表
input double              InpMaxAddLot      = 2.0;              // 加仓手数上限(0=不启用)

//+------------------------------------------------------------------+
//| Section4: 自定义单K线加仓限制                                      |
//+------------------------------------------------------------------+
input group    "=== 自定义单K线加仓限制 ==="
input int                 InpKDepth         = 5;                // K线分析深度
input bool                InpUseKLimit      = true;             // 启用单K线加仓限制
input ENUM_TIMEFRAMES     InpKLimitTF       = PERIOD_CURRENT;   // 单K线限制加仓周期

//+------------------------------------------------------------------+
//| Section5: 自定义平仓设置                                           |
//+------------------------------------------------------------------+
input group    "=== 自定义平仓设置 ==="
input double              InpProfitOptCoeff  = 1.0;             // 盈利优化系数
input int                 InpCloseFilter     = 1;               // 平仓信号过滤
input double              InpProfitPer001Lot = 1.0;             // 每0.01手盈利金额
input bool                InpUseFloatProtect = false;           // 启用浮亏全平保护
input double              InpFloatProtectVal = 10000.0;         // 浮亏全平阈值

//+------------------------------------------------------------------+
//| Section5b: 均价移动止盈设置                                        |
//+------------------------------------------------------------------+
input group    "=== 均价移动止盈设置 ==="
input bool                InpUseTrailing     = true;            // 启用均价移动止盈
input int                 InpTrailActive     = 500;             // 激活距离(点数)
input int                 InpTrailLock       = 300;             // 回撤锁定距离(点数)

//+------------------------------------------------------------------+
//| Section6: 自定义时间过滤设置                                       |
//+------------------------------------------------------------------+
input group    "=== 自定义时间过滤设置 ==="
input int                 InpTimeOffset     = 0;                // 时区偏移(小时)
input bool                InpUseTradeTime   = false;            // 启用开启交易时间段过滤
input string              InpTradeStartTime = "00:00";          // 开启交易开始时间
input string              InpTradeEndTime   = "23:59";          // 开启交易结束时间
input bool                InpUseBlockTime   = false;            // 启用禁止交易时间段过滤
input string              InpBlockStartTime = "00:00";          // 禁止交易开始时间
input string              InpBlockEndTime   = "00:00";          // 禁止交易结束时间

//+------------------------------------------------------------------+
//| SectionPairHedge: 尾单对冲首单移动止盈                             |
//+------------------------------------------------------------------+
input group    "=== 尾单对冲首单移动止盈 ==="
input bool                InpUsePairHedge   = true;             // 启用尾单带首单
input double              InpHedgeStartPL   = 1.5;              // 首尾组合盈利启动点
input double              InpHedgePullback  = 0.5;              // 回撤多少点平仓
input bool                InpHedgeBlockAdd  = false;            // 尾单盈利时禁止继续加仓

//+------------------------------------------------------------------+
//| Section8: 托管模式设置                                             |
//+------------------------------------------------------------------+
input group    "=== 托管模式设置 ==="
input bool                InpShowPanel      = true;             // 启用高级面板/托管显示
input int                 InpPanelX         = 10;               // 面板X位置
input int                 InpPanelY         = 30;               // 面板Y位置

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

// 收益统计
double      g_today_profit = 0;
double      g_yesterday_profit = 0;
double      g_total_profit = 0;
int         g_total_trades = 0;
int         g_win_trades = 0;

// 面板拖拽
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
   
   // 时区偏移
   int offset = InpTimeOffset * 60;
   cur_min = (cur_min + offset + 1440) % 1440;
   
   // 开启时间段检查
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
   
   // 禁止时间段检查
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
//| 信号系统类                                                         |
//+------------------------------------------------------------------+
class CSignalSystem
{
private:
   int    m_bb_handle_m1;
   int    m_bb_handle_m5;
   int    m_ma_handle;
   int    m_rsi_handle;
   double m_bb_upper[], m_bb_middle[], m_bb_lower[];
   double m_ma_val[], m_rsi_val[];
   
public:
   CSignalSystem() : m_bb_handle_m1(INVALID_HANDLE), m_bb_handle_m5(INVALID_HANDLE),
                     m_ma_handle(INVALID_HANDLE), m_rsi_handle(INVALID_HANDLE) {}
   
   bool Init(string symbol)
   {
      if(InpUseAdaptive)
      {
         m_bb_handle_m1 = iBands(symbol, PERIOD_M1, InpBBM1Period, 0, InpBBM1Dev, PRICE_CLOSE);
         m_bb_handle_m5 = iBands(symbol, PERIOD_M5, InpBBM5Period, 0, InpBBM5Dev, PRICE_CLOSE);
      }
      m_ma_handle = iMA(symbol, InpOpenTimeFrame, InpOpenPeriod, 0, MODE_SMA, PRICE_CLOSE);
      m_rsi_handle = iRSI(symbol, InpOpenTimeFrame, InpOpenIndicator, PRICE_CLOSE);
      
      return (m_ma_handle != INVALID_HANDLE && m_rsi_handle != INVALID_HANDLE);
   }
   
   void Deinit()
   {
      if(m_bb_handle_m1 != INVALID_HANDLE) IndicatorRelease(m_bb_handle_m1);
      if(m_bb_handle_m5 != INVALID_HANDLE) IndicatorRelease(m_bb_handle_m5);
      if(m_ma_handle != INVALID_HANDLE) IndicatorRelease(m_ma_handle);
      if(m_rsi_handle != INVALID_HANDLE) IndicatorRelease(m_rsi_handle);
   }
   
   // 自适应布林入场信号
   int GetAdaptiveSignal(string symbol)
   {
      if(!InpUseAdaptive) return 0;
      
      double close = iClose(symbol, PERIOD_CURRENT, 0);
      double close_m1 = iClose(symbol, PERIOD_M1, 0);
      double close_m5 = iClose(symbol, PERIOD_M5, 0);
      
      // M1布林
      if(CopyBuffer(m_bb_handle_m1, 0, 0, 1, m_bb_middle) > 0 &&
         CopyBuffer(m_bb_handle_m1, 1, 0, 1, m_bb_upper) > 0 &&
         CopyBuffer(m_bb_handle_m1, 2, 0, 1, m_bb_lower) > 0)
      {
         double band_m1 = m_bb_upper[0] - m_bb_lower[0];
         double dist_upper = MathAbs(close_m1 - m_bb_upper[0]);
         double dist_lower = MathAbs(close_m1 - m_bb_lower[0]);
         
         if(dist_upper < band_m1 * InpBBProximity) return -1;  // 接近上轨，做空信号
         if(dist_lower < band_m1 * InpBBProximity) return 1;   // 接近下轨，做多信号
      }
      
      // M5布林
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
   
   // 主信号系统
   int GetMainSignal(string symbol)
   {
      if(CopyBuffer(m_ma_handle, 0, 0, 3, m_ma_val) < 3) return 0;
      if(CopyBuffer(m_rsi_handle, 0, 0, 3, m_rsi_val) < 3) return 0;
      
      double close = iClose(symbol, PERIOD_CURRENT, 0);
      double prev_close = iClose(symbol, PERIOD_CURRENT, 1);
      
      // 趋势确认
      bool trend_up = (m_ma_val[0] > m_ma_val[1] && m_ma_val[1] > m_ma_val[2]);
      bool trend_down = (m_ma_val[0] < m_ma_val[1] && m_ma_val[1] < m_ma_val[2]);
      
      // RSI信号
      bool rsi_buy = (m_rsi_val[0] < 40 && m_rsi_val[0] > m_rsi_val[1]);
      bool rsi_sell = (m_rsi_val[0] > 60 && m_rsi_val[0] < m_rsi_val[1]);
      
      // 强度系数
      double strength = InpSignalStrength;
      
      // K线确认
      int buy_count = 0, sell_count = 0;
      for(int i = 0; i < InpConfirmBars && i < 10; i++)
      {
         double o = iOpen(symbol, PERIOD_CURRENT, i);
         double c = iClose(symbol, PERIOD_CURRENT, i);
         if(c > o) buy_count++;
         else if(c < o) sell_count++;
      }
      
      // 综合信号
      if(trend_up && rsi_buy && buy_count >= InpConfirmBars * strength)
         return 1;
      if(trend_down && rsi_sell && sell_count >= InpConfirmBars * strength)
         return -1;
      
      return 0;
   }
   
   // 综合信号
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
   
   // 自定义手数列表
   double   m_custom_lots[];
   int      m_custom_lot_idx;
   
public:
   CTradeEngine() : m_custom_lot_idx(0) {}
   
   bool Init(string symbol)
   {
      m_symbol = symbol;
      m_point = SymbolInfoDouble(symbol, SYMBOL_POINT);
      m_digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
      m_lot_step = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
      m_min_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
      m_max_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
      
      // 解析自定义手数列表
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
      
      // 加仓上限
      if(InpMaxAddLot > 0 && lot > InpMaxAddLot)
         lot = InpMaxAddLot;
      
      // 小数位
      double multiplier = MathPow(10, (int)InpDecimalPlace);
      lot = MathFloor(lot * multiplier) / multiplier;
      
      // 步长
      double steps = MathRound(lot / m_lot_step);
      lot = steps * m_lot_step;
      
      return lot;
   }
   
   double GetNextLot(double current_lot, int add_count)
   {
      double next_lot = current_lot;
      
      switch(InpAddType)
      {
         case ADD_MARTIN:
            next_lot = current_lot * InpMartinMult * InpAddCoeff;
            break;
         case ADD_INCREASE:
            next_lot = current_lot + InpIncreaseLot * InpAddCoeff;
            break;
         case ADD_CUSTOM:
            if(m_custom_lot_idx < ArraySize(m_custom_lots))
            {
               next_lot = m_custom_lots[m_custom_lot_idx] * InpAddCoeff;
               m_custom_lot_idx++;
            }
            break;
      }
      
      return NormalizeLot(next_lot);
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
   
   void ClosePosition(ulong ticket)
   {
      g_trade.PositionClose(ticket);
   }
};

//+------------------------------------------------------------------+
//| 风控系统类                                                         |
//+------------------------------------------------------------------+
class CRiskControl
{
private:
   double   m_max_buy_pl;
   double   m_max_sell_pl;
   double   m_peak_equity;
   double   m_trail_active_price;
   bool     m_trail_activated;
   
public:
   CRiskControl() : m_max_buy_pl(0), m_max_sell_pl(0), m_peak_equity(0),
                    m_trail_active_price(0), m_trail_activated(false) {}
   
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
   
   // 浮亏全平保护
   bool CheckFloatProtect()
   {
      if(!InpUseFloatProtect) return false;
      
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      if(profit <= -InpFloatProtectVal)
      {
         return true;  // 需要全平
      }
      return false;
   }
   
   // 均价移动止盈
   void CheckTrailingStop(string symbol, double &buy_sl, double &sell_sl)
   {
      if(!InpUseTrailing) return;
      
      double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
      
      // 计算多单均价和盈亏
      double buy_avg_price = 0, buy_total_lot = 0, buy_pl = 0;
      double sell_avg_price = 0, sell_total_lot = 0, sell_pl = 0;
      
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         
         int type = (int)PositionGetInteger(POSITION_TYPE);
         double lot = PositionGetDouble(POSITION_VOLUME);
         double price = PositionGetDouble(POSITION_PRICE_OPEN);
         
         if(type == POSITION_TYPE_BUY)
         {
            buy_avg_price += price * lot;
            buy_total_lot += lot;
         }
         else
         {
            sell_avg_price += price * lot;
            sell_total_lot += lot;
         }
      }
      
      double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
      
      // 多单移动止盈
      if(buy_total_lot > 0)
      {
         buy_avg_price /= buy_total_lot;
         double pl_points = (bid - buy_avg_price) / point;
         
         if(pl_points >= InpTrailActive)
         {
            if(!m_trail_activated)
            {
               m_trail_activated = true;
               m_trail_active_price = bid;
            }
            else if(bid > m_trail_active_price)
            {
               m_trail_active_price = bid;
            }
            
            double lock_price = m_trail_active_price - InpTrailLock * point;
            if(lock_price > buy_avg_price)
               buy_sl = lock_price;
         }
      }
      
      // 空单移动止盈
      if(sell_total_lot > 0)
      {
         sell_avg_price /= sell_total_lot;
         double pl_points = (sell_avg_price - ask) / point;
         
         if(pl_points >= InpTrailActive)
         {
            if(!m_trail_activated)
            {
               m_trail_activated = true;
               m_trail_active_price = ask;
            }
            else if(ask < m_trail_active_price)
            {
               m_trail_active_price = ask;
            }
            
            double lock_price = m_trail_active_price + InpTrailLock * point;
            if(lock_price < sell_avg_price)
               sell_sl = lock_price;
         }
      }
   }
   
   void ResetTrail() { m_trail_activated = false; m_trail_active_price = 0; }
};

//+------------------------------------------------------------------+
//| 尾单对冲类                                                         |
//+------------------------------------------------------------------+
class CPairHedge
{
private:
   double   m_first_buy_price;
   double   m_last_buy_price;
   double   m_first_sell_price;
   double   m_last_sell_price;
   double   m_peak_combo_pl;
   bool     m_hedge_active;
   
public:
   CPairHedge() : m_first_buy_price(0), m_last_buy_price(0),
                  m_first_sell_price(0), m_last_sell_price(0),
                  m_peak_combo_pl(0), m_hedge_active(false) {}
   
   void Update(string symbol)
   {
      if(!InpUsePairHedge) return;
      
      double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
      double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
      
      // 获取首单和尾单价格
      m_first_buy_price = 0; m_last_buy_price = 0;
      m_first_sell_price = 0; m_last_sell_price = 0;
      
      datetime first_buy_time = 0, last_buy_time = 0;
      datetime first_sell_time = 0, last_sell_time = 0;
      
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         
         int type = (int)PositionGetInteger(POSITION_TYPE);
         double price = PositionGetDouble(POSITION_PRICE_OPEN);
         datetime open_time = (datetime)PositionGetInteger(POSITION_TIME);
         
         if(type == POSITION_TYPE_BUY)
         {
            if(first_buy_time == 0 || open_time < first_buy_time)
            { first_buy_time = open_time; m_first_buy_price = price; }
            if(last_buy_time == 0 || open_time > last_buy_time)
            { last_buy_time = open_time; m_last_buy_price = price; }
         }
         else
         {
            if(first_sell_time == 0 || open_time < first_sell_time)
            { first_sell_time = open_time; m_first_sell_price = price; }
            if(last_sell_time == 0 || open_time > last_sell_time)
            { last_sell_time = open_time; m_last_sell_price = price; }
         }
      }
      
      // 计算首尾组合盈亏
      if(m_first_buy_price > 0 && m_last_buy_price > 0)
      {
         double combo_pl = (bid - m_first_buy_price) / point + (m_last_buy_price - bid) / point;
         if(combo_pl >= InpHedgeStartPL)
         {
            m_hedge_active = true;
            if(combo_pl > m_peak_combo_pl) m_peak_combo_pl = combo_pl;
            
            // 回撤平仓
            if(m_peak_combo_pl - combo_pl >= InpHedgePullback)
            {
               // 平首单和尾单
               CloseFirstAndLast(symbol, POSITION_TYPE_BUY);
               m_hedge_active = false;
               m_peak_combo_pl = 0;
            }
         }
      }
      
      if(m_first_sell_price > 0 && m_last_sell_price > 0)
      {
         double combo_pl = (m_first_sell_price - ask) / point + (ask - m_last_sell_price) / point;
         if(combo_pl >= InpHedgeStartPL)
         {
            m_hedge_active = true;
            if(combo_pl > m_peak_combo_pl) m_peak_combo_pl = combo_pl;
            
            if(m_peak_combo_pl - combo_pl >= InpHedgePullback)
            {
               CloseFirstAndLast(symbol, POSITION_TYPE_SELL);
               m_hedge_active = false;
               m_peak_combo_pl = 0;
            }
         }
      }
   }
   
   void CloseFirstAndLast(string symbol, int type)
   {
      datetime first_time = 0, last_time = 0;
      ulong first_ticket = 0, last_ticket = 0;
      
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         if((int)PositionGetInteger(POSITION_TYPE) != type) continue;
         
         datetime open_time = (datetime)PositionGetInteger(POSITION_TIME);
         
         if(first_time == 0 || open_time < first_time)
         { first_time = open_time; first_ticket = ticket; }
         if(last_time == 0 || open_time > last_time)
         { last_time = open_time; last_ticket = ticket; }
      }
      
      if(first_ticket > 0) g_trade.PositionClose(first_ticket);
      if(last_ticket > 0 && last_ticket != first_ticket) g_trade.PositionClose(last_ticket);
   }
   
   bool IsHedgeActive() { return m_hedge_active; }
   
   bool BlockAdd() { return InpHedgeBlockAdd && m_hedge_active; }
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
   int      m_color_idx;
   
public:
   CInfoPanel() : m_ch(0), m_sub(0), m_x(0), m_y(0), m_w(320), m_h(400), m_color_idx(0) {}
   
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
      // 主背景
      Rect("BG", 0, 0, m_w, m_h, C'25,25,30', C'80,60,30');
      
      // 标题区域
      Rect("TitleBG", 0, 0, m_w, 60, C'35,30,25', C'100,80,40');
      Label("Title1", "金戈铁马  多核对冲量化引擎", 8, 4, 250, 16, C'200,180,120', 10);
      Label("Title2", "GOLDEN CAVALRY · MULTI-CORE HEDGE · ARES FLAGSHIP", 8, 20, 300, 10, C'150,130,80', 7);
      Label("Title3", "「 金戈所向·多空俱亡  |  铁马奔腾·对冲千军 」", 8, 32, 300, 10, C'180,160,100', 7);
      Label("Symbol", "XAUUSD", 8, 46, 60, 10, clrSilver, 8);
      Label("Magic", "Magic " + IntegerToString(InpMagicNumber), 80, 46, 100, 10, clrSilver, 8);
      Label("Status", "战况: 允许交易", 200, 46, 100, 10, clrLimeGreen, 8);
      
      // 收益区域
      int ry = 64;
      Rect("ProfitBG", 4, ry, m_w - 8, 50, C'20,25,20', C'60,70,50');
      Label("TodayLbl", "今日斩获", 12, ry + 4, 60, 12, C'180,160,100', 8);
      Label("TodayVal", "0.00", 12, ry + 18, 80, 16, clrLimeGreen, 11);
      Label("YestLbl", "昨日斩获", 110, ry + 4, 60, 12, C'180,160,100', 8);
      Label("YestVal", "0.00", 110, ry + 18, 80, 16, clrLimeGreen, 11);
      Label("TotalLbl", "首战累积", 210, ry + 4, 60, 12, C'180,160,100', 8);
      Label("TotalVal", "0.00", 210, ry + 18, 80, 16, clrLimeGreen, 11);
      
      // 账户概览
      ry += 56;
      Rect("AcctBG", 4, ry, m_w - 8, 70, C'20,20,25', C'50,50,60');
      Label("AcctTitle", "账户概览", 12, ry + 4, 60, 12, C'150,180,200', 9);
      Label("BalLbl", "余额", 12, ry + 20, 40, 10, clrSilver, 8);
      Label("BalVal", "--", 48, ry + 20, 80, 10, clrWhite, 8);
      Label("EqLbl", "净值", 140, ry + 20, 40, 10, clrSilver, 8);
      Label("EqVal", "--", 176, ry + 20, 80, 10, clrWhite, 8);
      Label("MarLbl", "可用保证金", 12, ry + 34, 60, 10, clrSilver, 8);
      Label("MarVal", "--", 72, ry + 34, 80, 10, clrWhite, 8);
      Label("MargPLbl", "保证金比例", 140, ry + 34, 60, 10, clrSilver, 8);
      Label("MargPVal", "--", 200, ry + 34, 80, 10, clrWhite, 8);
      
      // 持仓监控
      ry += 76;
      Rect("PosBG", 4, ry, m_w - 8, 70, C'25,20,20', C'60,50,50');
      Label("PosTitle", "持仓监控", 12, ry + 4, 60, 12, C'200,150,150', 9);
      Label("BuyLbl", "多单", 12, ry + 20, 30, 10, clrSilver, 8);
      Label("BuyVal", "0单/0.00手", 40, ry + 20, 80, 10, clrWhite, 8);
      Label("BuyPL", "0.00", 130, ry + 20, 60, 10, clrLimeGreen, 8);
      Label("SellLbl", "空单", 12, ry + 34, 30, 10, clrSilver, 8);
      Label("SellVal", "0单/0.00手", 40, ry + 34, 80, 10, clrWhite, 8);
      Label("SellPL", "0.00", 130, ry + 34, 60, 10, clrRed, 8);
      Label("TotalPLLbl", "总浮盈亏", 12, ry + 50, 50, 10, clrSilver, 8);
      Label("TotalPLVal", "0.00", 60, ry + 50, 80, 10, clrWhite, 8);
      Label("TotalLots", "0.00手", 150, ry + 50, 60, 10, clrWhite, 8);
      
      // 多核对冲状态
      ry += 76;
      Rect("HedgeBG", 4, ry, m_w - 8, 60, C'20,25,20', C'50,60,50');
      Label("HedgeTitle", "多核对冲 · 移动止盈战法", 12, ry + 4, 160, 12, C'150,200,150', 9);
      Label("HedgeBuy", "多单对冲待触发", 12, ry + 20, 100, 10, clrSilver, 8);
      Label("HedgeSell", "空单对冲待触发", 12, ry + 34, 100, 10, clrSilver, 8);
      Label("HedgeRule", "兵法: 盈 " + DoubleToString(InpHedgeStartPL, 1) + " 启动 / 撤 " + 
             DoubleToString(InpHedgePullback, 1) + " 触发 / 配对 1点 收兵", 
             12, ry + 48, 280, 10, C'150,170,150', 7);
      
      // 风控
      ry += 66;
      Rect("RiskBG", 4, ry, m_w - 8, 50, C'30,20,20', C'70,40,40');
      Label("RiskTitle", "风控师令 · 全军安危", 12, ry + 4, 120, 12, C'200,150,150', 9);
      Label("RiskFloat", "全单浮盈亏: 0.00", 12, ry + 20, 100, 10, clrWhite, 8);
      Label("RiskDD", "回撤: 0.00 / 0.00%", 140, ry + 20, 120, 10, clrWhite, 8);
      
      // 底部状态栏
      Rect("FooterBG", 0, m_h - 20, m_w, 20, C'30,25,20', C'80,70,40');
      Label("Footer", "金戈铁马 · 铁骑托管中 · 多核对冲风控执行 · 请勿混用同Magic", 
            8, m_h - 18, 300, 10, C'180,160,100', 7);
   }
   
   void Update(string symbol)
   {
      // 账户数据
      double bal = AccountInfoDouble(ACCOUNT_BALANCE);
      double eq = AccountInfoDouble(ACCOUNT_EQUITY);
      double margin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
      double margin_level = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      
      SetText("BalVal", StringFormat("%.2f USD", bal));
      SetText("EqVal", StringFormat("%.2f", eq));
      SetText("MarVal", StringFormat("%.2f", margin));
      SetText("MargPVal", StringFormat("%.1f%%", margin_level));
      
      // 持仓统计
      int buy_count = 0, sell_count = 0;
      double buy_lot = 0, sell_lot = 0;
      double buy_pl = 0, sell_pl = 0;
      
      for(int i = 0; i < (int)PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
         
         int type = (int)PositionGetInteger(POSITION_TYPE);
         double lot = PositionGetDouble(POSITION_VOLUME);
         double pl = PositionGetDouble(POSITION_PROFIT);
         
         if(type == POSITION_TYPE_BUY)
         { buy_count++; buy_lot += lot; buy_pl += pl; }
         else
         { sell_count++; sell_lot += lot; sell_pl += pl; }
      }
      
      SetText("BuyVal", StringFormat("%d单/%.2f手", buy_count, buy_lot));
      SetColor("BuyPL", buy_pl >= 0 ? clrLimeGreen : clrRed);
      SetText("BuyPL", StringFormat("%+.2f", buy_pl));
      
      SetText("SellVal", StringFormat("%d单/%.2f手", sell_count, sell_lot));
      SetColor("SellPL", sell_pl >= 0 ? clrLimeGreen : clrRed);
      SetText("SellPL", StringFormat("%+.2f", sell_pl));
      
      double total_pl = buy_pl + sell_pl;
      double total_lot = buy_lot + sell_lot;
      SetColor("TotalPLVal", total_pl >= 0 ? clrLimeGreen : clrRed);
      SetText("TotalPLVal", StringFormat("%+.2f", total_pl));
      SetText("TotalLots", StringFormat("%.2f手", total_lot));
      
      // 收益
      SetText("TodayVal", StringFormat("%+.2f", g_today_profit));
      SetColor("TodayVal", g_today_profit >= 0 ? clrLimeGreen : clrRed);
      SetText("YestVal", StringFormat("%+.2f", g_yesterday_profit));
      SetColor("YestVal", g_yesterday_profit >= 0 ? clrLimeGreen : clrRed);
      SetText("TotalVal", StringFormat("%+.2f", g_total_profit));
      SetColor("TotalVal", g_total_profit >= 0 ? clrLimeGreen : clrRed);
      
      // 风控
      SetText("RiskFloat", StringFormat("全单浮盈亏: %+.2f", profit));
      SetColor("RiskFloat", profit >= 0 ? clrLimeGreen : clrRed);
      
      // 回撤
      CRiskControl risk;
      risk.UpdatePeakEquity();
      double dd = risk.GetDrawdown();
      SetText("RiskDD", StringFormat("回撤: %.2f / %.2f%%", profit, dd));
      
      // 对冲状态
      string buy_status = "多单";
      string sell_status = "空单";
      if(buy_count >= 2) buy_status = "多单对冲待触发";
      if(sell_count >= 2) sell_status = "空单对冲待触发";
      SetText("HedgeBuy", buy_status);
      SetText("HedgeSell", sell_status);
      
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
   
   // 初始化交易对象
   g_trade.SetExpertMagicNumber(InpMagicNumber);
   g_trade.SetDeviationInPoints(30);
   g_trade.SetTypeFilling(ORDER_FILLING_IOC);
   g_trade.SetAsyncMode(false);
   
   // 初始化各模块
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
   
   // 初始化面板
   if(InpShowPanel)
   {
      g_panel.Create(g_chart_id, 0, "GH", InpPanelX, InpPanelY);
      ChartSetInteger(g_chart_id, CHART_EVENT_MOUSE_MOVE, true);
   }
   
   // 加载历史收益
   LoadProfitHistory();
   
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
   Print("金戈铁马X3D EA 已停止");
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!g_initialized) return;
   
   string symbol = Symbol();
   
   // 检查新K线
   datetime cur_bar = iTime(symbol, PERIOD_CURRENT, 0);
   bool new_bar = (cur_bar != g_last_bar_time);
   if(new_bar) g_last_bar_time = cur_bar;
   
   // 更新收益统计
   UpdateProfitStats();
   
   // 风控检查
   if(g_risk.CheckFloatProtect())
   {
      Print("浮亏全平保护触发！当前浮亏:", AccountInfoDouble(ACCOUNT_PROFIT));
      g_engine.CloseAllPositions(symbol);
      return;
   }
   
   // 尾单对冲检查
   g_hedge.Update(symbol);
   
   // 移动止盈
   double buy_sl = 0, sell_sl = 0;
   g_risk.CheckTrailingStop(symbol, buy_sl, sell_sl);
   if(buy_sl > 0 || sell_sl > 0)
   {
      ModifyAllSL(symbol, buy_sl, sell_sl);
   }
   
   // 获取信号
   int signal = g_signal.GetSignal(symbol);
   
   // 统计当前持仓
   int buy_count = 0, sell_count = 0;
   double buy_lot = 0, sell_lot = 0;
   double last_buy_price = 0, last_sell_price = 0;
   
   for(int i = 0; i < (int)PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      
      int type = (int)PositionGetInteger(POSITION_TYPE);
      double lot = PositionGetDouble(POSITION_VOLUME);
      double price = PositionGetDouble(POSITION_PRICE_OPEN);
      
      if(type == POSITION_TYPE_BUY)
      {
         buy_count++;
         buy_lot += lot;
         if(price > last_buy_price) last_buy_price = price;
      }
      else
      {
         sell_count++;
         sell_lot += lot;
         if(last_sell_price == 0 || price < last_sell_price) last_sell_price = price;
      }
   }
   
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
   
   // 开仓逻辑
   if(signal > 0 && buy_count == 0)  // 开多单
   {
      double lot = GetInitialLot();
      g_engine.OpenPosition(ORDER_TYPE_BUY, lot, InpOpenPeriod * 10, 0, "GH Buy");
      g_engine.ResetLotIndex();
   }
   else if(signal < 0 && sell_count == 0)  // 开空单
   {
      double lot = GetInitialLot();
      g_engine.OpenPosition(ORDER_TYPE_SELL, lot, InpOpenPeriod * 10, 0, "GH Sell");
      g_engine.ResetLotIndex();
   }
   
   // 加仓逻辑
   if(g_engine.CanAddPosition(g_last_add_time) && !g_hedge.BlockAdd())
   {
      if(g_engine.CheckKLineLimit(symbol))
      {
         // 多单加仓
         if(buy_count > 0 && signal > 0)
         {
            double spacing = InpAddSpacing * point;
            if(bid <= last_buy_price - spacing)
            {
               double next_lot = g_engine.GetNextLot(buy_lot / buy_count, buy_count);
               g_engine.OpenPosition(ORDER_TYPE_BUY, next_lot, InpOpenPeriod * 10, 0, "GH Add Buy");
            }
         }
         
         // 空单加仓
         if(sell_count > 0 && signal < 0)
         {
            double spacing = InpAddSpacing * point;
            if(ask >= last_sell_price + spacing)
            {
               double next_lot = g_engine.GetNextLot(sell_lot / sell_count, sell_count);
               g_engine.OpenPosition(ORDER_TYPE_SELL, next_lot, InpOpenPeriod * 10, 0, "GH Add Sell");
            }
         }
      }
   }
   
   // 盈利平仓
   CheckProfitClose(symbol);
   
   // 更新面板
   if(InpShowPanel) g_panel.Update(symbol);
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

void ModifyAllSL(string symbol, double buy_sl, double sell_sl)
{
   for(int i = 0; i < (int)PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      
      int type = (int)PositionGetInteger(POSITION_TYPE);
      double cur_sl = PositionGetDouble(POSITION_SL);
      double new_sl = (type == POSITION_TYPE_BUY) ? buy_sl : sell_sl;
      
      if(new_sl > 0 && MathAbs(new_sl - cur_sl) > SymbolInfoDouble(symbol, SYMBOL_POINT))
      {
         g_trade.PositionModify(ticket, new_sl, PositionGetDouble(POSITION_TP));
      }
   }
}

void CheckProfitClose(string symbol)
{
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
      if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
      
      double lot = PositionGetDouble(POSITION_VOLUME);
      double profit = PositionGetDouble(POSITION_PROFIT);
      double price_open = PositionGetDouble(POSITION_PRICE_OPEN);
      int type = (int)PositionGetInteger(POSITION_TYPE);
      
      // 每0.01手盈利金额
      double target_profit = InpProfitPer001Lot * (lot / 0.01) * InpProfitOptCoeff;
      
      if(profit >= target_profit)
      {
         g_trade.PositionClose(ticket);
         g_total_profit += profit;
         if(profit > 0) g_win_trades++;
      }
   }
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
   g_panel.Update(Symbol());
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
   
   // 统计今日收益
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
