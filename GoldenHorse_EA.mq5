//+------------------------------------------------------------------+
//|                                          GoldenHorse_EA.mq5       |
//|                                    金戈铁马X3D 多核对冲 战神旗舰版 2.10 |
//+------------------------------------------------------------------+
#property copyright "GoldenHorse EA"
#property link      ""
#property version   "2.10"
#property strict

enum ENUM_TRADE_MODE { 保守模式, 稳健模式, 激进模式, 自定义模式 };
enum ENUM_ADD_TYPE { 马丁倍率, 递增手数, 自定义列表, 斐波那契 };
enum ENUM_DECIMAL_PLACE { 两位小数=2, 三位小数=3 };
enum ENUM_CLOSE_TYPE { 盈利平仓, 信号平仓, 对冲平仓, 移动止盈, 全部平仓 };
enum ENUM_HEDGE_STATUS { 无对冲, 等待多单, 等待空单, 对冲激活 };
enum ENUM_ADD_DIRECTION { 双向加仓, 顺势加仓, 逆势加仓 };
enum ENUM_TRAILING_TYPE { 固定间距, ATR动态, 阶梯式 };
enum ENUM_PROFIT_CLOSE_MODE { 单目标止盈, 阶梯止盈, 回撤止盈 };

input group "=== 基础设置 ==="
input ENUM_TRADE_MODE InpTradeMode=稳健模式;        // 交易模式
input double InpInitialLot=0.01;                  // 初始手数
input ENUM_DECIMAL_PLACE InpDecimalPlace=两位小数; // 手数小数位
input int InpMagicNumber=888888;                  // 魔术号
input int InpSlippage=30;                        // 滑点（点）
input bool InpAllowBothDir=true;                  // 允许多空双向

input group "=== 自定义开仓设置 ==="
input int InpOpenPeriod=14;                       // 均线周期
input double InpSignalStrength=0.618;             // 信号强度阈值
input int InpConfirmBars=2;                       // K线确认根数
input ENUM_TIMEFRAMES InpOpenTimeFrame=PERIOD_M5; // 开仓周期
input int InpOpenIndicator=60;                    // RSI周期
input double InpOpenCoeff=2.0;                    // 开仓系数
input bool InpUseAdaptive=true;                   // 自适应布林带
input int InpBBM1Period=20;                       // M1布林带周期
input double InpBBM1Dev=1.5;                      // M1布林带标准差
input int InpBBM5Period=20;                       // M5布林带周期
input double InpBBM5Dev=2.0;                      // M5布林带标准差
input double InpBBProximity=0.25;                 // 布林带接近度
input int InpOpenPeriod2=3;                       // 辅助开仓周期

input group "=== 自定义加仓设置 ==="
input int InpAddDelay=0;                          // 加仓延迟（秒）
input double InpAddCoeff=1.0;                     // 加仓系数
input ENUM_ADD_TYPE InpAddType=马丁倍率;           // 加仓方式
input ENUM_ADD_DIRECTION InpAddDirection=逆势加仓; // 加仓方向
input int InpAddSpacing=150;                      // 加仓间距（点）
input double InpAddSpacingMult=1.0;               // 间距递增倍数
input bool InpUseSpacingATR=true;                 // ATR动态间距
input double InpATRMult=0.8;                      // ATR倍数 (间距=ATR*0.8)
input int InpATRPeriod=14;                        // ATR周期
input double InpMartinMult=1.4;                   // 马丁倍率
input double InpIncreaseLot=0.01;                 // 递增手数
input string InpCustomLots="0.01,0.02,0.03,0.05,0.08,0.13,0.21,0.34,0.55,0.89";
input double InpMaxAddLot=0.5;                    // 单笔最大加仓
input double InpMaxTotalLot=2.0;                  // 总手数上限
input int InpMaxAddCount=5;                       // 最大加仓层数 (马丁层级)
input bool InpUseAddFilter=true;                  // 加仓过滤
input int InpAddFilterBars=1;                     // 过滤K线数
input bool InpUseAddSLReset=true;                 // 加仓重置止损
input bool InpUseAddTPReset=false;                // 加仓重置止盈

input group "=== 自定义平仓设置 ==="
input ENUM_PROFIT_CLOSE_MODE InpProfitCloseMode=回撤止盈;
input double InpProfitOptCoeff=1.0;
input int InpCloseFilter=1;
input double InpProfitPer001Lot=1.2;
input string InpMultiTargets="0.3,0.6,1.0";
input string InpMultiRatios="0.5,0.3,0.2";
input double InpDrawdownTrigger=1.0;
input double InpDrawdownPercent=35.0;
input bool InpUseFloatProtect=true;
input double InpFloatProtectVal=300.0;
input bool InpUseSignalClose=true;
input int InpSignalCloseBar=2;
input bool InpUsePartialClose=true;
input double InpPartialRatio=0.5;
input bool InpUseTimeClose=true;
input int InpMaxHoldBars=40;
input int InpCloseHour=23;
input int InpCloseMinute=55;

input group "=== 均价移动止盈设置 ==="
input bool InpUseTrailing=true;
input ENUM_TRAILING_TYPE InpTrailingType=ATR动态;
input int InpTrailActive=100;
input int InpTrailLock=50;
input int InpTrailStep=20;
input double InpTrailATRMult=1.0;
input bool InpUseBreakeven=true;
input int InpBreakevenDist=100;
input bool InpUseStepProfit=true;
input string InpStepLevels="80,150,250,400,600";
input string InpStepLocks="40,75,125,200,300";

input group "=== 尾单对冲首单移动止盈 ==="
input bool InpUsePairHedge=true;
input double InpHedgeStartPL=1.0;
input double InpHedgePullback=0.3;
input bool InpHedgeBlockAdd=true;
input int InpHedgeMinPos=1;
input bool InpUseNetClose=true;
input double InpNetClosePL=3.0;

input group "=== 托管模式设置 ==="
input bool InpShowPanel=true;
input int InpPanelX=10;
input int InpPanelY=30;
input int InpPanelWidth=440;
input int InpPanelHeight=580;

CTrade g_trade;
CSignalSystem g_signal;
CTradeEngine g_engine;
CRiskControl g_risk;
CPairHedge g_hedge;
CInfoPanel g_panel;

int g_buy_add_count=0, g_sell_add_count=0;
double g_buy_peak_pl=0, g_sell_peak_pl=0;
int g_win_trades=0, g_lose_trades=0;
double m_fib_ratios[]={1.0,1.0,2.0,3.0,5.0,8.0,13.0,21.0,34.0,55.0};

//+------------------------------------------------------------------+
int OnInit()
{
   g_signal.Init(_Symbol,PERIOD_CURRENT);
   g_engine.Init(InpMagicNumber,InpSlippage);
   g_risk.Init();
   g_hedge.Init();
   g_panel.Init(InpPanelX,InpPanelY,InpPanelWidth,InpPanelHeight);
   ChartSetInteger(0,CHART_EVENT_OBJECT_CREATE,true);
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,true);
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   g_panel.Destroy();
}

void OnTick()
{
   if(!InpShowPanel) return;
   CheckTimeFilter();
   CheckPositionManagement();
   g_panel.Update();
}

bool CheckTimeFilter()
{
   if(!InpUseTradeTime) return true;
   datetime now=TimeCurrent();
   MqlDateTime dt;
   TimeToStruct(now,dt);
   int hh=dt.hour, mm=dt.min;
   int start_hh=StringToInteger(StringSubstr(InpTradeStartTime,0,2));
   int start_mm=StringToInteger(StringSubstr(InpTradeStartTime,3,2));
   int end_hh=StringToInteger(StringSubstr(InpTradeEndTime,0,2));
   int end_mm=StringToInteger(StringSubstr(InpTradeEndTime,3,2));
   int now_min=hh*60+mm, start_min=start_hh*60+start_mm, end_min=end_hh*60+end_mm;
   return (now_min>=start_min && now_min<=end_min);
}

void CheckPositionManagement()
{
   if(!CheckTimeFilter()) return;
   CheckTrailingStop(_Symbol);
   CheckBreakeven(_Symbol);
   CheckAddPosition(_Symbol);
   CheckClosePosition(_Symbol);
   CheckPairHedge(_Symbol);
}

class CSignalSystem
{
private:
   string m_symbol; ENUM_TIMEFRAMES m_tf;
public:
   void Init(string symbol,ENUM_TIMEFRAMES tf){ m_symbol=symbol; m_tf=tf; }
   int GetSignal()
   {
      double rsi=iRSI(m_symbol,m_tf,InpOpenIndicator,PRICE_CLOSE,0);
      double bb_upper=iBands(m_symbol,m_tf,InpBBM1Period,2.0,0,PRICE_CLOSE,MODE_UPPER,0);
      double bb_lower=iBands(m_symbol,m_tf,InpBBM1Period,2.0,0,PRICE_CLOSE,MODE_LOWER,0);
      double bb_middle=iBands(m_symbol,m_tf,InpBBM1Period,2.0,0,PRICE_CLOSE,MODE_MAIN,0);
      double close=SymbolInfoDouble(m_symbol,SYMBOL_BID);
      double bb_range=bb_upper-bb_lower;
      double dist_from_lower=close-bb_lower;
      double dist_from_upper=bb_upper-close;
      if(rsi<30 && dist_from_lower/bb_range<InpBBProximity) return 1;
      if(rsi>70 && dist_from_upper/bb_range<InpBBProximity) return -1;
      return 0;
   }
};

class CTradeEngine
{
private: int m_magic,m_slippage;
public:
   void Init(int magic,int slippage){ m_magic=magic; m_slippage=slippage; }
   bool OpenPosition(string symbol,int type,double lot,double sl,double tp)
   {
      CTrade trade;
      trade.SetMarginMode(TRADE_MARGIN_MODE_RETAIL_HEDGING);
      trade.SetExpertMagicNumber(m_magic);
      trade.SetSlippage(m_slippage);
      return (type==POSITION_TYPE_BUY)?trade.Buy(lot,symbol,SymbolInfoDouble(symbol,SYMBOL_ASK),sl,tp):trade.Sell(lot,symbol,SymbolInfoDouble(symbol,SYMBOL_BID),sl,tp);
   }
   bool ClosePosition(long ticket){ CTrade trade; return trade.PositionClose(ticket); }
   bool CloseAllPositions(string symbol,int type)
   {
      for(int i=0;i<(int)PositionsTotal();i++){ ulong t=PositionGetTicket(i); if(PositionGetSymbol(t)==symbol && PositionGetType(t)==type) ClosePosition(t); }
      return true;
   }
   bool ClosePartial(string symbol,int type,double ratio)
   {
      for(int i=0;i<(int)PositionsTotal();i++){ ulong t=PositionGetTicket(i); if(PositionGetSymbol(t)==symbol && PositionGetType(t)==type){ CTrade trade; trade.PositionClosePartial(t,PositionGetDouble(t,POSITION_VOLUME)*ratio); } }
      return true;
   }
   int GetPositionCount(string symbol,int type)
   {
      int cnt=0; for(int i=0;i<(int)PositionsTotal();i++){ ulong t=PositionGetTicket(i); if(PositionGetSymbol(t)==symbol && PositionGetType(t)==type) cnt++; }
      return cnt;
   }
   double GetTotalLot(string symbol,int type)
   {
      double lot=0; for(int i=0;i<(int)PositionsTotal();i++){ ulong t=PositionGetTicket(i); if(PositionGetSymbol(t)==symbol && PositionGetType(t)==type) lot+=PositionGetDouble(t,POSITION_VOLUME); }
      return lot;
   }
   double GetTotalProfit(string symbol,int type)
   {
      double pl=0; for(int i=0;i<(int)PositionsTotal();i++){ ulong t=PositionGetTicket(i); if(PositionGetSymbol(t)==symbol && PositionGetType(t)==type) pl+=PositionGetDouble(t,POSITION_PROFIT); }
      return pl;
   }
   double GetAvgPrice(string symbol,int type)
   {
      double total_lot=0,total_price=0;
      for(int i=0;i<(int)PositionsTotal();i++){ ulong t=PositionGetTicket(i); if(PositionGetSymbol(t)==symbol && PositionGetType(t)==type){ double lot=PositionGetDouble(t,POSITION_VOLUME); double price=PositionGetDouble(t,POSITION_PRICE_OPEN); total_lot+=lot; total_price+=lot*price; } }
      return (total_lot>0)?total_price/total_lot:0;
   }
};

class CRiskControl{ public: void Init(){} void ResetTrail(){} };
class CPairHedge{ public: void Init(){} };

class CInfoPanel
{
private:
   int m_x,m_y,m_w,m_h,m_ch,m_sub;
   string m_pfx; bool m_dragging;
   int m_dragStartX,m_dragStartY;
public:
   void Init(int x,int y,int w,int h){ m_x=x; m_y=y; m_w=w; m_h=h; m_ch=0; m_sub=0; m_pfx="GH_Panel_"; m_dragging=false; BuildPanel(); }
   void Destroy()
   {
      for(int i=ObjectsTotal(m_ch)-1;i>=0;i--){ string n=ObjectName(m_ch,i,m_sub); if(StrStarts(n,m_pfx)) ObjectDelete(m_ch,n); }
   }
   bool Rect(string n,int x,int y,int w,int h,color bg,color bc)
   {
      string nm=m_pfx+n;
      if(!ObjectCreate(m_ch,nm,OBJ_RECTANGLE_LABEL,m_sub,0,0)) return false;
      ObjectSetInteger(m_ch,nm,OBJPROP_XDISTANCE,m_x+x);
      ObjectSetInteger(m_ch,nm,OBJPROP_YDISTANCE,m_y+y);
      ObjectSetInteger(m_ch,nm,OBJPROP_XSIZE,w);
      ObjectSetInteger(m_ch,nm,OBJPROP_YSIZE,h);
      ObjectSetInteger(m_ch,nm,OBJPROP_BGCOLOR,bg);
      ObjectSetInteger(m_ch,nm,OBJPROP_COLOR,bc);
      ObjectSetInteger(m_ch,nm,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(m_ch,nm,OBJPROP_WIDTH,1);
      ObjectSetInteger(m_ch,nm,OBJPROP_BACK,false);
      ObjectSetInteger(m_ch,nm,OBJPROP_SELECTABLE,false);
      return true;
   }
   bool Label(string n,string t,int x,int y,int w,int h,color c,int fs)
   {
      string nm=m_pfx+n;
      if(!ObjectCreate(m_ch,nm,OBJ_LABEL,m_sub,0,0)) return false;
      ObjectSetInteger(m_ch,nm,OBJPROP_XDISTANCE,m_x+x);
      ObjectSetInteger(m_ch,nm,OBJPROP_YDISTANCE,m_y+y);
      ObjectSetInteger(m_ch,nm,OBJPROP_XSIZE,w);
      ObjectSetInteger(m_ch,nm,OBJPROP_YSIZE,h);
      ObjectSetInteger(m_ch,nm,OBJPROP_COLOR,c);
      ObjectSetInteger(m_ch,nm,OBJPROP_FONTSIZE,fs);
      ObjectSetInteger(m_ch,nm,OBJPROP_BACK,false);
      ObjectSetInteger(m_ch,nm,OBJPROP_SELECTABLE,false);
      ObjectSetString(m_ch,nm,OBJPROP_TEXT,t);
      return true;
   }
   void SetText(string name,string text){ ObjectSetString(m_ch,m_pfx+name,OBJPROP_TEXT,text); }
   void SetColor(string name,color c){ ObjectSetInteger(m_ch,m_pfx+name,OBJPROP_COLOR,c); }
   void BuildPanel()
   {
      Rect("BG",0,0,m_w,m_h,C'25,25,30',C'80,60,30');
      int y=0;
      Rect("TitleBG",0,y,m_w,72,C'35,30,25',C'100,80,40');
      Label("Title1","金戈铁马 多核对冲引擎",12,y+6,260,16,C'200,180,120',11);
      Label("Title2","GOLDEN CAVALRY · MULTI-CORE HEDGE v2.1",12,y+26,320,10,C'150,130,80',6);
      Label("Title3","金戈所向·多空俱亡 | 铁马奔腾·对冲千军",12,y+40,320,10,C'180,160,100',7);
      Label("Symbol",_Symbol,12,y+56,70,10,clrSilver,7);
      Label("Magic","Magic "+IntegerToString(InpMagicNumber),85,y+56,90,10,clrSilver,7);
      Label("Period","M"+IntegerToString(Period()/60),180,y+56,40,10,clrSilver,7);
      Label("Status","战况: 允许交易",225,y+56,180,10,clrLimeGreen,7);
      y+=72;
      Rect("ProfitBG",8,y,m_w-16,50,C'20,25,20',C'60,70,50');
      Label("TodayLbl","今日斩获",14,y+5,50,10,C'180,160,100',7);
      Label("TodayVal","0.00",14,y+18,90,16,clrLimeGreen,11);
      Label("YestLbl","昨日斩获",110,y+5,50,10,C'180,160,100',7);
      Label("YestVal","0.00",110,y+18,90,16,clrLimeGreen,11);
      Label("TotalLbl","累计斩获",210,y+5,50,10,C'180,160,100',7);
      Label("TotalVal","0.00",210,y+18,180,16,clrLimeGreen,11);
      y+=50;
      Rect("AcctBG",8,y,m_w-16,78,C'20,20,25',C'50,50,60');
      Label("AcctTitle","账户概览",14,y+4,55,10,C'150,180,200',8);
      Label("BalLbl","余额",14,y+18,30,9,clrSilver,7);
      Label("BalVal","--",48,y+18,85,9,clrWhite,7);
      Label("EqLbl","净值",138,y+18,30,9,clrSilver,7);
      Label("EqVal","--",171,y+18,85,9,clrWhite,7);
      Label("TradeCntLbl","交易",261,y+18,30,9,clrSilver,7);
      Label("TradeCntVal","0",294,y+18,40,9,clrWhite,7);
      Label("MarLbl","可用",14,y+34,30,9,clrSilver,7);
      Label("MarVal","--",48,y+34,75,9,clrWhite,7);
      Label("MargPLbl","保证金",138,y+34,35,9,clrSilver,7);
      Label("MargPVal","--",176,y+34,60,9,clrWhite,7);
      Label("WinRateLbl","胜率",261,y+34,25,9,clrSilver,7);
      Label("WinRateVal","--",290,y+34,40,9,clrWhite,7);
      Label("FreeLbl","已用",14,y+50,30,9,clrSilver,7);
      Label("FreeVal","--",48,y+50,75,9,clrWhite,7);
      Label("LevLbl","杠杆",138,y+50,30,9,clrSilver,7);
      Label("LevVal","--",171,y+50,50,9,clrWhite,7);
      Label("PFLLbl","盈亏比",261,y+50,35,9,clrSilver,7);
      Label("PFLVal","--",300,y+50,40,9,clrWhite,7);
      y+=78;
      Rect("PosBG",8,y,m_w-16,88,C'25,20,20',C'60,50,50');
      Label("PosTitle","持仓监控",14,y+4,55,10,C'200,150,150',8);
      Label("BuyLbl","多单",14,y+18,28,9,clrSilver,7);
      Label("BuyVal","0单/0.00手",45,y+18,70,9,clrWhite,7);
      Label("BuyPL","0.00",120,y+18,55,9,clrLimeGreen,7);
      Label("BuyAvgLbl","均价",180,y+18,28,9,clrSilver,7);
      Label("BuyAvgVal","--",211,y+18,180,9,clrWhite,7);
      Label("SellLbl","空单",14,y+34,28,9,clrSilver,7);
      Label("SellVal","0单/0.00手",45,y+34,70,9,clrWhite,7);
      Label("SellPL","0.00",120,y+34,55,9,clrRed,7);
      Label("SellAvgLbl","均价",180,y+34,28,9,clrSilver,7);
      Label("SellAvgVal","--",211,y+34,180,9,clrWhite,7);
      Label("TotalPLLbl","总盈亏",14,y+50,40,9,clrSilver,7);
      Label("TotalPLVal","0.00",57,y+50,65,9,clrWhite,8);
      Label("TotalLots","0.00手",127,y+50,45,9,clrWhite,8);
      Label("NetPLbl","净盈亏",177,y+50,35,9,clrSilver,7);
      Label("NetPVal","0.00",215,y+50,155,9,clrWhite,8);
      Label("BuyPeakLbl","多峰值",14,y+66,40,8,C'180,140,140',6);
      Label("BuyPeakVal","0.00",57,y+66,50,8,C'200,160,160',6);
      Label("SellPeakLbl","空峰值",112,y+66,40,8,C'180,140,140',6);
      Label("SellPeakVal","0.00",155,y+66,50,8,C'200,160,160',6);
      Label("NetPeakLbl","净峰值",210,y+66,40,8,C'180,140,140',6);
      Label("NetPeakVal","0.00",253,y+66,140,8,C'200,160,160',6);
      y+=88;
      Rect("HedgeBG",8,y,m_w-16,72,C'20,25,20',C'50,60,50');
      Label("HedgeTitle","多核对冲 · 移动止盈",14,y+4,140,10,C'150,200,150',8);
      Label("HedgeType",GetCloseModeName(),285,y+4,120,10,C'150,200,180',7);
      Label("HedgeBuy","多单对冲: 待触发",14,y+20,160,9,clrSilver,7);
      Label("HedgeSell","空单对冲: 待触发",180,y+20,160,9,clrSilver,7);
      Label("HedgeNet","净盈亏对冲: 待触发",14,y+36,180,9,clrSilver,7);
      Label("TrailType","止盈: "+GetTrailingTypeName(),200,y+36,180,9,C'150,200,150',7);
      Label("HedgeRule","盈"+DoubleToString(InpHedgeStartPL,1)+"撤"+DoubleToString(InpHedgePullback,1)+"净平"+DoubleToString(InpNetClosePL,1),14,y+52,380,9,C'150,170,150',6);
      y+=72;
      Rect("AddBG",8,y,m_w-16,66,C'22,22,28',C'55,50,60');
      Label("AddTitle","加仓监控",14,y+4,55,10,C'200,180,140',8);
      Label("AddTypeLbl","方式",14,y+20,22,9,clrSilver,7);
      Label("AddTypeVal",GetAddTypeName(),40,y+20,80,9,clrWhite,7);
      Label("AddDirLbl","方向",125,y+20,22,9,clrSilver,7);
      Label("AddDirVal",GetAddDirName(),151,y+20,55,9,clrWhite,7);
      Label("AddCountLbl","多/空",211,y+20,35,9,clrSilver,7);
      Label("AddCountVal","0/0",250,y+20,40,9,clrWhite,7);
      Label("MaxLotLbl","最大手",14,y+38,35,9,clrSilver,7);
      Label("MaxLotVal",DoubleToString(InpMaxAddLot,2),52,y+38,40,9,clrWhite,7);
      Label("MaxTotLbl","总手限",97,y+38,35,9,clrSilver,7);
      Label("MaxTotVal",DoubleToString(InpMaxTotalLot,2),135,y+38,40,9,clrWhite,7);
      Label("MaxAddLbl","最大层",180,y+38,35,9,clrSilver,7);
      Label("MaxAddVal",IntegerToString(InpMaxAddCount),218,y+38,25,9,clrWhite,7);
      Label("SpacingLbl","间距",248,y+38,22,9,clrSilver,7);
      Label("SpacingVal",GetSpacingName(),273,y+38,120,9,clrWhite,7);
      y+=66;
      Rect("RiskBG",8,y,m_w-16,58,C'30,20,20',C'70,40,40');
      Label("RiskTitle","风控师令",14,y+4,55,10,C'200,150,150',8);
      Label("RiskFloat","浮盈亏: 0.00",14,y+20,95,9,clrWhite,7);
      Label("RiskDD","回撤: 0.00",114,y+20,60,9,clrWhite,7);
      Label("RiskDDPct","0.00%",179,y+20,40,9,clrWhite,7);
      Label("RiskMode","模式: "+GetModeName(),224,y+20,160,9,C'200,170,170',7);
      Label("RiskTrail","移止: "+IntegerToString(InpTrailActive)+"/"+IntegerToString(InpTrailLock),14,y+36,170,9,C'180,140,140',7);
      Label("RiskBreakeven","保本: "+IntegerToString(InpBreakevenDist)+"点",190,y+36,160,9,C'180,140,140',7);
      y+=58;
      Rect("FooterBG",0,y,m_w,20,C'30,25,20',C'80,70,40');
      Label("Footer","金戈铁马 · 多核对冲风控执行",14,y+4,380,10,C'180,160,100',7);
   }
   void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam)
   {
      int x=(int)lparam, y=(int)dparam;
      if(id==CHARTEVENT_CLICK)
      {
         if(!m_dragging)
         {
            if(x>=m_x && x<=m_x+m_w && y>=m_y && y<=m_y+m_h)
            {
               m_dragging=true;
               m_dragStartX=x-m_x;
               m_dragStartY=y-m_y;
               ObjectSetInteger(m_ch,m_pfx+"BG",OBJPROP_COLOR,clrRed);
               ObjectSetInteger(m_ch,m_pfx+"BG",OBJPROP_WIDTH,2);
               ChartRedraw(0);
            }
         }
         else
         {
            m_dragging=false;
            ObjectSetInteger(m_ch,m_pfx+"BG",OBJPROP_COLOR,C'80,60,30');
            ObjectSetInteger(m_ch,m_pfx+"BG",OBJPROP_WIDTH,1);
            ChartRedraw(0);
         }
      }
      else if(id==CHARTEVENT_MOUSE_MOVE && m_dragging)
      {
         int nx=x-m_dragStartX, ny=y-m_dragStartY;
         long cw=ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
         long ch=ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
         int mx=(int)cw-m_w, my=(int)ch-m_h;
         if(mx<0) mx=0; if(my<0) my=0;
         if(nx<0) nx=0; if(ny<0) ny=0;
         if(nx>mx) nx=mx; if(ny>my) ny=my;
         m_x=nx; m_y=ny;
         Destroy();
         BuildPanel();
      }
   }
   void Update()
   {
      UpdateAccount();
      UpdatePositions();
      UpdateHedge();
      UpdateAdd();
      UpdateRisk();
      ChartRedraw(0);
   }
   void UpdateAccount()
   {
      double bal=AccountInfoDouble(ACCOUNT_BALANCE);
      double eq=AccountInfoDouble(ACCOUNT_EQUITY);
      double free=AccountInfoDouble(ACCOUNT_FREE_MARGIN);
      double ml=AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
      double used=AccountInfoDouble(ACCOUNT_MARGIN);
      int lev=(int)AccountInfoInteger(ACCOUNT_LEVERAGE);
      SetText("BalVal",DoubleToString(bal,2)+" USD");
      SetText("EqVal",DoubleToString(eq,2)+" USD");
      SetText("MarVal",DoubleToString(free,2));
      SetText("MargPVal",DoubleToString(ml,1)+"%");
      SetText("FreeVal",DoubleToString(used,2));
      SetText("LevVal","1:"+IntegerToString(lev));
      SetText("TradeCntVal",IntegerToString(g_win_trades+g_lose_trades));
      double wr=(g_win_trades+g_lose_trades>0)?(double)g_win_trades/(g_win_trades+g_lose_trades)*100:0;
      SetText("WinRateVal",DoubleToString(wr,1)+"%");
      SetText("PFLVal","--");
   }
   void UpdatePositions()
   {
      int bc=g_engine.GetPositionCount(_Symbol,POSITION_TYPE_BUY);
      double bl=g_engine.GetTotalLot(_Symbol,POSITION_TYPE_BUY);
      double bpl=g_engine.GetTotalProfit(_Symbol,POSITION_TYPE_BUY);
      double bav=g_engine.GetAvgPrice(_Symbol,POSITION_TYPE_BUY);
      int sc=g_engine.GetPositionCount(_Symbol,POSITION_TYPE_SELL);
      double sl=g_engine.GetTotalLot(_Symbol,POSITION_TYPE_SELL);
      double spl=g_engine.GetTotalProfit(_Symbol,POSITION_TYPE_SELL);
      double sav=g_engine.GetAvgPrice(_Symbol,POSITION_TYPE_SELL);
      SetText("BuyVal",IntegerToString(bc)+"单/"+DoubleToString(bl,2)+"手");
      SetText("BuyPL",DoubleToString(bpl,2));
      SetColor("BuyPL",(bpl>=0)?clrLimeGreen:clrRed);
      SetText("BuyAvgVal",(bav>0)?DoubleToString(bav,5):"--");
      SetText("SellVal",IntegerToString(sc)+"单/"+DoubleToString(sl,2)+"手");
      SetText("SellPL",DoubleToString(spl,2));
      SetColor("SellPL",(spl>=0)?clrLimeGreen:clrRed);
      SetText("SellAvgVal",(sav>0)?DoubleToString(sav,5):"--");
      double tpl=bpl+spl, tlot=bl+sl, npl=bpl-spl;
      SetText("TotalPLVal",DoubleToString(tpl,2));
      SetColor("TotalPLVal",(tpl>=0)?clrLimeGreen:clrRed);
      SetText("TotalLots",DoubleToString(tlot,2)+"手");
      SetText("NetPVal",DoubleToString(npl,2));
      SetColor("NetPVal",(npl>=0)?clrLimeGreen:clrRed);
      SetText("BuyPeakVal",DoubleToString(g_buy_peak_pl,2));
      SetText("SellPeakVal",DoubleToString(g_sell_peak_pl,2));
      SetText("NetPeakVal",DoubleToString(MathMax(g_buy_peak_pl,g_sell_peak_pl),2));
      SetText("Status",(bc+sc>0)?"战况: 持仓中":"战况: 允许交易");
      SetColor("Status",(bc+sc>0)?clrYellow:clrLimeGreen);
   }
   void UpdateHedge()
   {
      SetText("HedgeType",GetCloseModeName());
      SetText("TrailType","止盈: "+GetTrailingTypeName());
      SetText("HedgeRule","兵法: 盈"+DoubleToString(InpHedgeStartPL,1)+" 撤"+DoubleToString(InpHedgePullback,1)+" 净平"+DoubleToString(InpNetClosePL,1));
   }
   void UpdateAdd()
   {
      SetText("AddTypeVal",GetAddTypeName());
      SetText("AddDirVal",GetAddDirName());
      SetText("AddCountVal",IntegerToString(g_buy_add_count)+"/"+IntegerToString(g_sell_add_count));
      SetText("MaxLotVal",DoubleToString(InpMaxAddLot,2));
      SetText("MaxTotVal",DoubleToString(InpMaxTotalLot,2));
      SetText("MaxAddVal",IntegerToString(InpMaxAddCount));
      SetText("SpacingVal",GetSpacingName());
   }
   void UpdateRisk()
   {
      double tpl=g_engine.GetTotalProfit(_Symbol,POSITION_TYPE_BUY)+g_engine.GetTotalProfit(_Symbol,POSITION_TYPE_SELL);
      SetText("RiskFloat","浮盈亏: "+DoubleToString(tpl,2));
      SetColor("RiskFloat",(tpl>=0)?clrLimeGreen:clrRed);
      SetText("RiskMode","模式: "+GetModeName());
   }
};

string GetAddTypeName(){ switch(InpAddType){ case 马丁倍率: return "马丁倍率"; case 递增手数: return "递增手数"; case 自定义列表: return "自定义列表"; case 斐波那契: return "斐波那契"; } return "--"; }
string GetAddDirName(){ switch(InpAddDirection){ case 双向加仓: return "双向"; case 顺势加仓: return "顺势"; case 逆势加仓: return "逆势"; } return "--"; }
string GetTrailingTypeName(){ switch(InpTrailingType){ case 固定间距: return "固定间距"; case ATR动态: return "ATR动态"; case 阶梯式: return "阶梯式"; } return "--"; }
string GetCloseModeName(){ switch(InpProfitCloseMode){ case 单目标止盈: return "单目标"; case 阶梯止盈: return "阶梯止盈"; case 回撤止盈: return "回撤止盈"; } return "--"; }
string GetModeName(){ switch(InpTradeMode){ case 保守模式: return "保守"; case 稳健模式: return "稳健"; case 激进模式: return "激进"; case 自定义模式: return "自定义"; } return "--"; }
string GetSpacingName(){ return (InpUseSpacingATR)?"ATR动态":IntegerToString(InpAddSpacing)+"点"; }

void CheckTrailingStop(string symbol)
{
   if(!InpUseTrailing) return;
   double pt=SymbolInfoDouble(symbol,SYMBOL_POINT);
   double bid=SymbolInfoDouble(symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);
   double buy_avg=g_engine.GetAvgPrice(symbol,POSITION_TYPE_BUY);
   double sell_avg=g_engine.GetAvgPrice(symbol,POSITION_TYPE_SELL);
   double buy_lot=g_engine.GetTotalLot(symbol,POSITION_TYPE_BUY);
   double sell_lot=g_engine.GetTotalLot(symbol,POSITION_TYPE_SELL);
   double atr_val=0;
   if(InpTrailingType==ATR动态){ int h=iATR(symbol,PERIOD_CURRENT,InpATRPeriod); if(h!=INVALID_HANDLE){ double buf[]; if(CopyBuffer(h,0,0,1,buf)>0) atr_val=buf[0]; IndicatorRelease(h); } }
   if(buy_lot>0 && buy_avg>0)
   {
      double td=InpTrailLock*pt; if(InpTrailingType==ATR动态 && atr_val>0) td=atr_val*InpTrailATRMult;
      double nsl=bid-td;
      for(int i=0;i<(int)PositionsTotal();i++){ ulong t=PositionGetTicket(i); if(PositionGetSymbol(t)==symbol && PositionGetType(t)==POSITION_TYPE_BUY){ double csl=PositionGetDouble(t,POSITION_SL); if(csl>0 && nsl>csl){ CTrade tr; tr.PositionModify(t,nsl,PositionGetDouble(t,POSITION_TP)); } } }
   }
   if(sell_lot>0 && sell_avg>0)
   {
      double td=InpTrailLock*pt; if(InpTrailingType==ATR动态 && atr_val>0) td=atr_val*InpTrailATRMult;
      double nsl=ask+td;
      for(int i=0;i<(int)PositionsTotal();i++){ ulong t=PositionGetTicket(i); if(PositionGetSymbol(t)==symbol && PositionGetType(t)==POSITION_TYPE_SELL){ double csl=PositionGetDouble(t,POSITION_SL); if(csl>0 && nsl<csl){ CTrade tr; tr.PositionModify(t,nsl,PositionGetDouble(t,POSITION_TP)); } } }
   }
}

void CheckBreakeven(string symbol)
{
   if(!InpUseBreakeven) return;
   double pt=SymbolInfoDouble(symbol,SYMBOL_POINT);
   for(int i=0;i<(int)PositionsTotal();i++){ ulong t=PositionGetTicket(i); if(PositionGetSymbol(t)!=symbol) continue; int type=PositionGetType(t); double op=PositionGetDouble(t,POSITION_PRICE_OPEN); double csl=PositionGetDouble(t,POSITION_SL); double pl=PositionGetDouble(t,POSITION_PROFIT); double bd=InpBreakevenDist*pt; if(type==POSITION_TYPE_BUY){ if(pl>bd && (csl==0 || csl<op)){ CTrade tr; tr.PositionModify(t,op,PositionGetDouble(t,POSITION_TP)); } } else { if(pl>bd && (csl==0 || csl>op)){ CTrade tr; tr.PositionModify(t,op,PositionGetDouble(t,POSITION_TP)); } } }
}

void CheckAddPosition(string symbol)
{
   double bid=SymbolInfoDouble(symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);
   int bc=g_engine.GetPositionCount(symbol,POSITION_TYPE_BUY);
   int sc=g_engine.GetPositionCount(symbol,POSITION_TYPE_SELL);
   double bav=g_engine.GetAvgPrice(symbol,POSITION_TYPE_BUY);
   double sav=g_engine.GetAvgPrice(symbol,POSITION_TYPE_SELL);
   double bl=g_engine.GetTotalLot(symbol,POSITION_TYPE_BUY);
   double sl=g_engine.GetTotalLot(symbol,POSITION_TYPE_SELL);
   if(InpAddDirection!=双向加仓){ int sig=g_signal.GetSignal(); if(InpAddDirection==顺势加仓 && sig==0) return; if(InpAddDirection==逆势加仓 && sig!=0) return; }
   if(bc>0 && bav>0 && bl<InpMaxTotalLot){ double sp=GetAddSpacing(g_buy_add_count); double ap=bav-sp; if(bid<=ap && g_buy_add_count<InpMaxAddCount){ double nl=GetNextLot(InpInitialLot,g_buy_add_count); if(nl<=InpMaxAddLot){ double slvl=bav-sp*2; double tplvl=bav+sp*3; if(g_engine.OpenPosition(symbol,POSITION_TYPE_BUY,nl,slvl,tplvl)) g_buy_add_count++; } } }
   if(sc>0 && sav>0 && sl<InpMaxTotalLot){ double sp=GetAddSpacing(g_sell_add_count); double ap=sav+sp; if(ask>=ap && g_sell_add_count<InpMaxAddCount){ double nl=GetNextLot(InpInitialLot,g_sell_add_count); if(nl<=InpMaxAddLot){ double slvl=sav+sp*2; double tplvl=sav-sp*3; if(g_engine.OpenPosition(symbol,POSITION_TYPE_SELL,nl,slvl,tplvl)) g_sell_add_count++; } } }
}

double GetAddSpacing(int add_count)
{
   double sp=InpAddSpacing*SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   if(InpUseSpacingATR){ int h=iATR(_Symbol,PERIOD_CURRENT,InpATRPeriod); if(h!=INVALID_HANDLE){ double buf[]; if(CopyBuffer(h,0,0,1,buf)>0){ if(buf[0]>0) sp=buf[0]*InpATRMult; } IndicatorRelease(h); } }
   if(add_count>0) sp*=MathPow(InpAddSpacingMult,add_count);
   return sp;
}

double GetNextLot(double initial_lot,int add_count)
{
   double nl=initial_lot;
   switch(InpAddType)
   {
      case 马丁倍率: nl=initial_lot*MathPow(InpMartinMult,add_count)*InpAddCoeff; break;
      case 递增手数: nl=initial_lot+InpIncreaseLot*add_count*InpAddCoeff; break;
      case 自定义列表: { double cl[]; StringSplit(InpCustomLots,',',cl); if(add_count<ArraySize(cl)) nl=StringToDouble(cl[add_count])*InpAddCoeff; else if(ArraySize(cl)>0) nl=StringToDouble(cl[ArraySize(cl)-1])*InpAddCoeff; } break;
      case 斐波那契: if(add_count<ArraySize(m_fib_ratios)) nl=initial_lot*m_fib_ratios[add_count]*InpAddCoeff; else nl=initial_lot*55.0*InpAddCoeff; break;
   }
   int dec=(InpDecimalPlace==两位小数)?2:3;
   return NormalizeDouble(nl,dec);
}

void CheckClosePosition(string symbol)
{
   CheckMultiTargetClose(symbol,POSITION_TYPE_BUY);
   CheckMultiTargetClose(symbol,POSITION_TYPE_SELL);
   CheckDrawdownClose(symbol,POSITION_TYPE_BUY);
   CheckDrawdownClose(symbol,POSITION_TYPE_SELL);
   CheckTimeClose(symbol);
}

void CheckMultiTargetClose(string symbol,int type)
{
   if(InpProfitCloseMode!=阶梯止盈) return;
   double tl=g_engine.GetTotalLot(symbol,type);
   if(tl<=0) return;
   double tpl=g_engine.GetTotalProfit(symbol,type);
   double ppl=tpl/tl/0.01;
   double tgts[],rts[];
   StringSplit(InpMultiTargets,',',tgts);
   StringSplit(InpMultiRatios,',',rts);
   int tc=MathMin(ArraySize(tgts),ArraySize(rts));
   for(int i=0;i<tc;i++){ double tgt=StringToDouble(tgts[i]); double rt=StringToDouble(rts[i]); if(ppl>=tgt){ if(InpUsePartialClose) g_engine.ClosePartial(symbol,type,rt); else g_engine.CloseAllPositions(symbol,type); g_win_trades++; g_risk.ResetTrail(); if(type==POSITION_TYPE_BUY) g_buy_add_count=0; else g_sell_add_count=0; break; } }
}

void CheckDrawdownClose(string symbol,int type)
{
   if(InpProfitCloseMode!=回撤止盈) return;
   double tl=g_engine.GetTotalLot(symbol,type);
   if(tl<=0) return;
   double tpl=g_engine.GetTotalProfit(symbol,type);
   double ppl=tpl/tl/0.01;
   double pk=(type==POSITION_TYPE_BUY)?g_buy_peak_pl:g_sell_peak_pl;
   if(ppl>pk){ pk=ppl; if(type==POSITION_TYPE_BUY) g_buy_peak_pl=pk; else g_sell_peak_pl=pk; }
   if(pk>=InpDrawdownTrigger){ double dd=pk-ppl; double ddp=(pk>0)?(dd/pk*100):0; if(ddp>=InpDrawdownPercent){ if(InpUsePartialClose) g_engine.ClosePartial(symbol,type,InpPartialRatio); else g_engine.CloseAllPositions(symbol,type); g_win_trades++; if(type==POSITION_TYPE_BUY) g_buy_peak_pl=0; else g_sell_peak_pl=0; g_risk.ResetTrail(); if(type==POSITION_TYPE_BUY) g_buy_add_count=0; else g_sell_add_count=0; } }
}

void CheckTimeClose(string symbol)
{
   if(!InpUseTimeClose) return;
   datetime now=TimeCurrent();
   MqlDateTime dt;
   TimeToStruct(now,dt);
   if(dt.hour==InpCloseHour && dt.min>=InpCloseMinute){ g_engine.CloseAllPositions(symbol,POSITION_TYPE_BUY); g_engine.CloseAllPositions(symbol,POSITION_TYPE_SELL); g_buy_add_count=0; g_sell_add_count=0; }
}

void CheckPairHedge(string symbol)
{
   if(!InpUsePairHedge) return;
   double bp=g_engine.GetTotalProfit(symbol,POSITION_TYPE_BUY);
   double sp=g_engine.GetTotalProfit(symbol,POSITION_TYPE_SELL);
   double np=bp-sp;
   if(InpUseNetClose && MathAbs(np)>=InpNetClosePL){ g_engine.CloseAllPositions(symbol,POSITION_TYPE_BUY); g_engine.CloseAllPositions(symbol,POSITION_TYPE_SELL); g_buy_add_count=0; g_sell_add_count=0; }
}

void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam)
{
   g_panel.OnChartEvent(id,lparam,dparam,sparam);
}