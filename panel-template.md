# EA 面板完整模板 — 整合所有模块

## 概述

这是一个功能完整的 EA 参数配置面板，整合了：标准控件 + 布局系统 + 事件处理 + 视觉设计。复制到你的 EA 文件中即可使用。

---

## 完整代码 (EA.mq5)

```mql5
//+------------------------------------------------------------------+
//|                                                    EA_Panel.mq5 |
//|                                              MiniMax Code Agent |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "MiniMax Code Agent"
#property link      ""
#property version   "1.00"
#property strict

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\ComboBox.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\SpinEdit.mqh>
#include <Controls\Label.mqh>
#include <Controls\GroupBox.mqh>
#include <Controls\TabControl.mqh>
#include <Arrays\ArrayObj.mqh>

//==================================================================
// 视觉配置
//==================================================================
#define CLR_PANEL_BG     C'18, 20, 28'
#define CLR_CARD_BG      C'25, 27, 36'
#define CLR_BORDER       C'55, 60, 80'
#define CLR_FOCUS        C'80, 130, 220'
#define CLR_GREEN        C'30, 160, 70'
#define CLR_RED          C'190, 45, 45'
#define CLR_YELLOW       C'200, 165, 0'
#define CLR_TEXT_MAIN    C'215, 220, 235'
#define CLR_TEXT_SUB     C'130, 145, 165'
#define CLR_TEXT_DIS     C'75, 80, 95'

#define FONT_MAIN        "Segoe UI"
#define FONT_MONO        "Consolas"
#define FONT_SIZE        9

#define H_BTN            28
#define H_EDIT           22
#define H_LABEL          16
#define W_LABEL          72
#define W_EDIT           110
#define W_UNIT           36
#define GAP_X            6
#define GAP_Y            6
#define MARGIN           10

//==================================================================
// 布局类
//==================================================================
class CGridLayout {
private:
   int               m_x, m_y;
   int               m_col_widths[];
   int               m_row_h;
   int               m_hgap, m_vgap;
   int               m_col, m_row;
   int               m_max_cols;

public:
   CGridLayout(int x, int y, int max_cols,
               const int &cw[], int row_h = 22,
               int hgap = 6, int vgap = 6) {
      m_x = x; m_y = y; m_max_cols = max_cols;
      m_row_h = row_h;
      m_hgap = hgap; m_vgap = vgap;
      m_col = 0; m_row = 0;
      ArrayCopy(m_col_widths, cw);
   }

   void              Next(int &x, int &y, int &w, int &h) {
      x = m_x;
      for(int i = 0; i < m_col; i++)
         x += m_col_widths[i] + m_hgap;
      y = m_y + m_row * (m_row_h + m_vgap);
      w = m_col_widths[m_col];
      h = m_row_h;
      m_col++;
      if(m_col >= m_max_cols) { m_col = 0; m_row++; }
   }

   void              Skip(int n) {
      m_col += n;
      if(m_col >= m_max_cols) { m_col = 0; m_row++; }
   }

   void              NewRow() { m_col = 0; m_row++; }

   int               CurY() const {
      return m_y + m_row * (m_row_h + m_vgap);
   }
};

//==================================================================
// EA 面板类
//==================================================================
class CEA_Panel : public CAppDialog {
private:
   //--- Tab 页
   CTabControl        m_tabs;

   //--- 通用
   CEdit              m_ed_lot, m_ed_sl, m_ed_tp;
   CEdit              m_ed_maxspread, m_ed_magic;
   CComboBox          m_cb_symbol, m_cb_risk_mode;
   CComboBox          m_cb_tf, m_cb_direction;
   CCheckBox          m_cb_martingale, m_cb_news_filter;
   CCheckBox          m_cb_break_even, m_cb_trailing;
   CSpinEdit          m_sp_mult, m_sp_max_lots;
   CLabel             m_lb_status, m_lb_equity;
   CGroupBox          m_gb_trade, m_gb_risk, m_gb_manage;

   //--- 按钮
   CButton            m_btn_start, m_btn_stop;
   CButton            m_btn_close, m_btn_settings;

   //--- 状态
   bool               m_running;
   color              m_status_color;

public:
   //+--------------------------------------------------------------+
   //| 主面板参数                                                    |
   //+--------------------------------------------------------------+
   string            Symbol()         { return m_cb_symbol.Text(); }
   double            LotSize()        {
      double v = StringToDouble(m_ed_lot.Text());
      return (v > 0 ? v : 0.01);
   }
   int               StopLoss()       {
      return (int)StringToInteger(m_ed_sl.Text());
   }
   int               TakeProfit()     {
      return (int)StringToInteger(m_ed_tp.Text());
   }
   bool               IsRunning()     { return m_running; }

   //+--------------------------------------------------------------+
   //| 初始化                                                        |
   //+--------------------------------------------------------------+
   virtual int       OnInit() {
      if(!Create(0, "EA Trading Panel",
                 0, 10, 10, 320, 460))
         return INIT_FAILED;

      // 背景
      ColorBackground(CLR_PANEL_BG);
      ColorBorder(CLR_BORDER);

      // Tab
      if(!m_tabs.Create(m_chart_id, "Tabs", m_subwin,
                         5, 5, Width()-10, Height()-10))
         return INIT_FAILED;
      Add(m_tabs);

      int tab0 = m_tabs.AddItem("参数");
      int tab1 = m_tabs.AddItem("风控");
      int tab2 = m_tabs.AddItem("控制");

      CreateParamsTab(tab0);
      CreateRiskTab(tab1);
      CreateControlTab(tab2);

      // 全局事件
      m_tabs.SelectedTab(0);

      return INIT_SUCCEEDED;
   }

   //+--------------------------------------------------------------+
   //| 事件路由                                                      |
   //+--------------------------------------------------------------+
   virtual bool      OnEvent(const int id, const long &lparam,
                              const double &dparam,
                              const string &sparam) {
      // 按钮点击
      if(id == CHARTEVENT_CUSTOM + 1) {
         if(sparam == "btn_start")     { OnStart(); return true; }
         if(sparam == "btn_stop")      { OnStop(); return true; }
         if(sparam == "btn_close")     { OnCloseAll(); return true; }
         if(sparam == "btn_settings")  { OnOpenSettings(); return true; }
      }
      // ComboBox
      if(id == CHARTEVENT_CUSTOM + 2) {
         OnComboChanged(sparam);
         return true;
      }
      // Edit
      if(id == CHARTEVENT_CUSTOM + 3) {
         OnEditChanged(sparam);
         return true;
      }
      // CheckBox
      if(id == CHARTEVENT_CUSTOM + 4) {
         OnCheckChanged(sparam, lparam != 0);
         return true;
      }
      return CAppDialog::OnEvent(id, lparam, dparam, sparam);
   }

   //+--------------------------------------------------------------+
   //| 更新状态显示                                                  |
   //+--------------------------------------------------------------+
   void              RefreshStatus() {
      if(m_running) {
         m_lb_status.Text("● 运行中");
         m_lb_status.Color(CLR_GREEN);
         m_btn_start.Enabled(false);
         m_btn_stop.Enabled(true);
      } else {
         m_lb_status.Text("○ 已停止");
         m_lb_status.Color(CLR_YELLOW);
         m_btn_start.Enabled(true);
         m_btn_stop.Enabled(false);
      }

      double eq = AccountInfoDouble(ACCOUNT_EQUITY);
      m_lb_equity.Text("净值: " + DoubleToString(eq, 2));
   }

private:
   //+--------------------------------------------------------------+
   //| Tab 1: 参数                                                   |
   //+--------------------------------------------------------------+
   void              CreateParamsTab(int idx) {
      int cx = 8, cy = 30, cw = Width()-16, ch = Height()-50;

      // 交易分组
      m_gb_trade.Text("交易设置");
      m_gb_trade.Create(0, "gb_trade", m_subwin,
                        cx, cy, cw, 135);
      m_gb_trade.Color(CLR_TEXT_SUB);
      m_gb_trade.ColorBackground(CLR_CARD_BG);
      Add(m_gb_trade);

      int col_w[] = {W_LABEL, W_EDIT, W_UNIT};
      CGridLayout grid(cx + 6, cy + 22, 3, col_w, H_EDIT, GAP_X, GAP_Y);
      int x, y, w, h;

      // 交易品种
      grid.Next(x, y, w, h);
      CLabel lb_sym; lb_sym.Create(0,"lb_sym",m_subwin,x,y,w,H_LABEL);
      lb_sym.Text("交易品种");
      lb_sym.Color(CLR_TEXT_SUB);
      m_gb_trade.Add(lb_sym);

      grid.Next(x, y, w, h);
      m_cb_symbol.Create(0,"cb_sym",m_subwin,x,y,w,h);
      string syms[] = {"EURUSD","GBPUSD","USDJPY",
                       "XAUUSD","AUDUSD","USDCNH"};
      for(int i=0;i<ArraySize(syms);i++)
         m_cb_symbol.AddItem(syms[i]);
      m_cb_symbol.Select(0);
      m_gb_trade.Add(m_cb_symbol);
      grid.Skip(1);

      // 周期
      grid.NewRow();
      grid.Next(x, y, w, h);
      CLabel lb_tf; lb_tf.Create(0,"lb_tf",m_subwin,x,y,w,H_LABEL);
      lb_tf.Text("交易周期");
      lb_tf.Color(CLR_TEXT_SUB);
      m_gb_trade.Add(lb_tf);

      grid.Next(x, y, w, h);
      m_cb_tf.Create(0,"cb_tf",m_subwin,x,y,w,h);
      string tfs[] = {"M1","M5","M15","M30","H1","H4","D1"};
      for(int i=0;i<ArraySize(tfs);i++)
         m_cb_tf.AddItem(tfs[i]);
      m_cb_tf.Select(0);
      m_gb_trade.Add(m_cb_tf);
      grid.Skip(1);

      // 手数
      grid.NewRow();
      grid.Next(x, y, w, h);
      CLabel lb_lot; lb_lot.Create(0,"lb_lot",m_subwin,x,y,w,H_LABEL);
      lb_lot.Text("开仓手数");
      lb_lot.Color(CLR_TEXT_SUB);
      m_gb_trade.Add(lb_lot);

      grid.Next(x, y, w, h);
      m_ed_lot.Create(0,"ed_lot",m_subwin,x,y,w,h);
      m_ed_lot.Text("0.01");
      m_ed_lot.Font(FONT_MONO);
      m_ed_lot.ColorBackground(C'22,24,32');
      m_ed_lot.ColorBorder(CLR_BORDER);
      m_ed_lot.Color(CLR_TEXT_MAIN);
      m_gb_trade.Add(m_ed_lot);

      grid.Next(x, y, w, h);
      CLabel lb_unit1; lb_unit1.Create(0,"lb_u1",m_subwin,x,y,w,H_LABEL);
      lb_unit1.Text("手");
      lb_unit1.Color(CLR_TEXT_SUB);
      m_gb_trade.Add(lb_unit1);

      // 方向
      grid.NewRow();
      grid.Next(x, y, w, h);
      CLabel lb_dir; lb_dir.Create(0,"lb_dir",m_subwin,x,y,w,H_LABEL);
      lb_dir.Text("交易方向");
      lb_dir.Color(CLR_TEXT_SUB);
      m_gb_trade.Add(lb_dir);

      grid.Next(x, y, w, h);
      m_cb_direction.Create(0,"cb_dir",m_subwin,x,y,w,h);
      m_cb_direction.AddItem("双向");
      m_cb_direction.AddItem("仅做多");
      m_cb_direction.AddItem("仅做空");
      m_cb_direction.Select(0);
      m_gb_trade.Add(m_cb_direction);
      grid.Skip(1);

      // 风控分组
      int gb2_y = cy + 145;
      m_gb_risk.Text("风控设置");
      m_gb_risk.Create(0,"gb_risk",m_subwin,cx,gb2_y,cw,110);
      m_gb_risk.Color(CLR_TEXT_SUB);
      m_gb_risk.ColorBackground(CLR_CARD_BG);
      Add(m_gb_risk);

      CGridLayout grid2(cx+6, gb2_y+22, 3, col_w, H_EDIT, GAP_X, GAP_Y);

      // 止损
      grid2.Next(x, y, w, h);
      CLabel lb_sl; lb_sl.Create(0,"lb_sl",m_subwin,x,y,w,H_LABEL);
      lb_sl.Text("止损点数");
      lb_sl.Color(CLR_TEXT_SUB);
      m_gb_risk.Add(lb_sl);

      grid2.Next(x, y, w, h);
      m_ed_sl.Create(0,"ed_sl",m_subwin,x,y,w,h);
      m_ed_sl.Text("50");
      m_ed_sl.Font(FONT_MONO);
      m_ed_sl.ColorBackground(C'22,24,32');
      m_ed_sl.ColorBorder(CLR_BORDER);
      m_ed_sl.Color(CLR_TEXT_MAIN);
      m_gb_risk.Add(m_ed_sl);

      grid2.Next(x, y, w, h);
      CLabel lb_pips; lb_pips.Create(0,"lb_pip",m_subwin,x,y,w,H_LABEL);
      lb_pips.Text("点");
      lb_pips.Color(CLR_TEXT_SUB);
      m_gb_risk.Add(lb_pips);

      // 止盈
      grid2.NewRow();
      grid2.Next(x, y, w, h);
      CLabel lb_tp; lb_tp.Create(0,"lb_tp",m_subwin,x,y,w,H_LABEL);
      lb_tp.Text("止盈点数");
      lb_tp.Color(CLR_TEXT_SUB);
      m_gb_risk.Add(lb_tp);

      grid2.Next(x, y, w, h);
      m_ed_tp.Create(0,"ed_tp",m_subwin,x,y,w,h);
      m_ed_tp.Text("100");
      m_ed_tp.Font(FONT_MONO);
      m_ed_tp.ColorBackground(C'22,24,32');
      m_ed_tp.ColorBorder(CLR_BORDER);
      m_ed_tp.Color(CLR_TEXT_MAIN);
      m_gb_risk.Add(m_ed_tp);

      grid2.Next(x, y, w, h);
      CLabel lb_pips2; lb_pips2.Create(0,"lb_pip2",m_subwin,x,y,w,H_LABEL);
      lb_pips2.Text("点");
      lb_pips2.Color(CLR_TEXT_SUB);
      m_gb_risk.Add(lb_pips2);

      // 最大止损
      grid2.NewRow();
      grid2.Next(x, y, w, h);
      CLabel lb_sp; lb_sp.Create(0,"lb_sp",m_subwin,x,y,w,H_LABEL);
      lb_sp.Text("最大spread");
      lb_sp.Color(CLR_TEXT_SUB);
      m_gb_risk.Add(lb_sp);

      grid2.Next(x, y, w, h);
      m_ed_maxspread.Create(0,"ed_sp",m_subwin,x,y,w,h);
      m_ed_maxspread.Text("30");
      m_ed_maxspread.Font(FONT_MONO);
      m_ed_maxspread.ColorBackground(C'22,24,32');
      m_ed_maxspread.ColorBorder(CLR_BORDER);
      m_ed_maxspread.Color(CLR_TEXT_MAIN);
      m_gb_risk.Add(m_ed_maxspread);
      grid2.Skip(1);
   }

   //+--------------------------------------------------------------+
   //| Tab 2: 风控                                                   |
   //+--------------------------------------------------------------+
   void              CreateRiskTab(int idx) {
      int cx = 8, cy = 30, cw = Width()-16;

      m_gb_manage.Text("风控选项");
      m_gb_manage.Create(0,"gb_mg",m_subwin,cx,cy,cw,180);
      m_gb_manage.Color(CLR_TEXT_SUB);
      m_gb_manage.ColorBackground(CLR_CARD_BG);
      Add(m_gb_manage);

      // 复选框
      m_cb_martingale.Create(0,"cb_mg",m_subwin,
                              cx+10, cy+22, 140, 20);
      m_cb_martingale.Text("启用马丁格尔");
      m_cb_martingale.Color(CLR_TEXT_MAIN);
      m_gb_manage.Add(m_cb_martingale);

      CLabel lb_mult; lb_mult.Create(0,"lb_mult",m_subwin,
                                      cx+10, cy+48, 70, H_LABEL);
      lb_mult.Text("马丁系数");
      lb_mult.Color(CLR_TEXT_SUB);
      m_gb_manage.Add(lb_mult);

      m_sp_mult.Create(0,"sp_mult",m_subwin,
                        cx+80, cy+46, 60, H_EDIT);
      m_sp_mult.MinValue(1);
      m_sp_mult.MaxValue(10);
      m_sp_mult.Value(2);
      m_sp_mult.ColorBackground(C'22,24,32');
      m_sp_mult.ColorBorder(CLR_BORDER);
      m_sp_mult.Color(CLR_TEXT_MAIN);
      m_sp_mult.Enabled(false);
      m_gb_manage.Add(m_sp_mult);

      m_cb_break_even.Create(0,"cb_be",m_subwin,
                               cx+160, cy+22, 140, 20);
      m_cb_break_even.Text("移动保本");
      m_cb_break_even.Color(CLR_TEXT_MAIN);
      m_gb_manage.Add(m_cb_break_even);

      m_cb_trailing.Create(0,"cb_tr",m_subwin,
                             cx+10, cy+74, 140, 20);
      m_cb_trailing.Text("追踪止损");
      m_cb_trailing.Color(CLR_TEXT_MAIN);
      m_gb_manage.Add(m_cb_trailing);

      m_cb_news_filter.Create(0,"cb_news",m_subwin,
                                cx+160, cy+74, 140, 20);
      m_cb_news_filter.Text("新闻过滤");
      m_cb_news_filter.Color(CLR_TEXT_MAIN);
      m_gb_manage.Add(m_cb_news_filter);

      // 最大持仓
      CLabel lb_ml; lb_ml.Create(0,"lb_ml",m_subwin,
                                  cx+10, cy+100, 70, H_LABEL);
      lb_ml.Text("最大手数");
      lb_ml.Color(CLR_TEXT_SUB);
      m_gb_manage.Add(lb_ml);

      m_sp_max_lots.Create(0,"sp_ml",m_subwin,
                             cx+80, cy+98, 60, H_EDIT);
      m_sp_max_lots.MinValue(1);
      m_sp_max_lots.MaxValue(100);
      m_sp_max_lots.Value(10);
      m_sp_max_lots.ColorBackground(C'22,24,32');
      m_sp_max_lots.ColorBorder(CLR_BORDER);
      m_sp_max_lots.Color(CLR_TEXT_MAIN);
      m_gb_manage.Add(m_sp_max_lots);

      CLabel lb_mg; lb_mg.Create(0,"lb_mgunit",m_subwin,
                                   cx+145, cy+100, 40, H_LABEL);
      lb_mg.Text("手");
      lb_mg.Color(CLR_TEXT_SUB);
      m_gb_manage.Add(lb_mg);
   }

   //+--------------------------------------------------------------+
   //| Tab 3: 控制                                                   |
   //+--------------------------------------------------------------+
   void              CreateControlTab(int idx) {
      int cx = 8, cy = 30, cw = Width()-16;

      // 状态显示
      m_lb_status.Create(0,"lb_stat",m_subwin,cx+10,cy+10,200,H_LABEL);
      m_lb_status.Text("○ 就绪");
      m_lb_status.Color(CLR_TEXT_SUB);
      m_lb_status.FontFlags(FONT_BOLD);
      Add(m_lb_status);

      m_lb_equity.Create(0,"lb_eq",m_subwin,cx+10,cy+30,200,H_LABEL);
      m_lb_equity.Text("净值: --");
      m_lb_equity.Color(CLR_TEXT_MAIN);
      Add(m_lb_equity);

      // Magic 编号
      CLabel lb_mg; lb_mg.Create(0,"lb_mg",m_subwin,cx+10,cy+60,60,H_LABEL);
      lb_mg.Text("MagicID");
      lb_mg.Color(CLR_TEXT_SUB);
      Add(lb_mg);

      m_ed_magic.Create(0,"ed_mg",m_subwin,cx+75,cy+58,100,H_EDIT);
      m_ed_magic.Text("2024001");
      m_ed_magic.Font(FONT_MONO);
      m_ed_magic.ColorBackground(C'22,24,32');
      m_ed_magic.ColorBorder(CLR_BORDER);
      m_ed_magic.Color(CLR_TEXT_MAIN);
      Add(m_ed_magic);

      // 按钮组
      int btn_y = cy + 100;

      // 开始按钮 (绿色)
      m_btn_start.Create(0,"btn_start",m_subwin,
                          cx+10, btn_y, 90, H_BTN);
      m_btn_start.Text("▶ 开始");
      m_btn_start.Color(clrWhite);
      m_btn_start.ColorBackground(CLR_GREEN);
      m_btn_start.ColorBorder(CLR_GREEN);
      m_btn_start.FontFlags(FONT_BOLD);
      Add(m_btn_start);

      // 停止按钮 (红色)
      m_btn_stop.Create(0,"btn_stop",m_subwin,
                         cx+108, btn_y, 90, H_BTN);
      m_btn_stop.Text("■ 停止");
      m_btn_stop.Color(clrWhite);
      m_btn_stop.ColorBackground(CLR_RED);
      m_btn_stop.ColorBorder(CLR_RED);
      m_btn_stop.FontFlags(FONT_BOLD);
      m_btn_stop.Enabled(false);
      Add(m_btn_stop);

      // 平仓按钮 (黄色)
      m_btn_close.Create(0,"btn_close",m_subwin,
                           cx+206, btn_y, 90, H_BTN);
      m_btn_close.Text("✕ 平仓");
      m_btn_close.Color(C'30,30,30');
      m_btn_close.ColorBackground(CLR_YELLOW);
      m_btn_close.ColorBorder(CLR_YELLOW);
      m_btn_close.FontFlags(FONT_BOLD);
      Add(m_btn_close);

      m_running = false;
      RefreshStatus();
   }

   //+--------------------------------------------------------------+
   //| 事件处理                                                      |
   //+--------------------------------------------------------------+
   void              OnStart() {
      m_running = true;
      RefreshStatus();
      Print("=== EA 开始运行 ===");
      Print("品种: ", m_cb_symbol.Text());
      Print("手数: ", m_ed_lot.Text());
      Print("止损: ", m_ed_sl.Text(), "点 | 止盈: ",
             m_ed_tp.Text(), "点");
   }

   void              OnStop() {
      m_running = false;
      RefreshStatus();
      Print("=== EA 已停止 ===");
   }

   void              OnCloseAll() {
      Print("=== 平仓所有仓位 ===");
      // 遍历持仓，调用 PositionClose
   }

   void              OnOpenSettings() {
      m_tabs.SelectedTab(0);  // 切换到参数 Tab
   }

   void              OnComboChanged(const string name) {
      Print("ComboBox 变化: ", name,
            " = ", m_cb_symbol.Text());
   }

   void              OnEditChanged(const string name) {
      Print("Edit 变化: ", name);
   }

   void              OnCheckChanged(const string name,
                                    bool checked) {
      Print("CheckBox ", name, " = ", checked);
      if(name == "cb_mg") {
         m_sp_mult.Enabled(checked);
      }
   }
};

//==================================================================
// EA 全局变量
//==================================================================
CEA_Panel  g_panel;

//==================================================================
// EA 标准函数
//==================================================================
int OnInit() {
   return g_panel.OnInit();
}

void OnDeinit(const int reason) {
   g_panel.Destroy(reason);
}

void OnTick() {
   // EA 交易逻辑
   if(g_panel.IsRunning()) {
      // ... 你的策略代码 ...
   }
}

void OnChartEvent(const int id, const long &lparam,
                  const double &dparam, const string &sparam) {
   g_panel.OnEvent(id, lparam, dparam, sparam);
}
```

---

## 模板速查

| 元素 | 对应控件 | 事件 |
|------|---------|------|
| 开始/停止/平仓 | `CButton` | `CHARTEVENT_CUSTOM+1` |
| 交易品种/周期/方向 | `CComboBox` | `CHARTEVENT_CUSTOM+2` |
| 手数/止损/止盈输入 | `CEdit` | `CHARTEVENT_CUSTOM+3` |
| 马丁/保本/追踪止损开关 | `CCheckBox` | `CHARTEVENT_CUSTOM+4` |
| 马丁系数/最大手数 | `CSpinEdit` | `CHARTEVENT_CUSTOM+3` |
| Tab 切换 | `CTabControl` | `CHARTEVENT_CUSTOM` |
| 状态/净值显示 | `CLabel` | 只读 |
| 分组卡片 | `CGroupBox` | 只读容器 |
