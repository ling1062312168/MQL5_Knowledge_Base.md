#property version   "3.10"
#property strict

/*
  Quantum King 3.1 — AUDCAD M5 网格对冲策略
*/

#include <Trade/Trade.mqh>

input string Nome_Preset =
   ">>> Quantum King 是针对 AUDCAD M5 优化的策略"; // 策略说明
input ulong  Inp_Magic                 = 74638; // 交易识别码（Magic）
input int    Inp_Spread_Max            = 30; // 最大点差（点）
input int    Inp_Slippage_Max          = 100; // 最大滑点（点）
input int    Inp_Tamanho_Painel        = 15; // 面板字号
input string Inp_Comentario_Ordens     = "Quantum King"; // 订单备注
input string lineMoneySkip             = ""; // ──────────
input string lineMoney                 = ">>> 资金管理"; // 资金管理
input bool   Risco_Automatico          = true; // 自动风险管理
input int    Risco_Preset              = 2; // 风险预设
input double Inp_Lote_Inicial_Manual   = 0.01; // 手动初始手数
input string lineStopSkip              = ""; // ──────────
input string lineStop                  = ">>> 总止损设置"; // 总止损设置
input double Inp_Prejuizo_Saldo_Atual  = 0.0; // 当前余额亏损阈值
input int    Inp_Prejuizo_Porcentagem_Atual = 0; // 当前亏损百分比
input int    Inp_Aguardar_Prejuizo_Atual = 0; // 亏损后等待时间
input bool   Parar_Prejuizo_Atual      = false; // 触发亏损后停止
input string lineGridSkip              = ""; // ──────────
input string lineGrid                  = ">>> 网格设置"; // 网格设置
input int    Inp_TakeProfit            = 100; // 止盈点数
input int    Inp_BreakEven             = 0; // 保本触发点数
input int    Inp_BreakEven_Stop        = 0; // 保本止损点数
input string lineCurrencySkip          = ""; // ──────────
input string lineCurrency              = ">>> 账户货币非 USD 时调整汇率"; // 货币调整
input int    Inp_Modo_Ajustar_Moeda    = 0; // 货币调整模式
input string Lista_Ajustar_Moeda       =
   "XXX=1.00,EUR=0.88,GBP=0.77,AUD=1.54,NZD=1.66,JPY=150.00,CHF=0.86,CAD=1.37,SGD=1.33,RUB=85.00,CNH=7.20,BRL=5.50"; // 货币汇率列表
input string linePermittedSkip         = ""; // ──────────
input string linePermitted             = ">>> 允许交易日"; // 允许交易日
input bool   Operar_Domingo            = true; // 星期日交易
input bool   Operar_Segunda            = true; // 星期一交易
input bool   Operar_Terca              = true; // 星期二交易
input bool   Operar_Quarta             = true; // 星期三交易
input bool   Operar_Quinta             = true; // 星期四交易
input bool   Operar_Sexta              = true; // 星期五交易
input bool   Operar_Sabado             = true; // 星期六交易
input bool   Disable_NFP_Friday        = true; // 非农周五停止交易
input bool   Disable_Holidays          = false; // 节假日停止交易

// 预设常量（针对 AUDCAD M5 优化）
static const int    QK_ENV_PERIOD          = 14;   // Envelopes 周期
static const double QK_ENV_DEVIATION       = 0.2;  // Envelopes 偏离
static const int    QK_BASE_GRID_POINTS    = 200;  // 基础网格点数
static const double QK_GRID_MULTIPLIER     = 1.2;  // 网格倍数
static const int    QK_MIN_GRID_POINTS     = 10;   // 最小网格点数
static const int    QK_OPEN_COOLDOWN_MINUTES = 30;// 开仓冷却（分钟）
static const int    QK_RECOVERY_POINTS     = 100;  // 恢复点数
static const double QK_RECOVERY_DRAWDOWN   = 100.0;// 恢复回撤阈值
static const double QK_MIN_CONFIG_LOT      = 0.01; // 配置最小手数
static const double QK_MAX_CONFIG_LOT      = 0.10; // 配置最大手数

CTrade   g_trade;
int      g_envelopes = INVALID_HANDLE;
datetime g_last_bar  = 0;
double   g_initial_lot = 0.01;
bool     g_stopped_by_equity = false;
bool     g_recovery_buy = false;
bool     g_recovery_sell = false;
double   g_account_balance = 0.0;
double   g_account_equity = 0.0;
double   g_account_margin_free = 0.0;
double   g_account_commission_blocked = 0.0;
int      g_history_deal_count = 0;
int      g_history_entry_count = 0;
int      g_history_exit_count = 0;
int      g_history_win_count = 0;
ulong    g_history_latest_ticket = 0;
datetime g_history_latest_time = 0;
double   g_history_net_result = 0.0;
double   g_history_volume = 0.0;
double   g_history_latest_price = 0.0;
string   g_configured_symbols[];
string   g_conversion_symbols[];
bool     g_conversion_direct[];
double   g_runtime_tick_value[];
double   g_runtime_tick_size[];
double   g_runtime_volume_limit[];
double   g_runtime_volume_limit_state[];
double   g_runtime_point[];
double   g_runtime_volume_step[];
double   g_runtime_volume_min[];
double   g_runtime_volume_max[];
double   g_runtime_volume_state[];
double   g_runtime_ask[];
double   g_runtime_bid[];
double   g_runtime_m1_close[];
double   g_runtime_margin_buy[];
double   g_runtime_margin_sell[];
bool     g_runtime_margin_buy_ready[];
bool     g_runtime_margin_sell_ready[];
double   g_single_target_buy = 0.0;
double   g_single_target_sell = 0.0;
ulong    g_single_ticket_buy = 0;
ulong    g_single_ticket_sell = 0;
double   g_pair_target_buy = 0.0;
double   g_pair_target_sell = 0.0;
ulong    g_pair_oldest_buy = 0;
ulong    g_pair_newest_buy = 0;
ulong    g_pair_oldest_sell = 0;
ulong    g_pair_newest_sell = 0;
double   g_reduced_next_lot_buy = 0.0;
double   g_reduced_next_lot_sell = 0.0;
datetime g_reduced_lot_time_buy = 0;
datetime g_reduced_lot_time_sell = 0;
datetime g_fresh_buy_resume_bar = 0;
datetime g_fresh_sell_resume_bar = 0;
datetime g_last_buy_open_time = 0;
datetime g_last_sell_open_time = 0;
datetime g_last_buy_close_time = 0;
datetime g_last_sell_close_time = 0;

struct QKSideState
{
   int count;
   double volume;
   double weighted_open;
   double floating_profit;
   double recovery_metric;
   double last_open;
   double last_volume;
   ulong oldest_ticket;
   ulong newest_ticket;
   double oldest_open;
   double newest_open;
   double oldest_volume;
   double newest_volume;
   long newest_time_msc;
};

double QKClamp(const double value,const double low,const double high)
{
   return MathMax(low,MathMin(high,value));
}

double QKNormalizePriceNative(const double value)
{
   // 价格归一化：放大到整数位、加 0.5000001 取整后还原（价格恒正）
   const double scale=MathPow(10.0,(double)_Digits);
   if(scale<=0.0)
      return value;
   return MathFloor(value*scale+0.5000001)/scale;
}

double QKNormalizeVolume(const double requested)
{
   const double broker_min = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   const double broker_max = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   const double step       = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   const double low        = MathMax(broker_min,QK_MIN_CONFIG_LOT);
   const double high       = MathMin(broker_max,QK_MAX_CONFIG_LOT);
   if(step<=0.0)
      return QKClamp(requested,low,high);
   const double units = MathFloor((requested-low)/step+0.5);
   return NormalizeDouble(QKClamp(low+units*step,low,high),8);
}

double QKCurrencyFactor()
{
   if(Inp_Modo_Ajustar_Moeda==0)
      return 1.0;

   string currency=AccountInfoString(ACCOUNT_CURRENCY);
   string entries[];
   const int n=StringSplit(Lista_Ajustar_Moeda,',',entries);
   for(int i=0;i<n;i++)
   {
      string pair[];
      if(StringSplit(entries[i],'=',pair)==2 && pair[0]==currency)
         return StringToDouble(pair[1]);
   }
   return 1.0;
}

double QKInitialLot()
{
   if(!Risco_Automatico)
      return QKNormalizeVolume(Inp_Lote_Inicial_Manual);

   // 自动风险：基础 0.01 手，余额每满 10000 上浮 0.01
   const double balance=AccountInfoDouble(ACCOUNT_BALANCE);
   double lot=0.01;
   if(Risco_Preset>2 && balance>0.0)
      lot=0.01*MathMax(1.0,MathFloor(balance/10000.0));
   return QKNormalizeVolume(lot);
}

bool QKDayAllowed()
{
   MqlDateTime now;
   TimeToStruct(TimeCurrent(),now);
   bool allowed=false;
   switch(now.day_of_week)
   {
      case 0: allowed=Operar_Domingo; break;
      case 1: allowed=Operar_Segunda; break;
      case 2: allowed=Operar_Terca; break;
      case 3: allowed=Operar_Quarta; break;
      case 4: allowed=Operar_Quinta; break;
      case 5: allowed=Operar_Sexta; break;
      case 6: allowed=Operar_Sabado; break;
   }
   // "Disable NFP Friday" is the first Friday of the month.
   if(allowed && Disable_NFP_Friday && now.day_of_week==5 && now.day<=7)
      allowed=false;
   return allowed;
}

int QKConfiguredSymbolIndex(const string symbol)
{
   const int count=ArraySize(g_configured_symbols);
   for(int i=0;i<count;i++)
      if(g_configured_symbols[i]==symbol)
         return i;
   return -1;
}

bool QKFindNativeOpeningDeal(const long position_id,
                             double &deal_volume,
                             double &deal_price,
                             double &deal_commission)
{
   deal_volume=0.0;
   deal_price=0.0;
   deal_commission=0.0;
   const int total=HistoryDealsTotal();
   for(int i=0;i<total;i++)
   {
      const ulong deal_ticket=HistoryDealGetTicket(i);
      if(deal_ticket==0)
         continue;
      if((long)HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID)!=position_id)
         continue;
      const ENUM_DEAL_ENTRY entry=
         (ENUM_DEAL_ENTRY)HistoryDealGetInteger(deal_ticket,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_IN && entry!=DEAL_ENTRY_INOUT)
         continue;
      const double volume=HistoryDealGetDouble(deal_ticket,DEAL_VOLUME);
      if(volume<=0.0)
         continue;
      deal_volume=volume;
      deal_price=HistoryDealGetDouble(deal_ticket,DEAL_PRICE);
      deal_commission=HistoryDealGetDouble(deal_ticket,DEAL_COMMISSION);
      return deal_price>0.0;
   }
   return false;
}

bool QKNativeAccountContribution(const ENUM_POSITION_TYPE side,
                                 const string symbol,
                                 const double position_volume,
                                 const double position_swap,
                                 const long position_id,
                                 double &contribution)
{
   contribution=0.0;
   const int symbol_index=QKConfiguredSymbolIndex(symbol);
   if(symbol_index<0)
      return false;
   double opening_volume=0.0;
   double opening_price=0.0;
   double opening_commission=0.0;
   if(!QKFindNativeOpeningDeal(position_id,
                               opening_volume,
                               opening_price,
                               opening_commission))
      return false;
   const double remaining_volume=
      MathMin(opening_volume,MathMax(0.0,position_volume));
   if(remaining_volume<=0.0)
      return false;
   const double remaining_fraction=
      QKClamp(remaining_volume/opening_volume,0.0,1.0);
   const double contract_size=
      SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE);
   if(contract_size<=0.0)
      return false;
   MqlTick tick;
   if(!SymbolInfoTick(symbol,tick))
      return false;
   const double current_price=
      (side==POSITION_TYPE_BUY ? tick.bid : tick.ask);
   if(current_price<=0.0)
      return false;
   const double price_delta=
      (side==POSITION_TYPE_BUY
       ? current_price-opening_price
       : opening_price-current_price);
   double account_price_component=
      price_delta*remaining_volume*contract_size;
   if(symbol_index<ArraySize(g_conversion_symbols))
   {
      const string conversion_symbol=g_conversion_symbols[symbol_index];
      if(conversion_symbol!="")
      {
         if(!SymbolSelect(conversion_symbol,true))
            return false;
         const ENUM_SYMBOL_INFO_DOUBLE quote_property=
            (side==POSITION_TYPE_BUY ? SYMBOL_BID : SYMBOL_ASK);
         const double conversion_quote=
            SymbolInfoDouble(conversion_symbol,quote_property);
         if(conversion_quote<=0.0)
            return false;
         account_price_component=
            (g_conversion_direct[symbol_index]
             ? account_price_component/conversion_quote
             : account_price_component*conversion_quote);
      }
   }
   const double commission_component=
      2.0*opening_commission*remaining_fraction;
   const double native_value=
      account_price_component+position_swap+commission_component;
   if(!MathIsValidNumber(native_value))
      return false;
   contribution=native_value;
   return true;
}

bool QKReadSide(const ENUM_POSITION_TYPE side,QKSideState &state)
{
   state.count=0;
   state.volume=0.0;
   state.weighted_open=0.0;
   state.floating_profit=0.0;
   state.recovery_metric=0.0;
   state.last_open=0.0;
   state.last_volume=0.0;
   state.oldest_ticket=0;
   state.newest_ticket=0;
   state.oldest_open=0.0;
   state.newest_open=0.0;
   state.oldest_volume=0.0;
   state.newest_volume=0.0;
   state.newest_time_msc=0;

   double weighted_sum=0.0;
   double native_side_sum=0.0;
   long oldest_time=LONG_MAX;
   long newest_time=LONG_MIN;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      const ulong ticket=PositionGetTicket(i);
      if(ticket==0 || !PositionSelectByTicket(ticket))
         continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol)
         continue;
      if((ulong)PositionGetInteger(POSITION_MAGIC)!=Inp_Magic)
         continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)!=side)
         continue;

      const double volume=PositionGetDouble(POSITION_VOLUME);
      const double price=PositionGetDouble(POSITION_PRICE_OPEN);
      const long position_time=(long)PositionGetInteger(POSITION_TIME_MSC);
      state.count++;
      state.volume+=volume;
      weighted_sum+=price*volume;
      const double position_profit=PositionGetDouble(POSITION_PROFIT);
      const double position_swap=PositionGetDouble(POSITION_SWAP);
      state.floating_profit+=position_profit+position_swap;

      const long position_id=
         (long)PositionGetInteger(POSITION_IDENTIFIER);
      double native_contribution=0.0;
      if(!QKNativeAccountContribution(side,
                                      PositionGetString(POSITION_SYMBOL),
                                      volume,
                                      position_swap,
                                      position_id,
                                      native_contribution))
         return false;
      native_side_sum+=native_contribution;
      if(position_time<oldest_time)
      {
         oldest_time=position_time;
         state.oldest_ticket=ticket;
         state.oldest_open=price;
         state.oldest_volume=volume;
      }
      if(position_time>newest_time)
      {
         newest_time=position_time;
         state.newest_ticket=ticket;
         state.newest_open=price;
         state.newest_volume=volume;
         state.newest_time_msc=position_time;
      }
      if(state.last_open==0.0 ||
         (side==POSITION_TYPE_BUY && price<state.last_open) ||
         (side==POSITION_TYPE_SELL && price>state.last_open))
      {
         state.last_open=price;
         state.last_volume=volume;
      }
   }
   const datetime newest_open_time=(datetime)(state.newest_time_msc/1000);
   if(side==POSITION_TYPE_BUY && newest_open_time>g_last_buy_open_time)
      g_last_buy_open_time=newest_open_time;
   if(side==POSITION_TYPE_SELL && newest_open_time>g_last_sell_open_time)
      g_last_sell_open_time=newest_open_time;
   if(state.volume>0.0)
      state.weighted_open=weighted_sum/state.volume;
   state.recovery_metric=NormalizeDouble(native_side_sum,2);
   return true;
}

double QKNextLot(const QKSideState &state,
                 const ENUM_POSITION_TYPE side)
{
   if(state.count<=0)
      return g_initial_lot;

   // 上一笔开仓后 10 小时内保持极端仓手数；过期则在极端手数上加初始手
   const datetime latest_open=
      (side==POSITION_TYPE_BUY
       ? g_last_buy_open_time
       : g_last_sell_open_time);
   const long remaining_minutes=
      (latest_open<=0
       ? 0
       : (long)((latest_open+600*60-TimeCurrent())/60));
   if(remaining_minutes>0)
      return QKNormalizeVolume(state.last_volume);
   return QKNormalizeVolume(state.last_volume+g_initial_lot);
}

double QKGridPoints(const QKSideState &state)
{
   if(state.count<=0)
      return QK_BASE_GRID_POINTS;
   const double multiplier=MathPow(QK_GRID_MULTIPLIER,
                                   (double)MathMax(0,state.count-1));
   return MathMax((double)QK_MIN_GRID_POINTS,
                  (double)QK_BASE_GRID_POINTS*multiplier);
}

bool QKOpenCooldownElapsed(const ENUM_POSITION_TYPE side)
{
   // 同向最近一次开/平仓后 30 分钟冷却，且与对向最近开/平仓时间取最大值
   const bool buy_side=(side==POSITION_TYPE_BUY);
   datetime expiry=0;
   if(buy_side)
   {
      expiry=MathMax(g_last_buy_open_time+QK_OPEN_COOLDOWN_MINUTES*60,
                     g_last_buy_close_time+QK_OPEN_COOLDOWN_MINUTES*60);
      expiry=MathMax(expiry,g_last_sell_open_time);
      expiry=MathMax(expiry,g_last_sell_close_time);
   }
   else
   {
      expiry=MathMax(g_last_sell_open_time+QK_OPEN_COOLDOWN_MINUTES*60,
                     g_last_sell_close_time+QK_OPEN_COOLDOWN_MINUTES*60);
      expiry=MathMax(expiry,g_last_buy_open_time);
      expiry=MathMax(expiry,g_last_buy_close_time);
   }
   const long remaining_minutes=
      (long)((expiry-TimeCurrent())/60);
   return remaining_minutes<=0;
}

double QKReducedBasketNextLot(const QKSideState &state,
                              const ENUM_POSITION_TYPE side,
                              const double oldest_close_volume)
{
   int remaining_count=state.count-1; // newest is removed in full
   const double volume_step=
      SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   if(state.oldest_volume<=oldest_close_volume+volume_step*0.5)
      remaining_count--;

   double remaining_max=0.0;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      const ulong ticket=PositionGetTicket(i);
      if(ticket==0 || ticket==state.newest_ticket ||
         !PositionSelectByTicket(ticket))
         continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol ||
         (ulong)PositionGetInteger(POSITION_MAGIC)!=Inp_Magic ||
         (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)!=side)
         continue;

      double volume=PositionGetDouble(POSITION_VOLUME);
      if(ticket==state.oldest_ticket)
         volume=MathMax(0.0,volume-oldest_close_volume);
      remaining_max=MathMax(remaining_max,volume);
   }

   /*
     The post-reduction bound is the greater of the surviving maximum lot
     and the remaining basket level, with a two-lot floor.
   */
   const double basket_floor=
      g_initial_lot*(double)MathMax(2,remaining_count);
   return QKNormalizeVolume(MathMax(remaining_max,basket_floor));
}

bool QKSpreadAllowed()
{
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick) || _Point<=0.0)
      return false;
   const int spread=(int)MathRound((tick.ask-tick.bid)/_Point);
   return spread<=Inp_Spread_Max;
}

ENUM_ORDER_TYPE_FILLING QKFilling()
{
   const long mode=SymbolInfoInteger(_Symbol,SYMBOL_FILLING_MODE);
   if((mode&SYMBOL_FILLING_FOK)==SYMBOL_FILLING_FOK)
      return ORDER_FILLING_FOK;
   if((mode&SYMBOL_FILLING_IOC)==SYMBOL_FILLING_IOC)
      return ORDER_FILLING_IOC;
   return ORDER_FILLING_RETURN;
}

bool QKOpen(const ENUM_ORDER_TYPE type,const double volume)
{
   if(!QKSpreadAllowed())
      return false;
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return false;

   MqlTradeRequest request={};
   MqlTradeResult result={};
   request.action=TRADE_ACTION_DEAL;
   request.magic=Inp_Magic;
   request.symbol=_Symbol;
   request.volume=QKNormalizeVolume(volume);
   request.type=type;
   request.price=(type==ORDER_TYPE_BUY ? tick.ask : tick.bid);
   request.deviation=(ulong)MathMax(0,Inp_Slippage_Max);
   request.type_filling=QKFilling();
   request.comment=Inp_Comentario_Ordens;
   if(!OrderSend(request,result))
      return false;
   const bool opened=
      result.retcode==TRADE_RETCODE_DONE ||
      result.retcode==TRADE_RETCODE_DONE_PARTIAL ||
      result.retcode==TRADE_RETCODE_PLACED;
   if(opened)
   {
      if(type==ORDER_TYPE_BUY)
         g_last_buy_open_time=TimeCurrent();
      else
         g_last_sell_open_time=TimeCurrent();
   }
   return opened;
}

bool QKCloseTicketVolume(const ulong ticket,const double requested_volume)
{
   if(!PositionSelectByTicket(ticket))
      return false;
   const string symbol=PositionGetString(POSITION_SYMBOL);
   const double position_volume=PositionGetDouble(POSITION_VOLUME);
   const double volume=QKNormalizeVolume(
      MathMin(position_volume,requested_volume));
   const ENUM_POSITION_TYPE ptype=
      (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   MqlTick tick;
   if(!SymbolInfoTick(symbol,tick))
      return false;

   MqlTradeRequest request={};
   MqlTradeResult result={};
   request.action=TRADE_ACTION_DEAL;
   request.position=ticket;
   request.magic=Inp_Magic;
   request.symbol=symbol;
   request.volume=volume;
   request.type=(ptype==POSITION_TYPE_BUY ? ORDER_TYPE_SELL : ORDER_TYPE_BUY);
   request.price=(ptype==POSITION_TYPE_BUY ? tick.bid : tick.ask);
   request.deviation=(ulong)MathMax(0,Inp_Slippage_Max);
   request.type_filling=QKFilling();
   request.comment="";
   if(!OrderSend(request,result))
      return false;
   const bool closed=
      result.retcode==TRADE_RETCODE_DONE ||
      result.retcode==TRADE_RETCODE_DONE_PARTIAL;
   if(closed)
   {
      if(ptype==POSITION_TYPE_BUY)
         g_last_buy_close_time=TimeCurrent();
      else
         g_last_sell_close_time=TimeCurrent();
   }
   return closed;
}

bool QKCloseTicket(const ulong ticket)
{
   if(!PositionSelectByTicket(ticket))
      return false;
   return QKCloseTicketVolume(ticket,PositionGetDouble(POSITION_VOLUME));
}

void QKCloseSide(const ENUM_POSITION_TYPE side)
{
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      const ulong ticket=PositionGetTicket(i);
      if(ticket==0 || !PositionSelectByTicket(ticket))
         continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol ||
         (ulong)PositionGetInteger(POSITION_MAGIC)!=Inp_Magic ||
         (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)!=side)
         continue;
      QKCloseTicket(ticket);
   }
}

bool QKSignal(const bool sell)
{
   // 信号：取上一根已收盘 H1 K 线的 Envelopes 上下轨
   if(g_envelopes==INVALID_HANDLE)
      return false;
   double upper[1],lower[1];
   if(CopyBuffer(g_envelopes,0,1,1,upper)!=1 ||
      CopyBuffer(g_envelopes,1,1,1,lower)!=1)
      return false;
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return false;
   // 卖信号：Bid 升破上轨；买信号：Ask 跌破下轨
   return sell ? (tick.bid>upper[0]) : (tick.ask<lower[0]);
}

void QKApplyBreakEven()
{
   if(Inp_BreakEven<=0)
      return;
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      const ulong ticket=PositionGetTicket(i);
      if(ticket==0 || !PositionSelectByTicket(ticket))
         continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol ||
         (ulong)PositionGetInteger(POSITION_MAGIC)!=Inp_Magic)
         continue;
      const ENUM_POSITION_TYPE side=
         (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      const double open=PositionGetDouble(POSITION_PRICE_OPEN);
      const double old_sl=PositionGetDouble(POSITION_SL);
      const double tp=PositionGetDouble(POSITION_TP);
      const double gain=(side==POSITION_TYPE_BUY ? tick.bid-open : open-tick.ask)/_Point;
      if(gain<Inp_BreakEven)
         continue;
      const double sl=NormalizeDouble(
         side==POSITION_TYPE_BUY
            ? open+Inp_BreakEven_Stop*_Point
            : open-Inp_BreakEven_Stop*_Point,_Digits);
      if((side==POSITION_TYPE_BUY && (old_sl==0.0 || sl>old_sl)) ||
         (side==POSITION_TYPE_SELL && (old_sl==0.0 || sl<old_sl)))
         g_trade.PositionModify(ticket,sl,tp);
   }
}

bool QKEquityStop()
{
   if(g_stopped_by_equity)
      return true;
   const double balance=g_account_balance;
   const double equity=g_account_equity;
   double limit=Inp_Prejuizo_Saldo_Atual;
   if(Inp_Prejuizo_Porcentagem_Atual>0)
      limit=MathMax(limit,balance*Inp_Prejuizo_Porcentagem_Atual/100.0);
   if(limit<=0.0 || balance-equity<limit)
      return false;

   QKCloseSide(POSITION_TYPE_BUY);
   QKCloseSide(POSITION_TYPE_SELL);
   g_stopped_by_equity=Parar_Prejuizo_Atual;
   return g_stopped_by_equity;
}

void QKManageTakeProfit(const QKSideState &buy,const QKSideState &sell)
{
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return;

   /*
     单仓止盈目标（与配对目标同样的回撤修正）：
       BUY  candidate = open + distance - loss_ratio*distance，取历史最小
       SELL candidate = open - distance + loss_ratio*distance，取历史最大
   */
   const double single_distance=Inp_TakeProfit*_Point;
   if(buy.count==1)
   {
      if(g_single_ticket_buy!=buy.oldest_ticket)
      {
         g_single_ticket_buy=buy.oldest_ticket;
         g_single_target_buy=
            QKNormalizePriceNative(buy.last_open+single_distance);
      }
      const double loss_ratio=
         QKClamp(-buy.recovery_metric/QK_RECOVERY_DRAWDOWN,0.0,1.0);
      const double candidate=
         buy.last_open+single_distance-loss_ratio*single_distance;
      g_single_target_buy=
         QKNormalizePriceNative(MathMin(g_single_target_buy,candidate));
      if(tick.bid>=g_single_target_buy)
         QKCloseSide(POSITION_TYPE_BUY);
   }
   else
   {
      g_single_target_buy=0.0;
      g_single_ticket_buy=0;
   }

   if(sell.count==1)
   {
      if(g_single_ticket_sell!=sell.oldest_ticket)
      {
         g_single_ticket_sell=sell.oldest_ticket;
         g_single_target_sell=
            QKNormalizePriceNative(sell.last_open-single_distance);
      }
      const double loss_ratio=
         QKClamp(-sell.recovery_metric/QK_RECOVERY_DRAWDOWN,0.0,1.0);
      const double candidate=
         sell.last_open-single_distance+loss_ratio*single_distance;
      g_single_target_sell=
         QKNormalizePriceNative(MathMax(g_single_target_sell,candidate));
      if(tick.ask<=g_single_target_sell)
         QKCloseSide(POSITION_TYPE_SELL);
   }
   else
   {
      g_single_target_sell=0.0;
      g_single_ticket_sell=0;
   }

   /*
     配对止盈目标：
       pair_price = volume-weighted(oldest,newest)
       distance   = TakeProfit * _Point
       loss_ratio = clamp(-side_profit / 100, 0, 1)
       BUY  candidate = pair_price + distance - loss_ratio*distance（取历史最小）
       SELL candidate = pair_price - distance + loss_ratio*distance（取历史最大）
     达到目标后平掉最新仓 + 部分平掉最老仓（按初始手数）
   */
   if(buy.count<2 || buy.oldest_ticket==buy.newest_ticket)
   {
      g_pair_target_buy=0.0;
      g_pair_oldest_buy=0;
      g_pair_newest_buy=0;
      if(buy.count==0)
      {
         g_reduced_next_lot_buy=0.0;
         g_reduced_lot_time_buy=0;
      }
   }
   else
   {
      if(g_pair_oldest_buy!=buy.oldest_ticket ||
         g_pair_newest_buy!=buy.newest_ticket)
      {
         g_pair_target_buy=0.0;
         g_pair_oldest_buy=buy.oldest_ticket;
         g_pair_newest_buy=buy.newest_ticket;
      }
      const double oldest_close_volume=
         MathMin(buy.oldest_volume,g_initial_lot);
      const double pair_volume=oldest_close_volume+buy.newest_volume;
      const double pair_price=
         (buy.oldest_open*oldest_close_volume+
          buy.newest_open*buy.newest_volume)/pair_volume;
      const double distance=Inp_TakeProfit*_Point;
      const double loss_ratio=
         QKClamp(-buy.recovery_metric/QK_RECOVERY_DRAWDOWN,0.0,1.0);
      const double candidate=
         QKNormalizePriceNative(
            pair_price+distance-loss_ratio*distance);
      if(g_pair_target_buy==0.0 || candidate<g_pair_target_buy)
         g_pair_target_buy=candidate;
      if(tick.bid>=g_pair_target_buy)
      {
         g_reduced_next_lot_buy=QKReducedBasketNextLot(
            buy,POSITION_TYPE_BUY,oldest_close_volume);
         g_reduced_lot_time_buy=TimeCurrent();
         if(sell.count==0)
         {
            const datetime current_bar=iTime(_Symbol,PERIOD_CURRENT,0);
            const double volume_step=
               SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
            int buy_remaining_count=buy.count-1;
            if(buy.oldest_volume<=
               oldest_close_volume+volume_step*0.5)
               buy_remaining_count--;
            const bool buy_basket_remains=
               buy_remaining_count>=2;
            g_fresh_sell_resume_bar=
               current_bar+
               (buy_basket_remains ? 2 : 1)*
               PeriodSeconds(PERIOD_CURRENT);
         }
         QKCloseTicket(buy.newest_ticket);
         QKCloseTicketVolume(buy.oldest_ticket,oldest_close_volume);
         g_pair_target_buy=0.0;
      }
   }

   if(sell.count<2 || sell.oldest_ticket==sell.newest_ticket)
   {
      g_pair_target_sell=0.0;
      g_pair_oldest_sell=0;
      g_pair_newest_sell=0;
      if(sell.count==0)
      {
         g_reduced_next_lot_sell=0.0;
         g_reduced_lot_time_sell=0;
      }
   }
   else
   {
      if(g_pair_oldest_sell!=sell.oldest_ticket ||
         g_pair_newest_sell!=sell.newest_ticket)
      {
         g_pair_target_sell=0.0;
         g_pair_oldest_sell=sell.oldest_ticket;
         g_pair_newest_sell=sell.newest_ticket;
      }
      const double oldest_close_volume=
         MathMin(sell.oldest_volume,g_initial_lot);
      const double pair_volume=oldest_close_volume+sell.newest_volume;
      const double pair_price=
         (sell.oldest_open*oldest_close_volume+
          sell.newest_open*sell.newest_volume)/pair_volume;
      const double distance=Inp_TakeProfit*_Point;
      const double loss_ratio=
         QKClamp(-sell.recovery_metric/QK_RECOVERY_DRAWDOWN,0.0,1.0);
      const double candidate=
         QKNormalizePriceNative(
            pair_price-distance+loss_ratio*distance);
      if(candidate>g_pair_target_sell)
         g_pair_target_sell=candidate;
      if(tick.ask<=g_pair_target_sell)
      {
         g_reduced_next_lot_sell=QKReducedBasketNextLot(
            sell,POSITION_TYPE_SELL,oldest_close_volume);
         g_reduced_lot_time_sell=TimeCurrent();
         if(buy.count==0)
         {
            // 配对平仓后，若反向仍有残余篮子，则延后 2 根 K 线才能开反向首仓
            const datetime current_bar=iTime(_Symbol,PERIOD_CURRENT,0);
            const double volume_step=
               SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
            int sell_remaining_count=sell.count-1;
            if(sell.oldest_volume<=
               oldest_close_volume+volume_step*0.5)
               sell_remaining_count--;
            const bool sell_basket_remains=
               sell_remaining_count>=2;
            g_fresh_buy_resume_bar=
               current_bar+
               (sell_basket_remains ? 2 : 1)*
               PeriodSeconds(PERIOD_CURRENT);
         }
         QKCloseTicket(sell.newest_ticket);
         QKCloseTicketVolume(sell.oldest_ticket,oldest_close_volume);
         g_pair_target_sell=0.0;
      }
   }
}

void QKManageEntries(const QKSideState &buy,const QKSideState &sell,
                     const bool new_bar,const datetime bar)
{
   if(!QKDayAllowed() || !QKSpreadAllowed())
      return;
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return;

   if(buy.count==0)
   {
      // 买卖信号独立判断，允许对冲首仓同时存在
      if(new_bar &&
         bar>=g_fresh_buy_resume_bar &&
         QKOpenCooldownElapsed(POSITION_TYPE_BUY) &&
         QKSignal(false))
         QKOpen(ORDER_TYPE_BUY,g_initial_lot);
   }
   else
   {
      const double trigger=buy.last_open-QKGridPoints(buy)*_Point;
      if(new_bar &&
         QKOpenCooldownElapsed(POSITION_TYPE_BUY) &&
         tick.ask<=trigger)
         QKOpen(ORDER_TYPE_BUY,QKNextLot(buy,POSITION_TYPE_BUY));
   }

   if(sell.count==0)
   {
      if(new_bar &&
         bar>=g_fresh_sell_resume_bar &&
         QKOpenCooldownElapsed(POSITION_TYPE_SELL) &&
         QKSignal(true))
         QKOpen(ORDER_TYPE_SELL,g_initial_lot);
   }
   else
   {
      const double trigger=sell.last_open+QKGridPoints(sell)*_Point;
      if(new_bar &&
         QKOpenCooldownElapsed(POSITION_TYPE_SELL) &&
         tick.bid>=trigger)
         QKOpen(ORDER_TYPE_SELL,QKNextLot(sell,POSITION_TYPE_SELL));
   }
}

bool QKPanelSetCommon(const string name)
{
   bool ok=true;
   ok=ObjectSetInteger(0,name,OBJPROP_BACK,false) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_SELECTED,false) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_HIDDEN,true) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_ZORDER,0) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_TIMEFRAMES,0x1FFFFF) && ok;
   return ok;
}

bool QKPanelCreateLabel(const string name,const string text,
                        const int font_size,const color object_color,
                        const int x,const int y,
                        const ENUM_BASE_CORNER corner,
                        const ENUM_ANCHOR_POINT anchor)
{
   ObjectDelete(0,name);
   if(!ObjectCreate(0,name,OBJ_LABEL,0,0,0))
      return false;
   bool ok=QKPanelSetCommon(name);
   ok=ObjectSetString(0,name,OBJPROP_TEXT,text) && ok;
   string panel_font="Impact";
   for(int i=0;i<StringLen(text);i++)
   {
      if(StringGetCharacter(text,i)>127)
      {
         panel_font="Microsoft YaHei UI";
         break;
      }
   }
   ok=ObjectSetString(0,name,OBJPROP_FONT,panel_font) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_FONTSIZE,font_size) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_COLOR,object_color) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_CORNER,corner) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_ANCHOR,anchor) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y) && ok;
   return ok;
}

bool QKPanelCreatePriceLine(const string name,const color object_color,
                            const ENUM_LINE_STYLE style)
{
   ObjectDelete(0,name);
   if(!ObjectCreate(0,name,OBJ_HLINE,0,0,0.0))
      return false;
   bool ok=QKPanelSetCommon(name);
   ok=ObjectSetInteger(0,name,OBJPROP_COLOR,object_color) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_STYLE,style) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_WIDTH,1) && ok;
   return ok;
}

bool QKPanelCreateTimeLine(const string name,const color object_color)
{
   ObjectDelete(0,name);
   if(!ObjectCreate(0,name,OBJ_VLINE,0,0,0.0))
      return false;
   bool ok=QKPanelSetCommon(name);
   ok=ObjectSetInteger(0,name,OBJPROP_COLOR,object_color) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID) && ok;
   ok=ObjectSetInteger(0,name,OBJPROP_WIDTH,1) && ok;
   return ok;
}

void QKPanelDelete()
{
   const string names[]={
      "BreakEven_Compra","BreakEven_Venda","Dia_Final","Dia_Inicio",
      "Hora_Comecar","Hora_Fechar","Hora_Parar","Indicador_Compra",
      "Indicador_Venda","Media_Compra","Media_Compra_Recup","Media_Venda",
      "Media_Venda_Recup","Passo_Compra","Passo_Venda","Pendente_Compra",
      "Pendente_Venda","StopLoss_Compra","StopLoss_Venda",
      "TakeProfit_Compra","TakeProfit_Compra_Recup","TakeProfit_Venda",
      "TakeProfit_Venda_Recup","TextoAbrirCompra","TextoAbrirVenda",
      "TextoAcerto","TextoAtual","TextoCentro","TextoComprado",
      "TextoCompras","TextoDuranteFinal","TextoFecharCompra",
      "TextoFecharVenda","TextoFinal","TextoNomeRobo","TextoRealizado",
      "TextoVendas","TextoVendido","ValorAbrirCompra","ValorAbrirVenda",
      "ValorAcerto","ValorAtual","ValorComprado","ValorCompras",
      "ValorFecharCompra","ValorFecharVenda","ValorRealizado",
      "ValorVendas","ValorVendido"
   };
   for(int i=ArraySize(names)-1;i>=0;i--)
      ObjectDelete(0,names[i]);
}

bool QKPanelCreate()
{
   bool ok=true;
   ok=QKPanelCreatePriceLine("BreakEven_Compra",(color)16711680,STYLE_DOT) && ok;
   ok=QKPanelCreatePriceLine("BreakEven_Venda",(color)255,STYLE_DOT) && ok;
   ok=QKPanelCreateTimeLine("Dia_Final",(color)16777215) && ok;
   ok=QKPanelCreateTimeLine("Dia_Inicio",(color)16777215) && ok;
   ok=QKPanelCreateTimeLine("Hora_Comecar",(color)65280) && ok;
   ok=QKPanelCreateTimeLine("Hora_Fechar",(color)255) && ok;
   ok=QKPanelCreateTimeLine("Hora_Parar",(color)65535) && ok;
   ok=QKPanelCreatePriceLine("Indicador_Compra",(color)65280,STYLE_DOT) && ok;
   ok=QKPanelCreatePriceLine("Indicador_Venda",(color)65280,STYLE_DOT) && ok;
   ok=QKPanelCreatePriceLine("Media_Compra",(color)16711680,STYLE_SOLID) && ok;
   ok=QKPanelCreatePriceLine("Media_Compra_Recup",(color)16776960,STYLE_SOLID) && ok;
   ok=QKPanelCreatePriceLine("Media_Venda",(color)255,STYLE_SOLID) && ok;
   ok=QKPanelCreatePriceLine("Media_Venda_Recup",(color)16711935,STYLE_SOLID) && ok;
   ok=QKPanelCreatePriceLine("Passo_Compra",(color)8421504,STYLE_DASHDOT) && ok;
   ok=QKPanelCreatePriceLine("Passo_Venda",(color)8421504,STYLE_DASHDOT) && ok;
   ok=QKPanelCreatePriceLine("Pendente_Compra",(color)65535,STYLE_DOT) && ok;
   ok=QKPanelCreatePriceLine("Pendente_Venda",(color)65535,STYLE_DOT) && ok;
   ok=QKPanelCreatePriceLine("StopLoss_Compra",(color)16711680,STYLE_DASHDOT) && ok;
   ok=QKPanelCreatePriceLine("StopLoss_Venda",(color)255,STYLE_DASHDOT) && ok;
   ok=QKPanelCreatePriceLine("TakeProfit_Compra",(color)16711680,STYLE_DASHDOT) && ok;
   ok=QKPanelCreatePriceLine("TakeProfit_Compra_Recup",(color)16776960,STYLE_DASHDOT) && ok;
   ok=QKPanelCreatePriceLine("TakeProfit_Venda",(color)255,STYLE_DASHDOT) && ok;
   ok=QKPanelCreatePriceLine("TakeProfit_Venda_Recup",(color)16711935,STYLE_DASHDOT) && ok;

   ok=QKPanelCreateLabel("TextoNomeRobo","Quantum King",30,(color)42495,
                         12,15,CORNER_LEFT_UPPER,ANCHOR_LEFT_UPPER) && ok;
   ok=QKPanelCreateLabel("TextoRealizado","总计",15,(color)16777215,
                         12,72,CORNER_LEFT_UPPER,ANCHOR_LEFT_UPPER) && ok;
   ok=QKPanelCreateLabel("ValorRealizado","0",15,(color)16777215,
                         294,72,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoAtual","卖出",15,(color)13353215,
                         498,99,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("ValorAtual","0",15,(color)16777215,
                         498,72,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("ValorAcerto","0",15,(color)16777215,
                         12,99,CORNER_LEFT_UPPER,ANCHOR_LEFT_UPPER) && ok;
   ok=QKPanelCreateLabel("TextoAcerto","买入",15,(color)16776960,
                         294,99,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoCompras","当前",15,(color)16777215,
                         12,126,CORNER_LEFT_UPPER,ANCHOR_LEFT_UPPER) && ok;
   ok=QKPanelCreateLabel("ValorCompras","0",15,(color)16776960,
                         294,126,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoVendas"," ",15,(color)16777215,
                         498,126,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("ValorVendas","0",15,(color)13353215,
                         498,126,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoComprado","持仓",15,(color)16777215,
                         12,153,CORNER_LEFT_UPPER,ANCHOR_LEFT_UPPER) && ok;
   ok=QKPanelCreateLabel("ValorComprado","0",15,(color)16776960,
                         294,153,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoVendido"," ",15,(color)16777215,
                         498,153,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("ValorVendido","0",15,(color)13353215,
                         498,153,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoAbrirCompra","开仓",15,(color)16777215,
                         12,180,CORNER_LEFT_UPPER,ANCHOR_LEFT_UPPER) && ok;
   ok=QKPanelCreateLabel("ValorAbrirCompra","0",15,(color)16776960,
                         294,180,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoAbrirVenda"," ",15,(color)16777215,
                         498,180,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("ValorAbrirVenda","0",15,(color)13353215,
                         498,180,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoFecharCompra","平仓",15,(color)16777215,
                         12,207,CORNER_LEFT_UPPER,ANCHOR_LEFT_UPPER) && ok;
   ok=QKPanelCreateLabel("ValorFecharCompra","0",15,(color)16776960,
                         294,207,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoFecharVenda"," ",15,(color)16777215,
                         498,207,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("ValorFecharVenda","0",15,(color)13353215,
                         498,207,CORNER_LEFT_UPPER,(ENUM_ANCHOR_POINT)6) && ok;
   ok=QKPanelCreateLabel("TextoDuranteFinal"," ",22,(color)16776960,
                         1031,308,(ENUM_BASE_CORNER)3,(ENUM_ANCHOR_POINT)8) && ok;
   ok=QKPanelCreateLabel("TextoCentro"," ",22,(color)16776960,
                         1031,353,(ENUM_BASE_CORNER)3,(ENUM_ANCHOR_POINT)8) && ok;
   ok=QKPanelCreateLabel("TextoFinal"," ",22,(color)16776960,
                         1031,398,(ENUM_BASE_CORNER)3,(ENUM_ANCHOR_POINT)8) && ok;
   ChartRedraw(0);
   return ok;
}

string QKPanelTimeText(const datetime value)
{
   if(value<=0)
      return "0";
   return TimeToString(value,TIME_DATE|TIME_MINUTES);
}

void QKPanelSetPrice(const string name,const double value)
{
   ObjectSetDouble(0,name,OBJPROP_PRICE,0,value);
}

void QKPanel(const QKSideState &buy,const QKSideState &sell)
{
   const int total_positions=buy.count+sell.count;
   const double total_floating=buy.floating_profit+sell.floating_profit;
   string realized="0";
   string hit_rate="0";
   if(g_history_exit_count>0)
   {
      realized=DoubleToString(g_history_net_result,2)+" $";
      const double percentage=
         100.0*(double)g_history_win_count/(double)g_history_exit_count;
      hit_rate=DoubleToString(percentage,0)+" %/"+
               IntegerToString(g_history_exit_count);
   }
   ObjectSetString(0,"ValorRealizado",OBJPROP_TEXT,realized);
   ObjectSetString(0,"ValorAcerto",OBJPROP_TEXT,hit_rate);
   ObjectSetString(0,"ValorAtual",OBJPROP_TEXT,
                   DoubleToString(total_floating,2)+" /"+
                   IntegerToString(total_positions));
   ObjectSetString(0,"ValorCompras",OBJPROP_TEXT,
                   buy.count>0
                   ? DoubleToString(buy.floating_profit,2)+" /"+
                     IntegerToString(buy.count)
                   : "0");
   ObjectSetString(0,"ValorComprado",OBJPROP_TEXT,
                   buy.count>0
                   ? DoubleToString(buy.weighted_open,_Digits)
                   : "0");
   ObjectSetString(0,"ValorVendas",OBJPROP_TEXT,
                   sell.count>0
                   ? DoubleToString(sell.floating_profit,2)+" /"+
                     IntegerToString(sell.count)
                   : "0");
   ObjectSetString(0,"ValorVendido",OBJPROP_TEXT,
                   sell.count>0
                   ? DoubleToString(sell.weighted_open,_Digits)
                   : "0");
   ObjectSetString(0,"ValorAbrirCompra",OBJPROP_TEXT,
                   QKPanelTimeText(g_last_buy_open_time));
   ObjectSetString(0,"ValorAbrirVenda",OBJPROP_TEXT,
                   QKPanelTimeText(g_last_sell_open_time));
   ObjectSetString(0,"ValorFecharCompra",OBJPROP_TEXT,
                   QKPanelTimeText(g_last_buy_close_time));
   ObjectSetString(0,"ValorFecharVenda",OBJPROP_TEXT,
                   QKPanelTimeText(g_last_sell_close_time));

   QKPanelSetPrice("Media_Compra",buy.count>0 ? buy.weighted_open : 0.0);
   QKPanelSetPrice("Media_Venda",sell.count>0 ? sell.weighted_open : 0.0);
   QKPanelSetPrice("Passo_Compra",
                   buy.count>0
                   ? buy.last_open-QKGridPoints(buy)*_Point
                   : 0.0);
   QKPanelSetPrice("Passo_Venda",
                   sell.count>0
                   ? sell.last_open+QKGridPoints(sell)*_Point
                   : 0.0);
   QKPanelSetPrice("TakeProfit_Compra",
                   g_single_target_buy>0.0
                   ? g_single_target_buy
                   : g_pair_target_buy);
   QKPanelSetPrice("TakeProfit_Venda",
                   g_single_target_sell>0.0
                   ? g_single_target_sell
                   : g_pair_target_sell);
   QKPanelSetPrice("TakeProfit_Compra_Recup",
                   g_recovery_buy ? g_pair_target_buy : 0.0);
   QKPanelSetPrice("TakeProfit_Venda_Recup",
                   g_recovery_sell ? g_pair_target_sell : 0.0);
   QKPanelSetPrice("Media_Compra_Recup",
                   g_recovery_buy ? buy.weighted_open : 0.0);
   QKPanelSetPrice("Media_Venda_Recup",
                   g_recovery_sell ? sell.weighted_open : 0.0);
   ChartRedraw(0);
}

bool QKInitializeNativeSymbolRuntime()
{
   // 配置交易品种数组与货币转换品种数组分离；当前仅支持本图表品种
   const int count=1;
   if(ArrayResize(g_configured_symbols,count)!=count ||
      ArrayResize(g_conversion_symbols,count)!=count ||
      ArrayResize(g_conversion_direct,count)!=count ||
      ArrayResize(g_runtime_tick_value,count)!=count ||
      ArrayResize(g_runtime_tick_size,count)!=count ||
      ArrayResize(g_runtime_volume_limit,count)!=count ||
      ArrayResize(g_runtime_volume_limit_state,count)!=count ||
      ArrayResize(g_runtime_point,count)!=count ||
      ArrayResize(g_runtime_volume_step,count)!=count ||
      ArrayResize(g_runtime_volume_min,count)!=count ||
      ArrayResize(g_runtime_volume_max,count)!=count ||
      ArrayResize(g_runtime_volume_state,count)!=count ||
      ArrayResize(g_runtime_ask,count)!=count ||
      ArrayResize(g_runtime_bid,count)!=count ||
      ArrayResize(g_runtime_m1_close,count)!=count ||
      ArrayResize(g_runtime_margin_buy,count)!=count ||
      ArrayResize(g_runtime_margin_sell,count)!=count ||
      ArrayResize(g_runtime_margin_buy_ready,count)!=count ||
      ArrayResize(g_runtime_margin_sell_ready,count)!=count)
      return false;

   g_configured_symbols[0]=_Symbol;
   g_conversion_symbols[0]="";
   g_conversion_direct[0]=true;
   g_runtime_tick_value[0]=0.0;
   g_runtime_tick_size[0]=0.0;
   g_runtime_volume_limit[0]=0.0;
   g_runtime_volume_limit_state[0]=0.0;
   g_runtime_point[0]=0.0;
   g_runtime_volume_step[0]=0.0;
   g_runtime_volume_min[0]=0.0;
   g_runtime_volume_max[0]=0.0;
   g_runtime_volume_state[0]=0.0;
   g_runtime_ask[0]=0.0;
   g_runtime_bid[0]=0.0;
   g_runtime_m1_close[0]=0.0;
   g_runtime_margin_buy[0]=0.0;
   g_runtime_margin_sell[0]=0.0;
   g_runtime_margin_buy_ready[0]=false;
   g_runtime_margin_sell_ready[0]=false;

   for(int i=0;i<count;i++)
   {
      const string symbol=g_configured_symbols[i];
      if(symbol=="" || !SymbolSelect(symbol,true))
         return false;

      g_runtime_tick_value[i]=
         SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE);
      g_runtime_tick_size[i]=
         SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
      g_runtime_volume_limit[i]=
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_LIMIT);
      g_runtime_volume_limit_state[i]=0.0;
      g_runtime_point[i]=
         SymbolInfoDouble(symbol,SYMBOL_POINT);
      g_runtime_volume_step[i]=
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
      g_runtime_volume_min[i]=
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
      g_runtime_volume_max[i]=
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
      g_runtime_volume_state[i]=0.0;

      const string account_currency=
         AccountInfoString(ACCOUNT_CURRENCY);
      const string profit_currency=
         SymbolInfoString(symbol,SYMBOL_CURRENCY_PROFIT);
      if(account_currency=="" || profit_currency=="")
         return false;
      if(account_currency!=profit_currency)
      {
         const string direct_symbol=account_currency+profit_currency;
         if(SymbolSelect(direct_symbol,true))
         {
            g_conversion_symbols[i]=direct_symbol;
            g_conversion_direct[i]=true;
         }
         else
         {
            const string reverse_symbol=profit_currency+account_currency;
            if(!SymbolSelect(reverse_symbol,true))
            {
               PrintFormat("currency conversion symbol unavailable for %s (%s/%s)",
                           symbol,account_currency,profit_currency);
               return false;
            }
            g_conversion_symbols[i]=reverse_symbol;
            g_conversion_direct[i]=false;
         }
      }
      g_runtime_ask[i]=SymbolInfoDouble(symbol,SYMBOL_ASK);
      g_runtime_bid[i]=SymbolInfoDouble(symbol,SYMBOL_BID);
   }
   return true;
}

int OnInit()
{
   g_trade.SetExpertMagicNumber(Inp_Magic);
   g_trade.SetDeviationInPoints(Inp_Slippage_Max);
   g_initial_lot=QKInitialLot();
   if(!QKInitializeNativeSymbolRuntime())
      return INIT_FAILED;
   // Envelopes 用 H1 周期，偏离按货币因子调整
   g_envelopes=iEnvelopes(_Symbol,PERIOD_H1,QK_ENV_PERIOD,0,
                           MODE_EMA,PRICE_CLOSE,
                           QK_ENV_DEVIATION*QKCurrencyFactor());
   if(g_envelopes==INVALID_HANDLE)
      return INIT_FAILED;
   if(ArraySize(g_configured_symbols)>=2 &&
      !EventSetTimer(1))
      return INIT_FAILED;
   if(!QKPanelCreate())
      Print("Quantum King panel creation was incomplete");
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   if(ArraySize(g_configured_symbols)>=2)
      EventKillTimer();
   if(g_envelopes!=INVALID_HANDLE)
      IndicatorRelease(g_envelopes);
   QKPanelDelete();
}

void QKRefreshAccountRuntime()
{
   // 刷新账户余额、净值、可用保证金、冻结手续费
   g_account_balance=AccountInfoDouble(ACCOUNT_BALANCE);
   g_account_equity=AccountInfoDouble(ACCOUNT_EQUITY);
   g_account_margin_free=AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   g_account_commission_blocked=AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED);
}

void QKRefreshHistoryRuntime()
{
   // 遍历全部历史成交，按 magic 与品种过滤，统计净盈亏、胜率与成交量
   int selected=0;
   int entries=0;
   int exits=0;
   int wins=0;
   ulong latest_ticket=0;
   datetime latest_time=0;
   double net_result=0.0;
   double total_volume=0.0;
   double latest_price=0.0;

   if(HistorySelect(0,TimeCurrent()))
   {
      const int total=HistoryDealsTotal();
      for(int i=0;i<total;i++)
      {
         const ulong ticket=HistoryDealGetTicket(i);
         if(ticket==0)
            continue;

         const long magic=HistoryDealGetInteger(ticket,DEAL_MAGIC);
         if((ulong)magic!=Inp_Magic)
            continue;

         const ENUM_DEAL_TYPE type=
            (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket,DEAL_TYPE);
         if(type!=DEAL_TYPE_BUY && type!=DEAL_TYPE_SELL)
            continue;

         const datetime deal_time=
            (datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
         const double profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);
         const double swap=HistoryDealGetDouble(ticket,DEAL_SWAP);
         const double commission=
            HistoryDealGetDouble(ticket,DEAL_COMMISSION);
         const string symbol=HistoryDealGetString(ticket,DEAL_SYMBOL);
         if(symbol!=_Symbol)
            continue;

         const ENUM_DEAL_ENTRY entry=
            (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket,DEAL_ENTRY);
         const double price=HistoryDealGetDouble(ticket,DEAL_PRICE);
         const double volume=HistoryDealGetDouble(ticket,DEAL_VOLUME);

         selected++;
         const double deal_result=profit+swap+commission;
         net_result+=deal_result;
         total_volume+=volume;
         if(entry==DEAL_ENTRY_IN || entry==DEAL_ENTRY_INOUT)
            entries++;
         if(entry==DEAL_ENTRY_OUT || entry==DEAL_ENTRY_INOUT ||
            entry==DEAL_ENTRY_OUT_BY)
         {
            exits++;
            if(deal_result>0.0)
               wins++;
         }
         if(deal_time>=latest_time)
         {
            latest_time=deal_time;
            latest_ticket=ticket;
            latest_price=price;
         }
      }
   }

   g_history_deal_count=selected;
   g_history_entry_count=entries;
   g_history_exit_count=exits;
   g_history_win_count=wins;
   g_history_latest_ticket=latest_ticket;
   g_history_latest_time=latest_time;
   g_history_net_result=net_result;
   g_history_volume=total_volume;
   g_history_latest_price=latest_price;
}

void QKRefreshCloseSeriesRuntime()
{
   // 缓存每个配置品种的 M1 最新收盘价
   const int count=ArraySize(g_configured_symbols);
   for(int i=0;i<count;i++)
      g_runtime_m1_close[i]=
         iClose(g_configured_symbols[i],PERIOD_M1,0);
}

void QKRefreshMarginRuntime()
{
   // 对每个配置品种分别预计算买/卖方向 1 手初始仓所需保证金
   const int count=ArraySize(g_configured_symbols);
   for(int i=0;i<count;i++)
   {
      const string symbol=g_configured_symbols[i];
      MqlTick tick;
      if(!SymbolInfoTick(symbol,tick))
      {
         g_runtime_margin_buy_ready[i]=false;
         g_runtime_margin_sell_ready[i]=false;
         continue;
      }

      double buy_margin=0.0;
      if(OrderCalcMargin(ORDER_TYPE_BUY,symbol,g_initial_lot,
                         tick.ask,buy_margin))
      {
         g_runtime_margin_buy[i]=buy_margin;
         g_runtime_margin_buy_ready[i]=true;
      }
      else
      {
         g_runtime_margin_buy_ready[i]=false;
      }

      double sell_margin=0.0;
      if(OrderCalcMargin(ORDER_TYPE_SELL,symbol,g_initial_lot,
                         tick.bid,sell_margin))
      {
         g_runtime_margin_sell[i]=sell_margin;
         g_runtime_margin_sell_ready[i]=true;
      }
      else
      {
         g_runtime_margin_sell_ready[i]=false;
      }
   }
}

void QKProcessTick()
{
   QKRefreshAccountRuntime();
   QKRefreshHistoryRuntime();
   QKRefreshMarginRuntime();

   if(QKEquityStop())
      return;

   QKSideState buy,sell;
   if(!QKReadSide(POSITION_TYPE_BUY,buy) ||
      !QKReadSide(POSITION_TYPE_SELL,sell))
      return;
   if(buy.count==0)
      g_recovery_buy=false;
   else if(buy.count>=2 &&
           NormalizeDouble(buy.recovery_metric,2)<=-QK_RECOVERY_DRAWDOWN)
      g_recovery_buy=true;
   if(sell.count==0)
      g_recovery_sell=false;
   else if(sell.count>=2 &&
           NormalizeDouble(sell.recovery_metric,2)<=-QK_RECOVERY_DRAWDOWN)
      g_recovery_sell=true;
   QKManageTakeProfit(buy,sell);
   QKApplyBreakEven();

   const datetime bar=iTime(_Symbol,PERIOD_CURRENT,0);
   const bool new_bar=(bar!=0 && bar!=g_last_bar);
   if(new_bar)
      g_last_bar=bar;

   if(!QKReadSide(POSITION_TYPE_BUY,buy) ||
      !QKReadSide(POSITION_TYPE_SELL,sell))
      return;
   QKManageEntries(buy,sell,new_bar,bar);
   QKPanel(buy,sell);
   QKRefreshCloseSeriesRuntime();
}

bool QKRefreshNativeQuoteCache()
{
   const int count=ArraySize(g_configured_symbols);
   if(ArraySize(g_runtime_ask)<count ||
      ArraySize(g_runtime_bid)<count)
      return false;
   for(int i=0;i<count;i++)
   {
      const string symbol=g_configured_symbols[i];
      if(symbol=="" || !SymbolSelect(symbol,true))
         return false;
      g_runtime_ask[i]=SymbolInfoDouble(symbol,SYMBOL_ASK);
      g_runtime_bid[i]=SymbolInfoDouble(symbol,SYMBOL_BID);
   }
   return true;
}

void OnTick()
{
   if(!QKRefreshNativeQuoteCache())
      return;
   QKProcessTick();
}

void OnTimer()
{
   const int count=ArraySize(g_configured_symbols);
   if(count==1)
      return;
   if(ArraySize(g_runtime_ask)<count ||
      ArraySize(g_runtime_bid)<count)
      return;
   for(int i=0;i<count;i++)
   {
      const string symbol=g_configured_symbols[i];
      if(symbol=="")
         continue;
      const double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);
      const double bid=SymbolInfoDouble(symbol,SYMBOL_BID);
      if(ask!=g_runtime_ask[i] || bid!=g_runtime_bid[i])
      {
         if(!QKRefreshNativeQuoteCache())
            return;
         QKProcessTick();
         return;
      }
   }
}

double OnTester()
{
   return 0.0;
}
