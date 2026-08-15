//+------------------------------------------------------------------+
//|                 1H                                   ATRBreakout |
//|                                          Copyright 2026 Liang Fu |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"

//--- 引入交易库
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

//--- 输入参数
input double   LotSize          = 0.1;      // 交易手数
input int      ATR_Period       = 14;       // ATR周期
input int      MA_Period        = 20;       // MA周期
input double   StopLoss_ATR     = 2.0;      // 止损ATR倍数
input double   TakeProfit_ATR   = 3.0;      // 止盈ATR倍数
input double   TrailingStop_ATR = 1.5;      // 追踪止损ATR倍数
input int      MagicNumber      = 123456;   // 幻数
input int      Slippage         = 3;        // 滑点(Points)

//--- 全局对象
CTrade         trade;
CPositionInfo  posInfo;

//--- 指标句柄
int    atrHandle;
int    maHandle;

//--- 全局变量
double atrValue;
double maValue;
datetime lastOrderTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- 创建ATR指标句柄
   atrHandle = iATR(_Symbol, PERIOD_CURRENT, ATR_Period);
   if(atrHandle == INVALID_HANDLE)
   {
      Print("创建ATR指标失败，错误码：", GetLastError());
      return(INIT_FAILED);
   }

   //--- 创建MA指标句柄
   maHandle = iMA(_Symbol, PERIOD_CURRENT, MA_Period, 0, MODE_SMA, PRICE_CLOSE);
   if(maHandle == INVALID_HANDLE)
   {
      Print("创建MA指标失败，错误码：", GetLastError());
      return(INIT_FAILED);
   }

   //--- 设置交易对象参数
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(Slippage);
   trade.SetTypeFilling(ORDER_FILLING_IOC);

   Print("EA初始化成功");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- 释放指标句柄
   if(atrHandle != INVALID_HANDLE)
      IndicatorRelease(atrHandle);

   if(maHandle != INVALID_HANDLE)
      IndicatorRelease(maHandle);

   Print("EA已卸载，原因码：", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- 获取指标数据
   if(!GetIndicatorValues())
      return;

   //--- 检查冷却时间（15分钟内不重复开仓）
   if(TimeCurrent() - lastOrderTime < PeriodSeconds(PERIOD_M15))
      return;

   //--- 检查是否已有持仓
   if(HasOpenPosition())
      return;

   //--- 获取上一根K线数据
   double highPrice = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double lowPrice  = iLow(_Symbol, PERIOD_CURRENT,  1);
   double closePrice = iClose(_Symbol, PERIOD_CURRENT, 1);

   //--- 获取当前报价
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   //--- MA上方ATR突破做多
   if(closePrice > maValue && highPrice > (closePrice + atrValue))
   {
      double stopLoss   = bid - (StopLoss_ATR   * atrValue);
      double takeProfit = bid + (TakeProfit_ATR  * atrValue);

      //--- 价格规范化
      stopLoss   = NormalizeDouble(stopLoss,   _Digits);
      takeProfit = NormalizeDouble(takeProfit,  _Digits);

      if(trade.Buy(LotSize, _Symbol, ask, stopLoss, takeProfit, "ATR Breakout Long"))
      {
         Print("做多开仓成功 | Ask:", ask, " SL:", stopLoss, " TP:", takeProfit);
         lastOrderTime = TimeCurrent();
      }
      else
      {
         Print("做多开仓失败，错误码：", GetLastError());
      }
   }
   //--- MA下方ATR突破做空
   else if(closePrice < maValue && lowPrice < (closePrice - atrValue))
   {
      double stopLoss   = ask + (StopLoss_ATR   * atrValue);
      double takeProfit = ask - (TakeProfit_ATR  * atrValue);

      //--- 价格规范化
      stopLoss   = NormalizeDouble(stopLoss,   _Digits);
      takeProfit = NormalizeDouble(takeProfit,  _Digits);

      if(trade.Sell(LotSize, _Symbol, bid, stopLoss, takeProfit, "ATR Breakout Short"))
      {
         Print("做空开仓成功 | Bid:", bid, " SL:", stopLoss, " TP:", takeProfit);
         lastOrderTime = TimeCurrent();
      }
      else
      {
         Print("做空开仓失败，错误码：", GetLastError());
      }
   }

   //--- 执行追踪止损
   TrailingStop();
}

//+------------------------------------------------------------------+
//| 获取指标值                                                       |
//+------------------------------------------------------------------+
bool GetIndicatorValues()
{
   double atrBuffer[];
   double maBuffer[];

   ArraySetAsSeries(atrBuffer, true);
   ArraySetAsSeries(maBuffer,  true);

   //--- 复制ATR数据（取第1根，即上一根K线）
   if(CopyBuffer(atrHandle, 0, 1, 1, atrBuffer) <= 0)
   {
      Print("获取ATR数据失败，错误码：", GetLastError());
      return false;
   }

   //--- 复制MA数据（取第1根，即上一根K线）
   if(CopyBuffer(maHandle, 0, 1, 1, maBuffer) <= 0)
   {
      Print("获取MA数据失败，错误码：", GetLastError());
      return false;
   }

   atrValue = atrBuffer[0];
   maValue  = maBuffer[0];

   return true;
}

//+------------------------------------------------------------------+
//| 检查是否有本EA持仓                                               |
//+------------------------------------------------------------------+
bool HasOpenPosition()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(posInfo.SelectByIndex(i))
      {
         if(posInfo.Magic() == MagicNumber && posInfo.Symbol() == _Symbol)
            return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| 追踪止损函数                                                     |
//+------------------------------------------------------------------+
void TrailingStop()
{
   double trailingDist = TrailingStop_ATR * atrValue;

   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(!posInfo.SelectByIndex(i))
         continue;

      //--- 筛选本EA、本品种的持仓
      if(posInfo.Magic() != MagicNumber || posInfo.Symbol() != _Symbol)
         continue;

      double openPrice  = posInfo.PriceOpen();
      double currentSL  = posInfo.StopLoss();
      double currentTP  = posInfo.TakeProfit();
      ulong  ticket     = posInfo.Ticket();

      //--- 多单追踪止损
      if(posInfo.PositionType() == POSITION_TYPE_BUY)
      {
         double newSL = NormalizeDouble(bid - trailingDist, _Digits);

         //--- 仅在新止损高于当前止损时修改
         if(bid - openPrice > trailingDist && newSL > currentSL)
         {
            if(trade.PositionModify(ticket, newSL, currentTP))
               Print("多单追踪止损更新 | Ticket:", ticket, " 新SL:", newSL);
            else
               Print("多单追踪止损修改失败，错误码：", GetLastError());
         }
      }
      //--- 空单追踪止损
      else if(posInfo.PositionType() == POSITION_TYPE_SELL)
      {
         double newSL = NormalizeDouble(ask + trailingDist, _Digits);

         //--- 仅在新止损低于当前止损时修改
         if(openPrice - ask > trailingDist && (newSL < currentSL || currentSL == 0))
         {
            if(trade.PositionModify(ticket, newSL, currentTP))
               Print("空单追踪止损更新 | Ticket:", ticket, " 新SL:", newSL);
            else
               Print("空单追踪止损修改失败，错误码：", GetLastError());
         }
      }
   }
}
//+------------------------------------------------------------------+