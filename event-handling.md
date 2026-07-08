# 事件处理 — 按钮点击 / 下拉选择 / 焦点管理

## 概述

MQL5 的图表事件通过 `OnChartEvent` 统一分发。标准控件的事件处理依赖于 `CAppDialog` 基类，它负责将 `CHARTEVENT_CUSTOM+` 事件路由到具体控件。

两种主要面板的事件处理方式：

| 面板类型 | 事件ID | 触发条件 |
|---------|--------|---------|
| 标准控件 (CAppDialog) | `CHARTEVENT_CUSTOM+N` | 控件内部封装 |
| 图表对象 (OBJ_BUTTON) | `CHARTEVENT_OBJECT_CLICK` | 鼠标点击按钮对象 |

---

## 1. ⭐ 图表对象按钮事件（最常用）

使用 `OBJ_BUTTON` 等图表对象时，所有点击事件统一通过 `CHARTEVENT_OBJECT_CLICK` 分发。这种方式是从你源码中提炼的最常见模式：

```mql5
//+------------------------------------------------------------------+
//| 事件入口 — 两种面板类型共用                                       |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam,
                  const double &dparam, const string &sparam) {
   // 图表对象按钮点击（图表对象法）
   if(id == CHARTEVENT_OBJECT_CLICK) {
      HandleButtonClick(sparam);  // sparam = 被点击对象的名称
      return;
   }

   // 标准控件事件（CAppDialog 法）
   if(id >= CHARTEVENT_CUSTOM) {
      g_panel.OnEvent(id, lparam, dparam, sparam);
   }
}

//+------------------------------------------------------------------+
//| 按钮点击路由（提取自你源码中的 HandleButtonClick）                  |
//+------------------------------------------------------------------+
void HandleButtonClick(string buttonName) {
   // 安全检查：确认对象属于本面板
   if(StringFind(buttonName, PREFIX) != 0)
      return;  // 不是本面板的按钮，忽略

   // 去掉前缀，得到内部名称
   string name = StringSubstr(buttonName, StringLen(PREFIX));

   // === 开始/停止 ===
   if(name == "btn_start") {
      OnStartTrading();
      return;
   }
   if(name == "btn_stop") {
      OnStopTrading();
      return;
   }

   // === 平仓按钮 ===
   if(name == "CloseAllLong") {
      if(!ConfirmDialog("Close all LONG positions?"))
         return;
      CloseAllByType(POSITION_TYPE_BUY);
      UpdatePanel();
      return;
   }
   if(name == "CloseAllShort") {
      if(!ConfirmDialog("Close all SHORT positions?"))
         return;
      CloseAllByType(POSITION_TYPE_SELL);
      UpdatePanel();
      return;
   }

   // === Magic 模式按钮 ===
   if(name == "ToggleMode") {
      // 切换 Magic/Ticket 模式
      string input = ObjectGetString(0, buttonName, OBJPROP_TEXT);
      ApplyMagic(StringToInteger(input));
      return;
   }
}
```

---

## 3. CAppDialog 内置事件处理

`CAppDialog`（Controls.mqh）已封装好大部分事件路由。继承它之后，只需重写以下虚函数：

```mql5
class CEAPanel : public CAppDialog {
public:
   virtual bool      OnEvent(const int id, const long &lparam,
                              const double &dparam,
                              const string &sparam) {
      // 优先匹配具体事件
      if(id == CHARTEVENT_CUSTOM + 1) {
         // 按钮点击事件 (BUTTON_CLICKED)
         Print("按钮被点击: ", sparam);
         return true;
      }
      // ComboBox 选择事件
      if(id == CHARTEVENT_CUSTOM + 2) {
         Print("下拉框选择: ", sparam);
         return true;
      }
      // Edit 输入完成事件
      if(id == CHARTEVENT_CUSTOM + 3) {
         Print("输入框内容: ", sparam);
         return true;
      }

      // 交给默认处理
      return CAppDialog::OnEvent(id, lparam, dparam, sparam);
   }
};
```

---

### 2. 按钮点击事件（CAppDialog）

### 2.1 标准控件按钮

```mql5
class CEAPanel : public CAppDialog {
private:
   CButton            m_btn_start;
   CButton            m_btn_stop;
   CButton            m_btn_close;

public:
   int               OnInit() {
      if(!Create(0, "EA面板", 0, 10, 10, 280, 380))
         return INIT_FAILED;

      // 创建按钮
      int btn_x = 10, btn_y = 310, btn_w = 80, btn_h = 28;

      m_btn_start.Create(0, "btn_start", m_subwin,
                          btn_x, btn_y, btn_w, btn_h);
      m_btn_start.Text("开始");
      m_btn_start.Color(clrWhite);
      m_btn_start.ColorBackground(C'30, 100, 30'));
      Add(m_btn_start);

      m_btn_stop.Create(0, "btn_stop", m_subwin,
                         btn_x + 90, btn_y, btn_w, btn_h);
      m_btn_stop.Text("停止");
      m_btn_stop.Color(clrWhite);
      m_btn_stop.ColorBackground(C'100, 30, 30'));
      m_btn_stop.Enabled(false);
      Add(m_btn_stop);

      m_btn_close.Create(0, "btn_close", m_subwin,
                          btn_x + 180, btn_y, btn_w, btn_h);
      m_btn_close.Text("平仓");
      m_btn_close.Color(clrWhite);
      m_btn_close.ColorBackground(C'80, 60, 20'));
      Add(m_btn_close);

      return INIT_SUCCEEDED;
   }

   // 重写按钮点击事件
   virtual bool      OnEvent(const int id, const long &lparam,
                              const double &dparam,
                              const string &sparam) {
      if(id == CHARTEVENT_CUSTOM + 1) {
         if(sparam == "btn_start") {
            OnStartClick();
            return true;
         }
         if(sparam == "btn_stop") {
            OnStopClick();
            return true;
         }
         if(sparam == "btn_close") {
            OnCloseClick();
            return true;
         }
      }
      return CAppDialog::OnEvent(id, lparam, dparam, sparam);
   }

private:
   void              OnStartClick() {
      Print("开始交易!");
      m_btn_start.Enabled(false);
      m_btn_stop.Enabled(true);
      m_lb_status.Text("状态: 运行中");
      m_lb_status.Color(clrLime);
      // 触发 EA 开始逻辑
   }

   void              OnStopClick() {
      Print("停止交易!");
      m_btn_start.Enabled(true);
      m_btn_stop.Enabled(false);
      m_lb_status.Text("状态: 已停止");
      m_lb_status.Color(clrOrange);
      // 触发 EA 停止逻辑
   }

   void              OnCloseClick() {
      Print("平仓所有!");
      // CloseAllPositions()
   }
};
```

---

### 3. 下拉框 (ComboBox) 选择事件

```mql5
class CEAPanel : public CAppDialog {
private:
   CComboBox          m_cb_risk_mode;
   CComboBox          m_cb_symbol;
   CLabel             m_lb_current;

public:
   int               OnInit() {
      // ... 面板初始化 ...

      // 风险模式
      m_cb_risk_mode.Create(0, "cb_risk", m_subwin,
                              80, 50, 140, 22);
      m_cb_risk_mode.AddItem("固定手数");
      m_cb_risk_mode.AddItem("固定比例(%)");
      m_cb_risk_mode.AddItem("ATR动态");
      m_cb_risk_mode.Select(0);
      Add(m_cb_risk_mode);

      // 品种
      m_cb_symbol.Create(0, "cb_symbol", m_subwin,
                          80, 80, 140, 22);
      string symbols[] = {"EURUSD", "GBPUSD", "USDJPY",
                          "XAUUSD", "BTCUSD"};
      for(int i = 0; i < ArraySize(symbols); i++)
         m_cb_symbol.AddItem(symbols[i]);
      m_cb_symbol.Select(0);
      Add(m_cb_symbol);

      // 当前选择标签
      m_lb_current.Create(0, "lb_sel", m_subwin,
                           10, 110, 260, 18);
      m_lb_current.Text("当前: 固定手数 / EURUSD");
      m_lb_current.Color(clrYellow);
      Add(m_lb_current);

      return INIT_SUCCEEDED;
   }

   virtual bool      OnEvent(const int id, const long &lparam,
                              const double &dparam,
                              const string &sparam) {
      // ComboBox 选中事件 ID = CHARTEVENT_CUSTOM + 2
      if(id == CHARTEVENT_CUSTOM + 2) {
         OnComboBoxChange(sparam);
         return true;
      }
      return CAppDialog::OnEvent(id, lparam, dparam, sparam);
   }

private:
   void              OnComboBoxChange(const string ctrl_name) {
      if(ctrl_name == "cb_risk") {
         int idx = m_cb_risk_mode.Value();
         string items[] = {"固定手数", "固定比例(%)", "ATR动态"};
         if(idx >= 0 && idx < ArraySize(items))
            Print("风险模式切换为: ", items[idx]);
         // 刷新显示
         UpdateStatusLabel();
      }
      else if(ctrl_name == "cb_symbol") {
         int idx = m_cb_symbol.Value();
         string symbols[] = {"EURUSD", "GBPUSD", "USDJPY",
                            "XAUUSD", "BTCUSD"};
         if(idx >= 0 && idx < ArraySize(symbols))
            Print("交易品种切换为: ", symbols[idx]);
         UpdateStatusLabel();
      }
   }

   void              UpdateStatusLabel() {
      string risk_items[] = {"固定手数", "固定比例(%)", "ATR动态"};
      string sym_items[] = {"EURUSD", "GBPUSD", "USDJPY",
                            "XAUUSD", "BTCUSD"};
      int r = m_cb_risk_mode.Value();
      int s = m_cb_symbol.Value();
      string txt = "当前: " + risk_items[r] + " / " +
                   sym_items[s];
      m_lb_current.Text(txt);
   }
};
```

---

### 4. 输入框 (Edit) 输入完成事件

```mql5
class CEAPanel : public CAppDialog {
private:
   CEdit              m_ed_lot;
   CEdit              m_ed_sl;
   CEdit              m_ed_tp;
   CLabel             m_lb_err;

public:
   virtual bool      OnEvent(const int id, const long &lparam,
                              const double &dparam,
                              const string &sparam) {
      // Edit 提交事件 ID = CHARTEVENT_CUSTOM + 3
      // 触发条件: 输入框失焦 (点击其他区域) 或按 Enter
      if(id == CHARTEVENT_CUSTOM + 3) {
         OnEditSubmit(sparam);
         return true;
      }

      // ENTER 键提交 (KEYDOWN 事件自行处理)
      if(id == CHARTEVENT_KEYDOWN && lparam == KEY_ENTER) {
         // 找到当前聚焦的输入框并提交
         OnEditSubmit(GetFocusedEditName());
         return true;
      }

      return CAppDialog::OnEvent(id, lparam, dparam, sparam);
   }

private:
   string            GetFocusedEditName() {
      if(m_ed_lot.Focus())     return "ed_lot";
      if(m_ed_sl.Focus())      return "ed_sl";
      if(m_ed_tp.Focus())      return "ed_tp";
      return "";
   }

   void              OnEditSubmit(const string ctrl_name) {
      if(ctrl_name == "ed_lot") {
         double lot = StringToDouble(m_ed_lot.Text());
         if(lot < 0.01 || lot > 1.0) {
            m_lb_err.Text("错误: 手数必须在 0.01~1.0 之间");
            m_lb_err.Color(clrRed);
            m_ed_lot.ColorBackground(clrDarkRed);
            return;
         }
         m_lb_err.Text("");
         m_ed_lot.ColorBackground(C'25, 25, 35');
         Print("手数设置为: ", lot);
      }
      else if(ctrl_name == "ed_sl") {
         int sl = (int)StringToInteger(m_ed_sl.Text());
         Print("止损设置为: ", sl, " 点");
      }
      else if(ctrl_name == "ed_tp") {
         int tp = (int)StringToInteger(m_ed_tp.Text());
         Print("止盈设置为: ", tp, " 点");
      }
   }
};
```

---

### 5. 复选框 / 单选框事件

```mql5
class CEAPanel : public CAppDialog {
private:
   CCheckBox          m_cb_martingale;
   CCheckBox          m_cb_hedge;
   CCheckBox          m_cb_news_filter;

public:
   virtual bool      OnEvent(const int id, const long &lparam,
                              const double &dparam,
                              const string &sparam) {
      // CheckBox 状态变化事件 ID = CHARTEVENT_CUSTOM + 4
      if(id == CHARTEVENT_CUSTOM + 4) {
         bool checked = (lparam != 0);
         OnCheckChange(sparam, checked);
         return true;
      }
      return CAppDialog::OnEvent(id, lparam, dparam, sparam);
   }

private:
   void              OnCheckChange(const string name, bool checked) {
      if(name == "cb_mg") {
         Print("马丁格尔: ", checked ? "启用" : "禁用");
         m_sp_multiplier.Enabled(checked);
      }
      else if(name == "cb_hedge") {
         Print("对冲模式: ", checked ? "启用" : "禁用");
      }
      else if(name == "cb_news") {
         Print("新闻过滤: ", checked ? "启用" : "禁用");
         // 显示/隐藏新闻设置组
      }
   }
};
```

---

### 6. 数字微调框 (SpinEdit) 事件

```mql5
class CEAPanel : public CDialog {
private:
   CSpinEdit          m_sp_multiplier;

public:
   virtual bool      OnEvent(const int id, const long &lparam,
                              const double &dparam,
                              const string &sparam) {
      // SpinEdit 变化事件 (继承 Edit 事件)
      if(id == CHARTEVENT_CUSTOM + 3 && sparam == "sp_mult") {
         int val = m_sp_multiplier.Value();
         Print("马丁系数: ", val);
         return true;
      }
      return CDialog::OnEvent(id, lparam, dparam, sparam);
   }
};
```

---

### 7. Tab 切换事件

```mql5
class CEAPanel : public CAppDialog {
private:
   CTabControl        m_tab;
   CLabel             m_lb_tab_info;

public:
   virtual bool      OnEvent(const int id, const long &lparam,
                              const double &dparam,
                              const string &sparam) {
      // Tab 切换事件 ID = CHARTEVENT_CUSTOM
      if(id == CHARTEVENT_CUSTOM && sparam == "MainTabs") {
         int sel = m_tab.SelectedTab();
         string tabs[] = {"参数", "控制", "日志"};
         Print("切换到 Tab: ", tabs[sel]);
         OnTabChanged(sel);
         return true;
      }
      return CAppDialog::OnEvent(id, lparam, dparam, sparam);
   }

private:
   void              OnTabChanged(int idx) {
      if(idx == 0) {
         // 参数页 — 可刷新参数显示
      }
      else if(idx == 1) {
         // 控制页 — 可刷新状态
         UpdateTradeStatus();
      }
      else if(idx == 2) {
         // 日志页 — 可加载最新日志
         RefreshLogList();
      }
   }
};
```

---

### 8. 鼠标悬停提示 (Tooltip)

```mql5
class CEAPanel : public CAppDialog {
private:
   // 为控件添加 Tooltip (通过 CWndObj 的 Tooltip 属性)
   void              SetupTooltips() {
      m_ed_lot.Tooltip("交易手数，最小0.01，最大1.0手");
      m_ed_sl.Tooltip("止损距离，单位为交易品种的点数");
      m_ed_tp.Tooltip("止盈距离，设为0则不使用止盈");
      m_cb_risk_mode.Tooltip("风险管理模式:\n"
                              "• 固定手数: 每笔固定开仓量\n"
                              "• 固定比例: 按账户余额比例计算\n"
                              "• ATR动态: 根据波动率调整");
   }
};
```

---

### 9. 键盘快捷键

```mql5
class CEAPanel : public CAppDialog {
private:
   bool              OnKeyboardDown(const int key) {
      switch(key) {
         case KEY_F1:
            ShowHelp();
            return true;
         case KEY_F2:
            TogglePanel();  // 折叠/展开面板
            return true;
         case KEY_ESCAPE:
            // 关闭面板或取消输入
            if(IsInputFocused())
               ClearInputFocus();
            return true;
         case KEY_TAB:
            // 在输入框之间切换焦点
            MoveFocusToNextEdit();
            return true;
      }
      return false;
   }

   bool              IsInputFocused() {
      return m_ed_lot.Focus() || m_ed_sl.Focus() ||
             m_ed_tp.Focus();
   }

   void              ClearInputFocus() {
      m_ed_lot.Focus(false);
      m_ed_sl.Focus(false);
      m_ed_tp.Focus(false);
   }

   void              MoveFocusToNextEdit() {
      if(m_ed_lot.Focus())       { m_ed_lot.Focus(false); m_ed_sl.Focus(true); }
      else if(m_ed_sl.Focus())   { m_ed_sl.Focus(false); m_ed_tp.Focus(true); }
      else                        { m_ed_tp.Focus(false); m_ed_lot.Focus(true); }
   }
};
```

---

### 10. 事件 ID 速查表

| 控件 | 事件 ID | sparam | lparam / dparam |
|------|---------|--------|----------------|
| CButton | `CHARTEVENT_CUSTOM+1` | 控件名 | - |
| CComboBox | `CHARTEVENT_CUSTOM+2` | 控件名 | - |
| CEdit | `CHARTEVENT_CUSTOM+3` | 控件名 | - |
| CCheckBox | `CHARTEVENT_CUSTOM+4` | 控件名 | 1=选中, 0=未选中 |
| CSpinEdit | `CHARTEVENT_CUSTOM+3` | 控件名 | - |
| CTabControl | `CHARTEVENT_CUSTOM` | Tab名 | - |
| ListView/ListBox | `CHARTEVENT_CUSTOM+5` | 控件名 | 选中索引 |
| CWndClient 背景点击 | `CHARTEVENT_CUSTOM+ON_CLICK_CLIENT` | - | - |
