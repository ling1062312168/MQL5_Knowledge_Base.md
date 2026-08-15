# 开仓模块 — 基础开仓 / 挂单 / 持仓过滤

---

## 1. 基础开仓（CTrade 推荐写法）

### 1.1 最简洁的开仓模板

```mql5
#include <Trade\Trade.mqh>
CTrade   g_trade;

//+------------------------------------------------------------------+
void SetTradeParams(ulong magic) {
   g_trade.SetExpertMagicNumber(magic);
   g_trade.SetDeviationInPoints(10);
   // 自动检测订单执行模式
   ENUM_ORDER_TYPE_FILLING filling =
       (ENUM_ORDER_TYPE_FILLING)SymbolInfoInteger(_Symbol, SYMBOL_FILLING_MODE);
   g_trade.SetTypeFilling(filling);
}

//+------------------------------------------------------------------+
//| 开多仓                                                          |
//+------------------------------------------------------------------+
bool OpenBuy(double lots, double sl_pips, double tp_pips) {
   double price     = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double sl        = sl_pips > 0 ? price - sl_pips * _Point : 0;
   double tp        = tp_pips > 0 ? price + tp_pips * _Point : 0;
   double sl_price  = NormalizeDouble(sl, _Digits);
   double tp_price  = NormalizeDouble(tp, _Digits);

   bool result = g_trade.Buy(lots, _Symbol, 0, sl_price, tp_price);
   if(!result)
      Print("Buy 失败: ", g_trade.ResultRetcodeDescription());
   else
      Print("Buy 开仓成功, Ticket=#", g_trade.ResultOrder(),
            " 手数=", lots);
   return result;
}

//+------------------------------------------------------------------+
//| 开空仓                                                          |
//+------------------------------------------------------------------+
bool OpenSell(double lots, double sl_pips, double tp_pips) {
   double price     = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl        = sl_pips > 0 ? price + sl_pips * _Point : 0;
   double tp        = tp_pips > 0 ? price - tp_pips * _Point : 0;
   double sl_price  = NormalizeDouble(sl, _Digits);
   double tp_price  = NormalizeDouble(tp, _Digits);

   bool result = g_trade.Sell(lots, _Symbol, 0, sl_price, tp_price);
   if(!result)
      Print("Sell 失败: ", g_trade.ResultRetcodeDescription());
   else
      Print("Sell 开仓成功, Ticket=#", g_trade.ResultOrder(),
            " 手数=", lots);
   return result;
}
```

### 1.2 低级 API（原生 OrderSend）

```mql5
//+------------------------------------------------------------------+
//| 原生 OrderSend 开仓（适合需要精确控制的场景）                      |
//+------------------------------------------------------------------+
bool OrderSendBuy(double volume, double price,
                  double sl, double tp) {
   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};

   request.action       = TRADE_ACTION_DEAL;
   request.symbol       = _Symbol;
   request.volume       = volume;
   request.type         = ORDER_TYPE_BUY;
   request.price        = price;
   request.sl           = sl;
   request.tp           = tp;
   request.deviation    = 10;
   request.magic        = g_magic;
   request.comment      = "EA Buy";
   request.type_filling = ORDER_FILLING_FOK;

   if(!OrderSend(request, result))
      return false;

   if(result.retcode != TRADE_RETCODE_DONE &&
      result.retcode != TRADE_RETCODE_PLACED) {
      Print("OrderSend 失败: retcode=", result.retcode,
            " (", result.comment, ")");
      return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| 平仓（反向开仓法）                                               |
//+------------------------------------------------------------------+
bool CloseByReverse(ulong ticket) {
   if(!PositionSelectByTicket(ticket)) return false;

   double volume = PositionGetDouble(POSITION_VOLUME);
   string symbol = PositionGetString(POSITION_SYMBOL);
   ENUM_POSITION_TYPE type =
       (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};

   request.action       = TRADE_ACTION_DEAL;
   request.symbol       = symbol;
   request.volume       = volume;
   request.type         = (type == POSITION_TYPE_BUY) ?
                           ORDER_TYPE_SELL : ORDER_TYPE_BUY;
   request.price        = (type == POSITION_TYPE_BUY) ?
                           SymbolInfoDouble(symbol, SYMBOL_BID) :
                           SymbolInfoDouble(symbol, SYMBOL_ASK);
   request.deviation    = 10;
   request.position     = ticket;
   request.type_filling = ORDER_FILLING_FOK;

   return OrderSend(request, result);
}
```

---

## 2. 挂单（Pending Orders）

### 2.1 BuyStop / SellStop / BuyLimit / SellLimit

```mql5
//+------------------------------------------------------------------+
//| 挂单类型枚举                                                     |
//+------------------------------------------------------------------+
enum ENUM_PENDING_TYPE {
   PENDING_BUY_STOP,    // 买入止损（突破做多）
   PENDING_SELL_STOP,   // 卖出止损（突破做空）
   PENDING_BUY_LIMIT,   // 买入限价（回踩做多）
   PENDING_SELL_LIMIT   // 卖出限价（回踩做空）
};

//+------------------------------------------------------------------+
//| 下挂单                                                          |
//+------------------------------------------------------------------+
bool PlacePending(ENUM_PENDING_TYPE ptype,
                  double volume, double price,
                  double sl, double tp,
                  datetime expiry = 0) {
   ENUM_ORDER_TYPE type;
   switch(ptype) {
      case PENDING_BUY_STOP:   type = ORDER_TYPE_BUY_STOP;   break;
      case PENDING_SELL_STOP:  type = ORDER_TYPE_SELL_STOP;  break;
      case PENDING_BUY_LIMIT:  type = ORDER_TYPE_BUY_LIMIT;  break;
      case PENDING_SELL_LIMIT: type = ORDER_TYPE_SELL_LIMIT; break;
   }

   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};

   request.action       = TRADE_ACTION_PENDING;
   request.symbol       = _Symbol;
   request.volume       = volume;
   request.type         = type;
   request.price        = price;
   request.sl           = sl;
   request.tp           = tp;
   request.magic        = g_magic;
   request.comment      = "EA Pending";
   request.type_filling = ORDER_FILLING_FOK;

   if(expiry > 0) {
      request.type_time   = ORDER_TIME_SPECIFIED;
      request.expiration  = expiry;
   } else {
      request.type_time   = ORDER_TIME_GTC;
   }

   if(!OrderSend(request, result))
      return false;

   Print("挂单成功, type=", type, " price=", price,
         " ticket=#", result.order);
   return true;
}

//+------------------------------------------------------------------+
//| 取消挂单（按 Ticket）                                            |
//+------------------------------------------------------------------+
bool CancelPendingOrder(ulong ticket) {
   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};

   request.action = TRADE_ACTION_REMOVE;
   request.order  = ticket;

   return OrderSend(request, result);
}

//+------------------------------------------------------------------+
//| 取消所有挂单                                                     |
//+------------------------------------------------------------------+
int DeleteAllPendingOrders() {
   int deleted = 0;
   MqlTradeRequest request = {};
   MqlTradeResult  result  = {};

   for(int i = OrdersTotal() - 1; i >= 0; i--) {
      ulong ticket = OrderGetTicket(i);
      if(OrderSelect(ticket)) {
         if(OrderGetString(ORDER_SYMBOL) == _Symbol &&
            OrderGetInteger(ORDER_MAGIC) == g_magic) {
            ENUM_ORDER_TYPE type = (ENUM_ORDER_TYPE)
                                   OrderGetInteger(ORDER_TYPE);
            if(type >= ORDER_TYPE_BUY_LIMIT &&
               type <= ORDER_TYPE_SELL_STOP) {
               request.action = TRADE_ACTION_REMOVE;
               request.order  = ticket;
               if(OrderSend(request, result)) deleted++;
            }
         }
      }
   }
   return deleted;
}
```

### 2.2 布林带突破挂单示例

```mql5
//+------------------------------------------------------------------+
//| 布林带突破策略：价格上破上轨挂 BuyStop，下破下轨挂 SellStop        |
//+------------------------------------------------------------------+
void CheckBollingerBreakout() {
   double upper, middle, lower;
   int    handle = iBands(_Symbol, PERIOD_CURRENT, 20, 0, 2,
                           PRICE_CLOSE);
   if(handle == INVALID_HANDLE) return;

   double buf[];
   ArraySetAsSeries(buf, true);
   CopyBuffer(handle, 0, 0, 3, buf);
   upper  = buf[0];
   middle = buf[1];
   lower  = buf[2];

   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   // 上破上轨 → 挂 BuyStop
   if(ask > upper && !HasPendingOfType(ORDER_TYPE_BUY_STOP)) {
      PlacePending(PENDING_BUY_STOP, 0.1, ask,
                   ask - 30 * _Point,  // SL
                   ask + 60 * _Point); // TP
   }
   // 下破下轨 → 挂 SellStop
   else if(bid < lower && !HasPendingOfType(ORDER_TYPE_SELL_STOP)) {
      PlacePending(PENDING_SELL_STOP, 0.1, bid,
                   bid + 30 * _Point,
                   bid - 60 * _Point);
   }
}

// 检查是否已有某类型挂单
bool HasPendingOfType(ENUM_ORDER_TYPE type) {
   for(int i = OrdersTotal() - 1; i >= 0; i--) {
      ulong ticket = OrderGetTicket(i);
      if(OrderSelect(ticket)) {
         if(OrderGetString(ORDER_SYMBOL) == _Symbol &&
            OrderGetInteger(ORDER_TYPE) == type &&
            OrderGetInteger(ORDER_MAGIC) == g_magic)
            return true;
      }
   }
   return false;
}
```

---

## 3. 持仓过滤（筛选哪些持仓属于本 EA）

### 3.1 MagicNumber 过滤

```mql5
//+------------------------------------------------------------------+
//| 判断持仓是否属于本 EA                                            |
//+------------------------------------------------------------------+
bool IsMyPosition(ulong ticket) {
   if(!PositionSelectByTicket(ticket)) return false;
   if(PositionGetString(POSITION_SYMBOL) != _Symbol) return false;
   return (PositionGetInteger(POSITION_MAGIC) == g_magic);
}

//+------------------------------------------------------------------+
//| 遍历本 EA 所有持仓                                               |
//+------------------------------------------------------------------+
void ForEachMyPosition(bool longOnly, bool shortOnly,
                       void &callback(ulong ticket)) {
   int total = PositionsTotal();
   for(int i = total - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;

      ENUM_POSITION_TYPE ptype =
          (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

      if(longOnly  && ptype != POSITION_TYPE_BUY)  continue;
      if(shortOnly && ptype != POSITION_TYPE_SELL) continue;

      callback(ticket);
   }
}
```

### 3.2 Ticket 指定模式（从你源码提炼）

```mql5
//+------------------------------------------------------------------+
//| 两种模式：Magic 模式 或 单 Ticket 模式                            |
//+------------------------------------------------------------------+
input ulong  MagicNumber     = 2024001;  // Magic 号码（0=不限制）
input ulong  PositionTicket  = 0;        // 指定持仓单号（0=不限）

bool g_useTicketMode = false;

// 自动检测模式
void DetectMode() {
   g_useTicketMode = (PositionTicket > 0);
}

// 是否匹配过滤条件
bool MatchesFilter(ulong ticket) {
   if(!PositionSelectByTicket(ticket)) return false;
   if(PositionGetString(POSITION_SYMBOL) != _Symbol) return false;

   if(g_useTicketMode) {
      return (PositionTicket == 0 ||
              ticket == PositionTicket);
   } else {
      return (MagicNumber == 0 ||
              PositionGetInteger(POSITION_MAGIC) == MagicNumber);
   }
}
```

### 3.3 品种过滤

```mql5
//+------------------------------------------------------------------+
//| 遍历所有品种的持仓（多品种 EA）                                   |
//+------------------------------------------------------------------+
void ForEachSymbol(string symbols[],
                   bool longOnly, bool shortOnly,
                   void &callback(string sym, ulong ticket)) {
   int total = PositionsTotal();
   for(int i = total - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;

      string sym  = PositionGetString(POSITION_SYMBOL);
      bool   found = false;
      for(int j = 0; j < ArraySize(symbols); j++) {
         if(sym == symbols[j]) { found = true; break; }
      }
      if(!found) continue;

      ENUM_POSITION_TYPE ptype =
          (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      if(longOnly  && ptype != POSITION_TYPE_BUY)  continue;
      if(shortOnly && ptype != POSITION_TYPE_SELL) continue;

      callback(sym, ticket);
   }
}
```

---

## 4. MQL4 差异

> MQL4 的开仓使用 `OrderSend`，语法与 MQL5 类似但有差异：

```mql4
// MQL4 开多仓
int ticket = OrderSend(Symbol(), OP_BUY, lots, Ask, 3,
                       StopLoss, TakeProfit, "EA Buy", Magic, 0, Green);
if(ticket < 0)
   Print("Error: ", GetLastError());
else
   Print("Order opened: #", ticket);

// MQL4 开空仓
int ticket = OrderSend(Symbol(), OP_SELL, lots, Bid, 3,
                       StopLoss, TakeProfit, "EA Sell", Magic, 0, Red);

// MQL4 挂单
int ticket = OrderSend(Symbol(), OP_BUYSTOP, lots, price,
                       StopLoss, TakeProfit, "EA BuyStop",
                       Magic, 0, Green);
int ticket = OrderSend(Symbol(), OP_SELLLIMIT, lots, price,
                       StopLoss, TakeProfit, "EA SellLimit",
                       Magic, 0, Red);

// MQL4 平仓
bool success = OrderClose(ticket, lots, Bid, 3, Red);

// MQL4 删除挂单
bool success = OrderDelete(ticket);
```

| 差异项 | MQL5 | MQL4 |
|--------|------|------|
| 开仓函数 | `CTrade.Buy/Sell` 或 `OrderSend` | `OrderSend`（无 CTrade） |
| 挂单类型 | `ORDER_TYPE_BUY_STOP` 等 | `OP_BUYSTOP` / `OP_SELLLIMIT` 等 |
| 持仓信息 | `PositionGet*` | `OrderSelect` + 全局变量 |
| 平仓函数 | `CTrade.PositionClose` 或 `OrderSend` | `OrderClose` |
| 订单过滤 | `ORDER_TYPE_BUY` ~ `ORDER_TYPE_SELL_STOP` | `OP_BUY` ~ `OP_SELLSTOP` |
| 颜色定义 | `clrGreen` / `clrRed` | `Green` / `Red`（预定义常量） |
