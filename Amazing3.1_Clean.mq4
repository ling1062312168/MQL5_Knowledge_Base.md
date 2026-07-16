//EA交易     =>  ...\MT4\MQL4\Experts

#property  copyright "Amazing3.1"
#property version    "3.1"
#property strict

input bool 用佣金平仓开关=true;
input double 每一手订单返佣美金=10;
input double 当前成交订单的返佣总额和亏损总额差值大于等于=5;

input bool 多空差距大于等于N停止开单开关=true;
input int 多空差距大于等于N停止开单=1000;
input bool 多空差距大于M使用第三组参数开关=true;
input int 多空差距大于M使用第三组参数=1000;


extern int   TwoMinDistance3=60  ;    //第三最小距离
extern int   TwoStep3=100  ;    //第三补单间距




input bool 对冲平仓开关=false;
//enum ENUM_TIMEFRAMES      {PERIOD_CURRENT = 0, PERIOD_M1 = 1, PERIOD_M2 = 2, PERIOD_M3 = 3, PERIOD_M4 = 4, PERIOD_M5 = 5, PERIOD_M6 = 6, PERIOD_M10 = 10, PERIOD_M12 = 12, PERIOD_M15 = 15, PERIOD_M20 = 20, PERIOD_M30 = 30, PERIOD_H1 = 60, PERIOD_H2 = 120, PERIOD_H3 = 180, PERIOD_H4 = 240, PERIOD_H6 = 360, PERIOD_H8 = 480, PERIOD_H12 = 720, PERIOD_D1 = 1440, PERIOD_W1 = 10080, PERIOD_MN1 = 43200, };

enum opentime
  {
   A = 1,//开单时区模式
   B = 2,//开单时间间距(秒)模式
   C = 3,//不延迟模式
  };
//------------------
extern double On_top_of_this_price_not_Buy_first_order=0  ;    //B以上不开(首)
extern double On_under_of_this_price_not_Sell_first_order=0  ;    //S以下不开(首)
extern double On_top_of_this_price_not_Buy_order=0  ;    //B以上不开(补)
extern double On_under_of_this_price_not_Sell_order=0  ;    //S以下不开(补)
extern string Limit_StartTime="00:00"  ;   //限价开始时间
extern string Limit_StopTime="24:00"  ;   //限价结束时间
extern bool CloseBuySell=true  ;    //逆势保护开关
extern bool HomeopathyCloseAll=true  ;    //顺势保护开关
extern bool Homeopathy=false ;    //完全对锁时挂上顺势开关
extern bool Over=false ;    //平仓后停止交易
extern int   NextTime=0  ;    //整体平仓后多少秒后新局


extern double Money=0  ;    //浮亏多少启用第二参数
extern int   FirstStep=30  ;    //首单距离
extern int   MinDistance=60  ;    //最小距离
extern int   TwoMinDistance=60  ;    //第二最小距离
extern int   StepTrallOrders=5  ;    //挂单追踪点数
extern int   Step=100  ;    //补单间距
extern int   TwoStep=100  ;    //第二补单间距
extern  opentime  OpenMode=3  ;
extern  ENUM_TIMEFRAMES  TimeZone=1  ;    //开单时区
extern int   sleep=30  ;    //开单时间间距(秒)
extern double MaxLoss=100000  ;    //单边浮亏超过多少不继续加仓
extern double MaxLossCloseAll=50  ;    //单边平仓限制
extern double lot=0.01  ;    //起始手数
extern double Maxlot=10  ;    //最大开单手数
extern double PlusLot=0  ;    //累加手数
extern double K_Lot=1.3  ;    //倍率
extern int   DigitsLot=2  ;    //下单量的小数位
extern double CloseAll=0.5  ;    //整体平仓金额
extern bool Profit=true  ;    //单边平仓金额累加开关
extern double StopProfit=2  ;    //单边平仓金额
extern double StopLoss=0  ;    //止损金额
extern int   Magic=9453  ;
extern int   Totals=50  ;    //最大单量
extern int   MaxSpread=32  ;    //点差限制
extern int   Leverage=100  ;    //平台杠杆限制
extern string EA_StartTime="00:00"  ;   //EA开始时间
extern string EA_StopTime="24:00"  ;   //EA结束时间

//========================= 突破EA参数 =========================
input bool   Flag_Stop              = false;    // 是否停止新增挂单（可用面板切换）
input bool   HidePanel              = true;     // 是否隐藏左上角Comment文字
input bool   EnableChartPanel       = true;     // 显示图表操作面板
input int    PanelStartX            = 16;       // 按钮面板X(像素)
input int    PanelStartY            = 18;       // 按钮面板Y(像素)

input group "新闻过滤"
input bool   EnableHighImpactNewsPause = true;  // 启用高影响新闻暂停
input int    NewsLeadMinutes           = 180;   // 新闻前暂停分钟
input int    NewsCooldownMinutes       = 180;   // 新闻后暂停分钟

input group "Session"
input bool   EnableTradingSessionWindow = true;  // 启用工作时间段控制
input bool   EnableDailyWrapUpPhase     = true;  // 启用日内收尾阶段
input string DailyWrapUpStartTime       = "20:00"; // 收尾开始(服务器时间)
input string DailyWrapUpStopTime        = "24:00"; // 收尾结束(服务器时间)
input bool   EnableDailyProfitTarget     = true;  // 启用每日盈利目标
input double DailyProfitTarget          = 500.0;  // 每日盈利目标

int       g_timeframe = 1;
int       g_maxVolatility = 0;
int       g_fontSize = 10;
uint      g_colorLime = Lime;
uint      g_colorBlue = Blue;
uint      g_colorRed = Red;
datetime  g_nextTradeTime = 0;
bool      g_ignoreMargin = true;
bool      g_sellHeavy = false;
bool      g_buyHeavy = false;
string    g_str13  =  "";
string    g_tooltipDesc  =  "0-off  1-Candle  2-Fractals  >2-pips";
int       g_in15 = 3;
int       g_in16 = 20;
int       g_in17 = 25;
int       g_in18 = 0;
int       g_timeframeConv = 15;
int       g_minSpreadStep = 0;
int       g_in21 = 346856;
int       g_slippagePoints = 0;
double    g_buyImbalanceVal = 0.0;
double    g_sellImbalanceVal = 0.0;
int       g_expiryDate = 0 /* expiry removed */;
string    g_brokerName1  =  "" /* broker */;
string    g_brokerName2  =  "" /* broker */;
int       g_closeProfitN = 1;
int       g_closeLossN = 2;
double    g_lotCoeff = 10.0;
uint      g_colorDimGray = DimGray;
string    g_spreadLabel  =  "Spread";
int       g_in33 = 0;
bool      g_showButtons = true;
string    g_btnBuyName  =  "Button1";
string    g_btnSellName  =  "Button2";
string    g_btnCloseName  =  "Button5";
int       g_colorBlueInt = 55295;
int       g_colorWhiteInt = 16777215;
int       g_arrowColor = 65280;
int       g_colorGreenInt = 65280;
int       g_colorYellowInt = 65535;
int       g_colorGrayInt = 12632256;
string    g_leverLabel  =  "Lever";
string    g_spreadsLabel  =  "Spreads";
int       g_labelCorner = 0;
int       g_labelX = 25;
int       g_labelY = 180;
bool      g_bo49 = false;
string    g_eaName  =  "Amazing3.1";
double    g_do51 = 0.0;
double    g_do52 = 0.0;
int       g_in53 = 0;
int       g_in54 = 0;
int       g_in55 = 0;
string    g_colorStr1  =  "000,000,000";
string    g_colorStr2  =  "000,000,255";
int       g_in58 = 40;
int       g_in59 = 0;
int       g_in60 = 0;
int       g_in61 = 0;
datetime  g_lastBarTime = 0;
datetime  g_eaStartTime = 0;
datetime  g_eaStopTime = 0;
datetime  g_limitStartTime = 0;
datetime  g_limitStopTime = 0;
datetime  g_da67 = 0;
datetime  g_da68 = 0;
int       g_in69 = 0;

//========================= 面板状态 =========================
string   g_panel_prefix        = "Amazing.";
bool     g_panel_open          = false;
int      g_panel_x             = 16;
int      g_panel_y             = 18;
bool     g_panel_dragging      = false;
int      g_panel_drag_offset_x = 0;
int      g_panel_drag_offset_y = 0;
datetime g_last_panel_refresh  = 0;
bool     g_allow_buy           = true;
bool     g_allow_sell          = true;
bool     g_stop_new_orders     = false;

struct EAStats
{
   int    buy_positions;
   int    sell_positions;
   int    buy_pending;
   int    sell_pending;
   double buy_lots;
   double sell_lots;
   double buy_profit;
   double sell_profit;
   double total_profit;
};

struct PanelMetrics
{
   int margin_x;
   int margin_y;
   int width;
   int pad;
   int section_gap;
   int header_h;
   int row_h;
   int gap;
   int button_h;
   int inner_w;
   int half_w;
   int card_status_h;
   int card_metrics_h;
   int card_actions_h;
   int button_font;
   int font_xs;
   int font_sm;
   int font_md;
   int font_lg;
   int toggle_w;
   int panel_h;
};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   int         errCode;
   bool        initFlag;
   string      initStr;
   int         remainingCount;

//----------------------------


   g_eaName = WindowExpertName() ;

   errCode = 0 ;
   initFlag = false ;
   remainingCount = 0 ;
   g_timeframeConv = ConvertTimeframe(g_timeframeConv) ;
   if((Digits() == 5 || Digits() == 3))
     {
      g_slippagePoints = 30 ;
     }
   Comment("");
   g_minSpreadStep=(int)MathMax(MarketInfo(Symbol(),33),MarketInfo(Symbol(),14)) + 1;
   if(Step <  g_minSpreadStep)
     {
      Step = g_minSpreadStep ;
     }
   if(FirstStep <  g_minSpreadStep)
     {
      FirstStep = g_minSpreadStep ;
     }
   if(MinDistance <  g_minSpreadStep)
     {
      MinDistance = g_minSpreadStep ;
     }
   initFlag = false ;
   initStr = "Paramfalse" ;
   MaxLossCloseAll = -(MaxLossCloseAll);
   MaxLoss = -(MaxLoss);
   StopLoss = -(StopLoss);
   Money = -(Money);

   if(g_eaName  !=  WindowExpertName())
     {
      Comment("");
      g_allow_buy = false ;
      g_allow_sell = false ;
      ObjectsDeleteAll(-1,-1);
      if(ObjectFind(g_spreadLabel) <  0)
        {
         ObjectCreate(g_spreadLabel,OBJ_LABEL,0,0,0.0,0,0.0,0,0.0);
         ObjectSet(g_spreadLabel,OBJPROP_CORNER,1.0);
         ObjectSet(g_spreadLabel,OBJPROP_YDISTANCE,260.0);
         ObjectSet(g_spreadLabel,OBJPROP_XDISTANCE,10.0);
         ObjectSetText(g_spreadLabel,"Spread: " + DoubleToString((Ask - Bid) / g_lotCoeff,1) + " pips",13,"Arial",g_colorDimGray);
        }
      ObjectSetText(g_spreadLabel,"Spread: " + DoubleToString((Ask - Bid) / g_lotCoeff,1) + " pips",0,NULL,0xFFFFFFFF);
      WindowRedraw();
      WindowRedraw();
     }
   PlaySound("Starting.wav");
   StringReplace(EA_StartTime," ","");
   StringReplace(EA_StopTime," ","");
   StringTrimLeft(EA_StartTime);
   StringTrimLeft(EA_StopTime);
   StringTrimRight(EA_StartTime);
   StringTrimRight(EA_StopTime);
   if(EA_StopTime == "24:00")
     {
      EA_StopTime = "23:59:59" ;
     }
   StringReplace(Limit_StartTime," ","");
   StringReplace(Limit_StopTime," ","");
   StringTrimLeft(Limit_StartTime);
   StringTrimLeft(Limit_StopTime);
   StringTrimRight(Limit_StartTime);
   StringTrimRight(Limit_StopTime);
   if(Limit_StopTime == "24:00")
     {
      Limit_StopTime = "23:59:59" ;
     }
   start();
   if(EnableChartPanel)
   {
      g_panel_open = true;
      InitPanelPosition();
      RefreshPanel(true);
   }
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   return(0);
  }
//init
//---------------------  ----------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
//Comment(CountOrders(OP_BUY,Magic,"")+" "+CountOrders(OP_SELL,Magic,""));

   if(用佣金平仓开关)
      if(SumOrderProfit(-200,Magic,"")+SumOrderLots(-200,Magic,"")*每一手订单返佣美金>=当前成交订单的返佣总额和亏损总额差值大于等于)
         DeleteOrders(-100,Magic,"");

   if(多空差距大于等于N停止开单开关)
     {
      if(CountOrders(OP_BUY,Magic,"")>=CountOrders(OP_SELL,Magic,"")+多空差距大于等于N停止开单)
         DeleteOrders(OP_BUYSTOP,Magic,"");
      if(CountOrders(OP_SELL,Magic,"")>=CountOrders(OP_BUY,Magic,"")+多空差距大于等于N停止开单)
         DeleteOrders(OP_SELLSTOP,Magic,"");
     }
   bool        isAuthorized;
   double      orderOpenPrice;
   double      sellProfit;
   double      buyProfit;
   double      buyTotalLots;
   double      sellTotalLots;
   double      orderLots;
   int         buyCount;
   int         sellCount;
   int         buyStopCount;
   int         sellStopCount;
   int         orderType;
   int         buyStopTicket;
   int         sellStopTicket;
   double      highestBuyPrice;
   double      lowestBuyPrice;
   double      highestSellPrice;
   double      lowestSellPrice;
   double      buyStopPrice;
   double      sellStopPrice;
   double      sellWeightedSum;
   double      buyWeightedSum;
   double      buyAvgPrice;
   double      sellAvgPrice;
   double      newOrderPrice;
   double      newOrderLots;
   int         loopIdx;
   double      spreadPoints;
   string      spreadText;
   double      leverage;
   string      leverageText;
   double      profitDiff;
   double      do33;
   bool        useSecondParam;
   double      highRange;
   double      highRangePoints;
   double      lowRange;
   double      lowRangePoints;
   double      totalProfit;

//----------------------------
   datetime   checkTime1;
   bool       inLimitWindow1;
   string     fontStr1;
   string     stopMsg1;
   string     fontStr2;
   string     stopMsg2;
   datetime   checkTime2;
   bool       inEaWindow1;
   string     fontStr3;
   string     stopMsg3;
   string     fontStr4;
   string     stopMsg4;
   datetime   checkTime3;
   bool       inEaWindow2;
   string     fontStr5;
   string     stopMsg5;
   string     sortKey1;
   string     sortDir1;
   int        maxTicket1;
   double     maxLots1;
   int        orderIdx1;
   double     sortResult1;
   int        resultTicket1;
   string     sortKey2;
   string     sortDir2;
   int        maxTicket2;
   double     maxLots2;
   int        orderIdx2;
   double     sortResult2;
   string     trailStr_b1;
   string     trailStr_b2;
   int        tmpInt_32;
   double     tmpDbl_33;
   int        tmpInt_34;
   double     tmpDbl_35;
   int        tmpInt_36;
   string     trailStr_s1;
   string     trailStr_s2;
   int        tmpInt_39;
   double     tmpDbl_40;
   int        tmpInt_41;
   double     tmpDbl_42;
   string     trailStr_s3;
   int        tmpInt_44;
   int        tmpInt_45;
   string     trailStr_s4;
   int tmpInt_47 = 0;
   int        tmpInt_48;
   string     trailStr_s5;
   int        tmpInt_50;
   int        tmpInt_51;
   string     trailStr_s6;
   int        tmpInt_53;
   int        tmpInt_54;
   string     trailStr_s7;
   string     trailStr_s8;
   int        tmpInt_57;
   double     trailVal_b1;
   int        trailIdx_b1;
   double     trailVal_b2;
   int        trailIdx_b2;
   string     trailStr_s9;
   string     trailStr_s10;
   int        tmpInt_64;
   double     trailVal_b3;
   int        trailIdx_b3;
   double     trailVal_b4;
   string     trailStr_s11;
   string     trailStr_s12;
   int        trailIdx_b4;
   double     trailVal_b5;
   int        trailIdx_b5;
   double     trailVal_b6;
   int        trailIdx_b6;
   string     trailStr_s13;
   string     trailStr_s14;
   int        trailIdx_b7;
   double     trailVal_b7;
   int        trailIdx_b8;
   double     trailVal_b8;
   string     trailStr_s15;
   string     trailStr_s16;
   int        trailIdx_b9;
   double     trailVal_b9;
   int        trailIdx_b10;
   double     trailVal_b10;
   int        trailIdx_b11;
   string     trailStr_s17;
   string     trailStr_s18;
   int        trailIdx_b12;
   double     trailVal_b11;
   int        trailIdx_b13;
   double     trailVal_b12;
   string     trailStr_s19;
   string     trailStr_s20;
   int        trailIdx_b14;
   double     trailVal_b13;
   int        trailIdx_b15;
   double     trailVal_b14;
   int        trailIdx_b16;
   string     trailStr_s21;
   string     trailStr_s22;
   int        trailIdx_s1;
   double     trailVal_s1;
   int        trailIdx_s2;
   double     trailVal_s2;
   int        profitMode1;
   int        magicFilter1;
   int        typeFilter1;
   double     maxProfitLots1;
   double     maxProfit1;
   int        orderIdx3;
   int        profitMode2;
   int        magicFilter2;
   int        typeFilter2;
   double     maxProfitLots2;
   double     maxProfit2;
   int        orderIdx4;
   datetime   checkTime_b1;
   bool       inEaWindow_b1;
   datetime   checkTime_b2;
   bool       inLimitWindow_b1;
   datetime   checkTime_b3;
   bool       inLimitWindow_b2;
   datetime   checkTime_b4;
   bool       inLimitWindow_b3;
   datetime   checkTime_b5;
   bool inLimitWindow_b4 = false;
   datetime   checkTime_b6;
   bool inLimitWindow_b5 = false;
   int        inLimit_b1;
   int        inLimit_b2;
   int        inLimit_b3;
   int        inLimit_b4;
   int        inLimit_b5;
   datetime   checkTime_s1;
   bool       inEaWindow_s1;
   datetime   checkTime_s2;
   bool       inEaWindow_s2;
   datetime   checkTime_s3;
   bool       inEaWindow_s3;
   datetime   checkTime_s4;
   bool       inEaWindow_s4;
   datetime   checkTime_s5;
   bool inEaWindow_s5 = false;
   datetime   checkTime_s6;
   bool inEaWindow_s6 = false;
   int        inLimit_s1;
   int        inLimit_s2;
   int        inLimit_s3;
   int        inLimit_s4;
   int        inLimit_s5;



   /* 账户验证已移除 */
   isAuthorized = true;
   if(IsDemo())
     {
      isAuthorized = true ;
     }
   if(IsTesting())
     {
      isAuthorized = true ;
     }
   /* 非法账户处理已移除 */
   checkTime1 = 0;
   if(IsTesting())
     {
      checkTime1 = TimeCurrent();
     }
   else
     {
      checkTime1 = TimeLocal();
     }
   g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime1),".",TimeMonth(checkTime1),".",TimeDay(checkTime1)," ",Limit_StartTime)) ;
   g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime1),".",TimeMonth(checkTime1),".",TimeDay(checkTime1)," ",Limit_StopTime)) ;
   if(g_limitStartTime <  g_limitStopTime && (checkTime1 < g_eaStartTime || checkTime1 > g_limitStopTime))
     {
      ObjectDelete("HLINE_LONG");
      ObjectDelete("HLINE_SHORT");
      ObjectDelete("HLINE_LONGII");
      ObjectDelete("HLINE_SHORTII");
      inLimitWindow1 = false;
     }
   else
     {
      if(g_limitStartTime > g_limitStopTime && checkTime1 <  g_limitStartTime && checkTime1 > g_limitStopTime)
        {
         ObjectDelete("HLINE_LONG");
         ObjectDelete("HLINE_SHORT");
         ObjectDelete("HLINE_LONGII");
         ObjectDelete("HLINE_SHORTII");
         inLimitWindow1 = false;
        }
      else
        {
         inLimitWindow1 = true;
        }
     }
   if(inLimitWindow1)
     {
      if(On_top_of_this_price_not_Buy_first_order!=0.0)
        {
         ObjectCreate(0,"HLINE_LONG",OBJ_HLINE,0,0,On_top_of_this_price_not_Buy_first_order);
         ObjectSet("HLINE_LONG",OBJPROP_STYLE,0.0);
         ObjectSet("HLINE_LONG",OBJPROP_COLOR,10025880.0);
        }
      if(On_under_of_this_price_not_Sell_first_order!=0.0)
        {
         ObjectCreate(0,"HLINE_SHORT",OBJ_HLINE,0,0,On_under_of_this_price_not_Sell_first_order);
         ObjectSet("HLINE_SHORT",OBJPROP_STYLE,0.0);
         ObjectSet("HLINE_SHORT",OBJPROP_COLOR,16711935.0);
        }
      if(On_top_of_this_price_not_Buy_order!=0.0)
        {
         ObjectCreate(0,"HLINE_LONGII",OBJ_HLINE,0,0,On_top_of_this_price_not_Buy_order);
         ObjectSet("HLINE_LONGII",OBJPROP_STYLE,2.0);
         ObjectSet("HLINE_LONGII",OBJPROP_COLOR,10025880.0);
        }
      if(On_under_of_this_price_not_Sell_order!=0.0)
        {
         ObjectCreate(0,"HLINE_SHORTII",OBJ_HLINE,0,0,On_under_of_this_price_not_Sell_order);
         ObjectSet("HLINE_SHORTII",OBJPROP_STYLE,2.0);
         ObjectSet("HLINE_SHORTII",OBJPROP_COLOR,16711935.0);
        }
     }
   orderOpenPrice = 0.0 ;
   sellProfit = 0.0 ;
   buyProfit = 0.0 ;
   buyTotalLots = 0.0 ;
   sellTotalLots = 0.0 ;
   orderLots = 0.0 ;
   buyCount = 0 ;
   sellCount = 0 ;
   buyStopCount = 0 ;
   sellStopCount = 0 ;
   orderType = 0 ;
   buyStopTicket = 0 ;
   sellStopTicket = 0 ;
   highestBuyPrice = 0.0 ;
   lowestBuyPrice = 0.0 ;
   highestSellPrice = 0.0 ;
   lowestSellPrice = 0.0 ;
   buyStopPrice = 0.0 ;
   sellStopPrice = 0.0 ;
   sellWeightedSum = 0.0 ;
   buyWeightedSum = 0.0 ;
   buyAvgPrice = 0.0 ;
   sellAvgPrice = 0.0 ;
   newOrderPrice = 0.0 ;
   newOrderLots = 0.0 ;
   loopIdx = 0 ;
   spreadPoints = 0.0 ;
   leverage = 0.0 ;
   profitDiff = 0.0 ;
   do33 = 0.0 ;
   useSecondParam = false ;

   for(loopIdx = 0 ; loopIdx < OrdersTotal() ; loopIdx = loopIdx + 1)
     {
      if(!(OrderSelect(loopIdx,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || Magic != OrderMagicNumber())
         continue;
      orderType = OrderType() ;
      orderLots = OrderLots() ;
      orderOpenPrice = NormalizeDouble(OrderOpenPrice(),Digits()) ;
      if(orderType == 4)
        {
         buyStopCount = buyStopCount + 1;
         if((highestBuyPrice<orderOpenPrice || highestBuyPrice==0.0))
           {
            highestBuyPrice = orderOpenPrice ;
           }
         buyStopTicket = OrderTicket() ;
         buyStopPrice = orderOpenPrice ;
        }
      if(orderType == 5)
        {
         sellStopCount = sellStopCount + 1;
         if((lowestSellPrice>orderOpenPrice || lowestSellPrice==0.0))
           {
            lowestSellPrice = orderOpenPrice ;
           }
         sellStopTicket = OrderTicket() ;
         sellStopPrice = orderOpenPrice ;
        }
      if(orderType == 0)
        {
         buyCount = buyCount + 1;
         buyTotalLots = buyTotalLots + orderLots ;
         buyWeightedSum = orderOpenPrice * orderLots + buyWeightedSum ;
         if((highestBuyPrice<orderOpenPrice || highestBuyPrice==0.0))
           {
            highestBuyPrice = orderOpenPrice ;
           }
         if((lowestBuyPrice>orderOpenPrice || lowestBuyPrice==0.0))
           {
            lowestBuyPrice = orderOpenPrice ;
           }
         buyProfit = OrderProfit() + OrderSwap() + OrderCommission() + buyProfit ;
        }
      if(orderType != 1)
         continue;
      sellCount = sellCount + 1;
      sellTotalLots = sellTotalLots + orderLots ;
      sellWeightedSum = orderOpenPrice * orderLots + sellWeightedSum ;
      if((lowestSellPrice>orderOpenPrice || lowestSellPrice==0.0))
        {
         lowestSellPrice = orderOpenPrice ;
        }
      if((highestSellPrice<orderOpenPrice || highestSellPrice==0.0))
        {
         highestSellPrice = orderOpenPrice ;
        }
      sellProfit = OrderProfit() + OrderSwap() + OrderCommission() + sellProfit ;
     }
   if(buyProfit>0.0)
     {
      ObjectSetInteger(0,g_btnBuyName,OBJPROP_BGCOLOR,17919);
     }
   else
     {
      ObjectSetInteger(0,g_btnBuyName,OBJPROP_BGCOLOR,6908265);
     }
   if(sellProfit>0.0)
     {
      ObjectSetInteger(0,g_btnSellName,OBJPROP_BGCOLOR,17919);
     }
   else
     {
      ObjectSetInteger(0,g_btnSellName,OBJPROP_BGCOLOR,6908265);
     }
   if(buyProfit + sellProfit>0.0)
     {
      ObjectSetInteger(0,g_btnCloseName,OBJPROP_BGCOLOR,17919);
     }
   else
     {
      ObjectSetInteger(0,g_btnCloseName,OBJPROP_BGCOLOR,6908265);
     }
   if(buyTotalLots>0.0 && sellTotalLots / buyTotalLots>3.0 && sellTotalLots - buyTotalLots>0.2)
     {
      g_sellHeavy = true ;
     }
   else
     {
      g_sellHeavy = false ;
     }
   if(sellTotalLots>0.0 && buyTotalLots / sellTotalLots>3.0 && buyTotalLots - sellTotalLots>0.2)
     {
      g_buyHeavy = true ;
     }
   else
     {
      g_buyHeavy = false ;
     }
   highRange = 0.0 ;
   highRangePoints = 0.0 ;
   lowRange = 0.0 ;
   lowRangePoints = 0.0 ;
   highRange = iHigh(Symbol(),g_timeframe,0) - iLow(Symbol(),g_timeframe,5) ;
   lowRange = iLow(Symbol(),g_timeframe,0) - iHigh(Symbol(),g_timeframe,5) ;
   highRangePoints = int(highRange / Point()) ;
   lowRangePoints = MathAbs(lowRange / Point()) ;
   if((AccountLeverage() < Leverage || IsTradeAllowed() == false || IsExpertEnabled() == false || IsStopped() || buyCount + sellCount >= Totals || MarketInfo(Symbol(),13)>MaxSpread || (g_maxVolatility != 0 && highRangePoints>=g_maxVolatility) || (g_maxVolatility != 0 && lowRangePoints>=g_maxVolatility)))
     {
      g_allow_buy = false ;
      g_allow_sell = false ;
      fontStr1 = "Arial";
      stopMsg1 = "This EA has stop work ! ";
      if(ObjectFind("Stop") == -1)
        {
         ObjectCreate("Stop",OBJ_LABEL,0,0,0.0,0,0.0,0,0.0);
         ObjectSet("Stop",OBJPROP_CORNER,g_labelCorner);
         ObjectSet("Stop",OBJPROP_XDISTANCE,g_labelX);
         ObjectSet("Stop",OBJPROP_YDISTANCE,g_labelY + 30);
        }
      ObjectSetText("Stop",stopMsg1,g_fontSize,fontStr1,g_colorDimGray);
     }
   else
     {
      g_allow_buy = true ;
      g_allow_sell = true ;
      fontStr2 = "Arial";
      stopMsg2 = "";
      if(ObjectFind("Stop") == -1)
        {
         ObjectCreate("Stop",OBJ_LABEL,0,0,0.0,0,0.0,0,0.0);
         ObjectSet("Stop",OBJPROP_CORNER,g_labelCorner);
         ObjectSet("Stop",OBJPROP_XDISTANCE,g_labelX);
         ObjectSet("Stop",OBJPROP_YDISTANCE,g_labelY + 30);
        }
      ObjectSetText("Stop",stopMsg2,g_fontSize,fontStr2,g_colorDimGray);
     }
   checkTime2 = 0;
   if(IsTesting())
     {
      checkTime2 = TimeCurrent();
     }
   else
     {
      checkTime2 = TimeLocal();
     }
   g_eaStartTime = StringToTime(StringConcatenate(TimeYear(checkTime2),".",TimeMonth(checkTime2),".",TimeDay(checkTime2)," ",EA_StartTime)) ;
   g_eaStopTime = StringToTime(StringConcatenate(TimeYear(checkTime2),".",TimeMonth(checkTime2),".",TimeDay(checkTime2)," ",EA_StopTime)) ;
   if(g_eaStartTime <  g_eaStopTime && (checkTime2 < g_eaStartTime || checkTime2 > g_eaStopTime))
     {
      inEaWindow1 = false;
     }
   else
     {
      if(g_eaStartTime > g_eaStopTime && checkTime2 <  g_eaStartTime && checkTime2 > g_eaStopTime)
        {
         inEaWindow1 = false;
        }
      else
        {
         inEaWindow1 = true;
        }
     }
   if(!(inEaWindow1))
     {
      fontStr3 = "Arial";
      stopMsg3 = "Time out,This EA has stop open order";
      if(ObjectFind("Stop") == -1)
        {
         ObjectCreate("Stop",OBJ_LABEL,0,0,0.0,0,0.0,0,0.0);
         ObjectSet("Stop",OBJPROP_CORNER,g_labelCorner);
         ObjectSet("Stop",OBJPROP_XDISTANCE,g_labelX);
         ObjectSet("Stop",OBJPROP_YDISTANCE,g_labelY + 30);
        }
      ObjectSetText("Stop",stopMsg3,g_fontSize,fontStr3,g_colorDimGray);
     }
   if(g_eaName  !=  WindowExpertName())
     {
      g_allow_buy = false ;
      g_allow_sell = false ;
      fontStr4 = "Arial";
      stopMsg4 = "This EA has stop work ! ";
      if(ObjectFind("Stop") == -1)
        {
         ObjectCreate("Stop",OBJ_LABEL,0,0,0.0,0,0.0,0,0.0);
         ObjectSet("Stop",OBJPROP_CORNER,g_labelCorner);
         ObjectSet("Stop",OBJPROP_XDISTANCE,g_labelX);
         ObjectSet("Stop",OBJPROP_YDISTANCE,g_labelY + 30);
        }
      ObjectSetText("Stop",stopMsg4,g_fontSize,fontStr4,g_colorDimGray);
     }
   if(TimeCurrent() <  g_nextTradeTime)
     {
      checkTime3 = 0;
      if(IsTesting())
        {
         checkTime3 = TimeCurrent();
        }
      else
        {
         checkTime3 = TimeLocal();
        }
      g_eaStartTime = StringToTime(StringConcatenate(TimeYear(checkTime3),".",TimeMonth(checkTime3),".",TimeDay(checkTime3)," ",EA_StartTime)) ;
      g_eaStopTime = StringToTime(StringConcatenate(TimeYear(checkTime3),".",TimeMonth(checkTime3),".",TimeDay(checkTime3)," ",EA_StopTime)) ;
      if(g_eaStartTime <  g_eaStopTime && (checkTime3 < g_eaStartTime || checkTime3 > g_eaStopTime))
        {
         inEaWindow2 = false;
        }
      else
        {
         if(g_eaStartTime > g_eaStopTime && checkTime3 <  g_eaStartTime && checkTime3 > g_eaStopTime)
           {
            inEaWindow2 = false;
           }
         else
           {
            inEaWindow2 = true;
           }
        }
      if(inEaWindow2)
        {
         g_allow_buy = false ;
         g_allow_sell = false ;
         fontStr5 = "Arial";
         stopMsg5 = "This EA has stop work " + string(NextTime) + "second! ";
         if(ObjectFind("Stop") == -1)
           {
            ObjectCreate("Stop",OBJ_LABEL,0,0,0.0,0,0.0,0,0.0);
            ObjectSet("Stop",OBJPROP_CORNER,g_labelCorner);
            ObjectSet("Stop",OBJPROP_XDISTANCE,g_labelX);
            ObjectSet("Stop",OBJPROP_YDISTANCE,g_labelY + 30);
           }
         ObjectSetText("Stop",stopMsg5,g_fontSize,fontStr5,g_colorDimGray);
        }
     }
   if(Over == 1 && buyCount == 0)
     {
      g_allow_buy = false ;
     }
   if(Over == 1 && sellCount == 0)
     {
      g_allow_sell = false ;
     }
   ObjectDelete("SLb");
   ObjectDelete("SLs");
   if(buyCount > 0)
     {
      buyAvgPrice = NormalizeDouble(buyWeightedSum / buyTotalLots,Digits()) ;
      ObjectCreate("SLb",OBJ_ARROW,0,Time[0],buyAvgPrice,0,0.0,0,0.0);
      ObjectSet("SLb",OBJPROP_ARROWCODE,6.0);
      ObjectSet("SLb",OBJPROP_COLOR,g_colorBlue);
     }
   if(sellCount > 0)
     {
      sellAvgPrice = NormalizeDouble(sellWeightedSum / sellTotalLots,Digits()) ;
      ObjectCreate("SLs",OBJ_ARROW,0,Time[0],sellAvgPrice,0,0.0,0,0.0);
      ObjectSet("SLs",OBJPROP_ARROWCODE,6.0);
      ObjectSet("SLs",OBJPROP_COLOR,g_colorRed);
     }
   ObjectSetText("Char.op",CharToString(74),g_fontSize + 2,"Wingdings",Red);
   totalProfit = buyProfit + sellProfit ;
   if(Over == 1 && totalProfit>=CloseAll)
     {
      g_allow_buy = false ;
      g_allow_sell = false ;
      sortKey1 = "Ticket";
      sortDir1 = "sell";
      maxTicket1 = 0;
      maxLots1 = 0.0;
      for(orderIdx1 = OrdersTotal() - 1 ; orderIdx1 >= 0 ; orderIdx1 = orderIdx1 - 1)
        {
         if(!(OrderSelect(orderIdx1,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
            continue;

         if(sortDir1 == "buy" && OrderType() == 0 && OrderTicket() > maxTicket1)
           {
            OrderOpenTime();
            OrderOpenPrice();
            maxLots1 = OrderLots();
            maxTicket1 = OrderTicket();
           }
         if(sortDir1 != "sell" || OrderType() != 1 || OrderTicket() <= maxTicket1)
            continue;
         OrderOpenTime();
         OrderOpenPrice();
         maxLots1 = OrderLots();
         maxTicket1 = OrderTicket();
        }
      if(sortKey1 == "Ticket")
        {
         sortResult1 = maxTicket1;
        }
      else
        {
         if(sortKey1 == "Lots")
           {
            sortResult1 = maxLots1;
           }
         else
           {
            sortResult1 = 0.0;
           }
        }
      resultTicket1 = (int)sortResult1;
      sortKey2 = "Ticket";
      sortDir2 = "buy";
      maxTicket2 = 0;
      maxLots2 = 0.0;
      for(orderIdx2 = OrdersTotal() - 1 ; orderIdx2 >= 0 ; orderIdx2 = orderIdx2 - 1)
        {
         if(!(OrderSelect(orderIdx2,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
            continue;

         if(sortDir2 == "buy" && OrderType() == 0 && OrderTicket() > maxTicket2)
           {
            OrderOpenTime();
            OrderOpenPrice();
            maxLots2 = OrderLots();
            maxTicket2 = OrderTicket();
           }
         if(sortDir2 != "sell" || OrderType() != 1 || OrderTicket() <= maxTicket2)
            continue;
         OrderOpenTime();
         OrderOpenPrice();
         maxLots2 = OrderLots();
         maxTicket2 = OrderTicket();
        }
      if(sortKey2 == "Ticket")
        {
         sortResult2 = maxTicket2;
        }
      else
        {
         if(sortKey2 == "Lots")
           {
            sortResult2 = maxLots2;
           }
         else
           {
            sortResult2 = 0.0;
           }
        }

      if(对冲平仓开关)
         if(OrderCloseBy((int)sortResult2,resultTicket1,0xFFFFFFFF))
           {
            do
              {
               trailStr_b1 = "Ticket";
               trailStr_b2 = "sell";
               tmpInt_32 = 0;
               tmpDbl_33 = 0.0;
               for(tmpInt_34 = OrdersTotal() - 1 ; tmpInt_34 >= 0 ; tmpInt_34 = tmpInt_34 - 1)
                 {
                  if(!(OrderSelect(tmpInt_34,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
                     continue;

                  if(trailStr_b2 == "buy" && OrderType() == 0 && OrderTicket() > tmpInt_32)
                    {
                     OrderOpenTime();
                     OrderOpenPrice();
                     tmpDbl_33 = OrderLots();
                     tmpInt_32 = OrderTicket();
                    }
                  if(trailStr_b2 != "sell" || OrderType() != 1 || OrderTicket() <= tmpInt_32)
                     continue;
                  OrderOpenTime();
                  OrderOpenPrice();
                  tmpDbl_33 = OrderLots();
                  tmpInt_32 = OrderTicket();
                 }
               if(trailStr_b1 == "Ticket")
                 {
                  tmpDbl_35 = tmpInt_32;
                 }
               else
                 {
                  if(trailStr_b1 == "Lots")
                    {
                     tmpDbl_35 = tmpDbl_33;
                    }
                  else
                    {
                     tmpDbl_35 = 0.0;
                    }
                 }
               tmpInt_36 = (int)tmpDbl_35;
               trailStr_s1 = "Ticket";
               trailStr_s2 = "buy";
               tmpInt_39 = 0;
               tmpDbl_40 = 0.0;
               for(tmpInt_41 = OrdersTotal() - 1 ; tmpInt_41 >= 0 ; tmpInt_41 = tmpInt_41 - 1)
                 {
                  if(!(OrderSelect(tmpInt_41,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
                     continue;

                  if(trailStr_s2 == "buy" && OrderType() == 0 && OrderTicket() > tmpInt_39)
                    {
                     OrderOpenTime();
                     OrderOpenPrice();
                     tmpDbl_40 = OrderLots();
                     tmpInt_39 = OrderTicket();
                    }
                  if(trailStr_s2 != "sell" || OrderType() != 1 || OrderTicket() <= tmpInt_39)
                     continue;
                  OrderOpenTime();
                  OrderOpenPrice();
                  tmpDbl_40 = OrderLots();
                  tmpInt_39 = OrderTicket();
                 }
               if(trailStr_s1 == "Ticket")
                 {
                  tmpDbl_42 = tmpInt_39;
                 }
               else
                 {
                  if(trailStr_s1 == "Lots")
                    {
                     tmpDbl_42 = tmpDbl_40;
                    }
                  else
                    {
                     tmpDbl_42 = 0.0;
                    }
                 }
              }
            while(OrderCloseBy((int)tmpDbl_42,tmpInt_36,0xFFFFFFFF));
           }
      CloseAllOrders(0);
      if(ObjectFind(g_spreadLabel) <  0)
        {
         ObjectCreate(g_spreadLabel,OBJ_LABEL,0,0,0.0,0,0.0,0,0.0);
         ObjectSet(g_spreadLabel,OBJPROP_CORNER,1.0);
         ObjectSet(g_spreadLabel,OBJPROP_YDISTANCE,260.0);
         ObjectSet(g_spreadLabel,OBJPROP_XDISTANCE,10.0);
         ObjectSetText(g_spreadLabel,"Spread: " + DoubleToString((Ask - Bid) / g_lotCoeff,1) + " pips",13,"Arial",g_colorDimGray);
        }
      ObjectSetText(g_spreadLabel,"Spread: " + DoubleToString((Ask - Bid) / g_lotCoeff,1) + " pips",0,NULL,0xFFFFFFFF);
      WindowRedraw();
      WindowRedraw();
     }
   if(Over == false)
     {
      if(HomeopathyCloseAll == true)
        {
         trailStr_s3 = "buy";
         tmpInt_44 = 0;
         for(tmpInt_45 = OrdersTotal() - 1 ; tmpInt_45 >= 0 ; tmpInt_45=tmpInt_45 - 1)
           {
            if(!(OrderSelect(tmpInt_45,SELECT_BY_POS,MODE_TRADES)) || Symbol() != OrderSymbol() || OrderMagicNumber() != Magic || OrderComment() != "QQ已移除")
               continue;

            if(trailStr_s3 == "buy" && OrderType() == 0)
              {
               tmpInt_44 = tmpInt_44 + 1;
              }
            if(trailStr_s3 != "sell" || OrderType() != 1)
               continue;
            tmpInt_44 = tmpInt_44 + 1;
           }
         if(tmpInt_44 <  1)
           {
            trailStr_s4 = "sell";
            tmpInt_47 = 0;
            for(tmpInt_48 = OrdersTotal() - 1 ; tmpInt_48 >= 0 ; tmpInt_48=tmpInt_48 - 1)
              {
               if(!(OrderSelect(tmpInt_48,SELECT_BY_POS,MODE_TRADES)) || Symbol() != OrderSymbol() || OrderMagicNumber() != Magic || OrderComment() != "QQ已移除")
                  continue;

               if(trailStr_s4 == "buy" && OrderType() == 0)
                 {
                  tmpInt_47 = tmpInt_47 + 1;
                 }
               if(trailStr_s4 != "sell" || OrderType() != 1)
                  continue;
               tmpInt_47 = tmpInt_47 + 1;
              }

           }
        }
      if((tmpInt_47 < 1 || HomeopathyCloseAll == false) && buyProfit>MaxLossCloseAll && sellProfit>MaxLossCloseAll)
        {
         ObjectSetText("Char.op",CharToString(251),g_fontSize + 2,"Wingdings",Silver);
         if(((Profit == true && buyProfit>StopProfit * buyCount) || (Profit == false && buyProfit>StopProfit)))
           {
            Print("Buy Profit ",buyProfit);
            CloseAllOrders(1);
            return(0);
           }
         if(((Profit == true && sellProfit>StopProfit * sellCount) || (Profit == false && sellProfit>StopProfit)))
           {
            Print("Sell Profit ",sellProfit);
            CloseAllOrders(-1);
            return(0);
           }
        }
      if(HomeopathyCloseAll == true)
        {
         trailStr_s5 = "buy";
         tmpInt_50 = 0;
         for(tmpInt_51 = OrdersTotal() - 1 ; tmpInt_51 >= 0 ; tmpInt_51=tmpInt_51 - 1)
           {
            if(!(OrderSelect(tmpInt_51,SELECT_BY_POS,MODE_TRADES)) || Symbol() != OrderSymbol() || OrderMagicNumber() != Magic || OrderComment() != "QQ已移除")
               continue;

            if(trailStr_s5 == "buy" && OrderType() == 0)
              {
               tmpInt_50 = tmpInt_50 + 1;
              }
            if(trailStr_s5 != "sell" || OrderType() != 1)
               continue;
            tmpInt_50 = tmpInt_50 + 1;
           }

         trailStr_s6 = "sell";
         tmpInt_53 = 0;
         for(tmpInt_54 = OrdersTotal() - 1 ; tmpInt_54 >= 0 ; tmpInt_54=tmpInt_54 - 1)
           {
            if(!(OrderSelect(tmpInt_54,SELECT_BY_POS,MODE_TRADES)) || Symbol() != OrderSymbol() || OrderMagicNumber() != Magic || OrderComment() != "QQ已移除")
               continue;

            if(trailStr_s6 == "buy" && OrderType() == 0)
              {
               tmpInt_53 = tmpInt_53 + 1;
              }
            if(trailStr_s6 != "sell" || OrderType() != 1)
               continue;
            tmpInt_53 = tmpInt_53 + 1;
           }
         if((tmpInt_50 > 0 || tmpInt_53 > 0) && buyProfit + sellProfit>=CloseAll)
           {
            trailStr_s7 = "Ticket";
            trailStr_s8 = "sell";
            tmpInt_57 = 0;
            trailVal_b1 = 0.0;
            for(trailIdx_b1 = OrdersTotal() - 1 ; trailIdx_b1 >= 0 ; trailIdx_b1 = trailIdx_b1 - 1)
              {
               if(!(OrderSelect(trailIdx_b1,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
                  continue;

               if(trailStr_s8 == "buy" && OrderType() == 0 && OrderTicket() > tmpInt_57)
                 {
                  OrderOpenTime();
                  OrderOpenPrice();
                  trailVal_b1 = OrderLots();
                  tmpInt_57 = OrderTicket();
                 }
               if(trailStr_s8 != "sell" || OrderType() != 1 || OrderTicket() <= tmpInt_57)
                  continue;
               OrderOpenTime();
               OrderOpenPrice();
               trailVal_b1 = OrderLots();
               tmpInt_57 = OrderTicket();
              }
            if(trailStr_s7 == "Ticket")
              {
               trailVal_b2 = tmpInt_57;
              }
            else
              {
               if(trailStr_s7 == "Lots")
                 {
                  trailVal_b2 = trailVal_b1;
                 }
               else
                 {
                  trailVal_b2 = 0.0;
                 }
              }
            trailIdx_b2 = (int)trailVal_b2;
            trailStr_s9 = "Ticket";
            trailStr_s10 = "buy";
            tmpInt_64 = 0;
            trailVal_b3 = 0.0;
            for(trailIdx_b3 = OrdersTotal() - 1 ; trailIdx_b3 >= 0 ; trailIdx_b3 = trailIdx_b3 - 1)
              {
               if(!(OrderSelect(trailIdx_b3,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
                  continue;

               if(trailStr_s10 == "buy" && OrderType() == 0 && OrderTicket() > tmpInt_64)
                 {
                  OrderOpenTime();
                  OrderOpenPrice();
                  trailVal_b3 = OrderLots();
                  tmpInt_64 = OrderTicket();
                 }
               if(trailStr_s10 != "sell" || OrderType() != 1 || OrderTicket() <= tmpInt_64)
                  continue;
               OrderOpenTime();
               OrderOpenPrice();
               trailVal_b3 = OrderLots();
               tmpInt_64 = OrderTicket();
              }
            if(trailStr_s9 == "Ticket")
              {
               trailVal_b4 = tmpInt_64;
              }
            else
              {
               if(trailStr_s9 == "Lots")
                 {
                  trailVal_b4 = trailVal_b3;
                 }
               else
                 {
                  trailVal_b4 = 0.0;
                 }
              }

            if(对冲平仓开关)
               if(OrderCloseBy((int)trailVal_b4,trailIdx_b2,0xFFFFFFFF))
                 {
                  do
                    {
                     trailStr_s11 = "Ticket";
                     trailStr_s12 = "sell";
                     trailIdx_b4 = 0;
                     trailVal_b5 = 0.0;
                     for(trailIdx_b5 = OrdersTotal() - 1 ; trailIdx_b5 >= 0 ; trailIdx_b5 = trailIdx_b5 - 1)
                       {
                        if(!(OrderSelect(trailIdx_b5,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
                           continue;

                        if(trailStr_s12 == "buy" && OrderType() == 0 && OrderTicket() > trailIdx_b4)
                          {
                           OrderOpenTime();
                           OrderOpenPrice();
                           trailVal_b5 = OrderLots();
                           trailIdx_b4 = OrderTicket();
                          }
                        if(trailStr_s12 != "sell" || OrderType() != 1 || OrderTicket() <= trailIdx_b4)
                           continue;
                        OrderOpenTime();
                        OrderOpenPrice();
                        trailVal_b5 = OrderLots();
                        trailIdx_b4 = OrderTicket();
                       }
                     if(trailStr_s11 == "Ticket")
                       {
                        trailVal_b6 = trailIdx_b4;
                       }
                     else
                       {
                        if(trailStr_s11 == "Lots")
                          {
                           trailVal_b6 = trailVal_b5;
                          }
                        else
                          {
                           trailVal_b6 = 0.0;
                          }
                       }
                     trailIdx_b6 = (int)trailVal_b6;
                     trailStr_s13 = "Ticket";
                     trailStr_s14 = "buy";
                     trailIdx_b7 = 0;
                     trailVal_b7 = 0.0;
                     for(trailIdx_b8 = OrdersTotal() - 1 ; trailIdx_b8 >= 0 ; trailIdx_b8 = trailIdx_b8 - 1)
                       {
                        if(!(OrderSelect(trailIdx_b8,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
                           continue;

                        if(trailStr_s14 == "buy" && OrderType() == 0 && OrderTicket() > trailIdx_b7)
                          {
                           OrderOpenTime();
                           OrderOpenPrice();
                           trailVal_b7 = OrderLots();
                           trailIdx_b7 = OrderTicket();
                          }
                        if(trailStr_s14 != "sell" || OrderType() != 1 || OrderTicket() <= trailIdx_b7)
                           continue;
                        OrderOpenTime();
                        OrderOpenPrice();
                        trailVal_b7 = OrderLots();
                        trailIdx_b7 = OrderTicket();
                       }
                     if(trailStr_s13 == "Ticket")
                       {
                        trailVal_b8 = trailIdx_b7;
                       }
                     else
                       {
                        if(trailStr_s13 == "Lots")
                          {
                           trailVal_b8 = trailVal_b7;
                          }
                        else
                          {
                           trailVal_b8 = 0.0;
                          }
                       }
                    }
                  while(OrderCloseBy((int)trailVal_b8,trailIdx_b6,0xFFFFFFFF));
                 }
            CloseAllOrders(0);
            if(NextTime > 0)
              {
               g_nextTradeTime=TimeCurrent() + NextTime;
              }
            return(0);
           }
        }
      if(buyProfit + sellProfit>=CloseAll && (buyProfit<=MaxLossCloseAll || sellProfit<=MaxLossCloseAll))
        {
         trailStr_s15 = "Ticket";
         trailStr_s16 = "sell";
         trailIdx_b9 = 0;
         trailVal_b9 = 0.0;
         for(trailIdx_b10 = OrdersTotal() - 1 ; trailIdx_b10 >= 0 ; trailIdx_b10 = trailIdx_b10 - 1)
           {
            if(!(OrderSelect(trailIdx_b10,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
               continue;

            if(trailStr_s16 == "buy" && OrderType() == 0 && OrderTicket() > trailIdx_b9)
              {
               OrderOpenTime();
               OrderOpenPrice();
               trailVal_b9 = OrderLots();
               trailIdx_b9 = OrderTicket();
              }
            if(trailStr_s16 != "sell" || OrderType() != 1 || OrderTicket() <= trailIdx_b9)
               continue;
            OrderOpenTime();
            OrderOpenPrice();
            trailVal_b9 = OrderLots();
            trailIdx_b9 = OrderTicket();
           }
         if(trailStr_s15 == "Ticket")
           {
            trailVal_b10 = trailIdx_b9;
           }
         else
           {
            if(trailStr_s15 == "Lots")
              {
               trailVal_b10 = trailVal_b9;
              }
            else
              {
               trailVal_b10 = 0.0;
              }
           }
         trailIdx_b11 = (int)trailVal_b10;
         trailStr_s17 = "Ticket";
         trailStr_s18 = "buy";
         trailIdx_b12 = 0;
         trailVal_b11 = 0.0;
         for(trailIdx_b13 = OrdersTotal() - 1 ; trailIdx_b13 >= 0 ; trailIdx_b13 = trailIdx_b13 - 1)
           {
            if(!(OrderSelect(trailIdx_b13,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
               continue;

            if(trailStr_s18 == "buy" && OrderType() == 0 && OrderTicket() > trailIdx_b12)
              {
               OrderOpenTime();
               OrderOpenPrice();
               trailVal_b11 = OrderLots();
               trailIdx_b12 = OrderTicket();
              }
            if(trailStr_s18 != "sell" || OrderType() != 1 || OrderTicket() <= trailIdx_b12)
               continue;
            OrderOpenTime();
            OrderOpenPrice();
            trailVal_b11 = OrderLots();
            trailIdx_b12 = OrderTicket();
           }
         if(trailStr_s17 == "Ticket")
           {
            trailVal_b12 = trailIdx_b12;
           }
         else
           {
            if(trailStr_s17 == "Lots")
              {
               trailVal_b12 = trailVal_b11;
              }
            else
              {
               trailVal_b12 = 0.0;
              }
           }

         if(对冲平仓开关)
            if(OrderCloseBy((int)trailVal_b12,trailIdx_b11,0xFFFFFFFF))
              {
               do
                 {
                  trailStr_s19 = "Ticket";
                  trailStr_s20 = "sell";
                  trailIdx_b14 = 0;
                  trailVal_b13 = 0.0;
                  for(trailIdx_b15 = OrdersTotal() - 1 ; trailIdx_b15 >= 0 ; trailIdx_b15 = trailIdx_b15 - 1)
                    {
                     if(!(OrderSelect(trailIdx_b15,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
                        continue;

                     if(trailStr_s20 == "buy" && OrderType() == 0 && OrderTicket() > trailIdx_b14)
                       {
                        OrderOpenTime();
                        OrderOpenPrice();
                        trailVal_b13 = OrderLots();
                        trailIdx_b14 = OrderTicket();
                       }
                     if(trailStr_s20 != "sell" || OrderType() != 1 || OrderTicket() <= trailIdx_b14)
                        continue;
                     OrderOpenTime();
                     OrderOpenPrice();
                     trailVal_b13 = OrderLots();
                     trailIdx_b14 = OrderTicket();
                    }
                  if(trailStr_s19 == "Ticket")
                    {
                     trailVal_b14 = trailIdx_b14;
                    }
                  else
                    {
                     if(trailStr_s19 == "Lots")
                       {
                        trailVal_b14 = trailVal_b13;
                       }
                     else
                       {
                        trailVal_b14 = 0.0;
                       }
                    }
                  trailIdx_b16 = (int)trailVal_b14;
                  trailStr_s21 = "Ticket";
                  trailStr_s22 = "buy";
                  trailIdx_s1 = 0;
                  trailVal_s1 = 0.0;
                  for(trailIdx_s2 = OrdersTotal() - 1 ; trailIdx_s2 >= 0 ; trailIdx_s2 = trailIdx_s2 - 1)
                    {
                     if(!(OrderSelect(trailIdx_s2,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
                        continue;

                     if(trailStr_s22 == "buy" && OrderType() == 0 && OrderTicket() > trailIdx_s1)
                       {
                        OrderOpenTime();
                        OrderOpenPrice();
                        trailVal_s1 = OrderLots();
                        trailIdx_s1 = OrderTicket();
                       }
                     if(trailStr_s22 != "sell" || OrderType() != 1 || OrderTicket() <= trailIdx_s1)
                        continue;
                     OrderOpenTime();
                     OrderOpenPrice();
                     trailVal_s1 = OrderLots();
                     trailIdx_s1 = OrderTicket();
                    }
                  if(trailStr_s21 == "Ticket")
                    {
                     trailVal_s2 = trailIdx_s1;
                    }
                  else
                    {
                     if(trailStr_s21 == "Lots")
                       {
                        trailVal_s2 = trailVal_s1;
                       }
                     else
                       {
                        trailVal_s2 = 0.0;
                       }
                    }
                 }
               while(OrderCloseBy((int)trailVal_s2,trailIdx_b16,0xFFFFFFFF));
              }
         CloseAllOrders(0);
         if(NextTime > 0)
           {
            g_nextTradeTime=TimeCurrent() + NextTime;
           }
         return(0);
        }
     }
   if(StopLoss!=0.0 && buyProfit + sellProfit<=StopLoss)
     {
      Print("Buy Loss ",buyProfit);
      Print("Sell Loss ",sellProfit);
      CloseAllOrders(0);
      if(NextTime > 0)
        {
         g_nextTradeTime=TimeCurrent() + NextTime;
        }
      return(0);
     }

   if(buyProfit<=MaxLoss)
     {
      Comment("Buy");
      ObjectSetText("Char.b",CharToString(225) + CharToString(251),g_fontSize,"Wingdings",Red);
     }
   else
     {
      ObjectSetText("Char.b",CharToString(233),g_fontSize,"Wingdings",Lime);
     }
   if(sellProfit<=MaxLoss)
     {
      Comment("Sell");
      ObjectSetText("Char.s",CharToString(226) + CharToString(251),g_fontSize,"Wingdings",Red);
     }
   else
     {
      ObjectSetText("Char.s",CharToString(234),g_fontSize,"Wingdings",Lime);
     }
   if(iOpen(Symbol(),1,0)>iOpen(Symbol(),1,1))
     {
      g_arrowColor = g_colorBlueInt ;
     }
   if(iOpen(Symbol(),1,0)<iOpen(Symbol(),1,1))
     {
      g_arrowColor = g_colorWhiteInt ;
     }
   if(iClose(Symbol(),1,0)>iClose(Symbol(),1,1))
     {
      g_arrowColor = g_colorYellowInt ;
     }
   if(iClose(Symbol(),1,0)<iClose(Symbol(),1,1))
     {
      g_arrowColor = g_colorGrayInt ;
     }
   spreadPoints = (Ask - Bid) / Point() ;
   spreadText = Symbol() + ": " + DoubleToString(spreadPoints,1) + " pips" ;
   ObjectCreate(g_spreadLabel,OBJ_LABEL,0,0,0.0,0,0.0,0,0.0);
   ObjectSet(g_spreadLabel,OBJPROP_CORNER,1.0);
   ObjectSet(g_spreadLabel,OBJPROP_YDISTANCE,340.0);
   ObjectSet(g_spreadLabel,OBJPROP_XDISTANCE,10.0);
   ObjectSetText(g_spreadLabel,spreadText,13,"Arial",g_colorDimGray);
   leverage = AccountLeverage() ;
   leverageText = "Lever: " + DoubleToString(leverage,0) + " multi" ;
   ObjectCreate(g_leverLabel,OBJ_LABEL,0,0,0.0,0,0.0,0,0.0);
   ObjectSet(g_leverLabel,OBJPROP_CORNER,1.0);
   ObjectSet(g_leverLabel,OBJPROP_YDISTANCE,320.0);
   ObjectSet(g_leverLabel,OBJPROP_XDISTANCE,10.0);
   ObjectSetText(g_leverLabel,leverageText,13,"Arial",g_colorDimGray);
   if(CloseBuySell == 1)
     {
      profitDiff = SumTopNProfit(0,Magic,1,g_closeProfitN) - SumTopNProfit(0,Magic,2,g_closeLossN) ;
      if(g_buyImbalanceVal<profitDiff)
        {
         g_buyImbalanceVal = profitDiff ;
        }
      if(g_buyImbalanceVal>0.0 && profitDiff>0.0 && g_buyImbalanceVal>0.0)
        {
         profitMode1 = 1;
         magicFilter1 = Magic;
         typeFilter1 = 0;
         maxProfitLots1 = 0.0;
         maxProfit1 = 0.0;
         for(orderIdx3 = OrdersTotal() - 1 ; orderIdx3 >= 0 ; orderIdx3 = orderIdx3 - 1)
           {
            if(!(OrderSelect(orderIdx3,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || (OrderMagicNumber()  !=  magicFilter1 && magicFilter1 != -1) || (OrderType()  !=  typeFilter1 && typeFilter1 != -100))
               continue;

            if(profitMode1 == 1 && maxProfit1<OrderProfit())
              {
               maxProfit1 = OrderProfit();
               maxProfitLots1 = OrderLots();
              }
            if(profitMode1 != 2 || (!(maxProfit1>OrderProfit()) && !(maxProfit1==0.0)))
               continue;
            maxProfit1 = OrderProfit();
            maxProfitLots1 = OrderLots();
           }
         if(buyTotalLots>maxProfitLots1 * 3.0 + sellTotalLots && buyCount > 3)
           {
            CloseProfitLossOrders(0,Magic,g_closeProfitN,1);
            CloseProfitLossOrders(0,Magic,g_closeLossN,2);
            g_buyImbalanceVal = 0.0 ;
            g_sellImbalanceVal = 0.0 ;
           }
        }
      profitDiff = SumTopNProfit(1,Magic,1,g_closeProfitN) - SumTopNProfit(1,Magic,2,g_closeLossN) ;
      if(g_sellImbalanceVal<profitDiff)
        {
         g_sellImbalanceVal = profitDiff ;
        }
      if(g_sellImbalanceVal>0.0 && profitDiff>0.0 && g_sellImbalanceVal>0.0)
        {
         profitMode2 = 1;
         magicFilter2 = Magic;
         typeFilter2 = 1;
         maxProfitLots2 = 0.0;
         maxProfit2 = 0.0;
         for(orderIdx4 = OrdersTotal() - 1 ; orderIdx4 >= 0 ; orderIdx4 = orderIdx4 - 1)
           {
            if(!(OrderSelect(orderIdx4,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || (OrderMagicNumber()  !=  magicFilter2 && magicFilter2 != -1) || (OrderType()  !=  typeFilter2 && typeFilter2 != -100))
               continue;

            if(profitMode2 == 1 && maxProfit2<OrderProfit())
              {
               maxProfit2 = OrderProfit();
               maxProfitLots2 = OrderLots();
              }
            if(profitMode2 != 2 || (!(maxProfit2>OrderProfit()) && !(maxProfit2==0.0)))
               continue;
            maxProfit2 = OrderProfit();
            maxProfitLots2 = OrderLots();
           }
         if(sellTotalLots>maxProfitLots2 * 3.0 + buyTotalLots && sellCount > 3)
           {
            CloseProfitLossOrders(1,Magic,g_closeProfitN,1);
            CloseProfitLossOrders(1,Magic,g_closeLossN,2);
            g_buyImbalanceVal = 0.0 ;
            g_sellImbalanceVal = 0.0 ;
           }
        }
     }
   if(((Money!=0.0 && totalProfit>Money) || Money==0.0))
     {
      useSecondParam = true ;
     }
   if(Money!=0.0 && totalProfit<=Money)
     {
      useSecondParam = false ;
     }

   bool 多三组=false;
   bool 空三组=false;

   if(多空差距大于M使用第三组参数开关)
     {
      if(CountOrders(OP_BUY,Magic,"")>=CountOrders(OP_SELL,Magic,"")+多空差距大于M使用第三组参数)
         多三组=true;
      if(CountOrders(OP_SELL,Magic,"")>=CountOrders(OP_BUY,Magic,"")+多空差距大于M使用第三组参数)
         空三组=true;
     }

   if(((OpenMode == 1 && g_lastBarTime != iTime(NULL,TimeZone,0)) || OpenMode == 2 || OpenMode == 3))
     {
      if(buyStopCount == 0 && buyProfit > -MaxLoss && g_allow_buy)
        {
         if(buyCount == 0)
           {
            newOrderPrice = NormalizeDouble(FirstStep * Point() + Ask,Digits()) ;
           }
         else
           {
            if(useSecondParam&&多三组==false)
              {
               newOrderPrice = NormalizeDouble(MinDistance * Point() + Ask,Digits()) ;
              }
            if(useSecondParam == false && Money!=0.0)
              {
               newOrderPrice = NormalizeDouble(TwoMinDistance * Point() + Ask,Digits()) ;
              }
            if(多三组)
              {
               newOrderPrice = NormalizeDouble(TwoMinDistance3 * Point() + Ask,Digits()) ;
              }
            if(newOrderPrice<NormalizeDouble(lowestBuyPrice - Step * Point(),Digits()) && useSecondParam&&多三组==false)
              {
               newOrderPrice = NormalizeDouble(Step * Point() + Ask,Digits()) ;
              }
            if(newOrderPrice<NormalizeDouble(lowestBuyPrice - TwoStep * Point(),Digits()) && useSecondParam == false && Money!=0.0)
              {
               newOrderPrice = NormalizeDouble(TwoStep * Point() + Ask,Digits()) ;
              }
            if(多三组)
               if(newOrderPrice<NormalizeDouble(lowestBuyPrice - TwoStep3 * Point(),Digits()))
                 {
                  newOrderPrice = NormalizeDouble(TwoStep3 * Point() + Ask,Digits()) ;
                 }
           }
         if((
               buyCount == 0
               || (highestBuyPrice!=0.0 && newOrderPrice>=NormalizeDouble(Step * Point() + highestBuyPrice,Digits()) && g_sellHeavy && useSecondParam&&多三组==false)
               || (highestBuyPrice!=0.0 && newOrderPrice>=NormalizeDouble(TwoStep * Point() + highestBuyPrice,Digits()) && g_sellHeavy && useSecondParam == false && Money!=0.0)
               || (highestBuyPrice!=0.0 && newOrderPrice>=NormalizeDouble(TwoStep3 * Point() + highestBuyPrice,Digits()) && 多三组)

               || (lowestBuyPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestBuyPrice - Step * Point(),Digits()) && useSecondParam&&多三组==false)
               || (lowestBuyPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestBuyPrice - TwoStep * Point(),Digits()) && useSecondParam == false && Money!=0.0)
               || (lowestBuyPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestBuyPrice - TwoStep3 * Point(),Digits()) && 多三组)
               || (Homeopathy && highestBuyPrice!=0.0 && newOrderPrice>=NormalizeDouble(Step * Point() + highestBuyPrice,Digits()) && buyTotalLots==sellTotalLots)))
           {
            if(buyCount == 0)
              {
               newOrderLots = lot ;
              }
            else
              {
               newOrderLots = NormalizeDouble(lot * MathPow(K_Lot,buyCount) + buyCount * PlusLot,DigitsLot) ;
              }
            if(newOrderLots>Maxlot)
              {
               newOrderLots = Maxlot ;
              }
            if(((newOrderLots * 2.0<AccountFreeMargin() / MarketInfo(Symbol(),32) && buyCount > 0) || g_ignoreMargin))
              {
               checkTime_b1 = 0;
               if(IsTesting())
                 {
                  checkTime_b1 = TimeCurrent();
                 }
               else
                 {
                  checkTime_b1 = TimeLocal();
                 }
               g_eaStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_b1),".",TimeMonth(checkTime_b1),".",TimeDay(checkTime_b1)," ",EA_StartTime)) ;
               g_eaStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_b1),".",TimeMonth(checkTime_b1),".",TimeDay(checkTime_b1)," ",EA_StopTime)) ;
               if(g_eaStartTime <  g_eaStopTime && (checkTime_b1 < g_eaStartTime || checkTime_b1 > g_eaStopTime))
                 {
                  inEaWindow_b1 = false;
                 }
               else
                 {
                  if(g_eaStartTime > g_eaStopTime && checkTime_b1 <  g_eaStartTime && checkTime_b1 > g_eaStopTime)
                    {
                     inEaWindow_b1 = false;
                    }
                  else
                    {
                     inEaWindow_b1 = true;
                    }
                 }

               checkTime_b2 = 0;
               if(inEaWindow_b1)
                 {
                  if(IsTesting())
                    {
                     checkTime_b2 = TimeCurrent();
                    }
                  else
                    {
                     checkTime_b2 = TimeLocal();
                    }
                  g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_b2),".",TimeMonth(checkTime_b2),".",TimeDay(checkTime_b2)," ",Limit_StartTime)) ;
                  g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_b2),".",TimeMonth(checkTime_b2),".",TimeDay(checkTime_b2)," ",Limit_StopTime)) ;
                  if(g_limitStartTime <  g_limitStopTime && (checkTime_b2 < g_eaStartTime || checkTime_b2 > g_limitStopTime))
                    {
                     ObjectDelete("HLINE_LONG");
                     ObjectDelete("HLINE_SHORT");
                     ObjectDelete("HLINE_LONGII");
                     ObjectDelete("HLINE_SHORTII");
                     inLimitWindow_b1 = false;
                    }
                  else
                    {
                     if(g_limitStartTime > g_limitStopTime && checkTime_b2 <  g_limitStartTime && checkTime_b2 > g_limitStopTime)
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inLimitWindow_b1 = false;
                       }
                     else
                       {
                        inLimitWindow_b1 = true;
                       }
                    }

                  checkTime_b3 = 0;
                  if(IsTesting())
                    {
                     checkTime_b3 = TimeCurrent();
                    }
                  else
                    {
                     checkTime_b3 = TimeLocal();
                    }
                  g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_b3),".",TimeMonth(checkTime_b3),".",TimeDay(checkTime_b3)," ",Limit_StartTime)) ;
                  g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_b3),".",TimeMonth(checkTime_b3),".",TimeDay(checkTime_b3)," ",Limit_StopTime)) ;

                  if(g_limitStartTime <  g_limitStopTime && (checkTime_b3 < g_eaStartTime || checkTime_b3 > g_limitStopTime))
                    {
                     ObjectDelete("HLINE_LONG");
                     ObjectDelete("HLINE_SHORT");
                     ObjectDelete("HLINE_LONGII");
                     ObjectDelete("HLINE_SHORTII");
                     inLimitWindow_b2 = false;
                    }
                  else
                    {
                     if(g_limitStartTime > g_limitStopTime && checkTime_b3 <  g_limitStartTime && checkTime_b3 > g_limitStopTime)
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inLimitWindow_b2 = false;
                       }
                     else
                       {
                        inLimitWindow_b2 = true;
                       }
                    }
                  if(!(inLimitWindow_b2))
                    {
                     checkTime_b4 = 0;
                     if(IsTesting())
                       {
                        checkTime_b4 = TimeCurrent();
                       }
                     else
                       {
                        checkTime_b4 = TimeLocal();
                       }
                     g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_b4),".",TimeMonth(checkTime_b4),".",TimeDay(checkTime_b4)," ",Limit_StartTime)) ;
                     g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_b4),".",TimeMonth(checkTime_b4),".",TimeDay(checkTime_b4)," ",Limit_StopTime)) ;
                     if(g_limitStartTime <  g_limitStopTime && (checkTime_b4 < g_eaStartTime || checkTime_b4 > g_limitStopTime))
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inLimitWindow_b3 = false;
                       }
                     else
                       {
                        if(g_limitStartTime > g_limitStopTime && checkTime_b4 <  g_limitStartTime && checkTime_b4 > g_limitStopTime)
                          {
                           ObjectDelete("HLINE_LONG");
                           ObjectDelete("HLINE_SHORT");
                           ObjectDelete("HLINE_LONGII");
                           ObjectDelete("HLINE_SHORTII");
                           inLimitWindow_b3 = false;
                          }
                        else
                          {
                           inLimitWindow_b3 = true;
                          }
                       }
                     // if ( (   (inLimitWindow_b3 && buyCount >= 1) ) )
                     //  {


                     checkTime_b5 = 0;
                     if(IsTesting())
                       {
                        checkTime_b5 = TimeCurrent();
                       }
                     else
                       {
                        checkTime_b5 = TimeLocal();
                       }
                     g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_b5),".",TimeMonth(checkTime_b5),".",TimeDay(checkTime_b5)," ",Limit_StartTime)) ;
                     g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_b5),".",TimeMonth(checkTime_b5),".",TimeDay(checkTime_b5)," ",Limit_StopTime)) ;
                     if(g_limitStartTime <  g_limitStopTime && (checkTime_b5 < g_eaStartTime || checkTime_b5 > g_limitStopTime))
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inLimitWindow_b4 = false;
                       }
                     else
                       {
                        if(g_limitStartTime > g_limitStopTime && checkTime_b5 <  g_limitStartTime && checkTime_b5 > g_limitStopTime)
                          {
                           ObjectDelete("HLINE_LONG");
                           ObjectDelete("HLINE_SHORT");
                           ObjectDelete("HLINE_LONGII");
                           ObjectDelete("HLINE_SHORTII");
                           inLimitWindow_b4 = false;
                          }
                        else
                          {
                           inLimitWindow_b4 = true;
                          }
                       }

                     checkTime_b6 = 0;
                     if(IsTesting())
                       {
                        checkTime_b6 = TimeCurrent();
                       }
                     else
                       {
                        checkTime_b6 = TimeLocal();
                       }
                     g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_b6),".",TimeMonth(checkTime_b6),".",TimeDay(checkTime_b6)," ",Limit_StartTime)) ;
                     g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_b6),".",TimeMonth(checkTime_b6),".",TimeDay(checkTime_b6)," ",Limit_StopTime)) ;
                     if(g_limitStartTime <  g_limitStopTime && (checkTime_b6 < g_eaStartTime || checkTime_b6 > g_limitStopTime))
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inLimitWindow_b5 = false;
                       }
                     else
                       {
                        if(g_limitStartTime > g_limitStopTime && checkTime_b6 <  g_limitStartTime && checkTime_b6 > g_limitStopTime)
                          {
                           ObjectDelete("HLINE_LONG");
                           ObjectDelete("HLINE_SHORT");
                           ObjectDelete("HLINE_LONGII");
                           ObjectDelete("HLINE_SHORTII");
                           inLimitWindow_b5 = false;
                          }
                        else
                          {
                           inLimitWindow_b5 = true;
                          }
                       }
                    }
                  // Print("g_limitStartTime=",g_limitStartTime,"  g_limitStopTime=",g_limitStopTime,"  checkTime_b3=",checkTime_b3,"  g_eaStartTime=",g_eaStartTime,"  checkTime_b3=",checkTime_b3);
                  if((On_top_of_this_price_not_Buy_order==0.0 || (inLimitWindow_b4 && buyCount >= 1 && newOrderPrice<On_top_of_this_price_not_Buy_order) || buyCount == 0 || !(inLimitWindow_b5)))
                    {
                     inLimit_b1 = 0;
                     inLimit_b2 = Magic;
                     inLimit_b3 = 0;
                     inLimit_b4 = 0;
                     for(inLimit_b5 = OrdersTotal() - 1 ; inLimit_b5 >= 0 ; inLimit_b5=inLimit_b5 - 1)
                       {
                        if(!(OrderSelect(inLimit_b5,SELECT_BY_POS,MODE_TRADES)) || Symbol() != OrderSymbol() || OrderMagicNumber() != inLimit_b2 || OrderTicket() <= inLimit_b4 || OrderType() != inLimit_b1)
                           continue;
                        inLimit_b4 = OrderTicket();
                        inLimit_b3 = (int)OrderOpenTime();
                       }

                     if(!(多空差距大于等于N停止开单开关&&CountOrders(OP_BUY,Magic,"")>=CountOrders(OP_SELL,Magic,"")+多空差距大于等于N停止开单))
                        if(((TimeCurrent() - inLimit_b3 >= sleep && OpenMode == 2) || OpenMode == 3 || OpenMode == 1))
                          {
                           if((
                                 (highestBuyPrice!=0.0 && newOrderPrice>=NormalizeDouble(Step * Point() + highestBuyPrice,Digits()) && g_sellHeavy && useSecondParam&&多三组==false)
                                 || (highestBuyPrice!=0.0 && newOrderPrice>=NormalizeDouble(TwoStep * Point() + highestBuyPrice,Digits()) && g_sellHeavy && useSecondParam == false && Money!=0.0)
                                 || (highestBuyPrice!=0.0 && newOrderPrice>=NormalizeDouble(TwoStep3 * Point() + highestBuyPrice,Digits()) && 多三组)
                                 || (Homeopathy && highestBuyPrice!=0.0 && newOrderPrice>=NormalizeDouble(Step * Point() + highestBuyPrice,Digits()) && buyTotalLots==sellTotalLots)))
                             {
                              g_in69 = OrderSend(Symbol(),OP_BUYSTOP,newOrderLots,newOrderPrice,g_slippagePoints,0.0,0.0,"QQ已移除",Magic,0,Blue) ;
                              if(g_in69 > 0)
                                {
                                 Print(Symbol() + "开单成功，订单编号:" + DoubleToString(g_in69,0));
                                }
                              else
                                {
                                 Print(Symbol() + "开单失败");
                                }
                             }
                           else
                             {
                              g_in69 = OrderSend(Symbol(),OP_BUYSTOP,newOrderLots,newOrderPrice,g_slippagePoints,0.0,0.0,"QQ已移除",Magic,0,Blue) ;
                              if(g_in69 > 0)
                                {
                                 Print(Symbol() + "开单成功，订单编号:" + DoubleToString(g_in69,0));
                                }
                              else
                                {
                                 Print(Symbol() + "开单失败");
                                }
                             }
                          }
                    }
                 }
              }
            else
              {
               Comment("Lot ",DoubleToString(newOrderLots,2));
              }
           }
        }

      if(sellStopCount == 0 && sellProfit > -MaxLoss && g_allow_sell)
        {
         if(sellCount == 0)
           {
            newOrderPrice = NormalizeDouble(Bid - FirstStep * Point(),Digits()) ;
           }
         else
           {
            if(useSecondParam&&空三组==false)
              {
               newOrderPrice = NormalizeDouble(Bid - MinDistance * Point(),Digits()) ;
              }
            if(useSecondParam == false)
              {
               newOrderPrice = NormalizeDouble(Bid - TwoMinDistance * Point(),Digits()) ;
              }
            if(空三组)
               newOrderPrice = NormalizeDouble(Bid - TwoMinDistance3 * Point(),Digits()) ;

            if(newOrderPrice<NormalizeDouble(Step * Point() + highestSellPrice,Digits()) && useSecondParam&&空三组==false)
              {
               newOrderPrice = NormalizeDouble(Bid - Step * Point(),Digits()) ;
              }
            if(newOrderPrice<NormalizeDouble(TwoStep * Point() + highestSellPrice,Digits()) && useSecondParam == false && Money!=0.0)
              {
               newOrderPrice = NormalizeDouble(Bid - TwoStep * Point(),Digits()) ;
              }
            if(空三组)
               if(newOrderPrice<NormalizeDouble(TwoStep3 * Point() + highestSellPrice,Digits()))
                 {
                  newOrderPrice = NormalizeDouble(Bid - TwoStep3 * Point(),Digits()) ;
                 }
           }
         if((
               sellCount == 0
               || (lowestSellPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestSellPrice - Step * Point(),Digits()) && g_buyHeavy && useSecondParam&&空三组==false)
               || (lowestSellPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestSellPrice - TwoStep * Point(),Digits()) && g_buyHeavy && useSecondParam == false && Money!=0.0)
               || (lowestSellPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestSellPrice - TwoStep3 * Point(),Digits()) && 空三组)
               || (highestSellPrice!=0.0 && newOrderPrice>=NormalizeDouble(Step * Point() + highestSellPrice,Digits()) && useSecondParam&&空三组==false)
               || (highestSellPrice!=0.0 && newOrderPrice>=NormalizeDouble(TwoStep * Point() + highestSellPrice,Digits()) && useSecondParam == false && Money!=0.0)
               || (highestSellPrice!=0.0 && newOrderPrice>=NormalizeDouble(TwoStep3 * Point() + highestSellPrice,Digits()) && 空三组)
               || (Homeopathy && lowestSellPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestSellPrice - Step * Point(),Digits()) && buyTotalLots==sellTotalLots)))
           {
            if(sellCount == 0)
              {
               newOrderLots = lot ;
              }
            else
              {
               newOrderLots = NormalizeDouble(lot * MathPow(K_Lot,sellCount) + sellCount * PlusLot,DigitsLot) ;
              }
            if(newOrderLots>Maxlot)
              {
               newOrderLots = Maxlot ;
              }
            if(((newOrderLots * 2.0<AccountFreeMargin() / MarketInfo(Symbol(),32) && sellCount > 0) || g_ignoreMargin))
              {
               checkTime_s1 = 0;
               if(IsTesting())
                 {
                  checkTime_s1 = TimeCurrent();
                 }
               else
                 {
                  checkTime_s1 = TimeLocal();
                 }
               g_eaStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_s1),".",TimeMonth(checkTime_s1),".",TimeDay(checkTime_s1)," ",EA_StartTime)) ;
               g_eaStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_s1),".",TimeMonth(checkTime_s1),".",TimeDay(checkTime_s1)," ",EA_StopTime)) ;
               if(g_eaStartTime <  g_eaStopTime && (checkTime_s1 < g_eaStartTime || checkTime_s1 > g_eaStopTime))
                 {
                  inEaWindow_s1 = false;
                 }
               else
                 {
                  if(g_eaStartTime > g_eaStopTime && checkTime_s1 <  g_eaStartTime && checkTime_s1 > g_eaStopTime)
                    {
                     inEaWindow_s1 = false;
                    }
                  else
                    {
                     inEaWindow_s1 = true;
                    }
                 }

               checkTime_s2 = 0;
               if(inEaWindow_s1)
                 {
                  if(IsTesting())
                    {
                     checkTime_s2 = TimeCurrent();
                    }
                  else
                    {
                     checkTime_s2 = TimeLocal();
                    }
                  g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_s2),".",TimeMonth(checkTime_s2),".",TimeDay(checkTime_s2)," ",Limit_StartTime)) ;
                  g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_s2),".",TimeMonth(checkTime_s2),".",TimeDay(checkTime_s2)," ",Limit_StopTime)) ;
                  if(g_limitStartTime <  g_limitStopTime && (checkTime_s2 < g_eaStartTime || checkTime_s2 > g_limitStopTime))
                    {
                     ObjectDelete("HLINE_LONG");
                     ObjectDelete("HLINE_SHORT");
                     ObjectDelete("HLINE_LONGII");
                     ObjectDelete("HLINE_SHORTII");
                     inEaWindow_s2 = false;
                    }
                  else
                    {
                     if(g_limitStartTime > g_limitStopTime && checkTime_s2 <  g_limitStartTime && checkTime_s2 > g_limitStopTime)
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inEaWindow_s2 = false;
                       }
                     else
                       {
                        inEaWindow_s2 = true;
                       }
                    }

                  checkTime_s3 = 0;
                  if(IsTesting())
                    {
                     checkTime_s3 = TimeCurrent();
                    }
                  else
                    {
                     checkTime_s3 = TimeLocal();
                    }
                  g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_s3),".",TimeMonth(checkTime_s3),".",TimeDay(checkTime_s3)," ",Limit_StartTime)) ;
                  g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_s3),".",TimeMonth(checkTime_s3),".",TimeDay(checkTime_s3)," ",Limit_StopTime)) ;
                  if(g_limitStartTime <  g_limitStopTime && (checkTime_s3 < g_eaStartTime || checkTime_s3 > g_limitStopTime))
                    {
                     ObjectDelete("HLINE_LONG");
                     ObjectDelete("HLINE_SHORT");
                     ObjectDelete("HLINE_LONGII");
                     ObjectDelete("HLINE_SHORTII");
                     inEaWindow_s3 = false;
                    }
                  else
                    {
                     if(g_limitStartTime > g_limitStopTime && checkTime_s3 <  g_limitStartTime && checkTime_s3 > g_limitStopTime)
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inEaWindow_s3 = false;
                       }
                     else
                       {
                        inEaWindow_s3 = true;
                       }
                    }
                  if(!(inEaWindow_s3))
                    {
                     checkTime_s4 = 0;
                     if(IsTesting())
                       {
                        checkTime_s4 = TimeCurrent();
                       }
                     else
                       {
                        checkTime_s4 = TimeLocal();
                       }
                     g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_s4),".",TimeMonth(checkTime_s4),".",TimeDay(checkTime_s4)," ",Limit_StartTime)) ;
                     g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_s4),".",TimeMonth(checkTime_s4),".",TimeDay(checkTime_s4)," ",Limit_StopTime)) ;
                     if(g_limitStartTime <  g_limitStopTime && (checkTime_s4 < g_eaStartTime || checkTime_s4 > g_limitStopTime))
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inEaWindow_s4 = false;
                       }
                     else
                       {
                        if(g_limitStartTime > g_limitStopTime && checkTime_s4 <  g_limitStartTime && checkTime_s4 > g_limitStopTime)
                          {
                           ObjectDelete("HLINE_LONG");
                           ObjectDelete("HLINE_SHORT");
                           ObjectDelete("HLINE_LONGII");
                           ObjectDelete("HLINE_SHORTII");
                           inEaWindow_s4 = false;
                          }
                        else
                          {
                           inEaWindow_s4 = true;
                          }
                       }
                     //if ( (   (inEaWindow_s4 && sellCount >= 1) ) )
                     //  {


                     checkTime_s5 = 0;
                     if(IsTesting())
                       {
                        checkTime_s5 = TimeCurrent();
                       }
                     else
                       {
                        checkTime_s5 = TimeLocal();
                       }
                     g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_s5),".",TimeMonth(checkTime_s5),".",TimeDay(checkTime_s5)," ",Limit_StartTime)) ;
                     g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_s5),".",TimeMonth(checkTime_s5),".",TimeDay(checkTime_s5)," ",Limit_StopTime)) ;
                     if(g_limitStartTime <  g_limitStopTime && (checkTime_s5 < g_eaStartTime || checkTime_s5 > g_limitStopTime))
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inEaWindow_s5 = false;
                       }
                     else
                       {
                        if(g_limitStartTime > g_limitStopTime && checkTime_s5 <  g_limitStartTime && checkTime_s5 > g_limitStopTime)
                          {
                           ObjectDelete("HLINE_LONG");
                           ObjectDelete("HLINE_SHORT");
                           ObjectDelete("HLINE_LONGII");
                           ObjectDelete("HLINE_SHORTII");
                           inEaWindow_s5 = false;
                          }
                        else
                          {
                           inEaWindow_s5 = true;
                          }
                       }

                     checkTime_s6 = 0;
                     if(IsTesting())
                       {
                        checkTime_s6 = TimeCurrent();
                       }
                     else
                       {
                        checkTime_s6 = TimeLocal();
                       }
                     g_limitStartTime = StringToTime(StringConcatenate(TimeYear(checkTime_s6),".",TimeMonth(checkTime_s6),".",TimeDay(checkTime_s6)," ",Limit_StartTime)) ;
                     g_limitStopTime = StringToTime(StringConcatenate(TimeYear(checkTime_s6),".",TimeMonth(checkTime_s6),".",TimeDay(checkTime_s6)," ",Limit_StopTime)) ;
                     if(g_limitStartTime <  g_limitStopTime && (checkTime_s6 < g_eaStartTime || checkTime_s6 > g_limitStopTime))
                       {
                        ObjectDelete("HLINE_LONG");
                        ObjectDelete("HLINE_SHORT");
                        ObjectDelete("HLINE_LONGII");
                        ObjectDelete("HLINE_SHORTII");
                        inEaWindow_s6 = false;
                       }
                     else
                       {
                        if(g_limitStartTime > g_limitStopTime && checkTime_s6 <  g_limitStartTime && checkTime_s6 > g_limitStopTime)
                          {
                           ObjectDelete("HLINE_LONG");
                           ObjectDelete("HLINE_SHORT");
                           ObjectDelete("HLINE_LONGII");
                           ObjectDelete("HLINE_SHORTII");
                           inEaWindow_s6 = false;
                          }
                        else
                          {
                           inEaWindow_s6 = true;
                          }
                       }
                    }
                  // Print("g_limitStartTime=",g_limitStartTime,"  g_limitStopTime=",g_limitStopTime,"  checkTime_b3=",checkTime_b3,"  g_eaStartTime=",g_eaStartTime,"  checkTime_b3=",checkTime_b3);
                  if((On_under_of_this_price_not_Sell_order==0.0 || (inEaWindow_s5 && sellCount >= 1 && newOrderPrice>On_under_of_this_price_not_Sell_order) || sellCount == 0 || !(inEaWindow_s6)))
                    {
                     inLimit_s1 = 1;
                     inLimit_s2 = Magic;
                     inLimit_s3 = 0;
                     inLimit_s4 = 0;
                     for(inLimit_s5 = OrdersTotal() - 1 ; inLimit_s5 >= 0 ; inLimit_s5=inLimit_s5 - 1)
                       {
                        if(!(OrderSelect(inLimit_s5,SELECT_BY_POS,MODE_TRADES)) || Symbol() != OrderSymbol() || OrderMagicNumber() != inLimit_s2 || OrderTicket() <= inLimit_s4 || OrderType() != inLimit_s1)
                           continue;
                        inLimit_s4 = OrderTicket();
                        inLimit_s3 = (int)OrderOpenTime();
                       }

                     if(!(多空差距大于等于N停止开单开关&&CountOrders(OP_SELL,Magic,"")>=CountOrders(OP_BUY,Magic,"")+多空差距大于等于N停止开单))
                        if(((TimeCurrent() - inLimit_s3 >= sleep && OpenMode == 2) || OpenMode == 3 || OpenMode == 1))
                          {
                           if((
                                 (lowestSellPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestSellPrice - Step * Point(),Digits()) && g_buyHeavy && useSecondParam&&空三组==false)
                                 || (lowestSellPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestSellPrice - TwoStep * Point(),Digits()) && g_buyHeavy && useSecondParam == false && Money!=0.0)
                                 || (lowestSellPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestSellPrice - TwoStep3 * Point(),Digits()) && 空三组)
                                 || (Homeopathy && lowestSellPrice!=0.0 && newOrderPrice<=NormalizeDouble(lowestSellPrice - Step * Point(),Digits()) && buyTotalLots==sellTotalLots)))
                             {
                              g_in69 = OrderSend(Symbol(),OP_SELLSTOP,newOrderLots,newOrderPrice,g_slippagePoints,0.0,0.0,"QQ已移除",Magic,0,Red) ;
                              if(g_in69 > 0)
                                {
                                 Print(Symbol() + "开单成功，订单编号:" + DoubleToString(g_in69,0));
                                }
                              else
                                {
                                 Print(Symbol() + "开单失败");
                                }
                             }
                           else
                             {
                              g_in69 = OrderSend(Symbol(),OP_SELLSTOP,newOrderLots,newOrderPrice,g_slippagePoints,0.0,0.0,"QQ已移除",Magic,0,Red) ;
                              if(g_in69 > 0)
                                {
                                 Print(Symbol() + "开单成功，订单编号:" + DoubleToString(g_in69,0));
                                }
                              else
                                {
                                 Print(Symbol() + "开单失败");
                                }
                             }
                          }
                    }
                 }
              }
            else
              {
               Comment("Lot ",DoubleToString(newOrderLots,2));
              }
           }
        }
      g_lastBarTime = iTime(NULL,TimeZone,0) ;
     }
   do33 = buyProfit + sellProfit ;
   
   ObjectSetText("BalVal",DoubleToString(AccountBalance(),2),9,"Arial",clrWhite);
   ObjectSetText("EqVal",DoubleToString(AccountEquity(),2),9,"Arial",clrWhite);
   ObjectSetText("FreeVal",DoubleToString(AccountFreeMargin(),2),9,"Arial",clrWhite);
   ObjectSetText("MarVal",DoubleToString(AccountMargin(),2),9,"Arial",clrWhite);
   ObjectSetText("LevVal",IntegerToString(AccountLeverage()),9,"Arial",clrWhite);
   ObjectSetText("SpreadVal",DoubleToString((Ask - Bid)/Point(),1)+"点",9,"Arial",clrWhite);
   
   if(buyCount > 0)
     {
      ObjectSetText("BuyVal",IntegerToString(buyCount)+"单/"+DoubleToString(buyTotalLots,2)+"手",9,"Arial",clrWhite);
      if(buyProfit >= 0)
        ObjectSetText("BuyPL",DoubleToString(buyProfit,2),9,"Arial",C'0,255,0');
      else
        ObjectSetText("BuyPL",DoubleToString(buyProfit,2),9,"Arial",clrRed);
      if(buyAvgPrice > 0)
        ObjectSetText("BuyAvgVal",DoubleToString(buyAvgPrice,Digits()),9,"Arial",clrWhite);
      else
        ObjectSetText("BuyAvgVal","--",9,"Arial",clrWhite);
     }
   else
     {
      ObjectSetText("BuyVal","0单/0.00手",9,"Arial",clrWhite);
      ObjectSetText("BuyPL","0.00",9,"Arial",C'0,255,0');
      ObjectSetText("BuyAvgVal","--",9,"Arial",clrWhite);
     }
   
   if(sellCount > 0)
     {
      ObjectSetText("SellVal",IntegerToString(sellCount)+"单/"+DoubleToString(sellTotalLots,2)+"手",9,"Arial",clrWhite);
      if(sellProfit >= 0)
        ObjectSetText("SellPL",DoubleToString(sellProfit,2),9,"Arial",C'0,255,0');
      else
        ObjectSetText("SellPL",DoubleToString(sellProfit,2),9,"Arial",clrRed);
      if(sellAvgPrice > 0)
        ObjectSetText("SellAvgVal",DoubleToString(sellAvgPrice,Digits()),9,"Arial",clrWhite);
      else
        ObjectSetText("SellAvgVal","--",9,"Arial",clrWhite);
     }
   else
     {
      ObjectSetText("SellVal","0单/0.00手",9,"Arial",clrWhite);
      ObjectSetText("SellPL","0.00",9,"Arial",clrRed);
      ObjectSetText("SellAvgVal","--",9,"Arial",clrWhite);
     }
   
   if(do33 >= 0)
     ObjectSetText("TotalPLVal",DoubleToString(do33,2),10,"Arial",C'0,255,0');
   else
     ObjectSetText("TotalPLVal",DoubleToString(do33,2),10,"Arial",clrRed);
   ObjectSetText("TotalLotsVal",DoubleToString(buyTotalLots + sellTotalLots,2)+"手",10,"Arial",clrWhite);
   
   ObjectSetText("LotVal",DoubleToString(lot,2)+"手",9,"Arial",C'180,220,180');
   ObjectSetText("StepVal",IntegerToString(Step)+"点",9,"Arial",C'180,220,180');
   ObjectSetText("KlotVal",DoubleToString(K_Lot,2),9,"Arial",C'180,220,180');
   ObjectSetText("CloseVal",DoubleToString(CloseAll,2),9,"Arial",C'180,220,180');
   ObjectSetText("MaxVal",DoubleToString(Maxlot,2)+"手",9,"Arial",C'180,220,180');
   if(g_allow_buy && g_allow_sell)
     ObjectSetText("StatusVal","允许交易",9,"Arial",C'0,255,0');
   else
     ObjectSetText("StatusVal","已停止",9,"Arial",clrRed);
   if(buyStopPrice!=0.0 && g_allow_buy)
     {
      if(buyCount == 0)
        {
         newOrderPrice = NormalizeDouble(FirstStep * Point() + Ask,Digits()) ;
        }
      if(useSecondParam&&多三组==false && buyCount > 0)
        {
         newOrderPrice = NormalizeDouble(MinDistance * Point() + Ask,Digits()) ;
        }
      if(useSecondParam == false && buyCount > 0 && Money!=0.0)
        {
         newOrderPrice = NormalizeDouble(TwoMinDistance * Point() + Ask,Digits()) ;
        }
      if(多三组)
        {
         newOrderPrice = NormalizeDouble(TwoMinDistance3 * Point() + Ask,Digits()) ;
        }
      if(NormalizeDouble(buyStopPrice - StepTrallOrders * Point(),Digits())>newOrderPrice
         && (
            ((newOrderPrice<=NormalizeDouble(lowestBuyPrice - Step * Point(),Digits())
              || lowestBuyPrice==0.0
              || (g_sellHeavy && buyCount == 0)
              || newOrderPrice>=NormalizeDouble(Step * Point() + highestBuyPrice,Digits())
              || newOrderPrice<=NormalizeDouble(lowestBuyPrice - Step * Point(),Digits())) && useSecondParam&&多三组==false)
            ||
            ((newOrderPrice<=NormalizeDouble(lowestBuyPrice - TwoStep * Point(),Digits())
              || lowestBuyPrice==0.0
              || (g_sellHeavy && buyCount == 0)
              || newOrderPrice>=NormalizeDouble(TwoStep * Point() + highestBuyPrice,Digits())
              || newOrderPrice<=NormalizeDouble(lowestBuyPrice - TwoStep * Point(),Digits())) && useSecondParam == false && Money!=0.0)
            ||
            ((newOrderPrice<=NormalizeDouble(lowestBuyPrice - TwoStep3 * Point(),Digits())
              || lowestBuyPrice==0.0
              || (g_sellHeavy && buyCount == 0)
              || newOrderPrice>=NormalizeDouble(TwoStep3 * Point() + highestBuyPrice,Digits())
              || newOrderPrice<=NormalizeDouble(lowestBuyPrice - TwoStep3 * Point(),Digits())) && 多三组)
         ))
        {
         if(!(OrderModify(buyStopTicket,newOrderPrice,0.0,0.0,0,White)))
           {
            Print("Error ",GetLastError(),"   Order Modify Buy   OOP ",buyStopPrice,"->",newOrderPrice);
           }
         else
           {
            Print("Order Buy Modify   OOP ",orderOpenPrice,"->",newOrderPrice);
           }
        }
     }
   if(sellStopPrice!=0.0 && g_allow_sell)
     {
      if(sellCount == 0)
        {
         newOrderPrice = NormalizeDouble(Bid - FirstStep * Point(),Digits()) ;
        }
      if(useSecondParam&&空三组==false && sellCount > 0)
        {
         newOrderPrice = NormalizeDouble(Bid - MinDistance * Point(),Digits()) ;
        }
      if(useSecondParam == false && sellCount > 0 && Money!=0.0)
        {
         newOrderPrice = NormalizeDouble(Bid - TwoMinDistance * Point(),Digits()) ;
        }

      if(空三组)
        {
         newOrderPrice = NormalizeDouble(Bid - TwoMinDistance3 * Point(),Digits()) ;
        }

      if(NormalizeDouble(StepTrallOrders * Point() + sellStopPrice,Digits())<newOrderPrice &&
         (
            ((newOrderPrice>=NormalizeDouble(Step * Point() + highestSellPrice,Digits())
              || highestSellPrice==0.0
              || (g_buyHeavy && sellCount == 0)
              || newOrderPrice<=NormalizeDouble(lowestSellPrice - Step * Point(),Digits())
              || newOrderPrice>=NormalizeDouble(Step * Point() + highestSellPrice,Digits())) && useSecondParam&&空三组==false)

            || ((newOrderPrice>=NormalizeDouble(TwoStep * Point() + highestSellPrice,Digits())
                 || highestSellPrice==0.0 || (g_buyHeavy && sellCount == 0)
                 || newOrderPrice<=NormalizeDouble(lowestSellPrice - TwoStep * Point(),Digits())
                 || newOrderPrice>=NormalizeDouble(TwoStep * Point() + highestSellPrice,Digits())) && useSecondParam == false && Money!=0.0)

            || ((newOrderPrice>=NormalizeDouble(TwoStep3 * Point() + highestSellPrice,Digits())
                 || highestSellPrice==0.0 || (g_buyHeavy && sellCount == 0)
                 || newOrderPrice<=NormalizeDouble(lowestSellPrice - TwoStep3 * Point(),Digits())
                 || newOrderPrice>=NormalizeDouble(TwoStep3 * Point() + highestSellPrice,Digits())) && 空三组)
         )

        )
        {
         if(!(OrderModify(sellStopTicket,newOrderPrice,0.0,0.0,0,White)))
           {
            Print("Error ",GetLastError(),"   Order Modify Sell   OOP ",sellStopPrice,"->",newOrderPrice);
           }
         else
           {
            Print("Order Sell Modify   OOP ",orderOpenPrice,"->",newOrderPrice);
           }
        }
     }
   RefreshPanel(false);
   return(0);
  }
//start
//---------------------  ----------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
{
   if(id == CHARTEVENT_CLICK)
   {
      int click_x = (int)lparam;
      int click_y = (int)dparam;
      
      if(!g_panel_dragging)
      {
         if(IsClickOnPanelDragArea(click_x,click_y))
         {
            g_panel_dragging = true;
            g_panel_drag_offset_x = click_x - g_panel_x;
            g_panel_drag_offset_y = click_y - g_panel_y;
            SetPanelDragHighlight(true);
            ChartRedraw(0);
         }
      }
      else
      {
         g_panel_dragging = false;
         SetPanelDragHighlight(false);
         ChartRedraw(0);
      }
      return;
   }
   
   if(id == CHARTEVENT_MOUSE_MOVE && g_panel_dragging)
   {
      int new_x = (int)lparam - g_panel_drag_offset_x;
      int new_y = (int)dparam - g_panel_drag_offset_y;
      ClampPanelPosition(new_x,new_y);
      MovePanelTo(new_x,new_y);
      return;
   }
   
   if(id != CHARTEVENT_OBJECT_CLICK) return;
   HandlePanelButtonClick(sparam);
}
//OnChartEvent
//---------------------  ----------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {

//----------------------------

   ObjectDelete("HLINE_LONGII");
   ObjectDelete("HLINE_SHORTII");
   ObjectDelete("HLINE_LONG");
   ObjectDelete("HLINE_SHORT");
   DeleteObjectsByPrefix(g_panel_prefix);
   ObjectsDeleteAll(0,-1);
   return(0);
  }
//deinit
//---------------------  ----------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CloseAllOrders(int eventID)
  {
   int         errCode;
   int retryCount = 0;
   int         orderType_7;
   int         remainingCount;
   bool        closeResult;
   int         orderIdx_7;

//----------------------------

   orderType_7 = 0 ;
   remainingCount = 0 ;
   closeResult = true ;
   for(; ;)
     {
      for(orderIdx_7 = OrdersTotal() - 1 ; orderIdx_7 >= 0 ; orderIdx_7 = orderIdx_7 - 1)
        {
         if(!(OrderSelect(orderIdx_7,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
            continue;
         orderType_7 = OrderType() ;
         if(orderType_7 == 0 && (eventID == 1 || eventID == 0))
           {
            closeResult = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits()),g_slippagePoints,Blue) ;
            if(closeResult)
              {
               Comment("",OrderTicket(),"",OrderProfit(),"     ",TimeToString(TimeCurrent(),TIME_SECONDS));
              }
           }
         if(orderType_7 == 1 && (eventID == -1 || eventID == 0))
           {
            closeResult = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits()),g_slippagePoints,Red) ;
            if(closeResult)
              {
               Comment("",OrderTicket(),"",OrderProfit(),"     ",TimeToString(TimeCurrent(),TIME_SECONDS));
              }
           }
         if(orderType_7 == 4 && (eventID == 1 || eventID == 0))
           {
            closeResult = OrderDelete(OrderTicket(),0xFFFFFFFF) ;
           }
         if(orderType_7 == 5 && (eventID == -1 || eventID == 0))
           {
            closeResult = OrderDelete(OrderTicket(),0xFFFFFFFF) ;
           }
         if(closeResult)
            continue;
         errCode = GetLastError() ;
         if(errCode < 2)
            continue;

         if(errCode == 129)
           {
            Comment("",TimeToString(TimeCurrent(),TIME_SECONDS));
            RefreshRates();
            continue;
           }
         if(errCode == 146)
           {
            if(!(IsTradeContextBusy()))
               continue;
            Sleep(2000);
            continue;
           }
         Comment("",errCode,"",OrderTicket(),"     ",TimeToString(TimeCurrent(),TIME_SECONDS));
        }
      remainingCount = 0 ;
      for(orderIdx_7 = 0 ; orderIdx_7 < OrdersTotal() ; orderIdx_7 = orderIdx_7 + 1)
        {
         if(!(OrderSelect(orderIdx_7,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != Magic)
            continue;
         orderType_7 = OrderType() ;
         if((orderType_7 == 4 || orderType_7 == 0) && (eventID == 1 || eventID == 0))
           {
            remainingCount = remainingCount + 1;
           }
         if((orderType_7  !=  5 && orderType_7 != 1) || (eventID  !=  -1 && eventID != 0))
            continue;
         remainingCount = remainingCount + 1;
        }
      if(remainingCount == 0)
         break;
      retryCount = retryCount + 1;
      if(retryCount > 10)
        {
         Alert(Symbol(),"平仓超过10次",remainingCount);
         return(0);
        }
      Sleep(1000);
      RefreshRates();
      continue;
     }
   return(1);
  }
//CloseAllOrders
//---------------------  ----------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ConvertTimeframe(int eventID)
  {

//----------------------------

   if(eventID > 43200)
     {
      return(0);
     }
   if(eventID > 10080)
     {
      return(43200);
     }
   if(eventID > 1440)
     {
      return(10080);
     }
   if(eventID > 240)
     {
      return(1440);
     }
   if(eventID > 60)
     {
      return(240);
     }
   if(eventID > 30)
     {
      return(60);
     }
   if(eventID > 15)
     {
      return(30);
     }
   if(eventID > 5)
     {
      return(15);
     }
   if(eventID > 1)
     {
      return(5);
     }
   if(eventID == 1)
     {
      return(1);
     }
   if(eventID == 0)
     {
      return(Period());
     }
   return(0);
  }
//ConvertTimeframe
//---------------------  ----------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseProfitLossOrders(int eventID,int eventLParam,int eventDParam,int eventSParam)
  {

//----------------------------
   int        li10_magic;
   int        li10_type;
   int        li10_ticket;
   double     li10_profit;
   int        li10_idx;

   while(eventDParam > 0)
     {
      li10_magic = eventLParam;
      li10_type = eventID;
      li10_ticket = -1;
      li10_profit = 0.0;
      for(li10_idx = OrdersTotal() - 1 ; li10_idx >= 0 ; li10_idx = li10_idx - 1)
        {
         if(!(OrderSelect(li10_idx,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || (OrderMagicNumber()  !=  li10_magic && li10_magic != -1) || (OrderType()  !=  li10_type && li10_type != -100))
            continue;

         if(eventSParam == 1 && li10_profit<OrderProfit())
           {
            li10_profit = OrderProfit();
            li10_ticket = OrderTicket();
           }
         if(eventSParam != 2 || (!(li10_profit>OrderProfit()) && !(li10_profit==0.0)))
            continue;
         li10_profit = OrderProfit();
         li10_ticket = OrderTicket();
        }
      if(OrderSelect(li10_ticket,SELECT_BY_TICKET,MODE_TRADES))
        {
         if(eventSParam == 1 && OrderProfit()>=0.0 && OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,0xFFFFFFFF))
           {
            eventDParam = eventDParam - 1;
           }
         if(eventSParam == 1 && OrderProfit()<0.0)
           {
            eventDParam = eventDParam - 1;
           }
         if(eventSParam == 2 && OrderProfit()<0.0 && OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,0xFFFFFFFF))
           {
            eventDParam = eventDParam - 1;
           }
         if(eventSParam == 2 && OrderProfit()>=0.0)
           {
            eventDParam = eventDParam - 1;
           }
        }
      else
        {
         eventDParam = eventDParam - 1;
        }
     }
  }
//CloseProfitLossOrders
//---------------------  ----------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SumTopNProfit(int eventID,int eventLParam,int eventDParam,int eventSParam)
  {
   double      子_x[100];
   int         errCode;
   int retryCount = 0;
   double      sellProfit;

//----------------------------

   retryCount = 0 ;
   sellProfit = 0.0 ;
   ArrayInitialize(子_x,0.0);
   errCode = 0 ;
   for(retryCount = OrdersTotal() - 1 ; retryCount >= 0 ; retryCount = retryCount - 1)
     {
      if(!(OrderSelect(retryCount,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || (OrderMagicNumber()  !=  eventLParam && eventLParam != -1) || (OrderType()  !=  eventID && eventID != -100))
         continue;

      if(eventDParam == 1 && OrderProfit()>=0.0)
        {
         子_x[errCode] = OrderProfit();
         errCode = errCode + 1;
        }
      if(eventDParam != 2 || !(OrderProfit()<0.0))
         continue;
      子_x[errCode] =  -(OrderProfit());
      errCode = errCode + 1;
     }
   ArraySort(子_x,0,0,2);
   sellProfit = 0.0 ;
   for(retryCount = 0 ; retryCount < eventSParam ; retryCount = retryCount + 1)
     {
      sellProfit = sellProfit + 子_x[retryCount] ;
     }
   return(sellProfit);
  }
//SumTopNProfit
//---------------------  ----------------------------------------

//+------------------------------------------------------------------+
void 按钮(string name,string txt1,string txt2,int XX,int YX,int XL,int YL,int WZ,color A,color B,int 字体大小X=7)
  {
   if(ObjectFind(0,name)==-1)
     {
      ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,XX);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,YX);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,XL);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,YL);
      ObjectSetString(0,name,OBJPROP_FONT,"宋体");
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,字体大小X);
      ObjectSetInteger(0,name,OBJPROP_CORNER,WZ);
     }

   if(ObjectGetInteger(0,name,OBJPROP_STATE)==1)
     {
      ObjectSetInteger(0,name,OBJPROP_COLOR,A);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,B);
      ObjectSetString(0,name,OBJPROP_TEXT,txt1);
     }
   else
     {
      ObjectSetInteger(0,name,OBJPROP_COLOR,B);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,A);
      ObjectSetString(0,name,OBJPROP_TEXT,txt2);
     }
  }

//+------------------------------------------------------------------+
//||
//+------------------------------------------------------------------+
int FindExtremumTicket(int type1,int type2,int magicX,string 高低,string comm,int pc1,int pc2)
  {
   double 价格=0;
   int 订单号=0;
   for(int i=0; i<OrdersTotal(); i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderTicket()!=pc1 && OrderTicket()!=pc2)
            if(Symbol()==OrderSymbol())
               if(OrderMagicNumber()==magicX || magicX==-1)
                  if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                     if(
                        OrderType()==type1
                        || OrderType()==type2
                        || type1==-100
                        || type2==-100
                        ||(type1==-200&&OrderType()<2)
                        ||(type2==-200&&OrderType()<2)
                        ||(type1==-300&&OrderType()>=2)
                        ||(type2==-300&&OrderType()>=2)
                     )
                        if(((价格==0 || 价格>OrderOpenPrice()) && 高低=="L")
                           || ((价格==0 || 价格<OrderOpenPrice()) && 高低=="H"))
                          {
                           价格=OrderOpenPrice();
                           订单号=OrderTicket();
                          }
   return(订单号);
  }
//+----------------------------------------------------- -------------+
//| |
//+------------------------------------------------------------------+
int FindOrder(int type1,int type2,int magicX,string fx,string 现在与历史,string comm,int 排除)
  {
   int i;
   if(现在与历史=="现在")
      if(fx=="后")
         for(i=OrdersTotal()-1; i>=0; i--)
            if(OrderSelect(i,SELECT_BY_POS))
               if(OrderTicket()!=排除 || 排除==0)
                  if(Symbol()==OrderSymbol())
                     if(OrderMagicNumber()==magicX || magicX==-1)
                        if(
                           OrderType()==type1
                           || OrderType()==type2
                           || type1==-100
                           || type2==-100
                           ||(type1==-200&&OrderType()<2)
                           ||(type2==-200&&OrderType()<2)
                           ||(type1==-300&&OrderType()>=2)
                           ||(type2==-300&&OrderType()>=2)
                        )
                           if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                              return(OrderTicket());

   if(现在与历史=="现在")
      if(fx=="前")
         for(i=0; i<OrdersTotal(); i++)
            if(OrderSelect(i,SELECT_BY_POS))
               if(OrderTicket()!=排除 || 排除==0)
                  if(Symbol()==OrderSymbol())
                     if(OrderMagicNumber()==magicX || magicX==-1)
                        if(
                           OrderType()==type1
                           || OrderType()==type2
                           || type1==-100
                           || type2==-100
                           ||(type1==-200&&OrderType()<2)
                           ||(type2==-200&&OrderType()<2)
                           ||(type1==-300&&OrderType()>=2)
                           ||(type2==-300&&OrderType()>=2)
                        )
                           if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                              return(OrderTicket());

   if(现在与历史=="历史")
      if(fx=="后")
         for(i=OrdersHistoryTotal()-1; i>=0; i--)
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
               if(OrderTicket()!=排除 || 排除==0)
                  if(Symbol()==OrderSymbol())
                     if(OrderMagicNumber()==magicX || magicX==-1)
                        if(OrderType()<=5 && OrderType()>=0)
                           if(
                              OrderType()==type1
                              || OrderType()==type2
                              || type1==-100
                              || type2==-100
                              ||(type1==-200&&OrderType()<2)
                              ||(type2==-200&&OrderType()<2)
                              ||(type1==-300&&OrderType()>=2)
                              ||(type2==-300&&OrderType()>=2)
                           )
                              if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                                 if(OrderCloseTime()!=0)
                                    return(OrderTicket());

   if(现在与历史=="历史")
      if(fx=="前")
         for(i=0; i<OrdersHistoryTotal(); i++)
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
               if(OrderTicket()!=排除 || 排除==0)
                  if(Symbol()==OrderSymbol())
                     if(OrderMagicNumber()==magicX || magicX==-1)
                        if(OrderType()<=5 && OrderType()>=0)
                           if(
                              OrderType()==type1
                              || OrderType()==type2
                              || type1==-100
                              || type2==-100
                              ||(type1==-200&&OrderType()<2)
                              ||(type2==-200&&OrderType()<2)
                              ||(type1==-300&&OrderType()>=2)
                              ||(type2==-300&&OrderType()>=2)
                           )
                              if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                                 if(OrderCloseTime()!=0)
                                    return(OrderTicket());

   return(-1);
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
void DeleteOrders(int type,int magicX,string comm)
  {
//datetime time=TimeCurrent();
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
         if(Symbol()==OrderSymbol())
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(
                  (OrderType()==type || type==-100)
                  || (OrderType()<2 && type==-200)
                  || (OrderType()>=2 && type==-300)
               )
                  if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                     //if(OrderOpenTime()<=time)
                    {
                     if(OrderType()>=2)
                       {
                        if(OrderDelete(OrderTicket())==false)
                           HandleError("");
                        i=OrdersTotal();
                       }
                     else
                       {
                        if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),(int)(滑点*GetPointCoeff(OrderSymbol())))==false)
                           HandleError("");
                        i=OrdersTotal();
                       }
                    }
     }
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
int CountOrders(int type,int magicX,string comm)
  {
   int 数量=0;
   for(int i=0; i<OrdersTotal(); i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(Symbol()==OrderSymbol())
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                  if(
                     (OrderType()==type || type==-100)
                     || (OrderType()<2 && type==-200)
                     || (OrderType()>=2 && type==-300)
                  )
                     数量++;
   return(数量);
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
double SumOrderProfit(int type,int magicX,string comm)
  {
   double 利润=0;
   for(int i=0; i<OrdersTotal(); i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(Symbol()==OrderSymbol())
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                  if(
                     (OrderType()==type || type==-100)
                     || (OrderType()<2 && type==-200)
                     || (OrderType()>=2 && type==-300)
                  )
                     利润+=OrderProfit()+OrderSwap()+OrderCommission();
   return(利润);
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
double SumOrderLots(int type,int magicX,string comm)
  {
   double js=0;
   for(int i=0; i<OrdersTotal(); i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(Symbol()==OrderSymbol())
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                  if(
                     (OrderType()==type || type==-100)
                     || (OrderType()<2 && type==-200)
                     || (OrderType()>=2 && type==-300)
                  )
                     js+=OrderLots();

   return(NormalizeDouble(js,2));
  }

//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
void CreateFixedLabel(string 名称,string 内容,int XX,int YX,color C,int 字体大小,int 固定角内)
  {
   if(内容==NULL)
      return;

   if(ObjectFind(0,名称)==-1)
     {
      ObjectDelete(0,名称);
      ObjectCreate(0,名称,OBJ_LABEL,0,0,0);
     }
   ObjectSetInteger(0,名称,OBJPROP_XDISTANCE,XX);
   ObjectSetInteger(0,名称,OBJPROP_YDISTANCE,YX);
   ObjectSetString(0,名称,OBJPROP_TEXT,内容);
   ObjectSetString(0,名称,OBJPROP_FONT,"宋体");
   ObjectSetInteger(0,名称,OBJPROP_FONTSIZE,字体大小);
   ObjectSetInteger(0,名称,OBJPROP_COLOR,C);
   ObjectSetInteger(0,名称,OBJPROP_CORNER,固定角内);
   ObjectSetInteger(0,名称,OBJPROP_ANCHOR,ANCHOR_LEFT);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PlaceOrder(string 货币对,int 类型,double 单量内,double 价位,double 间隔,double 止损内,double 止盈内,string 备注内,int magicX,color 颜色标记=clrNONE)
  {

   备注内=备注内+"-"+(string)Period()+"-"+(string)magicX;

   if(SymbolInfoDouble(货币对,SYMBOL_VOLUME_STEP)!=0)
      单量内=NormalizeDouble(单量内/SymbolInfoDouble(货币对,SYMBOL_VOLUME_STEP),0)*SymbolInfoDouble(货币对,SYMBOL_VOLUME_STEP);

   if(单量内<MarketInfo(货币对,MODE_MINLOT))
     {
      laber("低于最低单量",Yellow,0);
      return(-1);
     }

   if(单量内>MarketInfo(货币对,MODE_MAXLOT))
      单量内=MarketInfo(货币对,MODE_MAXLOT);

   int t=-1,ix,ix2;
   double POINT=MarketInfo(货币对,MODE_POINT)*GetPointCoeff(货币对);
   int DIGITS=(int)MarketInfo(货币对,MODE_DIGITS);
   int 滑点内=(int)(滑点*GetPointCoeff(货币对));

   if(类型==OP_BUY || 类型==OP_SELL)
      if(AccountFreeMargin()<单量内*MarketInfo(货币对,MODE_MARGINREQUIRED))
        {
         Print("保证金不足");
         return(-1);
        }

   if(类型==OP_BUY)
     {
      t=-1;
      for(ix2=0; ix2<1; ix2++)
         if(t==-1)
           {
            RefreshRates();
            t=OrderSend(货币对,OP_BUY,单量内,MarketInfo(货币对,MODE_ASK),滑点内,0,0,备注内,magicX,0,颜色标记);
            HandleError("");
            if(OrderSelect(t,SELECT_BY_TICKET))
              {
               if(止损内!=0 && 止盈内!=0)
                  for(ix=0; ix<3; ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-止损内 *POINT,DIGITS),NormalizeDouble(OrderOpenPrice()+止盈内 *POINT,DIGITS),0))
                        break;

               if(止损内==0 && 止盈内!=0)
                  for(ix=0; ix<3; ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),0,NormalizeDouble(OrderOpenPrice()+止盈内 *POINT,DIGITS),0))
                        break;

               if(止损内!=0 && 止盈内==0)
                  for(ix=0; ix<3; ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-止损内 *POINT,DIGITS),0,0))
                        break;

               HandleError("");
              }
           }
     }

   if(类型==OP_SELL)
     {
      t=-1;
      for(ix2=0; ix2<1; ix2++)
         if(t==-1)
           {
            RefreshRates();
            t=OrderSend(货币对,OP_SELL,单量内,MarketInfo(货币对,MODE_BID),滑点内,0,0,备注内,magicX,0,颜色标记);
            HandleError("");
            if(OrderSelect(t,SELECT_BY_TICKET))
              {
               if(止损内!=0 && 止盈内!=0)
                  for(ix=0; ix<3; ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+止损内 *POINT,DIGITS),NormalizeDouble(OrderOpenPrice()-止盈内 *POINT,DIGITS),0))
                        break;

               if(止损内==0 && 止盈内!=0)
                  for(ix=0; ix<3; ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),0,NormalizeDouble(OrderOpenPrice()-止盈内 *POINT,DIGITS),0))
                        break;

               if(止损内!=0 && 止盈内==0)
                  for(ix=0; ix<3; ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+止损内 *POINT,DIGITS),0,0))
                        break;
              }
            HandleError("");
           }
     }

   if(类型==OP_BUYLIMIT || 类型==OP_BUYSTOP)
     {
      t=-1;
      for(ix2=0; ix2<1; ix2++)
         if(t==-1)
           {
            if(价位==0)
              {
               RefreshRates();
               价位=MarketInfo(货币对,MODE_ASK);
              }

            if(类型==OP_BUYLIMIT)
              {
               if(止损内!=0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_BUYLIMIT,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位-间隔*POINT-止损内 *POINT,DIGITS),NormalizeDouble(价位-间隔*POINT+止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_BUYLIMIT,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,0,NormalizeDouble(价位-间隔*POINT+止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内!=0 && 止盈内==0)
                  t=OrderSend(货币对,OP_BUYLIMIT,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位-间隔*POINT-止损内 *POINT,DIGITS),0,备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内==0)
                  t=OrderSend(货币对,OP_BUYLIMIT,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,0,0,备注内,magicX,0,颜色标记);
              }

            if(类型==OP_BUYSTOP)
              {
               if(止损内!=0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_BUYSTOP,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位+间隔*POINT-止损内 *POINT,DIGITS),NormalizeDouble(价位+间隔*POINT+止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_BUYSTOP,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,0,NormalizeDouble(价位+间隔*POINT+止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内!=0 && 止盈内==0)
                  t=OrderSend(货币对,OP_BUYSTOP,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位+间隔*POINT-止损内 *POINT,DIGITS),0,备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内==0)
                  t=OrderSend(货币对,OP_BUYSTOP,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,0,0,备注内,magicX,0,颜色标记);
              }
            HandleError("");
           }
     }

   if(类型==OP_SELLLIMIT || 类型==OP_SELLSTOP)
     {
      t=-1;
      for(ix2=0; ix2<1; ix2++)
         if(t==-1)
           {
            if(价位==0)
              {
               RefreshRates();
               价位=MarketInfo(货币对,MODE_BID);
              }

            if(类型==OP_SELLSTOP)
              {
               if(止损内!=0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_SELLSTOP,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位-间隔*POINT+止损内 *POINT,DIGITS),NormalizeDouble(价位-间隔*POINT-止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_SELLSTOP,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,0,NormalizeDouble(价位-间隔*POINT-止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内!=0 && 止盈内==0)
                  t=OrderSend(货币对,OP_SELLSTOP,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位-间隔*POINT+止损内 *POINT,DIGITS),0,备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内==0)
                  t=OrderSend(货币对,OP_SELLSTOP,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,0,0,备注内,magicX,0,颜色标记);
              }

            if(类型==OP_SELLLIMIT)
              {
               if(止损内!=0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_SELLLIMIT,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位+间隔*POINT+止损内 *POINT,DIGITS),NormalizeDouble(价位+间隔*POINT-止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_SELLLIMIT,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,0,NormalizeDouble(价位+间隔*POINT-止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内!=0 && 止盈内==0)
                  t=OrderSend(货币对,OP_SELLLIMIT,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位+间隔*POINT+止损内 *POINT,DIGITS),0,备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内==0)
                  t=OrderSend(货币对,OP_SELLLIMIT,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,0,0,备注内,magicX,0,颜色标记);
              }
            HandleError("");
           }
     }
   return(t);
  }
//+------------------------------------------------------------------+
//||
//+------------------------------------------------------------------+

int 滑点=30;
bool 是否显示文字标签=true;
bool 国际点差自适应=true;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetPointCoeff(string symbol)
  {
   int GetPointCoeff=1;
   if(
      MarketInfo(symbol,MODE_DIGITS)==3
      || MarketInfo(symbol,MODE_DIGITS)==5
      || (StringFind(symbol,"XAU",0)==0 && MarketInfo(symbol,MODE_DIGITS)==2)
      ||(StringFind(symbol,"GOLD",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      ||(StringFind(symbol,"Gold",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      || (StringFind(symbol,"USD_GLD",0)==0 && MarketInfo(symbol,MODE_DIGITS)==2)
   )
      GetPointCoeff=10;

   if(StringFind(symbol,"XAU",0)==0 && MarketInfo(symbol,MODE_DIGITS)==3)
      GetPointCoeff=100;
   if(StringFind(symbol,"GOLD",0)==0 && MarketInfo(symbol,MODE_DIGITS)==3)
      GetPointCoeff=100;
   if(StringFind(symbol,"Gold",0)==0 && MarketInfo(symbol,MODE_DIGITS)==3)
      GetPointCoeff=100;
   if(StringFind(symbol,"USD_GLD",0)==0 && MarketInfo(symbol,MODE_DIGITS)==3)
      GetPointCoeff=100;

   if(国际点差自适应==false)
      return(1);

   return(GetPointCoeff);
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
void laber(string a,color b,int jl)
  {
   Print(a);
   if(IsOptimization())
      return;

   if(是否显示文字标签==true)
     {
      int pp=WindowBarsPerChart();
      double hh=High[iHighest(Symbol(),0,MODE_HIGH,pp,0)];
      double ll=Low[iLowest(Symbol(),0,MODE_LOW,pp,0)];
      double 文字小距离=(hh-ll)*0.03;

      ObjectDelete("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a);
      ObjectCreate("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,OBJ_TEXT,0,Time[0],Low[0]-jl*文字小距离);
      ObjectSetText("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,a,8,"Times New Roman",b);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void HandleError(string a)
//  {
//   RefreshRates();
//
//   if(IsOptimization())
//      return;
//
//   int t=GetLastError();
//
//   if(t!=0)
//     {
//      while(IsTradeContextBusy())
//         Sleep(300);
//      Print("error code"+(string)t);
//      laber("error code"+(string)t,clrYellow,0);
//     }
//  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HandleError(string a)
  {

   RefreshRates();

   if(IsOptimization())
      return;

   int t=GetLastError();
   string 报警;
   if(t!=0)
      switch(t)
        {
         //case 0:报警="错误代码:"+(string)0+"没有错误返回";break;
         //case 1:报警="错误代码:"+(string)1+"没有错误返回但结果不明";break;
         //case 2:报警="错误代码:"+(string)2+"一般错误";break;
         //case 3:报警="错误代码:"+(string)3+"无效交易参量";break;
         case 4:
            报警="错误代码:"+(string)4+"交易服务器繁忙";
            break;
         case 5:
            报警="错误代码:"+(string)5+"客户终端旧版本";
            break;
         case 6:
            报警="错误代码:"+(string)6+"没有连接服务器";
            break;
         case 7:
            报警="错误代码:"+(string)7+"没有权限";
            break;
         //case 8:报警="错误代码:"+(string)8+"请求过于频繁";break;
         case 9:
            报警="错误代码:"+(string)9+"交易运行故障";
            break;
         case 64:
            报警="错误代码:"+(string)64+"账户禁止";
            break;
         case 65:
            报警="错误代码:"+(string)65+"无效账户";
            break;
         // case 128:报警="错误代码:"+(string)128+"交易超时";break;
         //case 129:报警="错误代码:"+(string)129+"无效价格";break;
         case 130:
            报警="错误代码:"+(string)130+"无效停止";
            break;
         //case 131:报警="错误代码:"+(string)131+"无效交易量";break;
         case 132:
            报警="错误代码:"+(string)132+"市场关闭";
            break;
         case 133:
            报警="错误代码:"+(string)133+"交易被禁止";
            break;
         case 134:
            报警="错误代码:"+(string)134+"资金不足";
            break;
         case 135:
            报警="错误代码:"+(string)135+"价格改变";
            break;
         //case 136:报警="错误代码:"+(string)136+"开价";break;
         case 137:
            报警="错误代码:"+(string)137+"经纪繁忙";
            break;
         //case 138:报警="错误代码:"+(string)138+"重新开价";break;
         case 139:
            报警="错误代码:"+(string)139+"定单被锁定";
            break;
         case 140:
            报警="错误代码:"+(string)140+"只允许看涨仓位";
            break;
         //case 141:报警="错误代码:"+(string)141+"过多请求";break;
         //case 145:报警="错误代码:"+(string)145+"因为过于接近市场，修改否定";break;
         //case 146:报警="错误代码:"+(string)146+"交易文本已满";break;
         case 147:
            报警="错误代码:"+(string)147+"时间周期被经纪否定";
            break;
         case 148:
            报警="错误代码:"+(string)148+"开单和挂单总数已被经纪限定";
            break;
         case 149:
            报警="错误代码:"+(string)149+"当对冲备拒绝时,打开相对于现有的一个单置";
            break;
         case 150:
            报警="错误代码:"+(string)150+"把为反FIFO规定的单子平掉";
            break;
         case 4000:
            报警="错误代码:"+(string)4000+"没有错误";
            break;
         case 4001:
            报警="错误代码:"+(string)4001+"错误函数指示";
            break;
         case 4002:
            报警="错误代码:"+(string)4002+"数组索引超出范围";
            break;
         case 4003:
            报警="错误代码:"+(string)4003+"对于调用堆栈储存器函数没有足够内存";
            break;
         case 4004:
            报警="错误代码:"+(string)4004+"循环堆栈储存器溢出";
            break;
         case 4005:
            报警="错误代码:"+(string)4005+"对于堆栈储存器参量没有内存";
            break;
         case 4006:
            报警="错误代码:"+(string)4006+"对于字行参量没有足够内存";
            break;
         case 4007:
            报警="错误代码:"+(string)4007+"对于字行没有足够内存";
            break;
         //case 4008:报警="错误代码:"+(string)4008+"没有初始字行";break;
         case 4009:
            报警="错误代码:"+(string)4009+"在数组中没有初始字串符";
            break;
         case 4010:
            报警="错误代码:"+(string)4010+"对于数组没有内存";
            break;
         case 4011:
            报警="错误代码:"+(string)4011+"字行过长";
            break;
         case 4012:
            报警="错误代码:"+(string)4012+"余数划分为零";
            break;
         case 4013:
            报警="错误代码:"+(string)4013+"零划分";
            break;
         case 4014:
            报警="错误代码:"+(string)4014+"不明命令";
            break;
         case 4015:
            报警="错误代码:"+(string)4015+"错误转换(没有常规错误)";
            break;
         case 4016:
            报警="错误代码:"+(string)4016+"没有初始数组";
            break;
         case 4017:
            报警="错误代码:"+(string)4017+"禁止调用DLL ";
            break;
         case 4018:
            报警="错误代码:"+(string)4018+"数据库不能下载";
            break;
         case 4019:
            报警="错误代码:"+(string)4019+"不能调用函数";
            break;
         case 4020:
            报警="错误代码:"+(string)4020+"禁止调用智能交易函数";
            break;
         case 4021:
            报警="错误代码:"+(string)4021+"对于来自函数的字行没有足够内存";
            break;
         case 4022:
            报警="错误代码:"+(string)4022+"系统繁忙 (没有常规错误)";
            break;
         case 4050:
            报警="错误代码:"+(string)4050+"无效计数参量函数";
            break;
         case 4051:
            报警="错误代码:"+(string)4051+"无效参量值函数";
            break;
         case 4052:
            报警="错误代码:"+(string)4052+"字行函数内部错误";
            break;
         case 4053:
            报警="错误代码:"+(string)4053+"一些数组错误";
            break;
         case 4054:
            报警="错误代码:"+(string)4054+"应用不正确数组";
            break;
         case 4055:
            报警="错误代码:"+(string)4055+"自定义指标错误";
            break;
         case 4056:
            报警="错误代码:"+(string)4056+"不协调数组";
            break;
         case 4057:
            报警="错误代码:"+(string)4057+"整体变量过程错误";
            break;
         case 4058:
            报警="错误代码:"+(string)4058+"整体变量未找到";
            break;
         case 4059:
            报警="错误代码:"+(string)4059+"测试模式函数禁止";
            break;
         case 4060:
            报警="错误代码:"+(string)4060+"没有确认函数";
            break;
         case 4061:
            报警="错误代码:"+(string)4061+"发送邮件错误";
            break;
         case 4062:
            报警="错误代码:"+(string)4062+"字行预计参量";
            break;
         case 4063:
            报警="错误代码:"+(string)4063+"整数预计参量";
            break;
         case 4064:
            报警="错误代码:"+(string)4064+"双预计参量";
            break;
         case 4065:
            报警="错误代码:"+(string)4065+"数组作为预计参量";
            break;
         case 4066:
            报警="错误代码:"+(string)4066+"刷新状态请求历史数据";
            break;
         case 4067:
            报警="错误代码:"+(string)4067+"交易函数错误";
            break;
         case 4099:
            报警="错误代码:"+(string)4099+"文件结束";
            break;
         case 4100:
            报警="错误代码:"+(string)4100+"一些文件错误";
            break;
         case 4101:
            报警="错误代码:"+(string)4101+"错误文件名称";
            break;
         case 4102:
            报警="错误代码:"+(string)4102+"打开文件过多";
            break;
         case 4103:
            报警="错误代码:"+(string)4103+"不能打开文件";
            break;
         case 4104:
            报警="错误代码:"+(string)4104+"不协调文件";
            break;
         case 4105:
            报警="错误代码:"+(string)4105+"没有选择定单";
            break;
         case 4106:
            报警="错误代码:"+(string)4106+"不明货币对";
            break;
         case 4107:
            报警="错误代码:"+(string)4107+"无效价格";
            break;
         case 4108:
            报警="错误代码:"+(string)4108+"无效定单编码";
            break;
         case 4109:
            报警="错误代码:"+(string)4109+"不允许交易";
            break;
         case 4110:
            报警="错误代码:"+(string)4110+"不允许长期";
            break;
         case 4111:
            报警="错误代码:"+(string)4111+"不允许短期";
            break;
         case 4200:
            报警="错误代码:"+(string)4200+"定单已经存在";
            break;
         case 4201:
            报警="错误代码:"+(string)4201+"不明定单属性";
            break;
         //case 4202:报警="错误代码:"+(string)4202+"定单不存在";break;
         case 4203:
            报警="错误代码:"+(string)4203+"不明定单类型";
            break;
         case 4204:
            报警="错误代码:"+(string)4204+"没有定单名称";
            break;
         case 4205:
            报警="错误代码:"+(string)4205+"定单坐标错误";
            break;
         case 4206:
            报警="错误代码:"+(string)4206+"没有指定子窗口";
            break;
         case 4207:
            报警="错误代码:"+(string)4207+"定单一些函数错误";
            break;
         case 4250:
            报警="错误代码:"+(string)4250+"错误设定发送通知到队列中";
            break;
         case 4251:
            报警="错误代码:"+(string)4251+"无效参量- 空字符串传递到SendNotification()函数";
            break;
         case 4252:
            报警="错误代码:"+(string)4252+"无效设置发送通知(未指定ID或未启用通知)";
            break;
         case 4253:
            报警="错误代码:"+(string)4253+"通知发送过于频繁";
            break;
        }
   if(t!=0)
     {
      while(IsTradeContextBusy())
         Sleep(300);
      Print(a+报警);
      laber(a+报警,Yellow,0);
     }
  }


string JLA[];
double JLB[];
datetime JLC[];
string JLD[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HQXH(string A)
  {
   int JL=-100;
   for(int ix=0; ix<ArraySize(JLA); ix++)
     {
      if(JLA[ix]==A)
         return(ix);
     }

   ArrayResize(JLA,ArraySize(JLA)+1);
   ArrayResize(JLB,ArraySize(JLA)+1);
   ArrayResize(JLC,ArraySize(JLA)+1);
   ArrayResize(JLD,ArraySize(JLA)+1);
   JL=ArraySize(JLA)-1;
   return(JL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int objectFind(string A)
  {
   if(IsOptimization())
     {
      for(int ix=0; ix<ArraySize(JLA); ix++)
         if(JLA[ix]==A)
            return(0);
      return(-1);
     }
   return(ObjectFind(A));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void objectDelete(string A)
  {
   if(IsOptimization())
     {
      int WZ=HQXH(A);
      JLA[WZ]=NULL;
      return;
     }
   ObjectDelete(A);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double objectGet(string A,int B)
  {
   if(IsOptimization())
     {
      if(objectFind(A)!=-1)
        {
         if(B==OBJPROP_PRICE1)
            return(JLB[HQXH(A)]);
         if(B==OBJPROP_TIME1)
            return((double)JLC[HQXH(A)]);
        }
      else
         return(0);
     }
   return(ObjectGet(A,B));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string objectDescription(string A)
  {
   if(IsOptimization())
      return(JLD[HQXH(A)]);
   return(ObjectDescription(A));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void laber0(string name,string txt,color 颜色,datetime 时间,double 价位,int 字体大小,int 定位,int 窗口)
  {
   if(IsOptimization())
     {
      int WZ=HQXH(name);
      JLA[WZ]=name;
      JLB[WZ]=价位;
      JLC[WZ]=时间;
      JLD[WZ]=txt;
      return;
     }
   ObjectDelete(name);
   ObjectCreate(name,OBJ_TEXT,窗口,时间,价位);
   ObjectSetText(name,txt,字体大小,"Times New Roman",颜色);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,定位);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 画直线(string e,int type,double b,datetime c,color d,int type2,int width)
  {
   if(IsOptimization())
     {
      int WZ=HQXH(e);
      JLA[WZ]=e;
      JLB[WZ]=b;
      JLC[WZ]=c;
      return;
     }

   ObjectDelete(e);
   ObjectCreate(e,type,0,0,0);
   ObjectSet(e,OBJPROP_PRICE1,b);
   ObjectSet(e,OBJPROP_TIME1,c);
   ObjectSet(e,OBJPROP_COLOR,d);
   ObjectSet(e,OBJPROP_STYLE,type2);
   ObjectSet(e,OBJPROP_WIDTH,width);
  }

void LabelCreate(string name,string text,int x,int y,int width,int height,color clr,int fontSize)
  {
   ObjectCreate(0,name,OBJ_LABEL,0,0,0.0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontSize);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
  }
//+------------------------------------------------------------------+
//| 面板UI函数                                                       |
//+------------------------------------------------------------------+
void BuildPanelMetrics(PanelMetrics &m)
{
   m.margin_x = g_panel_x;
   m.margin_y = g_panel_y;
   m.width = 420;
   m.pad = 14;
   m.section_gap = 10;
   m.header_h = 56;
   m.row_h = 18;
   m.gap = 8;
   m.button_h = 30;
   m.inner_w = m.width - m.pad * 2;
   m.half_w = (m.inner_w - m.gap) / 2;
   m.card_status_h = 184;
   m.card_metrics_h = 236;
   m.card_actions_h = m.pad * 2 + 22 + m.gap + m.button_h * 6 + m.gap * 5;
   m.button_font = 9;
   m.font_xs = 9;
   m.font_sm = 10;
   m.font_md = 11;
   m.font_lg = 15;
   m.toggle_w = 64;
   m.panel_h = m.header_h + m.section_gap + m.card_status_h + m.section_gap + m.card_metrics_h + m.section_gap + m.card_actions_h;
}

void EnsureRectangle(const string name,int x,int y,int w,int h,color bg,color border)
{
   if(ObjectFind(0,name) < 0)
      ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,name,OBJPROP_COLOR,border);
   ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
}

void EnsureLabel(const string name,const string text,int x,int y,int font_size,color clr)
{
   if(ObjectFind(0,name) < 0)
      ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetString(0,name,OBJPROP_FONT,"Microsoft YaHei");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
}

void EnsureButton(const string name,const string text,int x,int y,int w,int h,color bg,color fg)
{
   if(ObjectFind(0,name) < 0)
      ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,name,OBJPROP_COLOR,fg);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,bg);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,9);
   ObjectSetString(0,name,OBJPROP_FONT,"Microsoft YaHei");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
}

void InitPanelPosition()
{
   g_panel_x = PanelStartX;
   g_panel_y = PanelStartY;
}

void ClampPanelPosition(int &panel_x,int &panel_y)
{
   PanelMetrics m;
   BuildPanelMetrics(m);
   long chart_width = ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
   long chart_height = ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
   int max_x = (int)chart_width - m.width;
   int max_y = (int)chart_height - m.panel_h;
   if(max_x < 0) max_x = 0;
   if(max_y < 0) max_y = 0;
   if(panel_x < 0) panel_x = 0;
   if(panel_y < 0) panel_y = 0;
   if(panel_x > max_x) panel_x = max_x;
   if(panel_y > max_y) panel_y = max_y;
}

bool IsClickOnPanelDragArea(int click_x,int click_y)
{
   if(!g_panel_open) return(false);
   PanelMetrics m;
   BuildPanelMetrics(m);
   if(click_x < g_panel_x || click_x > g_panel_x + m.width) return(false);
   if(click_y < g_panel_y || click_y > g_panel_y + m.header_h) return(false);
   return(true);
}

void MovePanelTo(int new_x,int new_y)
{
   int delta_x = new_x - g_panel_x;
   int delta_y = new_y - g_panel_y;
   if(delta_x == 0 && delta_y == 0) return;

   for(int i = ObjectsTotal() - 1; i >= 0; i--)
   {
      string name = ObjectName(i);
      if(StringFind(name,g_panel_prefix,0) != 0) continue;
      if(name == g_panel_prefix + "toggle_panel") continue;

      int x = (int)ObjectGet(name,OBJPROP_XDISTANCE);
      int y = (int)ObjectGet(name,OBJPROP_YDISTANCE);
      ObjectSet(name,OBJPROP_XDISTANCE,x + delta_x);
      ObjectSet(name,OBJPROP_YDISTANCE,y + delta_y);
   }
   g_panel_x = new_x;
   g_panel_y = new_y;
   ChartRedraw(0);
}

void SetPanelDragHighlight(bool active)
{
   string panel_name = g_panel_prefix + "panel";
   if(ObjectFind(0,panel_name) < 0) return;
   if(active)
   {
      ObjectSet(panel_name,OBJPROP_COLOR,C'66,153,225');
      ObjectSet(panel_name,OBJPROP_WIDTH,2);
   }
   else
   {
      ObjectSet(panel_name,OBJPROP_COLOR,C'45,58,74');
      ObjectSet(panel_name,OBJPROP_WIDTH,1);
   }
}

void DeletePanelContentObjects()
{
   for(int i = ObjectsTotal() - 1; i >= 0; i--)
   {
      string name = ObjectName(i);
      if(StringFind(name,g_panel_prefix,0) != 0) continue;
      if(name == g_panel_prefix + "toggle_panel") continue;
      ObjectDelete(0,name);
   }
}

void DrawPanelToggleAnchor()
{
   color accent = C'66,153,225';
   int anchor_w = 64;
   int anchor_h = 30;
   int anchor_x = 16;
   int anchor_y = 35;
   string toggle_text = g_panel_open ? "隐藏" : "展开";
   EnsureButton(g_panel_prefix + "toggle_panel",toggle_text,anchor_x,anchor_y,anchor_w,anchor_h,accent,White);
}

void CollectStats(EAStats &stats)
{
   stats.buy_positions = 0;
   stats.sell_positions = 0;
   stats.buy_pending = 0;
   stats.sell_pending = 0;
   stats.buy_lots = 0.0;
   stats.sell_lots = 0.0;
   stats.buy_profit = 0.0;
   stats.sell_profit = 0.0;
   stats.total_profit = 0.0;

   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol() != Symbol()) continue;
      if(OrderMagicNumber() != Magic) continue;

      int type = OrderType();
      double lots = OrderLots();
      double profit = OrderProfit() + OrderSwap() + OrderCommission();

      if(type == OP_BUY)
      {
         stats.buy_positions++;
         stats.buy_lots += lots;
         stats.buy_profit += profit;
      }
      else if(type == OP_SELL)
      {
         stats.sell_positions++;
         stats.sell_lots += lots;
         stats.sell_profit += profit;
      }
      else if(type == OP_BUYSTOP || type == OP_BUYLIMIT)
      {
         stats.buy_pending++;
      }
      else if(type == OP_SELLSTOP || type == OP_SELLLIMIT)
      {
         stats.sell_pending++;
      }
   }
   stats.total_profit = stats.buy_profit + stats.sell_profit;
}

string BoolText(bool enabled,string on_text,string off_text)
{
   return(enabled ? on_text : off_text);
}

string FormatSignedMoney(double value)
{
   string sign = (value > 0.0) ? "+" : "";
   return(sign + DoubleToString(value,2));
}

string ClipText(string text,int max_chars)
{
   if(max_chars <= 0) return("");
   if(StringLen(text) <= max_chars) return(text);
   if(max_chars <= 3) return(StringSubstr(text,0,max_chars));
   return(StringSubstr(text,0,max_chars - 3) + "...");
}

void DrawPanel(EAStats &stats)
{
   if(!g_panel_open) { DeletePanelContentObjects(); DrawPanelToggleAnchor(); return; }

   PanelMetrics m;
   BuildPanelMetrics(m);

   color panel_bg = C'15,20,27';
   color panel_border = C'45,58,74';
   color header_bg = C'20,29,40';
   color card_bg = C'24,33,45';
   color muted = C'150,164,181';
   color ok_color = C'88,199,135';
   color warn_color = C'255,183,77';
   color bad_color = C'239,100,97';
   color accent = C'66,153,225';
   color accent_alt = C'34,197,154';
   color cream = C'244,248,252';

   int x = m.margin_x;
   int inner_x = x + m.pad;
   int inner_x2 = inner_x + m.half_w + m.gap;

   double balance = AccountBalance();
   double equity = AccountEquity();
   double margin = AccountMargin();
   double margin_level = (margin > 0.0) ? equity / margin * 100.0 : 0.0;
   double spread_pts = (Ask - Bid) / Point();

   EnsureRectangle(g_panel_prefix + "panel",x,m.margin_y,m.width,m.panel_h,panel_bg,panel_border);
   EnsureRectangle(g_panel_prefix + "header",x,m.margin_y,m.width,m.header_h,header_bg,panel_border);
   EnsureLabel(g_panel_prefix + "title","Amazing3.1 双向网格",inner_x + 6,m.margin_y + 10,m.font_lg,cream);
   EnsureLabel(g_panel_prefix + "subtitle",Symbol() + " | " + IntegerToString(Period()) + "min | " + AccountCurrency(),inner_x + 6,m.margin_y + 31,m.font_sm,muted);

   int y = m.margin_y + m.header_h + m.section_gap;
   EnsureRectangle(g_panel_prefix + "card_status",x,y,m.width,m.card_status_h,card_bg,panel_border);
   EnsureLabel(g_panel_prefix + "status_title","工作状态",inner_x,y + m.pad - 1,m.font_md,cream);

   string work_state = "工作中";
   color work_color = ok_color;
   if(!g_allow_buy && !g_allow_sell) { work_state = "手动暂停"; work_color = bad_color; }
   else if(!g_allow_buy || !g_allow_sell) { work_state = "单边运行"; work_color = accent_alt; }

   EnsureLabel(g_panel_prefix + "status_line1","当前  " + work_state,inner_x,y + m.pad + 20,m.font_sm,work_color);
   EnsureLabel(g_panel_prefix + "status_line2","交易  " + BoolText(g_allow_buy,"多开","多停") + "/" + BoolText(g_allow_sell,"空开","空停"),inner_x,y + m.pad + 40,m.font_sm,cream);
   EnsureLabel(g_panel_prefix + "status_line3","时段  " + EA_StartTime + "-" + EA_StopTime,inner_x,y + m.pad + 60,m.font_sm,muted);
   EnsureLabel(g_panel_prefix + "status_line4","点差  " + DoubleToString(spread_pts,1) + " 点",inner_x,y + m.pad + 80,m.font_xs,muted);
   EnsureLabel(g_panel_prefix + "status_line5","杠杆  " + IntegerToString(AccountLeverage()) + "x",inner_x,y + m.pad + 100,m.font_xs,muted);
   EnsureLabel(g_panel_prefix + "status_line6","Magic  " + IntegerToString(Magic),inner_x,y + m.pad + 120,m.font_xs,muted);
   EnsureLabel(g_panel_prefix + "status_line7","停止挂单  " + BoolText(Flag_Stop,"是","否"),inner_x,y + m.pad + 140,m.font_xs,Flag_Stop ? warn_color : muted);

   y += m.card_status_h + m.section_gap;
   EnsureRectangle(g_panel_prefix + "card_metrics",x,y,m.width,m.card_metrics_h,card_bg,panel_border);
   EnsureLabel(g_panel_prefix + "metrics_title","今日目标与账户",inner_x,y + m.pad - 1,m.font_md,cream);

   int line_y = y + m.pad + 22;
   EnsureLabel(g_panel_prefix + "metrics_a_l","Buy  " + IntegerToString(stats.buy_positions) + "单  " + DoubleToString(stats.buy_lots,2) + "手",inner_x,line_y,m.font_sm,cream);
   EnsureLabel(g_panel_prefix + "metrics_a_r","Sell  " + IntegerToString(stats.sell_positions) + "单  " + DoubleToString(stats.sell_lots,2) + "手",inner_x2,line_y,m.font_sm,cream);
   line_y += m.row_h + m.gap / 2;
   EnsureLabel(g_panel_prefix + "metrics_b_l","Buy浮盈  " + FormatSignedMoney(stats.buy_profit),inner_x,line_y,m.font_sm,stats.buy_profit >= 0.0 ? ok_color : bad_color);
   EnsureLabel(g_panel_prefix + "metrics_b_r","Sell浮盈  " + FormatSignedMoney(stats.sell_profit),inner_x2,line_y,m.font_sm,stats.sell_profit >= 0.0 ? ok_color : bad_color);
   line_y += m.row_h + m.gap / 2;
   EnsureLabel(g_panel_prefix + "metrics_c_l","EA浮盈亏  " + FormatSignedMoney(stats.total_profit),inner_x,line_y,m.font_sm,stats.total_profit >= 0.0 ? ok_color : bad_color);
   EnsureLabel(g_panel_prefix + "metrics_c_r","挂单  " + IntegerToString(stats.buy_pending + stats.sell_pending) + "个",inner_x2,line_y,m.font_sm,muted);
   line_y += m.row_h + m.gap / 2;
   EnsureLabel(g_panel_prefix + "metrics_d_l","余额  " + DoubleToString(balance,2),inner_x,line_y,m.font_sm,cream);
   EnsureLabel(g_panel_prefix + "metrics_d_r","净值  " + DoubleToString(equity,2),inner_x2,line_y,m.font_sm,accent_alt);
   line_y += m.row_h + m.gap / 2;
   EnsureLabel(g_panel_prefix + "metrics_e_l","保证金  " + DoubleToString(margin,2),inner_x,line_y,m.font_sm,muted);
   EnsureLabel(g_panel_prefix + "metrics_e_r","保证金比  " + DoubleToString(margin_level,1) + "%",inner_x2,line_y,m.font_sm,margin_level >= 200.0 ? ok_color : warn_color);
   line_y += m.row_h + m.gap / 2;
   EnsureLabel(g_panel_prefix + "metrics_f_l","可用  " + DoubleToString(AccountFreeMargin(),2),inner_x,line_y,m.font_sm,cream);
   EnsureLabel(g_panel_prefix + "metrics_f_r","累计手数  " + DoubleToString(stats.buy_lots + stats.sell_lots,2),inner_x2,line_y,m.font_sm,muted);

   y += m.card_metrics_h + m.section_gap;
   EnsureRectangle(g_panel_prefix + "card_actions",x,y,m.width,m.card_actions_h,card_bg,panel_border);
   EnsureLabel(g_panel_prefix + "actions_title","快捷操作",inner_x,y + m.pad - 1,m.font_md,cream);

   int button_y = y + m.pad + 24;
   EnsureButton(g_panel_prefix + "stop_all",BoolText(g_allow_buy || g_allow_sell,"停止交易","开启交易"),inner_x,button_y,m.inner_w,m.button_h,(g_allow_buy || g_allow_sell) ? bad_color : accent_alt,White);
   button_y += m.button_h + m.gap;
   EnsureButton(g_panel_prefix + "stop_buy",BoolText(g_allow_buy,"停止做多","开启做多"),inner_x,button_y,m.half_w,m.button_h,g_allow_buy ? warn_color : accent_alt,White);
   EnsureButton(g_panel_prefix + "stop_sell",BoolText(g_allow_sell,"停止做空","开启做空"),inner_x2,button_y,m.half_w,m.button_h,g_allow_sell ? warn_color : accent_alt,White);
   button_y += m.button_h + m.gap;
   EnsureButton(g_panel_prefix + "close_all_buy","全平多单",inner_x,button_y,m.half_w,m.button_h,C'29,78,216',White);
   EnsureButton(g_panel_prefix + "close_all_sell","全平空单",inner_x2,button_y,m.half_w,m.button_h,C'185,74,72',White);
   button_y += m.button_h + m.gap;
   EnsureButton(g_panel_prefix + "close_profit_buy","全平盈利多单",inner_x,button_y,m.half_w,m.button_h,accent_alt,White);
   EnsureButton(g_panel_prefix + "close_profit_sell","全平盈利空单",inner_x2,button_y,m.half_w,m.button_h,accent_alt,White);
   button_y += m.button_h + m.gap;
   EnsureButton(g_panel_prefix + "close_loss_buy","全平亏损多单",inner_x,button_y,m.half_w,m.button_h,bad_color,White);
   EnsureButton(g_panel_prefix + "close_loss_sell","全平亏损空单",inner_x2,button_y,m.half_w,m.button_h,bad_color,White);
   button_y += m.button_h + m.gap;
   EnsureButton(g_panel_prefix + "close_all_ea","一键全平仓",inner_x,button_y,m.inner_w,m.button_h,C'121,89,214',White);

   DrawPanelToggleAnchor();
}

void RefreshPanel(bool force)
{
   datetime now_second = TimeCurrent();
   if(!force && now_second == g_last_panel_refresh) return;

   EAStats stats;
   CollectStats(stats);
   DrawPanel(stats);
   if(g_panel_dragging) SetPanelDragHighlight(true);
   g_last_panel_refresh = now_second;
   ChartRedraw(0);
}

void DeleteObjectsByPrefix(string prefix)
{
   for(int i = ObjectsTotal() - 1; i >= 0; i--)
   {
      string name = ObjectName(i);
      if(StringFind(name,prefix,0) == 0)
         ObjectDelete(0,name);
   }
}

bool ShowConfirmDialog(string message)
{
   return(MessageBox(message,"确认操作",MB_YESNO | MB_ICONQUESTION) == IDYES);
}

void ResetPanelButtonState(string button_name)
{
   if(button_name == "") return;
   if(ObjectFind(0,button_name) < 0) return;
   ObjectSetInteger(0,button_name,OBJPROP_STATE,false);
}

void HandlePanelButtonClick(string key)
{
   EAStats stats;
   CollectStats(stats);

   if(key == g_panel_prefix + "toggle_panel")
   {
      ResetPanelButtonState(key);
      g_panel_open = !g_panel_open;
      g_panel_dragging = false;
      SetPanelDragHighlight(false);
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "stop_all")
   {
      ResetPanelButtonState(key);
      bool currently_on = (g_allow_buy || g_allow_sell);
      if(currently_on)
      {
         if(!ShowConfirmDialog("确定要停止全部交易吗？\n将暂停多空新开单，已有持仓保留。")) return;
      }
      else
      {
         if(!ShowConfirmDialog("确定要开启全部交易吗？")) return;
      }
      g_allow_buy = !currently_on;
      g_allow_sell = !currently_on;
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "stop_buy")
   {
      ResetPanelButtonState(key);
      if(g_allow_buy) { if(!ShowConfirmDialog("确定要停止做多吗？")) return; }
      else { if(!ShowConfirmDialog("确定要开启做多吗？")) return; }
      g_allow_buy = !g_allow_buy;
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "stop_sell")
   {
      ResetPanelButtonState(key);
      if(g_allow_sell) { if(!ShowConfirmDialog("确定要停止做空吗？")) return; }
      else { if(!ShowConfirmDialog("确定要开启做空吗？")) return; }
      g_allow_sell = !g_allow_sell;
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "close_all_buy")
   {
      ResetPanelButtonState(key);
      if(!ShowConfirmDialog("确定要全平 " + Symbol() + " 上本EA的全部多单吗？\nMagic=" + IntegerToString(Magic) + "\n当前多单：" + IntegerToString(stats.buy_positions) + " 单，" + DoubleToString(stats.buy_lots,2) + " 手")) return;
      CloseAllOrders(1);
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "close_all_sell")
   {
      ResetPanelButtonState(key);
      if(!ShowConfirmDialog("确定要全平 " + Symbol() + " 上本EA的全部空单吗？\nMagic=" + IntegerToString(Magic) + "\n当前空单：" + IntegerToString(stats.sell_positions) + " 单，" + DoubleToString(stats.sell_lots,2) + " 手")) return;
      CloseAllOrders(-1);
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "close_profit_buy")
   {
      ResetPanelButtonState(key);
      if(!ShowConfirmDialog("确定要全平 " + Symbol() + " 上本EA的盈利多单吗？")) return;
      CloseProfitLossOrders(0,Magic,0,1);
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "close_profit_sell")
   {
      ResetPanelButtonState(key);
      if(!ShowConfirmDialog("确定要全平 " + Symbol() + " 上本EA的盈利空单吗？")) return;
      CloseProfitLossOrders(1,Magic,0,1);
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "close_loss_buy")
   {
      ResetPanelButtonState(key);
      if(!ShowConfirmDialog("确定要全平 " + Symbol() + " 上本EA的亏损多单吗？")) return;
      CloseProfitLossOrders(0,Magic,0,2);
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "close_loss_sell")
   {
      ResetPanelButtonState(key);
      if(!ShowConfirmDialog("确定要全平 " + Symbol() + " 上本EA的亏损空单吗？")) return;
      CloseProfitLossOrders(1,Magic,0,2);
      RefreshPanel(true);
      return;
   }

   if(key == g_panel_prefix + "close_all_ea")
   {
      ResetPanelButtonState(key);
      if(!ShowConfirmDialog("确定要一键全平 " + Symbol() + " 上本EA的全部持仓与挂单吗？\nMagic=" + IntegerToString(Magic) + "\n当前：" + IntegerToString(stats.buy_positions + stats.sell_positions) + " 单持仓")) return;
      CloseAllOrders(0);
      RefreshPanel(true);
   }
}
//+------------------------------------------------------------------+
