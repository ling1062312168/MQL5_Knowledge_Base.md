//+------------------------------------------------------------------+
//|                                           浮亏监控关闭图表.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.01"

// 输入参数
input string SymbolList = "XAUUSD,EURUSD,GBPUSD,AUDUSD,USDCHF,GBPJPY,BTCUSD,NZDCAD"; // 监控的货币对列表（用逗号分隔）
input string SymbolSuffix = "";  // 货币对后缀（如.m，留空表示无后缀）
input int    CheckInterval = 5;  // 检查间隔（秒）
input bool   EnableLockPosition = false;  // 是否开启达到阈值并且锁仓
input int    PanelX_init = 20;   // 面板X坐标初始值
input int    PanelY_init = 50;   // 面板Y坐标初始值

// 支持的货币对配置
#define MAX_SYMBOLS 8
string g_symbols[MAX_SYMBOLS];  // 从输入参数解析的货币对列表

// 面板配置
#define PFX "FLP_"  // 面板对象前缀（Floating Loss Panel，用于拖拽时批量识别对象）
#define PANEL_WIDTH 730  // 面板宽度
#define PANEL_HEIGHT 296  // 面板高度（边距2+标题26+间距4+表头24+间距2+8行26+间距4+底栏24+边距2）
#define ROW_HEIGHT 26     // 行高（更紧凑）
// 列宽定义（可用宽度=730-20=710）
#define COL_NUM     30   // 序号列
#define COL_SYMBOL  90   // 品种列
#define COL_LOTS    60   // 手数列
#define COL_COUNT   50   // 单量列
#define COL_PROFIT  110  // 浮亏列
#define COL_THRESH  90   // 阈值列
#define COL_STATUS  80   // 状态列
#define COL_ACTION  200  // 操作列（平仓操作）
#define MARGIN 10
#define HEADER_HEIGHT 24
#define EDIT_HEIGHT 20
#define FONT_HEADER_SIZE 9
#define FONT_LABEL_SIZE 9
#define FONT_EDIT_SIZE 9
#define FONT_VALUE_SIZE 9
#define TITLE_BAR_HEIGHT 26  // 标题栏高度（拖拽手柄区域）
#define BORDER_WIDTH 3       // 拖拽边框宽度
#define FOOTER_HEIGHT 24     // 底部栏高度（锁仓+隐藏按钮）

//+------------------------------------------------------------------+
//| 配色方案枚举                                                       |
//+------------------------------------------------------------------+
enum COLOR_SCHEME
{
   SCHEME_BLUE_GOLD = 0,      // 深空蓝金
   SCHEME_JADE_GREEN = 1,     // 墨玉绿
   SCHEME_TECH_CYAN = 2,      // 炭青科技
   SCHEME_PURPLE_NIGHT = 3,   // 紫银夜（默认）
   SCHEME_MORANDI_GRAY = 4,   // 莫兰迪灰
   SCHEME_NEON_PLASMA = 5,    // 霓虹等离子
   SCHEME_AURORA_TEAL = 6,    // 极光青翠
   SCHEME_SUNSET_FIRE = 7,    // 烈焰夕阳
   SCHEME_ICE_FROST = 8,      // 冰晶霜银
   SCHEME_CYBER_GOLD = 9      // 赛博鎏金
};

#define SCHEME_COUNT 10

// 配色方案数据结构
struct ColorScheme
{
   string name;           // 方案名称
   color  titleColor;     // 标题文字色
   color  panelBgColor;   // 面板背景色
   color  rowBgDark;      // 行背景深
   color  rowBgLight;     // 行背景浅
   color  rowBgDanger;    // 危险行背景
   color  borderColor;    // 边框色
   color  headerBgColor;  // 表头背景
   color  headerTxtColor; // 表头文字
   color  profitNegColor; // 亏损色
   color  profitPosColor; // 盈利色
   color  profitZeroColor;// 零值色
};

// 全局配色方案数组
ColorScheme g_schemes[SCHEME_COUNT];
int g_currentScheme = SCHEME_PURPLE_NIGHT;  // 当前配色方案（默认紫银夜）

const string FONT_NAME = "Consolas";              // 等宽字体（数据对齐）

// 主题选择持久化键名
const string THEME_KEY = "FLP_ColorScheme";

// 面板位置变量（运行时可变，拖拽时动态更新）
int g_panelX = 20;
int g_panelY = 50;

// 拖拽相关全局变量
bool g_isDragging = false;      // 是否正在拖拽
int g_dragStartX = 0;           // 拖拽开始时鼠标X坐标
int g_dragStartY = 0;           // 拖拽开始时鼠标Y坐标
int g_panelOffsetX = 0;         // 拖拽开始时面板X位置
int g_panelOffsetY = 0;         // 拖拽开始时面板Y位置
int g_hideOffsetX = 0;          // 隐藏偏移量（0=可见，-10000=隐藏）

// 全局变量
double g_thresholds[MAX_SYMBOLS];  // 存储每个货币对的阈值
string g_editNames[MAX_SYMBOLS];        // 阈值输入框对象名称
string g_labelNames[MAX_SYMBOLS];       // 操作标签对象名称（保留兼容）
string g_btnCloseAllNames[MAX_SYMBOLS]; // 全平该品种按钮
string g_btnCloseBuyNames[MAX_SYMBOLS]; // 平仓多单按钮
string g_btnCloseSellNames[MAX_SYMBOLS];// 平仓空单按钮
string g_profitLabelNames[MAX_SYMBOLS]; // 盈亏标签对象名称
string g_lotsLabelNames[MAX_SYMBOLS];   // 手数标签对象名称
string g_countLabelNames[MAX_SYMBOLS];  // 单量标签对象名称
string g_statusLabelNames[MAX_SYMBOLS]; // 状态标签对象名称
long g_currentChartID = 0;         // 当前图表ID
datetime g_lastCheckTime = 0;      // 上次检查时间
datetime g_lastProfitUpdateTime = 0;  // 上次更新盈亏时间
int g_symbolCount = 0;             // 实际货币对数量
bool g_thresholdsUpdated = false;  // 标记阈值是否已更新（避免频繁读取输入框）
bool g_panelVisible = true;        // 面板是否可见
bool g_enableLockPosition = false; // 运行时锁仓设置（可持久化）
const string SETTINGS_PREFIX = "FloatingLossEA";  // 全局变量前缀

//+------------------------------------------------------------------+
//| 构建用于保存全局变量的键                                          |
//+------------------------------------------------------------------+
string BuildStorageKey(string suffix)
{
   long login = (long)AccountInfoInteger(ACCOUNT_LOGIN);
   return SETTINGS_PREFIX + "_" + IntegerToString((int)login) + "_" +
          IntegerToString((int)g_currentChartID) + "_" + suffix;
}

//+------------------------------------------------------------------+
//| 将阈值、锁仓设置、配色方案保存到全局变量                            |
//+------------------------------------------------------------------+
void SaveSettingsToGlobalVars()
{
   if(g_symbolCount <= 0)
      return;

   string enableKey = BuildStorageKey("EnableLock");
   GlobalVariableSet(enableKey, g_enableLockPosition ? 1.0 : 0.0);

   // 保存当前配色方案
   GlobalVariableSet(THEME_KEY, g_currentScheme);

   for(int i = 0; i < g_symbolCount; i++)
   {
      string key = BuildStorageKey("Threshold_" + IntegerToString(i));
      GlobalVariableSet(key, g_thresholds[i]);
   }
}

//+------------------------------------------------------------------+
//| 从全局变量读取上次保存的阈值、锁仓设置和配色方案                    |
//+------------------------------------------------------------------+
void LoadSettingsFromGlobalVars()
{
   if(g_symbolCount <= 0)
      return;

   string enableKey = BuildStorageKey("EnableLock");
   if(GlobalVariableCheck(enableKey))
   {
      double value = GlobalVariableGet(enableKey);
      g_enableLockPosition = (value > 0.5);
   }
   else
   {
      g_enableLockPosition = EnableLockPosition;
   }

   // 恢复配色方案
   if(GlobalVariableCheck(THEME_KEY))
      g_currentScheme = (int)GlobalVariableGet(THEME_KEY);
   else
      g_currentScheme = SCHEME_PURPLE_NIGHT;

   for(int i = 0; i < g_symbolCount; i++)
   {
      string key = BuildStorageKey("Threshold_" + IntegerToString(i));
      if(GlobalVariableCheck(key))
      {
         g_thresholds[i] = GlobalVariableGet(key);
      }
   }
}

//+------------------------------------------------------------------+
//| 判断本次启动是否需要恢复保存的设置                                |
//+------------------------------------------------------------------+
bool ShouldRestoreSavedSettings()
{
   string reasonKey = BuildStorageKey("LastDeinitReason");
   if(GlobalVariableCheck(reasonKey))
   {
      double lastReason = GlobalVariableGet(reasonKey);
      GlobalVariableDel(reasonKey);
      if((int)lastReason == REASON_PARAMETERS)
         return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| 解析货币对列表字符串                                              |
//+------------------------------------------------------------------+
int ParseSymbolList(string symbolList)
{
   // 清空数组（MQL5中字符串数组不能用ArrayInitialize，使用循环）
   for(int i = 0; i < MAX_SYMBOLS; i++)
   {
      g_symbols[i] = "";
   }
   g_symbolCount = 0;

   if(StringLen(symbolList) == 0)
   {
      Print("警告：货币对列表为空，使用默认列表");
      symbolList = "XAUUSD,EURUSD,GBPUSD,AUDUSD,USDCHF,GBPJPY,BTCUSD,NZDCAD";
   }

   // 分割字符串
   string symbols[];
   int count = StringSplit(symbolList, ',', symbols);

   // 复制到全局数组（最多MAX_SYMBOLS个）
   int maxCount = MathMin(count, MAX_SYMBOLS);
   for(int i = 0; i < maxCount; i++)
   {
      // 去除前后空格
      string symbol = symbols[i];
      StringTrimLeft(symbol);
      StringTrimRight(symbol);

      if(StringLen(symbol) > 0)
      {
         g_symbols[g_symbolCount] = symbol;
         g_symbolCount++;
      }
   }

   Print("已解析 ", g_symbolCount, " 个货币对配置项");
   return g_symbolCount;
}

//+------------------------------------------------------------------+
//| 判断点击是否在面板可拖拽区域                                      |
//| 返回true表示点击在标题栏或面板边框（可拖拽），false表示不可拖拽  |
//+------------------------------------------------------------------+
bool IsClickOnPanelArea(int x, int y)
{
   // 面板不可见时不允许拖拽
   if(!g_panelVisible)
      return false;

   // 标题栏区域是拖拽手柄（标题栏无按钮，全部可拖拽）
   int titleTop = g_panelY + 2;
   int titleBottom = g_panelY + 2 + TITLE_BAR_HEIGHT;
   if(y >= titleTop && y <= titleBottom &&
      x >= g_panelX && x <= g_panelX + PANEL_WIDTH)
   {
      return true;  // 点击在标题栏，开始拖拽
   }

   // 面板边框区域（6像素宽的内边框）也是拖拽区域
   int DRAG_ZONE = 6;
   int outerLeft   = g_panelX - DRAG_ZONE;
   int outerTop    = g_panelY - DRAG_ZONE;
   int outerRight  = g_panelX + PANEL_WIDTH + DRAG_ZONE;
   int outerBottom = g_panelY + PANEL_HEIGHT + DRAG_ZONE;
   int innerLeft   = g_panelX + DRAG_ZONE;
   int innerTop    = g_panelY + DRAG_ZONE;
   int innerRight  = g_panelX + PANEL_WIDTH - DRAG_ZONE;
   int innerBottom = g_panelY + PANEL_HEIGHT - DRAG_ZONE;

   // 超出外边界，不在面板范围
   if(x < outerLeft || x > outerRight || y < outerTop || y > outerBottom)
      return false;
   // 在内边界以内，点击的是面板内容（输入框、按钮等），不拖拽
   if(x > innerLeft && x < innerRight && y > innerTop && y < innerBottom)
      return false;
   return true;  // 点击在边框区域，开始拖拽
}

//+------------------------------------------------------------------+
//| 判断点击是否落在标题文字区域（用于点击标题循环切换配色）          |
//| 标题栏左侧约60%为标题文字点击区，右侧留给拖拽提示与边框拖拽      |
//+------------------------------------------------------------------+
bool IsClickOnTitleLabel(int x, int y)
{
   if(!g_panelVisible)
      return false;

   int titleTop    = g_panelY + 2;
   int titleBottom = g_panelY + 2 + TITLE_BAR_HEIGHT;
   // 标题文字点击区：标题栏左侧约60%宽度
   int titleRight  = g_panelX + 2 + (int)((PANEL_WIDTH - 4) * 0.60);

   if(y >= titleTop && y <= titleBottom &&
      x >= g_panelX + 2 && x <= titleRight)
   {
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 平移面板内所有对象（拖拽时调用）                                  |
//+------------------------------------------------------------------+
void OffsetPanelObjects(int dx, int dy)
{
   if(dx == 0 && dy == 0)
      return;

   int total = ObjectsTotal(0);
   for(int i = total - 1; i >= 0; i--)
   {
      string objName = ObjectName(0, i);
      if(objName != "" && StringFind(objName, PFX) == 0)
      {
         int ox = (int)ObjectGetInteger(0, objName, OBJPROP_XDISTANCE);
         int oy = (int)ObjectGetInteger(0, objName, OBJPROP_YDISTANCE);
         ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, ox + dx);
         ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, oy + dy);
      }
   }

   // 更新面板当前位置
   g_panelX += dx;
   g_panelY += dy;
}

//+------------------------------------------------------------------+
//| 移动面板到指定位置（限制不超出屏幕范围）                          |
//+------------------------------------------------------------------+
void MovePanel(int newX, int newY)
{
   int chartWidth  = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   int chartHeight = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);

   int maxX = chartWidth  - PANEL_WIDTH;
   int maxY = chartHeight - PANEL_HEIGHT;
   if(maxX < 0) maxX = 0;
   if(maxY < 0) maxY = 0;

   if(newX < 0)    newX = 0;
   if(newY < 0)    newY = 0;
   if(newX > maxX) newX = maxX;
   if(newY > maxY) newY = maxY;

   int dx = newX - g_panelX;
   int dy = newY - g_panelY;
   OffsetPanelObjects(dx, dy);
}

//+------------------------------------------------------------------+
//| 初始化10种配色方案（颜色值按设计稿逐项赋值）                      |
//+------------------------------------------------------------------+
void InitColorSchemes()
{
   // 方案1：深空蓝金（金融奢华）
   g_schemes[0].name             = "深空蓝金";
   g_schemes[0].titleColor       = C'201,169,97';
   g_schemes[0].panelBgColor     = C'15,25,35';
   g_schemes[0].rowBgDark        = C'19,32,41';
   g_schemes[0].rowBgLight       = C'21,30,41';
   g_schemes[0].rowBgDanger      = C'42,21,24';
   g_schemes[0].borderColor      = C'26,42,58';
   g_schemes[0].headerBgColor    = C'21,32,43';
   g_schemes[0].headerTxtColor   = C'122,138,154';
   g_schemes[0].profitNegColor   = C'232,90,90';
   g_schemes[0].profitPosColor   = C'90,200,138';
   g_schemes[0].profitZeroColor  = C'90,106,122';

   // 方案2：墨玉绿（沉稳东方）
   g_schemes[1].name             = "墨玉绿";
   g_schemes[1].titleColor       = C'168,192,152';
   g_schemes[1].panelBgColor     = C'26,30,28';
   g_schemes[1].rowBgDark        = C'30,36,34';
   g_schemes[1].rowBgLight       = C'30,36,34';
   g_schemes[1].rowBgDanger      = C'42,24,24';
   g_schemes[1].borderColor      = C'42,46,44';
   g_schemes[1].headerBgColor    = C'30,36,34';
   g_schemes[1].headerTxtColor   = C'122,138,122';
   g_schemes[1].profitNegColor   = C'232,120,120';
   g_schemes[1].profitPosColor   = C'136,200,120';
   g_schemes[1].profitZeroColor  = C'90,106,90';

   // 方案3：炭青科技（冷峻未来）
   g_schemes[2].name             = "炭青科技";
   g_schemes[2].titleColor       = C'88,166,255';
   g_schemes[2].panelBgColor     = C'13,17,23';
   g_schemes[2].rowBgDark        = C'19,24,34';
   g_schemes[2].rowBgLight       = C'19,24,34';
   g_schemes[2].rowBgDanger      = C'42,20,24';
   g_schemes[2].borderColor      = C'26,32,48';
   g_schemes[2].headerBgColor    = C'19,24,34';
   g_schemes[2].headerTxtColor   = C'106,117,136';
   g_schemes[2].profitNegColor   = C'248,113,113';
   g_schemes[2].profitPosColor   = C'63,185,80';
   g_schemes[2].profitZeroColor  = C'74,85,104';

   // 方案4：紫银夜（神秘高级）★ 默认
   g_schemes[3].name             = "紫银夜";
   g_schemes[3].titleColor       = C'192,132,252';
   g_schemes[3].panelBgColor     = C'21,18,31';
   g_schemes[3].rowBgDark        = C'26,22,40';
   g_schemes[3].rowBgLight       = C'26,22,40';
   g_schemes[3].rowBgDanger      = C'42,20,32';
   g_schemes[3].borderColor      = C'36,30,54';
   g_schemes[3].headerBgColor    = C'26,22,40';
   g_schemes[3].headerTxtColor   = C'122,106,138';
   g_schemes[3].profitNegColor   = C'248,120,168';
   g_schemes[3].profitPosColor   = C'120,216,168';
   g_schemes[3].profitZeroColor  = C'90,74,106';

   // 方案5：莫兰迪灰（低饱和高级）
   g_schemes[4].name             = "莫兰迪灰";
   g_schemes[4].titleColor       = C'176,168,152';
   g_schemes[4].panelBgColor     = C'28,28,31';
   g_schemes[4].rowBgDark        = C'32,32,36';
   g_schemes[4].rowBgLight       = C'32,32,36';
   g_schemes[4].rowBgDanger      = C'42,30,30';
   g_schemes[4].borderColor      = C'42,42,46';
   g_schemes[4].headerBgColor    = C'32,32,36';
   g_schemes[4].headerTxtColor   = C'122,122,126';
   g_schemes[4].profitNegColor   = C'216,120,120';
   g_schemes[4].profitPosColor   = C'136,184,144';
   g_schemes[4].profitZeroColor  = C'90,90,94';

   // 方案6：霓虹等离子（赛博朋克霓虹）
   g_schemes[5].name             = "霓虹等离子";
   g_schemes[5].titleColor       = C'255,0,200';
   g_schemes[5].panelBgColor     = C'12,8,20';
   g_schemes[5].rowBgDark        = C'18,12,28';
   g_schemes[5].rowBgLight       = C'20,14,32';
   g_schemes[5].rowBgDanger      = C'42,12,32';
   g_schemes[5].borderColor      = C'40,20,60';
   g_schemes[5].headerBgColor    = C'18,12,28';
   g_schemes[5].headerTxtColor   = C'160,140,180';
   g_schemes[5].profitNegColor   = C'255,80,180';
   g_schemes[5].profitPosColor   = C'80,255,220';
   g_schemes[5].profitZeroColor  = C'100,80,120';

   // 方案7：极光青翠（极光翠绿）
   g_schemes[6].name             = "极光青翠";
   g_schemes[6].titleColor       = C'80,255,200';
   g_schemes[6].panelBgColor     = C'8,20,22';
   g_schemes[6].rowBgDark        = C'12,28,30';
   g_schemes[6].rowBgLight       = C'14,32,34';
   g_schemes[6].rowBgDanger      = C'32,16,18';
   g_schemes[6].borderColor      = C'20,48,52';
   g_schemes[6].headerBgColor    = C'12,28,30';
   g_schemes[6].headerTxtColor   = C'120,160,150';
   g_schemes[6].profitNegColor   = C'255,120,120';
   g_schemes[6].profitPosColor   = C'100,240,180';
   g_schemes[6].profitZeroColor  = C'80,110,105';

   // 方案8：烈焰夕阳（烈焰橙红）
   g_schemes[7].name             = "烈焰夕阳";
   g_schemes[7].titleColor       = C'255,140,40';
   g_schemes[7].panelBgColor     = C'22,12,8';
   g_schemes[7].rowBgDark        = C'30,16,10';
   g_schemes[7].rowBgLight       = C'34,18,12';
   g_schemes[7].rowBgDanger      = C'42,16,12';
   g_schemes[7].borderColor      = C'58,28,16';
   g_schemes[7].headerBgColor    = C'30,16,10';
   g_schemes[7].headerTxtColor   = C'170,140,120';
   g_schemes[7].profitNegColor   = C'255,90,80';
   g_schemes[7].profitPosColor   = C'255,200,100';
   g_schemes[7].profitZeroColor  = C'120,90,75';

   // 方案9：冰晶霜银（冰蓝银白）
   g_schemes[8].name             = "冰晶霜银";
   g_schemes[8].titleColor       = C'180,220,255';
   g_schemes[8].panelBgColor     = C'12,16,22';
   g_schemes[8].rowBgDark        = C'18,24,32';
   g_schemes[8].rowBgLight       = C'20,28,36';
   g_schemes[8].rowBgDanger      = C'32,18,24';
   g_schemes[8].borderColor      = C'40,52,68';
   g_schemes[8].headerBgColor    = C'18,24,32';
   g_schemes[8].headerTxtColor   = C'150,170,190';
   g_schemes[8].profitNegColor   = C'255,130,150';
   g_schemes[8].profitPosColor   = C'140,220,255';
   g_schemes[8].profitZeroColor  = C'100,120,140';

   // 方案10：赛博鎏金（黑金奢华科技）
   g_schemes[9].name             = "赛博鎏金";
   g_schemes[9].titleColor       = C'255,210,80';
   g_schemes[9].panelBgColor     = C'10,8,6';
   g_schemes[9].rowBgDark        = C'16,14,10';
   g_schemes[9].rowBgLight       = C'20,18,14';
   g_schemes[9].rowBgDanger      = C'38,18,12';
   g_schemes[9].borderColor      = C'56,44,20';
   g_schemes[9].headerBgColor    = C'16,14,10';
   g_schemes[9].headerTxtColor   = C'150,140,110';
   g_schemes[9].profitNegColor   = C'255,100,90';
   g_schemes[9].profitPosColor   = C'255,220,120';
   g_schemes[9].profitZeroColor  = C'110,100,80';
}

//+------------------------------------------------------------------+
//| 获取当前配色的颜色（基于 g_currentScheme 动态返回）                |
//+------------------------------------------------------------------+
color GetTitleColor()     { return g_schemes[g_currentScheme].titleColor; }
color GetPanelBgColor()   { return g_schemes[g_currentScheme].panelBgColor; }
color GetRowBgDark()      { return g_schemes[g_currentScheme].rowBgDark; }
color GetRowBgLight()     { return g_schemes[g_currentScheme].rowBgLight; }
color GetRowBgDanger()    { return g_schemes[g_currentScheme].rowBgDanger; }
color GetBorderColor()    { return g_schemes[g_currentScheme].borderColor; }
color GetHeaderBgColor()  { return g_schemes[g_currentScheme].headerBgColor; }
color GetHeaderTxtColor() { return g_schemes[g_currentScheme].headerTxtColor; }
color GetProfitNegColor() { return g_schemes[g_currentScheme].profitNegColor; }
color GetProfitPosColor() { return g_schemes[g_currentScheme].profitPosColor; }
color GetProfitZeroColor(){ return g_schemes[g_currentScheme].profitZeroColor; }

//+------------------------------------------------------------------+
//| 状态颜色（基于当前配色方案动态计算）                              |
//+------------------------------------------------------------------+
color GetStatusNormalColor()  { return GetProfitPosColor(); }
color GetStatusWarningColor() { return GetTitleColor(); }   // 用标题色作为警告
color GetStatusDangerColor()  { return GetProfitNegColor(); }
color GetStatusEmptyColor()   { return GetProfitZeroColor(); }

//+------------------------------------------------------------------+
//| 切换配色方案：更新索引、重建面板UI背景、保存到GlobalVariable       |
//+------------------------------------------------------------------+
void SwitchColorScheme(int newScheme)
{
   if(newScheme < 0 || newScheme >= SCHEME_COUNT)
      return;
   if(newScheme == g_currentScheme)
      return;

   g_currentScheme = newScheme;

   // 删除旧面板并重新创建（应用新配色，面板UI背景随之切换）
   DeletePanel();
   CreatePanel();
   UpdateProfitLabels();

   // 保存到GlobalVariable（持久化主题选择，下次启动恢复）
   GlobalVariableSet(THEME_KEY, g_currentScheme);

   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // 获取当前图表ID
   g_currentChartID = ChartID();
   g_enableLockPosition = EnableLockPosition;

   // 初始化10种配色方案
   InitColorSchemes();

   // 从全局变量恢复上次保存的配色方案
   if(GlobalVariableCheck(THEME_KEY))
      g_currentScheme = (int)GlobalVariableGet(THEME_KEY);
   else
      g_currentScheme = SCHEME_PURPLE_NIGHT;  // 默认紫银夜

   // 初始化面板位置（使用输入参数）
   g_panelX = PanelX_init;
   g_panelY = PanelY_init;
   g_hideOffsetX = 0;  // 重置隐藏偏移量

   // 解析货币对列表
   ParseSymbolList(SymbolList);

   // 初始化阈值（默认-88888888，负数表示浮亏）
   for(int i = 0; i < g_symbolCount; i++)
   {
      g_thresholds[i] = -88888888.0;  // 负数表示浮亏阈值
      g_editNames[i] = PFX "ThresholdEdit_" + IntegerToString(i);
      g_labelNames[i] = PFX "ActionLabel_" + IntegerToString(i);
      g_btnCloseAllNames[i]  = PFX "BtnCloseAll_"  + IntegerToString(i);
      g_btnCloseBuyNames[i]  = PFX "BtnCloseBuy_"  + IntegerToString(i);
      g_btnCloseSellNames[i] = PFX "BtnCloseSell_" + IntegerToString(i);
      g_profitLabelNames[i] = PFX "ProfitLabel_" + IntegerToString(i);
      g_lotsLabelNames[i] = PFX "LotsLabel_" + IntegerToString(i);
      g_countLabelNames[i] = PFX "CountLabel_" + IntegerToString(i);
      g_statusLabelNames[i] = PFX "StatusLabel_" + IntegerToString(i);
   }

   // 尝试加载上次保存的阈值与锁仓设置（参数变更时跳过）
   if(ShouldRestoreSavedSettings())
      LoadSettingsFromGlobalVars();

   // 初始化阈值更新标志
   g_thresholdsUpdated = false;

   // 初始化检查时间（避免首次立即执行）
   g_lastCheckTime = TimeCurrent();
   g_lastProfitUpdateTime = 0;  // 初始化为0，让首次立即更新

   // 启用鼠标移动事件（拖拽功能需要）
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);

   // 创建面板
   CreatePanel();

   // 立即更新一次盈亏显示
   UpdateProfitLabels();

   Print("浮亏监控关闭图表EA已启动，检查间隔: ", CheckInterval, " 秒");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   SaveSettingsToGlobalVars();
   string reasonKey = BuildStorageKey("LastDeinitReason");
   GlobalVariableSet(reasonKey, reason);
   // 删除所有面板对象
   DeletePanel();
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // 按设定间隔检查
   if(TimeCurrent() - g_lastCheckTime < CheckInterval)
      return;

   g_lastCheckTime = TimeCurrent();

   // 更新盈亏显示（每秒更新一次）
   if(TimeCurrent() - g_lastProfitUpdateTime >= 1)
   {
      g_lastProfitUpdateTime = TimeCurrent();
      UpdateProfitLabels();
   }

   // 检查并关闭达到阈值的图表
   CheckAndCloseCharts();
}

//+------------------------------------------------------------------+
//| 计算各列X坐标偏移量（相对于面板左边距）                           |
//+------------------------------------------------------------------+
int ColX_Num()    { return MARGIN + 6; }
int ColX_Symbol() { return MARGIN + COL_NUM + 6; }
int ColX_Lots()   { return MARGIN + COL_NUM + COL_SYMBOL + 6; }
int ColX_Count()  { return MARGIN + COL_NUM + COL_SYMBOL + COL_LOTS + 6; }
int ColX_Profit() { return MARGIN + COL_NUM + COL_SYMBOL + COL_LOTS + COL_COUNT + 6; }
int ColX_Thresh() { return MARGIN + COL_NUM + COL_SYMBOL + COL_LOTS + COL_COUNT + COL_PROFIT + 4; }
int ColX_Status() { return MARGIN + COL_NUM + COL_SYMBOL + COL_LOTS + COL_COUNT + COL_PROFIT + COL_THRESH + 6; }
int ColX_Action() { return MARGIN + COL_NUM + COL_SYMBOL + COL_LOTS + COL_COUNT + COL_PROFIT + COL_THRESH + COL_STATUS + 6; }

//+------------------------------------------------------------------+
//| 创建配置面板（暗色现代监控条）                                    |
//+------------------------------------------------------------------+
void CreatePanel()
{
   // 创建拖拽边框（在面板背景下层，拖拽时高亮显示）
   CreateCell(PFX "Panel_Border", g_panelX - BORDER_WIDTH, g_panelY - BORDER_WIDTH,
              PANEL_WIDTH + 2 * BORDER_WIDTH, PANEL_HEIGHT + 2 * BORDER_WIDTH,
              GetBorderColor(), CORNER_LEFT_UPPER, true);

   // 创建面板背景
   CreateCell(PFX "Panel_BG", g_panelX, g_panelY, PANEL_WIDTH, PANEL_HEIGHT,
              GetPanelBgColor(), CORNER_LEFT_UPPER, false);

   // === 标题栏 ===
   int titleY = g_panelY + 2;
   CreateCell(PFX "Title_Bar", g_panelX + 2, titleY, PANEL_WIDTH - 4, TITLE_BAR_HEIGHT,
              GetHeaderBgColor(), CORNER_LEFT_UPPER, false);
   // 标题显示当前主题名（点击标题文字可循环切换10种配色）
   string titleText = "◆ 浮亏监控关闭图表  [" + g_schemes[g_currentScheme].name + "]";
   CreateLabel(PFX "Title_Label", titleText,
               g_panelX + 8, titleY + 5, GetTitleColor(), FONT_HEADER_SIZE);

   // === 表头 ===
   int headerY = g_panelY + TITLE_BAR_HEIGHT + 4;
   int headerWidth = PANEL_WIDTH - MARGIN * 2;
   CreateCell(PFX "Header_BG", g_panelX + MARGIN, headerY, headerWidth, HEADER_HEIGHT,
              GetHeaderBgColor(), CORNER_LEFT_UPPER, false);
   CreateHeaderLabel(PFX "Header_Num",    "#",        g_panelX + ColX_Num(),    headerY + 5);
   CreateHeaderLabel(PFX "Header_Symbol", "品种",     g_panelX + ColX_Symbol(), headerY + 5);
   CreateHeaderLabel(PFX "Header_Lots",   "手数",     g_panelX + ColX_Lots(),   headerY + 5);
   CreateHeaderLabel(PFX "Header_Count",  "单量",     g_panelX + ColX_Count(),  headerY + 5);
   CreateHeaderLabel(PFX "Header_Profit", "浮亏",     g_panelX + ColX_Profit(), headerY + 5);
   CreateHeaderLabel(PFX "Header_Thresh", "阈值",     g_panelX + ColX_Thresh(), headerY + 5);
   CreateHeaderLabel(PFX "Header_Status", "状态",     g_panelX + ColX_Status(), headerY + 5);
   CreateHeaderLabel(PFX "Header_Action", "平仓操作", g_panelX + ColX_Action(), headerY + 5);

   // 表头分隔线
   CreateCell(PFX "Header_Line", g_panelX + MARGIN, headerY + HEADER_HEIGHT, headerWidth, 1,
              GetBorderColor(), CORNER_LEFT_UPPER, false);

   // === 数据行 ===
   int startY = headerY + HEADER_HEIGHT + 2;

   for(int i = 0; i < g_symbolCount; i++)
   {
      int rowY = startY + i * ROW_HEIGHT;

      // 交替行背景色（深/浅）
      color rowColor = (i % 2 == 0) ? GetRowBgDark() : GetRowBgLight();
      CreateCell(PFX "Row_BG_" + IntegerToString(i), g_panelX + MARGIN, rowY, headerWidth, ROW_HEIGHT,
                 rowColor, CORNER_LEFT_UPPER, false);

      // 序号
      CreateLabel(PFX "NumLabel_" + IntegerToString(i), IntegerToString(i + 1),
                  g_panelX + ColX_Num(), rowY + 5, GetProfitZeroColor(), FONT_LABEL_SIZE);

      // 品种名（用表头文字色显示）
      CreateLabel(PFX "SymbolLabel_" + IntegerToString(i), g_symbols[i],
                  g_panelX + ColX_Symbol(), rowY + 5, GetHeaderTxtColor(), FONT_LABEL_SIZE);

      // 手数
      CreateLabel(g_lotsLabelNames[i], "0.00",
                  g_panelX + ColX_Lots(), rowY + 5, GetHeaderTxtColor(), FONT_VALUE_SIZE);

      // 单量
      CreateLabel(g_countLabelNames[i], "0",
                  g_panelX + ColX_Count(), rowY + 5, GetHeaderTxtColor(), FONT_VALUE_SIZE);

      // 浮亏（颜色由UpdateProfitLabels动态设置）
      CreateLabel(g_profitLabelNames[i], "0.00",
                  g_panelX + ColX_Profit(), rowY + 5, GetProfitZeroColor(), FONT_VALUE_SIZE);

      // 阈值输入框
      CreateEdit(g_editNames[i], DoubleToString(g_thresholds[i], 0),
                 g_panelX + ColX_Thresh(), rowY + 3, COL_THRESH - 8, EDIT_HEIGHT);

      // 状态（颜色由UpdateProfitLabels动态设置）
      CreateLabel(g_statusLabelNames[i], "● 无仓位",
                  g_panelX + ColX_Status(), rowY + 5, GetProfitZeroColor(), FONT_LABEL_SIZE);

      // 平仓操作：三个按钮（全平该品种、平仓多单、平仓空单）
      int btnW = 62;
      int btnH = 20;
      int btnGap = 4;
      int btnY = rowY + 3;
      int btnBaseX = g_panelX + ColX_Action();
      CreateActionButton(g_btnCloseAllNames[i],  "全平", btnBaseX,                    btnY, btnW, btnH);
      CreateActionButton(g_btnCloseBuyNames[i],  "平多", btnBaseX + btnW + btnGap,    btnY, btnW, btnH);
      CreateActionButton(g_btnCloseSellNames[i], "平空", btnBaseX + 2*(btnW + btnGap), btnY, btnW, btnH);
   }

   // === 底部栏 ===
   int footerY = startY + g_symbolCount * ROW_HEIGHT + 4;
   CreateCell(PFX "Footer_Bar", g_panelX + MARGIN, footerY, headerWidth, FOOTER_HEIGHT,
              GetHeaderBgColor(), CORNER_LEFT_UPPER, false);

   // 锁仓开关按钮（左侧）
   string lockBtnName = PFX "LockToggleButton";
   int lockBtnX = g_panelX + MARGIN + 8;
   SwitchButton(lockBtnName, lockBtnX, footerY + 3, 100, 18,
                "锁仓：关", "锁仓：开", 9, false, FONT_NAME,
                GetTitleColor(), GetHeaderBgColor(), CORNER_LEFT_UPPER);
   if(g_enableLockPosition)
      ObjectSetString(0, lockBtnName, OBJPROP_TEXT, "锁仓：开");

   // 隐藏/显示按钮（右侧）
   string hideBtnName = PFX "PanelHideButton";
   SwitchButton(hideBtnName, g_panelX + PANEL_WIDTH - MARGIN - 78, footerY + 3, 70, 18,
                "隐藏面板", "显示面板", 9, false, FONT_NAME,
                GetTitleColor(), GetHeaderBgColor(), CORNER_LEFT_UPPER);

   if(g_panelVisible)
      ObjectSetString(0, hideBtnName, OBJPROP_TEXT, "隐藏面板");
   else
      ObjectSetString(0, hideBtnName, OBJPROP_TEXT, "显示面板");

   // 更新面板可见性
   UpdatePanelVisibility();

   ChartRedraw();
}

//+------------------------------------------------------------------+
//| 辅助函数: 创建背景单元格                                         |
//+------------------------------------------------------------------+
void CreateCell(string name, int x, int y, int width, int height, color bgColor, ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, bool inBackground=true)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, name, OBJPROP_BACK, inBackground);  // 控制是否在背景
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);   // 不可选中，避免干扰拖拽
   }
}

//+------------------------------------------------------------------+
//| 创建表头标签                                                      |
//+------------------------------------------------------------------+
void CreateHeaderLabel(string name, string text, int x, int y)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_COLOR, GetHeaderTxtColor());  // 使用当前主题表头文字色
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FONT_HEADER_SIZE);
      ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME);  // 使用统一字体
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}

//+------------------------------------------------------------------+
//| 创建标签                                                          |
//+------------------------------------------------------------------+
void CreateLabel(string name, string text, int x, int y, color clr, int fontSize)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
      ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME);  // 使用统一字体
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}

//+------------------------------------------------------------------+
//| 创建输入框                                                        |
//+------------------------------------------------------------------+
void CreateEdit(string name, string text, int x, int y, int width, int height)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, GetPanelBgColor());  // 输入框背景（深色）
      ObjectSetInteger(0, name, OBJPROP_COLOR, GetTitleColor());      // 输入框文字
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, GetTitleColor());  // 边框跟随文字色
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FONT_EDIT_SIZE);
      ObjectSetInteger(0, name, OBJPROP_ALIGN, ALIGN_CENTER);  // 文字居中
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
   }
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}

//+------------------------------------------------------------------+
//| 创建操作按钮（小尺寸，用于行内平仓操作）                          |
//+------------------------------------------------------------------+
void CreateActionButton(string name, string text, int x, int y, int w, int h)
{
   if(ObjectFind(0, name) >= 0)
   {
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
   ObjectSetString(0, name, OBJPROP_FONT, FONT_NAME);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, name, OBJPROP_COLOR, GetTitleColor());
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, GetRowBgDark());
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, GetBorderColor());
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
}

//+------------------------------------------------------------------+
//| 创建开关按钮                                                      |
//+------------------------------------------------------------------+
void SwitchButton(string name, int x, int y, int width, int height, string text, string switchText,
                  int fontSize=10, bool reverse=false, string font="Arial", color clr=clrBlack,
                  color backClr=clrDeepSkyBlue, int corner=0)
{
   if(ObjectFind(0, name) < 0)
   {
      if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
      {
         Print("错误：创建按钮 ", name, " 失败，错误代码: ", GetLastError());
         return;
      }
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, backClr);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrGray);
      ObjectSetString(0, name, OBJPROP_FONT, font);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, C'180,180,190');
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}

//+------------------------------------------------------------------+
//| 更新面板可见性（隐藏时平移到屏幕外，显示时恢复原位）              |
//+------------------------------------------------------------------+
void UpdatePanelVisibility()
{
   int targetOffset = g_panelVisible ? 0 : -10000;
   int dx = targetOffset - g_hideOffsetX;

   if(dx != 0)
   {
      int total = ObjectsTotal(0);
      for(int i = total - 1; i >= 0; i--)
      {
         string objName = ObjectName(0, i);
         if(objName != "" && StringFind(objName, PFX) == 0)
         {
            // 隐藏/显示按钮不隐藏，保持可见以便重新显示面板
            if(objName == PFX "PanelHideButton")
               continue;
            int ox = (int)ObjectGetInteger(0, objName, OBJPROP_XDISTANCE);
            ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, ox + dx);
         }
      }
      g_hideOffsetX = targetOffset;
   }

   ChartRedraw();
}

//+------------------------------------------------------------------+
//| 删除面板所有对象                                                  |
//+------------------------------------------------------------------+
void DeletePanel()
{
   // 删除所有带面板前缀的对象
   ObjectsDeleteAll(0, PFX);
}

//+------------------------------------------------------------------+
//| 检查并关闭达到阈值的图表                                          |
//+------------------------------------------------------------------+
void CheckAndCloseCharts()
{
   // 只在阈值未更新时读取输入框（优化性能）
   // 阈值更新由OnChartEvent处理，这里只做兜底检查
   if(!g_thresholdsUpdated)
   {
      // 读取所有输入框的值，如果输入正数则转换为负数
      for(int i = 0; i < g_symbolCount; i++)
      {
         string text = ObjectGetString(0, g_editNames[i], OBJPROP_TEXT);
         if(StringLen(text) == 0)
            continue;  // 跳过空值

         double value = StringToDouble(text);

         // 验证是否为有效数字
         if(value == 0 && StringCompare(text, "0", false) != 0 &&
            StringCompare(text, "-0", false) != 0 && StringCompare(text, "0.0", false) != 0)
         {
            Print("警告：输入框 ", g_editNames[i], " 的值无效: ", text);
            continue;
         }

         // 如果用户输入正数，自动转换为负数（浮亏是负数）
         if(value > 0)
            g_thresholds[i] = -value;
         else
            g_thresholds[i] = value;

         // 更新输入框显示为负数
         if(value > 0)
            ObjectSetString(0, g_editNames[i], OBJPROP_TEXT, DoubleToString(-value, 0));
      }
      g_thresholdsUpdated = true;
      SaveSettingsToGlobalVars();
   }

   // 用于记录关闭图表的信息
   struct CloseInfo
   {
      string symbol;      // 货币对
      double floatingLoss; // 浮亏
      double threshold;    // 阈值
      int    closeCount;   // 关闭的图表数量
      bool   isLocked;    // 是否执行了锁仓
      string lockDirection; // 锁仓方向（多单/空单）
      double lockVolume;    // 锁仓手数
   };

   CloseInfo closeInfos[];
   int infoCount = 0;

   // 遍历所有图表
   long chartID = ChartFirst();
   if(chartID < 0)
      return;

   long firstChartID = chartID;

   do
   {
      // 跳过当前图表
      if(chartID == g_currentChartID)
      {
         chartID = ChartNext(chartID);
         if(chartID < 0 || chartID == firstChartID)
            break;
         continue;
      }

      // 获取图表的货币对
      string chartSymbol = ChartSymbol(chartID);
      if(StringLen(chartSymbol) == 0)
      {
         chartID = ChartNext(chartID);
         if(chartID < 0 || chartID == firstChartID)
            break;
         continue;
      }

      // 计算该货币对的总浮亏（只计算浮亏，不包含盈利）
      double floatingLoss = GetSymbolFloatingLoss(chartSymbol);

      // 只处理浮亏情况（负数）
      if(floatingLoss >= 0)
      {
         chartID = ChartNext(chartID);
         if(chartID < 0 || chartID == firstChartID)
            break;
         continue;
      }

      // 检查是否达到阈值
      bool shouldClose = false;
      double matchedThreshold = 0;

      for(int i = 0; i < g_symbolCount; i++)
      {
         // 检查是否匹配货币对（支持后缀匹配，如EURUSD匹配EURUSD.a）
         // 注意：g_symbols[i]是配置的货币对，chartSymbol是图表货币对（可能带后缀）
         bool symbolMatch = SymbolMatch(g_symbols[i], chartSymbol);

         if(symbolMatch)
         {
            // 检查浮亏是否超过阈值（浮亏和阈值都是负数，更小的负数表示更大的亏损）
            // 例如：浮亏-100000 <= 阈值-88888，表示亏损超过阈值
            if(g_thresholds[i] < 0 && floatingLoss <= g_thresholds[i])
            {
               shouldClose = true;
               matchedThreshold = g_thresholds[i];
               Print("货币对 ", chartSymbol, " 浮亏 ", DoubleToString(floatingLoss, 2),
                     " 超过阈值 ", DoubleToString(g_thresholds[i], 2), "，准备关闭图表");
               break;
            }
         }
      }

      // 如果需要关闭，先获取下一个图表ID
      long nextChartID = ChartNext(chartID);

      if(shouldClose)
      {
         // 锁仓信息
         bool isLocked = false;
         string lockDirection = "";
         double lockVolume = 0.0;

         // 如果开启锁仓功能，先执行锁仓
         if(g_enableLockPosition)
         {
            Print("开始锁仓货币对: ", chartSymbol);
            bool locked = LockPosition(chartSymbol, lockDirection, lockVolume);
            if(locked)
            {
               isLocked = true;
               Print("货币对 ", chartSymbol, " 锁仓成功，", lockDirection, "方向，开仓手数: ", DoubleToString(lockVolume, 2));
            }
            else
            {
               Print("货币对 ", chartSymbol, " 锁仓失败或无需锁仓，但继续执行关闭图表操作");
            }
         }

         // 关闭图表前验证图表ID是否有效
         if(ChartSymbol(chartID) != "")
         {
            bool closed = ChartClose(chartID);
            if(closed)
            {
               Print("已关闭图表: ", chartSymbol, " (ID: ", chartID, ")");

               // 查找或创建该货币对的关闭信息记录
               int foundIndex = -1;
               for(int j = 0; j < infoCount; j++)
               {
                  if(closeInfos[j].symbol == chartSymbol)
                  {
                     foundIndex = j;
                     break;
                  }
               }

               if(foundIndex >= 0)
               {
                  // 更新现有记录
                  closeInfos[foundIndex].closeCount++;
                  // 如果本次有锁仓操作，更新锁仓信息（只记录第一次锁仓信息）
                  if(isLocked && !closeInfos[foundIndex].isLocked)
                  {
                     closeInfos[foundIndex].isLocked = true;
                     closeInfos[foundIndex].lockDirection = lockDirection;
                     closeInfos[foundIndex].lockVolume = lockVolume;
                  }
               }
               else
               {
                  // 创建新记录
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
            }
            else
            {
               Print("错误：无法关闭图表: ", chartSymbol, " (ID: ", chartID, "), 错误代码: ", GetLastError());
            }
         }
      }

      // 移动到下一个图表
      chartID = nextChartID;

      // 检查是否遍历完成
      if(chartID < 0 || chartID == firstChartID)
         break;

   } while(true);

   // 如果有图表被关闭，显示弹窗报警
   if(infoCount > 0)
   {
      // 构建报警消息
      string alertMessage = "";
      for(int i = 0; i < infoCount; i++)
      {
         if(StringLen(alertMessage) > 0)
            alertMessage += "\n";

         // 格式：货币：BTCUSD 锁仓完成，空单方向，开仓手数: 10.00并关闭图表1个。
         if(closeInfos[i].isLocked)
         {
            alertMessage += "货币：" + closeInfos[i].symbol +
                           " 锁仓完成，" + closeInfos[i].lockDirection + "方向，开仓手数: " +
                           DoubleToString(closeInfos[i].lockVolume, 2) + "并关闭图表" +
                           IntegerToString(closeInfos[i].closeCount) + "个。";
         }
         else
         {
            // 没有锁仓的情况，保持原格式
            alertMessage += "货币：" + closeInfos[i].symbol +
                           " 浮亏 " + DoubleToString(closeInfos[i].floatingLoss, 2) +
                           " 超过阈值 " + DoubleToString(closeInfos[i].threshold, 2) +
                           "，已成功关闭图表" + IntegerToString(closeInfos[i].closeCount) + "个。";
         }
      }

      // 显示弹窗报警
      Alert(alertMessage);
      Print("弹窗报警: ", alertMessage);
   }
}

//+------------------------------------------------------------------+
//| 货币对匹配（支持后缀匹配）                                        |
//| 参数: symbol1 - 第一个货币对（通常是配置中的货币对）            |
//|      symbol2 - 第二个货币对（通常是持仓或图表中的货币对，可能带后缀）|
//| 返回: true表示匹配，支持symbol2是symbol1的后缀形式（如EURUSD匹配EURUSD.a）|
//+------------------------------------------------------------------+
bool SymbolMatch(string symbol1, string symbol2)
{
   // 如果完全相等，直接返回true
   if(StringCompare(symbol1, symbol2, false) == 0)
      return true;

   // 如果设置了后缀，尝试添加/去除后缀进行匹配
   if(StringLen(SymbolSuffix) > 0)
   {
      string symbol1WithSuffix = symbol1 + SymbolSuffix;
      string symbol2WithSuffix = symbol2 + SymbolSuffix;

      if(StringCompare(symbol1WithSuffix, symbol2, false) == 0 ||
         StringCompare(symbol2WithSuffix, symbol1, false) == 0)
         return true;

      int suffixLen = StringLen(SymbolSuffix);

      if(StringLen(symbol1) > suffixLen)
      {
         string symbol1Base = StringSubstr(symbol1, 0, StringLen(symbol1) - suffixLen);
         if(StringCompare(symbol1Base, symbol2, false) == 0)
            return true;
      }

      if(StringLen(symbol2) > suffixLen)
      {
         string symbol2Base = StringSubstr(symbol2, 0, StringLen(symbol2) - suffixLen);
         if(StringCompare(symbol2Base, symbol1, false) == 0)
            return true;
      }
   }

   if(StringLen(SymbolSuffix) == 0)
   {
      // 检查symbol2是否是symbol1的后缀形式（如EURUSD匹配EURUSD.a）
      int len1 = StringLen(symbol1);
      int len2 = StringLen(symbol2);

      // symbol2必须比symbol1长或相等
      if(len2 < len1)
         return false;

      // 检查symbol2的前len1个字符是否与symbol1匹配
      string prefix = StringSubstr(symbol2, 0, len1);
      if(StringCompare(symbol1, prefix, false) == 0)
      {
         if(len2 > len1)
         {
            string suffix = StringSubstr(symbol2, len1, 1);
            if(suffix == "." || suffix == "-" || suffix == "_")
               return true;
         }
         return true;
      }
   }

   return false;
}

//+------------------------------------------------------------------+
//| 锁仓指定货币对的所有持仓                                          |
//| 参数: symbol - 货币对名称                                        |
//|      outDirection - 输出参数：锁仓方向（"多单"或"空单"）        |
//|      outVolume - 输出参数：锁仓手数                             |
//| 返回: true表示锁仓成功，false表示失败或无需锁仓                 |
//+------------------------------------------------------------------+
bool LockPosition(string symbol, string &outDirection, double &outVolume)
{
   double buyVolume = 0.0;  // 买入总手数
   double sellVolume = 0.0; // 卖出总手数

   // 遍历所有持仓，计算买入和卖出的总手数
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
      {
         if(PositionSelectByTicket(ticket))
         {
            // 只处理指定货币对的持仓（支持后缀匹配）
            string posSymbol = PositionGetString(POSITION_SYMBOL);
            if(SymbolMatch(symbol, posSymbol))
            {
               ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
               double volume = PositionGetDouble(POSITION_VOLUME);

               if(posType == POSITION_TYPE_BUY)
                  buyVolume += volume;
               else if(posType == POSITION_TYPE_SELL)
                  sellVolume += volume;
            }
         }
      }
   }

   // 计算需要锁仓的手数
   double lockVolume = MathAbs(buyVolume - sellVolume);
   if(lockVolume < 0.01)  // 如果已经锁仓（买入和卖出手数相等），不需要操作
   {
      Print("货币对 ", symbol, " 已经锁仓，无需操作");
      outDirection = "";
      outVolume = 0;
      return false;  // 返回false表示无需锁仓
   }

   // 确定锁仓方向
   ENUM_ORDER_TYPE orderType;
   if(buyVolume > sellVolume)
   {
      // 买入多于卖出，需要开卖出单锁仓（空单方向）
      orderType = ORDER_TYPE_SELL;
      outDirection = "空单";
      Print("货币对 ", symbol, " 买入 ", DoubleToString(buyVolume, 2), " 手，卖出 ", DoubleToString(sellVolume, 2),
            " 手，需要开卖出 ", DoubleToString(lockVolume, 2), " 手锁仓");
   }
   else
   {
      // 卖出多于买入，需要开买入单锁仓（多单方向）
      orderType = ORDER_TYPE_BUY;
      outDirection = "多单";
      Print("货币对 ", symbol, " 买入 ", DoubleToString(buyVolume, 2), " 手，卖出 ", DoubleToString(sellVolume, 2),
            " 手，需要开买入 ", DoubleToString(lockVolume, 2), " 手锁仓");
   }

   outVolume = lockVolume;

   // 获取货币对信息
   double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbol, SYMBOL_BID);

   if(ask == 0 || bid == 0)
   {
      Print("错误：无法获取货币对 ", symbol, " 的价格");
      outDirection = "";
      outVolume = 0;
      return false;
   }

   // 准备交易请求
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

   // 自动检测订单填充类型
   int filling = (int)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);
   if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
      request.type_filling = ORDER_FILLING_FOK;
   else if((filling & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
      request.type_filling = ORDER_FILLING_IOC;
   else
      request.type_filling = ORDER_FILLING_RETURN;

   // 发送交易请求
   if(!OrderSend(request, result))
   {
      Print("错误：锁仓失败，货币对 ", symbol, "，错误代码: ", result.retcode, "，错误描述: ", result.comment);
      outDirection = "";
      outVolume = 0;
      return false;
   }

   if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
   {
      Print("成功：货币对 ", symbol, " 锁仓完成，", outDirection, "方向，开仓手数: ", DoubleToString(lockVolume, 2));
      return true;
   }
   else
   {
      Print("警告：锁仓请求已提交，但状态: ", result.retcode, "，描述: ", result.comment);
      outDirection = "";
      outVolume = 0;
      return false;
   }
}

//+------------------------------------------------------------------+
//| 获取指定货币对的总浮亏（MQL5版本）                                |
//+------------------------------------------------------------------+
double GetSymbolFloatingLoss(string symbol)
{
   double totalLoss = 0.0;

   // 遍历所有持仓（MQL5使用PositionsTotal和PositionGetTicket）
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
      {
         if(PositionSelectByTicket(ticket))
         {
            // 只计算指定货币对的持仓（支持后缀匹配）
            string posSymbol = PositionGetString(POSITION_SYMBOL);
            if(SymbolMatch(symbol, posSymbol))
            {
               // MQL5中浮亏 = 盈亏 + 库存费（POSITION_COMMISSION已弃用）
               totalLoss += PositionGetDouble(POSITION_PROFIT) +
                           PositionGetDouble(POSITION_SWAP);
            }
         }
      }
   }

   return totalLoss;
}

//+------------------------------------------------------------------+
//| 获取指定货币对的总盈亏（包括盈利和亏损）                          |
//+------------------------------------------------------------------+
double GetSymbolTotalProfit(string symbol)
{
   double totalProfit = 0.0;

   // 遍历所有持仓（MQL5使用PositionsTotal和PositionGetTicket）
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
      {
         if(PositionSelectByTicket(ticket))
         {
            // 只计算指定货币对的持仓（支持后缀匹配）
            string posSymbol = PositionGetString(POSITION_SYMBOL);
            if(SymbolMatch(posSymbol, symbol))
            {
               // MQL5中总盈亏 = 盈亏 + 库存费（POSITION_COMMISSION已弃用）
               totalProfit += PositionGetDouble(POSITION_PROFIT) +
                            PositionGetDouble(POSITION_SWAP);
            }
         }
      }
   }

   return totalProfit;
}

//+------------------------------------------------------------------+
//| 获取货币对的浮亏排名（返回排名，0表示浮亏最大）                    |
//+------------------------------------------------------------------+
int GetSymbolLossRank(int symbolIndex)
{
   if(symbolIndex < 0 || symbolIndex >= g_symbolCount)
      return -1;

   // 获取所有货币对的浮亏
   double losses[MAX_SYMBOLS];
   for(int i = 0; i < g_symbolCount; i++)
   {
      losses[i] = GetSymbolTotalProfit(g_symbols[i]);  // 注意：这里返回的是盈亏，负数表示浮亏
   }

   // 计算当前货币对的浮亏排名（浮亏越大排名越靠前，即数值越小排名越靠前）
   double currentLoss = losses[symbolIndex];
   int rank = 0;

   for(int i = 0; i < g_symbolCount; i++)
   {
      if(i != symbolIndex && losses[i] < currentLoss)  // 如果其他货币对浮亏更大（数值更小）
         rank++;
   }

   return rank;
}

//+------------------------------------------------------------------+
//| 获取指定货币对的总手数和总单量（MQL5版本）                        |
//+------------------------------------------------------------------+
void GetSymbolLotsAndCount(string symbol, double &outLots, int &outCount)
{
   outLots = 0.0;
   outCount = 0;
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket))
      {
         string posSymbol = PositionGetString(POSITION_SYMBOL);
         if(SymbolMatch(symbol, posSymbol))
         {
            outLots += PositionGetDouble(POSITION_VOLUME);
            outCount++;
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 平仓指定货币对的持仓（按方向过滤，MQL5版本）                      |
//| direction: -1=全部, 0=多单(POSITION_TYPE_BUY), 1=空单(POSITION_TYPE_SELL)|
//| 返回成功平仓的订单数                                              |
//+------------------------------------------------------------------+
int CloseSymbolPositions(string symbol, int direction)
{
   int closedCount = 0;
   MqlTradeRequest request;
   MqlTradeResult result;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;

      string posSymbol = PositionGetString(POSITION_SYMBOL);
      if(!SymbolMatch(symbol, posSymbol)) continue;

      ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

      // 按方向过滤
      if(direction == 0 && posType != POSITION_TYPE_BUY) continue;
      if(direction == 1 && posType != POSITION_TYPE_SELL) continue;

      double volume = PositionGetDouble(POSITION_VOLUME);

      // 准备平仓请求（反向下单）
      ZeroMemory(request);
      ZeroMemory(result);
      request.action = TRADE_ACTION_DEAL;
      request.position = ticket;
      request.symbol = posSymbol;
      request.volume = volume;

      if(posType == POSITION_TYPE_BUY)
      {
         request.type = ORDER_TYPE_SELL;
         request.price = SymbolInfoDouble(posSymbol, SYMBOL_BID);
      }
      else
      {
         request.type = ORDER_TYPE_BUY;
         request.price = SymbolInfoDouble(posSymbol, SYMBOL_ASK);
      }

      request.deviation = 10;
      request.magic = 0;
      request.comment = "平仓操作";

      // 填充类型
      int filling = (int)SymbolInfoInteger(posSymbol, SYMBOL_FILLING_MODE);
      if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
         request.type_filling = ORDER_FILLING_FOK;
      else if((filling & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
         request.type_filling = ORDER_FILLING_IOC;
      else
         request.type_filling = ORDER_FILLING_RETURN;

      if(OrderSend(request, result))
      {
         if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
            closedCount++;
         else
            Print("平仓失败：", posSymbol, " 订单#", ticket, " retcode:", result.retcode);
      }
      else
      {
         Print("平仓失败：", posSymbol, " 订单#", ticket, " 错误码:", GetLastError());
      }
   }

   return closedCount;
}

//+------------------------------------------------------------------+
//| 全平该品种（带确认提示）                                          |
//+------------------------------------------------------------------+
void ActionCloseAllSymbol(int symbolIndex)
{
   if(symbolIndex < 0 || symbolIndex >= g_symbolCount)
      return;
   string symbol = g_symbols[symbolIndex];

   double lots = 0.0;
   int count = 0;
   GetSymbolLotsAndCount(symbol, lots, count);
   if(count == 0)
   {
      Print(symbol, " 当前无持仓，无需平仓");
      return;
   }

   string msg = "确认全平 " + symbol + " ?\n共 " + IntegerToString(count) + " 单，" +
                DoubleToString(lots, 2) + " 手\n该操作不可撤销！";
   if(MessageBox(msg, "全平确认", MB_YESNO | MB_ICONQUESTION) != IDYES)
      return;

   int closed = CloseSymbolPositions(symbol, -1);
   Print("全平 ", symbol, " 完成：成功平仓 ", closed, " / ", count, " 单");
   UpdateProfitLabels();
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| 平多单（只平该品种买单，带确认）                                  |
//+------------------------------------------------------------------+
void ActionCloseBuy(int symbolIndex)
{
   if(symbolIndex < 0 || symbolIndex >= g_symbolCount)
      return;
   string symbol = g_symbols[symbolIndex];

   double buyLots = 0.0;
   int buyCount = 0;
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket))
      {
         string posSymbol = PositionGetString(POSITION_SYMBOL);
         if(SymbolMatch(symbol, posSymbol))
         {
            ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            if(posType == POSITION_TYPE_BUY)
            {
               buyLots += PositionGetDouble(POSITION_VOLUME);
               buyCount++;
            }
         }
      }
   }
   if(buyCount == 0)
   {
      Print(symbol, " 当前无多单，无需平仓");
      return;
   }

   string msg = "确认平掉 " + symbol + " 所有多单?\n共 " + IntegerToString(buyCount) + " 单，" +
                DoubleToString(buyLots, 2) + " 手\n该操作不可撤销！";
   if(MessageBox(msg, "平多单确认", MB_YESNO | MB_ICONQUESTION) != IDYES)
      return;

   int closed = CloseSymbolPositions(symbol, 0);
   Print("平多单 ", symbol, " 完成：成功平仓 ", closed, " / ", buyCount, " 单");
   UpdateProfitLabels();
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| 平空单（只平该品种卖单，带确认）                                  |
//+------------------------------------------------------------------+
void ActionCloseSell(int symbolIndex)
{
   if(symbolIndex < 0 || symbolIndex >= g_symbolCount)
      return;
   string symbol = g_symbols[symbolIndex];

   double sellLots = 0.0;
   int sellCount = 0;
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0 && PositionSelectByTicket(ticket))
      {
         string posSymbol = PositionGetString(POSITION_SYMBOL);
         if(SymbolMatch(symbol, posSymbol))
         {
            ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            if(posType == POSITION_TYPE_SELL)
            {
               sellLots += PositionGetDouble(POSITION_VOLUME);
               sellCount++;
            }
         }
      }
   }
   if(sellCount == 0)
   {
      Print(symbol, " 当前无空单，无需平仓");
      return;
   }

   string msg = "确认平掉 " + symbol + " 所有空单?\n共 " + IntegerToString(sellCount) + " 单，" +
                DoubleToString(sellLots, 2) + " 手\n该操作不可撤销！";
   if(MessageBox(msg, "平空单确认", MB_YESNO | MB_ICONQUESTION) != IDYES)
      return;

   int closed = CloseSymbolPositions(symbol, 1);
   Print("平空单 ", symbol, " 完成：成功平仓 ", closed, " / ", sellCount, " 单");
   UpdateProfitLabels();
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| 根据浮亏和阈值获取状态信息                                        |
//+------------------------------------------------------------------+
void GetSymbolStatusInfo(double profit, double threshold, int lossRank,
                         string &outStatusText, color &outStatusColor)
{
   // 无仓位
   if(profit == 0)
   {
      outStatusText = "● 无仓位";
      outStatusColor = GetStatusEmptyColor();
      return;
   }
   // 盈利
   if(profit > 0)
   {
      outStatusText = "● 盈利中";
      outStatusColor = GetStatusNormalColor();
      return;
   }
   // 浮亏：检查是否超阈值
   if(threshold < 0 && profit <= threshold)
   {
      outStatusText = "⚠ 超阈值";
      outStatusColor = GetStatusDangerColor();
      return;
   }
   // 浮亏排名前3：危险
   if(lossRank < 3)
   {
      outStatusText = "● 浮亏大";
      outStatusColor = GetStatusDangerColor();
      return;
   }
   // 浮亏排名4-5：警告
   if(lossRank < 5)
   {
      outStatusText = "● 浮亏中";
      outStatusColor = GetStatusWarningColor();
      return;
   }
   // 正常
   outStatusText = "● 正常";
   outStatusColor = GetStatusNormalColor();
}

//+------------------------------------------------------------------+
//| 更新盈亏、手数、单量、状态标签                                    |
//+------------------------------------------------------------------+
void UpdateProfitLabels()
{
   if(!g_panelVisible)
      return;

   for(int i = 0; i < g_symbolCount; i++)
   {
      // 计算该货币对的总盈亏、手数、单量
      double totalProfit = GetSymbolTotalProfit(g_symbols[i]);
      double totalLots = 0.0;
      int totalCount = 0;
      GetSymbolLotsAndCount(g_symbols[i], totalLots, totalCount);

      // 更新浮亏标签
      string profitText = DoubleToString(totalProfit, 2);
      color profitColor = GetProfitZeroColor();
      if(totalProfit < 0)
         profitColor = GetProfitNegColor();
      else if(totalProfit > 0)
         profitColor = GetProfitPosColor();

      if(ObjectFind(0, g_profitLabelNames[i]) >= 0)
      {
         ObjectSetString(0, g_profitLabelNames[i], OBJPROP_TEXT, profitText);
         ObjectSetInteger(0, g_profitLabelNames[i], OBJPROP_COLOR, profitColor);
      }

      // 更新手数标签
      if(ObjectFind(0, g_lotsLabelNames[i]) >= 0)
      {
         ObjectSetString(0, g_lotsLabelNames[i], OBJPROP_TEXT, DoubleToString(totalLots, 2));
      }

      // 更新单量标签
      if(ObjectFind(0, g_countLabelNames[i]) >= 0)
      {
         ObjectSetString(0, g_countLabelNames[i], OBJPROP_TEXT, IntegerToString(totalCount));
      }

      // 更新状态标签
      int lossRank = GetSymbolLossRank(i);
      string statusText = "";
      color statusColor = GetProfitZeroColor();
      GetSymbolStatusInfo(totalProfit, g_thresholds[i], lossRank, statusText, statusColor);
      if(ObjectFind(0, g_statusLabelNames[i]) >= 0)
      {
         ObjectSetString(0, g_statusLabelNames[i], OBJPROP_TEXT, statusText);
         ObjectSetInteger(0, g_statusLabelNames[i], OBJPROP_COLOR, statusColor);
      }

      // 更新行背景颜色（交替深浅，超阈值时用危险行背景高亮）
      string rowBgName = PFX "Row_BG_" + IntegerToString(i);
      if(ObjectFind(0, rowBgName) >= 0)
      {
         color rowColor = (i % 2 == 0) ? GetRowBgDark() : GetRowBgLight();
         // 超阈值时用危险行背景高亮
         if(totalProfit < 0 && g_thresholds[i] < 0 && totalProfit <= g_thresholds[i])
            rowColor = GetRowBgDanger();
         ObjectSetInteger(0, rowBgName, OBJPROP_BGCOLOR, rowColor);
      }
   }

   ChartRedraw();
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//| 整合拖拽事件和原有事件处理                                        |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   // 1. 处理对象点击事件（平仓按钮、隐藏/显示按钮、锁仓开关）
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      // 全平该品种按钮
      if(StringFind(sparam, PFX "BtnCloseAll_") == 0)
      {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);  // 重置按钮状态，使其弹起
         string numStr = StringSubstr(sparam, StringLen(PFX "BtnCloseAll_"));
         int idx = (int)StringToInteger(numStr);
         ActionCloseAllSymbol(idx);
         return;
      }

      // 平多单按钮
      if(StringFind(sparam, PFX "BtnCloseBuy_") == 0)
      {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);  // 重置按钮状态，使其弹起
         string numStr = StringSubstr(sparam, StringLen(PFX "BtnCloseBuy_"));
         int idx = (int)StringToInteger(numStr);
         ActionCloseBuy(idx);
         return;
      }

      // 平空单按钮
      if(StringFind(sparam, PFX "BtnCloseSell_") == 0)
      {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);  // 重置按钮状态，使其弹起
         string numStr = StringSubstr(sparam, StringLen(PFX "BtnCloseSell_"));
         int idx = (int)StringToInteger(numStr);
         ActionCloseSell(idx);
         return;
      }

      // 锁仓开关按钮
      if(sparam == PFX "LockToggleButton")
      {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);  // 重置按钮状态，使其弹起
         g_enableLockPosition = !g_enableLockPosition;
         ObjectSetString(0, PFX "LockToggleButton", OBJPROP_TEXT,
                         g_enableLockPosition ? "锁仓：开" : "锁仓：关");
         SaveSettingsToGlobalVars();
         ChartRedraw();
         return;
      }

      // 隐藏/显示面板按钮
      if(sparam == PFX "PanelHideButton")
      {
         ObjectSetInteger(0, sparam, OBJPROP_STATE, false);  // 重置按钮状态，使其弹起
         // 切换面板可见性
         g_panelVisible = !g_panelVisible;

         // 更新按钮文本
         if(g_panelVisible)
            ObjectSetString(0, PFX "PanelHideButton", OBJPROP_TEXT, "隐藏面板");
         else
            ObjectSetString(0, PFX "PanelHideButton", OBJPROP_TEXT, "显示面板");

         // 更新面板可见性
         UpdatePanelVisibility();

         ChartRedraw();
         return;
      }
   }

   // 获取鼠标坐标（用于拖拽）
   int mouseX = (int)lparam;
   int mouseY = (int)dparam;

   // 2. 处理图表点击：拖拽开始/结束、点击标题循环切换配色
   if(id == CHARTEVENT_CLICK)
   {
      // 正在拖拽时，任意点击先结束拖拽（不触发主题切换，避免误操作）
      if(g_isDragging)
      {
         g_isDragging = false;
         if(ObjectFind(0, PFX "Panel_Border") >= 0)
         {
            ObjectSetInteger(0, PFX "Panel_Border", OBJPROP_BGCOLOR, GetBorderColor());
            ChartRedraw();
         }
         return;
      }

      // 未拖拽时，点击标题文字区域 → 循环切换到下一个配色方案
      if(IsClickOnTitleLabel(mouseX, mouseY))
      {
         int nextScheme = (g_currentScheme + 1) % SCHEME_COUNT;
         SwitchColorScheme(nextScheme);
         return;
      }

      // 未拖拽时，点击面板边框/标题栏右侧可拖拽区域 → 开始拖拽
      if(IsClickOnPanelArea(mouseX, mouseY))
      {
         // 开始拖拽
         g_isDragging = true;
         g_dragStartX = mouseX;
         g_dragStartY = mouseY;
         g_panelOffsetX = g_panelX;  // 记录拖拽开始时面板位置
         g_panelOffsetY = g_panelY;

         // 边框高亮，提示正在拖拽（用标题色作为拖拽高亮）
         if(ObjectFind(0, PFX "Panel_Border") >= 0)
         {
            ObjectSetInteger(0, PFX "Panel_Border", OBJPROP_BGCOLOR, GetTitleColor());
            ChartRedraw();
         }
      }
      return;
   }

   // 3. 处理拖拽移动（鼠标移动时平移面板）
   if(id == CHARTEVENT_MOUSE_MOVE && g_isDragging)
   {
      int dx = mouseX - g_dragStartX;
      int dy = mouseY - g_dragStartY;
      int newX = g_panelOffsetX + dx;
      int newY = g_panelOffsetY + dy;
      MovePanel(newX, newY);
      return;
   }

   // 4. 处理阈值输入框编辑（保留原有逻辑）
   if(id == CHARTEVENT_OBJECT_ENDEDIT)
   {
      for(int i = 0; i < g_symbolCount; i++)
      {
         if(sparam == g_editNames[i])
         {
            string text = ObjectGetString(0, g_editNames[i], OBJPROP_TEXT);

            // 验证输入是否为空
            if(StringLen(text) == 0)
            {
               Print("警告：输入框 ", g_editNames[i], " 的值为空，保持原值");
               break;
            }

            double value = StringToDouble(text);

            // 验证是否为有效数字
            if(value == 0 && StringCompare(text, "0", false) != 0 &&
               StringCompare(text, "-0", false) != 0 && StringCompare(text, "0.0", false) != 0)
            {
               Print("错误：输入框 ", g_editNames[i], " 的值无效: ", text, "，恢复为原值");
               // 恢复显示原值
               ObjectSetString(0, g_editNames[i], OBJPROP_TEXT, DoubleToString(g_thresholds[i], 0));
               break;
            }

            // 如果用户输入正数，自动转换为负数（浮亏是负数）
            if(value > 0)
            {
               g_thresholds[i] = -value;
               // 更新输入框显示为负数
               ObjectSetString(0, g_editNames[i], OBJPROP_TEXT, DoubleToString(-value, 0));
            }
            else
            {
               g_thresholds[i] = value;
            }

            Print("更新 ", g_symbols[i], " 的阈值为: ", DoubleToString(g_thresholds[i], 0));

            // 标记阈值已更新
            g_thresholdsUpdated = true;
            SaveSettingsToGlobalVars();
            break;
         }
      }
   }
}
//+------------------------------------------------------------------+
