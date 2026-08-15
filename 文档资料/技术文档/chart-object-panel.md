# 图表对象 UI 面板 — 纯代码法（无控件库）

## 概述

你的源码里最常见的做法：**不依赖 `Controls.mqh` 标准控件库**，而是直接用 MQL 内置的图表对象（`OBJ_BUTTON`、`OBJ_LABEL`、`OBJ_EDIT` 等）手工拼装面板。这种方式：

- **零依赖**：不需要 `#include <Controls\Dialog.mqh>`
- **完全可控**：每个像素都能手动调整
- **MT4/MT5 通用**：语法几乎一样

本模块从你的真实 EA 源码中提炼出的最佳实践。

---

## 1. 完整面板创建模板（MT5）

### 1.1 常量与命名规范

```mql5
//+------------------------------------------------------------------+
//| 面板全局配置                                                     |
//+------------------------------------------------------------------+
#property strict

// 面板位置和尺寸
input int PanelX     = 10;           // 面板X坐标
input int PanelY     = 50;           // 面板Y坐标
input int PanelW     = 220;          // 面板宽度
input int PanelH     = 380;          // 面板高度

// 面板前缀（所有对象名前缀，避免与图表其他对象冲突）
#define PREFIX         "EAPanel_"
#define P_WIDE         (PanelW - 20)

// 颜色主题（深色专业风格，提取自你的EA源码）
#define CLR_BG          C'15, 18, 25'     // 面板背景
#define CLR_CARD         C'22, 26, 36'     // 卡片/分组背景
#define CLR_BORDER      C'40, 45, 60'     // 边框
#define CLR_BTN_BG      C'35, 42, 60'     // 按钮背景
#define CLR_BTN_HOVER   C'50, 60, 90'     // 按钮悬停
#define CLR_ACCENT      C'0, 120, 215'    // 强调蓝
#define CLR_GREEN       C'20, 160, 70'    // 盈利/开始
#define CLR_RED         C'200, 45, 45'    // 亏损/停止
#define CLR_YELLOW      C'200, 165, 0'    // 警告/平仓
#define CLR_TEXT        C'210, 220, 235'  // 主文字
#define CLR_TEXT_DIM    C'120, 135, 160'  // 次要文字
#define CLR_PROFIT      C'20, 200, 100'   // 盈利数字
#define CLR_LOSS        C'220, 60, 60'    // 亏损数字

// 按钮尺寸规范
#define BTN_W           85              // 按钮宽度
#define BTN_H           28              // 按钮高度
#define BTN_GAP         8               // 按钮间距

// 字体
#define FONT_NAME       "Segoe UI"
#define FONT_SIZE       9
```

### 1.2 对象创建函数

```mql5
//+------------------------------------------------------------------+
//| 创建标签文本                                                     |
//+------------------------------------------------------------------+
void CreateLabel(string name, string text, int x, int y,
                 int w, int h, color txt_color,
                 int font_size = 9, bool bold = false) {
   if(!ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0))
      return;
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_X, x);
   ObjectSetInteger(0, name, OBJPROP_Y, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_COLOR, txt_color);
   ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(0, name, OBJPROP_FONTFLAGS, bold ? 1 : 0);
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, 0);
}

//+------------------------------------------------------------------+
//| 创建按钮                                                         |
//+------------------------------------------------------------------+
void CreateButton(string name, string text, int x, int y,
                  int w, int h, color bg_color, color txt_color) {
   if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
      return;
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_X, x);
   ObjectSetInteger(0, name, OBJPROP_Y, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_COLOR, txt_color);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_color);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bg_color);
   ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FONT_SIZE);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, 0);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 100);
}

//+------------------------------------------------------------------+
//| 创建输入框 (OBJ_EDIT)                                           |
//+------------------------------------------------------------------+
void CreateEdit(string name, string default_text,
                int x, int y, int w, int h) {
   if(!ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0))
      return;
   ObjectSetString(0, name, OBJPROP_TEXT, default_text);
   ObjectSetInteger(0, name, OBJPROP_X, x);
   ObjectSetInteger(0, name, OBJPROP_Y, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_COLOR, CLR_TEXT);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, CLR_CARD);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, CLR_BORDER);
   ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FONT_SIZE);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, 0);
   ObjectSetInteger(0, name, OBJPROP_ALIGN, ALIGN_CENTER);
}

//+------------------------------------------------------------------+
//| 创建矩形背景（面板容器）                                          |
//+------------------------------------------------------------------+
void CreateRect(string name, int x, int y, int w, int h,
                color bg_color, color border_color) {
   if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return;
   ObjectSetInteger(0, name, OBJPROP_X, x);
   ObjectSetInteger(0, name, OBJPROP_Y, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_color);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, border_color);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, 0);
   ObjectSetInteger(0, name, OBJPROP_BACK, true);  // 置底
}
```

### 1.3 完整面板创建函数

```mql5
//+------------------------------------------------------------------+
//| EA 面板创建                                                      |
//+------------------------------------------------------------------+
void CreatePanel() {
   int px = PanelX;
   int py = PanelY;

   // 面板背景
   CreateRect(PREFIX + "BG", px, py, PanelW, PanelH,
               CLR_BG, CLR_BORDER);

   // 标题栏
   CreateRect(PREFIX + "TitleBar", px, py, PanelW, 30,
               C'25, 30, 45', CLR_BORDER);
   CreateLabel(PREFIX + "Title", "═══ EA Control ═══",
               px + 5, py + 5, PanelW - 10, 20,
               CLR_TEXT, 10, true);

   // 副标题（显示当前品种）
   CreateLabel(PREFIX + "Symbol", "Symbol=EURUSD",
               px + 5, py + 30, PanelW - 10, 18,
               CLR_TEXT_DIM, 8);

   int cy = py + 55;  // 当前Y坐标

   // === 分组1: 多空状态 ===
   CreateLabel(PREFIX + "LongLabel", "Long: 0.00 lots × 0  P/L: +0.00",
               px + 5, cy, P_WIDE, 18, CLR_GREEN, 9, true);
   cy += 22;

   CreateLabel(PREFIX + "ShortLabel", "Short: 0.00 lots × 0  P/L: -0.00",
               px + 5, cy, P_WIDE, 18, CLR_LOSS, 9, true);
   cy += 28;

   // === 分组2: 平多仓控制 ===
   CreateLabel(PREFIX + "LongGroup", "--- Long Close ---",
               px + 5, cy, P_WIDE, 16, CLR_TEXT_DIM, 8);
   cy += 20;

   // 百分比平仓
   CreateLabel(PREFIX + "LongPctLbl", "Percent:",
               px + 5, cy, 60, 20, CLR_TEXT, 9);
   CreateEdit(PREFIX + "LongPctEdit", "50",
               px + 65, cy, 60, 20);
   CreateButton(PREFIX + "LongPctBtn", "Close %",
               px + 130, cy, 80, 22,
               CLR_GREEN, clrWhite);
   cy += 26;

   // 固定手数平仓
   CreateLabel(PREFIX + "LongFixLbl", "Lots:",
               px + 5, cy, 55, 20, CLR_TEXT, 9);
   CreateEdit(PREFIX + "LongFixEdit", "0.10",
               px + 60, cy, 60, 20);
   CreateButton(PREFIX + "LongFixBtn", "Close Lots",
               px + 125, cy, 85, 22,
               CLR_GREEN, clrWhite);
   cy += 28;

   // === 分组3: 平空仓控制 ===
   CreateLabel(PREFIX + "ShortGroup", "--- Short Close ---",
               px + 5, cy, P_WIDE, 16, CLR_TEXT_DIM, 8);
   cy += 20;

   CreateLabel(PREFIX + "ShortPctLbl", "Percent:",
               px + 5, cy, 60, 20, CLR_TEXT, 9);
   CreateEdit(PREFIX + "ShortPctEdit", "50",
               px + 65, cy, 60, 20);
   CreateButton(PREFIX + "ShortPctBtn", "Close %",
               px + 130, cy, 80, 22,
               CLR_RED, clrWhite);
   cy += 26;

   CreateLabel(PREFIX + "ShortFixLbl", "Lots:",
               px + 5, cy, 55, 20, CLR_TEXT, 9);
   CreateEdit(PREFIX + "ShortFixEdit", "0.10",
               px + 60, cy, 60, 20);
   CreateButton(PREFIX + "ShortFixBtn", "Close Lots",
               px + 125, cy, 85, 22,
               CLR_RED, clrWhite);
   cy += 28;

   // === 分组4: 全平按钮 ===
   CreateButton(PREFIX + "CloseAllLong", "✕ Close All Long",
               px + 5, cy, P_WIDE / 2 - 4, BTN_H,
               CLR_YELLOW, C'30, 30, 30');
   CreateButton(PREFIX + "CloseAllShort", "✕ Close All Short",
               px + P_WIDE / 2 + 3, cy, P_WIDE / 2 - 4, BTN_H,
               CLR_YELLOW, C'30, 30, 30');
   cy += 36;

   // === 分组5: Magic/Ticket 模式切换 ===
   CreateButton(PREFIX + "ToggleMode", "Magic Mode:",
               px + 5, cy, 90, 22, CLR_ACCENT, clrWhite);
   CreateEdit(PREFIX + "MagicEdit", "0",
               px + 98, cy, 112, 22);
   cy += 28;

   // === 分组6: 删除挂单 ===
   CreateButton(PREFIX + "DeletePending", "Delete All Pending",
               px + 5, cy, P_WIDE, 26,
               CLR_BTN_BG, CLR_TEXT);

   ChartRedraw();
}
```

### 1.4 实时数据更新

```mql5
//+------------------------------------------------------------------+
//| 实时更新面板数据（每秒执行）                                       |
//+------------------------------------------------------------------+
datetime g_lastUpdate = 0;

void UpdatePanel() {
   datetime now = TimeCurrent();
   if(now - g_lastUpdate < 1)   // 最多每秒更新一次
      return;
   g_lastUpdate = now;

   // 更新品种显示
   string title = "Symbol=" + _Symbol;
   ObjectSetString(0, PREFIX + "Symbol", OBJPROP_TEXT, title);

   // 获取多仓信息
   double longLots = 0; int longCount = 0; double longProfit = 0;
   double shortLots = 0; int shortCount = 0; double shortProfit = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket)) {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol) {
            if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)
               == POSITION_TYPE_BUY) {
               longCount++;
               longLots += PositionGetDouble(POSITION_VOLUME);
               longProfit += PositionGetDouble(POSITION_PROFIT)
                           + PositionGetDouble(POSITION_SWAP);
            } else {
               shortCount++;
               shortLots += PositionGetDouble(POSITION_VOLUME);
               shortProfit += PositionGetDouble(POSITION_PROFIT)
                            + PositionGetDouble(POSITION_SWAP);
            }
         }
      }
   }

   // 更新多仓标签（颜色随盈亏变化）
   string longTxt = StringFormat("Long: %.2f lots × %d  P/L: %+.2f",
                                  longLots, longCount, longProfit);
   ObjectSetString(0, PREFIX + "LongLabel", OBJPROP_TEXT, longTxt);
   ObjectSetInteger(0, PREFIX + "LongLabel", OBJPROP_COLOR,
                    longProfit >= 0 ? CLR_PROFIT : CLR_LOSS);

   // 更新空仓标签
   string shortTxt = StringFormat("Short: %.2f lots × %d  P/L: %+.2f",
                                   shortLots, shortCount, shortProfit);
   ObjectSetString(0, PREFIX + "ShortLabel", OBJPROP_TEXT, shortTxt);
   ObjectSetInteger(0, PREFIX + "ShortLabel", OBJPROP_COLOR,
                    shortProfit >= 0 ? CLR_PROFIT : CLR_LOSS);

   // 更新按钮文字中的预估盈亏（平仓预览）
   double pctLong = StringToDouble(
       ObjectGetString(0, PREFIX + "LongPctEdit", OBJPROP_TEXT));
   double pctShort = StringToDouble(
       ObjectGetString(0, PREFIX + "ShortPctEdit", OBJPROP_TEXT));

   // 实时显示平仓后的预估盈亏
   double estLong = longProfit * pctLong / 100.0;
   double estShort = shortProfit * pctShort / 100.0;
   string longBtnTxt = StringFormat("Close %d%% (≈ %+.2f)",
                                    (int)pctLong, estLong);
   ObjectSetString(0, PREFIX + "LongPctBtn", OBJPROP_TEXT, longBtnTxt);

   string shortBtnTxt = StringFormat("Close %d%% (≈ %+.2f)",
                                     (int)pctShort, estShort);
   ObjectSetString(0, PREFIX + "ShortPctBtn", OBJPROP_TEXT, shortBtnTxt);
}
```

### 1.5 按钮点击事件处理

```mql5
//+------------------------------------------------------------------+
//| 按钮点击处理（提取自你源码中的 HandleButtonClick）                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam,
                  const double &dparam, const string &sparam) {
   if(id == CHARTEVENT_OBJECT_CLICK) {
      HandleButtonClick(sparam);
   }
}

void HandleButtonClick(string buttonName) {
   // === 平多仓按钮 ===
   if(buttonName == PREFIX + "CloseAllLong") {
      if(!ConfirmDialog("Close ALL Long positions on " + _Symbol + "?"))
         return;
      CloseAllByType(POSITION_TYPE_BUY);
      return;
   }

   // === 平空仓按钮 ===
   if(buttonName == PREFIX + "CloseAllShort") {
      if(!ConfirmDialog("Close ALL Short positions on " + _Symbol + "?"))
         return;
      CloseAllByType(POSITION_TYPE_SELL);
      return;
   }

   // === 百分比平多仓 ===
   if(buttonName == PREFIX + "LongPctBtn") {
      double pct = StringToDouble(
          ObjectGetString(0, PREFIX + "LongPctEdit", OBJPROP_TEXT));
      if(pct <= 0 || pct > 100) {
         Alert("Invalid percent: " + DoubleToString(pct, 1));
         return;
      }
      string msg = StringFormat("Close %.1f%% of Long positions?\n"
                                "Estimated profit: %.2f",
                                pct, EstimateCloseProfit(POSITION_TYPE_BUY, pct));
      if(!ConfirmDialog(msg)) return;
      CloseByPercent(POSITION_TYPE_BUY, pct);
      return;
   }

   // === 固定手数平多仓 ===
   if(buttonName == PREFIX + "LongFixBtn") {
      double lots = StringToDouble(
          ObjectGetString(0, PREFIX + "LongFixEdit", OBJPROP_TEXT));
      if(lots <= 0) {
         Alert("Invalid lots: " + DoubleToString(lots, 2));
         return;
      }
      string msg = StringFormat("Close %.2f lots of Long positions?\n"
                                "Estimated profit: %.2f",
                                lots, EstimateCloseProfit(POSITION_TYPE_BUY, lots));
      if(!ConfirmDialog(msg)) return;
      CloseByLots(POSITION_TYPE_BUY, lots);
      return;
   }

   // === Magic 模式切换 ===
   if(buttonName == PREFIX + "ToggleMode") {
      string input = ObjectGetString(0, PREFIX + "MagicEdit",
                                      OBJPROP_TEXT);
      ulong magic = (ulong)StringToInteger(input);
      // 应用新的 Magic
      Print("Set Magic to: ", magic);
      ObjectSetString(0, PREFIX + "MagicEdit", OBJPROP_TEXT,
                      IntegerToString(magic));
      return;
   }

   // === 删除所有挂单 ===
   if(buttonName == PREFIX + "DeletePending") {
      if(!ConfirmDialog("Delete ALL pending orders on " + _Symbol + "?"))
         return;
      DeleteAllPendingOrders();
      return;
   }
}
```

### 1.6 确认对话框（提取自你源码）

```mql5
//+------------------------------------------------------------------+
//| Windows API 确认对话框（提取自你源码中的 MessageBox 封装）          |
//+------------------------------------------------------------------+
#import "user32.dll"
int MessageBoxW(int hWnd, string text, string caption, int flags);
#import

#define MB_YESNO        0x04
#define MB_ICONQUESTION 0x20
#define IDYES           6

bool ConfirmDialog(string message) {
   int ret = MessageBoxW(0, message, "Confirm", MB_YESNO | MB_ICONQUESTION);
   return (ret == IDYES);
}

//+------------------------------------------------------------------+
//| Alert 弹窗                                                       |
//+------------------------------------------------------------------+
void Alert(string message) {
   MessageBoxW(0, message, "Notice", 0x40);  // MB_OK | MB_ICONINFORMATION
}
```

### 1.7 清理与初始化

```mql5
//+------------------------------------------------------------------+
//| 删除面板对象（带前缀保护，防止误删其他对象）                        |
//+------------------------------------------------------------------+
void DeletePanel() {
   long total = ObjectsTotal(0, -1, -1);
   for(long i = total - 1; i >= 0; i--) {
      string name = ObjectName(0, i);
      if(StringFind(name, PREFIX) == 0)
         ObjectDelete(0, name);
   }
}

//+------------------------------------------------------------------+
//| EA 标准函数                                                      |
//+------------------------------------------------------------------+
int OnInit() {
   CreatePanel();
   EventSetTimer(1);   // 每秒更新面板
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
   DeletePanel();
   EventKillTimer();
}

void OnTick() {
   // 交易逻辑
}

void OnTimer() {
   UpdatePanel();       // 每秒刷新面板数据
}
```

---

## 2. MT4 版本（几乎相同，仅小差异）

```mql5
// MT4 差异点说明：
// 1. PositionGetString/Integer/Double → OrderGetString/Integer/Double (遍历订单)
// 2. POSITION_TYPE → OrderType()
// 3. C'15, 18, 25' → clrBlack (MT4 不支持 C'...' 颜色字面量)
// 4. _Symbol → Symbol()
// 5. MessageBoxW 参数类型略有不同
// 6. #property strict 在 MT4 中不存在
```

### MT4 颜色替代方案

```mql5
// MT4 没有 C'...' 颜色字面量，使用 RGB 宏或预定义颜色
#define CLR_BG_MT4       clrBlack
#define CLR_CARD_MT4     clrDarkBlue
#define CLR_BORDER_MT4   clrSlateGray
#define CLR_BTN_BG_MT4   clrNavy
#define CLR_GREEN_MT4    clrGreen
#define CLR_RED_MT4      clrRed
#define CLR_YELLOW_MT4   clrGold
#define CLR_TEXT_MT4     clrWhite
```

---

## 3. 面板实时预览盈亏（你源码中的高级模式）

这是你源码里很实用的一个技巧：**平仓按钮上实时显示预估盈亏**：

```mql5
// 在 UpdatePanel() 中实时更新按钮文字
void UpdateCloseButtonProfitPreview() {
   // 多仓百分比按钮
   double pct = StringToDouble(
       ObjectGetString(0, PREFIX + "LongPctEdit", OBJPROP_TEXT));
   double longProfit = GetTotalProfit(POSITION_TYPE_BUY);
   double estProfit = longProfit * pct / 100.0;
   color btnColor = estProfit >= 0 ? CLR_GREEN : CLR_RED;

   string txt = StringFormat("Close %d%% ≈ %+.2f",
                              (int)pct, estProfit);
   ObjectSetString(0, PREFIX + "LongPctBtn", OBJPROP_TEXT, txt);
   ObjectSetInteger(0, PREFIX + "LongPctBtn", OBJPROP_BGCOLOR, btnColor);

   // 空仓同理...
}
```

效果：用户输入 50 后，按钮文字自动变成 `Close 50% ≈ +125.50`，颜色随盈亏变化，用户在点之前就知道能平多少钱。

---

## 4. MT4 平仓实现（提取自你源码）

```mql5
//+------------------------------------------------------------------+
//| MT4 平多仓/平空仓实现                                            |
//+------------------------------------------------------------------+
void CloseAllByType(int orderType) {  // OP_BUY=0, OP_SELL=1
   for(int i = OrdersTotal() - 1; i >= 0; i--) {
      if(OrderSelect(i)) {
         if(OrderSymbol() == Symbol() &&
            OrderType() == orderType &&
            OrderMagicNumber() == MagicNumber) {

            RefreshRates();
            if(orderType == OP_BUY)
               OrderClose(OrderTicket(), OrderLots(),
                          Bid, 3, CLRRed);
            else
               OrderClose(OrderTicket(), OrderLots(),
                          Ask, 3, CLRGreen);
         }
      }
   }
}

// 按百分比平仓
void CloseByPercent(int orderType, double percent) {
   for(int i = OrdersTotal() - 1; i >= 0; i--) {
      if(OrderSelect(i)) {
         if(OrderSymbol() == Symbol() &&
            OrderType() == orderType &&
            OrderMagicNumber() == MagicNumber) {

            double closeLots = NormalizeDouble(
                OrderLots() * percent / 100.0, 2);
            if(closeLots < MarketInfo(OrderSymbol(), MODE_MINLOT))
               continue;

            RefreshRates();
            if(orderType == OP_BUY)
               OrderClose(OrderTicket(), closeLots, Bid, 3, CLRRed);
            else
               OrderClose(OrderTicket(), closeLots, Ask, 3, CLRGreen);
         }
      }
   }
}

// 计算预估平仓盈亏
double EstimateCloseProfit(int orderType, double percent) {
   double total = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--) {
      if(OrderSelect(i)) {
         if(OrderSymbol() == Symbol() &&
            OrderType() == orderType &&
            OrderMagicNumber() == MagicNumber) {
            total += OrderProfit() + OrderSwap() + OrderCommission();
         }
      }
   }
   return total * percent / 100.0;
}
```

---

## 5. 模式速查对比

| 特性 | 图表对象法 (本模块) | 标准控件库 (standard-controls.md) |
|------|-------------------|--------------------------------|
| 依赖 | 零依赖 | `#include <Controls\Dialog.mqh>` |
| MT4 兼容 | ✅ 几乎相同 | ❌ 需要 MQL4 控件库 |
| 圆角/渐变 | ❌ 不支持（纯色） | ❌ 也不支持 |
| 控件数量 | 少（标签/按钮/输入框） | 多（ComboBox/DatePicker等） |
| 事件处理 | `CHARTEVENT_OBJECT_CLICK` | `CHARTEVENT_CUSTOM+N` |
| 学习成本 | 低（MQL 内置对象） | 高（CAppDialog 框架） |
| 适合场景 | 参数面板、平仓面板 | 复杂表单、多Tab界面 |
