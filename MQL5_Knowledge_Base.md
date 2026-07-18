# MQL5 编码知识库

> 每次编写/修改 MQL5 代码前，必须先查阅此文件。
> 每次遇到新的编译错误或警告，必须在此文件中追加记录。

---

## 🔥 BUG快速索引表

> 每次修复BUG后必须在此表追加记录，防止重复踩坑。

| BUG描述 | 现象 | 根因 | 解决方案 | 所在章节 |
|---------|------|------|---------|---------|
| 类成员用指针声明 | 大量级联undeclared错误 | 类成员应声明为对象而非指针 | 改为对象成员，用`.`访问 | 第1章 |
| long→int隐式转换 | 编译警告possible loss of data | PositionsTotal()等返回long | 加`(int)`显式强制转换 | 第2章 |
| Hour函数找不到 | undeclared identifier 'Hour' | MQL5无Hour()，需用TimeToStruct | MqlDateTime结构体取dt.hour | 第4章 |
| CTrade.Close不存在 | undeclared identifier 'Close' | 方法名记错了 | 用`trade.PositionClose(ticket)` | 第5章 |
| 面板被K线遮挡 | 面板背景在K线后面 | `OBJPROP_BACK=true`后置底 | 改为`OBJPROP_BACK=false` | 第7.1章 |
| 拖拽无法停止 | 鼠标松开后面板仍跟随 | 错误使用sparam检测按键，不可靠 | **完整沿用DraggablePanel_MT5模式**：CHARTEVENT_CLICK处理开始/结束拖拽，IsClickOnPanel检测，边框视觉反馈 | 第7章 |
| 内部面板错位 | 内部黑色面板拖拽时位置不变 | Rct/Lbl/Btn/Edt创建控件时使用绝对坐标，未加m_x/m_y偏移 | 所有创建函数添加m_x+x, m_y+y偏移，拖拽时Destroy+重建 | 第7章 |
| 显示"Label" | 持仓行标签显示"Label"文本 | 1. BuildPositionsTab()创建后未调用UpdatePositions() 2. 初始文本设置为"--"但不生效 | 创建标签用空字符串""，Build末尾调用UpdatePositions()动态填充 | 持仓Tab布局 |
| 订单号显示不全 | 按钮文字被截断 | 按钮宽度不够，票号太长 | 订单号独立一列，按钮只显示"改/平" | 持仓Tab布局 |
| 输入框无法输入 | 编辑框无法输入或值不保存 | 缺少CHARTEVENT_OBJECT_ENDEDIT处理和READONLY设置 | 添加ENDEDIT事件处理，设置OBJPROP_READONLY=false | 第27章 |
| 持仓页显示"--" | 无订单时行标签仍显示-- | SwitchTab后未调用UpdatePositions清空 | SwitchTab时同时调用UpdatePositions | 持仓Tab布局 |
| EA完全不开仓 | 设置了点差限制后完全不下单 | 开仓条件中MaxLoss正负号写反，`buyProfit > -MaxLoss`误写为`buyProfit > MaxLoss`的反面 | 检查init中是否已对MaxLoss取反，开仓条件保持与原版一致 | 第12章 |
| 点差限制判断错误 | MaxSpread设为50仍不开仓 | 小点(MODE_SPREAD)与标准点单位不统一，比较时混用 | MaxSpread直接与MODE_SPREAD(小点)比较，面板显示时再除以g_lotCoeff转标准点 | 第21章 |
| 手动停止按钮无效 | 点击"停止做多/做空"后状态被覆盖 | start()每次执行自动将g_allow_buy/sell设为true，覆盖用户手动设置 | 新增g_manual_stop_buy/sell变量保存手动状态，自动检查通过后再检查手动状态 | 第36章 |
| 图表左上角异常数值 | 显示563122860.52等调试信息 | 代码中Comment()函数调用显示调试数据 | 全部注释掉Comment()调用，改用面板UI显示 | 第37章 |
| 变量重复定义 | 'DailyProfitTarget' - variable already defined | extern与input同名变量冲突（第58行extern + 第80行input） | 删除extern定义，只保留input版本 | 第38章 |
| 回测错误触发盈利目标 | 未开单就说满足每日盈利500目标 | 全局变量AMZ3_today_closed保留历史数据，回测时last_reset时间戳判断失效 | init()中添加IsTesting()检测，回测时重置所有全局变量 | 第39章 |

---

## 📋 目录索引

| 分类 | 说明 | 章节 |
|------|------|------|
| **编译错误与警告** | 常见编译错误、警告及解决方案 | 第1-5章 |
| **面板UI交互** | 面板创建、拖拽、颜色、下拉菜单 | 第6-11章 |
| **开仓操作** | 开仓API、CTrade、风险手数计算 | 第12-14章 |
| **加仓操作** | 加仓逻辑、手数管理 | 第15章 |
| **平仓操作** | 平仓API、批量平仓 | 第16-17章 |
| **统计分析** | 交易统计、盈亏计算、回撤 | 第18-19章 |
| **对冲策略** | 对冲逻辑、锁仓管理 | 第20章 |
| **风险管理** | 风险模式、移动止损、时间过滤 | 第21-23章 |
| **全局设置** | 参数分组、初始化、内存管理 | 第24-25章 |
| **文本处理** | 字符串操作、格式化输出 | 第26章 |
| **输入框** | 编辑框创建、值读取 | 第27章 |
| **按钮** | 按钮创建、事件处理 | 第28章 |
| **调试与优化** | 日志输出、性能优化 | 第29-30章 |
| **MT4网格EA专项修复** | 手动停止状态、Comment调试、变量重复、回测全局变量重置 | 第36-39章 |

---

# 第一部分：编译错误与警告

## 1. 类指针 vs 对象成员（致命错误）

### 错误现象
```
'->' - object pointer expected
'->' - operand expected
cannot convert parameter 'CClassName*' to 'long'
```
大量级联错误（一个指针错误可产生50+错误）。

### 解决方案
**将类成员从指针改为对象，用 `.` 运算符调用：**

```cpp
// ❌ 错误写法
class CPanel {
   CTrading    *m_tr;
   CStatistics *m_st;
};

// ✅ 正确写法
class CPanel {
   CTrading    m_tr;
   CStatistics m_st;
};
// 调用: m_st.Method()
```

### 初始化方式
```cpp
void SetTr(int magic, int slip) { m_tr.Init(magic, slip); }
void SetSt(int magic) { m_st.Init(magic); }
```

---

## 2. long → int 隐式转换（警告）

### 错误现象
```
implicit conversion from 'long' to 'int'
possible loss of data
```

### 解决方案
**始终添加显式 `(int)` 强制转换：**

```cpp
// ❌ 警告写法
int total = HistoryDealsTotal();
for(int i = PositionsTotal()-1; i >= 0; i--)

// ✅ 正确写法
int total = (int)HistoryDealsTotal();
for(int i = (int)PositionsTotal()-1; i >= 0; i--)
```

### 受影响函数列表
| 函数 | 返回类型 | 转换方式 |
|------|---------|---------|
| `PositionsTotal()` | long | `(int)PositionsTotal()` |
| `HistoryDealsTotal()` | long | `(int)HistoryDealsTotal()` |
| `ObjectsTotal()` | long | `(int)ObjectsTotal()` |
| `StringToInteger()` | long | `(int)StringToInteger()` |
| `ObjectGetInteger()` | long | `(int)ObjectGetInteger()` |

---

## 3. 未实现的声明方法（致命错误）

### 错误现象
```
'ClassName::MethodName' - member function already defined with different parameters
undeclared identifier
```

### 解决方案
**确保每个声明的 public/private 方法都有对应的实现：**

```cpp
class CPanel {
public:
   void CloseDropdown();
   void CloseRiskDropdown();
private:
   void HideDropdown();
   void HideRiskDropdown();
};

void CPanel::CloseDropdown() { HideDropdown(); }
void CPanel::CloseRiskDropdown() { HideRiskDropdown(); }
```

---

## 4. MQL5 不存在的枚举/常量（致命错误）

### 常见错误
```
'CHART_MOUSE_BUTTON_DOWN' - undeclared identifier
'DEAL_BALANCE' - undeclared identifier
```

### 解决方案
```cpp
// CHART_MOUSE_BUTTON_DOWN → 用全局变量跟踪
bool g_mouse_down = false;

// DEAL_BALANCE → 用账户信息计算
double dd = AccountBalance() - AccountEquity();

// TimeHour/TimeMinute → 用TimeToStruct
MqlDateTime dt;
TimeToStruct(TimeCurrent(), dt);
int hour = dt.hour;
```

---

## 5. CTrade 方法名错误（致命错误）

### 错误现象
```
undeclared identifier 'Close'
```

### 解决方案
**CTrade 类的正确方法名：**

| 操作 | 正确方法 | 错误写法 |
|------|---------|---------|
| 买入开仓 | `trade.Buy(lot, symbol, 0, sl, tp)` | - |
| 卖出开仓 | `trade.Sell(lot, symbol, 0, sl, tp)` | - |
| 平仓 | `trade.PositionClose(ticket)` | `trade.Close()` |
| 修改SL/TP | `trade.PositionModify(ticket, sl, tp)` | - |

---

# 第二部分：面板UI交互

## 6. 面板创建与布局

### 创建面板背景
```cpp
bool CreatePanel(int x, int y, int w, int h) {
   // 创建背景矩形
   if(!ObjectCreate(0, "Panel_BG", OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;
   
   ObjectSetInteger(0, "Panel_BG", OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, "Panel_BG", OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, "Panel_BG", OBJPROP_XSIZE, w);
   ObjectSetInteger(0, "Panel_BG", OBJPROP_YSIZE, h);
   ObjectSetInteger(0, "Panel_BG", OBJPROP_BGCOLOR, clrDarkSlateGray);
   ObjectSetInteger(0, "Panel_BG", OBJPROP_BACK, true);
   return true;
}
```

### 统一前缀命名
```cpp
#define PREFIX "EAP_"
string GetName(string base) { return PREFIX + base; }
```

---

## 7. 面板拖拽功能

### 核心逻辑
```cpp
bool g_dragging = false;
int g_drag_start_x = 0, g_drag_start_y = 0;
int g_panel_x = 0, g_panel_y = 0;

void OnChartEvent(const int id, const long &lparam, 
                  const double &dparam, const string &sparam) {
   if(id == CHARTEVENT_OBJECT_CLICK) {
      if(sparam == PREFIX "Title") {
         g_dragging = true;
         g_drag_start_x = (int)ChartGetInteger(0, CHART_MOUSE_X);
         g_drag_start_y = (int)ChartGetInteger(0, CHART_MOUSE_Y);
      }
   }
   
   if(id == CHARTEVENT_MOUSE_MOVE && g_dragging) {
      int dx = (int)ChartGetInteger(0, CHART_MOUSE_X) - g_drag_start_x;
      int dy = (int)ChartGetInteger(0, CHART_MOUSE_Y) - g_drag_start_y;
      MovePanel(dx, dy);
   }
}
```

### ⚠️ 关键BUG：拖拽无法停止（完整修复方案）

**问题**：拖拽面板时，松开鼠标后面板仍跟随鼠标移动，无法停止拖拽。

**❌ 错误方案（已废弃）**：
1. 在 `CHARTEVENT_MOUSE_MOVE` 中检测 `sparam` 是否含 `"l"` — 不可靠
2. 只在 `CHARTEVENT_OBJECT_CLICK` 中结束拖拽 — 空白区域不触发

**✅ 正确方案**：完整沿用 `DraggablePanel_MT5.mq5` 模式。

**核心原理**：
- `CHARTEVENT_CLICK` → **同时处理开始和结束拖拽**（点击面板区域开始，再次点击任意位置结束）
- `CHARTEVENT_MOUSE_MOVE` → 移动面板
- `IsClickOnPanel()` → 判断点击是否在面板区域内
- 边框视觉反馈 → 拖拽时变红加粗，结束时恢复

**完整拖拽事件处理（参考DraggablePanel_MT5.mq5）**：
```cpp
void OnChartEvent(const int id, const long &lparam, 
                  const double &dparam, const string &sp)
{
   int x = (int)lparam;
   int y = (int)dparam;

   // 1. 鼠标移动: 拖拽移动
   if(id == CHARTEVENT_MOUSE_MOVE)
   {
      if(g_drag_state)
         panel.DragTo(x, y);
      return;
   }

   // 2. 图表点击: 开始/结束拖拽（核心模式）
   if(id == CHARTEVENT_CLICK)
   {
      if(!g_drag_state)
      {
         // 点击面板区域 → 开始拖拽
         if(panel.IsClickOnPanel(x, y))
         {
            g_drag_state = true;
            g_mouse_down = true;
            g_drag_start_x = x - panel.GetX();
            g_drag_start_y = y - panel.GetY();
            // 边框变红色，增加宽度（视觉反馈）
            ObjectSetInteger(0, "EAP_BG", OBJPROP_COLOR, clrRed);
            ObjectSetInteger(0, "EAP_BG", OBJPROP_WIDTH, 2);
            ChartRedraw(0);
         }
      }
      else
      {
         // 已在拖拽中 → 结束拖拽
         g_drag_state = false;
         g_mouse_down = false;
         // 恢复原边框颜色和宽度
         ObjectSetInteger(0, "EAP_BG", OBJPROP_COLOR, clrDimGray);
         ObjectSetInteger(0, "EAP_BG", OBJPROP_WIDTH, 1);
         ChartRedraw(0);
      }
      return;
   }

   // 3. 编辑框完成事件...
   if(id == CHARTEVENT_OBJECT_ENDEDIT) { ... }

   // 4. 对象点击事件（按钮等）
   if(id != CHARTEVENT_OBJECT_CLICK) return;

   // 拖拽中忽略对象点击
   if(g_drag_state) return;

   // 其他按钮点击处理...
}
```

**IsClickOnPanel方法**（只检测外边框）：
```cpp
bool CPanel::IsClickOnPanel(int x, int y)
{
   int border = 3;  // 边框宽度3像素
   return (x >= m_x && x <= m_x + m_w && y >= m_y && y <= m_y + m_h &&
           (x <= m_x + border || x >= m_x + m_w - border ||
            y <= m_y + border || y >= m_y + m_h - border));
}
```

**说明**：点击面板边缘3像素范围内才触发拖拽，点击内部区域（按钮、输入框等）不会触发，避免误拖拽。

**交互流程**：
1. 点击面板外边框（边缘3像素） → 开始拖拽（边框变红加粗）
2. 移动鼠标 → 面板跟随移动（自动边界限制）
3. 点击任意位置（图表或面板上） → 结束拖拽（边框恢复）

---

### 面板边界限制（防止拖出屏幕）

拖拽时添加边界检查，确保面板不会被拖到可视区域外：
```cpp
void DragTo(int x, int y)
{
   if(!g_drag_state) return;
   int nx = x - g_drag_start_x;
   int ny = y - g_drag_start_y;

   // 边界限制
   long cw = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   long ch = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
   int maxX = (int)cw - m_w;
   int maxY = (int)ch - m_h;
   if(maxX < 0) maxX = 0;
   if(maxY < 0) maxY = 0;
   if(nx < 0) nx = 0;
   if(ny < 0) ny = 0;
   if(nx > maxX) nx = maxX;
   if(ny > maxY) ny = maxY;

   // 移动所有面板控件...
}
```

---

## 7.1 Z轴层级与面板置顶

### OBJPROP_BACK 属性
```cpp
// false = 在图表前方（置顶），true = 在图表后方
ObjectSetInteger(0, name, OBJPROP_BACK, false);
```

### 面板默认置顶设置
面板所有元素（背景、按钮、标签、编辑框）都应设置 `OBJPROP_BACK=false`，确保显示在K线之上。

**注意**：背景矩形若设为 `OBJPROP_BACK=true`，会被K线和指标覆盖，导致面板"消失"在图表后面。

### 切换置顶/置底
```cpp
void ToggleOnTop()
{
   static bool on_top = true;
   on_top = !on_top;
   int tot=(int)ObjectsTotal(0, 0);
   for(int i=0;i<tot;i++)
   {
      string n=ObjectName(0,i,0);
      if(StrStarts(n, PREFIX))
         ObjectSetInteger(0, n, OBJPROP_BACK, on_top?false:true);
   }
   ChartRedraw();
}
```

---

## 8. 颜色配置

### 动态颜色管理
```cpp
input color TEXT_COLOR   = clrWhite;
input color BG_COLOR     = clrDarkSlateGray;
input color POSITIVE_COL = clrLimeGreen;
input color NEGATIVE_COL = clrRed;

void UpdateProfitColor(string labelName, double profit) {
   ObjectSetInteger(0, labelName, OBJPROP_TEXT_COLOR, 
                    profit >= 0 ? POSITIVE_COL : NEGATIVE_COL);
}
```

### RGB颜色定义
```cpp
color CustomColor = C'255,100,50';  // 红255,绿100,蓝50
```

---

## 9. 下拉菜单

### 创建下拉菜单
```cpp
void ShowDropdown(int x, int y, int w, string items[], int count) {
   int h = count * 22 + 4;
   ObjectCreate(0, "DD_BG", OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "DD_BG", OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, "DD_BG", OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, "DD_BG", OBJPROP_XSIZE, w);
   ObjectSetInteger(0, "DD_BG", OBJPROP_YSIZE, h);
   
   for(int i = 0; i < count; i++) {
      ObjectCreate(0, "DD_Item_" + IntegerToString(i), OBJ_BUTTON, 0, 0, 0);
      ObjectSetString(0, "DD_Item_" + IntegerToString(i), OBJPROP_TEXT, items[i]);
   }
}
```

### 关闭下拉菜单
```cpp
void HideDropdown() {
   ObjectDelete(0, "DD_BG");
   for(int i = 0; i < 5; i++)
      ObjectDelete(0, "DD_Item_" + IntegerToString(i));
}
```

---

## 10. 标签页切换

### 切换逻辑
```cpp
void SwitchTab(int tab) {
   // 更新导航高亮
   for(int i = 0; i < 4; i++) {
      ObjectSetInteger(0, "Nav_" + IntegerToString(i), OBJPROP_BGCOLOR,
                       i == tab ? clrDodgerBlue : clrGray);
   }
   
   // 清空并重建内容
   ClearTabContent();
   if(tab == 0) BuildTradeTab();
   else if(tab == 1) BuildPositionsTab();
   else if(tab == 2) BuildStatsTab();
   else if(tab == 3) BuildSettingsTab();
}
```

---

## 11. 模态对话框

### 创建对话框
```cpp
void ShowDialog(int x, int y, int w, int h) {
   ObjectCreate(0, "Dlg_BG", OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "Dlg_BG", OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, "Dlg_BG", OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, "Dlg_BG", OBJPROP_XSIZE, w);
   ObjectSetInteger(0, "Dlg_BG", OBJPROP_YSIZE, h);
   ObjectSetInteger(0, "Dlg_BG", OBJPROP_BGCOLOR, clrBlack);
   ObjectSetInteger(0, "Dlg_BG", OBJPROP_COLOR, clrAqua);
}
```

---

# 第三部分：开仓操作

## 12. CTrade 标准库

### 标准引入方式
```cpp
#include <Trade\Trade.mqh>

CTrade trade;

void OnInit() {
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(Slippage);
}
```

### 开仓方法
```cpp
// 简单开仓
trade.Buy(lot, symbol);
trade.Sell(lot, symbol);

// 带SL/TP的开仓
trade.Buy(lot, symbol, 0, sl_price, tp_price);
trade.Sell(lot, symbol, 0, sl_price, tp_price);
```

---

## 13. 开仓参数计算

### SL/TP价格计算
```cpp
double CalculateSL(ENUM_ORDER_TYPE type, int slPoints) {
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double price = (type == ORDER_TYPE_BUY) ? 
                  SymbolInfoDouble(_Symbol, SYMBOL_ASK) : 
                  SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl = (type == ORDER_TYPE_BUY) ? 
               price - slPoints * point : 
               price + slPoints * point;
   return NormalizeDouble(sl, (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS));
}
```

---

## 14. 风险手数计算

### 三种风险模式
```cpp
enum RiskMode {
   RISK_FIXED_LOT,      // 固定手数
   RISK_BALANCE_PERCENT, // 余额百分比
   RISK_RATIO           // 风险比例
};

double CalculateLotSize(RiskMode mode, double baseLot, double riskPercent, int slPoints) {
   double lot = baseLot;
   
   switch(mode) {
      case RISK_BALANCE_PERCENT: {
         double balance = AccountBalance();
         double riskAmount = balance * riskPercent / 100.0;
         double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
         if(slPoints > 0 && tickValue > 0)
            lot = riskAmount / (slPoints * tickValue);
         break;
      }
      case RISK_RATIO: {
         double freeMargin = AccountEquity() - AccountInfoDouble(ACCOUNT_MARGIN);
         lot = freeMargin / 1000.0;
         break;
      }
   }
   
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   return MathMax(minLot, MathMin(maxLot, lot));
}
```

---

# 第四部分：加仓操作

## 15. 加仓逻辑

### 按方向加仓
```cpp
ulong AddToPosition(int pos_type, double lot) {
   ENUM_ORDER_TYPE type = (pos_type == POSITION_TYPE_BUY) ? 
                          ORDER_TYPE_BUY : ORDER_TYPE_SELL;
   return trade.Buy(lot, _Symbol);
}
```

### 检查最大持仓数
```cpp
bool CanAddPosition(int maxPositions) {
   return (int)PositionsTotal() < maxPositions;
}
```

---

# 第五部分：平仓操作

## 16. 平仓API

### 单个平仓
```cpp
bool ClosePosition(ulong ticket) {
   if(!PositionSelectByTicket(ticket)) return false;
   return trade.PositionClose(ticket);
}
```

### 批量平仓
```cpp
bool CloseAll() {
   int success = 0;
   for(int i = (int)PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(trade.PositionClose(ticket)) success++;
   }
   return success > 0;
}
```

---

## 17. 条件平仓

### 按方向平仓
```cpp
bool CloseByType(int pos_type) {
   int success = 0;
   for(int i = (int)PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      
      if((int)PositionGetInteger(POSITION_TYPE) == pos_type) {
         if(trade.PositionClose(ticket)) success++;
      }
   }
   return success > 0;
}
```

---

# 第六部分：统计分析

## 18. 交易统计

### 统计结构体
```cpp
struct TradeStats {
   int    totalTrades;
   int    winTrades;
   int    lossTrades;
   double winRate;
   double profitFactor;
   double netProfit;
   double avgWin;
   double avgLoss;
   double maxDrawdown;
};
```

### 计算统计数据
```cpp
TradeStats CalculateStats(datetime fromTime) {
   TradeStats stats = {0};
   if(!HistorySelect(fromTime, TimeCurrent())) return stats;
   
   int total = (int)HistoryDealsTotal();
   double grossProfit = 0, grossLoss = 0;
   
   for(int i = 0; i < total; i++) {
      ulong ticket = HistoryDealGetTicket(i);
      if(ticket == 0) continue;
      
      double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
      if(profit >= 0) {
         stats.winTrades++;
         grossProfit += profit;
      } else {
         stats.lossTrades++;
         grossLoss += MathAbs(profit);
      }
      stats.netProfit += profit;
   }
   
   stats.totalTrades = stats.winTrades + stats.lossTrades;
   if(stats.totalTrades > 0) {
      stats.winRate = (double)stats.winTrades / stats.totalTrades * 100;
      if(grossLoss > 0) stats.profitFactor = grossProfit / grossLoss;
   }
   return stats;
}
```

---

## 19. 持仓汇总

### 获取持仓信息
```cpp
struct PositionSummary {
   int    total;
   int    buyCount;
   int    sellCount;
   double totalLots;
   double totalProfit;
};

PositionSummary GetPositionSummary() {
   PositionSummary summary = {0};
   
   for(int i = 0; i < (int)PositionsTotal(); i++) {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      
      summary.total++;
      summary.totalLots += PositionGetDouble(POSITION_VOLUME);
      summary.totalProfit += PositionGetDouble(POSITION_PROFIT);
      
      if((int)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         summary.buyCount++;
      else
         summary.sellCount++;
   }
   return summary;
}
```

---

# 第七部分：对冲策略

## 20. 对冲管理

### 检查是否有反向持仓
```cpp
bool HasOppositePosition(string symbol, ENUM_POSITION_TYPE type) {
   ENUM_POSITION_TYPE opposite = (type == POSITION_TYPE_BUY) ? 
                                 POSITION_TYPE_SELL : POSITION_TYPE_BUY;
   
   for(int i = 0; i < (int)PositionsTotal(); i++) {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      
      if(PositionGetString(POSITION_SYMBOL) == symbol &&
         (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == opposite)
         return true;
   }
   return false;
}
```

### 锁仓操作
```cpp
ulong LockPosition(ulong ticket) {
   if(!PositionSelectByTicket(ticket)) return 0;
   
   string symbol = PositionGetString(POSITION_SYMBOL);
   double volume = PositionGetDouble(POSITION_VOLUME);
   ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   
   ENUM_ORDER_TYPE orderType = (type == POSITION_TYPE_BUY) ? 
                               ORDER_TYPE_SELL : ORDER_TYPE_BUY;
   
   return trade.Sell(volume, symbol); // 反向开仓实现锁仓
}
```

---

# 第八部分：风险管理

## 21. 移动止损

### 动态移动止损
```cpp
void TrailingStop(int tsPoints) {
   if(tsPoints <= 0) return;
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   for(int i = (int)PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      
      ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double currentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
      double currentSL = PositionGetDouble(POSITION_SL);
      double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      
      double newSL;
      if(type == POSITION_TYPE_BUY) {
         newSL = NormalizeDouble(currentPrice - tsPoints * point, 
                                 (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS));
         if(currentSL > 0 && newSL <= currentSL) continue;
         if(newSL <= openPrice) continue;
      } else {
         newSL = NormalizeDouble(currentPrice + tsPoints * point, 
                                 (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS));
         if(currentSL > 0 && newSL >= currentSL) continue;
         if(newSL >= openPrice) continue;
      }
      
      trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP));
   }
}
```

---

## 22. 时间过滤

### 交易时段控制
```cpp
input bool     InpTimeFilter = false;
input string   InpStartTime  = "09:00";
input string   InpStopTime   = "23:00";

bool IsInTradingSession() {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int hour = dt.hour;
   int minute = dt.min;
   
   int startHour = (int)StringToInteger(StringSubstr(InpStartTime, 0, 2));
   int startMin  = (int)StringToInteger(StringSubstr(InpStartTime, 3, 2));
   int stopHour  = (int)StringToInteger(StringSubstr(InpStopTime, 0, 2));
   int stopMin   = (int)StringToInteger(StringSubstr(InpStopTime, 3, 2));
   
   int currentMin = hour * 60 + minute;
   int startMinTotal = startHour * 60 + startMin;
   int stopMinTotal = stopHour * 60 + stopMin;
   
   return (currentMin >= startMinTotal && currentMin <= stopMinTotal);
}
```

---

## 23. 保证金检查

### 检查可用保证金
```cpp
bool CheckMargin(double lot) {
   double margin = 0;
   if(!OrderCalcMargin(ORDER_TYPE_BUY, _Symbol, lot, 
                       SymbolInfoDouble(_Symbol, SYMBOL_ASK), margin))
      return false;
   return margin <= AccountInfoDouble(ACCOUNT_MARGIN_FREE);
}
```

---

# 第九部分：全局设置

## 24. 参数分组

### 规范格式
```cpp
input group "=== 交易参数 ==="
input double   InpLot          = 0.10;
input int      InpStopLoss     = 50;
input int      InpTakeProfit   = 100;
input int      InpMagicNumber  = 2024001;

input group "=== 风险管理 ==="
input ENUM_RISK_MODE InpRiskMode = RISK_FIXED;
input double   InpRiskPercent  = 2.0;

input group "=== 显示设置 ==="
input int      InpPanelX       = 10;
input int      InpPanelY       = 30;
```

---

## 25. 初始化与清理

### OnInit 标准流程
```cpp
int OnInit() {
   // 1. 初始化交易类
   trading.Init(InpMagicNumber, InpSlippage);
   
   // 2. 初始化统计类
   stats.Init(InpMagicNumber);
   
   // 3. 创建面板
   panel.Create(ChartID(), 0, "EAP", InpPanelX, InpPanelY);
   
   // 4. 设置面板参数
   panel.SetLot(InpLot);
   panel.SetSL(InpStopLoss);
   panel.SetTP(InpTakeProfit);
   
   // 5. 启用鼠标事件
   ChartSetInteger(ChartID(), CHART_EVENT_MOUSE_MOVE, true);
   
   return INIT_SUCCEEDED;
}
```

### OnDeinit 标准流程
```cpp
void OnDeinit(const int reason) {
   panel.Destroy();
   ChartSetInteger(ChartID(), CHART_EVENT_MOUSE_MOVE, false);
   Comment("");
}
```

---

# 第十部分：文本处理

## 26. 字符串操作

### 字符串替换
```cpp
string StringReplaceAll(string source, string find, string replace) {
   int pos = StringFind(source, find, 0);
   while(pos >= 0) {
      source = StringSubstr(source, 0, pos) + replace + 
               StringSubstr(source, pos + StringLen(find));
      pos = StringFind(source, find, pos + StringLen(replace));
   }
   return source;
}
```

### 格式化输出
```cpp
string FormatPrice(double price) {
   return StringFormat("%.5f", price);
}

string FormatProfit(double profit) {
   return StringFormat("%+.2f", profit);
}
```

### 字符串分割
```cpp
int StringSplit(string source, string delimiter, string &result[]) {
   ArrayResize(result, 0);
   int pos = 0, start = 0;
   while((pos = StringFind(source, delimiter, start)) >= 0) {
      ArrayResize(result, ArraySize(result) + 1);
      result[ArraySize(result) - 1] = StringSubstr(source, start, pos - start);
      start = pos + StringLen(delimiter);
   }
   ArrayResize(result, ArraySize(result) + 1);
   result[ArraySize(result) - 1] = StringSubstr(source, start);
   return ArraySize(result);
}
```

---

# 第十一部分：输入框

## 27. 编辑框操作

### 创建编辑框
```cpp
bool CreateEdit(string name, int x, int y, int w, int h, string defaultValue) {
   if(!ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0)) return false;
   
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clrDarkGray);
   ObjectSetString(0, name, OBJPROP_TEXT, defaultValue);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   return true;
}
```

### 读取编辑框值
```cpp
double ReadEditDouble(string name) {
   string text = ObjectGetString(0, name, OBJPROP_TEXT);
   return StringToDouble(text);
}

int ReadEditInteger(string name) {
   string text = ObjectGetString(0, name, OBJPROP_TEXT);
   return (int)StringToInteger(text);
}
```

### 设置编辑框值
```cpp
void SetEditString(string name, string value) {
   ObjectSetString(0, name, OBJPROP_TEXT, value);
}

void SetEditDouble(string name, double value, int digits = 2) {
   ObjectSetString(0, name, OBJPROP_TEXT, DoubleToString(value, digits));
}
```

### ⚠️ 关键BUG：输入框无法输入/值不保存

**问题现象**：点击编辑框无法输入文字，或输入的值点击其他地方后丢失。

**根因分析**：
1. 未设置 `OBJPROP_READONLY = false`（默认可能因版本不同而异）
2. 缺少 `CHARTEVENT_OBJECT_ENDEDIT` 事件处理，编辑完成后值未被读取保存
3. 切换Tab时编辑框被销毁，输入的值未先读取

**完整解决方案**：
```cpp
// 1. 创建编辑框时显式设置可编辑
bool CreateEdit(string name, int x, int y, int w, int h, string defaultValue) {
   if(!ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0)) return false;
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clrDarkGray);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_READONLY, false);  // ← 关键：允许编辑
   ObjectSetString(0, name, OBJPROP_TEXT, defaultValue);
   ObjectSetInteger(0, name, OBJPROP_ALIGN, ALIGN_CENTER);
   return true;
}

// 2. OnChartEvent中处理编辑完成事件
void OnChartEvent(const int id, const long &lparam, 
                  const double &dparam, const string &sp)
{
   // 鼠标移动事件处理...
   
   // 编辑完成事件：保存所有输入框的值
   if(id == CHARTEVENT_OBJECT_ENDEDIT)
   {
      if(StrStarts(sp, "EAP_"))
      {
         ReadAllEdits();   // 读取所有编辑框的值到变量
         ChartRedraw(0);
      }
      return;
   }
   
   // 点击事件处理...
}

// 3. 切换Tab前先读取编辑框值（防止数据丢失）
void SwitchTab(int tab)
{
   ReadAllEdits();  // ← 切换前保存
   ClearTabContent();
   // ... 构建新Tab内容
}
```

**编辑操作说明**：
- 单击编辑框 → 进入编辑模式
- 输入数值 → 编辑中
- 按 Enter 键 或 点击其他区域 → 完成编辑，触发 `CHARTEVENT_OBJECT_ENDEDIT`

---

# 第十二部分：按钮

## 28. 按钮操作

### 创建按钮
```cpp
bool CreateButton(string name, int x, int y, int w, int h, 
                  string text, color bgColor, color textColor) {
   if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0)) return false;
   
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
   ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   return true;
}
```

### 设置按钮状态
```cpp
void SetButtonColor(string name, color bgColor, color textColor) {
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
   ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
}

void SetButtonText(string name, string text) {
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}
```

### 按钮事件处理
```cpp
void HandleButtonClick(string buttonName) {
   if(buttonName == "Btn_Buy") {
      trading.OpenOrder(ORDER_TYPE_BUY, panel.GetLot(), panel.GetSL(), panel.GetTP());
   } else if(buttonName == "Btn_Sell") {
      trading.OpenOrder(ORDER_TYPE_SELL, panel.GetLot(), panel.GetSL(), panel.GetTP());
   } else if(buttonName == "Btn_CloseAll") {
      trading.CloseAll();
   }
}
```

---

# 第十三部分：调试与优化

## 29. 调试技巧

### 日志输出
```cpp
// 详细日志
void LogTrade(ENUM_ORDER_TYPE type, double lot, double price) {
   Print(StringFormat("[EA] %s | Lot: %.2f | Price: %.5f", 
                      type == ORDER_TYPE_BUY ? "BUY" : "SELL", lot, price));
}

// 错误日志
void LogError(string action, int errorCode) {
   Print(StringFormat("[EA] Error: %s failed, code: %d", action, errorCode));
}

// 定时日志
datetime g_lastLogTime = 0;
void LogAccountStatus() {
   if(TimeCurrent() - g_lastLogTime < 60) return;
   Print(StringFormat("[EA] Balance: %.2f | Equity: %.2f | Margin: %.2f",
                      AccountBalance(), AccountEquity(), AccountInfoDouble(ACCOUNT_MARGIN)));
   g_lastLogTime = TimeCurrent();
}
```

---

## 30. 性能优化

### 减少循环次数
```cpp
// ❌ 每次循环都调用函数
for(int i = 0; i < PositionsTotal(); i++) { ... }

// ✅ 先获取总数
int total = (int)PositionsTotal();
for(int i = 0; i < total; i++) { ... }
```

### 缓存高频访问数据
```cpp
double g_point;
int g_digits;
double g_minLot;

int OnInit() {
   g_point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   g_digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   g_minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   return INIT_SUCCEEDED;
}
```

### 避免频繁创建对象
```cpp
// ❌ 每次OnTick都创建
void OnTick() {
   CTrade trade;
   trade.Buy(lot, symbol);
}

// ✅ 使用全局对象
CTrade trade;
void OnTick() {
   trade.Buy(lot, symbol);
}
```

---

## 📝 更新日志

| 日期 | 更新内容 |
|------|---------|
| 2026-07-07 | 初始创建：记录10类常见错误及解决方案 |
| 2026-07-07 | 新增20条：从30+个成品源码中提取的最佳实践 |
| 2026-07-07 | 使用CTrade标准库替代原生OrderSend |
| 2026-07-07 | 添加时间过滤功能和移动止损功能 |
| 2026-07-07 | 修复CTrade平仓方法名：PositionClose() |
| 2026-07-07 | 修复时间函数：MQL5需用TimeToStruct() |
| 2026-07-07 | **重构：按12大分类重新组织知识库** |
| 2026-07-08 | 新增BUG快速索引表，7个历史BUG全收录 |
| 2026-07-08 | 新增拖拽无法停止BUG修复方案（MOUSE_MOVE检测sparam） |
| 2026-07-08 | 新增Z轴置顶方案（OBJPROP_BACK=false） |
| 2026-07-08 | 新增订单号显示不全解决方案（独立列布局） |
| 2026-07-08 | 新增输入框无法输入BUG修复（ENDEDIT事件+READONLY设置） |
| 2026-07-08 | 新增持仓页空数据标签显示问题（SwitchTab后调用UpdatePositions） |
| 2026-07-08 | **修正拖拽方案**：改用CHARTEVENT_CLICK结束拖拽，废弃sparam检测方案 |
| 2026-07-08 | 新增面板边界限制，防止拖出屏幕 |

---

## ☁️ 云端同步

此文件应保存到云端存储（如 GitHub、OneDrive、阿里云盘等），方便：
- 跨电脑访问
- 版本历史追溯
- 多人协作
- 分类快速调取

建议文件名：`MQL5_Knowledge_Base.md`

---

> **使用方式**: 每次编写 MQL5 代码前阅读此文件；每次修复新错误后在此追加记录。

---

# 第十四部分：多核对冲EA设计

## 31. 金戈铁马X3D 多核对冲EA架构

### 整体架构
```
┌─────────────────────────────────────────┐
│           金戈铁马X3D EA v2.00          │
├─────────────────────────────────────────┤
│  信号系统  │  交易引擎  │  风控系统  │ 面板  │
├─────────────────────────────────────────┤
│  多周期指标  │  开仓管理  │  移动止盈  │ 拖拽  │
│  自适应布林  │  加仓系统  │  浮亏保护  │ 统计  │
│  RSI+MA     │  平仓逻辑  │  时间过滤  │ 监控  │
├─────────────────────────────────────────┤
│           尾单对冲首单系统               │
└─────────────────────────────────────────┘
```

### 输入参数组织（group分区）
```cpp
input group "=== 基础设置 ==="
input ENUM_TRADE_MODE  InpTradeMode   = MODE_STEADY;
input double           InpInitialLot  = 0.01;

input group "=== 自定义开仓设置 ==="
input int              InpOpenPeriod     = 14;
input double           InpSignalStrength = 0.618;
input bool             InpUseAdaptive    = true;

input group "=== 自定义加仓设置 ==="
input ENUM_ADD_TYPE    InpAddType     = ADD_MARTIN;
input int              InpAddSpacing  = 500;
input double           InpMartinMult  = 1.5;
```

### 信号系统（多核）
```cpp
class CSignalSystem {
   // M1/M5 自适应布林
   int GetAdaptiveSignal(string symbol) {
      // 接近上轨 → 做空信号
      // 接近下轨 → 做多信号
   }
   
   // 主信号：MA趋势 + RSI超买超卖 + K线确认
   int GetMainSignal(string symbol) {
      // trend_up + rsi_buy + confirm_bars → BUY
      // trend_down + rsi_sell + confirm_bars → SELL
   }
};
```

### 加仓系统（三种模式）
```cpp
enum ENUM_ADD_TYPE {
   ADD_MARTIN,     // 马丁倍率：lot *= multiplier
   ADD_INCREASE,   // 递增手数：lot += fixed_amount
   ADD_CUSTOM      // 自定义列表：从预定义数组取
};

// 马丁倍率加仓
double GetNextLot(double current, int count) {
   return current * InpMartinMult * InpAddCoeff;
}

// 单K线限制
bool CheckKLineLimit(string symbol) {
   // 统计当前K线已加仓次数
   // 超过InpKDepth则禁止加仓
}
```

### 风控系统
```cpp
class CRiskControl {
   // 1. 浮亏全平保护
   bool CheckFloatProtect() {
      return (AccountProfit() <= -InpFloatProtectVal);
   }
   
   // 2. 均价移动止盈
   void CheckTrailingStop(string symbol, double &buy_sl, double &sell_sl) {
      // 盈利超过激活距离 → 启动追踪
      // 从峰值回撤锁定距离 → 设置止损
   }
   
   // 3. 回撤计算
   double GetDrawdown() {
      return (PeakEquity - CurrentEquity) / PeakEquity * 100;
   }
};
```

### 尾单对冲首单
```cpp
class CPairHedge {
   // 原理：首单+尾单组合盈利达到一定值后
   // 回撤即平仓首尾两单
   
   void Update(string symbol) {
      // 计算首单和尾单的组合盈亏
      double combo_pl = FirstPL + LastPL;
      
      if(combo_pl >= InpHedgeStartPL) {
         // 激活对冲追踪
         if(PeakComboPL - combo_pl >= InpHedgePullback) {
            CloseFirstAndLast();  // 平首尾两单
         }
      }
   }
};
```

### 时间过滤
```cpp
bool IsTradeTimeAllowed() {
   // 1. 时区偏移计算
   // 2. 开启时间段检查
   // 3. 禁止时间段检查
   
   int cur_min = dt.hour * 60 + dt.min;
   // 处理跨天时间（如22:00-06:00）
   if(start_min > end_min) { // 跨天
      if(cur_min < start_min && cur_min > end_min) return false;
   }
}
```

### 面板UI设计（暗色金戈主题）
```cpp
// 配色方案
color TITLE_BG    = C'35,30,25';   // 暗金背景
color TITLE_TEXT  = C'200,180,120'; // 金色文字
color PROFIT_BG   = C'20,25,20';   // 深绿背景
color PROFIT_TEXT = clrLimeGreen;   // 盈利绿
color LOSS_TEXT   = clrRed;         // 亏损红
color RISK_BG     = C'30,20,20';   // 暗红背景

// 布局层次
// 1. 标题栏（引擎名称+副标题+品种+魔术数字+状态）
// 2. 收益区（今日/昨日/累积）
// 3. 账户概览（余额/净值/保证金/比例）
// 4. 持仓监控（多单/空单/总盈亏）
// 5. 对冲状态（触发条件/当前状态）
// 6. 风控信息（浮盈亏/回撤）
// 7. 底部状态栏
```

### 收益统计持久化
```cpp
// 保存到文件（FILE_COMMON共享目录）
void SaveProfitHistory() {
   string filepath = "GoldenHorse\\GH_" + Magic + ".dat";
   int handle = FileOpen(filepath, FILE_WRITE|FILE_COMMON|FILE_BIN);
   FileWriteDouble(handle, g_total_profit);
   FileWriteInteger(handle, g_total_trades);
   FileClose(handle);
}

// 每日收益计算
void UpdateProfitStats() {
   static datetime last_day = 0;
   datetime cur_day = TimeCurrent() / 86400 * 86400;
   if(cur_day != last_day) {
      g_yesterday_profit = g_today_profit;
      g_today_profit = 0;
      last_day = cur_day;
   }
   // 从HistoryDeals统计今日收益
}
```

## 32. v2.1增强：加仓系统完善

### 加仓模式扩展（4种+方向控制）
```cpp
enum ENUM_ADD_TYPE {
   ADD_MARTIN,     // 马丁倍率
   ADD_INCREASE,   // 递增手数
   ADD_CUSTOM,     // 自定义列表
   ADD_FIBONACCI   // 斐波那契数列
};

enum ENUM_ADD_DIRECTION {
   ADD_BOTH,       // 双向加仓
   ADD_TREND,      // 顺势加仓（信号同向才加）
   ADD_REVERSE     // 逆势加仓（信号反向才加，马丁常用）
};
```

### ATR动态间距
```cpp
double GetAddSpacing(int add_count)
{
   double spacing = InpAddSpacing * m_point;
   
   if(InpUseSpacingATR) {
      double atr = iATR(m_symbol, PERIOD_CURRENT, InpATRPeriod, 0);
      if(atr > 0) spacing = atr * InpATRMult;
   }
   
   if(add_count > 0)
      spacing *= MathPow(InpAddSpacingMult, add_count);
   
   return spacing;
}
```

### 总手数限制 + 加仓后重置止损
```cpp
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
   double new_sl = (type == POSITION_TYPE_BUY) ? 
                   avg_price - sl_dist : avg_price + sl_dist;
   ModifySL(symbol, type, new_sl);
}
```

## 33. v2.1增强：平仓系统完善

### 7种平仓模式汇总
| 模式 | 触发条件 | 适用场景 |
|------|---------|---------|
| 单目标止盈 | 单笔盈利达目标 | 简单策略 |
| 阶梯止盈 | 多目标分批止盈 | 趋势跟踪 |
| 回撤止盈 | 盈利达峰值后回撤X% | 保护利润 |
| 信号平仓 | 反向信号出现 | 趋势反转 |
| 时间平仓 | 持仓时间/定时平仓 | 日内交易 |
| 对冲平仓 | 多空均价对冲盈利 | 震荡行情 |
| 移动止盈 | 跟随价格移动止损 | 趋势保护 |

### 盈利回撤平仓（核心逻辑）
```cpp
void CheckDrawdownClose(string symbol, int type)
{
   double total_pl = GetTotalProfit(symbol, type);
   double profit_per_lot = total_pl / total_lot / 0.01;
   
   double &peak_pl = (type == BUY) ? g_buy_peak_pl : g_sell_peak_pl;
   if(profit_per_lot > peak_pl) peak_pl = profit_per_lot;
   
   if(peak_pl >= InpDrawdownTrigger) {
      double drawdown_pct = (peak_pl - profit_per_lot) / peak_pl * 100;
      if(drawdown_pct >= InpDrawdownPercent) {
         CloseAllPositions(symbol, type);
         peak_pl = 0;
      }
   }
}
```

### 阶梯止盈（多目标分批）
```cpp
// 输入: InpMultiTargets = "0.5,1.0,2.0"
// 输入: InpMultiRatios = "0.3,0.3,0.4"
void CheckMultiTargetClose(string symbol, int type)
{
   static int target_reached = 0;
   
   for(int i = target_reached; i < targets.Size(); i++) {
      if(profit_per_lot >= targets[i]) {
         ClosePartial(symbol, type, ratios[i]);
         target_reached = i + 1;
      }
   }
}
```

### 时间平仓（两种方式）
```cpp
// 1. 定时平仓（每日固定时间）
if(cur_min == close_min) CloseAll();

// 2. 持仓K线数限制
int bars_held = (now - open_time) / PeriodSeconds();
if(bars_held >= InpMaxHoldBars) ClosePosition(ticket);
```

### 均价对冲平仓
```cpp
bool CheckAvgHedgeClose(string symbol, CTradeEngine &engine)
{
   double buy_avg = engine.GetAvgPrice(symbol, POSITION_TYPE_BUY);
   double sell_avg = engine.GetAvgPrice(symbol, POSITION_TYPE_SELL);
   
   if(sell_avg > buy_avg) {
      double hedge_profit = (sell_avg - buy_avg) * min_lot / point;
      if(hedge_profit >= target) {
         // 同时平掉多空等量仓位
         ClosePartial(BUY, 0.5);
         ClosePartial(SELL, 0.5);
         return true;
      }
   }
   return false;
}
```

## 34. v2.1增强：移动止盈3种模式

```cpp
enum ENUM_TRAILING_TYPE {
   TRAIL_FIXED,   // 固定间距（最常用）
   TRAIL_ATR,     // ATR动态间距（自适应波动）
   TRAIL_STEP     // 阶梯式（盈利越多锁利越多）
};

// ATR动态止盈
if(InpTrailingType == TRAIL_ATR) {
   double atr = iATR(symbol, PERIOD_CURRENT, 14, 0);
   lock_dist = atr * InpTrailATRMult;
}

// 阶梯式止盈
else if(InpTrailingType == TRAIL_STEP) {
   lock_dist = MathFloor(profit_points / step) * step * point;
}

// 阶梯止盈（另一种：预设档位）
// InpStepLevels = "200,400,600,800,1000"
// InpStepLocks  = "100,200,300,400,500"
```

## 35. v2.1增强：面板升级（420x580）

### 面板区块布局（共8大区块）
```
┌──────────────────────────────────────┐
│ 标题区（68px）：标题+周期+状态        │
├──────────────────────────────────────┤
│ 斩获区（56px）：今日/昨日/累计        │
├──────────────────────────────────────┤
│ 账户区（80px）：余额/净值/保证金/胜率  │
├──────────────────────────────────────┤
│ 持仓区（86px）：多/空单+均价+峰值      │
├──────────────────────────────────────┤
│ 对冲区（72px）：多空/净盈亏/止盈方式   │
├──────────────────────────────────────┤
│ 加仓区（64px）：方式/方向/层数/限制    │
├──────────────────────────────────────┤
│ 风控区（60px）：浮盈亏/回撤/模式      │
├──────────────────────────────────────┤
│ 底部（24px）：版权提示                │
└──────────────────────────────────────┘
```

### 新增显示字段
- 周期显示（M5/M15等）
- 交易次数 + 胜率 + 盈亏比
- 多单/空单/净盈亏 峰值盈利
- 加仓方向（顺势/逆势/双向）
- 总手数限制
- 平仓模式（单目标/阶梯/回撤）
- 止盈类型（固定/ATR/阶梯）

---

# 第十二部分：MT4网格EA专项修复

> 本章记录稳盈网格EA（Amazing3.1_Clean.mq4）修复过程中的4个关键BUG，适用于MT4/MQL4，但原理对MQL5同样适用。

## 36. 手动停止按钮无效（状态被覆盖）

### 错误现象
点击"停止做多"或"停止做空"按钮后，按钮状态显示正确，但下一次start()执行时交易立即恢复，停止功能形同虚设。

### 根因分析
start()函数每次执行时，在风控检查通过后自动将`g_allow_buy`/`g_allow_sell`设为true：

```cpp
// ❌ 错误写法：自动覆盖手动状态
if(!stopFlag)
{
   g_allow_buy = true;   // 每次都重置，覆盖用户手动停止
   g_allow_sell = true;
}
```

### 解决方案
新增`g_manual_stop_buy`/`g_manual_stop_sell`变量保存用户手动状态，自动检查通过后再检查手动状态：

```cpp
// 全局变量
bool g_manual_stop_buy  = false;  // 用户手动停止做多
bool g_manual_stop_sell = false;  // 用户手动停止做空

// ✅ 正确写法：手动状态优先
if(stopFlag)
{
   g_allow_buy = false;
   g_allow_sell = false;
}
else
{
   if(!g_manual_stop_buy)  g_allow_buy = true;
   if(!g_manual_stop_sell) g_allow_sell = true;
}
```

### 关键原则
**自动检查逻辑不应直接覆盖用户手动状态**，必须分离为两层：
1. 自动层：风控检查（点差/杠杆/单量等）
2. 手动层：用户操作（停止做多/做空）
手动层优先级高于自动层，但风控触发时两者都应停止。

---

## 37. 图表左上角显示异常数值

### 错误现象
图表左上角显示异常数值（如563122860.52和08:27:02），影响视觉。

### 根因分析
代码中有多处`Comment()`函数调用显示调试信息：

```cpp
// ❌ 错误写法：Comment显示调试信息
Comment(CountOrders(OP_BUY,Magic,"")+" "+CountOrders(OP_SELL,Magic,""));
Comment("Buy Profit ",buyProfit);
Comment("Sell Profit ",sellProfit);
Comment("Buy Loss ",buyProfit);
Comment("Sell Loss ",sellProfit);
```

### 解决方案
全部注释掉`Comment()`调用，改用面板UI显示：

```cpp
// ✅ 正确写法：注释掉Comment
//Comment(CountOrders(OP_BUY,Magic,"")+" "+CountOrders(OP_SELL,Magic,""));
//Comment("Buy Profit ",buyProfit);
//Comment("Sell Profit ",sellProfit);
```

### 关键原则
**禁止在start()中使用Comment()输出调试信息**，原因：
1. 每次tick刷新，屏幕闪烁
2. 显示未格式化的原始数据，视觉混乱
3. 正式版应使用面板UI或Print()日志

---

## 38. 变量重复定义（extern与input冲突）

### 错误现象
```
'DailyProfitTarget' - variable already defined
Amazing修改1.mq4  93  14
```

### 根因分析
同一变量名同时用`extern`和`input`声明，导致重复定义：

```cpp
// ❌ 错误写法：第58行extern + 第80行input，同名冲突
extern double DailyProfitTarget = 500.0;  // 第58行
// ...
input double DailyProfitTarget = 500.0;  // 第80行（input组内）
```

### 解决方案
删除`extern`定义，只保留`input`版本：

```cpp
// ✅ 正确写法：只保留input版本（推荐，input更严格）
input group "Session"
input bool   EnableDailyProfitTarget = true;
input double DailyProfitTarget       = 500.0;  // 每日盈利目标
```

### extern vs input 对比

| 特性 | extern | input |
|------|--------|-------|
| 作用域 | 全局 | 全局 |
| 参数面板显示 | 是 | 是 |
| 编译时检查 | 宽松 | 严格 |
| 推荐度 | 旧版兼容 | **推荐** |
| 重复定义报错 | 不报错 | 报错 |

**建议**：新代码统一使用`input`，旧代码迁移时删除同名`extern`。

---

## 39. 回测错误触发每日盈利目标（全局变量未重置）

### 错误现象
开启历史数据回测，EA未开任何订单，却显示"每日目标已达成(553.69/500)"，停止开仓。

### 根因分析
`RecordCloseProfit`函数使用`GlobalVariableGet/Set`存储统计数据，这些全局变量在MT4中是持久化的，回测时不会被清除：

```cpp
void RecordCloseProfit(double profit)
{
   datetime today_start = StringToTime(TimeToStr(TimeCurrent(),TIME_DATE) + " 00:00:00");
   datetime last_reset = (datetime)GlobalVariableGet("AMZ3_last_reset");

   // ❌ 问题：回测时此判断失效
   // last_reset = 2026年（之前测试的真实时间）
   // today_start = 2023年（回测历史时间）
   // 2026 < 2023 为 false，不会重置
   if(last_reset < today_start)
   {
      GlobalVariableSet("AMZ3_today_closed", 0.0);  // 不会执行
      GlobalVariableSet("AMZ3_last_reset", today_start);
   }

   GlobalVariableSet("AMZ3_today_closed",
      GlobalVariableGet("AMZ3_today_closed") + profit);  // 保留了旧值553.69
}
```

### 解决方案
在`init()`函数开头添加回测模式检测，强制重置所有全局变量：

```cpp
int init()
{
   // ✅ 回测模式：重置全局变量
   if(IsTesting())
   {
      GlobalVariableSet("AMZ3_today_closed", 0.0);
      GlobalVariableSet("AMZ3_yesterday_closed", 0.0);
      GlobalVariableSet("AMZ3_total_closed", 0.0);
      GlobalVariableSet("AMZ3_last_reset", 0);
      g_today_key = "";
      g_daily_target_locked = false;
   }
   // ... 其他初始化代码
}
```

### GlobalVariableSet持久化机制

| 场景 | 行为 | 需要处理 |
|------|------|----------|
| 实盘运行 | 变量持久化保存，跨日使用 | ✅ 正常 |
| Demo运行 | 变量持久化保存，跨日使用 | ✅ 正常 |
| 回测启动 | 变量保留之前实盘/Demo的数据 | ❌ 需重置 |
| 回测中 | 变量正常工作 | ✅ 正常 |
| 优化模式 | 变量保留之前数据 | ❌ 需重置 |

### 关键原则
**任何使用GlobalVariableGet/Set的EA，在init()中必须检测IsTesting()并重置相关变量**。否则回测会继承历史数据，导致统计错误、错误触发目标、面板显示异常。

---

## 📝 更新日志

| 日期 | 更新内容 |
|------|---------|
| 2026-07-07 | 初始创建：记录10类常见错误及解决方案 |
| 2026-07-07 | 新增20条：从30+个成品源码中提取的最佳实践 |
| 2026-07-07 | 使用CTrade标准库替代原生OrderSend |
| 2026-07-07 | 添加时间过滤功能和移动止损功能 |
| 2026-07-07 | 修复CTrade平仓方法名：PositionClose() |
| 2026-07-07 | 修复时间函数：MQL5需用TimeToStruct() |
| 2026-07-07 | **重构：按12大分类重新组织知识库** |
| 2026-07-08 | 新增BUG快速索引表，7个历史BUG全收录 |
| 2026-07-08 | 新增拖拽无法停止BUG修复方案（MOUSE_MOVE检测sparam） |
| 2026-07-08 | 新增Z轴置顶方案（OBJPROP_BACK=false） |
| 2026-07-08 | 新增订单号显示不全解决方案（独立列布局） |
| 2026-07-08 | 新增输入框无法输入BUG修复（ENDEDIT事件+READONLY设置） |
| 2026-07-08 | 新增持仓页空数据标签显示问题（SwitchTab后调用UpdatePositions） |
| 2026-07-08 | **修正拖拽方案**：改用CHARTEVENT_CLICK结束拖拽，废弃sparam检测方案 |
| 2026-07-08 | 新增面板边界限制，防止拖出屏幕 |
| 2026-07-08 | 新增多核对冲EA完整架构设计（信号/交易/风控/对冲/面板） |
| 2026-07-08 | **v2.1增强**：加仓4模式+方向控制+ATR间距+总手限 |
| 2026-07-08 | **v2.1增强**：平仓7种模式（单目标/阶梯/回撤/信号/时间/对冲/移动止盈） |
| 2026-07-08 | **v2.1增强**：面板调至420x580，新增峰值/胜率/交易次数显示 |
| 2026-07-18 | 新增第36章：手动停止按钮无效（手动状态被自动覆盖） |
| 2026-07-18 | 新增第37章：图表左上角显示异常数值（Comment()调试信息） |
| 2026-07-18 | 新增第38章：变量重复定义（extern与input冲突） |
| 2026-07-18 | 新增第39章：回测错误触发每日盈利目标（全局变量未重置） |
| 2026-07-18 | BUG索引表新增4条记录：手动停止/Comment异常/变量重复/回测全局变量 |