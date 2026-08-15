# CCanvas 自定义面板 — 完整代码骨架

## 适用场景

- 标准控件样式无法满足需求（想要圆角、渐变、阴影）
- 需要自定义交互（拖拽滑块、仪表盘、特殊按钮）
- 追求专业视觉效果的 EA 面板

## 引入

```mql5
#include <Canvas\Canvas.mqh>
#include <ChartObjects\ChartObjectsBmp.mqh>
#include <Arrays\ArrayObj.mqh>
```

---

## 1. 完整 CCanvas 面板类骨架

```mql5
//+------------------------------------------------------------------+
//| 自定义按钮状态枚举                                               |
//+------------------------------------------------------------------+
enum ENUM_BTN_STATE {
   BTN_NORMAL = 0,      // 正常
   BTN_HOVER,           // 鼠标悬停
   BTN_PRESSED,         // 按下
   BTN_DISABLED         // 禁用
};

//+------------------------------------------------------------------+
//| 自定义按钮类                                                     |
//+------------------------------------------------------------------+
class CCustomButton {
private:
   string            m_name;
   int               m_x, m_y, m_w, m_h;
   ENUM_BTN_STATE    m_state;
   string            m_text;
   uint              m_clr_normal;
   uint              m_clr_hover;
   uint              m_clr_pressed;
   uint              m_clr_text;
   uint              m_clr_border;
   bool              m_visible;
   bool              m_enabled;

public:
   CCustomButton(string name, int x, int y, int w, int h) {
      m_name = name;
      m_x = x; m_y = y; m_w = w; m_h = h;
      m_state = BTN_NORMAL;
      m_clr_normal = C'30, 30, 40';        // 深色背景
      m_clr_hover = C'50, 50, 70';        // 悬停变亮
      m_clr_pressed = C'20, 20, 30';      // 按下变暗
      m_clr_text = clrWhite;
      m_clr_border = C'80, 80, 100';
      m_visible = true;
      m_enabled = true;
      m_text = name;
   }

   void              SetText(string text)    { m_text = text; }
   void              SetColors(uint n, uint h, uint p,
                                uint t, uint b) {
      m_clr_normal = n; m_clr_hover = h;
      m_clr_pressed = p; m_clr_text = t; m_clr_border = b;
   }

   // 绘制按钮 (在 CCanvas 上调用)
   void              Draw(CCanvas& canvas) {
      if(!m_visible) return;

      uint bg = GetBackgroundColor();
      uint brd = m_enabled ? m_clr_border : clrGray;

      // 圆角矩形 (CCanvas 内置圆角矩形)
      canvas.FillRectangle(m_x, m_y, m_w, m_h, bg);
      canvas.Rectangle(m_x, m_y, m_x + m_w - 1,
                        m_y + m_h - 1, brd);

      // 文字居中
      canvas.TextOut(m_x + m_w / 2, m_y + m_h / 2,
                      m_text, m_clr_text, TA_CENTER | TA_VCENTER);
   }

   // 检测坐标是否在按钮范围内
   bool              HitTest(int x, int y) const {
      return (x >= m_x && x <= m_x + m_w &&
              y >= m_y && y <= m_y + m_h);
   }

   ENUM_BTN_STATE    GetState()    const { return m_state; }
   void              SetState(ENUM_BTN_STATE s) { m_state = s; }
   void              SetVisible(bool v)       { m_visible = v; }
   void              SetEnabled(bool e) {
      m_enabled = e;
      m_state = e ? BTN_NORMAL : BTN_DISABLED;
   }
   string            GetName()      const { return m_name; }
   int               GetX()         const { return m_x; }
   int               GetY()         const { return m_y; }
   int               GetWidth()     const { return m_w; }
   int               GetHeight()    const { return m_h; }

private:
   uint              GetBackgroundColor() const {
      if(!m_enabled) return C'70, 70, 70';
      switch(m_state) {
         case BTN_HOVER:    return m_clr_hover;
         case BTN_PRESSED:  return m_clr_pressed;
         default:            return m_clr_normal;
      }
   }
};

//+------------------------------------------------------------------+
//| 自定义输入框类                                                   |
//+------------------------------------------------------------------+
class CCustomEdit {
private:
   string            m_name;
   int               m_x, m_y, m_w, m_h;
   string            m_text;
   uint              m_bg_color;
   uint              m_text_color;
   uint              m_border_color;
   bool              m_focused;
   bool              m_visible;
   string            m_placeholder;

public:
   CCustomEdit(string name, int x, int y, int w, int h) {
      m_name = name;
      m_x = x; m_y = y; m_w = w; m_h = h;
      m_text = "";
      m_bg_color = C'25, 25, 35';
      m_text_color = clrWhite;
      m_border_color = C'60, 60, 80';
      m_focused = false;
      m_visible = true;
      m_placeholder = "";
   }

   void              SetText(string t)         { m_text = t; }
   string            GetText()         const    { return m_text; }
   void              SetPlaceholder(string p)   { m_placeholder = p; }
   void              SetFocused(bool f)         { m_focused = f; }
   bool              IsFocused()      const     { return m_focused; }
   void              SetVisible(bool v)         { m_visible = v; }

   void              Draw(CCanvas& canvas) {
      if(!m_visible) return;

      // 背景
      canvas.FillRectangle(m_x, m_y, m_w, m_h, m_bg_color);

      // 边框 (聚焦时变亮)
      uint brd = m_focused ?
                  ColorToUint(C'100, 140, 220)') : m_border_color;
      canvas.Rectangle(m_x, m_y, m_x + m_w - 1,
                       m_y + m_h - 1, brd);

      // 显示文本或占位符
      string disp_text = (m_text != "" ? m_text :
                          (m_placeholder != "" ? m_placeholder : ""));
      uint txt_clr = (m_text != "" ? m_text_color :
                      C'100, 100, 120');
      canvas.TextOut(m_x + 6, m_y + m_h / 2,
                      disp_text, txt_clr, TA_LEFT | TA_VCENTER);
   }

   bool              HitTest(int x, int y) const {
      return (x >= m_x && x <= m_x + m_w &&
              y >= m_y && y <= m_y + m_h);
   }

   // 键盘输入处理 (在 CHARTEVENT_KEYDOWN 中调用)
   bool              OnKeyDown(const int key_code) {
      if(key_code == KEY_BACK) {
         if(StringLen(m_text) > 0)
            m_text = StringSubstr(m_text, 0,
                                  StringLen(m_text) - 1);
         return true;
      }
      if(key_code == KEY_ENTER || key_code == KEY_ESCAPE) {
         m_focused = false;
         return false;  // 结束输入
      }
      if(key_code >= KEY_0 && key_code <= KEY_9) {
         m_text += ShortToString(key_code);
         return true;
      }
      if(key_code == KEY_PERIOD) {
         m_text += ".";
         return true;
      }
      return false;
   }

   string            GetName()  const { return m_name; }
   int               GetX()    const { return m_x; }
   int               GetY()    const { return m_y; }
};

//+------------------------------------------------------------------+
//| 主面板类                                                         |
//+------------------------------------------------------------------+
class CMyCanvasPanel : public CObject {
private:
   string            m_chart_name;
   long               m_chart_id;
   int                m_subwin;
   int                m_x, m_y, m_w, m_h;
   bool               m_visible;

   CCanvas            m_canvas;
   CCustomButton      m_btn_start;
   CCustomButton      m_btn_stop;
   CCustomButton      m_btn_close;
   CCustomEdit        m_edit_lot;
   CCustomEdit        m_edit_sl;
   CCustomEdit        m_edit_tp;

   // 鼠标状态
   int                m_mouse_x;
   int                m_mouse_y;
   bool               m_mouse_lbtn_down;

public:
   CMyCanvasPanel() {
      m_chart_id = ChartID();
      m_chart_name = "MyCanvasPanel";
      m_subwin = 0;
      m_visible = false;

      // 初始化子控件 (面板内相对坐标)
      m_btn_start("开始", 10, 10, 80, 28);
      m_btn_stop("停止", 100, 10, 80, 28);
      m_btn_close("平仓", 190, 10, 80, 28);
      m_btn_stop.SetEnabled(false);   // 默认禁用停止按钮

      m_edit_lot("edit_lot", 10, 50, 120, 24);
      m_edit_lot.SetPlaceholder("手数 0.01");
      m_edit_sl("edit_sl", 10, 82, 120, 24);
      m_edit_sl.SetPlaceholder("止损点数");
      m_edit_tp("edit_tp", 10, 114, 120, 24);
      m_edit_tp.SetPlaceholder("止盈点数");
   }

   // 创建面板
   bool              Create(const long chart_id,
                            const string name,
                            const int x, const int y,
                            const int w, const int h) {
      m_chart_id = chart_id;
      m_chart_name = name;
      m_x = x; m_y = y; m_w = w; m_h = h;

      // 获取子窗口高度 (Canvas 需要准确高度)
      m_subwin = ChartWindowFind(m_chart_id, name);
      if(m_subwin < 0) {
         m_subwin = ChartWindowAdd(m_chart_id);
         ObjectSetString(m_chart_id, name, OBJPROP_NAME, name);
         ObjectSetInteger(m_chart_id, name, OBJPROP_TYPE,
                         OBJ_BITMAP_LABEL);
         ObjectSetInteger(m_chart_id, name, OBJPROP_XDISTANCE, m_x);
         ObjectSetInteger(m_chart_id, name, OBJPROP_YDISTANCE, m_y);
         ObjectSetInteger(m_chart_id, name, OBJPROP_XSIZE, m_w);
         ObjectSetInteger(m_chart_id, name, OBJPROP_YSIZE, m_h);
         ObjectSetInteger(m_chart_id, name, OBJPROP_CORNER,
                         CORNER_LEFT_UPPER);
         ObjectSetInteger(m_chart_id, name, OBJPROP_ANCHOR,
                         ANCHOR_LEFT_UPPER);
         ObjectSetString(m_chart_id, name, OBJPROP_BMPFILE, "");
      }

      // 创建 CCanvas
      if(!m_canvas.CreateBitmapLabel(m_chart_id, name,
                                      m_subwin, m_w, m_h))
         return false;

      // 初始绘制
      m_visible = true;
      Draw();

      return true;
   }

   // 绘制整个面板
   void              Draw() {
      if(!m_visible) return;

      // 1. 清空画布 (深色背景)
      m_canvas.Erase(C'20, 20, 30');

      // 2. 绘制面板边框 (细线)
      m_canvas.Rectangle(0, 0, m_w - 1, m_h - 1,
                          C'50, 50, 70');

      // 3. 绘制标题栏
      m_canvas.FillRectangle(0, 0, m_w, 32,
                              C'30, 30, 50');
      m_canvas.TextOut(m_w / 2, 16,
                       "═══ EA Control Panel ═══",
                       C'255, 215, 0', TA_CENTER | TA_VCENTER);

      // 4. 绘制所有子控件
      m_btn_start.Draw(m_canvas);
      m_btn_stop.Draw(m_canvas);
      m_btn_close.Draw(m_canvas);

      m_edit_lot.Draw(m_canvas);
      m_edit_sl.Draw(m_canvas);
      m_edit_tp.Draw(m_canvas);

      // 5. 绘制分隔线
      m_canvas.Line(0, 38, m_w, 38, C'60, 60, 80');

      // 6. 更新画布
      m_canvas.Update();
   }

   // 处理鼠标事件 (在 OnChartEvent 中调用)
   void              OnMouseEvent(int x, int y,
                                  int button, int flag) {
      if(!m_visible) return;

      // 鼠标移动 — 更新悬停状态
      if(flag == CHARTEVENT_MOUSE_MOVE) {
         m_mouse_x = x;
         m_mouse_y = y;

         // 更新按钮悬停状态
         UpdateButtonHover();

         // 检查输入框焦点
         bool any_hit = false;
         if(m_edit_lot.HitTest(x, y)) {
            m_edit_lot.SetFocused(true);
            any_hit = true;
         } else
            m_edit_lot.SetFocused(false);

         Draw();
      }

      // 鼠标左键按下
      if(button == CHARTEVENT_MOUSE_DOWN &&
         (flag & 1) == 1) {
         // 检查哪个按钮被点击
         if(m_btn_start.HitTest(x, y) &&
            m_btn_start.GetState() != BTN_DISABLED) {
            m_btn_start.SetState(BTN_PRESSED);
            Draw();
         }
         if(m_btn_stop.HitTest(x, y) &&
            m_btn_stop.GetState() != BTN_DISABLED) {
            m_btn_stop.SetState(BTN_PRESSED);
            Draw();
         }
      }

      // 鼠标左键释放 (点击事件)
      if(button == CHARTEVENT_MOUSE_UP &&
         (flag & 2) == 2) {
         if(m_btn_start.GetState() == BTN_PRESSED) {
            m_btn_start.SetState(BTN_NORMAL);
            OnButtonClick(m_btn_start.GetName());
            Draw();
         }
         if(m_btn_stop.GetState() == BTN_PRESSED) {
            m_btn_stop.SetState(BTN_NORMAL);
            OnButtonClick(m_btn_stop.GetName());
            Draw();
         }
      }
   }

   // 处理键盘事件 (聚焦输入框时)
   void              OnKeyDown(int key_code) {
      if(m_edit_lot.IsFocused()) {
         if(m_edit_lot.OnKeyDown(key_code))
            Draw();
      }
   }

   void              Show() {
      m_visible = true;
      Draw();
   }

   void              Hide() {
      m_visible = false;
   }

   bool              IsVisible() const { return m_visible; }

private:
   void              UpdateButtonHover() {
      if(!m_visible) return;

      // 简单悬停检测
      ENUM_BTN_STATE new_state;

      new_state = (m_btn_start.HitTest(m_mouse_x, m_mouse_y) &&
                   m_btn_start.GetState() != BTN_DISABLED &&
                   !m_mouse_lbtn_down) ? BTN_HOVER : BTN_NORMAL;
      if(m_btn_start.GetState() != BTN_DISABLED)
         m_btn_start.SetState(new_state);

      new_state = (m_btn_stop.HitTest(m_mouse_x, m_mouse_y) &&
                   m_btn_stop.GetState() != BTN_DISABLED &&
                   !m_mouse_lbtn_down) ? BTN_HOVER : BTN_NORMAL;
      if(m_btn_stop.GetState() != BTN_DISABLED)
         m_btn_stop.SetState(new_state);
   }

   void              OnButtonClick(string btn_name) {
      if(btn_name == "开始") {
         Print("用户点击了开始按钮!");
         m_btn_start.SetEnabled(false);
         m_btn_stop.SetEnabled(true);
      } else if(btn_name == "停止") {
         Print("用户点击了停止按钮!");
         m_btn_stop.SetEnabled(false);
         m_btn_start.SetEnabled(true);
      } else if(btn_name == "平仓") {
         Print("用户点击了平仓按钮!");
      }
      Draw();
   }
};
```

---

## 2. 进阶技巧

### 2.1 圆角矩形 (CCanvas)

```mql5
// 自定义圆角矩形函数
void DrawRoundRect(CCanvas& canvas, int x, int y,
                   int w, int h, uint color,
                   int radius = 4) {
   // 画四个圆角 (用圆形裁切)
   // CCanvas 没有内置圆角矩形，自己组合实现
   canvas.FillRectangle(x + radius, y, w - 2 * radius, h, color);
   canvas.FillRectangle(x, y + radius, w, h - 2 * radius, color);
   // 四个角的圆弧用 FillCircle 近似
   canvas.FillCircle(x + radius, y + radius,
                     radius, color);
   canvas.FillCircle(x + w - radius - 1, y + radius,
                     radius, color);
   canvas.FillCircle(x + radius, y + h - radius - 1,
                     radius, color);
   canvas.FillCircle(x + w - radius - 1,
                     y + h - radius - 1, radius, color);
}
```

### 2.2 渐变填充

```mql5
// 垂直渐变 (从上到下)
void DrawVerticalGradient(CCanvas& canvas, int x, int y,
                         int w, int h,
                         uint top_color, uint bottom_color) {
   int r1 = (top_color >> 16) & 0xFF;
   int g1 = (top_color >> 8) & 0xFF;
   int b1 = top_color & 0xFF;
   int r2 = (bottom_color >> 16) & 0xFF;
   int g2 = (bottom_color >> 8) & 0xFF;
   int b2 = bottom_color & 0xFF;

   for(int i = 0; i < h; i++) {
      float t = float(i) / float(MathMax(h - 1, 1));
      int r = (int)(r1 + t * (r2 - r1));
      int g = (int)(g1 + t * (g2 - g1));
      int b = (int)(b1 + t * (b2 - b1));
      uint clr = RGB(r, g, b);
      canvas.FillRectangle(x, y + i, w, 1, clr);
   }
}
```

### 2.3 阴影效果

```mql5
// 绘制带阴影的矩形
void DrawShadowRect(CCanvas& canvas, int x, int y,
                    int w, int h, uint shadow_color,
                    int offset = 3) {
   // 先画阴影
   canvas.FillRectangle(x + offset, y + offset, w, h,
                          shadow_color);
   // 再画主体
   canvas.FillRectangle(x, y, w, h,
                          C'40, 40, 60');
   // 边框
   canvas.Rectangle(x, y, x + w - 1, y + h - 1,
                     C'80, 80, 120');
}
```

### 2.4 图标绘制 (Emoji / 符号)

```mql5
// 使用 Wingdings / Webdings 字体绘制符号图标
void DrawIconButton(CCanvas& canvas, int x, int y,
                    int w, int h, ushort icon_char,
                    uint bg_color, uint icon_color) {
   // 背景
   canvas.FillRectangle(x, y, w, h, bg_color);
   canvas.Rectangle(x, y, x + w - 1, y + h - 1,
                    C'70, 70, 90');

   // 居中绘制图标字符
   canvas.TextOut(x + w / 2, y + h / 2,
                   ShortToString(icon_char), icon_color,
                   TA_CENTER | TA_VCENTER);
}

// 使用示例: 播放图标 (Wingdings 字体)
// DrawIconButton(canvas, 10, 10, 30, 30, 0xFC, clrBlue, clrWhite);
// DrawIconButton(canvas, 45, 10, 30, 30, 0xFB, clrRed, clrWhite);
// DrawIconButton(canvas, 80, 10, 30, 30, 0xF9, clrGray, clrWhite);
```

### 2.5 滑块进度条

```mql5
//+------------------------------------------------------------------+
//| 进度条/滑块类                                                   |
//+------------------------------------------------------------------+
class CSlider {
private:
   int               m_x, m_y, m_w, m_h;
   float              m_value;       // 0.0 ~ 1.0
   bool               m_dragging;

public:
   CSlider(int x, int y, int w, int h) {
      m_x = x; m_y = y; m_w = w; m_h = h;
      m_value = 0.5f;
      m_dragging = false;
   }

   void              Draw(CCanvas& canvas) {
      // 轨道
      canvas.FillRectangle(m_x, m_y + m_h / 2 - 2,
                            m_w, 4, C'50, 50, 70');
      // 进度
      int fill_w = (int)(m_value * m_w);
      canvas.FillRectangle(m_x, m_y + m_h / 2 - 2,
                            fill_w, 4, C'70, 130, 255');

      // 滑块手柄
      int handle_x = m_x + fill_w;
      canvas.FillCircle(handle_x, m_y + m_h / 2,
                          m_h / 2, C'150, 180, 255');
      canvas.Circle(handle_x, m_y + m_h / 2,
                     m_h / 2, C'200, 220, 255');
   }

   // 拖拽
   void              OnMouseMove(int x, int y) {
      if(m_dragging) {
         m_value = (float)MathMax(0,
                        MathMin(1, float(x - m_x) / float(m_w)));
      }
   }

   void              SetDragging(bool d) { m_dragging = d; }
   float             GetValue() const { return m_value; }
   void              SetValue(float v) { m_value = MathMax(0,
                                              MathMin(1, v)); }
};
```

---

## 3. 性能优化提示

```mql5
//+------------------------------------------------------------------+
//| 面板刷新策略                                                     |
//+------------------------------------------------------------------+
// 1. 仅在数据变化时重绘，不要每 tick 都 Draw()
// 2. 用脏标记 (dirty flag) 避免重复绘制
bool m_dirty = true;

// 在 Draw() 末尾:
m_dirty = false;

// 在状态变化时设置脏标记
void OnButtonClick() {
   m_dirty = true;  // 标记需要重绘
}

// 在 OnTimer 或 OnTick 中:
if(m_dirty) {
   Draw();
}
```

---

## 4. 完整使用示例

```mql5
//+------------------------------------------------------------------+
//| 全局变量                                                         |
//+------------------------------------------------------------------+
CMyCanvasPanel  g_panel;

//+------------------------------------------------------------------+
//| EA 初始化                                                        |
//+------------------------------------------------------------------+
int OnInit() {
   // 创建面板: 位置(10,10), 尺寸(300, 200)
   if(!g_panel.Create(ChartID(), "EAPanel",
                        10, 10, 300, 200)) {
      Print("面板创建失败!");
      return INIT_FAILED;
   }

   // 显示面板
   g_panel.Show();

   // 注册快捷键 (F11 切换面板显示)
   ChartSetInteger(ChartID(), CHART_EVENT_MOUSE_MOVE, 1);

   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| 图表事件                                                        |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam,
                  const double& dparam, const string& sparam) {
   // 鼠标事件 — 转发给面板
   if(id == CHARTEVENT_MOUSE_MOVE ||
      id == CHARTEVENT_MOUSE_DOWN ||
      id == CHARTEVENT_MOUSE_UP) {
      int x = (int)lparam;
      int y = (int)dparam;
      g_panel.OnMouseEvent(x, y, id, (int)lparam);
   }

   // 键盘事件 — 转发给面板
   if(id == CHARTEVENT_KEYDOWN) {
      g_panel.OnKeyDown((int)lparam);
   }

   // 快捷键切换显示
   if(id == CHARTEVENT_KEYDOWN && lparam == KEY_F11) {
      if(g_panel.IsVisible())
         g_panel.Hide();
      else
         g_panel.Show();
   }
}
```
