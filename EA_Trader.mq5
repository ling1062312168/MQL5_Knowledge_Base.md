//+------------------------------------------------------------------+
//|                                          EA_Trader.mq5           |
//|                                      EA Control Panel v2.0.0     |
//|          完整功能版: 导航下拉/4个Tab页/参数实时/统计筛选/拖拽         |
//+------------------------------------------------------------------+
#property copyright "EA Trader"
#property version   "2.00"
#property description "完整功能交易面板 — 开仓/加仓/平仓/统计/设置"
#property strict

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| 枚举                                                              |
//+------------------------------------------------------------------+
enum ENUM_RISK_MODE
{
   RISK_FIXED = 0,
   RISK_PERCENT = 1,
   RISK_RATIO = 2
};

enum ENUM_STATS_PERIOD
{
   SP_TODAY = 0,
   SP_WEEK = 1,
   SP_MONTH = 2,
   SP_ALL = 3
};

enum ENUM_POS_FILTER
{
   PF_ALL = 0,
   PF_BUY = 1,
   PF_SELL = 2
};

//+------------------------------------------------------------------+
//| 输入参数                                                          |
//+------------------------------------------------------------------+
input group "=== 交易参数 ==="
input double   InpLot            = 0.10;
input int      InpStopLoss       = 50;
input int      InpTakeProfit     = 100;
input int      InpMagicNumber    = 2024001;
input int      InpSlippage       = 30;

input group "=== 时间过滤 ==="
input bool     InpTimeFilter     = false;
input string   InpStartTime      = "09:00";
input string   InpStopTime       = "23:00";

input group "=== 风险管理 ==="
input ENUM_RISK_MODE InpRiskMode = RISK_FIXED;
input double   InpRiskPercent    = 2.0;

input group "=== 加仓参数 ==="
input double   InpAddLot         = 0.10;
input int      InpAddDistance    = 30;
input int      InpMaxPositions   = 10;

input group "=== 显示设置 ==="
input int      InpPanelX         = 10;
input int      InpPanelY         = 30;

//+------------------------------------------------------------------+
//| 全局状态变量                                                      |
//+------------------------------------------------------------------+
bool              g_drag_state      = false;
int               g_drag_start_x    = 0;
int               g_drag_start_y    = 0;
bool              g_mouse_down      = false;
int               g_active_tab      = 0;
bool              g_auto_trading    = true;
bool              g_dropdown_open   = false;
int               g_dropdown_tab    = -1;
ENUM_STATS_PERIOD g_stats_period    = SP_ALL;
ENUM_POS_FILTER   g_pos_filter      = PF_ALL;
int               g_pos_sort        = 0;
bool              g_risk_dd_open    = false;
color             g_panel_colors[5] = {clrDarkSlateGray, clrDarkOliveGreen, clrDarkBlue, clrPurple, clrMaroon};
int               g_panel_color_idx = 0;

// 移动止损参数
input int         InpTrailingStop   = 0;       // 移动止损点数（0=关闭）
input int         InpTrailingStep   = 5;       // 移动止损步长（点）

//+------------------------------------------------------------------+
//| CTrading 类 — 交易管理                                              |
//+------------------------------------------------------------------+
class CTrading
{
private:
   int   m_magic, m_slip;
   CTrade m_trade;
   bool  ChkMargin(double lot);

public:
   void  Init(int magic, int slip) { m_magic=magic; m_slip=slip; m_trade.SetExpertMagicNumber(magic); m_trade.SetDeviationInPoints(slip); }
   ulong OpenOrder(ENUM_ORDER_TYPE type, double lot, int sl_pt, int tp_pt);
   ulong AddToPosition(int pos_type, double lot);
   bool  ClosePosition(ulong ticket);
   bool  CloseAll();
   bool  CloseByType(int pos_type);
   bool  Modify(ulong ticket, double sl, double tp);
   int   Count(int pos_type);
   int   TotalCount();
   void  TrailingStop(int ts_points, int ts_step);
};

bool CTrading::ChkMargin(double lot)
{
   double margin=0; string sym=Symbol();
   if(!OrderCalcMargin(ORDER_TYPE_BUY,sym,lot,SymbolInfoDouble(sym,SYMBOL_ASK),margin)) return false;
   return margin <= AccountInfoDouble(ACCOUNT_MARGIN_FREE);
}

ulong CTrading::OpenOrder(ENUM_ORDER_TYPE type, double lot, int sl_pt, int tp_pt)
{
   if(!ChkMargin(lot)) { Print("保证金不足"); return 0; }
   string sym=Symbol();
   double sl=0,tp=0,pt=SymbolInfoDouble(sym,SYMBOL_POINT);
   int dg=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
   if(sl_pt>0) sl=(type==ORDER_TYPE_BUY)?SymbolInfoDouble(sym,SYMBOL_ASK)-sl_pt*pt:SymbolInfoDouble(sym,SYMBOL_BID)+sl_pt*pt;
   if(tp_pt>0) tp=(type==ORDER_TYPE_BUY)?SymbolInfoDouble(sym,SYMBOL_ASK)+tp_pt*pt:SymbolInfoDouble(sym,SYMBOL_BID)-tp_pt*pt;
   sl=NormalizeDouble(sl,dg);
   tp=NormalizeDouble(tp,dg);

   bool result;
   if(type==ORDER_TYPE_BUY)
      result = m_trade.Buy(lot, sym, 0, sl, tp);
   else
      result = m_trade.Sell(lot, sym, 0, sl, tp);

   if(!result) { Print("开仓失败:",m_trade.ResultRetcode()); return 0; }
   Print("开仓 ",type==ORDER_TYPE_BUY?"BUY":"SELL"," lot:",lot);
   return m_trade.ResultOrder();
}

ulong CTrading::AddToPosition(int pos_type, double lot)
{
   if(!ChkMargin(lot)) return 0;
   ENUM_ORDER_TYPE ot=(pos_type==POSITION_TYPE_BUY)?ORDER_TYPE_BUY:ORDER_TYPE_SELL;
   return OpenOrder(ot,lot,0,0);
}

bool CTrading::ClosePosition(ulong ticket)
{
   if(!PositionSelectByTicket(ticket)) return false;

   bool result = m_trade.PositionClose(ticket);
   if(!result) { Print("平仓失败:",ticket," ",m_trade.ResultRetcode()); return false; }
   Print("平仓 ",ticket); return true;
}

bool CTrading::CloseAll()
{
   int ok=0;
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   { ulong t=PositionGetTicket(i); if(t>0&&ClosePosition(t)) ok++; }
   return ok>0;
}

bool CTrading::CloseByType(int pos_type)
{
   int ok=0;
   for(int i=(int)PositionsTotal()-1;i>=0;i--)
   {
      ulong t=PositionGetTicket(i);
      if(t>0&&PositionSelectByTicket(t)&&(int)PositionGetInteger(POSITION_TYPE)==pos_type)
         if(ClosePosition(t)) ok++;
   }
   return ok>0;
}

bool CTrading::Modify(ulong ticket, double sl, double tp)
{
   if(!PositionSelectByTicket(ticket)) return false;
   string sym=PositionGetString(POSITION_SYMBOL);
   int dg=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
   sl=NormalizeDouble(sl,dg);
   tp=NormalizeDouble(tp,dg);

   bool result = m_trade.PositionModify(ticket, sl, tp);
   if(!result) { Print("改单失败:",ticket," ",m_trade.ResultRetcode()); return false; }
   return true;
}

int CTrading::Count(int pos_type)
{
   int c=0;
   for(int i=0;i<(int)PositionsTotal();i++)
   { ulong t=PositionGetTicket(i); if(t>0&&PositionSelectByTicket(t)&&(int)PositionGetInteger(POSITION_TYPE)==pos_type) c++; }
   return c;
}

int CTrading::TotalCount()
{
   return (int)PositionsTotal();
}

void CTrading::TrailingStop(int ts_points, int ts_step)
{
   if(ts_points <= 0) return;
   string sym = Symbol();
   double point = SymbolInfoDouble(sym, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);

   for(int i = (int)PositionsTotal()-1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;

      ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double current_price = PositionGetDouble(POSITION_PRICE_CURRENT);
      double current_sl = PositionGetDouble(POSITION_SL);
      double open_price = PositionGetDouble(POSITION_PRICE_OPEN);

      double new_sl = 0;
      if(type == POSITION_TYPE_BUY)
      {
         new_sl = NormalizeDouble(current_price - ts_points * point, digits);
         if(current_sl > 0 && new_sl < current_sl) continue;
         if(new_sl <= open_price) continue;
      }
      else
      {
         new_sl = NormalizeDouble(current_price + ts_points * point, digits);
         if(current_sl > 0 && new_sl > current_sl) continue;
         if(new_sl >= open_price) continue;
      }

      m_trade.PositionModify(ticket, new_sl, PositionGetDouble(POSITION_TP));
   }
}

//+------------------------------------------------------------------+
//| CStatistics 类 — 交易统计                                           |
//+------------------------------------------------------------------+
class CStatistics
{
private:
   int    m_magic;
   int    m_tot, m_win, m_los, m_max_cw, m_max_cl;
   double m_net, m_win_amt, m_los_amt, m_max_dd, m_max_win_amt, m_max_los_amt;
   void   ResetCache();

public:
   void   Init(int magic) { m_magic=magic; ResetCache(); }
   void   Update(ENUM_STATS_PERIOD period);
   void   ResetAll() { ResetCache(); }

   int    Total()        { return m_tot; }
   int    Wins()         { return m_win; }
   int    Losses()       { return m_los; }
   double WinRate()      { return m_tot>0?(double)m_win/m_tot*100.0:0; }
   double ProfitRatio()  { return m_los_amt>0?m_win_amt/m_los_amt:(m_win_amt>0?999:0); }
   double Net()          { return m_net; }
   double AvgWin()       { return m_win>0?m_win_amt/m_win:0; }
   double AvgLoss()      { return m_los>0?m_los_amt/m_los:0; }
   double MaxDD()        { return m_max_dd; }
   int    MaxCW()        { return m_max_cw; }
   int    MaxCL()        { return m_max_cl; }
   double Sharpe();
   double Recovery()     { return m_max_dd>0?m_net/m_max_dd:m_net; }
   double Expectancy();
};

void CStatistics::ResetCache()
{
   m_tot=m_win=m_los=m_max_cw=m_max_cl=0;
   m_net=m_win_amt=m_los_amt=m_max_dd=m_max_win_amt=m_max_los_amt=0;
}

void CStatistics::Update(ENUM_STATS_PERIOD period)
{
   ResetCache();
   datetime from=0;
   datetime now=TimeCurrent();
   if(period==SP_TODAY)
   {
      MqlDateTime dt;
      TimeToStruct(now,dt);
      dt.hour=0; dt.min=0; dt.sec=0;
      from=StructToTime(dt);
   }
   else if(period==SP_WEEK)
   {
      MqlDateTime dt;
      TimeToStruct(now,dt);
      int dow=dt.day_of_week==0?6:dt.day_of_week-1;
      dt.hour=0; dt.min=0; dt.sec=0;
      from=StructToTime(dt)-dow*86400;
   }
   else if(period==SP_MONTH)
   {
      MqlDateTime dt;
      TimeToStruct(now,dt);
      dt.day=1; dt.hour=0; dt.min=0; dt.sec=0;
      from=StructToTime(dt);
   }

   if(!HistorySelect(from,now)) return;
   int total=(int)HistoryDealsTotal();
   if(total==0) return;

   int cw=0,cl=0;
   double peak=AccountInfoDouble(ACCOUNT_BALANCE);

   for(int i=0;i<total;i++)
   {
      ulong tkt=HistoryDealGetTicket(i); if(tkt==0) continue;
      long dm=HistoryDealGetInteger(tkt,DEAL_MAGIC);
      if(m_magic>0&&dm!=m_magic) continue;
      long dt=HistoryDealGetInteger(tkt,DEAL_TYPE);
      if(dt!=DEAL_TYPE_SELL&&dt!=DEAL_TYPE_BUY) continue;
      double p=HistoryDealGetDouble(tkt,DEAL_PROFIT)
               +HistoryDealGetDouble(tkt,DEAL_COMMISSION)
               +HistoryDealGetDouble(tkt,DEAL_SWAP);
      if(p==0) continue;
      m_tot++; m_net+=p;
      if(p>0)
      {
         m_win++; m_win_amt+=p; cw++; cl=0;
         if(p>m_max_win_amt) m_max_win_amt=p;
         if(cw>m_max_cw) m_max_cw=cw;
      }
      else
      {
         m_los++; m_los_amt+=MathAbs(p); cl++; cw=0;
         if(MathAbs(p)>m_max_los_amt) m_max_los_amt=MathAbs(p);
         if(cl>m_max_cl) m_max_cl=cl;
      }
   }
   double eq=AccountInfoDouble(ACCOUNT_EQUITY);
   m_max_dd=peak-eq; if(m_max_dd<0) m_max_dd=0;
}

double CStatistics::Sharpe()
{
   if(m_tot<2) return 0;
   double avg=m_net/m_tot, sq=0; int cnt=0;
   datetime now=TimeCurrent();
   HistorySelect(0,now);
   int hd=(int)HistoryDealsTotal();
   for(int i=0;i<hd;i++)
   {
      ulong tkt=HistoryDealGetTicket(i); if(tkt==0) continue;
      long dm=HistoryDealGetInteger(tkt,DEAL_MAGIC);
      if(m_magic>0&&dm!=m_magic) continue;
      long dt=HistoryDealGetInteger(tkt,DEAL_TYPE);
      if(dt!=DEAL_TYPE_SELL&&dt!=DEAL_TYPE_BUY) continue;
      double p=HistoryDealGetDouble(tkt,DEAL_PROFIT)
               +HistoryDealGetDouble(tkt,DEAL_COMMISSION)
               +HistoryDealGetDouble(tkt,DEAL_SWAP);
      if(p==0) continue;
      cnt++; double d=p-avg; sq+=d*d;
   }
   double sd=cnt>1?MathSqrt(sq/(cnt-1)):1;
   return sd>0?avg/sd*MathSqrt(cnt):0;
}

double CStatistics::Expectancy()
{
   if(m_tot==0) return 0;
   double wr=(double)m_win/m_tot, lr=(double)m_los/m_tot;
   double aw=m_win>0?m_win_amt/m_win:0;
   double al=m_los>0?m_los_amt/m_los:0;
   return wr*aw-lr*al;
}

//+------------------------------------------------------------------+
//| CPanel 类 — 完整面板UI                                              |
//+------------------------------------------------------------------+
class CPanel
{
private:
   long   m_ch; int m_sub; string m_pfx;
   int    m_x,m_y,m_w,m_h;

   // 参数
   double m_lot, m_add_lot, m_risk_pct;
   int    m_sl, m_tp;
   ENUM_RISK_MODE m_risk_mode;
   bool   m_auto;
   ulong  m_mod_ticket;
   int    m_color_idx;

   // 模块
   CTrading    m_tr;
   CStatistics m_st;

   // 内部创建
   void BuildLayout();
   bool Btn(string n,string t,int x,int y,int w,int h,color bg,color tc);
   bool Lbl(string n,string t,int x,int y,int w,int h,color tc,int fs=9);
   bool Edt(string n,string t,int x,int y,int w,int h);
   bool Rct(string n,int x,int y,int w,int h,color bg,color bc);
   void ShowDropdown(int tab);
   void HideDropdown();
   void ShowRiskDropdown(int px, int py, int pw);
   void HideRiskDropdown();
   void UpdatePanelColor();
   void UpdateLotPreview();

   // Tab页内容创建
   void BuildTradeTab();
   void BuildPositionsTab();
   void BuildStatsTab();
   void BuildSettingsTab();
   void ClearTabContent();

public:
   CPanel();
   ~CPanel();
   bool   Create(long ch,int sub,string pfx,int x,int y);
   void   Destroy();
   void   Redraw() { ChartRedraw(m_ch); }

   // 更新
   void   UpdateAccount();
   void   UpdatePL();
   void   UpdatePositions(ENUM_POS_FILTER filter, int sort_mode);
   void   UpdateStats();
   void   SwitchTab(int tab);

   // 下拉菜单
   void   ToggleDropdown(int tab);
   void   CloseDropdown();
   void   ToggleRiskDropdown(int px, int py, int pw);
   void   CloseRiskDropdown();
   void   SetRiskMode(ENUM_RISK_MODE mode);

   // 修改对话框
   void   ShowModDialog(ulong ticket);
   void   HideModDialog();

   // 设置功能
   void   NextPanelColor();
   void   ResetPosition();
   void   ToggleOnTop();
   void   SaveSettings();

   // Getter/Setter
   void   SetTr(int magic, int slip) { m_tr.Init(magic, slip); }
   void   SetSt(int magic) { m_st.Init(magic); }
   void   SetLot(double v)      { m_lot=v; }
   void   SetSL(int v)          { m_sl=v; }
   void   SetTP(int v)          { m_tp=v; }
   void   SetRisk(ENUM_RISK_MODE v){ m_risk_mode=v; }
   void   SetAuto(bool v);
   void   SetAddLot(double v)   { m_add_lot=v; }
   void   SetRPct(double v)     { m_risk_pct=v; }

   double GetLot()              { return m_lot; }
   int    GetSL()               { return m_sl; }
   int    GetTP()               { return m_tp; }
   double GetAddLot()           { return m_add_lot; }
   double GetRPct()             { return m_risk_pct; }
   ENUM_RISK_MODE GetRisk()     { return m_risk_mode; }
   bool   IsAuto()              { return m_auto; }
   ulong  ModTicket()           { return m_mod_ticket; }
   double ModSL();
   double ModTP();

   void   ReadAllEdits();
   void   CycleRiskMode();
   double CalcRiskLotSize();

   // 拖拽
   void   StartDrag(int x,int y);
   void   DragTo(int x,int y);
   void   EndDrag();
   bool   IsDragging()          { return g_drag_state; }
   int    GetX()                { return m_x; }
   int    GetY()                { return m_y; }
   bool   IsClickOnPanel(int x,int y);
};

CPanel::CPanel()
{
   m_ch=0;m_sub=0;m_pfx="EAP_";
   m_x=10;m_y=30;m_w=500;m_h=620;
   m_lot=0.10;m_add_lot=0.10;m_risk_pct=2.0;m_sl=50;m_tp=100;
   m_risk_mode=RISK_FIXED;m_auto=true;m_mod_ticket=0;
   m_color_idx=0;
   // m_tr和m_st使用默认构造，通过Init方法初始化
}
CPanel::~CPanel(){ Destroy(); }

// 辅助: 检查字符串前缀
bool StrStarts(string s, string pfx)
{
   return StringFind(s, pfx) == 0;
}

bool CPanel::Create(long ch,int sub,string pfx,int x,int y)
{
   m_ch=ch;m_sub=sub;m_pfx=pfx+"_";m_x=x;m_y=y;
   Destroy();
   BuildLayout();
   BuildTradeTab();
   Redraw();
   return true;
}

void CPanel::Destroy()
{
   for(int i=(int)ObjectsTotal(m_ch,m_sub)-1;i>=0;i--)
   { string n=ObjectName(m_ch,i,m_sub); if(StrStarts(n,m_pfx)) ObjectDelete(m_ch,n); }
}

void CPanel::BuildLayout()
{
   color bgc = g_panel_colors[m_color_idx];
   // 背景
   Rct("BG",0,0,m_w,m_h,bgc,clrDimGray);
   // 标题栏 (拖拽区)
   Lbl("Title","EA Trader v2.0  [拖拽标题移动]",10,6,280,18,clrAqua,11);
   Lbl("Status","Online",300,6,60,18,clrLimeGreen,9);

   // 导航栏 - 点击显示下拉菜单
   int nbw=(m_w-24)/4;
   string tbs[4]={"交易 ▼","持仓 ▼","统计 ▼","设置 ▼"};
   string nns[4]={"Nav_0","Nav_1","Nav_2","Nav_3"};
   for(int i=0;i<4;i++)
      Btn(nns[i],tbs[i],10+i*(nbw+2),28,nbw,24,i==0?clrDodgerBlue:clrGray,clrWhite);

   // 账户信息条 (始终显示)
   Rct("Sec_Acc",10,58,m_w-20,52,clrBlack,clrDimGray);
   int cw=(m_w-36)/4;
   string al[4]={"余额","净值","保证金","浮盈亏"};
   string av[4]={"Acc_Bal","Acc_Eq","Acc_Mar","Acc_PL"};
   for(int i=0;i<4;i++)
   {
      Lbl(av[i],"--",16+i*cw,68,cw,16,clrWhite,12);
      Lbl("L"+av[i],al[i],16+i*cw,86,cw,12,clrLightGray,8);
   }

   // Tab内容区域分隔线
   Lbl("TabContentStart","",10,116,1,1,clrBlack,1);

   // 底部状态栏
   int by=m_h-30;
   Rct("BottomBar",0,by,m_w,30,clrBlack,clrDimGray);
   Lbl("Bot_Ver","v2.00",10,by+8,60,16,clrDimGray,8);
   Lbl("Bot_Sym",Symbol(),75,by+8,120,16,clrLightGray,8);
   Btn("Bot_Auto","自动:ON",m_w-100,by+4,86,20,clrGreen,clrWhite);
}

//==================== Tab页切换 ====================
void CPanel::SwitchTab(int tab)
{
   ReadAllEdits();
   for(int i=0;i<4;i++)
   {
      long c=(i==tab)?clrDodgerBlue:clrGray;
      ObjectSetInteger(m_ch,m_pfx+"Nav_"+IntegerToString(i),OBJPROP_BGCOLOR,c);
   }
   ClearTabContent();
   HideDropdown();
   HideRiskDropdown();

   if(tab==0) BuildTradeTab();
   else if(tab==1) { BuildPositionsTab(); UpdatePositions(g_pos_filter, g_pos_sort); }
   else if(tab==2) { BuildStatsTab(); UpdateStats(); }
   else if(tab==3) BuildSettingsTab();
}

void CPanel::ClearTabContent()
{
   for(int i=(int)ObjectsTotal(m_ch,m_sub)-1;i>=0;i--)
   {
      string n=ObjectName(m_ch,i,m_sub);
      if(StrStarts(n,m_pfx+"Tab_")) ObjectDelete(m_ch,n);
   }
}

//==================== Tab 0: 交易页 ====================
void CPanel::BuildTradeTab()
{
   int ty=118;

   // 交易操作区
   Rct("Tab_Tr_BG",10,ty,m_w-20,200,clrBlack,clrDimGray);
   Lbl("Tab_Tr_Title","交易操作",16,ty+4,80,16,clrAqua,10);

   int bw=(m_w-34)/2;
   Btn("Tab_Tr_Buy","BUY",16,ty+22,bw-2,28,clrGreen,clrWhite);
   Btn("Tab_Tr_Sell","SELL",18+bw,ty+22,bw-2,28,clrRed,clrWhite);

   int sm=(m_w-50)/4;
   int ry=ty+54;
   Btn("Tab_Tr_Add","+加仓",16,ry,sm,22,clrDarkGray,clrWhite);
   Btn("Tab_Tr_CA","全平",18+sm,ry,sm,22,clrMaroon,clrWhite);
   Btn("Tab_Tr_CB","平Buy",20+sm*2,ry,sm,22,clrDarkGreen,clrWhite);
   Btn("Tab_Tr_CS","平Sell",22+sm*3,ry,sm,22,clrDarkRed,clrWhite);

   // 参数设置区
   int py=ty+82;
   Lbl("Tab_Tr_ParamTitle","参数设置 (点击编辑框修改)",16,py,200,14,clrAqua,9);

   int pcw=(m_w-40)/4;
   py+=16;
   Lbl("Tab_Tr_LotLbl","手数",16,py,pcw,12,clrLightGray,8);
   Edt("Tab_Tr_Lot",DoubleToString(m_lot,2),16,py+12,pcw-4,18);
   Lbl("Tab_Tr_SLLbl","止损(点)",20+pcw,py,pcw,12,clrLightGray,8);
   Edt("Tab_Tr_SL",IntegerToString(m_sl),20+pcw,py+12,pcw-4,18);
   Lbl("Tab_Tr_TPLbl","止盈(点)",24+pcw*2,py,pcw,12,clrLightGray,8);
   Edt("Tab_Tr_TP",IntegerToString(m_tp),24+pcw*2,py+12,pcw-4,18);
   Lbl("Tab_Tr_RiskLbl","风险模式 ▼",28+pcw*3,py,pcw,12,clrLightGray,8);

   string rm_txt="";
   if(m_risk_mode==RISK_FIXED) rm_txt="固定手数";
   else if(m_risk_mode==RISK_PERCENT) rm_txt="余额%";
   else rm_txt="风险比";
   Btn("Tab_Tr_RiskBtn",rm_txt,28+pcw*3,py+12,pcw-4,18,clrDimGray,clrWhite);

   // 风险手数预览
   int pry=py+42;
   Lbl("Tab_Tr_PrevLbl","实际开仓手数:",16,pry,120,14,clrAqua,9);
   double calc_lot = CalcRiskLotSize();
   Lbl("Tab_Tr_PrevVal",DoubleToString(calc_lot,2),140,pry,80,14,clrYellow,11);
   Lbl("Tab_Tr_PrevHint",
       m_risk_mode==RISK_FIXED?"固定手数模式":
       (m_risk_mode==RISK_PERCENT?StringFormat("风险 %.1f%% 余额",m_risk_pct):"风险比例模式"),
       220,pry,180,14,clrLightGray,8);
}

//==================== Tab 1: 持仓页 ====================
void CPanel::BuildPositionsTab()
{
   int ty=118;
   Rct("Tab_P_BG",10,ty,m_w-20,460,clrBlack,clrDimGray);

   // 筛选按钮
   Lbl("Tab_P_Title","持仓管理",16,ty+4,80,16,clrAqua,10);
   Btn("Tab_P_F_All","全部",100,ty+4,50,20,(g_pos_filter==PF_ALL)?clrDodgerBlue:clrGray,clrWhite);
   Btn("Tab_P_F_Buy","Buy",152,ty+4,50,20,(g_pos_filter==PF_BUY)?clrDodgerBlue:clrGray,clrWhite);
   Btn("Tab_P_F_Sell","Sell",204,ty+4,50,20,(g_pos_filter==PF_SELL)?clrDodgerBlue:clrGray,clrWhite);
   Btn("Tab_P_Refresh","刷新",m_w-80,ty+4,55,20,clrDarkGray,clrWhite);

   // 排序按钮
   int sy_row=ty+28;
   string sort_labels[4]={"默认排序","按盈亏","按手数","按品种"};
   int sw=(m_w-52)/4;
   for(int i=0;i<4;i++)
      Btn("Tab_P_Sort_"+IntegerToString(i),sort_labels[i],
          16+i*(sw+2),sy_row,sw,18,
          g_pos_sort==i?clrSteelBlue:clrDarkGray,clrWhite);

   // 列表头
   int hy=ty+52;
   int cw6=(m_w-48)/6;
   string hd[6]={"品种","方向","手数","盈亏","订单号","操作"};
   for(int i=0;i<6;i++)
      Lbl("Tab_P_Hdr_"+IntegerToString(i),hd[i],18+i*cw6,hy,cw6,14,clrDimGray,8);

   // 10行持仓
   for(int r=0;r<10;r++)
   {
      int ry=hy+16+r*30;
      Lbl("Tab_P_R"+IntegerToString(r)+"_0","--",18+0*cw6,ry,cw6,16,clrWhite,8);
      Lbl("Tab_P_R"+IntegerToString(r)+"_1","--",18+1*cw6,ry,cw6,16,clrWhite,8);
      Lbl("Tab_P_R"+IntegerToString(r)+"_2","--",18+2*cw6,ry,cw6,16,clrWhite,8);
      Lbl("Tab_P_R"+IntegerToString(r)+"_3","--",18+3*cw6,ry,cw6,16,clrWhite,8);
      Lbl("Tab_P_R"+IntegerToString(r)+"_4","--",18+4*cw6,ry,cw6,16,clrWhite,7);

      Btn("Tab_P_Mod_"+IntegerToString(r),"改",18+5*cw6,ry,22,16,clrDodgerBlue,clrWhite);
      Btn("Tab_P_Close_"+IntegerToString(r),"平",18+5*cw6+26,ry,22,16,clrRed,clrWhite);
   }
   Lbl("Tab_P_Empty","-- 无持仓 --",160,ty+240,120,16,clrDimGray,10);

   // 汇总
   int sy=ty+410;
   Lbl("Tab_P_Sum_Title","持仓汇总",16,sy,80,14,clrAqua,9);
   Lbl("Tab_P_Sum_Total","总持仓: 0  |  Buy: 0  |  Sell: 0",16,sy+18,250,12,clrLightGray,9);
   Lbl("Tab_P_Sum_PL","总盈亏: --",16,sy+36,180,12,clrLightGray,9);
}

//==================== Tab 2: 统计页 ====================
void CPanel::BuildStatsTab()
{
   int ty=118;
   Rct("Tab_S_BG",10,ty,m_w-20,460,clrBlack,clrDimGray);

   Lbl("Tab_S_Title","交易统计",16,ty+4,80,16,clrAqua,10);

   // 周期筛选
   Btn("Tab_S_P_Today","今日",100,ty+4,50,20,(g_stats_period==SP_TODAY)?clrDodgerBlue:clrGray,clrWhite);
   Btn("Tab_S_P_Week","本周",152,ty+4,50,20,(g_stats_period==SP_WEEK)?clrDodgerBlue:clrGray,clrWhite);
   Btn("Tab_S_P_Month","本月",204,ty+4,50,20,(g_stats_period==SP_MONTH)?clrDodgerBlue:clrGray,clrWhite);
   Btn("Tab_S_P_All","全部",256,ty+4,50,20,(g_stats_period==SP_ALL)?clrDodgerBlue:clrGray,clrWhite);

   // 12项统计 4x3
   int sy=ty+36;
   int scw=(m_w-40)/4;
   string slb[12]={"总交易","胜率","盈亏比","净利润","平均盈","平均亏","夏普率","回收率","期望值","最大连胜","最大连败","最大回撤"};
   string sk[12]={"Tot","WR","Ratio","Net","AW","AL","SR","RF","Exp","MCW","MCL","MDD"};
   for(int i=0;i<12;i++)
   {
      int r=i/4,c=i%4;
      Lbl("Tab_S_V_"+sk[i],"--",20+c*scw,sy+r*38,scw,18,clrWhite,11);
      Lbl("Tab_S_L_"+sk[i],slb[i],20+c*scw,sy+r*38+16,scw,14,clrLightGray,7);
   }

   // 重置统计按钮
   Btn("Tab_S_Reset","重置统计",m_w-100,ty+410,80,22,clrMaroon,clrWhite);
   Lbl("Tab_S_Hint","点击周期切换统计范围",16,ty+420,200,14,clrDimGray,8);
}

//==================== Tab 3: 设置页 ====================
void CPanel::BuildSettingsTab()
{
   int ty=118;
   Rct("Tab_Set_BG",10,ty,m_w-20,460,clrBlack,clrDimGray);
   Lbl("Tab_Set_Title","EA 设置",16,ty+4,80,16,clrAqua,10);

   // 分组1: 交易参数
   int gy=ty+28;
   Lbl("Tab_Set_G1_T","交易参数",16,gy,100,14,clrAqua,9);
   int pcw=(m_w-40)/4;
   gy+=20;
   Lbl("Tab_Set_L1","手数",16,gy,pcw,12,clrLightGray,8);
   Edt("Tab_Set_E1",DoubleToString(m_lot,2),16,gy+14,pcw-4,18);
   Lbl("Tab_Set_L2","止损点",20+pcw,gy,pcw,12,clrLightGray,8);
   Edt("Tab_Set_E2",IntegerToString(m_sl),20+pcw,gy+14,pcw-4,18);
   Lbl("Tab_Set_L3","止盈点",24+pcw*2,gy,pcw,12,clrLightGray,8);
   Edt("Tab_Set_E3",IntegerToString(m_tp),24+pcw*2,gy+14,pcw-4,18);
   Lbl("Tab_Set_L4","加仓手数",28+pcw*3,gy,pcw,12,clrLightGray,8);
   Edt("Tab_Set_E4",DoubleToString(m_add_lot,2),28+pcw*3,gy+14,pcw-4,18);

   // 分组2: 风险管理
   gy+=52;
   Lbl("Tab_Set_G2_T","风险管理",16,gy,100,14,clrAqua,9);
   gy+=20;
   Lbl("Tab_Set_RiskLbl","风险模式(点击切换)",16,gy,200,12,clrLightGray,8);
   string rm_t="";
   if(m_risk_mode==RISK_FIXED) rm_t="固定手数";
   else if(m_risk_mode==RISK_PERCENT) rm_t="余额百分比";
   else rm_t="风险比例";
   Btn("Tab_Set_RiskBtn",rm_t,16,gy+14,pcw*2,20,clrDimGray,clrWhite);

   Lbl("Tab_Set_RiskPctLbl","风险百分比%",24+pcw*2,gy,pcw,12,clrLightGray,8);
   Edt("Tab_Set_RiskPct",DoubleToString(m_risk_pct,1),24+pcw*2,gy+14,pcw-4,18);

   // 分组3: 显示设置
   gy+=60;
   Lbl("Tab_Set_G3_T","显示设置",16,gy,100,14,clrAqua,9);
   gy+=20;
   Btn("Tab_Set_Color","切换面板颜色",16,gy,120,22,clrDimGray,clrWhite);
   Btn("Tab_Set_ResetPos","重置面板位置",150,gy,120,22,clrDimGray,clrWhite);
   Btn("Tab_Set_OnTop","面板置顶",284,gy,100,22,clrDimGray,clrWhite);

   // 分组4: 其他
   gy+=50;
   Lbl("Tab_Set_G4_T","信息",16,gy,100,14,clrAqua,9);
   gy+=18;
   Lbl("Tab_Set_Ver","版本: v2.00",16,gy,200,12,clrLightGray,8);
   Lbl("Tab_Set_Magic","Magic: "+IntegerToString(InpMagicNumber),16,gy+16,200,12,clrLightGray,8);
   Lbl("Tab_Set_Sym","当前品种: "+Symbol(),16,gy+32,200,12,clrLightGray,8);

   // 保存按钮
   Btn("Tab_Set_Save","保存设置",m_w-100,ty+410,80,22,clrGreen,clrWhite);
   Lbl("Tab_Set_Hint","修改输入框后点击Tab其他区域生效",16,ty+430,280,12,clrDimGray,8);
}

//==================== 下拉菜单 ====================
void CPanel::ToggleDropdown(int tab)
{
   if(g_dropdown_open && g_dropdown_tab==tab)
   {
      HideDropdown();
      return;
   }
   ShowDropdown(tab);
}

void CPanel::CloseDropdown()
{
   if(g_dropdown_open) HideDropdown();
}

void CPanel::ShowDropdown(int tab)
{
   HideDropdown();
   g_dropdown_open=true;
   g_dropdown_tab=tab;

   int nbw=(m_w-24)/4;
   int dx=10+tab*(nbw+2);
   int dy=52;
   int dw=nbw;
   int dh=0;

   string items[5];
   int count=0;

   if(tab==0) // 交易
   {
      items[0]="快速开仓"; items[1]="加仓操作"; items[2]="全平所有";
      items[3]="平所有Buy"; items[4]="平所有Sell";
      count=5;
   }
   else if(tab==1) // 持仓
   {
      items[0]="查看全部"; items[1]="仅看Buy"; items[2]="仅看Sell";
      items[3]="刷新列表"; items[4]="";
      count=4;
   }
   else if(tab==2) // 统计
   {
      items[0]="今日统计"; items[1]="本周统计"; items[2]="本月统计";
      items[3]="全部统计"; items[4]="重置统计";
      count=5;
   }
   else if(tab==3) // 设置
   {
      items[0]="交易参数"; items[1]="风险设置"; items[2]="显示设置";
      items[3]="重置面板"; items[4]="关于EA";
      count=5;
   }

   dh=count*22+4;
   Rct("DD_BG",dx,dy,dw,dh,clrDarkSlateGray,clrAqua);
   for(int i=0;i<count;i++)
   {
      Btn("DD_Item_"+IntegerToString(i),items[i],dx+2,dy+2+i*22,dw-4,20,clrDarkSlateGray,clrWhite);
   }
   Redraw();
}

void CPanel::HideDropdown()
{
   g_dropdown_open=false;
   g_dropdown_tab=-1;
   string objs[]={"DD_BG","DD_Item_0","DD_Item_1","DD_Item_2","DD_Item_3","DD_Item_4"};
   for(int i=0;i<ArraySize(objs);i++) ObjectDelete(m_ch,m_pfx+objs[i]);
}

//==================== 风险模式下拉菜单 ====================
void CPanel::ToggleRiskDropdown(int px, int py, int pw)
{
   if(g_risk_dd_open) HideRiskDropdown();
   else ShowRiskDropdown(px, py, pw);
}

void CPanel::ShowRiskDropdown(int px, int py, int pw)
{
   HideRiskDropdown();
   g_risk_dd_open = true;
   Rct("RiskDD_BG", px, py+18, pw, 66, clrDarkSlateGray, clrAqua);
   Btn("RiskDD_0", "固定手数", px+2, py+20, pw-4, 20,
       m_risk_mode==RISK_FIXED?clrDodgerBlue:clrDarkSlateGray, clrWhite);
   Btn("RiskDD_1", "余额百分比", px+2, py+42, pw-4, 20,
       m_risk_mode==RISK_PERCENT?clrDodgerBlue:clrDarkSlateGray, clrWhite);
   Btn("RiskDD_2", "风险比例", px+2, py+64, pw-4, 20,
       m_risk_mode==RISK_RATIO?clrDodgerBlue:clrDarkSlateGray, clrWhite);
   Redraw();
}

void CPanel::HideRiskDropdown()
{
   g_risk_dd_open = false;
   string objs[]={"RiskDD_BG","RiskDD_0","RiskDD_1","RiskDD_2"};
   for(int i=0;i<ArraySize(objs);i++) ObjectDelete(m_ch,m_pfx+objs[i]);
}

void CPanel::CloseRiskDropdown()
{
   HideRiskDropdown();
}

void CPanel::SetRiskMode(ENUM_RISK_MODE mode)
{
   m_risk_mode = mode;
   HideRiskDropdown();
}

//==================== 面板颜色 ====================
void CPanel::UpdatePanelColor()
{
   color bgc = g_panel_colors[m_color_idx];
   ObjectSetInteger(m_ch, m_pfx+"BG", OBJPROP_BGCOLOR, bgc);
   Redraw();
}

void CPanel::NextPanelColor()
{
   m_color_idx = (m_color_idx + 1) % 5;
   g_panel_color_idx = m_color_idx;
   UpdatePanelColor();
}

void CPanel::ResetPosition()
{
   Destroy();
   m_x = InpPanelX;
   m_y = InpPanelY;
   Create(m_ch, m_sub, "EAP", m_x, m_y);
   // m_tr和m_st已经在OnInit中初始化，无需重复设置
   SwitchTab(g_active_tab);
   UpdateAccount();
}

void CPanel::ToggleOnTop()
{
   static bool on_top = true;
   on_top = !on_top;
   int tot=(int)ObjectsTotal(m_ch,m_sub);
   for(int i=0;i<tot;i++)
   {
      string n=ObjectName(m_ch,i,m_sub);
      if(StrStarts(n,m_pfx))
      {
         ObjectSetInteger(m_ch, n, OBJPROP_BACK, on_top?false:true);
      }
   }
   Redraw();
}

void CPanel::SaveSettings()
{
   Print("=== 设置已保存 ===");
   Print("手数: ", m_lot, " 止损: ", m_sl, " 止盈: ", m_tp);
   Print("风险模式: ", m_risk_mode, " 风险%: ", m_risk_pct);
   Print("加仓手数: ", m_add_lot);
}

double CPanel::CalcRiskLotSize()
{
   double lot = m_lot;
   if(m_risk_mode == RISK_FIXED) return lot;

   double bal = AccountInfoDouble(ACCOUNT_BALANCE);
   double ra = bal * m_risk_pct / 100.0;
   string sym = Symbol();
   double tv = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
   double ts = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   int sp = m_sl;
   if(tv <= 0 || sp <= 0) return lot;

   lot = ra / (sp * ts * tv);
   double step = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   double mn = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
   if(step <= 0) step = 0.01;
   lot = MathFloor(lot / step) * step;
   lot = MathMax(mn, MathMin(mx, lot));
   return lot;
}

//==================== 修改对话框 ====================
void CPanel::ShowModDialog(ulong ticket)
{
   m_mod_ticket=ticket;
   int dx=80, dy=200;
   Rct("Mod_BG",dx,dy,260,100,clrBlack,clrAqua);
   Lbl("Mod_T","修改 SL/TP",dx+10,dy+6,150,18,clrAqua,10);
   Lbl("Mod_LSL","新止损价:",dx+10,dy+30,60,16,clrLightGray,9);
   Edt("Mod_ESL","",dx+70,dy+28,100,20);
   Lbl("Mod_LTP","新止盈价:",dx+10,dy+54,60,16,clrLightGray,9);
   Edt("Mod_ETP","",dx+70,dy+52,100,20);
   Btn("Mod_OK","确认",dx+180,dy+28,60,22,clrGreen,clrWhite);
   Btn("Mod_CA","取消",dx+180,dy+54,60,22,clrMaroon,clrWhite);

   if(PositionSelectByTicket(ticket))
   {
      double sl=PositionGetDouble(POSITION_SL),tp=PositionGetDouble(POSITION_TP);
      string sym=PositionGetString(POSITION_SYMBOL);
      int d=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
      ObjectSetString(m_ch,m_pfx+"Mod_ESL",OBJPROP_TEXT,sl>0?DoubleToString(sl,d):"");
      ObjectSetString(m_ch,m_pfx+"Mod_ETP",OBJPROP_TEXT,tp>0?DoubleToString(tp,d):"");
   }
   Redraw();
}

void CPanel::HideModDialog()
{
   m_mod_ticket=0;
   string o[]={"Mod_BG","Mod_T","Mod_LSL","Mod_ESL","Mod_LTP","Mod_ETP","Mod_OK","Mod_CA"};
   for(int i=0;i<ArraySize(o);i++) ObjectDelete(m_ch,m_pfx+o[i]);
   Redraw();
}

double CPanel::ModSL()
{ return StringToDouble(ObjectGetString(m_ch,m_pfx+"Mod_ESL",OBJPROP_TEXT)); }
double CPanel::ModTP()
{ return StringToDouble(ObjectGetString(m_ch,m_pfx+"Mod_ETP",OBJPROP_TEXT)); }

//==================== 读取所有编辑框 ====================
void CPanel::ReadAllEdits()
{
   // 交易Tab
   string s_lot=ObjectGetString(m_ch,m_pfx+"Tab_Tr_Lot",OBJPROP_TEXT);
   string s_sl=ObjectGetString(m_ch,m_pfx+"Tab_Tr_SL",OBJPROP_TEXT);
   string s_tp=ObjectGetString(m_ch,m_pfx+"Tab_Tr_TP",OBJPROP_TEXT);
   if(StringLen(s_lot)>0) { double v=StringToDouble(s_lot); if(v>0) m_lot=v; }
   if(StringLen(s_sl)>0)  { int v=(int)StringToInteger(s_sl); if(v>=0) m_sl=v; }
   if(StringLen(s_tp)>0)  { int v=(int)StringToInteger(s_tp); if(v>=0) m_tp=v; }

   // 设置Tab
   string s4=ObjectGetString(m_ch,m_pfx+"Tab_Set_E4",OBJPROP_TEXT);
   if(StringLen(s4)>0) { double v=StringToDouble(s4); if(v>0) m_add_lot=v; }
   string s_rp=ObjectGetString(m_ch,m_pfx+"Tab_Set_RiskPct",OBJPROP_TEXT);
   if(StringLen(s_rp)>0) { double v=StringToDouble(s_rp); if(v>0) m_risk_pct=v; }

   string s1=ObjectGetString(m_ch,m_pfx+"Tab_Set_E1",OBJPROP_TEXT);
   string s2=ObjectGetString(m_ch,m_pfx+"Tab_Set_E2",OBJPROP_TEXT);
   string s3=ObjectGetString(m_ch,m_pfx+"Tab_Set_E3",OBJPROP_TEXT);
   if(StringLen(s1)>0) { double v=StringToDouble(s1); if(v>0) m_lot=v; }
   if(StringLen(s2)>0)  { int v=(int)StringToInteger(s2); if(v>=0) m_sl=v; }
   if(StringLen(s3)>0)  { int v=(int)StringToInteger(s3); if(v>=0) m_tp=v; }
}

void CPanel::CycleRiskMode()
{
   if(m_risk_mode==RISK_FIXED) m_risk_mode=RISK_PERCENT;
   else if(m_risk_mode==RISK_PERCENT) m_risk_mode=RISK_RATIO;
   else m_risk_mode=RISK_FIXED;
}

void CPanel::SetAuto(bool v)
{
   m_auto=v;
   g_auto_trading = v;
   if(ObjectFind(m_ch, m_pfx+"Bot_Auto") >= 0)
   {
      ObjectSetString(m_ch, m_pfx+"Bot_Auto", OBJPROP_TEXT, v?"自动:ON":"自动:OFF");
      ObjectSetInteger(m_ch, m_pfx+"Bot_Auto", OBJPROP_BGCOLOR, v?clrGreen:clrMaroon);
   }
}

//==================== 更新方法 ====================
void CPanel::UpdateAccount()
{
   double b=AccountInfoDouble(ACCOUNT_BALANCE);
   double e=AccountInfoDouble(ACCOUNT_EQUITY);
   double m=AccountInfoDouble(ACCOUNT_MARGIN);
   double p=AccountInfoDouble(ACCOUNT_PROFIT);
   ObjectSetString(m_ch,m_pfx+"Acc_Bal",OBJPROP_TEXT,StringFormat("%.2f",b));
   ObjectSetString(m_ch,m_pfx+"Acc_Eq",OBJPROP_TEXT,StringFormat("%.2f",e));
   ObjectSetString(m_ch,m_pfx+"Acc_Mar",OBJPROP_TEXT,StringFormat("%.2f",m));
   ObjectSetString(m_ch,m_pfx+"Acc_PL",OBJPROP_TEXT,StringFormat("%+.2f",p));
   ObjectSetInteger(m_ch,m_pfx+"Acc_PL",OBJPROP_COLOR,p>=0?clrLimeGreen:clrRed);
}

void CPanel::UpdatePL()
{
   double p=AccountInfoDouble(ACCOUNT_PROFIT);
   ObjectSetString(m_ch,m_pfx+"Acc_PL",OBJPROP_TEXT,StringFormat("%+.2f",p));
   ObjectSetInteger(m_ch,m_pfx+"Acc_PL",OBJPROP_COLOR,p>=0?clrLimeGreen:clrRed);
}

void CPanel::UpdatePositions(ENUM_POS_FILTER filter, int sort_mode)
{
   // 收集持仓数据
   ulong  tkt[128];
   string syms[128];
   int    ptypes[128];
   double vols[128];
   double pls[128];
   int count = 0;
   int buy_count = 0, sell_count = 0;
   double total_pl = 0;

   for(int i=0;i<(int)PositionsTotal()&&count<128;i++)
   {
      ulong t=PositionGetTicket(i);
      if(t<=0||!PositionSelectByTicket(t)) continue;
      int pt=(int)PositionGetInteger(POSITION_TYPE);
      if(filter==PF_BUY&&pt!=POSITION_TYPE_BUY) continue;
      if(filter==PF_SELL&&pt!=POSITION_TYPE_SELL) continue;

      tkt[count] = t;
      syms[count] = PositionGetString(POSITION_SYMBOL);
      ptypes[count] = pt;
      vols[count] = PositionGetDouble(POSITION_VOLUME);
      pls[count] = PositionGetDouble(POSITION_PROFIT);

      total_pl += pls[count];
      if(pt==POSITION_TYPE_BUY) buy_count++;
      else sell_count++;
      count++;
   }

   // 排序
   for(int i=0;i<count-1;i++)
      for(int j=i+1;j<count;j++)
      {
         bool swap = false;
         if(sort_mode == 1) // 按盈亏
            swap = pls[i] < pls[j];
         else if(sort_mode == 2) // 按手数
            swap = vols[i] < vols[j];
         else if(sort_mode == 3) // 按品种
            swap = StringCompare(syms[i], syms[j]) > 0;
         if(swap)
         {
            ulong  t1=tkt[i]; tkt[i]=tkt[j]; tkt[j]=t1;
            string s1=syms[i]; syms[i]=syms[j]; syms[j]=s1;
            int    p1=ptypes[i]; ptypes[i]=ptypes[j]; ptypes[j]=p1;
            double v1=vols[i]; vols[i]=vols[j]; vols[j]=v1;
            double pl1=pls[i]; pls[i]=pls[j]; pls[j]=pl1;
         }
      }

   // 清空显示
   for(int r=0;r<10;r++)
   {
      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+IntegerToString(r)+"_0",OBJPROP_TEXT,"");
      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+IntegerToString(r)+"_1",OBJPROP_TEXT,"");
      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+IntegerToString(r)+"_2",OBJPROP_TEXT,"");
      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+IntegerToString(r)+"_3",OBJPROP_TEXT,"");
      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+IntegerToString(r)+"_4",OBJPROP_TEXT,"");
      ObjectSetInteger(m_ch,m_pfx+"Tab_P_Mod_"+IntegerToString(r),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetInteger(m_ch,m_pfx+"Tab_P_Close_"+IntegerToString(r),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   }

   // 显示
   int display = MathMin(count, 10);
   for(int r=0;r<display;r++)
   {
      int pt = ptypes[r];
      string ts=(pt==POSITION_TYPE_BUY)?"BUY":"SELL";
      color tc=(pt==POSITION_TYPE_BUY)?clrLimeGreen:clrRed;
      color pc=pls[r]>=0?clrLimeGreen:clrRed;
      string di=IntegerToString(r);

      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+di+"_0",OBJPROP_TEXT,syms[r]);
      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+di+"_1",OBJPROP_TEXT,ts);
      ObjectSetInteger(m_ch,m_pfx+"Tab_P_R"+di+"_1",OBJPROP_COLOR,tc);
      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+di+"_2",OBJPROP_TEXT,StringFormat("%.2f",vols[r]));
      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+di+"_3",OBJPROP_TEXT,StringFormat("%+.2f",pls[r]));
      ObjectSetInteger(m_ch,m_pfx+"Tab_P_R"+di+"_3",OBJPROP_COLOR,pc);
      ObjectSetString(m_ch,m_pfx+"Tab_P_R"+di+"_4",OBJPROP_TEXT,IntegerToString(tkt[r]));

      ObjectSetInteger(m_ch,m_pfx+"Tab_P_Mod_"+di,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetString(m_ch,m_pfx+"Tab_P_Mod_"+di,OBJPROP_TOOLTIP,IntegerToString(tkt[r]));
      ObjectSetInteger(m_ch,m_pfx+"Tab_P_Close_"+di,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetString(m_ch,m_pfx+"Tab_P_Close_"+di,OBJPROP_TOOLTIP,IntegerToString(tkt[r]));
   }

   // 汇总
   ObjectSetString(m_ch,m_pfx+"Tab_P_Sum_Total",OBJPROP_TEXT,
                   "总持仓: "+IntegerToString(count)+"  |  Buy: "+IntegerToString(buy_count)+"  |  Sell: "+IntegerToString(sell_count));
   ObjectSetString(m_ch,m_pfx+"Tab_P_Sum_PL",OBJPROP_TEXT,
                   "总盈亏: "+StringFormat("%+.2f",total_pl));
   ObjectSetInteger(m_ch,m_pfx+"Tab_P_Sum_PL",OBJPROP_COLOR,total_pl>=0?clrLimeGreen:clrRed);

   // 空仓提示
   ObjectSetInteger(m_ch,m_pfx+"Tab_P_Empty",OBJPROP_TIMEFRAMES,
                    count==0?OBJ_ALL_PERIODS:OBJ_NO_PERIODS);
}

void CPanel::UpdateStats()
{
   m_st.Update(g_stats_period);
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_Tot",OBJPROP_TEXT,IntegerToString(m_st.Total()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_WR",OBJPROP_TEXT,StringFormat("%.1f%%",m_st.WinRate()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_Ratio",OBJPROP_TEXT,StringFormat("1:%.2f",m_st.ProfitRatio()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_Net",OBJPROP_TEXT,StringFormat("%+.2f",m_st.Net()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_AW",OBJPROP_TEXT,StringFormat("%.2f",m_st.AvgWin()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_AL",OBJPROP_TEXT,StringFormat("%.2f",m_st.AvgLoss()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_SR",OBJPROP_TEXT,StringFormat("%.2f",m_st.Sharpe()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_RF",OBJPROP_TEXT,StringFormat("%.2f",m_st.Recovery()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_Exp",OBJPROP_TEXT,StringFormat("%.2f",m_st.Expectancy()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_MCW",OBJPROP_TEXT,IntegerToString(m_st.MaxCW()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_MCL",OBJPROP_TEXT,IntegerToString(m_st.MaxCL()));
   ObjectSetString(m_ch,m_pfx+"Tab_S_V_MDD",OBJPROP_TEXT,StringFormat("%.2f",m_st.MaxDD()));
   ObjectSetInteger(m_ch,m_pfx+"Tab_S_V_Net",OBJPROP_COLOR,m_st.Net()>=0?clrLimeGreen:clrRed);
}

//==================== 拖拽 ====================
void CPanel::StartDrag(int x,int y)
{
   g_drag_state=true;
   g_drag_start_x=x-m_x;
   g_drag_start_y=y-m_y;
}

void CPanel::DragTo(int x,int y)
{
   if(!g_drag_state) return;
   int nx=x-g_drag_start_x, ny=y-g_drag_start_y;

   long cw=ChartGetInteger(m_ch,CHART_WIDTH_IN_PIXELS);
   long ch=ChartGetInteger(m_ch,CHART_HEIGHT_IN_PIXELS);
   int maxX=(int)cw-m_w;
   int maxY=(int)ch-m_h;
   if(maxX<0) maxX=0;
   if(maxY<0) maxY=0;
   if(nx<0) nx=0;
   if(ny<0) ny=0;
   if(nx>maxX) nx=maxX;
   if(ny>maxY) ny=maxY;

   int dx=nx-m_x, dy=ny-m_y;
   if(dx==0&&dy==0) return;

   int tot=(int)ObjectsTotal(m_ch,m_sub);
   for(int i=0;i<tot;i++)
   {
      string n=ObjectName(m_ch,i,m_sub);
      if(StrStarts(n,m_pfx))
      {
         long t=ObjectGetInteger(m_ch,n,OBJPROP_TYPE);
         if(t==OBJ_BUTTON||t==OBJ_LABEL||t==OBJ_EDIT||t==OBJ_RECTANGLE_LABEL)
         {
            int xx=(int)ObjectGetInteger(m_ch,n,OBJPROP_XDISTANCE)+dx;
            int yy=(int)ObjectGetInteger(m_ch,n,OBJPROP_YDISTANCE)+dy;
            ObjectSetInteger(m_ch,n,OBJPROP_XDISTANCE,xx);
            ObjectSetInteger(m_ch,n,OBJPROP_YDISTANCE,yy);
         }
      }
   }
   m_x=nx; m_y=ny;
   Redraw();
}

void CPanel::EndDrag()
{
   g_drag_state=false;
}

bool CPanel::IsClickOnPanel(int x,int y)
{
   int border = 3;
   return (x >= m_x && x <= m_x + m_w && y >= m_y && y <= m_y + m_h &&
           (x <= m_x + border || x >= m_x + m_w - border ||
            y <= m_y + border || y >= m_y + m_h - border));
}

//==================== 辅助创建 ====================
bool CPanel::Btn(string n,string t,int x,int y,int w,int h,color bg,color tc)
{
   string nm=m_pfx+n;
   if(!ObjectCreate(m_ch,nm,OBJ_BUTTON,m_sub,0,0)) return false;
   ObjectSetInteger(m_ch,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(m_ch,nm,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(m_ch,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(m_ch,nm,OBJPROP_YSIZE,h);
   ObjectSetInteger(m_ch,nm,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(m_ch,nm,OBJPROP_COLOR,tc);
   ObjectSetInteger(m_ch,nm,OBJPROP_BORDER_COLOR,clrDimGray);
   ObjectSetInteger(m_ch,nm,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(m_ch,nm,OBJPROP_FONTSIZE,9);
   ObjectSetInteger(m_ch,nm,OBJPROP_BACK,false);
   ObjectSetInteger(m_ch,nm,OBJPROP_SELECTABLE,false);
   ObjectSetString(m_ch,nm,OBJPROP_TEXT,t);
   return true;
}

bool CPanel::Lbl(string n,string t,int x,int y,int w,int h,color tc,int fs)
{
   string nm=m_pfx+n;
   if(!ObjectCreate(m_ch,nm,OBJ_LABEL,m_sub,0,0)) return false;
   ObjectSetInteger(m_ch,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(m_ch,nm,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(m_ch,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(m_ch,nm,OBJPROP_YSIZE,h);
   ObjectSetInteger(m_ch,nm,OBJPROP_COLOR,tc);
   ObjectSetInteger(m_ch,nm,OBJPROP_FONTSIZE,fs);
   ObjectSetInteger(m_ch,nm,OBJPROP_BACK,false);
   ObjectSetInteger(m_ch,nm,OBJPROP_SELECTABLE,false);
   ObjectSetString(m_ch,nm,OBJPROP_TEXT,t);
   ObjectSetString(m_ch,nm,OBJPROP_FONT,"Consolas");
   return true;
}

bool CPanel::Edt(string n,string t,int x,int y,int w,int h)
{
   string nm=m_pfx+n;
   if(!ObjectCreate(m_ch,nm,OBJ_EDIT,m_sub,0,0)) return false;
   ObjectSetInteger(m_ch,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(m_ch,nm,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(m_ch,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(m_ch,nm,OBJPROP_YSIZE,h);
   ObjectSetInteger(m_ch,nm,OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(m_ch,nm,OBJPROP_BGCOLOR,clrDarkGray);
   ObjectSetInteger(m_ch,nm,OBJPROP_BORDER_COLOR,clrGray);
   ObjectSetInteger(m_ch,nm,OBJPROP_FONTSIZE,9);
   ObjectSetInteger(m_ch,nm,OBJPROP_BACK,false);
   ObjectSetInteger(m_ch,nm,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(m_ch,nm,OBJPROP_READONLY,false);
   ObjectSetString(m_ch,nm,OBJPROP_TEXT,t);
   ObjectSetString(m_ch,nm,OBJPROP_FONT,"Consolas");
   ObjectSetInteger(m_ch,nm,OBJPROP_ALIGN,ALIGN_CENTER);
   return true;
}

bool CPanel::Rct(string n,int x,int y,int w,int h,color bg,color bc)
{
   string nm=m_pfx+n;
   if(!ObjectCreate(m_ch,nm,OBJ_RECTANGLE_LABEL,m_sub,0,0)) return false;
   ObjectSetInteger(m_ch,nm,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(m_ch,nm,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(m_ch,nm,OBJPROP_XSIZE,w);
   ObjectSetInteger(m_ch,nm,OBJPROP_YSIZE,h);
   ObjectSetInteger(m_ch,nm,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(m_ch,nm,OBJPROP_COLOR,bc);
   ObjectSetInteger(m_ch,nm,OBJPROP_BORDER_COLOR,bc);
   ObjectSetInteger(m_ch,nm,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(m_ch,nm,OBJPROP_BACK,false);
   ObjectSetInteger(m_ch,nm,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(m_ch,nm,OBJPROP_FILL,true);
   return true;
}

//+------------------------------------------------------------------+
//| 全局实例 & 变量                                                    |
//+------------------------------------------------------------------+
CTrading    trading;
CStatistics stats;
CPanel      panel;
long        g_ch = 0;
int         g_tick_count = 0;
bool        g_modal_open = false;

//+------------------------------------------------------------------+
//| OnInit                                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   g_ch = ChartID();
   trading.Init(InpMagicNumber, InpSlippage);
   stats.Init(InpMagicNumber);

   panel.Create(g_ch, 0, "EAP", InpPanelX, InpPanelY);
   panel.SetTr(InpMagicNumber, InpSlippage);
   panel.SetSt(InpMagicNumber);
   panel.SetLot(InpLot);
   panel.SetSL(InpStopLoss);
   panel.SetTP(InpTakeProfit);
   panel.SetRisk(InpRiskMode);
   panel.SetAddLot(InpAddLot);
   panel.SetRPct(InpRiskPercent);
   panel.SetAuto(g_auto_trading);

   panel.UpdateAccount();
   panel.UpdateStats();

   ChartSetInteger(g_ch, CHART_EVENT_MOUSE_MOVE, true);

   Print("EA Trader v2.0 启动成功");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnDeinit                                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   panel.Destroy();
   Comment("");
   ChartSetInteger(g_ch, CHART_EVENT_MOUSE_MOVE, false);
   Print("EA Trader 已卸载");
}

//+------------------------------------------------------------------+
//| OnTick                                                            |
//+------------------------------------------------------------------+
void OnTick()
{
   g_tick_count++;

   if(InpTimeFilter && !IsInTradingSession())
   {
      panel.UpdateAccount();
      return;
   }

   if(g_tick_count % 10 == 0)
   {
      panel.UpdateAccount();
      if(g_active_tab == 1) panel.UpdatePositions(g_pos_filter, g_pos_sort);
   }
   if(g_tick_count % 5 == 0)
      panel.UpdatePL();
   if(g_tick_count >= 100)
   {
      if(g_active_tab == 2) panel.UpdateStats();
      g_tick_count = 0;
   }

   if(InpTrailingStop > 0 && g_tick_count % 30 == 0)
   {
      trading.TrailingStop(InpTrailingStop, InpTrailingStep);
   }
}

//+------------------------------------------------------------------+
//| 时间过滤检查                                                       |
//+------------------------------------------------------------------+
bool IsInTradingSession()
{
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

//+------------------------------------------------------------------+
//| 计算风险手数                                                       |
//+------------------------------------------------------------------+
double CalcRiskLot()
{
   double lot = panel.GetLot();
   ENUM_RISK_MODE rm = panel.GetRisk();
   if(rm == RISK_FIXED) return lot;

   double bal = AccountInfoDouble(ACCOUNT_BALANCE);
   double ra = bal * panel.GetRPct() / 100.0;
   string sym = Symbol();
   double tv = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
   double ts = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   int sp = panel.GetSL();
   if(tv <= 0 || sp <= 0) return lot;

   lot = ra / (sp * ts * tv);
   double step = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   double mn = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
   lot = MathFloor(lot / step) * step;
   lot = MathMax(mn, MathMin(mx, lot));
   return lot;
}

//+------------------------------------------------------------------+
//| OnChartEvent                                                      |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sp)
{
   int x = (int)lparam;
   int y = (int)dparam;

   // --- 鼠标移动: 拖拽移动 ---
   if(id == CHARTEVENT_MOUSE_MOVE)
   {
      if(g_drag_state)
         panel.DragTo(x, y);
      return;
   }

   // --- 图表点击: 开始/结束拖拽（参考DraggablePanel_MT5.mq5模式） ---
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
            // 开始拖拽：边框变红色，增加边框宽度
            ObjectSetInteger(g_ch, "EAP_BG", OBJPROP_COLOR, clrRed);
            ObjectSetInteger(g_ch, "EAP_BG", OBJPROP_WIDTH, 2);
            ChartRedraw(g_ch);
         }
      }
      else
      {
         // 已在拖拽中 → 结束拖拽
         g_drag_state = false;
         g_mouse_down = false;
         // 结束拖拽：恢复原边框颜色和宽度
         ObjectSetInteger(g_ch, "EAP_BG", OBJPROP_COLOR, clrDimGray);
         ObjectSetInteger(g_ch, "EAP_BG", OBJPROP_WIDTH, 1);
         ChartRedraw(g_ch);
      }
      return;
   }

   // --- 编辑框输入完成: 保存数值 ---
   if(id == CHARTEVENT_OBJECT_ENDEDIT)
   {
      if(StrStarts(sp, "EAP_"))
      {
         panel.ReadAllEdits();
         ChartRedraw(g_ch);
      }
      return;
   }

   if(id != CHARTEVENT_OBJECT_CLICK) return;

   // 正在拖拽时，忽略所有对象点击（让CHARTEVENT_CLICK处理结束）
   if(g_drag_state) return;

   // 点击非面板控件则关闭所有弹窗
   if(!StrStarts(sp, "EAP_"))
   {
      if(g_dropdown_open) panel.CloseDropdown();
      if(g_risk_dd_open) panel.CloseRiskDropdown();
      return;
   }

   // --- 底部自动交易开关 ---
   if(sp == "EAP_Bot_Auto")
   {
      bool na = !panel.IsAuto();
      panel.SetAuto(na);
      ChartRedraw(g_ch);
      return;
   }

   // 关闭风险下拉如果点击其他地方
   bool clicked_on_riskdd = StrStarts(sp, "EAP_RiskDD_");
   bool clicked_on_riskbtn = (sp == "EAP_Tab_Tr_RiskBtn" || sp == "EAP_Tab_Set_RiskBtn");
   if(!clicked_on_riskdd && !clicked_on_riskbtn && g_risk_dd_open)
      panel.CloseRiskDropdown();

   // 关闭导航下拉如果点击其他地方
   bool clicked_on_dd = StrStarts(sp, "EAP_DD_");
   bool clicked_on_nav = StrStarts(sp, "EAP_Nav_");
   if(!clicked_on_dd && !clicked_on_nav && g_dropdown_open)
      panel.CloseDropdown();

   // --- 导航Tab点击: 显示下拉菜单 ---
   for(int i=0;i<4;i++)
   {
      if(sp == "EAP_Nav_" + IntegerToString(i))
      {
         panel.ReadAllEdits();
         panel.ToggleDropdown(i);
         ChartRedraw(g_ch);
         return;
      }
   }

   // --- 导航下拉菜单项 ---
   if(StrStarts(sp, "EAP_DD_Item_"))
   {
      string idx_str = StringSubstr(sp, 12);
      int idx = (int)StringToInteger(idx_str);
      int tab = g_dropdown_tab;
      panel.CloseDropdown();

      if(tab == 0) // 交易
      {
         if(idx == 0) { g_active_tab=0; panel.SwitchTab(0); }
         else if(idx == 1)
         {
            if(!g_auto_trading) { Print("自动交易已关闭"); return; }
            int bc=trading.Count(POSITION_TYPE_BUY), sc=trading.Count(POSITION_TYPE_SELL);
            if(bc>0) trading.AddToPosition(POSITION_TYPE_BUY, panel.GetAddLot());
            else if(sc>0) trading.AddToPosition(POSITION_TYPE_SELL, panel.GetAddLot());
         }
         else if(idx == 2) { if(g_auto_trading) trading.CloseAll(); }
         else if(idx == 3) { if(g_auto_trading) trading.CloseByType(POSITION_TYPE_BUY); }
         else if(idx == 4) { if(g_auto_trading) trading.CloseByType(POSITION_TYPE_SELL); }
      }
      else if(tab == 1) // 持仓
      {
         if(idx==0) g_pos_filter=PF_ALL;
         else if(idx==1) g_pos_filter=PF_BUY;
         else if(idx==2) g_pos_filter=PF_SELL;
         g_active_tab=1;
         panel.SwitchTab(1);
         panel.UpdatePositions(g_pos_filter, g_pos_sort);
      }
      else if(tab == 2) // 统计
      {
         if(idx==0) g_stats_period=SP_TODAY;
         else if(idx==1) g_stats_period=SP_WEEK;
         else if(idx==2) g_stats_period=SP_MONTH;
         else if(idx==3) g_stats_period=SP_ALL;
         else if(idx==4) stats.ResetAll();
         g_active_tab=2;
         panel.SwitchTab(2);
         panel.UpdateStats();
      }
      else if(tab == 3) // 设置
      {
         if(idx==0) { g_active_tab=3; panel.SwitchTab(3); }
         else if(idx==1) { g_active_tab=3; panel.SwitchTab(3); }
         else if(idx==2) { g_active_tab=3; panel.SwitchTab(3); }
         else if(idx==3) { panel.ResetPosition(); }
         else if(idx==4) { g_active_tab=3; panel.SwitchTab(3); }
      }
      ChartRedraw(g_ch);
      return;
   }

   // --- 风险模式下拉选项 ---
   if(StrStarts(sp, "EAP_RiskDD_"))
   {
      ENUM_RISK_MODE rm = RISK_FIXED;
      if(sp == "EAP_RiskDD_0") rm = RISK_FIXED;
      else if(sp == "EAP_RiskDD_1") rm = RISK_PERCENT;
      else if(sp == "EAP_RiskDD_2") rm = RISK_RATIO;
      panel.SetRiskMode(rm);
      panel.ReadAllEdits();
      if(g_active_tab == 0) { panel.SwitchTab(0); }
      else if(g_active_tab == 3) { panel.SwitchTab(3); }
      ChartRedraw(g_ch);
      return;
   }

   // --- 模态对话框优先处理 ---
   if(g_modal_open)
   {
      if(sp == "EAP_Mod_OK")
      {
         ulong t = panel.ModTicket();
         if(t > 0 && g_auto_trading)
         {
            trading.Modify(t, panel.ModSL(), panel.ModTP());
            panel.HideModDialog();
            g_modal_open = false;
            if(g_active_tab == 1) panel.UpdatePositions(g_pos_filter, g_pos_sort);
            ChartRedraw(g_ch);
         }
         return;
      }
      if(sp == "EAP_Mod_CA")
      {
         panel.HideModDialog();
         g_modal_open = false;
         ChartRedraw(g_ch);
         return;
      }
      return;
   }

   // --- Tab内按钮 ---

   // 交易Tab
   if(g_active_tab == 0)
   {
      if(sp == "EAP_Tab_Tr_Buy")
      {
         if(!g_auto_trading) { Print("自动交易已关闭"); return; }
         panel.ReadAllEdits();
         double lot = panel.CalcRiskLotSize();
         trading.OpenOrder(ORDER_TYPE_BUY, lot, panel.GetSL(), panel.GetTP());
         ChartRedraw(g_ch);
         return;
      }
      if(sp == "EAP_Tab_Tr_Sell")
      {
         if(!g_auto_trading) { Print("自动交易已关闭"); return; }
         panel.ReadAllEdits();
         double lot = panel.CalcRiskLotSize();
         trading.OpenOrder(ORDER_TYPE_SELL, lot, panel.GetSL(), panel.GetTP());
         ChartRedraw(g_ch);
         return;
      }
      if(sp == "EAP_Tab_Tr_Add")
      {
         if(!g_auto_trading) { Print("自动交易已关闭"); return; }
         panel.ReadAllEdits();
         int bc=trading.Count(POSITION_TYPE_BUY), sc=trading.Count(POSITION_TYPE_SELL);
         if(bc>0) trading.AddToPosition(POSITION_TYPE_BUY, panel.GetAddLot());
         else if(sc>0) trading.AddToPosition(POSITION_TYPE_SELL, panel.GetAddLot());
         ChartRedraw(g_ch);
         return;
      }
      if(sp == "EAP_Tab_Tr_CA") { if(g_auto_trading) trading.CloseAll(); ChartRedraw(g_ch); return; }
      if(sp == "EAP_Tab_Tr_CB") { if(g_auto_trading) trading.CloseByType(POSITION_TYPE_BUY); ChartRedraw(g_ch); return; }
      if(sp == "EAP_Tab_Tr_CS") { if(g_auto_trading) trading.CloseByType(POSITION_TYPE_SELL); ChartRedraw(g_ch); return; }
      if(sp == "EAP_Tab_Tr_RiskBtn")
      {
         panel.ReadAllEdits();
         int pcw=(420-40)/4;
         int px=28+pcw*3, py=118+82+16+12;
         panel.ToggleRiskDropdown(px, py, pcw-4);
         ChartRedraw(g_ch);
         return;
      }
      // 编辑框
      if(StrStarts(sp,"EAP_Tab_Tr_"))
      { panel.ReadAllEdits(); return; }
   }

   // 持仓Tab
   if(g_active_tab == 1)
   {
      if(sp == "EAP_Tab_P_F_All")  { g_pos_filter=PF_ALL;  panel.SwitchTab(1); panel.UpdatePositions(PF_ALL,g_pos_sort); ChartRedraw(g_ch); return; }
      if(sp == "EAP_Tab_P_F_Buy")  { g_pos_filter=PF_BUY;  panel.SwitchTab(1); panel.UpdatePositions(PF_BUY,g_pos_sort); ChartRedraw(g_ch); return; }
      if(sp == "EAP_Tab_P_F_Sell") { g_pos_filter=PF_SELL; panel.SwitchTab(1); panel.UpdatePositions(PF_SELL,g_pos_sort); ChartRedraw(g_ch); return; }
      if(sp == "EAP_Tab_P_Refresh"){ panel.UpdatePositions(g_pos_filter,g_pos_sort); ChartRedraw(g_ch); return; }

      // 排序按钮
      for(int s=0;s<4;s++)
      {
         if(sp == "EAP_Tab_P_Sort_" + IntegerToString(s))
         {
            g_pos_sort = s;
            panel.SwitchTab(1);
            panel.UpdatePositions(g_pos_filter, g_pos_sort);
            ChartRedraw(g_ch);
            return;
         }
      }

      // 改单按钮
      for(int r=0;r<10;r++)
      {
         if(sp == "EAP_Tab_P_Mod_" + IntegerToString(r))
         {
            string ts = ObjectGetString(g_ch, sp, OBJPROP_TOOLTIP);
            ulong tkt = (ulong)StringToInteger(ts);
            if(tkt > 0) { panel.ShowModDialog(tkt); g_modal_open = true; return; }
         }
      }
      // 平仓按钮
      for(int r=0;r<10;r++)
      {
         if(sp == "EAP_Tab_P_Close_" + IntegerToString(r))
         {
            if(!g_auto_trading) { Print("自动交易已关闭"); return; }
            string ts = ObjectGetString(g_ch, sp, OBJPROP_TOOLTIP);
            ulong tkt = (ulong)StringToInteger(ts);
            if(tkt > 0)
            {
               trading.ClosePosition(tkt);
               panel.UpdatePositions(g_pos_filter, g_pos_sort);
               if(g_active_tab==2) panel.UpdateStats();
               ChartRedraw(g_ch);
            }
            return;
         }
      }
   }

   // 统计Tab
   if(g_active_tab == 2)
   {
      if(sp=="EAP_Tab_S_P_Today"){g_stats_period=SP_TODAY;panel.SwitchTab(2);panel.UpdateStats();ChartRedraw(g_ch);return;}
      if(sp=="EAP_Tab_S_P_Week") {g_stats_period=SP_WEEK; panel.SwitchTab(2);panel.UpdateStats();ChartRedraw(g_ch);return;}
      if(sp=="EAP_Tab_S_P_Month"){g_stats_period=SP_MONTH;panel.SwitchTab(2);panel.UpdateStats();ChartRedraw(g_ch);return;}
      if(sp=="EAP_Tab_S_P_All")  {g_stats_period=SP_ALL;  panel.SwitchTab(2);panel.UpdateStats();ChartRedraw(g_ch);return;}
      if(sp=="EAP_Tab_S_Reset")  {stats.ResetAll();panel.UpdateStats();ChartRedraw(g_ch);return;}
   }

   // 设置Tab
   if(g_active_tab == 3)
   {
      if(sp=="EAP_Tab_Set_RiskBtn")
      {
         panel.ReadAllEdits();
         int pcw=(420-40)/4;
         panel.ToggleRiskDropdown(16, 118+28+20+14, pcw*2);
         ChartRedraw(g_ch);
         return;
      }
      if(sp=="EAP_Tab_Set_Save")
      {
         panel.ReadAllEdits();
         panel.SaveSettings();
         ChartRedraw(g_ch);
         return;
      }
      if(sp=="EAP_Tab_Set_Color")
      {
         panel.NextPanelColor();
         return;
      }
      if(sp=="EAP_Tab_Set_ResetPos")
      {
         panel.ResetPosition();
         return;
      }
      if(sp=="EAP_Tab_Set_OnTop")
      {
         panel.ToggleOnTop();
         return;
      }
      // 编辑框
      if(StrStarts(sp,"EAP_Tab_Set_"))
      { panel.ReadAllEdits(); return; }
   }
}
//+------------------------------------------------------------------+
