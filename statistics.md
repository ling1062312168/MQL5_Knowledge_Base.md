# 统计模块 — 持仓统计 / 账户统计 / 面板展示

---

## 1. 持仓统计（从你源码提炼）

### 1.1 PositionInfo 结构体（从你源码提炼）

```mql5
//+------------------------------------------------------------------+
//| 持仓信息结构体（从你源码中的 PositionInfo 提炼）                   |
//+------------------------------------------------------------------+
struct PositionInfo {
   int               count;      // 持仓数量
   double            totalLots;  // 总手数
   double            profit;     // 总盈亏（含 Swap）
   double            commission; // 总手续费（MT5 无此字段，设为0）
};

//+------------------------------------------------------------------+
//| 获取某方向的持仓统计                                             |
//+------------------------------------------------------------------+
PositionInfo GetPositionInfo(ENUM_POSITION_TYPE target_type) {
   PositionInfo info = {};

   int total = (int)PositionsTotal();
   for(int i = 0; i < total; i++) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         != target_type) continue;

      info.count++;
      info.totalLots += PositionGetDouble(POSITION_VOLUME);
      // MT5 中 POSITION_COMMISSION 字段通常为0，通过盈亏统计
      info.profit += PositionGetDouble(POSITION_PROFIT)
                   + PositionGetDouble(POSITION_SWAP);
   }
   return info;
}

//+------------------------------------------------------------------+
//| 快速获取数值（从你源码中的简洁写法提炼）                           |
//+------------------------------------------------------------------+
int    CountPositionsByType(ENUM_ORDER_TYPE order_type) {
   int count = 0;
   ENUM_POSITION_TYPE target =
       (order_type == ORDER_TYPE_BUY) ?
       POSITION_TYPE_BUY : POSITION_TYPE_SELL;

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(IsMyPosition(ticket) &&
         (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
         == target) count++;
   }
   return count;
}

//+------------------------------------------------------------------+
//| 总持仓统计（含多空）                                             |
//+------------------------------------------------------------------+
struct TotalStats {
   int         total_count;
   double      total_lots;
   double      total_profit;
   int         long_count;
   double      long_lots;
   double      long_profit;
   int         short_count;
   double      short_lots;
   double      short_profit;
};

TotalStats GetTotalStats() {
   TotalStats s = {};

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!IsMyPosition(ticket)) continue;

      ENUM_POSITION_TYPE ptype =
          (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double lots   = PositionGetDouble(POSITION_VOLUME);
      double profit = PositionGetDouble(POSITION_PROFIT)
                    + PositionGetDouble(POSITION_SWAP);

      s.total_count++;
      s.total_lots   += lots;
      s.total_profit += profit;

      if(ptype == POSITION_TYPE_BUY) {
         s.long_count++;
         s.long_lots   += lots;
         s.long_profit += profit;
      } else {
         s.short_count++;
         s.short_lots   += lots;
         s.short_profit += profit;
      }
   }
   return s;
}
```

---

## 2. 账户统计

### 2.1 账户基本信息

```mql5
//+------------------------------------------------------------------+
//| 账户信息结构体                                                   |
//+------------------------------------------------------------------+
struct AccountInfo {
   double            balance;          // 余额
   double            equity;           // 净值
   double            margin;           // 已用保证金
   double            freeMargin;       // 可用保证金
   double            marginLevel;      // 保证金比例
   double            drawdown;         // 当前回撤（%）
   double            dailyProfit;      // 今日盈亏
};

AccountInfo GetAccountInfo() {
   AccountInfo info = {};

   info.balance     = AccountInfoDouble(ACCOUNT_BALANCE);
   info.equity      = AccountInfoDouble(ACCOUNT_EQUITY);
   info.margin      = AccountInfoDouble(ACCOUNT_MARGIN);
   info.freeMargin  = AccountInfoDouble(ACCOUNT_MARGIN_SO);
   info.marginLevel = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);

   // 今日盈亏 = 净值 - 余额
   info.dailyProfit = info.equity - info.balance;

   // 回撤 = (历史最高净值 - 当前净值) / 历史最高净值
   // 需要记录历史最高净值（用全局变量）
   if(info.equity > g_peak_equity)
      g_peak_equity = info.equity;

   if(g_peak_equity > 0)
      info.drawdown = (g_peak_equity - info.equity)
                      / g_peak_equity * 100.0;

   return info;
}

double  g_peak_equity = 0;
```

### 2.2 风险指标

```mql5
//+------------------------------------------------------------------+
//| 计算风险指标                                                     |
//+------------------------------------------------------------------+
struct RiskMetrics {
   double            riskPercent;     // 风险比例（已用保证金/净值）
   double            leverage;        // 当前杠杆
   double            exposure;        // 总持仓保证金/净值
   double            unrealizedPct;   // 未实现盈亏/净值
};

RiskMetrics GetRiskMetrics() {
   RiskMetrics m = {};

   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double equity  = AccountInfoDouble(ACCOUNT_EQUITY);
   double margin  = AccountInfoDouble(ACCOUNT_MARGIN);

   if(equity > 0) {
      m.riskPercent    = margin / equity * 100.0;
      m.exposure       = margin / equity * 100.0;
      m.unrealizedPct  = (equity - balance) / equity * 100.0;
   }

   // 计算实际杠杆
   TotalStats stats = GetTotalStats();
   if(stats.total_lots > 0) {
      double notional = stats.total_lots *
          SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE)
          * SymbolInfoDouble(_Symbol, SYMBOL_PRICE);
      if(equity > 0)
         m.leverage = notional / equity;
   }

   return m;
}

//+------------------------------------------------------------------+
//| 爆仓风险检测                                                     |
//+------------------------------------------------------------------+
bool CheckMarginCall() {
   double marginLevel = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
   double freeMargin  = AccountInfoDouble(ACCOUNT_MARGIN_SO);

   // MT5 保证金追缴通常在 50%~100% 之间
   if(marginLevel < 100) {
      Alert("⚠️ 保证金追缴警告！保证金比例=",
            DoubleToString(marginLevel, 1) + "%");
      return true;
   }
   if(freeMargin < 0) {
      Alert("🚨 爆仓风险！可用保证金为负！");
      return true;
   }
   return false;
}
```

---

## 3. 交易历史统计

### 3.1 历史订单遍历

```mql5
//+------------------------------------------------------------------+
//| 历史订单统计结构体                                               |
//+------------------------------------------------------------------+
struct HistoryStats {
   int               total_trades;     // 总交易次数
   int               win_trades;       // 盈利次数
   int               loss_trades;      // 亏损次数
   double            total_profit;     // 总盈亏
   double            max_win;          // 最大单笔盈利
   double            max_loss;         // 最大单笔亏损
   double            avg_win;          // 平均盈利
   double            avg_loss;         // 平均亏损
   double            profit_factor;    // 盈亏比
   double            win_rate;         // 胜率
};

HistoryStats GetHistoryStats(datetime from, datetime to) {
   HistoryStats s = {};

   if(!HistorySelect(from, to)) return s;

   for(int i = HistoryDealsTotal() - 1; i >= 0; i--) {
      ulong ticket = HistoryDealGetTicket(i);
      if(ticket == 0) continue;

      long    magic    = HistoryDealGetInteger(ticket, DEAL_MAGIC);
      if(magic != g_magic) continue;

      double  profit   = HistoryDealGetDouble(ticket, DEAL_PROFIT);
      double  commission = HistoryDealGetDouble(ticket, DEAL_COMMISSION);
      double  swap     = HistoryDealGetDouble(ticket, DEAL_SWAP);
      double  net      = profit + commission + swap;

      s.total_trades++;
      s.total_profit += net;

      if(net > 0) {
         s.win_trades++;
         s.max_win = MathMax(s.max_win, net);
         s.avg_win += net;
      } else if(net < 0) {
         s.loss_trades++;
         s.max_loss = MathMin(s.max_loss, net);
         s.avg_loss += net;
      }
   }

   if(s.win_trades > 0)
      s.avg_win /= s.win_trades;
   if(s.loss_trades > 0)
      s.avg_loss /= s.loss_trades;

   s.win_rate = (s.total_trades > 0) ?
       double(s.win_trades) / s.total_trades * 100.0 : 0;
   s.profit_factor = (s.avg_loss != 0) ?
       -s.avg_win / s.avg_loss : 0;

   return s;
}

//+------------------------------------------------------------------+
//| 本日统计（从今天0点开始）                                         |
//+------------------------------------------------------------------+
HistoryStats GetTodayStats() {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   dt.hour = 0; dt.min = 0; dt.sec = 0;
   datetime start = StructToTime(dt);
   return GetHistoryStats(start, TimeCurrent());
}

//+------------------------------------------------------------------+
//| 本周统计                                                         |
//+------------------------------------------------------------------+
HistoryStats GetWeekStats() {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   // 找到本周一
   int dayOfWeek = (dt.day_of_week + 6) % 7; // 周一=0
   dt.day -= dayOfWeek;
   dt.hour = 0; dt.min = 0; dt.sec = 0;
   datetime start = StructToTime(dt);
   return GetHistoryStats(start, TimeCurrent());
}
```

---

## 4. 统计面板展示（从你源码提炼）

### 4.1 实时统计面板（图表对象）

```mql5
//+------------------------------------------------------------------+
//| 更新统计面板（从你源码中的 UpdatePanel 提炼）                      |
//+------------------------------------------------------------------+
void UpdateStatsPanel() {
   datetime now = TimeCurrent();
   if(now - g_lastUpdate < g_updateInterval) return;
   g_lastUpdate = now;

   TotalStats   ts    = GetTotalStats();
   AccountInfo  ai    = GetAccountInfo();
   RiskMetrics  rm    = GetRiskMetrics();

   // === 持仓统计 ===
   string txt;

   // 多仓行
   txt = StringFormat("Long:  %.2f lots × %d  P/L: %+.2f",
                      ts.long_lots, ts.long_count, ts.long_profit);
   ObjectSetString(0, PREFIX + "LongLabel", OBJPROP_TEXT, txt);
   ObjectSetInteger(0, PREFIX + "LongLabel", OBJPROP_COLOR,
                    ts.long_profit >= 0 ? CLR_GREEN : CLR_RED);

   // 空仓行
   txt = StringFormat("Short: %.2f lots × %d  P/L: %+.2f",
                      ts.short_lots, ts.short_count, ts.short_profit);
   ObjectSetString(0, PREFIX + "ShortLabel", OBJPROP_TEXT, txt);
   ObjectSetInteger(0, PREFIX + "ShortLabel", OBJPROP_COLOR,
                    ts.short_profit >= 0 ? CLR_GREEN : CLR_RED);

   // 净值行
   txt = StringFormat("Equity: %.2f  Balance: %.2f  DD: %.1f%%",
                      ai.equity, ai.balance, ai.drawdown);
   ObjectSetString(0, PREFIX + "EquityLabel", OBJPROP_TEXT, txt);
   color eqColor = (ai.equity >= ai.balance) ? CLR_GREEN : CLR_RED;
   ObjectSetInteger(0, PREFIX + "EquityLabel", OBJPROP_COLOR, eqColor);

   // 保证金风险行
   txt = StringFormat("Margin: %.0f%%  Risk: %.1f%%  Leverage: %.1fx",
                      rm.marginLevel, rm.exposure, rm.leverage);
   ObjectSetString(0, PREFIX + "MarginLabel", OBJPROP_TEXT, txt);
   color riskColor = (rm.marginLevel > 200) ? CLR_TEXT :
                     (rm.marginLevel > 100) ? CLR_YELLOW : CLR_RED;
   ObjectSetInteger(0, PREFIX + "MarginLabel", OBJPROP_COLOR, riskColor);

   // 今日盈亏
   txt = StringFormat("Today: %+.2f  Net: %+.2f",
                      ai.dailyProfit, ts.total_profit);
   ObjectSetString(0, PREFIX + "TodayLabel", OBJPROP_TEXT, txt);
   color todayColor = (ts.total_profit >= 0) ? CLR_GREEN : CLR_RED;
   ObjectSetInteger(0, PREFIX + "TodayLabel", OBJPROP_COLOR, todayColor);

   ChartRedraw();
}

//+------------------------------------------------------------------+
//| 创建统计面板对象                                                 |
//+------------------------------------------------------------------+
void CreateStatsPanel() {
   int px = PanelX;
   int py = PanelY;

   CreateRect(PREFIX + "BG", px, py, PanelW, PanelH,
               CLR_BG, CLR_BORDER);

   int cy = py + 5;

   // 标题
   CreateLabel(PREFIX + "Title", "═══ EA Stats ═══",
               px + 5, cy, PanelW - 10, 18, CLR_TEXT, 10, true);
   cy += 22;

   // 净值
   CreateLabel(PREFIX + "EquityLabel", "", px + 5, cy,
               PanelW - 10, 16, CLR_TEXT, 9);
   cy += 20;

   // 多仓
   CreateLabel(PREFIX + "LongLabel", "", px + 5, cy,
               PanelW - 10, 16, CLR_GREEN, 9);
   cy += 20;

   // 空仓
   CreateLabel(PREFIX + "ShortLabel", "", px + 5, cy,
               PanelW - 10, 16, CLR_RED, 9);
   cy += 20;

   // 保证金
   CreateLabel(PREFIX + "MarginLabel", "", px + 5, cy,
               PanelW - 10, 16, CLR_TEXT, 9);
   cy += 20;

   // 今日盈亏
   CreateLabel(PREFIX + "TodayLabel", "", px + 5, cy,
               PanelW - 10, 16, CLR_TEXT, 9);

   ChartRedraw();
}

datetime g_lastUpdate = 0;
int      g_updateInterval = 1;  // 每秒更新
```

---

## 5. MQL4 统计差异

| 差异项 | MQL5 | MQL4 |
|--------|------|------|
| 历史订单遍历 | `HistorySelect()` + `HistoryDealsTotal()` | `OrderSelect(i)` 遍历 `OrdersHistoryTotal()` |
| 账户信息 | `AccountInfoDouble(ACCOUNT_EQUITY)` | `AccountEquity()` |
| 保证金 | `AccountInfoDouble(ACCOUNT_MARGIN)` | `AccountMargin()` |
| 历史净值 | 无直接字段，需自行记录峰值 | 同 |
