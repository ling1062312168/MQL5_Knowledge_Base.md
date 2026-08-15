# 视觉设计指南 — 配色 / 字体 / 间距 / 润色

## 概述

MQL5 标准控件默认外观偏丑（灰色背景、粗黑边框）。本模块提供配色方案、字体设置、间距规范，以及让面板变专业的润色技巧。

配色方案来源：
- **通用暗色主题**：标准推荐，通用场景
- **源码配色**：从你的 EA 源码（趋势EA、海龟EA、进阶EA）中提取的实战配色

---

## 1. 配色方案

### 1.0 ⭐ 源码实战配色（从你的 EA 中提取）

你的源码中使用的配色，经验证适合实盘盯盘：

```mql5
// 提取自: 趋势EA28/26, 进阶EA, 手工对冲半自动EA
#define CLR_BG          C'15, 18, 25'      // 面板整体背景（深蓝黑）
#define CLR_CARD         C'22, 26, 36'      // 卡片/输入框背景
#define CLR_BORDER       C'40, 45, 60'      // 普通边框（不抢眼）
#define CLR_BTN_BG       C'35, 42, 60'      // 普通按钮背景
#define CLR_BTN_HOVER    C'50, 60, 90'      // 按钮悬停（轻微提亮）
#define CLR_ACCENT       C'0, 120, 215'     // 强调蓝（模式切换等）
#define CLR_GREEN        C'20, 160, 70'     // 多仓/开始/盈利（鲜绿）
#define CLR_RED          C'200, 45, 45'     // 空仓/停止/亏损（正红）
#define CLR_YELLOW       C'200, 165, 0'     // 平仓按钮（警告黄）
#define CLR_TEXT         C'210, 220, 235'    // 主文字（柔和白）
#define CLR_TEXT_DIM     C'120, 135, 160'   // 分组标题/次要文字
#define CLR_PROFIT       C'20, 200, 100'    // 盈利数字（亮绿）
#define CLR_LOSS         C'220, 60, 60'     // 亏损数字（亮红）
#define CLR_TITLEBAR     C'25, 30, 45'       // 标题栏背景
```

**设计理念**：这个配色是 **深蓝黑 + 低饱和彩色** 的组合。边框和背景用深蓝灰色系不抢眼，按钮和状态文字用高饱和鲜亮色（绿/红/黄）形成视觉焦点，非常适合长时间盯盘。

### 1.1 专业暗色主题 (推荐)

适合长时间盯盘，深色背景减少眼部疲劳：

```mql5
// 暗色主题颜色常量
#define CLR_BG_DARK       C'18, 20, 28'    // 面板背景
#define CLR_BG_CARD       C'25, 27, 36'    // 卡片/分组背景
#define CLR_BG_INPUT      C'22, 24, 32'    // 输入框背景
#define CLR_BORDER        C'55, 60, 80'    // 普通边框
#define CLR_BORDER_FOCUS  C'80, 130, 220'  // 聚焦边框(蓝)
#define CLR_ACCENT        C'0, 120, 215'   // 强调色(蓝)
#define CLR_ACCENT_GREEN  C'30, 180, 80'   // 成功/开始
#define CLR_ACCENT_RED    C'200, 50, 50'   // 危险/停止
#define CLR_ACCENT_YELLOW C'200, 170, 0'   // 警告/提示
#define CLR_TEXT_MAIN     C'220, 225, 235' // 主文字(白灰)
#define CLR_TEXT_SUB      C'140, 150, 170' // 次要文字
#define CLR_TEXT_DISABLED C'80, 85, 100'  // 禁用文字
```

### 1.2 深蓝专业主题

适合金融交易终端风格：

```mql5
#define CLR_NAVY_BG       C'15, 25, 45'
#define CLR_NAVY_CARD     C'20, 35, 65'
#define CLR_NAVY_BORDER   C'40, 70, 120'
#define CLR_NAVY_ACCENT   C'0, 150, 255'
#define CLR_NAVY_TEXT     C'200, 215, 240'
```

### 1.3 浅色主题 (备用)

适合高亮显示器或截图分享：

```mql5
#define CLR_LIGHT_BG      C'235, 238, 243'
#define CLR_LIGHT_CARD    C'255, 255, 255'
#define CLR_LIGHT_BORDER  C'190, 200, 215'
#define CLR_LIGHT_ACCENT  C'0, 100, 200'
#define CLR_LIGHT_TEXT    C'40, 50, 70'
```

---

## 2. 应用配色到控件

```mql5
class CStyledPanel : public CAppDialog {
protected:
   // 应用暗色主题到所有控件
   void              ApplyDarkTheme() {
      // 对话框背景
      ColorBackground(CLR_BG_DARK);
      ColorBorder(CLR_BORDER);

      // 所有子控件的默认颜色
      m_btn_start.ColorBackground(CLR_ACCENT_GREEN);
      m_btn_start.ColorBorder(CLR_ACCENT_GREEN);
      m_btn_start.Color(clrWhite);

      m_btn_stop.ColorBackground(CLR_ACCENT_RED);
      m_btn_stop.ColorBorder(CLR_ACCENT_RED);
      m_btn_stop.Color(clrWhite);

      m_btn_close.ColorBackground(CLR_ACCENT_YELLOW);
      m_btn_close.ColorBorder(CLR_ACCENT_YELLOW);
      m_btn_close.Color(C'30, 30, 30');

      // 输入框
      m_ed_lot.ColorBackground(CLR_BG_INPUT);
      m_ed_lot.ColorBorder(CLR_BORDER);
      m_ed_lot.Color(CLR_TEXT_MAIN);
      m_ed_lot.TextColor(CLR_TEXT_MAIN);

      // 下拉框
      m_cb_risk_mode.ColorBackground(CLR_BG_INPUT);
      m_cb_risk_mode.ColorBorder(CLR_BORDER);
      m_cb_risk_mode.Color(CLR_TEXT_MAIN);

      // 标签
      m_lb_lot.Color(CLR_TEXT_SUB);
      m_lb_unit.Color(CLR_TEXT_SUB);

      // 复选框
      m_cb_mg.Color(CLR_TEXT_MAIN);

      // 分组框
      m_gb_params.Color(CLR_TEXT_SUB);
      m_gb_params.ColorBackground(CLR_BG_CARD);
   }
};
```

---

## 3. 字体设置

### 3.1 字体常量

```mql5
// MQL5 可用字体 (Windows)
#define FONT_NAME         "Segoe UI"       // 系统默认
#define FONT_NAME_MONO    "Consolas"        // 等宽 (数字)
#define FONT_SIZE_TITLE   10                // 标题
#define FONT_SIZE_MAIN    9                 // 正文
#define FONT_SIZE_SMALL   8                 // 辅助/单位
#define FONT_SIZE_NUM     9                 // 数字显示
```

### 3.2 控件字体设置

```mql5
void              ApplyFonts() {
   // 标题标签 (大字体，加粗)
   m_lb_title.Font("Segoe UI");
   m_lb_title.FontSize(10);
   m_lb_title.FontFlags(FONT_BOLD);

   // 普通标签
   m_lb_lot.Font("Segoe UI");
   m_lb_lot.FontSize(9);

   // 输入框 — 数字建议用等宽字体 (对齐美观)
   m_ed_lot.Font("Consolas");
   m_ed_lot.FontSize(9);

   m_ed_sl.Font("Consolas");
   m_ed_sl.FontSize(9);

   m_ed_tp.Font("Consolas");
   m_ed_tp.FontSize(9);

   // 下拉框
   m_cb_risk_mode.Font("Segoe UI");
   m_cb_risk_mode.FontSize(9);

   // 按钮
   m_btn_start.Font("Segoe UI");
   m_btn_start.FontSize(9);
   m_btn_start.FontFlags(FONT_BOLD);

   // 状态标签 — 醒目色
   m_lb_status.Font("Segoe UI");
   m_lb_status.FontSize(9);
   m_lb_status.FontFlags(FONT_BOLD);
}
```

---

## 4. 间距与边距规范

```mql5
// 布局间距常量
#define MARGIN            10      // 面板边缘留白
#define GAP_SM            4       // 小间距 (标签与输入框之间)
#define GAP_MD            8       // 中间距 (行与行之间)
#define GAP_LG            12      // 大间距 (分组之间)
#define GAP_XL            16      // 特大间距 (Tab 之间)

// 控件尺寸规范
#define HEIGHT_BTN        28      // 按钮高度
#define HEIGHT_EDIT       22      // 输入框高度
#define HEIGHT_LABEL      16      // 标签高度
#define HEIGHT_SPIN       22      // 微调框高度
#define WIDTH_MIN_EDIT    80      // 输入框最小宽度
#define WIDTH_LABEL       70      // 标签宽度
```

---

## 5. 圆角效果 (CAppDialog + 分组框)

MQL5 标准控件本身不支持圆角，但可以通过以下方式模拟：

### 5.1 分组框模拟圆角卡片

```mql5
// 创建圆角"卡片"效果 (用分组框 + 自定义绘制)
class CRoundedGroupBox : public CGroupBox {
public:
   void              SetRoundedStyle() {
      // 分组框作为卡片容器
      ColorBackground(CLR_BG_CARD);
      ColorBorder(CLR_BORDER);
      // 注意: 标准 CGroupBox 不支持圆角，此为视觉近似
   }
};
```

### 5.2 CCanvas 绘制圆角面板 (完整示例见 canvas-custom.md)

---

## 6. 视觉润色技巧

### 6.1 按钮状态样式

```mql5
// 根据按钮状态切换颜色
void              StyleButtonByState(CButton& btn,
                                    bool enabled,
                                    bool hovered) {
   if(!enabled) {
      btn.ColorBackground(C'60, 62, 75');
      btn.ColorBorder(C'50, 52, 65');
      btn.Color(CLR_TEXT_DISABLED);
      return;
   }
   btn.ColorBackground(hovered ?
                       C'50, 140, 70' : CLR_ACCENT_GREEN);
   btn.ColorBorder(hovered ?
                   C'60, 170, 90' : CLR_ACCENT_GREEN);
   btn.Color(clrWhite);
}
```

### 6.2 输入框聚焦高亮

```mql5
// Edit 聚焦时边框变亮
void              HighlightFocusedEdit(CEdit& ed) {
   if(ed.Focus()) {
      ed.ColorBorder(CLR_BORDER_FOCUS);
      ed.ColorBackground(C'28, 30, 40');
   } else {
      ed.ColorBorder(CLR_BORDER);
      ed.ColorBackground(CLR_BG_INPUT);
   }
}

// 在 OnEvent 中调用
virtual bool      OnEvent(const int id, const long &lparam,
                            const double &dparam,
                            const string &sparam) {
   // 检测输入框焦点变化
   HighlightFocusedEdit(m_ed_lot);
   HighlightFocusedEdit(m_ed_sl);
   HighlightFocusedEdit(m_ed_tp);
   return CAppDialog::OnEvent(id, lparam, dparam, sparam);
}
```

### 6.3 数字输入校验视觉反馈

```mql5
void              ValidateAndStyle(CEdit& ed,
                                   double value,
                                   double min_val,
                                   double max_val) {
   bool valid = (value >= min_val && value <= max_val);
   if(!valid) {
      ed.ColorBorder(CLR_ACCENT_RED);
      ed.ColorBackground(C'40, 20, 20');
   } else {
      ed.ColorBorder(CLR_BORDER);
      ed.ColorBackground(CLR_BG_INPUT);
   }
}
```

### 6.4 状态指示器 (彩色圆点)

```mql5
// 在标签前绘制状态圆点
class CStatusIndicator : public CEdit {
public:
   void              CreateStatus(long chart_id, int x, int y,
                                   int size) {
      Create(chart_id, "status_ind", 0, x, y, size, size);
      ReadOnly(true);
      ColorBackground(clrNONE);
      ColorBorder(clrNONE);
      Text("●");
      FontSize(12);
   }

   void              SetStatus(color clr) {
      Color(clr);
   }
};

// 使用
CStatusIndicator m_indicator;
m_indicator.CreateStatus(ChartID(), 10, 12, 20);
m_indicator.SetStatus(clrLime);     // 运行中
m_indicator.SetStatus(clrOrange);  // 暂停
m_indicator.SetStatus(clrRed);      // 错误
```

### 6.5 进度条 (用 CEdit 模拟)

```mql5
class CProgressBar : public CEdit {
public:
   CProgressBar() {
      m_value = 0;
   }

   void              Create(long chart_id, string name,
                            int x, int y, int w, int h) {
      Create(chart_id, name, 0, x, y, w, h);
      ColorBackground(C'30, 35, 50');
      ColorBorder(C'50, 55, 70');
      ReadOnly(true);
      TextAlign(TA_LEFT);
   }

   void              SetValue(double pct) {
      m_value = MathMax(0, MathMin(100, pct));
      // 用方块字符模拟进度
      int filled = (int)(m_value / 10);
      string bar = "";
      for(int i = 0; i < 10; i++)
         bar += (i < filled) ? "█" : "░";
      Text(bar + " " + DoubleToString(m_value, 0) + "%");

      // 颜色随进度变化
      if(m_value < 30)        Color(clrLime);
      else if(m_value < 70)  Color(clrYellow);
      else                   Color(clrRed);
   }

private:
   double            m_value;
};
```

---

## 7. 面板整体效果提升清单

| 技巧 | 效果 | 难度 |
|------|------|------|
| 深色背景 + 浅色文字 | 专业终端感 | ⭐ |
| 等宽字体 (Consolas) 数字 | 数字对齐美观 | ⭐ |
| 按钮使用彩色背景 | 视觉层次分明 | ⭐ |
| 输入框聚焦时边框变蓝 | 交互反馈清晰 | ⭐ |
| 状态文字变色 (绿/黄/红) | 一眼识别状态 | ⭐ |
| Tab 分区不同功能 | 结构清晰 | ⭐ |
| 分组框包裹相关控件 | 逻辑分组 | ⭐ |
| 输入校验失败边框变红 | 错误提示 | ⭐ |
| CCanvas 绘制圆角/渐变 | 极致视觉 | ⭐⭐⭐ |
| 状态指示器圆点 | 直观状态显示 | ⭐⭐ |
| CCanvas 进度条 | 实时数据可视化 | ⭐⭐ |

---

## 8. 完整视觉配置模板

```mql5
//+------------------------------------------------------------------+
//| 视觉配置                                                         |
//+------------------------------------------------------------------+
class CVisualConfig {
public:
   // 面板尺寸
   static int         PanelWidth()  { return 320; }
   static int         PanelHeight() { return 420; }

   // 颜色
   static uint        BgColor()     { return CLR_BG_DARK; }
   static uint        CardColor()   { return CLR_BG_CARD; }
   static uint        BorderColor() { return CLR_BORDER; }
   static uint        AccentBlue()  { return CLR_ACCENT; }
   static uint        AccentGreen() { return CLR_ACCENT_GREEN; }
   static uint        AccentRed()   { return CLR_ACCENT_RED; }
   static uint        TextMain()    { return CLR_TEXT_MAIN; }
   static uint        TextSub()     { return CLR_TEXT_SUB; }

   // 尺寸
   static int         BtnHeight()   { return HEIGHT_BTN; }
   static int         EditHeight()  { return HEIGHT_EDIT; }
   static int         LabelHeight() { return HEIGHT_LABEL; }

   // 间距
   static int         Margin()      { return MARGIN; }
   static int         Gap()         { return GAP_MD; }

   // 字体
   static string      FontUI()      { return "Segoe UI"; }
   static string      FontMono()    { return "Consolas"; }
   static int         FontSize()    { return FONT_SIZE_MAIN; }
};
```
