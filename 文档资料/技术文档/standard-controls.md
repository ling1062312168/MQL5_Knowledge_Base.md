# MQL5 标准控件模板参考

## 快速引入

所有标准控件都通过以下方式引入：

```mql5
#include <Controls\Controls.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\ComboBox.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\SpinEdit.mqh>
#include <Controls\ListView.mqh>
#include <Controls\Label.mqh>
#include <Controls\TabControl.mqh>
#include <Controls\Dialog.mqh>
```

---

## 1. 基础对话框容器 (CWndClient)

所有控件必须放在一个窗口容器里，通常使用 `CWndClient` 或 `CDialog`：

```mql5
//+------------------------------------------------------------------+
class CMyPanel : public CAppDialog {
public:
   CButton        m_button1;       // 普通按钮
   CButton        m_button2;       // 开关按钮
   CEdit          m_edit_lot;      // 文本输入
   CComboBox      m_combo_sym;     // 下拉框
   CCheckBox      m_chk_auto;      // 复选框
   CSpinEdit      m_spin_lots;     // 数值微调
   CLabel         m_lbl_lot;       // 文字标签

   int            OnInit() override;
   void           OnDeinit(const int reason) override;
   void           OnEvent(const int id, const long& lparam,
                          const double& dparam,
                          const string& sparam) override;

private:
   bool           CreateCommonControls();
   bool           CreateButtons();
};

//+------------------------------------------------------------------+
int CMyPanel::OnInit() {
   // 创建主窗口 (参数: 所属图表, 窗口名, 左上X, 左上Y, 宽, 高)
   if(!Create(ChartID(), "My EA Panel", 0, 0, 300, 400))
      return INIT_FAILED;

   // 创建子控件
   if(!CreateCommonControls())
      return INIT_FAILED;
   if(!CreateButtons())
      return INIT_FAILED;

   // 初始隐藏，等用户按按钮才显示
   Hide();

   return INIT_SUCCEEDED;
}
//+------------------------------------------------------------------+
```

---

## 2. CButton 按钮

### 2.1 普通按钮

```mql5
bool CMyPanel::CreateButtons() {
   // 文本按钮: 左上X=10, 左上Y=10, 宽=80, 高=25
   if(!m_button1.Create(m_chart_id, "btn_start",
                        m_subwin, 10, 10, 90, 25))
      return false;
   m_button1.Text("开始交易");
   m_button1.Color(clrWhite);
   m_button1.ColorBackground(clrForestGreen);   // 背景色
   m_button1.ColorBorder(clrNone);             // 无边框
   m_button1.FontSize(10);
   m_button1.Font("微软雅黑");
   Add(m_button1);   // ⚠️ 必须添加到对话框
   return true;
}
```

### 2.2 开关按钮 (切换状态)

```mql5
// 创建开关按钮 (保持按下状态)
if(!m_btn_toggle.Create(m_chart_id, "btn_toggle",
                        m_subwin, 110, 10, 90, 25))
   return false;
m_btn_toggle.Text("自动模式: 关");
m_btn_toggle.Color(clrWhite);
m_btn_toggle.ColorBackground(clrGray);
m_btn_toggle.Pressed(false);
Add(m_btn_toggle);

// 事件处理中切换状态
void CMyPanel::OnEvent(const int id, const long& lparam,
                        const double& dparam, const string& sparam) {
   if(id == CHARTEVENT_CUSTOM + BUTTON_CLICK) {
      if(StringFind(sparam, "btn_toggle") >= 0) {
         m_btn_toggle.Pressed(!m_btn_toggle.Pressed());
         if(m_btn_toggle.Pressed()) {
            m_btn_toggle.Text("自动模式: 开");
            m_btn_toggle.ColorBackground(clrForestGreen);
            m_auto_mode = true;
         } else {
            m_btn_toggle.Text("自动模式: 关");
            m_btn_toggle.ColorBackground(clrGray);
            m_auto_mode = false;
         }
      }
   }
}
```

### 2.3 图标按钮 (使用 BMP 资源)

```mql5
// 按钮绑定图标 (需先加载 BMP 图片资源)
// m_button.PictBackGapX(4);    // 图片与文字的水平间距
// m_button.PictBackGapY(2);   // 图片与文字的垂直间距
// m_button.BmpNameOn("ico_play_on.bmp");     // 正常状态图标
// m_button.BmpNameOff("ico_play_off.bmp");   // 按下状态图标
// m_button.BmpName(NULL);  // 只用文字，不带图标
```

---

## 3. CEdit 输入框

### 3.1 文本输入框

```mql5
// 创建文本输入框
if(!m_edit_lot.Create(m_chart_id, "edit_lot",
                        m_subwin, 110, 45, 90, 20))
   return false;
m_edit_lot.Text("0.01");            // 默认值
m_edit_lot.FontSize(10);
m_edit_lot.Font("Consolas");        // 等宽字体，数字更清晰
m_edit_lot.ColorBackground(clrWhiteSmoke);
m_edit_lot.Color(clrBlack);
Add(m_edit_lot);

// 读取用户输入
double GetLotSize() {
   double lot = StringToDouble(m_edit_lot.Text());
   return MathMax(lot, SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN));
}
```

### 3.2 数值微调框 (CSpinEdit)

```mql5
CSpinEdit m_spin_lots;

// 创建数值微调框 (带上下箭头)
if(!m_spin_lots.Create(m_chart_id, "spin_lots",
                        m_subwin, 110, 45, 90, 20))
   return false;
m_spin_lots.SetValue(1);           // 当前值
m_spin_lots.SetRange(1, 1000);     // 范围: 1~1000步长
m_spin_lots.Increment(1);          // 步长=1
m_spin_lots.FontSize(10);
Add(m_spin_lots);

// 获取数值
int GetMagicNumber() {
   return (int)m_spin_lots.Value();
}
```

---

## 4. CComboBox 下拉框

### 4.1 基础下拉框

```mql5
CComboBox m_combo_magic;
CComboBox m_combo_sym;

// 创建魔数选择下拉框
if(!m_combo_magic.Create(m_chart_id, "combo_magic",
                          m_subwin, 110, 70, 120, 20))
   return false;
// 添加选项项 (显示文本, 关联值)
m_combo_magic.AddItem("马丁策略 #101", 101);
m_combo_magic.AddItem("趋势策略 #102", 102);
m_combo_magic.AddItem("网格策略 #103", 103);
m_combo_magic.SelectText("马丁策略 #101"); // 默认选中
Add(m_combo_magic);

// 创建品种选择下拉框
if(!m_combo_sym.Create(m_chart_id, "combo_sym",
                        m_subwin, 110, 95, 120, 20))
   return false;
m_combo_sym.AddItem("EURUSD", 0);
m_combo_sym.AddItem("GBPUSD", 1);
m_combo_sym.AddItem("XAUUSD", 2);
m_combo_sym.AddItem("USDJPY", 3);
m_combo_sym.SelectText("EURUSD");
Add(m_combo_sym);

// 事件处理
void CMyPanel::OnEvent(const int id, const long& lparam,
                        const double& dparam, const string& sparam) {
   if(id == CHARTEVENT_CUSTOM + COMBO_BOX_SELECT) {
      if(StringFind(sparam, "combo_sym") >= 0) {
         // 获取当前选中项的索引
         int idx = m_combo_sym.Value();
         // 根据索引处理
         Print("用户选择了品种, 索引: ", idx);
      }
   }
}
```

---

## 5. CCheckBox 复选框

```mql5
CCheckBox m_chk_autotrade;
CCheckBox m_chk_trailing;
CCheckBox m_chk_newsfilter;

// 自动交易开关
if(!m_chk_autotrade.Create(m_chart_id, "chk_autotrade",
                             m_subwin, 10, 45, 100, 20))
   return false;
m_chk_autotrade.Text("自动交易");
m_chk_autotrade.Check(false);       // 默认不勾选
Add(m_chk_autotrade);

// 追踪止损开关
if(!m_chk_trailing.Create(m_chart_id, "chk_trailing",
                            m_subwin, 10, 70, 100, 20))
   return false;
m_chk_trailing.Text("追踪止损");
m_chk_trailing.Check(true);
Add(m_chk_trailing);

// 事件处理
void CMyPanel::OnEvent(const int id, const long& lparam,
                        const double& dparam, const string& sparam) {
   if(id == CHARTEVENT_CUSTOM + CHECK_BOX_CLICK) {
      if(StringFind(sparam, "chk_autotrade") >= 0) {
         bool is_checked = m_chk_autotrade.Check();
         m_autotrade_enabled = is_checked;
         Print("自动交易: ", is_checked ? "开启" : "关闭");
      }
   }
}
```

---

## 6. CLabel 文字标签

```mql5
CLabel m_lbl_title;
CLabel m_lbl_lot;
CLabel m_lbl_status;

// 标题
if(!m_lbl_title.Create(m_chart_id, "lbl_title",
                         m_subwin, 10, 10, 200, 20))
   return false;
m_lbl_title.Text("═══ 我的 EA 控制面板 ═══");
m_lbl_title.Color(clrGold);         // 金色标题
m_lbl_title.FontSize(12);
m_lbl_title.Font("微软雅黑");
m_lbl_title.Alignment(TEXT_ALIGN_CENTER); // 居中对齐
Add(m_lbl_title);

// 参数说明标签
if(!m_lbl_lot.Create(m_chart_id, "lbl_lot",
                       m_subwin, 10, 47, 100, 20))
   return false;
m_lbl_lot.Text("交易手数:");
m_lbl_lot.Color(clrWhite);
m_lbl_lot.FontSize(10);
Add(m_lbl_lot);

// 状态标签 (用于显示运行时信息)
if(!m_lbl_status.Create(m_chart_id, "lbl_status",
                          m_subwin, 10, 320, 280, 20))
   return false;
m_lbl_status.Text("状态: 等待信号...");
m_lbl_status.Color(clrLime);       // 绿色提示
m_lbl_status.FontSize(10);
Add(m_lbl_status);

// 动态更新状态 (在 OnTick 或定时器中调用)
void CMyPanel::UpdateStatus() {
   string status = StringFormat(
      "余额: %.2f | 持仓: %d | 盈亏: %.2f",
      AccountInfoDouble(ACCOUNT_BALANCE),
      PositionsTotal(),
      AccountInfoDouble(ACCOUNT_PROFIT)
   );
   m_lbl_status.Text(status);
}
```

---

## 7. CTabControl 选项卡 (分组页面)

```mql5
CTabControl m_tabs;
CLabel       m_tab1_lot;
CEdit        m_tab1_edit_lot;
CCheckBox    m_tab1_chk_auto;
CLabel       m_tab2_lbl;
CSpinEdit    m_tab2_spin_sl;
CSpinEdit    m_tab2_spin_tp;

// 创建选项卡控件
if(!m_tabs.Create(m_chart_id, "tabs", m_subwin, 5, 25, 290, 340))
   return false;
// 背景色设为透明，融入对话框
m_tabs.ColorBack(CLR_OWN);
m_tabs.Color(clrWhite);
Add(m_tabs);

// ===== Tab 1: 基础参数 =====
// Tab页内控件也需要创建，但事件处理和布局由Tab内部处理
if(!m_tab1_lot.Create(m_chart_id, "tab1_lot",
                        m_subwin, 15, 55, 80, 20))
   return false;
m_tab1_lot.Text("手数:");
m_tab1_lot.Color(clrWhite);
Add(m_tab1_lot);

// ⚠️ 重要: 控件要放在对应的Tab页中
m_tabs.Add(m_tab1_lot);  // 这会把控件放到当前Tab页
```

---

## 8. CListView 列表视图 (多行选择)

```mql5
CListView m_list_orders;

// 创建列表视图
if(!m_list_orders.Create(m_chart_id, "list_orders",
                          m_subwin, 10, 200, 280, 100))
   return false;
m_list_orders.View(LISTVIEW_REPORT);      // 报表视图(可排序列)
m_list_orders.HeaderFlags(0);              // 无列头
m_list_orders.ColorBackground(clrWhiteSmoke);
m_list_orders.Color(clrBlack);
m_list_orders.FontSize(9);

// 添加列 (仅在 REPORT 视图下)
m_list_orders.AddColumn("订单号", 60);
m_list_orders.AddColumn("品种", 60);
m_list_orders.AddColumn("类型", 40);
m_list_orders.AddColumn("盈亏", 60);

// 添加数据行
m_list_orders.AddItem("12345|EURUSD|买入|+10.5");
m_list_orders.AddItem("12346|GBPUSD|卖出|-3.2");
Add(m_list_orders);
```

---

## 9. CWndObj 通用控件基类

`CWndObj` 是所有控件的基类，如果你需要自定义控件继承它：

```mql5
//+------------------------------------------------------------------+
//| 自定义控件: 盈亏显示框                                           |
//+------------------------------------------------------------------+
class CProfitDisplay : public CWndObj {
public:
   double         m_profit;

   bool           Create(const long chart, const string name,
                         const int subwin, const int x, const int y,
                         const int width, const int height) override {
      if(!CWndObj::Create(chart, name, subwin, x, y, width, height))
         return false;
      m_profit = 0.0;
      return true;
   }

   void           SetProfit(double profit) {
      m_profit = profit;
      // 根据盈亏正负设置不同颜色
      if(profit > 0)
         Color(clrLime);
      else if(profit < 0)
         Color(clrRed);
      else
         Color(clrGray);
      Text(StringFormat("%.2f", profit));
      m_profit = profit;
      Redraw();
   }
};
```

---

## 10. 完整面板初始化模板

以下是一个完整 `CMyDialog` 的初始化函数模板，可直接复制使用：

```mql5
//+------------------------------------------------------------------+
//| CMyDialog: 面板主类                                              |
//+------------------------------------------------------------------+
class CMyDialog : public CAppDialog {
private:
   // 控件声明
   CButton        m_btn_start;       // 开始按钮
   CButton        m_btn_stop;         // 停止按钮
   CButton        m_btn_close;        // 平仓按钮
   CEdit          m_edit_lot;        // 手数输入
   CComboBox      m_combo_sym;       // 品种选择
   CComboBox      m_combo_magic;     // 策略选择
   CCheckBox      m_chk_autotrade;   // 自动交易
   CCheckBox      m_chk_trailing;    // 追踪止损
   CSpinEdit      m_spin_sl;         // 止损点数
   CSpinEdit      m_spin_tp;         // 止盈点数
   CLabel         m_lbl_lot;        // 手数标签
   CLabel         m_lbl_status;      // 状态显示
   CTabControl    m_tabs;            // 选项卡

public:
   int            OnInit() override;
   void           OnDeinit(const int reason) override;
   void           OnEvent(const int id, const long& lparam,
                          const double& dparam,
                          const string& sparam) override;
   void           ShowPanel();
   void           HidePanel();
   bool           IsVisible() { return (m_subwin != -1); }

private:
   bool           CreateHeader();
   bool           CreateTradingControls();
   bool           CreateSymbolControls();
   bool           CreateSLTPCtrls();
   bool           CreateTabControls();
   bool           CreateButtons();
   void           UpdateStatus();
};

//+------------------------------------------------------------------+
//| 初始化面板                                                       |
//+------------------------------------------------------------------+
int CMyDialog::OnInit() {
   // 1. 创建主对话框窗口
   if(!Create(ChartID(), "EA Trading Panel", 0, 0, 320, 480))
      return INIT_FAILED;

   // 2. 按顺序创建各组控件
   if(!CreateHeader())
      return INIT_FAILED;
   if(!CreateTradingControls())
      return INIT_FAILED;
   if(!CreateSymbolControls())
      return INIT_FAILED;
   if(!CreateSLTPCtrls())
      return INIT_FAILED;
   if(!CreateButtons())
      return INIT_FAILED;

   // 3. 默认隐藏，用户通过 OnChartEvent 快捷键唤出
   Hide();
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| 显示/隐藏面板 (通过快捷键 F11 切换)                              |
//+------------------------------------------------------------------+
void CMyDialog::ShowPanel() {
   if(!IsVisible()) {
      // 切换到显示状态
      if(ChartWindowAdd(ChartID(), m_subwin)) {
         Show();
         ChartRedraw();
      }
   }
}

void CMyDialog::HidePanel() {
   Hide();
   ChartRedraw();
}
```

---

## 事件类型常量参考

| 控件 | 事件常量 |
|------|----------|
| CButton | `BUTTON_CLICK` |
| CEdit | `EDIT_CHANGE`, `EDIT_TEXT_END` |
| CComboBox | `COMBO_BOX_SELECT` |
| CCheckBox | `CHECK_BOX_CLICK` |
| CSpinEdit | `SPIN_EDIT_CHANGE` |
| CListView | `LISTVIEW_CLICK`, `LISTVIEW_DBL_CLICK` |
| CTabControl | `TAB_CONTROL_CLICK` |

## 事件处理模式

```mql5
void CMyDialog::OnEvent(const int id, const long& lparam,
                        const double& dparam, const string& sparam) {
   // 先调用父类处理 (内部会分发 CHARTEVENT_CUSTOM 事件)
   base::OnEvent(id, lparam, dparam, sparam);

   // ===== 自定义处理 =====

   // 按钮点击
   if(id == CHARTEVENT_CUSTOM + BUTTON_CLICK) {
      if(sparam == m_btn_start.Name()) {
         // 处理开始按钮点击
      } else if(sparam == m_btn_close.Name()) {
         // 处理平仓按钮点击
      }
   }

   // 下拉框选择
   if(id == CHARTEVENT_CUSTOM + COMBO_BOX_SELECT) {
      if(sparam == m_combo_sym.Name()) {
         // 用户选择了不同品种
      }
   }

   // 复选框
   if(id == CHARTEVENT_CUSTOM + CHECK_BOX_CLICK) {
      if(sparam == m_chk_autotrade.Name()) {
         m_autotrade = m_chk_autotrade.Check();
      }
   }
}
```

---

## 常见问题

**Q: 控件显示但点击没反应？**
A: 检查是否调用了 `Add(控件对象)` 把控件添加到对话框，以及 `OnEvent` 是否正确处理了事件。

**Q: 控件位置偏移？**
A: 控件坐标是相对于对话框左上角，而不是图表左上角。建议使用布局管理器 (参考 `layout-system.md`) 统一管理位置。

**Q: 输入框只能输入数字？**
A: 使用 `CEdit`，可通过 `ReadOnly()` 限制编辑权限，或在 `OnEvent` 的 `EDIT_CHANGE` 中验证输入合法性。

**Q: 想让面板始终显示在图表上，不隐藏？**
A: 在 `OnInit()` 中不调用 `Hide()`，并在 `Create()` 时指定固定位置即可。
