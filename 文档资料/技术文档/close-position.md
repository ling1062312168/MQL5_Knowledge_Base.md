# 平仓模块 — 全平 / 部分 / 异步 / 策略

---

## 1. 全平仓

### 1.1 按持仓类型全平（多仓或空仓）

```mql5
//+------------------------------------------------------------------+
//| 平掉所有多仓或所有空仓                                           |
//+------------------------------------------------------------------+
int CloseAllByType(ENUM_POSITION_TYPE target_type) {
   int closed = 0;
   int total  = (int)PositionsTotal();

   for(int i = total - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;

      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;

      double vol = PositionGetDouble(POSITION_VOLUME);
      string sym = PositionGetString(POSITION_SYMBOL);

      // 反向开仓平仓
      ENUM_ORDER_TYPE close_type =
          (target_type == POSITION_TYPE_BUY) ?
          ORDER_TYPE_SELL : ORDER_TYPE_BUY;
      double close_price =
          (target_type == POSITION_TYPE_BUY) ?
          SymbolInfoDouble(sym, SYMBOL_BID) :
          SymbolInfoDouble(sym, SYMBOL_ASK);

      MqlTradeRequest request = {};
      MqlTradeResult  result  = {};

      request.action       = TRADE_ACTION_DEAL;
      request.symbol       = sym;
      request.volume       = vol;
      request.type         = close_type;
      request.price        = close_price;
      request.deviation    = 10;
      request.position     = ticket;
      request.type_filling = ORDER_FILLING_FOK;
      request.comment      = "CloseAll";

      if(OrderSend(request, result) &&
         (result.retcode == TRADE_RETCODE_DONE ||
          result.retcode == TRADE_RETCODE_PLACED))
         closed++;
   }
   return closed;
}
```

### 1.2 使用 CTrade 平仓

```mql5
#include <Trade\Trade.mqh>
CTrade   g_trade;

int CloseAllByType_CTrade(ENUM_POSITION_TYPE target_type) {
   int closed = 0;
   int total  = (int)PositionsTotal();

   for(int i = total - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;

      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;

      if(g_trade.PositionClose(ticket))
         closed++;
      else
         Print("PositionClose 失败 #", ticket, ": ",
               g_trade.ResultRetcodeDescription());
   }
   return closed;
}
```

---

## 2. 部分平仓

### 2.1 按固定手数平仓（从你源码提炼）

```mql5
//+------------------------------------------------------------------+
//| 按固定手数平仓（从最大持仓单开始平）                               |
//+------------------------------------------------------------------+
bool CloseByFixedLots(ENUM_POSITION_TYPE target_type,
                      double lots_to_close) {
   int lotDigits = (int)SymbolInfoInteger(_Symbol,
                           SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double step   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   int total = (int)PositionsTotal();
   for(int i = total - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;

      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;

      double posLots = PositionGetDouble(POSITION_VOLUME);
      if(posLots <= 0) continue;

      // 平掉 min(要平手数, 剩余手数)
      double closeVol = MathMin(lots_to_close, posLots);
      closeVol = NormalizeDouble(closeVol, lotDigits);
      closeVol = MathMax(closeVol, minLot);

      // 对齐到步长
      closeVol = MathFloor(closeVol / step) * step;

      if(closeVol < minLot) continue;

      bool ok = g_trade.PositionClose(ticket, closeVol);
      if(ok)
         lots_to_close -= closeVol;

      if(lots_to_close <= 0) break;
   }
   return true;
}
```

### 2.2 按百分比平仓（从你源码提炼）

```mql5
//+------------------------------------------------------------------+
//| 按百分比平仓                                                     |
//+------------------------------------------------------------------+
bool CloseByPercent(ENUM_POSITION_TYPE target_type,
                    double percent) {
   if(percent <= 0 || percent > 100) return false;

   int total = (int)PositionsTotal();
   for(int i = total - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;

      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;

      double posLots = PositionGetDouble(POSITION_VOLUME);
      double closeLots = NormalizeDouble(
          posLots * percent / 100.0, 2);

      if(closeLots < SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN))
         continue;

      g_trade.PositionClose(ticket, closeLots);
   }
   return true;
}
```

### 2.3 按均价顺序平仓（从你源码提炼）

```mql5
//+------------------------------------------------------------------+
//| 按开仓价排序平仓：多仓从高到低，空仓从低到高                        |
//+------------------------------------------------------------------+
struct OrderEntry {
   ulong  ticket;
   double openPrice;
   double lots;
};

bool CloseByOrder(ENUM_POSITION_TYPE target_type,
                  double total_lots, bool reverse) {
   int lotDigits = (int)SymbolInfoInteger(_Symbol,
                           SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double remain = NormalizeDouble(total_lots, lotDigits);

   // 收集所有符合条件的持仓
   int count = 0;
   int total = (int)PositionsTotal();
   for(int i = 0; i < total; i++) {
      ulong t = PositionGetTicket(i);
      if(!IsMyPosition(t)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;
      count++;
   }
   if(count == 0) return false;

   OrderEntry entries[];
   ArrayResize(entries, count);
   count = 0;

   for(int i = 0; i < total; i++) {
      ulong t = PositionGetTicket(i);
      if(!IsMyPosition(t)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;
      entries[count].ticket    = t;
      entries[count].openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      entries[count].lots      = PositionGetDouble(POSITION_VOLUME);
      count++;
   }

   // 排序：多仓高→低，空仓低→高
   for(int i = 0; i < count - 1; i++) {
      for(int j = i + 1; j < count; j++) {
         bool needSwap = false;
         if(target_type == POSITION_TYPE_BUY) {
            needSwap = reverse ?
                (entries[i].openPrice < entries[j].openPrice) :
                (entries[i].openPrice > entries[j].openPrice);
         } else {
            needSwap = reverse ?
                (entries[i].openPrice > entries[j].openPrice) :
                (entries[i].openPrice < entries[j].openPrice);
         }
         if(needSwap) {
            OrderEntry tmp = entries[i];
            entries[i]     = entries[j];
            entries[j]     = tmp;
         }
      }
   }

   // 按顺序平仓
   for(int k = 0; k < count && remain > 0; k++) {
      if(!PositionSelectByTicket(entries[k].ticket)) continue;

      double closeVol = MathMin(remain, entries[k].lots);
      closeVol = NormalizeDouble(closeVol, lotDigits);

      if(closeVol >= minLot) {
         if(g_trade.PositionClose(entries[k].ticket, closeVol))
            remain -= closeVol;
      }
   }
   return true;
}
```

---

## 3. 异步批量平仓（从你源码提炼）

这是你源码里非常实用的一个模式——当持仓很多时（几十上百单），一次性平仓会被经纪商拒绝，需要分批异步平仓：

```mql5
//+------------------------------------------------------------------+
//| 异步批量平仓状态机（从你源码中的 StartAsyncClosingOrders 提炼）     |
//+------------------------------------------------------------------+
struct CloseTask {
   ulong  positionTicket;
   double remainingLots;
   string symbol;
};

CloseTask  g_closeTasks[];
int        g_closeTaskCount  = 0;
bool       g_isAsyncClosing  = false;
ENUM_ORDER_TYPE g_asyncCloseOrderType;
int        g_asyncCloseInitialCount = 0;
datetime   g_asyncCloseStartTime = 0;
CTrade     g_asyncTrade;

void StartAsyncClosingOrders(ENUM_ORDER_TYPE orderType) {
   if(g_isAsyncClosing) {
      Print("异步平仓中，请等待...");
      return;
   }

   // 统计实际持仓数
   int currentPositions = CountPositionsByType(orderType);
   if(currentPositions == 0) {
      Print("异步平仓：当前没有持仓");
      return;
   }

   g_asyncCloseOrderType    = orderType;
   g_asyncCloseInitialCount = currentPositions;
   g_isAsyncClosing         = true;
   g_asyncCloseStartTime    = TimeCurrent();

   // 初始化异步交易对象
   g_asyncTrade.SetExpertMagicNumber(g_magic);
   g_asyncTrade.SetDeviationInPoints(10);
   g_asyncTrade.SetAsyncMode(true);   // 开启异步模式
   ENUM_ORDER_TYPE_FILLING filling =
       (ENUM_ORDER_TYPE_FILLING)SymbolInfoInteger(_Symbol,
       SYMBOL_FILLING_MODE);
   g_asyncTrade.SetTypeFilling(filling);

   // 收集所有持仓到任务队列
   ArrayResize(g_closeTasks, 0);
   g_closeTaskCount = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;

      ENUM_POSITION_TYPE ptype =
          (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      ENUM_POSITION_TYPE target =
          (orderType == ORDER_TYPE_BUY) ?
          POSITION_TYPE_BUY : POSITION_TYPE_SELL;

      if(ptype != target) continue;

      int idx = g_closeTaskCount;
      ArrayResize(g_closeTasks, idx + 1);
      g_closeTasks[idx].positionTicket = ticket;
      g_closeTasks[idx].remainingLots  =
          PositionGetDouble(POSITION_VOLUME);
      g_closeTasks[idx].symbol         = _Symbol;
      g_closeTaskCount++;
   }

   Print("异步平仓启动: ", orderType,
         " 当前持仓=", currentPositions, " 单");
}

//+------------------------------------------------------------------+
//| 每 Tick 继续执行平仓（直到全部平完）                               |
//+------------------------------------------------------------------+
void ContinueAsyncClosingOrders() {
   if(!g_isAsyncClosing) return;

   // 检测是否已全部平完
   int current = CountPositionsByType(g_asyncCloseOrderType);
   if(current == 0) {
      int timeUsed = (int)(TimeCurrent() - g_asyncCloseStartTime);
      Print("异步平仓完成，共平 ",
            g_asyncCloseInitialCount, " 单，耗时 ",
            timeUsed, " 秒");
      g_isAsyncClosing = false;
      return;
   }

   // 每 Tick 最多平 N 单（避免请求过多）
   int batchSize = MathMin(current, 10);
   int sent = 0;

   for(int i = g_closeTaskCount - 1; i >= 0 && sent < batchSize; i--) {
      if(!PositionSelectByTicket(g_closeTasks[i].positionTicket)) {
         // 持仓已被平，移除
         if(i != g_closeTaskCount - 1)
            g_closeTasks[i] = g_closeTasks[g_closeTaskCount - 1];
         g_closeTaskCount--;
         ArrayResize(g_closeTasks, g_closeTaskCount);
         continue;
      }

      double curVol = PositionGetDouble(POSITION_VOLUME);
      g_closeTasks[i].remainingLots = curVol;

      double closeVol = MathFloor(curVol / g_lotStep) * g_lotStep;
      if(closeVol < g_minLot) {
         if(i != g_closeTaskCount - 1)
            g_closeTasks[i] = g_closeTasks[g_closeTaskCount - 1];
         g_closeTaskCount--;
         ArrayResize(g_closeTasks, g_closeTaskCount);
         continue;
      }

      bool ok = g_asyncTrade.PositionClose(
          g_closeTasks[i].positionTicket);

      if(ok)
         sent++;
   }
}

//+------------------------------------------------------------------+
//| OnTick 中调用                                                    |
//+------------------------------------------------------------------+
void OnTick() {
   if(g_isAsyncClosing)
      ContinueAsyncClosingOrders();

   // ... 其他交易逻辑
}
```

---

## 4. 平仓盈亏预估（从你源码提炼）

在面板按钮上实时显示点击后能获得多少盈亏：

```mql5
//+------------------------------------------------------------------+
//| 计算某类型持仓的总盈亏（含 Swap）                                  |
//+------------------------------------------------------------------+
double GetTotalProfit(ENUM_POSITION_TYPE target_type) {
   double total = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;
      total += PositionGetDouble(POSITION_PROFIT)
             + PositionGetDouble(POSITION_SWAP);
   }
   return total;
}

//+------------------------------------------------------------------+
//| 计算平仓后的预估盈亏（百分比）                                     |
//+------------------------------------------------------------------+
double CalcCloseProfit(ENUM_POSITION_TYPE target_type,
                       double percent) {
   if(percent <= 0 || percent > 100) return 0;
   return GetTotalProfit(target_type) * percent / 100.0;
}

//+------------------------------------------------------------------+
//| 计算平仓后的预估盈亏（固定手数）                                   |
//+------------------------------------------------------------------+
double CalcCloseProfitByLots(ENUM_POSITION_TYPE target_type,
                              double lots) {
   if(lots <= 0) return 0;

   int lotDigits = (int)SymbolInfoInteger(_Symbol,
                           SYMBOL_VOLUME_STEP);
   double profit = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;

      double posLots = PositionGetDouble(POSITION_VOLUME);
      double closeLots = NormalizeDouble(
          MathMin(lots, posLots), lotDigits);

      double totalPnl = PositionGetDouble(POSITION_PROFIT)
                      + PositionGetDouble(POSITION_SWAP);
      if(posLots > 0)
         profit += totalPnl * (closeLots / posLots);
   }
   return profit;
}
```

---

## 5. 平仓策略

### 5.1 保本（Break Even）

```mql5
//+------------------------------------------------------------------+
//| 保本单：当盈利达到 trigger_pips 时，将 SL 移到入场价                |
//+------------------------------------------------------------------+
void CheckBreakEven(double trigger_pips) {
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;

      double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl        = PositionGetDouble(POSITION_SL);
      double tp        = PositionGetDouble(POSITION_TP);
      double vol       = PositionGetDouble(POSITION_VOLUME);
      ENUM_POSITION_TYPE ptype =
          (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

      double profitPoints = (ptype == POSITION_TYPE_BUY) ?
          (SymbolInfoDouble(_Symbol, SYMBOL_BID) - openPrice)
          / _Point :
          (openPrice - SymbolInfoDouble(_Symbol, SYMBOL_ASK))
          / _Point;

      // 盈利达到触发值，且 SL 未到入场价
      if(profitPoints >= trigger_pips) {
         double new_sl = NormalizeDouble(openPrice, _Digits);
         // 多仓：SL 不能低于现价；空仓：SL 不能高于现价
         if(ptype == POSITION_TYPE_BUY) {
            double curBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            if(new_sl < curBid - trigger_pips * _Point)
               new_sl = curBid - trigger_pips * _Point;
         } else {
            double curAsk = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            if(new_sl > curAsk + trigger_pips * _Point)
               new_sl = curAsk + trigger_pips * _Point;
         }

         if(new_sl != sl) {
            g_trade.PositionModify(ticket, new_sl, tp);
         }
      }
   }
}
```

### 5.2 追踪止损（Trailing Stop）

```mql5
//+------------------------------------------------------------------+
//| 追踪止损：盈利回撤超过 trail_pips 时平仓                           |
//+------------------------------------------------------------------+
void CheckTrailingStop(double trail_pips,
                       double minProfit_pips) {
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;

      double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double curSL     = PositionGetDouble(POSITION_SL);
      ENUM_POSITION_TYPE ptype =
          (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

      double curPrice = (ptype == POSITION_TYPE_BUY) ?
          SymbolInfoDouble(_Symbol, SYMBOL_BID) :
          SymbolInfoDouble(_Symbol, SYMBOL_ASK);

      double profitPips = (ptype == POSITION_TYPE_BUY) ?
          (curPrice - openPrice) / _Point :
          (openPrice - curPrice) / _Point;

      if(profitPips < minProfit_pips) continue; // 未达到最小盈利

      double new_sl;
      if(ptype == POSITION_TYPE_BUY) {
         new_sl = curPrice - trail_pips * _Point;
         // 只上移 SL，不下移
         if(new_sl > curSL || curSL == 0)
            g_trade.PositionModify(ticket, new_sl, 0);
      } else {
         new_sl = curPrice + trail_pips * _Point;
         if(new_sl < curSL || curSL == 0)
            g_trade.PositionModify(ticket, new_sl, 0);
      }
   }
}
```

### 5.3 全品种全平

```mql5
//+------------------------------------------------------------------+
//| 平掉所有品种所有持仓                                             |
//+------------------------------------------------------------------+
void CloseEverything() {
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket)) {
         g_trade.PositionClose(ticket);
      }
   }
   // 删除所有挂单
   for(int i = OrdersTotal() - 1; i >= 0; i--) {
      ulong ticket = OrderGetTicket(i);
      if(OrderSelect(ticket))
         g_trade.OrderDelete(ticket);
   }
}
```

---

## 6. MQL4 平仓差异

| 差异项 | MQL5 | MQL4 |
|--------|------|------|
| 部分平仓 | `CTrade.PositionClose(ticket, lots)` | `OrderClose(ticket, lots, price, slippage, color)` |
| 反向平仓 | 用 `TRADE_ACTION_DEAL` + `request.position` | `OrderClose`（不支持 position 字段） |
| 异步平仓 | `SetAsyncMode(true)` | 不支持，需自行分批 |
| 保本/追踪 | `PositionModify` | `OrderModify(ticket, price, sl, tp, expiration, color)` |
