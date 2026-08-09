//+------------------------------------------------------------------+
//|      融合交易系统 - 对冲引擎 + 浮亏监控 + 多UI方案                  |
//+------------------------------------------------------------------+
#property copyright "Fusion EA"
#property link      ""
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

// ====================================================================
// 配置层 - 所有输入参数
// ====================================================================

// ========== 对冲引擎参数（来自原对冲EA） ==========
input double LossThreshold = 1000;              // 启动对冲的总浮亏阈值
input double MinRemainProfit = 5;               // 当天最小保留盈利
input double MaxProfitConsumeRatio = 0.9;      // 当天盈利最多消耗比例
input double MinHedgeLots = 0.01;               // 每次最小对冲手数
input int    HedgeCheckInterval = 30;           // 对冲检测周期（分钟）
input bool   EnableHedgeAlert = true;           // 对冲弹窗提示
input double DailyProfitThreshold = 50;         // 当天盈利阈值
input bool   UseFloatingProfitHedge = false;    // 浮盈对冲模式
input string CryptoSymbols = "BTCUSDm,ETHUSDm"; // 加密货币品种列表

// ========== 浮亏监控参数（来自原浮亏监控EA） ==========
input string SymbolList = "XAUUSD,EURUSD,GBPUSD,AUDUSD,USDCHF,GBPJPY,BTCUSD,NZDCAD";
input string SymbolSuffix = "";                 // 货币对后缀
input int    MonitorCheckInterval = 5;          // 浮亏检查间隔（秒）
input bool   EnableLockPosition = false;        // 开启锁仓功能

// ========== 融合新增参数 ==========
input int    PanelStyle = 0;                   // 面板样式: 0=原始, 1=信息密集, 2=视觉增强, 3=分区布局
input int    ColorScheme = 3;                  // 配色方案: 0-9
input int    PanelX_Init = 20;                 // 面板X坐标初始值
input int    PanelY_Init = 50;                 // 面板Y坐标初始值
input bool   EnableHedgeEngine = true;         // 启用对冲引擎
input bool   EnableLossMonitor = true;         // 启用浮亏监控
input bool   SynergyMode = true;               // 协同模式
input int    PanelRefreshSeconds = 1;          // 面板刷新间隔
input bool   UseMarketClose = true;            // 是否用市价平仓

// ====================================================================
// 配色方案枚举（来自浮亏监控EA）
// ====================================================================
enum COLOR_SCHEME
{
   SCHEME_BLUE_GOLD = 0,
   SCHEME_JADE_GREEN = 1,
   SCHEME_TECH_CYAN = 2,
   SCHEME_PURPLE_NIGHT = 3,
   SCHEME_MORANDI_GRAY = 4,
   SCHEME_NEON_PLASMA = 5,
   SCHEME_AURORA_TEAL = 6,
   SCHEME_SUNSET_FIRE = 7,
   SCHEME_ICE_FROST = 8,
   SCHEME_CYBER_GOLD = 9
};

#define SCHEME_COUNT 10

struct ColorSchemeData
{
   string name;
   color  titleColor;
   color  panelBgColor;
   color  rowBgDark;
   color  rowBgLight;
   color  rowBgDanger;
   color  borderColor;
   color  headerBgColor;
   color  headerTxtColor;
   color  profitNegColor;
   color  profitPosColor;
   color  profitZeroColor;
};

ColorSchemeData g_schemes[SCHEME_COUNT];
int g_currentScheme = SCHEME_PURPLE_NIGHT;

// ====================================================================
// 浮亏监控EA常量
// ====================================================================
#define MAX_SYMBOLS 8
#define PFX_MON "Mon_"           // 浮亏监控面板前缀
#define PFX_HEDGE "Hedge_"       // 对冲引擎面板前缀
#define PFX_FUSION "Fusion_"     // 融合系统面板前缀

#define PANEL_WIDTH_MON 730
#define PANEL_HEIGHT_MON 296
#define ROW_HEIGHT_MON 26
#define COL_NUM_MON 30
#define COL_SYMBOL_MON 90
#define COL_LOTS_MON 60
#define COL_COUNT_MON 50
#define COL_PROFIT_MON 110
#define COL_THRESH_MON 90
#define COL_STATUS_MON 80
#define COL_ACTION_MON 200
#define MARGIN_MON 10
#define HEADER_HEIGHT_MON 24
#define EDIT_HEIGHT_MON 20
#define FONT_HEADER_SIZE_MON 9
#define FONT_LABEL_SIZE_MON 9
#define FONT_EDIT_SIZE_MON 9
#define FONT_VALUE_SIZE_MON 9
#define TITLE_BAR_HEIGHT_MON 26
#define BORDER_WIDTH_MON 3
#define FOOTER_HEIGHT_MON 24

const string FONT_NAME_MON = "Consolas";
const string THEME_KEY = "Fusion_ColorScheme";

// ====================================================================
// 全局变量 - 对冲引擎
// ====================================================================
datetime g_hedgeLastCheck = 0;
datetime g_hedgeLastPanelUpdate = 0;
string   g_hedgePanelPrefix = "Fusion_Hedge_";

// 当日盈利修正
datetime g_LastProfitDate = 0;
double   g_MaxTodayProfit = 0;
string   g_ProfitFileName = "Fusion_TodayProfit.txt";

int      g_TradeableTicket = -1;
int      g_ClosedTicket = -1;
string   g_TradeableText = "";
string   g_ClosedText = "";

CTrade         trade;
CPositionInfo  posInfo;

// ====================================================================
// 运行时状态变量（可通过按钮切换，input变量不可修改）
// ====================================================================
bool g_enableHedgeEngine;
bool g_enableLossMonitor;
bool g_synergyMode;

// ====================================================================
// 全局变量 - 浮亏监控
// ====================================================================
string g_symbols[MAX_SYMBOLS];
double g_thresholds[MAX_SYMBOLS];
string g_editNames[MAX_SYMBOLS];
string g_labelNames[MAX_SYMBOLS];
string g_btnCloseAllNames[MAX_SYMBOLS];
string g_btnCloseBuyNames[MAX_SYMBOLS];
string g_btnCloseSellNames[MAX_SYMBOLS];
string g_profitLabelNames[MAX_SYMBOLS];
string g_lotsLabelNames[MAX_SYMBOLS];
string g_countLabelNames[MAX_SYMBOLS];
string g_statusLabelNames[MAX_SYMBOLS];

long g_currentChartID = 0;
datetime g_monitorLastCheckTime = 0;
datetime g_monitorLastProfitUpdateTime = 0;
int g_symbolCount = 0;
bool g_thresholdsUpdated = false;

int g_panelX = 20;
int g_panelY = 50;
bool g_panelVisible = true;
bool g_isDragging = false;
int g_dragStartX = 0;
int g_dragStartY = 0;
int g_panelOffsetX = 0;
int g_panelOffsetY = 0;
int g_hideOffsetX = 0;

bool g_enableLockPosition = false;
const string SETTINGS_PREFIX = "FusionEA";

// ====================================================================
// 协同层 - 共享数据
// ====================================================================
struct HedgeStatusData
{
   bool    isActive;
   double  todayProfit;
   double  totalFloatingLoss;
   double  floatingProfitPool;
   bool    hedgeReady;
   int     hedgeCount;
   datetime lastHedgeTime;
   string  mode;
};

HedgeStatusData g_hedgeStatus;

struct MonitorStatusData
{
   int    totalSymbols;
   int    alertCount;
   double totalLoss;
   bool   lockEnabled;
   int    closeCountToday;
};

MonitorStatusData g_monitorStatus;

// 协同事件队列
struct SynergyEvent
{
   int    eventType;    // 1=对冲完成, 2=监控触发, 3=手动操作
   string symbol;
   double amount;
   datetime timestamp;
};

SynergyEvent g_events[50];
int g_eventCount = 0;

// ====================================================================
// 工具函数 - 配色方案初始化
// ====================================================================
void InitColorSchemes()
{
   g_schemes[SCHEME_BLUE_GOLD].name = "深空蓝金";
   g_schemes[SCHEME_BLUE_GOLD].titleColor = C'201,169,97';
   g_schemes[SCHEME_BLUE_GOLD].panelBgColor = C'15,25,35';
   g_schemes[SCHEME_BLUE_GOLD].rowBgDark = C'19,32,41';
   g_schemes[SCHEME_BLUE_GOLD].rowBgLight = C'21,30,41';
   g_schemes[SCHEME_BLUE_GOLD].rowBgDanger = C'42,21,24';
   g_schemes[SCHEME_BLUE_GOLD].borderColor = C'26,42,58';
   g_schemes[SCHEME_BLUE_GOLD].headerBgColor = C'21,32,43';
   g_schemes[SCHEME_BLUE_GOLD].headerTxtColor = C'122,138,154';
   g_schemes[SCHEME_BLUE_GOLD].profitNegColor = C'232,90,90';
   g_schemes[SCHEME_BLUE_GOLD].profitPosColor = C'90,200,138';
   g_schemes[SCHEME_BLUE_GOLD].profitZeroColor = C'90,106,122';

   g_schemes[SCHEME_JADE_GREEN].name = "墨玉绿";
   g_schemes[SCHEME_JADE_GREEN].titleColor = C'168,192,152';
   g_schemes[SCHEME_JADE_GREEN].panelBgColor = C'26,30,28';
   g_schemes[SCHEME_JADE_GREEN].rowBgDark = C'30,36,34';
   g_schemes[SCHEME_JADE_GREEN].rowBgLight = C'30,36,34';
   g_schemes[SCHEME_JADE_GREEN].rowBgDanger = C'42,24,24';
   g_schemes[SCHEME_JADE_GREEN].borderColor = C'42,46,44';
   g_schemes[SCHEME_JADE_GREEN].headerBgColor = C'30,36,34';
   g_schemes[SCHEME_JADE_GREEN].headerTxtColor = C'122,138,122';
   g_schemes[SCHEME_JADE_GREEN].profitNegColor = C'232,120,120';
   g_schemes[SCHEME_JADE_GREEN].profitPosColor = C'136,200,120';
   g_schemes[SCHEME_JADE_GREEN].profitZeroColor = C'90,106,90';

   g_schemes[SCHEME_TECH_CYAN].name = "炭青科技";
   g_schemes[SCHEME_TECH_CYAN].titleColor = C'88,166,255';
   g_schemes[SCHEME_TECH_CYAN].panelBgColor = C'13,17,23';
   g_schemes[SCHEME_TECH_CYAN].rowBgDark = C'19,24,34';
   g_schemes[SCHEME_TECH_CYAN].rowBgLight = C'19,24,34';
   g_schemes[SCHEME_TECH_CYAN].rowBgDanger = C'42,20,24';
   g_schemes[SCHEME_TECH_CYAN].borderColor = C'26,32,48';
   g_schemes[SCHEME_TECH_CYAN].headerBgColor = C'19,24,34';
   g_schemes[SCHEME_TECH_CYAN].headerTxtColor = C'106,117,136';
   g_schemes[SCHEME_TECH_CYAN].profitNegColor = C'248,113,113';
   g_schemes[SCHEME_TECH_CYAN].profitPosColor = C'63,185,80';
   g_schemes[SCHEME_TECH_CYAN].profitZeroColor = C'74,85,104';

   g_schemes[SCHEME_PURPLE_NIGHT].name = "紫银夜";
   g_schemes[SCHEME_PURPLE_NIGHT].titleColor = C'192,132,252';
   g_schemes[SCHEME_PURPLE_NIGHT].panelBgColor = C'21,18,31';
   g_schemes[SCHEME_PURPLE_NIGHT].rowBgDark = C'26,22,40';
   g_schemes[SCHEME_PURPLE_NIGHT].rowBgLight = C'26,22,40';
   g_schemes[SCHEME_PURPLE_NIGHT].rowBgDanger = C'42,20,32';
   g_schemes[SCHEME_PURPLE_NIGHT].borderColor = C'36,30,54';
   g_schemes[SCHEME_PURPLE_NIGHT].headerBgColor = C'26,22,40';
   g_schemes[SCHEME_PURPLE_NIGHT].headerTxtColor = C'122,106,138';
   g_schemes[SCHEME_PURPLE_NIGHT].profitNegColor = C'248,120,168';
   g_schemes[SCHEME_PURPLE_NIGHT].profitPosColor = C'120,216,168';
   g_schemes[SCHEME_PURPLE_NIGHT].profitZeroColor = C'90,74,106';

   g_schemes[SCHEME_MORANDI_GRAY].name = "莫兰迪灰";
   g_schemes[SCHEME_MORANDI_GRAY].titleColor = C'176,168,152';
   g_schemes[SCHEME_MORANDI_GRAY].panelBgColor = C'28,28,31';
   g_schemes[SCHEME_MORANDI_GRAY].rowBgDark = C'32,32,36';
   g_schemes[SCHEME_MORANDI_GRAY].rowBgLight = C'32,32,36';
   g_schemes[SCHEME_MORANDI_GRAY].rowBgDanger = C'42,30,30';
   g_schemes[SCHEME_MORANDI_GRAY].borderColor = C'42,42,46';
   g_schemes[SCHEME_MORANDI_GRAY].headerBgColor = C'32,32,36';
   g_schemes[SCHEME_MORANDI_GRAY].headerTxtColor = C'122,122,126';
   g_schemes[SCHEME_MORANDI_GRAY].profitNegColor = C'216,120,120';
   g_schemes[SCHEME_MORANDI_GRAY].profitPosColor = C'136,184,144';
   g_schemes[SCHEME_MORANDI_GRAY].profitZeroColor = C'90,90,94';

   g_schemes[SCHEME_NEON_PLASMA].name = "霓虹等离子";
   g_schemes[SCHEME_NEON_PLASMA].titleColor = C'255,0,200';
   g_schemes[SCHEME_NEON_PLASMA].panelBgColor = C'12,8,20';
   g_schemes[SCHEME_NEON_PLASMA].rowBgDark = C'18,12,28';
   g_schemes[SCHEME_NEON_PLASMA].rowBgLight = C'20,14,32';
   g_schemes[SCHEME_NEON_PLASMA].rowBgDanger = C'42,12,32';
   g_schemes[SCHEME_NEON_PLASMA].borderColor = C'40,20,60';
   g_schemes[SCHEME_NEON_PLASMA].headerBgColor = C'18,12,28';
   g_schemes[SCHEME_NEON_PLASMA].headerTxtColor = C'160,140,180';
   g_schemes[SCHEME_NEON_PLASMA].profitNegColor = C'255,80,180';
   g_schemes[SCHEME_NEON_PLASMA].profitPosColor = C'80,255,220';
   g_schemes[SCHEME_NEON_PLASMA].profitZeroColor = C'100,80,120';

   g_schemes[SCHEME_AURORA_TEAL].name = "极光青翠";
   g_schemes[SCHEME_AURORA_TEAL].titleColor = C'80,255,200';
   g_schemes[SCHEME_AURORA_TEAL].panelBgColor = C'8,20,22';
   g_schemes[SCHEME_AURORA_TEAL].rowBgDark = C'12,28,30';
   g_schemes[SCHEME_AURORA_TEAL].rowBgLight = C'14,32,34';
   g_schemes[SCHEME_AURORA_TEAL].rowBgDanger = C'32,16,18';
   g_schemes[SCHEME_AURORA_TEAL].borderColor = C'20,48,52';
   g_schemes[SCHEME_AURORA_TEAL].headerBgColor = C'12,28,30';
   g_schemes[SCHEME_AURORA_TEAL].headerTxtColor = C'120,160,150';
   g_schemes[SCHEME_AURORA_TEAL].profitNegColor = C'255,120,120';
   g_schemes[SCHEME_AURORA_TEAL].profitPosColor = C'100,240,180';
   g_schemes[SCHEME_AURORA_TEAL].profitZeroColor = C'80,110,105';

   g_schemes[SCHEME_SUNSET_FIRE].name = "烈焰夕阳";
   g_schemes[SCHEME_SUNSET_FIRE].titleColor = C'255,140,40';
   g_schemes[SCHEME_SUNSET_FIRE].panelBgColor = C'22,12,8';
   g_schemes[SCHEME_SUNSET_FIRE].rowBgDark = C'30,16,10';
   g_schemes[SCHEME_SUNSET_FIRE].rowBgLight = C'34,18,12';
   g_schemes[SCHEME_SUNSET_FIRE].rowBgDanger = C'42,16,12';
   g_schemes[SCHEME_SUNSET_FIRE].borderColor = C'58,28,16';
   g_schemes[SCHEME_SUNSET_FIRE].headerBgColor = C'30,16,10';
   g_schemes[SCHEME_SUNSET_FIRE].headerTxtColor = C'170,140,120';
   g_schemes[SCHEME_SUNSET_FIRE].profitNegColor = C'255,90,80';
   g_schemes[SCHEME_SUNSET_FIRE].profitPosColor = C'255,200,100';
   g_schemes[SCHEME_SUNSET_FIRE].profitZeroColor = C'120,90,75';

   g_schemes[SCHEME_ICE_FROST].name = "冰晶霜银";
   g_schemes[SCHEME_ICE_FROST].titleColor = C'180,220,255';
   g_schemes[SCHEME_ICE_FROST].panelBgColor = C'12,16,22';
   g_schemes[SCHEME_ICE_FROST].rowBgDark = C'18,24,32';
   g_schemes[SCHEME_ICE_FROST].rowBgLight = C'20,28,36';
   g_schemes[SCHEME_ICE_FROST].rowBgDanger = C'32,18,24';
   g_schemes[SCHEME_ICE_FROST].borderColor = C'40,52,68';
   g_schemes[SCHEME_ICE_FROST].headerBgColor = C'18,24,32';
   g_schemes[SCHEME_ICE_FROST].headerTxtColor = C'150,170,190';
   g_schemes[SCHEME_ICE_FROST].profitNegColor = C'255,130,150';
   g_schemes[SCHEME_ICE_FROST].profitPosColor = C'140,220,255';
   g_schemes[SCHEME_ICE_FROST].profitZeroColor = C'100,120,140';

   g_schemes[SCHEME_CYBER_GOLD].name = "赛博鎏金";
   g_schemes[SCHEME_CYBER_GOLD].titleColor = C'255,210,80';
   g_schemes[SCHEME_CYBER_GOLD].panelBgColor = C'10,8,6';
   g_schemes[SCHEME_CYBER_GOLD].rowBgDark = C'16,14,10';
   g_schemes[SCHEME_CYBER_GOLD].rowBgLight = C'20,18,14';
   g_schemes[SCHEME_CYBER_GOLD].rowBgDanger = C'38,18,12';
   g_schemes[SCHEME_CYBER_GOLD].borderColor = C'56,44,20';
   g_schemes[SCHEME_CYBER_GOLD].headerBgColor = C'16,14,10';
   g_schemes[SCHEME_CYBER_GOLD].headerTxtColor = C'150,140,110';
   g_schemes[SCHEME_CYBER_GOLD].profitNegColor = C'255,100,90';
   g_schemes[SCHEME_CYBER_GOLD].profitPosColor = C'255,220,120';
   g_schemes[SCHEME_CYBER_GOLD].profitZeroColor = C'110,100,80';
}

// 配色访问函数
color GetTitleColor() { return g_schemes[g_currentScheme].titleColor; }
color GetPanelBgColor() { return g_schemes[g_currentScheme].panelBgColor; }
color GetRowBgDark() { return g_schemes[g_currentScheme].rowBgDark; }
color GetRowBgLight() { return g_schemes[g_currentScheme].rowBgLight; }
color GetRowBgDanger() { return g_schemes[g_currentScheme].rowBgDanger; }
color GetBorderColor() { return g_schemes[g_currentScheme].borderColor; }
color GetHeaderBgColor() { return g_schemes[g_currentScheme].headerBgColor; }
color GetHeaderTxtColor() { return g_schemes[g_currentScheme].headerTxtColor; }
color GetProfitNegColor() { return g_schemes[g_currentScheme].profitNegColor; }
color GetProfitPosColor() { return g_schemes[g_currentScheme].profitPosColor; }
color GetProfitZeroColor() { return g_schemes[g_currentScheme].profitZeroColor; }

color GetStatusNormalColor() { return GetProfitPosColor(); }
color GetStatusWarningColor() { return GetTitleColor(); }
color GetStatusDangerColor() { return GetProfitNegColor(); }
color GetStatusEmptyColor() { return GetProfitZeroColor(); }

// ====================================================================
// 工具函数 - 公共工具
// ====================================================================
double GetPositionNetProfitByTicket(ulong ticket) {
   if(!posInfo.SelectByTicket(ticket))
      return 0.0;
   return posInfo.Profit() + posInfo.Swap() + posInfo.Commission();
}

double NormalizeVolumeBySymbol(string sym, double lots) {
   double step = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   if(step <= 0) step = MinHedgeLots;
   double minVol = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   if(minVol <= 0) minVol = MinHedgeLots;
   double v = MathFloor(lots / step) * step;
   if(v < minVol || v < MinHedgeLots) return 0.0;
   return NormalizeDouble(v, 2);
}

bool IsWeekend() {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   return (dt.day_of_week == 0 || dt.day_of_week == 6);
}

bool IsInCryptoSymbols(string sym) {
   if(StringLen(CryptoSymbols) == 0) return false;
   string arr[];
   int n = StringSplit(CryptoSymbols, ',', arr);
   for(int i = 0; i < n; i++) {
      string item = arr[i];
      StringTrimRight(item);
      StringTrimLeft(item);
      if(item == sym) return true;
   }
   return false;
}

bool IsSymbolTradeable(string sym) {
   if(IsWeekend()) {
      if(!IsInCryptoSymbols(sym)) return false;
   }
   long mode = SymbolInfoInteger(sym, SYMBOL_TRADE_MODE);
   if(mode == SYMBOL_TRADE_MODE_DISABLED) return false;
   if(mode != SYMBOL_TRADE_MODE_FULL) return false;
   double bid = SymbolInfoDouble(sym, SYMBOL_BID);
   double ask = SymbolInfoDouble(sym, SYMBOL_ASK);
   return (bid > 0 && ask > 0);
}

bool SymbolMatch(string symbol1, string symbol2) {
   if(StringCompare(symbol1, symbol2, false) == 0)
      return true;

   if(StringLen(SymbolSuffix) > 0) {
      string symbol1WithSuffix = symbol1 + SymbolSuffix;
      string symbol2WithSuffix = symbol2 + SymbolSuffix;

      if(StringCompare(symbol1WithSuffix, symbol2, false) == 0 ||
         StringCompare(symbol2WithSuffix, symbol1, false) == 0)
         return true;

      int suffixLen = StringLen(SymbolSuffix);
      if(StringLen(symbol1) > suffixLen) {
         string symbol1Base = StringSubstr(symbol1, 0, StringLen(symbol1) - suffixLen);
         if(StringCompare(symbol1Base, symbol2, false) == 0)
            return true;
      }
      if(StringLen(symbol2) > suffixLen) {
         string symbol2Base = StringSubstr(symbol2, 0, StringLen(symbol2) - suffixLen);
         if(StringCompare(symbol2Base, symbol1, false) == 0)
            return true;
      }
   }

   if(StringLen(SymbolSuffix) == 0) {
      int len1 = StringLen(symbol1);
      int len2 = StringLen(symbol2);
      if(len2 < len1) return false;
      string prefix = StringSubstr(symbol2, 0, len1);
      if(StringCompare(symbol1, prefix, false) == 0) {
         if(len2 > len1) {
            string suffix = StringSubstr(symbol2, len1, 1);
            if(suffix == "." || suffix == "-" || suffix == "_")
               return true;
         }
         return true;
      }
   }
   return false;
}

double CalculateTotalFloatingLoss() {
   double loss = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      if(PositionGetTicket(i) != 0)
         loss += PositionGetDouble(POSITION_PROFIT);
   }
   return -loss;
}

double CalculateTotalFloatingProfitPool() {
   double totalProfit = 0.0;
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong h = PositionGetTicket(i);
      if(h == 0) continue;
      if(PositionGetInteger(POSITION_TYPE) > POSITION_TYPE_SELL) continue;
      double p = GetPositionNetProfitByTicket(h);
      if(p > 0) totalProfit += p;
   }
   return totalProfit;
}

// ====================================================================
// 工具函数 - 浮亏监控
// ====================================================================
string BuildStorageKey(string suffix) {
   long login = (long)AccountInfoInteger(ACCOUNT_LOGIN);
   return SETTINGS_PREFIX + "_" + IntegerToString((int)login) + "_" +
          IntegerToString((int)g_currentChartID) + "_" + suffix;
}

void SaveSettingsToGlobalVars() {
   if(g_symbolCount <= 0) return;
   string enableKey = BuildStorageKey("EnableLock");
   GlobalVariableSet(enableKey, g_enableLockPosition ? 1.0 : 0.0);
   GlobalVariableSet(THEME_KEY, g_currentScheme);
   for(int i = 0; i < g_symbolCount; i++) {
      string key = BuildStorageKey("Threshold_" + IntegerToString(i));
      GlobalVariableSet(key, g_thresholds[i]);
   }
}

void LoadSettingsFromGlobalVars() {
   if(g_symbolCount <= 0) return;
   string enableKey = BuildStorageKey("EnableLock");
   if(GlobalVariableCheck(enableKey)) {
      double value = GlobalVariableGet(enableKey);
      g_enableLockPosition = (value > 0.5);
   } else {
      g_enableLockPosition = EnableLockPosition;
   }
   if(GlobalVariableCheck(THEME_KEY))
      g_currentScheme = (int)GlobalVariableGet(THEME_KEY);
   else
      g_currentScheme = ColorScheme;
   for(int i = 0; i < g_symbolCount; i++) {
      string key = BuildStorageKey("Threshold_" + IntegerToString(i));
      if(GlobalVariableCheck(key))
         g_thresholds[i] = GlobalVariableGet(key);
   }
}

bool ShouldRestoreSavedSettings() {
   string reasonKey = BuildStorageKey("LastDeinitReason");
   if(GlobalVariableCheck(reasonKey)) {
      double lastReason = GlobalVariableGet(reasonKey);
      GlobalVariableDel(reasonKey);
      if((int)lastReason == REASON_PARAMETERS)
         return false;
   }
   return true;
}

int ParseSymbolList(string symbolList) {
   for(int i = 0; i < MAX_SYMBOLS; i++)
      g_symbols[i] = "";
   g_symbolCount = 0;
   if(StringLen(symbolList) == 0) {
      Print("警告：货币对列表为空，使用默认列表");
      symbolList = "XAUUSD,EURUSD,GBPUSD,AUDUSD,USDCHF,GBPJPY,BTCUSD,NZDCAD";
   }
   string symbols[];
   int count = StringSplit(symbolList, ',', symbols);
   int maxCount = MathMin(count, MAX_SYMBOLS);
   for(int i = 0; i < maxCount; i++) {
      string symbol = symbols[i];
      StringTrimLeft(symbol);
      StringTrimRight(symbol);
      if(StringLen(symbol) > 0) {
         g_symbols[g_symbolCount] = symbol;
         g_symbolCount++;
      }
   }
   return g_symbolCount;
}

double GetSymbolFloatingLoss(string symbol) {
   double totalLoss = 0.0;
   int total = PositionsTotal();
   for(int i = 0; i < total; i++) {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket)) {
         string posSymbol = PositionGetString(POSITION_SYMBOL);
         if(SymbolMatch(symbol, posSymbol))
            totalLoss += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      }
   }
   return totalLoss;
}

double GetSymbolTotalProfit(string symbol) {
   double totalProfit = 0.0;
   int total = PositionsTotal();
   for(int i = 0; i < total; i++) {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket)) {
         string posSymbol = PositionGetString(POSITION_SYMBOL);
         if(SymbolMatch(posSymbol, symbol))
            totalProfit += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      }
   }
   return totalProfit;
}

void GetSymbolLotsAndCount(string symbol, double &outLots, int &outCount) {
   outLots = 0.0;
   outCount = 0;
   int total = PositionsTotal();
   for(int i = 0; i < total; i++) {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket)) {
         string posSymbol = PositionGetString(POSITION_SYMBOL);
         if(SymbolMatch(symbol, posSymbol)) {
            outLots += PositionGetDouble(POSITION_VOLUME);
            outCount++;
         }
      }
   }
}

int GetSymbolLossRank(int symbolIndex) {
   if(symbolIndex < 0 || symbolIndex >= g_symbolCount) return -1;
   double losses[MAX_SYMBOLS];
   for(int i = 0; i < g_symbolCount; i++)
      losses[i] = GetSymbolTotalProfit(g_symbols[i]);
   double currentLoss = losses[symbolIndex];
   int rank = 0;
   for(int i = 0; i < g_symbolCount; i++) {
      if(i != symbolIndex && losses[i] < currentLoss)
         rank++;
   }
   return rank;
}

bool LockPosition(string symbol, string &outDirection, double &outVolume) {
   double buyVolume = 0.0;
   double sellVolume = 0.0;
   int total = PositionsTotal();
   for(int i = 0; i < total; i++) {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket)) {
         string posSymbol = PositionGetString(POSITION_SYMBOL);
         if(SymbolMatch(symbol, posSymbol)) {
            ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            double volume = PositionGetDouble(POSITION_VOLUME);
            if(posType == POSITION_TYPE_BUY) buyVolume += volume;
            else if(posType == POSITION_TYPE_SELL) sellVolume += volume;
         }
      }
   }
   double lockVolume = MathAbs(buyVolume - sellVolume);
   if(lockVolume < 0.01) {
      outDirection = "";
      outVolume = 0;
      return false;
   }
   ENUM_ORDER_TYPE orderType;
   if(buyVolume > sellVolume) {
      orderType = ORDER_TYPE_SELL;
      outDirection = "空单";
   } else {
      orderType = ORDER_TYPE_BUY;
      outDirection = "多单";
   }
   outVolume = lockVolume;
   double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
   if(ask == 0 || bid == 0) {
      outDirection = "";
      outVolume = 0;
      return false;
   }
   MqlTradeRequest request;
   MqlTradeResult result;
   ZeroMemory(request);
   ZeroMemory(result);
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = lockVolume;
   request.type = orderType;
   request.price = (orderType == ORDER_TYPE_BUY) ? ask : bid;
   request.deviation = 10;
   request.magic = 0;
   request.comment = "锁仓操作";
   int filling = (int)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);
   if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
      request.type_filling = ORDER_FILLING_FOK;
   else if((filling & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
      request.type_filling = ORDER_FILLING_IOC;
   else
      request.type_filling = ORDER_FILLING_RETURN;
   if(!OrderSend(request, result)) {
      outDirection = "";
      outVolume = 0;
      return false;
   }
   if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
      return true;
   outDirection = "";
   outVolume = 0;
   return false;
}

int CloseSymbolPositions(string symbol, int direction) {
   int closedCount = 0;
   MqlTradeRequest request;
   MqlTradeResult result;
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
      string posSymbol = PositionGetString(POSITION_SYMBOL);
      if(!SymbolMatch(symbol, posSymbol)) continue;
      ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      if(direction == 0 && posType != POSITION_TYPE_BUY) continue;
      if(direction == 1 && posType != POSITION_TYPE_SELL) continue;
      double volume = PositionGetDouble(POSITION_VOLUME);
      ZeroMemory(request);
      ZeroMemory(result);
      request.action = TRADE_ACTION_DEAL;
      request.position = ticket;
      request.symbol = posSymbol;
      request.volume = volume;
      if(posType == POSITION_TYPE_BUY) {
         request.type = ORDER_TYPE_SELL;
         request.price = SymbolInfoDouble(posSymbol, SYMBOL_BID);
      } else {
         request.type = ORDER_TYPE_BUY;
         request.price = SymbolInfoDouble(posSymbol, SYMBOL_ASK);
      }
      request.deviation = 10;
      request.magic = 0;
      request.comment = "平仓操作";
      int filling = (int)SymbolInfoInteger(posSymbol, SYMBOL_FILLING_MODE);
      if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
         request.type_filling = ORDER_FILLING_FOK;
      else if((filling & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
         request.type_filling = ORDER_FILLING_IOC;
      else
         request.type_filling = ORDER_FILLING_RETURN;
      if(OrderSend(request, result)) {
         if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
            closedCount++;
      }
   }
   return closedCount;
}

void GetSymbolStatusInfo(double profit, double threshold, int lossRank,
                        string &outStatusText, color &outStatusColor) {
   if(profit == 0) {
      outStatusText = "● 无仓位";
      outStatusColor = GetStatusEmptyColor();
      return;
   }
   if(profit > 0) {
      outStatusText = "● 盈利中";
      outStatusColor = GetStatusNormalColor();
      return;
   }
   if(threshold < 0 && profit <= threshold) {
      outStatusText = "⚠ 超阈值";
      outStatusColor = GetStatusDangerColor();
      return;
   }
   if(lossRank < 3) {
      outStatusText = "● 浮亏大";
      outStatusColor = GetStatusDangerColor();
      return;
   }
   if(lossRank < 5) {
      outStatusText = "● 浮亏中";
      outStatusColor = GetStatusWarningColor();
      return;
   }
   outStatusText = "● 正常";
   outStatusColor = GetStatusNormalColor();
}

// ====================================================================
// 工具函数 - 对冲盈利计算
// ====================================================================
void LoadMaxTodayProfit() {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   datetime todayStart = StringToTime(StringFormat("%04d.%02d.%02d", dt.year, dt.mon, dt.day));
   int h = FileOpen(g_ProfitFileName, FILE_READ | FILE_TXT | FILE_COMMON);
   if(h == INVALID_HANDLE) return;
   if(FileIsLineEnding(h)) { FileClose(h); return; }
   string sDate = FileReadString(h);
   if(FileIsLineEnding(h)) { FileClose(h); return; }
   double val = (double)StringToDouble(FileReadString(h));
   FileClose(h);
   datetime fileDate = StringToTime(sDate);
   if(fileDate == todayStart && val > 0)
      g_MaxTodayProfit = val;
   g_LastProfitDate = todayStart;
}

void SaveMaxTodayProfit() {
   int h = FileOpen(g_ProfitFileName, FILE_WRITE | FILE_TXT | FILE_COMMON);
   if(h == INVALID_HANDLE) return;
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   FileWrite(h, StringFormat("%04d.%02d.%02d", dt.year, dt.mon, dt.day));
   FileWrite(h, DoubleToString(g_MaxTodayProfit, 2));
   FileClose(h);
}

double CalculateTodayProfit() {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   datetime todayStart = StringToTime(StringFormat("%04d.%02d.%02d", dt.year, dt.mon, dt.day));
   if(todayStart != g_LastProfitDate) {
      g_LastProfitDate = todayStart;
      g_MaxTodayProfit = 0;
   }
   if(!HistorySelect(todayStart, TimeCurrent())) return g_MaxTodayProfit;
   double profit = 0;
   int total = HistoryDealsTotal();
   for(int i = total - 1; i >= 0; i--) {
      ulong dealTicket = HistoryDealGetTicket(i);
      if(dealTicket == 0) continue;
      if(HistoryDealGetInteger(dealTicket, DEAL_ENTRY) != DEAL_ENTRY_OUT) continue;
      if(HistoryDealGetInteger(dealTicket, DEAL_TIME) < (long)todayStart) continue;
      if(HistoryDealGetInteger(dealTicket, DEAL_TYPE) == DEAL_TYPE_BUY || 
         HistoryDealGetInteger(dealTicket, DEAL_TYPE) == DEAL_TYPE_SELL)
         profit += HistoryDealGetDouble(dealTicket, DEAL_PROFIT);
   }
   if(profit > g_MaxTodayProfit) {
      g_MaxTodayProfit = profit;
      SaveMaxTodayProfit();
   }
   return profit;
}

double GetMaxCryptoSingleSymbolLoss() {
   string syms[];
   double lossBySym[];
   int numSyms = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong h = PositionGetTicket(i);
      if(h == 0) continue;
      if(PositionGetInteger(POSITION_TYPE) > POSITION_TYPE_SELL) continue;
      string sym = PositionGetString(POSITION_SYMBOL);
      if(!IsInCryptoSymbols(sym)) continue;
      double p = PositionGetDouble(POSITION_PROFIT);
      int idx = -1;
      for(int j = 0; j < numSyms; j++) if(syms[j] == sym) { idx = j; break; }
      if(idx < 0) {
         ArrayResize(syms, numSyms + 1);
         ArrayResize(lossBySym, numSyms + 1);
         syms[numSyms] = sym;
         lossBySym[numSyms] = p;
         numSyms++;
      } else
         lossBySym[idx] += p;
   }
   double maxSingleLoss = 0;
   for(int j = 0; j < numSyms; j++)
      if(lossBySym[j] < 0 && (-lossBySym[j]) > maxSingleLoss)
         maxSingleLoss = -lossBySym[j];
   return maxSingleLoss;
}

// ====================================================================
// 工具函数 - 账户信息
// ====================================================================
double GetAccountBalance() { return AccountInfoDouble(ACCOUNT_BALANCE); }
double GetAccountEquity() { return AccountInfoDouble(ACCOUNT_EQUITY); }
double GetAccountMargin() { return AccountInfoDouble(ACCOUNT_MARGIN); }
double GetAccountMarginLevel() {
   double margin = AccountInfoDouble(ACCOUNT_MARGIN);
   if(margin <= 0) return 0;
   return AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
}

// ====================================================================
// 对冲引擎核心逻辑
// ====================================================================
void GetMaxFloatingLossOrderInfo(string &outText, long &outTicket) {
   outTicket = -1;
   long ticket = 0;
   double maxLoss = 0;
   string maxSymbol = "";
   long posType = 0;
   double orderLots = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong h = PositionGetTicket(i);
      if(h == 0) continue;
      if(PositionGetInteger(POSITION_TYPE) > POSITION_TYPE_SELL) continue;
      if(!IsSymbolTradeable(PositionGetString(POSITION_SYMBOL))) continue;
      double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(posInfo.SelectByTicket(h)) profit += posInfo.Commission();
      if(profit < maxLoss) {
         maxLoss = profit;
         ticket = (long)h;
         maxSymbol = PositionGetString(POSITION_SYMBOL);
         posType = PositionGetInteger(POSITION_TYPE);
         orderLots = PositionGetDouble(POSITION_VOLUME);
      }
   }
   if(ticket == 0 || maxLoss >= 0) {
      outText = "可交易最大净亏: 无";
      return;
   }
   outTicket = ticket;
   string dirStr = (posType == POSITION_TYPE_BUY) ? "多" : "空";
   outText = "可交易最大净亏: " + maxSymbol + " " + dirStr + " " + DoubleToString(orderLots, 2) + "手 净亏" + DoubleToString(maxLoss, 2);
}

void GetMaxFloatingLossOrderInfoClosedMarket(string &outText, long &outTicket) {
   outTicket = -1;
   long ticket = 0;
   double maxLoss = 0;
   string maxSymbol = "";
   long posType = 0;
   double orderLots = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong h = PositionGetTicket(i);
      if(h == 0) continue;
      if(PositionGetInteger(POSITION_TYPE) > POSITION_TYPE_SELL) continue;
      if(IsSymbolTradeable(PositionGetString(POSITION_SYMBOL))) continue;
      double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      if(posInfo.SelectByTicket(h)) profit += posInfo.Commission();
      if(profit < maxLoss) {
         maxLoss = profit;
         ticket = (long)h;
         maxSymbol = PositionGetString(POSITION_SYMBOL);
         posType = PositionGetInteger(POSITION_TYPE);
         orderLots = PositionGetDouble(POSITION_VOLUME);
      }
   }
   if(ticket == 0 || maxLoss >= 0) {
      outText = "休市品种: 无";
      return;
   }
   outTicket = ticket;
   string dirStr = (posType == POSITION_TYPE_BUY) ? "多" : "空";
   outText = "休市品种最大: " + maxSymbol + " " + dirStr + " " + DoubleToString(orderLots, 2) + "手 净亏" + DoubleToString(maxLoss, 2);
}

string FormatHedgeNextCheckTime() {
   datetime now = TimeCurrent();
   datetime nextAt = now;
   if(g_hedgeLastCheck > 0)
      nextAt = g_hedgeLastCheck + HedgeCheckInterval * 60;
   long secLeft = (long)(nextAt - now);
   if(secLeft < 0) secLeft = 0;
   int h = (int)(secLeft / 3600);
   int m = (int)((secLeft % 3600) / 60);
   int s = (int)(secLeft % 60);
   return StringFormat("%02d:%02d:%02d", h, m, s);
}

// 协同层 - 记录对冲事件
void RecordSynergyEvent(int eventType, string symbol, double amount) {
   if(g_eventCount >= 50) {
      for(int i = 0; i < 49; i++)
         g_events[i] = g_events[i + 1];
      g_eventCount = 49;
   }
   g_events[g_eventCount].eventType = eventType;
   g_events[g_eventCount].symbol = symbol;
   g_events[g_eventCount].amount = amount;
   g_events[g_eventCount].timestamp = TimeCurrent();
   g_eventCount++;
}

// 同步对冲状态到监控
void SyncHedgeStatus() {
   g_hedgeStatus.isActive = g_enableHedgeEngine;
   g_hedgeStatus.todayProfit = CalculateTodayProfit();
   g_hedgeStatus.totalFloatingLoss = CalculateTotalFloatingLoss();
   g_hedgeStatus.floatingProfitPool = CalculateTotalFloatingProfitPool();
   g_hedgeStatus.hedgeReady = g_hedgeStatus.todayProfit >= DailyProfitThreshold;
   g_hedgeStatus.mode = UseFloatingProfitHedge ? "浮盈对冲" : "盈利消耗";
}

// 同步监控状态到对冲
void SyncMonitorStatus() {
   g_monitorStatus.totalSymbols = g_symbolCount;
   g_monitorStatus.lockEnabled = g_enableLockPosition;

   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   static int lastMonitorDay = 0;
   if(lastMonitorDay != dt.day) {
      g_monitorStatus.closeCountToday = 0;
      lastMonitorDay = dt.day;
   }

   double totalLoss = 0;
   int alertCount = 0;
   for(int i = 0; i < g_symbolCount; i++) {
      double loss = GetSymbolFloatingLoss(g_symbols[i]);
      if(loss < 0) {
         totalLoss += loss;
         if(g_thresholds[i] < 0 && loss <= g_thresholds[i])
            alertCount++;
      }
   }
   g_monitorStatus.totalLoss = totalLoss;
   g_monitorStatus.alertCount = alertCount;
}

// 协同事件处理 - 对冲引擎与浮亏监控联动
void ProcessSynergyEvents() {
   if(!g_synergyMode || g_eventCount <= 0) return;

   for(int i = 0; i < g_eventCount; i++) {
      SynergyEvent evt = g_events[i];

      // 事件类型2: 浮亏监控触发（图表被关闭）
      if(evt.eventType == 2 && g_enableHedgeEngine) {
         if(TimeCurrent() - evt.timestamp < 30) {
            double symLoss = GetSymbolFloatingLoss(evt.symbol);
            if(symLoss < 0 && g_hedgeStatus.hedgeReady) {
               double maxConsume = MathMax((g_hedgeStatus.todayProfit - MinRemainProfit) * MaxProfitConsumeRatio, 0);
               if(maxConsume > 0) {
                  Print("[协同] 监控触发: ", evt.symbol, " 浮亏 ", DoubleToString(evt.amount, 2),
                        " 已触发监控关闭，尝试启动对冲保护");
                  g_hedgeLastCheck = 0;
               }
            }
         }
      }

      // 事件类型1: 对冲完成
      if(evt.eventType == 1 && g_enableLossMonitor) {
         if(TimeCurrent() - evt.timestamp < 10) {
            Print("[协同] 对冲完成: ", evt.symbol, " 对冲金额 ", DoubleToString(evt.amount, 2),
                  " 浮亏监控已同步");
         }
      }
   }

   int processedCount = 0;
   for(int i = 0; i < g_eventCount; i++) {
      if(TimeCurrent() - g_events[i].timestamp > 120) {
         processedCount++;
      } else {
         if(processedCount > 0) {
            for(int j = 0; j < g_eventCount - processedCount; j++)
               g_events[j] = g_events[j + processedCount];
         }
         break;
      }
   }
   g_eventCount -= processedCount;
   if(g_eventCount < 0) g_eventCount = 0;
}

// ====================================================================
// 对冲引擎主逻辑
// ====================================================================
void RunHedgeEngine() {
   datetime now = TimeCurrent();
   if(now - g_hedgeLastCheck < HedgeCheckInterval * 60)
      return;

   g_hedgeLastCheck = now;
   double todayProfit = CalculateTodayProfit();

   if(todayProfit < DailyProfitThreshold) {
      g_hedgeStatus.hedgeReady = false;
      return;
   }
   g_hedgeStatus.hedgeReady = true;

   double totalFloatingLoss = CalculateTotalFloatingLoss();
   if(IsWeekend()) {
      double maxCryptoLoss = GetMaxCryptoSingleSymbolLoss();
      if(maxCryptoLoss < LossThreshold) return;
   } else {
      if(totalFloatingLoss < LossThreshold) return;
   }

   double profitBase = todayProfit;
   if(UseFloatingProfitHedge)
      profitBase = CalculateTotalFloatingProfitPool();

   double maxProfitConsume = MathMax((profitBase - MinRemainProfit) * MaxProfitConsumeRatio, 0);
   if(profitBase <= MinRemainProfit || maxProfitConsume <= 0) return;

   double remainProfitConsume = maxProfitConsume;
   int maxLoop = 100;

   while(totalFloatingLoss > LossThreshold && remainProfitConsume > 0 && maxLoop-- > 0) {
      long ticket = 0;
      double maxLoss = 0;
      string maxSymbol = "";
      long orderType = 0;
      double orderLots = 0;

      for(int i = PositionsTotal() - 1; i >= 0; i--) {
         ulong h = PositionGetTicket(i);
         if(h == 0) continue;
         if(PositionGetInteger(POSITION_TYPE) > POSITION_TYPE_SELL) continue;
         string sym = PositionGetString(POSITION_SYMBOL);
         if(!IsSymbolTradeable(sym)) continue;
         double loss = GetPositionNetProfitByTicket(h);
         if(loss < maxLoss) {
            maxLoss = loss;
            ticket = (long)h;
            maxSymbol = sym;
            orderType = PositionGetInteger(POSITION_TYPE);
            orderLots = PositionGetDouble(POSITION_VOLUME);
         }
      }

      if(ticket == 0 || maxLoss >= 0) break;

      double lossNeed = totalFloatingLoss - LossThreshold;
      if(lossNeed < 0) lossNeed = 0;

      double lotsByProfit = 0.0;
      double lotsByThreshold = 0.0;

      if(-maxLoss > 0 && orderLots > 0) {
         lotsByProfit = remainProfitConsume * orderLots / (-maxLoss);
         if(lossNeed > 0)
            lotsByThreshold = lossNeed * orderLots / (-maxLoss);
      }

      double hedgeLots = orderLots;
      if(lotsByProfit > 0)
         hedgeLots = MathMin(hedgeLots, lotsByProfit);
      if(lotsByThreshold > 0)
         hedgeLots = MathMin(hedgeLots, lotsByThreshold);

      if(hedgeLots <= 0.0) break;

      hedgeLots = NormalizeVolumeBySymbol(maxSymbol, hedgeLots);
      if(hedgeLots < MinHedgeLots) break;

      double profitConsume = hedgeLots * (-maxLoss / orderLots);

      if(AccountInfoDouble(ACCOUNT_BALANCE) <= 1.0) break;

      bool hedgeSuccess = false;

      if(UseFloatingProfitHedge) {
         long profitTicket = 0;
         double maxProfit = 0;
         string profitSymbol = "";
         long profitOrderType = 0;
         double profitOrderLots = 0;

         for(int j = PositionsTotal() - 1; j >= 0; j--) {
            ulong hp = PositionGetTicket(j);
            if(hp == 0) continue;
            if(PositionGetInteger(POSITION_TYPE) > POSITION_TYPE_SELL) continue;
            string psym = PositionGetString(POSITION_SYMBOL);
            if(!IsSymbolTradeable(psym)) continue;
            double p = GetPositionNetProfitByTicket(hp);
            if(p > maxProfit) {
               maxProfit = p;
               profitTicket = (long)hp;
               profitSymbol = psym;
               profitOrderType = PositionGetInteger(POSITION_TYPE);
               profitOrderLots = PositionGetDouble(POSITION_VOLUME);
            }
         }

         if(profitTicket == 0 || maxProfit <= 0 || profitOrderLots <= 0) break;

         double lossMoneyPerLot = (-maxLoss / orderLots);
         double profitMoneyPerLot = (maxProfit / profitOrderLots);
         if(lossMoneyPerLot <= 0 || profitMoneyPerLot <= 0) break;

         double profitCloseLots = NormalizeVolumeBySymbol(profitSymbol, profitConsume / profitMoneyPerLot);
         if(profitCloseLots <= 0) break;

         double profitReleaseMoney = profitCloseLots * profitMoneyPerLot;
         hedgeLots = NormalizeVolumeBySymbol(maxSymbol, MathMin(hedgeLots, profitReleaseMoney / lossMoneyPerLot));
         if(hedgeLots <= 0) break;

         profitConsume = hedgeLots * lossMoneyPerLot;
         profitCloseLots = NormalizeVolumeBySymbol(profitSymbol, profitConsume / profitMoneyPerLot);
         if(profitCloseLots <= 0) break;

         bool closeProfitOK = trade.PositionClosePartial((ulong)profitTicket, profitCloseLots, 50);
         if(!closeProfitOK) break;

         bool closeLossOK = trade.PositionClosePartial((ulong)ticket, hedgeLots, 50);
         if(closeLossOK) {
            hedgeSuccess = true;
            if(EnableHedgeAlert) {
               string lossDirStr = (orderType == POSITION_TYPE_SELL) ? "空单" : "多单";
               string profitDirStr = (profitOrderType == POSITION_TYPE_SELL) ? "空单" : "多单";
               Alert("已启用浮盈对冲：先平浮盈单 " + profitSymbol + " " + profitDirStr + " " + DoubleToString(profitCloseLots, 2) + "手，再平亏损单 " +
                     maxSymbol + " " + lossDirStr + " " + DoubleToString(hedgeLots, 2) + "手");
            }
            remainProfitConsume -= profitConsume;
            totalFloatingLoss = CalculateTotalFloatingLoss();
         }
      } else {
         if(trade.PositionClosePartial((ulong)ticket, hedgeLots, 50)) {
            hedgeSuccess = true;
            if(EnableHedgeAlert) {
               string dirStr = (orderType == POSITION_TYPE_SELL) ? "空单" : "多单";
               Alert(maxSymbol + "最大浮亏的" + dirStr + DoubleToString(orderLots, 2) + "手被对冲掉" +
                     DoubleToString(hedgeLots, 2) + "手");
            }
            remainProfitConsume -= profitConsume;
            totalFloatingLoss = CalculateTotalFloatingLoss();
         }
      }

      if(hedgeSuccess) {
         g_hedgeStatus.hedgeCount++;
         g_hedgeStatus.lastHedgeTime = now;
         if(g_synergyMode) {
            RecordSynergyEvent(1, maxSymbol, profitConsume);
         }
      } else break;
   }
}

// ====================================================================
// 浮亏监控核心逻辑
// ====================================================================
int ColX_Num() { return MARGIN_MON + 6; }
int ColX_Symbol() { return MARGIN_MON + COL_NUM_MON + 6; }
int ColX_Lots() { return MARGIN_MON + COL_NUM_MON + COL_SYMBOL_MON + 6; }
int ColX_Count() { return MARGIN_MON + COL_NUM_MON + COL_SYMBOL_MON + COL_LOTS_MON + 6; }
int ColX_Profit() { return MARGIN_MON + COL_NUM_MON + COL_SYMBOL_MON + COL_LOTS_MON + COL_COUNT_MON + 6; }
int ColX_Thresh() { return MARGIN_MON + COL_NUM_MON + COL_SYMBOL_MON + COL_LOTS_MON + COL_COUNT_MON + COL_PROFIT_MON + 4; }
int ColX_Status() { return MARGIN_MON + COL_NUM_MON + COL_SYMBOL_MON + COL_LOTS_MON + COL_COUNT_MON + COL_PROFIT_MON + COL_THRESH_MON + 6; }
int ColX_Action() { return MARGIN_MON + COL_NUM_MON + COL_SYMBOL_MON + COL_LOTS_MON + COL_COUNT_MON + COL_PROFIT_MON + COL_THRESH_MON + COL_STATUS_MON + 6; }

void UpdateProfitLabels() {
   if(!g_panelVisible) return;
   for(int i = 0; i < g_symbolCount; i++) {
      double totalProfit = GetSymbolTotalProfit(g_symbols[i]);
      double totalLots = 0.0;
      int totalCount = 0;
      GetSymbolLotsAndCount(g_symbols[i], totalLots, totalCount);

      string profitText = DoubleToString(totalProfit, 2);
      color profitColor = GetProfitZeroColor();
      if(totalProfit < 0) profitColor = GetProfitNegColor();
      else if(totalProfit > 0) profitColor = GetProfitPosColor();

      if(ObjectFind(0, g_profitLabelNames[i]) >= 0) {
         ObjectSetString(0, g_profitLabelNames[i], OBJPROP_TEXT, profitText);
         ObjectSetInteger(0, g_profitLabelNames[i], OBJPROP_COLOR, profitColor);
      }
      if(ObjectFind(0, g_lotsLabelNames[i]) >= 0)
         ObjectSetString(0, g_lotsLabelNames[i], OBJPROP_TEXT, DoubleToString(totalLots, 2));
      if(ObjectFind(0, g_countLabelNames[i]) >= 0)
         ObjectSetString(0, g_countLabelNames[i], OBJPROP_TEXT, IntegerToString(totalCount));

      int lossRank = GetSymbolLossRank(i);
      string statusText = "";
      color statusColor = GetProfitZeroColor();
      GetSymbolStatusInfo(totalProfit, g_thresholds[i], lossRank, statusText, statusColor);
      if(ObjectFind(0, g_statusLabelNames[i]) >= 0) {
         ObjectSetString(0, g_statusLabelNames[i], OBJPROP_TEXT, statusText);
         ObjectSetInteger(0, g_statusLabelNames[i], OBJPROP_COLOR, statusColor);
      }

      string rowBgName = PFX_MON "Row_BG_" + IntegerToString(i);
      if(ObjectFind(0, rowBgName) >= 0) {
         color rowColor = (i % 2 == 0) ? GetRowBgDark() : GetRowBgLight();
         if(totalProfit < 0 && g_thresholds[i] < 0 && totalProfit <= g_thresholds[i])
            rowColor = GetRowBgDanger();
         ObjectSetInteger(0, rowBgName, OBJPROP_BGCOLOR, rowColor);
      }
   }
   ChartRedraw();
}

void RunMonitorEngine() {
   if(TimeCurrent() - g_monitorLastCheckTime < MonitorCheckInterval) return;
   g_monitorLastCheckTime = TimeCurrent();

   if(TimeCurrent() - g_monitorLastProfitUpdateTime >= 1) {
      g_monitorLastProfitUpdateTime = TimeCurrent();
      UpdateProfitLabels();
   }

   if(!g_thresholdsUpdated) {
      for(int i = 0; i < g_symbolCount; i++) {
         string text = ObjectGetString(0, g_editNames[i], OBJPROP_TEXT);
         if(StringLen(text) == 0) continue;
         double value = StringToDouble(text);
         if(value == 0 && StringCompare(text, "0", false) != 0 &&
            StringCompare(text, "-0", false) != 0 && StringCompare(text, "0.0", false) != 0)
            continue;
         if(value > 0) {
            g_thresholds[i] = -value;
            ObjectSetString(0, g_editNames[i], OBJPROP_TEXT, DoubleToString(-value, 0));
         } else
            g_thresholds[i] = value;
      }
      g_thresholdsUpdated = true;
      SaveSettingsToGlobalVars();
   }

   struct CloseInfo {
      string symbol;
      double floatingLoss;
      double threshold;
      int closeCount;
      bool isLocked;
      string lockDirection;
      double lockVolume;
   };
   CloseInfo closeInfos[];
   int infoCount = 0;

   long chartID = ChartFirst();
   if(chartID < 0) return;
   long firstChartID = chartID;

   do {
      if(chartID == g_currentChartID) {
         chartID = ChartNext(chartID);
         if(chartID < 0 || chartID == firstChartID) break;
         continue;
      }
      string chartSymbol = ChartSymbol(chartID);
      if(StringLen(chartSymbol) == 0) {
         chartID = ChartNext(chartID);
         if(chartID < 0 || chartID == firstChartID) break;
         continue;
      }
      double floatingLoss = GetSymbolFloatingLoss(chartSymbol);
      if(floatingLoss >= 0) {
         chartID = ChartNext(chartID);
         if(chartID < 0 || chartID == firstChartID) break;
         continue;
      }

      bool shouldClose = false;
      double matchedThreshold = 0;
      for(int i = 0; i < g_symbolCount; i++) {
         bool symbolMatch = SymbolMatch(g_symbols[i], chartSymbol);
         if(symbolMatch) {
            if(g_thresholds[i] < 0 && floatingLoss <= g_thresholds[i]) {
               shouldClose = true;
               matchedThreshold = g_thresholds[i];
               break;
            }
         }
      }

      if(shouldClose) {
         bool isLocked = false;
         string lockDirection = "";
         double lockVolume = 0.0;
         if(g_enableLockPosition) {
            LockPosition(chartSymbol, lockDirection, lockVolume);
            isLocked = (lockVolume > 0);
         }
         if(ChartSymbol(chartID) != "") {
            if(ChartClose(chartID)) {
               int foundIndex = -1;
               for(int j = 0; j < infoCount; j++) {
                  if(closeInfos[j].symbol == chartSymbol) { foundIndex = j; break; }
               }
               if(foundIndex >= 0) {
                  closeInfos[foundIndex].closeCount++;
                  if(isLocked && !closeInfos[foundIndex].isLocked) {
                     closeInfos[foundIndex].isLocked = true;
                     closeInfos[foundIndex].lockDirection = lockDirection;
                     closeInfos[foundIndex].lockVolume = lockVolume;
                  }
               } else {
                  ArrayResize(closeInfos, infoCount + 1);
                  closeInfos[infoCount].symbol = chartSymbol;
                  closeInfos[infoCount].floatingLoss = floatingLoss;
                  closeInfos[infoCount].threshold = matchedThreshold;
                  closeInfos[infoCount].closeCount = 1;
                  closeInfos[infoCount].isLocked = isLocked;
                  closeInfos[infoCount].lockDirection = lockDirection;
                  closeInfos[infoCount].lockVolume = lockVolume;
                  infoCount++;
               }
               g_monitorStatus.closeCountToday++;
               if(g_synergyMode) RecordSynergyEvent(2, chartSymbol, floatingLoss);
            } else {
               Print("[监控] 关闭图表失败: ", chartSymbol, " (ID:", chartID, ") 错误码: ", GetLastError());
            }
         }
      }
      chartID = ChartNext(chartID);
      if(chartID < 0 || chartID == firstChartID) break;
   } while(true);

   if(infoCount > 0) {
      string alertMessage = "";
      for(int i = 0; i < infoCount; i++) {
         if(StringLen(alertMessage) > 0) alertMessage += "\n";
         if(closeInfos[i].isLocked) {
            alertMessage += "货币：" + closeInfos[i].symbol + " 锁仓完成，" + closeInfos[i].lockDirection + "方向，开仓手数: " +
                           DoubleToString(closeInfos[i].lockVolume, 2) + "并关闭图表" +
                           IntegerToString(closeInfos[i].closeCount) + "个。";
         } else {
            alertMessage += "货币：" + closeInfos[i].symbol + " 浮亏 " + DoubleToString(closeInfos[i].floatingLoss, 2) +
                           " 超过阈值 " + DoubleToString(closeInfos[i].threshold, 2) +
                           "，已成功关闭图表" + IntegerToString(closeInfos[i].closeCount) + "个。";
         }
      }
      Alert(alertMessage);
   }
}

void ActionCloseAllSymbol(int symbolIndex) {
   if(symbolIndex < 0 || symbolIndex >= g_symbolCount) return;
   string symbol = g_symbols[symbolIndex];
   double lots = 0.0;
   int count = 0;
   GetSymbolLotsAndCount(symbol, lots, count);
   if(count == 0) return;
   if(MessageBox("确认全平 " + symbol + " ?\n共 " + IntegerToString(count) + " 单，" +
                DoubleToString(lots, 2) + " 手\n该操作不可撤销！", "全平确认", MB_YESNO | MB_ICONQUESTION) != IDYES)
      return;
   CloseSymbolPositions(symbol, -1);
   UpdateProfitLabels();
   ChartRedraw();
}

void ActionCloseBuy(int symbolIndex) {
   if(symbolIndex < 0 || symbolIndex >= g_symbolCount) return;
   string symbol = g_symbols[symbolIndex];
   double buyLots = 0.0;
   int buyCount = 0;
   int total = PositionsTotal();
   for(int i = 0; i < total; i++) {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket)) {
         string posSymbol = PositionGetString(POSITION_SYMBOL);
         if(SymbolMatch(symbol, posSymbol)) {
            ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            if(posType == POSITION_TYPE_BUY) {
               buyLots += PositionGetDouble(POSITION_VOLUME);
               buyCount++;
            }
         }
      }
   }
   if(buyCount == 0) return;
   if(MessageBox("确认平掉 " + symbol + " 所有多单?\n共 " + IntegerToString(buyCount) + " 单，" +
                DoubleToString(buyLots, 2) + " 手", "平多单确认", MB_YESNO | MB_ICONQUESTION) != IDYES)
      return;
   CloseSymbolPositions(symbol, 0);
   UpdateProfitLabels();
   ChartRedraw();
}

void ActionCloseSell(int symbolIndex) {
   if(symbolIndex < 0 || symbolIndex >= g_symbolCount) return;
   string symbol = g_symbols[symbolIndex];
   double sellLots = 0.0;
   int sellCount = 0;
   int total = PositionsTotal();
   for(int i = 0; i < total; i++) {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket)) {
         string posSymbol = PositionGetString(POSITION_SYMBOL);
         if(SymbolMatch(symbol, posSymbol)) {
            ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            if(posType == POSITION_TYPE_SELL) {
               sellLots += PositionGetDouble(POSITION_VOLUME);
               sellCount++;
            }
         }
      }
   }
   if(sellCount == 0) return;
   if(MessageBox("确认平掉 " + symbol + " 所有空单?\n共 " + IntegerToString(sellCount) + " 单，" +
                DoubleToString(sellLots, 2) + " 手", "平空单确认", MB_YESNO | MB_ICONQUESTION) != IDYES)
      return;
   CloseSymbolPositions(symbol, 1);
   UpdateProfitLabels();
   ChartRedraw();
}

// ====================================================================
// UI 面板辅助函数
// ====================================================================
string StringRepeat(string str, int count) {
   string result = "";
   for(int i = 0; i < count; i++)
      result += str;
   return result;
}

void CreateCell(string name, int x, int y, int width, int height, color bgColor, ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, bool inBackground=true) {
   if(ObjectFind(0, name) < 0) {
      ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, name, OBJPROP_BACK, inBackground);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
}

void CreateHeaderLabel(string name, string text, int x, int y) {
   if(ObjectFind(0, name) < 0) {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_COLOR, GetHeaderTxtColor());
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FONT_HEADER_SIZE_MON);
      ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME_MON);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}

void CreateLabel(string name, string text, int x, int y, color clr, int fontSize) {
   if(ObjectFind(0, name) < 0) {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
      ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME_MON);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}

void CreateEdit(string name, string text, int x, int y, int width, int height) {
   if(ObjectFind(0, name) < 0) {
      ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, GetPanelBgColor());
      ObjectSetInteger(0, name, OBJPROP_COLOR, GetTitleColor());
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, GetTitleColor());
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME_MON);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FONT_EDIT_SIZE_MON);
      ObjectSetInteger(0, name, OBJPROP_ALIGN, ALIGN_CENTER);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
   }
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}

void CreateActionButton(string name, string text, int x, int y, int w, int h) {
   if(ObjectFind(0, name) >= 0) {
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
      return;
   }
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME_MON);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, name, OBJPROP_COLOR, GetTitleColor());
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, GetRowBgDark());
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, GetBorderColor());
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
}

void SwitchButton(string name, int x, int y, int width, int height, string text, string switchText,
                  int fontSize=10, bool reverse=false, string font="Arial", color clr=clrBlack,
                  color backClr=clrDeepSkyBlue, int corner=0) {
   if(ObjectFind(0, name) < 0) {
      if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0)) return;
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, backClr);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, C'180,180,190');
      ObjectSetString(0, name, OBJPROP_FONT, font);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}

void UpdatePanelVisibility() {
   int targetOffset = g_panelVisible ? 0 : -10000;
   int dx = targetOffset - g_hideOffsetX;
   if(dx != 0) {
      int total = ObjectsTotal(0);
      for(int i = total - 1; i >= 0; i--) {
         string objName = ObjectName(0, i);
         if(objName == "") continue;
         if(StringFind(objName, PFX_FUSION) == 0) {
            if(objName == PFX_FUSION "PanelHideButton") continue;
            int ox = (int)ObjectGetInteger(0, objName, OBJPROP_XDISTANCE);
            ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, ox + dx);
         }
         if(StringFind(objName, PFX_MON) == 0) {
            if(objName == PFX_MON "PanelHideButton") continue;
            int ox = (int)ObjectGetInteger(0, objName, OBJPROP_XDISTANCE);
            ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, ox + dx);
         }
      }
      g_hideOffsetX = targetOffset;
   }
   ChartRedraw();
}

// ====================================================================
// UI 面板创建 - 方案0/1/2/3
// ====================================================================

// 方案0 - 原始面板（基础版）
void CreatePanel_Original() {
   int x = 10, y = 25;
   string pfx = PFX_FUSION;

   if(ObjectFind(0, pfx + "Background") < 0)
      ObjectCreate(0, pfx + "Background", OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, pfx + "Background", OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, pfx + "Background", OBJPROP_XDISTANCE, 5);
   ObjectSetInteger(0, pfx + "Background", OBJPROP_YDISTANCE, 20);
   ObjectSetInteger(0, pfx + "Background", OBJPROP_XSIZE, 390);
   ObjectSetInteger(0, pfx + "Background", OBJPROP_YSIZE, 175);
   ObjectSetInteger(0, pfx + "Background", OBJPROP_BGCOLOR, C'30,35,40');
   ObjectSetInteger(0, pfx + "Background", OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, pfx + "Background", OBJPROP_BORDER_COLOR, C'60,65,70');
   ObjectSetInteger(0, pfx + "Background", OBJPROP_BACK, false);

   CreateLabel(pfx + "Title", "===== 融合交易系统 =====", x, y, clrWhite, 9);
   CreateLabel(pfx + "Profit", "当天盈利: --  |  阈值: --", x, y + 18, clrWhite, 9);
   CreateLabel(pfx + "NextCheck", "下一个检测周期【00:30:00】", x, y + 36, clrGold, 9);
   CreateLabel(pfx + "Status", "未达到当天盈利阈值", x, y + 54, clrYellow, 9);
   CreateLabel(pfx + "FloatingPool", "", x, y + 72, clrAqua, 9);
   CreateLabel(pfx + "MaxLoss", "可交易最大净亏: 无", x, y + 90, clrOrange, 9);
   ObjectSetInteger(0, pfx + "MaxLoss", OBJPROP_SELECTABLE, true);
   CreateLabel(pfx + "MaxLossTicketLine", "", x, y + 108, clrOrange, 9);
   ObjectSetInteger(0, pfx + "MaxLossTicketLine", OBJPROP_SELECTABLE, true);
   CreateLabel(pfx + "MaxLossClosed", "休市品种: 无", x, y + 126, clrGray, 9);
   ObjectSetInteger(0, pfx + "MaxLossClosed", OBJPROP_SELECTABLE, true);
   CreateLabel(pfx + "MaxLossClosedTicketLine", "", x, y + 144, clrGray, 9);
   ObjectSetInteger(0, pfx + "MaxLossClosedTicketLine", OBJPROP_SELECTABLE, true);
}

void UpdatePanel_Original() {
   string pfx = PFX_FUSION;
   double todayProfit = g_hedgeStatus.todayProfit;

   ObjectSetString(0, pfx + "Title", OBJPROP_TEXT, "===== 融合交易系统 =====");
   ObjectSetString(0, pfx + "Profit", OBJPROP_TEXT, "当天盈利: " + DoubleToString(todayProfit, 2) + "  |  阈值: " + DoubleToString(DailyProfitThreshold, 2));
   ObjectSetString(0, pfx + "NextCheck", OBJPROP_TEXT, "下一个检测周期【" + FormatHedgeNextCheckTime() + "】");

   if(todayProfit < DailyProfitThreshold) {
      ObjectSetString(0, pfx + "Status", OBJPROP_TEXT, "未达到当天盈利阈值");
      ObjectSetInteger(0, pfx + "Status", OBJPROP_COLOR, clrYellow);
   } else {
      ObjectSetString(0, pfx + "Status", OBJPROP_TEXT, "已达当天盈利阈值，可启动对冲");
      ObjectSetInteger(0, pfx + "Status", OBJPROP_COLOR, clrLime);
   }

   if(UseFloatingProfitHedge) {
      ObjectSetString(0, pfx + "FloatingPool", OBJPROP_TEXT, "当前浮盈池: " + DoubleToString(g_hedgeStatus.floatingProfitPool, 2) + "  |  模式: 浮盈对冲");
   } else {
      ObjectSetString(0, pfx + "FloatingPool", OBJPROP_TEXT, "模式: 当天盈利对冲");
   }

   string tradeableText;
   long tradeableTicket;
   GetMaxFloatingLossOrderInfo(tradeableText, tradeableTicket);
   ObjectSetString(0, pfx + "MaxLoss", OBJPROP_TEXT, tradeableText);
   ObjectSetString(0, pfx + "MaxLossTicketLine", OBJPROP_TEXT, tradeableTicket >= 0 ? "订单号：" + IntegerToString((int)tradeableTicket) : "");

   string closedText;
   long closedTicket;
   GetMaxFloatingLossOrderInfoClosedMarket(closedText, closedTicket);
   ObjectSetString(0, pfx + "MaxLossClosed", OBJPROP_TEXT, closedText);
   ObjectSetString(0, pfx + "MaxLossClosedTicketLine", OBJPROP_TEXT, closedTicket >= 0 ? "订单号：" + IntegerToString((int)closedTicket) : "");

   ChartRedraw();
}

void DeletePanel_Original() {
   string pfx = PFX_FUSION;
   ObjectDelete(0, pfx + "Background");
   ObjectDelete(0, pfx + "Title");
   ObjectDelete(0, pfx + "Profit");
   ObjectDelete(0, pfx + "NextCheck");
   ObjectDelete(0, pfx + "Status");
   ObjectDelete(0, pfx + "FloatingPool");
   ObjectDelete(0, pfx + "MaxLoss");
   ObjectDelete(0, pfx + "MaxLossTicketLine");
   ObjectDelete(0, pfx + "MaxLossClosed");
   ObjectDelete(0, pfx + "MaxLossClosedTicketLine");
}

// 方案1 - 信息密集型面板
void CreatePanel_InfoDense() {
   string pfx = PFX_FUSION + "Info_";
   int w = 600, h = 350;
   int px = PanelX_Init, py = PanelY_Init;

   CreateCell(pfx + "Bg", px, py, w, h, GetPanelBgColor(), CORNER_LEFT_UPPER, false);
   CreateLabel(pfx + "Title", "🛡️ 融合交易系统 v1.0", px + 10, py + 10, GetTitleColor(), 11);

   int y = py + 35;
   CreateCell(pfx + "AccountBg", px + 10, y, w - 20, 45, GetRowBgDark(), CORNER_LEFT_UPPER, false);
   CreateLabel(pfx + "Balance", "💰 余额: $0.00", px + 20, y + 8, GetProfitPosColor(), 9);
   CreateLabel(pfx + "Equity", "💎 净值: $0.00", px + 180, y + 8, GetTitleColor(), 9);
   CreateLabel(pfx + "Margin", "⚖️ 保证金: $0.00", px + 340, y + 8, GetHeaderTxtColor(), 9);
   CreateLabel(pfx + "MarginLevel", "📊 风险率: 0%", px + 20, y + 25, GetProfitNegColor(), 9);
   CreateLabel(pfx + "TodayProfit", "📈 今日盈亏: $0.00", px + 180, y + 25, GetProfitPosColor(), 9);
   CreateLabel(pfx + "Runtime", "⏱ 运行: 0h", px + 340, y + 25, GetHeaderTxtColor(), 9);

   y += 55;
   CreateCell(pfx + "HedgeBg", px + 10, y, w - 20, 60, GetRowBgLight(), CORNER_LEFT_UPPER, false);
   CreateLabel(pfx + "HedgeTitle", "🛡️ 对冲引擎状态", px + 20, y + 8, GetTitleColor(), 9);
   CreateLabel(pfx + "HedgeProgress", "今日盈利: $0.00 / $50.00", px + 20, y + 25, GetProfitPosColor(), 9);
   CreateLabel(pfx + "HedgeStatus", "状态: 未启动", px + 300, y + 8, GetStatusEmptyColor(), 9);
   CreateLabel(pfx + "HedgeMode", "模式: 盈利消耗", px + 300, y + 25, GetHeaderTxtColor(), 9);
   CreateLabel(pfx + "HedgeNext", "下次检测: --", px + 20, y + 42, GetTitleColor(), 9);
   CreateLabel(pfx + "HedgeCount", "已对冲: 0次", px + 300, y + 42, GetHeaderTxtColor(), 9);

   y += 70;
   CreateCell(pfx + "MonitorBg", px + 10, y, w - 20, 85, GetRowBgDark(), CORNER_LEFT_UPPER, false);
   CreateLabel(pfx + "MonitorTitle", "📊 浮亏监控 (点击品种可操作)", px + 20, y + 8, GetTitleColor(), 9);
   int colX = px + 20;
   for(int i = 0; i < MathMin(g_symbolCount, 3); i++) {
      string symText = g_symbols[i];
      double symLoss = GetSymbolTotalProfit(g_symbols[i]);
      color symColor = symLoss >= 0 ? GetProfitPosColor() : GetProfitNegColor();
      string symStatus = symLoss >= 0 ? "盈利" : "亏损";
      CreateLabel(pfx + "MonSym_" + IntegerToString(i), symText + " " + DoubleToString(symLoss, 2) + " [" + symStatus + "]", colX + i * 190, y + 28, symColor, 9);
   }
   CreateLabel(pfx + "MonitorAlert", "⚠️ 超阈值品种: 0", px + 20, y + 55, GetProfitNegColor(), 9);
   CreateLabel(pfx + "MonitorCount", "监控品种: " + IntegerToString(g_symbolCount) + " 个", px + 200, y + 55, GetHeaderTxtColor(), 9);
   CreateLabel(pfx + "MonitorLock", g_enableLockPosition ? "🔒 锁仓: 开" : "🔓 锁仓: 关", px + 380, y + 55, GetTitleColor(), 9);

   y += 95;
   CreateCell(pfx + "BtnBg", px + 10, y, w - 20, 35, GetHeaderBgColor(), CORNER_LEFT_UPPER, false);
   CreateActionButton(pfx + "BtnManualHedge", "手动对冲", px + 20, y + 8, 80, 20);
   CreateActionButton(pfx + "BtnToggleLock", g_enableLockPosition ? "锁仓:开" : "锁仓:关", px + 110, y + 8, 80, 20);
   CreateActionButton(pfx + "BtnHide", "隐藏面板", px + 200, y + 8, 70, 20);
   CreateActionButton(pfx + "BtnScheme", "配色", px + 280, y + 8, 60, 20);
   CreateActionButton(pfx + "BtnCloseAll", "全平", px + 350, y + 8, 60, 20);
   CreateActionButton(pfx + "BtnPause", "暂停EA", px + 420, y + 8, 70, 20);

   ChartRedraw();
}

void UpdatePanel_InfoDense() {
   string pfx = PFX_FUSION + "Info_";
   double bal = GetAccountBalance();
   double eq = GetAccountEquity();
   double margin = GetAccountMargin();
   double marginLevel = GetAccountMarginLevel();

   ObjectSetString(0, pfx + "Balance", OBJPROP_TEXT, "💰 余额: $" + DoubleToString(bal, 2));
   ObjectSetString(0, pfx + "Equity", OBJPROP_TEXT, "💎 净值: $" + DoubleToString(eq, 2));
   ObjectSetString(0, pfx + "Margin", OBJPROP_TEXT, "⚖️ 保证金: $" + DoubleToString(margin, 2));
   ObjectSetString(0, pfx + "MarginLevel", OBJPROP_TEXT, "📊 风险率: " + DoubleToString(marginLevel, 1) + "%");

   ObjectSetString(0, pfx + "TodayProfit", OBJPROP_TEXT, "📈 今日盈亏: $" + DoubleToString(g_hedgeStatus.todayProfit, 2));
   ObjectSetString(0, pfx + "HedgeProgress", OBJPROP_TEXT, "今日盈利: $" + DoubleToString(g_hedgeStatus.todayProfit, 2) + " / $" + DoubleToString(DailyProfitThreshold, 2));
   ObjectSetString(0, pfx + "HedgeStatus", OBJPROP_TEXT, g_hedgeStatus.hedgeReady ? "状态: 待命" : "状态: 未启动");
   ObjectSetInteger(0, pfx + "HedgeStatus", OBJPROP_COLOR, g_hedgeStatus.hedgeReady ? GetStatusNormalColor() : GetStatusEmptyColor());
   ObjectSetString(0, pfx + "HedgeMode", OBJPROP_TEXT, "模式: " + g_hedgeStatus.mode);
   ObjectSetString(0, pfx + "HedgeNext", OBJPROP_TEXT, "下次检测: " + FormatHedgeNextCheckTime());
   ObjectSetString(0, pfx + "HedgeCount", OBJPROP_TEXT, "已对冲: " + IntegerToString(g_hedgeStatus.hedgeCount) + "次");

   for(int i = 0; i < MathMin(g_symbolCount, 3); i++) {
      double symLoss = GetSymbolTotalProfit(g_symbols[i]);
      color symColor = symLoss >= 0 ? GetProfitPosColor() : GetProfitNegColor();
      string symStatus = symLoss >= 0 ? "盈利" : "亏损";
      ObjectSetString(0, pfx + "MonSym_" + IntegerToString(i), OBJPROP_TEXT, g_symbols[i] + " " + DoubleToString(symLoss, 2) + " [" + symStatus + "]");
      ObjectSetInteger(0, pfx + "MonSym_" + IntegerToString(i), OBJPROP_COLOR, symColor);
   }
   ObjectSetString(0, pfx + "MonitorAlert", OBJPROP_TEXT, "⚠️ 超阈值品种: " + IntegerToString(g_monitorStatus.alertCount));
   ObjectSetString(0, pfx + "MonitorCount", OBJPROP_TEXT, "监控品种: " + IntegerToString(g_symbolCount) + " 个");
   ObjectSetString(0, pfx + "MonitorLock", OBJPROP_TEXT, g_enableLockPosition ? "🔒 锁仓: 开" : "🔓 锁仓: 关");

   ObjectSetString(0, pfx + "BtnToggleLock", OBJPROP_TEXT, g_enableLockPosition ? "锁仓:开" : "锁仓:关");
   ObjectSetString(0, pfx + "BtnHide", OBJPROP_TEXT, g_panelVisible ? "隐藏面板" : "显示面板");

   ChartRedraw();
}

void DeletePanel_InfoDense() {
   ObjectsDeleteAll(0, PFX_FUSION + "Info_");
}

// 方案2 - 视觉增强型面板
void CreatePanel_VisualEnhanced() {
   string pfx = PFX_FUSION + "Visual_";
   int w = 550, h = 280;
   int px = PanelX_Init, py = PanelY_Init;

   CreateCell(pfx + "Bg", px, py, w, h, GetPanelBgColor(), CORNER_LEFT_UPPER, false);
   CreateCell(pfx + "TitleBar", px, py, w, 25, GetHeaderBgColor(), CORNER_LEFT_UPPER, false);
   CreateLabel(pfx + "Title", "🌙 融合交易系统", px + 10, py + 8, GetTitleColor(), 11);
   CreateLabel(pfx + "ThemeName", "[" + g_schemes[g_currentScheme].name + "]", px + w - 100, py + 8, GetHeaderTxtColor(), 9);

   int y = py + 35;
   CreateCell(pfx + "MainCard", px + 10, y, w - 20, 80, GetRowBgDark(), CORNER_LEFT_UPPER, false);
   CreateLabel(pfx + "MainTitle", "⚡ 今日盈利 / 🛡️ 对冲状态", px + 20, y + 8, GetTitleColor(), 9);
   string progressText = "$0.00 / $50.00";
   CreateLabel(pfx + "Progress", progressText, px + 20, y + 25, GetProfitPosColor(), 10);
   CreateLabel(pfx + "ProgressBar", "▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░", px + 20, y + 40, GetTitleColor(), 10);
   CreateLabel(pfx + "HedgeStatus", g_hedgeStatus.hedgeReady ? "🔵 待命" : "⚪ 未启动", px + 380, y + 8, g_hedgeStatus.hedgeReady ? GetStatusNormalColor() : GetStatusEmptyColor(), 9);
   CreateLabel(pfx + "HedgeMode", "模式: " + g_hedgeStatus.mode, px + 380, y + 25, GetHeaderTxtColor(), 9);
   CreateLabel(pfx + "HedgeNext", "下次: " + FormatHedgeNextCheckTime(), px + 380, y + 42, GetTitleColor(), 9);
   CreateLabel(pfx + "HedgeCount", "已对冲: 0次", px + 380, y + 58, GetHeaderTxtColor(), 9);

   y += 90;
   CreateCell(pfx + "MonitorCard", px + 10, y, w - 20, 95, GetRowBgLight(), CORNER_LEFT_UPPER, false);
   CreateLabel(pfx + "MonTitle", "📊 品种监控 (Top 3)", px + 20, y + 8, GetTitleColor(), 9);

   long ticket = 0;
   double maxLoss = 0;
   string maxSymbol = "";
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong h = PositionGetTicket(i);
      if(h == 0) continue;
      if(PositionGetInteger(POSITION_TYPE) > POSITION_TYPE_SELL) continue;
      double loss = GetPositionNetProfitByTicket(h);
      if(loss < maxLoss) {
         maxLoss = loss;
         ticket = (long)h;
         maxSymbol = PositionGetString(POSITION_SYMBOL);
      }
   }

   if(ticket > 0 && maxLoss < 0) {
      CreateLabel(pfx + "MaxLoss", "🔴 " + maxSymbol + " 亏 $" + DoubleToString(maxLoss, 2), px + 20, y + 28, GetProfitNegColor(), 9);
      CreateLabel(pfx + "MaxLossInfo", "订单号: " + IntegerToString((int)ticket), px + 20, y + 44, GetHeaderTxtColor(), 8);
   } else {
      CreateLabel(pfx + "MaxLoss", "🟢 无浮亏", px + 20, y + 28, GetProfitPosColor(), 9);
   }

   CreateLabel(pfx + "MonitorInfo", "监控品种: " + IntegerToString(g_symbolCount) + " 个", px + 200, y + 28, GetHeaderTxtColor(), 9);
   CreateLabel(pfx + "AlertInfo", "超阈值: " + IntegerToString(g_monitorStatus.alertCount), px + 200, y + 44, GetProfitNegColor(), 9);
   CreateLabel(pfx + "LockInfo", g_enableLockPosition ? "🔒 锁仓: 开" : "🔓 锁仓: 关", px + 350, y + 28, GetTitleColor(), 9);

   y += 105;
   CreateCell(pfx + "BtnCard", px + 10, y, w - 20, 30, GetHeaderBgColor(), CORNER_LEFT_UPPER, false);
   CreateActionButton(pfx + "BtnHedge", "手动对冲", px + 20, y + 5, 80, 20);
   CreateActionButton(pfx + "BtnLock", g_enableLockPosition ? "锁仓:开" : "锁仓:关", px + 110, y + 5, 80, 20);
   CreateActionButton(pfx + "BtnHide", g_panelVisible ? "隐藏" : "显示", px + 200, y + 5, 60, 20);
   CreateActionButton(pfx + "BtnScheme", "配色", px + 270, y + 5, 50, 20);
   CreateActionButton(pfx + "BtnCloseAll", "全平", px + 330, y + 5, 50, 20);
   CreateActionButton(pfx + "BtnPause", "暂停", px + 390, y + 5, 50, 20);

   ChartRedraw();
}

void UpdatePanel_VisualEnhanced() {
   string pfx = PFX_FUSION + "Visual_";

   ObjectSetString(0, pfx + "ThemeName", OBJPROP_TEXT, "[" + g_schemes[g_currentScheme].name + "]");
   ObjectSetString(0, pfx + "Progress", OBJPROP_TEXT, "$" + DoubleToString(g_hedgeStatus.todayProfit, 2) + " / $" + DoubleToString(DailyProfitThreshold, 2));

   double progressRatio = MathMin(g_hedgeStatus.todayProfit / DailyProfitThreshold, 1.0);
   int barLen = 20;
   int filledLen = (int)(progressRatio * barLen);
   string bar = StringRepeat("▓", filledLen) + StringRepeat("░", barLen - filledLen);
   ObjectSetString(0, pfx + "ProgressBar", OBJPROP_TEXT, bar);
   ObjectSetInteger(0, pfx + "ProgressBar", OBJPROP_COLOR, g_hedgeStatus.hedgeReady ? GetProfitPosColor() : GetProfitNegColor());

   ObjectSetString(0, pfx + "HedgeStatus", OBJPROP_TEXT, g_hedgeStatus.hedgeReady ? "🔵 待命" : "⚪ 未启动");
   ObjectSetInteger(0, pfx + "HedgeStatus", OBJPROP_COLOR, g_hedgeStatus.hedgeReady ? GetStatusNormalColor() : GetStatusEmptyColor());
   ObjectSetString(0, pfx + "HedgeMode", OBJPROP_TEXT, "模式: " + g_hedgeStatus.mode);
   ObjectSetString(0, pfx + "HedgeNext", OBJPROP_TEXT, "下次: " + FormatHedgeNextCheckTime());
   ObjectSetString(0, pfx + "HedgeCount", OBJPROP_TEXT, "已对冲: " + IntegerToString(g_hedgeStatus.hedgeCount) + "次");

   long ticket = 0;
   double maxLoss = 0;
   string maxSymbol = "";
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong h = PositionGetTicket(i);
      if(h == 0) continue;
      if(PositionGetInteger(POSITION_TYPE) > POSITION_TYPE_SELL) continue;
      double loss = GetPositionNetProfitByTicket(h);
      if(loss < maxLoss) {
         maxLoss = loss;
         ticket = (long)h;
         maxSymbol = PositionGetString(POSITION_SYMBOL);
      }
   }

   if(ticket > 0 && maxLoss < 0) {
      ObjectSetString(0, pfx + "MaxLoss", OBJPROP_TEXT, "🔴 " + maxSymbol + " 亏 $" + DoubleToString(maxLoss, 2));
      ObjectSetInteger(0, pfx + "MaxLoss", OBJPROP_COLOR, GetProfitNegColor());
      ObjectSetString(0, pfx + "MaxLossInfo", OBJPROP_TEXT, "订单号: " + IntegerToString((int)ticket));
   } else {
      ObjectSetString(0, pfx + "MaxLoss", OBJPROP_TEXT, "🟢 无浮亏");
      ObjectSetInteger(0, pfx + "MaxLoss", OBJPROP_COLOR, GetProfitPosColor());
      ObjectSetString(0, pfx + "MaxLossInfo", OBJPROP_TEXT, "");
   }

   ObjectSetString(0, pfx + "MonitorInfo", OBJPROP_TEXT, "监控品种: " + IntegerToString(g_symbolCount) + " 个");
   ObjectSetString(0, pfx + "AlertInfo", OBJPROP_TEXT, "超阈值: " + IntegerToString(g_monitorStatus.alertCount));
   ObjectSetString(0, pfx + "LockInfo", OBJPROP_TEXT, g_enableLockPosition ? "🔒 锁仓: 开" : "🔓 锁仓: 关");

   ObjectSetString(0, pfx + "BtnLock", OBJPROP_TEXT, g_enableLockPosition ? "锁仓:开" : "锁仓:关");
   ObjectSetString(0, pfx + "BtnHide", OBJPROP_TEXT, g_panelVisible ? "隐藏" : "显示");

   ChartRedraw();
}

void DeletePanel_VisualEnhanced() {
   ObjectsDeleteAll(0, PFX_FUSION + "Visual_");
}

// 方案3 - 分区布局型面板
void CreatePanel_TabLayout() {
   string pfx = PFX_FUSION + "Tab_";
   int w = 650, h = 320;
   int px = PanelX_Init, py = PanelY_Init;

   CreateCell(pfx + "Bg", px, py, w, h, GetPanelBgColor(), CORNER_LEFT_UPPER, false);
   CreateCell(pfx + "TitleBar", px, py, w, 25, GetHeaderBgColor(), CORNER_LEFT_UPPER, false);
   CreateLabel(pfx + "Title", "🛡️ 融合交易系统 v1.0", px + 10, py + 8, GetTitleColor(), 11);

   int tabY = py + 30;
   CreateCell(pfx + "TabBar", px, tabY, w, 25, GetBorderColor(), CORNER_LEFT_UPPER, false);
   CreateActionButton(pfx + "Tab0", "📊 总览", px + 5, tabY + 3, 80, 19);
   CreateActionButton(pfx + "Tab1", "🛡️ 对冲", px + 90, tabY + 3, 80, 19);
   CreateActionButton(pfx + "Tab2", "📉 监控", px + 175, tabY + 3, 80, 19);
   CreateActionButton(pfx + "Tab3", "📜 日志", px + 260, tabY + 3, 80, 19);
   CreateActionButton(pfx + "Tab4", "⚙️ 设置", px + 345, tabY + 3, 80, 19);

   int contentY = tabY + 30;
   CreateCell(pfx + "ContentBg", px + 10, contentY, w - 20, 220, GetRowBgDark(), CORNER_LEFT_UPPER, false);

   CreateLabel(pfx + "BalLabel", "💰 余额", px + 20, contentY + 15, GetHeaderTxtColor(), 8);
   CreateLabel(pfx + "BalValue", "$0.00", px + 20, contentY + 30, GetProfitPosColor(), 10);
   CreateLabel(pfx + "EqLabel", "💎 净值", px + 110, contentY + 15, GetHeaderTxtColor(), 8);
   CreateLabel(pfx + "EqValue", "$0.00", px + 110, contentY + 30, GetTitleColor(), 10);
   CreateLabel(pfx + "MarLabel", "⚖️ 保证金", px + 200, contentY + 15, GetHeaderTxtColor(), 8);
   CreateLabel(pfx + "MarValue", "$0.00", px + 200, contentY + 30, GetHeaderTxtColor(), 10);
   CreateLabel(pfx + "RiskLabel", "📊 风险率", px + 290, contentY + 15, GetHeaderTxtColor(), 8);
   CreateLabel(pfx + "RiskValue", "0%", px + 290, contentY + 30, GetProfitNegColor(), 10);

   CreateLabel(pfx + "TPLabel", "📈 今日盈亏", px + 20, contentY + 55, GetHeaderTxtColor(), 8);
   CreateLabel(pfx + "TPValue", "$0.00", px + 20, contentY + 70, GetProfitPosColor(), 10);
   CreateLabel(pfx + "StatusLabel", "🛡️ 对冲状态", px + 110, contentY + 55, GetHeaderTxtColor(), 8);
   CreateLabel(pfx + "StatusValue", "⚪ 未启动", px + 110, contentY + 70, GetStatusEmptyColor(), 10);
   CreateLabel(pfx + "ModeLabel", "💡 对冲模式", px + 200, contentY + 55, GetHeaderTxtColor(), 8);
   CreateLabel(pfx + "ModeValue", "盈利消耗", px + 200, contentY + 70, GetHeaderTxtColor(), 10);
   CreateLabel(pfx + "NextLabel", "⏱ 下次检测", px + 290, contentY + 55, GetHeaderTxtColor(), 8);
   CreateLabel(pfx + "NextValue", "--", px + 290, contentY + 70, GetTitleColor(), 10);

   CreateLabel(pfx + "MonTitle", "📊 监控品种 Top 3", px + 20, contentY + 100, GetTitleColor(), 9);
   for(int i = 0; i < MathMin(g_symbolCount, 3); i++) {
      double symLoss = GetSymbolTotalProfit(g_symbols[i]);
      color symColor = symLoss >= 0 ? GetProfitPosColor() : GetProfitNegColor();
      CreateLabel(pfx + "MonSym_" + IntegerToString(i), g_symbols[i] + ": $" + DoubleToString(symLoss, 2), px + 20, contentY + 120 + i * 18, symColor, 9);
   }

   CreateActionButton(pfx + "BtnManualHedge", "手动对冲", px + 20, py + h - 35, 80, 20);
   CreateActionButton(pfx + "BtnLock", g_enableLockPosition ? "锁仓:开" : "锁仓:关", px + 110, py + h - 35, 80, 20);
   CreateActionButton(pfx + "BtnHide", g_panelVisible ? "隐藏" : "显示", px + 200, py + h - 35, 60, 20);
   CreateActionButton(pfx + "BtnScheme", "配色", px + 270, py + h - 35, 50, 20);

   ChartRedraw();
}

void UpdatePanel_TabLayout() {
   string pfx = PFX_FUSION + "Tab_";

   ObjectSetString(0, pfx + "BalValue", OBJPROP_TEXT, "$" + DoubleToString(GetAccountBalance(), 2));
   ObjectSetString(0, pfx + "EqValue", OBJPROP_TEXT, "$" + DoubleToString(GetAccountEquity(), 2));
   ObjectSetString(0, pfx + "MarValue", OBJPROP_TEXT, "$" + DoubleToString(GetAccountMargin(), 2));
   ObjectSetString(0, pfx + "RiskValue", OBJPROP_TEXT, DoubleToString(GetAccountMarginLevel(), 1) + "%");

   ObjectSetString(0, pfx + "TPValue", OBJPROP_TEXT, "$" + DoubleToString(g_hedgeStatus.todayProfit, 2));
   ObjectSetString(0, pfx + "StatusValue", OBJPROP_TEXT, g_hedgeStatus.hedgeReady ? "🔵 待命" : "⚪ 未启动");
   ObjectSetInteger(0, pfx + "StatusValue", OBJPROP_COLOR, g_hedgeStatus.hedgeReady ? GetStatusNormalColor() : GetStatusEmptyColor());
   ObjectSetString(0, pfx + "ModeValue", OBJPROP_TEXT, g_hedgeStatus.mode);
   ObjectSetString(0, pfx + "NextValue", OBJPROP_TEXT, FormatHedgeNextCheckTime());

   for(int i = 0; i < MathMin(g_symbolCount, 3); i++) {
      double symLoss = GetSymbolTotalProfit(g_symbols[i]);
      color symColor = symLoss >= 0 ? GetProfitPosColor() : GetProfitNegColor();
      ObjectSetString(0, pfx + "MonSym_" + IntegerToString(i), OBJPROP_TEXT, g_symbols[i] + ": $" + DoubleToString(symLoss, 2));
      ObjectSetInteger(0, pfx + "MonSym_" + IntegerToString(i), OBJPROP_COLOR, symColor);
   }

   ObjectSetString(0, pfx + "BtnLock", OBJPROP_TEXT, g_enableLockPosition ? "锁仓:开" : "锁仓:关");
   ObjectSetString(0, pfx + "BtnHide", OBJPROP_TEXT, g_panelVisible ? "隐藏" : "显示");

   ChartRedraw();
}

void DeletePanel_TabLayout() {
   ObjectsDeleteAll(0, PFX_FUSION + "Tab_");
}

// ====================================================================
// UI 面板管理
// ====================================================================
void CreateActivePanel() {
   switch(PanelStyle) {
      case 0: CreatePanel_Original(); break;
      case 1: CreatePanel_InfoDense(); break;
      case 2: CreatePanel_VisualEnhanced(); break;
      case 3: CreatePanel_TabLayout(); break;
   }
   // 同时创建浮亏监控面板
   if(g_enableLossMonitor)
      CreateMonitorPanel();
}

void UpdateActivePanel() {
   switch(PanelStyle) {
      case 0: UpdatePanel_Original(); break;
      case 1: UpdatePanel_InfoDense(); break;
      case 2: UpdatePanel_VisualEnhanced(); break;
      case 3: UpdatePanel_TabLayout(); break;
   }
}

void DeleteActivePanel() {
   switch(PanelStyle) {
      case 0: DeletePanel_Original(); break;
      case 1: DeletePanel_InfoDense(); break;
      case 2: DeletePanel_VisualEnhanced(); break;
      case 3: DeletePanel_TabLayout(); break;
   }
   if(g_enableLossMonitor)
      DeleteMonitorPanel();
}

// ====================================================================
// 浮亏监控面板（独立面板）
// ====================================================================
void CreateMonitorPanel() {
   int px = PanelX_Init, py = PanelY_Init + 360;
   CreateCell(PFX_MON "Panel_Border", px - BORDER_WIDTH_MON, py - BORDER_WIDTH_MON,
              PANEL_WIDTH_MON + 2 * BORDER_WIDTH_MON, PANEL_HEIGHT_MON + 2 * BORDER_WIDTH_MON,
              GetBorderColor(), CORNER_LEFT_UPPER, true);
   CreateCell(PFX_MON "Panel_BG", px, py, PANEL_WIDTH_MON, PANEL_HEIGHT_MON,
              GetPanelBgColor(), CORNER_LEFT_UPPER, false);
   CreateCell(PFX_MON "Title_Bar", px + 2, py, PANEL_WIDTH_MON - 4, TITLE_BAR_HEIGHT_MON,
              GetHeaderBgColor(), CORNER_LEFT_UPPER, false);
   string titleText = "◆ 浮亏监控  [" + g_schemes[g_currentScheme].name + "]";
   CreateLabel(PFX_MON "Title_Label", titleText, px + 8, py + 5, GetTitleColor(), 9);

   int headerY = py + TITLE_BAR_HEIGHT_MON + 4;
   int headerWidth = PANEL_WIDTH_MON - MARGIN_MON * 2;
   CreateCell(PFX_MON "Header_BG", px + MARGIN_MON, headerY, headerWidth, HEADER_HEIGHT_MON,
              GetHeaderBgColor(), CORNER_LEFT_UPPER, false);
   CreateHeaderLabel(PFX_MON "Header_Num", "#", px + ColX_Num(), headerY);
   CreateHeaderLabel(PFX_MON "Header_Symbol", "品种", px + ColX_Symbol(), headerY);
   CreateHeaderLabel(PFX_MON "Header_Lots", "手数", px + ColX_Lots(), headerY);
   CreateHeaderLabel(PFX_MON "Header_Count", "单量", px + ColX_Count(), headerY);
   CreateHeaderLabel(PFX_MON "Header_Profit", "盈亏", px + ColX_Profit(), headerY);
   CreateHeaderLabel(PFX_MON "Header_Thresh", "阈值", px + ColX_Thresh(), headerY);
   CreateHeaderLabel(PFX_MON "Header_Status", "状态", px + ColX_Status(), headerY);
   CreateHeaderLabel(PFX_MON "Header_Action", "操作", px + ColX_Action(), headerY);

   CreateCell(PFX_MON "Header_Line", px + MARGIN_MON, headerY + HEADER_HEIGHT_MON, headerWidth, 1,
              GetBorderColor(), CORNER_LEFT_UPPER, false);

   int startY = headerY + HEADER_HEIGHT_MON + 2;
   for(int i = 0; i < g_symbolCount; i++) {
      int rowY = startY + i * ROW_HEIGHT_MON;
      color rowColor = (i % 2 == 0) ? GetRowBgDark() : GetRowBgLight();
      CreateCell(PFX_MON "Row_BG_" + IntegerToString(i), px + MARGIN_MON, rowY, headerWidth, ROW_HEIGHT_MON,
                 rowColor, CORNER_LEFT_UPPER, false);
      CreateLabel(PFX_MON "Num_" + IntegerToString(i), IntegerToString(i + 1), px + ColX_Num(), rowY + 5, GetProfitZeroColor(), 9);
      CreateLabel(PFX_MON "Symbol_" + IntegerToString(i), g_symbols[i], px + ColX_Symbol(), rowY + 5, GetHeaderTxtColor(), 9);
      CreateLabel(g_lotsLabelNames[i], "0.00", px + ColX_Lots(), rowY + 5, GetHeaderTxtColor(), 9);
      CreateLabel(g_countLabelNames[i], "0", px + ColX_Count(), rowY + 5, GetHeaderTxtColor(), 9);
      CreateLabel(g_profitLabelNames[i], "0.00", px + ColX_Profit(), rowY + 5, GetProfitZeroColor(), 9);
      CreateEdit(g_editNames[i], DoubleToString(g_thresholds[i], 0), px + ColX_Thresh(), rowY + 3, COL_THRESH_MON - 8, EDIT_HEIGHT_MON);
      CreateLabel(g_statusLabelNames[i], "● 无仓位", px + ColX_Status(), rowY + 5, GetProfitZeroColor(), 9);

      int btnW = 62, btnH = 20, btnGap = 4;
      int btnY = rowY + 3;
      int btnBaseX = px + ColX_Action();
      CreateActionButton(g_btnCloseAllNames[i], "全平", btnBaseX, btnY, btnW, btnH);
      CreateActionButton(g_btnCloseBuyNames[i], "平多", btnBaseX + btnW + btnGap, btnY, btnW, btnH);
      CreateActionButton(g_btnCloseSellNames[i], "平空", btnBaseX + 2 * (btnW + btnGap), btnY, btnW, btnH);
   }

   int footerY = startY + g_symbolCount * ROW_HEIGHT_MON + 4;
   CreateCell(PFX_MON "Footer_Bar", px + MARGIN_MON, footerY, headerWidth, FOOTER_HEIGHT_MON,
              GetHeaderBgColor(), CORNER_LEFT_UPPER, false);
   SwitchButton(PFX_MON "LockToggleButton", px + MARGIN_MON + 8, footerY + 3, 100, 18,
                g_enableLockPosition ? "锁仓：开" : "锁仓：关", "锁仓：关", 9, false, FONT_NAME_MON,
                GetTitleColor(), GetHeaderBgColor(), CORNER_LEFT_UPPER);
   SwitchButton(PFX_MON "PanelHideButton", px + PANEL_WIDTH_MON - MARGIN_MON - 78, footerY + 3, 70, 18,
                g_panelVisible ? "隐藏面板" : "显示面板", "显示面板", 9, false, FONT_NAME_MON,
                GetTitleColor(), GetHeaderBgColor(), CORNER_LEFT_UPPER);

   if(!g_panelVisible) {
      int total = ObjectsTotal(0);
      for(int i = total - 1; i >= 0; i--) {
         string objName = ObjectName(0, i);
         if(objName != "" && StringFind(objName, PFX_MON) == 0) {
            if(objName == PFX_MON "PanelHideButton") continue;
            int ox = (int)ObjectGetInteger(0, objName, OBJPROP_XDISTANCE);
            ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, ox - 10000);
         }
      }
      g_hideOffsetX = -10000;
   }

   ChartRedraw();
}

void DeleteMonitorPanel() {
   ObjectsDeleteAll(0, PFX_MON);
}

// ====================================================================
// 主循环函数 - 初始化、运行、事件处理
// ====================================================================
int OnInit() {
   trade.SetExpertMagicNumber(0);
   trade.SetDeviationInPoints(50);
   Print("融合交易系统已启动 - 版本 1.00");

   InitColorSchemes();

   if(GlobalVariableCheck(THEME_KEY))
      g_currentScheme = (int)GlobalVariableGet(THEME_KEY);
   else
      g_currentScheme = MathMin(ColorScheme, SCHEME_COUNT - 1);

   g_currentChartID = ChartID();
   g_panelX = PanelX_Init;
   g_panelY = PanelY_Init;
   g_hideOffsetX = 0;
   g_enableLockPosition = EnableLockPosition;
   g_enableHedgeEngine = EnableHedgeEngine;
   g_enableLossMonitor = EnableLossMonitor;
   g_synergyMode = SynergyMode;

   ParseSymbolList(SymbolList);

   for(int i = 0; i < g_symbolCount; i++) {
      g_thresholds[i] = -88888888.0;
      g_editNames[i] = PFX_MON "ThresholdEdit_" + IntegerToString(i);
      g_labelNames[i] = PFX_MON "ActionLabel_" + IntegerToString(i);
      g_btnCloseAllNames[i] = PFX_MON "BtnCloseAll_" + IntegerToString(i);
      g_btnCloseBuyNames[i] = PFX_MON "BtnCloseBuy_" + IntegerToString(i);
      g_btnCloseSellNames[i] = PFX_MON "BtnCloseSell_" + IntegerToString(i);
      g_profitLabelNames[i] = PFX_MON "ProfitLabel_" + IntegerToString(i);
      g_lotsLabelNames[i] = PFX_MON "LotsLabel_" + IntegerToString(i);
      g_countLabelNames[i] = PFX_MON "CountLabel_" + IntegerToString(i);
      g_statusLabelNames[i] = PFX_MON "StatusLabel_" + IntegerToString(i);
   }

   if(ShouldRestoreSavedSettings())
      LoadSettingsFromGlobalVars();

   g_thresholdsUpdated = false;
   g_hedgeLastCheck = TimeCurrent();
   g_monitorLastCheckTime = TimeCurrent();
   g_monitorLastProfitUpdateTime = 0;

   LoadMaxTodayProfit();

   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);

   CreateActivePanel();
   UpdateProfitLabels();

   SyncHedgeStatus();
   SyncMonitorStatus();

   Print("融合EA初始化完成:");
   Print("  - 对冲引擎: ", EnableHedgeEngine ? "启用" : "禁用");
   Print("  - 浮亏监控: ", EnableLossMonitor ? "启用" : "禁用");
   Print("  - 协同模式: ", SynergyMode ? "开启" : "关闭");
   Print("  - 面板样式: ", PanelStyle, " (0=原始, 1=信息密集, 2=视觉增强, 3=分区布局)");
   Print("  - 配色方案: ", g_schemes[g_currentScheme].name);
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
   SaveSettingsToGlobalVars();
   string reasonKey = BuildStorageKey("LastDeinitReason");
   GlobalVariableSet(reasonKey, reason);
   DeleteActivePanel();
   ChartRedraw();
   Print("融合EA已关闭");
}

void OnTick() {
   SyncHedgeStatus();
   SyncMonitorStatus();
   ProcessSynergyEvents();

   datetime now = TimeCurrent();
   int refreshSec = (PanelRefreshSeconds < 1) ? 1 : PanelRefreshSeconds;

   if(now - g_hedgeLastPanelUpdate >= refreshSec && g_panelVisible) {
      g_hedgeLastPanelUpdate = now;
      UpdateActivePanel();
      if(g_enableLossMonitor)
         UpdateProfitLabels();
   }

   if(g_enableHedgeEngine)
      RunHedgeEngine();

   if(g_enableLossMonitor)
      RunMonitorEngine();
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   if(id == CHARTEVENT_OBJECT_CLICK) {
      // 浮亏监控面板按钮
      if(StringFind(sparam, PFX_MON "BtnCloseAll_") == 0) {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
         int idx = (int)StringToInteger(StringSubstr(sparam, StringLen(PFX_MON "BtnCloseAll_")));
         ActionCloseAllSymbol(idx);
         return;
      }
      if(StringFind(sparam, PFX_MON "BtnCloseBuy_") == 0) {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
         int idx = (int)StringToInteger(StringSubstr(sparam, StringLen(PFX_MON "BtnCloseBuy_")));
         ActionCloseBuy(idx);
         return;
      }
      if(StringFind(sparam, PFX_MON "BtnCloseSell_") == 0) {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
         int idx = (int)StringToInteger(StringSubstr(sparam, StringLen(PFX_MON "BtnCloseSell_")));
         ActionCloseSell(idx);
         return;
      }
      if(sparam == PFX_MON "LockToggleButton") {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
         g_enableLockPosition = !g_enableLockPosition;
         SaveSettingsToGlobalVars();
         if(PanelStyle == 1)
            ObjectSetString(0, PFX_FUSION + "Info_BtnToggleLock", OBJPROP_TEXT, g_enableLockPosition ? "锁仓:开" : "锁仓:关");
         else if(PanelStyle == 2)
            ObjectSetString(0, PFX_FUSION + "Visual_BtnLock", OBJPROP_TEXT, g_enableLockPosition ? "锁仓:开" : "锁仓:关");
         else if(PanelStyle == 3)
            ObjectSetString(0, PFX_FUSION + "Tab_BtnLock", OBJPROP_TEXT, g_enableLockPosition ? "锁仓:开" : "锁仓:关");
         DeleteMonitorPanel();
         CreateMonitorPanel();
         UpdateProfitLabels();
         SaveSettingsToGlobalVars();
         return;
      }
      if(sparam == PFX_MON "PanelHideButton") {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
         g_panelVisible = !g_panelVisible;
         if(g_panelVisible)
            ObjectSetString(0, sparam, OBJPROP_TEXT, "隐藏面板");
         else
            ObjectSetString(0, sparam, OBJPROP_TEXT, "显示面板");
         UpdatePanelVisibility();
         return;
      }

      // 主面板按钮
      if(StringFind(sparam, PFX_FUSION + "Info_") == 0 ||
         StringFind(sparam, PFX_FUSION + "Visual_") == 0 ||
         StringFind(sparam, PFX_FUSION + "Tab_") == 0) {

         string btnName = sparam;
         ObjectSetInteger(0, btnName, OBJPROP_STATE, false);

         if(StringFind(btnName, "BtnManualHedge") > 0 || StringFind(btnName, "BtnHedge") > 0) {
            if(!g_enableHedgeEngine) {
               Alert("对冲引擎已禁用，请先启用对冲引擎");
               return;
            }
            if(g_hedgeStatus.todayProfit < DailyProfitThreshold) {
               Alert("今日盈利不足，无法启动对冲。当前盈利: " + DoubleToString(g_hedgeStatus.todayProfit, 2) +
                     "，阈值: " + DoubleToString(DailyProfitThreshold, 2));
               return;
            }
            Alert("手动对冲已触发，等待下一个对冲检测周期执行");
            g_hedgeLastCheck = 0;
            return;
         }
         if(StringFind(btnName, "BtnToggleLock") > 0 || StringFind(btnName, "BtnLock") > 0) {
            g_enableLockPosition = !g_enableLockPosition;
            SaveSettingsToGlobalVars();
            UpdateActivePanel();
            CreateMonitorPanel();
            return;
         }
         if(StringFind(btnName, "BtnHide") > 0) {
            g_panelVisible = !g_panelVisible;
            UpdatePanelVisibility();
            UpdateActivePanel();
            if(g_enableLossMonitor) CreateMonitorPanel();
            return;
         }
         if(StringFind(btnName, "BtnScheme") > 0) {
            int nextScheme = (g_currentScheme + 1) % SCHEME_COUNT;
            g_currentScheme = nextScheme;
            GlobalVariableSet(THEME_KEY, g_currentScheme);
            DeleteActivePanel();
            CreateActivePanel();
            return;
         }
         if(StringFind(btnName, "BtnCloseAll") > 0) {
            if(MessageBox("确认全平所有监控品种？\n该操作不可撤销！", "全平确认", MB_YESNO | MB_ICONQUESTION) == IDYES) {
               for(int i = 0; i < g_symbolCount; i++)
                  CloseSymbolPositions(g_symbols[i], -1);
               UpdateActivePanel();
            }
            return;
         }
         if(StringFind(btnName, "BtnPause") > 0) {
            g_enableHedgeEngine = !g_enableHedgeEngine;
            Alert(g_enableHedgeEngine ? "对冲引擎已启用" : "对冲引擎已暂停");
            return;
         }
      }

      // 方案0面板
      if(PanelStyle == 0) {
         if((sparam == PFX_FUSION + "MaxLoss" || sparam == PFX_FUSION + "MaxLossTicketLine") && g_TradeableTicket >= 0)
            Alert(g_TradeableText);
         if((sparam == PFX_FUSION + "MaxLossClosed" || sparam == PFX_FUSION + "MaxLossClosedTicketLine") && g_ClosedTicket >= 0)
            Alert(g_ClosedText);
      }
   }

   int mouseX = (int)lparam;
   int mouseY = (int)dparam;

   if(id == CHARTEVENT_CLICK) {
      if(!g_enableLossMonitor) return;

      if(IsClickOnTitleLabel_Mon(mouseX, mouseY)) {
         int nextScheme = (g_currentScheme + 1) % SCHEME_COUNT;
         g_currentScheme = nextScheme;
         GlobalVariableSet(THEME_KEY, g_currentScheme);
         DeleteActivePanel();
         CreateActivePanel();
         return;
      }

      if(IsClickOnPanelArea_Mon(mouseX, mouseY)) {
         g_isDragging = true;
         g_dragStartX = mouseX;
         g_dragStartY = mouseY;
         g_panelOffsetX = g_panelX;
         g_panelOffsetY = g_panelY;
      }
   }

   if(id == CHARTEVENT_MOUSE_MOVE && g_isDragging) {
      if(!g_enableLossMonitor) { g_isDragging = false; return; }
      int dx = mouseX - g_dragStartX;
      int dy = mouseY - g_dragStartY;
      int newX = g_panelOffsetX + dx;
      int newY = g_panelOffsetY + dy;
      MovePanel_Mon(newX, newY);
   }

   if(id == CHARTEVENT_OBJECT_ENDEDIT) {
      for(int i = 0; i < g_symbolCount; i++) {
         if(sparam == g_editNames[i]) {
            string text = ObjectGetString(0, g_editNames[i], OBJPROP_TEXT);
            if(StringLen(text) == 0) break;
            double value = StringToDouble(text);
            if(value == 0 && StringCompare(text, "0", false) != 0 &&
               StringCompare(text, "-0", false) != 0 && StringCompare(text, "0.0", false) != 0) {
               ObjectSetString(0, g_editNames[i], OBJPROP_TEXT, DoubleToString(g_thresholds[i], 0));
               break;
            }
            if(value > 0) {
               g_thresholds[i] = -value;
               ObjectSetString(0, g_editNames[i], OBJPROP_TEXT, DoubleToString(-value, 0));
            } else
               g_thresholds[i] = value;
            g_thresholdsUpdated = true;
            SaveSettingsToGlobalVars();
            break;
         }
      }
   }
}

bool IsClickOnPanelArea_Mon(int x, int y) {
   if(!g_panelVisible) return false;
   int titleTop = g_panelY + 2;
   int titleBottom = g_panelY + 2 + TITLE_BAR_HEIGHT_MON;
   if(y >= titleTop && y <= titleBottom &&
      x >= g_panelX && x <= g_panelX + PANEL_WIDTH_MON)
      return true;

   int DRAG_ZONE = 6;
   int outerLeft = g_panelX - DRAG_ZONE;
   int outerTop = g_panelY - DRAG_ZONE;
   int outerRight = g_panelX + PANEL_WIDTH_MON + DRAG_ZONE;
   int outerBottom = g_panelY + PANEL_HEIGHT_MON + DRAG_ZONE;
   int innerLeft = g_panelX + DRAG_ZONE;
   int innerTop = g_panelY + DRAG_ZONE;
   int innerRight = g_panelX + PANEL_WIDTH_MON - DRAG_ZONE;
   int innerBottom = g_panelY + PANEL_HEIGHT_MON - DRAG_ZONE;

   if(x < outerLeft || x > outerRight || y < outerTop || y > outerBottom)
      return false;
   if(x > innerLeft && x < innerRight && y > innerTop && y < innerBottom)
      return false;
   return true;
}

bool IsClickOnTitleLabel_Mon(int x, int y) {
   if(!g_panelVisible) return false;
   int titleTop = g_panelY + 2;
   int titleBottom = g_panelY + 2 + TITLE_BAR_HEIGHT_MON;
   int titleRight = g_panelX + 2 + (int)((PANEL_WIDTH_MON - 4) * 0.60);
   if(y >= titleTop && y <= titleBottom &&
      x >= g_panelX + 2 && x <= titleRight)
      return true;
   return false;
}

void OffsetPanelObjects_Mon(int dx, int dy) {
   if(dx == 0 && dy == 0) return;
   int total = ObjectsTotal(0);
   for(int i = total - 1; i >= 0; i--) {
      string objName = ObjectName(0, i);
      if(objName != "" && StringFind(objName, PFX_MON) == 0) {
         int ox = (int)ObjectGetInteger(0, objName, OBJPROP_XDISTANCE);
         int oy = (int)ObjectGetInteger(0, objName, OBJPROP_YDISTANCE);
         ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, ox + dx);
         ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, oy + dy);
      }
   }
   g_panelX += dx;
   g_panelY += dy;
}

void MovePanel_Mon(int newX, int newY) {
   int chartWidth = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   int chartHeight = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
   int maxX = chartWidth - PANEL_WIDTH_MON;
   int maxY = chartHeight - PANEL_HEIGHT_MON;
   if(maxX < 0) maxX = 0;
   if(maxY < 0) maxY = 0;
   if(newX < 0) newX = 0;
   if(newY < 0) newY = 0;
   if(newX > maxX) newX = maxX;
   if(newY > maxY) newY = maxY;
   int dx = newX - g_panelX;
   int dy = newY - g_panelY;
   OffsetPanelObjects_Mon(dx, dy);
}
