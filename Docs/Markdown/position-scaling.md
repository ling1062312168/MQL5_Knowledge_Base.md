# 加仓模块 — 马丁 / 网格 / 均价位平

---

## 1. 马丁格尔（从你源码提炼）

### 1.1 核心手数管理器

```mql5
//+------------------------------------------------------------------+
//| 马丁格尔手数管理器（从你源码中的实现提炼）                         |
//+------------------------------------------------------------------+
class CMartingaleManager {
private:
   double            m_base_lot;         // 基准手数
   double            m_multiplier;       // 系数（如 2.0）
   int               m_max_lots;         // 最大手数上限
   int               m_max_orders;       // 最大加仓次数
   double            m_lot_step;         // 手数步长
   double            m_min_lot;          // 最小手数

public:
   CMartingaleManager(double base_lot, double multiplier,
                      int max_lots, int max_orders) {
      m_base_lot    = base_lot;
      m_multiplier  = multiplier;
      m_max_lots    = max_lots;
      m_max_orders  = max_orders;
      m_lot_step    = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
      m_min_lot     = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   }

   // 获取下次应开手数（基于当前持仓数量）
   double            GetNextLot(ENUM_POSITION_TYPE type) {
      int count = CountPositionsByType(
          (type == POSITION_TYPE_BUY) ?
          ORDER_TYPE_BUY : ORDER_TYPE_SELL);

      if(count == 0) return m_base_lot;
      if(count >= m_max_orders) return 0;  // 达到上限

      double lot = m_base_lot;
      for(int i = 0; i < count; i++)
         lot *= m_multiplier;

      // 对齐步长
      lot = MathFloor(lot / m_lot_step) * m_lot_step;

      // 不超过上限
      lot = MathMin(lot, (double)m_max_lots);
      return lot;
   }

   // 获取马丁加仓次数（用于显示）
   int               GetMartingaleLevel(ENUM_POSITION_TYPE type) {
      return CountPositionsByType(
          (type == POSITION_TYPE_BUY) ?
          ORDER_TYPE_BUY : ORDER_TYPE_SELL);
   }

   // 获取最大可加仓次数
   int               GetRemainingLevels(ENUM_POSITION_TYPE type) {
      return MathMax(0, m_max_orders -
                     GetMartingaleLevel(type));
   }
};
```

### 1.2 马丁格尔 EA 主逻辑

```mql5
CMartingaleManager *g_mg;

int OnInit() {
   g_mg = new CMartingaleManager(
       g_base_lot, g_multiplier, g_max_lots, g_max_orders);
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
   delete g_mg;
}

void OnTick() {
   // 检查是否需要加仓
   CheckMartingaleAdd();

   // 检查保本
   CheckBreakEven(g_be_trigger_pips);

   // 追踪止损
   CheckTrailingStop(g_trail_pips, g_trail_min_pips);
}

//+------------------------------------------------------------------+
//| 马丁格尔加仓检查（亏损时反向加仓）                                 |
//+------------------------------------------------------------------+
void CheckMartingaleAdd() {
   // === 多仓马丁：亏损时加多 ===
   double longProfit = GetTotalProfit(POSITION_TYPE_BUY);
   if(longProfit < -g_loss_threshold * _Point * g_base_lot * 10) {
      double nextLot = g_mg.GetNextLot(POSITION_TYPE_BUY);
      if(nextLot >= g_min_lot) {
         // 在当前均价下方加多仓
         double avgPrice = GetAveragePrice(POSITION_TYPE_BUY);
         double addPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         double sl = addPrice - g_loss_pips * _Point;
         double tp = addPrice + g_profit_pips * _Point;
         g_trade.Buy(nextLot, _Symbol, 0, sl, tp);
         Print("马丁加多仓: 手数=", nextLot,
               " 当前亏损=", longProfit);
      }
   }

   // === 空仓马丁：亏损时加空 ===
   double shortProfit = GetTotalProfit(POSITION_TYPE_SELL);
   if(shortProfit < -g_loss_threshold * _Point * g_base_lot * 10) {
      double nextLot = g_mg.GetNextLot(POSITION_TYPE_SELL);
      if(nextLot >= g_min_lot) {
         double addPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double sl = addPrice + g_loss_pips * _Point;
         double tp = addPrice - g_profit_pips * _Point;
         g_trade.Sell(nextLot, _Symbol, 0, sl, tp);
         Print("马丁加空仓: 手数=", nextLot,
               " 当前亏损=", shortProfit);
      }
   }
}
```

### 1.3 马丁平仓策略

```mql5
//+------------------------------------------------------------------+
//| 马丁全部平仓（盈利超过阈值时一次性平所有）                          |
//+------------------------------------------------------------------+
void CheckMartingaleCloseAll(double profit_target) {
   double longProfit  = GetTotalProfit(POSITION_TYPE_BUY);
   double shortProfit = GetTotalProfit(POSITION_TYPE_SELL);

   if(longProfit >= profit_target) {
      CloseAllByType(POSITION_TYPE_BUY);
      Print("马丁多仓全部平仓，盈利=", longProfit);
   }
   if(shortProfit >= profit_target) {
      CloseAllByType(POSITION_TYPE_SELL);
      Print("马丁空仓全部平仓，盈利=", shortProfit);
   }
}

//+------------------------------------------------------------------+
//| 马丁分批平仓（逐级收回利润）                                       |
//+------------------------------------------------------------------+
void CheckMartingaleClosePartial(double recover_target) {
   // 多仓：盈利达到 recover_target 后，从最早一单开始逐级平
   int longCount = CountPositionsByType(ORDER_TYPE_BUY);
   if(longCount == 0) return;

   double longProfit = GetTotalProfit(POSITION_TYPE_BUY);
   if(longProfit >= recover_target) {
      // 平掉最早的一单
      ulong oldest = GetOldestTicket(POSITION_TYPE_BUY);
      if(oldest > 0) {
         g_trade.PositionClose(oldest);
         Print("马丁多仓平掉最老一单 #", oldest);
      }
   }
}
```

---

## 2. 网格交易

### 2.1 等距网格

```mql5
//+------------------------------------------------------------------+
//| 等距网格 EA（从你源码中的趋势EA网格逻辑提炼）                       |
//+------------------------------------------------------------------+
struct GridLevel {
   double            price;
   ENUM_ORDER_TYPE   order_type;
   double            lot;
   bool              triggered;
};

GridLevel            g_grid_levels[];
int                  g_grid_count = 0;
double               g_grid_step;       // 网格间距（点数）
double               g_grid_lot;        // 每格手数

//+------------------------------------------------------------------+
//| 初始化网格（在首次入场时调用）                                     |
//+------------------------------------------------------------------+
void InitGrid(double entry_price, int levels,
              double step, double lot) {
   ArrayResize(g_grid_levels, levels * 2 + 1);
   g_grid_count = levels * 2 + 1;
   g_grid_step  = step;
   g_grid_lot   = lot;

   int mid = levels;  // 中间层 = 入场价

   for(int i = 0; i < g_grid_count; i++) {
      g_grid_levels[i].price      = entry_price +
                                    (i - mid) * step * _Point;
      g_grid_levels[i].lot        = lot;
      g_grid_levels[i].triggered  = false;
   }

   Print("网格初始化: 共 ", g_grid_count, " 层",
         " 间距=", step, " 点");
}

//+------------------------------------------------------------------+
//| 检查网格触发（每 Tick 调用）                                       |
//+------------------------------------------------------------------+
void CheckGridTrigger() {
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   for(int i = 0; i < g_grid_count; i++) {
      if(g_grid_levels[i].triggered) continue;

      ENUM_ORDER_TYPE type = g_grid_levels[i].order_type;
      double price = g_grid_levels[i].price;
      double lot   = g_grid_levels[i].lot;

      bool hit = false;
      if(type == ORDER_TYPE_BUY && bid <= price)  hit = true;
      if(type == ORDER_TYPE_SELL && ask >= price) hit = true;

      if(hit) {
         g_grid_levels[i].triggered = true;

         if(type == ORDER_TYPE_BUY)
            g_trade.Buy(lot, _Symbol, 0,
                        price - g_sl_pips * _Point,
                        price + g_tp_pips * _Point);
         else
            g_trade.Sell(lot, _Symbol, 0,
                         price + g_sl_pips * _Point,
                         price - g_tp_pips * _Point);

         Print("网格触发: 第 ", i, " 层",
               " type=", type, " price=", price);
      }
   }
}
```

### 2.2 斐波那契网格

```mql5
//+------------------------------------------------------------------+
//| 斐波那契网格                                                     |
//+------------------------------------------------------------------+
double fibLevels[] = {0.0, 0.236, 0.382, 0.5,
                       0.618, 0.786, 1.0, 1.272, 1.618};

void PlaceFibonacciGrid(double high, double low,
                        double lot, double sl_pips) {
   double range = high - low;
   double tp_mult = 1.5;  // 止盈为区间高度的 1.5 倍

   for(int i = 1; i < ArraySize(fibLevels); i++) {
      double level = high - range * fibLevels[i];

      // 下方挂 Buy Limit
      double tp = level + range * tp_mult * fibLevels[i];
      PlacePending(PENDING_BUY_LIMIT, lot, level,
                   level - sl_pips * _Point, tp);

      // 上方挂 Sell Limit
      tp = level - range * tp_mult * fibLevels[i];
      PlacePending(PENDING_SELL_LIMIT, lot, level,
                   level + sl_pips * _Point, tp);
   }
}
```

---

## 3. 均价位平（从你源码提炼）

### 3.1 计算持仓均价

```mql5
//+------------------------------------------------------------------+
//| 计算某类型持仓的加权平均入场价                                     |
//+------------------------------------------------------------------+
double GetAveragePrice(ENUM_POSITION_TYPE target_type) {
   double totalCost = 0;
   double totalLots = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;

      totalCost += PositionGetDouble(POSITION_PRICE_OPEN) *
                   PositionGetDouble(POSITION_VOLUME);
      totalLots += PositionGetDouble(POSITION_VOLUME);
   }

   return (totalLots > 0) ? (totalCost / totalLots) : 0;
}

//+------------------------------------------------------------------+
//| 按均价平全部持仓                                                 |
//+------------------------------------------------------------------+
bool CloseAllAtAverage(ENUM_POSITION_TYPE target_type,
                       double sl_pips, double tp_pips) {
   double avgPrice = GetAveragePrice(target_type);
   if(avgPrice == 0) return false;

   ENUM_ORDER_TYPE close_type =
       (target_type == POSITION_TYPE_BUY) ?
       ORDER_TYPE_SELL : ORDER_TYPE_BUY;
   double close_price =
       (target_type == POSITION_TYPE_BUY) ?
       SymbolInfoDouble(_Symbol, SYMBOL_BID) :
       SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   // 统计总手数
   double totalLots = 0;
   ulong  tickets[];
   int    count = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;

      ArrayResize(tickets, count + 1);
      tickets[count] = ticket;
      count++;
      totalLots += PositionGetDouble(POSITION_VOLUME);
   }

   if(count == 0) return false;

   // 用反向开仓一次性平掉全部
   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};

   request.action       = TRADE_ACTION_DEAL;
   request.symbol       = _Symbol;
   request.volume       = totalLots;
   request.type         = close_type;
   request.price        = close_price;
   request.sl           = NormalizeDouble(
       avgPrice - sl_pips * _Point, _Digits);
   request.tp           = NormalizeDouble(
       avgPrice + tp_pips * _Point, _Digits);
   request.deviation    = 10;
   request.position     = tickets[0];  // 用第一个持仓做 reference
   request.type_filling = ORDER_FILLING_FOK;

   bool ok = OrderSend(request, result);

   // 如果失败，逐个平仓
   if(!ok || result.retcode != TRADE_RETCODE_DONE) {
      for(int i = 0; i < count; i++)
         g_trade.PositionClose(tickets[i]);
   }

   return true;
}

//+------------------------------------------------------------------+
//| 按均价平部分手数                                                  |
//+------------------------------------------------------------------+
bool ClosePartialAtAverage(ENUM_POSITION_TYPE target_type,
                           double lots) {
   double avgPrice = GetAveragePrice(target_type);
   if(avgPrice == 0) return false;

   // 遍历持仓，从小到大平
   double remain = NormalizeDouble(lots, 2);
   int total = (int)PositionsTotal();

   for(int i = total - 1; i >= 0 && remain > 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;

      double posLots = PositionGetDouble(POSITION_VOLUME);
      double closeVol = MathMin(remain, posLots);

      g_trade.PositionClose(ticket, closeVol);
      remain -= closeVol;
   }
   return true;
}
```

---

## 4. 加仓手数管理（固定递增）

```mql5
//+------------------------------------------------------------------+
//| 固定递增手数：每次加仓手数 = base_lot + n * step_lot              |
//+------------------------------------------------------------------+
double GetLinearIncreaseLot(ENUM_POSITION_TYPE type,
                            double base_lot,
                            double step_lot) {
   int count = CountPositionsByType(
       (type == POSITION_TYPE_BUY) ?
       ORDER_TYPE_BUY : ORDER_TYPE_SELL);
   return NormalizeDouble(base_lot + count * step_lot, 2);
}

//+------------------------------------------------------------------+
//| 动态比例手数：根据账户余额计算                                     |
//+------------------------------------------------------------------+
double GetRiskBasedLot(double risk_percent) {
   double balance    = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = balance * risk_percent / 100.0;
   double slPips     = g_default_sl_pips;

   // 每点价值（粗略估算，1 标准手 = 10 USD/点 for EURUSD）
   double pipValue   = 10.0;
   double lot        = riskAmount / (slPips * pipValue);

   // 对齐步长
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   lot = MathFloor(lot / step) * step;

   // 限制范围
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   lot = MathMax(lot, minLot);
   lot = MathMin(lot, maxLot);

   return lot;
}
```
