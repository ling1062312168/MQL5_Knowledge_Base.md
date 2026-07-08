//+------------------------------------------------------------------+
//|         绿色线+RSI4点点核心指标 (MQL4, 含D1过滤与箭头)           |
//+------------------------------------------------------------------+
#property strict
#property indicator_separate_window
#property indicator_buffers 8

#property indicator_color1 Lime      // 绿色线主线颜色
#property indicator_color2 Blue      // RSI4主线颜色
#property indicator_color3 Magenta   // RSI4点点颜色
#property indicator_color4 Lime      // 多单箭头颜色
#property indicator_color5 Red       // 空单箭头颜色
#property indicator_color6 Lime      // 看涨点颜色
#property indicator_color7 Yellow    // 看跌点颜色
#property indicator_width1 2
#property indicator_width2 1
#property indicator_width3 2
#property indicator_width4 1
#property indicator_width5 1
#property indicator_level1 70
#property indicator_level2 50
#property indicator_level3 30

//---- 输入参数
input int  RSI4周期      = 4;     // RSI4周期
input int  RSI14周期     = 14;    // RSI14周期
input bool 显示RSI14     = true;  // 是否显示RSI14线
input int  GreenLine周期 = 16;    // 绿色线平滑周期
input int  信号回补根数  = 100;   // 箭头/点点与RSI点点回补的历史根数（防止新K线后信号“消失”）
input bool 显示K线倒计时 = true;  // 在图表右上角显示当前K线倒计时
input int  倒计时右移K线数 = 1;   // 倒计时显示在最新K线右侧N根K线处
input bool 显示多单信号  = true;  // 显示多单信号箭头
input bool 显示空单信号  = true;  // 显示空单信号箭头
input bool 是否弹窗      = true;  // 是否弹窗
input bool 是否推送      = false; // 是否推送 (SendNotification)
input bool 是否邮件      = false; // 是否邮件
input bool Inp_Alert_M1  = false; // 开启1分钟图信号提示
input bool Inp_Alert_M5  = false; // 开启5分钟图信号提示
input bool Inp_Alert_M15 = true;  // 开启15分钟图信号提示
input bool Inp_Alert_M30 = false; // 开启30分钟图信号提示
input bool Inp_Alert_H1  = true;  // 开启1小时图信号提示
input bool Inp_Alert_H4  = true;  // 开启4小时图信号提示
input bool Inp_Alert_D1  = true;  // 开启D1图信号提示
input bool Inp_Alert_W1  = false; // 开启W1图信号提示
input bool Inp_Alert_MN  = false; // 开启MN图信号提示
input int              D1MA周期  = 14;        // 日线均线周期
input ENUM_MA_METHOD   D1MA类型  = MODE_EMA;  // 日线均线类型

//---- 常量
const double EPSILON = 1e-10;
string K线倒计时对象名 = "GL_LastTime";

//---- 指标缓冲区
double GreenLineBuffer[];  // 绿色线
double RSI4Buffer[];       // RSI4线
double RSI4DotBuffer[];    // RSI4红点
double RSI14Buffer[];      // RSI14线
double LongArrowBuffer[];  // 多单箭头
double ShortArrowBuffer[]; // 空单箭头
double BullDotBuffer[];    // 看涨点（仅信号赋值）
double BearDotBuffer[];    // 看跌点（仅信号赋值）

// ---- 多周期提醒去重（按周期分别记录上一根已提醒的K线时间）
datetime g_lastLongAlertTime[9];
datetime g_lastShortAlertTime[9];
// ---- 多周期缓存：仅在该周期出现新K线时更新一次 ----
datetime g_lastProcessedBarTime[9];
double   g_cachedRsi1[9], g_cachedRsi2[9];
double   g_cachedGl1[9],  g_cachedGl2[9];

int PeriodSeconds4(int tf)
  {
   if(tf==PERIOD_M1)  return 60;
   if(tf==PERIOD_M5)  return 5*60;
   if(tf==PERIOD_M15) return 15*60;
   if(tf==PERIOD_M30) return 30*60;
   if(tf==PERIOD_H1)  return 60*60;
   if(tf==PERIOD_H4)  return 4*60*60;
   if(tf==PERIOD_D1)  return 24*60*60;
   if(tf==PERIOD_W1)  return 7*24*60*60;
   if(tf==PERIOD_MN1) return 30*24*60*60; // 近似月线（用于倒计时显示足够）
   return 0;
  }

void UpdateBarCountdown()
  {
   if(!显示K线倒计时) return;
   int sec = PeriodSeconds4(Period());
   if(sec <= 0) return;
   if(Bars < 1) return;

   datetime now = TimeCurrent();
   datetime candleOpen = Time[0];
   int remain = sec - (int)(now - candleOpen);
   if(remain < 0) remain = 0;

   int total = remain;
   if(total < 0) total = 0;

   int s = total % 60;
   int m = (total / 60) % 60;
   int h = total / 3600;

   string txt;
   if(h > 0) txt = StringFormat("< %d:%02d:%02d", h, m, s);
   else      txt = StringFormat("< %02d:%02d", m, s);

   // 显示在最新K线右侧N根K线的位置
   datetime t = candleOpen + 倒计时右移K线数 * sec;
   double   p = Close[0];

   if(ObjectFind(K线倒计时对象名) < 0)
     {
      ObjectCreate(K线倒计时对象名, OBJ_TEXT, 0, t, p);
      ObjectSet(K线倒计时对象名, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
     }
   ObjectMove(K线倒计时对象名, 0, t, p);
   ObjectSetText(K线倒计时对象名, txt, 15, "Arial", Yellow);
  }

int TfToIndex(int tf)
  {
   if(tf==PERIOD_M1)  return 0;
   if(tf==PERIOD_M5)  return 1;
   if(tf==PERIOD_M15) return 2;
   if(tf==PERIOD_M30) return 3;
   if(tf==PERIOD_H1)  return 4;
   if(tf==PERIOD_H4)  return 5;
   if(tf==PERIOD_D1)  return 6;
   if(tf==PERIOD_W1)  return 7;
   if(tf==PERIOD_MN1) return 8;
   return -1;
  }

bool IsAlertEnabledForTF(int tf)
  {
   if(tf==PERIOD_M1)  return Inp_Alert_M1;
   if(tf==PERIOD_M5)  return Inp_Alert_M5;
   if(tf==PERIOD_M15) return Inp_Alert_M15;
   if(tf==PERIOD_M30) return Inp_Alert_M30;
   if(tf==PERIOD_H1)  return Inp_Alert_H1;
   if(tf==PERIOD_H4)  return Inp_Alert_H4;
   if(tf==PERIOD_D1)  return Inp_Alert_D1;
   if(tf==PERIOD_W1)  return Inp_Alert_W1;
   if(tf==PERIOD_MN1) return Inp_Alert_MN;
   return false;
  }

// 计算指定周期(tf)上某根K线(shift)的绿色线数值（复用原算法，只取单点）
double CalcGreenLineValueOnTF(string sym, int tf, int shift)
  {
   int bars = iBars(sym, tf);
   if(bars <= GreenLine周期 + shift + 2) return EMPTY_VALUE;

   double alpha = 3.0 / (GreenLine周期 + 2.0);
   double beta  = 1.0 - alpha;

   double ld_0=0, ld_8=0, ld_16=0, ld_24=0;
   double ld_32=0, ld_40=0, ld_48=0, ld_56=0;
   double ld_64=0, ld_72=0, ld_80=0, ld_88=0;
   double ld_96=alpha, ld_104=beta;
   double ld_112=0, ld_120=0, ld_128=0, ld_136=0;
   double ld_144=0, ld_152=0, ld_160=0, ld_168=0;
   double ld_176=0, ld_184=0, ld_192=0, ld_200=0;
   double ld_208=0;

   int startBar = bars - GreenLine周期 - 1;
   if(startBar < shift) startBar = shift;

   for(int li = startBar; li >= shift; li--)
     {
      double h = iHigh(sym, tf, li);
      double l = iLow(sym, tf, li);
      double c = iClose(sym, tf, li);
      if(h==0.0 && l==0.0 && c==0.0) return EMPTY_VALUE;

      if(ld_8 == 0.0)
        {
         ld_8 = 1.0;
         ld_16 = 0.0;
         ld_0 = (GreenLine周期 - 1 >= 5) ? GreenLine周期 - 1.0 : 5.0;
         ld_80 = 100.0 * ((h + l + c) / 3.0);
        }
      else
        {
         ld_8 = (ld_0 <= ld_8) ? ld_0 + 1.0 : ld_8 + 1.0;
         ld_88 = ld_80;
         ld_80 = 100.0 * ((h + l + c) / 3.0);
         ld_32 = ld_80 - ld_88;

         ld_112 = ld_104 * ld_112 + ld_96 * ld_32;
         ld_120 = ld_96  * ld_112 + ld_104 * ld_120;
         ld_40  = 1.5 * ld_112 - ld_120 / 2.0;

         ld_128 = ld_104 * ld_128 + ld_96 * ld_40;
         ld_208 = ld_96  * ld_128 + ld_104 * ld_208;
         ld_48  = 1.5 * ld_128 - ld_208 / 2.0;

         ld_136 = ld_104 * ld_136 + ld_96 * ld_48;
         ld_152 = ld_96  * ld_136 + ld_104 * ld_152;
         ld_56  = 1.5 * ld_136 - ld_152 / 2.0;

         ld_160 = ld_104 * ld_160 + ld_96 * MathAbs(ld_32);
         ld_168 = ld_96  * ld_160 + ld_104 * ld_168;
         ld_64  = 1.5 * ld_160 - ld_168 / 2.0;

         ld_176 = ld_104 * ld_176 + ld_96 * ld_64;
         ld_184 = ld_96  * ld_176 + ld_104 * ld_184;
         ld_144 = 1.5 * ld_176 - ld_184 / 2.0;

         ld_192 = ld_104 * ld_192 + ld_96 * ld_144;
         ld_200 = ld_96  * ld_192 + ld_104 * ld_200;
         ld_72  = 1.5 * ld_192 - ld_200 / 2.0;

         if(ld_0 >= ld_8 && ld_80 != ld_88) ld_16 = 1.0;
         if(ld_0 == ld_8 && ld_16 == 0.0)   ld_8  = 0.0;
        }

      if(ld_0 < ld_8 && ld_72 > EPSILON)
        {
         ld_24 = 50.0 * (ld_56 / ld_72 + 1.0);
         if(ld_24 > 100.0) ld_24 = 100.0;
         if(ld_24 < 0.0)   ld_24 = 0.0;
        }
      else
         ld_24 = 50.0;
     }

   return ld_24;
  }

//+------------------------------------------------------------------+
//| 周期转字符串                                                      |
//+------------------------------------------------------------------+
string PeriodToString(int tf)
  {
   switch(tf)
     {
      case PERIOD_M1:  return "M1";
      case PERIOD_M5:  return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_M30: return "M30";
      case PERIOD_H1:  return "H1";
      case PERIOD_H4:  return "H4";
      case PERIOD_D1:  return "D1";
      case PERIOD_W1:  return "W1";
      case PERIOD_MN1: return "MN1";
      default:         return IntegerToString(tf);
     }
  }

// 兼容旧名字（原本只判断当前图周期）；现在仍然可用，但内部转为按当前周期判断
bool IsAlertEnabledForCurrentPeriod()
  {
   return IsAlertEnabledForTF(Period());
  }

//+------------------------------------------------------------------+
//| 初始化                                                            |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, GreenLineBuffer);
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2, Lime);
   SetIndexLabel(0, "绿色线");

   SetIndexBuffer(1, RSI4Buffer);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1, Blue);
   SetIndexLabel(1, "RSI("+IntegerToString(RSI4周期)+")");

   SetIndexBuffer(2, RSI4DotBuffer);
   SetIndexStyle(2, DRAW_ARROW, STYLE_SOLID, 2, Magenta);
   SetIndexArrow(2, 159);
   SetIndexLabel(2, "RSI4点");
   SetIndexEmptyValue(2, EMPTY_VALUE);

   SetIndexBuffer(3, RSI14Buffer);
   SetIndexStyle(3, 显示RSI14 ? DRAW_LINE : DRAW_NONE, STYLE_SOLID, 2, clrDodgerBlue);
   SetIndexLabel(3, "RSI("+IntegerToString(RSI14周期)+")");
   SetIndexEmptyValue(3, EMPTY_VALUE);

   SetIndexBuffer(4, LongArrowBuffer);
   SetIndexStyle(4, DRAW_ARROW, STYLE_SOLID, 1, Lime);
   SetIndexArrow(4, 233);
   SetIndexLabel(4, "多单信号");
   SetIndexEmptyValue(4, EMPTY_VALUE);

   SetIndexBuffer(5, ShortArrowBuffer);
   SetIndexStyle(5, DRAW_ARROW, STYLE_SOLID, 1, Red);
   SetIndexArrow(5, 234);
   SetIndexLabel(5, "空单信号");
   SetIndexEmptyValue(5, EMPTY_VALUE);

   SetIndexBuffer(6, BullDotBuffer);
   SetIndexStyle(6, DRAW_ARROW, STYLE_SOLID, 2, Lime);
   SetIndexArrow(6, 159);
   SetIndexLabel(6, "看涨点");
   SetIndexEmptyValue(6, EMPTY_VALUE);

   SetIndexBuffer(7, BearDotBuffer);
   SetIndexStyle(7, DRAW_ARROW, STYLE_SOLID, 2, Yellow);
   SetIndexArrow(7, 159);
   SetIndexLabel(7, "看跌点");
   SetIndexEmptyValue(7, EMPTY_VALUE);

   SetLevelValue(0, 70);
   SetLevelValue(1, 50);
   SetLevelValue(2, 30);
   SetLevelStyle(STYLE_DOT, 1, Silver);

   IndicatorShortName("");

   if(显示K线倒计时) EventSetTimer(1); // 每秒刷新倒计时（不依赖tick）
   return(0);
  }

//+------------------------------------------------------------------+
//| 反初始化                                                          |
//+------------------------------------------------------------------+
int deinit()
  {
   EventKillTimer();
   if(ObjectFind(K线倒计时对象名) >= 0) ObjectDelete(K线倒计时对象名);
   return(0);
  }

void OnTimer()
  {
   UpdateBarCountdown();
   WindowRedraw();
  }

//+------------------------------------------------------------------+
//| 主计算函数                                                        |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) return(0);

   int limit = Bars - counted_bars;
   if(limit > Bars - GreenLine周期) limit = Bars - GreenLine周期;
   // 为了让箭头/点点与提醒同步，至少刷新最近几根K线（需覆盖 shift=1/2）
   if(limit < 3) limit = 3;
   if(limit > Bars-1) limit = Bars-1;

   // ---- 绿色线计算（原始三级串联DEMA，保持不变）----
   double alpha = 3.0 / (GreenLine周期 + 2.0);
   double beta  = 1.0 - alpha;

   // 递推变量（局部，每次从最老一根重新预热）
   double ld_0=0, ld_8=0, ld_16=0, ld_24=0;
   double ld_32=0, ld_40=0, ld_48=0, ld_56=0;
   double ld_64=0, ld_72=0, ld_80=0, ld_88=0;
   double ld_96=alpha, ld_104=beta;
   double ld_112=0, ld_120=0, ld_128=0, ld_136=0;
   double ld_144=0, ld_152=0, ld_160=0, ld_168=0;
   double ld_176=0, ld_184=0, ld_192=0, ld_200=0;
   double ld_208=0;

   int startBar = Bars - GreenLine周期 - 1;

   for(int li = startBar; li >= 0; li--)
     {
      if(ld_8 == 0.0)
        {
         ld_8 = 1.0;
         ld_16 = 0.0;
         ld_0 = (GreenLine周期 - 1 >= 5) ? GreenLine周期 - 1.0 : 5.0;
         ld_80 = 100.0 * ((High[li] + Low[li] + Close[li]) / 3.0);
        }
      else
        {
         ld_8 = (ld_0 <= ld_8) ? ld_0 + 1.0 : ld_8 + 1.0;
         ld_88 = ld_80;
         ld_80 = 100.0 * ((High[li] + Low[li] + Close[li]) / 3.0);
         ld_32 = ld_80 - ld_88;

         // 级1
         ld_112 = ld_104 * ld_112 + ld_96 * ld_32;
         ld_120 = ld_96  * ld_112 + ld_104 * ld_120;
         ld_40  = 1.5 * ld_112 - ld_120 / 2.0;
         // 级2
         ld_128 = ld_104 * ld_128 + ld_96 * ld_40;
         ld_208 = ld_96  * ld_128 + ld_104 * ld_208;
         ld_48  = 1.5 * ld_128 - ld_208 / 2.0;
         // 级3
         ld_136 = ld_104 * ld_136 + ld_96 * ld_48;
         ld_152 = ld_96  * ld_136 + ld_104 * ld_152;
         ld_56  = 1.5 * ld_136 - ld_152 / 2.0;

         // 绝对值级1
         ld_160 = ld_104 * ld_160 + ld_96 * MathAbs(ld_32);
         ld_168 = ld_96  * ld_160 + ld_104 * ld_168;
         ld_64  = 1.5 * ld_160 - ld_168 / 2.0;
         // 绝对值级2
         ld_176 = ld_104 * ld_176 + ld_96 * ld_64;
         ld_184 = ld_96  * ld_176 + ld_104 * ld_184;
         ld_144 = 1.5 * ld_176 - ld_184 / 2.0;
         // 绝对值级3
         ld_192 = ld_104 * ld_192 + ld_96 * ld_144;
         ld_200 = ld_96  * ld_192 + ld_104 * ld_200;
         ld_72  = 1.5 * ld_192 - ld_200 / 2.0;

         if(ld_0 >= ld_8 && ld_80 != ld_88) ld_16 = 1.0;
         if(ld_0 == ld_8 && ld_16 == 0.0)   ld_8  = 0.0;
        }

      if(ld_0 < ld_8 && ld_72 > EPSILON)
        {
         ld_24 = 50.0 * (ld_56 / ld_72 + 1.0);
         if(ld_24 > 100.0) ld_24 = 100.0;
         if(ld_24 < 0.0)   ld_24 = 0.0;
        }
      else
         ld_24 = 50.0;

      GreenLineBuffer[li] = ld_24;
     }

   // ---- RSI4 线和红点（为保证历史点点与信号不丢失，至少回补固定根数）----
   int repaint = limit;
   if(repaint < 信号回补根数) repaint = 信号回补根数;
   if(repaint > Bars-1) repaint = Bars-1;

   for(int k = repaint; k >= 0; k--)
     {
      double rsi = iRSI(NULL, 0, RSI4周期, PRICE_CLOSE, k);
      RSI4Buffer[k]    = rsi;
      RSI4DotBuffer[k] = rsi;
      RSI14Buffer[k]   = iRSI(NULL, 0, RSI14周期, PRICE_CLOSE, k);
     }

   // ---- 清空箭头 ----
   for(int j = repaint; j >= 0; j--)
     {
      LongArrowBuffer[j]  = EMPTY_VALUE;
      ShortArrowBuffer[j] = EMPTY_VALUE;
      BullDotBuffer[j]    = EMPTY_VALUE;
      BearDotBuffer[j]    = EMPTY_VALUE;
     }

   // ---- D1方向过滤 ----
   double d1_close = iClose(Symbol(), PERIOD_D1, 1);
   double d1_ma    = iMA(Symbol(), PERIOD_D1, D1MA周期, 0, D1MA类型, PRICE_CLOSE, 1);
   bool showLong  = 显示多单信号 && (d1_close > d1_ma);
   bool showShort = 显示空单信号 && (d1_close < d1_ma);

   // ---- 历史箭头回补 ----
   // 注意：下面会用到 h+1，所以 h 最大只能到 repaint-1，避免数组越界
   for(int h = repaint - 1; h >= 1; h--)
     {
      if(showLong  && RSI4Buffer[h+1] <= GreenLineBuffer[h+1] && RSI4Buffer[h] > GreenLineBuffer[h])
        {
         LongArrowBuffer[h]  = RSI4Buffer[h] - 5.0;
         BullDotBuffer[h]    = RSI4Buffer[h];
        }
      if(showShort && RSI4Buffer[h+1] >= GreenLineBuffer[h+1] && RSI4Buffer[h] < GreenLineBuffer[h])
        {
         ShortArrowBuffer[h] = RSI4Buffer[h] + 5.0;
         BearDotBuffer[h]    = RSI4Buffer[h];
        }
     }

   // ---- 强制同步上一根已完成K线(h=1)的箭头/点点 ----
   // 在某些情况下 counted_bars 会让重算范围变小，导致图形信号滞后；这里确保与提醒同一时刻出现
   int h1 = 1;
   if(h1+1 < Bars)
     {
      // 先清空
      LongArrowBuffer[h1]  = EMPTY_VALUE;
      ShortArrowBuffer[h1] = EMPTY_VALUE;
      BullDotBuffer[h1]    = EMPTY_VALUE;
      BearDotBuffer[h1]    = EMPTY_VALUE;

      if(showLong && RSI4Buffer[h1+1] <= GreenLineBuffer[h1+1] && RSI4Buffer[h1] > GreenLineBuffer[h1])
        {
         LongArrowBuffer[h1] = RSI4Buffer[h1] - 5.0;
         BullDotBuffer[h1]   = RSI4Buffer[h1];
        }
      if(showShort && RSI4Buffer[h1+1] >= GreenLineBuffer[h1+1] && RSI4Buffer[h1] < GreenLineBuffer[h1])
        {
         ShortArrowBuffer[h1] = RSI4Buffer[h1] + 5.0;
         BearDotBuffer[h1]    = RSI4Buffer[h1];
        }
     }

   // ---- 多周期收盘后提示（监测各周期上一根已完成K线：shift=1）----
   int tfs[9] = {PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1};
   for(int ti=0; ti<9; ti++)
     {
      int tf = tfs[ti];
      if(!IsAlertEnabledForTF(tf)) continue;

      int idx = TfToIndex(tf);
      if(idx < 0) continue;

      int s1 = 1; // 已完成K线
      int s2 = 2; // 再上一根

      datetime barTime = iTime(Symbol(), tf, s1);
      if(barTime <= 0) continue;

      // 只在该周期出现新K线时更新缓存，避免每个tick重复重算
      if(barTime != g_lastProcessedBarTime[idx])
        {
         g_lastProcessedBarTime[idx] = barTime;

         double rsi1 = iRSI(Symbol(), tf, RSI4周期, PRICE_CLOSE, s1);
         double rsi2 = iRSI(Symbol(), tf, RSI4周期, PRICE_CLOSE, s2);
         double gl1  = CalcGreenLineValueOnTF(Symbol(), tf, s1);
         double gl2  = CalcGreenLineValueOnTF(Symbol(), tf, s2);

         g_cachedRsi1[idx] = rsi1;
         g_cachedRsi2[idx] = rsi2;
         g_cachedGl1[idx]  = gl1;
         g_cachedGl2[idx]  = gl2;
        }

      if(g_cachedRsi1[idx]==EMPTY_VALUE || g_cachedRsi2[idx]==EMPTY_VALUE) continue;
      if(g_cachedGl1[idx]==EMPTY_VALUE  || g_cachedGl2[idx]==EMPTY_VALUE)  continue;

      bool longSignal  = showLong  && (g_cachedRsi2[idx] <= g_cachedGl2[idx]) && (g_cachedRsi1[idx] > g_cachedGl1[idx]);
      bool shortSignal = showShort && (g_cachedRsi2[idx] >= g_cachedGl2[idx]) && (g_cachedRsi1[idx] < g_cachedGl1[idx]);

      string tfText = PeriodToString(tf);
      string baseMsg = Symbol()+" "+tfText+" 绿色线/RSI4 交叉信号";

      if(longSignal && barTime != g_lastLongAlertTime[idx])
        {
         g_lastLongAlertTime[idx] = barTime;
         string msg = baseMsg+"：多单";
         if(是否弹窗) Alert(msg);
         if(是否推送) SendNotification(msg);
         if(是否邮件) SendMail("Indicator Signal", msg);
        }

      if(shortSignal && barTime != g_lastShortAlertTime[idx])
        {
         g_lastShortAlertTime[idx] = barTime;
         string msg = baseMsg+"：空单";
         if(是否弹窗) Alert(msg);
         if(是否推送) SendNotification(msg);
         if(是否邮件) SendMail("Indicator Signal", msg);
        }
     }

   UpdateBarCountdown();
   return(0);
  }
