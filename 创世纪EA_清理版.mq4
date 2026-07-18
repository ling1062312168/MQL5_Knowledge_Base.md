//+------------------------------------------------------------------+
//|                                                     创世纪网格 v1.0 |
//|                                      Copyright 2026, 创世纪网格 |
//|                                                              |
//+------------------------------------------------------------------+

#property version "1.00"
#property strict
#resource "\\Indicators\\Gold trading_code.ex4"

#include <ChartObjects/ChartObjectsTxtControls.mqh>
#include <Arrays/ArrayString.mqh>
#include <Controls/Label.mqh>
#include <Controls/Edit.mqh>
#include <Controls/Button.mqh>
#include <Canvas/Canvas.mqh>

extern string sPosComm = "创世纪EA"; //EA系列
extern double dVol = 0.01; // 首单手数
extern double MM = 1.3; // 加仓倍数
extern int iDist = 150; //加仓间距
extern double dML = 0.6; //单笔最大开仓手数
extern int TP = 1500; // 止盈点数
extern int SL=0; // 止损点数 (0 - 为无止损)
extern double 单品种止盈金额=150.0;
extern bool Reduction=true;//首尾对冲平仓
extern int Magic = 2025216; // EA识别码
extern double 超过此浮盈金额开启移动止损=300.0;
extern double 移动止损保金额=100.0;

struct sGetInfo
  {
public:
   double            buy_profit;
   double            sell_profit;
   double            buy_breakeven_price;
   double            sell_breakeven_price;
   double            buy_lots;
   double            sell_lots;
   double            buy_sl_price;
   double            sell_sl_price;
   double            buy_tp_price;
   double            sell_tp_price;
   double            buy_ts_price;
   double            sell_ts_price;
   double            last_loss_lot;
   bool              buy_ts_active;
   bool              sell_ts_active;
   double            lowest_buy_open_price;
   double            highest_sell_open_price;
  };

struct sInfoOrder
  {
public:
   double            open_price;
   double            lots;
   double            tp_price;
   double            profit;
   double            sl_price;
   int               ticket;
   int               order_type;
   datetime          open_time;
   string            comment;
   void              DummyInit()
     {
     }

                     sInfoOrder()
     {
     }

   void              DummyReset()
     {
     }

  };

long last_error_print_time_buy;
long last_tick_time;
bool panel_initialized;
int last_error_code;
string panel_name;
string label_buy_profit_name;
string label_sell_profit_name;
string btn_trade_buy_name;
string btn_trade_sell_name;
string btn_close_buy_name;
string btn_close_sell_name;
string btn_new_series_name;
string btn_open_buy_name;
string btn_open_sell_name;
string edit_lot_name;
string unused_gs_0001;
int tmp_int_2;
int manual_close_mode;
bool flag_open_buy;
bool flag_open_sell;
long last_tp_close_time;
long last_sl_close_time;
double tmp_double_0;
double indicator_val_0;
double indicator_val_2;
int min_lot_digits;
int lot_step_digits;
bool tmp_bool_0;
bool last_bool_result;
int label_buy_corner;
int label_buy_color;
int label_buy_font_size;
int label_buy_anchor;
int label_buy_y;
int label_buy_x;
long label_buy_chart_id;
int edit_start_hour_y;
bool label_sell_bg;
int label_sell_corner;
int label_sell_color;
int label_sell_font_size;
int label_sell_anchor;
int label_sell_y;
int label_sell_x;
long label_sell_chart_id;
int Gi_0012;
long Gl_0012;
long Gl_000A;
long order_open_time_tmp;
long last_long_result;
string Is_0A58;
double ask_price;
double bid_price;
double stoplevel_price;
double spread_price_double;
bool can_open_order;
double buy_profit_tmp;
int spread_points;
int tmp_int_0;
long last_bar_time;
int tmp_int_1;
long max_spread_limit;
int indicator_timeframe_check;
bool indicator_param2;
bool indicator_param1;
double indicator_band1;
bool Gb_0004;
long Gl_0004;
bool debug_mode;
double spread_price;
int panel_x_pos;
int panel_y_pos;
string Gs_0002;
string Gs_0003;
string Gs_0005;
string Gs_0006;

int panel_x_save;
int edit_end_hour_x;
int Gi_0013;
int Gi_0014;
int Gi_0015;
int last_buy_order_idx;
int label_time_x;
int label_profit_x;
long Gl_0019;
int label_buy_profit_y2;
long Gl_001A;
int btn_sell_y;
long Gl_001B;
int btn_close_y;
long Gl_001C;
int btn_new_series_y;
int Gi_001E;
string Gs_001D;
string Gs_001E;
long Gl_001F;
int Gi_001F;
int Gi_0021;
string Gs_0020;
string Gs_0021;
long ts_start_plus_spread2;
int Gi_0022;
int line_noloss_style;
string Gs_0023;
string Gs_0024;
int Gi_0025;
int Gi_0027;
string Gs_0027;
int line_noloss_sell_color;
int Gi_002A;
string Gs_0029;
string Gs_002A;
int Gi_002B;
int config_item_idx;
string Gs_002D;
int line_tp_color;
int Gi_0030;
string Gs_002F;
string Gs_0030;
string Is_0C00;
long Gl_002D;
string Gs_002C;
long Gl_0027;
string Gs_0026;
int unused_ii_0EE0;
string config_version;
int buy_order_count;
int sell_order_count;
double buy_ts_high_price;
double sell_ts_low_price;
int tp_close_enabled;
int sl_close_enabled;
string trading_start_time_str;
int line_tp_color_code;
int line_sl_color_code;
int line_noloss_color_code;
int line_ts_color_code;
double buy_margin_multiplier;
double sell_margin_multiplier;
long last_buy_order_time;
long last_sell_order_time;
long last_order_error_time;
struct Input_Struct_00000EAC;
long Gl_0002;
bool Gb_0003;
bool Gb_0006;
bool Gb_0008;
long buy_order_open_time;
bool config_load_result;
bool Gb_0007;
bool Gb_0009;
bool Gb_000B;
long Gl_000C;
long Gl_0008;
long Gl_0006;
bool Gb_0001;
string Gs_0000;
double sell_margin_required;
double sell_profit_tmp;
string Gs_000B;
double Gd_000F;
long sell_order_open_time;
double lot_diff_tmp;
bool Gb_0014;
double indicator_val_4;
double sl_price_distance;
long Gl_0015;
long Gl_0017;
double close_price_tmp_buy;
double Gd_0017;
double close_price_max_buy;
bool Gb_0018;
bool Gb_001A;
double tp_price_distance;
long Gl_001D;
int Gi_001D;
double close_price_tmp_sell;
double Gd_001D;
double close_price_min_sell;
long spread_tmp;
long ts_start_plus_spread;
double ts_start_dist_sell;
bool Gb_0020;
int sell_ts_min_idx;
bool Gb_0021;
long spread_tmp2;
double ts_start_dist_sell2;
bool tmp_bool_1;
int line_noloss_color;
double Gd_0025;
long line_noloss_chart_id;
bool line_noloss_sell_bg;
int line_noloss_sell_style;
double Gd_002A;
long line_noloss_sell_chart_id;
int config_total_items;
bool line_tp_bg;
double Gd_002F;
long line_tp_chart_id;
int line_tp_sell_color;
bool line_tp_sell_bg;
int line_tp_sell_style;
int Gi_0033;
double Gd_0034;
long line_tp_sell_chart_id;
int line_sl_color;
bool line_sl_bg;
int line_sl_style;
int Gi_0038;
double Gd_0039;
long line_sl_chart_id;
int line_sl_sell_color;
bool line_sl_sell_bg;
int line_sl_sell_style;
int Gi_003D;
double Gd_003E;
long line_sl_sell_chart_id;
int line_ts_color;
bool line_ts_bg;
int line_ts_style;
int Gi_0042;
double Gd_0043;
long line_ts_chart_id;
int line_ts_sell_color;
bool line_ts_sell_bg;
int line_ts_sell_style;
int Gi_0047;
double Gd_0048;
long line_ts_sell_chart_id;
int text_noloss_bg_color;
bool text_noloss_bg;
int text_noloss_corner;
int text_noloss_color;
double Gd_004D;
long Gl_004E;
long text_noloss_chart_id;
int label_title_y;
bool text_noloss_sell_bg;
int label_title_x;
int text_noloss_sell_color;
double Gd_0053;
long Gl_0054;
long text_noloss_sell_chart_id;
int text_tp_bg_color;
bool text_tp_bg;
int text_tp_corner;
int text_tp_color;
double Gd_0059;
long Gl_005A;
long text_tp_chart_id;
int text_tp_sell_bg_color;
bool text_tp_sell_bg;
int text_tp_sell_corner;
int text_tp_sell_color;
double Gd_005F;
long Gl_0060;
long text_tp_sell_chart_id;
int text_sl_bg_color;
bool text_sl_bg;
int text_sl_corner;
int text_sl_color;
double Gd_0065;
long Gl_0066;
long text_sl_sell_chart_id;
int text_sl_sell_bg_color;
bool text_sl_sell_bg;
int text_sl_sell_corner;
int text_sl_sell_color;
double Gd_006B;
long Gl_006C;
long text_ts_sell_chart_id;
int text_ts_bg_color;
bool text_ts_bg;
int text_ts_corner;
int text_ts_color;
double Gd_0071;
long Gl_0072;
long text_ts_chart_id2;
int text_ts_sell_bg_color;
bool text_ts_sell_bg;
int text_ts_sell_corner;
int text_ts_sell_color;
double Gd_0077;
long Gl_0078;
long text_ts_sell_chart_id2;
int Gi_007A;
long Gl_007A;
long Gl_0074;
long Gl_006E;
long text_ts_chart_id;
long text_sl_chart_id;
long label_buy_profit2_chart_id;
long Gl_0056;
long Gl_0050;
long Gl_004A;
long Gl_0045;
long Gl_0040;
long Gl_003B;
long Gl_0036;
long Gl_0031;
long Gl_002C;
double Gd_0001;
double Gd_0007;
double tmp_double_1;
bool config_load_result2;
long Gl_000D;
bool Gb_000D;
double ts_trigger_dist;
long Gl_000F;
double Gd_0011;
double Gd_0010;
long Gl_0014;
long Gl_0016;
bool Gb_0017;
bool Gb_001B;
bool Gb_001C;
long Gl_0023;
bool Gb_0024;
double Gd_0026;
int Gi_0026;
bool Gb_0029;
long Gl_002A;
long Gl_0029;
bool Gb_002A;
double Gd_002C;
double Gd_002B;
bool Gb_002F;
int line_tp_style;
long Gl_002F;
bool Gb_0030;
long Gl_0032;
double Gd_0033;
int Gi_0034;
int Gi_0035;
bool Gb_0037;
long Gl_0038;
long Gl_0037;
long Gl_0003;
double Gd_000A;
double Gd_0009;
double Gd_000E;
double sell_free_margin;
string Gs_0007;
string Gs_0008;
string Gs_000C;
bool Gb_0010;
string Gs_000D;
string Gs_0011;
bool edit_readonly_flag;
string Gs_0012;
string Gs_0016;
string Gs_0017;
string Gs_001B;
bool Gb_001F;
string Gs_001C;
string Gs_0025;
long Gl_004B;
long Gl_004C;
long Gl_004D;
int edit_time_y;
int edit_time_x;
long Gl_0051;
int Gi_0053;
int Gi_0054;
int Gi_0055;
bool label_buy_profit2_bg;
int Gi_0059;
int Gi_005A;
int Gi_005B;
bool Gb_005D;
int Gi_005F;
int Gi_0060;
int Gi_0061;
long label_sell_profit2_chart_id;
int Gi_0065;
int Gi_0066;
int Gi_0067;
int btn_new_series_color;
int Gi_006C;
int Gi_006D;
long Gl_0065;
long Gl_005D;
bool Gb_0025;
bool Gb_0016;
bool Gb_0011;
int Gi_003E;
int Gi_0044;
int Gi_0049;
string Gs_0048;
string Gs_0049;
string Gs_0045;
string Gs_0046;
int Gi_0043;
string Gs_0042;
string Gs_0043;
string Gs_003F;
string Gs_0040;
string Gs_003C;
string Gs_003D;
int Gi_003A;
string Gs_0039;
string Gs_003A;
string Gs_0036;
string Gs_0037;
string Gs_0033;
string Gs_0034;
string Gs_002E;
string Gs_0004;
string Gs_0013;
long Gl_0018;
bool Gb_0026;
long Gl_002E;
bool Gb_0035;
int Gi_0039;
int Gi_003F;
bool Gb_0041;
bool Gb_0042;
int Gi_0048;
string Gs_0009;
string Gs_000E;
bool Gb_000F;
double indicator_val_3;

double Id_0F18[4];
int Ii_0F6C[4];
int Ii_0FB0[4];
CEdit editControls[10];
sInfoOrder buyOrders[];
sInfoOrder sellOrders[];
sGetInfo tradeStats;
CEdit timeEdit;
CEdit lotEdit;
CArrayString *configArray;
double last_double_result;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   int Li_FFFC;

   config_version = "v01";
   unused_ii_0EE0 = 0;

   panel_x_pos = 0;
   panel_y_pos = 0;
   buy_order_count = 0;
   sell_order_count = 0;
   buy_ts_high_price = 0;
   sell_ts_low_price = 1.79769313486232E+308;
   debug_mode = false;
   tp_close_enabled = 0;
   sl_close_enabled = 0;
   indicator_timeframe_check = 1;
   trading_start_time_str = "22:30";
   indicator_param1 = false;
   indicator_param2 = false;
   line_tp_color_code = 32768;
   line_sl_color_code = 255;
   line_noloss_color_code = 42495;
   line_ts_color_code = 7504122;
   obj_prefix = "";
   stoplevel_price = 0;
   spread_price_double = 0;
   ask_price = 0;
   bid_price = 0;
   spread_points = 0;
   flag_open_buy = false;
   flag_open_sell = false;
   min_lot_digits = 0;
   lot_step_digits = 0;
   buy_margin_multiplier = 0;
   sell_margin_multiplier = 0;
   manual_close_mode = 0;
   last_tp_close_time = 0;
   last_sl_close_time = 0;
   last_error_print_time_buy = 0;
   last_tick_time = 0;
   panel_initialized = false;
   last_buy_order_time = 0;
   last_sell_order_time = 0;
   last_bar_time = 0;
   last_order_error_time = 0;

   last_error_print_time_buy = 0;
   last_tick_time = 0;
   panel_initialized = true;
   _RandomSeed = GetTickCount();
   panel_name = obj_prefix + "ControlPanel_recar";
   label_buy_profit_name = obj_prefix + "text_Buy_Profit";
   label_sell_profit_name = obj_prefix + "text_Sell_Profit";
   btn_trade_buy_name = obj_prefix + "Button_Trade_Buy";
   btn_trade_sell_name = obj_prefix + "Button_Trade_Sell";
   btn_close_buy_name = obj_prefix + "Button_Close_Buy";
   btn_close_sell_name = obj_prefix + "Button_Close_Sell";
   btn_new_series_name = obj_prefix + "Button_New_Series";
   btn_open_buy_name = obj_prefix + "Button_Open_Buy";
   btn_open_sell_name = obj_prefix + "Button_Open_Sell";
   edit_lot_name = obj_prefix + "Edit_Lot";
   configArray = new CArrayString();

   EventSetTimer(1);
   manual_close_mode = -1;
   flag_open_buy = false;
   flag_open_sell = false;
   last_tp_close_time = 0;
   last_sl_close_time = 0;
   tmp_double_0 = log(MarketInfo(_Symbol, MODE_MINLOT));
   tmp_double_0 = fabs((tmp_double_0 / 2.30258509299405));
   tmp_double_0 = round(tmp_double_0);
   min_lot_digits = (int)tmp_double_0;
   tmp_double_0 = log(MarketInfo(_Symbol, MODE_LOTSTEP));
   tmp_double_0 = fabs((tmp_double_0 / 2.30258509299405));
   tmp_double_0 = round(tmp_double_0);
   lot_step_digits = (int)tmp_double_0;
   if(fA_MM && iAuLot == 0)
     {
      Print("Money Management Disabled");
      fA_MM = false;
     }
   if(_Digits == 2 || _Digits == 4)
     {

      TP = TP / 10;
      SL = SL / 10;
      IStop = IStop / 10;
      ISTart =  ISTart / 10;
     }
   if((dVol < MarketInfo(_Symbol, MODE_MINLOT)))
     {
      Print("dVol uncorrect");
      dVol = MarketInfo(_Symbol, MODE_MINLOT);
     }
   if((MM < 0))
     {
      Print("MM uncorrect");
      MM = 1;
     }
   tmp_bool_0 = (dML > MarketInfo(_Symbol, MODE_MAXLOT));
   if(dML < MarketInfo(_Symbol, MODE_MINLOT) || tmp_bool_0 != false)
     {

      Print("dML uncorrect");
      dML = MarketInfo(_Symbol, MODE_MAXLOT);
     }
   if(TP < 0)
     {
      Print("TP uncorrect");
      TP = 100;
     }
   if(SL < 0)
     {
      Print("SL uncorrect");
      SL = 2000;
     }
   if(iDist < 1)
     {
      Print("iDist uncorrect");
      iDist = 100;
     }
   if(ISTart < 0)
     {
      Print(" ISTart uncorrect");
      ISTart = 400;
     }
   if(IStop < 1 || IStop >=  ISTart)
     {

      Print("TraiiDistance uncorrect");
      IStop = 200;
     }
   if(Magic < 0)
     {
      Print("Magic uncorrect");
      Magic = 1;
     }
   tmp_bool_0 = false;
   label_buy_corner = 1;
   label_buy_color = 16711680;
   label_buy_font_size = FontSize;
   Ls0_str0000 = "多单盈亏: 0";
   label_buy_anchor = 0;
   label_buy_y = Y1;
   label_buy_x = X1 + 5;
   Ls0_str0001 = label_buy_profit_name;
   label_buy_chart_id = 0;
   if(ObjectFind(0, Ls0_str0001) == -1 && ObjectCreate(0, Ls0_str0001, OBJ_LABEL, 0, 0, 0) == false)
     {
      Print("DrawLabel", "Error: ", GetLastError());
     }
   else
     {
      ObjectSetInteger(label_buy_chart_id, Ls0_str0001, 102, label_buy_x);
      ObjectSetInteger(label_buy_chart_id, Ls0_str0001, 103, label_buy_y);
      ObjectSetInteger(label_buy_chart_id, Ls0_str0001, 101, label_buy_anchor);
      ObjectSetString(label_buy_chart_id, Ls0_str0001, 999, Ls0_str0000);
      ObjectSetInteger(label_buy_chart_id, Ls0_str0001, 100, label_buy_font_size);
      ObjectSetInteger(label_buy_chart_id, Ls0_str0001, 1011, label_buy_corner);
      ObjectSetInteger(label_buy_chart_id, Ls0_str0001, 6, label_buy_color);
      ObjectSetInteger(label_buy_chart_id, Ls0_str0001, 1000, tmp_bool_0);
     }
   label_sell_bg = false;
   label_sell_corner = 1;
   label_sell_color = 16711680;
   label_sell_font_size = FontSize;
   Ls0_str0002 = "空单盈亏: 0";
   label_sell_anchor = 0;
   label_sell_y = Y1 + 20;
   label_sell_x = X1 + 5;
   Ls0_str0003 = label_sell_profit_name;
   label_sell_chart_id = 0;
   if(ObjectFind(0, Ls0_str0003) == -1 && ObjectCreate(0, Ls0_str0003, OBJ_LABEL, 0, 0, 0) == false)
     {
      Print("DrawLabel", "Error: ", GetLastError());
      return 0;
     }
   ObjectSetInteger(label_sell_chart_id, Ls0_str0003, 102, label_sell_x);
   ObjectSetInteger(label_sell_chart_id, Ls0_str0003, 103, label_sell_y);
   ObjectSetInteger(label_sell_chart_id, Ls0_str0003, 101, label_sell_anchor);
   ObjectSetString(label_sell_chart_id, Ls0_str0003, 999, Ls0_str0002);
   ObjectSetInteger(label_sell_chart_id, Ls0_str0003, 100, label_sell_font_size);
   ObjectSetInteger(label_sell_chart_id, Ls0_str0003, 1011, label_sell_corner);
   ObjectSetInteger(label_sell_chart_id, Ls0_str0003, 6, label_sell_color);
   ObjectSetInteger(label_sell_chart_id, Ls0_str0003, 1000, label_sell_bg);

   Li_FFFC = 0;
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |

//+------------------------------------------------------------------+
//|                                                                  |
void CloseAllOrders()
  {
   bool li_0;
   bool li_4;
   for(int li_80=0; li_80<100; li_80++)
      for(int li_8=0; li_8<OrdersTotal(); li_8++)
        {
         RefreshRates();
         li_0=OrderSelect(li_8,SELECT_BY_POS,MODE_TRADES);
         if(li_0)
           {
            if(OrderMagicNumber()==Magic  && OrderSymbol()==Symbol())
              {
               if(OrderType()<2)
                 {
                  li_4=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,Yellow);

                 }
              }
           }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

   if(chexk()!=1)
      return;
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;

   CreateInfoLabel("净值", "账户净值："+DoubleToStr(AccountEquity(),2)+"＄",  10,  358);

   CreateInfoLabel("余额", "账户余额："+DoubleToStr(AccountBalance(),2)+"＄",  10,  313);

   CreateInfoLabel("手数", "总持仓："+DoubleToStr(GetTotalLotsByType(0)+GetTotalLotsByType(1),2)+"手",  10,  278);

   CreateInfoLabel("盈亏", "浮盈亏："+DoubleToStr(GetTotalProfitByType(0)+GetTotalProfitByType(1),2)+"＄",  240,  278);

   CreateInfoLabel("duodan", "多单："+DoubleToStr(GetTotalLotsByType(0),2)+"手",  10,  233);

   CreateInfoLabel("duodans", "浮盈亏："+DoubleToStr(GetTotalProfitByType(0),2)+"＄",  205,  233);

   CreateInfoLabel("kongdan", "空单："+DoubleToStr(GetTotalLotsByType(1),2)+"手",  10,  193);

   CreateInfoLabel("kongdand", "浮盈亏："+DoubleToStr(GetTotalProfitByType(1),2)+"＄",  205,  193);
   HedgeCloseFirstLast();
   HedgeCloseFirstLast2();
   AdjustPendingOrderPrices() ;

   if(单品种止盈金额>0)
      if(GetTotalProfitByType(0)+GetTotalProfitByType(1)>单品种止盈金额)
         CloseAllOrders();

   static double mf0125=0;
   if(GetTotalProfitByType(0)+GetTotalProfitByType(1)>mf0125)
      mf0125=GetTotalProfitByType(0)+GetTotalProfitByType(1);

   if(mf0125>超过此浮盈金额开启移动止损)
      if(GetTotalProfitByType(0)+GetTotalProfitByType(1)<=移动止损保金额)
        {
         mf0125=0;
         CloseAllOrders();

        }

   timeEdit.Text("平台时间: " + TimeToString(TimeCurrent(), 6));
   RefreshRates();
   ask_price = NormalizeDouble(Ask, _Digits);
   bid_price = NormalizeDouble(Bid, _Digits);
   stoplevel_price = (MarketInfo(_Symbol, MODE_STOPLEVEL) * _Point);
   spread_price_double = (MarketInfo(_Symbol, MODE_SPREAD) * _Point);
   if((stoplevel_price == 0))
     {
      stoplevel_price = NormalizeDouble((spread_price_double * 1.5), _Digits);
     }
   spread_points = (int)MarketInfo(_Symbol, MODE_SPREAD);
   if(spread_points < 0)
     {
      spread_points = 0;
     }
   if(manual_close_mode != -1)
     {
      CloseAllOrdersManual();
      return ;
     }
   if(last_bar_time != Time[0])
     {
      last_bar_time = Time[0];
      flag_open_buy = false;
      flag_open_sell = false;
     }
//if(last_tick_time != iTime(NULL, 0, 0))
     {
      HideTestIndicators(true);
      if(indicator_timeframe_check == 1)
        {
         last_tick_time = iTime(NULL, 0, 0);
        }
      tmp_double_0 = iCustom(NULL, TF, "::Indicators\\Gold trading_code.ex4", indicator_param1, Deviation, indicator_param2, 0, 1);
      indicator_band1 = iCustom(NULL, TF, "::Indicators\\Gold trading_code.ex4", indicator_param1, Deviation, indicator_param2, 1, 1);
      if((tmp_double_0 != EMPTY_VALUE))
        {
         if(Bid>tmp_double_0)
            flag_open_buy = true;
         else
            flag_open_sell = true;
        }
      if((indicator_band1 != EMPTY_VALUE))
        {

         if(Bid>indicator_band1)
            flag_open_buy = true;
         else
            flag_open_sell = true;

        }
     }

   UpdateStatsAndDrawLines();
   if((tradeStats.buy_profit >= 0))
     {
      label_buy_color = 16711680;
     }
   else
     {
      label_buy_color = 255;
     }
   Ls0_str0000 = "多单盈亏: " + DoubleToString(tradeStats.buy_profit, 2);
   Ls0_str0001 = label_buy_profit_name;
   if(ObjectFind(0, Ls0_str0001) != -1)
     {
      ObjectSetString(0, Ls0_str0001, 999, Ls0_str0000);
      ObjectSetInteger(0, Ls0_str0001, 6, label_buy_color);
     }
   if((tradeStats.sell_profit >= 0))
     {
      label_buy_color = 16711680;
     }
   else
     {
      label_buy_color = 255;
     }
   Ls0_str0002 = "空单盈亏: " + DoubleToString(tradeStats.sell_profit, 2);
   Ls0_str0003 = label_sell_profit_name;
   if(ObjectFind(0, Ls0_str0003) != -1)
     {
      ObjectSetString(0, Ls0_str0003, 999, Ls0_str0002);
      ObjectSetInteger(0, Ls0_str0003, 6, label_buy_color);
     }
   if(debug_mode)
     {
      spread_price = (Ask - Bid);
      Ls0_str0004 = DoubleToString((spread_price / _Point), 0);
      Comment("GetInfo.LastOrderBuyPrice = ", tradeStats.lowest_buy_open_price, " \nGetInfo.LastOrderSellPrice = ", tradeStats.highest_sell_open_price, " \n iDist = ", iDist, " \n Ask-Bid = ", Ls0_str0004, "\n Flag_Open_Buy = ", flag_open_buy, "\n Flag_Open_Sell = ", flag_open_sell);
     }
   MainTradeLogic();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
//  ObjectsDeleteAll();
   tmp_int_1 = CheckPointer(configArray);
   if(tmp_int_1 == 1)
     {
      delete configArray;
     }

  }

//+------------------------------------------------------------------+
void CreateInfoLabel(string Name,string Text,int XOffset,int YLine)
  {

   ObjectCreate(0,Name,OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,Name,OBJPROP_CORNER,2);
   ObjectSetInteger(0,Name,OBJPROP_XDISTANCE,XOffset);
   ObjectSetInteger(0,Name,OBJPROP_YDISTANCE,YLine);
   ObjectSetInteger(0,Name,OBJPROP_BACK,1);
   ObjectSetInteger(0,Name,OBJPROP_HIDDEN,1);

   ObjectSetInteger(0,Name,OBJPROP_COLOR,DeepPink);
   ObjectSetInteger(0,Name,OBJPROP_FONTSIZE,15);
   ObjectSetString(0,Name,OBJPROP_FONT,"微软雅黑");

   ObjectSetInteger(0,Name,OBJPROP_ANCHOR,2);

   ObjectSetString(0,Name,OBJPROP_TEXT,Text);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   timeEdit.Text("平台时间: " + TimeToString(TimeCurrent(), 6));

   CreateInfoLabel("净值", "账户净值："+DoubleToStr(AccountEquity(),2)+"＄",  10,  358);

   CreateInfoLabel("余额", "账户余额："+DoubleToStr(AccountBalance(),2)+"＄",  10,  313);

   CreateInfoLabel("手数", "总持仓："+DoubleToStr(GetTotalLotsByType(0)+GetTotalLotsByType(1),2)+"手",  10,  278);

   CreateInfoLabel("盈亏", "浮盈亏："+DoubleToStr(GetTotalProfitByType(0)+GetTotalProfitByType(1),2)+"＄",  240,  278);

   CreateInfoLabel("duodan", "多单："+DoubleToStr(GetTotalLotsByType(0),2)+"手",  10,  233);

   CreateInfoLabel("duodans", "浮盈亏："+DoubleToStr(GetTotalProfitByType(0),2)+"＄",  205,  233);

   CreateInfoLabel("kongdan", "空单："+DoubleToStr(GetTotalLotsByType(1),2)+"手",  10,  193);

   CreateInfoLabel("kongdand", "浮盈亏："+DoubleToStr(GetTotalProfitByType(1),2)+"＄",  205,  193);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls0_str0008;
   string Ls0_str0009;
   string Ls0_str000A;
   int Li_FFFC;
   long Ll_FFF0;
   int Li_FFEC;
   int Li_FFE8;
   double Ld_FFE0;
   double Ld_FFD8;

   Li_FFFC = (int)ChartGetInteger(0, 107, 0);
   tmp_int_0 = Li_FFFC - 31;

   lotEdit.Move(70, tmp_int_0);
   Ll_FFF0 = 0;
   if(sparam == panel_name)
     {
      X1 = (int)ObjectGetInteger(0, panel_name, 102, 0);
      Y1 = (int)ObjectGetInteger(0, panel_name, 103, 0);
      if(X1 != panel_x_pos || Y1 != panel_y_pos)
        {

         Ls0_str0000 = (string)X1;
         configArray.Update(0, Ls0_str0000);

         Ls0_str0000 = (string)Y1;
         configArray.Update(1, Ls0_str0000);

         SaveLoadConfig(2);
         label_buy_x = Y1;
         panel_x_save = X1;

         editControls[0].Move(panel_x_save, label_buy_x);
         edit_start_hour_y = Y1 + 130;
         label_sell_corner = X1 + 5;

         editControls[1].Move(label_sell_corner, edit_start_hour_y);
         label_sell_corner = Y1 + 130;
         label_sell_anchor = X1 + 85;

         editControls[2].Move(label_sell_anchor, label_sell_corner);
         label_sell_anchor = Y1 + 150;
         edit_end_hour_x = X1 + 5;

         editControls[3].Move(edit_end_hour_x, label_sell_anchor);
         edit_end_hour_x = Y1 + 150;
         Gi_0014 = X1 + 85;

         editControls[4].Move(Gi_0014, edit_end_hour_x);
         Gi_0014 = Y1 + 35;
         label_time_x = X1 + 5;

         timeEdit.Move(label_time_x, Gi_0014);
         label_profit_x = X1 + 5;
         ObjectSetInteger(Ll_FFF0, label_buy_profit_name, 102, label_profit_x);
         label_buy_profit_y2 = Y1 + 65;
         ObjectSetInteger(Ll_FFF0, label_buy_profit_name, 103, label_buy_profit_y2);
         ObjectSetInteger(Ll_FFF0, label_sell_profit_name, 102, label_profit_x);
         label_buy_profit_y2 = Y1 + 83;
         ObjectSetInteger(Ll_FFF0, label_sell_profit_name, 103, label_buy_profit_y2);
         label_buy_profit_y2 = X1 + 85;
         ObjectSetInteger(Ll_FFF0, btn_trade_sell_name, 102, label_buy_profit_y2);
         btn_sell_y = Y1 + 100;
         ObjectSetInteger(Ll_FFF0, btn_trade_sell_name, 103, btn_sell_y);
         ObjectSetInteger(Ll_FFF0, btn_trade_buy_name, 102, label_profit_x);
         ObjectSetInteger(Ll_FFF0, btn_trade_buy_name, 103, btn_sell_y);
         ObjectSetInteger(Ll_FFF0, btn_close_buy_name, 102, label_profit_x);
         btn_close_y = Y1 + 185;
         ObjectSetInteger(Ll_FFF0, btn_close_buy_name, 103, btn_close_y);
         ObjectSetInteger(Ll_FFF0, btn_close_sell_name, 102, label_buy_profit_y2);
         ObjectSetInteger(Ll_FFF0, btn_close_sell_name, 103, btn_close_y);
         ObjectSetInteger(Ll_FFF0, btn_new_series_name, 102, label_profit_x);
         btn_new_series_y = Y1 + 215;
         ObjectSetInteger(Ll_FFF0, btn_new_series_name, 103, btn_new_series_y);
        }
     }
   if(sparam == btn_trade_buy_name && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {
      if(fTrBuy)
        {
         fTrBuy = false;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr2);
        }
      else
        {
         fTrBuy = true;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr1);
        }
      Ls0_str0000 = (string)fTrBuy;
      configArray.Update(3, Ls0_str0000);
      SaveLoadConfig(2);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   if(sparam == btn_trade_sell_name && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {
      if(fTrSell)
        {
         fTrSell = false;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr2);
        }
      else
        {
         fTrSell = true;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr1);
        }
      Ls0_str0000 = (string)fTrSell;
      configArray.Update(4, Ls0_str0000);
      SaveLoadConfig(2);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   if(sparam == btn_new_series_name && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {
      if(fNS)
        {
         fNS = false;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr2);
        }
      else
        {
         fNS = true;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr1);
        }
      Ls0_str0000 = (string)fNS;
      configArray.Update(7, Ls0_str0000);
      SaveLoadConfig(2);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   Ls0_str0000 = obj_prefix + "Start Hour_3";
   if(sparam == Ls0_str0000)
     {

      Ls0_str0001 = editControls[3].Text();
      Li_FFEC = (int)StringToInteger(Ls0_str0001);
      if(Li_FFEC < 0)
        {
         Li_FFEC = 0;
        }
      else
        {
         if(Li_FFEC > 23)
           {
            Li_FFEC = 23;
           }
        }
      Ls0_str0002 = (string)Li_FFEC;
      editControls[3].Text(Ls0_str0002);;
      iStart_H = Li_FFEC;
      Ls0_str0002 = (string)Li_FFEC;

      configArray.Update(5, Ls0_str0002);
      SaveLoadConfig(2);
     }
   Ls0_str0002 = obj_prefix + "End Hour_4";
   if(sparam == Ls0_str0002)
     {

      Ls0_str0003 = editControls[4].Text();
      Li_FFE8 = (int)StringToInteger(Ls0_str0003);
      if(Li_FFE8 < 0)
        {
         Li_FFE8 = 0;
        }
      else
        {
         if(Li_FFE8 > 24)
           {
            Li_FFE8 = 24;
           }
        }
      Ls0_str0004 = (string)Li_FFE8;
      editControls[4].Text(Ls0_str0004);
      iEnd_H = Li_FFE8;
      Ls0_str0004 = (string)Li_FFE8;
      configArray.Update(6, Ls0_str0004);
      SaveLoadConfig(2);
     }
   if(sparam == btn_open_buy_name && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {

      Ls0_str0005 = lotEdit.Text();
      last_double_result = StringToDouble(Ls0_str0005);
      Ld_FFE0 = last_double_result;
      Ls0_str0006 = DoubleToString(last_double_result, 2);
      Print("Open manual Buy order, Lot = ", Ls0_str0006);
      OpenMarketOrder(0, Ld_FFE0);
      Sleep(300);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   if(sparam == btn_open_sell_name && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {

      Ls0_str0008 = lotEdit.Text();
      last_double_result = StringToDouble(Ls0_str0008);
      Ld_FFD8 = last_double_result;
      Ls0_str0009 = DoubleToString(last_double_result, 2);
      Print("Open manual Sell order, Lot = ", Ls0_str0009);
      OpenMarketOrder(1, Ld_FFD8);
      Sleep(300);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   RefreshRates();
   Ls0_str000A = btn_close_buy_name;
   if(ObjectGetInteger(0, Ls0_str000A, 1018, 0) == 1)
     {
      manual_close_mode = 0;
      CloseAllOrdersManual();
      Sleep(300);
      ObjectSetInteger(0, Ls0_str000A, 1018, 0);
     }
   Ls0_str000A = btn_close_sell_name;
   if(ObjectGetInteger(0, Ls0_str000A, 1018, 0) != 1)
      return;
   manual_close_mode = 1;
   CloseAllOrdersManual();
   Sleep(300);
   ObjectSetInteger(0, Ls0_str000A, 1018, 0);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetTotalLotsByType(int t)
  {
   double li_4=0;
   int li_8=OrdersTotal();
   for(int li_12=0; li_12<li_8; li_12++)
     {
      int t00=OrderSelect(li_12,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==t)
         li_4=li_4+OrderLots();
     }
   return (li_4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetTotalProfitByType(int t)
  {
   double li_4=0;
   int li_8=OrdersTotal();
   for(int li_12=0; li_12<li_8; li_12++)
     {
      int t00=OrderSelect(li_12,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==t)
         li_4=li_4+OrderProfit()+OrderCommission()+OrderSwap();
     }
   return (li_4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateStatsAndDrawLines()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls0_str0008;
   string Ls0_str0009;
   string Ls0_str000A;
   string Ls0_str000B;
   string Ls0_str000C;
   string Ls0_str000D;
   string Ls0_str000E;
   string Ls0_str000F;
   string Ls0_str0010;
   string Ls0_str0011;
   string Ls0_str0012;
   string Ls0_str0013;
   string Ls0_str0014;
   string Ls0_str0015;
   string Ls0_str0016;
   string Ls0_str0017;
   int Li_FFFC;
   double Ld_FFF0;
   double Ld_FFE8;
   double Ld_FFE0;
   double Ld_FFD8;
   int Li_FF6C;
   double Ld_FF60;
   double Ld_FF58;
   int Li_FF54;
   long Ll_FF48;

   Li_FFFC = 0;
   Ld_FFF0 = 0;
   buy_order_count = 0;
   sell_order_count = 0;
   ArrayResize(buyOrders, OrdersTotal(), 0);
   ArrayResize(sellOrders, OrdersTotal(), 0);

   tradeStats.buy_profit = 0;
   tradeStats.buy_lots = 0;
   tradeStats.sell_profit = 0;
   tradeStats.sell_lots = 0;
   tradeStats.last_loss_lot = 0;

   tradeStats.lowest_buy_open_price = 1.79769313486232E+308;
   tradeStats.highest_sell_open_price = 0;
   Li_FFFC = 0;
   if(OrdersTotal() > 0)
     {
      do
        {
         if(OrderSelect(Li_FFFC, 0, 0) && OrderSymbol() == _Symbol)
           {
            if(OrderMagicNumber() == Magic || (OrderMagicNumber() == 0 && fHO))
              {

               if(OrderType() == OP_BUY)
                 {
                  order_open_time_tmp = OrderOpenTime();
                  if(order_open_time_tmp >= Time[0] && last_buy_order_time < OrderOpenTime())
                    {
                     last_buy_order_time = OrderOpenTime();
                     buy_ts_high_price = 0;
                    }
                 }
               if(OrderType() == OP_SELL)
                 {
                  order_open_time_tmp = OrderOpenTime();
                  if(order_open_time_tmp >= Time[0] && last_sell_order_time < OrderOpenTime())
                    {
                     last_sell_order_time = OrderOpenTime();
                     sell_ts_low_price = 1.79769313486232E+308;
                    }
                 }
               if(OrderType() == OP_BUY)
                 {
                  if((NormalizeDouble(OrderOpenPrice(), _Digits) < tradeStats.lowest_buy_open_price))
                    {
                     tradeStats.lowest_buy_open_price = NormalizeDouble(OrderOpenPrice(), _Digits);
                    }
                  buy_profit_tmp = OrderProfit();
                  buy_profit_tmp = (buy_profit_tmp + OrderCommission());
                  Ld_FFF0 = (buy_profit_tmp + OrderSwap());
                  tradeStats.buy_profit = (Ld_FFF0 + tradeStats.buy_profit);
                  tradeStats.buy_lots = (tradeStats.buy_lots + OrderLots());
                  tmp_int_0 = OrderTicket();
                  buyOrders[buy_order_count].ticket = tmp_int_0;
                  tmp_int_0 = OrderType();
                  buyOrders[buy_order_count].order_type = tmp_int_0;
                  buyOrders[buy_order_count].comment = OrderComment();
                  buyOrders[buy_order_count].tp_price = OrderTakeProfit();
                  buyOrders[buy_order_count].open_price = NormalizeDouble(OrderOpenPrice(), _Digits);
                  buy_order_open_time = OrderOpenTime();
                  buyOrders[buy_order_count].open_time = (datetime)buy_order_open_time;
                  buyOrders[buy_order_count].lots = OrderLots();
                  buyOrders[buy_order_count].sl_price = OrderStopLoss();
                  buyOrders[buy_order_count].profit = Ld_FFF0;
                  buy_order_count = buy_order_count + 1;
                 }
               if(OrderType() == OP_SELL)
                 {
                  if((NormalizeDouble(OrderOpenPrice(), _Digits) > tradeStats.highest_sell_open_price))
                    {
                     tradeStats.highest_sell_open_price = NormalizeDouble(OrderOpenPrice(), _Digits);
                    }
                  sell_profit_tmp = OrderProfit();
                  sell_profit_tmp = (sell_profit_tmp + OrderCommission());
                  Ld_FFF0 = (sell_profit_tmp + OrderSwap());
                  tradeStats.sell_profit = (Ld_FFF0 + tradeStats.sell_profit);
                  tradeStats.sell_lots = (tradeStats.sell_lots + OrderLots());
                  label_sell_corner = OrderTicket();
                  sellOrders[sell_order_count].ticket = label_sell_corner;
                  label_sell_corner = OrderType();
                  sellOrders[sell_order_count].order_type = label_sell_corner;
                  sellOrders[sell_order_count].comment = OrderComment();
                  sellOrders[sell_order_count].tp_price = OrderTakeProfit();
                  sellOrders[sell_order_count].open_price = NormalizeDouble(OrderOpenPrice(), _Digits);
                  sell_order_open_time = OrderOpenTime();
                  sellOrders[sell_order_count].open_time = (datetime)sell_order_open_time;
                  sellOrders[sell_order_count].lots = OrderLots();
                  sellOrders[sell_order_count].sl_price = OrderStopLoss();
                  sellOrders[sell_order_count].profit = Ld_FFF0;
                  sell_order_count = sell_order_count + 1;
                 }
              }
           }
         Li_FFFC = Li_FFFC + 1;
        }
      while(Li_FFFC < OrdersTotal());
     }
   Ld_FFE8 = 0;
   Ld_FFE0 = 0;
   Ld_FFD8 = MarketInfo(_Symbol, MODE_TICKVALUE);
   lot_diff_tmp = (tradeStats.buy_lots - tradeStats.sell_lots);
   Ld_FFE8 = NormalizeDouble(lot_diff_tmp, 2);
   Ld_FFE0 = NormalizeDouble(lot_diff_tmp, 2);
   RefreshRates();
   if((tradeStats.buy_lots > 0) && (Ld_FFD8 > 0))
     {
      lot_diff_tmp = ((tradeStats.buy_profit / (Ld_FFD8 * tradeStats.buy_lots)) * _Point);
      tradeStats.buy_breakeven_price = NormalizeDouble((Bid - lot_diff_tmp), _Digits);
     }
   if((tradeStats.sell_lots > 0) && (Ld_FFD8 > 0))
     {
      lot_diff_tmp = -tradeStats.sell_lots;
      lot_diff_tmp = ((tradeStats.sell_profit / (Ld_FFD8 * lot_diff_tmp)) * _Point);
      tradeStats.sell_breakeven_price = NormalizeDouble((Ask - lot_diff_tmp), _Digits);
     }
   Li_FFFC = HistoryTotal() - 1;
   if(Li_FFFC >= 0)
     {
      do
        {
         if(OrderSelect(Li_FFFC, 0, 1) && OrderMagicNumber() == Magic && OrderSymbol() == _Symbol)
           {
            if(OrderType() == OP_BUY || OrderType() == OP_SELL)
              {

               lot_diff_tmp = OrderProfit();
               lot_diff_tmp = (lot_diff_tmp + OrderSwap());
               if(((lot_diff_tmp + OrderCommission()) >= 0))
                  break;
               tradeStats.last_loss_lot = OrderLots();
               break;
              }
           }
         Li_FFFC = Li_FFFC - 1;
        }
      while(Li_FFFC >= 0);
     }
   double Ld_FFA4[];
   double Ld_FF70[];
   Li_FF6C = 0;
   if(buy_order_count > 0)
     {
      if(TP != 0)
        {
         tradeStats.buy_tp_price = ((TP * _Point) + tradeStats.buy_breakeven_price);
        }
      if(SL != 0)
        {
         sl_price_distance = (SL * _Point);
         tradeStats.buy_sl_price = (buyOrders[0].open_price - sl_price_distance);
        }
      if(ISTart != 0 &&  ISTart < TP)
        {
         ArrayInitialize(Ld_FFA4, 2147483647);
         last_buy_order_idx = buy_order_count - 1;
         Li_FF6C = CopyHigh(NULL, 0, buyOrders[last_buy_order_idx].open_time, TimeCurrent(), Ld_FFA4);
         if(Li_FF6C < 1)
           {
            close_price_tmp_buy = Close[0];
            if(close_price_tmp_buy <= buy_ts_high_price)
              {
               close_price_max_buy = buy_ts_high_price;
              }
            else
              {
               close_price_max_buy = close_price_tmp_buy;
              }
            buy_ts_high_price = close_price_max_buy;
            if((close_price_max_buy > ((ISTart * _Point) + tradeStats.buy_breakeven_price)))
              {
               close_price_tmp_buy = (IStop * _Point);
               tradeStats.buy_ts_price = (close_price_max_buy - close_price_tmp_buy);
               tradeStats.buy_ts_active = true;
              }
            else
              {
               tradeStats.buy_ts_price = ((ISTart * _Point) + tradeStats.buy_breakeven_price);
               tradeStats.buy_ts_active = false;
              }
           }
         if(Li_FF6C > 0)
           {
            label_profit_x = ArrayMaximum(Ld_FFA4, Li_FF6C, 0);
            Ld_FF60 = Ld_FFA4[label_profit_x];
            if((Ld_FF60 > ((ISTart * _Point) + tradeStats.buy_breakeven_price)))
              {
               tp_price_distance = (IStop * _Point);
               tradeStats.buy_ts_price = (Ld_FF60 - tp_price_distance);
               tradeStats.buy_ts_active = true;
              }
            else
              {
               tradeStats.buy_ts_price = ((ISTart * _Point) + tradeStats.buy_breakeven_price);
               tradeStats.buy_ts_active = false;
              }
           }
        }
     }
   if(sell_order_count > 0)
     {
      if(TP != 0)
        {
         tp_price_distance = (TP * _Point);
         tradeStats.sell_tp_price = (tradeStats.sell_breakeven_price - tp_price_distance);
        }
      if(SL != 0)
        {
         tradeStats.sell_sl_price = ((SL * _Point) + sellOrders[0].open_price);
        }
      if(ISTart != 0 &&  ISTart < TP)
        {
         ArrayInitialize(Ld_FF70, 2147483647);
         btn_new_series_y = sell_order_count - 1;
         Li_FF6C = CopyLow(NULL, 0, sellOrders[btn_new_series_y].open_time, TimeCurrent(), Ld_FF70);
         if(Li_FF6C < 1)
           {
            close_price_tmp_sell = Close[0];
            if(close_price_tmp_sell >= sell_ts_low_price)
              {
               close_price_min_sell = sell_ts_low_price;
              }
            else
              {
               close_price_min_sell = close_price_tmp_sell;
              }
            sell_ts_low_price = close_price_min_sell;
            spread_tmp = SymbolInfoInteger(NULL, SYMBOL_SPREAD);
            ts_start_plus_spread =  ISTart;
            ts_start_plus_spread = ts_start_plus_spread + spread_tmp;
            ts_start_dist_sell = (ts_start_plus_spread * _Point);
            if((close_price_min_sell < (tradeStats.sell_breakeven_price - ts_start_dist_sell)))
              {
               tradeStats.sell_ts_price = ((IStop * _Point) + close_price_min_sell);
               tradeStats.sell_ts_active = true;
              }
            else
              {
               ts_start_dist_sell = (ISTart * _Point);
               tradeStats.sell_ts_price = (tradeStats.sell_breakeven_price - ts_start_dist_sell);
               tradeStats.sell_ts_active = false;
              }
           }
         if(Li_FF6C > 0)
           {
            sell_ts_min_idx = ArrayMinimum(Ld_FF70, Li_FF6C, 0);
            Ld_FF58 = Ld_FF70[sell_ts_min_idx];
            spread_tmp2 = SymbolInfoInteger(NULL, SYMBOL_SPREAD);
            ts_start_plus_spread2 =  ISTart;
            ts_start_plus_spread2 = ts_start_plus_spread2 + spread_tmp2;
            ts_start_dist_sell2 = (ts_start_plus_spread2 * _Point);
            tmp_bool_1 = (Ld_FF58 < (tradeStats.sell_breakeven_price - ts_start_dist_sell2));
            if((Ld_FF58 > 0) && tmp_bool_1 != false)
              {
               tradeStats.sell_ts_price = ((IStop * _Point) + Ld_FF58);
               tradeStats.sell_ts_active = true;
              }
            else
              {
               ts_start_dist_sell2 = (ISTart * _Point);
               tradeStats.sell_ts_price = (tradeStats.sell_breakeven_price - ts_start_dist_sell2);
               tradeStats.sell_ts_active = false;
              }
           }
        }
     }
   Li_FF54 = 10;
   Ll_FF48 = iTime(_Symbol, _Period, (WindowFirstVisibleBar() - 2));
   tmp_bool_1 = false;
   line_noloss_color = line_noloss_color_code;
   line_noloss_style = 1;
   Ls0_str0000 = obj_prefix + "FlNoLossBuy";
   line_noloss_chart_id = 0;
   if(ObjectFind(0, Ls0_str0000) == -1 && ObjectCreate(0, Ls0_str0000, OBJ_HLINE, 0, 0, tradeStats.buy_breakeven_price) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0000, 0, 0, tradeStats.buy_breakeven_price);
      ObjectSetInteger(line_noloss_chart_id, Ls0_str0000, 6, line_noloss_color);
      ObjectSetInteger(line_noloss_chart_id, Ls0_str0000, 8, line_noloss_style);
      ObjectSetInteger(line_noloss_chart_id, Ls0_str0000, 1000, tmp_bool_1);
     }
   line_noloss_sell_bg = false;
   line_noloss_sell_color = line_noloss_color_code;
   line_noloss_sell_style = 1;
   Ls0_str0001 = obj_prefix + "FltNoLossSell";
   line_noloss_sell_chart_id = 0;
   if(ObjectFind(0, Ls0_str0001) == -1 && ObjectCreate(0, Ls0_str0001, OBJ_HLINE, 0, 0, tradeStats.sell_breakeven_price) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0001, 0, 0, tradeStats.sell_breakeven_price);
      ObjectSetInteger(line_noloss_sell_chart_id, Ls0_str0001, 6, line_noloss_sell_color);
      ObjectSetInteger(line_noloss_sell_chart_id, Ls0_str0001, 8, line_noloss_sell_style);
      ObjectSetInteger(line_noloss_sell_chart_id, Ls0_str0001, 1000, line_noloss_sell_bg);
     }
   line_tp_bg = false;
   config_item_idx = line_tp_color_code;
   line_tp_color = 2;
   Ls0_str0002 = obj_prefix + "FlTPBuy";
   line_tp_chart_id = 0;
   if(ObjectFind(0, Ls0_str0002) == -1 && ObjectCreate(0, Ls0_str0002, OBJ_HLINE, 0, 0, tradeStats.buy_tp_price) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0002, 0, 0, tradeStats.buy_tp_price);
      ObjectSetInteger(line_tp_chart_id, Ls0_str0002, 6, config_item_idx);
      ObjectSetInteger(line_tp_chart_id, Ls0_str0002, 8, line_tp_color);
      ObjectSetInteger(line_tp_chart_id, Ls0_str0002, 1000, line_tp_bg);
     }
   line_tp_sell_bg = false;
   line_tp_sell_style = line_tp_color_code;
   Gi_0033 = 2;
   Ls0_str0003 = obj_prefix + "FlTPSell";
   line_tp_sell_chart_id = 0;
   if(ObjectFind(0, Ls0_str0003) == -1 && ObjectCreate(0, Ls0_str0003, OBJ_HLINE, 0, 0, tradeStats.sell_tp_price) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0003, 0, 0, tradeStats.sell_tp_price);
      ObjectSetInteger(line_tp_sell_chart_id, Ls0_str0003, 6, line_tp_sell_style);
      ObjectSetInteger(line_tp_sell_chart_id, Ls0_str0003, 8, Gi_0033);
      ObjectSetInteger(line_tp_sell_chart_id, Ls0_str0003, 1000, line_tp_sell_bg);
     }
   line_sl_bg = false;
   line_sl_style = line_sl_color_code;
   Gi_0038 = 2;
   Ls0_str0004 = obj_prefix + "FlSLBuy";
   line_sl_chart_id = 0;
   if(ObjectFind(0, Ls0_str0004) == -1 && ObjectCreate(0, Ls0_str0004, OBJ_HLINE, 0, 0, tradeStats.buy_sl_price) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0004, 0, 0, tradeStats.buy_sl_price);
      ObjectSetInteger(line_sl_chart_id, Ls0_str0004, 6, line_sl_style);
      ObjectSetInteger(line_sl_chart_id, Ls0_str0004, 8, Gi_0038);
      ObjectSetInteger(line_sl_chart_id, Ls0_str0004, 1000, line_sl_bg);
     }
   line_sl_sell_bg = false;
   line_sl_sell_style = line_sl_color_code;
   Gi_003D = 2;
   Ls0_str0005 = obj_prefix + "FlSLSell";
   line_sl_sell_chart_id = 0;
   if(ObjectFind(0, Ls0_str0005) == -1 && ObjectCreate(0, Ls0_str0005, OBJ_HLINE, 0, 0, tradeStats.sell_sl_price) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0005, 0, 0, tradeStats.sell_sl_price);
      ObjectSetInteger(line_sl_sell_chart_id, Ls0_str0005, 6, line_sl_sell_style);
      ObjectSetInteger(line_sl_sell_chart_id, Ls0_str0005, 8, Gi_003D);
      ObjectSetInteger(line_sl_sell_chart_id, Ls0_str0005, 1000, line_sl_sell_bg);
     }
   line_ts_bg = false;
   line_ts_style = line_ts_color_code;
   Gi_0042 = 1;
   Ls0_str0006 = obj_prefix + "FlTSBuy";
   line_ts_chart_id = 0;
   if(ObjectFind(0, Ls0_str0006) == -1 && ObjectCreate(0, Ls0_str0006, OBJ_HLINE, 0, 0, tradeStats.buy_ts_price) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0006, 0, 0, tradeStats.buy_ts_price);
      ObjectSetInteger(line_ts_chart_id, Ls0_str0006, 6, line_ts_style);
      ObjectSetInteger(line_ts_chart_id, Ls0_str0006, 8, Gi_0042);
      ObjectSetInteger(line_ts_chart_id, Ls0_str0006, 1000, line_ts_bg);
     }
   line_ts_sell_bg = false;
   line_ts_sell_style = line_ts_color_code;
   Gi_0047 = 1;
   Ls0_str0007 = obj_prefix + "FlTSSell";
   line_ts_sell_chart_id = 0;
   if(ObjectFind(0, Ls0_str0007) == -1 && ObjectCreate(0, Ls0_str0007, OBJ_HLINE, 0, 0, tradeStats.sell_ts_price) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0007, 0, 0, tradeStats.sell_ts_price);
      ObjectSetInteger(line_ts_sell_chart_id, Ls0_str0007, 6, line_ts_sell_style);
      ObjectSetInteger(line_ts_sell_chart_id, Ls0_str0007, 8, Gi_0047);
      ObjectSetInteger(line_ts_sell_chart_id, Ls0_str0007, 1000, line_ts_sell_bg);
     }
   text_noloss_bg = false;
   text_noloss_corner = 0;
   text_noloss_color = line_noloss_color_code;
   Ls0_str0008 = "Breakeven Buy";
   Ls0_str0009 = obj_prefix + "FlNoLossBuyText";
   text_noloss_chart_id = 0;
   if(ObjectFind(0, Ls0_str0009) == -1 && ObjectCreate(0, Ls0_str0009, OBJ_TEXT, 0, Ll_FF48, tradeStats.buy_breakeven_price) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0009, 0, Ll_FF48, tradeStats.buy_breakeven_price);
      ObjectSetInteger(text_noloss_chart_id, Ls0_str0009, 6, text_noloss_color);
      ObjectSetText(Ls0_str0009, Ls0_str0008, 0, NULL, 4294967295);
      ObjectSetInteger(text_noloss_chart_id, Ls0_str0009, 1011, text_noloss_corner);
      ObjectSetInteger(text_noloss_chart_id, Ls0_str0009, 1000, text_noloss_bg);
     }
   text_noloss_sell_bg = false;
   label_title_x = 0;
   text_noloss_sell_color = line_noloss_color_code;
   Ls0_str000A = "Breakeven Sell";
   Ls0_str000B = obj_prefix + "FlNoLossSellText";
   text_noloss_sell_chart_id = 0;
   if(ObjectFind(0, Ls0_str000B) == -1 && ObjectCreate(0, Ls0_str000B, OBJ_TEXT, 0, Ll_FF48, tradeStats.sell_breakeven_price) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str000B, 0, Ll_FF48, tradeStats.sell_breakeven_price);
      ObjectSetInteger(text_noloss_sell_chart_id, Ls0_str000B, 6, text_noloss_sell_color);
      ObjectSetText(Ls0_str000B, Ls0_str000A, 0, NULL, 4294967295);
      ObjectSetInteger(text_noloss_sell_chart_id, Ls0_str000B, 1011, label_title_x);
      ObjectSetInteger(text_noloss_sell_chart_id, Ls0_str000B, 1000, text_noloss_sell_bg);
     }
   text_tp_bg = false;
   text_tp_corner = 0;
   text_tp_color = line_tp_color_code;
   Ls0_str000C = "TP Buy";
   Ls0_str000D = obj_prefix + "FlTPBuyText";
   text_tp_chart_id = 0;
   if(ObjectFind(0, Ls0_str000D) == -1 && ObjectCreate(0, Ls0_str000D, OBJ_TEXT, 0, Ll_FF48, tradeStats.buy_tp_price) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str000D, 0, Ll_FF48, tradeStats.buy_tp_price);
      ObjectSetInteger(text_tp_chart_id, Ls0_str000D, 6, text_tp_color);
      ObjectSetText(Ls0_str000D, Ls0_str000C, 0, NULL, 4294967295);
      ObjectSetInteger(text_tp_chart_id, Ls0_str000D, 1011, text_tp_corner);
      ObjectSetInteger(text_tp_chart_id, Ls0_str000D, 1000, text_tp_bg);
     }
   text_tp_sell_bg = false;
   text_tp_sell_corner = 0;
   text_tp_sell_color = line_tp_color_code;
   Ls0_str000E = "TP Sell";
   Ls0_str000F = obj_prefix + "FlTPSellText";
   text_tp_sell_chart_id = 0;
   if(ObjectFind(0, Ls0_str000F) == -1 && ObjectCreate(0, Ls0_str000F, OBJ_TEXT, 0, Ll_FF48, tradeStats.sell_tp_price) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str000F, 0, Ll_FF48, tradeStats.sell_tp_price);
      ObjectSetInteger(text_tp_sell_chart_id, Ls0_str000F, 6, text_tp_sell_color);
      ObjectSetText(Ls0_str000F, Ls0_str000E, 0, NULL, 4294967295);
      ObjectSetInteger(text_tp_sell_chart_id, Ls0_str000F, 1011, text_tp_sell_corner);
      ObjectSetInteger(text_tp_sell_chart_id, Ls0_str000F, 1000, text_tp_sell_bg);
     }
   text_sl_bg = false;
   text_sl_corner = 0;
   text_sl_color = line_sl_color_code;
   Ls0_str0010 = "SL Buy";
   Ls0_str0011 = obj_prefix + "FlSLBuyText";
   text_sl_sell_chart_id = 0;
   if(ObjectFind(0, Ls0_str0011) == -1 && ObjectCreate(0, Ls0_str0011, OBJ_TEXT, 0, Ll_FF48, tradeStats.buy_sl_price) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0011, 0, Ll_FF48, tradeStats.buy_sl_price);
      ObjectSetInteger(text_sl_sell_chart_id, Ls0_str0011, 6, text_sl_color);
      ObjectSetText(Ls0_str0011, Ls0_str0010, 0, NULL, 4294967295);
      ObjectSetInteger(text_sl_sell_chart_id, Ls0_str0011, 1011, text_sl_corner);
      ObjectSetInteger(text_sl_sell_chart_id, Ls0_str0011, 1000, text_sl_bg);
     }
   text_sl_sell_bg = false;
   text_sl_sell_corner = 0;
   text_sl_sell_color = line_sl_color_code;
   Ls0_str0012 = "SL Sell";
   Ls0_str0013 = obj_prefix + "FlSLSellText";
   text_ts_sell_chart_id = 0;
   if(ObjectFind(0, Ls0_str0013) == -1 && ObjectCreate(0, Ls0_str0013, OBJ_TEXT, 0, Ll_FF48, tradeStats.sell_sl_price) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0013, 0, Ll_FF48, tradeStats.sell_sl_price);
      ObjectSetInteger(text_ts_sell_chart_id, Ls0_str0013, 6, text_sl_sell_color);
      ObjectSetText(Ls0_str0013, Ls0_str0012, 0, NULL, 4294967295);
      ObjectSetInteger(text_ts_sell_chart_id, Ls0_str0013, 1011, text_sl_sell_corner);
      ObjectSetInteger(text_ts_sell_chart_id, Ls0_str0013, 1000, text_sl_sell_bg);
     }
   text_ts_bg = false;
   text_ts_corner = 0;
   text_ts_color = line_ts_color_code;
   if(tradeStats.buy_ts_active == true)
     {
      Ls0_str0014 = "Trailing stop buy";
     }
   else
     {
      Ls0_str0014 = "Trailing stop buy start";
     }
   Ls0_str0015 = obj_prefix + "FlTSBuyText";
   text_ts_chart_id2 = 0;
   if(ObjectFind(0, Ls0_str0015) == -1 && ObjectCreate(0, Ls0_str0015, OBJ_TEXT, 0, Ll_FF48, tradeStats.buy_ts_price) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0015, 0, Ll_FF48, tradeStats.buy_ts_price);
      ObjectSetInteger(text_ts_chart_id2, Ls0_str0015, 6, text_ts_color);
      ObjectSetText(Ls0_str0015, Ls0_str0014, 0, NULL, 4294967295);
      ObjectSetInteger(text_ts_chart_id2, Ls0_str0015, 1011, text_ts_corner);
      ObjectSetInteger(text_ts_chart_id2, Ls0_str0015, 1000, text_ts_bg);
     }
   text_ts_sell_bg = false;
   text_ts_sell_corner = 0;
   text_ts_sell_color = line_ts_color_code;
   if(tradeStats.sell_ts_active == true)
     {
      Ls0_str0016 = "Trailing stop sell";
     }
   else
     {
      Ls0_str0016 = "Trailing stop sell start";
     }
   Ls0_str0017 = obj_prefix + "FlTSSellText";
   text_ts_sell_chart_id2 = 0;
   if(ObjectFind(0, Ls0_str0017) == -1 && ObjectCreate(0, Ls0_str0017, OBJ_TEXT, 0, Ll_FF48, tradeStats.sell_ts_price) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0017, 0, Ll_FF48, tradeStats.sell_ts_price);
      ObjectSetInteger(text_ts_sell_chart_id2, Ls0_str0017, 6, text_ts_sell_color);
      ObjectSetText(Ls0_str0017, Ls0_str0016, 0, NULL, 4294967295);
      ObjectSetInteger(text_ts_sell_chart_id2, Ls0_str0017, 1011, text_ts_sell_corner);
      ObjectSetInteger(text_ts_sell_chart_id2, Ls0_str0017, 1000, text_ts_sell_bg);
     }
   ArrayFree(Ld_FF70);
   ArrayFree(Ld_FFA4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalcAddLotSize(double ss,double bb,int Count)
  {

   double tLots=0;
   tLots=NormalizeDouble(ss*MathPow(bb,Count),2);
   if(tLots>=dML)
      tLots=dML;
   return (tLots);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MainTradeLogic()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls0_str0008;
   string Ls0_str0009;
   string Ls0_str000A;
   string Ls0_str000B;
   string Ls0_str000C;
   string Ls0_str000D;
   string Ls0_str000E;
   string Ls0_str000F;
   double Ld_FFF8;
   int Li_FFF4;
   bool Lb_FFF3;
   double Ld_FFE8;
   int Li_FFE4;
   double Ld_FFD8;
   string Ls_FFC8;
   string Ls_FFB8;
   bool Lb_FFB7;
   string Ls_FFA8;
   string Ls_FF98;
   string Ls_FF88;
   string Ls_FF78;
   string Ls_FF68;
   string Ls_FF58;

   Ld_FFF8 = 0;
   Li_FFF4 = 0;
   Lb_FFF3 = true;
   if(iMaxS != 0)
     {
      order_open_time_tmp = SymbolInfoInteger(NULL, SYMBOL_SPREAD);
      max_spread_limit = iMaxS;
      if(order_open_time_tmp > max_spread_limit)
        {
         Lb_FFF3 = false;
        }
     }
   Ld_FFE8 = 0;
   Li_FFE4 = -1;
   Ld_FFD8 = -1;
   if(flag_open_buy && buy_order_count == 0 && sell_order_count != 0)
     {
      tmp_double_0 = fabs((sellOrders[0].open_price - Ask));
      if((tmp_double_0 > (iDist * _Point)))
        {

         Ld_FFE8 = 0;
         Li_FFF4 = 0;
         if(sell_order_count > 0)
           {
            do
              {
               if(sellOrders[Li_FFF4].ticket != 0)
                 {
                  Ld_FFE8 = (Ld_FFE8 + sellOrders[Li_FFF4].profit);
                  Ld_FFD8 = CloseOrderByTicket(sellOrders[Li_FFF4].ticket);
                  Li_FFE4 = sellOrders[Li_FFF4].order_type;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     DrawTradeMarkers(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < sell_order_count);
           }
         if(fDraw)
           {
            Ls0_str0000 = obj_prefix + "Rez_";
            Ls0_str0001 = (string)TimeCurrent();
            Ls0_str0000 = Ls0_str0000 + Ls0_str0001;
            Ls_FFC8 = Ls0_str0000;
            Ls0_str0001 = "$" + DoubleToString(Ld_FFE8, 2);
            DrawProfitLabel(Ls0_str0000, Time[0], Ld_FFD8, Ls0_str0001, Color_Fon_Metki, Li_FFE4);
           }
         UpdateStatsAndDrawLines();
        }
      else
        {
         flag_open_buy = false;

        }
     }
   if(flag_open_sell && sell_order_count == 0 && buy_order_count != 0)
     {
      tmp_double_1 = fabs((buyOrders[0].open_price - Bid));
      if((tmp_double_1 > (iDist * _Point)))
        {

         Ld_FFE8 = 0;
         Li_FFF4 = 0;
         if(buy_order_count > 0)
           {
            do
              {
               if(buyOrders[Li_FFF4].ticket != 0)
                 {
                  Ld_FFE8 = (Ld_FFE8 + buyOrders[Li_FFF4].profit);
                  Ld_FFD8 = CloseOrderByTicket(buyOrders[Li_FFF4].ticket);
                  Li_FFE4 = buyOrders[Li_FFF4].order_type;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     DrawTradeMarkers(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < buy_order_count);
           }
         if(fDraw)
           {
            Ls0_str0002 = obj_prefix + "Rez_";
            Ls0_str0003 = (string)TimeCurrent();
            Ls0_str0002 = Ls0_str0002 + Ls0_str0003;
            Ls_FFB8 = Ls0_str0002;
            Ls0_str0003 = "$" + DoubleToString(Ld_FFE8, 2);
            DrawProfitLabel(Ls0_str0002, Time[0], Ld_FFD8, Ls0_str0003, Color_Fon_Metki, Li_FFE4);
           }
         UpdateStatsAndDrawLines();
        }
      else
        {

         flag_open_sell = false;
        }
     }
   if(buy_order_count != 0)
     {
      flag_open_buy = false;
     }
   if(sell_order_count != 0)
     {
      flag_open_sell = false;
     }
   Lb_FFB7 = true;
   if(iStart_H != 0 && iEnd_H != 0)
     {
      if(iStart_H < iEnd_H)
        {
         if(Hour() < iStart_H || Hour() >= iEnd_H)
           {

            Lb_FFB7 = false;
           }
        }
      if(iStart_H > iEnd_H && Hour() < iStart_H && Hour() >= iEnd_H)
        {
         Lb_FFB7 = false;
        }
     }

   if(fTrBuy && flag_open_buy && buy_order_count == 0 && Lb_FFB7 && Lb_FFF3 && fNS && sell_order_count == 0)
     {
      if((tradeStats.last_loss_lot != 0))
        {
         Ld_FFF8 = (tradeStats.last_loss_lot * MM);
        }
      else
        {
         Ld_FFF8 = dVol;
         if(fA_MM)
           {
            Ld_FFF8 = ((AccountFreeMargin() / iAuLot) * 0.01);
           }
        }
      if((Ld_FFF8 > dML))
        {
         Ld_FFF8 = dML;
        }

        {

         OpenMarketOrder(0, Ld_FFF8);

         if(CountOrdersByType(1)==0)
           {
            DeletePendingOrdersByType(OP_SELLSTOP);

            int      Ld_FFF802 =   OrderSend(_Symbol, OP_SELLSTOP, dVol, Bid-  50*Point, spread_points, 0, 0, sPosComm+"SELL0", Magic, 0, 255);

           }

        }

      buy_ts_high_price = 0;
     }

   OpenPendingOrder(0, CalcAddLotSize(dVol,MM,CountOrdersByType(0)));

   if(fTrSell && flag_open_sell && sell_order_count == 0 && Lb_FFB7 && Lb_FFF3 && fNS && buy_order_count == 0)
     {
      if((tradeStats.last_loss_lot != 0))
        {
         Ld_FFF8 = (tradeStats.last_loss_lot * MM);
        }
      else
        {
         Ld_FFF8 = dVol;
         if(fA_MM)
           {
            Ld_FFF8 = ((AccountFreeMargin() / iAuLot) * 0.01);
           }
        }
      if((Ld_FFF8 > dML))
        {
         Ld_FFF8 = dML;
        }

        {

         OpenMarketOrder(1, Ld_FFF8);
         if(CountOrdersByType(0)==0)
           {

            DeletePendingOrdersByType(OP_BUYSTOP);
            int      Ld_FFF802  = OrderSend(_Symbol, OP_BUYSTOP, dVol, Ask+ 50*Point, spread_points, 0, 0, sPosComm+"Buy0", Magic, 0, 255);

           }

        }

      sell_ts_low_price = 1.79769313486232E+308;
     }
   OpenPendingOrder(1, CalcAddLotSize(dVol,MM,CountOrdersByType(1)));
   if(tradeStats.buy_ts_active && (Bid <= tradeStats.buy_ts_price))
     {
      ts_trigger_dist = (_Point * 100);
      if((Bid > (tradeStats.buy_ts_price - ts_trigger_dist)))
        {
         Ld_FFE8 = 0;
         Li_FFF4 = 0;
         if(buy_order_count > 0)
           {
            do
              {
               if(buyOrders[Li_FFF4].ticket != 0)
                 {
                  Print("Close Position ts, tf: ", tradeStats.buy_ts_active, " ts: ", tradeStats.buy_ts_price, " OpenPrice: ", buyOrders[Li_FFF4].open_price, " Bid: ", Bid, " LastTime: ", buyOrders[Li_FFF4].open_time);
                  Ld_FFE8 = (Ld_FFE8 + buyOrders[Li_FFF4].profit);
                  Ld_FFD8 = CloseOrderByTicket(buyOrders[Li_FFF4].ticket);
                  Li_FFE4 = buyOrders[Li_FFF4].order_type;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     DrawTradeMarkers(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < buy_order_count);
           }
         if(fDraw)
           {
            Ls0_str0004 = obj_prefix + "Rez_";
            Ls0_str0005 = (string)TimeCurrent();
            Ls0_str0004 = Ls0_str0004 + Ls0_str0005;
            Ls_FFA8 = Ls0_str0004;
            Ls0_str0005 = "$" + DoubleToString(Ld_FFE8, 2);
            DrawProfitLabel(Ls0_str0004, Time[0], Ld_FFD8, Ls0_str0005, Color_Fon_Metki, Li_FFE4);
           }
        }
     }
   if(last_tp_close_time != Time[0])
     {
      Ld_FFE8 = 0;
      if(tp_close_enabled == 1)
        {
         last_tp_close_time = Time[0];
        }
      if((tradeStats.buy_tp_price != 0) && (Bid >= tradeStats.buy_tp_price))
        {
         Li_FFF4 = 0;
         if(buy_order_count > 0)
           {
            do
              {
               if(buyOrders[Li_FFF4].ticket != 0)
                 {
                  Ld_FFE8 = (Ld_FFE8 + buyOrders[Li_FFF4].profit);
                  Ld_FFD8 = CloseOrderByTicket(buyOrders[Li_FFF4].ticket);
                  Li_FFE4 = buyOrders[Li_FFF4].order_type;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     DrawTradeMarkers(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < buy_order_count);
           }
         if(fDraw)
           {
            Ls0_str0006 = obj_prefix + "Rez_";
            Ls0_str0007 = (string)TimeCurrent();
            Ls0_str0006 = Ls0_str0006 + Ls0_str0007;
            Ls_FF98 = Ls0_str0006;
            Ls0_str0007 = "$" + DoubleToString(Ld_FFE8, 2);
            DrawProfitLabel(Ls0_str0006, Time[0], Ld_FFD8, Ls0_str0007, Color_Fon_Metki, Li_FFE4);
           }
        }
      if((tradeStats.sell_tp_price != 0) && (Ask <= tradeStats.sell_tp_price))
        {
         Li_FFF4 = 0;
         if(sell_order_count > 0)
           {
            do
              {
               if(sellOrders[Li_FFF4].ticket != 0)
                 {
                  Print("Close Position tp, tp: ", tradeStats.sell_tp_price, " OpenPrice: ", sellOrders[Li_FFF4].open_price, " Bid: ", Bid);
                  Ld_FFE8 = (Ld_FFE8 + sellOrders[Li_FFF4].profit);
                  Ld_FFD8 = CloseOrderByTicket(sellOrders[Li_FFF4].ticket);
                  Li_FFE4 = sellOrders[Li_FFF4].order_type;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     DrawTradeMarkers(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < sell_order_count);
           }
         if(fDraw)
           {
            Ls0_str0008 = obj_prefix + "Rez_";
            Ls0_str0009 = (string)TimeCurrent();
            Ls0_str0008 = Ls0_str0008 + Ls0_str0009;
            Ls_FF88 = Ls0_str0008;
            Ls0_str0009 = "$" + DoubleToString(Ld_FFE8, 2);
            DrawProfitLabel(Ls0_str0008, Time[0], Ld_FFD8, Ls0_str0009, Color_Fon_Metki, Li_FFE4);
           }
        }
     }
   if(last_sl_close_time != Time[0])
     {
      Ld_FFE8 = 0;
      if(sl_close_enabled == 1)
        {
         last_sl_close_time = Time[0];
        }
      if((tradeStats.buy_sl_price != 0) && (Bid <= tradeStats.buy_sl_price))
        {
         Li_FFF4 = 0;
         if(buy_order_count > 0)
           {
            do
              {
               if(buyOrders[Li_FFF4].ticket != 0)
                 {
                  Print("Close Position sl, sl: ", tradeStats.buy_sl_price, " OpenPrice: ", buyOrders[Li_FFF4].open_price, " Bid: ", Bid);
                  Ld_FFE8 = (Ld_FFE8 + buyOrders[Li_FFF4].profit);
                  Ld_FFD8 = CloseOrderByTicket(buyOrders[Li_FFF4].ticket);
                  Li_FFE4 = buyOrders[Li_FFF4].order_type;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     DrawTradeMarkers(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < buy_order_count);
           }
         if(fDraw)
           {
            Ls0_str000A = obj_prefix + "Rez_";
            Ls0_str000B = (string)TimeCurrent();
            Ls0_str000A = Ls0_str000A + Ls0_str000B;
            Ls_FF78 = Ls0_str000A;
            Ls0_str000B = "$" + DoubleToString(Ld_FFE8, 2);
            DrawProfitLabel(Ls0_str000A, Time[0], Ld_FFD8, Ls0_str000B, Color_Fon_Metki, Li_FFE4);
           }
        }
      if((tradeStats.sell_sl_price != 0) && (Ask >= tradeStats.sell_sl_price))
        {
         Li_FFF4 = 0;
         if(sell_order_count > 0)
           {
            do
              {
               if(sellOrders[Li_FFF4].ticket != 0)
                 {
                  Print("Close Position sl, sl: ", tradeStats.sell_sl_price, " OpenPrice: ", sellOrders[Li_FFF4].open_price, " Bid: ", Bid);
                  Ld_FFE8 = (Ld_FFE8 + sellOrders[Li_FFF4].profit);
                  Ld_FFD8 = CloseOrderByTicket(sellOrders[Li_FFF4].ticket);
                  Li_FFE4 = sellOrders[Li_FFF4].order_type;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     DrawTradeMarkers(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < sell_order_count);
           }
         if(fDraw)
           {
            Ls0_str000C = obj_prefix + "Rez_";
            Ls0_str000D = (string)TimeCurrent();
            Ls0_str000C = Ls0_str000C + Ls0_str000D;
            Ls_FF68 = Ls0_str000C;
            Ls0_str000D = "$" + DoubleToString(Ld_FFE8, 2);
            DrawProfitLabel(Ls0_str000C, Time[0], Ld_FFD8, Ls0_str000D, Color_Fon_Metki, Li_FFE4);
           }
        }
     }
   if(tradeStats.sell_ts_active == false)
      return;
   if((Ask < tradeStats.sell_ts_price))
      return;
   if((Ask >= ((_Point * 100) + tradeStats.sell_ts_price)))
      return;
   Ld_FFE8 = 0;
   Li_FFF4 = 0;
   if(sell_order_count > 0)
     {
      do
        {
         if(sellOrders[Li_FFF4].ticket != 0)
           {
            Print("Close Position ts, tf: ", tradeStats.sell_ts_active, " ts: ", tradeStats.sell_ts_price, "  OpenPrice: ", sellOrders[Li_FFF4].open_price, " Bid: ", Bid, " LastTime: ", sellOrders[Li_FFF4].open_time);
            Ld_FFE8 = (Ld_FFE8 + sellOrders[Li_FFF4].profit);
            Ld_FFD8 = CloseOrderByTicket(sellOrders[Li_FFF4].ticket);
            Li_FFE4 = sellOrders[Li_FFF4].order_type;
            if((Ld_FFD8 != -1) && fDraw)
              {
               DrawTradeMarkers(Ld_FFD8);
              }
           }
         Li_FFF4 = Li_FFF4 + 1;
        }
      while(Li_FFF4 < sell_order_count);
     }
   if(fDraw == false)
      return;
   Ls0_str000E = obj_prefix + "Rez_";
   Ls0_str000F = (string)TimeCurrent();
   Ls0_str000E = Ls0_str000E + Ls0_str000F;
   Ls_FF58 = Ls0_str000E;
   Ls0_str000F = "$" + DoubleToString(Ld_FFE8, 2);
   DrawProfitLabel(Ls0_str000E, Time[0], Ld_FFD8, Ls0_str000F, Color_Fon_Metki, Li_FFE4);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenMarketOrder(int Fa_i_00, double Fa_d_01)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   int Li_FFFC;
   double Ld_FFF0;
   double Ld_FFE8;
   int Li_FFE4;
   int Li_FFE0;
   int Li_FFDC;
   int Li_FFD8;
   int Li_FFD4;

   if(!IsTradeAllowed())
      return;
   tmp_int_0 = (int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   tmp_int_1 = tmp_int_0;
   if(tmp_int_0 == 0)
     {
      can_open_order = true;
     }
   else
     {
      tmp_bool_0 = (OrdersTotal() < tmp_int_1);
      can_open_order = tmp_bool_0;
     }
   if(can_open_order == false)
      return;
   Li_FFFC = 0;
   Ld_FFF0 = Fa_d_01;
   if((Fa_d_01 < MarketInfo(_Symbol, MODE_MINLOT)))
     {
      Ld_FFF0 = MarketInfo(_Symbol, MODE_MINLOT);
      Print("Lot less than the minimum. Order will open with minimum lot");
     }
   if((Ld_FFF0 > MarketInfo(_Symbol, MODE_MAXLOT)))
     {
      Ld_FFF0 = MarketInfo(_Symbol, MODE_MAXLOT);
      Print("Lot more than the maximum. Order opens maximum lot");
     }
   last_double_result = SymbolInfoDouble(NULL, 36);
   Ld_FFE8 = last_double_result;
   if(Ld_FFE8 == 0)
      return;
   tmp_double_0 = round((Ld_FFF0 / last_double_result));
   Li_FFE4 = (int)tmp_double_0;
   if(Li_FFE4 == 0)
     {
      Li_FFE4 = 1;
     }
   Ld_FFF0 = (Li_FFE4 * Ld_FFE8);
   if(debug_mode)
     {
      Print("----- В олпен ордер прийшов Ask: ", Ask, "  Bid = ", Bid);
     }
   Li_FFE0 = 0;
   Li_FFDC = 1;
   do
     {
      RefreshRates();
      if(Fa_i_00 == 0)
        {
         tmp_double_0 = AccountFreeMargin();
         indicator_band1 = ((MarketInfo(_Symbol, MODE_MARGINREQUIRED) * Ld_FFF0) * buy_margin_multiplier);
         if(AccountFreeMarginCheck(_Symbol, Fa_i_00, Ld_FFF0) < 0
            || ((tmp_double_0 - indicator_band1) < 0))
           {

            if(last_error_print_time_buy != Time[0])
              {
               Print("Not enouth money to open position");
              }
            last_error_print_time_buy = Time[0];
            return ;
           }
         if(Ld_FFF0==dVol)
            Li_FFE0 = OrderSend(_Symbol, Fa_i_00, Ld_FFF0, Ask, spread_points, 0, 0, sPosComm+"Buy", Magic, 0, 16711680);
         else
            Li_FFE0 = OrderSend(_Symbol, Fa_i_00, Ld_FFF0, Ask, spread_points, 0, 0, sPosComm+DoubleToStr(Ask+iDist*Point*2,Digits), Magic, 0, 16711680);
         if(Li_FFE0 == -1)
           {
            Print(923, "  ERR open Buy Order. Err: ", GetLastError());
           }
        }
      else
        {
         if(Fa_i_00 == 1)
           {
            sell_free_margin = AccountFreeMargin();
            sell_margin_required = ((MarketInfo(_Symbol, MODE_MARGINREQUIRED) * Ld_FFF0) * sell_margin_multiplier);
            if(AccountFreeMarginCheck(_Symbol, Fa_i_00, Ld_FFF0) < 0
               || ((sell_free_margin - sell_margin_required) < 0))
              {

               if(last_error_print_time_buy != Time[0])
                 {
                  Print("Not enouth money to open position");
                 }
               last_error_print_time_buy = Time[0];
               return ;
              }
            if(Ld_FFF0==dVol)
               Li_FFE0 = OrderSend(_Symbol, Fa_i_00, Ld_FFF0, Bid, spread_points, 0, 0, sPosComm+"Sell", Magic, 0, 255);

            else
               Li_FFE0 = OrderSend(_Symbol, Fa_i_00, Ld_FFF0, Bid, spread_points, 0, 0, sPosComm+DoubleToStr(Ask-iDist*Point*2,Digits), Magic, 0, 255);

            if(Li_FFE0 == -1)
              {
               Print(938, "  ERR open Sell Order. Err: ", GetLastError());
              }
           }
        }
      if(Li_FFE0 > 0)
        {
         if(debug_mode == false)
            return;
         Print("---- Order #", Li_FFE0, " open. lot: ", Ld_FFF0, " type: ", Fa_i_00, " CountTry = ", Li_FFDC, " Ask = ", Ask, " Bid = ", Bid);
         Print("----  GetInfo.LastOrderBuyPrice = ", tradeStats.lowest_buy_open_price, " GetInfo.LastOrderSellPrice = ", tradeStats.highest_sell_open_price, " iDist = ", iDist);
         if(Fa_i_00 == 0)
           {
            Li_FFD8 = 0;
            if(buy_order_count > 0)
              {
               do
                 {
                  Ls0_str0000 = TimeToString(buyOrders[Li_FFD8].open_time, 7);
                  Print(" Tic Buy = ", buyOrders[Li_FFD8].ticket, " OpPr = ", buyOrders[Li_FFD8].open_price, " OpTim = ", Ls0_str0000);
                  Li_FFD8 = Li_FFD8 + 1;
                 }
               while(Li_FFD8 < buy_order_count);
              }
           }
         if(Fa_i_00 == 1)
           {
            Li_FFD4 = 0;
            if(sell_order_count > 0)
              {
               do
                 {
                  Ls0_str0001 = TimeToString(sellOrders[Li_FFD4].open_time, 7);
                  Print(" Tic Sell = ", sellOrders[Li_FFD4].ticket, " OpPr = ", sellOrders[Li_FFD4].open_price, " OpTim = ", Ls0_str0001);
                  Li_FFD4 = Li_FFD4 + 1;
                 }
               while(Li_FFD4 < sell_order_count);
              }
           }
         Print("==========");
         return ;
        }
      label_sell_x = GetLastError();
      Li_FFFC = label_sell_x;
      if(last_order_error_time != Time[0])
        {
         last_order_error_time = Time[0];
         last_error_code = label_sell_x;
         if(last_error_code >= 2 && last_error_code <= 149)
           {

            if(last_error_code == 2)
              {

               Alert("Total mistake");
               return ;
              }
            if(last_error_code == 3)
              {

               Alert("Wrong trading parameters");
               return ;
              }
            if(last_error_code == 4)
              {

               Sleep(60000);
              }
            if(last_error_code == 5)
              {

               Alert("The client terminal is out of date");
               return ;
              }
            if(last_error_code == 6)
              {

               Sleep(5000);
              }
            if(last_error_code == 8)
              {

               Alert("Too frequent queries");
               return ;
              }
            if(last_error_code == 64)
              {

               Alert("Account is blocked");
               return ;
              }
            if(last_error_code == 65)
              {

               Alert("Wrong account number");
               return ;
              }
            if(last_error_code == 128)
              {

               Sleep(60000);
              }
            if(last_error_code == 129)
              {

               Sleep(5000);
              }
            if(last_error_code == 130)
              {

               Sleep(1000);
              }
            if(last_error_code == 131)
              {

               Alert("Wrong Lots");
               return ;
              }
            if(last_error_code == 132)
              {

               Alert("Market Close");
               return ;
              }
            if(last_error_code == 133)
              {

               Alert("trade is disabled");
               return ;
              }
            if(last_error_code == 134)
              {

               Alert("Not enough money");
               return ;
              }
            if(last_error_code == 135)
              {

              }
            if(last_error_code == 136)
              {

               Sleep(1000);
              }
            if(last_error_code == 138)
              {

              }
            if(last_error_code == 139)
              {

               return ;
              }
            if(last_error_code == 140)
              {

               Alert("Allowed only buying");
               return ;
              }
            if(last_error_code == 141)
              {

               Alert("Too many requests");
               return ;
              }
            if(last_error_code == 142)
              {

               Sleep(60000);
              }
            if(last_error_code == 143)
              {

               Sleep(60000);
              }
            if(last_error_code == 144)
              {

               Alert("Order canceled customer");
               return ;
              }
            if(last_error_code == 146)
              {

               if(IsTradeContextBusy())
                 {
                  do
                    {
                    }
                  while(IsTradeContextBusy());
                 }
              }
            if(last_error_code == 148)
              {

               Alert("Too many orders");
               return ;
              }
            if(last_error_code == 149)
              {

               Alert("hedging is disabled");
               return ;
              }
           }
        }
      Li_FFDC = Li_FFDC + 1;
     }
   while(Li_FFDC < 6);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountOrdersByType(int t)
  {
   bool b=0;
   int li_4 = 0;
   int li_8 = OrdersTotal();
   for(int li_12=0; li_12<li_8; li_12++)
     {
      b=OrderSelect(li_12,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==t)
         li_4++;
     }
   return (li_4);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenPendingOrder(int Fa_i_00, double Fa_d_01)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   int Li_FFFC;
   double Ld_FFF0;
   double Ld_FFE8;
   int Li_FFE4;
   int Li_FFE0;
   int Li_FFDC;
   int Li_FFD8;
   int Li_FFD4;

   if(!IsTradeAllowed())
      return;
   tmp_int_0 = (int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   tmp_int_1 = tmp_int_0;
   if(tmp_int_0 == 0)
     {
      can_open_order = true;
     }
   else
     {
      tmp_bool_0 = (OrdersTotal() < tmp_int_1);
      can_open_order = tmp_bool_0;
     }
   if(can_open_order == false)
      return;
   Li_FFFC = 0;
   Ld_FFF0 = Fa_d_01;
   if((Fa_d_01 < MarketInfo(_Symbol, MODE_MINLOT)))
     {
      Ld_FFF0 = MarketInfo(_Symbol, MODE_MINLOT);
      Print("Lot less than the minimum. Order will open with minimum lot");
     }
   if((Ld_FFF0 > MarketInfo(_Symbol, MODE_MAXLOT)))
     {
      Ld_FFF0 = MarketInfo(_Symbol, MODE_MAXLOT);
      Print("Lot more than the maximum. Order opens maximum lot");
     }
   last_double_result = SymbolInfoDouble(NULL, 36);
   Ld_FFE8 = last_double_result;
   if(Ld_FFE8 == 0)
      return;
   tmp_double_0 = round((Ld_FFF0 / last_double_result));
   Li_FFE4 = (int)tmp_double_0;
   if(Li_FFE4 == 0)
     {
      Li_FFE4 = 1;
     }
   Ld_FFF0 = (Li_FFE4 * Ld_FFE8);
   if(debug_mode)
     {
      Print("----- В олпен ордер прийшов Ask: ", Ask, "  Bid = ", Bid);
     }
   Li_FFE0 = 0;
   Li_FFDC = 1;
   do
     {
      RefreshRates();
      if(Fa_i_00 == 0)
         if(CountOrdersByType(OP_BUYSTOP)==0)
            if(CountOrdersByType(0)>0)
              {
               tmp_double_0 = AccountFreeMargin();
               indicator_band1 = ((MarketInfo(_Symbol, MODE_MARGINREQUIRED) * Ld_FFF0) * buy_margin_multiplier);
               if(AccountFreeMarginCheck(_Symbol, Fa_i_00, Ld_FFF0) < 0
                  || ((tmp_double_0 - indicator_band1) < 0))
                 {

                  if(last_error_print_time_buy != Time[0])
                    {
                     Print("Not enouth money to open position");
                    }
                  last_error_print_time_buy = Time[0];
                  return ;
                 }
               Li_FFE0 = OrderSend(_Symbol, OP_BUYSTOP, Ld_FFF0, Ask+iDist*Point, spread_points, 0, 0, sPosComm+DoubleToStr(Ask+iDist*Point*2,Digits), Magic, 0, 16711680);
               if(Li_FFE0 == -1)
                 {
                  Print(923, "  ERR open Buy Order. Err: ", GetLastError());
                 }
              }

        {
         if(Fa_i_00 == 1)
            if(CountOrdersByType(OP_SELLSTOP)==0)
               if(CountOrdersByType(1)>0)
                 {
                  sell_free_margin = AccountFreeMargin();
                  sell_margin_required = ((MarketInfo(_Symbol, MODE_MARGINREQUIRED) * Ld_FFF0) * sell_margin_multiplier);
                  if(AccountFreeMarginCheck(_Symbol, Fa_i_00, Ld_FFF0) < 0
                     || ((sell_free_margin - sell_margin_required) < 0))
                    {

                     if(last_error_print_time_buy != Time[0])
                       {
                        Print("Not enouth money to open position");
                       }
                     last_error_print_time_buy = Time[0];
                     return ;
                    }
                  Li_FFE0 = OrderSend(_Symbol, OP_SELLSTOP, Ld_FFF0, Bid-iDist*Point, spread_points, 0, 0, sPosComm+DoubleToStr(Bid-iDist*Point*2,Digits), Magic, 0, 255);
                  if(Li_FFE0 == -1)
                    {
                     Print(938, "  ERR open Sell Order. Err: ", GetLastError());
                    }
                 }
        }
      if(Li_FFE0 > 0)
        {
         if(debug_mode == false)
            return;
         Print("---- Order #", Li_FFE0, " open. lot: ", Ld_FFF0, " type: ", Fa_i_00, " CountTry = ", Li_FFDC, " Ask = ", Ask, " Bid = ", Bid);
         Print("----  GetInfo.LastOrderBuyPrice = ", tradeStats.lowest_buy_open_price, " GetInfo.LastOrderSellPrice = ", tradeStats.highest_sell_open_price, " iDist = ", iDist);
         if(Fa_i_00 == 0)
           {
            Li_FFD8 = 0;
            if(buy_order_count > 0)
              {
               do
                 {
                  Ls0_str0000 = TimeToString(buyOrders[Li_FFD8].open_time, 7);
                  Print(" Tic Buy = ", buyOrders[Li_FFD8].ticket, " OpPr = ", buyOrders[Li_FFD8].open_price, " OpTim = ", Ls0_str0000);
                  Li_FFD8 = Li_FFD8 + 1;
                 }
               while(Li_FFD8 < buy_order_count);
              }
           }
         if(Fa_i_00 == 1)
           {
            Li_FFD4 = 0;
            if(sell_order_count > 0)
              {
               do
                 {
                  Ls0_str0001 = TimeToString(sellOrders[Li_FFD4].open_time, 7);
                  Print(" Tic Sell = ", sellOrders[Li_FFD4].ticket, " OpPr = ", sellOrders[Li_FFD4].open_price, " OpTim = ", Ls0_str0001);
                  Li_FFD4 = Li_FFD4 + 1;
                 }
               while(Li_FFD4 < sell_order_count);
              }
           }
         Print("==========");
         return ;
        }
      label_sell_x = GetLastError();
      Li_FFFC = label_sell_x;
      if(last_order_error_time != Time[0])
        {
         last_order_error_time = Time[0];
         last_error_code = label_sell_x;
         if(last_error_code >= 2 && last_error_code <= 149)
           {

            if(last_error_code == 2)
              {

               Alert("Total mistake");
               return ;
              }
            if(last_error_code == 3)
              {

               Alert("Wrong trading parameters");
               return ;
              }
            if(last_error_code == 4)
              {

               Sleep(60000);
              }
            if(last_error_code == 5)
              {

               Alert("The client terminal is out of date");
               return ;
              }
            if(last_error_code == 6)
              {

               Sleep(5000);
              }
            if(last_error_code == 8)
              {

               Alert("Too frequent queries");
               return ;
              }
            if(last_error_code == 64)
              {

               Alert("Account is blocked");
               return ;
              }
            if(last_error_code == 65)
              {

               Alert("Wrong account number");
               return ;
              }
            if(last_error_code == 128)
              {

               Sleep(60000);
              }
            if(last_error_code == 129)
              {

               Sleep(5000);
              }
            if(last_error_code == 130)
              {

               Sleep(1000);
              }
            if(last_error_code == 131)
              {

               Alert("Wrong Lots");
               return ;
              }
            if(last_error_code == 132)
              {

               Alert("Market Close");
               return ;
              }
            if(last_error_code == 133)
              {

               Alert("trade is disabled");
               return ;
              }
            if(last_error_code == 134)
              {

               Alert("Not enough money");
               return ;
              }
            if(last_error_code == 135)
              {

              }
            if(last_error_code == 136)
              {

               Sleep(1000);
              }
            if(last_error_code == 138)
              {

              }
            if(last_error_code == 139)
              {

               return ;
              }
            if(last_error_code == 140)
              {

               Alert("Allowed only buying");
               return ;
              }
            if(last_error_code == 141)
              {

               Alert("Too many requests");
               return ;
              }
            if(last_error_code == 142)
              {

               Sleep(60000);
              }
            if(last_error_code == 143)
              {

               Sleep(60000);
              }
            if(last_error_code == 144)
              {

               Alert("Order canceled customer");
               return ;
              }
            if(last_error_code == 146)
              {

               if(IsTradeContextBusy())
                 {
                  do
                    {
                    }
                  while(IsTradeContextBusy());
                 }
              }
            if(last_error_code == 148)
              {

               Alert("Too many orders");
               return ;
              }
            if(last_error_code == 149)
              {

               Alert("hedging is disabled");
               return ;
              }
           }
        }
      Li_FFDC = Li_FFDC + 1;
     }
   while(Li_FFDC < 6);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CloseOrderByTicket(int Fa_i_00)
  {
   return 0;
   double Ld_FFF8;
   int Li_FFF4;
   double Ld_FFE8;
   int Li_FFE4;
   int Li_FFE0;
   double Ld_FFD8;

   RefreshRates();
   ask_price = NormalizeDouble(Ask, _Digits);
   bid_price = NormalizeDouble(Bid, _Digits);
   stoplevel_price = (MarketInfo(_Symbol, MODE_STOPLEVEL) * _Point);
   spread_price_double = (MarketInfo(_Symbol, MODE_SPREAD) * _Point);
   if((stoplevel_price == 0))
     {
      stoplevel_price = NormalizeDouble((spread_price_double * 1.5), _Digits);
     }
   spread_points = (int)MarketInfo(_Symbol, MODE_SPREAD);
   if(spread_points < 0)
     {
      spread_points = 0;
     }
   if(iMaxS != 0 && (spread_price_double > (iMaxS * _Point)))
     {
      Print("Spread is more than maximum. Can not close.");
      Ld_FFF8 = -1;
      return Ld_FFF8;
     }
   Li_FFF4 = 0;
   Ld_FFE8 = 0;
   Li_FFE4 = 0;
   Li_FFE0 = 1;
   if(OrderSelect(Fa_i_00, 1, 0) != true)
     {
      Alert("order#", Fa_i_00, " not found");
      Ld_FFF8 = -1;
      return Ld_FFF8;
     }
   Ld_FFD8 = OrderLots();
   if(Li_FFE0 < 6)
     {
      do
        {
         if(OrderSelect(Fa_i_00, 1, 0) != true)
           {
            Alert("order#", Fa_i_00, " not found");
            Ld_FFF8 = -1;
            return Ld_FFF8;
           }
         Print("Closing orders #", Fa_i_00, " try ", Li_FFE0);
         RefreshRates();
         if(OrderType() == OP_BUY)
           {
            Ld_FFE8 = Bid;
            Li_FFE4 = 16711680;
           }
         else
           {
            if(OrderType() == OP_SELL)
              {
               Ld_FFE8 = Ask;
               Li_FFE4 = 255;
              }
            else
              {
               Ld_FFF8 = -1;
               return Ld_FFF8;
              }
           }
         if(OrderClose(Fa_i_00, Ld_FFD8, Ld_FFE8, spread_points, Li_FFE4))
           {
            Print("order #", Fa_i_00, "  Close");
            Ld_FFF8 = Ld_FFE8;
            return Ld_FFF8;
           }
         tmp_int_0 = GetLastError();
         Li_FFF4 = tmp_int_0;
         Print("Order #", Fa_i_00, " Try ", Li_FFE0, " Error ", tmp_int_0);
         Li_FFE0 = Li_FFE0 + 1;
        }
      while(Li_FFE0 < 6);
     }
   Print("Failed close the order #", Fa_i_00, " completed by TimeOut Error ", Li_FFF4);
   tmp_int_0 = -Li_FFF4;
   Ld_FFF8 = tmp_int_0;

   return Ld_FFF8;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateButton(string Fa_s_00,
              int Fa_i_01,
              int Fa_i_02,
              int Fa_i_03,
              int Fa_i_04,
              string Fa_s_05,
              string Fa_s_06,
              int Fa_i_07,
              int Fa_i_08,
              int Fa_i_09,
              bool FuncArg_Boolean_0000000A,
              bool FuncArg_Boolean_0000000B,
              bool FuncArg_Boolean_0000000C,
              bool FuncArg_Boolean_0000000D,
              bool FuncArg_Boolean_0000000E,
              long Fa_l_0F,
              int Fa_i_10)
  {
   int Li_FFFC;
   long Ll_FFF0;

   Li_FFFC = 0;
   Ll_FFF0 = 0;
   if(ObjectFind(0, Fa_s_00) == -1 && ObjectCreate(0, Fa_s_00, OBJ_BUTTON, 0, 0, 0) == false)
     {
      Print("ButtonCreate", "Error: ", GetLastError());
      return ;
     }
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 102, Fa_i_01);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 103, Fa_i_02);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1019, Fa_i_03);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1020, Fa_i_04);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 101, Fa_i_10);
   ObjectSetString(Ll_FFF0, Fa_s_00, 999, Fa_s_05);
   ObjectSetString(Ll_FFF0, Fa_s_00, 1001, Fa_s_06);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 100, Fa_i_07);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 6, Fa_i_08);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1025, Fa_i_09);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1035, cCB);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 9, FuncArg_Boolean_0000000C);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1018, FuncArg_Boolean_0000000B);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1000, FuncArg_Boolean_0000000D);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 17, FuncArg_Boolean_0000000D);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 208, FuncArg_Boolean_0000000E);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 207, Fa_l_0F);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllOrdersManual()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   double Ld_FFF8;
   int Li_FFF4;
   double Ld_FFE8;
   int Li_FFE4;
   int Li_FFE0;
   bool Lb_FFDF;
   int Li_FFA4;
   int Li_FFA0;
   string Ls_FF90;

   RefreshRates();
   ask_price = NormalizeDouble(Ask, _Digits);
   bid_price = NormalizeDouble(Bid, _Digits);
   stoplevel_price = (MarketInfo(_Symbol, MODE_STOPLEVEL) * _Point);
   spread_price_double = (MarketInfo(_Symbol, MODE_SPREAD) * _Point);
   if((stoplevel_price == 0))
     {
      stoplevel_price = NormalizeDouble((spread_price_double * 1.5), _Digits);
     }
   spread_points = (int)MarketInfo(_Symbol, MODE_SPREAD);
   if(spread_points < 0)
     {
      spread_points = 0;
     }
   if(iMaxS != 0 && (spread_price_double > (iMaxS * _Point)))
     {
      Print("Spread is more than maximum. Can not close.");
      return ;
     }
   Ld_FFF8 = 0;
   Li_FFF4 = -1;
   Ld_FFE8 = -1;
   Li_FFE4 = 0;
   Li_FFE0 = 0;
   Lb_FFDF = false;
   int Li_FFA8[];
   Li_FFA4 = 0;
   Li_FFA0 = manual_close_mode;
   manual_close_mode = -1;
   ArrayResize(Li_FFA8, OrdersTotal(), 0);
   ArrayInitialize(Li_FFA8, -1);
   Li_FFE4 = OrdersTotal() - 1;
   if(Li_FFE4 >= 0)
     {
      do
        {
         if(OrderSelect(Li_FFE4, 0, 0))
           {
            if(OrderMagicNumber() == Magic || (OrderMagicNumber() == 0 && fHO))
              {

               if(OrderSymbol() == _Symbol)
                 {
                  Lb_FFDF = false;
                  if(Li_FFA0 == 2)
                    {
                     Lb_FFDF = true;
                    }
                  if(Li_FFA0 == 0 && OrderType() == OP_BUY)
                    {
                     Lb_FFDF = true;
                    }
                  if(Li_FFA0 == 1 && OrderType() == OP_SELL)
                    {
                     Lb_FFDF = true;
                    }
                  if(Lb_FFDF)
                    {
                     tmp_int_0 = OrderTicket();
                     Li_FFA8[Li_FFA4] = tmp_int_0;
                     Li_FFA4 = Li_FFA4 + 1;
                    }
                 }
              }
           }
         Li_FFE4 = Li_FFE4 - 1;
        }
      while(Li_FFE4 >= 0);
     }
   Li_FFE4 = 0;
   if(Li_FFA4 > 0)
     {
      do
        {
         if(OrderSelect(Li_FFA8[Li_FFE4], 1, 0))
           {
            Lb_FFDF = false;
            Li_FFE0 = 0;
            do
              {
               RefreshRates();
               ask_price = NormalizeDouble(Ask, _Digits);
               bid_price = NormalizeDouble(Bid, _Digits);
               stoplevel_price = (MarketInfo(_Symbol, MODE_STOPLEVEL) * _Point);
               spread_price_double = (MarketInfo(_Symbol, MODE_SPREAD) * _Point);
               if((stoplevel_price == 0))
                 {
                  stoplevel_price = NormalizeDouble((spread_price_double * 1.5), _Digits);
                 }
               spread_points = (int)MarketInfo(_Symbol, MODE_SPREAD);
               if(spread_points < 0)
                 {
                  spread_points = 0;
                 }
               if(IsTradeContextBusy())
                 {
                  Sleep(500);
                 }
               else
                 {
                  Ld_FFE8 = OrderClosePrice();
                  tmp_double_0 = OrderProfit();
                  tmp_double_0 = (tmp_double_0 + OrderSwap());
                  Ld_FFF8 = ((tmp_double_0 + OrderCommission()) + Ld_FFF8);
                  Li_FFF4 = OrderType();
                  if(OrderType() > OP_SELL)
                    {
                     Lb_FFDF = OrderDelete(Li_FFA8[Li_FFE4], 2139610);
                    }
                  else
                    {
                     Lb_FFDF = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), spread_points, 2139610);
                    }
                  if(Lb_FFDF != true)
                    {
                     Sleep(500);
                    }
                  else
                    {
                     if(fDraw)
                       {
                        DrawTradeMarkers(Ld_FFE8);
                       }
                    }
                  Li_FFE0 = Li_FFE0 + 1;
                 }
               if(Lb_FFDF)
                  break;
              }
            while(Li_FFE0 < 5);

            if(Lb_FFDF != true)
              {
               Ls0_str0000 = OrderSymbol();
               Print("F: ", "DEL_ALL_ORDER", "()  L: ", 1505, "  ", Ls0_str0000, ".  Failed close the order #", Li_FFA8[Li_FFE4], "  _LastError = ", GetLastError());
               manual_close_mode = Li_FFA0;
              }
           }
         Li_FFE4 = Li_FFE4 + 1;
        }
      while(Li_FFE4 < Li_FFA4);
     }
   if(fDraw)
     {
      Ls0_str0001 = obj_prefix + "Rez_";
      Ls0_str0002 = (string)TimeCurrent();
      Ls0_str0001 = Ls0_str0001 + Ls0_str0002;
      Ls_FF90 = Ls0_str0001;
      Ls0_str0002 = "$" + DoubleToString(Ld_FFF8, 2);
      DrawProfitLabel(Ls0_str0001, Time[0], Ld_FFE8, Ls0_str0002, Color_Fon_Metki, Li_FFF4);
     }
   ArrayFree(Li_FFA8);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool InitControlPanel()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls0_str0008;
   string Ls0_str0009;
   string Ls0_str000A;
   string Ls0_str000B;
   string Ls0_str000C;
   string Ls0_str000D;
   string Ls0_str000E;
   string Ls0_str000F;
   string Ls0_str0010;
   string Ls0_str0011;
   string Ls0_str0012;
   string Ls0_str0013;
   string Ls0_str0014;
   string Ls0_str0015;
   string Ls0_str0016;
   string Ls0_str0017;
   string Ls0_str0018;
   string Ls0_str0019;
   string Ls0_str001A;
   string Ls0_str001B;
   int Li_FFF8;
   string Ls_FFE8;
   int Li_FFE4;
   bool Lb_FFFF;
   int Li_FFE0;

   Li_FFF8 = 0;
   Ls_FFE8 = panel_name;
   Li_FFE4 = 0;
   SaveLoadConfig(1);
   tmp_int_2 = configArray.Total();
   if(tmp_int_2 == 0)
     {
      Print("---- Initial string initialization ----");
      Ls0_str0000 = IntegerToString(X1, 0, 32);
      label_buy_color = 1;
      label_buy_font_size = 0;
      configArray.Add(Ls0_str0000);

      Ls0_str0001 = IntegerToString(Y1, 0, 32);
      configArray.Add(Ls0_str0001);

      Ls0_str0002 = "1";
      configArray.Add(Ls0_str0002);

      Ls0_str0003 = (string)fTrBuy;
      configArray.Add(Ls0_str0003);

      Ls0_str0004 = (string)fTrSell;
      configArray.Add(Ls0_str0004);

      Ls0_str0005 = (string)iStart_H;
      configArray.Add(Ls0_str0005);

      Ls0_str0006 = (string)iEnd_H;
      configArray.Add(Ls0_str0006);

      Ls0_str0007 = (string)fNS;
      configArray.Add(Ls0_str0007);

      SaveLoadConfig(2);
     }
   else
     {
      Li_FFF8 = 0;
      config_total_items = configArray.Total();
      if(config_total_items > 0)
        {
         do
           {
            config_item_idx = Li_FFF8;

            Ls0_str0008 = configArray.At(config_item_idx);
            Print("i = ", Li_FFF8, "  Prop = ", Ls0_str0008);
            Li_FFF8 = Li_FFF8 + 1;
            line_tp_sell_color = configArray.Total();
           }
         while(Li_FFF8 < line_tp_sell_color);
        }

      Ls0_str0009 = configArray.At(0);
      X1 = (int)StringToInteger(Ls0_str0009);

      Ls0_str000A = configArray.At(1);
      Y1 = (int)StringToInteger(Ls0_str000A);

      Ls0_str000B = configArray.At(2);
      Li_FFE0 = (int)StringToInteger(Ls0_str000B);
      fTrBuy = true;

      Ls0_str000C = configArray.At(3);
      if(Ls0_str000C == "false")
        {
         fTrBuy = false;
        }
      fTrSell = true;
      Ls0_str000D = configArray.At(4);
      if(Ls0_str000D == "false")
        {
         fTrSell = false;
        }

      Ls0_str000E = configArray.At(5);
      iStart_H = (int)StringToInteger(Ls0_str000E);
      Ls0_str000F = configArray.At(6);
      iEnd_H = (int)StringToInteger(Ls0_str000F);
      fNS = true;
      Ls0_str0010 = configArray.At(7);
      if(Ls0_str0010 == "false")
        {
         fNS = false;
        }
     }
   ObjectCreate(0, Ls_FFE8, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 102, X1);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 103, Y1);
   panel_x_pos = X1;
   panel_y_pos = Y1;
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1019, 165);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1020, 245);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 6, 0);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1025, cCIP);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1035, cCB);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1000, 1);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 17, 0);
   edit_time_y = Y1 + 10;
   edit_time_x = X1 + 10;
   label_title_y = Y1 + 35;
   label_title_x = X1 + 5;
   Ls0_str0011 = obj_prefix + "LabTime";
   Ls0_str0012 = Ls0_str0011;

   if(timeEdit.Create(0, Ls0_str0012, 0, label_title_x, label_title_y, label_title_x + 155, label_title_y + 18))
     {
     }
   timeEdit.Text("平台时间: " + TimeToString(TimeCurrent(), 6));
   timeEdit.Color(cTimeTerminal);
   timeEdit.FontSize(FontSize);
   timeEdit.ColorBackground(cCIP);
   timeEdit.ColorBorder(cCIP);

   ObjectSetInteger(0,"ke_GSr_LabTime",OBJPROP_XDISTANCE,11);
   Ls0_str0011 = "";
   CreateEditLabel(0, Ls0_str0011, X1, Y1, 165, 30);
   Ls0_str0013 = "开始时间";
   CreateEditLabel(1, Ls0_str0013, (X1 + 5), (Y1 + 130), 75, 20);
   Ls0_str0014 = "结束时间";
   CreateEditLabel(2, Ls0_str0014, (X1 + 85), (Y1 + 130), 75, 20);
   Ls0_str0015 = "开始时间";
   CreateEditLabel(3, Ls0_str0015, (X1 + 5), (Y1 + 150), 75, 25);
   Ls0_str0016 = "结束时间";
   CreateEditLabel(4, Ls0_str0016, (X1 + 85), (Y1 + 150), 75, 25);
   label_buy_profit2_bg = false;
   text_tp_bg_color = 1;
   text_tp_corner = 16711680;
   text_tp_color = FontSize;
   Ls0_str0017 = "多单盈亏: 0";
   Gi_0059 = 0;
   Gi_005A = Y1 + 65;
   Gi_005B = X1 + 5;
   Ls0_str0018 = label_buy_profit_name;
   label_buy_profit2_chart_id = 0;
   if(ObjectFind(0, Ls0_str0018) == -1 && ObjectCreate(0, Ls0_str0018, OBJ_LABEL, 0, 0, 0) == false)
     {
      Print("DrawLabel", "Error: ", GetLastError());
     }
   else
     {
      ObjectSetInteger(label_buy_profit2_chart_id, Ls0_str0018, 102, Gi_005B);
      ObjectSetInteger(label_buy_profit2_chart_id, Ls0_str0018, 103, Gi_005A);
      ObjectSetInteger(label_buy_profit2_chart_id, Ls0_str0018, 101, Gi_0059);
      ObjectSetString(label_buy_profit2_chart_id, Ls0_str0018, 999, Ls0_str0017);
      ObjectSetInteger(label_buy_profit2_chart_id, Ls0_str0018, 100, text_tp_color);
      ObjectSetInteger(label_buy_profit2_chart_id, Ls0_str0018, 1011, text_tp_bg_color);
      ObjectSetInteger(label_buy_profit2_chart_id, Ls0_str0018, 6, text_tp_corner);
      ObjectSetInteger(label_buy_profit2_chart_id, Ls0_str0018, 1000, label_buy_profit2_bg);
     }
   Gb_005D = false;
   text_tp_sell_color = 1;
   Gi_005F = 16711680;
   Gi_0060 = FontSize;
   Ls0_str0019 = "空单盈亏: 0";
   Gi_0061 = 0;
   text_sl_bg_color = Y1 + 83;
   text_sl_corner = X1 + 5;
   Ls0_str001A = label_sell_profit_name;
   label_sell_profit2_chart_id = 0;
   if(ObjectFind(0, Ls0_str001A) == -1 && ObjectCreate(0, Ls0_str001A, OBJ_LABEL, 0, 0, 0) == false)
     {
      Print("DrawLabel", "Error: ", GetLastError());
     }
   else
     {
      ObjectSetInteger(label_sell_profit2_chart_id, Ls0_str001A, 102, text_sl_corner);
      ObjectSetInteger(label_sell_profit2_chart_id, Ls0_str001A, 103, text_sl_bg_color);
      ObjectSetInteger(label_sell_profit2_chart_id, Ls0_str001A, 101, Gi_0061);
      ObjectSetString(label_sell_profit2_chart_id, Ls0_str001A, 999, Ls0_str0019);
      ObjectSetInteger(label_sell_profit2_chart_id, Ls0_str001A, 100, Gi_0060);
      ObjectSetInteger(label_sell_profit2_chart_id, Ls0_str001A, 1011, text_tp_sell_color);
      ObjectSetInteger(label_sell_profit2_chart_id, Ls0_str001A, 6, Gi_005F);
      ObjectSetInteger(label_sell_profit2_chart_id, Ls0_str001A, 1000, Gb_005D);
     }
   if(fTrBuy)
     {
      Gi_0065 = cTrNSStr1;
     }
   else
     {
      Gi_0065 = cTrNSStr2;
     }
   CreateButton(btn_trade_buy_name, (X1 + 5), (Y1 + 100), 75, 25, "多单开关", Font, FontSize, 16777215, Gi_0065, 65535, false, false, false, true, 0, 0);
   if(fTrSell)
     {
      Gi_0067 = cTrNSStr1;
     }
   else
     {
      Gi_0067 = cTrNSStr2;
     }
   CreateButton(btn_trade_sell_name, (X1 + 85), (Y1 + 100), 75, 25, "空单开关", Font, FontSize, 16777215, Gi_0067, 65535, false, false, false, true, 0, 0);
   CreateButton(btn_close_buy_name, (X1 + 5), (Y1 + 185), 75, 25, "平仓多单", Font, FontSize, 16777215, cOpClBut, 65535, false, false, false, true, 0, 0);
   CreateButton(btn_close_sell_name, (X1 + 85), (Y1 + 185), 75, 25, "平仓空单", Font, FontSize, 16777215, cOpClBut, 65535, false, false, false, true, 0, 0);
   if(fNS)
     {
      btn_new_series_color = cTrNSStr1;
     }
   else
     {
      btn_new_series_color = cTrNSStr2;
     }
   CreateButton(btn_new_series_name, (X1 + 5), (Y1 + 215), 155, 25, "新批次", Font, FontSize, 16777215, btn_new_series_color, 65535, false, false, false, true, 0, 0);
   CreateButton(btn_open_buy_name, 5, 30, 65, 22, "开仓多单", Font, FontSize, 16777215, cOpClBut, 65535, false, false, false, true, 0, 2);
   CreateButton(btn_open_sell_name, 120, 30, 65, 22, "开仓空单", Font, FontSize, 16777215, cOpClBut, 65535, false, false, false, true, 0, 2);
   Ls0_str001B = edit_lot_name;
   CreateLotInputBox(Ls0_str001B, 70, 30, 50, 22);
   Lb_FFFF = true;
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateEditLabel(int Fa_i_00, string Fa_s_01, int Fa_i_02, int Fa_i_03, int Fa_i_04, int Fa_i_05)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls_FFF0;

   if(Fa_i_00 == 0)
     {
      Ls0_str0000 = obj_prefix + Fa_s_01;
      Ls0_str0000 = Ls0_str0000 + "edit";
      Ls0_str0000 = Ls0_str0000 + IntegerToString(Fa_i_00, 0, 32);
      Ls0_str0001 = Ls0_str0000;
      label_buy_anchor = Fa_i_05;
      label_buy_y = Fa_i_04;
      label_buy_x = Fa_i_03;
      panel_x_save = Fa_i_02;
      edit_start_hour_y = 0;

      if(editControls[Fa_i_00].Create(0, Ls0_str0001, 0, Fa_i_02, Fa_i_03, Fa_i_02 + Fa_i_04, Fa_i_03 + Fa_i_05))
        {
        }
      Ls0_str0002 = Fa_s_01;
      editControls[Fa_i_00].Text(Ls0_str0002);
      editControls[Fa_i_00].ColorBackground(16711680);
      editControls[Fa_i_00].ColorBorder(cCIP);
      editControls[Fa_i_00].Color(16777215);
      edit_end_hour_x = FontSize + 3;
      editControls[Fa_i_00].FontSize(edit_end_hour_x);
      edit_end_hour_x = 2;
      editControls[Fa_i_00].ZOrder(2);
      editControls[Fa_i_00].TextAlign(2);

      edit_readonly_flag = true;
      editControls[Fa_i_00].ReadOnly(true);
      editControls[Fa_i_00].Move(Fa_i_02, Fa_i_03);
     }
   if(Fa_i_00 == 1 || Fa_i_00 == 2)
     {

      Ls0_str0003 = obj_prefix + Fa_s_01;
      Ls0_str0003 = Ls0_str0003 + "edit";
      Ls0_str0003 = Ls0_str0003 + IntegerToString(Fa_i_00, 0, 32);
      Ls0_str0004 = Ls0_str0003;
      sell_ts_min_idx = Fa_i_05;
      Gi_0021 = Fa_i_04;
      Gi_0022 = Fa_i_03;
      line_noloss_color = Fa_i_02;
      line_noloss_style = 0;
      if(editControls[Fa_i_00].Create(0, Ls0_str0004, 0, Fa_i_02, Fa_i_03, Fa_i_02 + Fa_i_04, Fa_i_03 + Fa_i_05))
        {
        }
      Ls0_str0005 = Fa_s_01;
      editControls[Fa_i_00].Text(Ls0_str0005);
      editControls[Fa_i_00].ColorBackground(cCIP);
      editControls[Fa_i_00].ColorBorder(cCIP);
      editControls[Fa_i_00].Color(cCT);
      editControls[Fa_i_00].FontSize(FontSize);
      config_total_items = 2;
      editControls[Fa_i_00].ZOrder(2);
      editControls[Fa_i_00].TextAlign(2);
      editControls[Fa_i_00].ReadOnly(true);
      editControls[Fa_i_00].Move(Fa_i_02, Fa_i_03);
     }
   if(Fa_i_00 != 3 && Fa_i_00 != 4)
     {
      if(Fa_i_00 != 5)
         return;
     }
   Ls0_str0006 = obj_prefix + Fa_s_01;
   Ls0_str0006 = Ls0_str0006 + "_";
   Ls0_str0006 = Ls0_str0006 + IntegerToString(Fa_i_00, 0, 32);
   Ls0_str0007 = Ls0_str0006;
   line_sl_sell_color = Fa_i_05;
   line_sl_sell_style = Fa_i_04;
   Gi_003D = Fa_i_03;
   Gi_003E = Fa_i_02;
   Gi_003F = 0;
   if(editControls[Fa_i_00].Create(0, Ls0_str0007, 0, Fa_i_02, Fa_i_03, Fa_i_04 + Fa_i_02, Fa_i_05 + Fa_i_03))
     {
     }
   if(Fa_i_00 == 3)
     {
      Ls_FFF0 = (string)iStart_H;
     }
   if(Fa_i_00 == 4)
     {
      Ls_FFF0 = (string)iEnd_H;
     }
   if(Fa_i_00 == 5)
     {
      Ls_FFF0 = "";
     }
   editControls[Fa_i_00].Text(Ls_FFF0);
   editControls[Fa_i_00].ColorBackground(16777215);
   editControls[Fa_i_00].ColorBorder(cCIP);
   editControls[Fa_i_00].Color(cCT);
   editControls[Fa_i_00].FontSize(FontSize);
   Gi_0047 = 2;
   editControls[Fa_i_00].TextAlign(2);
   editControls[Fa_i_00].Move(Fa_i_02, Fa_i_03);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateLotInputBox(string Fa_s_00, int Fa_i_01, int Fa_i_02, int Fa_i_03, int Fa_i_04)
  {
   string Ls0_str0000;
   string Ls_FFF0;
   int Li_FFEC;

   Li_FFEC = (int)ChartGetInteger(0, 107, 0);
   tmp_int_0 = Li_FFEC - 31;
   Ls0_str0000 = Fa_s_00;
   if(lotEdit.Create(0, Ls0_str0000, 0, Fa_i_01, tmp_int_0, Fa_i_03 + Fa_i_01, Fa_i_04 + tmp_int_0))
     {
     }
   Ls_FFF0 = DoubleToString(MarketInfo(_Symbol, MODE_MINLOT), 2);
   lotEdit.Text(Ls_FFF0);
   lotEdit.ColorBackground(16777215);
   lotEdit.ColorBorder(15631086);
   lotEdit.Color(cCT);
   lotEdit.FontSize(FontSize);
   lotEdit.TextAlign(2);
   lotEdit.Move(Fa_i_01, tmp_int_0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SaveLoadConfig(int Fa_i_00)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls_FFF0;
   int Li_FFEC;
   bool Lb_FFFF;
   int Li_FFE8;

   Ls0_str0000 = _Symbol + "_";
   Ls0_str0001 = (string)Magic;
   Ls0_str0000 = Ls0_str0000 + Ls0_str0001;
   Ls0_str0000 = Ls0_str0000 + "_GoldStuff_";
   Ls0_str0000 = Ls0_str0000 + config_version;
   Ls0_str0000 = Ls0_str0000 + ".bin";
   Ls_FFF0 = Ls0_str0000;
   if(Fa_i_00 == 1)
     {
      Li_FFEC = FileOpen(Ls_FFF0, 37);
      if(Li_FFEC >= 0)
        {
         tmp_int_0 = Li_FFEC;
         tmp_int_2 = 0;
         label_buy_corner = 0;
         label_buy_color = 0;
         config_load_result = configArray.Load(Li_FFEC);

         if(config_load_result != true)
           {
            PrintFormat("File %s read: Error %d!", Ls_FFF0, GetLastError());
            FileClose(Li_FFEC);
            Lb_FFFF = false;
            return Lb_FFFF;
           }
         FileClose(Li_FFEC);
         Lb_FFFF = true;
         return Lb_FFFF;
        }
     }
   if(Fa_i_00 != 2)
      return false;
   Li_FFE8 = FileOpen(Ls_FFF0, 38);
   if(Li_FFE8 < 0)
      return false;
   label_buy_x = Li_FFE8;
   edit_start_hour_y = 0;
   label_sell_corner = 0;

   config_load_result2 = configArray.Load(Li_FFE8);
   if(config_load_result2 != true)
     {
      PrintFormat("File %s read: Error %d!", Ls_FFF0, GetLastError());
      FileClose(Li_FFE8);
      Lb_FFFF = true;
      return Lb_FFFF;
     }
   FileClose(Li_FFE8);

   Lb_FFFF = false;

   return Lb_FFFF;
  }

int  ISTart =1400;
int IStop = 100;

//+------------------------------------------------------------------+
int iMaxS; // Max spread (0 - not use)
int iStart_H; // Start Hour
int iEnd_H; // End Hour
bool fDraw = true; // Draw on-off
string Font_Metki = "Verdana"; // Font Result
int Size_Metki = 14; // Font size Result
color ColorText_Metki = White; // Font color Result
color Color_Fon_Metki = Green; // Background color Result
int MinuteStop; // Pause between orders (min. 0 - not use)

ENUM_TIMEFRAMES TF = PERIOD_CURRENT;
int Deviation = 2;
int X1 = 10;
int Y1 = 100;
color cCIP = Gainsboro; // Info panel background color
color cCB = DarkGray; // Border color
color cCT = DimGray; // Border text color
color cOpClBut = DarkOrchid; // Button Open, Close color
color cTrNSStr1 = Green; // Button On: Trade and 新批次 color
color cTrNSStr2 = Red; // Button Off: Trade and 新批次 color
color cTimeTerminal = Blue; // 平台时间
string Font = "Arial";
int FontSize = 10;
bool fA_MM=0; // Use Money Management
int iAuLot = 1000; // Autolot. Free margin for each 0.01 Lots

bool fNS = true; // Open new series
bool fTrBuy = true; // 多单开关
bool fTrSell = true; // 空单开关
bool fHO = true; // Support manual orders
int loc_x02152in,loc_x02152ax,loc_x02152ax2;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FindMostProfitableOrder(int t,int MagicNumber)
  {
   bool b=0;
   loc_x02152ax=0;
   double l_ord_open_price_8=0;
   double l_ticket_24=0;

   double l_ticket_20=-999999;
   for(int l_pos_16=OrdersTotal()-1; l_pos_16>=0; l_pos_16--)
     {
      b=OrderSelect(l_pos_16,SELECT_BY_POS,MODE_TRADES);

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==t)
        {
         l_ticket_24=OrderProfit();
         if(l_ticket_24>l_ticket_20)
           {
            l_ord_open_price_8=OrderProfit();
            loc_x02152ax=OrderTicket();
            l_ticket_20 = l_ticket_24;
           }
        }
     }
   return (l_ord_open_price_8);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FindSecondMostProfitableOrder(int t,int MagicNumber)
  {
   bool b=0;
   loc_x02152ax2=0;
   double l_ord_open_price_8=0;
   double l_ticket_24=0;

   double l_ticket_20=-99990;
   for(int l_pos_16=OrdersTotal()-1; l_pos_16>=0; l_pos_16--)
     {
      b=OrderSelect(l_pos_16,SELECT_BY_POS,MODE_TRADES);
      if(OrderTicket()!=loc_x02152ax)
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==t)
           {
            l_ticket_24=OrderProfit();
            if(l_ticket_24>l_ticket_20)
              {
               l_ord_open_price_8=OrderProfit();
               loc_x02152ax2=OrderTicket();
               l_ticket_20 = l_ticket_24;
              }
           }
     }
   return (l_ord_open_price_8);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FindLeastProfitableOrder(int t,int MagicNumber)
  {
   bool b=0;
   loc_x02152in=0;
   double l_ord_open_price_8=0;
   double l_ticket_24=0;

   double l_ticket_20=EMPTY_VALUE;
   for(int l_pos_16=OrdersTotal()-1; l_pos_16>=0; l_pos_16--)
     {
      b=OrderSelect(l_pos_16,SELECT_BY_POS,MODE_TRADES);

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==t)
        {
         l_ticket_24=OrderProfit();
         if(l_ticket_24<l_ticket_20)
           {
            l_ord_open_price_8=OrderProfit();
            loc_x02152in=OrderTicket();
            l_ticket_20 = l_ticket_24;
           }
        }
     }
   return (l_ord_open_price_8);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int chexk()
  {
   return 1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeletePendingOrdersByType(int t)
  {
   RefreshRates();
   for(int i=OrdersTotal() -1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
        }
      else
        {
         continue;
        }

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        {

         if(OrderType()==t)
            bool b=OrderDelete(OrderTicket());

        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CloseOrderByTicketSimple(int tik)
  {
   bool li_0=0;
   bool li_4=0;
   for(int li_81=0; li_81<15; li_81++)
      for(int li_8=0; li_8<OrdersTotal(); li_8++)
        {
         RefreshRates();
         li_0=OrderSelect(li_8,SELECT_BY_POS,MODE_TRADES);
         if(li_0)
           {
            if(OrderTicket()==tik)
              {
               if(OrderType()<2)
                 {
                  li_4=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,clrNONE);

                  if(li_4>0)
                     break;
                 }

              }
           }
        }

   return li_4;
  }
//|                                                                  |
//+------------------------------------------------------------------+
void DrawTradeMarkers2(double Fa_d_00)
  {
   string tmp_str0000;
   string tmp_str0001;
   string tmp_str0002;
   string tmp_str0003;
   double Ld_FFF8;
   string Ls_FFE8;
   double Ld_FF90;
   int Li_FF8C;
   long Ll_FF80;
   long Ll_FF78;
   int Li_FF74;
   Ld_FFF8 = 0;
   int Li_FFD0[6] = { 16711680, 255, 16711680, 255, 16711680, 255 };
   Ld_FF90 = 0;
   Li_FF8C = OrderTicket();
   Ll_FF80 = 0;
   Ll_FF78 = 0;
   Ld_FF90 = OrderOpenPrice();
   Ll_FF78 = Time[0];
   Ll_FF80 = OrderOpenTime();
   Li_FF74 = OrderType();
   tmp_str0000 = obj_prefix + "Ord_";
   tmp_str0001 = (string)Li_FF8C;
   tmp_str0000 = tmp_str0000 + tmp_str0001;
   Ls_FFE8 = tmp_str0000;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      ObjectCreate(0, Ls_FFE8, OBJ_ARROW, 0, Ll_FF80, Ld_FF90, 0, 0, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_ARROWCODE, 1);
      tmp_int_2 = Li_FFD0[Li_FF74];
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, tmp_int_2);
     }
   tmp_str0001 = obj_prefix + "Close_";
   tmp_str0002 = (string)Li_FF8C;
   tmp_str0001 = tmp_str0001 + tmp_str0002;
   Ls_FFE8 = tmp_str0001;
   Ld_FFF8 = Fa_d_00;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      ObjectCreate(0, Ls_FFE8, OBJ_ARROW, 0, Ll_FF78, Fa_d_00, 0, 0, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_ARROWCODE, 3);
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, 2139610);
     }
   tmp_str0002 = obj_prefix + "Ord_Line_";
   tmp_str0003 = (string)Li_FF8C;
   tmp_str0002 = tmp_str0002 + tmp_str0003;
   Ls_FFE8 = tmp_str0002;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      //  ObjectCreate(0, Ls_FFE8, OBJ_TREND, 0, Ll_FF80, Ld_FF90, Ll_FF78, Ld_FFF8, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_RAY, 0);
      ObjectSet(Ls_FFE8, OBJPROP_STYLE, 2);
      label_buy_corner = Li_FFD0[Li_FF74];
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, label_buy_corner);
     }
   ArrayFree(Li_FFD0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double DummyCloseOrder(int Fa_i_00)
  {

   return 0;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HedgeCloseFirstLast2()
  {
   int ReductionOrderNumber = 4; //
   int ReductionPercent = 3; //

   string tmp_str0000;
   string tmp_str0001;
   string tmp_str0002;
   string tmp_str0003;
   double Ld_FFF8;
   double Ld_FFF0;
   int Li_FFEC;
   int Li_FFE8;
   double Ld_FFE0;
   double Ld_FFD8;
   int Li_FFD4;
   int Li_FFD0;
   int Li_FFCC;
   int Li_FFC8;
   long Ll_FFC0;
   long Ll_FFB8;
   long Ll_FFB0;
   long Ll_FFA8;
   int Li_FFA4;
   double Ld_FF98;
   bool Lb_FF97;
   int Li_FF90;
   double Ld_FF88;
   string Ls_FF78;
   string Ls_FF68;
   Ld_FFF8 = 0;
   Ld_FFF0 = 0;
   Li_FFEC = 0;
   Li_FFE8 = 0;
   Ld_FFE0 = 0;
   Ld_FFD8 = 0;
   Li_FFD4 = 0;
   Li_FFD0 = 0;
   Li_FFCC = 0;
   Li_FFC8 = 0;
   Ll_FFC0 = TimeCurrent();
   Ll_FFB8 = 0;
   Ll_FFB0 = TimeCurrent();
   Ll_FFA8 = 0;
   Li_FFA4 = 0;
   if(OrdersTotal() > 0)
     {
      do
        {
         if(OrderSelect(Li_FFA4, 0, 0))
           {
            if(OrderMagicNumber() == Magic || (OrderMagicNumber() == 0 && fHO))
              {
               if(OrderSymbol() == _Symbol)
                 {
                  if(OrderType() == OP_BUY)
                    {
                     Li_FFCC = Li_FFCC + 1;
                     if(OrderOpenTime() <= Ll_FFC0)
                       {
                        Ll_FFC0 = OrderOpenTime();
                        buy_profit_tmp = OrderProfit();
                        buy_profit_tmp = (buy_profit_tmp + OrderSwap());
                        Ld_FFF8 = (buy_profit_tmp + OrderCommission());
                        Li_FFEC = OrderTicket();
                       }
                     if(OrderOpenTime() >= Ll_FFB8)
                       {
                        Ll_FFB8 = OrderOpenTime();
                        buy_profit_tmp = OrderProfit();
                        buy_profit_tmp = (buy_profit_tmp + OrderSwap());
                        Ld_FFF0 = (buy_profit_tmp + OrderCommission());
                        Li_FFE8 = OrderTicket();
                       }
                    }
                  if(OrderType() == OP_SELL)
                    {
                     Li_FFC8 = Li_FFC8 + 1;
                     if(OrderOpenTime() <= Ll_FFB0)
                       {
                        Ll_FFB0 = OrderOpenTime();
                        buy_profit_tmp = OrderProfit();
                        buy_profit_tmp = (buy_profit_tmp + OrderSwap());
                        Ld_FFE0 = (buy_profit_tmp + OrderCommission());
                        Li_FFD4 = OrderTicket();
                       }
                     if(OrderOpenTime() >= Ll_FFA8)
                       {
                        Ll_FFA8 = OrderOpenTime();
                        buy_profit_tmp = OrderProfit();
                        buy_profit_tmp = (buy_profit_tmp + OrderSwap());
                        Ld_FFD8 = (buy_profit_tmp + OrderCommission());
                        Li_FFD0 = OrderTicket();
                       }
                    }
                 }
              }
           }
         Li_FFA4 = Li_FFA4 + 1;
        }
      while(Li_FFA4 < OrdersTotal());
     }
   Ld_FF98 = 0;
   Lb_FF97 = false;
   Li_FF90 = -1;
   Ld_FF88 = -1;
   if(Li_FFCC >= ReductionOrderNumber && Reduction == true && (Ld_FFF0 > 0))
     {
      buy_profit_tmp = -Ld_FFF8;
      tmp_int_1 = ReductionPercent + 100;
      if((Ld_FFF0 >= ((buy_profit_tmp * tmp_int_1) / 100)))
        {
         Print("Close overlap last order, ticket first order: ", Li_FFEC, " profit first order: ", Ld_FFF8, " ticket last order: ", Li_FFE8, " profit last order: ", Ld_FFF0, " Bid: ", Bid, " Ask: ", Ask);
         Lb_FF97 = OrderSelect(Li_FFE8, 1, 0);
         Li_FF90 = OrderType();
         Gd_0001 = OrderProfit();
         Gd_0001 = (Gd_0001 + OrderSwap());
         Ld_FF98 = (Gd_0001 + OrderCommission());
         Ld_FF88 = DummyCloseOrder(OrderTicket());
         if((Ld_FF88 != -1) && fDraw)
           {
            DrawTradeMarkers2(Ld_FF88);
           }
         Lb_FF97 = OrderSelect(Li_FFEC, 1, 0);
         Gd_0001 = OrderProfit();
         Gd_0001 = (Gd_0001 + OrderSwap());
         Ld_FF98 = ((Gd_0001 + OrderCommission()) + Ld_FF98);
         Ld_FF88 = DummyCloseOrder(OrderTicket());
         if((Ld_FF88 != -1) && fDraw)
           {
            DrawTradeMarkers2(Ld_FF88);
           }
         if(fDraw)
           {
            tmp_str0000 = obj_prefix + "Rez_";
            tmp_str0001 = (string)TimeCurrent();
            tmp_str0000 = tmp_str0000 + tmp_str0001;
            Ls_FF78 = tmp_str0000;
            tmp_str0001 = "$" + DoubleToString(Ld_FF98, 2);
           }
        }
     }
   if(Li_FFC8 < ReductionOrderNumber)
      return;
   if(Reduction != true)
      return;
   if((Ld_FFD8 <= 0))
      return;
   tmp_double_0 = -Ld_FFE0;
   label_buy_corner = ReductionPercent + 100;
   if((Ld_FFD8 < ((tmp_double_0 * label_buy_corner) / 100)))
      return;
   Print("Close overlap last order, ticket first order: ", Li_FFD4, " profit first order: ", Ld_FFE0, " ticket last order: ", Li_FFD0, " profit last order: ", Ld_FFD8, " Bid: ", Bid, " Ask: ", Ask);
   Lb_FF97 = OrderSelect(Li_FFD0, 1, 0);
   Li_FF90 = OrderType();
   indicator_band1 = OrderProfit();
   indicator_band1 = (indicator_band1 + OrderSwap());
   Ld_FF98 = ((indicator_band1 + OrderCommission()) + Ld_FF98);
   Ld_FF88 = DummyCloseOrder(OrderTicket());
   if((Ld_FF88 != -1) && fDraw)
     {
      DrawTradeMarkers2(Ld_FF88);
     }
   Lb_FF97 = OrderSelect(Li_FFD4, 1, 0);
   indicator_band1 = OrderProfit();
   indicator_band1 = (indicator_band1 + OrderSwap());
   Ld_FF98 = ((indicator_band1 + OrderCommission()) + Ld_FF98);
   Ld_FF88 = DummyCloseOrder(OrderTicket());
   if((Ld_FF88 != -1) && fDraw)
     {
      DrawTradeMarkers2(Ld_FF88);
     }
   if(fDraw == false)
      return;
   tmp_str0002 = obj_prefix + "Rez_";
   tmp_str0003 = (string)TimeCurrent();
   tmp_str0002 = tmp_str0002 + tmp_str0003;
   Ls_FF68 = tmp_str0002;
   tmp_str0003 = "$" + DoubleToString(Ld_FF98, 2);
  }
//+-------------------------------

double GOl_Dopf0212=2;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HedgeCloseFirstLast()
  {

   loc_x02152in=0;
   loc_x02152ax=0;
   loc_x02152ax2=0;

   double ppf=FindMostProfitableOrder(0,Magic)+FindLeastProfitableOrder(0,Magic);
   if(ppf>GOl_Dopf0212)
     {

      CloseOrderByTicketSimple(loc_x02152ax);
      CloseOrderByTicketSimple(loc_x02152in);
     }

   double ppf1=FindMostProfitableOrder(1,Magic)+FindLeastProfitableOrder(1,Magic);
   if(ppf1>GOl_Dopf0212)
     {

      CloseOrderByTicketSimple(loc_x02152ax);
      CloseOrderByTicketSimple(loc_x02152in);
     }

   ppf=FindMostProfitableOrder(0,Magic)+FindLeastProfitableOrder(0,Magic)+FindSecondMostProfitableOrder(0,Magic);
   if(ppf>GOl_Dopf0212)
     {

      CloseOrderByTicketSimple(loc_x02152ax);
      CloseOrderByTicketSimple(loc_x02152ax2);
      CloseOrderByTicketSimple(loc_x02152in);
     }

   ppf1=FindMostProfitableOrder(1,Magic)+FindLeastProfitableOrder(1,Magic)+FindSecondMostProfitableOrder(1,Magic);
   if(ppf1>GOl_Dopf0212)
     {

      CloseOrderByTicketSimple(loc_x02152ax);
      CloseOrderByTicketSimple(loc_x02152ax2);
      CloseOrderByTicketSimple(loc_x02152in);
     }

  }

//+------------------------------------------------------------------+
void AdjustPendingOrderPrices()  //
  {
   double li_16;
   int ai_0=iDist;
   double order_stoploss_20;
   double points=Point;
   if(1)
     {
      for(int pos_36 = OrdersTotal() - 1; pos_36 >= 0; pos_36--)
        {
         if(OrderSelect(pos_36, SELECT_BY_POS, MODE_TRADES))
           {

            if(OrderSymbol() == Symbol() && OrderMagicNumber()==Magic)
              {
               if(OrderType() == OP_BUYSTOP)
                 {
                  li_16 = NormalizeDouble((OrderOpenPrice() -Bid) / points, 0);
                  if(li_16 < ai_0)
                     continue;

                  order_stoploss_20 = OrderStopLoss();

                  int  a021=OrderModify(OrderTicket(), Bid+iDist*points, 0, 0, 0, clrNONE);
                 }
               if(OrderType() == OP_SELLSTOP)
                 {
                  li_16 = NormalizeDouble((Ask-OrderOpenPrice()) / points, 0);
                  if(li_16 < ai_0)
                     continue;

                  order_stoploss_20 = OrderStopLoss();

                  int  a021=     OrderModify(OrderTicket(),  Ask-iDist*points, 0, 0, 0, clrNONE);
                 }
              }

           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawTradeMarkers(double Fa_d_00)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   double Ld_FFF8;
   string Ls_FFE8;
   double Ld_FF90;
   int Li_FF8C;
   long Ll_FF80;
   long Ll_FF78;
   int Li_FF74;

   Ld_FFF8 = 0;
   int Li_FFD0[6] = { 16711680, 255, 16711680, 255, 16711680, 255 };
   Ld_FF90 = 0;
   Li_FF8C = OrderTicket();
   Ll_FF80 = 0;
   Ll_FF78 = 0;
   Ld_FF90 = OrderOpenPrice();
   Ll_FF78 = Time[0];
   Ll_FF80 = OrderOpenTime();
   Li_FF74 = OrderType();
   Ls0_str0000 = obj_prefix + "Ord_";
   Ls0_str0001 = (string)Li_FF8C;
   Ls0_str0000 = Ls0_str0000 + Ls0_str0001;
   Ls_FFE8 = Ls0_str0000;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      ObjectCreate(0, Ls_FFE8, OBJ_ARROW, 0, Ll_FF80, Ld_FF90, 0, 0, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_ARROWCODE, 1);
      tmp_int_2 = Li_FFD0[Li_FF74];
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, tmp_int_2);
     }
   Ls0_str0001 = obj_prefix + "Close_";
   Ls0_str0002 = (string)Li_FF8C;
   Ls0_str0001 = Ls0_str0001 + Ls0_str0002;
   Ls_FFE8 = Ls0_str0001;
   Ld_FFF8 = Fa_d_00;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      ObjectCreate(0, Ls_FFE8, OBJ_ARROW, 0, Ll_FF78, Fa_d_00, 0, 0, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_ARROWCODE, 3);
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, 2139610);
     }
   Ls0_str0002 = obj_prefix + "Ord_Line_";
   Ls0_str0003 = (string)Li_FF8C;
   Ls0_str0002 = Ls0_str0002 + Ls0_str0003;
   Ls_FFE8 = Ls0_str0002;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      //  ObjectCreate(0, Ls_FFE8, OBJ_TREND, 0, Ll_FF80, Ld_FF90, Ll_FF78, Ld_FFF8, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_RAY, 0);
      ObjectSet(Ls_FFE8, OBJPROP_STYLE, 2);
      label_buy_corner = Li_FFD0[Li_FF74];
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, label_buy_corner);
     }
   ArrayFree(Li_FFD0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawProfitLabel(string Fa_s_00, long Fa_l_01, double Fa_d_02, string Fa_s_03, color  arg4, int Fa_i_05)
  {
   string Ls0_str0002;
   string Ls0_str0004;
   CCanvas Local_Pointer_FFFFFF68;
   int Li_FF64;
   int Li_FF60;
   bool Lb_FF5F;
   int Li_FF58;
   int Li_FF54;
   int Li_FF50;
   int Li_FF4C;
   int Li_FF48;

   Li_FF64 = 2;
   Li_FF60 = 18;
   Lb_FF5F = false;
   Li_FF58 = 0;
   if(Fa_i_05 == 0)
     {
      Fa_d_02 = ((Ask - Bid) + Fa_d_02);
      Li_FF58 = 2;
     }
   else
     {
      buy_profit_tmp = (Ask - Bid);
      Fa_d_02 = (Fa_d_02 - buy_profit_tmp);
     }
   Local_Pointer_FFFFFF68.FontNameSet(Font_Metki);
   Local_Pointer_FFFFFF68.FontFlagsSet(7);
   Local_Pointer_FFFFFF68.FontSizeSet(Size_Metki);
   tmp_int_0 = 0;
   tmp_int_1 = 0;
   Local_Pointer_FFFFFF68.TextSize(Fa_s_03, tmp_int_0, tmp_int_1);

   label_buy_corner = Li_FF64 * 2;
   Li_FF54 = tmp_int_0 + label_buy_corner;
   Li_FF50 = 0;
   Li_FF4C = 0;
   Li_FF48 = 0;
   ChartTimePriceToXY(0, 0, Fa_l_01, Fa_d_02, Li_FF50, Li_FF4C);
   Li_FF50 = Li_FF50 - Li_FF54;
   ChartXYToTimePrice(0, Li_FF50, Li_FF4C, Li_FF48, Fa_l_01, Fa_d_02);
   Ls0_str0002 = Fa_s_00;

//Local_Pointer_FFFFFF68.CreateBitmap(0, 0, Ls0_str0002, Fa_l_01, Fa_d_02, Li_FF54, Li_FF60, 0);
   Local_Pointer_FFFFFF68.Erase(arg4);
   Local_Pointer_FFFFFF68.TextOut((Li_FF54 / 2), (Li_FF60 / 2), Fa_s_03, ColorText_Metki, 5);

   ObjectSetInteger(0, Fa_s_00, 1000, 1);
   Ls0_str0004 = StringConcatenate("Profit: ", Fa_s_03);
   ObjectSetString(0, Fa_s_00, 206, Ls0_str0004);
   ObjectSetInteger(0, Fa_s_00, 1011, Li_FF58);
   Local_Pointer_FFFFFF68.Update(true);

  }

//+------------------------------------------------------------------+
