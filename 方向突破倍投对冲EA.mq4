//+------------------------------------------------------------------+
//|                                            方向突破倍投对冲EA.mq4 |
//|                                   基于方向突破+倍数加仓的对冲策略 |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Direction Breakout Hedge EA"
#property link      ""
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| 基本参数设置                                                      |
//+------------------------------------------------------------------+
extern string 基本参数说明 = "=== 基本交易参数设置 ===";
extern double 初始下单手数 = 0.01;           // 初始开仓手数
extern double 对冲手数倍数 = 2.0;            // 对冲开仓倍数（空单相对多单）
extern double 反转加仓倍数 = 4.0;            // 反转加仓倍数（例如：初始0.01->反转0.04->再反转0.16）
extern int 魔数码 = 88888;                   // MagicNumber，区分不同EA
extern int 滑点 = 3;                         // 允许滑点
extern bool 启用统计显示 = true;              // 是否显示统计信息

//+------------------------------------------------------------------+
//| 盈利参数设置                                                      |
//+------------------------------------------------------------------+
extern string 盈利参数说明 = "=== 盈利出场参数设置 ===";
extern int 直接盈利点数 = 50;                // 场景1：多单直接盈利点数
extern int 对冲整体盈利点数 = 30;            // 场景2：对冲后整体盈利点数
extern int 整体盈利阈值点数 = 20;            // 场景3：最终整体盈利阈值点数
extern int 对冲触发点数 = 20;                // 触发开对冲空单的点数

//+------------------------------------------------------------------+
//| 方向判断参数                                                      |
//+------------------------------------------------------------------+
extern string 方向参数说明 = "=== 方向判断参数 ===";
extern double 反转确认点数 = 10;              // 价格回到多单开仓价附近多少点确认反转
extern bool 启用方向确认 = false;             // 是否启用方向确认（暂未使用）

//+------------------------------------------------------------------+
//| 全局变量                                                          |
//+------------------------------------------------------------------+
int magic = 魔数码;
datetime 上次开单时间 = 0;
datetime EA启动时间 = 0;
double 初始多单开仓价 = 0;                    // 记录初始多单开仓价
bool 已开初始多单 = false;                    // 是否已开初始多单
bool 已开对冲空单 = false;                    // 是否已开对冲空单

// 统计变量
double 累计盈利 = 0;
int 总交易次数 = 0;
int 盈利次数 = 0;
int 亏损次数 = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   EA启动时间 = TimeCurrent();
   
   // 重置状态
   已开初始多单 = false;
   已开对冲空单 = false;
   初始多单开仓价 = 0;
   
   // 创建统计标签
   if(启用统计显示)
   {
      CreateStatLabels();
   }
   
   Print("方向突破倍投对冲EA启动成功！");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // 删除统计标签
   DeleteStatLabels();
   Print("方向突破倍投对冲EA已停止！");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // 更新统计信息
   UpdateStatistics();
   
   // 检查是否在同一根K线上已经开过单
   if(Time[0] == 上次开单时间 && 已开初始多单)
   {
      // 已有订单时继续检查盈利条件
      CheckProfitConditions();
      return;
   }
   
   // 如果没有初始多单，先开初始多单
   if(!已开初始多单)
   {
      int longOrders = CountOrders(OP_BUY);
      if(longOrders == 0)
      {
         // 开初始多单
         if(OpenOrder(OP_BUY, 初始下单手数, "初始多单"))
         {
            已开初始多单 = true;
            // 记录初始多单开仓价（从最新多单获取）
            初始多单开仓价 = GetLastOrderPrice(OP_BUY);
            上次开单时间 = Time[0];
            Print("已开初始多单，开仓价: ", DoubleToString(初始多单开仓价, Digits));
         }
      }
      else
      {
         // 已经有多单了，更新状态
         已开初始多单 = true;
         初始多单开仓价 = GetLastOrderPrice(OP_BUY);
      }
      return;
   }
   
   // 检查盈利条件和交易逻辑
   CheckProfitConditions();
   ProcessTradingLogic();
}

//+------------------------------------------------------------------+
//| 处理交易逻辑                                                      |
//+------------------------------------------------------------------+
void ProcessTradingLogic()
{
   int longOrders = CountOrders(OP_BUY);
   int shortOrders = CountOrders(OP_SELL);
   double currentPrice = Ask;
   
   // 如果还没有多单，返回
   if(longOrders == 0)
   {
      已开初始多单 = false;
      已开对冲空单 = false;
      初始多单开仓价 = 0;
      return;
   }
   
   // 更新初始多单开仓价（如果丢失了）
   if(初始多单开仓价 == 0)
   {
      初始多单开仓价 = GetFirstOrderPrice(OP_BUY);
   }
   
   // 场景2：如果有多单但没有对冲空单，检查是否需要开对冲空单
   if(longOrders > 0 && shortOrders == 0 && !已开对冲空单)
   {
      double longOpenPrice = GetFirstOrderPrice(OP_BUY);
      double priceDiff = (longOpenPrice - currentPrice) / Point;
      
      // 如果价格下跌超过触发点数，开对冲空单
      if(priceDiff >= 对冲触发点数)
      {
         double hedgeLot = 初始下单手数 * 对冲手数倍数;
         if(OpenOrder(OP_SELL, hedgeLot, "对冲空单"))
         {
            已开对冲空单 = true;
            上次开单时间 = Time[0];
            Print("已开对冲空单，手数: ", DoubleToString(hedgeLot, 2));
         }
         return;
      }
   }
   
   // 场景3：如果已有多单和空单，检查是否需要反转加仓
   if(longOrders > 0 && shortOrders > 0)
   {
      double firstLongPrice = GetFirstOrderPrice(OP_BUY);
      double lastLongLot = GetLastOrderLots(OP_BUY);
      
      // 检查价格是否回到初始多单开仓价附近（反转确认）
      double priceDiffToFirst = MathAbs(currentPrice - firstLongPrice) / Point;
      
      // 如果价格回到初始多单开仓价附近，且当前价格高于初始多单开仓价，可能反转向上
      if(currentPrice > firstLongPrice && priceDiffToFirst <= 反转确认点数)
      {
         // 检查是否已经有更大手数的多单（避免重复加仓）
         double maxLongLot = GetMaxOrderLots(OP_BUY);
         
         // 场景3：反转加仓 - 新多单是前一多单手数的倍数
         // 例如：初始0.01 -> 反转0.04（是0.01的4倍），再反转0.16（是0.04的4倍）
         double newLot = lastLongLot * 反转加仓倍数;
         
         // 如果已经有更大的手数，说明已经加仓过了，避免重复
         if(maxLongLot < newLot - 0.001)  // 使用小误差避免浮点数比较问题
         {
            if(OpenOrder(OP_BUY, newLot, "反转加仓多单"))
            {
               上次开单时间 = Time[0];
               Print("场景3：已开反转加仓多单，手数: ", DoubleToString(newLot, 2), " (前一手数: ", DoubleToString(lastLongLot, 2), ")");
            }
            return;
         }
      }
      
      // 如果价格低于初始多单开仓价，继续向下，可能需要对冲空单加仓
      if(currentPrice < firstLongPrice)
      {
         double firstShortPrice = GetFirstOrderPrice(OP_SELL);
         double priceDiffFromShort = (currentPrice - firstShortPrice) / Point;
         
         // 如果价格继续下跌，可能需要对冲空单加仓
         if(priceDiffFromShort <= -对冲触发点数)
         {
            double lastShortLot = GetLastOrderLots(OP_SELL);
            double newShortLot = lastShortLot * 反转加仓倍数;
            
            // 检查是否已有更大手数
            double maxShortLot = GetMaxOrderLots(OP_SELL);
            if(maxShortLot < newShortLot)
            {
               if(OpenOrder(OP_SELL, newShortLot, "对冲空单加仓"))
               {
                  上次开单时间 = Time[0];
                  Print("已开对冲空单加仓，手数: ", DoubleToString(newShortLot, 2));
               }
               return;
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 检查盈利条件                                                      |
//+------------------------------------------------------------------+
void CheckProfitConditions()
{
   int longOrders = CountOrders(OP_BUY);
   int shortOrders = CountOrders(OP_SELL);
   
   // 场景1：只有多单，检查直接盈利
   if(longOrders > 0 && shortOrders == 0)
   {
      double longProfit = GetOrdersProfit(OP_BUY);
      double firstLongPrice = GetFirstOrderPrice(OP_BUY);
      double currentPrice = Ask;
      
      // 如果价格高于多单开仓价且盈利达到阈值
      double priceDiff = (currentPrice - firstLongPrice) / Point;
      double profitPoints = longProfit / (MarketInfo(Symbol(), MODE_TICKVALUE) * 初始下单手数);
      
      if(priceDiff >= 直接盈利点数 || profitPoints >= 直接盈利点数)
      {
         CloseAllOrders(OP_BUY);
         Print("场景1：多单直接盈利出场！盈利点数: ", DoubleToString(priceDiff, 1));
         已开初始多单 = false;
         已开对冲空单 = false;
         初始多单开仓价 = 0;
         return;
      }
   }
   
   // 场景2和场景3：有多单和空单，检查整体盈利
   if(longOrders > 0 && shortOrders > 0)
   {
      double longProfit = GetOrdersProfit(OP_BUY);
      double shortProfit = GetOrdersProfit(OP_SELL);
      double totalProfit = longProfit + shortProfit;
      
      // 计算整体盈利点数
      double totalLot = GetTotalLots();
      double profitPoints = 0;
      if(totalLot > 0)
      {
         profitPoints = totalProfit / (MarketInfo(Symbol(), MODE_TICKVALUE) * totalLot);
      }
      
      // 检查是否达到整体盈利阈值
      if(profitPoints >= 整体盈利阈值点数)
      {
         CloseAllOrders(OP_BUY);
         CloseAllOrders(OP_SELL);
         Print("场景2/3：整体盈利出场！盈利点数: ", DoubleToString(profitPoints, 1));
         已开初始多单 = false;
         已开对冲空单 = false;
         初始多单开仓价 = 0;
         return;
      }
      
      // 场景2：如果空单盈利足够大，使得整体盈利达到阈值
      if(shortProfit > 0 && totalProfit > 0)
      {
         if(profitPoints >= 对冲整体盈利点数)
         {
            CloseAllOrders(OP_BUY);
            CloseAllOrders(OP_SELL);
            Print("场景2：对冲后整体盈利出场！盈利点数: ", DoubleToString(profitPoints, 1));
            已开初始多单 = false;
            已开对冲空单 = false;
            初始多单开仓价 = 0;
            return;
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 开仓函数                                                          |
//+------------------------------------------------------------------+
bool OpenOrder(int orderType, double lots, string comment)
{
   string symbol = Symbol();
   double price = 0;
   int ticket = -1;
   
   if(orderType == OP_BUY)
   {
      price = MarketInfo(symbol, MODE_ASK);
      ticket = OrderSend(symbol, OP_BUY, lots, price, 滑点, 0, 0, comment, magic, 0, clrBlue);
   }
   else if(orderType == OP_SELL)
   {
      price = MarketInfo(symbol, MODE_BID);
      ticket = OrderSend(symbol, OP_SELL, lots, price, 滑点, 0, 0, comment, magic, 0, clrRed);
   }
   
   if(ticket > 0)
   {
      Print("开仓成功: ", comment, " 手数: ", DoubleToString(lots, 2), " 价格: ", DoubleToString(price, Digits));
      return(true);
   }
   else
   {
      Print("开仓失败: ", comment, " 错误代码: ", GetLastError());
      return(false);
   }
}

//+------------------------------------------------------------------+
//| 统计订单数量                                                      |
//+------------------------------------------------------------------+
int CountOrders(int orderType)
{
   int count = 0;
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == orderType)
         {
            count++;
         }
      }
   }
   return(count);
}

//+------------------------------------------------------------------+
//| 获取订单总盈利                                                    |
//+------------------------------------------------------------------+
double GetOrdersProfit(int orderType)
{
   double totalProfit = 0;
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == orderType)
         {
            totalProfit += OrderProfit() + OrderSwap() + OrderCommission();
         }
      }
   }
   return(totalProfit);
}

//+------------------------------------------------------------------+
//| 获取最后一单的手数                                                |
//+------------------------------------------------------------------+
double GetLastOrderLots(int orderType)
{
   double lastLots = 初始下单手数;
   datetime lastTime = 0;
   
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == orderType)
         {
            if(OrderOpenTime() > lastTime)
            {
               lastTime = OrderOpenTime();
               lastLots = OrderLots();
            }
         }
      }
   }
   return(lastLots);
}

//+------------------------------------------------------------------+
//| 获取最大手数                                                      |
//+------------------------------------------------------------------+
double GetMaxOrderLots(int orderType)
{
   double maxLots = 0;
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == orderType)
         {
            if(OrderLots() > maxLots)
            {
               maxLots = OrderLots();
            }
         }
      }
   }
   return(maxLots);
}

//+------------------------------------------------------------------+
//| 获取第一单开仓价                                                  |
//+------------------------------------------------------------------+
double GetFirstOrderPrice(int orderType)
{
   double firstPrice = 0;
   datetime firstTime = D'2099.12.31';
   
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == orderType)
         {
            if(OrderOpenTime() < firstTime)
            {
               firstTime = OrderOpenTime();
               firstPrice = OrderOpenPrice();
            }
         }
      }
   }
   return(firstPrice);
}

//+------------------------------------------------------------------+
//| 获取最后一单开仓价                                                |
//+------------------------------------------------------------------+
double GetLastOrderPrice(int orderType)
{
   double lastPrice = 0;
   datetime lastTime = 0;
   
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == orderType)
         {
            if(OrderOpenTime() > lastTime)
            {
               lastTime = OrderOpenTime();
               lastPrice = OrderOpenPrice();
            }
         }
      }
   }
   return(lastPrice);
}

//+------------------------------------------------------------------+
//| 获取总手数                                                        |
//+------------------------------------------------------------------+
double GetTotalLots()
{
   double totalLots = 0;
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic)
         {
            totalLots += OrderLots();
         }
      }
   }
   return(totalLots);
}

//+------------------------------------------------------------------+
//| 平仓所有指定类型订单                                              |
//+------------------------------------------------------------------+
void CloseAllOrders(int orderType)
{
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == orderType)
         {
            // 记录平仓前的盈利
            double orderProfit = OrderProfit() + OrderSwap() + OrderCommission();
            
            bool result = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 滑点, clrYellow);
            if(result)
            {
               // 更新统计数据（每个订单单独统计）
               总交易次数++;
               if(orderProfit > 0)
               {
                  盈利次数++;
               }
               else if(orderProfit < 0)
               {
                  亏损次数++;
               }
               Print("平仓成功: ", OrderTicket(), " 盈利: $", DoubleToString(orderProfit, 2));
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 创建统计标签                                                      |
//+------------------------------------------------------------------+
void CreateStatLabels()
{
   if(!启用统计显示) return;
   
   // 创建标题标签
   ObjectCreate("StatTitle", OBJ_LABEL, 0, 0, 0);
   ObjectSet("StatTitle", OBJPROP_CORNER, 1);
   ObjectSet("StatTitle", OBJPROP_XDISTANCE, 20);
   ObjectSet("StatTitle", OBJPROP_YDISTANCE, 30);
   ObjectSetText("StatTitle", "=== 方向突破倍投对冲EA ===", 12, "Arial Bold", clrWhite);
   
   // 创建累计盈利标签
   ObjectCreate("StatProfit", OBJ_LABEL, 0, 0, 0);
   ObjectSet("StatProfit", OBJPROP_CORNER, 1);
   ObjectSet("StatProfit", OBJPROP_XDISTANCE, 20);
   ObjectSet("StatProfit", OBJPROP_YDISTANCE, 55);
   ObjectSetText("StatProfit", "累计盈利: $0.00", 10, "Arial", clrWhite);
   
   // 创建多单数量标签
   ObjectCreate("StatLongOrders", OBJ_LABEL, 0, 0, 0);
   ObjectSet("StatLongOrders", OBJPROP_CORNER, 1);
   ObjectSet("StatLongOrders", OBJPROP_XDISTANCE, 20);
   ObjectSet("StatLongOrders", OBJPROP_YDISTANCE, 75);
   ObjectSetText("StatLongOrders", "多单数量: 0", 10, "Arial", clrWhite);
   
   // 创建空单数量标签
   ObjectCreate("StatShortOrders", OBJ_LABEL, 0, 0, 0);
   ObjectSet("StatShortOrders", OBJPROP_CORNER, 1);
   ObjectSet("StatShortOrders", OBJPROP_XDISTANCE, 20);
   ObjectSet("StatShortOrders", OBJPROP_YDISTANCE, 95);
   ObjectSetText("StatShortOrders", "空单数量: 0", 10, "Arial", clrWhite);
   
   // 创建交易次数标签
   ObjectCreate("StatTrades", OBJ_LABEL, 0, 0, 0);
   ObjectSet("StatTrades", OBJPROP_CORNER, 1);
   ObjectSet("StatTrades", OBJPROP_XDISTANCE, 20);
   ObjectSet("StatTrades", OBJPROP_YDISTANCE, 115);
   ObjectSetText("StatTrades", "总交易次数: 0", 10, "Arial", clrWhite);
   
   // 创建盈利次数标签
   ObjectCreate("StatWinCount", OBJ_LABEL, 0, 0, 0);
   ObjectSet("StatWinCount", OBJPROP_CORNER, 1);
   ObjectSet("StatWinCount", OBJPROP_XDISTANCE, 20);
   ObjectSet("StatWinCount", OBJPROP_YDISTANCE, 135);
   ObjectSetText("StatWinCount", "盈利次数: 0", 10, "Arial", clrLime);
   
   // 创建亏损次数标签
   ObjectCreate("StatLossCount", OBJ_LABEL, 0, 0, 0);
   ObjectSet("StatLossCount", OBJPROP_CORNER, 1);
   ObjectSet("StatLossCount", OBJPROP_XDISTANCE, 20);
   ObjectSet("StatLossCount", OBJPROP_YDISTANCE, 155);
   ObjectSetText("StatLossCount", "亏损次数: 0", 10, "Arial", clrRed);
}

//+------------------------------------------------------------------+
//| 更新统计信息                                                      |
//+------------------------------------------------------------------+
void UpdateStatistics()
{
   if(!启用统计显示) return;
   
   // 计算累计盈利
   累计盈利 = CalculateTotalProfit();
   
   // 获取当前订单数量
   int longOrders = CountOrders(OP_BUY);
   int shortOrders = CountOrders(OP_SELL);
   
   // 更新标签显示
   ObjectSetText("StatProfit", "累计盈利: $" + DoubleToString(累计盈利, 2), 10, "Arial", 
                累计盈利 >= 0 ? clrLime : clrRed);
   ObjectSetText("StatLongOrders", "多单数量: " + longOrders, 10, "Arial", clrWhite);
   ObjectSetText("StatShortOrders", "空单数量: " + shortOrders, 10, "Arial", clrWhite);
   ObjectSetText("StatTrades", "总交易次数: " + 总交易次数, 10, "Arial", clrWhite);
   ObjectSetText("StatWinCount", "盈利次数: " + 盈利次数, 10, "Arial", clrLime);
   ObjectSetText("StatLossCount", "亏损次数: " + 亏损次数, 10, "Arial", clrRed);
}

//+------------------------------------------------------------------+
//| 计算累计盈利                                                      |
//+------------------------------------------------------------------+
double CalculateTotalProfit()
{
   double totalProfit = 0;
   
   // 计算历史订单盈利
   for(int i = OrdersHistoryTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic)
         {
            if(OrderCloseTime() > EA启动时间)
            {
               totalProfit += OrderProfit() + OrderSwap() + OrderCommission();
            }
         }
      }
   }
   
   // 计算当前持仓浮动盈利
   for(int j = 0; j < OrdersTotal(); j++)
   {
      if(OrderSelect(j, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic)
         {
            totalProfit += OrderProfit() + OrderSwap() + OrderCommission();
         }
      }
   }
   
   return(totalProfit);
}

//+------------------------------------------------------------------+
//| 删除统计标签                                                      |
//+------------------------------------------------------------------+
void DeleteStatLabels()
{
   ObjectDelete("StatTitle");
   ObjectDelete("StatProfit");
   ObjectDelete("StatLongOrders");
   ObjectDelete("StatShortOrders");
   ObjectDelete("StatTrades");
   ObjectDelete("StatWinCount");
   ObjectDelete("StatLossCount");
}

