# 布局系统 — Grid / VBox / HBox / Tab / GroupBox

## 概述

MQL5 标准库没有内置布局管理器，所有控件的位置都需要手动计算。本模块提供一套轻量布局类，帮你自动排版，再也不用手动算 X/Y 坐标。

---

## 1. 布局核心类

### 1.1 CGridLayout — 网格布局

适用于参数表格（标签 + 输入框成对排列）。

```mql5
//+------------------------------------------------------------------+
//| 网格布局                                                         |
//+------------------------------------------------------------------+
class CGridLayout {
private:
   int               m_x, m_y;        // 起始坐标
   int               m_col_widths[];  // 每列宽度
   int               m_row_height;     // 行高
   int               m_hgap;          // 列间距
   int               m_vgap;          // 行间距
   int               m_cur_col;       // 当前列
   int               m_cur_row;       // 当前行
   int               m_max_cols;      // 总列数

public:
   // col_widths: 每列宽度数组 (标签列/输入列/单位列)
   // row_height: 每行高度
   // hgap/vgap: 间距
   CGridLayout(int x, int y, int max_cols,
               const int &col_widths[],
               int row_height = 22,
               int hgap = 8, int vgap = 4) {
      m_x = x; m_y = y;
      m_max_cols = max_cols;
      ArrayCopy(m_col_widths, col_widths);
      m_row_height = row_height;
      m_hgap = hgap;
      m_vgap = vgap;
      m_cur_col = 0;
      m_cur_row = 0;
   }

   // 获取下一个控件的坐标和大小
   void              Next(int &x, int &y, int &w, int &h) {
      x = m_x;
      for(int i = 0; i < m_cur_col; i++)
         x += m_col_widths[i] + m_hgap;

      y = m_y + m_cur_row * (m_row_height + m_vgap);
      w = m_col_widths[m_cur_col];
      h = m_row_height;

      m_cur_col++;
      if(m_cur_col >= m_max_cols) {
         m_cur_col = 0;
         m_cur_row++;
      }
   }

   // 跳过若干列（用于跨列大控件）
   void              SkipCols(int cols) {
      m_cur_col += cols;
      if(m_cur_col >= m_max_cols) {
         m_cur_col = 0;
         m_cur_row++;
      }
   }

   int               TotalWidth() const {
      int total = 0;
      for(int i = 0; i < ArraySize(m_col_widths); i++)
         total += m_col_widths];
      total += (m_max_cols - 1) * m_hgap;
      return total;
   }

   int               TotalHeight() const {
      return (m_cur_row + 1) * (m_row_height + m_vgap) - m_vgap;
   }

   int               CurrentY() const {
      return m_y + m_cur_row * (m_row_height + m_vgap);
   }

   void              NewRow() {
      m_cur_col = 0;
      m_cur_row++;
   }

   int               GetX() const { return m_x; }
   int               GetY() const { return m_y; }
   void              SetX(int x) { m_x = x; }
   void              SetY(int y) { m_y = y; }
};
```

#### CGridLayout 使用示例

```mql5
// 标签宽度=80, 输入框宽度=120, 单位列=50
int col_widths[] = {80, 120, 50};
CGridLayout grid(10, 10, 3, col_widths, 22, 6, 4);

int x, y, w, h;

// 第一行: 标签 + 输入框 + 单位
grid.Next(x, y, w, h);
CEdit ed_lot;  ed_lot.Create(0, "ed_lot", 0, x, y, w, h);
CLabel lb_lot; lb_lot.Create(0, "lb_lot", 0, x, y, w, h);
lb_lot.Text("手数");

grid.Next(x, y, w, h);
CEdit ed_lot_input; ed_lot_input.Create(0, "ed_lot_val", 0, x, y, w, h);

grid.Next(x, y, w, h);
CLabel lb_unit; lb_unit.Create(0, "lb_unit", 0, x, y, w, h);
lb_unit.Text("手");

// 第二行
grid.Next(x, y, w, h);
// ... 同上
```

---

### 1.2 CVBox — 垂直堆叠布局

适用于垂直排列的按钮组、开关组。

```mql5
//+------------------------------------------------------------------+
//| 垂直盒子                                                         |
//+------------------------------------------------------------------+
class CVBox {
private:
   int               m_x, m_y;
   int               m_width;
   int               m_spacing;       // 控件间距
   CArrayObj         m_controls;       // CWndObj 指针数组
   int               m_cur_y;
   ENUM_BORDER_STYLE m_border_style;
   uint              m_bg_color;

public:
   CVBox(int x, int y, int width, int spacing = 4) {
      m_x = x; m_y = y;
      m_width = width;
      m_spacing = spacing;
      m_cur_y = 0;
      m_border_style = BORDER_FLAT;
      m_bg_color = C'20, 20, 30';
   }

   // 添加控件，自动计算 Y 坐标
   template<typename T>
   void              Add(T& ctrl) {
      CWndObj* w = &ctrl;
      int ctrl_h = w.YSize();
      w.XSize(m_width);
      w.Move(m_x, m_y + m_cur_y);
      m_controls.Add(w);
      m_cur_y += ctrl_h + m_spacing;
   }

   // 添加带边框的分组框
   void              AddGroupBox(CGroupBox& gb,
                                 const string text,
                                 int height) {
      gb.Create(0, "GB_" + text, 0, m_x, m_y + m_cur_y,
                 m_width, height);
      gb.Text(text);
      m_controls.Add(&gb);
      m_cur_y += height + m_spacing;
   }

   int               Height() const { return m_cur_y - m_spacing; }
   int               Width() const { return m_width; }
   int               X() const { return m_x; }
   int               Y() const { return m_y; }
   void              SetX(int x) {
      int delta = x - m_x;
      m_x = x;
      for(int i = 0; i < m_controls.Total(); i++) {
         CWndObj* w = m_controls.At(i);
         w.Move(w.Left() + delta, w.Top());
      }
   }
};
```

---

### 1.3 CHBox — 水平堆叠布局

适用于一行内的控件组合（标签 + 输入框 + 按钮）。

```mql5
//+------------------------------------------------------------------+
//| 水平盒子                                                         |
//+------------------------------------------------------------------+
class CHBox {
private:
   int               m_x, m_y;
   int               m_total_width;
   int               m_height;
   int               m_spacing;
   CArrayObj         m_controls;

public:
   CHBox(int x, int y, int spacing = 4) {
      m_x = x; m_y = y;
      m_spacing = spacing;
      m_total_width = 0;
      m_height = 0;
   }

   template<typename T>
   void              Add(T& ctrl) {
      CWndObj* w = &ctrl;
      w.Move(m_x + m_total_width, m_y);
      m_total_width += w.XSize() + m_spacing;
      m_height = MathMax(m_height, w.YSize());
      m_controls.Add(w);
   }

   // 添加弹簧 (spacer) — 占据剩余空间
   void              AddSpacer(int width) {
      m_total_width += width + m_spacing;
   }

   int               Width() const {
      return m_total_width - m_spacing;
   }
   int               Height() const { return m_height; }
};
```

---

### 1.4 CTabLayout — Tab 页布局

适用于功能分区（参数设置 / 回测 / 日志）。

```mql5
//+------------------------------------------------------------------+
//| Tab 页包装器                                                     |
//+------------------------------------------------------------------+
class CTabLayout {
private:
   CTabControl       m_tab_control;
   CArrayObj         m_tab_pages;      // 每页的子布局数组
   int               m_x, m_y;
   int               m_w, m_h;

public:
   bool              Create(const long chart_id,
                            const string name,
                            const int x, const int y,
                            const int w, const int h) {
      m_x = x; m_y = y; m_w = w; m_h = h;
      return m_tab_control.Create(chart_id, name,
                                  0, x, y, w, h);
   }

   // 添加一个 Tab 页
   int               AddTab(const string text) {
      int idx = m_tab_control.AddItem(text);
      return idx;
   }

   // 获取某 Tab 页的客户区（不含标签栏）
   void              GetTabClientRect(int tab_idx,
                                      int &x, int &y,
                                      int &w, int &h) {
      // 标签栏高度约 24px
      int tab_h = 24;
      x = m_x + 4;
      y = m_y + tab_h + 4;
      w = m_w - 8;
      h = m_h - tab_h - 8;
   }

   CTabControl*      TabControl() { return &m_tab_control; }
};
```

---

### 1.5 CAnchorLayout — 锚点布局

适用于控件跟随父容器边缘拉伸（类似 WinForms Anchor/Dock）。

```mql5
//+------------------------------------------------------------------+
//| 锚点定义                                                         |
//+------------------------------------------------------------------+
enum ENUM_ANCHOR {
   ANCHOR_NONE     = 0,
   ANCHOR_LEFT     = 1,
   ANCHOR_TOP      = 2,
   ANCHOR_RIGHT    = 4,
   ANCHOR_BOTTOM   = 8,
   ANCHOR_ALL      = ANCHOR_LEFT | ANCHOR_TOP |
                     ANCHOR_RIGHT | ANCHOR_BOTTOM,
};

//+------------------------------------------------------------------+
//| 锚点控件包装器                                                   |
//+------------------------------------------------------------------+
class CAnchoredControl {
private:
   CWndObj*          m_ctrl;
   ENUM_ANCHOR       m_anchor;
   int               m_original_x, m_original_y;
   int               m_original_w, m_original_h;
   int               m_margin_right, m_margin_bottom;

public:
   CAnchoredControl(CWndObj& ctrl, ENUM_ANCHOR anchor) {
      m_ctrl = &ctrl;
      m_anchor = anchor;
      m_original_x = ctrl.Left();
      m_original_y = ctrl.Top();
      m_original_w = ctrl.XSize();
      m_original_h = ctrl.YSize();
   }

   // 当父容器大小变化时重新计算位置
   void              OnParentResize(int new_w, int new_h,
                                    int old_w, int old_h) {
      int dx = new_w - old_w;
      int dy = new_h - old_h;

      int x = m_original_x;
      int y = m_original_y;
      int w = m_original_w;
      int h = m_original_h;

      if((m_anchor & ANCHOR_RIGHT) && !(m_anchor & ANCHOR_LEFT))
         x += dx;
      if((m_anchor & ANCHOR_RIGHT) && (m_anchor & ANCHOR_LEFT))
         w += dx;

      if((m_anchor & ANCHOR_BOTTOM) && !(m_anchor & ANCHOR_TOP))
         y += dy;
      if((m_anchor & ANCHOR_BOTTOM) && (m_anchor & ANCHOR_TOP))
         h += dy;

      m_ctrl.Move(x, y);
      m_ctrl.XSize(w);
      m_ctrl.YSize(h);
   }
};
```

---

## 2. 完整布局示例

```mql5
//+------------------------------------------------------------------+
//| 面板布局示例                                                     |
//+------------------------------------------------------------------+
class CEAPanel : public CAppDialog {
private:
   CEdit              m_ed_lot, m_ed_sl, m_ed_tp;
   CButton            m_btn_start, m_btn_stop;
   CCheckBox          m_cb_martingale;
   CComboBox          m_cb_risk_mode;
   CSpinEdit          m_sp_multiplier;
   CLabel             m_lb_status;
   CGroupBox          m_gb_params;
   CTabControl        m_tab;

public:
   int               OnInit() {
      // 主对话框
      if(!Create(0, "EA参数面板", 0, 10, 10, 320, 420))
         return INIT_FAILED;

      // Tab 控制
      if(!m_tab.Create(m_chart_id, "MainTabs",
                        m_subwin, 5, 5, Width() - 10,
                        Height() - 10))
         return INIT_FAILED;
      Add(m_tab);

      // Tab 1: 参数设置
      int tab_idx = m_tab.AddItem("参数");
      CreateParamsTab(tab_idx);

      // Tab 2: 控制
      tab_idx = m_tab.AddItem("控制");
      CreateControlTab(tab_idx);

      // Tab 3: 日志
      tab_idx = m_tab.AddItem("日志");
      CreateLogTab(tab_idx);

      // 显示
      m_tab.SelectedTab(0);
      m_tb.SelectedTab(0);
      return INIT_SUCCEEDED;
   }

private:
   void              CreateParamsTab(int idx) {
      // 获取该 Tab 的内容区
      int cx, cy, cw, ch;
      GetTabClientRect(idx, cx, cy, cw, ch);

      // 标签宽度=70, 输入框=100, 单位=40, 间距=6
      int col_widths[] = {70, 100, 40};
      CGridLayout grid(cx, cy, 3, col_widths, 22, 6, 6);

      int x, y, w, h;

      // 手数
      grid.Next(x, y, w, h);
      CLabel lb1; lb1.Create(0, "lb_lot", m_subwin, x, y, w, h);
      lb1.Text("手数:");
      lb1.Color(clrWhite);
      Add(lb1);

      grid.Next(x, y, w, h);
      m_ed_lot.Create(0, "ed_lot", m_subwin, x, y, w, h);
      m_ed_lot.Text("0.01");
      Add(m_ed_lot);

      grid.Next(x, y, w, h);
      CLabel lb_unit; lb_unit.Create(0, "lb_unit", m_subwin, x, y, w, h);
      lb_unit.Text("手");
      lb_unit.Color(C'150, 150, 170'));
      Add(lb_unit);

      // 止损
      grid.Next(x, y, w, h);
      CLabel lb2; lb2.Create(0, "lb_sl", m_subwin, x, y, w, h);
      lb2.Text("止损:");
      lb2.Color(clrWhite);
      Add(lb2);

      grid.Next(x, y, w, h);
      m_ed_sl.Create(0, "ed_sl", m_subwin, x, y, w, h);
      m_ed_sl.Text("50");
      Add(m_ed_sl);

      grid.Next(x, y, w, h);
      CLabel lb_pips; lb_pips.Create(0, "lb_sp", m_subwin, x, y, w, h);
      lb_pips.Text("点");
      lb_pips.Color(C'150, 150, 170'));
      Add(lb_pips);

      // 风险模式
      grid.NewRow();
      grid.Next(x, y, w, h);
      CLabel lb3; lb3.Create(0, "lb_risk", m_subwin, x, y, w, h);
      lb3.Text("风险模式:");
      lb3.Color(clrWhite);
      Add(lb3);

      grid.Next(x, y, w, h);
      m_cb_risk_mode.Create(0, "cb_risk", m_subwin, x, y, w, h);
      m_cb_risk_mode.AddItem("固定手数");
      m_cb_risk_mode.AddItem("固定比例");
      m_cb_risk_mode.AddItem("ATR动态");
      Add(m_cb_risk_mode);
      grid.SkipCols(1);

      // 马丁开关
      grid.NewRow();
      grid.Next(x, y, w, h);
      m_cb_martingale.Create(0, "cb_mg", m_subwin, x, y, w, h);
      m_cb_martingale.Text("启用马丁格尔");
      m_cb_martingale.Color(clrWhite);
      Add(m_cb_martingale);
      grid.SkipCols(2);
   }

   void              CreateControlTab(int idx) {
      int cx, cy, cw, ch;
      GetTabClientRect(idx, cx, cy, cw, ch);

      // 两个按钮水平排列
      CHBox hbox(cx, cy, 10);
      m_btn_start.Create(0, "btn_start", m_subwin, 0, 0, 100, 30);
      m_btn_start.Text("开始交易");
      hbox.Add(m_btn_start);
      Add(m_btn_start);

      m_btn_stop.Create(0, "btn_stop", m_subwin, 0, 0, 100, 30);
      m_btn_stop.Text("停止交易");
      hbox.Add(m_btn_stop);
      m_btn_stop.Enabled(false);
      Add(m_btn_stop);

      // 状态标签
      m_lb_status.Create(0, "lb_status", m_subwin,
                          cx, cy + 50, 200, 20);
      m_lb_status.Text("状态: 就绪");
      m_lb_status.Color(clrLime);
      Add(m_lb_status);
   }

   void              CreateLogTab(int idx) {
      int cx, cy, cw, ch;
      GetTabClientRect(idx, cx, cy, cw, ch);
      // 可添加 CListView 作为日志区
   }
};
```

---

## 3. 对齐工具函数

```mql5
// 水平居中对齐多个控件
void CenterHorizontally(CArrayObj& ctrls, int container_w) {
   int total_w = 0;
   for(int i = 0; i < ctrls.Total(); i++) {
      CWndObj* w = ctrls.At(i);
      total_w += w.XSize();
   }
   total_w += (ctrls.Total() - 1) * 8; // 间距

   int start_x = (container_w - total_w) / 2;
   int cur_x = start_x;
   for(int i = 0; i < ctrls.Total(); i++) {
      CWndObj* w = ctrls.At(i);
      w.Move(cur_x, w.Top());
      cur_x += w.XSize() + 8;
   }
}

// 垂直居中对齐
void CenterVertically(CArrayObj& ctrls, int container_h) {
   int total_h = 0;
   for(int i = 0; i < ctrls.Total(); i++) {
      CWndObj* w = ctrls.At(i);
      total_h += w.YSize();
   }
   total_h += (ctrls.Total() - 1) * 4;

   int start_y = (container_h - total_h) / 2;
   int cur_y = start_y;
   for(int i = 0; i < ctrls.Total(); i++) {
      CWndObj* w = ctrls.At(i);
      w.Move(w.Left(), cur_y);
      cur_y += w.YSize() + 4;
   }
}

// 等宽排列 (evenly space)
void EvenlySpaceHorizontally(CArrayObj& ctrls,
                              int container_w,
                              int margin = 10) {
   int inner_w = container_w - 2 * margin;
   int total_ctrl_w = 0;
   for(int i = 0; i < ctrls.Total(); i++) {
      CWndObj* w = ctrls.At(i);
      total_ctrl_w += w.XSize();
   }
   int gaps = ctrls.Total() + 1;
   int gap = (inner_w - total_ctrl_w) / gaps;

   int cur_x = margin + gap;
   for(int i = 0; i < ctrls.Total(); i++) {
      CWndObj* w = ctrls.At(i);
      w.Move(cur_x, w.Top());
      cur_x += w.XSize() + gap;
   }
}
```

---

## 4. 常见布局模板速查

| 场景 | 推荐布局 |
|------|---------|
| 参数标签 + 输入框对齐 | CGridLayout (3列) |
| 按钮水平排列 | CHBox |
| 按钮垂直排列 | CVBox |
| 多功能分区 | CTabControl + CGridLayout |
| 面板填充 (填满底部) | CAnchoredControl (ANCHOR_ALL) |
| 右下角固定按钮 | CAnchoredControl (ANCHOR_RIGHT \| ANCHOR_BOTTOM) |
