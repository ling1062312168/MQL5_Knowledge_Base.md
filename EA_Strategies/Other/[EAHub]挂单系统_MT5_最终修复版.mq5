#property copyright ">>>QQ群666666121<<<"
#property link      "http://wpa.qq.com/msgrd?v=3&uin=Goodlily&site=qq&menu=yes"
#property description "免责声明: 1.过去的收益不代表未来的收益 2.账号产生的盈亏客户需要自己承担..."
#property version   "4.8"
#property strict

//+------------------------------------------------------------------+
//| 枚举与输入参数                                                 |
//+------------------------------------------------------------------+
enum Option1 { Expert = 10, Moderate = 20, Safe = 30 };

string description = "300启动最少200";

// === 输入参数 ===
input string 注释 = "QQ666666121";
input string Configuration = "==== 设置 ====";
input int 魔术码 = 123;
input bool 自动手数开关 = false;
input Option1 自动手数模式 = Expert;
input double 固定手数 = 0.01;
input double 加仓系数 = 1.3; // 前一单手数 × 此系数

input string OrderSetting = "=== 订单设置 ===";
input double 止损点数 = 500.0;
input double 止盈点数 = 1500.0;
input int 挂单距离点数 = 150; // 挂单价与行情价的点数差（核心）

// 挂单更新速度控制参数
input int 挂单更新间隔毫秒 = 100; // 数值越大，挂单更新越慢
input int 距离止盈多少点启动移动止盈 = 300;
input int 每隔多少点修改止盈 = 50;

input string Config = "==== 时间过滤 ====";
input int 开始小时 = 1;
input int 开始分钟 = 0;
input int 结束小时 = 23;
input int 结束分钟 = 59;

input int 浮盈多少点启动移动止损 = 300;
input int 保留活动点数 = 50;
input int 每隔多少点改止损 = 5;

//+------------------------------------------------------------------+
//| 全局变量                                                         |
//+------------------------------------------------------------------+
double zong_1_do = 0.1;
double zong_2_do = 0.0;
double xt = 1.0;
int zong_20_in = 10;
datetime zong_21_in = 0;
datetime zong_22_in = 0;
double zong_26_do = 0.0;
int LotDigits = 0;

datetime lastUpdateTime = 0;

int g_buy_loss_count = 0;
double g_buy_last_lot = 0.0;
int g_sell_loss_count = 0;
double g_sell_last_lot = 0.0;

//+------------------------------------------------------------------+
//| 辅助函数：获取点值                                               |
//+------------------------------------------------------------------+
double GetPoint() { return SymbolInfoDouble(_Symbol, SYMBOL_POINT); }
int GetDigits() { return (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS); }

//+------------------------------------------------------------------+
//| 持仓成本价计算 (修复废弃API)                                      |
//+------------------------------------------------------------------+
double 持仓成本价(string symbol, ENUM_POSITION_TYPE type)
{
   double Cb = 0.0;
   double Zong_lot = 0.0;
   
   for(int pos_0 = 0; pos_0 < PositionsTotal(); pos_0++)
   {
      ulong pos_ticket = PositionGetTicket(pos_0);
      if(pos_ticket == 0 || !PositionSelectByTicket(pos_ticket)) continue;
      
      if(PositionGetString(POSITION_SYMBOL) == symbol &&
         (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == type &&
         (int)PositionGetInteger(POSITION_MAGIC) == 魔术码)
      {
         double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
         double volume = PositionGetDouble(POSITION_VOLUME);
         Cb += open_price * volume;
         Zong_lot += volume;
      }
   }
   
   if(Zong_lot > 0.0) Cb /= Zong_lot;
   return NormalizeDouble(Cb, GetDigits());
}

//+------------------------------------------------------------------+
//| 核心函数：移动止损 (彻底修复无效请求)                              |
//+------------------------------------------------------------------+
void moveStopMore()
{
   double _startmove = (double)浮盈多少点启动移动止损 * GetPoint();
   double _tickmove = (double)每隔多少点改止损 * GetPoint();
   double stoplevel = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * GetPoint();
   double _keepmove = MathMax((double)保留活动点数 * GetPoint(), stoplevel);
   
   double avg_buy = 持仓成本价(_Symbol, POSITION_TYPE_BUY);
   double avg_sell = 持仓成本价(_Symbol, POSITION_TYPE_SELL);
   double Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   int dig = GetDigits();

   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong pos_ticket = PositionGetTicket(i);
      if(pos_ticket == 0 || !PositionSelectByTicket(pos_ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != 魔术码) continue;

      double current_sl = PositionGetDouble(POSITION_SL);
      double current_tp = PositionGetDouble(POSITION_TP);
      ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

      // 多单移动止损
      if(pos_type == POSITION_TYPE_BUY)
      {
         if(Bid - _startmove > avg_buy)
         {
            double ns = Bid - _keepmove;
            if((ns - _tickmove >= current_sl) || current_sl == 0)
            {
               double new_sl = NormalizeDouble(ns, dig);
               if(new_sl > current_sl || current_sl == 0)
               {
                  MqlTradeRequest request = {};
                  MqlTradeResult result = {};
                  request.action = TRADE_ACTION_SLTP;
                  request.symbol = _Symbol;
                  request.position = pos_ticket;
                  request.sl = new_sl;
                  request.tp = current_tp;
                  
                  if(OrderSend(request, result))
                     Print("多单移动止损成功 | 订单号：", pos_ticket, " 新止损：", new_sl);
                  else
                     Print("多单移动止损失败 | 订单号：", pos_ticket, " 错误码：", result.retcode, " 说明：", result.comment);
               }
            }
         }
      }
      // 空单移动止损
      else if(pos_type == POSITION_TYPE_SELL)
      {
         if(Ask + _startmove < avg_sell)
         {
            double ns = Ask + _keepmove;
            if((ns + _tickmove <= current_sl) || current_sl == 0)
            {
               double new_sl = NormalizeDouble(ns, dig);
               if(new_sl < current_sl || current_sl == 0)
               {
                  MqlTradeRequest request = {};
                  MqlTradeResult result = {};
                  request.action = TRADE_ACTION_SLTP;
                  request.symbol = _Symbol;
                  request.position = pos_ticket;
                  request.sl = new_sl;
                  request.tp = current_tp;
                  
                  if(OrderSend(request, result))
                     Print("空单移动止损成功 | 订单号：", pos_ticket, " 新止损：", new_sl);
                  else
                     Print("空单移动止损失败 | 订单号：", pos_ticket, " 错误码：", result.retcode, " 说明：", result.comment);
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 核心函数：移动止盈 (修复版)                                       |
//+------------------------------------------------------------------+
void moveTakeProfit()
{
   double tp_start = (double)距离止盈多少点启动移动止盈 * GetPoint();
   double tp_step  = (double)每隔多少点修改止盈 * GetPoint();
   double slvl     = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * GetPoint();
   int dig         = GetDigits();
   
   double Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   for(int i=0; i<PositionsTotal(); i++)
   {
      ulong pos_ticket = PositionGetTicket(i);
      if(pos_ticket == 0 || !PositionSelectByTicket(pos_ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != 魔术码) continue;

      double otp = PositionGetDouble(POSITION_TP);
      if(otp == 0) continue;
      
      double current_sl = PositionGetDouble(POSITION_SL);
      ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

      if(pos_type == POSITION_TYPE_BUY)
      {
         if(otp - Bid > 0 && otp - Bid <= tp_start)
         {
            double ntp = NormalizeDouble(otp + tp_step, dig);
            if(ntp > PositionGetDouble(POSITION_PRICE_OPEN) + slvl)
            {
               MqlTradeRequest request = {};
               MqlTradeResult result = {};
               request.action = TRADE_ACTION_SLTP;
               request.symbol = _Symbol;
               request.position = pos_ticket;
               request.sl = current_sl;
               request.tp = ntp;
               
               if(OrderSend(request, result))
                  Print("多单移动止盈成功 | 订单号：", pos_ticket, " 新止盈：", ntp);
               else
                  Print("多单移动止盈失败 | 订单号：", pos_ticket, " 错误码：", result.retcode);
            }
         }
      }
      else if(pos_type == POSITION_TYPE_SELL)
      {
         if(Ask - otp > 0 && Ask - otp <= tp_start)
         {
            double ntp = NormalizeDouble(otp - tp_step, dig);
            if(ntp < PositionGetDouble(POSITION_PRICE_OPEN) - slvl)
            {
               MqlTradeRequest request = {};
               MqlTradeResult result = {};
               request.action = TRADE_ACTION_SLTP;
               request.symbol = _Symbol;
               request.position = pos_ticket;
               request.sl = current_sl;
               request.tp = ntp;
               
               if(OrderSend(request, result))
                  Print("空单移动止盈成功 | 订单号：", pos_ticket, " 新止盈：", ntp);
               else
                  Print("空单移动止盈失败 | 订单号：", pos_ticket, " 错误码：", result.retcode);
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 获取指定类型最后一单信息                                         |
//+------------------------------------------------------------------+
bool GetLastOrderInfoByType(ENUM_POSITION_TYPE type, double& lot, double& profit)
{
   lot = 0; profit = 0;
   datetime last_close_time = 0;
   
   datetime to = TimeCurrent();
   datetime from = to - 86400 * 30;

   if(!HistorySelect(from, to)) return false;

   for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
   {
      ulong deal_ticket = HistoryDealGetTicket(i);
      if(deal_ticket == 0) continue;
      
      if(HistoryDealGetString(deal_ticket, DEAL_SYMBOL) == _Symbol &&
         (int)HistoryDealGetInteger(deal_ticket, DEAL_MAGIC) == 魔术码)
      {
         ENUM_DEAL_ENTRY entry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(deal_ticket, DEAL_ENTRY);
         if(entry != DEAL_ENTRY_OUT) continue;
         
         datetime close_time = (datetime)HistoryDealGetInteger(deal_ticket, DEAL_TIME);
         if(close_time > last_close_time)
         {
            ENUM_DEAL_TYPE deal_type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(deal_ticket, DEAL_TYPE);
            bool is_match = (type == POSITION_TYPE_BUY && deal_type == DEAL_TYPE_BUY) ||
                           (type == POSITION_TYPE_SELL && deal_type == DEAL_TYPE_SELL);
            
            if(is_match)
            {
               last_close_time = close_time;
               lot = HistoryDealGetDouble(deal_ticket, DEAL_VOLUME);
               profit = HistoryDealGetDouble(deal_ticket, DEAL_PROFIT);
            }
         }
      }
   }
   
   if(last_close_time == 0)
   {
      for(int i = 0; i < PositionsTotal(); i++)
      {
         ulong pos_ticket = PositionGetTicket(i);
         if(pos_ticket == 0 || !PositionSelectByTicket(pos_ticket)) continue;
         
         if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
            (int)PositionGetInteger(POSITION_MAGIC) == 魔术码 &&
            (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == type)
         {
            lot = PositionGetDouble(POSITION_VOLUME);
            profit = 0;
            return true;
         }
      }
   }
   
   return (last_close_time > 0 || lot > 0);
}

//+------------------------------------------------------------------+
//| 更新加仓状态                                                     |
//+------------------------------------------------------------------+
void UpdateAddLotStatus(ENUM_POSITION_TYPE type)
{
   double last_lot = 0.0, last_profit = 0.0;
   
   if(!GetLastOrderInfoByType(type, last_lot, last_profit))
   {
      if(type == POSITION_TYPE_BUY) { g_buy_loss_count = 0; g_buy_last_lot = 固定手数; }
      if(type == POSITION_TYPE_SELL) { g_sell_loss_count = 0; g_sell_last_lot = 固定手数; }
      return;
   }
   
   if(type == POSITION_TYPE_BUY)
   {
      g_buy_last_lot = last_lot;
      g_buy_loss_count = last_profit < 0 ? g_buy_loss_count + 1 : 0;
   }
   else if(type == POSITION_TYPE_SELL)
   {
      g_sell_last_lot = last_lot;
      g_sell_loss_count = last_profit < 0 ? g_sell_loss_count + 1 : 0;
   }
}

//+------------------------------------------------------------------+
//| 手数计算函数 (兼容所有MT5版本)                                    |
//+------------------------------------------------------------------+
double CalculateLotByType(ENUM_POSITION_TYPE type)
{
   UpdateAddLotStatus(type);
   
   double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double step_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   
   double base_lot = 固定手数;
   if(自动手数开关)
   {
      base_lot = AccountInfoDouble(ACCOUNT_BALANCE) / zong_2_do * zong_1_do;
      base_lot = MathMax(base_lot, min_lot);
   }
   
   if(type == POSITION_TYPE_BUY)
      base_lot = g_buy_loss_count > 0 ? g_buy_last_lot * 加仓系数 : 固定手数;
   else if(type == POSITION_TYPE_SELL)
      base_lot = g_sell_loss_count > 0 ? g_sell_last_lot * 加仓系数 : 固定手数;
   
   base_lot = MathFloor(base_lot / step_lot) * step_lot;
   // 修复：用MathMax/MathMin替代MathClamp，兼容所有MT5版本
   if(base_lot < min_lot) base_lot = min_lot;
   if(base_lot > max_lot) base_lot = max_lot;
   
   return base_lot;
}

//+------------------------------------------------------------------+
//| 查找指定类型的挂单                                               |
//+------------------------------------------------------------------+
ulong FindPendingOrder(ENUM_ORDER_TYPE order_type)
{
   for(int i = 0; i < OrdersTotal(); i++)
   {
      ulong order_ticket = OrderGetTicket(i);
      if(order_ticket == 0 || !OrderSelect(order_ticket)) continue;
      
      if(OrderGetString(ORDER_SYMBOL) == _Symbol &&
         (int)OrderGetInteger(ORDER_MAGIC) == 魔术码 &&
         (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE) == order_type)
         return order_ticket;
   }
   return 0;
}

//+------------------------------------------------------------------+
//| 更新挂单价格                                                     |
//+------------------------------------------------------------------+
void UpdatePendingOrderPrice()
{
   if(GetTickCount() - lastUpdateTime < 挂单更新间隔毫秒) return;
   lastUpdateTime = GetTickCount();
   
   if(!InTimeRange()) return;
   
   int dig = GetDigits();
   double point = GetPoint();
   double step_p = (double)挂单距离点数 * point;
   double Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double stoplevel = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * point;

   ulong buy_stop_ticket = FindPendingOrder(ORDER_TYPE_BUY_STOP);
   if(buy_stop_ticket > 0)
   {
      if(!OrderSelect(buy_stop_ticket)) return;
      
      double new_buy_stop_price = NormalizeDouble(Ask + MathMax(step_p, stoplevel+10*point), dig);
      double current_price = OrderGetDouble(ORDER_PRICE_OPEN);
      
      if(MathAbs(new_buy_stop_price - current_price) >= 10*point)
      {
         double new_sl = NormalizeDouble(new_buy_stop_price - MathMax(止损点数*point, stoplevel+10*point), dig);
         double new_tp = NormalizeDouble(new_buy_stop_price + MathMax(止盈点数*point, stoplevel+10*point), dig);
         
         MqlTradeRequest request = {};
         MqlTradeResult result = {};
         request.action = TRADE_ACTION_MODIFY;
         request.symbol = _Symbol;
         request.order = buy_stop_ticket;
         request.price = new_buy_stop_price;
         request.sl = new_sl;
         request.tp = new_tp;
         request.type_time = ORDER_TIME_GTC;
         request.type_filling = ORDER_FILLING_FOK;
         
         if(OrderSend(request, result))
            Print("更新多单挂单价成功 | 订单号：", buy_stop_ticket);
         else
            Print("更新多单挂单价失败 | 订单号：", buy_stop_ticket, " 错误码：", result.retcode);
      }
   }

   ulong sell_stop_ticket = FindPendingOrder(ORDER_TYPE_SELL_STOP);
   if(sell_stop_ticket > 0)
   {
      if(!OrderSelect(sell_stop_ticket)) return;
      
      double new_sell_stop_price = NormalizeDouble(Bid - MathMax(step_p, stoplevel+10*point), dig);
      double current_price = OrderGetDouble(ORDER_PRICE_OPEN);
      
      if(MathAbs(current_price - new_sell_stop_price) >= 10*point)
      {
         double new_sl = NormalizeDouble(new_sell_stop_price + MathMax(止损点数*point, stoplevel+10*point), dig);
         double new_tp = NormalizeDouble(new_sell_stop_price - MathMax(止盈点数*point, stoplevel+10*point), dig);
         
         MqlTradeRequest request = {};
         MqlTradeResult result = {};
         request.action = TRADE_ACTION_MODIFY;
         request.symbol = _Symbol;
         request.order = sell_stop_ticket;
         request.price = new_sell_stop_price;
         request.sl = new_sl;
         request.tp = new_tp;
         request.type_time = ORDER_TIME_GTC;
         request.type_filling = ORDER_FILLING_FOK;
         
         if(OrderSend(request, result))
            Print("更新空单挂单价成功 | 订单号：", sell_stop_ticket);
         else
            Print("更新空单挂单价失败 | 订单号：", sell_stop_ticket, " 错误码：", result.retcode);
      }
   }
}

//+------------------------------------------------------------------+
//| 时间过滤函数                                                     |
//+------------------------------------------------------------------+
bool InTimeRange()
{
   datetime now = TimeLocal();
   MqlDateTime time_struct;
   TimeToStruct(now, time_struct);
   
   int h = time_struct.hour;
   int m = time_struct.min;
   
   return ((h > 开始小时) || (h == 开始小时 && m >= 开始分钟)) &&
          ((h < 结束小时) || (h == 结束小时 && m <= 结束分钟));
}

//+------------------------------------------------------------------+
//| 订单计数函数                                                     |
//+------------------------------------------------------------------+
int CountTrades(string s)
{
   int c = 0;
   
   if(s == "buy" || s == "sell")
   {
      for(int i = 0; i < PositionsTotal(); i++)
      {
         ulong pos_ticket = PositionGetTicket(i);
         if(pos_ticket == 0 || !PositionSelectByTicket(pos_ticket)) continue;
         
         if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
            (int)PositionGetInteger(POSITION_MAGIC) == 魔术码)
         {
            ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            if((s == "buy" && pos_type == POSITION_TYPE_BUY) || (s == "sell" && pos_type == POSITION_TYPE_SELL)) c++;
         }
      }
   }
   
   if(s == "buystop" || s == "sellstop")
   {
      for(int i = 0; i < OrdersTotal(); i++)
      {
         ulong order_ticket = OrderGetTicket(i);
         if(order_ticket == 0 || !OrderSelect(order_ticket)) continue;
         
         if(OrderGetString(ORDER_SYMBOL) == _Symbol &&
            (int)OrderGetInteger(ORDER_MAGIC) == 魔术码)
         {
            ENUM_ORDER_TYPE order_type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
            if((s == "buystop" && order_type == ORDER_TYPE_BUY_STOP) || (s == "sellstop" && order_type == ORDER_TYPE_SELL_STOP)) c++;
         }
      }
   }
   return c;
}

//+------------------------------------------------------------------+
//| 初始化函数                                                       |
//+------------------------------------------------------------------+
int OnInit()
{
   zong_2_do = (double)自动手数模式 * 100.0;
   int d = GetDigits();
   xt = (d == 3 || d == 5) ? 10.0 : 1.0;
   
   zong_26_do = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   
   g_buy_loss_count = 0; g_buy_last_lot = 固定手数;
   g_sell_loss_count = 0; g_sell_last_lot = 固定手数;
   
   lastUpdateTime = GetTickCount();
   
   Print("EA 初始化成功");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| 主逻辑函数                                                       |
//+------------------------------------------------------------------+
void OnTick()
{
   datetime expire = D'2063.02.28';
   if(TimeCurrent() > expire)
   {
      Alert("账号到期请联系QQ：666666121");
      ExpertRemove();
      return;
   }

   moveStopMore();
   moveTakeProfit();
   UpdatePendingOrderPrice();
   
   int buy_pos_cnt = CountTrades("buy");
   int buy_stop_cnt = CountTrades("buystop");
   int sell_pos_cnt = CountTrades("sell");
   int sell_stop_cnt = CountTrades("sellstop");
   
   int dig = GetDigits();
   double point = GetPoint();
   double step_p = (double)挂单距离点数 * point;
   double Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double stoplevel = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * point;

   if(buy_pos_cnt == 0 && buy_stop_cnt == 0 && InTimeRange())
   {
      double lots = CalculateLotByType(POSITION_TYPE_BUY);
      double buy_stop_price = NormalizeDouble(Ask + MathMax(step_p, stoplevel+10*point), dig);
      double sl = NormalizeDouble(buy_stop_price - MathMax(止损点数*point, stoplevel+10*point), dig);
      double tp = NormalizeDouble(buy_stop_price + MathMax(止盈点数*point, stoplevel+10*point), dig);
      
      MqlTradeRequest request = {};
      MqlTradeResult result = {};
      request.action = TRADE_ACTION_PENDING;
      request.symbol = _Symbol;
      request.volume = lots;
      request.type = ORDER_TYPE_BUY_STOP;
      request.price = buy_stop_price;
      request.sl = sl;
      request.tp = tp;
      request.deviation = 10;
      request.magic = 魔术码;
      request.comment = 注释;
      request.type_filling = ORDER_FILLING_FOK;
      request.type_time = ORDER_TIME_GTC;
      
      if(OrderSend(request, result))
      {
         zong_21_in = TimeCurrent();
         Print("新建多单挂单成功 | 手数：", lots);
      }
      else
         Print("新建多单挂单失败 | 错误码：", result.retcode);
   }

   if(sell_pos_cnt == 0 && sell_stop_cnt == 0 && InTimeRange())
   {
      double lots = CalculateLotByType(POSITION_TYPE_SELL);
      double sell_stop_price = NormalizeDouble(Bid - MathMax(step_p, stoplevel+10*point), dig);
      double sl = NormalizeDouble(sell_stop_price + MathMax(止损点数*point, stoplevel+10*point), dig);
      double tp = NormalizeDouble(sell_stop_price - MathMax(止盈点数*point, stoplevel+10*point), dig);
      
      MqlTradeRequest request = {};
      MqlTradeResult result = {};
      request.action = TRADE_ACTION_PENDING;
      request.symbol = _Symbol;
      request.volume = lots;
      request.type = ORDER_TYPE_SELL_STOP;
      request.price = sell_stop_price;
      request.sl = sl;
      request.tp = tp;
      request.deviation = 10;
      request.magic = 魔术码;
      request.comment = 注释;
      request.type_filling = ORDER_FILLING_FOK;
      request.type_time = ORDER_TIME_GTC;
      
      if(OrderSend(request, result))
      {
         zong_22_in = TimeCurrent();
         Print("新建空单挂单成功 | 手数：", lots);
      }
      else
         Print("新建空单挂单失败 | 错误码：", result.retcode);
   }
}
//+------------------------------------------------------------------+