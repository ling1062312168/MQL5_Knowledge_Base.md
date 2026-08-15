#property copyright "Quantum Queen MT5"
#property version   "4.3"
#property strict

#include <Trade/Trade.mqh>

enum QQ_LOT_MODE
  {
   QQ_LOT_AUTOMATIC=0,         // 自动
   QQ_LOT_FIXED=1,             // 固定
   QQ_LOT_FIXED_PER_BALANCE=2  // 按余额固定
  };

enum QQ_RISK_LEVEL
  {
   QQ_RISK_VERY_LOW=0,     // 极低
   QQ_RISK_LOW=1,          // 低
   QQ_RISK_LOW_MEDIUM=2,   // 低-中
   QQ_RISK_MEDIUM=3,       // 中
   QQ_RISK_MEDIUM_HIGH=4,  // 中-高
   QQ_RISK_HIGH=5,         // 高
   QQ_RISK_VERY_HIGH=6     // 极高
  };

enum QQ_PRESET
  {
   QQ_PRESET_ICVT_HIGH=0,      // IC Markets/VT Markets (RAW) - 高风险
   QQ_PRESET_ICVT_MEDIUM=1,    // IC Markets/VT Markets (RAW) - 中风险
   QQ_PRESET_ICVT_LOW=2,       // IC Markets/VT Markets (RAW) - 低风险
   QQ_PRESET_ROBO_ECN=3,       // RoboForex - ECN
   QQ_PRESET_FUSION_ZERO=4,    // Fusion Markets - Zero
   QQ_PRESET_CUSTOM=5          // 自定义
  };

enum QQ_DD_MODE
  {
   QQ_DD_OFF=0,               // 关闭
   QQ_DD_PERCENT_CONTINUE=1,  // [百分比] 平仓后继续
   QQ_DD_PERCENT_REMOVE=2,    // [百分比] 平仓后移除
   QQ_DD_PERCENT_ALERT=3,     // [百分比] 终端告警
   QQ_DD_MONEY_CONTINUE=4,    // [金额] 平仓后继续
   QQ_DD_MONEY_REMOVE=5,      // [金额] 平仓后移除
   QQ_DD_MONEY_ALERT=6        // [金额] 终端告警
  };

enum QQ_DIRECTION_MODE
  {
   QQ_DIRECTION_BUY_ONLY=0,     // 仅做多
   QQ_DIRECTION_SELL_ONLY=1,    // 仅做空
   QQ_DIRECTION_PER_STRATEGY=2  // 多空均可
  };

enum QQ_BINARY_OPTION
  {
   QQ_OPTION_ON=0,   // 开启
   QQ_OPTION_OFF=1   // 关闭
  };

enum QQ_HOUR_OF_DAY
  {
   QQ_HOUR_00=0,   // 00:00
   QQ_HOUR_01=1,   // 01:00
   QQ_HOUR_02=2,   // 02:00
   QQ_HOUR_03=3,   // 03:00
   QQ_HOUR_04=4,   // 04:00
   QQ_HOUR_05=5,   // 05:00
   QQ_HOUR_06=6,   // 06:00
   QQ_HOUR_07=7,   // 07:00
   QQ_HOUR_08=8,   // 08:00
   QQ_HOUR_09=9,   // 09:00
   QQ_HOUR_10=10,  // 10:00
   QQ_HOUR_11=11,  // 11:00
   QQ_HOUR_12=12,  // 12:00
   QQ_HOUR_13=13,  // 13:00
   QQ_HOUR_14=14,  // 14:00
   QQ_HOUR_15=15,  // 15:00
   QQ_HOUR_16=16,  // 16:00
   QQ_HOUR_17=17,  // 17:00
   QQ_HOUR_18=18,  // 18:00
   QQ_HOUR_19=19,  // 19:00
   QQ_HOUR_20=20,  // 20:00
   QQ_HOUR_21=21,  // 21:00
   QQ_HOUR_22=22,  // 22:00
   QQ_HOUR_23=23   // 23:00
  };

input string            YoLic_LicenseKey=""; // 授权码
input string            InpNoteName="Quantum Queen MT5 v4.3 (22/07/2026)"; // 名称：
input string            InpNoteOverview="Quantum Queen X V4.3"; // 概述：
input string            InpNoteWebsite=""; // 网站：
input group ">>>> 通用设置"
input QQ_BINARY_OPTION  InpPause=QQ_OPTION_OFF; // 启动后先暂停
input QQ_LOT_MODE       InpLotsCalc=QQ_LOT_AUTOMATIC; // 仓位计算方式
input QQ_RISK_LEVEL     InpAutoLotsValue=QQ_RISK_MEDIUM; // 自动手数风险等级
input double            InpLotsFixed=0.01; // 固定
input double            InpLotsFixedBalance=500.0; // 按余额固定
input int               InpOrdersMax=100; // 最大订单数
input QQ_DD_MODE        InpDDMode=QQ_DD_OFF; // 回撤控制模式
input double            InpDDValue=0.0; // 回撤阈值
input QQ_BINARY_OPTION  InpMQID=QQ_OPTION_OFF; // MQID 推送通知
input long              InpMagicNumber=1234; // 魔术数字
input int               InpSpread=100; // 最大点差（点）
input int               InpSlippage=100; // 最大滑点（点）
input string            InpTradeCommentRaw="QQX"; // 交易备注
input QQ_DIRECTION_MODE InpTradingDirectionType=QQ_DIRECTION_PER_STRATEGY; // 交易方向类型

input group ">>>> 组合与策略"
input QQ_PRESET         InpSets=QQ_PRESET_ICVT_HIGH; // 组合选择
input QQ_BINARY_OPTION  InpS01Strategy=QQ_OPTION_ON; // 策略 1
input QQ_BINARY_OPTION  InpS02Strategy=QQ_OPTION_ON; // 策略 2
input QQ_BINARY_OPTION  InpS03Strategy=QQ_OPTION_ON; // 策略 3
input QQ_BINARY_OPTION  InpS04Strategy=QQ_OPTION_ON; // 策略 4
input QQ_BINARY_OPTION  InpS05Strategy=QQ_OPTION_ON; // 策略 5
input QQ_BINARY_OPTION  InpS06Strategy=QQ_OPTION_ON; // 策略 6
input QQ_BINARY_OPTION  InpS07Strategy=QQ_OPTION_OFF; // 策略 7
input QQ_BINARY_OPTION  InpS08Strategy=QQ_OPTION_ON; // 策略 8
input QQ_BINARY_OPTION  InpS09Strategy=QQ_OPTION_ON; // 策略 9
input QQ_BINARY_OPTION  InpS10Strategy=QQ_OPTION_ON; // 策略 10
input QQ_BINARY_OPTION  InpS12Strategy=QQ_OPTION_ON; // 策略 12

input group ">>> 交易日"
input bool              InpUseNfpFridayFilter=true; // NFP周五不进场
input bool              InpTradingFridayNight=true; // 周五夜盘关闭
input QQ_HOUR_OF_DAY    InpTradingFridayNightHour=QQ_HOUR_22; // 周五夜盘关闭时段
input bool              InpUseYearEndPause=false; // 年底停盘（12月15日-1月15日）
input bool              InpTradeOnMonday=true; // 周一交易
input bool              InpTradeOnTuesday=true; // 周二交易
input bool              InpTradeOnWednesday=true; // 周三交易
input bool              InpTradeOnThursday=true; // 周四交易
input bool              InpTradeOnFriday=true; // 周五交易
input bool              InpTradeOnSaturday=true; // 周六交易
input bool              InpTradeOnSunday=true; // 周日交易

input group ">>>> 面板与显示设置"
input QQ_BINARY_OPTION  InpPanel=QQ_OPTION_ON; // 显示面板
input string            InpFont="Trebuchet MS"; // 面板字体
input int               InpFontSize=8; // 字号
input string            InpComment="Quantum Queen MT5"; // 面板注释
input ENUM_LINE_STYLE   InpLineStyle=STYLE_SOLID; // 线条样式
input int               InpLineWidth=2; // 线条宽度
input color             InpTPColor=clrLime; // 止盈线颜色
input color             InpBEColor=clrWhite; // BE线颜色
input color             InpGridColor=clrYellow; // 网格线颜色

static const string QQ_NAME="Quantum Queen MT5 v4.3 (22/07/2026)";
static const string QQ_OVERVIEW="Quantum Queen 交易核心功能重建版";
static const string QQ_WEBSITE="Quantum Queen MT5";
static const string QQ_TRIAL_FILE="quantum_queen_x_mt5_42_14d_b.dat";
static const string QQ_LICENSE_PREFIX="YL_quantum_queen_x_mt5_42_14d_";
static const long   QQ_TRIAL_SECONDS=1209600;
static const string QQ_PANEL_PREFIX="QQX_";
static const int    QQ_STRATEGY_COUNT=12;

CTrade g_trade;
bool   g_authorized=false;
bool   g_trial_expired=false;
bool   g_license_invalid=false;
bool   g_paused=false;
bool   g_fail_closed_logged=false;
bool   g_remove_after_risk=false;
bool   g_panel_collapsed=false;
string g_dialog_prefix="";
bool   g_drawdown_triggered=false;
datetime g_trial_start=0;
datetime g_trial_end=0;
datetime g_last_auth_check=0;
datetime g_last_panel_update=0;
long   g_last_bar_time[12];
datetime g_last_manage_bar[12];
double g_basket_target_price[12];
int    g_basket_target_count[12];
int    g_demarker_a[12];
int    g_demarker_b[12];

string StrategyTag(const int slot)
  {
   static string tags[12]=
     {
      "[T1/策略1]","[T1/策略2]","[T2/策略3]","[T2/策略4]",
      "[T3/策略5]","[T3/策略6]","[T4/策略7]","[T4/策略8]",
      "[T5/策略9]","[T5/策略10]","[T6/策略11]","[T6/策略12]"
     };
   if(slot<0 || slot>=QQ_STRATEGY_COUNT)
      return "[策略 ?]";
   return tags[slot];
  }

bool StrategyEnabled(const int slot)
  {
   if(InpSets==QQ_PRESET_CUSTOM)
     {
      switch(slot)
        {
         case 0:  return InpS01Strategy==QQ_OPTION_ON;
         case 1:  return InpS02Strategy==QQ_OPTION_ON;
         case 2:  return InpS03Strategy==QQ_OPTION_ON;
         case 3:  return InpS04Strategy==QQ_OPTION_ON;
         case 4:  return InpS05Strategy==QQ_OPTION_ON;
         case 5:  return InpS06Strategy==QQ_OPTION_ON;
         case 6:  return InpS07Strategy==QQ_OPTION_ON;
         case 7:  return InpS08Strategy==QQ_OPTION_ON;
         case 8:  return InpS09Strategy==QQ_OPTION_ON;
         case 9:  return InpS10Strategy==QQ_OPTION_ON;
         case 10: return false;
         case 11: return InpS12Strategy==QQ_OPTION_ON;
        }
     }
// 默认预设矩阵恢复（来自 sub_209E03D0）。
   if(InpSets==QQ_PRESET_ICVT_HIGH)
      return slot==0 || slot==1 || slot==2 || slot==4 || slot==5 ||
             slot==7 || slot==8 || slot==9 || slot==11;
   if(InpSets==QQ_PRESET_ICVT_MEDIUM)
      return slot==0 || slot==2 || slot==7 || slot==8 || slot==11;
   if(InpSets==QQ_PRESET_ICVT_LOW)
      return slot==0 || slot==3 || slot==4 || slot==6 || slot==7 ||
             slot==8 || slot==9;
   if(InpSets==QQ_PRESET_ROBO_ECN)
      return slot==0 || slot==2 || slot==3 || slot==4 || slot==5 ||
             slot==7 || slot==8 || slot==9 || slot==11;
   if(InpSets==QQ_PRESET_FUSION_ZERO)
      return slot==0 || slot==2 || slot==3 || slot==4 || slot==7 ||
             slot==8 || slot==11;
   return false;
  }

int StrategyDirection(const int slot)
  {
   if(InpTradingDirectionType==QQ_DIRECTION_BUY_ONLY)
      return 1;
   if(InpTradingDirectionType==QQ_DIRECTION_SELL_ONLY)
      return -1;
   if(slot==4 || slot==5 || slot==10 || slot==11)
      return -1;
   return 1;
  }

long StrategyMagic(const int slot)
  {
   return InpMagicNumber;
  }

string SafeComment(const int slot)
  {
   string value=StringSubstr(InpTradeCommentRaw,0,30);
   return value+StrategyTag(slot);
  }

bool IsTesterEnvironment()
  {
   return (bool)MQLInfoInteger(MQL_TESTER) || (bool)MQLInfoInteger(MQL_OPTIMIZATION);
  }

bool ReadTrialStart(datetime &value)
  {
   value=0;
   int handle=FileOpen(QQ_TRIAL_FILE,FILE_READ|FILE_TXT|FILE_COMMON|FILE_ANSI);
   if(handle==INVALID_HANDLE)
      return false;
   string marker=FileReadString(handle);
   string timestamp=FileReadString(handle);
   FileClose(handle);
   if(marker!=QQ_LICENSE_PREFIX)
      return false;
   long parsed=(long)StringToInteger(timestamp);
   if(parsed<=0)
      return false;
   value=(datetime)parsed;
   return true;
  }

bool WriteTrialStart(const datetime value)
  {
   int handle=FileOpen(QQ_TRIAL_FILE,FILE_WRITE|FILE_TXT|FILE_COMMON|FILE_ANSI);
   if(handle==INVALID_HANDLE)
      return false;
   FileWrite(handle,QQ_LICENSE_PREFIX);
   FileWrite(handle,(string)(long)value);
   FileClose(handle);
   return true;
  }

bool CheckAuthorization(const bool show_dialog)
  {
   // 授权与试用期校验；只影响交易允许状态，不改动交易规则。
   g_license_invalid=false;
   g_trial_expired=false;
   if(IsTesterEnvironment())
     {
      g_authorized=true;
      return true;
     }

   datetime now=TimeCurrent();
   if(now<=0)
      now=TimeLocal();
   datetime stored=0;
   if(!ReadTrialStart(stored))
     {
      stored=now;
      if(!WriteTrialStart(stored))
        {
         g_license_invalid=true;
         g_authorized=false;
        }
     }
   if(stored>now || stored<=0)
     {
      g_license_invalid=true;
      g_authorized=false;
     }
   else
     {
      g_trial_start=stored;
      g_trial_end=stored+(datetime)QQ_TRIAL_SECONDS;
      g_trial_expired=(now>=g_trial_end);
      g_authorized=!g_trial_expired;
     }

   if(!g_authorized && show_dialog)
     {
      string state=(g_trial_expired ? "试用到期" : "授权无效");
      string body="Quantum Queen X - 需要授权\n\n";
      if(g_trial_expired)
         body+="Quantum Queen X: 免费试用期已到期。\n";
      body+=state;
      MessageBox(body,"Quantum Queen X - 需要授权",MB_OK|MB_ICONWARNING);
     }
   return g_authorized;
  }

bool TradingEnvironmentReady()
  {
   // 检查终端与账户权限，缺一不可才允许继续交易。
   if(!(bool)TerminalInfoInteger(TERMINAL_CONNECTED))
     {
      Print("系统诊断：终端未连接");
      return false;
     }
   if(!(bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
     {
      Print("系统诊断：终端交易已禁用");
      return false;
     }
   if(!(bool)MQLInfoInteger(MQL_TRADE_ALLOWED))
     {
      Print("系统诊断：MQL交易已禁用");
      return false;
     }
   if(!(bool)AccountInfoInteger(ACCOUNT_TRADE_EXPERT))
     {
      Print("系统诊断：EA交易已禁用");
      return false;
     }
   if(!(bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))
     {
      Print("系统诊断：账号交易已禁用");
      return false;
     }
   return true;
  }

double NormalizeVolume(const double requested)
  {
   double minimum=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double maximum=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   if(step<=0.0)
      step=minimum;
// 先按 1e-7 偏移做两位小数舍入（原逻辑兼容）。
   double whole=(requested<0.0 ? MathCeil(requested) : MathFloor(requested));
   double scaled=(requested-whole)*100.0+
                 (requested>0.0 ? 0.5000001 : -0.5000001);
   double rounded_fraction=(scaled<0.0 ? MathCeil(scaled) : MathFloor(scaled));
   double rounded=whole+rounded_fraction/100.0;
   if(rounded==0.0)
      return 0.0;
// 再按标准步长向零截断，得到最终手数。
   double volume=step*(int)(rounded/step);
   if(volume<minimum)
      volume=minimum;
   if(volume>maximum)
      volume=maximum;
   return volume;
  }

double NormalizeRecoveredPrice(const double price)
  {
// 价格按小数位进行四舍五入：floor(price*10^digits+0.5)。
   int digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(digits<0)
      digits=0;
   if(digits>11)
      digits=11;
   double scale=MathPow(10.0,digits);
   if(scale<=0.0)
      return price;
   return MathFloor(price*scale+0.5)/scale;
  }

double CalculateVolume()
  {
   if(InpLotsCalc==QQ_LOT_FIXED)
      return NormalizeVolume(InpLotsFixed);
   if(InpLotsCalc==QQ_LOT_FIXED_PER_BALANCE)
     {
      double unit=MathMax(1.0,InpLotsFixedBalance);
      return NormalizeVolume(AccountInfoDouble(ACCOUNT_BALANCE)/unit*InpLotsFixed);
     }
   static double divisor_high[7]={2000.0,1200.0,800.0,600.0,500.0,400.0,300.0};
   static double divisor_other[7]={2000.0,1500.0,1000.0,800.0,600.0,550.0,400.0};
   int level=(int)InpAutoLotsValue;
   if(level<0 || level>6)
      return 0.0;
   double divisor=divisor_high[level];
   if(InpSets>=QQ_PRESET_ICVT_LOW)
      divisor=divisor_other[level];
   if(InpSets==QQ_PRESET_FUSION_ZERO && level==6)
      divisor=300.0;
   return NormalizeVolume(AccountInfoDouble(ACCOUNT_BALANCE)/divisor*0.01);
  }

bool IsOurPosition(const ulong ticket,const int slot=-1)
  {
   if(ticket==0 || !PositionSelectByTicket(ticket))
      return false;
   long magic=PositionGetInteger(POSITION_MAGIC);
   if(magic!=InpMagicNumber || PositionGetString(POSITION_SYMBOL)!=_Symbol)
      return false;
   if(slot>=0)
      return PositionGetString(POSITION_COMMENT)==SafeComment(slot);
   return true;
  }

int StrategyPositionCount(const int slot)
  {
   int count=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(IsOurPosition(ticket,slot))
         count++;
     }
   return count;
  }

double StrategyProfit(const int slot)
  {
   double value=0.0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(!IsOurPosition(ticket,slot))
         continue;
      value+=PositionGetDouble(POSITION_PROFIT);
      value+=PositionGetDouble(POSITION_SWAP);
     }
   return value;
  }

double TotalStrategyProfit()
  {
   double value=0.0;
   for(int slot=0;slot<QQ_STRATEGY_COUNT;slot++)
      value+=StrategyProfit(slot);
   return value;
  }

double TotalStrategyVolume()
  {
   double value=0.0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(IsOurPosition(ticket))
         value+=PositionGetDouble(POSITION_VOLUME);
     }
   return value;
  }

bool CloseStrategy(const int slot,const string reason)
  {
   bool selected=false;
   bool closed=true;
   g_trade.SetExpertMagicNumber(StrategyMagic(slot));
   ulong tickets[];
   ArrayResize(tickets,0);
   for(int i=0;i<PositionsTotal();i++)
     {
      ulong ticket=PositionGetTicket(i);
      if(!IsOurPosition(ticket,slot))
         continue;
      selected=true;
      int size=ArraySize(tickets);
      ArrayResize(tickets,size+1);
      tickets[size]=ticket;
     }
   ArraySort(tickets);
   for(int i=0;i<ArraySize(tickets);i++)
     {
      ulong ticket=tickets[i];
      if(!g_trade.PositionClose(ticket))
        {
         closed=false;
         PrintFormat("%s 平仓失败 ticket=%I64u retcode=%u err=%d",
                     reason,ticket,g_trade.ResultRetcode(),GetLastError());
        }
     }
   PrintFormat("P07 汇总 slot=%d 选中=%s 已平=%s",
               slot,(selected ? "是" : "否"),(closed ? "是" : "否"));
   return selected && closed;
  }

bool CloseAllStrategies(const string reason)
  {
   bool result=true;
   for(int slot=0;slot<QQ_STRATEGY_COUNT;slot++)
     {
      if(StrategyPositionCount(slot)>0 && !CloseStrategy(slot,reason))
         result=false;
     }
   return result;
  }

void NotifyRisk(const string text)
  {
   Print(text);
   if(InpMQID==QQ_OPTION_ON && !SendNotification(text))
      PrintFormat("Quantum Queen：通知未发送 (%d)",GetLastError());
  }

void ApplyDrawdownControl()
  {
   if(InpDDMode==QQ_DD_OFF || InpDDValue<=0.0)
     {
      g_drawdown_triggered=false;
      return;
     }
   double floating=TotalStrategyProfit();
   if(floating>=0.0)
     {
      g_drawdown_triggered=false;
      return;
     }
   bool percent_mode=((int)InpDDMode>=1 && (int)InpDDMode<=3);
   double measured=-floating;
   string unit=AccountInfoString(ACCOUNT_CURRENCY);
   if(percent_mode)
     {
      double balance=AccountInfoDouble(ACCOUNT_BALANCE);
      if(balance<=0.0)
         return;
      measured=(-floating/balance)*100.0;
      unit="%";
     }
   if(measured<InpDDValue)
     {
      g_drawdown_triggered=false;
      return;
     }
   string text=StringFormat("回撤阈值已触发：%.2f%s（浮动盈亏 %.2f %s）",
                            InpDDValue,unit,floating,AccountInfoString(ACCOUNT_CURRENCY));
   bool first_trigger=!g_drawdown_triggered;
   if(first_trigger)
     {
      Print("回撤告警：浮动已回升，停止风险触发锁定");
      NotifyRisk(text);
     }
   g_drawdown_triggered=true;
   if(InpDDMode==QQ_DD_PERCENT_ALERT || InpDDMode==QQ_DD_MONEY_ALERT)
     {
// 回撤告警将持续保持，直至浮动盈亏回到阈值内。
      if(first_trigger &&
         !MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_OPTIMIZATION))
         Alert(text);
      return;
     }
   CloseAllStrategies("Drawdown");
   if(InpDDMode==QQ_DD_PERCENT_REMOVE || InpDDMode==QQ_DD_MONEY_REMOVE)
      g_remove_after_risk=true;
  }

bool RecoveredSpreadAllowsEntry()
  {
   // 根据当前点差过滤开仓，避免价差过大时无效入场。
// 点差过滤读取 SYMBOL_ASK、SYMBOL_BID、SYMBOL_POINT；
// 通过条件为 InpSpread >= (Ask-Bid)/Point，Point<=0 直接拒绝。
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double point=SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   if(point<=0.0)
      return false;
   return ((double)InpSpread >= (ask-bid)/point);
  }

bool RecoveredMarginAllowsEntry(const int direction,const double volume)
  {
   // 下单前做保证金预估算，所需保证金必须不大于可用保证金。
// 下单前做保证金预判：买单按 Ask、卖单按 Bid 估算所需保证金；
// 若所需保证金大于可用保证金则直接拒绝。
   double free_margin=AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   if(free_margin<0.0)
      return false;
   double price=SymbolInfoDouble(_Symbol,
                                 direction>0 ? SYMBOL_ASK : SYMBOL_BID);
   double required_margin=0.0;
   ENUM_ORDER_TYPE order_type=(direction>0 ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
   if(!OrderCalcMargin(order_type,_Symbol,volume,price,required_margin))
      return false;
   return (required_margin<=free_margin);
  }

void ApplyGrid(const int slot)
  {
   // 网格加仓：仅当仓位方向一致且已触发网格线时，按原始仓量继续加仓。
   int count=StrategyPositionCount(slot);
   if(count<=0 || count>=InpOrdersMax)
      return;
   static int grid_points[12]={150,150,150,150,150,300,100,150,500,300,100,200};
   int direction=0;
   double anchor=0.0;
   double volume=0.0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(!IsOurPosition(ticket,slot))
         continue;
      long type=PositionGetInteger(POSITION_TYPE);
      int current=(type==POSITION_TYPE_BUY ? 1 : -1);
      double price=PositionGetDouble(POSITION_PRICE_OPEN);
      if(direction==0)
        {
         direction=current;
         anchor=price;
        }
      if(current!=direction)
         return;
      if(direction>0 && price<anchor)
         anchor=price;
      if(direction<0 && price>anchor)
         anchor=price;
      volume=PositionGetDouble(POSITION_VOLUME);
     }
   if(direction==0 || anchor<=0.0 || volume<=0.0)
      return;
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return;
   double next=NormalizeRecoveredPrice(
                direction>0 ?
                anchor-grid_points[slot]*_Point :
                anchor+grid_points[slot]*_Point);
// 网格加仓取价：买单参考 Ask，卖单参考 Bid。
   bool crossed=(direction>0 ? tick.ask<next : tick.bid>next);
   if(!crossed || !RecoveredSpreadAllowsEntry() ||
      !RecoveredMarginAllowsEntry(direction,volume))
      return;
   g_trade.SetExpertMagicNumber(StrategyMagic(slot));
   g_trade.SetDeviationInPoints((ulong)MathMax(0,InpSlippage));
   bool opened=(direction>0 ?
                g_trade.Buy(volume,_Symbol,0.0,0.0,0.0,SafeComment(slot)) :
                g_trade.Sell(volume,_Symbol,0.0,0.0,0.0,SafeComment(slot)));
   if(!opened)
       PrintFormat("网格加仓失败 slot=%d count=%d retcode=%u err=%d",
                  slot,count,g_trade.ResultRetcode(),GetLastError());
  }

bool ApplyRecoveredBasketTarget(const int slot)
  {
   // 达到预设目标均价后，按严格条件将该策略全部仓位一起关闭。
   static int target_points[12]={50,50,50,50,50,50,50,150,200,200,200,100};
   int count=0;
   int direction=0;
   double total_volume=0.0;
   double weighted_price=0.0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(!IsOurPosition(ticket,slot))
         continue;
      int current=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY ? 1 : -1);
      if(direction!=0 && current!=direction)
         return false;
      direction=current;
      double volume=PositionGetDouble(POSITION_VOLUME);
      total_volume+=volume;
      weighted_price+=volume*PositionGetDouble(POSITION_PRICE_OPEN);
      count++;
     }
   if(count<=0 || direction==0 || total_volume<=0.0)
     {
      g_basket_target_price[slot]=0.0;
      g_basket_target_count[slot]=0;
      return false;
     }
   if(count!=g_basket_target_count[slot] || g_basket_target_price[slot]<=0.0)
     {
      MqlDateTime now;
      TimeToStruct(TimeCurrent(),now);
      int ymd=now.year*10000+now.mon*100+now.day;
      static int dates_x15[8]=
        {
         20210204,20210603,20210701,20220119,
         20250123,20250127,20250402,20250724
        };
      static int dates_x5[19]=
        {
         20210112,20210121,20210312,20210512,20210907,
         20211116,20220301,20220309,20220602,20250205,
         20250210,20250226,20250227,20250624,20260122,
         20260220,20260319,20260420,20260610
        };
      int multiplier=1;
      for(int i=0;i<ArraySize(dates_x15);i++)
         if(ymd==dates_x15[i])
           {
            multiplier=15;
            break;
           }
      if(multiplier==1)
         for(int i=0;i<ArraySize(dates_x5);i++)
            if(ymd==dates_x5[i])
              {
               multiplier=5;
               break;
              }
      double average=weighted_price/total_volume;
      g_basket_target_price[slot]=NormalizeRecoveredPrice(
                                   direction>0 ?
                                   average+target_points[slot]*multiplier*_Point :
                                   average-target_points[slot]*multiplier*_Point);
      g_basket_target_count[slot]=count;
     }
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return false;
// 严格比较触发平仓：买单要求 Bid > 目标，卖单要求 Ask < 目标。
// 仅“穿越”才触发，不含平价。
   bool reached=(direction>0 ?
                 tick.bid>g_basket_target_price[slot] :
                 tick.ask<g_basket_target_price[slot]);
   if(!reached)
      return false;
   CloseStrategy(slot,"RecoveredBasketTarget");
   g_basket_target_price[slot]=0.0;
   g_basket_target_count[slot]=0;
   return true;
  }

void SetRecoveredHorizontalLine(const string name,const double price,const color clr)
  {
   string object=QQ_PANEL_PREFIX+name;
   if(price<=0.0)
     {
      if(ObjectFind(0,object)>=0)
         ObjectDelete(0,object);
      return;
     }
   if(ObjectFind(0,object)<0 &&
      !ObjectCreate(0,object,OBJ_HLINE,0,0,price))
      return;
   ObjectSetDouble(0,object,OBJPROP_PRICE,price);
   ObjectSetInteger(0,object,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,object,OBJPROP_STYLE,InpLineStyle);
   ObjectSetInteger(0,object,OBJPROP_WIDTH,InpLineWidth);
   ObjectSetInteger(0,object,OBJPROP_BACK,true);
   ObjectSetInteger(0,object,OBJPROP_SELECTABLE,false);
  }

void UpdateRecoveredStrategyLines(const int slot)
  {
   // 根据当前仓位方向、持仓加权成本绘制TP/BE/网格辅助线。
   int count=0;
   int direction=0;
   double total_volume=0.0;
   double weighted_price=0.0;
   double anchor=0.0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(!IsOurPosition(ticket,slot))
         continue;
      long type=PositionGetInteger(POSITION_TYPE);
      int current=(type==POSITION_TYPE_BUY ? 1 : -1);
      double price=PositionGetDouble(POSITION_PRICE_OPEN);
      double volume=PositionGetDouble(POSITION_VOLUME);
      if(direction==0)
        {
         direction=current;
         anchor=price;
        }
      if(current!=direction)
         continue;
      if(direction>0 && price<anchor)
         anchor=price;
      if(direction<0 && price>anchor)
         anchor=price;
      count++;
      total_volume+=volume;
      weighted_price+=price*volume;
     }
   double break_even=(count>=2 && total_volume>0.0 ?
                      NormalizeRecoveredPrice(weighted_price/total_volume) : 0.0);
   static int grid_points[12]={150,150,150,150,150,300,100,150,500,300,100,200};
   double grid=0.0;
   if(count>0 && direction!=0 && anchor>0.0)
      grid=NormalizeRecoveredPrice(direction>0 ?
                                   anchor-grid_points[slot]*_Point :
                                   anchor+grid_points[slot]*_Point);
   SetRecoveredHorizontalLine("TakeProfit_"+(string)(slot+1),
                              g_basket_target_price[slot],InpTPColor);
   SetRecoveredHorizontalLine("BreakEven_"+(string)(slot+1),
                              break_even,InpBEColor);
   SetRecoveredHorizontalLine("Grid_"+(string)(slot+1),
                              grid,InpGridColor);
  }

void ManageStrategy(const int slot)
  {
   // 每M1根K线执行一次管理，避免重复处理已新开的仓位。
   if(!StrategyEnabled(slot) || StrategyPositionCount(slot)<=0)
      return;
   datetime minute=iTime(_Symbol,PERIOD_M1,0);
   if(minute<=0 || minute==g_last_manage_bar[slot])
      return;
   g_last_manage_bar[slot]=minute;
// 同一根 M1 K 线内不重复管理刚开仓位，避免重复加仓/平仓。
   if(PositionSelect(_Symbol) &&
      (datetime)PositionGetInteger(POSITION_TIME)>=minute)
      return;
   if(ApplyRecoveredBasketTarget(slot))
      return;
   ApplyGrid(slot);
  }

bool ScheduleAllowsTrading()
  {
   // 时间窗口过滤：周内可交易日、NFP 过滤、周五夜盘、年末停盘。
   MqlDateTime now;
   TimeToStruct(TimeCurrent(),now);
   bool day_allowed=false;
   switch(now.day_of_week)
     {
      case 0: day_allowed=InpTradeOnSunday; break;
      case 1: day_allowed=InpTradeOnMonday; break;
      case 2: day_allowed=InpTradeOnTuesday; break;
      case 3: day_allowed=InpTradeOnWednesday; break;
      case 4: day_allowed=InpTradeOnThursday; break;
      case 5: day_allowed=InpTradeOnFriday; break;
      case 6: day_allowed=InpTradeOnSaturday; break;
     }
   if(!day_allowed)
      return false;
   if(InpUseNfpFridayFilter && now.day_of_week==5 && now.day<8)
      return false;
   if(InpTradingFridayNight && now.day_of_week==5 && now.hour>=InpTradingFridayNightHour)
      return false;
   int mmdd=now.mon*100+now.day;
   if(InpUseYearEndPause && (mmdd<=115 || mmdd>=1215))
      return false;
   static int pause_dates[24]=
     {
      20200203
     };
   int ymd=now.year*10000+mmdd;
   for(int i=0;i<ArraySize(pause_dates);i++)
      if(ymd==pause_dates[i])
         return false;
   return true;
  }

ENUM_TIMEFRAMES PrimaryTimeframe(const int slot)
  {
   static ENUM_TIMEFRAMES values[12]=
     {
      PERIOD_M6,PERIOD_M15,PERIOD_M15,PERIOD_M15,
      PERIOD_M5,PERIOD_M10,PERIOD_M5,PERIOD_M5,
      PERIOD_M12,PERIOD_M10,PERIOD_M10,PERIOD_M12
     };
   if(slot<0 || slot>=QQ_STRATEGY_COUNT)
      return PERIOD_CURRENT;
   return values[slot];
  }

bool StrategyHourAllowed(const int slot,const int hour)
  {
   switch(slot)
     {
      case 0:  return hour==22 || hour==23;
      case 1:  return hour==3;
      case 2:  return hour==22;
      case 3:  return hour==19;
      case 4:  return hour==0;
      case 5:  return hour==23;
      case 6:  return hour>=8 && hour<=10;
      case 7:  return hour>=6 && hour<=11;
      case 8:  return hour>=10 && hour<=13;
      case 9:  return hour==22;
      case 10: return hour>=4 && hour<=8;
      case 11: return hour==8 || hour==9;
     }
   return false;
  }

bool IsNewEligibleBar(const int slot)
  {
   // 按策略定义的时段与周期触发，只在新根K线处理一次。
   MqlDateTime now;
   TimeToStruct(TimeCurrent(),now);
   if(!StrategyHourAllowed(slot,now.hour))
      return false;
   datetime bar=iTime(_Symbol,PrimaryTimeframe(slot),0);
   if(bar<=0 || bar==g_last_bar_time[slot])
      return false;
   g_last_bar_time[slot]=bar;
   return true;
  }

int DeMarkerDirection(const double value,const double upper,const double lower)
  {
   if(value>upper)
      return 1;
   if(value<lower)
      return -1;
   return 0;
  }

int RecoveredSignalProvider(const int slot)
  {
   if(slot<0 || slot>=QQ_STRATEGY_COUNT ||
      g_demarker_a[slot]==INVALID_HANDLE || g_demarker_b[slot]==INVALID_HANDLE)
      return 0;
   double a[2],b[2];
   if(CopyBuffer(g_demarker_a[slot],0,0,2,a)!=2)
      return 0;
   if(CopyBuffer(g_demarker_b[slot],0,0,2,b)!=2)
      return 0;
   static double upper_a[12]={0.7,0.7,0.7,0.7,0.7,0.7,0.9,0.5,0.9,0.7,0.7,0.7};
   static double lower_a[12]={0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.1};
   static double upper_b[12]={0.7,0.7,0.7,0.7,0.7,0.7,0.7,0.9,0.9,0.9,0.7,0.7};
   static double lower_b[12]={0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3};
// 反序列化数组时取第0项为当前方向判断基准。
   int da=DeMarkerDirection(a[0],upper_a[slot],lower_a[slot]);
   int db=DeMarkerDirection(b[0],upper_b[slot],lower_b[slot]);
   return (da!=0 && da==db ? da : 0);
  }

void ProcessStrategy(const int slot)
  {
   // 新信号流程：时间窗 -> 指标信号 -> 方向校验 -> 风控 -> 下单。
   if(!StrategyEnabled(slot))
      return;
   if(!ScheduleAllowsTrading() || g_paused)
      return;
   if(!IsNewEligibleBar(slot))
      return;
   int signal=RecoveredSignalProvider(slot);
   if(signal==0)
      return;
   int expected=StrategyDirection(slot);
   if((signal>0 && expected<0) || (signal<0 && expected>0))
      return;
   if(StrategyPositionCount(slot)>0)
      return;
   double volume=CalculateVolume();
   if(volume<=0.0)
      return;
   if(!RecoveredSpreadAllowsEntry() ||
      !RecoveredMarginAllowsEntry(signal,volume))
      return;
   g_trade.SetExpertMagicNumber(StrategyMagic(slot));
   g_trade.SetDeviationInPoints((ulong)MathMax(0,InpSlippage));
   bool opened=(signal>0 ?
                g_trade.Buy(volume,_Symbol,0.0,0.0,0.0,SafeComment(slot)) :
                g_trade.Sell(volume,_Symbol,0.0,0.0,0.0,SafeComment(slot)));
      if(!opened)
         PrintFormat("下单失败 slot=%d signal=%d retcode=%u err=%d",
                  slot,signal,g_trade.ResultRetcode(),GetLastError());
  }

string LotModeText()
  {
   if(InpLotsCalc==QQ_LOT_FIXED)
      return "固定";
   if(InpLotsCalc==QQ_LOT_FIXED_PER_BALANCE)
      return "按余额固定";
   return "自动";
  }

string RiskLevelText()
  {
   static string names[7]=
     {
      "极低","低","低-中","中","中-高","高","极高"
     };
   int index=(int)InpAutoLotsValue;
   if(index<0 || index>6)
      return "---";
   return names[index];
  }

string PresetText()
  {
   switch(InpSets)
     {
      case QQ_PRESET_ICVT_HIGH:   return "IC Markets/VT Markets (RAW) - 高风险";
      case QQ_PRESET_ICVT_MEDIUM: return "IC Markets/VT Markets (RAW) - 中风险";
      case QQ_PRESET_ICVT_LOW:    return "IC Markets/VT Markets (RAW) - 低风险";
      case QQ_PRESET_ROBO_ECN:    return "RoboForex - ECN";
      case QQ_PRESET_FUSION_ZERO: return "Fusion Markets - Zero";
      case QQ_PRESET_CUSTOM:      return "自定义";
     }
   return "自定义";
  }

string DrawdownModeText()
  {
   switch(InpDDMode)
     {
      case QQ_DD_OFF:              return "关闭";
      case QQ_DD_PERCENT_CONTINUE: return "[百分比] 平仓后继续";
      case QQ_DD_PERCENT_REMOVE:   return "[百分比] 平仓后移除";
      case QQ_DD_PERCENT_ALERT:    return "[百分比] 终端告警";
      case QQ_DD_MONEY_CONTINUE:   return "[金额] 平仓后继续";
      case QQ_DD_MONEY_REMOVE:     return "[金额] 平仓后移除";
      case QQ_DD_MONEY_ALERT:      return "[金额] 终端告警";
     }
   return "关闭";
  }

void ConfigurePanelObject(const string name)
  {
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
  }

bool CreatePanelRectangle(const string name,const int x,const int y,
                          const int width,const int height)
  {
   if(!ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0) && ObjectFind(0,name)<0)
      return false;
   ConfigurePanelObject(name);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrBlack);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrBlack);
   return true;
  }

bool CreatePanelLabel(const string name,const string text,const int x,const int y,
                      const color clr=clrWhite,const string font_name="",
                      const int font_size=-1)
  {
   if(!ObjectCreate(0,name,OBJ_LABEL,0,0,0) && ObjectFind(0,name)<0)
      return false;
   ConfigurePanelObject(name);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,(font_size<0 ? InpFontSize : font_size));
   ObjectSetString(0,name,OBJPROP_FONT,(font_name=="" ? InpFont : font_name));
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   return true;
  }

bool CreatePanelButton(const string name,const int x,const int y,
                       const int width,const int height)
  {
   if(!ObjectCreate(0,name,OBJ_BUTTON,0,0,0) && ObjectFind(0,name)<0)
      return false;
   ConfigurePanelObject(name);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,C'13,12,82');
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,C'25,24,130');
   ObjectSetInteger(0,name,OBJPROP_STATE,false);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,InpFontSize);
   ObjectSetString(0,name,OBJPROP_FONT,InpFont);
   ObjectSetString(0,name,OBJPROP_TEXT,name);
   return true;
  }

void SetPanelLine(const int index,const string text)
  {
   const int x=(index<24 ? 16 : 330);
   const int row=(index<24 ? index : index-24);
   const color clr=((index==9 || index==11 || index==19 ||
                     (index>=25 && (index%2)==1)) ? clrNONE : clrWhite);
   CreatePanelLabel("Panel_Lines"+(string)index,text,x,99+row*16,clr);
  }

void DeletePanelObjects()
  {
   for(int i=0;i<48;i++)
      ObjectDelete(0,"Panel_Lines"+(string)i);
   ObjectDelete(0,"PAUSE EA");
   ObjectDelete(0,"CLOSE ALL TRADES");
   ObjectDelete(0,"INFORMATION");
   if(g_dialog_prefix!="")
     {
      ObjectDelete(0,g_dialog_prefix+"Back");
      ObjectDelete(0,g_dialog_prefix+"Border");
      ObjectDelete(0,g_dialog_prefix+"Caption");
      ObjectDelete(0,g_dialog_prefix+"ClientBack");
       ObjectDelete(0,g_dialog_prefix+"Close");
       ObjectDelete(0,g_dialog_prefix+"MinMax");
       ObjectDelete(0,g_dialog_prefix+"Brand");
       ObjectDelete(0,g_dialog_prefix+"WeChat");
      }
  }

void CreatePanel()
  {
   g_dialog_prefix=StringFormat("%05d",(int)(ChartID()%100000));
   CreatePanelRectangle(g_dialog_prefix+"Back",6,21,643,468);
   CreatePanelRectangle(g_dialog_prefix+"Border",5,20,645,470);
   CreatePanelRectangle(g_dialog_prefix+"ClientBack",9,44,637,442);
   string caption=g_dialog_prefix+"Caption";
   if(ObjectCreate(0,caption,OBJ_EDIT,0,0,0) || ObjectFind(0,caption)>=0)
     {
      ConfigurePanelObject(caption);
      ObjectSetInteger(0,caption,OBJPROP_XDISTANCE,7);
      ObjectSetInteger(0,caption,OBJPROP_YDISTANCE,22);
      ObjectSetInteger(0,caption,OBJPROP_XSIZE,641);
      ObjectSetInteger(0,caption,OBJPROP_YSIZE,22);
      ObjectSetInteger(0,caption,OBJPROP_COLOR,clrWhite);
      ObjectSetInteger(0,caption,OBJPROP_BGCOLOR,C'25,24,130');
      ObjectSetInteger(0,caption,OBJPROP_BORDER_COLOR,C'25,24,130');
      ObjectSetInteger(0,caption,OBJPROP_FONTSIZE,InpFontSize+1);
      ObjectSetInteger(0,caption,OBJPROP_READONLY,true);
      ObjectSetString(0,caption,OBJPROP_FONT,InpFont);
      ObjectSetString(0,caption,OBJPROP_TEXT,QQ_NAME+" ["+_Symbol+"]");
     }
   CreatePanelLabel(g_dialog_prefix+"Close","x",632,25,clrWhite,InpFont,InpFontSize+2);
   CreatePanelLabel(g_dialog_prefix+"MinMax","-",615,25,clrWhite,InpFont,InpFontSize+2);
   CreatePanelButton("PAUSE EA",14,50,309,19);
   CreatePanelButton("CLOSE ALL TRADES",330,50,311,19);
   CreatePanelButton("INFORMATION",14,74,627,18);
   for(int i=0;i<48;i++)
      SetPanelLine(i," ");
   UpdatePanel();
  }

void UpdatePanel()
  {
   if(ObjectFind(0,"Panel_Lines0")<0)
      return;
   string currency=AccountInfoString(ACCOUNT_CURRENCY);
   SetPanelLine(0,"仓位计算方式："+LotModeText());
   SetPanelLine(1,"自动仓位风险级别："+
                  (InpLotsCalc==QQ_LOT_AUTOMATIC ? RiskLevelText() : "---"));
   SetPanelLine(2,"固定值："+
                  (InpLotsCalc==QQ_LOT_FIXED ? DoubleToString(InpLotsFixed,2) : "---"));
   SetPanelLine(3,"按余额固定："+
                  (InpLotsCalc==QQ_LOT_FIXED_PER_BALANCE ?
                   DoubleToString(InpLotsFixedBalance,2) : "---"));
   SetPanelLine(4,"回撤控制模式："+DrawdownModeText());
   SetPanelLine(5,"回撤阈值："+(InpDDMode==QQ_DD_OFF ? "---" : DoubleToString(InpDDValue,2)));
   SetPanelLine(6,"魔术编号："+(string)InpMagicNumber);
   SetPanelLine(7,"备注："+InpComment);
   SetPanelLine(8,"MQID推送通知 [回撤/止盈/止损]："+
                  (InpMQID==QQ_OPTION_ON ? "开启" : "关闭"));
   SetPanelLine(9," ");
   SetPanelLine(10,"组合："+PresetText());
   SetPanelLine(11," ");
   SetPanelLine(12,StringFormat("总盈亏: %.2f %s",TotalStrategyProfit(),currency));
   SetPanelLine(13,StringFormat("余额: %.2f %s",AccountInfoDouble(ACCOUNT_BALANCE),currency));
   SetPanelLine(14,StringFormat("净值: %.2f %s",AccountInfoDouble(ACCOUNT_EQUITY),currency));
   SetPanelLine(15,StringFormat("保证金水平: %.0f %%",AccountInfoDouble(ACCOUNT_MARGIN_LEVEL)));
   SetPanelLine(16,StringFormat("追保水平: %.0f %%",AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL)));
   SetPanelLine(17,StringFormat("爆仓水平: %.0f %%",AccountInfoDouble(ACCOUNT_MARGIN_SO_SO)));
   SetPanelLine(18,StringFormat("总手数: %.2f 手",TotalStrategyVolume()));
   SetPanelLine(19," ");
   SetPanelLine(20,"名称: "+AccountInfoString(ACCOUNT_NAME));
   SetPanelLine(21,"经纪商: "+AccountInfoString(ACCOUNT_COMPANY)+" | "+
                   TimeToString(TimeCurrent(),TIME_SECONDS));
   SetPanelLine(22,"账号/服务器: "+(string)AccountInfoInteger(ACCOUNT_LOGIN)+
                   " / "+AccountInfoString(ACCOUNT_SERVER));
   SetPanelLine(23,"杠杆/币种: "+
                   (string)AccountInfoInteger(ACCOUNT_LEVERAGE)+":1 / "+currency);
   for(int slot=0;slot<QQ_STRATEGY_COUNT;slot++)
     {
      int count=StrategyPositionCount(slot);
      string state=(count<=0 ? "等待信号..." :
                    StringFormat("持仓数：%d 笔",count));
      int line=24+slot*2;
      SetPanelLine(line,StringFormat("[策略 %d] %s | %s",
                                    slot+1,(StrategyEnabled(slot) ? "开启" : "关闭"),state));
      SetPanelLine(line+1," ");
     }
   ObjectSetString(0,"PAUSE EA",OBJPROP_TEXT,(g_paused ? "恢复EA" : "暂停EA"));
   ChartRedraw();
  }

bool CreateSignalHandles()
  {
   for(int i=0;i<QQ_STRATEGY_COUNT;i++)
     {
      g_demarker_a[i]=INVALID_HANDLE;
      g_demarker_b[i]=INVALID_HANDLE;
     }
   g_demarker_a[0]=iDeMarker(_Symbol,PERIOD_M6,18);
   g_demarker_b[0]=iDeMarker(_Symbol,PERIOD_M15,16);
   g_demarker_a[1]=iDeMarker(_Symbol,PERIOD_M15,14);
   g_demarker_b[1]=iDeMarker(_Symbol,PERIOD_M20,20);
   g_demarker_a[2]=iDeMarker(_Symbol,PERIOD_M15,26);
   g_demarker_b[2]=iDeMarker(_Symbol,PERIOD_M15,24);
   g_demarker_a[3]=iDeMarker(_Symbol,PERIOD_M15,20);
   g_demarker_b[3]=iDeMarker(_Symbol,PERIOD_M20,22);
   g_demarker_a[4]=iDeMarker(_Symbol,PERIOD_M1,18);
   g_demarker_b[4]=iDeMarker(_Symbol,PERIOD_M15,18);
   g_demarker_a[5]=iDeMarker(_Symbol,PERIOD_M10,30);
   g_demarker_b[5]=iDeMarker(_Symbol,PERIOD_M30,28);
   g_demarker_a[6]=iDeMarker(_Symbol,PERIOD_M1,20);
   g_demarker_b[6]=iDeMarker(_Symbol,PERIOD_M20,16);
   g_demarker_a[7]=iDeMarker(_Symbol,PERIOD_M1,12);
   g_demarker_b[7]=iDeMarker(_Symbol,PERIOD_H1,20);
   g_demarker_a[8]=iDeMarker(_Symbol,PERIOD_M12,18);
   g_demarker_b[8]=iDeMarker(_Symbol,PERIOD_M15,12);
   g_demarker_a[9]=iDeMarker(_Symbol,PERIOD_M10,20);
   g_demarker_b[9]=iDeMarker(_Symbol,PERIOD_M15,10);
   g_demarker_a[10]=iDeMarker(_Symbol,PERIOD_M10,30);
   g_demarker_b[10]=iDeMarker(_Symbol,PERIOD_M30,28);
   g_demarker_a[11]=iDeMarker(_Symbol,PERIOD_M12,10);
   g_demarker_b[11]=iDeMarker(_Symbol,PERIOD_M15,20);
   for(int i=0;i<QQ_STRATEGY_COUNT;i++)
      if(g_demarker_a[i]==INVALID_HANDLE || g_demarker_b[i]==INVALID_HANDLE)
         return false;
   return true;
  }

int OnInit()
  {
   ArrayInitialize(g_last_bar_time,0);
   ArrayInitialize(g_last_manage_bar,0);
   ArrayInitialize(g_basket_target_price,0.0);
   ArrayInitialize(g_basket_target_count,0);
// 启动标记来自 InpPause（InpPause==0 时表示未暂停），用于限制 OnTick 的新开仓入口。
// 开关状态仅影响 OnTick 新信号，管理逻辑仍按配置执行。
   g_paused=(InpPause==QQ_OPTION_ON);
   g_trade.SetAsyncMode(false);
   g_trade.SetTypeFillingBySymbol(_Symbol);
   if(!CheckAuthorization(true))
      return INIT_FAILED;
   if(!CreateSignalHandles())
     {
      PrintFormat("Quantum Queen：DeMarker指标句柄创建失败 (%d)",GetLastError());
      return INIT_FAILED;
     }
   Print("Quantum Queen：已写入初始化参数");
   Print("Quantum Queen 启动 | 名称: ",QQ_NAME);
   Print("Quantum Queen 启动 | 概述: ",QQ_OVERVIEW);
   Print("面板MQID推送 ",(InpMQID==QQ_OPTION_ON ? "开启" : "关闭"));
// 根据 InpPanel 控制是否创建面板。
   if(InpPanel==QQ_OPTION_ON)
      CreatePanel();
   if(!EventSetTimer(1))
      Print("Quantum Queen：面板刷新计时器启动失败");
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   for(int i=0;i<QQ_STRATEGY_COUNT;i++)
     {
      if(g_demarker_a[i]!=INVALID_HANDLE)
         IndicatorRelease(g_demarker_a[i]);
      if(g_demarker_b[i]!=INVALID_HANDLE)
         IndicatorRelease(g_demarker_b[i]);
     }
   DeletePanelObjects();
   ObjectDelete(0,"QQ_TYPED_IR_WATERMARK_TELEGRAM_V1");
   ObjectDelete(0,"QQ_TYPED_IR_WATERMARK_TELEGRAM_V2");
   ObjectsDeleteAll(0,QQ_PANEL_PREFIX);
   ChartRedraw();
  }

void OnTick()
  {
   if(!g_authorized)
      return;
   if(!TradingEnvironmentReady())
      return;
   ApplyDrawdownControl();
   for(int slot=0;slot<QQ_STRATEGY_COUNT;slot++)
      ProcessStrategy(slot);
   for(int slot=0;slot<QQ_STRATEGY_COUNT;slot++)
     {
      ManageStrategy(slot);
      UpdateRecoveredStrategyLines(slot);
     }
   if(g_remove_after_risk)
     {
      g_remove_after_risk=false;
      ExpertRemove();
     }
  }

void OnTimer()
  {
   datetime now=TimeCurrent();
   if(now-g_last_auth_check>=30)
     {
      g_last_auth_check=now;
      if(!CheckAuthorization(false))
        {
      string state=(g_trial_expired ? "试用到期" : "授权无效");
         NotifyRisk("Quantum Queen X - 需要授权: "+state);
         ExpertRemove();
         return;
        }
     }
   if(InpPanel==QQ_OPTION_ON && now-g_last_panel_update>=1)
     {
      g_last_panel_update=now;
      UpdatePanel();
     }
  }

void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id!=CHARTEVENT_OBJECT_CLICK)
      return;
   if(sparam=="PAUSE EA")
     {
      g_paused=!g_paused;
      Print("面板暂停切换 label=",(g_paused ? "恢复EA" : "暂停EA"),
            " 暂停状态=",(g_paused ? "开启" : "关闭"));
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
      UpdatePanel();
      return;
     }
   if(sparam=="CLOSE ALL TRADES")
     {
      if(MessageBox("是否平掉全部策略仓位？","Quantum Queen",MB_YESNO|MB_ICONQUESTION)==IDYES)
         CloseAllStrategies("ChartCloseAll");
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
      UpdatePanel();
      return;
     }
   if(sparam=="INFORMATION")
     {
      MessageBox("Quantum Queen MT5",
                 "Quantum Queen",MB_OK|MB_ICONINFORMATION);
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
      return;
     }
   if(g_dialog_prefix!="" && sparam==g_dialog_prefix+"Close")
     {
      ExpertRemove();
      return;
     }
   if(g_dialog_prefix!="" && sparam==g_dialog_prefix+"MinMax")
     {
      g_panel_collapsed=!g_panel_collapsed;
      for(int i=0;i<48;i++)
         ObjectSetInteger(0,"Panel_Lines"+(string)i,OBJPROP_TIMEFRAMES,
                          (g_panel_collapsed ? OBJ_NO_PERIODS : OBJ_ALL_PERIODS));
      ObjectSetInteger(0,"PAUSE EA",OBJPROP_TIMEFRAMES,
                       (g_panel_collapsed ? OBJ_NO_PERIODS : OBJ_ALL_PERIODS));
      ObjectSetInteger(0,"CLOSE ALL TRADES",OBJPROP_TIMEFRAMES,
                       (g_panel_collapsed ? OBJ_NO_PERIODS : OBJ_ALL_PERIODS));
      ObjectSetInteger(0,"INFORMATION",OBJPROP_TIMEFRAMES,
                       (g_panel_collapsed ? OBJ_NO_PERIODS : OBJ_ALL_PERIODS));
      ObjectSetString(0,sparam,OBJPROP_TEXT,(g_panel_collapsed ? "+" : "-"));
      ChartRedraw();
     }
  }


