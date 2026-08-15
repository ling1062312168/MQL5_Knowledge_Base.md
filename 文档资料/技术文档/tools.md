# 工具模块 — 手数计算 / 错误处理 / MQL4差异 / 时间函数

---

## 1. 手数计算

### 1.1 风险比例手数（最常用）

```mql5
//+------------------------------------------------------------------+
//| 按风险比例计算手数                                               |
//+------------------------------------------------------------------+
double CalcLotByRisk(double riskPercent, int slPips) {
   if(slPips <= 0) return 0;

   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskMoney = balance * riskPercent / 100.0;

   // 计算每手每点价值（简化版，适合 EURUSD 等直盘）
   // 1 标准手 ≈ 10 USD/点 (for EURUSD, 1 pip = $10)
   // 其他品种需用 SymbolInfoDouble(SYMBOL_TRADE_TICK_VALUE) 精确计算
   double tickValue  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize   = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double pipValue   = tickValue * (0.0001 / tickSize);

   double lot = riskMoney / (slPips * pipValue);

   // 对齐步长
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   lot = MathFloor(lot / step) * step;

   // 限制范围
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   lot = MathMax(lot, minLot);
   lot = MathMin(lot, maxLot);

   Print("风险手数: 风险=", riskPercent, "% ($",
         DoubleToString(riskMoney, 2), ") SL=",
         slPips, "点 → 手数=", DoubleToString(lot, 2));

   return lot;
}

//+------------------------------------------------------------------+
//| 按固定金额计算手数                                               |
//+------------------------------------------------------------------+
double CalcLotByMoney(double riskMoney, int slPips) {
   if(slPips <= 0) return 0;

   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double pipValue  = tickValue * (0.0001 / tickSize);

   double lot = riskMoney / (slPips * pipValue);

   double step  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);

   lot = MathFloor(lot / step) * step;
   lot = MathMax(lot, minLot);
   lot = MathMin(lot, maxLot);

   return lot;
}

//+------------------------------------------------------------------+
//| 按保证金比例计算手数                                             |
//+------------------------------------------------------------------+
double CalcLotByMargin(double marginPercent) {
   double freeMargin = AccountInfoDouble(ACCOUNT_MARGIN_SO);
   double maxMoney   = freeMargin * marginPercent / 100.0;

   double contractSize = SymbolInfoDouble(_Symbol,
                           SYMBOL_TRADE_CONTRACT_SIZE);
   double price        = SymbolInfoDouble(_Symbol,
                           SYMBOL_ASK);

   // 保证金 ≈ 手数 × 合约量 × 价格 / 杠杆
   double leverage = AccountInfoInteger(ACCOUNT_LEVERAGE);
   double lot = maxMoney * leverage / (contractSize * price);

   double step  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);

   lot = MathFloor(lot / step) * step;
   lot = MathMax(lot, minLot);
   lot = MathMin(lot, maxLot);

   return lot;
}

//+------------------------------------------------------------------+
//| 获取手数精度（小数位数）                                         |
//+------------------------------------------------------------------+
int GetLotDigits() {
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(step >= 1.0) return 0;
   if(step >= 0.1) return 1;
   if(step >= 0.01) return 2;
   return 3;
}

//+------------------------------------------------------------------+
//| 对齐手数到步长                                                   |
//+------------------------------------------------------------------+
double AlignLotToStep(double lot) {
   double step   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   int    digits = GetLotDigits();
   lot = NormalizeDouble(lot, digits);
   lot = MathFloor(lot / step) * step;
   lot = NormalizeDouble(lot, digits);
   return lot;
}
```

---

## 2. 错误处理

### 2.1 错误码处理函数

```mql5
//+------------------------------------------------------------------+
//| 获取错误描述（中文）                                             |
//+------------------------------------------------------------------+
string GetErrorDescription(int err) {
   switch(err) {
      case ERR_NO_ERROR:           return "无错误";
      case ERR_NO_RESULT:          return "无结果";
      case ERR_COMMON_ERROR:       return "通用错误";
      case ERR_INVALID_TRADE_PARAMS: return "无效交易参数";
      case ERR_SERVER_BUSY:        return "服务器忙";
      case ERR_NO_CONNECTION:      return "无连接";
      case ERR_TOO_FREQUENT_REQUESTS: return "请求过于频繁";
      case ERR_TRADE_DISABLED:     return "交易已禁用";
      case ERR_NOT_ENOUGH_MONEY:   return "资金不足";
      case ERR_PRICE_CHANGED:      return "价格已变化";
      case ERR_OFFQUOTES:          return "报价无效";
      case ERR_BROKER_BUSY:        return "经纪商忙";
      case ERR_REQUOTE:            return "重新报价";
      case ERR_LOCKED:             return "请求被锁定";
      case ERR_LONG_POSITION_FULL: return "多方仓位已满";
      case ERR_SHORT_POSITION_FULL: return "空方仓位已满";
      case ERR_TOO_MANY_REQUESTS:  return "请求过多";
      case ERR_TRADE_TIMEOUT:      return "交易超时";
      case ERR_INVALID_PRICE:      return "无效价格";
      case ERR_INVALID_STOPS:      return "无效止损止盈";
      case ERR_INVALID_TRADE_VOLUME: return "无效交易量";
      case ERR_MARKET_CLOSED:      return "市场已关闭";
      case ERR_TRADE_NOT_ALLOWED:  return "不允许交易";
      case ERR_SHORT_POSITIONS:    return "空头仓位受限";
      case ERR_TOO_MANY_OPEN:      return "开仓数过多";
      default:                      return "未知错误(" + IntegerToString(err) + ")";
   }
}

//+------------------------------------------------------------------+
//| 自动重试逻辑（网络抖动时）                                        |
//+------------------------------------------------------------------+
bool TradeWithRetry(bool tradeFunc()) {
   int maxRetries = 3;
   int retryDelay = 500;  // ms

   for(int i = 0; i < maxRetries; i++) {
      if(tradeFunc()) return true;

      int err = GetLastError();
      Print("交易失败 (尝试 ", i + 1, "/", maxRetries,
            "): ", GetErrorDescription(err));

      // 非致命错误，等待后重试
      if(err == ERR_SERVER_BUSY || err == ERR_NO_CONNECTION ||
         err == ERR_REQUOTE || err == ERR_TRADE_TIMEOUT) {
         Sleep(retryDelay);
         retryDelay *= 2;  // 指数退避
         continue;
      }
      // 致命错误，不再重试
      break;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 包装 OrderSend 带自动重试                                        |
//+------------------------------------------------------------------+
bool SafeOrderSend(MqlTradeRequest &request,
                   MqlTradeResult  &result) {
   int maxRetries = 3;
   int delay = 300;

   for(int i = 0; i < maxRetries; i++) {
      if(OrderSend(request, result)) {
         if(result.retcode == TRADE_RETCODE_DONE ||
            result.retcode == TRADE_RETCODE_PLACED)
            return true;

         // 部分执行，尝试 FOK → IOC 降级
         if(request.type_filling == ORDER_FILLING_FOK &&
            result.retcode == TRADE_RETCODE_PARTIAL) {
            request.type_filling = ORDER_FILLING_IOC;
            continue;
         }

         // 失败但无致命错误
         if(IsRetryableError(result.retcode)) {
            Sleep(delay);
            delay *= 2;
            continue;
         }
      }
      return false;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 是否是可重试的错误                                               |
//+------------------------------------------------------------------+
bool IsRetryableError(uint retcode) {
   return (retcode == TRADE_RETCODE_REQUOTE ||
           retcode == TRADE_RETCODE_TIMEOUT ||
           retcode == TRADE_RETCODE_BUSY ||
           retcode == TRADE_RETCODE_NO_CONNECTION ||
           retcode == TRADE_RETCODE_SERVER_BUSY);
}
```

---

## 3. 时间函数

### 3.1 交易时段过滤

```mql5
//+------------------------------------------------------------------+
//| 是否在交易时段内                                                 |
//+------------------------------------------------------------------+
bool IsInTradingSession(int startHour, int endHour) {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);

   if(startHour <= endHour) {
      // 同一天: 09:00 ~ 18:00
      return (dt.hour >= startHour && dt.hour < endHour);
   } else {
      // 跨天: 例如 23:00 ~ 05:00
      return (dt.hour >= startHour || dt.hour < endHour);
   }
}

//+------------------------------------------------------------------+
//| 排除特定时间（如新闻时段）                                        |
//+------------------------------------------------------------------+
bool IsInBlackout(int startHour, int startMin,
                  int endHour, int endMin) {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);

   int nowMins = dt.hour * 60 + dt.min;
   int sMins   = startHour * 60 + startMin;
   int eMins   = endHour * 60 + endMin;

   if(sMins <= eMins) {
      return (nowMins >= sMins && nowMins < eMins);
   } else {
      return (nowMins >= sMins || nowMins < eMins);
   }
}

//+------------------------------------------------------------------+
//| 距离下一交易时段开始的秒数                                        |
//+------------------------------------------------------------------+
int SecondsToSessionStart(int startHour) {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);

   int nowSecs   = dt.hour * 3600 + dt.min * 60 + dt.sec;
   int targetSecs = startHour * 3600;

   int diff = targetSecs - nowSecs;
   if(diff <= 0) diff += 24 * 3600;  // 明天
   return diff;
}

//+------------------------------------------------------------------+
//| 倒计时显示文字                                                    |
//+------------------------------------------------------------------+
string SessionCountdown(int startHour) {
   int secs = SecondsToSessionStart(startHour);
   int h = secs / 3600;
   int m = (secs % 3600) / 60;
   int s = secs % 60;
   return StringFormat("距开盘: %02d:%02d:%02d", h, m, s);
}
```

### 3.2 交易日判断

```mql5
//+------------------------------------------------------------------+
//| 是否是交易日（排除周末）                                         |
//+------------------------------------------------------------------+
bool IsTradingDay() {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   // 周六=6, 周日=0 (day_of_week: 0=周日, 1=周一 ... 6=周六)
   return (dt.day_of_week != 0 && dt.day_of_week != 6);
}

//+------------------------------------------------------------------+
//| 本周已交易日数                                                   |
//+------------------------------------------------------------------+
int DaysTradedThisWeek() {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int dayOfWeek = dt.day_of_week;  // 0=周日
   if(dayOfWeek == 0) return 0;     // 周日 = 0
   if(dayOfWeek == 6) return 5;     // 周六 = 已过5天
   return dayOfWeek;                // 周一到周五
}
```

---

## 4. MQL4 / MQL5 完整差异对照

```mql4
// ==================================================================
// MQL4 / MQL5 语法差异速查表
// ==================================================================

// --- 头文件 ---
// MQL4: 无标准头文件，直接用内置函数
// MQL5: #include <Trade\Trade.mqh>  // CTrade

// --- 开仓 ---
// MQL4:
int ticket = OrderSend(Symbol(), OP_BUY, lots, Ask, slip,
                       SL, TP, comment, magic, 0, Blue);
// MQL5:
bool ok = g_trade.Buy(lots, _Symbol, 0, SL, TP);
// MQL5 原生:
MqlTradeRequest req = {}; req.action = TRADE_ACTION_DEAL;
OrderSend(req, result);

// --- 挂单 ---
// MQL4: OP_BUYSTOP, OP_SELLLIMIT 等
int ticket = OrderSend(Symbol(), OP_BUYSTOP, lots, price,
                       SL, TP, comment, magic, expiry, Green);
// MQL5: ORDER_TYPE_BUY_STOP 等
PlacePending(PENDING_BUY_STOP, lots, price, SL, TP);

// --- 平仓 ---
// MQL4:
bool ok = OrderClose(ticket, lots, Bid, slip, Red);
// MQL5:
g_trade.PositionClose(ticket);
g_trade.PositionClose(ticket, partial_lots);  // 部分平仓

// --- 持仓信息 ---
// MQL4: 全局函数（无命名空间）
double profit = OrderProfit();
double lots   = OrderLots();
double openPrice = OrderOpenPrice();
// 遍历持仓
for(int i = OrdersTotal() - 1; i >= 0; i--) {
   if(OrderSelect(i)) {
      if(OrderSymbol() == Symbol() &&
         OrderMagicNumber() == Magic)
         // 处理
   }
}

// MQL5: PositionGet* 函数
double profit = PositionGetDouble(POSITION_PROFIT);
double lots   = PositionGetDouble(POSITION_VOLUME);
// 遍历持仓
for(int i = PositionsTotal() - 1; i >= 0; i--) {
   ulong ticket = PositionGetTicket(i);
   if(PositionSelectByTicket(ticket)) {
      if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == Magic)
         // 处理
   }
}

// --- 历史订单 ---
// MQL4:
for(int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
   if(OrderSelect(i)) { /* 处理 */ }
}
// MQL5:
HistorySelect(from, to);
for(int i = HistoryDealsTotal() - 1; i >= 0; i--) {
   ulong ticket = HistoryDealGetTicket(i);
   // ...
}

// --- 账户信息 ---
// MQL4: 全局函数
double balance = AccountBalance();
double equity  = AccountEquity();
double margin  = AccountMargin();
double free    = AccountFreeMargin();
// MQL5: AccountInfoDouble
double balance = AccountInfoDouble(ACCOUNT_BALANCE);
double equity  = AccountInfoDouble(ACCOUNT_EQUITY);
double margin  = AccountInfoDouble(ACCOUNT_MARGIN);

// --- 颜色常量 ---
// MQL4: Green, Red, Blue, Black, White, Yellow, clrRed, clrGreen
// MQL5: clrGreen, clrRed, clrBlue (推荐) 或 ColorToString()

// --- 品种信息 ---
// MQL4: MarketInfo(Symbol(), MODE_ASK)
// MQL5: SymbolInfoDouble(_Symbol, SYMBOL_ASK)

// --- _Point / _Digits ---
// 两者相同：_Point = 合约最小价格变动，_Digits = 报价小数位数

// --- OrderSend 返回值 ---
// MQL4: 返回 ticket（>0成功，<0失败），用 GetLastError() 获取错误
// MQL5: 返回 bool，用 result.retcode 判断结果

// --- #property ---
// MQL4: #property copyright "xxx" / #property strict (不存在)
// MQL5: #property copyright "xxx" / #property strict (推荐开启)

// --- bool vs int ---
// MQL4: 没有 bool 类型，用 int (0=false, 非0=true)
// MQL5: 有 bool 类型

// --- 字符串 ---
// MQL4: String函数名略有不同，无 StringToCharArray
// MQL5: 字符串处理更接近标准 C++

// --- 数组 ---
// MQL4: 不支持动态多维数组，ArrayResize有限
// MQL5: 支持 ArrayResize，数组更灵活

// --- 类/结构体 ---
// MQL4: 不支持 class，只有 struct
// MQL5: 支持 class（OOP）、struct、模板
```

---

## 5. 常用全局宏

```mql5
//+------------------------------------------------------------------+
//| 全局常量和辅助函数（可放入一个 Common.mqh）                        |
//+------------------------------------------------------------------+

// 常用颜色
#define CLR_BG          C'15, 18, 25'
#define CLR_CARD        C'22, 26, 36'
#define CLR_GREEN       C'20, 160, 70'
#define CLR_RED         C'200, 45, 45'
#define CLR_YELLOW      C'200, 165, 0'
#define CLR_TEXT        C'210, 220, 235'

// 面板前缀
#ifndef PANEL_PREFIX
#define PANEL_PREFIX    "EAPanel_"
#endif

//+------------------------------------------------------------------+
//| 安全打印（防止空指针崩溃）                                        |
//+------------------------------------------------------------------+
void SafePrint(string msg) {
   if(msg == NULL || msg == "")
      msg = "(null)";
   Print(msg);
}

//+------------------------------------------------------------------+
//| 字符串安全转数值（带默认值）                                      |
//+------------------------------------------------------------------+
double SafeStrToDouble(string s, double defaultVal = 0) {
   if(s == NULL || s == "") return defaultVal;
   double v = StringToDouble(s);
   if(v == 0 && StringFind(s, "0") != 0)
      return defaultVal;  // 不是真的0，而是转换失败
   return v;
}
```

---

## 6. MQL4 兼容工具（可选）

如果需要同时兼容 MQL4 和 MQL5，可以使用条件编译：

```mql5
//+------------------------------------------------------------------+
//| 跨版本兼容宏                                                     |
//+------------------------------------------------------------------+
#ifdef __MQL4__
   #define IS_MQL5  false
   #define POSITION_PROFIT   OrderProfit()
   #define POSITION_VOLUME   OrderLots()
   #define POSITION_SYMBOL   OrderSymbol()
   #define POSITION_TYPE     OrderType()
   #define POSITION_OPEN_PRICE OrderOpenPrice()
#else
   #define IS_MQL5  true
   #define OP_BUY   ORDER_TYPE_BUY
   #define OP_SELL  ORDER_TYPE_SELL
#endif
```
