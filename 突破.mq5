#property strict
#property version   "1.00"
#property description "双阶梯突破挂单EA（MQ5完整版，中文注释）"

#include <Trade/Trade.mqh>

CTrade trade;

//========================= 参数区 =========================
input group "常规"
input bool   Flag_Stop              = false;    // 是否停止新增挂单（初始值，可用面板切换）
input long   Magic                  = 20260413;     // 魔术号
input bool   HidePanel              = true;     // 是否隐藏左上角Comment文字(图表面板独立)
input bool   EnableChartPanel       = true;     // 显示金麒麟同款图表操作面板
input int    PanelStartX            = 16;       // 按钮面板X(像素)
input int    PanelStartY            = 18;       // 按钮面板Y(像素)

input group "新闻过滤"
input bool   EnableHighImpactNewsPause = true;  // 启用高影响新闻暂停
input int    NewsLeadMinutes           = 180;   // 新闻前暂停分钟
input int    NewsCooldownMinutes       = 180;   // 新闻后暂停分钟

input group "Session"
input bool   EnableTradingSessionWindow = true;  // 启用工作时间段控制
input string EA_StartTime               = "00:00"; // EA开始时间
input string EA_StopTime                = "24:00"; // EA结束时间
input bool   EnableDailyWrapUpPhase     = true;  // 启用日内收尾阶段
input string DailyWrapUpStartTime       = "20:00"; // 收尾开始(服务器时间)
input string DailyWrapUpStopTime        = "24:00"; // 收尾结束(服务器时间)
input bool   EnableDailyProfitTarget     = true;  // 启用每日盈利目标
input double DailyProfitTarget          = 500.0;  // 每日盈利目标，达到后封盘
input int    Leverage                   = 0;     // 平台杠杆限制(0=不检查)

input group "逻辑参数"
input int    Filter                 = 30;       // 第一阶梯步长基数
input int    SecondFilter           = 15;       // 第二阶梯步长基数（对应原GAti_120）
input double TPfact                 = 4.5;      // 整体移动止损启动系数（均价浮盈点数达 TPfact*Filter 后启动）
input double SLfact                 = 3.0;      // 逆势加仓系数（间距=SLfact*Filter；反方向间距×2；仅浮亏方向）
input int    AddSpacingExpandFrom   = 3;        // 从第几笔订单起扩大加仓间距（1=首单，3=第三笔起）
input double AddSpacingExpandMult   = 2;      // 扩大倍数（第N笔起每层再乘此倍数，逐层递增）
input int    Indent                 = 0;        // 挂单价偏移（按pipScale单位）
input bool   GapProtect             = true;     // 缺口保护（挂单前检查最小距离）

input group "资金参数"
input int    CustomLotCycleCount    = 15;       // 自定义手数循环次数（1-15）
input double CustomLot1             = 0.02;     // 第1笔手数
input double CustomLot2             = 0.02;     // 第2笔手数
input double CustomLot3             = 0.02;     // 第3笔手数
input double CustomLot4             = 0.05;     // 第4笔手数
input double CustomLot5             = 0.09;     // 第5笔手数
input double CustomLot6             = 0.10;     // 第6笔手数
input double CustomLot7             = 0.15;     // 第7笔手数
input double CustomLot8             = 0.20;     // 第8笔手数
input double CustomLot9             = 0.30;     // 第9笔手数
input double CustomLot10            = 0.45;     // 第10笔手数
input double CustomLot11            = 0.60;     // 第11笔手数
input double CustomLot12            = 0.80;     // 第12笔手数
input double CustomLot13            = 1.00;     // 第13笔手数
input double CustomLot14            = 1.25;     // 第14笔手数
input double CustomLot15            = 1.50;     // 第15笔手数
input double ReverseDirectionLot    = 0.01;     // 反方向固定手数（突破入场及反方向逆势加仓）

input group "交易参数"
input int    SlippagePoints         = 10;       // 允许滑点（点）
input int    MaxSplitOrders         = 50;       // 单次最多分拆挂单次数

input group "点差补偿"
input int    ManualSpreadPipScale   = 0;        // 0=自动spread，>0=手工spread（pipScale单位）

input group "阶梯缓存"
input int    MaxBricks              = 1000;     // 阶梯缓存长度（数组索引1为最新）

input group "图表价格线"
input bool   显示多单加权成本价线 = true;    // 是否显示绿色线：多单加权成本价
input bool   显示空单加权成本价线 = true;    // 是否显示紫色线：空单加权成本价
input bool   显示多单爆仓预估价线 = true;    // 是否显示红色线：多单爆仓预估价
input bool   显示空单爆仓预估价线 = true;    // 是否显示橙色线：空单爆仓预估价

const int    MAX_ADD_LAYERS           = 15;       // 逆势加仓固定层数（对应 CustomLot1~15）
const string CHART_LINE_PREFIX              = "LadderBrkLine."; // 与面板前缀分离，避免被面板刷新删除/重绘
const int    CHART_PRICE_LINE_SEG_BARS      = 5;              // 价格线向右延伸K线数(短线段)
const double CHART_STOPOUT_MARGIN_LEVEL     = 0.2;            // 爆仓预估保证金比例(20%)

#define ORDER_COMMENT_PREFIX_BUY_FIRST    "多单首单"
#define ORDER_COMMENT_PREFIX_SELL_FIRST   "空单首单"
#define ORDER_COMMENT_PREFIX_BUY_TREND    "多单顺势加仓单"
#define ORDER_COMMENT_PREFIX_SELL_TREND   "空单顺势加仓单"
#define ORDER_COMMENT_PREFIX_BUY_COUNTER  "多单逆势加仓单"
#define ORDER_COMMENT_PREFIX_SELL_COUNTER "空单逆势加仓单"
#define EXTERNAL_ACTIVE_GV_BASE             "LadderBrk.Active"
#define EXTERNAL_LOCK_GV_BASE               "LadderBrk.ExternalLock"
const bool   ENABLE_EXTERNAL_TAKEOVER     = true;  // 向外部EA暴露GV协作标记(不暂停本EA交易)


//========================= 全局状态 =========================
// ---- 价格尺度与交易约束
double g_pipScale        = 0.0001; // 类似原GAtd_216
double g_spreadComp      = 0.0;    // 类似原GAtd_224
double g_stopDistance    = 0.0;    // 类似原GAtd_232（最小有效距离）

// ---- 移动止损 / 加仓挂单间距
double g_trailStartPoints        = 0.0; // = TPfact*Filter（整体均价浮盈达此后启动移动止损）
double g_trailStepPoints         = 0.0; // = Filter（整体移动止损追踪步长点数）
double g_addPendingSpacingPoints = 0.0; // = SLfact*Filter（逆势加仓间距与方向步长）

// ---- 主要边界（第一阶梯，交易用）
double g_mainUpper       = 0.0;    // 类似原GAtd_416
double g_mainLower       = 0.0;    // 类似原GAtd_424
double g_prevMainUpper   = 0.0;
double g_prevMainLower   = 0.0;

// ---- 第二边界（辅助）
double g_auxUpper        = 0.0;    // 类似原GAtd_456
double g_auxLower        = 0.0;    // 类似原GAtd_464

// ---- 马丁统计
int    g_consecutiveLossCount = 0; // 连亏笔数
double g_consecutiveLossMoney = 0; // 连亏总额（<=0）
double g_worstLossMoney       = 0; // 记录最大连亏金额（更负）
int    g_maxConsecutiveLoss   = 0; // 记录最大连亏笔数

// ---- 运行时统计
int    g_buyPosCount   = 0;
int    g_sellPosCount  = 0;
int    g_buyStopCount  = 0;
int    g_sellStopCount = 0;
int    g_buyLimitCount = 0;
int    g_sellLimitCount = 0;
bool   g_buy_has_first_order = false;
bool   g_sell_has_first_order = false;
bool   g_buy_chain_promoted = false;
bool   g_sell_chain_promoted = false;

double g_buyPendingLots  = 0.0;
double g_sellPendingLots = 0.0;
double g_buyAddPendingLots  = 0.0;
double g_sellAddPendingLots = 0.0;
double g_nextLots        = 0.0;
bool   Verbose           = true; // 打印详细日志（内部固定）
bool   DrawComment       = true; // 是否显示面板注释（内部固定）
bool   HideChartGrid     = true; // 是否隐藏图表网格（内部固定）
int    g_customLotStep   = 1;
datetime g_customLotLastClose = 0;
ulong  g_customLotLastDeal = 0;
double g_reverseLossCarryLots = 0.0; // 反手固定手数每次亏损累加至此，加到下一笔顺向自定义挂单；任意平仓盈利清零

// ---- 面板与新闻
bool     g_allow_buy           = true;
bool     g_allow_sell          = true;
bool     g_stop_new_orders     = false;
bool     g_panel_open          = false;
string   g_panel_prefix        = "LadderBrk.";
int      g_panel_x             = 16;
int      g_panel_y             = 18;
datetime g_news_cache_minute   = 0;
bool     g_external_locked     = false;

struct ChartPriceLineCache
{
   bool     visible;
   double   price;
   datetime t1;
   datetime t2;
   string   label_text;
};

ChartPriceLineCache g_cache_long_cost;
ChartPriceLineCache g_cache_short_cost;
ChartPriceLineCache g_cache_long_margin;
ChartPriceLineCache g_cache_short_margin;
datetime g_chart_price_line_bar_time = 0;
int      g_chart_line_last_long_cnt = -1;
int      g_chart_line_last_short_cnt = -1;
bool     g_chart_price_lines_inited = false;

struct NewsWindowState
{
   bool     enabled;
   bool     calendar_available;
   bool     has_active_window;
   bool     in_pre_window;
   bool     in_post_window;
   bool     has_upcoming_event;
   bool     block_entries;
   datetime server_now;
   datetime event_time;
   datetime window_start;
   datetime resume_time;
   string   currency;
   string   event_name;
   string   error_text;
};

struct NewsEvalAccumulator
{
   bool     any_success;
   string   first_error;
   datetime active_block_start;
   datetime active_block_end;
   datetime active_future_time;
   string   active_future_currency;
   string   active_future_name;
   datetime active_past_time;
   string   active_past_currency;
   string   active_past_name;
   datetime next_upcoming_time;
   string   next_upcoming_currency;
   string   next_upcoming_name;
};

NewsWindowState g_news_state;

struct EAStats
{
   int      buy_positions;
   int      sell_positions;
   int      buy_pending;
   int      sell_pending;
   double   buy_lots;
   double   sell_lots;
   double   buy_profit;
   double   sell_profit;
   double   total_profit;
   double   buy_weighted_sum;
   double   sell_weighted_sum;
   double   buy_avg_price;
   double   sell_avg_price;
   double   buy_highest_any;
   double   buy_lowest_position;
   double   sell_highest_position;
   double   sell_lowest_any;
   double   buy_pending_price;
   double   sell_pending_price;
   ulong    buy_pending_ticket;
   ulong    sell_pending_ticket;
   datetime last_buy_open_time;
   datetime last_sell_open_time;
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
   int font_sm;
   int font_xs;
   int font_md;
   int font_lg;
   int panel_h;
   int toggle_w;
};

datetime g_last_panel_refresh     = 0;
datetime g_pause_until            = 0;
string   g_today_key                = "";
bool     g_daily_target_locked      = false;
double   g_daily_target_hit_value   = 0.0;
bool     g_panel_dragging           = false;
int      g_panel_drag_offset_x      = 0;
int      g_panel_drag_offset_y      = 0;

// 外部EA接管：GV名 = EXTERNAL_LOCK_GV_BASE + "." + 品种 + "." + Magic
string BuildExternalLockGVName()
{
   return EXTERNAL_LOCK_GV_BASE + "." + _Symbol + "." + IntegerToString((int)Magic);
}

string BuildExternalActiveGVName()
{
   return EXTERNAL_ACTIVE_GV_BASE + "." + _Symbol + "." + IntegerToString((int)Magic);
}

bool IsExternalTakeoverActive()
{
   if(!ENABLE_EXTERNAL_TAKEOVER)
      return false;

   const string gv = BuildExternalLockGVName();
   if(!GlobalVariableCheck(gv))
      return false;

   return (GlobalVariableGet(gv) > 0.5);
}

void RefreshExternalTakeoverState()
{
   g_external_locked = IsExternalTakeoverActive();
}

void PublishExternalEaActiveMarker()
{
   if(!ENABLE_EXTERNAL_TAKEOVER)
      return;

   GlobalVariableSet(BuildExternalActiveGVName(), (double)TimeCurrent());
}

void ClearExternalEaActiveMarker()
{
   const string gv = BuildExternalActiveGVName();
   if(GlobalVariableCheck(gv))
      GlobalVariableDel(gv);
}

bool IsEaManagedComment(const string cmt)
{
   return (StringFind(cmt, ORDER_COMMENT_PREFIX_BUY_FIRST, 0) == 0 ||
           StringFind(cmt, ORDER_COMMENT_PREFIX_SELL_FIRST, 0) == 0 ||
           StringFind(cmt, "加仓单", 0) >= 0);
}

bool IsDirectionChainPromoted(const int dir)
{
   if(dir > 0) return g_buy_chain_promoted;
   if(dir < 0) return g_sell_chain_promoted;
   return false;
}

int GetDirectionPositionCount(const int dir)
{
   if(dir > 0) return g_buyPosCount;
   if(dir < 0) return g_sellPosCount;
   return 0;
}

// 顺位后的有效层数：剩余N单视为第1~N层，下一笔为第N+1层
int GetEffectiveNextLayer(const int dir)
{
   const int posCount = GetDirectionPositionCount(dir);
   if(posCount <= 0) return 1;
   return posCount + 1;
}

// 顺位后下一笔加仓注释序号（首单被平：原加仓单1视为首单，新加仓从1编号）
int GetEffectiveAddSequence(const int dir)
{
   return GetDirectionPositionCount(dir);
}

void MaintainPromotedChain(const int dir)
{
   if(!IsDirectionChainPromoted(dir))
      return;

   if(dir > 0 && g_buyStopCount > 0)
   {
      if(Verbose) Print("多单链已顺位：首单不在，清理残留BuyStop突破挂单");
      DeletePendingByDirection(+1);
   }
   else if(dir < 0 && g_sellStopCount > 0)
   {
      if(Verbose) Print("空单链已顺位：首单不在，清理残留SellStop突破挂单");
      DeletePendingByDirection(-1);
   }
}

#include "突破PanelKing.mqh"

//========================= 阶梯结构 =========================
struct LadderState
{
   // 当前阶梯上下沿
   double upperLevel;
   double lowerLevel;
   // 当前砖块期间局部高低
   double localHigh;
   double localLow;
   // 趋势计数：>0 连续向上，<0 连续向下，0 未初始化
   int trendCount;

   // 砖块OHLC（索引1最新）
   double o[];
   double l[];
   double h[];
   double c[];
};

LadderState g_ladder1;
LadderState g_ladder2;


//========================= 工具函数 =========================
double NormalizePrice(const double p)
{
   return NormalizeDouble(p, (int)_Digits);
}

double GetBid()
{
   double v = 0.0;
   SymbolInfoDouble(_Symbol, SYMBOL_BID, v);
   return v;
}

double GetAsk()
{
   double v = 0.0;
   SymbolInfoDouble(_Symbol, SYMBOL_ASK, v);
   return v;
}

double CurrentSpreadPrice()
{
   return GetAsk() - GetBid();
}

// 按品种识别pip尺度（兼容黄金白银）
double DetectPipScale()
{
   string s = _Symbol;
   if(StringSubstr(s, 0, 6) == "XAGUSD")
      return 0.01;
   if(StringSubstr(s, 0, 6) == "XAUUSD" || StringSubstr(s, 0, 4) == "GOLD" || StringSubstr(s, 0, 4) == "Gold")
      return 0.1;

   // 外汇常规
   if(_Digits < 4) return 0.01;
   return 0.0001;
}

// 手数归一化（按最小手、步进、最大手）
double NormalizeVolume(double vol)
{
   double vMin  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double vMax  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double vStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   if(vol < vMin) vol = vMin;
   if(vol > vMax) vol = vMax;

   if(vStep > 0.0)
   {
      vol = MathFloor(vol / vStep) * vStep;
      int vd = 2;
      if(vStep < 0.1)  vd = 2;
      if(vStep < 0.01) vd = 3;
      if(vStep < 0.001)vd = 4;
      vol = NormalizeDouble(vol, vd);
   }
   return vol;
}

// 更新spread补偿、最小有效距离、移动止损参数、加仓间距
void UpdateMarketDerivedValues()
{
   if(ManualSpreadPipScale == 0)
      g_spreadComp = CurrentSpreadPrice();
   else
      g_spreadComp = ManualSpreadPipScale * g_pipScale;

   int stopLevelPoints = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double brokerStopDist = stopLevelPoints * _Point;

   // 与原逻辑一致：取 max(交易所最小止损距离, 2*当前点差)
   g_stopDistance = MathMax(brokerStopDist, 2.0 * CurrentSpreadPrice());

   g_trailStartPoints = TPfact * Filter;
   g_trailStepPoints  = Filter;
   g_addPendingSpacingPoints = SLfact * Filter;
}


//========================= 阶梯函数 =========================
void InitLadder(LadderState &ladder)
{
   ladder.upperLevel = 0.0;
   ladder.lowerLevel = 0.0;
   ladder.localHigh  = 0.0;
   ladder.localLow   = 0.0;
   ladder.trendCount = 0;

   ArrayResize(ladder.o, MaxBricks + 1);
   ArrayResize(ladder.l, MaxBricks + 1);
   ArrayResize(ladder.h, MaxBricks + 1);
   ArrayResize(ladder.c, MaxBricks + 1);

   ArrayInitialize(ladder.o, 0.0);
   ArrayInitialize(ladder.l, 0.0);
   ArrayInitialize(ladder.h, 0.0);
   ArrayInitialize(ladder.c, 0.0);
}

// 新砖入栈（1最新）
void PushBrick(LadderState &ladder, const double bo, const double bl, const double bh, const double bc)
{
   for(int i = MaxBricks; i > 1; --i)
   {
      ladder.o[i] = ladder.o[i - 1];
      ladder.l[i] = ladder.l[i - 1];
      ladder.h[i] = ladder.h[i - 1];
      ladder.c[i] = ladder.c[i - 1];
   }

   ladder.o[1] = bo;
   ladder.l[1] = bl;
   ladder.h[1] = bh;
   ladder.c[1] = bc;
}

// 初始化阶梯锚点
void EnsureLadderReady(LadderState &ladder, const double step)
{
   if(ladder.trendCount != 0) return;

   double bid = GetBid();
   double anchor = MathFloor(bid / step) * step;

   ladder.upperLevel = anchor;
   ladder.lowerLevel = anchor - step;
   ladder.localHigh  = ladder.upperLevel;
   ladder.localLow   = ladder.lowerLevel;
   ladder.trendCount = 1;
}

// 更新单个阶梯（像Renko/箱体）
void UpdateLadder(LadderState &ladder, const double step)
{
   EnsureLadderReady(ladder, step);

   double bid = GetBid();
   ladder.localHigh = MathMax(ladder.localHigh, bid);
   if(bid > 0.0)
      ladder.localLow = (ladder.localLow == 0.0 ? bid : MathMin(ladder.localLow, bid));

   // 向上突破：可一次跳多格
   while(bid >= ladder.upperLevel + step)
   {
      ladder.upperLevel += step;
      ladder.lowerLevel += step;

      if(ladder.trendCount < 0) ladder.trendCount = 1;
      else                      ladder.trendCount++;

      PushBrick(
         ladder,
         ladder.lowerLevel,                           // open
         MathMin(ladder.localLow, ladder.lowerLevel), // low
         ladder.upperLevel,                           // high
         ladder.upperLevel                            // close
      );

      ladder.localHigh = 0.0;
      ladder.localLow  = EMPTY_VALUE;
   }

   // 向下突破：可一次跳多格
   while(bid <= ladder.lowerLevel - step)
   {
      ladder.upperLevel -= step;
      ladder.lowerLevel -= step;

      if(ladder.trendCount > 0) ladder.trendCount = -1;
      else                      ladder.trendCount--;

      PushBrick(
         ladder,
         ladder.upperLevel,                            // open
         MathMin(ladder.localLow, ladder.lowerLevel),  // low
         MathMax(ladder.localHigh, ladder.upperLevel), // high
         ladder.lowerLevel                             // close
      );

      ladder.localHigh = 0.0;
      ladder.localLow  = EMPTY_VALUE;
   }
}

// 从最近两根砖块提取上下边界（对应原f0_2/f0_0的“交叉关系”）
void ExtractBoundaries(const LadderState &ladder, double &upperBoundary, double &lowerBoundary)
{
   // 需要至少两根有效砖
   if(ladder.o[1] == 0.0 || ladder.o[2] == 0.0) return;

   // 若 o1>c1 且 o2<c2 => 记上边界
   if(ladder.o[1] > ladder.c[1] && ladder.o[2] < ladder.c[2])
      upperBoundary = NormalizePrice(MathMax(ladder.h[1], ladder.h[2]));

   // 若 o1<c1 且 o2>c2 => 记下边界
   if(ladder.o[1] < ladder.c[1] && ladder.o[2] > ladder.c[2])
      lowerBoundary = NormalizePrice(MathMin(ladder.l[1], ladder.l[2]));
}


//========================= 订单/持仓扫描 =========================
bool SelectOrderByIndex(const int idx)
{
   ulong ticket = OrderGetTicket(idx);
   if(ticket == 0) return false;
   return OrderSelect(ticket);
}

void RecountOrdersAndPositions()
{
   g_buyPosCount = 0;
   g_sellPosCount = 0;
   g_buyStopCount = 0;
   g_sellStopCount = 0;
   g_buyLimitCount = 0;
   g_sellLimitCount = 0;
   g_buyPendingLots = 0.0;
   g_sellPendingLots = 0.0;
   g_buyAddPendingLots = 0.0;
   g_sellAddPendingLots = 0.0;
   g_buy_has_first_order = false;
   g_sell_has_first_order = false;
   g_buy_chain_promoted = false;
   g_sell_chain_promoted = false;

   // 扫描持仓
   int pTotal = PositionsTotal();
   for(int i = 0; i < pTotal; ++i)
   {
      ulong ptk = PositionGetTicket(i);
      if(ptk == 0) continue;
      if(!PositionSelectByTicket(ptk)) continue;

      string sym = PositionGetString(POSITION_SYMBOL);
      long mgc   = PositionGetInteger(POSITION_MAGIC);
      long type  = PositionGetInteger(POSITION_TYPE);
      string cmt = PositionGetString(POSITION_COMMENT);

      if(sym != _Symbol || mgc != Magic) continue;

      if(type == POSITION_TYPE_BUY)
      {
         g_buyPosCount++;
         if(StringFind(cmt, ORDER_COMMENT_PREFIX_BUY_FIRST, 0) == 0)
            g_buy_has_first_order = true;
      }
      if(type == POSITION_TYPE_SELL)
      {
         g_sellPosCount++;
         if(StringFind(cmt, ORDER_COMMENT_PREFIX_SELL_FIRST, 0) == 0)
            g_sell_has_first_order = true;
      }
   }

   g_buy_chain_promoted = (g_buyPosCount > 0 && !g_buy_has_first_order);
   g_sell_chain_promoted = (g_sellPosCount > 0 && !g_sell_has_first_order);

   // 扫描挂单（订单池）
   int oTotal = OrdersTotal();
   for(int i = 0; i < oTotal; ++i)
   {
      if(!SelectOrderByIndex(i)) continue;

      string sym = OrderGetString(ORDER_SYMBOL);
      long mgc   = OrderGetInteger(ORDER_MAGIC);
      long type  = OrderGetInteger(ORDER_TYPE);
      double vol = OrderGetDouble(ORDER_VOLUME_CURRENT);
      string cmt = OrderGetString(ORDER_COMMENT);

      if(sym != _Symbol || mgc != Magic) continue;

      bool isAddOrder = IsAddOrderComment(cmt);

      if(type == ORDER_TYPE_BUY_STOP)
      {
         g_buyStopCount++;
         g_buyPendingLots += vol;
      }
      else if(type == ORDER_TYPE_SELL_STOP)
      {
         g_sellStopCount++;
         g_sellPendingLots += vol;
      }
      else if(type == ORDER_TYPE_BUY_LIMIT)
      {
         g_buyLimitCount++;
         if(isAddOrder) g_buyAddPendingLots += vol;
      }
      else if(type == ORDER_TYPE_SELL_LIMIT)
      {
         g_sellLimitCount++;
         if(isAddOrder) g_sellAddPendingLots += vol;
      }
   }
}


//========================= 马丁统计与手数 =========================
int GetCustomLotCycleCount()
{
   int n = CustomLotCycleCount;
   if(n < 1) n = 1;
   if(n > 15) n = 15;
   return n;
}

double GetCustomLotByStep(const int step)
{
   if(step <= 1) return CustomLot1;
   if(step == 2) return CustomLot2;
   if(step == 3) return CustomLot3;
   if(step == 4) return CustomLot4;
   if(step == 5) return CustomLot5;
   if(step == 6) return CustomLot6;
   if(step == 7) return CustomLot7;
   if(step == 8) return CustomLot8;
   if(step == 9) return CustomLot9;
   if(step == 10) return CustomLot10;
   if(step == 11) return CustomLot11;
   if(step == 12) return CustomLot12;
   if(step == 13) return CustomLot13;
   if(step == 14) return CustomLot14;
   return CustomLot15;
}

double GetCurrentCustomLot()
{
   int cnt = GetCustomLotCycleCount();
   if(g_customLotStep < 1 || g_customLotStep > cnt)
      g_customLotStep = 1;
   return GetCustomLotByStep(g_customLotStep);
}

bool IsTrendDirection(const int dir)
{
   int handle = iMA(_Symbol, PERIOD_D1, 14, 0, MODE_EMA, PRICE_CLOSE);
   if(handle == INVALID_HANDLE) return false;

   double emaBuf[3];
   ArraySetAsSeries(emaBuf, true);
   if(CopyBuffer(handle, 0, 0, 3, emaBuf) < 3)
   {
      IndicatorRelease(handle);
      return false;
   }
   double ema0 = emaBuf[0];
   double ema1 = emaBuf[1];
   IndicatorRelease(handle);

   // 多/空趋势：同时看当前开盘(Open[0])与上一根收盘(Close[1])相对EMA的位置
   double d1Open0  = iOpen(_Symbol, PERIOD_D1, 0);
   double d1Close1 = iClose(_Symbol, PERIOD_D1, 1);
   bool buyTrend = (d1Open0 > ema0 && d1Close1 > ema1);
   bool sellTrend = (d1Open0 < ema0 && d1Close1 < ema1);

   if(dir > 0) return buyTrend;
   if(dir < 0) return sellTrend;
   return false;
}

// 按“某个时刻所在D1柱”判断顺/逆势（用于按开仓时趋势归类）
bool IsTrendDirectionAtTime(const int dir, const datetime t)
{
   int handle = iMA(_Symbol, PERIOD_D1, 14, 0, MODE_EMA, PRICE_CLOSE);
   if(handle == INVALID_HANDLE) return false;

   int shift = iBarShift(_Symbol, PERIOD_D1, t, false);
   if(shift < 0)
   {
      IndicatorRelease(handle);
      return false;
   }

   // 复用当前规则：Open[s] 与 EMA[s]，且 Close[s+1] 与 EMA[s+1]
   double emaBuf[2];
   ArraySetAsSeries(emaBuf, true);
   if(CopyBuffer(handle, 0, shift, 2, emaBuf) < 2)
   {
      IndicatorRelease(handle);
      return false;
   }
   double emaCurr = emaBuf[0];
   double emaPrev = emaBuf[1];
   IndicatorRelease(handle);

   double d1OpenCurr  = iOpen(_Symbol, PERIOD_D1, shift);
   double d1ClosePrev = iClose(_Symbol, PERIOD_D1, shift + 1);
   if(d1OpenCurr <= 0.0 || d1ClosePrev <= 0.0)
      return false;

   bool buyTrend  = (d1OpenCurr > emaCurr && d1ClosePrev > emaPrev);
   bool sellTrend = (d1OpenCurr < emaCurr && d1ClosePrev < emaPrev);

   if(dir > 0) return buyTrend;
   if(dir < 0) return sellTrend;
   return false;
}

// 获取该平仓deal所属仓位的首个开仓时间（用于“开仓时趋势”判定）
bool GetPositionFirstEntryTime(const ulong posId, const datetime closeTime, datetime &entryTime)
{
   entryTime = 0;
   int deals = HistoryDealsTotal();
   for(int i = 0; i < deals; ++i)
   {
      ulong dtk = HistoryDealGetTicket(i);
      if(dtk == 0) continue;

      if((ulong)HistoryDealGetInteger(dtk, DEAL_POSITION_ID) != posId) continue;
      long entry = (long)HistoryDealGetInteger(dtk, DEAL_ENTRY);
      if(entry != DEAL_ENTRY_IN) continue;

      datetime t = (datetime)HistoryDealGetInteger(dtk, DEAL_TIME);
      if(t <= 0 || t > closeTime) continue;

      if(entryTime == 0 || t < entryTime)
         entryTime = t;
   }
   return (entryTime > 0);
}

void UpdateCustomLotCycle()
{
   if(!HistorySelect(0, TimeCurrent())) return;

   int deals = HistoryDealsTotal();
   for(int i = deals - 1; i >= 0; --i)
   {
      ulong dtk = HistoryDealGetTicket(i);
      if(dtk == 0) continue;

      string sym = HistoryDealGetString(dtk, DEAL_SYMBOL);
      long mgc   = (long)HistoryDealGetInteger(dtk, DEAL_MAGIC);
      long entry = (long)HistoryDealGetInteger(dtk, DEAL_ENTRY);
      if(sym != _Symbol || mgc != Magic || entry != DEAL_ENTRY_OUT) continue;

      datetime closeTime = (datetime)HistoryDealGetInteger(dtk, DEAL_TIME);
      if(closeTime == g_customLotLastClose && dtk == g_customLotLastDeal)
         return;

      double pnl = HistoryDealGetDouble(dtk, DEAL_PROFIT)
                 + HistoryDealGetDouble(dtk, DEAL_SWAP)
                 + HistoryDealGetDouble(dtk, DEAL_COMMISSION);
      double vol = HistoryDealGetDouble(dtk, DEAL_VOLUME);
      long dealType = (long)HistoryDealGetInteger(dtk, DEAL_TYPE);
      ulong posId = (ulong)HistoryDealGetInteger(dtk, DEAL_POSITION_ID);

      // 出场成交类型反推被平仓方向：SELL平多，BUY平空
      int closedDir = 0;
      if(dealType == DEAL_TYPE_SELL) closedDir = +1;
      if(dealType == DEAL_TYPE_BUY)  closedDir = -1;

      double reverseLot = ReverseDirectionLot;
      if(reverseLot <= 0.0) reverseLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
      reverseLot = NormalizeVolume(reverseLot);
      double volStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
      if(volStep <= 0.0) volStep = 0.01;
      bool isReverseLotTrade = (MathAbs(vol - reverseLot) <= volStep / 2.0 + 1e-8);
      datetime entryTime = 0;
      bool hasEntryTime = GetPositionFirstEntryTime(posId, closeTime, entryTime);
      bool isTrendTrade = hasEntryTime ? IsTrendDirectionAtTime(closedDir, entryTime) : IsTrendDirection(closedDir);
      bool isCounterTrendTrade = !isTrendTrade;
      double maxCarryLots = 3.0 * reverseLot;

      // 顺势或逆势（CustomLot循环方向）盈利：重置循环；逆势固定小手数盈利也重置
      if(pnl > 0.0 && !isReverseLotTrade && (isTrendTrade || isCounterTrendTrade))
      {
         g_reverseLossCarryLots = 0.0;
         g_customLotStep = 1;
      }
      // 顺势或逆势 CustomLot 单亏损：推进循环步数
      else if(!isReverseLotTrade && (isTrendTrade || isCounterTrendTrade))
      {
         g_customLotStep++;
         if(g_customLotStep > GetCustomLotCycleCount())
            g_customLotStep = 1;
      }
      else if(isReverseLotTrade && pnl < 0.0)
      {
         // 反方向固定手数亏损：不推进步数，最多累加3次ReverseDirectionLot
         g_reverseLossCarryLots += reverseLot;
         if(g_reverseLossCarryLots > maxCarryLots)
            g_reverseLossCarryLots = maxCarryLots;
      }

      g_customLotLastClose = closeTime;
      g_customLotLastDeal = dtk;
      return;
   }
}

double GetDirectionalLotFactor(const int dir)
{
   int period = 14;

   int handle = iMA(_Symbol, PERIOD_D1, period, 0, MODE_EMA, PRICE_CLOSE);
   if(handle == INVALID_HANDLE) return 1.0;

   double emaBuf[3];
   ArraySetAsSeries(emaBuf, true);
   if(CopyBuffer(handle, 0, 0, 3, emaBuf) < 3)
   {
      IndicatorRelease(handle);
      return 1.0;
   }
   double ema0 = emaBuf[0];
   double ema1 = emaBuf[1];
   IndicatorRelease(handle);

   // 多/空趋势：同时看当前开盘(Open[0])与上一根收盘(Close[1])相对EMA的位置
   double d1Open0 = iOpen(_Symbol, PERIOD_D1, 0);
   double d1Close1 = iClose(_Symbol, PERIOD_D1, 1);
   bool buyTrend = (d1Open0 > ema0 && d1Close1 > ema1);
   bool sellTrend = (d1Open0 < ema0 && d1Close1 < ema1);

    // 在“前N平投后倍投”模式下：
    // - 前平投阶段：双向都为1.0
    // - 倍投阶段：仅顺势方向倍投，逆势方向保持1.0
   double baseLot = GetCurrentCustomLot();
   if(baseLot <= 0.0) return 1.0;

   double reverseLot = ReverseDirectionLot;
   if(reverseLot <= 0.0) reverseLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);

   if(dir > 0) return buyTrend ? 1.0 : (reverseLot / baseLot);
   if(dir < 0) return sellTrend ? 1.0 : (reverseLot / baseLot);
   return 1.0;
}

string GetDirectionalLotBiasText()
{
   int period = 14;
   int handle = iMA(_Symbol, PERIOD_D1, period, 0, MODE_EMA, PRICE_CLOSE);
   if(handle == INVALID_HANDLE) return "方向识别失败";

   double emaBuf[3];
   ArraySetAsSeries(emaBuf, true);
   if(CopyBuffer(handle, 0, 0, 3, emaBuf) < 3)
   {
      IndicatorRelease(handle);
      return "方向识别失败";
   }
   double ema0 = emaBuf[0];
   double ema1 = emaBuf[1];
   IndicatorRelease(handle);

   double d1Open0 = iOpen(_Symbol, PERIOD_D1, 0);
   double d1Close1 = iClose(_Symbol, PERIOD_D1, 1);
   bool buyTrend = (d1Open0 > ema0 && d1Close1 > ema1);
   bool sellTrend = (d1Open0 < ema0 && d1Close1 < ema1);

   if(buyTrend) return "多向自定义 / 空向反手0.01";
   if(sellTrend) return "空向自定义 / 多向反手0.01";
   return "无明确趋势 / 双向反手0.01";
}

// 统计连续亏损（按历史成交deal，从新到旧，遇到盈利即停止）
void UpdateConsecutiveLossStats()
{
   g_consecutiveLossCount = 0;
   g_consecutiveLossMoney = 0.0;

   datetime fromTime = (datetime)0;
   datetime toTime = TimeCurrent();

   if(!HistorySelect(fromTime, toTime))
      return;

   int deals = HistoryDealsTotal();
   for(int i = deals - 1; i >= 0; --i)
   {
      ulong dtk = HistoryDealGetTicket(i);
      if(dtk == 0) continue;

      string sym = HistoryDealGetString(dtk, DEAL_SYMBOL);
      long mgc   = (long)HistoryDealGetInteger(dtk, DEAL_MAGIC);
      long entry = (long)HistoryDealGetInteger(dtk, DEAL_ENTRY);

      if(sym != _Symbol || mgc != Magic) continue;
      if(entry != DEAL_ENTRY_OUT) continue; // 只统计平仓

      double profit = HistoryDealGetDouble(dtk, DEAL_PROFIT)
                    + HistoryDealGetDouble(dtk, DEAL_SWAP)
                    + HistoryDealGetDouble(dtk, DEAL_COMMISSION);

      if(profit > 0.0)
         break; // 遇到盈利，停止连亏统计

      g_consecutiveLossMoney += profit; // 负数累加
      g_consecutiveLossCount++;
   }

   if(g_consecutiveLossCount > g_maxConsecutiveLoss)
      g_maxConsecutiveLoss = g_consecutiveLossCount;
   if(g_consecutiveLossMoney < g_worstLossMoney)
      g_worstLossMoney = g_consecutiveLossMoney;
}

// 计算基础手数（自定义循环或固定）
double CalcBaseLots()
{
   double lots = GetCurrentCustomLot();
   lots = NormalizeVolume(lots);
   return lots;
}

// 计算下一次总挂单手数（严格按自定义循环或固定手数）
double CalcNextLots()
{
   return CalcBaseLots();
}


//========================= 订单注释 =========================
int VolumeDigitsForComment(const double step)
{
   if(step < 0.001) return 4;
   if(step < 0.01)  return 3;
   if(step < 0.1)   return 2;
   return 2;
}

string FormatCommentLot(const double volume)
{
   const double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   const int digits = VolumeDigitsForComment(step);
   return DoubleToString(volume, digits);
}

bool IsAddOrderComment(const string cmt)
{
   return (StringFind(cmt, "加仓单", 0) >= 0);
}

bool IsBuyAddOrderComment(const string cmt)
{
   return (StringFind(cmt, ORDER_COMMENT_PREFIX_BUY_TREND, 0) == 0 ||
           StringFind(cmt, ORDER_COMMENT_PREFIX_BUY_COUNTER, 0) == 0);
}

bool IsSellAddOrderComment(const string cmt)
{
   return (StringFind(cmt, ORDER_COMMENT_PREFIX_SELL_TREND, 0) == 0 ||
           StringFind(cmt, ORDER_COMMENT_PREFIX_SELL_COUNTER, 0) == 0);
}

string BuildBreakthroughOrderComment(const bool is_buy, const double volume)
{
   const string lot_text = FormatCommentLot(volume);
   if(is_buy)
      return ORDER_COMMENT_PREFIX_BUY_FIRST + "0=" + lot_text + "手";
   return ORDER_COMMENT_PREFIX_SELL_FIRST + "0=" + lot_text + "手";
}

string BuildAddOrderComment(const int dir, const int sequence, const double volume)
{
   const string lot_text = FormatCommentLot(volume);
   const bool reverse = IsReverseAddSide(dir);

   if(dir > 0)
   {
      if(reverse)
         return ORDER_COMMENT_PREFIX_BUY_COUNTER + IntegerToString(sequence) + "=" + lot_text + "手";
      return ORDER_COMMENT_PREFIX_BUY_TREND + IntegerToString(sequence) + "=" + lot_text + "手";
   }

   if(reverse)
      return ORDER_COMMENT_PREFIX_SELL_COUNTER + IntegerToString(sequence) + "=" + lot_text + "手";
   return ORDER_COMMENT_PREFIX_SELL_TREND + IntegerToString(sequence) + "=" + lot_text + "手";
}


//========================= 交易请求辅助 =========================
bool SendPendingOrder(const ENUM_ORDER_TYPE type, const double volume, const double price, const string cmt)
{
   MqlTradeRequest req;
   MqlTradeResult  res;
   ZeroMemory(req);
   ZeroMemory(res);

   req.action       = TRADE_ACTION_PENDING;
   req.magic        = Magic;
   req.symbol       = _Symbol;
   req.volume       = volume;
   req.type         = type;
   req.price        = NormalizePrice(price);
   req.sl           = 0.0;
   req.tp           = 0.0;
   req.deviation    = SlippagePoints;
   req.type_time    = ORDER_TIME_GTC;
   req.type_filling = ORDER_FILLING_RETURN;
   req.comment      = cmt;

   bool ok = OrderSend(req, res);
   if(!ok || (res.retcode != TRADE_RETCODE_DONE && res.retcode != TRADE_RETCODE_PLACED))
   {
      if(Verbose)
         Print("挂单失败 type=", type, " ret=", res.retcode, " err=", GetLastError(), " ", res.comment);
      return false;
   }

   return true;
}

// 修改挂单价格（不设SL/TP，出场由持仓移动止损管理）
bool ModifyPending(const ulong orderTicket, const double newPrice)
{
   MqlTradeRequest req;
   MqlTradeResult  res;
   ZeroMemory(req);
   ZeroMemory(res);

   req.action = TRADE_ACTION_MODIFY;
   req.order  = orderTicket;
   req.symbol = _Symbol;
   req.price  = NormalizePrice(newPrice);
   req.sl     = 0.0;
   req.tp     = 0.0;

   bool ok = OrderSend(req, res);
   if(!ok || (res.retcode != TRADE_RETCODE_DONE && res.retcode != TRADE_RETCODE_PLACED))
   {
      if(Verbose)
         Print("修改挂单失败 ticket=", orderTicket, " ret=", res.retcode, " ", res.comment);
      return false;
   }
   return true;
}

// 修改持仓止损（保留原TP，移动止损专用）
bool ModifyPositionSL(const ulong posTicket, const double sl)
{
   if(!PositionSelectByTicket(posTicket)) return false;

   MqlTradeRequest req;
   MqlTradeResult  res;
   ZeroMemory(req);
   ZeroMemory(res);

   req.action   = TRADE_ACTION_SLTP;
   req.position = posTicket;
   req.symbol   = _Symbol;
   req.sl       = NormalizePrice(sl);
   req.tp       = PositionGetDouble(POSITION_TP);

   bool ok = OrderSend(req, res);
   if(!ok || (res.retcode != TRADE_RETCODE_DONE && res.retcode != TRADE_RETCODE_PLACED))
   {
      if(Verbose)
         Print("修改移动止损失败 pos=", posTicket, " ret=", res.retcode, " ", res.comment);
      return false;
   }
   return true;
}

// 同方向持仓加权均价（整体移动止损基准）
bool GetDirectionBasketVWAP(const int dir, double &vwap, double &totalLots, int &posCount)
{
   vwap = 0.0;
   totalLots = 0.0;
   posCount = 0;
   double sumPriceVol = 0.0;

   int pTotal = PositionsTotal();
   for(int i = 0; i < pTotal; ++i)
   {
      ulong ptk = PositionGetTicket(i);
      if(ptk == 0) continue;
      if(!PositionSelectByTicket(ptk)) continue;

      string sym = PositionGetString(POSITION_SYMBOL);
      long mgc   = PositionGetInteger(POSITION_MAGIC);
      long type  = PositionGetInteger(POSITION_TYPE);

      if(sym != _Symbol || mgc != Magic) continue;
      if(dir > 0 && type != POSITION_TYPE_BUY) continue;
      if(dir < 0 && type != POSITION_TYPE_SELL) continue;

      double vol = PositionGetDouble(POSITION_VOLUME);
      double op  = PositionGetDouble(POSITION_PRICE_OPEN);
      sumPriceVol += op * vol;
      totalLots += vol;
      posCount++;
   }

   if(totalLots <= 0.0 || posCount <= 0) return false;
   vwap = sumPriceVol / totalLots;
   return true;
}

bool IsChartPriceLineEnabled()
{
   return (显示多单加权成本价线 || 显示空单加权成本价线 ||
           显示多单爆仓预估价线 || 显示空单爆仓预估价线);
}

void ResetChartPriceLineCaches()
{
   g_cache_long_cost.visible = false;
   g_cache_long_cost.price = -1.0;
   g_cache_long_cost.t1 = 0;
   g_cache_long_cost.t2 = 0;
   g_cache_long_cost.label_text = "";
   g_cache_short_cost = g_cache_long_cost;
   g_cache_long_margin = g_cache_long_cost;
   g_cache_short_margin = g_cache_long_cost;
   g_chart_price_line_bar_time = 0;
   g_chart_line_last_long_cnt = -1;
   g_chart_line_last_short_cnt = -1;
   g_chart_price_lines_inited = false;
}

void GetChartPriceLineTimeRange(datetime &t1, datetime &t2)
{
   const int periodSec = PeriodSeconds(_Period);
   if(periodSec <= 0)
   {
      t1 = TimeCurrent();
      t2 = t1;
      return;
   }

   t1 = iTime(_Symbol, _Period, 0) + periodSec;
   t2 = t1 + (datetime)(periodSec * (CHART_PRICE_LINE_SEG_BARS - 1));
}

void DeleteChartPriceLineObjects()
{
   for(int i = ObjectsTotal(0, -1, -1) - 1; i >= 0; --i)
   {
      const string name = ObjectName(0, i, -1, -1);
      if(StringFind(name, CHART_LINE_PREFIX, 0) == 0)
         ObjectDelete(0, name);
   }

   ResetChartPriceLineCaches();
}

bool ChartPriceValueChanged(const double oldPrice, const double newPrice)
{
   if(oldPrice <= 0.0 && newPrice <= 0.0)
      return false;
   if(oldPrice <= 0.0 || newPrice <= 0.0)
      return true;

   const double minDelta = MathMax(_Point, g_pipScale * 0.1);
   return MathAbs(newPrice - oldPrice) >= minDelta;
}

void EnsureChartPriceTrendObject(const string lineName,
                                 const datetime t1,
                                 const datetime t2,
                                 const double price,
                                 const color lineColor,
                                 const int width)
{
   const double drawPrice = NormalizePrice(price);

   if(ObjectFind(0, lineName) >= 0)
   {
      if((int)ObjectGetInteger(0, lineName, OBJPROP_TYPE) != OBJ_TREND)
         ObjectDelete(0, lineName);
   }

   if(ObjectFind(0, lineName) < 0)
   {
      ObjectCreate(0, lineName, OBJ_TREND, 0, t1, drawPrice, t2, drawPrice);
      ObjectSetInteger(0, lineName, OBJPROP_COLOR, lineColor);
      ObjectSetInteger(0, lineName, OBJPROP_WIDTH, width);
      ObjectSetInteger(0, lineName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, lineName, OBJPROP_RAY_RIGHT, false);
      ObjectSetInteger(0, lineName, OBJPROP_RAY_LEFT, false);
      ObjectSetInteger(0, lineName, OBJPROP_BACK, true);
      ObjectSetInteger(0, lineName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, lineName, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, lineName, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
      return;
   }

   ObjectMove(0, lineName, 0, t1, drawPrice);
   ObjectMove(0, lineName, 1, t2, drawPrice);
}

void EnsureChartPriceLabelObject(const string labelName,
                                 const datetime t2,
                                 const double price,
                                 const color textColor,
                                 const string text)
{
   const double drawPrice = NormalizePrice(price);

   if(ObjectFind(0, labelName) >= 0)
   {
      if((int)ObjectGetInteger(0, labelName, OBJPROP_TYPE) != OBJ_TEXT)
         ObjectDelete(0, labelName);
   }

   if(ObjectFind(0, labelName) < 0)
   {
      ObjectCreate(0, labelName, OBJ_TEXT, 0, t2, drawPrice);
      ObjectSetInteger(0, labelName, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, labelName, OBJPROP_ANCHOR, ANCHOR_LEFT);
      ObjectSetInteger(0, labelName, OBJPROP_BACK, false);
      ObjectSetInteger(0, labelName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, labelName, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, labelName, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
   }

   ObjectSetString(0, labelName, OBJPROP_TEXT, text);
   ObjectSetInteger(0, labelName, OBJPROP_COLOR, textColor);
   ObjectMove(0, labelName, 0, t2, drawPrice);
}

void InitChartPriceLineObjects()
{
   if(g_chart_price_lines_inited)
      return;

   datetime t1 = 0;
   datetime t2 = 0;
   GetChartPriceLineTimeRange(t1, t2);

   EnsureChartPriceTrendObject(CHART_LINE_PREFIX + "LongCost", t1, t2, 0.0, clrLime, 2);
   EnsureChartPriceTrendObject(CHART_LINE_PREFIX + "ShortCost", t1, t2, 0.0, clrMagenta, 2);
   EnsureChartPriceTrendObject(CHART_LINE_PREFIX + "LongMargin", t1, t2, 0.0, clrRed, 1);
   EnsureChartPriceTrendObject(CHART_LINE_PREFIX + "ShortMargin", t1, t2, 0.0, clrOrange, 1);
   g_chart_price_lines_inited = true;
}

void SetChartPriceLineVisible(const string lineName, const bool visible)
{
   if(ObjectFind(0, lineName) < 0)
      return;

   ObjectSetInteger(0, lineName, OBJPROP_TIMEFRAMES, visible ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
}

void UpdateChartPriceSegmentLine(ChartPriceLineCache &cache,
                               const string lineName,
                               const string labelName,
                               const datetime t1,
                               const datetime t2,
                               const double price,
                               const color lineColor,
                               const int width,
                               const string displayText,
                               const bool show)
{
   InitChartPriceLineObjects();

   if(!show || price <= 0.0)
   {
      if(cache.visible)
      {
         SetChartPriceLineVisible(lineName, false);
         SetChartPriceLineVisible(labelName, false);
         cache.visible = false;
         cache.price = -1.0;
         cache.t1 = 0;
         cache.t2 = 0;
         cache.label_text = "";
      }
      return;
   }

   const double drawPrice = NormalizePrice(price);
   const bool priceChanged = ChartPriceValueChanged(cache.price, drawPrice);
   const bool timeChanged = (cache.t1 != t1 || cache.t2 != t2);
   const bool labelChanged = (cache.label_text != displayText);

   if(!cache.visible)
   {
      SetChartPriceLineVisible(lineName, true);
      SetChartPriceLineVisible(labelName, true);
   }

   if(priceChanged || timeChanged || !cache.visible)
      EnsureChartPriceTrendObject(lineName, t1, t2, drawPrice, lineColor, width);

   if(priceChanged || timeChanged || labelChanged || !cache.visible)
      EnsureChartPriceLabelObject(labelName, t2, drawPrice, lineColor, displayText);

   if(priceChanged || !cache.visible)
      ObjectSetString(0, lineName, OBJPROP_TOOLTIP, displayText);

   cache.visible = true;
   cache.price = drawPrice;
   cache.t1 = t1;
   cache.t2 = t2;
   cache.label_text = displayText;
}

bool ShouldRefreshChartPriceLines(const int longCount, const int shortCount)
{
   const datetime bar0 = iTime(_Symbol, _Period, 0);

   if(longCount != g_chart_line_last_long_cnt || shortCount != g_chart_line_last_short_cnt)
      return true;
   if(bar0 != g_chart_price_line_bar_time)
      return true;

   return false;
}

double CalcLongStopoutEstimatePrice(const double avgPrice, const double lots)
{
   if(lots <= 0.0 || avgPrice <= 0.0) return 0.0;

   const double contractSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   const double leverage = (double)AccountInfoInteger(ACCOUNT_LEVERAGE);
   if(contractSize <= 0.0 || leverage <= 0.0) return 0.0;

   const double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   const double marginPerLot = contractSize / leverage;
   const double totalMargin = lots * marginPerLot;
   const double stopoutEquity = totalMargin * CHART_STOPOUT_MARGIN_LEVEL;
   const double lossCanBear = equity - stopoutEquity;
   const double pipValue = contractSize * lots;
   if(pipValue <= 0.0) return 0.0;

   return NormalizePrice(avgPrice - lossCanBear / pipValue);
}

double CalcShortStopoutEstimatePrice(const double avgPrice, const double lots)
{
   if(lots <= 0.0 || avgPrice <= 0.0) return 0.0;

   const double contractSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   const double leverage = (double)AccountInfoInteger(ACCOUNT_LEVERAGE);
   if(contractSize <= 0.0 || leverage <= 0.0) return 0.0;

   const double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   const double marginPerLot = contractSize / leverage;
   const double totalMargin = lots * marginPerLot;
   const double stopoutEquity = totalMargin * CHART_STOPOUT_MARGIN_LEVEL;
   const double lossCanBear = equity - stopoutEquity;
   const double pipValue = contractSize * lots;
   if(pipValue <= 0.0) return 0.0;

   return NormalizePrice(avgPrice + lossCanBear / pipValue);
}

void DrawChartPriceLines(const bool force_refresh = false)
{
   if(!IsChartPriceLineEnabled())
   {
      DeleteChartPriceLineObjects();
      return;
   }

   double longVwap = 0.0;
   double shortVwap = 0.0;
   double longLots = 0.0;
   double shortLots = 0.0;
   int longCount = 0;
   int shortCount = 0;

   const bool hasLong = GetDirectionBasketVWAP(+1, longVwap, longLots, longCount);
   const bool hasShort = GetDirectionBasketVWAP(-1, shortVwap, shortLots, shortCount);

   if(!force_refresh && !ShouldRefreshChartPriceLines(longCount, shortCount))
      return;

   datetime t1 = 0;
   datetime t2 = 0;
   GetChartPriceLineTimeRange(t1, t2);

   UpdateChartPriceSegmentLine(
      g_cache_long_cost,
      CHART_LINE_PREFIX + "LongCost",
      CHART_LINE_PREFIX + "LongCostLbl",
      t1, t2, longVwap, clrLime, 2,
      "多单成本价:" + DoubleToString(longVwap, _Digits),
      hasLong && 显示多单加权成本价线);

   UpdateChartPriceSegmentLine(
      g_cache_short_cost,
      CHART_LINE_PREFIX + "ShortCost",
      CHART_LINE_PREFIX + "ShortCostLbl",
      t1, t2, shortVwap, clrMagenta, 2,
      "空单成本价:" + DoubleToString(shortVwap, _Digits),
      hasShort && 显示空单加权成本价线);

   const double longStopout = CalcLongStopoutEstimatePrice(longVwap, longLots);
   UpdateChartPriceSegmentLine(
      g_cache_long_margin,
      CHART_LINE_PREFIX + "LongMargin",
      CHART_LINE_PREFIX + "LongMarginLbl",
      t1, t2, longStopout, clrRed, 1,
      "多单爆仓价:" + DoubleToString(longStopout, _Digits),
      hasLong && 显示多单爆仓预估价线);

   const double shortStopout = CalcShortStopoutEstimatePrice(shortVwap, shortLots);
   UpdateChartPriceSegmentLine(
      g_cache_short_margin,
      CHART_LINE_PREFIX + "ShortMargin",
      CHART_LINE_PREFIX + "ShortMarginLbl",
      t1, t2, shortStopout, clrOrange, 1,
      "空单爆仓价:" + DoubleToString(shortStopout, _Digits),
      hasShort && 显示空单爆仓预估价线);

   g_chart_price_line_bar_time = iTime(_Symbol, _Period, 0);
   g_chart_line_last_long_cnt = longCount;
   g_chart_line_last_short_cnt = shortCount;
}

// 同方向当前最紧止损（多：最高SL；空：最低SL）
bool GetDirectionTightestSL(const int dir, double &tightestSL, bool &hasSL)
{
   tightestSL = 0.0;
   hasSL = false;

   int pTotal = PositionsTotal();
   for(int i = 0; i < pTotal; ++i)
   {
      ulong ptk = PositionGetTicket(i);
      if(ptk == 0) continue;
      if(!PositionSelectByTicket(ptk)) continue;

      string sym = PositionGetString(POSITION_SYMBOL);
      long mgc   = PositionGetInteger(POSITION_MAGIC);
      long type  = PositionGetInteger(POSITION_TYPE);
      double sl  = PositionGetDouble(POSITION_SL);

      if(sym != _Symbol || mgc != Magic) continue;
      if(dir > 0 && type != POSITION_TYPE_BUY) continue;
      if(dir < 0 && type != POSITION_TYPE_SELL) continue;
      if(sl <= 0.0) continue;

      if(!hasSL)
      {
         tightestSL = sl;
         hasSL = true;
      }
      else if(dir > 0)
         tightestSL = MathMax(tightestSL, sl);
      else
         tightestSL = MathMin(tightestSL, sl);
   }
   return hasSL;
}

// 同方向全部持仓统一设置止损（整体移动止盈/止损）
void ApplyBasketSLToDirection(const int dir, const double newSL)
{
   int pTotal = PositionsTotal();
   for(int i = pTotal - 1; i >= 0; --i)
   {
      ulong ptk = PositionGetTicket(i);
      if(ptk == 0) continue;
      if(!PositionSelectByTicket(ptk)) continue;

      string sym = PositionGetString(POSITION_SYMBOL);
      long mgc   = PositionGetInteger(POSITION_MAGIC);
      long type  = PositionGetInteger(POSITION_TYPE);
      double sl  = PositionGetDouble(POSITION_SL);

      if(sym != _Symbol || mgc != Magic) continue;
      if(dir > 0 && type != POSITION_TYPE_BUY) continue;
      if(dir < 0 && type != POSITION_TYPE_SELL) continue;

      if(MathAbs(sl - newSL) <= _Point) continue;
      ModifyPositionSL(ptk, newSL);
   }
}

// 单方向整体移动止损：均价浮盈达 TPfact*Filter 后，同向仓位共用同一 SL（仅收紧）
void UpdateBasketTrailingForDirection(const int dir)
{
   double vwap = 0.0, totalLots = 0.0;
   int posCount = 0;
   if(!GetDirectionBasketVWAP(dir, vwap, totalLots, posCount)) return;

   double trailStart = g_trailStartPoints * g_pipScale;
   double trailStep  = g_trailStepPoints * g_pipScale;
   if(trailStart <= 0.0 || trailStep <= 0.0) return;

   double newSL = 0.0;
   if(dir > 0)
   {
      double bid = GetBid();
      if(bid - vwap < trailStart) return;

      newSL = NormalizePrice(bid - trailStep);
      if(newSL >= bid - g_stopDistance) return;

      double tightestSL = 0.0;
      bool hasSL = false;
      GetDirectionTightestSL(+1, tightestSL, hasSL);
      if(hasSL && newSL <= tightestSL + _Point) return;
   }
   else
   {
      double ask = GetAsk();
      if(vwap - ask < trailStart) return;

      newSL = NormalizePrice(ask + trailStep);
      if(newSL <= ask + g_stopDistance) return;

      double tightestSL = 0.0;
      bool hasSL = false;
      GetDirectionTightestSL(-1, tightestSL, hasSL);
      if(hasSL && newSL >= tightestSL - _Point) return;
   }

   ApplyBasketSLToDirection(dir, newSL);
}

// 多空分别整体移动止损（同方向加仓后一并出场）
void UpdateTrailingStops()
{
   UpdateBasketTrailingForDirection(+1);
   UpdateBasketTrailingForDirection(-1);
}

double GetExpectedPendingLots(const int dir)
{
   double lots = g_nextLots * GetDirectionalLotFactor(dir);
   if(IsTrendDirection(dir) && g_reverseLossCarryLots > 0.0)
      lots += g_reverseLossCarryLots;
   lots = NormalizeVolume(lots);
   return lots;
}

// 删除某方向突破挂单（dir>0删BuyStop, dir<0删SellStop）
void DeletePendingByDirection(const int dir)
{
   for(int round = 0; round < 30; ++round)
   {
      bool needRetry = false;
      int total = OrdersTotal();

      for(int i = total - 1; i >= 0; --i)
      {
         if(!SelectOrderByIndex(i)) continue;

         string sym = OrderGetString(ORDER_SYMBOL);
         long mgc   = OrderGetInteger(ORDER_MAGIC);
         long type  = OrderGetInteger(ORDER_TYPE);
         ulong tk   = (ulong)OrderGetInteger(ORDER_TICKET);

         if(sym != _Symbol || mgc != Magic) continue;

         bool matchBuy  = (dir > 0 && type == ORDER_TYPE_BUY_STOP);
         bool matchSell = (dir < 0 && type == ORDER_TYPE_SELL_STOP);
         if(!(matchBuy || matchSell)) continue;

         MqlTradeRequest req;
         MqlTradeResult  res;
         ZeroMemory(req);
         ZeroMemory(res);

         req.action = TRADE_ACTION_REMOVE;
         req.order  = tk;
         req.symbol = _Symbol;

         bool ok = OrderSend(req, res);
         if(!ok || (res.retcode != TRADE_RETCODE_DONE && res.retcode != TRADE_RETCODE_PLACED))
         {
            needRetry = true;
            if(Verbose) Print("删除挂单失败 ticket=", tk, " ret=", res.retcode);
         }
      }

      if(!needRetry) return;
      Sleep(200);
   }

   if(Verbose) Print("DeletePendingByDirection 超过重试上限");
}

// 删除某方向逆势加仓限价单
void DeleteAddPendingByDirection(const int dir)
{
   for(int round = 0; round < 30; ++round)
   {
      bool needRetry = false;
      int total = OrdersTotal();

      for(int i = total - 1; i >= 0; --i)
      {
         if(!SelectOrderByIndex(i)) continue;

         string sym = OrderGetString(ORDER_SYMBOL);
         long mgc   = OrderGetInteger(ORDER_MAGIC);
         long type  = OrderGetInteger(ORDER_TYPE);
         ulong tk   = (ulong)OrderGetInteger(ORDER_TICKET);
         string cmt = OrderGetString(ORDER_COMMENT);

         if(sym != _Symbol || mgc != Magic) continue;
         bool matchBuy  = (dir > 0 && type == ORDER_TYPE_BUY_LIMIT && IsBuyAddOrderComment(cmt));
         bool matchSell = (dir < 0 && type == ORDER_TYPE_SELL_LIMIT && IsSellAddOrderComment(cmt));
         if(!(matchBuy || matchSell)) continue;

         MqlTradeRequest req;
         MqlTradeResult  res;
         ZeroMemory(req);
         ZeroMemory(res);

         req.action = TRADE_ACTION_REMOVE;
         req.order  = tk;
         req.symbol = _Symbol;

         bool ok = OrderSend(req, res);
         if(!ok || (res.retcode != TRADE_RETCODE_DONE && res.retcode != TRADE_RETCODE_PLACED))
         {
            needRetry = true;
            if(Verbose) Print("删除加仓挂单失败 ticket=", tk, " ret=", res.retcode);
         }
      }

      if(!needRetry) return;
      Sleep(200);
   }

   if(Verbose) Print("DeleteAddPendingByDirection 超过重试上限");
}

// 取同方向持仓中“最逆势”的开仓价（多单取最低，空单取最高）
bool GetExtremeOpenPrice(const int dir, double &extremePrice)
{
   extremePrice = 0.0;
   bool found = false;

   int pTotal = PositionsTotal();
   for(int i = 0; i < pTotal; ++i)
   {
      ulong ptk = PositionGetTicket(i);
      if(ptk == 0) continue;
      if(!PositionSelectByTicket(ptk)) continue;

      string sym = PositionGetString(POSITION_SYMBOL);
      long mgc   = PositionGetInteger(POSITION_MAGIC);
      long type  = PositionGetInteger(POSITION_TYPE);
      double op  = PositionGetDouble(POSITION_PRICE_OPEN);

      if(sym != _Symbol || mgc != Magic) continue;

      if(dir > 0 && type != POSITION_TYPE_BUY) continue;
      if(dir < 0 && type != POSITION_TYPE_SELL) continue;

      if(!found)
      {
         extremePrice = op;
         found = true;
      }
      else if(dir > 0)
         extremePrice = MathMin(extremePrice, op);
      else
         extremePrice = MathMax(extremePrice, op);
   }
   return found;
}

// 统计某方向持仓浮盈浮亏（含库存费）
bool GetDirectionFloatingPnL(const int dir, double &floatingPnL)
{
   floatingPnL = 0.0;
   bool found = false;

   int pTotal = PositionsTotal();
   for(int i = 0; i < pTotal; ++i)
   {
      ulong ptk = PositionGetTicket(i);
      if(ptk == 0) continue;
      if(!PositionSelectByTicket(ptk)) continue;

      string sym = PositionGetString(POSITION_SYMBOL);
      long mgc   = PositionGetInteger(POSITION_MAGIC);
      long type  = PositionGetInteger(POSITION_TYPE);

      if(sym != _Symbol || mgc != Magic) continue;

      if(dir > 0 && type != POSITION_TYPE_BUY) continue;
      if(dir < 0 && type != POSITION_TYPE_SELL) continue;

      floatingPnL += PositionGetDouble(POSITION_PROFIT)
                  + PositionGetDouble(POSITION_SWAP);
      found = true;
   }
   return found;
}

// 是否反方向（相对D1 EMA趋势）—— 固定手数加仓、间距×2
bool IsReverseAddSide(const int dir)
{
   return !IsTrendDirection(dir);
}

// 第N笔订单的加仓间距层倍数（前两笔=1.0，第三笔起逐层×AddSpacingExpandMult）
double GetAddLayerSpacingMultiplier(const int nextLayer)
{
   if(nextLayer < AddSpacingExpandFrom)
      return 1.0;
   if(AddSpacingExpandMult <= 0.0)
      return 1.0;

   const int expandSteps = nextLayer - AddSpacingExpandFrom + 1;
   return MathPow(AddSpacingExpandMult, expandSteps);
}

// 逆势加仓间距点数（反方向×2；第三笔起再乘层倍数；顺位后按剩余层数计）
double GetAddSpacingPoints(const int dir)
{
   double pts = g_addPendingSpacingPoints;
   if(IsReverseAddSide(dir))
      pts *= 2.0;

   const int posCount = GetDirectionPositionCount(dir);
   if(posCount > 0)
      pts *= GetAddLayerSpacingMultiplier(GetEffectiveNextLayer(dir));

   return pts;
}

// 逆势加仓方向 = 浮亏方向（该方向合计浮盈浮亏 < 0）
bool IsAdverseAddDirection(const int dir)
{
   double floatingPnL = 0.0;
   if(!GetDirectionFloatingPnL(dir, floatingPnL)) return false;
   return floatingPnL < 0.0;
}

// 下一笔逆势加仓手数（固定15层；反方向=ReverseDirectionLot，顺方向=CustomLot循环）
double GetNextAddLot(const int dir)
{
   const int posCount = GetDirectionPositionCount(dir);
   if(posCount <= 0) return 0.0;

   if(IsReverseAddSide(dir))
   {
      double lots = ReverseDirectionLot;
      if(lots <= 0.0) lots = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
      return NormalizeVolume(lots);
   }

   int step = GetEffectiveNextLayer(dir);
   if(step < 1) step = 1;
   if(step > MAX_ADD_LAYERS) step = MAX_ADD_LAYERS;

   return NormalizeVolume(GetCustomLotByStep(step));
}

// 计算逆势加仓限价（不设SL/TP，出场由移动止损管理）
bool BuildAddLimitPrices(const int dir, double &op)
{
   double spacing = GetAddSpacingPoints(dir) * g_pipScale;
   if(spacing <= 0.0) return false;

   double refPrice = 0.0;
   if(!GetExtremeOpenPrice(dir, refPrice)) return false;

   if(dir > 0)
      op = refPrice - spacing;
   else
      op = refPrice + spacing;

   op = NormalizePrice(op);
   return (op > 0.0);
}

// 挂逆势加仓限价单（同方向，CustomLot循环手数）
bool CanAllowBuy()
{
   if(!g_allow_buy || g_stop_new_orders) return false;
   if(g_news_state.block_entries) return false;

   EAStats stats;
   CollectStats(stats);
   const datetime now_value = ReferenceNow();
   RefreshDailyLocks(now_value, stats);

   if(!IsTradingSessionOpen(now_value)) return false;
   if(IsTradingSessionAfterStop(now_value)) return false;
   if(IsDailyWrapUpWindow(ReferenceNewsNow())) return false;
   if(g_daily_target_locked) return false;

   string env_reason = "";
   if(!IsTradingEnvironmentOk(stats, env_reason)) return false;
   return true;
}

bool CanAllowSell()
{
   if(!g_allow_sell || g_stop_new_orders) return false;
   if(g_news_state.block_entries) return false;

   EAStats stats;
   CollectStats(stats);
   const datetime now_value = ReferenceNow();
   RefreshDailyLocks(now_value, stats);

   if(!IsTradingSessionOpen(now_value)) return false;
   if(IsTradingSessionAfterStop(now_value)) return false;
   if(IsDailyWrapUpWindow(ReferenceNewsNow())) return false;
   if(g_daily_target_locked) return false;

   string env_reason = "";
   if(!IsTradingEnvironmentOk(stats, env_reason)) return false;
   return true;
}

bool PlaceOneAddPendingByDir(const int dir)
{
   if(!CanAllowBuy() && dir > 0) return false;
   if(!CanAllowSell() && dir < 0) return false;
   if(!IsAdverseAddDirection(dir)) return false;

   const int posCount = GetDirectionPositionCount(dir);
   if(posCount <= 0) return false;

   if(posCount >= MAX_ADD_LAYERS) return false;

   if(dir > 0 && g_buyAddPendingLots > 0.0) return false;
   if(dir < 0 && g_sellAddPendingLots > 0.0) return false;

   double lots = GetNextAddLot(dir);
   if(lots <= 0.0) return false;

   double op;
   if(!BuildAddLimitPrices(dir, op)) return false;

   const int nextLayer = GetEffectiveNextLayer(dir);
   const int addSequence = GetEffectiveAddSequence(dir);
   const string orderComment = BuildAddOrderComment(dir, addSequence, lots);

   if(dir > 0)
   {
      if(GapProtect && op >= GetBid() - g_stopDistance) return false;

      if(Verbose)
         Print("准备逆势加仓 BUYLIMIT ", orderComment,
               (IsDirectionChainPromoted(+1) ? " [顺位]" : ""),
               " 有效第", IntegerToString(nextLayer), "层",
               " 间距=", DoubleToString(GetAddSpacingPoints(+1), 1),
               " 层倍数=", DoubleToString(GetAddLayerSpacingMultiplier(nextLayer), 2),
               " OP=", DoubleToString(op, _Digits));

      return SendPendingOrder(ORDER_TYPE_BUY_LIMIT, lots, op, orderComment);
   }

   if(GapProtect && op <= GetAsk() + g_stopDistance) return false;

   if(Verbose)
      Print("准备逆势加仓 SELLLIMIT ", orderComment,
            (IsDirectionChainPromoted(-1) ? " [顺位]" : ""),
            " 有效第", IntegerToString(nextLayer), "层",
            " 间距=", DoubleToString(GetAddSpacingPoints(-1), 1),
            " 层倍数=", DoubleToString(GetAddLayerSpacingMultiplier(nextLayer), 2),
            " OP=", DoubleToString(op, _Digits));

   return SendPendingOrder(ORDER_TYPE_SELL_LIMIT, lots, op, orderComment);
}

void EvaluateAndPlaceAddPending()
{
   // 无持仓时清理残留加仓挂单
   if(g_buyPosCount == 0 && g_buyAddPendingLots > 0.0)
      DeleteAddPendingByDirection(+1);
   if(g_sellPosCount == 0 && g_sellAddPendingLots > 0.0)
      DeleteAddPendingByDirection(-1);

   if(g_buyPosCount > 0 && IsAdverseAddDirection(+1))
      PlaceOneAddPendingByDir(+1);
   else if(g_buyAddPendingLots > 0.0)
      DeleteAddPendingByDirection(+1);

   if(g_sellPosCount > 0 && IsAdverseAddDirection(-1))
      PlaceOneAddPendingByDir(-1);
   else if(g_sellAddPendingLots > 0.0)
      DeleteAddPendingByDirection(-1);
}

// 校验逆势加仓挂单手数，偏离则删后重挂
void SyncAddPendingLots()
{
   double volMin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);

   if(g_buyAddPendingLots > 0.0 && g_buyPosCount > 0 && IsAdverseAddDirection(+1))
   {
      double expected = GetNextAddLot(+1);
      if(g_buyAddPendingLots >= expected + volMin - 1e-8 || g_buyAddPendingLots <= expected - volMin + 1e-8)
      {
         DeleteAddPendingByDirection(+1);
         RecountOrdersAndPositions();
      }
   }

   if(g_sellAddPendingLots > 0.0 && g_sellPosCount > 0 && IsAdverseAddDirection(-1))
   {
      double expected = GetNextAddLot(-1);
      if(g_sellAddPendingLots >= expected + volMin - 1e-8 || g_sellAddPendingLots <= expected - volMin + 1e-8)
      {
         DeleteAddPendingByDirection(-1);
         RecountOrdersAndPositions();
      }
   }
}


//========================= 价格公式（核心） =========================
// 计算BuyStop挂单价（不设SL/TP）
void BuildBuyStopPrices(double &op)
{
   op = g_mainUpper + Indent * g_pipScale + g_spreadComp;
   op = NormalizePrice(op);
}

// 计算SellStop挂单价（不设SL/TP）
void BuildSellStopPrices(double &op)
{
   op = g_mainLower - Indent * g_pipScale;
   op = NormalizePrice(op);
}


//========================= 动态改单 =========================
// 边界变化后：更新突破挂单价格
void RepriceExistingOrdersIfNeeded()
{
   bool upperChanged = (NormalizePrice(g_mainUpper) != NormalizePrice(g_prevMainUpper));
   bool lowerChanged = (NormalizePrice(g_mainLower) != NormalizePrice(g_prevMainLower));
   double pendingMinDelta = MathMax(_Point, g_spreadComp);

   if(!upperChanged && !lowerChanged) return;

   int oTotal = OrdersTotal();
   for(int i = oTotal - 1; i >= 0; --i)
   {
      if(!SelectOrderByIndex(i)) continue;

      string sym = OrderGetString(ORDER_SYMBOL);
      long mgc   = OrderGetInteger(ORDER_MAGIC);
      long type  = OrderGetInteger(ORDER_TYPE);
      ulong tk   = (ulong)OrderGetInteger(ORDER_TICKET);

      if(sym != _Symbol || mgc != Magic) continue;
      if(type != ORDER_TYPE_BUY_STOP && type != ORDER_TYPE_SELL_STOP) continue;

      string cmt = OrderGetString(ORDER_COMMENT);
      if(IsAddOrderComment(cmt)) continue;

      double oldPrice = OrderGetDouble(ORDER_PRICE_OPEN);

      if(type == ORDER_TYPE_BUY_STOP)
      {
         double np;
         BuildBuyStopPrices(np);

         if(GapProtect && np <= GetAsk() + g_stopDistance) continue;

         if(MathAbs(np - oldPrice) >= pendingMinDelta)
            ModifyPending(tk, np);
      }
      else if(type == ORDER_TYPE_SELL_STOP)
      {
         double np;
         BuildSellStopPrices(np);

         if(GapProtect && np >= GetBid() - g_stopDistance) continue;

         if(MathAbs(np - oldPrice) >= pendingMinDelta)
            ModifyPending(tk, np);
      }
   }
}


//========================= 新增挂单逻辑 =========================
bool PlaceOnePendingByDir(const int dir, const double lots)
{
   if(dir > 0 && !CanAllowBuy()) return false;
   if(dir < 0 && !CanAllowSell()) return false;

   double finalLots = lots;
   if(finalLots <= 0.0) return false;
   finalLots *= GetDirectionalLotFactor(dir);
   if(IsTrendDirection(dir) && g_reverseLossCarryLots > 0.0)
      finalLots += g_reverseLossCarryLots;
   finalLots = NormalizeVolume(finalLots);
   if(finalLots <= 0.0) return false;

   if(dir > 0) // BUYSTOP
   {
      // 避免重复方向挂单
      if(g_buyStopCount > 0) return false;

      double op;
      BuildBuyStopPrices(op);

      // 条件2：最小有效距离保护
      if(GapProtect && op <= GetAsk() + g_stopDistance)
         return false;

      const string orderComment = BuildBreakthroughOrderComment(true, finalLots);

      if(Verbose)
         Print("准备BUYSTOP ", orderComment, " OP=", DoubleToString(op, _Digits));

      return SendPendingOrder(ORDER_TYPE_BUY_STOP, finalLots, op, orderComment);
   }
   else // SELLSTOP
   {
      if(g_sellStopCount > 0) return false;

      double op;
      BuildSellStopPrices(op);

      if(GapProtect && op >= GetBid() - g_stopDistance)
         return false;

      const string orderComment = BuildBreakthroughOrderComment(false, finalLots);

      if(Verbose)
         Print("准备SELLSTOP ", orderComment, " OP=", DoubleToString(op, _Digits));

      return SendPendingOrder(ORDER_TYPE_SELL_STOP, finalLots, op, orderComment);
   }
}

// 按剩余总手数分拆挂单（最多MaxSplitOrders次）
void PlacePendingByTotalLots(const int dir, double totalLots)
{
   double volMin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   if(totalLots < volMin - 1e-8) return;

   for(int k = 0; k < MaxSplitOrders; ++k)
   {
      if(totalLots < volMin - 1e-8) break;

      // 每次最多下到交易品种上限/用户上限
      double one = totalLots;
      double symbolMax = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
      if(one > symbolMax) one = symbolMax;

      one = NormalizeVolume(one);
      if(one < volMin - 1e-8) break;

      bool ok = PlaceOnePendingByDir(dir, one);
      if(!ok) break;

      totalLots -= one;
      totalLots = NormalizeDouble(totalLots, 8);

      // 成功后刷新计数，避免重复挂
      RecountOrdersAndPositions();

      // 本策略同方向默认只保留一个挂单，挂成功一次即可退出
      break;
   }
}


//========================= 面板显示 =========================
void ShowStatusComment()
{
   if(!DrawComment || HidePanel || EnableChartPanel)
   {
      Comment("");
      return;
   }

   string txt = "";
   txt += "双阶梯突破EA（MQ5完整版）\n\n";
   txt += "停止挂单: " + string(g_stop_new_orders ? "是" : "否") + "\n";
   txt += "外部协作: " + string(g_external_locked ? "是(外部GV锁定中)" : "否") + "\n";
   txt += "多单顺位: " + string(g_buy_chain_promoted ? "是(首单已平,加仓链续跑)" : "否");
   txt += "  空单顺位: " + string(g_sell_chain_promoted ? "是" : "否") + "\n";
   txt += "主上轨: " + DoubleToString(g_mainUpper, _Digits) + "\n";
   txt += "主下轨: " + DoubleToString(g_mainLower, _Digits) + "\n";
   txt += "辅上轨: " + DoubleToString(g_auxUpper, _Digits) + "\n";
   txt += "辅下轨: " + DoubleToString(g_auxLower, _Digits) + "\n\n";

   txt += "下一次手数: " + DoubleToString(g_nextLots, 2) + "\n";
   txt += "手数循环进度: 第" + IntegerToString(g_customLotStep) + "/" + IntegerToString(GetCustomLotCycleCount()) + "笔\n";
   txt += "EMA方向手数: " + GetDirectionalLotBiasText() + "\n";
   txt += "反向亏损累加手数: " + DoubleToString(g_reverseLossCarryLots, 2) + "\n";
   txt += "Buy持仓/挂单: " + IntegerToString(g_buyPosCount) + "/" + IntegerToString(g_buyStopCount);
   txt += " 加仓:" + IntegerToString(g_buyLimitCount) + " 层:" + IntegerToString(g_buyPosCount) + "/" + IntegerToString(MAX_ADD_LAYERS) + "\n";
   txt += "Sell持仓/挂单: " + IntegerToString(g_sellPosCount) + "/" + IntegerToString(g_sellStopCount);
   txt += " 加仓:" + IntegerToString(g_sellLimitCount) + " 层:" + IntegerToString(g_sellPosCount) + "/" + IntegerToString(MAX_ADD_LAYERS) + "\n\n";

   txt += "连亏笔数: " + IntegerToString(g_consecutiveLossCount) + "\n";
   txt += "连亏金额: " + DoubleToString(g_consecutiveLossMoney, 2) + "\n";
   txt += "历史最大连亏笔数: " + IntegerToString(g_maxConsecutiveLoss) + "\n";
   txt += "历史最深连亏金额: " + DoubleToString(g_worstLossMoney, 2) + "\n\n";

   txt += "spread补偿: " + DoubleToString(g_spreadComp, _Digits) + "\n";
   txt += "最小有效距离: " + DoubleToString(g_stopDistance, _Digits) + "\n";
   txt += "整体移动止损启动: " + DoubleToString(g_trailStartPoints, 2) + "  追踪步长: " + DoubleToString(g_trailStepPoints, 2) + "\n";
   txt += "加仓间距: " + DoubleToString(g_addPendingSpacingPoints, 2) + "  反方向间距: " + DoubleToString(g_addPendingSpacingPoints * 2.0, 2) + "\n";
   txt += "层间距扩大: 第" + IntegerToString(AddSpacingExpandFrom) + "笔起×" + DoubleToString(AddSpacingExpandMult, 2) + " 逐层递增\n";

   Comment(txt);
}


//========================= 核心流程 =========================
void UpdateBoundariesFromLadders()
{
   // 保存旧边界，用于判断是否变更
   g_prevMainUpper = g_mainUpper;
   g_prevMainLower = g_mainLower;

   // 1) 更新双阶梯
   double step1 = Filter * g_pipScale;
   double step2 = SecondFilter * g_pipScale;
   if(step1 <= 0.0 || step2 <= 0.0) return;

   UpdateLadder(g_ladder1, step1);
   UpdateLadder(g_ladder2, step2);

   // 2) 提取边界
   ExtractBoundaries(g_ladder1, g_mainUpper, g_mainLower);
   ExtractBoundaries(g_ladder2, g_auxUpper, g_auxLower);

   // 3) 若边界尚未形成，用前一日高低回退
   if(g_mainUpper <= 0.0)
      g_mainUpper = MathMax(iHigh(_Symbol, PERIOD_D1, 1), GetAsk() + Filter * g_pipScale);
   if(g_mainLower <= 0.0)
      g_mainLower = MathMin(iLow(_Symbol, PERIOD_D1, 1), GetBid() - Filter * g_pipScale);

   g_mainUpper = NormalizePrice(g_mainUpper);
   g_mainLower = NormalizePrice(g_mainLower);
}

void EvaluateAndPlacePending()
{
   // 条件2：不是“碰到就挂”，而是要有安全距离
   // 顺位链（首单已平、仅剩加仓）不再挂新突破首单
   bool canBuy =
      (g_buyPosCount == 0 && !g_buy_chain_promoted && g_buyStopCount == 0 &&
       GetAsk() < g_mainUpper - 5.0 * g_stopDistance &&
       CanAllowBuy());

   bool canSell =
      (g_sellPosCount == 0 && !g_sell_chain_promoted && g_sellStopCount == 0 &&
       GetBid() > g_mainLower + 5.0 * g_stopDistance &&
       CanAllowSell());

   if(canBuy)
   {
      PlacePendingByTotalLots(+1, g_nextLots);
   }
   if(canSell)
   {
      PlacePendingByTotalLots(-1, g_nextLots);
   }
}

void OnTickCore()
{
   RefreshExternalTakeoverState();
   RefreshNewsState(false);

   EAStats panelStats;
   CollectStats(panelStats);
   const datetime now_value = ReferenceNow();
   RefreshDailyLocks(now_value, panelStats);

   const bool news_blocked = g_news_state.block_entries;
   const bool session_blocked = (!IsTradingSessionOpen(now_value) || IsTradingSessionAfterStop(now_value));
   const bool wrap_up_blocked = IsDailyWrapUpWindow(ReferenceNewsNow());
   const bool target_locked = g_daily_target_locked;

   if((news_blocked || session_blocked || wrap_up_blocked || target_locked) &&
      HasActiveExposure(panelStats))
   {
      DeleteEaPendingOrders();
   }

   UpdateMarketDerivedValues();
   UpdateBoundariesFromLadders();

   // 统计
   RecountOrdersAndPositions();
   MaintainPromotedChain(+1);
   MaintainPromotedChain(-1);
   RecountOrdersAndPositions();
   UpdateConsecutiveLossStats();

   // 边界变化则动态改单
   RepriceExistingOrdersIfNeeded();

   UpdateTrailingStops();
   UpdateCustomLotCycle();

   // 计算下一次挂单手数
   g_nextLots = CalcNextLots();

   // 若当前挂单手数偏离目标，可删后重挂（方向独立；顺位链不校验突破Stop）
   double volMin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);

   if(g_buyStopCount > 0 && !g_buy_chain_promoted)
   {
      double expectedBuyLots = GetExpectedPendingLots(+1);
      if(g_buyPendingLots >= expectedBuyLots + volMin - 1e-8 || g_buyPendingLots <= expectedBuyLots - volMin + 1e-8)
      {
         DeletePendingByDirection(+1);
         RecountOrdersAndPositions();
      }
   }

   if(g_sellStopCount > 0 && !g_sell_chain_promoted)
   {
      double expectedSellLots = GetExpectedPendingLots(-1);
      if(g_sellPendingLots >= expectedSellLots + volMin - 1e-8 || g_sellPendingLots <= expectedSellLots - volMin + 1e-8)
      {
         DeletePendingByDirection(-1);
         RecountOrdersAndPositions();
      }
   }

   EvaluateAndPlacePending();
   SyncAddPendingLots();
   EvaluateAndPlaceAddPending();

   if(IsChartPriceLineEnabled())
      DrawChartPriceLines(false);

   // 面板
   ShowStatusComment();
   if(EnableChartPanel)
      RefreshPanel(false);
}


//========================= MT5 事件 =========================
int OnInit()
{
   g_pipScale = DetectPipScale();
   g_stop_new_orders = Flag_Stop;
   g_allow_buy = true;
   g_allow_sell = true;
   g_panel_open = false;
   g_panel_x = PanelStartX;
   g_panel_y = PanelStartY;

   InitLadder(g_ladder1);
   InitLadder(g_ladder2);

   trade.SetExpertMagicNumber(Magic);
   trade.SetDeviationInPoints(SlippagePoints);

   ResetNewsState(g_news_state);
   g_news_cache_minute = 0;

   if(HideChartGrid)
      ChartSetInteger(0, CHART_SHOW_GRID, false);
   ChartSetInteger(0, CHART_SHOW_TRADE_HISTORY, false); // 隐藏成交历史箭头

   if(EnableChartPanel)
   {
      InitPanelPosition();
      DeleteObjectsByPrefix(g_panel_prefix);
      RefreshNewsState(true);
      ChartSetInteger(0, CHART_EVENT_OBJECT_CREATE, true);
      ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
      RefreshPanel(true);
   }
   else
   {
      RefreshNewsState(true);
   }

   if(EnableChartPanel)
      EventSetTimer(1);

   if(IsChartPriceLineEnabled())
   {
      InitChartPriceLineObjects();
      DrawChartPriceLines(true);
   }

   PublishExternalEaActiveMarker();
   RefreshExternalTakeoverState();

   if(Verbose)
   {
      Print("初始化完成: Symbol=", _Symbol,
            " Digits=", _Digits,
            " pipScale=", DoubleToString(g_pipScale, 6),
            " Magic=", Magic,
            " 外部锁GV=", BuildExternalLockGVName(),
            " 活跃GV=", BuildExternalActiveGVName());
   }

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   DeleteObjectsByPrefix(g_panel_prefix);
   DeleteChartPriceLineObjects();
   ClearExternalEaActiveMarker();
   Comment("");
}

void OnTick()
{
   OnTickCore();
}

void OnTimer()
{
   if(EnableChartPanel)
      RefreshPanel(false);
}