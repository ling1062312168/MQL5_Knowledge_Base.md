//+------------------------------------------------------------------+
//|                                             绿色线多周期警报.mq5 |
//|                                 Copyright 2024,TradingBestE Ltd. |
//|                                      https://www.tradingBest.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024,TradingBest Ltd."
#property link      "https://www.tradingbest.net"
#property version   "1.00"
#property tester_indicator "GreenLine.ex5"
#property indicator_separate_window

#property indicator_minimum 0.0
#property indicator_maximum 100.0
#property indicator_buffers 7
#property indicator_plots   6 


//--- 线型属性使用编译程序指令设置 
#property indicator_label1  "绿色线"      // 数据窗口的标图名称 

#property indicator_type1   DRAW_LINE   // 标图类型是线型 
#property indicator_color1  clrLawnGreen
#property indicator_style1  STYLE_SOLID // 线型样式 
#property indicator_width1  3           // 线型宽度 

#property  indicator_level1 70
#property  indicator_level2 30
#property  indicator_level3 50.0               // 水平线 50  默认白色
//#property  indicator_levelcolor clrGreen
//#property  indicator_levelstyle 0
//#property  indicator_levelwidth 2


//---- RSI 1 分钟 线
#property indicator_label2  "RSI线" 
#property indicator_type2   DRAW_LINE 
#property indicator_color2  clrBlue 
#property indicator_style2  STYLE_SOLID 
#property indicator_width2  1 

//---- RSI 1 分钟
#property indicator_label3  "红点" 
#property indicator_type3   DRAW_COLOR_ARROW 
#property indicator_color3  clrRed,clrLime,clrYellow 
#property indicator_width3  2 

//---- RSI14 线
#property indicator_label4  "RSI14线" 
#property indicator_type4   DRAW_LINE 
#property indicator_color4  clrGreen 
#property indicator_style4  STYLE_SOLID 
#property indicator_width4  3

//---- 数据窗口信号值（不额外绘图）
#property indicator_label5  "看涨信号"
#property indicator_type5   DRAW_NONE
#property indicator_label6  "看跌信号"
#property indicator_type6   DRAW_NONE

#include <Trade\SymbolInfo.mqh>
CSymbolInfo m_symbol;
#include <Indicators\Oscilators.mqh>
CiRSI       c_RSI_M1;
CiRSI       c_RSI_M5;
CiRSI       c_RSI_M15;
CiRSI       c_RSI_M30;
CiRSI       c_RSI_H1;
CiRSI       c_RSI_H4;
CiRSI       c_RSI_D1;
CiRSI       c_RSI_W1;
CiRSI       c_RSI_MN;
CiRSI       c_RSI;
CiRSI       c_RSI14;


input string group1 = "…";     // ……交易信号做单方向设置………
input bool   Inp_onlyBuy      = true;                   // 只显示突破“多单”方向信号
input bool   Inp_onlySell     = true;                   // 只显示突破“空单”方向信号
//input int    Inp_rsiLen1         = 14;                     // rsi参数1
input int    Inp_rsiLen          = 4;                      // rsi周期
input int    Inp_rsi14Len        = 14;                     // RSI14周期
input bool   Inp_ShowRSI14       = true;                   // 是否显示RIS14线

//input string group2 = ""; // ………允许或关闭各周期图表信号监测设置……
//input ENUM_TIMEFRAMES TF = PERIOD_CURRENT;               // 是否显示当前周期RSI
//input bool   Inp_ShowRSI = false;                    // 是否显示当前周期RSI

input string group3 = "";   // ………各项报警提示设置……
input bool   Inp_SendMail           = false;                 // 是否出交易信号时刻发邮件提醒
input bool   Inp_SendNotification   = true;                 // 是否出交易信号时发通知提醒
input bool   Inp_Alert              = true;                   // 是否出交易信号时刻弹窗报警
input bool   Inp_Alert_M1   = false;                   // 开启1分钟图信号提示
input bool   Inp_Alert_M5   = false;                   // 开启5分钟图信号提示
input bool   Inp_Alert_M15  = true;                   // 开启15分钟图信号提示
input bool   Inp_Alert_M30  = false;                   // 开启30分钟图信号提示
input bool   Inp_Alert_H1   = true;                   // 开启1小时图信号提示
input bool   Inp_Alert_H4   = true;                   // 开启4小时图信号提示
input bool   Inp_Alert_D1   = true;                   // 开启D1图信号提示
input bool   Inp_Alert_W1   = false;                   // 开启W1图信号提示
input bool   Inp_Alert_MN   = false;                   // 开启MN图信号提示
input bool   Inp_DebugAlert = false;                  // 输出报警调试日志

input string group4 = "";  // ………允许或关闭显示箭头设置………
input bool   Inp_ShowArrow   = true;                   // 出现信号时显示箭头
input int    Inp_MaxArrow    = 50;                     // 箭头数量

double buffRSI[], buffCircle[], buffCircleColor[], buffRSI14[], buffBullSignal[], buffBearSignal[];
//double buffRSI5[];
//double buffM30[];


string   shortname="";
//int      handle_RSI;

string      Tips                 = "Bigwin绿色线RSI";
int         gi_84                = 16;
double      bufferGreenLine[];
datetime    newAlertTime;
bool        onAlert=false;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0, bufferGreenLine,INDICATOR_DATA);   
   ArraySetAsSeries(bufferGreenLine,true);   /* 
   PlotIndexSetInteger(0,PLOT_DRAW_TYPE,DRAW_LINE);
   PlotIndexSetInteger(0,PLOT_LINE_STYLE,STYLE_SOLID);
   PlotIndexSetInteger(0,PLOT_LINE_WIDTH,3);
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,clrLawnGreen); 
   PlotIndexSetString(0,PLOT_LABEL,"绿色线");*/
   
   SetIndexBuffer(1, buffRSI,INDICATOR_DATA);   
   ArraySetAsSeries(buffRSI,true);    
   
   SetIndexBuffer(2, buffCircle,INDICATOR_DATA);   
   ArraySetAsSeries(buffCircle,true);
   PlotIndexSetInteger(2,PLOT_ARROW,159);
   PlotIndexSetDouble(2,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   SetIndexBuffer(3, buffCircleColor, INDICATOR_COLOR_INDEX);
   ArraySetAsSeries(buffCircleColor,true);
   PlotIndexSetInteger(2,PLOT_COLOR_INDEXES,3);
   
   SetIndexBuffer(4, buffRSI14,INDICATOR_DATA);   
   ArraySetAsSeries(buffRSI14,true);
   if(!Inp_ShowRSI14)
      PlotIndexSetInteger(3,PLOT_DRAW_TYPE,DRAW_NONE);
   
   SetIndexBuffer(5, buffBullSignal,INDICATOR_DATA);
   ArraySetAsSeries(buffBullSignal,true);
   PlotIndexSetDouble(4,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   
   SetIndexBuffer(6, buffBearSignal,INDICATOR_DATA);
   ArraySetAsSeries(buffBearSignal,true);
   PlotIndexSetDouble(5,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   
   
   
   
   IndicatorSetString(INDICATOR_LEVELTEXT,0,"水平线70"); 
   IndicatorSetString(INDICATOR_LEVELTEXT,1,"水平线30"); 
   IndicatorSetString(INDICATOR_LEVELTEXT,2,"水平线50"); 
   shortname="绿色线+RSI报警("+IntegerToString(Inp_rsiLen)+")";
   IndicatorSetString(INDICATOR_SHORTNAME,shortname);
   
   // 不同周期  根据警报打开，分别初始化
               // 同时，在右侧列表显示，将在报警后高亮显示10秒
   if(Inp_Alert || Inp_SendMail || Inp_SendNotification)
   {
      int y=5;
      if(Inp_Alert_M1)
      {
         c_RSI_M1.Create(NULL, PERIOD_M1, Inp_rsiLen, PRICE_CLOSE);
         CreateLabelAlert(PERIOD_M1, y);
         y=y+12;
      }
      if(Inp_Alert_M5)
      {
         c_RSI_M5.Create(NULL, PERIOD_M5, Inp_rsiLen, PRICE_CLOSE);
         CreateLabelAlert(PERIOD_M5, y);
         y=y+12;
      }
      if(Inp_Alert_M15)
      {
         c_RSI_M15.Create(NULL, PERIOD_M15, Inp_rsiLen, PRICE_CLOSE);
         CreateLabelAlert(PERIOD_M15, y);
         y=y+12;
      }
      if(Inp_Alert_M30)
      {
         c_RSI_M30.Create(NULL, PERIOD_M30, Inp_rsiLen, PRICE_CLOSE);
         CreateLabelAlert(PERIOD_M30, y);
         y=y+12;
      }
      if(Inp_Alert_H1)
      {
         c_RSI_H1.Create(NULL, PERIOD_H1, Inp_rsiLen, PRICE_CLOSE);
         CreateLabelAlert(PERIOD_H1, y);
         y=y+12;
      }
      if(Inp_Alert_H4)
      {
         c_RSI_H4.Create(NULL, PERIOD_H4, Inp_rsiLen, PRICE_CLOSE);
         CreateLabelAlert(PERIOD_H4, y);
         y=y+12;
      }
      if(Inp_Alert_D1)
      {
         c_RSI_D1.Create(NULL, PERIOD_D1, Inp_rsiLen, PRICE_CLOSE);
         CreateLabelAlert(PERIOD_D1, y);
         y=y+12;
      }
      if(Inp_Alert_W1)
      {
         c_RSI_W1.Create(NULL, PERIOD_W1, Inp_rsiLen, PRICE_CLOSE);
         CreateLabelAlert(PERIOD_W1, y);
         y=y+12;
      }
      if(Inp_Alert_MN)
      {
         c_RSI_MN.Create(NULL, PERIOD_MN1, Inp_rsiLen, PRICE_CLOSE);
         CreateLabelAlert(PERIOD_MN1, y);
      }
   }


   c_RSI.Create(NULL, PERIOD_CURRENT, Inp_rsiLen, PRICE_CLOSE);
   c_RSI14.Create(NULL, PERIOD_CURRENT, Inp_rsi14Len, PRICE_CLOSE);
   //handle_RSI = iRSI(NULL,PERIOD_M15,Inp_rsiLen,PRICE_CLOSE);
   //ChartIndicatorAdd(0,2,handle_RSI);
//---



   ChartSetInteger(ChartID(),CHART_SHOW_VOLUMES,false);
   ChartSetInteger(ChartID(),CHART_SHOW_GRID,false);
   


   return(INIT_SUCCEEDED);
  }
  

void  OnDeinit(const int  reason){

      ObjectsDeleteAll(0,-1,-1);


}  
  
//+------------------------------------------------------------------+ 
//| 自定义指标 函数                                                 | 
//+------------------------------------------------------------------+ 
int OnCalculate(const int rates_total, 
                 const int prev_calculated, 
                 const datetime &time[], 
                 const double &open[], 
                 const double &high[], 
                 const double &low[], 
                 const double &close[], 
                 const long &tick_volume[], 
                 const long &volume[], 
                 const int &spread[]) 
  {
   //  
   if(rates_total<14)  return(0);
   //Refresh();
   
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(time,true);
   double ld_0=0;
   double ld_8=0;
   double ld_16=0;
   double ld_24=0;
   double ld_32=0;
   double ld_40=0;
   double ld_48=0;
   double ld_56=0;
   double ld_64=0;
   double ld_72=0;
   double ld_80=0;
   double ld_88=0;
   double ld_96=0;
   double ld_104=0;
   double ld_112=0;
   double ld_120=0;
   double ld_128=0;
   double ld_136=0;
   double ld_144=0;
   double ld_152=0;
   double ld_160=0;
   double ld_168=0;
   double ld_176=0;
   double ld_184=0;
   double ld_192=0;
   double ld_200=0;
   double ld_208=0;
   double ld_216 = Bars(NULL,0) - gi_84 - 1;
   for (int li_224 = (int)ld_216; li_224 >= 0; li_224--) {
      if (ld_8 == 0.0) {
         ld_8 = 1.0;
         ld_16 = 0.0;
         if (gi_84 - 1 >= 5) ld_0 = gi_84 - 1.0;
         else ld_0 = 5.0;
         ld_80 = 100.0 * ((high[li_224] + low[li_224] + close[li_224]) / 3.0);
         ld_96 = 3.0 / (gi_84 + 2.0);
         ld_104 = 1.0 - ld_96;
      } else {
         if (ld_0 <= ld_8) ld_8 = ld_0 + 1.0;
         else ld_8 += 1.0;
         ld_88 = ld_80;
         ld_80 = 100.0 * ((high[li_224] + low[li_224] + close[li_224]) / 3.0);
         ld_32 = ld_80 - ld_88;
         ld_112 = ld_104 * ld_112 + ld_96 * ld_32;
         ld_120 = ld_96 * ld_112 + ld_104 * ld_120;
         ld_40 = 1.5 * ld_112 - ld_120 / 2.0;
         ld_128 = ld_104 * ld_128 + ld_96 * ld_40;
         ld_208 = ld_96 * ld_128 + ld_104 * ld_208;
         ld_48 = 1.5 * ld_128 - ld_208 / 2.0;
         ld_136 = ld_104 * ld_136 + ld_96 * ld_48;
         ld_152 = ld_96 * ld_136 + ld_104 * ld_152;
         ld_56 = 1.5 * ld_136 - ld_152 / 2.0;
         ld_160 = ld_104 * ld_160 + ld_96 * MathAbs(ld_32);
         ld_168 = ld_96 * ld_160 + ld_104 * ld_168;
         ld_64 = 1.5 * ld_160 - ld_168 / 2.0;
         ld_176 = ld_104 * ld_176 + ld_96 * ld_64;
         ld_184 = ld_96 * ld_176 + ld_104 * ld_184;
         ld_144 = 1.5 * ld_176 - ld_184 / 2.0;
         ld_192 = ld_104 * ld_192 + ld_96 * ld_144;
         ld_200 = ld_96 * ld_192 + ld_104 * ld_200;
         ld_72 = 1.5 * ld_192 - ld_200 / 2.0;
         if (ld_0 >= ld_8 && ld_80 != ld_88) ld_16 = 1.0;
         if (ld_0 == ld_8 && ld_16 == 0.0) ld_8 = 0.0;
      }
      if (ld_0 < ld_8 && ld_72 > 0.0000000001) {
         ld_24 = 50.0 * (ld_56 / ld_72 + 1.0);
         if (ld_24 > 100.0) ld_24 = 100.0;
         if (ld_24 < 0.0) ld_24 = 0.0;
      } else ld_24 = 50.0;
      bufferGreenLine[li_224] = ld_24;
   }
   
   
//---  复制缓冲区数据
      int to_copy; 
      if(prev_calculated>rates_total || prev_calculated<=0) 
         to_copy=rates_total; 
      else 
        { 
         to_copy=rates_total-prev_calculated; 
         //--- 常常复制最后的值 
         to_copy++; 
        } 
      //CopyBuffer(handle_RSI,0,0,to_copy,buffRSI); 
      //CopyBuffer(handle_RSI,0,0,to_copy,buffCircle);
      
      c_RSI.Refresh();
      c_RSI.GetData(0, to_copy, 0, buffRSI);//获取指标数据，0号开始，共任意个数值，存入data 
      c_RSI.GetData(0, to_copy, 0, buffCircle);
      c_RSI14.Refresh();
      c_RSI14.GetData(0, to_copy, 0, buffRSI14);
      for(int i=0; i<to_copy; i++)
      {
         buffCircleColor[i]=0.0; // 默认红色
         buffBullSignal[i]=EMPTY_VALUE;
         buffBearSignal[i]=EMPTY_VALUE;
      }
      //ArrayPrint(buffRSI, 2, NULL, 0, 3);
      
      
// ---   画箭头
      if(Inp_ShowArrow)
      {
               //收盘时
               if(prev_calculated!=rates_total || prev_calculated<=0)
               {      
                           int n=0,m=0;
                           for(int i=0; i<to_copy && (n+m)<Inp_MaxArrow*2; i++)// 箭头数量 ddsf
                           {           
                                       //  数据太少，退出
                                       if(time[i]<time[rates_total-14]) break;
                                       
                                       //  向下箭头  死叉
                                       if(buffRSI[i+1]<bufferGreenLine[i+1] && buffRSI[i+2]>bufferGreenLine[i+2])//《《《《《《《《《《《《《《
                                       {
                                                  if(Inp_onlySell)
                                                  {
                                                      int sigShift=i+1;
                                                      buffCircleColor[sigShift]=2.0; // 看跌信号: 黄色
                                                      buffBearSignal[sigShift]=buffRSI[sigShift];
                                                      ArrowUpCreate(time[sigShift], bufferGreenLine[sigShift]);
                                                      n++;
                                                  }                
                                       }
                                       
                                       //  向上箭头  金叉
                                       if(buffRSI[i+1]>bufferGreenLine[i+1] && buffRSI[i+2]<bufferGreenLine[i+2])//《《《《《《《《《《《《《《
                                       {
                                                  if(Inp_onlyBuy)
                                                  {
                                                      int sigShift=i+1;
                                                      buffCircleColor[sigShift]=1.0; // 看涨信号: 绿色
                                                      buffBullSignal[sigShift]=buffRSI[sigShift];
                                                      ArrowDownCreate(time[sigShift], bufferGreenLine[sigShift]);
                                                      m++;
                                                  }                
                                       }            
                           
                  
                           }
               }
          
      }   
   
//--- create timer
   
 
   
//--- 警报 设置 
   if(Inp_Alert || Inp_SendMail || Inp_SendNotification) 
   {  
      // 1分钟 警报 
      if(isNewBar(PERIOD_M1) && Inp_Alert_M1)
      {
            c_RSI_M1.Refresh();
            double GreenLineM1[];
            if(!CalcGreenLineByPeriod(PERIOD_M1,GreenLineM1))
            {
               if(Inp_DebugAlert) Print("Alert skip M1: CalcGreenLineByPeriod failed");
            }
            else
            {
         
            //  向下箭头  死叉
            if(c_RSI_M1.Main(1)<GreenLineM1[1] && c_RSI_M1.Main(2)>GreenLineM1[2] && Inp_onlySell)//《《《《《《《《《《《《《《
            {
                     SendAlert(PERIOD_M1, -1);
            }
            //  向上箭头  金叉
            if(c_RSI_M1.Main(1)>GreenLineM1[1] && c_RSI_M1.Main(2)<GreenLineM1[2] && Inp_onlyBuy)//《《《《《《《《《《《《《《
            {
                     SendAlert(PERIOD_M1, 1);
            }
            }
      }
      
      // 5分钟 警报
      if(isNewBar(PERIOD_M5) && Inp_Alert_M5)
      {
            c_RSI_M5.Refresh();
            double GreenLineM5[];
            if(!CalcGreenLineByPeriod(PERIOD_M5,GreenLineM5))
            {
               if(Inp_DebugAlert) Print("Alert skip M5: CalcGreenLineByPeriod failed");
            }
            else
            {
            //  向下箭头  死叉
            if(c_RSI_M5.Main(1)<GreenLineM5[1] && c_RSI_M5.Main(2)>GreenLineM5[2] && Inp_onlySell)
            {
                     SendAlert(PERIOD_M5, -1);
            }
            //  向上箭头  金叉
            if(c_RSI_M5.Main(1)>GreenLineM5[1] && c_RSI_M5.Main(2)<GreenLineM5[2] && Inp_onlyBuy)
            {
                     SendAlert(PERIOD_M5, 1);
            }
            }
      }

      // 15分钟 警报
      if(Inp_Alert_M15 && isNewBar(PERIOD_M15))
      {
            c_RSI_M15.Refresh(); 
            double GreenLineM15[];
            if(!CalcGreenLineByPeriod(PERIOD_M15,GreenLineM15))
            {
               if(Inp_DebugAlert) Print("Alert skip M15: CalcGreenLineByPeriod failed");
            }
            else
            {
            //Print(bufferGreenLine[0],"  15分钟：",GreenLineM15[0]);

         
            //  向下箭头  死叉
            if(c_RSI_M15.Main(1)<GreenLineM15[1] && c_RSI_M15.Main(2)>GreenLineM15[2] && Inp_onlySell)
            {
                     SendAlert(PERIOD_M15, -1);
            }
            
            //  向上箭头  金叉
            if(c_RSI_M15.Main(1)>GreenLineM15[1] && c_RSI_M15.Main(2)<GreenLineM15[2] && Inp_onlyBuy)
            {
                     SendAlert(PERIOD_M15, 1);
            }
            }
      }
      
      // 30分钟 警报
      if(Inp_Alert_M30 && isNewBar(PERIOD_M30))
      {
            c_RSI_M30.Refresh();   
            double GreenLineM30[];
            if(!CalcGreenLineByPeriod(PERIOD_M30,GreenLineM30))
            {
               if(Inp_DebugAlert) Print("Alert skip M30: CalcGreenLineByPeriod failed");
            }
            else
            {

         
            //  向下箭头  死叉
            if(c_RSI_M30.Main(1)<GreenLineM30[1] && c_RSI_M30.Main(2)>GreenLineM30[2] && Inp_onlySell)
            {
                     SendAlert(PERIOD_M30, -1);
            }
            
            //  向上箭头  金叉
            if(c_RSI_M30.Main(1)>GreenLineM30[1] && c_RSI_M30.Main(2)<GreenLineM30[2] && Inp_onlyBuy)
            {
                     SendAlert(PERIOD_M30, 1);
            }
            }
      }
      
      
      // 1小时 警报
      if(Inp_Alert_H1 && isNewBar(PERIOD_H1))
      {
            c_RSI_H1.Refresh();     
            double GreenLineH1[];
            if(!CalcGreenLineByPeriod(PERIOD_H1,GreenLineH1))
            {
               if(Inp_DebugAlert) Print("Alert skip H1: CalcGreenLineByPeriod failed");
            }
            else
            {

         
            //  向下箭头  死叉
            if(c_RSI_H1.Main(1)<GreenLineH1[1] && c_RSI_H1.Main(2)>GreenLineH1[2] && Inp_onlySell)
            {
                     SendAlert(PERIOD_H1, -1);
            }
            
            //  向上箭头  金叉
            if(c_RSI_H1.Main(1)>GreenLineH1[1] && c_RSI_H1.Main(2)<GreenLineH1[2] && Inp_onlyBuy)
            {
                     SendAlert(PERIOD_H1, 1);                     
            }
            }
      }
      
      
      // 4小时 警报
      if(Inp_Alert_H4 && isNewBar(PERIOD_H4))
      {
            c_RSI_H4.Refresh();     
            double GreenLineH4[];
            if(!CalcGreenLineByPeriod(PERIOD_H4,GreenLineH4))
            {
               if(Inp_DebugAlert) Print("Alert skip H4: CalcGreenLineByPeriod failed");
            }
            else
            {

         
            //  向下箭头  死叉
            if(c_RSI_H4.Main(1)<GreenLineH4[1] && c_RSI_H4.Main(2)>GreenLineH4[2] && Inp_onlySell)
            {
                     SendAlert(PERIOD_H4, -1);                     
            }
            
            //  向上箭头  金叉
            if(c_RSI_H4.Main(1)>GreenLineH4[1] && c_RSI_H4.Main(2)<GreenLineH4[2] && Inp_onlyBuy)
            {
                     SendAlert(PERIOD_H4, 1);                                          
            }
            }
      }
      
      
      // 1天 警报
      if(Inp_Alert_D1 && isNewBar(PERIOD_D1))
      {
            c_RSI_D1.Refresh();     
            double GreenLineD1[];
            if(!CalcGreenLineByPeriod(PERIOD_D1,GreenLineD1))
            {
               if(Inp_DebugAlert) Print("Alert skip D1: CalcGreenLineByPeriod failed");
            }
            else
            {

         
            //  向下箭头  死叉
            if(c_RSI_D1.Main(1)<GreenLineD1[1] && c_RSI_D1.Main(2)>GreenLineD1[2] && Inp_onlySell)
            {
                     SendAlert(PERIOD_D1, -1);                                          
            }
            
            //  向上箭头  金叉
            if(c_RSI_D1.Main(1)>GreenLineD1[1] && c_RSI_D1.Main(2)<GreenLineD1[2] && Inp_onlyBuy)
            {
                     SendAlert(PERIOD_D1, 1);                                          
            }
            }
      }
      
      
      // 1星期 警报
      if(Inp_Alert_W1 && isNewBar(PERIOD_W1))
      {
            c_RSI_W1.Refresh();     
            double GreenLineW1[];
            if(!CalcGreenLineByPeriod(PERIOD_W1,GreenLineW1))
            {
               if(Inp_DebugAlert) Print("Alert skip W1: CalcGreenLineByPeriod failed");
            }
            else
            {

         
            //  向下箭头  死叉
            if(c_RSI_W1.Main(1)<GreenLineW1[1] && c_RSI_W1.Main(2)>GreenLineW1[2] && Inp_onlySell)
            {
                     SendAlert(PERIOD_W1, -1);                                          
            }
            
            //  向上箭头  金叉
            if(c_RSI_W1.Main(1)>GreenLineW1[1] && c_RSI_W1.Main(2)<GreenLineW1[2] && Inp_onlyBuy)
            {
                     SendAlert(PERIOD_W1, 1);                         
            }
            }
      }
      
      
      // 1月线 警报
      if(Inp_Alert_MN && isNewBar(PERIOD_MN1))
      {
            c_RSI_MN.Refresh();     
            double GreenLineMN1[];
            if(!CalcGreenLineByPeriod(PERIOD_MN1,GreenLineMN1))
            {
               if(Inp_DebugAlert) Print("Alert skip MN1: CalcGreenLineByPeriod failed");
            }
            else
            {

         
            //  向下箭头  死叉
            if(c_RSI_MN.Main(1)<GreenLineMN1[1] && c_RSI_MN.Main(2)>GreenLineMN1[2] && Inp_onlySell)
            {
                     SendAlert(PERIOD_MN1, -1);                     
                     
            }
            
            //  向上箭头  金叉
            if(c_RSI_MN.Main(1)>GreenLineMN1[1] && c_RSI_MN.Main(2)<GreenLineMN1[2] && Inp_onlyBuy)
            {
                     SendAlert(PERIOD_MN1, 1);                     
                     
            }
            }
      }
      

         
      
   }   
      

   // 改回报警周期标签颜色    
   if(onAlert)
   {
         //  警报后， 10秒， 颜色消失
         if((int)(TimeCurrent()-newAlertTime)>10)
         {
               if(ObjectsTotal(0,-1,OBJ_LABEL)>=1)
               {
                     for(int i = ObjectsTotal(0,-1,OBJ_LABEL)-1;i>=0;i--)
                     {
                        string name =  ObjectName(0,i,-1, OBJ_LABEL); 
                        if(StringFind(name,Tips + "LabelAlert",0)!=-1)//找到相符名字
                           ObjectSetInteger(0,name, OBJPROP_COLOR, clrDarkGray);//删除声明信息文字
                     }
                     onAlert=false;
                     ChartRedraw(0);       
               }
 
         }
   }
      
   //SetTime(); // K线倒计时
   TimeShow();
   return(rates_total); 
  }
//+------------------------------------------------------------------+
//|   时间周期 转化为 字符                                 |
//+------------------------------------------------------------------+  
string ptostr(int a)
  {
   string res="";
   if(a==PERIOD_M1)
     {
      res="M1";
     }
   if(a==PERIOD_M5)
     {
      res="M5";
     }
   if(a==PERIOD_M15)
     {
      res="M15";
     }
   if(a==PERIOD_M30)
     {
      res="M30";
     }
   if(a==PERIOD_H1)
     {
      res="H1";
     }
   if(a==PERIOD_H4)
     {
      res="H4";
     }
   if(a==PERIOD_D1)
     {
      res="D1";
     }
   if(a==PERIOD_W1)
     {
      res="W1";
     }
   if(a==PERIOD_MN1)
     {
      res="MN1";
     }
   return res;
  }  

bool CalcGreenLineByPeriod(const ENUM_TIMEFRAMES period,double &outGreen[])
{
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int bars=CopyRates(Symbol(),period,0,500,rates);
   if(bars<=gi_84+3)
      return(false);

   double tempGreen[];
   ArrayResize(tempGreen,bars);
   ArraySetAsSeries(tempGreen,true);

   double ld_0=0,ld_8=0,ld_16=0,ld_24=0,ld_32=0,ld_40=0,ld_48=0,ld_56=0,ld_64=0,ld_72=0;
   double ld_80=0,ld_88=0,ld_96=0,ld_104=0,ld_112=0,ld_120=0,ld_128=0,ld_136=0,ld_144=0;
   double ld_152=0,ld_160=0,ld_168=0,ld_176=0,ld_184=0,ld_192=0,ld_200=0,ld_208=0;
   int startBar=bars-gi_84-1;
   for(int i=startBar;i>=0;i--)
   {
      if(ld_8==0.0)
      {
         ld_8=1.0;
         ld_16=0.0;
         ld_0=(gi_84-1>=5)?gi_84-1.0:5.0;
         ld_80=100.0*((rates[i].high+rates[i].low+rates[i].close)/3.0);
         ld_96=3.0/(gi_84+2.0);
         ld_104=1.0-ld_96;
      }
      else
      {
         if(ld_0<=ld_8) ld_8=ld_0+1.0;
         else ld_8+=1.0;
         ld_88=ld_80;
         ld_80=100.0*((rates[i].high+rates[i].low+rates[i].close)/3.0);
         ld_32=ld_80-ld_88;
         ld_112=ld_104*ld_112+ld_96*ld_32;
         ld_120=ld_96*ld_112+ld_104*ld_120;
         ld_40=1.5*ld_112-ld_120/2.0;
         ld_128=ld_104*ld_128+ld_96*ld_40;
         ld_208=ld_96*ld_128+ld_104*ld_208;
         ld_48=1.5*ld_128-ld_208/2.0;
         ld_136=ld_104*ld_136+ld_96*ld_48;
         ld_152=ld_96*ld_136+ld_104*ld_152;
         ld_56=1.5*ld_136-ld_152/2.0;
         ld_160=ld_104*ld_160+ld_96*MathAbs(ld_32);
         ld_168=ld_96*ld_160+ld_104*ld_168;
         ld_64=1.5*ld_160-ld_168/2.0;
         ld_176=ld_104*ld_176+ld_96*ld_64;
         ld_184=ld_96*ld_176+ld_104*ld_184;
         ld_144=1.5*ld_176-ld_184/2.0;
         ld_192=ld_104*ld_192+ld_96*ld_144;
         ld_200=ld_96*ld_192+ld_104*ld_200;
         ld_72=1.5*ld_192-ld_200/2.0;
         if(ld_0>=ld_8&&ld_80!=ld_88) ld_16=1.0;
         if(ld_0==ld_8&&ld_16==0.0) ld_8=0.0;
      }
      if(ld_0<ld_8&&ld_72>0.0000000001)
      {
         ld_24=50.0*(ld_56/ld_72+1.0);
         if(ld_24>100.0) ld_24=100.0;
         if(ld_24<0.0) ld_24=0.0;
      }
      else ld_24=50.0;
      tempGreen[i]=ld_24;
   }

   ArrayResize(outGreen,3);
   outGreen[0]=tempGreen[0];
   outGreen[1]=tempGreen[1];
   outGreen[2]=tempGreen[2];
   return(true);
}



//+------------------------------------------------------------------+
//|                 警报发送 函数     根据方向，周期            |
//+------------------------------------------------------------------+
void SendAlert(const ENUM_TIMEFRAMES period, const int dir)
{
   string alertMess= dir>0 ? "向上突破警告：上涨" : "向下突破警告：下跌";
   alertMess= Symbol()+" 周期 "+ptostr(period)+alertMess;
   color clr= dir>0 ? clrWhite : clrYellow;
   
   // 弹出窗口警报
   if(Inp_Alert)
      Alert(alertMess);
      
   // 邮件警报   
   if(Inp_SendMail)
      SendMail("MT5交易警报："+shortname, alertMess);
      
   // “通知”警报
   if(Inp_SendNotification)
      SendNotification(alertMess);

   // 当前图表周期与报警周期一致时，红点颜色与弹窗同步
   if(period==(ENUM_TIMEFRAMES)Period())
   {
      int sigShift=1;
      if(dir>0)
      {
         buffCircleColor[sigShift]=1.0; // 看涨信号: 绿色
         buffBullSignal[sigShift]=buffRSI[sigShift];
      }
      else
      {
         buffCircleColor[sigShift]=2.0; // 看跌信号: 黄色
         buffBearSignal[sigShift]=buffRSI[sigShift];
      }
   }
      
   // 警报发生， 标记相关周期的颜色
   ObjectSetInteger(0,Tips + "LabelAlert" + ptostr(period),OBJPROP_COLOR,clr);
   
   // 警报生效时间，用于显示右下角警报标记变化
   onAlert=true;     //  警报发出
   newAlertTime=TimeCurrent();      // 警报发出时间
}

    
//+------------------------------------------------------------------+ 
//|  当新柱形图出现时返回'true'                                         | 
//+------------------------------------------------------------------+ 
//检查是不是新K线
bool isNewBar(const ENUM_TIMEFRAMES period) 
{
   static datetime last_time_M1 = 0;
   static datetime last_time_M5 = 0;
   static datetime last_time_M15 = 0; 
   static datetime last_time_M30 = 0;
   static datetime last_time_H1 = 0;     
   static datetime last_time_H4 = 0;
   static datetime last_time_D1 = 0; 
   static datetime last_time_W1 = 0;
   static datetime last_time_MN1 = 0; 
          
   datetime lastbar_time = iTime(Symbol(),period,0);  // datetime(SeriesInfoInteger(Symbol(), period, SERIES_LASTBAR_DATE));
   
   if(period==PERIOD_M1)
   {    
      if(last_time_M1 == 0)
      {
         last_time_M1 = lastbar_time;
         return(false);
      }
      if(last_time_M1 != lastbar_time)
      {
         last_time_M1 = lastbar_time;
         return(true);
      }
   }
   
   if(period==PERIOD_M15)
   {    
      if(last_time_M15 == 0)
      {
         last_time_M15 = lastbar_time;
         return(false);
      }
      if(last_time_M15 != lastbar_time)
      {
         last_time_M15 = lastbar_time;
         return(true);
      }
   }      
   
   if(period==PERIOD_M5)
   {    
      if(last_time_M5 == 0)
      {
         last_time_M5 = lastbar_time;
         return(false);
      }
      if(last_time_M5 != lastbar_time)
      {
         last_time_M5 = lastbar_time;
         return(true);
      }
   }
      
   if(period==PERIOD_M30)
   {    
      if(last_time_M30 == 0)
      {
         last_time_M30 = lastbar_time;
         return(false);
      }
      if(last_time_M30 != lastbar_time)
      {
         last_time_M30 = lastbar_time;
         return(true);
      }
   }      
      
      
   if(period==PERIOD_H1)
   {    
      if(last_time_H1 == 0)
      {
            last_time_H1 = lastbar_time;
            return(false);
      }
      if(last_time_H1 != lastbar_time)
      {
         last_time_H1 = lastbar_time;
         return(true);
      }
   }      
      
   if(period==PERIOD_H4)
   {    
      if(last_time_H4 == 0)
      {
         last_time_H4 = lastbar_time;
         return(false);
      }
      if(last_time_H4 != lastbar_time)
      {
         last_time_H4 = lastbar_time;
         return(true);
      }
   }      
      
   if(period==PERIOD_D1)
   {    
      if(last_time_D1 == 0)
      {
         last_time_D1 = lastbar_time;
         return(false);
      }
      if(last_time_D1 != lastbar_time)
      {
         last_time_D1 = lastbar_time;
         return(true);
      }
   }      
      
   if(period==PERIOD_W1)
   {    
      if(last_time_W1 == 0)
      {
         last_time_W1 = lastbar_time;
         return(false);
      }
      if(last_time_W1 != lastbar_time)
      {
         last_time_W1 = lastbar_time;
         return(true);
      }
   }      
      
   if(period==PERIOD_MN1)
   {    
      if(last_time_MN1 == 0)
      {
         last_time_MN1 = lastbar_time;
         return(false);
      }
      if(last_time_MN1 != lastbar_time)
      {
         last_time_MN1 = lastbar_time;
         return(true);
      }
   }

   return(false);
}
//+------------------------------------------------------------------+ 
//|  当新柱形图出现时返回'true'                                         | 
//+------------------------------------------------------------------+ 
bool isNewBar222(const ENUM_TIMEFRAMES period) 
{
   // 不同周期 开始价
   datetime lastbar_time =iTime(Symbol(),period,0);// (datetime)SeriesInfoInteger(NULL, period, SERIES_LASTBAR_DATE);
//
   if(TimeCurrent() == lastbar_time)      
   {

      return(true);
   }
   return(false);
}
  
//刷新函数
bool Refresh(void)
{
   if(!m_symbol.RefreshRates())
   {
      Print("refresh error");
      return (false);
   }
   if(m_symbol.Ask() == 0 || m_symbol.Bid() == 0)
   {
      Print("refresh error");
      return (false);
   }
   
   return(true);
}  

  
//+------------------------------------------------------------------+ 
//| 创建箭头向上符号                                                   | 
//+------------------------------------------------------------------+ 
bool ArrowUpCreate(datetime                time=0,               // 定位点时间 
                   double                  price=0)              // 定位点价格 
  { 
//--- 若未设置则设置定位点的坐标 
   ChangeArrowEmptyPoint(time,price); 
//--- 重置错误的值 
   ResetLastError(); 
//--- 创建符号 
   string name= Tips + "ArrowUp" + IntegerToString(time);
   if(!ObjectCreate(0,name,OBJ_ARROW,1,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": 画向下黄色箭头失败! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- 设置定位类型 
   ObjectSetInteger(0,name,OBJPROP_ARROWCODE,226);    // 设置箭头代码 
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_BOTTOM); 
//--- 设置符号颜色 
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrYellow); 
//--- 设置边界线条风格 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID); 
//--- 设置符号大小 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,1); 
//--- 显示前景 (false) 或背景 (true) 
   ObjectSetInteger(0,name,OBJPROP_BACK,false); 
//--- 启用 (true) 或禁用 (false) 通过鼠标移动符号的模式 
//--- 当使用ObjectCreate函数创建图形对象时，对象不能 
//--- 默认下突出并移动。在这个方法中，默认选择参数 
//--- true 可以突出移动对象 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false); 
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false); 
//--- 在对象列表隐藏(true) 或显示 (false) 图形对象名称 
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true); 
//--- 设置在图表中优先接收鼠标点击事件 
   ObjectSetInteger(0,name,OBJPROP_ZORDER,0); 
   ChartRedraw(0);  
//--- 成功执行 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| 删除箭头向上符号                                                   | 
//+------------------------------------------------------------------+ 
bool ArrowUpDelete(const string name) // 符号名称 
  { 
//--- 重置错误的值 
   ResetLastError(); 
//--- 删除符号 
   if(!ObjectDelete(0,name)) 
     { 
      Print(__FUNCTION__, 
            ": 删除白色向上箭头失败! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- 成功执行 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| 检查定位点的值和为空点设置                                           | 
//| 默认的值                                                          | 
//+------------------------------------------------------------------+ 
void ChangeArrowEmptyPoint(datetime &time,double &price) 
  { 
//--- 如果点的时间没有设置，它将位于当前柱 
   if(!time) 
      time=TimeCurrent(); 
//--- 如果点的价格没有设置，则它将用卖价值 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
  }   
  

//+------------------------------------------------------------------+ 
//| 创建箭头向下符号                                                   | 
//+------------------------------------------------------------------+ 
bool ArrowDownCreate(datetime                time=0,               // 定位点时间 
                     double                  price=0)              // 定位点价格 
  { 
//--- 若未设置则设置定位点的坐标 
   ChangeArrowEmptyPoint(time,price); 
//--- 重置错误的值 
   ResetLastError(); 
//--- 创建符号 
   string name= Tips + "ArrowDown" + IntegerToString(time);
   if(!ObjectCreate(0,name,OBJ_ARROW,1,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": 画向上箭头失败! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- 设置定位类型 
   ObjectSetInteger(0,name,OBJPROP_ARROWCODE,225);    // 设置箭头代码 
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_TOP); 
//--- 设置符号颜色 
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrWhite); 
//--- 设置边界线条风格 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID); 
//--- 设置符号大小 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,1); 
//--- 显示前景 (false) 或背景 (true) 
   ObjectSetInteger(0,name,OBJPROP_BACK,false); 
//--- 启用 (true) 或禁用 (false) 通过鼠标移动符号的模式 
//--- 当使用ObjectCreate函数创建图形对象时，对象不能 
//--- 默认下突出并移动。在这个方法中，默认选择参数 
//--- true 可以突出移动对象 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false); 
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false); 
//--- 在对象列表隐藏(true) 或显示 (false) 图形对象名称 
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true); 
//--- 设置在图表中优先接收鼠标点击事件 
   ObjectSetInteger(0,name,OBJPROP_ZORDER,0); 
   ChartRedraw(0);  
//--- 成功执行 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| 删除箭头向下符号                                                   | 
//+------------------------------------------------------------------+ 
bool ArrowDownDelete(const string name) // 符号名称 
  { 
//--- 重置错误的值 
   ResetLastError(); 
//--- 删除符号 
   if(!ObjectDelete(0,name)) 
     { 
      Print(__FUNCTION__, 
            ": 删除向下箭头失败! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- 成功执行 
   return(true); 
  }     
  
  
  
  
  
//+------------------------------------------------------------------+ 
//|      警报 各周期  信息                                                | 
//+------------------------------------------------------------------+ 
bool CreateLabelAlert(ENUM_TIMEFRAMES timeframe, int y)              // 定位点价格 
  { 

//--- 重置错误的值 
   ResetLastError(); 
//--- 创建符号 
   string name= Tips + "LabelAlert" + ptostr(timeframe);
   string text=ptostr(timeframe);
   if(!ObjectCreate(0,name,OBJ_LABEL,1,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": 各周期警报信息标签创建失败! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- 设置标签坐标 
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,5); 
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y); 
//--- 设置相对于定义点坐标的图表的角 
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_LOWER); 
//--- 设置文本 
   ObjectSetString(0,name,OBJPROP_TEXT,text); 
//--- 设置文本字体 
   ObjectSetString(0,name,OBJPROP_FONT,"Arial Black");             
//--- 设置字体大小 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10); 
//--- 设置文本的倾斜角 
   ObjectSetDouble(0,name,OBJPROP_ANGLE,0.0); 
//--- 设置定位类型 
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER); 
//--- 设置符号颜色 
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrDarkGray); 
//--- 显示前景 (false) 或背景 (true) 
   ObjectSetInteger(0,name,OBJPROP_BACK,false); 
//--- 启用 (true) 或禁用 (false) 通过鼠标移动符号的模式 
//--- 当使用ObjectCreate函数创建图形对象时，对象不能 
//--- 默认下突出并移动。在这个方法中，默认选择参数 
//--- true 可以突出移动对象 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false); 
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false); 
//--- 在对象列表隐藏(true) 或显示 (false) 图形对象名称 
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,false); 
//--- 设置在图表中优先接收鼠标点击事件 
   ObjectSetInteger(0,name,OBJPROP_ZORDER,0); 
   ChartRedraw(0);  
//--- 成功执行 
   return(true); 
  }   
  
  
  
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int TimeShow()
  {


   MqlRates rates[];
   MqlTick tick;
   SymbolInfoTick(Symbol(),tick);
   
   if(CopyRates(Symbol(),PERIOD_CURRENT,0,1,rates)<1)
      return(false);
      
//--- input parameters
   bool     ShowComment=false;
   color    FontColor=clrYellow;
   int      FontSize=20;
   string   FontName="Tahoma";
   int      Offset=5;      
   double i;
   long m,s;
   
   m=rates[0].time+GetMinute()*60-tick.time;
   i=m/60.0;
   s=m%60;
   m=(m-m%60)/60;


   string text="  <"+IntegerToString(m,0,' ')+":"+IntegerToString(s,0,' ');
   if(ObjectFind(0,"time")<1)
     {
      ObjectCreate(0,"time",OBJ_TEXT,0,rates[0].time,tick.bid+Point()*Offset);
      ObjectSetString(0,"time",OBJPROP_TEXT,text);
      ObjectSetInteger(0,"time",OBJPROP_COLOR,FontColor);
      ObjectSetInteger(0,"time",OBJPROP_FONTSIZE,FontSize);
      ObjectSetString(0,"time",OBJPROP_FONT,FontName);
     }
   else
     {
      ObjectSetString(0,"time",OBJPROP_TEXT,text);
      ObjectMove(0,"time",0,rates[0].time,tick.bid+Point()*Offset);
     }
//---

//--- return value of prev_calculated for next call
   return(true);
  }
//+------------------------------------------------------------------+

int GetMinute()
  {
   switch(Period())
     {
      case PERIOD_M1: return(1);
      case PERIOD_M2: return(2);
      case PERIOD_M3: return(3);
      case PERIOD_M4: return(4);
      case PERIOD_M5: return(5);
      case PERIOD_M6: return(6);
      case PERIOD_M10: return(10);
      case PERIOD_M12: return(12);
      case PERIOD_M15: return(15);
      case PERIOD_M20: return(20);
      case PERIOD_M30: return(30);
      case PERIOD_H1: return(60);
      case PERIOD_H2: return(120);
      case PERIOD_H3: return(180);
      case PERIOD_H4: return(240);
      case PERIOD_H6: return(360);
      case PERIOD_H8: return(480);
      case PERIOD_H12: return(720);
      case PERIOD_D1: return(1440);
      case PERIOD_W1: return(10080);
      case PERIOD_MN1: return(43200);
     }
   return(1);
  }
//+------------------------------------------------------------------+
  
  
  
  
  
  
  
  
  
  
  
  
  
//显示交易时间
void SetTime(void)
{
   if(ObjectFind(0, "LastTime") < 0)
   {
      //时间初始化
      ObjectCreate(0, "LastTime", OBJ_LABEL, 0, 0, 0);
      //x坐标
      ObjectSetInteger(0, "LastTime", OBJPROP_XDISTANCE, 10);
      //Y坐标
      ObjectSetInteger(0, "LastTime", OBJPROP_YDISTANCE, 2);
      //文本颜色
      ObjectSetInteger(0, "LastTime", OBJPROP_COLOR, clrDimGray);
      ObjectSetInteger(0, "LastTime", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      ObjectSetInteger(0, "LastTime", OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
      
   }
   
   MqlRates rates[];
   CopyRates(m_symbol.Name(), 0, 0, 1, rates);
   
   int total = int(rates[0].time + PeriodSeconds() - TimeCurrent());
   int s = total % 60;
   int m = (total - s) / 60;
   
   //标签文本
   ObjectSetString(0, "LastTime", OBJPROP_TEXT, IntegerToString(m) + ":" + IntegerToString(s) );
   //字体大小
   ObjectSetInteger(0, "LastTime", OBJPROP_FONTSIZE, 12);
   //禁止鼠标选择
   ObjectSetInteger(0, "LastTime", OBJPROP_SELECTABLE, false);
   //绘制
   ChartRedraw(0);
}