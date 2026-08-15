# 对冲模块 — 基础对冲 / 半自动对冲 / 统计

---

## 1. 基础对冲（多空同时开仓锁定）

### 1.1 同时开多空（开仓即锁）

```mql5
//+------------------------------------------------------------------+
//| 同时开多仓和空仓（对冲锁仓）                                       |
//+------------------------------------------------------------------+
void OpenHedge(double lots) {
   double price_buy  = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double price_sell = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   // 先开空仓（做空锁定）
   g_trade.Sell(lots, _Symbol, 0,
                price_sell + g_sl_pips * _Point,
                price_sell - g_tp_pips * _Point);

   // 再开多仓（做多锁定）
   g_trade.Buy(lots, _Symbol, 0,
               price_buy - g_sl_pips * _Point,
               price_buy + g_tp_pips * _Point);

   Print("对冲开仓: 多=", lots, " 空=", lots);
}

//+------------------------------------------------------------------+
//| 解锁：平掉盈利方向，留下亏损方向                                   |
//+------------------------------------------------------------------+
void UnlockHedge() {
   double longProfit  = GetTotalProfit(POSITION_TYPE_BUY);
   double shortProfit = GetTotalProfit(POSITION_TYPE_SELL);

   // 如果多仓盈利，空仓亏损 → 平多仓解锁
   if(longProfit > 0 && shortProfit < 0) {
      int closed = CloseAllByType(POSITION_TYPE_BUY);
      Print("解锁: 平多仓 ", closed, " 单，盈利=", longProfit);
   }
   // 如果空仓盈利，多仓亏损 → 平空仓解锁
   else if(shortProfit > 0 && longProfit < 0) {
      int closed = CloseAllByType(POSITION_TYPE_SELL);
      Print("解锁: 平空仓 ", closed, " 单，盈利=", shortProfit);
   }
   // 两边都盈利 → 全平（直接获利了结）
   else if(longProfit > 0 && shortProfit > 0) {
      CloseAllByType(POSITION_TYPE_BUY);
      CloseAllByType(POSITION_TYPE_SELL);
      Print("对冲全平: 多盈=", longProfit,
            " 空盈=", shortProfit);
   }
   // 两边都亏损 → 保持锁仓
   else {
      Print("对冲双亏，保持锁仓: 多亏=", longProfit,
            " 空亏=", shortProfit);
   }
}
```

---

## 2. 半自动对冲（从你源码提炼）

这是你源码里最实用的模式：**手动开单 → EA 自动识别并对冲**：

### 2.1 核心状态机

```mql5
//+------------------------------------------------------------------+
//| 半自动对冲状态机（从你源码提炼）                                   |
//+------------------------------------------------------------------+
struct HedgeState {
   bool               is_hedging;      // 是否处于对冲模式
   ulong              primary_ticket;  // 主动单 Ticket
   ENUM_POSITION_TYPE primary_type;    // 主动单方向
   ulong              hedge_ticket;    // 对冲单 Ticket
   double             primary_lots;    // 主动单手数
   double             hedge_lots;      // 对冲单手数
   double             trigger_pips;    // 触发对冲的盈利点数
};

HedgeState  g_hedge;

//+------------------------------------------------------------------+
//| 初始化参数                                                       |
//+------------------------------------------------------------------+
input double   HedgeTriggerPips  = 30;    // 盈利超过多少点触发对冲
input double   HedgeLotsRatio    = 1.0;   // 对冲单手数 = 主动单 × 此系数
input bool     AutoUnlock        = true;  // 是否自动解锁

//+------------------------------------------------------------------+
//| 检查是否需要对冲                                                 |
//+------------------------------------------------------------------+
void CheckHedgeTrigger() {
   if(g_hedge.is_hedging) return;  // 已在对冲中

   // 遍历所有持仓，找主动单（过滤本 EA 的对冲单）
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;

      ENUM_POSITION_TYPE ptype =
          (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double curPrice  = (ptype == POSITION_TYPE_BUY) ?
          SymbolInfoDouble(_Symbol, SYMBOL_BID) :
          SymbolInfoDouble(_Symbol, SYMBOL_ASK);

      double profitPips = (ptype == POSITION_TYPE_BUY) ?
          (curPrice - openPrice) / _Point :
          (openPrice - curPrice) / _Point;

      // 盈利达到触发条件
      if(profitPips >= HedgeTriggerPips) {
         // 找到对应的对冲单（同一品种、同一手数）
         ulong hedgeTicket = FindHedgePosition(ticket, ptype);
         if(hedgeTicket == 0) {
            // 开对冲单
            OpenHedgeForTicket(ticket);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 为指定主动单开对冲单                                             |
//+------------------------------------------------------------------+
void OpenHedgeForTicket(ulong primary_ticket) {
   if(!PositionSelectByTicket(primary_ticket)) return;

   string sym     = PositionGetString(POSITION_SYMBOL);
   double pLots   = PositionGetDouble(POSITION_VOLUME);
   ENUM_POSITION_TYPE ptype =
       (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

   // 对冲单方向相反
   ENUM_POSITION_TYPE htype =
       (ptype == POSITION_TYPE_BUY) ?
       POSITION_TYPE_SELL : POSITION_TYPE_BUY;

   double hedgeLots = NormalizeDouble(pLots * HedgeLotsRatio, 2);
   double price = (htype == POSITION_TYPE_BUY) ?
       SymbolInfoDouble(sym, SYMBOL_ASK) :
       SymbolInfoDouble(sym, SYMBOL_BID);

   ulong hedgeTicket = 0;
   if(htype == POSITION_TYPE_BUY)
      hedgeTicket = g_trade.Buy(hedgeLots, sym, 0, 0, 0);
   else
      hedgeTicket = g_trade.Sell(hedgeLots, sym, 0, 0, 0);

   // 记录状态
   g_hedge.is_hedging   = true;
   g_hedge.primary_ticket = primary_ticket;
   g_hedge.primary_type   = ptype;
   g_hedge.hedge_ticket   = hedgeTicket;
   g_hedge.primary_lots   = pLots;
   g_hedge.hedge_lots     = hedgeLots;

   Print("开对冲单: 主动单=#", primary_ticket,
         " 对冲单=#", hedgeTicket,
         " 对冲手数=", hedgeLots);
}

//+------------------------------------------------------------------+
//| 查找已有的对冲单                                                 |
//+------------------------------------------------------------------+
ulong FindHedgePosition(ulong primary_ticket,
                        ENUM_POSITION_TYPE primary_type) {
   ENUM_POSITION_TYPE hedge_type =
       (primary_type == POSITION_TYPE_BUY) ?
       POSITION_TYPE_SELL : POSITION_TYPE_BUY;

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != hedge_type) continue;
      // 可扩展：检查手数匹配关系
      return ticket;
   }
   return 0;
}

//+------------------------------------------------------------------+
//| 检查是否需要解锁                                                 |
//+------------------------------------------------------------------+
void CheckHedgeUnlock() {
   if(!g_hedge.is_hedging) return;

   // 检查主动单是否还存在
   if(!PositionSelectByTicket(g_hedge.primary_ticket)) {
      // 主动单已平，平掉对冲单
      if(PositionSelectByTicket(g_hedge.hedge_ticket)) {
         g_trade.PositionClose(g_hedge.hedge_ticket);
         Print("主动单已平，平掉对冲单 #", g_hedge.hedge_ticket);
      }
      ResetHedgeState();
      return;
   }

   // 自动解锁：当对冲单盈利达到阈值时平掉
   if(AutoUnlock) {
      double hedgeProfit = PositionGetDouble(POSITION_PROFIT) +
                           PositionGetDouble(POSITION_SWAP);
      if(hedgeProfit >= g_unlock_profit) {
         g_trade.PositionClose(g_hedge.hedge_ticket);
         Print("解锁: 平对冲单，盈利=", hedgeProfit);
         ResetHedgeState();
      }
   }
}

//+------------------------------------------------------------------+
//| 重置对冲状态                                                     |
//+------------------------------------------------------------------+
void ResetHedgeState() {
   g_hedge.is_hedging    = false;
   g_hedge.primary_ticket = 0;
   g_hedge.hedge_ticket   = 0;
   g_hedge.primary_lots   = 0;
   g_hedge.hedge_lots     = 0;
}
```

---

## 3. 对冲统计（从你源码提炼）

### 3.1 对冲状态面板数据

```mql5
//+------------------------------------------------------------------+
//| 对冲统计信息结构                                                  |
//+------------------------------------------------------------------+
struct HedgeStats {
   int               long_count;
   double            long_lots;
   double            long_profit;
   int               short_count;
   double            short_lots;
   double            short_profit;
   bool              is_locked;        // 是否锁仓（多空都有持仓）
   double            net_profit;       // 净盈亏
   double            lock_distance;    // 锁仓价差（点数）
};

HedgeStats GetHedgeStats() {
   HedgeStats s = {};
   s.is_locked = false;

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(!IsMyPosition(ticket)) continue;

      ENUM_POSITION_TYPE ptype =
          (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

      if(ptype == POSITION_TYPE_BUY) {
         s.long_count++;
         s.long_lots += PositionGetDouble(POSITION_VOLUME);
         s.long_profit += PositionGetDouble(POSITION_PROFIT)
                        + PositionGetDouble(POSITION_SWAP);
      } else {
         s.short_count++;
         s.short_lots += PositionGetDouble(POSITION_VOLUME);
         s.short_profit += PositionGetDouble(POSITION_PROFIT)
                          + PositionGetDouble(POSITION_SWAP);
      }
   }

   s.is_locked  = (s.long_count > 0 && s.short_count > 0);
   s.net_profit = s.long_profit + s.short_profit;

   // 计算锁仓价差
   if(s.is_locked) {
      double longAvg  = GetAveragePrice(POSITION_TYPE_BUY);
      double shortAvg = GetAveragePrice(POSITION_TYPE_SELL);
      s.lock_distance = MathAbs(longAvg - shortAvg) / _Point;
   }

   return s;
}

//+------------------------------------------------------------------+
//| 在面板上显示对冲状态（从你源码中的 UpdatePanel 提炼）              |
//+------------------------------------------------------------------+
void UpdateHedgeDisplay() {
   HedgeStats s = GetHedgeStats();

   string txt;

   // 多仓状态
   txt = StringFormat("Long: %.2f lots × %d  P/L: %+.2f",
                      s.long_lots, s.long_count, s.long_profit);
   ObjectSetString(0, PREFIX + "LongLabel", OBJPROP_TEXT, txt);
   ObjectSetInteger(0, PREFIX + "LongLabel", OBJPROP_COLOR,
                    s.long_profit >= 0 ? CLR_GREEN : CLR_RED);

   // 空仓状态
   txt = StringFormat("Short: %.2f lots × %d  P/L: %+.2f",
                      s.short_lots, s.short_count, s.short_profit);
   ObjectSetString(0, PREFIX + "ShortLabel", OBJPROP_TEXT, txt);
   ObjectSetInteger(0, PREFIX + "ShortLabel", OBJPROP_COLOR,
                    s.short_profit >= 0 ? CLR_GREEN : CLR_RED);

   // 锁仓提示
   if(s.is_locked) {
      string lockTxt = StringFormat(
          "锁仓中 | 价差: %.0f 点 | 净盈亏: %+.2f",
          s.lock_distance, s.net_profit);
      ObjectSetString(0, PREFIX + "LockLabel", OBJPROP_TEXT, lockTxt);
      ObjectSetInteger(0, PREFIX + "LockLabel", OBJPROP_COLOR,
                       s.net_profit >= 0 ? CLR_YELLOW : CLR_RED);
   } else {
      ObjectSetString(0, PREFIX + "LockLabel", OBJPROP_TEXT,
                      "未锁仓");
      ObjectSetInteger(0, PREFIX + "LockLabel", OBJPROP_COLOR,
                       CLR_TEXT_DIM);
   }
}
```

---

## 4. MQL4 对冲差异

| 差异项 | MQL5 | MQL4 |
|--------|------|------|
| 多空同时开仓 | 两次 `Buy/Sell` 调用 | 两次 `OrderSend(Symbol(), OP_BUY/OP_SELL, ...)` |
| 持仓遍历 | `PositionsTotal()` + `PositionGet*` | `OrdersTotal()` + `OrderSelect()` + 全局变量 |
| 对冲解锁 | `PositionClose` | `OrderClose(ticket, lots, price, slip, color)` |
