//+------------------------------------------------------------------+
//|                                                       突破EA.mq4 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
extern string 分组常规 = "--- 常规 ---";                 // 分组标题：常规设置
extern bool 停止挂单 =false;                    // 是否停止交易：TRUE 时不再推进开新单/挂单逻辑
extern bool 轨道变化仅同步挂单 = true;            // TRUE：上下轨变化时只移动挂单，不因市价止损调整而整批撤销对手挂单
extern string 分组逻辑 = "--- 逻辑 ---";                  // 分组标题：交易逻辑参数
extern int 过滤参数 = 30;                           // 过滤/触发距离（用于计算止盈/止损距离等）
extern int  过滤参数2=0;                           // 第二过滤项（当前版本代码里不明显使用，可保留默认）
extern double 止盈系数 = 1.6;                      // 止盈系数：会参与计算（通常为 止盈系数 * 过滤参数）
extern double 止损系数 = 2.0;                      // 止损系数：会参与计算（通常为 止损系数 * 过滤参数）
extern int 马丁止盈倍数 = 7;                // 马丁止盈倍数（用于“下一波/目标利润”的计算）
extern int 订单间距 = 0;                            // 订单偏移/间距（用于设置挂单的相对价格）
extern datetime 忽略回撤起始时间=315532800;   // 忽略DD早于此时间（用于回测/统计类逻辑）
extern bool 缺口保护=true  ;                   // 缺口保护：用于跳价/间隙情况下的处理开关
extern string 分组马丁 = "--- 马丁参数 ---";               // 分组标题：马丁/资金管理参数
extern double 基础手数 = 0.01;        // 初始/基础手数（非自动资金管理时直接用）
extern double 最大手数=0.0;                    // 最大手数限制：0=不限制，否则对计算出的手数做上限裁剪
extern int 最大亏损步数重置=15;                 // 当 启用自定义手数循环=false 且连续亏损笔数>=该值时，封顶重置为初始手数（0=不启用）
extern bool 自动资金管理 =false;                       // 自动资金管理开关：TRUE 时按资金比例动态计算手数
extern double 自动资金管理基准资金 = 10000.0;            // 自动资金管理基准资金：用于把当前资金映射到手数倍率
extern bool 启用自定义手数循环=true;              // 是否启用自定义手数循环
extern int 手数循环次数=15;               // 自定义手数循环次数（1-15）
extern double 手数1=0.01;                   // 第1笔手数
extern double 手数2=0.03;                   // 第2笔手数
extern double 手数3=0.05;                   // 第3笔手数
extern double 手数4=0.08;                   // 第4笔手数
extern double 手数5=0.12;                   // 第5笔手数
extern double 手数6=0.18;                   // 第6笔手数
extern double 手数7=0.27;                   // 第7笔手数
extern double 手数8=0.40;                   // 第8笔手数
extern double 手数9=0.60;                   // 第9笔手数
extern double 手数10=0.90;                  // 第10笔手数
extern double 手数11=1.20;                  // 第11笔手数
extern double 手数12=1.60;                  // 第12笔手数
extern double 手数13=2.00;                  // 第13笔手数
extern double 手数14=2.50;                  // 第14笔手数
extern double 手数15=3.00;                  // 第15笔手数
extern bool 启用EMA方向倍投=true;        // 是否启用EMA方向倍投过滤
extern int EMA方向周期=14;                 // EMA周期（默认14）
extern bool 要求EMA斜率=true;                 // 是否要求EMA方向斜率一致
extern double 顺势手数系数=1.5;       // 顺势方向手数系数
extern double 逆势手数系数=1.0;    // 非顺势方向手数系数（平投=1.0）
extern string 分组杂项 = "--- 杂项 ---";                 // 分组标题：显示与杂项
extern int 魔术号 = 8893;                         // 魔术号：EA 自己的订单用此值区分
extern bool 详细日志 =true;                      // 是否打印详细日志（对调试/观察很有用）
extern color 注释颜色 = White;             // 注释文字颜色（显示在图表左上/固定区域）
extern int  注释字体大小=11;               // 注释字体大小
extern int  注释行高=18;            // 注释行高（文字堆叠间距）
extern color 框颜色 = DarkSlateGray;        // 注释框/标记颜色
extern bool 绘制线条=true;                      // 是否绘制水平线（用于显示关键价格位）
extern color 上涨颜色=16748574;                  // 上涨线颜色（多单相关）
extern color 下跌颜色=7504122;                   // 下跌线颜色（空单相关）
bool GAti_192 =true;
int GAti_196 = 0;
int GAti_200 = 0;
bool GAti_156 =true;
int GAti_120 = 15;
string GAts_76;
int GAti_84 = 3;
double GAtd_216;
double GAtd_224;
double GAtd_232;
double GAtd_240;
double GAtd_248;
double GAtd_256;
double GAtd_264;
double GAtd_272;
int GAti_280;
int GAti_284 = 999;
double GAtd_288 = 0.0;
double GAtd_296 = 0.0;
int GAti_304 = 0;
int GAti_308 = 0;
int GAti_312 = 0;
int GAti_316 = 0;
double GAtd_320 = 0.0;
double GAtd_328 = 0.0;
double GAtd_336 = 0.0;
double GAtd_344 = 0.0;
double GAtd_352 = 0.0;
double GAtd_360 = 0.0;
double GAtd_368;
double GAtd_376;
int GAti_384 = 0;
int GAti_388 = 0;
int GAti_392 = 0;
int GAti_396 = 0;
int GAti_400;
int GAti_404;
int GAti_412 = 0;
double GAtd_416 = 0.0;
double GAtd_424 = 0.0;
int GAti_432;
double GAtda_436[1001];
double GAtda_440[1001];
double GAtda_444[1001];
double GAtda_448[1001];
int GAti_452 = 0;
double GAtd_456 = 0.0;
double GAtd_464 = 0.0;
int GAti_472;
double GAtda_476[1001];
double GAtda_480[1001];
double GAtda_484[1001];
double GAtda_488[1001];
double GAtd_492;
double GAtd_500;
double GAtd_508;
double GAtd_524;
double GAtd_532;
double GAtd_540;
double GAtd_548;
double GAtd_556;
double GAtd_572;
double GAtd_580;
string GAts_588 = "";
string GAts_596 = "comment_textbox";
int GAti_604 = 0;
string GAts_tahoma_612 = "Tahoma";
int GAti_620 = 12;
int GAti_624 = 40;
int GAti_632 = 500;
int GAti_636 = 4;
int GAti_640 = 10;
bool GAti_644 = FALSE;
int GAti_customLotStep = 1;
datetime GAtdt_customLotLastClose = 0;
int GAti_customLotLastTicket = 0;
int init()
  {
   if(Digits < 4)
      GAtd_216 = 0.01;
   else
      GAtd_216 = 0.0001;
   if(StringSubstr(Symbol(), 0, 6) == "XAGUSD")
     {
      GAtd_216 = 0.01;
      Print("Metals: silver");
      Print("Point = ", f0_1(Point), "  Digits = ", Digits, "  point4 = ", f0_1(GAtd_216));
      Print("Tick value = ", MarketInfo(Symbol(), MODE_TICKVALUE));
      Print("Price of pip = ", MarketInfo(Symbol(), MODE_TICKVALUE) * GAtd_216 / Point);
     }
   else
     {
      if(StringSubstr(Symbol(), 0, 6) == "XAUUSD" || StringSubstr(Symbol(), 0, 4) == "GOLD" || StringSubstr(Symbol(), 0, 4) == "Gold")
        {
         GAtd_216 = 0.1;
         Print("Metals: gold");
         Print("Point = ", f0_1(Point), "  Digits = ", Digits, "  point4 = ", f0_1(GAtd_216));
         Print("Tick value = ", MarketInfo(Symbol(), MODE_TICKVALUE));
         Print("Price of pip = ", MarketInfo(Symbol(), MODE_TICKVALUE) * GAtd_216 / Point);
        }
     }
   GAts_76 = WindowExpertName();
   GAti_400 = 止盈系数 * 过滤参数;
   GAti_404 = 止损系数 * 过滤参数;
   GAtd_240 = MarketInfo(Symbol(), MODE_MINLOT);
   GAtd_248 = MarketInfo(Symbol(), MODE_MAXLOT);
   GAtd_256 = MarketInfo(Symbol(), MODE_LOTSTEP);
   GAtd_264 = MarketInfo(Symbol(), MODE_TICKVALUE);
   GAtd_272 = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   if(GAtd_256 < 0.1)
      GAti_280 = 2;
   else
     {
      if(GAtd_256 < 1.0)
         GAti_280 = 1;
      else
         GAti_280 = 0;
     }
   GAtd_232 = MathMax(MarketInfo(Symbol(), MODE_STOPLEVEL) * Point, 2.0 * (Ask - Bid));
   if(GAti_196 == 0)
      GAtd_224 = MarketInfo(Symbol(), MODE_SPREAD) * Point;
   else
      GAtd_224 = GAti_196 * GAtd_216;
   Print("Ask-Bid = ", f0_1(Ask - Bid));
   Print("spread = ", f0_1(GAtd_224));
   Print("stop_level = ", f0_1(GAtd_232));
   Print("point4 = ", f0_1(GAtd_216));
   double LAtd_0 = 0;
   double LAtd_8 = 0;
   f0_19();
   for(int LAti_16 = 0; LAti_16 <= Bars - 4; LAti_16++)
     {
      f0_2(LAti_16);
      if(LAtd_0 == 0.0 && GAtd_424 > 0.0)
         LAtd_0 = GAtd_424;
      if(LAtd_8 == 0.0 && GAtd_416 > 0.0)
         LAtd_8 = GAtd_416;
      if(LAtd_8 > 0.0 && LAtd_0 > 0.0)
         break;
     }
   GAtd_424 = LAtd_0;
   GAtd_416 = LAtd_8;
   if(详细日志)
      Print("LastMax_1 = ", f0_1(GAtd_416));
   if(详细日志)
      Print("LastMin_1 = ", f0_1(GAtd_424));
   double LAtd_20 = 0;
   double LAtd_28 = 0;
   f0_4();
   for(LAti_16 = 0; LAti_16 <= Bars - 4; LAti_16++)
     {
      f0_0(LAti_16);
      if(LAtd_20 == 0.0 && GAtd_464 > 0.0)
         LAtd_20 = GAtd_464;
      if(LAtd_28 == 0.0 && GAtd_456 > 0.0)
         LAtd_28 = GAtd_456;
      if(LAtd_28 > 0.0 && LAtd_20 > 0.0)
         break;
     }
   GAtd_464 = LAtd_20;
   GAtd_456 = LAtd_28;
   if(详细日志)
      Print("LastMax_2 = ", f0_1(GAtd_456));
   if(详细日志)
      Print("LastMin_2 = ", f0_1(GAtd_464));
   return (0);
  }
void f0_2(int AAti_0 = 0)
  {
   if(GAtda_436[AAti_0 + 1] > GAtda_448[AAti_0 + 1] && GAtda_436[AAti_0 + 2] < GAtda_448[AAti_0 + 2])
      GAtd_416 = f0_11(MathMax(GAtda_444[AAti_0 + 1], GAtda_444[AAti_0 + 2]));
   if(GAtda_436[AAti_0 + 1] < GAtda_448[AAti_0 + 1] && GAtda_436[AAti_0 + 2] > GAtda_448[AAti_0 + 2])
      GAtd_424 = f0_11(MathMin(GAtda_440[AAti_0 + 1], GAtda_440[AAti_0 + 2]));
  }
void f0_0(int AAti_0 = 0)
  {
   if(GAtda_476[AAti_0 + 1] > GAtda_488[AAti_0 + 1] && GAtda_476[AAti_0 + 2] < GAtda_488[AAti_0 + 2])
      GAtd_456 = f0_11(MathMax(GAtda_484[AAti_0 + 1], GAtda_484[AAti_0 + 2]));
   if(GAtda_476[AAti_0 + 1] < GAtda_488[AAti_0 + 1] && GAtda_476[AAti_0 + 2] > GAtda_488[AAti_0 + 2])
      GAtd_464 = f0_11(MathMin(GAtda_480[AAti_0 + 1], GAtda_480[AAti_0 + 2]));
  }
void deinit()
  {
   f0_5();
   f0_10();
   ObjectDelete("Q_S_1");
   ObjectDelete("Q_S_2");
   string LAts_0 = "a" + GAts_76 + "Box";
   ObjectDelete(LAts_0);
   LAts_0 = "a" + GAts_76 + "Box2";
   ObjectDelete(LAts_0);
  }
  void OnTick()
  {
 start0();
  }
int start0()
  {
   f0_13();
   f0_23_updateCustomLotCycle();
   int LAti_0;
   double LAtd_4;
   double LAtd_12;
   double LAtd_20;
   int LAti_36;
   bool LAti_52;
   double LAtd_56;
   double LAtd_112;
   double LAtd_120;
   double LAtd_128;
   int LAti_136;
   int LAti_172;
   double LAtd_176;
   GAti_400 = 止盈系数 * 过滤参数;
   GAti_404 = 止损系数 * 过滤参数;
   double LAtd_64 = GAtd_416;
   double LAtd_72 = GAtd_424;
   if(GAtd_416 <= 0.0)
      GAtd_416 = MathMax(iHigh(NULL, PERIOD_D1, 1), Ask + 过滤参数 * GAtd_216);
   if(GAtd_424 <= 0.0)
      GAtd_424 = MathMin(iLow(NULL, PERIOD_D1, 1), Bid - 过滤参数 * GAtd_216);
   if(GAtd_416 <= 0.0 || GAtd_424 <= 0.0)
     {
      Comment("Not enough quotes");
      Print("Not enough quotes");
      return (0);
     }
   double LAtd_80 = GAtd_456;
   double LAtd_88 = GAtd_464;
   if(GAtd_456 <= 0.0)
      GAtd_456 = MathMax(iHigh(NULL, PERIOD_D1, 1), Ask + GAti_120 * GAtd_216);
   if(GAtd_464 <= 0.0)
      GAtd_464 = MathMin(iLow(NULL, PERIOD_D1, 1), Bid - GAti_120 * GAtd_216);
   if(GAtd_456 <= 0.0 || GAtd_464 <= 0.0)
     {
      Comment("Not enough quotes");
      Print("Not enough quotes");
      return (0);
     }
   LAtd_64 = GAtd_416;
   LAtd_72 = GAtd_424;
   f0_19();
   f0_2();
   if(GAti_412 <= 0 && Bid > GAtd_416)
      GAti_412 = 2;
   if(GAti_412 > 0 && Bid > GAtd_424 && Bid < GAtd_416)
      GAti_412 = 1;
   if(GAti_412 >= 0 && Bid < GAtd_424)
      GAti_412 = -2;
   if(GAti_412 < 0 && Bid > GAtd_424 && Bid < GAtd_416)
      GAti_412 = -1;
   LAtd_80 = GAtd_456;
   LAtd_88 = GAtd_464;
   f0_4();
   f0_0();
   if(GAti_452 <= 0 && Bid > GAtd_456)
      GAti_452 = 2;
   if(GAti_452 > 0 && Bid > GAtd_464 && Bid < GAtd_456)
      GAti_452 = 1;
   if(GAti_452 >= 0 && Bid < GAtd_464)
      GAti_452 = -2;
   if(GAti_452 < 0 && Bid > GAtd_464 && Bid < GAtd_456)
      GAti_452 = -1;
   double LAtd_96 = GAtd_288;
   double LAtd_104 = GAtd_296;
   GAtd_288 = GAtd_416;
   GAtd_296 = GAtd_424;
   if(GAtd_288 != LAtd_96)
     {
      LAti_52 = FALSE;
      for(int LAti_44 = OrdersTotal() - 1; LAti_44 >= 0; LAti_44--)
        {
         if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == 魔术号)
              {
               LAtd_4 = OrderOpenPrice();
               if(OrderType() == OP_SELL)
                 {
                  LAtd_20 = f0_11(MathMin(GAtd_288 + 订单间距 * GAtd_216 + GAtd_224, LAtd_4 + GAti_404 * GAtd_216));
                  if(LAtd_20 <= OrderStopLoss() - Point)
                    {
                     f0_15(OrderTicket(), OrderOpenPrice(), LAtd_20, OrderTakeProfit(), 0, Red);
                     LAti_52 = TRUE;
                    }
                 }
              }
           }
        }
      if(LAti_52 && GAti_156 && (!轨道变化仅同步挂单))
         f0_9(1);
     }
   if(GAtd_296 != LAtd_104)
     {
      LAti_52 = FALSE;
      for(LAti_44 = OrdersTotal() - 1; LAti_44 >= 0; LAti_44--)
        {
         if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == 魔术号)
              {
               LAtd_4 = OrderOpenPrice();
               if(OrderType() == OP_BUY)
                 {
                  LAtd_20 = f0_11(MathMax(GAtd_296 - 订单间距 * GAtd_216, LAtd_4 - GAti_404 * GAtd_216));
                  if(LAtd_20 >= OrderStopLoss() + Point)
                    {
                     f0_15(OrderTicket(), OrderOpenPrice(), LAtd_20, OrderTakeProfit(), 0, Blue);
                     LAti_52 = TRUE;
                    }
                 }
              }
           }
        }
      if(LAti_52 && GAti_156 && (!轨道变化仅同步挂单))
         f0_9(-1);
     }
   double LAtd_pendMinDelta = MathMax(Point, GAtd_224);
   if(GAtd_288 != LAtd_96 || GAtd_296 != LAtd_104)
     {
      for(LAti_44 = OrdersTotal() - 1; LAti_44 >= 0; LAti_44--)
        {
         if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == 魔术号 && OrderType() > OP_SELL)
              {
               LAtd_4 = OrderOpenPrice();
               LAtd_20 = OrderStopLoss();
               LAtd_12 = OrderTakeProfit();
               if(OrderType() == OP_BUYSTOP)
                 {
                  LAtd_112 = f0_11(GAtd_288 + 订单间距 * GAtd_216 + GAtd_224);
                  LAtd_120 = f0_11(MathMax(GAtd_296 - 订单间距 * GAtd_216, LAtd_112 - GAti_404 * GAtd_216));
                  LAtd_128 = f0_11(LAtd_112 + MathAbs(LAtd_4 - LAtd_12));
                  if((MathAbs(LAtd_112 - LAtd_4) >= LAtd_pendMinDelta || MathAbs(LAtd_120 - LAtd_20) >= LAtd_pendMinDelta)&& LAtd_112 > Ask + GAtd_232)
                     f0_15(OrderTicket(), LAtd_112, LAtd_120, LAtd_128, 0, Blue);
                 }
               if(OrderType() == OP_SELLSTOP)
                 {
                  LAtd_112 = f0_11(GAtd_296 - 订单间距 * GAtd_216);
                  LAtd_120 = f0_11(MathMin(GAtd_288 + 订单间距 * GAtd_216 + GAtd_224, LAtd_112 + GAti_404 * GAtd_216));
                  LAtd_128 = f0_11(LAtd_112 - MathAbs(LAtd_4 - LAtd_12));
                  if((MathAbs(LAtd_112 - LAtd_4) >= LAtd_pendMinDelta || MathAbs(LAtd_120 - LAtd_20) >= LAtd_pendMinDelta)&& LAtd_112 < Bid - GAtd_232)
                     f0_15(OrderTicket(), LAtd_112, LAtd_120, LAtd_128, 0, Red);
                 }
              }
           }
        }
     }
   if(GAti_156)
     {
      if(GAti_308 != OrdersHistoryTotal())
        {
         LAti_136 = GAti_312;
         GAti_308 = OrdersHistoryTotal();
         GAtd_320 = 0;
         GAti_312 = 0;
         for(LAti_44 = GAti_308 - 1; LAti_44 >= 0; LAti_44--)
           {
            if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_HISTORY))
              {
               if(OrderSymbol() == Symbol() && OrderMagicNumber() == 魔术号 && OrderType() <= OP_SELL)
                 {
                  if(OrderProfit() > 0.0)
                     break;
                  GAtd_320 += OrderProfit() + OrderCommission() + OrderSwap();
                  GAti_312++;
                 }
              }
           }
         if(GAti_312 > GAti_316)
            GAti_316 = GAti_312;
         if(GAtd_320 < GAtd_328)
            GAtd_328 = GAtd_320;
         if(GAtd_320 > 0.0)
            GAtd_320 = 0;
        }
     }
   GAti_384 = 0;
   GAti_388 = 0;
   GAti_392 = 0;
   GAti_396 = 0;
   GAtd_336 = 0;
   GAtd_344 = 0;
   GAtd_352 = 0;
   GAtd_360 = 0;
   double LAtd_140 = 0;
   double LAtd_148 = 0;
   double LAtd_156 = 0;
   double LAtd_164 = 0;
   for(LAti_44 = OrdersTotal() - 1; LAti_44 >= 0; LAti_44--)
     {
      if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == 魔术号)
           {
            LAti_172 = OrderType();
            if(LAti_172 == OP_BUY)
              {
               GAti_384++;
               LAtd_140 += OrderLots();
              }
            else
              {
               if(LAti_172 == OP_SELL)
                 {
                  GAti_388++;
                  LAtd_148 += OrderLots();
                 }
               else
                 {
                  if(LAti_172 == OP_BUYSTOP || LAti_172 == OP_BUYLIMIT)
                    {
                     GAti_392++;
                     LAtd_156 += OrderLots();
                     GAtd_352 += MathAbs(OrderOpenPrice() - OrderTakeProfit()) * OrderLots() / Point * GAtd_264;
                    }
                  else
                    {
                     if(LAti_172 == OP_SELLSTOP || LAti_172 == OP_SELLLIMIT)
                       {
                        GAti_396++;
                        LAtd_164 += OrderLots();
                        GAtd_360 += MathAbs(OrderOpenPrice() - OrderTakeProfit()) * OrderLots() / Point * GAtd_264;
                       }
                    }
                 }
              }
            if(LAti_172 <= OP_SELL)
              {
               GAtd_336 -= MathAbs(OrderOpenPrice() - OrderStopLoss()) * OrderLots() / Point * GAtd_264;
               GAtd_344 += MathAbs(OrderOpenPrice() - OrderTakeProfit()) * OrderLots() / Point * GAtd_264;
              }
           }
        }
     }
   if(GAti_156)
     {
      LAtd_176 = f0_3();
      if(GAti_312 == 0 && GAti_384 == 0 && GAti_388 == 0)
        {
         GAtd_368 = LAtd_176;
         LAti_0 = GAti_400;
        }
      else
        {
         LAti_0 = GAti_400;
         GAtd_376 = (-GAtd_320) - GAtd_336 + (GAti_312 + 2) * f0_3() * GAtd_264 * 马丁止盈倍数 * GAtd_216 / Point;
         GAtd_368 = f0_16(GAtd_376 / (LAti_0 * GAtd_216 / Point * GAtd_264));
         if(GAtd_368 < LAtd_176)
            GAtd_368 = LAtd_176;
        }
     }
   else
     {
      GAtd_368 = f0_3();
      LAti_0 = GAti_400;
     }
   if(!启用自定义手数循环 && 最大亏损步数重置>0 && GAti_156 && GAti_312 >= 最大亏损步数重置)
     {
      // 连续亏损封顶：重置为初始手数（不改变原 GAtd_368 计算逻辑，只做保险丝）
      GAtd_368 = f0_3();
      LAti_0 = GAti_400;
     }
   if(启用自定义手数循环)
     {
      GAtd_368 = f0_3();
      LAti_0 = GAti_400;
     }
   double LAtd_expBuy = f0_27_getExpectedPendingLot(1);
   double LAtd_expSell = f0_27_getExpectedPendingLot(-1);
   if(LAtd_156 > 0.0)
     {
      if(LAtd_156 >= LAtd_expBuy + GAtd_240 - 0.0001)
        {
         f0_9(1);
         GAti_392 = 0;
         LAtd_156 = 0;
        }
      else
        {
         if(LAtd_156 <= LAtd_expBuy - GAtd_240 + 0.0001)
           {
            f0_9(1);
            GAti_392 = 0;
            LAtd_156 = 0;
           }
        }
     }
   if(LAtd_164 > 0.0)
     {
      if(LAtd_164 >= LAtd_expSell + GAtd_240 - 0.0001)
        {
         f0_9(-1);
         GAti_396 = 0;
         LAtd_164 = 0;
        }
      else
        {
         if(LAtd_164 <= LAtd_expSell - GAtd_240 + 0.0001)
           {
            f0_9(-1);
            GAti_396 = 0;
            LAtd_164 = 0;
           }
        }
     }
   if(GAti_384 == 0 && GAti_392 == 0 && Ask < GAtd_288 - 5.0 * GAtd_232 && (!停止挂单))
     {
      for(int LAti_40 = 0; GAtd_368 > GAtd_240 - 0.0001 && LAti_40 < 50; LAti_40++)
        {
         LAtd_56 = MathMin(GAtd_368, GAtd_248);
         RefreshRates();
         LAti_36 = f0_7(1, LAtd_56, LAti_0);
         if(LAti_36 > 0)
            GAtd_368 -= LAtd_56;
        }
     }
   if(GAti_388 == 0 && GAti_396 == 0 && Bid > GAtd_296 + 5.0 * GAtd_232 && (!停止挂单))
     {
      for(LAti_40 = 0; GAtd_368 > GAtd_240 - 0.0001 && LAti_40 < 50; LAti_40++)
        {
         LAtd_56 = MathMin(GAtd_368, GAtd_248);
         RefreshRates();
         LAti_36 = f0_7(-1, LAtd_56, LAti_0);
         if(LAti_36 > 0)
            GAtd_368 -= LAtd_56;
        }
     }
   if((!IsTesting()) || IsVisualMode())
      f0_13();
   return (0);
  }
int FUN_0678(int t)
  {
   bool b=0;
   int li_4 = 0;
   int li_8 = OrdersTotal();
   for(int li_12=0; li_12<li_8; li_12++)
     {
      b=OrderSelect(li_12,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==魔术号  && OrderType()==t)
         li_4++;
     }
   return (li_4);
  }
int f0_7(int AAti_0, double AAtd_4, int AAti_12)
  {
   double LAtd_16;
   double LAtd_24;
   double LAtd_32;
   int LAti_40;
   int LAti_44;
   int LAti_48 = -1;
   double LAtd_52 = f0_25_getDirectionalLotFactor(AAti_0);
   AAtd_4 *= LAtd_52;
   if(GAtd_256 > 0.0)
      AAtd_4 = NormalizeDouble(MathRound(AAtd_4 / GAtd_256) * GAtd_256, GAti_280);
   if(AAtd_4 < GAtd_240)
      AAtd_4 = GAtd_240;
   if(AAtd_4 > GAtd_248)
      AAtd_4 = GAtd_248;
   if(最大手数>0)
      if(AAtd_4>=最大手数)
         AAtd_4 = 最大手数 ;
   if(AAti_0 > 0)
      if(FUN_0678(OP_BUYSTOP)==0)
        {
         LAtd_16 = GAtd_288 + 订单间距 * GAtd_216 + GAtd_224;
         LAtd_32 = LAtd_16 + AAti_12 * GAtd_216;
         LAtd_24 = MathMax(GAtd_296 - 订单间距 * GAtd_216, LAtd_16 - GAti_404 * GAtd_216);
         LAti_44 = AAti_12;
         LAti_40 = MathRound(MathAbs(LAtd_16 - LAtd_24) / GAtd_216);

         FUN_06("Q_S_1", f0_11(LAtd_16),  上涨颜色,1,2);
         if(详细日志)
            Print(魔术号 + " Setting the BUYSTOP order with Lot ", DoubleToStr(AAtd_4, GAti_280), ", TP = ", LAti_44, ", SL = ", LAti_40);
         if(GAti_192)
            LAti_48 = OrderSend(Symbol(), OP_BUYSTOP, AAtd_4, f0_11(LAtd_16), GAti_84, 0, 0, GAts_76, 魔术号, 0, Blue);
         else
            LAti_48 = OrderSend(Symbol(), OP_BUYSTOP, AAtd_4, f0_11(LAtd_16), GAti_84, f0_11(LAtd_24), f0_11(LAtd_32), GAts_76, 魔术号, 0, Blue);
         if(LAti_48 < 0)
           {
            f0_18();
            Print("Ask = ", f0_1(Ask), " OP = ", f0_1(LAtd_16), " OSL = ", f0_1(LAtd_24), " OTP = ", f0_1(LAtd_32));
           }
         if(LAti_48 > 0 && GAti_192)
            f0_12(LAti_48, LAti_40, LAti_44);
        }
    {
      if(AAti_0 < 0)
         if(FUN_0678(OP_SELLSTOP)==0)
           {
            LAtd_16 = GAtd_296 - 订单间距 * GAtd_216;
            LAtd_32 = LAtd_16 - AAti_12 * GAtd_216;
            LAtd_24 = MathMin(GAtd_288 + 订单间距 * GAtd_216 + GAtd_224, LAtd_16 + GAti_404 * GAtd_216);
            LAti_44 = AAti_12;
            LAti_40 = MathRound(MathAbs(LAtd_16 - LAtd_24) / GAtd_216);

            FUN_06("Q_S_2", f0_11(LAtd_16),  下跌颜色,1,2);
            if(详细日志)
               Print(魔术号 + " Setting the SELLSTOP order with Lot ", DoubleToStr(AAtd_4, GAti_280), ", TP = ", LAti_44, ", SL = ", LAti_40);
            if(GAti_192)
               LAti_48 = OrderSend(Symbol(), OP_SELLSTOP, AAtd_4, f0_11(LAtd_16), GAti_84, 0, 0, GAts_76, 魔术号, 0, Red);
            else
               LAti_48 = OrderSend(Symbol(), OP_SELLSTOP, AAtd_4, f0_11(LAtd_16), GAti_84, f0_11(LAtd_24), f0_11(LAtd_32), GAts_76, 魔术号, 0, Red);
            if(LAti_48 < 0)
              {
               f0_18();
               Print("Bid = ", f0_1(Bid), " OP = ", f0_1(LAtd_16), " OSL = ", f0_1(LAtd_24), " OTP = ", f0_1(LAtd_32));
              }
            if(LAti_48 > 0 && GAti_192)
               f0_12(LAti_48, LAti_40, LAti_44);
           }
     }
   return (LAti_48);
  }
double f0_25_getDirectionalLotFactor(int AAti_0)
  {
   if(!启用EMA方向倍投)
      return (1.0);
   int LAti_0 = EMA方向周期;
   if(LAti_0 < 2)
      LAti_0 = 14;
   double LAtd_8 = iMA(NULL, PERIOD_D1, LAti_0, 0, MODE_EMA, PRICE_CLOSE, 0);
   double LAtd_16 = iMA(NULL, PERIOD_D1, LAti_0, 0, MODE_EMA, PRICE_CLOSE, 1);
   double LAtd_24 = iClose(NULL, PERIOD_D1, 1);
   double LAtd_32 = iOpen(NULL, PERIOD_D1, 0);
   bool LAti_40 = (LAtd_24 > LAtd_16 && LAtd_32 > LAtd_8);
   bool LAti_44 = (LAtd_24 < LAtd_16 && LAtd_32 < LAtd_8);
   if(要求EMA斜率)
     {
      LAti_40 = (LAti_40 && LAtd_8 > LAtd_16);
      LAti_44 = (LAti_44 && LAtd_8 < LAtd_16);
     }
   if(AAti_0 > 0)
     {
      if(LAti_40)
         return (顺势手数系数);
      return (逆势手数系数);
     }
   if(AAti_0 < 0)
     {
      if(LAti_44)
         return (顺势手数系数);
      return (逆势手数系数);
     }
   return (1.0);
  }
string f0_26_getDirectionalLotBiasText()
  {
   if(!启用EMA方向倍投)
      return ("关闭");
   if(f0_25_getDirectionalLotFactor(1) > 逆势手数系数 + 0.0000001)
      return ("多单倍投 / 空单平投");
   if(f0_25_getDirectionalLotFactor(-1) > 逆势手数系数 + 0.0000001)
      return ("空单倍投 / 多单平投");
   return ("双向平投");
  }
double f0_27_getExpectedPendingLot(int AAti_0)
  {
   double AAtd_4 = MathMin(GAtd_368, GAtd_248);
   double LAtd_52 = f0_25_getDirectionalLotFactor(AAti_0);
   AAtd_4 *= LAtd_52;
   if(GAtd_256 > 0.0)
      AAtd_4 = NormalizeDouble(MathRound(AAtd_4 / GAtd_256) * GAtd_256, GAti_280);
   if(AAtd_4 < GAtd_240)
      AAtd_4 = GAtd_240;
   if(AAtd_4 > GAtd_248)
      AAtd_4 = GAtd_248;
   if(最大手数>0)
      if(AAtd_4>=最大手数)
         AAtd_4 = 最大手数 ;
   return (AAtd_4);
  }
double f0_3()
  {
   double LAtd_0;
   double LAtd_8;
   double LAtd_16;
   double LAtd_24;
   if(启用自定义手数循环)
      LAtd_0 = f0_24_getCurrentCustomLot();
   else
      if(自动资金管理 && 自动资金管理基准资金 > 0.0)
     {
      LAtd_8 = AccountBalance();
      LAtd_16 = 10.0;
      LAtd_24 = MathFloor(LAtd_8 / (自动资金管理基准资金 / LAtd_16)) * (自动资金管理基准资金 / LAtd_16);
      LAtd_0 = MathRound(基础手数 * LAtd_24 / 自动资金管理基准资金 / GAtd_256) * GAtd_256;
     }
      else
         LAtd_0 = 基础手数;
   if(LAtd_0 < GAtd_240)
      LAtd_0 = GAtd_240;
   if(LAtd_0 > GAtd_248)
      LAtd_0 = GAtd_248;
   if(最大手数>0)
      if(LAtd_0>=最大手数)
         LAtd_0 = 最大手数 ;
   return (LAtd_0);
  }
int f0_21_get手数循环次数()
  {
   int LAti_0 = 手数循环次数;
   if(LAti_0 < 1)
      LAti_0 = 1;
   if(LAti_0 > 15)
      LAti_0 = 15;
   return (LAti_0);
  }
double f0_22_getCustomLotByStep(int AAti_0)
  {
   if(AAti_0 <= 1)
      return (手数1);
   if(AAti_0 == 2)
      return (手数2);
   if(AAti_0 == 3)
      return (手数3);
   if(AAti_0 == 4)
      return (手数4);
   if(AAti_0 == 5)
      return (手数5);
   if(AAti_0 == 6)
      return (手数6);
   if(AAti_0 == 7)
      return (手数7);
   if(AAti_0 == 8)
      return (手数8);
   if(AAti_0 == 9)
      return (手数9);
   if(AAti_0 == 10)
      return (手数10);
   if(AAti_0 == 11)
      return (手数11);
   if(AAti_0 == 12)
      return (手数12);
   if(AAti_0 == 13)
      return (手数13);
   if(AAti_0 == 14)
      return (手数14);
   return (手数15);
  }
double f0_24_getCurrentCustomLot()
  {
   int LAti_0 = f0_21_get手数循环次数();
   if(GAti_customLotStep < 1 || GAti_customLotStep > LAti_0)
      GAti_customLotStep = 1;
   return (f0_22_getCustomLotByStep(GAti_customLotStep));
  }
void f0_23_updateCustomLotCycle()
  {
   if(!启用自定义手数循环)
      return;
   int LAti_0 = f0_21_get手数循环次数();
   int LAti_4 = -1;
   datetime LAtdt_8 = 0;
   double LAtd_16 = 0.0;
   int LAti_24 = -1;
   for(int LAti_28 = OrdersHistoryTotal() - 1; LAti_28 >= 0; LAti_28--)
     {
      if(OrderSelect(LAti_28, SELECT_BY_POS, MODE_HISTORY))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == 魔术号 && OrderType() <= OP_SELL)
           {
            LAti_4 = OrderTicket();
            LAtdt_8 = OrderCloseTime();
            LAtd_16 = OrderProfit() + OrderCommission() + OrderSwap();
            LAti_24 = 1;
            break;
           }
        }
     }
   if(LAti_24 < 0)
      return;
   if(LAtdt_8 == GAtdt_customLotLastClose && LAti_4 == GAti_customLotLastTicket)
      return;
   if(LAtd_16 > 0.0)
      GAti_customLotStep = 1;
   else
     {
      GAti_customLotStep++;
      if(GAti_customLotStep > LAti_0)
         GAti_customLotStep = 1;
     }
   GAtdt_customLotLastClose = LAtdt_8;
   GAti_customLotLastTicket = LAti_4;
  }
void f0_9(int AAti_0)
  {
   bool LAti_16;
   int LAti_4 = 0;
   bool LAti_8 = TRUE;
   while(LAti_8 && LAti_4 < 30)
     {
      LAti_4++;
      LAti_8 = FALSE;
      RefreshRates();
      for(int LAti_12 = OrdersTotal() - 1; LAti_12 >= 0; LAti_12--)
        {
         if(OrderSelect(LAti_12, SELECT_BY_POS, MODE_TRADES))
           {
            if(cd(OrderMagicNumber(), 魔术号))
              {
               if((AAti_0 > 0 &&(OrderType() == OP_BUYSTOP || OrderType() == OP_BUYLIMIT))|| (AAti_0 < 0 &&(OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT)))
                 {
                  if(cd(OrderLots(),最大手数))
                     return;

                  LAti_16 = OrderDelete(OrderTicket());
                  if(!LAti_16)
                    {
                     f0_18();
                     LAti_8 = TRUE;
                    }
                 }
              }
           }
        }
     }
   if(LAti_8)
      Print(魔术号 + " DeleteAllPendingOrders: failed");
  }
bool cd(double number1,double number2)

  {
   if(NormalizeDouble(number1-number2,8)==0)
      return(true);
   else
      return(false);
  }
void f0_12(int AAti_0, int AAti_4, int AAti_8)
  {
   double LAtd_12;
   double LAtd_20;
   double LAtd_28;
   int LAti_36;
   if(AAti_8 == 0 && AAti_4 == 0)
      return;
   if(OrderSelect(AAti_0, SELECT_BY_TICKET))
     {
      LAtd_12 = OrderOpenPrice();
      LAti_36 = OrderType();
      if(LAti_36 == OP_BUY || LAti_36 == OP_BUYSTOP || LAti_36 == OP_BUYLIMIT)
        {
         if(AAti_8 > 0)
            LAtd_20 = f0_11(LAtd_12 + MathMax(AAti_8 * GAtd_216, GAtd_232));
         else
            LAtd_20 = OrderTakeProfit();
         if(AAti_4 > 0)
            LAtd_28 = f0_11(LAtd_12 - MathMax(AAti_4 * GAtd_216, GAtd_232));
         else
            LAtd_28 = OrderStopLoss();
         if(!(f0_11(LAtd_20) != f0_11(OrderTakeProfit()) || f0_11(LAtd_28) != f0_11(OrderStopLoss())))
            return;
         f0_15(AAti_0, LAtd_12, LAtd_28, LAtd_20, 0, Blue);
         return;
        }
      if(!(LAti_36 == OP_SELL || LAti_36 == OP_SELLSTOP || LAti_36 == OP_SELLLIMIT))
         return;
      if(AAti_8 > 0)
         LAtd_20 = f0_11(LAtd_12 - MathMax(AAti_8 * GAtd_216, GAtd_232));
      else
         LAtd_20 = OrderTakeProfit();
      if(AAti_4 > 0)
         LAtd_28 = f0_11(LAtd_12 + MathMax(AAti_4 * GAtd_216, GAtd_232));
      else
         LAtd_28 = OrderStopLoss();
      if(!(f0_11(LAtd_20) != f0_11(OrderTakeProfit()) || f0_11(LAtd_28) != f0_11(OrderStopLoss())))
         return;
      f0_15(AAti_0, LAtd_12, LAtd_28, LAtd_20, 0, Red);
      return;
     }
   Print("Error selecting order #", AAti_0);
  }
void f0_15(int AAti_0, double AAtd_4, double AAtd_12, double AAtd_20, int AAti_28, color AAti_32)
  {
   bool LAti_40;
   for(int LAti_36 = 0; LAti_36 < 10; LAti_36++)
     {
      while(!IsTradeAllowed())
         Sleep(1000);
      RefreshRates();
      LAti_40 = OrderModify(AAti_0, AAtd_4, AAtd_12, AAtd_20, AAti_28, AAti_32);
      if(LAti_40)
         break;
      f0_18();
      Print(魔术号, "ticket = ", AAti_0, " price = ", f0_1(AAtd_4), " sl = ", f0_1(AAtd_12), " tp = ", f0_1(AAtd_20), " stop_level =", f0_1(GAtd_232));
      Print(魔术号, "OrderOpenPrice = ", f0_1(OrderOpenPrice()), " OrderStopLoss = ", f0_1(OrderStopLoss()), " OrderTakeProfit = ", f0_1(OrderTakeProfit()));
     }
  }
double f0_16(double AAtd_0)
  {
   double LAtd_8 = NormalizeDouble(MathRound(AAtd_0 / GAtd_256) * GAtd_256, GAti_280);
   if(LAtd_8 < GAtd_240)
      LAtd_8 = GAtd_240;
   return (LAtd_8);
  }
string f0_1(double AAtd_0)
  {
   return (DoubleToStr(AAtd_0, Digits));
  }
string f0_17(double AAtd_0)
  {
   return (DoubleToStr(AAtd_0, 2));
  }
void f0_19()
  {
   int LAti_8;
   int LAti_12;
   double LAtd_16;
   int LAti_32;
   int LAti_36;
   double LAtd_24 = f0_11(过滤参数 * GAtd_216);
   if(GAti_432 == 0)
     {
      LAti_32 = 10;
      if(iBars(NULL, PERIOD_M1) > 0)
         LAti_36 = 1;
      else
        {
         if(iBars(NULL, Period()) > 0)
            LAti_36 = Period();
         else
            LAti_36 = 0;
        }
      if(LAti_36 > 0)
        {
         for(int LAti_4 = 2; LAti_4 < MathMin(10000, iBars(NULL, LAti_36)); LAti_4++)
           {
            LAti_8 = LAti_4;
            if(MathAbs(iClose(NULL, LAti_36, LAti_4) - iClose(NULL, LAti_36, 1)) > LAti_32 * LAtd_24)
               break;
           }
         LAtd_16 = GAti_200 * GAtd_216;
         GAtd_508 = LAtd_16 + MathFloor((iClose(NULL, LAti_36, LAti_8) - LAtd_16) / LAtd_24) * LAtd_24;
        }
      else
        {
         LAti_8 = 0;
         LAtd_16 = GAti_200 * GAtd_216;
         GAtd_508 = LAtd_16 + MathFloor((Close[0] - LAtd_16) / LAtd_24) * LAtd_24;
        }
      GAtd_492 = GAtd_508;
      GAtd_500 = GAtd_508 - LAtd_24;
      GAtd_524 = GAtd_492;
      GAtd_532 = GAtd_500;
      GAti_432 = 1;
      for(LAti_4 = LAti_8 - 1; LAti_4 >= 1; LAti_4--)
        {
         LAti_12 = iHigh(NULL, LAti_36, LAti_4) + iLow(NULL, LAti_36, LAti_4) > iHigh(NULL, LAti_36, LAti_4 + 1) + iLow(NULL, LAti_36, LAti_4 + 1);
         GAtd_524 = MathMax(GAtd_524, iHigh(NULL, LAti_36, LAti_4));
         for(GAtd_532 = MathMin(GAtd_532, iLow(NULL, LAti_36, LAti_4)); LAti_12 && iLow(NULL, LAti_36, LAti_4) <= GAtd_500 - LAtd_24; GAtd_532 = EMPTY_VALUE)
           {
            GAtd_492 -= LAtd_24;
            GAtd_500 -= LAtd_24;
            GAtd_508 = GAtd_500;
            if(GAti_432 > 0)
               GAti_432 = -1;
            else
               GAti_432--;
            f0_20(GAtd_492, GAtd_500, MathMax(GAtd_524, GAtd_492), GAtd_500);
            GAtd_524 = 0;
           }
         while(iHigh(NULL, LAti_36, LAti_4) >= GAtd_492 + LAtd_24)
           {
            GAtd_492 += LAtd_24;
            GAtd_500 += LAtd_24;
            GAtd_508 = GAtd_492;
            if(GAti_432 < 0)
               GAti_432 = 1;
            else
               GAti_432++;
            f0_20(GAtd_500, MathMin(GAtd_532, GAtd_500), GAtd_492, GAtd_492);
            GAtd_524 = 0;
            GAtd_532 = EMPTY_VALUE;
           }
         while(!LAti_12 && iLow(NULL, LAti_36, LAti_4) < GAtd_500 - LAtd_24)
           {
            GAtd_492 -= LAtd_24;
            GAtd_500 -= LAtd_24;
            GAtd_508 = GAtd_500;
            if(GAti_432 > 0)
               GAti_432 = -1;
            else
               GAti_432--;
            f0_20(GAtd_492, GAtd_500, MathMax(GAtd_524, GAtd_492), GAtd_500);
            GAtd_524 = 0;
            GAtd_532 = EMPTY_VALUE;
           }
        }
     }
   if(GAti_432 != 0)
     {
      GAtd_524 = MathMax(GAtd_524, Bid);
      if(Bid > 0.0)
         GAtd_532 = MathMin(GAtd_532, Bid);
      if(Bid >= GAtd_492 + LAtd_24)
        {
         GAtd_492 += LAtd_24;
         GAtd_500 += LAtd_24;
         GAtd_508 = GAtd_492;
         if(GAti_432 < 0)
            GAti_432 = 1;
         else
            GAti_432++;
         f0_20(GAtd_500, MathMin(GAtd_532, GAtd_500), MathMax(GAtd_524, GAtd_492), GAtd_492);
         GAtd_524 = 0;
         GAtd_532 = EMPTY_VALUE;
        }
      if(Bid <= GAtd_500 - LAtd_24)
        {
         GAtd_492 -= LAtd_24;
         GAtd_500 -= LAtd_24;
         GAtd_508 = GAtd_500;
         if(GAti_432 > 0)
            GAti_432 = -1;
         else
            GAti_432--;
         f0_20(GAtd_492, MathMin(GAtd_532, GAtd_500), MathMax(GAtd_524, GAtd_492), GAtd_500);
         GAtd_524 = 0;
         GAtd_532 = EMPTY_VALUE;
        }
     }
  }
double FUN_03(int Ai_0)
  {
   double Ld_4 = 0;
   if(OrdersTotal() > 0)
     {
      for(int Li_12 = OrdersTotal() - 1; Li_12 >= 0; Li_12--)
        {
         if(OrderSelect(Li_12, SELECT_BY_POS, MODE_TRADES) == TRUE)
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == 魔术号)
                 {
                  if(OrderType() == Ai_0)
                    {
                     Ld_4 = OrderOpenPrice() - OrderTakeProfit();
                     break;
                    }
                 }
              }
           }
        }
     }
   return (MathAbs(Ld_4) / Point);
  }
double FUN_02(int Ai_0)
  {
   double Ld_4 = 0;
   if(OrdersTotal() > 0)
     {
      for(int Li_12 = OrdersTotal() - 1; Li_12 >= 0; Li_12--)
        {
         if(OrderSelect(Li_12, SELECT_BY_POS, MODE_TRADES) == TRUE)
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == 魔术号)
                 {
                  if(OrderType() == Ai_0)
                    {
                     Ld_4 = OrderLots() ;
                     break;
                    }
                 }
              }
           }
        }
     }
   return (Ld_4) ;
  }
double FUN_01(int Ai_0)
  {
   double Ld_4 = 0;
   if(OrdersTotal() > 0)
     {
      for(int Li_12 = OrdersTotal() - 1; Li_12 >= 0; Li_12--)
        {
         if(OrderSelect(Li_12, SELECT_BY_POS, MODE_TRADES) == TRUE)
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == 魔术号)
                 {
                  if(OrderType() == Ai_0)
                    {
                     Ld_4 = OrderOpenPrice() - OrderStopLoss();
                     break;
                    }
                 }
              }
           }
        }
     }
   return (MathAbs(Ld_4) / Point);
  }
double Gd_128;
double Gd_136;
double Gd_144;
double Gd_152;
void FUN_057()
  {
   double Ld_0 = MarketInfo(Symbol(), MODE_TICKVALUE);
   Gd_152 = FUN_03(OP_SELLSTOP) * Ld_0 *FUN_02(OP_SELLSTOP);
   Gd_144 = FUN_03(OP_BUYSTOP) * Ld_0  *FUN_02(OP_SELLSTOP);
   double Ld_8 = FUN_03(OP_BUY) *FUN_02(0);
   double Ld_16 = FUN_03(OP_SELL) *FUN_02(1);
   Gd_128 = 0;
   if(Ld_8 > 0.0)
      Gd_128 = Ld_8;
   if(Ld_16 > 0.0)
      Gd_128 = Ld_16;
   Gd_136 = 0;
   double Ld_24 = FUN_01(OP_BUY) *FUN_02(0);
   double Ld_32 = FUN_01(OP_SELL) *FUN_02(1);
   if(Ld_24 > 0.0)
      Gd_136 = Ld_24;
   if(Ld_32 > 0.0)
      Gd_136 = Ld_32;

  }
void f0_20(double AAtd_0, double AAtd_8, double AAtd_16, double AAtd_24)
  {
   for(int LAti_32 = GAti_284; LAti_32 > 1; LAti_32--)
     {
      GAtda_436[LAti_32] = GAtda_436[LAti_32 - 1];
      GAtda_440[LAti_32] = GAtda_440[LAti_32 - 1];
      GAtda_444[LAti_32] = GAtda_444[LAti_32 - 1];
      GAtda_448[LAti_32] = GAtda_448[LAti_32 - 1];
     }
   GAtda_436[1] = AAtd_0;
   GAtda_440[1] = AAtd_8;
   GAtda_444[1] = AAtd_16;
   GAtda_448[1] = AAtd_24;
  }
void f0_4()
  {
   int LAti_8;
   int LAti_12;
   double LAtd_16;
   int LAti_32;
   int LAti_36;
   double LAtd_24 = f0_11(GAti_120 * GAtd_216);
   if(GAti_472 == 0)
     {
      LAti_32 = 10;
      if(iBars(NULL, PERIOD_M1) > 0)
         LAti_36 = 1;
      else
        {
         if(iBars(NULL, Period()) > 0)
            LAti_36 = Period();
         else
            LAti_36 = 0;
        }
      if(LAti_36 > 0)
        {
         for(int LAti_4 = 2; LAti_4 < MathMin(10000, iBars(NULL, LAti_36)); LAti_4++)
           {
            LAti_8 = LAti_4;
            if(MathAbs(iClose(NULL, LAti_36, LAti_4) - iClose(NULL, LAti_36, 1)) > LAti_32 * LAtd_24)
               break;
           }
         LAtd_16 = GAti_200 * GAtd_216;
         GAtd_556 = LAtd_16 + MathFloor((iClose(NULL, LAti_36, LAti_8) - LAtd_16) / LAtd_24) * LAtd_24;
        }
      else
        {
         LAti_8 = 0;
         LAtd_16 = GAti_200 * GAtd_216;
         GAtd_556 = LAtd_16 + MathFloor((Close[0] - LAtd_16) / LAtd_24) * LAtd_24;
        }
      GAtd_540 = GAtd_556;
      GAtd_548 = GAtd_556 - LAtd_24;
      GAtd_572 = GAtd_540;
      GAtd_580 = GAtd_548;
      GAti_472 = 1;
      for(LAti_4 = LAti_8 - 1; LAti_4 >= 1; LAti_4--)
        {
         LAti_12 = iHigh(NULL, LAti_36, LAti_4) + iLow(NULL, LAti_36, LAti_4) > iHigh(NULL, LAti_36, LAti_4 + 1) + iLow(NULL, LAti_36, LAti_4 + 1);
         GAtd_572 = MathMax(GAtd_572, iHigh(NULL, LAti_36, LAti_4));
         for(GAtd_580 = MathMin(GAtd_580, iLow(NULL, LAti_36, LAti_4)); LAti_12 && iLow(NULL, LAti_36, LAti_4) <= GAtd_548 - LAtd_24; GAtd_580 = EMPTY_VALUE)
           {
            GAtd_540 -= LAtd_24;
            GAtd_548 -= LAtd_24;
            GAtd_556 = GAtd_548;
            if(GAti_472 > 0)
               GAti_472 = -1;
            else
               GAti_472--;
            f0_6(GAtd_540, GAtd_548, MathMax(GAtd_572, GAtd_540), GAtd_548);
            GAtd_572 = 0;
           }
         while(iHigh(NULL, LAti_36, LAti_4) >= GAtd_540 + LAtd_24)
           {
            GAtd_540 += LAtd_24;
            GAtd_548 += LAtd_24;
            GAtd_556 = GAtd_540;
            if(GAti_472 < 0)
               GAti_472 = 1;
            else
               GAti_472++;
            f0_6(GAtd_548, MathMin(GAtd_580, GAtd_548), GAtd_540, GAtd_540);
            GAtd_572 = 0;
            GAtd_580 = EMPTY_VALUE;
           }
         while(!LAti_12 && iLow(NULL, LAti_36, LAti_4) < GAtd_548 - LAtd_24)
           {
            GAtd_540 -= LAtd_24;
            GAtd_548 -= LAtd_24;
            GAtd_556 = GAtd_548;
            if(GAti_472 > 0)
               GAti_472 = -1;
            else
               GAti_472--;
            f0_6(GAtd_540, GAtd_548, MathMax(GAtd_572, GAtd_540), GAtd_548);
            GAtd_572 = 0;
            GAtd_580 = EMPTY_VALUE;
           }
        }
     }
   if(GAti_472 != 0)
     {
      GAtd_572 = MathMax(GAtd_572, Bid);
      if(Bid > 0.0)
         GAtd_580 = MathMin(GAtd_580, Bid);
      if(Bid >= GAtd_540 + LAtd_24)
        {
         GAtd_540 += LAtd_24;
         GAtd_548 += LAtd_24;
         GAtd_556 = GAtd_540;
         if(GAti_472 < 0)
            GAti_472 = 1;
         else
            GAti_472++;
         f0_6(GAtd_548, MathMin(GAtd_580, GAtd_548), MathMax(GAtd_572, GAtd_540), GAtd_540);
         GAtd_572 = 0;
         GAtd_580 = EMPTY_VALUE;
        }
      if(Bid <= GAtd_548 - LAtd_24)
        {
         GAtd_540 -= LAtd_24;
         GAtd_548 -= LAtd_24;
         GAtd_556 = GAtd_548;
         if(GAti_472 > 0)
            GAti_472 = -1;
         else
            GAti_472--;
         f0_6(GAtd_540, MathMin(GAtd_580, GAtd_548), MathMax(GAtd_572, GAtd_540), GAtd_548);
         GAtd_572 = 0;
         GAtd_580 = EMPTY_VALUE;
        }
     }
  }
void f0_6(double AAtd_0, double AAtd_8, double AAtd_16, double AAtd_24)
  {
   for(int LAti_32 = GAti_284; LAti_32 > 1; LAti_32--)
     {
      GAtda_476[LAti_32] = GAtda_476[LAti_32 - 1];
      GAtda_480[LAti_32] = GAtda_480[LAti_32 - 1];
      GAtda_484[LAti_32] = GAtda_484[LAti_32 - 1];
      GAtda_488[LAti_32] = GAtda_488[LAti_32 - 1];
     }
   GAtda_476[1] = AAtd_0;
   GAtda_480[1] = AAtd_8;
   GAtda_484[1] = AAtd_16;
   GAtda_488[1] = AAtd_24;
  }
double f0_11(double AAtd_0)
  {
   return (NormalizeDouble(AAtd_0, Digits));
  }
int f0_18()
  {
   int LAti_0 = GetLastError();
   Print("ERROR (" + LAti_0 + ")");
   if(LAti_0 == 130|| LAti_0 == 129|| LAti_0 == 138|| LAti_0 == 135||LAti_0 == 136)
     {
      RefreshRates();
      return (1);
     }
   if(LAti_0 == 146||LAti_0 == 133|| LAti_0 == 128||LAti_0 == 139)
     {
      Sleep(500);
      RefreshRates();
      return (1);
     }
   if(LAti_0 == 4 || LAti_0 == 137|| LAti_0 == 4022|| LAti_0 == 6|| LAti_0 == 141||
      LAti_0 == 8)
     {
      Sleep(1500);
      RefreshRates();
      return (1);
     }
   if(LAti_0 == 147)
     {
      RefreshRates();
      return (1);
     }
   if(LAti_0 != 0)
     {
      Sleep(500);
      RefreshRates();
      return (0);
     }
   return (0);
  }
int f0_8(string AAts_0)
  {
   GAts_588 = GAts_588 + AAts_0;
   return (0);
  }
int f0_10()
  {
   int LAti_0;
   string LAts_24;
   int LAti_32;
   if(GAti_644)
      LAti_0 = WindowFind("Empty");
   else
      LAti_0 = 0;
   if(LAti_0 < 0)
      return (0);
   int LAti_4 = 0;
   int LAti_8 = 0;
   int LAti_12 = 0;
   string LAts_16 = "";
   while(LAti_8 < StringLen(GAts_588))
     {
      LAti_12 = StringFind(GAts_588,
                           "\n", LAti_8);
      if(LAti_12 < 0)
         LAti_12 = StringLen(GAts_588);
      LAts_16 = StringSubstr(GAts_588, LAti_8, LAti_12 - LAti_8);
      LAti_8 = LAti_12 + 1;
      LAts_24 = GAts_596 + DoubleToStr(LAti_4, 0);
      LAti_32 = GAti_624 + 注释行高 * LAti_4;
      ObjectCreate(LAts_24, OBJ_LABEL, LAti_0, 0, 0, 0, 0);
      ObjectSet(LAts_24, OBJPROP_CORNER, GAti_604);
      if(LAti_4 < GAti_636 + GAti_640 || (!GAti_644))
        {
         ObjectSet(LAts_24, OBJPROP_XDISTANCE, GAti_620);
         ObjectSet(LAts_24, OBJPROP_YDISTANCE, LAti_32);
        }
      else
        {
         ObjectSet(LAts_24, OBJPROP_XDISTANCE, GAti_620 + GAti_632);
         ObjectSet(LAts_24, OBJPROP_YDISTANCE, LAti_32 - GAti_640 * 注释行高);
        }
      ObjectSetText(LAts_24, LAts_16, 注释字体大小, GAts_tahoma_612, 注释颜色);
      LAti_4++;
     }
   for(LAts_24 = GAts_596 + DoubleToStr(LAti_4, 0); ObjectFind(LAts_24) >= 0; LAts_24 = GAts_596 + DoubleToStr(LAti_4, 0))
     {
      ObjectDelete(LAts_24);
      LAti_4++;
     }
   Comment("");
   return (0);
  }
int f0_5()
  {
   GAts_588 = "";
   return (0);
  }
void FUN_06(string Name,double price,color Colour,int Width,int Style)
  {
   if(绘制线条==0)
     {
      ObjectDelete("Q_S_1");
      ObjectDelete("Q_S_2");
      return;
     }
   ObjectCreate(0,Name,OBJ_HLINE,0,0,price);
   ObjectSetInteger(0,Name,OBJPROP_COLOR,Colour);
   ObjectSetInteger(0,Name,OBJPROP_WIDTH,Width);
   ObjectSetInteger(0,Name,OBJPROP_STYLE,Style);
   if(price>0)
      ObjectMove(0,Name,0,0,price);
  }
double FUN_04()
  {
   double Mq4_LastOpenPrice=0;
   if(OrdersTotal()>0)
      for(int ix=OrdersTotal()-1; ix>=0; ix--)
         if(OrderSelect(ix,SELECT_BY_POS,MODE_TRADES)==true)
            if(OrderSymbol()==Symbol())
               if(OrderMagicNumber()==魔术号)

                  if(OrderType()==0||OrderType()==OP_BUYSTOP)
                    {
                     Mq4_LastOpenPrice=OrderOpenPrice();
                     break;
                    }

   return(Mq4_LastOpenPrice);
  }
double FUN_05()
  {
   double Mq4_LastOpenPrice=0;
   if(OrdersTotal()>0)
      for(int ix=OrdersTotal()-1; ix>=0; ix--)
         if(OrderSelect(ix,SELECT_BY_POS,MODE_TRADES)==true)
            if(OrderSymbol()==Symbol())
               if(OrderMagicNumber()==魔术号)

                  if(OrderType()==1||OrderType()==OP_SELLSTOP)
                    {
                     Mq4_LastOpenPrice=OrderOpenPrice();
                     break;
                    }

   return(Mq4_LastOpenPrice);
  }
void f0_13()
  {
   FUN_06("Q_S_1", FUN_04(),  上涨颜色,1,2);
   FUN_06("Q_S_2", FUN_05(),  下跌颜色,1,2);
   string LAts_0 = "a" + GAts_76 + "Box";
   if(ObjectFind(LAts_0) < 0)
     {
      ObjectCreate(LAts_0, OBJ_LABEL, 0, 0, 0);
      ObjectSetText(LAts_0, "g", 185, "Webdings", 框颜色);
      ObjectSet(LAts_0, OBJPROP_XDISTANCE, 5);
      ObjectSet(LAts_0, OBJPROP_YDISTANCE, 25);
      ObjectSet(LAts_0, OBJPROP_CORNER, GAti_604);
     }
   LAts_0 = "a" + GAts_76 + "Box2";
   if(ObjectFind(LAts_0) < 0)
     {
      ObjectCreate(LAts_0, OBJ_LABEL, 0, 0, 0);
      ObjectSetText(LAts_0, "g", 185, "Webdings", 框颜色);
      ObjectSet(LAts_0, OBJPROP_XDISTANCE, 5);
      ObjectSet(LAts_0, OBJPROP_YDISTANCE, 205);
      ObjectSet(LAts_0, OBJPROP_CORNER, GAti_604);
     }
   f0_5();
   f0_8(GAts_76
        + "\n");
   f0_8(" \n");
   if(停止挂单)
     {
      f0_8("【已开启停止挂单】");
      f0_8(" \n");      
     }
   f0_8("当前多单挂单价: " + f0_1(GAtd_288)
        + "\n");
   f0_8("当前空单挂单价: " + f0_1(GAtd_296)
        + "\n");
   f0_8(" \n");
   f0_8("下次开仓手数: " + f0_17(GAtd_368)
        + "\n");
   if(启用自定义手数循环)
      f0_8("手数循环进度: 第" + GAti_customLotStep + "/" + f0_21_get手数循环次数() + "笔\n");
   if(启用EMA方向倍投)
      f0_8("EMA方向倍投: " + f0_26_getDirectionalLotBiasText() + "\n");
   f0_8(" \n");
   if(GAti_392>0)
      f0_8("BUY挂单数量 = " + GAti_392
           + "\n");
   if(GAti_396>0)
      f0_8("SELL挂单数量 = " + GAti_396
           + "\n");
   f0_8(" \n");
   if(GAti_156)
     {
      f0_8("连续亏损订单数 = " + GAti_312 + "\n");
      f0_8("当前亏损金额 = " + f0_17(GAtd_320) + "\n");
     }
   FUN_057();
   f0_8(" \n");
   f0_8("市场止盈潜力 = " + DoubleToStr(Gd_128,2) + "\n");
   f0_8("市场止损风险 = -" + DoubleToStr(Gd_136,2) + "\n");
   f0_8("BUY挂单止盈潜力 = " + DoubleToStr(Gd_144,2) + "\n");
   f0_8("SELL挂单止盈潜力 = " + DoubleToStr(Gd_152,2) + "\n");
   f0_10();
  }
/*
//+------------------------------------------------------------------+
//|                                                       突破EA.mq4 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
extern string xxx00 = "--- 常规 ---";                 // 分组标题：常规设置
extern bool Flag_Stop =false;                    // 是否停止交易：TRUE 时不再推进开新单/挂单逻辑
extern string xxx1 = "--- 逻辑 ---";                  // 分组标题：交易逻辑参数
extern int Filter = 30;                           // 过滤/触发距离（用于计算止盈/止损距离等）
extern int  Filter2=0;                           // 第二过滤项（当前版本代码里不明显使用，可保留默认）
extern double TPfact = 1.6;                      // 止盈系数：会参与计算（通常为 TPfact * Filter）
extern double SLfact = 2.0;                      // 止损系数：会参与计算（通常为 SLfact * Filter）
extern int TakeProfit_Martin = 7;                // 马丁止盈倍数（用于“下一波/目标利润”的计算）
extern int Indent = 0;                            // 订单偏移/间距（用于设置挂单的相对价格）
extern datetime IgnoreDDBeforeDate=315532800;   // 忽略DD早于此时间（用于回测/统计类逻辑）
extern bool GapeProtect=true  ;                   // 缺口保护：用于跳价/间隙情况下的处理开关
extern string xxx2 = "--- 马丁参数 ---";               // 分组标题：马丁/资金管理参数
extern double LotSize = 0.01;        // 初始/基础手数（非自动资金管理时直接用）
extern double MaxLotSize=0.0;                    // 最大手数限制：0=不限制，否则对计算出的手数做上限裁剪
extern int MaxLossStepsReset=15;                 // 当 UseCustomLotCycle=false 且连续亏损笔数>=该值时，封顶重置为初始手数（0=不启用）
extern bool AutoMM =false;                       // 自动资金管理开关：TRUE 时按资金比例动态计算手数
extern double AutoMMEquity = 10000.0;            // 自动资金管理基准资金：用于把当前资金映射到手数倍率
extern bool UseCustomLotCycle=true;              // 是否启用自定义手数循环
extern int CustomLotCycleCount=15;               // 自定义手数循环次数（1-15）
extern double CustomLot1=0.01;                   // 第1笔手数
extern double CustomLot2=0.03;                   // 第2笔手数
extern double CustomLot3=0.05;                   // 第3笔手数
extern double CustomLot4=0.08;                   // 第4笔手数
extern double CustomLot5=0.12;                   // 第5笔手数
extern double CustomLot6=0.18;                   // 第6笔手数
extern double CustomLot7=0.27;                   // 第7笔手数
extern double CustomLot8=0.40;                   // 第8笔手数
extern double CustomLot9=0.60;                   // 第9笔手数
extern double CustomLot10=0.90;                  // 第10笔手数
extern double CustomLot11=1.20;                  // 第11笔手数
extern double CustomLot12=1.60;                  // 第12笔手数
extern double CustomLot13=2.00;                  // 第13笔手数
extern double CustomLot14=2.50;                  // 第14笔手数
extern double CustomLot15=3.00;                  // 第15笔手数
extern bool UseEMA14DirectionLotBias=true;        // 是否启用EMA方向倍投过滤
extern int EMADirectionPeriod=14;                 // EMA周期（默认14）
extern bool RequireEMASlope=true;                 // 是否要求EMA方向斜率一致
extern double TrendDirectionMultiplier=1.5;       // 顺势方向手数系数
extern double NonTrendDirectionMultiplier=1.0;    // 非顺势方向手数系数（平投=1.0）
extern string xxx3 = "--- 杂项 ---";                 // 分组标题：显示与杂项
extern int Magic = 8893;                         // 魔术号：EA 自己的订单用此值区分
extern bool Verbose =true;                      // 是否打印详细日志（对调试/观察很有用）
extern color comment_color = White;             // 注释文字颜色（显示在图表左上/固定区域）
extern int  comment_fontsize=11;               // 注释字体大小
extern int  comment_lineheight=18;            // 注释行高（文字堆叠间距）
extern color box_color = DarkSlateGray;        // 注释框/标记颜色
extern bool DrawLines=true;                      // 是否绘制水平线（用于显示关键价格位）
extern color ColorUp=16748574;                  // 上涨线颜色（多单相关）
extern color ColorLo=7504122;                   // 下跌线颜色（空单相关）
bool GAti_192 =true;
int GAti_196 = 0;
int GAti_200 = 0;
bool GAti_156 =true;
int GAti_120 = 15;
string GAts_76;
int GAti_84 = 3;
double GAtd_216;
double GAtd_224;
double GAtd_232;
double GAtd_240;
double GAtd_248;
double GAtd_256;
double GAtd_264;
double GAtd_272;
int GAti_280;
int GAti_284 = 999;
double GAtd_288 = 0.0;
double GAtd_296 = 0.0;
int GAti_304 = 0;
int GAti_308 = 0;
int GAti_312 = 0;
int GAti_316 = 0;
double GAtd_320 = 0.0;
double GAtd_328 = 0.0;
double GAtd_336 = 0.0;
double GAtd_344 = 0.0;
double GAtd_352 = 0.0;
double GAtd_360 = 0.0;
double GAtd_368;
double GAtd_376;
int GAti_384 = 0;
int GAti_388 = 0;
int GAti_392 = 0;
int GAti_396 = 0;
int GAti_400;
int GAti_404;
int GAti_412 = 0;
double GAtd_416 = 0.0;
double GAtd_424 = 0.0;
int GAti_432;
double GAtda_436[1001];
double GAtda_440[1001];
double GAtda_444[1001];
double GAtda_448[1001];
int GAti_452 = 0;
double GAtd_456 = 0.0;
double GAtd_464 = 0.0;
int GAti_472;
double GAtda_476[1001];
double GAtda_480[1001];
double GAtda_484[1001];
double GAtda_488[1001];
double GAtd_492;
double GAtd_500;
double GAtd_508;
double GAtd_524;
double GAtd_532;
double GAtd_540;
double GAtd_548;
double GAtd_556;
double GAtd_572;
double GAtd_580;
string GAts_588 = "";
string GAts_596 = "comment_textbox";
int GAti_604 = 0;
string GAts_tahoma_612 = "Tahoma";
int GAti_620 = 12;
int GAti_624 = 40;
int GAti_632 = 500;
int GAti_636 = 4;
int GAti_640 = 10;
bool GAti_644 = FALSE;
int GAti_customLotStep = 1;
datetime GAtdt_customLotLastClose = 0;
int GAti_customLotLastTicket = 0;
int init()
  {
   if(Digits < 4)
      GAtd_216 = 0.01;
   else
      GAtd_216 = 0.0001;
   if(StringSubstr(Symbol(), 0, 6) == "XAGUSD")
     {
      GAtd_216 = 0.01;
      Print("Metals: silver");
      Print("Point = ", f0_1(Point), "  Digits = ", Digits, "  point4 = ", f0_1(GAtd_216));
      Print("Tick value = ", MarketInfo(Symbol(), MODE_TICKVALUE));
      Print("Price of pip = ", MarketInfo(Symbol(), MODE_TICKVALUE) * GAtd_216 / Point);
     }
   else
     {
      if(StringSubstr(Symbol(), 0, 6) == "XAUUSD" || StringSubstr(Symbol(), 0, 4) == "GOLD" || StringSubstr(Symbol(), 0, 4) == "Gold")
        {
         GAtd_216 = 0.1;
         Print("Metals: gold");
         Print("Point = ", f0_1(Point), "  Digits = ", Digits, "  point4 = ", f0_1(GAtd_216));
         Print("Tick value = ", MarketInfo(Symbol(), MODE_TICKVALUE));
         Print("Price of pip = ", MarketInfo(Symbol(), MODE_TICKVALUE) * GAtd_216 / Point);
        }
     }
   GAts_76 = WindowExpertName();
   GAti_400 = TPfact * Filter;
   GAti_404 = SLfact * Filter;
   GAtd_240 = MarketInfo(Symbol(), MODE_MINLOT);
   GAtd_248 = MarketInfo(Symbol(), MODE_MAXLOT);
   GAtd_256 = MarketInfo(Symbol(), MODE_LOTSTEP);
   GAtd_264 = MarketInfo(Symbol(), MODE_TICKVALUE);
   GAtd_272 = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   if(GAtd_256 < 0.1)
      GAti_280 = 2;
   else
     {
      if(GAtd_256 < 1.0)
         GAti_280 = 1;
      else
         GAti_280 = 0;
     }
   GAtd_232 = MathMax(MarketInfo(Symbol(), MODE_STOPLEVEL) * Point, 2.0 * (Ask - Bid));
   if(GAti_196 == 0)
      GAtd_224 = MarketInfo(Symbol(), MODE_SPREAD) * Point;
   else
      GAtd_224 = GAti_196 * GAtd_216;
   Print("Ask-Bid = ", f0_1(Ask - Bid));
   Print("spread = ", f0_1(GAtd_224));
   Print("stop_level = ", f0_1(GAtd_232));
   Print("point4 = ", f0_1(GAtd_216));
   double LAtd_0 = 0;
   double LAtd_8 = 0;
   f0_19();
   for(int LAti_16 = 0; LAti_16 <= Bars - 4; LAti_16++)
     {
      f0_2(LAti_16);
      if(LAtd_0 == 0.0 && GAtd_424 > 0.0)
         LAtd_0 = GAtd_424;
      if(LAtd_8 == 0.0 && GAtd_416 > 0.0)
         LAtd_8 = GAtd_416;
      if(LAtd_8 > 0.0 && LAtd_0 > 0.0)
         break;
     }
   GAtd_424 = LAtd_0;
   GAtd_416 = LAtd_8;
   if(Verbose)
      Print("LastMax_1 = ", f0_1(GAtd_416));
   if(Verbose)
      Print("LastMin_1 = ", f0_1(GAtd_424));
   double LAtd_20 = 0;
   double LAtd_28 = 0;
   f0_4();
   for(LAti_16 = 0; LAti_16 <= Bars - 4; LAti_16++)
     {
      f0_0(LAti_16);
      if(LAtd_20 == 0.0 && GAtd_464 > 0.0)
         LAtd_20 = GAtd_464;
      if(LAtd_28 == 0.0 && GAtd_456 > 0.0)
         LAtd_28 = GAtd_456;
      if(LAtd_28 > 0.0 && LAtd_20 > 0.0)
         break;
     }
   GAtd_464 = LAtd_20;
   GAtd_456 = LAtd_28;
   if(Verbose)
      Print("LastMax_2 = ", f0_1(GAtd_456));
   if(Verbose)
      Print("LastMin_2 = ", f0_1(GAtd_464));
   return (0);
  }
void f0_2(int AAti_0 = 0)
  {
   if(GAtda_436[AAti_0 + 1] > GAtda_448[AAti_0 + 1] && GAtda_436[AAti_0 + 2] < GAtda_448[AAti_0 + 2])
      GAtd_416 = f0_11(MathMax(GAtda_444[AAti_0 + 1], GAtda_444[AAti_0 + 2]));
   if(GAtda_436[AAti_0 + 1] < GAtda_448[AAti_0 + 1] && GAtda_436[AAti_0 + 2] > GAtda_448[AAti_0 + 2])
      GAtd_424 = f0_11(MathMin(GAtda_440[AAti_0 + 1], GAtda_440[AAti_0 + 2]));
  }
void f0_0(int AAti_0 = 0)
  {
   if(GAtda_476[AAti_0 + 1] > GAtda_488[AAti_0 + 1] && GAtda_476[AAti_0 + 2] < GAtda_488[AAti_0 + 2])
      GAtd_456 = f0_11(MathMax(GAtda_484[AAti_0 + 1], GAtda_484[AAti_0 + 2]));
   if(GAtda_476[AAti_0 + 1] < GAtda_488[AAti_0 + 1] && GAtda_476[AAti_0 + 2] > GAtda_488[AAti_0 + 2])
      GAtd_464 = f0_11(MathMin(GAtda_480[AAti_0 + 1], GAtda_480[AAti_0 + 2]));
  }
void deinit()
  {
   f0_5();
   f0_10();
   ObjectDelete("Q_S_1");
   ObjectDelete("Q_S_2");
   string LAts_0 = "a" + GAts_76 + "Box";
   ObjectDelete(LAts_0);
   LAts_0 = "a" + GAts_76 + "Box2";
   ObjectDelete(LAts_0);
  }
  void OnTick()
  {
 start0();
  }
int start0()
  {
   f0_13();
   f0_23_updateCustomLotCycle();
   int LAti_0;
   double LAtd_4;
   double LAtd_12;
   double LAtd_20;
   int LAti_36;
   bool LAti_52;
   double LAtd_56;
   double LAtd_112;
   double LAtd_120;
   double LAtd_128;
   int LAti_136;
   int LAti_172;
   double LAtd_176;
   GAti_400 = TPfact * Filter;
   GAti_404 = SLfact * Filter;
   double LAtd_64 = GAtd_416;
   double LAtd_72 = GAtd_424;
   if(GAtd_416 <= 0.0)
      GAtd_416 = MathMax(iHigh(NULL, PERIOD_D1, 1), Ask + Filter * GAtd_216);
   if(GAtd_424 <= 0.0)
      GAtd_424 = MathMin(iLow(NULL, PERIOD_D1, 1), Bid - Filter * GAtd_216);
   if(GAtd_416 <= 0.0 || GAtd_424 <= 0.0)
     {
      Comment("Not enough quotes");
      Print("Not enough quotes");
      return (0);
     }
   double LAtd_80 = GAtd_456;
   double LAtd_88 = GAtd_464;
   if(GAtd_456 <= 0.0)
      GAtd_456 = MathMax(iHigh(NULL, PERIOD_D1, 1), Ask + GAti_120 * GAtd_216);
   if(GAtd_464 <= 0.0)
      GAtd_464 = MathMin(iLow(NULL, PERIOD_D1, 1), Bid - GAti_120 * GAtd_216);
   if(GAtd_456 <= 0.0 || GAtd_464 <= 0.0)
     {
      Comment("Not enough quotes");
      Print("Not enough quotes");
      return (0);
     }
   LAtd_64 = GAtd_416;
   LAtd_72 = GAtd_424;
   f0_19();
   f0_2();
   if(GAti_412 <= 0 && Bid > GAtd_416)
      GAti_412 = 2;
   if(GAti_412 > 0 && Bid > GAtd_424 && Bid < GAtd_416)
      GAti_412 = 1;
   if(GAti_412 >= 0 && Bid < GAtd_424)
      GAti_412 = -2;
   if(GAti_412 < 0 && Bid > GAtd_424 && Bid < GAtd_416)
      GAti_412 = -1;
   LAtd_80 = GAtd_456;
   LAtd_88 = GAtd_464;
   f0_4();
   f0_0();
   if(GAti_452 <= 0 && Bid > GAtd_456)
      GAti_452 = 2;
   if(GAti_452 > 0 && Bid > GAtd_464 && Bid < GAtd_456)
      GAti_452 = 1;
   if(GAti_452 >= 0 && Bid < GAtd_464)
      GAti_452 = -2;
   if(GAti_452 < 0 && Bid > GAtd_464 && Bid < GAtd_456)
      GAti_452 = -1;
   double LAtd_96 = GAtd_288;
   double LAtd_104 = GAtd_296;
   GAtd_288 = GAtd_416;
   GAtd_296 = GAtd_424;
   if(GAtd_288 != LAtd_96)
     {
      LAti_52 = FALSE;
      for(int LAti_44 = OrdersTotal() - 1; LAti_44 >= 0; LAti_44--)
        {
         if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic)
              {
               LAtd_4 = OrderOpenPrice();
               if(OrderType() == OP_SELL)
                 {
                  LAtd_20 = f0_11(MathMin(GAtd_288 + Indent * GAtd_216 + GAtd_224, LAtd_4 + GAti_404 * GAtd_216));
                  if(LAtd_20 <= OrderStopLoss() - Point)
                    {
                     f0_15(OrderTicket(), OrderOpenPrice(), LAtd_20, OrderTakeProfit(), 0, Red);
                     LAti_52 = TRUE;
                    }
                 }
              }
           }
        }
      if(LAti_52 && GAti_156)
         f0_9(1);
     }
   if(GAtd_296 != LAtd_104)
     {
      LAti_52 = FALSE;
      for(LAti_44 = OrdersTotal() - 1; LAti_44 >= 0; LAti_44--)
        {
         if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic)
              {
               LAtd_4 = OrderOpenPrice();
               if(OrderType() == OP_BUY)
                 {
                  LAtd_20 = f0_11(MathMax(GAtd_296 - Indent * GAtd_216, LAtd_4 - GAti_404 * GAtd_216));
                  if(LAtd_20 >= OrderStopLoss() + Point)
                    {
                     f0_15(OrderTicket(), OrderOpenPrice(), LAtd_20, OrderTakeProfit(), 0, Blue);
                     LAti_52 = TRUE;
                    }
                 }
              }
           }
        }
      if(LAti_52 && GAti_156)
         f0_9(-1);
     }
   if(GAtd_288 != LAtd_96 || GAtd_296 != LAtd_104)
     {
      for(LAti_44 = OrdersTotal() - 1; LAti_44 >= 0; LAti_44--)
        {
         if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() > OP_SELL)
              {
               LAtd_4 = OrderOpenPrice();
               LAtd_20 = OrderStopLoss();
               LAtd_12 = OrderTakeProfit();
               if(OrderType() == OP_BUYSTOP)
                 {
                  LAtd_112 = f0_11(GAtd_288 + Indent * GAtd_216 + GAtd_224);
                  LAtd_120 = f0_11(MathMax(GAtd_296 - Indent * GAtd_216, LAtd_112 - GAti_404 * GAtd_216));
                  LAtd_128 = f0_11(LAtd_112 + MathAbs(LAtd_4 - LAtd_12));
                  if((MathAbs(LAtd_112 - LAtd_4) >= Point || MathAbs(LAtd_120 - LAtd_20) >= Point)&& LAtd_112 > Ask + GAtd_232)
                     f0_15(OrderTicket(), LAtd_112, LAtd_120, LAtd_128, 0, Blue);
                 }
               if(OrderType() == OP_SELLSTOP)
                 {
                  LAtd_112 = f0_11(GAtd_296 - Indent * GAtd_216);
                  LAtd_120 = f0_11(MathMin(GAtd_288 + Indent * GAtd_216 + GAtd_224, LAtd_112 + GAti_404 * GAtd_216));
                  LAtd_128 = f0_11(LAtd_112 - MathAbs(LAtd_4 - LAtd_12));
                  if((MathAbs(LAtd_112 - LAtd_4) >= Point || MathAbs(LAtd_120 - LAtd_20) >= Point)&& LAtd_112 < Bid - GAtd_232)
                     f0_15(OrderTicket(), LAtd_112, LAtd_120, LAtd_128, 0, Red);
                 }
              }
           }
        }
     }
   if(GAti_156)
     {
      if(GAti_308 != OrdersHistoryTotal())
        {
         LAti_136 = GAti_312;
         GAti_308 = OrdersHistoryTotal();
         GAtd_320 = 0;
         GAti_312 = 0;
         for(LAti_44 = GAti_308 - 1; LAti_44 >= 0; LAti_44--)
           {
            if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_HISTORY))
              {
               if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() <= OP_SELL)
                 {
                  if(OrderProfit() > 0.0)
                     break;
                  GAtd_320 += OrderProfit() + OrderCommission() + OrderSwap();
                  GAti_312++;
                 }
              }
           }
         if(GAti_312 > GAti_316)
            GAti_316 = GAti_312;
         if(GAtd_320 < GAtd_328)
            GAtd_328 = GAtd_320;
         if(GAtd_320 > 0.0)
            GAtd_320 = 0;
        }
     }
   GAti_384 = 0;
   GAti_388 = 0;
   GAti_392 = 0;
   GAti_396 = 0;
   GAtd_336 = 0;
   GAtd_344 = 0;
   GAtd_352 = 0;
   GAtd_360 = 0;
   double LAtd_140 = 0;
   double LAtd_148 = 0;
   double LAtd_156 = 0;
   double LAtd_164 = 0;
   for(LAti_44 = OrdersTotal() - 1; LAti_44 >= 0; LAti_44--)
     {
      if(OrderSelect(LAti_44, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic)
           {
            LAti_172 = OrderType();
            if(LAti_172 == OP_BUY)
              {
               GAti_384++;
               LAtd_140 += OrderLots();
              }
            else
              {
               if(LAti_172 == OP_SELL)
                 {
                  GAti_388++;
                  LAtd_148 += OrderLots();
                 }
               else
                 {
                  if(LAti_172 == OP_BUYSTOP || LAti_172 == OP_BUYLIMIT)
                    {
                     GAti_392++;
                     LAtd_156 += OrderLots();
                     GAtd_352 += MathAbs(OrderOpenPrice() - OrderTakeProfit()) * OrderLots() / Point * GAtd_264;
                    }
                  else
                    {
                     if(LAti_172 == OP_SELLSTOP || LAti_172 == OP_SELLLIMIT)
                       {
                        GAti_396++;
                        LAtd_164 += OrderLots();
                        GAtd_360 += MathAbs(OrderOpenPrice() - OrderTakeProfit()) * OrderLots() / Point * GAtd_264;
                       }
                    }
                 }
              }
            if(LAti_172 <= OP_SELL)
              {
               GAtd_336 -= MathAbs(OrderOpenPrice() - OrderStopLoss()) * OrderLots() / Point * GAtd_264;
               GAtd_344 += MathAbs(OrderOpenPrice() - OrderTakeProfit()) * OrderLots() / Point * GAtd_264;
              }
           }
        }
     }
   if(GAti_156)
     {
      LAtd_176 = f0_3();
      if(GAti_312 == 0 && GAti_384 == 0 && GAti_388 == 0)
        {
         GAtd_368 = LAtd_176;
         LAti_0 = GAti_400;
        }
      else
        {
         LAti_0 = GAti_400;
         GAtd_376 = (-GAtd_320) - GAtd_336 + (GAti_312 + 2) * f0_3() * GAtd_264 * TakeProfit_Martin * GAtd_216 / Point;
         GAtd_368 = f0_16(GAtd_376 / (LAti_0 * GAtd_216 / Point * GAtd_264));
         if(GAtd_368 < LAtd_176)
            GAtd_368 = LAtd_176;
        }
     }
   else
     {
      GAtd_368 = f0_3();
      LAti_0 = GAti_400;
     }
   if(!UseCustomLotCycle && MaxLossStepsReset>0 && GAti_156 && GAti_312 >= MaxLossStepsReset)
     {
      // 连续亏损封顶：重置为初始手数（不改变原 GAtd_368 计算逻辑，只做保险丝）
      GAtd_368 = f0_3();
      LAti_0 = GAti_400;
     }
   if(UseCustomLotCycle)
     {
      GAtd_368 = f0_3();
      LAti_0 = GAti_400;
     }
   if(LAtd_156 > 0.0)
     {
      if(LAtd_156 >= GAtd_368 + GAtd_240 - 0.0001)
        {
         f0_9(1);
         GAti_392 = 0;
         LAtd_156 = 0;
        }
      else
        {
         if(LAtd_156 <= GAtd_368 - GAtd_240 + 0.0001)
           {
            f0_9(1);
            GAti_392 = 0;
            LAtd_156 = 0;
           }
        }
     }
   if(LAtd_164 > 0.0)
     {
      if(LAtd_164 >= GAtd_368 + GAtd_240 - 0.0001)
        {
         f0_9(-1);
         GAti_396 = 0;
         LAtd_164 = 0;
        }
      else
        {
         if(LAtd_164 <= GAtd_368 - GAtd_240 + 0.0001)
           {
            f0_9(-1);
            GAti_396 = 0;
            LAtd_164 = 0;
           }
        }
     }
   if(GAti_384 == 0 && GAti_392 == 0 && Ask < GAtd_288 - 5.0 * GAtd_232 && (!Flag_Stop))
     {
      for(int LAti_40 = 0; GAtd_368 > GAtd_240 - 0.0001 && LAti_40 < 50; LAti_40++)
        {
         LAtd_56 = MathMin(GAtd_368, GAtd_248);
         RefreshRates();
         LAti_36 = f0_7(1, LAtd_56, LAti_0);
         if(LAti_36 > 0)
            GAtd_368 -= LAtd_56;
        }
     }
   if(GAti_388 == 0 && GAti_396 == 0 && Bid > GAtd_296 + 5.0 * GAtd_232 && (!Flag_Stop))
     {
      for(LAti_40 = 0; GAtd_368 > GAtd_240 - 0.0001 && LAti_40 < 50; LAti_40++)
        {
         LAtd_56 = MathMin(GAtd_368, GAtd_248);
         RefreshRates();
         LAti_36 = f0_7(-1, LAtd_56, LAti_0);
         if(LAti_36 > 0)
            GAtd_368 -= LAtd_56;
        }
     }
   if((!IsTesting()) || IsVisualMode())
      f0_13();
   return (0);
  }
int FUN_0678(int t)
  {
   bool b=0;
   int li_4 = 0;
   int li_8 = OrdersTotal();
   for(int li_12=0; li_12<li_8; li_12++)
     {
      b=OrderSelect(li_12,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic  && OrderType()==t)
         li_4++;
     }
   return (li_4);
  }
int f0_7(int AAti_0, double AAtd_4, int AAti_12)
  {
   double LAtd_16;
   double LAtd_24;
   double LAtd_32;
   int LAti_40;
   int LAti_44;
   int LAti_48 = -1;
   double LAtd_52 = f0_25_getDirectionalLotFactor(AAti_0);
   AAtd_4 *= LAtd_52;
   if(GAtd_256 > 0.0)
      AAtd_4 = NormalizeDouble(MathRound(AAtd_4 / GAtd_256) * GAtd_256, GAti_280);
   if(AAtd_4 < GAtd_240)
      AAtd_4 = GAtd_240;
   if(AAtd_4 > GAtd_248)
      AAtd_4 = GAtd_248;
   if(MaxLotSize>0)
      if(AAtd_4>=MaxLotSize)
         AAtd_4 = MaxLotSize ;
   if(AAti_0 > 0)
      if(FUN_0678(OP_BUYSTOP)==0)
        {
         LAtd_16 = GAtd_288 + Indent * GAtd_216 + GAtd_224;
         LAtd_32 = LAtd_16 + AAti_12 * GAtd_216;
         LAtd_24 = MathMax(GAtd_296 - Indent * GAtd_216, LAtd_16 - GAti_404 * GAtd_216);
         LAti_44 = AAti_12;
         LAti_40 = MathRound(MathAbs(LAtd_16 - LAtd_24) / GAtd_216);

         FUN_06("Q_S_1", f0_11(LAtd_16),  ColorUp,1,2);
         if(Verbose)
            Print(Magic + " Setting the BUYSTOP order with Lot ", DoubleToStr(AAtd_4, GAti_280), ", TP = ", LAti_44, ", SL = ", LAti_40);
         if(GAti_192)
            LAti_48 = OrderSend(Symbol(), OP_BUYSTOP, AAtd_4, f0_11(LAtd_16), GAti_84, 0, 0, GAts_76, Magic, 0, Blue);
         else
            LAti_48 = OrderSend(Symbol(), OP_BUYSTOP, AAtd_4, f0_11(LAtd_16), GAti_84, f0_11(LAtd_24), f0_11(LAtd_32), GAts_76, Magic, 0, Blue);
         if(LAti_48 < 0)
           {
            f0_18();
            Print("Ask = ", f0_1(Ask), " OP = ", f0_1(LAtd_16), " OSL = ", f0_1(LAtd_24), " OTP = ", f0_1(LAtd_32));
           }
         if(LAti_48 > 0 && GAti_192)
            f0_12(LAti_48, LAti_40, LAti_44);
        }
    {
      if(AAti_0 < 0)
         if(FUN_0678(OP_SELLSTOP)==0)
           {
            LAtd_16 = GAtd_296 - Indent * GAtd_216;
            LAtd_32 = LAtd_16 - AAti_12 * GAtd_216;
            LAtd_24 = MathMin(GAtd_288 + Indent * GAtd_216 + GAtd_224, LAtd_16 + GAti_404 * GAtd_216);
            LAti_44 = AAti_12;
            LAti_40 = MathRound(MathAbs(LAtd_16 - LAtd_24) / GAtd_216);

            FUN_06("Q_S_2", f0_11(LAtd_16),  ColorLo,1,2);
            if(Verbose)
               Print(Magic + " Setting the SELLSTOP order with Lot ", DoubleToStr(AAtd_4, GAti_280), ", TP = ", LAti_44, ", SL = ", LAti_40);
            if(GAti_192)
               LAti_48 = OrderSend(Symbol(), OP_SELLSTOP, AAtd_4, f0_11(LAtd_16), GAti_84, 0, 0, GAts_76, Magic, 0, Red);
            else
               LAti_48 = OrderSend(Symbol(), OP_SELLSTOP, AAtd_4, f0_11(LAtd_16), GAti_84, f0_11(LAtd_24), f0_11(LAtd_32), GAts_76, Magic, 0, Red);
            if(LAti_48 < 0)
              {
               f0_18();
               Print("Bid = ", f0_1(Bid), " OP = ", f0_1(LAtd_16), " OSL = ", f0_1(LAtd_24), " OTP = ", f0_1(LAtd_32));
              }
            if(LAti_48 > 0 && GAti_192)
               f0_12(LAti_48, LAti_40, LAti_44);
           }
     }
   return (LAti_48);
  }
double f0_25_getDirectionalLotFactor(int AAti_0)
  {
   if(!UseEMA14DirectionLotBias)
      return (1.0);
   int LAti_0 = EMADirectionPeriod;
   if(LAti_0 < 2)
      LAti_0 = 14;
   double LAtd_8 = iMA(NULL, PERIOD_D1, LAti_0, 0, MODE_EMA, PRICE_CLOSE, 0);
   double LAtd_16 = iMA(NULL, PERIOD_D1, LAti_0, 0, MODE_EMA, PRICE_CLOSE, 1);
   double LAtd_24 = iClose(NULL, PERIOD_D1, 1);
   double LAtd_32 = iOpen(NULL, PERIOD_D1, 0);
   bool LAti_40 = (LAtd_24 > LAtd_16 && LAtd_32 > LAtd_8);
   bool LAti_44 = (LAtd_24 < LAtd_16 && LAtd_32 < LAtd_8);
   if(RequireEMASlope)
     {
      LAti_40 = (LAti_40 && LAtd_8 > LAtd_16);
      LAti_44 = (LAti_44 && LAtd_8 < LAtd_16);
     }
   if(AAti_0 > 0)
     {
      if(LAti_40)
         return (TrendDirectionMultiplier);
      return (NonTrendDirectionMultiplier);
     }
   if(AAti_0 < 0)
     {
      if(LAti_44)
         return (TrendDirectionMultiplier);
      return (NonTrendDirectionMultiplier);
     }
   return (1.0);
  }
string f0_26_getDirectionalLotBiasText()
  {
   if(!UseEMA14DirectionLotBias)
      return ("关闭");
   if(f0_25_getDirectionalLotFactor(1) > NonTrendDirectionMultiplier + 0.0000001)
      return ("多单倍投 / 空单平投");
   if(f0_25_getDirectionalLotFactor(-1) > NonTrendDirectionMultiplier + 0.0000001)
      return ("空单倍投 / 多单平投");
   return ("双向平投");
  }
double f0_3()
  {
   double LAtd_0;
   double LAtd_8;
   double LAtd_16;
   double LAtd_24;
   if(UseCustomLotCycle)
      LAtd_0 = f0_24_getCurrentCustomLot();
   else
      if(AutoMM && AutoMMEquity > 0.0)
     {
      LAtd_8 = AccountBalance();
      LAtd_16 = 10.0;
      LAtd_24 = MathFloor(LAtd_8 / (AutoMMEquity / LAtd_16)) * (AutoMMEquity / LAtd_16);
      LAtd_0 = MathRound(LotSize * LAtd_24 / AutoMMEquity / GAtd_256) * GAtd_256;
     }
      else
         LAtd_0 = LotSize;
   if(LAtd_0 < GAtd_240)
      LAtd_0 = GAtd_240;
   if(LAtd_0 > GAtd_248)
      LAtd_0 = GAtd_248;
   if(MaxLotSize>0)
      if(LAtd_0>=MaxLotSize)
         LAtd_0 = MaxLotSize ;
   return (LAtd_0);
  }
int f0_21_getCustomLotCycleCount()
  {
   int LAti_0 = CustomLotCycleCount;
   if(LAti_0 < 1)
      LAti_0 = 1;
   if(LAti_0 > 15)
      LAti_0 = 15;
   return (LAti_0);
  }
double f0_22_getCustomLotByStep(int AAti_0)
  {
   if(AAti_0 <= 1)
      return (CustomLot1);
   if(AAti_0 == 2)
      return (CustomLot2);
   if(AAti_0 == 3)
      return (CustomLot3);
   if(AAti_0 == 4)
      return (CustomLot4);
   if(AAti_0 == 5)
      return (CustomLot5);
   if(AAti_0 == 6)
      return (CustomLot6);
   if(AAti_0 == 7)
      return (CustomLot7);
   if(AAti_0 == 8)
      return (CustomLot8);
   if(AAti_0 == 9)
      return (CustomLot9);
   if(AAti_0 == 10)
      return (CustomLot10);
   if(AAti_0 == 11)
      return (CustomLot11);
   if(AAti_0 == 12)
      return (CustomLot12);
   if(AAti_0 == 13)
      return (CustomLot13);
   if(AAti_0 == 14)
      return (CustomLot14);
   return (CustomLot15);
  }
double f0_24_getCurrentCustomLot()
  {
   int LAti_0 = f0_21_getCustomLotCycleCount();
   if(GAti_customLotStep < 1 || GAti_customLotStep > LAti_0)
      GAti_customLotStep = 1;
   return (f0_22_getCustomLotByStep(GAti_customLotStep));
  }
void f0_23_updateCustomLotCycle()
  {
   if(!UseCustomLotCycle)
      return;
   int LAti_0 = f0_21_getCustomLotCycleCount();
   int LAti_4 = -1;
   datetime LAtdt_8 = 0;
   double LAtd_16 = 0.0;
   int LAti_24 = -1;
   for(int LAti_28 = OrdersHistoryTotal() - 1; LAti_28 >= 0; LAti_28--)
     {
      if(OrderSelect(LAti_28, SELECT_BY_POS, MODE_HISTORY))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() <= OP_SELL)
           {
            LAti_4 = OrderTicket();
            LAtdt_8 = OrderCloseTime();
            LAtd_16 = OrderProfit() + OrderCommission() + OrderSwap();
            LAti_24 = 1;
            break;
           }
        }
     }
   if(LAti_24 < 0)
      return;
   if(LAtdt_8 == GAtdt_customLotLastClose && LAti_4 == GAti_customLotLastTicket)
      return;
   if(LAtd_16 > 0.0)
      GAti_customLotStep = 1;
   else
     {
      GAti_customLotStep++;
      if(GAti_customLotStep > LAti_0)
         GAti_customLotStep = 1;
     }
   GAtdt_customLotLastClose = LAtdt_8;
   GAti_customLotLastTicket = LAti_4;
  }
void f0_9(int AAti_0)
  {
   bool LAti_16;
   int LAti_4 = 0;
   bool LAti_8 = TRUE;
   while(LAti_8 && LAti_4 < 30)
     {
      LAti_4++;
      LAti_8 = FALSE;
      RefreshRates();
      for(int LAti_12 = OrdersTotal() - 1; LAti_12 >= 0; LAti_12--)
        {
         if(OrderSelect(LAti_12, SELECT_BY_POS, MODE_TRADES))
           {
            if(cd(OrderMagicNumber(), Magic))
              {
               if((AAti_0 > 0 &&(OrderType() == OP_BUYSTOP || OrderType() == OP_BUYLIMIT))|| (AAti_0 < 0 &&(OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT)))
                 {
                  if(cd(OrderLots(),MaxLotSize))
                     return;

                  LAti_16 = OrderDelete(OrderTicket());
                  if(!LAti_16)
                    {
                     f0_18();
                     LAti_8 = TRUE;
                    }
                 }
              }
           }
        }
     }
   if(LAti_8)
      Print(Magic + " DeleteAllPendingOrders: failed");
  }
bool cd(double number1,double number2)

  {
   if(NormalizeDouble(number1-number2,8)==0)
      return(true);
   else
      return(false);
  }
void f0_12(int AAti_0, int AAti_4, int AAti_8)
  {
   double LAtd_12;
   double LAtd_20;
   double LAtd_28;
   int LAti_36;
   if(AAti_8 == 0 && AAti_4 == 0)
      return;
   if(OrderSelect(AAti_0, SELECT_BY_TICKET))
     {
      LAtd_12 = OrderOpenPrice();
      LAti_36 = OrderType();
      if(LAti_36 == OP_BUY || LAti_36 == OP_BUYSTOP || LAti_36 == OP_BUYLIMIT)
        {
         if(AAti_8 > 0)
            LAtd_20 = f0_11(LAtd_12 + MathMax(AAti_8 * GAtd_216, GAtd_232));
         else
            LAtd_20 = OrderTakeProfit();
         if(AAti_4 > 0)
            LAtd_28 = f0_11(LAtd_12 - MathMax(AAti_4 * GAtd_216, GAtd_232));
         else
            LAtd_28 = OrderStopLoss();
         if(!(f0_11(LAtd_20) != f0_11(OrderTakeProfit()) || f0_11(LAtd_28) != f0_11(OrderStopLoss())))
            return;
         f0_15(AAti_0, LAtd_12, LAtd_28, LAtd_20, 0, Blue);
         return;
        }
      if(!(LAti_36 == OP_SELL || LAti_36 == OP_SELLSTOP || LAti_36 == OP_SELLLIMIT))
         return;
      if(AAti_8 > 0)
         LAtd_20 = f0_11(LAtd_12 - MathMax(AAti_8 * GAtd_216, GAtd_232));
      else
         LAtd_20 = OrderTakeProfit();
      if(AAti_4 > 0)
         LAtd_28 = f0_11(LAtd_12 + MathMax(AAti_4 * GAtd_216, GAtd_232));
      else
         LAtd_28 = OrderStopLoss();
      if(!(f0_11(LAtd_20) != f0_11(OrderTakeProfit()) || f0_11(LAtd_28) != f0_11(OrderStopLoss())))
         return;
      f0_15(AAti_0, LAtd_12, LAtd_28, LAtd_20, 0, Red);
      return;
     }
   Print("Error selecting order #", AAti_0);
  }
void f0_15(int AAti_0, double AAtd_4, double AAtd_12, double AAtd_20, int AAti_28, color AAti_32)
  {
   bool LAti_40;
   for(int LAti_36 = 0; LAti_36 < 10; LAti_36++)
     {
      while(!IsTradeAllowed())
         Sleep(1000);
      RefreshRates();
      LAti_40 = OrderModify(AAti_0, AAtd_4, AAtd_12, AAtd_20, AAti_28, AAti_32);
      if(LAti_40)
         break;
      f0_18();
      Print(Magic, "ticket = ", AAti_0, " price = ", f0_1(AAtd_4), " sl = ", f0_1(AAtd_12), " tp = ", f0_1(AAtd_20), " stop_level =", f0_1(GAtd_232));
      Print(Magic, "OrderOpenPrice = ", f0_1(OrderOpenPrice()), " OrderStopLoss = ", f0_1(OrderStopLoss()), " OrderTakeProfit = ", f0_1(OrderTakeProfit()));
     }
  }
double f0_16(double AAtd_0)
  {
   double LAtd_8 = NormalizeDouble(MathRound(AAtd_0 / GAtd_256) * GAtd_256, GAti_280);
   if(LAtd_8 < GAtd_240)
      LAtd_8 = GAtd_240;
   return (LAtd_8);
  }
string f0_1(double AAtd_0)
  {
   return (DoubleToStr(AAtd_0, Digits));
  }
string f0_17(double AAtd_0)
  {
   return (DoubleToStr(AAtd_0, 2));
  }
void f0_19()
  {
   int LAti_8;
   int LAti_12;
   double LAtd_16;
   int LAti_32;
   int LAti_36;
   double LAtd_24 = f0_11(Filter * GAtd_216);
   if(GAti_432 == 0)
     {
      LAti_32 = 10;
      if(iBars(NULL, PERIOD_M1) > 0)
         LAti_36 = 1;
      else
        {
         if(iBars(NULL, Period()) > 0)
            LAti_36 = Period();
         else
            LAti_36 = 0;
        }
      if(LAti_36 > 0)
        {
         for(int LAti_4 = 2; LAti_4 < MathMin(10000, iBars(NULL, LAti_36)); LAti_4++)
           {
            LAti_8 = LAti_4;
            if(MathAbs(iClose(NULL, LAti_36, LAti_4) - iClose(NULL, LAti_36, 1)) > LAti_32 * LAtd_24)
               break;
           }
         LAtd_16 = GAti_200 * GAtd_216;
         GAtd_508 = LAtd_16 + MathFloor((iClose(NULL, LAti_36, LAti_8) - LAtd_16) / LAtd_24) * LAtd_24;
        }
      else
        {
         LAti_8 = 0;
         LAtd_16 = GAti_200 * GAtd_216;
         GAtd_508 = LAtd_16 + MathFloor((Close[0] - LAtd_16) / LAtd_24) * LAtd_24;
        }
      GAtd_492 = GAtd_508;
      GAtd_500 = GAtd_508 - LAtd_24;
      GAtd_524 = GAtd_492;
      GAtd_532 = GAtd_500;
      GAti_432 = 1;
      for(LAti_4 = LAti_8 - 1; LAti_4 >= 1; LAti_4--)
        {
         LAti_12 = iHigh(NULL, LAti_36, LAti_4) + iLow(NULL, LAti_36, LAti_4) > iHigh(NULL, LAti_36, LAti_4 + 1) + iLow(NULL, LAti_36, LAti_4 + 1);
         GAtd_524 = MathMax(GAtd_524, iHigh(NULL, LAti_36, LAti_4));
         for(GAtd_532 = MathMin(GAtd_532, iLow(NULL, LAti_36, LAti_4)); LAti_12 && iLow(NULL, LAti_36, LAti_4) <= GAtd_500 - LAtd_24; GAtd_532 = EMPTY_VALUE)
           {
            GAtd_492 -= LAtd_24;
            GAtd_500 -= LAtd_24;
            GAtd_508 = GAtd_500;
            if(GAti_432 > 0)
               GAti_432 = -1;
            else
               GAti_432--;
            f0_20(GAtd_492, GAtd_500, MathMax(GAtd_524, GAtd_492), GAtd_500);
            GAtd_524 = 0;
           }
         while(iHigh(NULL, LAti_36, LAti_4) >= GAtd_492 + LAtd_24)
           {
            GAtd_492 += LAtd_24;
            GAtd_500 += LAtd_24;
            GAtd_508 = GAtd_492;
            if(GAti_432 < 0)
               GAti_432 = 1;
            else
               GAti_432++;
            f0_20(GAtd_500, MathMin(GAtd_532, GAtd_500), GAtd_492, GAtd_492);
            GAtd_524 = 0;
            GAtd_532 = EMPTY_VALUE;
           }
         while(!LAti_12 && iLow(NULL, LAti_36, LAti_4) < GAtd_500 - LAtd_24)
           {
            GAtd_492 -= LAtd_24;
            GAtd_500 -= LAtd_24;
            GAtd_508 = GAtd_500;
            if(GAti_432 > 0)
               GAti_432 = -1;
            else
               GAti_432--;
            f0_20(GAtd_492, GAtd_500, MathMax(GAtd_524, GAtd_492), GAtd_500);
            GAtd_524 = 0;
            GAtd_532 = EMPTY_VALUE;
           }
        }
     }
   if(GAti_432 != 0)
     {
      GAtd_524 = MathMax(GAtd_524, Bid);
      if(Bid > 0.0)
         GAtd_532 = MathMin(GAtd_532, Bid);
      if(Bid >= GAtd_492 + LAtd_24)
        {
         GAtd_492 += LAtd_24;
         GAtd_500 += LAtd_24;
         GAtd_508 = GAtd_492;
         if(GAti_432 < 0)
            GAti_432 = 1;
         else
            GAti_432++;
         f0_20(GAtd_500, MathMin(GAtd_532, GAtd_500), MathMax(GAtd_524, GAtd_492), GAtd_492);
         GAtd_524 = 0;
         GAtd_532 = EMPTY_VALUE;
        }
      if(Bid <= GAtd_500 - LAtd_24)
        {
         GAtd_492 -= LAtd_24;
         GAtd_500 -= LAtd_24;
         GAtd_508 = GAtd_500;
         if(GAti_432 > 0)
            GAti_432 = -1;
         else
            GAti_432--;
         f0_20(GAtd_492, MathMin(GAtd_532, GAtd_500), MathMax(GAtd_524, GAtd_492), GAtd_500);
         GAtd_524 = 0;
         GAtd_532 = EMPTY_VALUE;
        }
     }
  }
double FUN_03(int Ai_0)
  {
   double Ld_4 = 0;
   if(OrdersTotal() > 0)
     {
      for(int Li_12 = OrdersTotal() - 1; Li_12 >= 0; Li_12--)
        {
         if(OrderSelect(Li_12, SELECT_BY_POS, MODE_TRADES) == TRUE)
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == Magic)
                 {
                  if(OrderType() == Ai_0)
                    {
                     Ld_4 = OrderOpenPrice() - OrderTakeProfit();
                     break;
                    }
                 }
              }
           }
        }
     }
   return (MathAbs(Ld_4) / Point);
  }
double FUN_02(int Ai_0)
  {
   double Ld_4 = 0;
   if(OrdersTotal() > 0)
     {
      for(int Li_12 = OrdersTotal() - 1; Li_12 >= 0; Li_12--)
        {
         if(OrderSelect(Li_12, SELECT_BY_POS, MODE_TRADES) == TRUE)
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == Magic)
                 {
                  if(OrderType() == Ai_0)
                    {
                     Ld_4 = OrderLots() ;
                     break;
                    }
                 }
              }
           }
        }
     }
   return (Ld_4) ;
  }
double FUN_01(int Ai_0)
  {
   double Ld_4 = 0;
   if(OrdersTotal() > 0)
     {
      for(int Li_12 = OrdersTotal() - 1; Li_12 >= 0; Li_12--)
        {
         if(OrderSelect(Li_12, SELECT_BY_POS, MODE_TRADES) == TRUE)
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == Magic)
                 {
                  if(OrderType() == Ai_0)
                    {
                     Ld_4 = OrderOpenPrice() - OrderStopLoss();
                     break;
                    }
                 }
              }
           }
        }
     }
   return (MathAbs(Ld_4) / Point);
  }
double Gd_128;
double Gd_136;
double Gd_144;
double Gd_152;
void FUN_057()
  {
   double Ld_0 = MarketInfo(Symbol(), MODE_TICKVALUE);
   Gd_152 = FUN_03(OP_SELLSTOP) * Ld_0 *FUN_02(OP_SELLSTOP);
   Gd_144 = FUN_03(OP_BUYSTOP) * Ld_0  *FUN_02(OP_SELLSTOP);
   double Ld_8 = FUN_03(OP_BUY) *FUN_02(0);
   double Ld_16 = FUN_03(OP_SELL) *FUN_02(1);
   Gd_128 = 0;
   if(Ld_8 > 0.0)
      Gd_128 = Ld_8;
   if(Ld_16 > 0.0)
      Gd_128 = Ld_16;
   Gd_136 = 0;
   double Ld_24 = FUN_01(OP_BUY) *FUN_02(0);
   double Ld_32 = FUN_01(OP_SELL) *FUN_02(1);
   if(Ld_24 > 0.0)
      Gd_136 = Ld_24;
   if(Ld_32 > 0.0)
      Gd_136 = Ld_32;

  }
void f0_20(double AAtd_0, double AAtd_8, double AAtd_16, double AAtd_24)
  {
   for(int LAti_32 = GAti_284; LAti_32 > 1; LAti_32--)
     {
      GAtda_436[LAti_32] = GAtda_436[LAti_32 - 1];
      GAtda_440[LAti_32] = GAtda_440[LAti_32 - 1];
      GAtda_444[LAti_32] = GAtda_444[LAti_32 - 1];
      GAtda_448[LAti_32] = GAtda_448[LAti_32 - 1];
     }
   GAtda_436[1] = AAtd_0;
   GAtda_440[1] = AAtd_8;
   GAtda_444[1] = AAtd_16;
   GAtda_448[1] = AAtd_24;
  }
void f0_4()
  {
   int LAti_8;
   int LAti_12;
   double LAtd_16;
   int LAti_32;
   int LAti_36;
   double LAtd_24 = f0_11(GAti_120 * GAtd_216);
   if(GAti_472 == 0)
     {
      LAti_32 = 10;
      if(iBars(NULL, PERIOD_M1) > 0)
         LAti_36 = 1;
      else
        {
         if(iBars(NULL, Period()) > 0)
            LAti_36 = Period();
         else
            LAti_36 = 0;
        }
      if(LAti_36 > 0)
        {
         for(int LAti_4 = 2; LAti_4 < MathMin(10000, iBars(NULL, LAti_36)); LAti_4++)
           {
            LAti_8 = LAti_4;
            if(MathAbs(iClose(NULL, LAti_36, LAti_4) - iClose(NULL, LAti_36, 1)) > LAti_32 * LAtd_24)
               break;
           }
         LAtd_16 = GAti_200 * GAtd_216;
         GAtd_556 = LAtd_16 + MathFloor((iClose(NULL, LAti_36, LAti_8) - LAtd_16) / LAtd_24) * LAtd_24;
        }
      else
        {
         LAti_8 = 0;
         LAtd_16 = GAti_200 * GAtd_216;
         GAtd_556 = LAtd_16 + MathFloor((Close[0] - LAtd_16) / LAtd_24) * LAtd_24;
        }
      GAtd_540 = GAtd_556;
      GAtd_548 = GAtd_556 - LAtd_24;
      GAtd_572 = GAtd_540;
      GAtd_580 = GAtd_548;
      GAti_472 = 1;
      for(LAti_4 = LAti_8 - 1; LAti_4 >= 1; LAti_4--)
        {
         LAti_12 = iHigh(NULL, LAti_36, LAti_4) + iLow(NULL, LAti_36, LAti_4) > iHigh(NULL, LAti_36, LAti_4 + 1) + iLow(NULL, LAti_36, LAti_4 + 1);
         GAtd_572 = MathMax(GAtd_572, iHigh(NULL, LAti_36, LAti_4));
         for(GAtd_580 = MathMin(GAtd_580, iLow(NULL, LAti_36, LAti_4)); LAti_12 && iLow(NULL, LAti_36, LAti_4) <= GAtd_548 - LAtd_24; GAtd_580 = EMPTY_VALUE)
           {
            GAtd_540 -= LAtd_24;
            GAtd_548 -= LAtd_24;
            GAtd_556 = GAtd_548;
            if(GAti_472 > 0)
               GAti_472 = -1;
            else
               GAti_472--;
            f0_6(GAtd_540, GAtd_548, MathMax(GAtd_572, GAtd_540), GAtd_548);
            GAtd_572 = 0;
           }
         while(iHigh(NULL, LAti_36, LAti_4) >= GAtd_540 + LAtd_24)
           {
            GAtd_540 += LAtd_24;
            GAtd_548 += LAtd_24;
            GAtd_556 = GAtd_540;
            if(GAti_472 < 0)
               GAti_472 = 1;
            else
               GAti_472++;
            f0_6(GAtd_548, MathMin(GAtd_580, GAtd_548), GAtd_540, GAtd_540);
            GAtd_572 = 0;
            GAtd_580 = EMPTY_VALUE;
           }
         while(!LAti_12 && iLow(NULL, LAti_36, LAti_4) < GAtd_548 - LAtd_24)
           {
            GAtd_540 -= LAtd_24;
            GAtd_548 -= LAtd_24;
            GAtd_556 = GAtd_548;
            if(GAti_472 > 0)
               GAti_472 = -1;
            else
               GAti_472--;
            f0_6(GAtd_540, GAtd_548, MathMax(GAtd_572, GAtd_540), GAtd_548);
            GAtd_572 = 0;
            GAtd_580 = EMPTY_VALUE;
           }
        }
     }
   if(GAti_472 != 0)
     {
      GAtd_572 = MathMax(GAtd_572, Bid);
      if(Bid > 0.0)
         GAtd_580 = MathMin(GAtd_580, Bid);
      if(Bid >= GAtd_540 + LAtd_24)
        {
         GAtd_540 += LAtd_24;
         GAtd_548 += LAtd_24;
         GAtd_556 = GAtd_540;
         if(GAti_472 < 0)
            GAti_472 = 1;
         else
            GAti_472++;
         f0_6(GAtd_548, MathMin(GAtd_580, GAtd_548), MathMax(GAtd_572, GAtd_540), GAtd_540);
         GAtd_572 = 0;
         GAtd_580 = EMPTY_VALUE;
        }
      if(Bid <= GAtd_548 - LAtd_24)
        {
         GAtd_540 -= LAtd_24;
         GAtd_548 -= LAtd_24;
         GAtd_556 = GAtd_548;
         if(GAti_472 > 0)
            GAti_472 = -1;
         else
            GAti_472--;
         f0_6(GAtd_540, MathMin(GAtd_580, GAtd_548), MathMax(GAtd_572, GAtd_540), GAtd_548);
         GAtd_572 = 0;
         GAtd_580 = EMPTY_VALUE;
        }
     }
  }
void f0_6(double AAtd_0, double AAtd_8, double AAtd_16, double AAtd_24)
  {
   for(int LAti_32 = GAti_284; LAti_32 > 1; LAti_32--)
     {
      GAtda_476[LAti_32] = GAtda_476[LAti_32 - 1];
      GAtda_480[LAti_32] = GAtda_480[LAti_32 - 1];
      GAtda_484[LAti_32] = GAtda_484[LAti_32 - 1];
      GAtda_488[LAti_32] = GAtda_488[LAti_32 - 1];
     }
   GAtda_476[1] = AAtd_0;
   GAtda_480[1] = AAtd_8;
   GAtda_484[1] = AAtd_16;
   GAtda_488[1] = AAtd_24;
  }
double f0_11(double AAtd_0)
  {
   return (NormalizeDouble(AAtd_0, Digits));
  }
int f0_18()
  {
   int LAti_0 = GetLastError();
   Print("ERROR (" + LAti_0 + ")");
   if(LAti_0 == 130|| LAti_0 == 129|| LAti_0 == 138|| LAti_0 == 135||LAti_0 == 136)
     {
      RefreshRates();
      return (1);
     }
   if(LAti_0 == 146||LAti_0 == 133|| LAti_0 == 128||LAti_0 == 139)
     {
      Sleep(500);
      RefreshRates();
      return (1);
     }
   if(LAti_0 == 4 || LAti_0 == 137|| LAti_0 == 4022|| LAti_0 == 6|| LAti_0 == 141||
      LAti_0 == 8)
     {
      Sleep(1500);
      RefreshRates();
      return (1);
     }
   if(LAti_0 == 147)
     {
      RefreshRates();
      return (1);
     }
   if(LAti_0 != 0)
     {
      Sleep(500);
      RefreshRates();
      return (0);
     }
   return (0);
  }
int f0_8(string AAts_0)
  {
   GAts_588 = GAts_588 + AAts_0;
   return (0);
  }
int f0_10()
  {
   int LAti_0;
   string LAts_24;
   int LAti_32;
   if(GAti_644)
      LAti_0 = WindowFind("Empty");
   else
      LAti_0 = 0;
   if(LAti_0 < 0)
      return (0);
   int LAti_4 = 0;
   int LAti_8 = 0;
   int LAti_12 = 0;
   string LAts_16 = "";
   while(LAti_8 < StringLen(GAts_588))
     {
      LAti_12 = StringFind(GAts_588,
                           "\n", LAti_8);
      if(LAti_12 < 0)
         LAti_12 = StringLen(GAts_588);
      LAts_16 = StringSubstr(GAts_588, LAti_8, LAti_12 - LAti_8);
      LAti_8 = LAti_12 + 1;
      LAts_24 = GAts_596 + DoubleToStr(LAti_4, 0);
      LAti_32 = GAti_624 + comment_lineheight * LAti_4;
      ObjectCreate(LAts_24, OBJ_LABEL, LAti_0, 0, 0, 0, 0);
      ObjectSet(LAts_24, OBJPROP_CORNER, GAti_604);
      if(LAti_4 < GAti_636 + GAti_640 || (!GAti_644))
        {
         ObjectSet(LAts_24, OBJPROP_XDISTANCE, GAti_620);
         ObjectSet(LAts_24, OBJPROP_YDISTANCE, LAti_32);
        }
      else
        {
         ObjectSet(LAts_24, OBJPROP_XDISTANCE, GAti_620 + GAti_632);
         ObjectSet(LAts_24, OBJPROP_YDISTANCE, LAti_32 - GAti_640 * comment_lineheight);
        }
      ObjectSetText(LAts_24, LAts_16, comment_fontsize, GAts_tahoma_612, comment_color);
      LAti_4++;
     }
   for(LAts_24 = GAts_596 + DoubleToStr(LAti_4, 0); ObjectFind(LAts_24) >= 0; LAts_24 = GAts_596 + DoubleToStr(LAti_4, 0))
     {
      ObjectDelete(LAts_24);
      LAti_4++;
     }
   Comment("");
   return (0);
  }
int f0_5()
  {
   GAts_588 = "";
   return (0);
  }
void FUN_06(string Name,double price,color Colour,int Width,int Style)
  {
   if(DrawLines==0)
     {
      ObjectDelete("Q_S_1");
      ObjectDelete("Q_S_2");
      return;
     }
   ObjectCreate(0,Name,OBJ_HLINE,0,0,price);
   ObjectSetInteger(0,Name,OBJPROP_COLOR,Colour);
   ObjectSetInteger(0,Name,OBJPROP_WIDTH,Width);
   ObjectSetInteger(0,Name,OBJPROP_STYLE,Style);
   if(price>0)
      ObjectMove(0,Name,0,0,price);
  }
double FUN_04()
  {
   double Mq4_LastOpenPrice=0;
   if(OrdersTotal()>0)
      for(int ix=OrdersTotal()-1; ix>=0; ix--)
         if(OrderSelect(ix,SELECT_BY_POS,MODE_TRADES)==true)
            if(OrderSymbol()==Symbol())
               if(OrderMagicNumber()==Magic)

                  if(OrderType()==0||OrderType()==OP_BUYSTOP)
                    {
                     Mq4_LastOpenPrice=OrderOpenPrice();
                     break;
                    }

   return(Mq4_LastOpenPrice);
  }
double FUN_05()
  {
   double Mq4_LastOpenPrice=0;
   if(OrdersTotal()>0)
      for(int ix=OrdersTotal()-1; ix>=0; ix--)
         if(OrderSelect(ix,SELECT_BY_POS,MODE_TRADES)==true)
            if(OrderSymbol()==Symbol())
               if(OrderMagicNumber()==Magic)

                  if(OrderType()==1||OrderType()==OP_SELLSTOP)
                    {
                     Mq4_LastOpenPrice=OrderOpenPrice();
                     break;
                    }

   return(Mq4_LastOpenPrice);
  }
void f0_13()
  {
   FUN_06("Q_S_1", FUN_04(),  ColorUp,1,2);
   FUN_06("Q_S_2", FUN_05(),  ColorLo,1,2);
   string LAts_0 = "a" + GAts_76 + "Box";
   if(ObjectFind(LAts_0) < 0)
     {
      ObjectCreate(LAts_0, OBJ_LABEL, 0, 0, 0);
      ObjectSetText(LAts_0, "g", 185, "Webdings", box_color);
      ObjectSet(LAts_0, OBJPROP_XDISTANCE, 5);
      ObjectSet(LAts_0, OBJPROP_YDISTANCE, 25);
      ObjectSet(LAts_0, OBJPROP_CORNER, GAti_604);
     }
   LAts_0 = "a" + GAts_76 + "Box2";
   if(ObjectFind(LAts_0) < 0)
     {
      ObjectCreate(LAts_0, OBJ_LABEL, 0, 0, 0);
      ObjectSetText(LAts_0, "g", 185, "Webdings", box_color);
      ObjectSet(LAts_0, OBJPROP_XDISTANCE, 5);
      ObjectSet(LAts_0, OBJPROP_YDISTANCE, 205);
      ObjectSet(LAts_0, OBJPROP_CORNER, GAti_604);
     }
   f0_5();
   f0_8(GAts_76
        + "\n");
   f0_8(" \n");
   if(Flag_Stop)
     {
      f0_8("【已开启停止挂单】");
      f0_8(" \n");      
     }
   f0_8("当前多单挂单价: " + f0_1(GAtd_288)
        + "\n");
   f0_8("当前空单挂单价: " + f0_1(GAtd_296)
        + "\n");
   f0_8(" \n");
   f0_8("下次开仓手数: " + f0_17(GAtd_368)
        + "\n");
   if(UseCustomLotCycle)
      f0_8("手数循环进度: 第" + GAti_customLotStep + "/" + f0_21_getCustomLotCycleCount() + "笔\n");
   if(UseEMA14DirectionLotBias)
      f0_8("EMA方向倍投: " + f0_26_getDirectionalLotBiasText() + "\n");
   f0_8(" \n");
   if(GAti_392>0)
      f0_8("BUY挂单数量 = " + GAti_392
           + "\n");
   if(GAti_396>0)
      f0_8("SELL挂单数量 = " + GAti_396
           + "\n");
   f0_8(" \n");
   if(GAti_156)
     {
      f0_8("连续亏损订单数 = " + GAti_312 + "\n");
      f0_8("当前亏损金额 = " + f0_17(GAtd_320) + "\n");
     }
   FUN_057();
   f0_8(" \n");
   f0_8("市场止盈潜力 = " + DoubleToStr(Gd_128,2) + "\n");
   f0_8("市场止损风险 = -" + DoubleToStr(Gd_136,2) + "\n");
   f0_8("BUY挂单止盈潜力 = " + DoubleToStr(Gd_144,2) + "\n");
   f0_8("SELL挂单止盈潜力 = " + DoubleToStr(Gd_152,2) + "\n");
   f0_10();
  }

*/


