//+------------------------------------------------------------------+
//|          11×20 网格面板 - 动态/静态 统计一体 EA (MT5)            |
//|  动态统计：按品种实时浮动统计                                    |
//|  静态统计：按日期汇总历史交易                                    |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict

//--- 面板位置
input int   PanelX      = 20;      // 面板左上角X偏移
input int   PanelY      = 20;      // 面板左上角Y偏移

//--- 面板外观
input color PanelBgColor     = (color)0xFAF5F5;    // 面板背景色
input color PanelBorderColor = (color)0xBEB4B4;    // 面板边框色
input int   PanelPadding     = 5;                 // 网格区到面板边缘的内边距（像素）

//--- 网格单元格样式（默认值）
input int   CellWidth    = 60;      // 默认单元格宽度
input int   CellHeight   = 24;      // 默认单元格高度
input int   CellGapX     = 2;       // 单元格左右间距
input int   CellGapY     = 2;       // 单元格上下间距
input color CellBgColor1 = (color)0xF5EBE6;  // 单元格背景色1 奇数行
input color CellBgColor2 = (color)0xF0E1DC;  // 单元格背景色2 偶数行
input color CellBorderColor = (color)0xD2C8C8; // 单元格边框色

//--- 每列宽度（列1-10）
input int   Col1Width = 35;
input int   Col2Width = 90;
input int   Col3Width = 60;
input int   Col4Width = 60;
input int   Col5Width = 60;
input int   Col6Width = 60;
input int   Col7Width = 60;
input int   Col8Width = 60;
input int   Col9Width = 60;
input int   Col10Width = 60;
//--- 每列宽度（列11-20）
input int   Col11Width = 60;
input int   Col12Width = 60;
input int   Col13Width = 80;
input int   Col14Width = 80;
input int   Col15Width = 80;
input int   Col16Width = 80;
input int   Col17Width = 60;
input int   Col18Width = 60;
input int   Col19Width = 60;
input int   Col20Width = 60;

//--- 每行高度（行1-11）
input int   Row1Height  = 24;
input int   Row2Height  = 24;
input int   Row3Height  = 24;
input int   Row4Height  = 24;
input int   Row5Height  = 24;
input int   Row6Height  = 24;
input int   Row7Height  = 24;
input int   Row8Height  = 24;
input int   Row9Height  = 24;
input int   Row10Height = 24;
input int   Row11Height = 24;

//--- 每列文本水平居中（列1-10）
input bool  Col1Center  = true;
input bool  Col2Center  = true;
input bool  Col3Center  = true;
input bool  Col4Center  = true;
input bool  Col5Center  = true;
input bool  Col6Center  = true;
input bool  Col7Center  = true;
input bool  Col8Center  = true;
input bool  Col9Center  = true;
input bool  Col10Center = true;
//--- 每列文本水平居中（列11-20）
input bool  Col11Center = true;
input bool  Col12Center = true;
input bool  Col13Center = true;
input bool  Col14Center = true;
input bool  Col15Center = true;
input bool  Col16Center = true;
input bool  Col17Center = true;
input bool  Col18Center = true;
input bool  Col19Center = true;
input bool  Col20Center = true;

//--- 刷新 / 统计设置
input int    RefreshInterval     = 1;       // 刷新间隔（秒）
input bool   AutoRefresh         = true;    // 自动刷新
input int    HistoryDays         = 0;       // 静态统计回溯天数（0=全历史）
input double InitialBalance      = 0.0;     // 静态统计初始账户余额（0=自动推算）
input color  ProfitColor         = (color)0x0000FF; // 盈利颜色
input color  LossColor           = (color)0x238E6B; // 亏损颜色
input color  PaginationTextColor = clrBlack;       // 分页信息文本颜色

//--- 动态统计的排序方式
enum SortMode
{
   SORT_FLOAT_LOSS   = 0, // 浮亏排序：最亏（合计浮动盈亏最小）排第1
   SORT_FLOAT_PROFIT = 1  // 盈利排序：最赚（合计浮动盈亏最大）排第1
};
input SortMode SortByMode = SORT_FLOAT_LOSS;

//--- 网格配置
#define GRID_ROWS   11
#define GRID_COLS   20
#define GRID_TOTAL  (GRID_ROWS*GRID_COLS)

#define CELL_PREFIX        "GridCell_"
#define CELL_LABEL_PREFIX  "GridCellTxt_"
#define PANEL_BG_NAME      "GridPanel_BG"
#define PANEL_BORDER_NAME  "GridPanel_Border"
#define TOGGLE_BTN_NAME    "GridPanel_ToggleBtn"
#define MODE_BTN_NAME      "GridPanel_ModeBtn"
#define PAGINATION_PREFIX  "GridPagination_"
#define PAGE_SIZE          10
//--- 全局变量前缀
#define GV_PREFIX          "FloatStats_"

//--- 全局变量
bool g_panelVisible = true;
bool g_dynamicMode  = true;  // true=动态统计；false=静态统计

int  g_colWidths[GRID_COLS];
int  g_rowHeights[GRID_ROWS];
bool g_colCenter[GRID_COLS];

int  g_currentPage  = 1;
int  g_totalPages   = 1;
int  g_totalRecords = 0;

//--- 动态统计：按品种实时浮动统计结构 (MQL5 持仓)
struct SymbolStats
{
   string symbol;
   int    buyCount;
   double buyLots;
   double buyProfit;   // 多单浮动盈亏合计

   int    sellCount;
   double sellLots;
   double sellProfit;  // 空单浮动盈亏合计

   double totalLots;   // 合计手数
   double totalProfit; // 合计浮动盈亏

   double maxFloatLoss;   // 单品种历史最大浮亏（最小盈亏值）
   double maxFloatProfit; // 单品种历史最大浮盈（最大盈亏值）

   // 成本价统计（按手数加权）
   double buyPriceSum;    // 多单价格*手数 累计
   double sellPriceSum;   // 空单价格*手数 累计
   double buyAvgPrice;    // 多单成本价
   double sellAvgPrice;   // 空单成本价
   double totalAvgPrice;  // 多空合计成本价
};

SymbolStats g_stats[];
int         g_statsCount = 0;

//--- 静态统计：日统计结构（全部品种合计）
struct DailyStats
{
   datetime date;
   double   profit;
   double   balance;
   int      tradeCount;
   int      winCount;
   double   volume;
   double   maxVolume;
   double   minVolume;
};

DailyStats g_dailyStats[];
int        g_dailyStatsCount = 0;

// 账户级最大浮亏/浮盈（静态统计用）
double g_accMaxFloatLoss   = 0.0;
double g_accMaxFloatProfit = 0.0;

//--- 表头：动态模式 和 静态模式
string g_row1LabelsDynamic[GRID_COLS] =
{
   "序号", "时间", "品种", "多单数量", "多单手数", "多单盈亏",
   "空单数量", "空单手数", "空单盈亏", "合计总单量",
   "合计总手数", "合计总盈亏", "品种最大浮亏", "品种最大浮盈",
   "多单成本价", "空单成本价", "多空成本价", "账户盈亏", "账户余额", "账户净值"
};

string g_row1LabelsStatic[GRID_COLS] =
{
   "序号", "日期", "盈亏", "余额", "当前净值", "胜率%",
   "最大浮亏", "浮亏%", "浮盈%", "最大浮盈", "总笔数",
   "总手数", "最大持仓时间", "最小持仓时间", "单笔最大手数",
   "单笔最小手数", "出入金", "账户盈亏", "账户余额", "账户净值"
};

// 当前实际使用的表头（根据模式切换）
string g_row1Labels[GRID_COLS];

//--- 函数声明
void   InitializeGridSizes();
void   InitializeStatsDynamic();
void   InitializeStatsDaily();
bool   CreatePanel();
void   CreateCellRect(string name, int x, int y, int width, int height, color bgColor, ENUM_BASE_CORNER corner, bool inBackground);
void   CreateGridCells();
void   CreateToggleButton();
void   CreateModeButton();
void   UpdateModeButtonText();
void   UpdatePanelVisibility();
void   DeletePanel();

void   ProcessOrderDataDynamic();
void   ProcessOrderDataDaily();
void   ProcessOrderData();          // 根据模式（动态/静态）分发

void   SortStatsDynamic();
void   SortDailyStats();

void   UpdatePagination();

void   UpdateGridDataDynamic();
void   UpdateGridDataDaily();
void   UpdateGridData();            // 根据模式（动态/静态）分发

void   UpdateCellText(int row, int col, string text, color clr = clrBlack);
void   CreatePaginationButton(string name, string text, int x, int y, int width, int height);
int    FindOrCreateSymbolIndex(string symbol);
string GetBeijingTimeString();
string FormatCompactFloat(double val, int maxDecimals);
void   ApplyHeaderLabels();

//+------------------------------------------------------------------+
//| EA 初始化 (OnInit)                                               |
//+------------------------------------------------------------------+
int OnInit()
{
   // 默认使用“动态统计”表头
   g_dynamicMode = true;
   for(int i = 0; i < GRID_COLS; i++)
      g_row1Labels[i] = g_row1LabelsDynamic[i];

   InitializeGridSizes();
   InitializeStatsDynamic();
   InitializeStatsDaily();

   if(!CreatePanel())
   {
      Print("错误：创建网格面板失败");
      return(INIT_FAILED);
   }

   // 恢复面板可见状态与当前页
   string baseKey   = GV_PREFIX + _Symbol + "_" + IntegerToString((int)_Period);
   string keyVisible = baseKey + "_visible";
   string keyPage    = baseKey + "_page";

   if(GlobalVariableCheck(keyVisible))
      g_panelVisible = (GlobalVariableGet(keyVisible) > 0.5);

   if(GlobalVariableCheck(keyPage))
   {
      int p = (int)MathRound(GlobalVariableGet(keyPage));
      if(p >= 1)
         g_currentPage = p;
   }

   UpdatePanelVisibility();

   ProcessOrderData();
   UpdatePagination();
   UpdateGridData();

   // 定时器
   EventSetTimer(MathMax(1, RefreshInterval));

   Print("动态/静态统计网格面板EA(MT5)已启动，", GRID_ROWS, "行 × ", GRID_COLS, "列");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| 反初始化                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // 保存面板状态
   string baseKey   = GV_PREFIX + _Symbol + "_" + IntegerToString((int)_Period);
   string keyVisible = baseKey + "_visible";
   string keyPage    = baseKey + "_page";
   GlobalVariableSet(keyVisible, g_panelVisible ? 1.0 : 0.0);
   GlobalVariableSet(keyPage, (double)g_currentPage);

   EventKillTimer();
   DeletePanel();
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| OnTick 保持轻量                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
   // 所有刷新逻辑在 OnTimer 中
}

//+------------------------------------------------------------------+
//| 定时器：按秒刷新                                                 |
//+------------------------------------------------------------------+
void OnTimer()
{
   static datetime s_lastRefresh = 0;
   datetime now = TimeCurrent();
   if(AutoRefresh && (now - s_lastRefresh >= RefreshInterval))
   {
      s_lastRefresh = now;
      int savedPage = g_currentPage;

      ProcessOrderData();

      int tempTotalPages = (g_totalRecords > 0) ? (int)MathCeil((double)g_totalRecords / PAGE_SIZE) : 1;
      if(tempTotalPages < 1) tempTotalPages = 1;

      if(savedPage > tempTotalPages) g_currentPage = tempTotalPages;
      else if(savedPage >= 1)        g_currentPage = savedPage;
      else                           g_currentPage = 1;

      UpdatePagination();
      UpdateGridData();
   }
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| 初始化列宽/行高/对齐                                              |
//+------------------------------------------------------------------+
void InitializeGridSizes()
{
   g_colWidths[0]  = Col1Width  > 0 ? Col1Width  : CellWidth;
   g_colWidths[1]  = Col2Width  > 0 ? Col2Width  : CellWidth;
   g_colWidths[2]  = Col3Width  > 0 ? Col3Width  : CellWidth;
   g_colWidths[3]  = Col4Width  > 0 ? Col4Width  : CellWidth;
   g_colWidths[4]  = Col5Width  > 0 ? Col5Width  : CellWidth;
   g_colWidths[5]  = Col6Width  > 0 ? Col6Width  : CellWidth;
   g_colWidths[6]  = Col7Width  > 0 ? Col7Width  : CellWidth;
   g_colWidths[7]  = Col8Width  > 0 ? Col8Width  : CellWidth;
   g_colWidths[8]  = Col9Width  > 0 ? Col9Width  : CellWidth;
   g_colWidths[9]  = Col10Width > 0 ? Col10Width : CellWidth;
   g_colWidths[10] = Col11Width > 0 ? Col11Width : CellWidth;
   g_colWidths[11] = Col12Width > 0 ? Col12Width : CellWidth;
   g_colWidths[12] = Col13Width > 0 ? Col13Width : CellWidth;
   g_colWidths[13] = Col14Width > 0 ? Col14Width : CellWidth;
   g_colWidths[14] = Col15Width > 0 ? Col15Width : CellWidth;
   g_colWidths[15] = Col16Width > 0 ? Col16Width : CellWidth;
   g_colWidths[16] = Col17Width > 0 ? Col17Width : CellWidth;
   g_colWidths[17] = Col18Width > 0 ? Col18Width : CellWidth;
   g_colWidths[18] = Col19Width > 0 ? Col19Width : CellWidth;
   g_colWidths[19] = Col20Width > 0 ? Col20Width : CellWidth;

   g_rowHeights[0]  = Row1Height  > 0 ? Row1Height  : CellHeight;
   g_rowHeights[1]  = Row2Height  > 0 ? Row2Height  : CellHeight;
   g_rowHeights[2]  = Row3Height  > 0 ? Row3Height  : CellHeight;
   g_rowHeights[3]  = Row4Height  > 0 ? Row4Height  : CellHeight;
   g_rowHeights[4]  = Row5Height  > 0 ? Row5Height  : CellHeight;
   g_rowHeights[5]  = Row6Height  > 0 ? Row6Height  : CellHeight;
   g_rowHeights[6]  = Row7Height  > 0 ? Row7Height  : CellHeight;
   g_rowHeights[7]  = Row8Height  > 0 ? Row8Height  : CellHeight;
   g_rowHeights[8]  = Row9Height  > 0 ? Row9Height  : CellHeight;
   g_rowHeights[9]  = Row10Height > 0 ? Row10Height : CellHeight;
   g_rowHeights[10] = Row11Height > 0 ? Row11Height : CellHeight;

   g_colCenter[0]  = Col1Center;  g_colCenter[1]  = Col2Center;  g_colCenter[2]  = Col3Center;
   g_colCenter[3]  = Col4Center;  g_colCenter[4]  = Col5Center;  g_colCenter[5]  = Col6Center;
   g_colCenter[6]  = Col7Center;  g_colCenter[7]  = Col8Center;  g_colCenter[8]  = Col9Center;
   g_colCenter[9]  = Col10Center; g_colCenter[10] = Col11Center; g_colCenter[11] = Col12Center;
   g_colCenter[12] = Col13Center; g_colCenter[13] = Col14Center; g_colCenter[14] = Col15Center;
   g_colCenter[15] = Col16Center; g_colCenter[16] = Col17Center; g_colCenter[17] = Col18Center;
   g_colCenter[18] = Col19Center; g_colCenter[19] = Col20Center;
}

//+------------------------------------------------------------------+
void InitializeStatsDynamic()
{
   ArrayFree(g_stats);
   g_statsCount    = 0;
   g_totalPages    = 1;
   g_totalRecords  = 0;
}

//+------------------------------------------------------------------+
void InitializeStatsDaily()
{
   ArrayFree(g_dailyStats);
   g_dailyStatsCount = 0;
   g_totalPages      = 1;
   g_totalRecords    = 0;
}

//+------------------------------------------------------------------+
bool CreatePanel()
{
   int totalWidth = 0;
   for(int col = 0; col < GRID_COLS; col++)
   {
      totalWidth += g_colWidths[col];
      if(col < GRID_COLS - 1) totalWidth += CellGapX;
   }
   int totalHeight = 0;
   for(int row = 0; row < GRID_ROWS; row++)
   {
      totalHeight += g_rowHeights[row];
      if(row < GRID_ROWS - 1) totalHeight += CellGapY;
   }
   int pad = MathMax(0, PanelPadding);
   int paginationHeight  = 22 + 5;
   int paginationSpacing = pad + 5;
   int totalPanelHeight  = totalHeight + paginationSpacing + paginationHeight;

   CreateCellRect(PANEL_BORDER_NAME,
                  PanelX - (pad + 2), PanelY - (pad + 2),
                  totalWidth + (pad + 2) * 2, totalPanelHeight + (pad + 2) * 2,
                  PanelBorderColor, CORNER_LEFT_UPPER, false);

   CreateCellRect(PANEL_BG_NAME,
                  PanelX - pad, PanelY - pad,
                  totalWidth + pad * 2, totalPanelHeight + pad * 2,
                  PanelBgColor, CORNER_LEFT_UPPER, false);

   CreateGridCells();
   CreateToggleButton();
   CreateModeButton();
   UpdatePanelVisibility();
   ChartRedraw(0);
   return(true);
}

//+------------------------------------------------------------------+
void CreateCellRect(string name, int x, int y, int width, int height, color bgColor, ENUM_BASE_CORNER corner, bool inBackground)
{
   if(ObjectFind(0, name) < 0)
   {
      if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      {
         Print("错误：创建矩形 ", name, " 失败");
         return;
      }
      ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, CellBorderColor);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_BACK, inBackground);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
}

//+------------------------------------------------------------------+
void CreateGridCells()
{
   int index = 0;
   for(int row = 0; row < GRID_ROWS; row++)
   {
      for(int col = 0; col < GRID_COLS; col++)
      {
         index++;
         int x = PanelX;
         for(int c = 0; c < col; c++) x += g_colWidths[c] + CellGapX;
         int y = PanelY;
         for(int r = 0; r < row; r++) y += g_rowHeights[r] + CellGapY;

         string cellName = CELL_PREFIX + IntegerToString(row + 1) + "_" + IntegerToString(col + 1);
         color  bg       = (row % 2 == 0 ? CellBgColor1 : CellBgColor2);
         CreateCellRect(cellName, x, y, g_colWidths[col], g_rowHeights[row], bg, CORNER_LEFT_UPPER, false);

         string labelName = CELL_LABEL_PREFIX + IntegerToString(index);
         string labelText;
         if(row == 0)
            labelText = (StringLen(g_row1Labels[col]) > 0) ? g_row1Labels[col] : ("方块" + IntegerToString(index));
         else if(row >= 1 && row <= 10)
            labelText = (col == 0) ? IntegerToString(row) : "-";
         else
            labelText = "-";

         bool isCenter = g_colCenter[col];
         int  labelX   = isCenter ? (x + g_colWidths[col] / 2) : (x + 5);
         int  labelY   = y + g_rowHeights[row] / 2;
         ENUM_ANCHOR_POINT anchor   = isCenter ? ANCHOR_CENTER : ANCHOR_LEFT;

         if(ObjectFind(0, labelName) < 0)
         {
            if(!ObjectCreate(0, labelName, OBJ_LABEL, 0, 0, 0))
            {
               Print("错误：创建标签 ", labelName);
               continue;
            }
            ObjectSetInteger(0, labelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(0, labelName, OBJPROP_ANCHOR, anchor);
            ObjectSetInteger(0, labelName, OBJPROP_BACK, false);
            ObjectSetInteger(0, labelName, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, labelName, OBJPROP_FONTSIZE, 8);
            ObjectSetString (0, labelName, OBJPROP_FONT, "Microsoft YaHei UI");
         }
         else
            ObjectSetInteger(0, labelName, OBJPROP_ANCHOR, anchor);

         ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, labelX);
         ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, labelY);
         ObjectSetString (0, labelName, OBJPROP_TEXT, labelText);
         ObjectSetInteger(0, labelName, OBJPROP_HIDDEN, false);
      }
   }
}

//+------------------------------------------------------------------+
void CreateToggleButton()
{
   string buttonText = g_panelVisible ? "隐藏" : "展开";
   if(ObjectFind(0, TOGGLE_BTN_NAME) < 0)
   {
      if(!ObjectCreate(0, TOGGLE_BTN_NAME, OBJ_BUTTON, 0, 0, 0))
      {
         Print("错误：创建切换按钮失败");
         return;
      }
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_CORNER,   CORNER_LEFT_LOWER);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_XDISTANCE,20);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_YDISTANCE,20);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_XSIZE,    80);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_YSIZE,    22);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_BACK,     false);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_BGCOLOR,  (color)0xB48246);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_COLOR,    (color)0xFFFFFF);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_BORDER_COLOR, (color)0xBEB4B4);
      ObjectSetString (0, TOGGLE_BTN_NAME, OBJPROP_FONT,     "Microsoft YaHei UI");
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_SELECTABLE, true);
   }
   ObjectSetString (0, TOGGLE_BTN_NAME, OBJPROP_TEXT, buttonText);
   ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_HIDDEN, false);
}

//+------------------------------------------------------------------+
void CreateModeButton()
{
   string buttonText = g_dynamicMode ? "动态统计" : "静态统计";
   if(ObjectFind(0, MODE_BTN_NAME) < 0)
   {
      if(!ObjectCreate(0, MODE_BTN_NAME, OBJ_BUTTON, 0, 0, 0))
      {
         Print("错误：创建模式切换按钮失败");
         return;
      }
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_CORNER,   CORNER_LEFT_LOWER);
      // 紧挨在“隐藏/展开”右侧
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_XDISTANCE,20 + 80 + 10);
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_YDISTANCE,20);
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_XSIZE,    90);
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_YSIZE,    22);
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_BACK,     false);
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_BGCOLOR,  (color)0xB48246);
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_COLOR,    (color)0xFFFFFF);
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_BORDER_COLOR, (color)0xBEB4B4);
      ObjectSetString (0, MODE_BTN_NAME, OBJPROP_FONT,     "Microsoft YaHei UI");
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_SELECTABLE, true);
   }
   ObjectSetString (0, MODE_BTN_NAME, OBJPROP_TEXT, buttonText);
   ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_HIDDEN, false);
}

//+------------------------------------------------------------------+
void UpdateModeButtonText()
{
   if(ObjectFind(0, MODE_BTN_NAME) >= 0)
   {
      string buttonText = g_dynamicMode ? "动态统计" : "静态统计";
      ObjectSetString(0, MODE_BTN_NAME, OBJPROP_TEXT, buttonText);
   }
}

//+------------------------------------------------------------------+
void UpdatePanelVisibility()
{
   bool visible    = g_panelVisible;
   bool hiddenFlag = !visible;
   int  hiddenX    = -10000;

   if(ObjectFind(0, PANEL_BORDER_NAME) >= 0)
   {
      ObjectSetInteger(0, PANEL_BORDER_NAME, OBJPROP_XDISTANCE, visible ? (PanelX - (PanelPadding + 2)) : hiddenX);
      ObjectSetInteger(0, PANEL_BORDER_NAME, OBJPROP_YDISTANCE, PanelY - (PanelPadding + 2));
      ObjectSetInteger(0, PANEL_BORDER_NAME, OBJPROP_HIDDEN, hiddenFlag);
   }
   if(ObjectFind(0, PANEL_BG_NAME) >= 0)
   {
      ObjectSetInteger(0, PANEL_BG_NAME, OBJPROP_XDISTANCE, visible ? (PanelX - PanelPadding) : hiddenX);
      ObjectSetInteger(0, PANEL_BG_NAME, OBJPROP_YDISTANCE, PanelY - PanelPadding);
      ObjectSetInteger(0, PANEL_BG_NAME, OBJPROP_HIDDEN, hiddenFlag);
   }

   int index = 0;
   for(int row = 0; row < GRID_ROWS; row++)
   {
      for(int col = 0; col < GRID_COLS; col++)
      {
         index++;
         string cellName = CELL_PREFIX + IntegerToString(row + 1) + "_" + IntegerToString(col + 1);
         if(ObjectFind(0, cellName) >= 0)
         {
            if(visible)
            {
               int x = PanelX; for(int c = 0; c < col; c++) x += g_colWidths[c] + CellGapX;
               int y = PanelY; for(int r = 0; r < row; r++) y += g_rowHeights[r] + CellGapY;
               ObjectSetInteger(0, cellName, OBJPROP_XDISTANCE, x);
               ObjectSetInteger(0, cellName, OBJPROP_YDISTANCE, y);
            }
            else
               ObjectSetInteger(0, cellName, OBJPROP_XDISTANCE, hiddenX);
            ObjectSetInteger(0, cellName, OBJPROP_HIDDEN, hiddenFlag);
         }
         string labelName = CELL_LABEL_PREFIX + IntegerToString(index);
         if(ObjectFind(0, labelName) >= 0)
         {
            if(visible)
            {
               int x = PanelX; for(int c2 = 0; c2 < col; c2++) x += g_colWidths[c2] + CellGapX;
               int y = PanelY; for(int r2 = 0; r2 < row; r2++) y += g_rowHeights[r2] + CellGapY;
               int labelX = g_colCenter[col] ? (x + g_colWidths[col] / 2) : (x + 5);
               int labelY = y + g_rowHeights[row] / 2;
               ObjectSetInteger(0, labelName, OBJPROP_ANCHOR, g_colCenter[col] ? ANCHOR_CENTER : ANCHOR_LEFT);
               ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, labelX);
               ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, labelY);
            }
            else
               ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, hiddenX);
            ObjectSetInteger(0, labelName, OBJPROP_HIDDEN, hiddenFlag);
         }
      }
   }

   if(ObjectFind(0, TOGGLE_BTN_NAME) >= 0)
   {
      ObjectSetString (0, TOGGLE_BTN_NAME, OBJPROP_TEXT, g_panelVisible ? "隐藏" : "展开");
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_HIDDEN, false);
   }
   UpdateModeButtonText();
   UpdatePagination();
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
void DeletePanel()
{
   ObjectDelete(0, PANEL_BG_NAME);
   ObjectDelete(0, PANEL_BORDER_NAME);
   ObjectDelete(0, TOGGLE_BTN_NAME);
   ObjectDelete(0, MODE_BTN_NAME);
   ObjectDelete(0, PAGINATION_PREFIX + "Info");
   ObjectDelete(0, PAGINATION_PREFIX + "First");
   ObjectDelete(0, PAGINATION_PREFIX + "Prev");
   ObjectDelete(0, PAGINATION_PREFIX + "Next");
   ObjectDelete(0, PAGINATION_PREFIX + "Last");
   int index = 0;
   for(int row = 0; row < GRID_ROWS; row++)
      for(int col = 0; col < GRID_COLS; col++)
      {
         index++;
         ObjectDelete(0, CELL_PREFIX + IntegerToString(row + 1) + "_" + IntegerToString(col + 1));
         ObjectDelete(0, CELL_LABEL_PREFIX + IntegerToString(index));
      }
}

//+------------------------------------------------------------------+
//| 动态统计：按当前持仓实时统计 (MQL5)                              |
//+------------------------------------------------------------------+
void ProcessOrderDataDynamic()
{
   // 保存上一轮的历史极值
   static string prevSymbols[];
   static double prevMaxLoss[];
   static double prevMaxProfit[];
   int prevCount = g_statsCount;
   ArrayResize(prevSymbols, prevCount);
   ArrayResize(prevMaxLoss, prevCount);
   ArrayResize(prevMaxProfit, prevCount);
   for(int iPrev = 0; iPrev < prevCount; iPrev++)
   {
      prevSymbols[iPrev]   = g_stats[iPrev].symbol;
      prevMaxLoss[iPrev]   = g_stats[iPrev].maxFloatLoss;
      prevMaxProfit[iPrev] = g_stats[iPrev].maxFloatProfit;
   }

   InitializeStatsDynamic();

   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;

      long  type = PositionGetInteger(POSITION_TYPE);
      if(type != POSITION_TYPE_BUY && type != POSITION_TYPE_SELL) continue;

      string sym      = PositionGetString(POSITION_SYMBOL);
      double lots     = PositionGetDouble(POSITION_VOLUME);
      double profit   = PositionGetDouble(POSITION_PROFIT)
                        + PositionGetDouble(POSITION_SWAP)
                        + PositionGetDouble(POSITION_COMMISSION);
      double price    = PositionGetDouble(POSITION_PRICE_OPEN);

      int idx = FindOrCreateSymbolIndex(sym);
      if(idx < 0) continue;

      if(type == POSITION_TYPE_BUY)
      {
         g_stats[idx].buyCount++;
         g_stats[idx].buyLots     += lots;
         g_stats[idx].buyProfit   += profit;
         g_stats[idx].buyPriceSum += price * lots;
      }
      else if(type == POSITION_TYPE_SELL)
      {
         g_stats[idx].sellCount++;
         g_stats[idx].sellLots     += lots;
         g_stats[idx].sellProfit   += profit;
         g_stats[idx].sellPriceSum += price * lots;
      }
   }

   // 合计 & 历史极值 & 成本价
   for(int k = 0; k < g_statsCount; k++)
   {
      g_stats[k].totalLots   = g_stats[k].buyLots + g_stats[k].sellLots;
      g_stats[k].totalProfit = g_stats[k].buyProfit + g_stats[k].sellProfit;

      double oldLoss   = 0.0;
      double oldProfit = 0.0;
      for(int j = 0; j < prevCount; j++)
      {
         if(prevSymbols[j] == g_stats[k].symbol)
         {
            oldLoss   = prevMaxLoss[j];
            oldProfit = prevMaxProfit[j];
            break;
         }
      }

      string glLossKey   = GV_PREFIX + "MaxLoss_"   + g_stats[k].symbol;
      string glProfitKey = GV_PREFIX + "MaxProfit_" + g_stats[k].symbol;
      if(GlobalVariableCheck(glLossKey))
      {
         double glLoss = GlobalVariableGet(glLossKey);
         if(oldLoss == 0.0 || glLoss < oldLoss)
            oldLoss = glLoss;
      }
      if(GlobalVariableCheck(glProfitKey))
      {
         double glProfit = GlobalVariableGet(glProfitKey);
         if(glProfit > oldProfit)
            oldProfit = glProfit;
      }

      double curTotal = g_stats[k].totalProfit;
      double newLoss  = oldLoss;
      if(curTotal < 0.0 && (oldLoss == 0.0 || curTotal < oldLoss))
         newLoss = curTotal;
      g_stats[k].maxFloatLoss = newLoss;

      double newProfit = oldProfit;
      if(curTotal > 0.0 && curTotal > oldProfit)
         newProfit = curTotal;
      g_stats[k].maxFloatProfit = newProfit;

      GlobalVariableSet(glLossKey,   g_stats[k].maxFloatLoss);
      GlobalVariableSet(glProfitKey, g_stats[k].maxFloatProfit);

      if(g_stats[k].buyLots > 0.0)
         g_stats[k].buyAvgPrice = g_stats[k].buyPriceSum / g_stats[k].buyLots;
      else
         g_stats[k].buyAvgPrice = 0.0;

      if(g_stats[k].sellLots > 0.0)
         g_stats[k].sellAvgPrice = g_stats[k].sellPriceSum / g_stats[k].sellLots;
      else
         g_stats[k].sellAvgPrice = 0.0;

      if(g_stats[k].totalLots > 0.0)
         g_stats[k].totalAvgPrice = (g_stats[k].buyPriceSum + g_stats[k].sellPriceSum) / g_stats[k].totalLots;
      else
         g_stats[k].totalAvgPrice = 0.0;
   }

   // 清理无持仓品种的历史极值全局变量
   int gvTotal = GlobalVariablesTotal();
   string lossPrefix   = GV_PREFIX + "MaxLoss_";
   string profitPrefix = GV_PREFIX + "MaxProfit_";
   int lossLen   = StringLen(lossPrefix);
   int profitLen = StringLen(profitPrefix);

   for(int gi = gvTotal - 1; gi >= 0; gi--)
   {
      string name = GlobalVariableName(gi);

      if(lossLen > 0 && StringSubstr(name, 0, lossLen) == lossPrefix)
      {
         string sym = StringSubstr(name, lossLen);
         bool exist = false;
         for(int s = 0; s < g_statsCount; s++)
         {
            if(g_stats[s].symbol == sym)
            {
               exist = true;
               break;
            }
         }
         if(!exist)
            GlobalVariableDel(name);
      }

      if(profitLen > 0 && StringSubstr(name, 0, profitLen) == profitPrefix)
      {
         string sym2 = StringSubstr(name, profitLen);
         bool exist2 = false;
         for(int s2 = 0; s2 < g_statsCount; s2++)
         {
            if(g_stats[s2].symbol == sym2)
            {
               exist2 = true;
               break;
            }
         }
         if(!exist2)
            GlobalVariableDel(name);
      }
   }

   g_totalRecords = g_statsCount;
   SortStatsDynamic();
}

//+------------------------------------------------------------------+
int FindOrCreateSymbolIndex(string symbol)
{
   for(int i = 0; i < g_statsCount; i++)
   {
      if(g_stats[i].symbol == symbol)
         return(i);
   }
   int newIdx = g_statsCount;
   g_statsCount++;
   ArrayResize(g_stats, g_statsCount);

   g_stats[newIdx].symbol         = symbol;
   g_stats[newIdx].buyCount       = 0;
   g_stats[newIdx].buyLots        = 0.0;
   g_stats[newIdx].buyProfit      = 0.0;
   g_stats[newIdx].sellCount      = 0;
   g_stats[newIdx].sellLots       = 0.0;
   g_stats[newIdx].sellProfit     = 0.0;
   g_stats[newIdx].totalLots      = 0.0;
   g_stats[newIdx].totalProfit    = 0.0;
   g_stats[newIdx].maxFloatLoss   = 0.0;
   g_stats[newIdx].maxFloatProfit = 0.0;
   g_stats[newIdx].buyPriceSum    = 0.0;
   g_stats[newIdx].sellPriceSum   = 0.0;
   g_stats[newIdx].buyAvgPrice    = 0.0;
   g_stats[newIdx].sellAvgPrice   = 0.0;
   g_stats[newIdx].totalAvgPrice  = 0.0;

   return(newIdx);
}

//+------------------------------------------------------------------+
void SortStatsDynamic()
{
   if(g_statsCount <= 1) return;
   for(int i = 0; i < g_statsCount - 1; i++)
      for(int j = 0; j < g_statsCount - i - 1; j++)
      {
         bool needSwap = false;
         if(SortByMode == SORT_FLOAT_PROFIT)
         {
            if(g_stats[j].totalProfit < g_stats[j + 1].totalProfit)
               needSwap = true;
            else if(g_stats[j].totalProfit == g_stats[j + 1].totalProfit && g_stats[j].symbol > g_stats[j + 1].symbol)
               needSwap = true;
         }
         else // SORT_FLOAT_LOSS
         {
            if(g_stats[j].totalProfit > g_stats[j + 1].totalProfit)
               needSwap = true;
            else if(g_stats[j].totalProfit == g_stats[j + 1].totalProfit && g_stats[j].symbol > g_stats[j + 1].symbol)
               needSwap = true;
         }

         if(needSwap)
         {
            SymbolStats tmp = g_stats[j];
            g_stats[j]      = g_stats[j + 1];
            g_stats[j + 1]  = tmp;
         }
      }
}

//+------------------------------------------------------------------+
//| 静态统计：按日期汇总历史成交 (简化版)                            |
//+------------------------------------------------------------------+
void ProcessOrderDataDaily()
{
   InitializeStatsDaily();

   datetime endTime   = TimeCurrent();
   datetime startTime = (HistoryDays > 0) ? (endTime - (datetime)(HistoryDays * 86400)) : 0;

   if(!HistorySelect(startTime, endTime))
      return;

   int deals = HistoryDealsTotal();
   if(deals <= 0) return;

   for(int i = 0; i < deals; i++)
   {
      ulong dealTicket = HistoryDealGetTicket(i);
      long  entryType  = (long)HistoryDealGetInteger(dealTicket, DEAL_ENTRY);
      if(entryType != DEAL_ENTRY_OUT) continue; // 只统计平仓成交

      double profit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT)
                    + HistoryDealGetDouble(dealTicket, DEAL_SWAP)
                    + HistoryDealGetDouble(dealTicket, DEAL_COMMISSION);
      double vol    = HistoryDealGetDouble(dealTicket, DEAL_VOLUME);
      datetime closeTime = (datetime)HistoryDealGetInteger(dealTicket, DEAL_TIME);
      if(closeTime < startTime) continue;

      datetime day = StringToTime(TimeToString(closeTime, TIME_DATE));

      int idx = -1;
      for(int k = 0; k < g_dailyStatsCount; k++)
      {
         if(g_dailyStats[k].date == day) { idx = k; break; }
      }
      if(idx < 0)
      {
         idx = g_dailyStatsCount;
         g_dailyStatsCount++;
         ArrayResize(g_dailyStats, g_dailyStatsCount);
         g_dailyStats[idx].date        = day;
         g_dailyStats[idx].profit      = 0.0;
         g_dailyStats[idx].balance     = 0.0;
         g_dailyStats[idx].tradeCount  = 0;
         g_dailyStats[idx].winCount    = 0;
         g_dailyStats[idx].volume      = 0.0;
         g_dailyStats[idx].maxVolume   = 0.0;
         g_dailyStats[idx].minVolume   = 0.0;
      }

      g_dailyStats[idx].profit     += profit;
      g_dailyStats[idx].volume     += vol;
      g_dailyStats[idx].tradeCount++;
      if(profit > 0.0) g_dailyStats[idx].winCount++;

      if(g_dailyStats[idx].maxVolume == 0.0 || vol > g_dailyStats[idx].maxVolume) g_dailyStats[idx].maxVolume = vol;
      if(g_dailyStats[idx].minVolume == 0.0 || vol < g_dailyStats[idx].minVolume) g_dailyStats[idx].minVolume = vol;
   }

   // 日期升序
   if(g_dailyStatsCount > 1)
   {
      for(int i2 = 0; i2 < g_dailyStatsCount - 1; i2++)
         for(int j2 = 0; j2 < g_dailyStatsCount - i2 - 1; j2++)
            if(g_dailyStats[j2].date > g_dailyStats[j2 + 1].date)
            {
               DailyStats tmp = g_dailyStats[j2];
               g_dailyStats[j2] = g_dailyStats[j2 + 1];
               g_dailyStats[j2 + 1] = tmp;
            }
   }

   // 计算累计余额
   double totalProfit = 0.0;
   for(int i3 = 0; i3 < g_dailyStatsCount; i3++)
      totalProfit += g_dailyStats[i3].profit;

   double runningBalance;
   double accBal = AccountInfoDouble(ACCOUNT_BALANCE);
   if(InitialBalance > 0.0)
      runningBalance = InitialBalance;
   else
      runningBalance = accBal - totalProfit;

   for(int i4 = 0; i4 < g_dailyStatsCount; i4++)
   {
      runningBalance += g_dailyStats[i4].profit;
      g_dailyStats[i4].balance = runningBalance;
   }

   // 账户级最大浮亏/浮盈（当前持仓）
   string keyMaxLoss   = GV_PREFIX + "AcctMaxFloatLoss";
   string keyMaxProfit = GV_PREFIX + "AcctMaxFloatProfit";

   int    tradeCount   = 0;
   double curTotalFloat = 0.0;
   int openTotal = PositionsTotal();
   for(int i5 = 0; i5 < openTotal; i5++)
   {
      ulong posTicket = PositionGetTicket(i5);
      if(posTicket == 0) continue;
      if(!PositionSelectByTicket(posTicket)) continue;

      long pType = PositionGetInteger(POSITION_TYPE);
      if(pType != POSITION_TYPE_BUY && pType != POSITION_TYPE_SELL) continue;
      tradeCount++;

      curTotalFloat += PositionGetDouble(POSITION_PROFIT)
                     + PositionGetDouble(POSITION_SWAP)
                     + PositionGetDouble(POSITION_COMMISSION);
   }

   if(tradeCount == 0)
   {
      g_accMaxFloatLoss   = 0.0;
      g_accMaxFloatProfit = 0.0;
      if(GlobalVariableCheck(keyMaxLoss))   GlobalVariableDel(keyMaxLoss);
      if(GlobalVariableCheck(keyMaxProfit)) GlobalVariableDel(keyMaxProfit);
   }
   else
   {
      double oldLoss   = 0.0;
      double oldProfit = 0.0;
      if(GlobalVariableCheck(keyMaxLoss))   oldLoss   = GlobalVariableGet(keyMaxLoss);
      if(GlobalVariableCheck(keyMaxProfit)) oldProfit = GlobalVariableGet(keyMaxProfit);

      if(curTotalFloat < 0.0 && (oldLoss == 0.0 || curTotalFloat < oldLoss))
         g_accMaxFloatLoss = curTotalFloat;
      else
         g_accMaxFloatLoss = oldLoss;

      if(curTotalFloat > 0.0 && curTotalFloat > oldProfit)
         g_accMaxFloatProfit = curTotalFloat;
      else
         g_accMaxFloatProfit = oldProfit;

      GlobalVariableSet(keyMaxLoss,   g_accMaxFloatLoss);
      GlobalVariableSet(keyMaxProfit, g_accMaxFloatProfit);
   }

   g_totalRecords = g_dailyStatsCount;
   SortDailyStats();
}

//+------------------------------------------------------------------+
void SortDailyStats()
{
   if(g_dailyStatsCount <= 1) return;
   for(int i = 0; i < g_dailyStatsCount - 1; i++)
      for(int j = 0; j < g_dailyStatsCount - i - 1; j++)
         if(g_dailyStats[j].date < g_dailyStats[j + 1].date)
         {
            DailyStats temp = g_dailyStats[j];
            g_dailyStats[j] = g_dailyStats[j + 1];
            g_dailyStats[j + 1] = temp;
         }
}

//+------------------------------------------------------------------+
//| 模式分发：动态 / 静态 处理                                       |
//+------------------------------------------------------------------+
void ProcessOrderData()
{
   if(g_dynamicMode)
      ProcessOrderDataDynamic();
   else
      ProcessOrderDataDaily();
}

//+------------------------------------------------------------------+
void UpdatePagination()
{
   if(g_totalRecords > 0)
   {
      g_totalPages = (int)MathCeil((double)g_totalRecords / PAGE_SIZE);
      if(g_totalPages < 1) g_totalPages = 1;
   }
   else
      g_totalPages = 1;

   if(g_currentPage > g_totalPages) g_currentPage = g_totalPages;
   if(g_currentPage < 1)           g_currentPage = 1;

   int totalWidth = 0;
   for(int c = 0; c < GRID_COLS; c++)
   {
      totalWidth += g_colWidths[c];
      if(c < GRID_COLS - 1) totalWidth += CellGapX;
   }
   int totalHeight = 0;
   for(int r = 0; r < GRID_ROWS; r++)
   {
      totalHeight += g_rowHeights[r];
      if(r < GRID_ROWS - 1) totalHeight += CellGapY;
   }
   int paginationY = PanelY + totalHeight + PanelPadding + 5;
   int paginationX = g_panelVisible ? PanelX : -10000;

   string thirdLabel = g_dynamicMode ? "品种数 " : "记录行数 ";
   string pageText   = "当前页 " + IntegerToString(g_currentPage) +
                       " | 总页数 " + IntegerToString(g_totalPages) +
                       " | " + thirdLabel + IntegerToString(g_totalRecords);

   string paginationLabelName = PAGINATION_PREFIX + "Info";
   if(ObjectFind(0, paginationLabelName) < 0)
   {
      ObjectCreate(0, paginationLabelName, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, paginationLabelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, paginationLabelName, OBJPROP_COLOR, PaginationTextColor);
      ObjectSetInteger(0, paginationLabelName, OBJPROP_FONTSIZE, 9);
      ObjectSetString (0, paginationLabelName, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSetInteger(0, paginationLabelName, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, paginationLabelName, OBJPROP_XDISTANCE, paginationX);
   ObjectSetInteger(0, paginationLabelName, OBJPROP_YDISTANCE, paginationY);
   ObjectSetInteger(0, paginationLabelName, OBJPROP_COLOR, PaginationTextColor);
   ObjectSetString (0, paginationLabelName, OBJPROP_TEXT, pageText);
   ObjectSetInteger(0, paginationLabelName, OBJPROP_HIDDEN, !g_panelVisible);

   int buttonY      = paginationY;
   int buttonX      = paginationX + 380;
   int buttonWidth  = 50;
   int buttonHeight = 22;
   CreatePaginationButton(PAGINATION_PREFIX + "First", "首页", buttonX, buttonY, buttonWidth, buttonHeight);
   CreatePaginationButton(PAGINATION_PREFIX + "Prev",  "上页", buttonX + buttonWidth + 5, buttonY, buttonWidth, buttonHeight);
   CreatePaginationButton(PAGINATION_PREFIX + "Next",  "下页", buttonX + (buttonWidth + 5) * 2, buttonY, buttonWidth, buttonHeight);
   CreatePaginationButton(PAGINATION_PREFIX + "Last",  "尾页", buttonX + (buttonWidth + 5) * 3, buttonY, buttonWidth, buttonHeight);
}

//+------------------------------------------------------------------+
void CreatePaginationButton(string name, string text, int x, int y, int width, int height)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, (color)0xB48246);
      ObjectSetInteger(0, name, OBJPROP_COLOR, (color)0xFFFFFF);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, (color)0xBEB4B4);
      ObjectSetString (0, name, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetString (0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, !g_panelVisible);
}

//+------------------------------------------------------------------+
//| 动态模式：更新网格                                               |
//+------------------------------------------------------------------+
void UpdateGridDataDynamic()
{
   int startIndex = (g_currentPage - 1) * PAGE_SIZE;
   int endIndex   = MathMin(startIndex + PAGE_SIZE, g_statsCount);

   string todayStr      = GetBeijingTimeString();
   double accProfit     = AccountInfoDouble(ACCOUNT_PROFIT);
   double accBalance    = AccountInfoDouble(ACCOUNT_BALANCE);
   double accEquity     = AccountInfoDouble(ACCOUNT_EQUITY);
   color  accProfitColor = (accProfit >= 0.0 ? ProfitColor : LossColor);

   int    accTotalBuyCount  = 0;
   int    accTotalSellCount = 0;
   double accTotalBuyLots   = 0.0;
   double accTotalSellLots  = 0.0;

   for(int si = 0; si < g_statsCount; si++)
   {
      accTotalBuyCount  += g_stats[si].buyCount;
      accTotalSellCount += g_stats[si].sellCount;
      accTotalBuyLots   += g_stats[si].buyLots;
      accTotalSellLots  += g_stats[si].sellLots;
   }

   int    accTotalOrderCount = accTotalBuyCount + accTotalSellCount;
   double accTotalLots       = accTotalBuyLots + accTotalSellLots;

   for(int row = 1; row <= 10; row++)
   {
      int dataIndex = startIndex + (row - 1);
      if(dataIndex < endIndex && dataIndex < g_statsCount)
      {
         SymbolStats st = g_stats[dataIndex];

         UpdateCellText(row, 0, IntegerToString(startIndex + row));
         UpdateCellText(row, 1, todayStr);
         UpdateCellText(row, 2, st.symbol);

         UpdateCellText(row, 3, IntegerToString(st.buyCount));
         UpdateCellText(row, 4, DoubleToString(st.buyLots, 2));
         color buyClr = (st.buyProfit >= 0.0 ? ProfitColor : LossColor);
         UpdateCellText(row, 5, DoubleToString(st.buyProfit, 2), buyClr);

         UpdateCellText(row, 6, IntegerToString(st.sellCount));
         UpdateCellText(row, 7, DoubleToString(st.sellLots, 2));
         color sellClr = (st.sellProfit >= 0.0 ? ProfitColor : LossColor);
         UpdateCellText(row, 8, DoubleToString(st.sellProfit, 2), sellClr);

         UpdateCellText(row, 9, IntegerToString(st.buyCount + st.sellCount));

         UpdateCellText(row,10, DoubleToString(st.totalLots, 2));
         color totalClr = (st.totalProfit >= 0.0 ? ProfitColor : LossColor);
         UpdateCellText(row,11, DoubleToString(st.totalProfit, 2), totalClr);

         UpdateCellText(row,12, DoubleToString(st.maxFloatLoss, 2), (st.maxFloatLoss <= 0.0 ? LossColor : ProfitColor));
         UpdateCellText(row,13, DoubleToString(st.maxFloatProfit, 2), (st.maxFloatProfit >= 0.0 ? ProfitColor : LossColor));

         int digits = (int)SymbolInfoInteger(st.symbol, SYMBOL_DIGITS);
         if(digits < 0)
            digits = (int)_Digits;
         UpdateCellText(row,14, DoubleToString(st.buyAvgPrice, digits));
         UpdateCellText(row,15, DoubleToString(st.sellAvgPrice, digits));
         UpdateCellText(row,16, DoubleToString(st.totalAvgPrice, digits));
      }
      else
      {
         UpdateCellText(row, 0, "-");
         for(int col = 1; col < GRID_COLS; col++)
            UpdateCellText(row, col, "-");
      }

      if(row == 1)
      {
         UpdateCellText(row,17, DoubleToString(accProfit, 2), accProfitColor);
         UpdateCellText(row,18, DoubleToString(accBalance, 2));
         UpdateCellText(row,19, DoubleToString(accEquity, 2));
      }
      else if(row == 2)
      {
         UpdateCellText(row,17, "=====");
         UpdateCellText(row,18, "=====");
         UpdateCellText(row,19, "=====");
      }
      else if(row == 3)
      {
         UpdateCellText(row,17, "总多单量");
         UpdateCellText(row,18, "总空单量");
         UpdateCellText(row,19, "总单量");
      }
      else if(row == 4)
      {
         UpdateCellText(row,17, IntegerToString(accTotalBuyCount));
         UpdateCellText(row,18, IntegerToString(accTotalSellCount));
         UpdateCellText(row,19, IntegerToString(accTotalOrderCount));
      }
      else if(row == 5)
      {
         UpdateCellText(row,17, "总多单手数");
         UpdateCellText(row,18, "总空单手数");
         UpdateCellText(row,19, "总手数");
      }
      else if(row == 6)
      {
         UpdateCellText(row,17, DoubleToString(accTotalBuyLots, 2));
         UpdateCellText(row,18, DoubleToString(accTotalSellLots, 2));
         UpdateCellText(row,19, DoubleToString(accTotalLots, 2));
      }
      else if(row == 7)
      {
         UpdateCellText(row,17, "=====");
         UpdateCellText(row,18, "=====");
         UpdateCellText(row,19, "=====");
      }
      else if(row == 8)
      {
         UpdateCellText(row,17, "格数");
         UpdateCellText(row,18, "量化");
         UpdateCellText(row,19, "编程");
      }
      else if(row == 9)
      {
         UpdateCellText(row,17, "微信号：");
         UpdateCellText(row,18, "1581187");
         UpdateCellText(row,19, "5342");
      }
      else if(row == 10)
      {
         UpdateCellText(row,17, "QQ号：");
         UpdateCellText(row,18, "106231");
         UpdateCellText(row,19, "2168");
      }
   }
}

//+------------------------------------------------------------------+
//| 静态模式：更新网格                                               |
//+------------------------------------------------------------------+
void UpdateGridDataDaily()
{
   int startIndex = (g_currentPage - 1) * PAGE_SIZE;
   int endIndex   = MathMin(startIndex + PAGE_SIZE, g_dailyStatsCount);

   double currentEquity  = AccountInfoDouble(ACCOUNT_EQUITY);
   double accProfit      = AccountInfoDouble(ACCOUNT_PROFIT);
   double accBalance     = AccountInfoDouble(ACCOUNT_BALANCE);
   color  accProfitColor = (accProfit >= 0.0 ? ProfitColor : LossColor);

   int    accTotalBuyCount  = 0;
   int    accTotalSellCount = 0;
   double accTotalBuyLots   = 0.0;
   double accTotalSellLots  = 0.0;
   int openTotal = PositionsTotal();
   for(int i = 0; i < openTotal; i++)
   {
      ulong posTicket = PositionGetTicket(i);
      if(posTicket == 0) continue;
      if(!PositionSelectByTicket(posTicket)) continue;
      long type = PositionGetInteger(POSITION_TYPE);
      if(type != POSITION_TYPE_BUY && type != POSITION_TYPE_SELL) continue;
      double lots = PositionGetDouble(POSITION_VOLUME);
      if(type == POSITION_TYPE_BUY)  { accTotalBuyCount++;  accTotalBuyLots  += lots; }
      else                           { accTotalSellCount++; accTotalSellLots += lots; }
   }
   int    accTotalOrderCount = accTotalBuyCount + accTotalSellCount;
   double accTotalLots       = accTotalBuyLots + accTotalSellLots;

   for(int row = 1; row <= 10; row++)
   {
      int dataIndex = startIndex + (row - 1);
      if(dataIndex < endIndex && dataIndex < g_dailyStatsCount)
      {
         DailyStats ds = g_dailyStats[dataIndex];

         UpdateCellText(row, 0, IntegerToString(startIndex + row));
         UpdateCellText(row, 1, TimeToString(ds.date, TIME_DATE));

         string profitText = DoubleToString(ds.profit, 2);
         color  profitColor = (ds.profit >= 0) ? ProfitColor : LossColor;
         UpdateCellText(row, 2, profitText, profitColor);

         UpdateCellText(row, 3, DoubleToString(ds.balance, 2));

         double netValue = (dataIndex == 0) ? currentEquity : ds.balance;
         UpdateCellText(row, 4, DoubleToString(netValue, 2));

         string winRateText = "-";
         if(ds.tradeCount > 0)
         {
            double winRate = 100.0 * (double)ds.winCount / (double)ds.tradeCount;
            winRateText = DoubleToString(winRate, 2) + "%";
         }
         UpdateCellText(row, 5, winRateText);

         UpdateCellText(row,10, IntegerToString(ds.tradeCount));
         UpdateCellText(row,11, DoubleToString(ds.volume, 2));

         // 简化处理：持仓时间、最小持仓时间暂用 "-"
         UpdateCellText(row, 12, "-");
         UpdateCellText(row, 13, "-");

         string maxVolStr = (ds.maxVolume > 0) ? DoubleToString(ds.maxVolume, 2) : "-";
         string minVolStr = (ds.minVolume > 0) ? DoubleToString(ds.minVolume, 2) : "-";
         UpdateCellText(row, 14, maxVolStr);
         UpdateCellText(row, 15, minVolStr);
         UpdateCellText(row, 16, "-");   // 出入金，这里未细分，简单用 "-" 站位
      }
      else
      {
         UpdateCellText(row, 0, "-");
         for(int col = 1; col <= 16; col++) UpdateCellText(row, col, "-");
      }

      if(dataIndex < endIndex && dataIndex < g_dailyStatsCount)
      {
         string maxLossStr   = (g_accMaxFloatLoss < 0.0)   ? FormatCompactFloat(g_accMaxFloatLoss, 2)   : "0";
         string maxProfitStr = (g_accMaxFloatProfit > 0.0) ? FormatCompactFloat(g_accMaxFloatProfit, 2) : "0";
         string lossPctStr   = "-";
         string profitPctStr = "-";
         double bal = AccountInfoDouble(ACCOUNT_BALANCE);
         if(bal > 0.0)
         {
            if(g_accMaxFloatLoss < 0.0)
               lossPctStr  = DoubleToString(100.0 * g_accMaxFloatLoss / bal, 1) + "%";
            if(g_accMaxFloatProfit > 0.0)
               profitPctStr = DoubleToString(100.0 * g_accMaxFloatProfit / bal, 1) + "%";
         }
         UpdateCellText(row, 6, maxLossStr,   (g_accMaxFloatLoss < 0.0 ? LossColor : clrBlack));
         UpdateCellText(row, 7, lossPctStr);
         UpdateCellText(row, 8, profitPctStr);
         UpdateCellText(row, 9, maxProfitStr, (g_accMaxFloatProfit > 0.0 ? ProfitColor : clrBlack));
      }
      else
      {
         UpdateCellText(row, 6, "-");
         UpdateCellText(row, 7, "-");
         UpdateCellText(row, 8, "-");
         UpdateCellText(row, 9, "-");
      }

      if(row == 1)
      {
         UpdateCellText(row, 17, DoubleToString(accProfit, 2), accProfitColor);
         UpdateCellText(row, 18, DoubleToString(accBalance, 2));
         UpdateCellText(row, 19, DoubleToString(currentEquity, 2));
      }
      else if(row == 2)
      {
         UpdateCellText(row, 17, "=====");
         UpdateCellText(row, 18, "=====");
         UpdateCellText(row, 19, "=====");
      }
      else if(row == 3)
      {
         UpdateCellText(row, 17, "总多单量");
         UpdateCellText(row, 18, "总空单量");
         UpdateCellText(row, 19, "总单量");
      }
      else if(row == 4)
      {
         UpdateCellText(row, 17, IntegerToString(accTotalBuyCount));
         UpdateCellText(row, 18, IntegerToString(accTotalSellCount));
         UpdateCellText(row, 19, IntegerToString(accTotalOrderCount));
      }
      else if(row == 5)
      {
         UpdateCellText(row, 17, "总多单手数");
         UpdateCellText(row, 18, "总空单手数");
         UpdateCellText(row, 19, "总手数");
      }
      else if(row == 6)
      {
         UpdateCellText(row, 17, DoubleToString(accTotalBuyLots, 2));
         UpdateCellText(row, 18, DoubleToString(accTotalSellLots, 2));
         UpdateCellText(row, 19, DoubleToString(accTotalLots, 2));
      }
      else if(row == 7)
      {
         UpdateCellText(row, 17, "=====");
         UpdateCellText(row, 18, "=====");
         UpdateCellText(row, 19, "=====");
      }
      else if(row == 8)
      {
         UpdateCellText(row, 17, "格数");
         UpdateCellText(row, 18, "量化");
         UpdateCellText(row, 19, "编程");
      }
      else if(row == 9)
      {
         UpdateCellText(row, 17, "微信号：");
         UpdateCellText(row, 18, "1581187");
         UpdateCellText(row, 19, "5342");
      }
      else if(row == 10)
      {
         UpdateCellText(row, 17, "QQ号：");
         UpdateCellText(row, 18, "106231");
         UpdateCellText(row, 19, "2168");
      }
   }
}

//+------------------------------------------------------------------+
//| 模式分发：更新网格                                               |
//+------------------------------------------------------------------+
void UpdateGridData()
{
   if(g_dynamicMode)
      UpdateGridDataDynamic();
   else
      UpdateGridDataDaily();
}

//+------------------------------------------------------------------+
void UpdateCellText(int row, int col, string text, color clr)
{
   int index = row * GRID_COLS + col + 1;
   string labelName = CELL_LABEL_PREFIX + IntegerToString(index);
   if(ObjectFind(0, labelName) >= 0)
   {
      ObjectSetString(0, labelName, OBJPROP_TEXT, text);
      ObjectSetInteger(0, labelName, OBJPROP_COLOR, clr);
   }
}

//+------------------------------------------------------------------+
string GetBeijingTimeString()
{
   datetime gmt = TimeGMT();
   if(gmt <= 0)
      gmt = TimeCurrent();

   datetime bj = gmt + 8 * 60 * 60;
   string s = TimeToString(bj, TIME_DATE | TIME_MINUTES);
   return s;
}

//+------------------------------------------------------------------+
string FormatCompactFloat(double val, int maxDecimals)
{
   double absVal = MathAbs(val);
   if(absVal >= 10000.0)
      return DoubleToString(val / 10000.0, 2) + "万";
   if(absVal >= 1000.0)
      return DoubleToString(val, 0);
   return DoubleToString(val, MathMin(maxDecimals, 2));
}

//+------------------------------------------------------------------+
void ApplyHeaderLabels()
{
   for(int col = 0; col < GRID_COLS; col++)
      UpdateCellText(0, col, g_row1Labels[col]);
}

//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id != CHARTEVENT_OBJECT_CLICK) return;

   if(sparam == TOGGLE_BTN_NAME)
   {
      g_panelVisible = !g_panelVisible;
      UpdatePanelVisibility();
      if(ObjectFind(0, TOGGLE_BTN_NAME) >= 0)
         ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_STATE, false);
      return;
   }

   if(sparam == MODE_BTN_NAME)
   {
      g_dynamicMode = !g_dynamicMode;

      // 切换当前表头数组
      for(int i = 0; i < GRID_COLS; i++)
         g_row1Labels[i] = g_dynamicMode ? g_row1LabelsDynamic[i] : g_row1LabelsStatic[i];

      UpdateModeButtonText();
      ApplyHeaderLabels();

      ProcessOrderData();
      UpdatePagination();
      UpdateGridData();

      if(ObjectFind(0, MODE_BTN_NAME) >= 0)
         ObjectSetInteger(0, MODE_BTN_NAME, OBJPROP_STATE, false);

      ChartRedraw(0);
      return;
   }

   string btnFirst = PAGINATION_PREFIX + "First";
   string btnPrev  = PAGINATION_PREFIX + "Prev";
   string btnNext  = PAGINATION_PREFIX + "Next";
   string btnLast  = PAGINATION_PREFIX + "Last";

   if(sparam == btnFirst)      { g_currentPage = 1;             UpdatePagination(); UpdateGridData(); }
   else if(sparam == btnPrev)  { if(g_currentPage > 1)          { g_currentPage--;  UpdatePagination(); UpdateGridData(); } }
   else if(sparam == btnNext)  { if(g_currentPage < g_totalPages) { g_currentPage++;  UpdatePagination(); UpdateGridData(); } }
   else if(sparam == btnLast)  { g_currentPage = g_totalPages;  UpdatePagination(); UpdateGridData(); }

   if(ObjectFind(0, sparam) >= 0)
      ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
   ChartRedraw(0);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                 浮动实时统计（MT5 EA 模板版）                    |
//|        11行×20列网格面板（按品种实时浮动统计 + 分页）           |
//+------------------------------------------------------------------+
#property strict
#property description "本指标仅为技术分析辅助工具，不构成投资建议、交易信号或盈利保证。"
#property description "市场有风险，交易需谨慎。"
#property description "使用者自行承担所有交易决策及盈亏结果，开发者不承担任何法律及经济责任。"
#property description "使用即视为已阅读并同意本声明。"
#property description "可提供源码出售、贴牌定制等编程服务。"
#property description "格数量化编程 | 微信：hardship56789"

//--- 授权相关（内部常量，不在参数中暴露）
string g_ExpiryDate   = "";          // 授权到期日(YYYY.MM.DD)，留空=永久
string g_AuthAccounts = "";          // 授权账号列表(逗号分隔)，留空=不限制
bool   g_Authorized   = false;       // 授权状态

//--- 面板位置
input int   PanelX      = 20;      // 面板左上角X偏移
input int   PanelY      = 20;      // 面板左上角Y偏移

//--- 面板外观
input group "=== 面板外观 ==="
input color PanelBgColor     = (color)0xFAF5F5;    // 面板背景色
input color PanelBorderColor = (color)0xBEB4B4;    // 面板边框色
input int   PanelPadding     = 5;                  // 网格区到面板边缘的内边距（像素）

//--- 网格单元格样式（默认值）
input group "=== 网格单元格样式（默认值） ==="
input int   CellWidth    = 60;      // 默认单元格宽度
input int   CellHeight   = 24;      // 默认单元格高度
input int   CellGapX     = 2;       // 单元格左右间距
input int   CellGapY     = 2;       // 单元格上下间距
input color CellBgColor1 = (color)0xF5EBE6;  // 单元格背景色1 奇数行
input color CellBgColor2 = (color)0xF0E1DC;  // 单元格背景色2 偶数行
input color CellBorderColor = (color)0xD2C8C8; // 单元格边框色

//--- 每列宽度（列1-10）
input group "=== 每列宽度设置（列1-10） ==="
input int   Col1Width = 35;
input int   Col2Width = 90;
input int   Col3Width = 60;
input int   Col4Width = 60;
input int   Col5Width = 60;
input int   Col6Width = 60;
input int   Col7Width = 60;
input int   Col8Width = 60;
input int   Col9Width = 60;
input int   Col10Width = 60;
//--- 每列宽度（列11-20）
input group "=== 每列宽度设置（列11-20） ==="
input int   Col11Width = 60;
input int   Col12Width = 60;
input int   Col13Width = 80;
input int   Col14Width = 80;
input int   Col15Width = 80;
input int   Col16Width = 60;
input int   Col17Width = 60;
input int   Col18Width = 60;
input int   Col19Width = 60;
input int   Col20Width = 60;

//--- 每行高度（行1-11）
input group "=== 每行高度设置（行1-11） ==="
input int   Row1Height = 24;
input int   Row2Height = 24;
input int   Row3Height = 24;
input int   Row4Height = 24;
input int   Row5Height = 24;
input int   Row6Height = 24;
input int   Row7Height = 24;
input int   Row8Height = 24;
input int   Row9Height = 24;
input int   Row10Height = 24;
input int   Row11Height = 24;

//--- 每列文本水平居中（列1-10）
input group "=== 每列文本水平居中设置（列1-10） ==="
input bool  Col1Center = true;
input bool  Col2Center = true;
input bool  Col3Center = true;
input bool  Col4Center = true;
input bool  Col5Center = true;
input bool  Col6Center = true;
input bool  Col7Center = true;
input bool  Col8Center = true;
input bool  Col9Center = true;
input bool  Col10Center = true;
//--- 每列文本水平居中（列11-20）
input group "=== 每列文本水平居中设置（列11-20） ==="
input bool  Col11Center = true;
input bool  Col12Center = true;
input bool  Col13Center = true;
input bool  Col14Center = true;
input bool  Col15Center = true;
input bool  Col16Center = true;
input bool  Col17Center = true;
input bool  Col18Center = true;
input bool  Col19Center = true;
input bool  Col20Center = true;

//--- 刷新 / 颜色设置
input group "=== 刷新与颜色设置 ==="
input int    RefreshInterval    = 1;       // 刷新间隔（秒）
input bool   AutoRefresh        = true;    // 自动刷新
input color  ProfitColor        = (color)0x0000FF; // 盈利颜色
input color  LossColor          = (color)0x238E6B; // 亏损颜色
input color  PaginationTextColor = clrBlack;      // 分页信息文本颜色

//--- 排序设置
enum SortMode
{
   SORT_FLOAT_LOSS   = 0, // 浮亏排序：最亏（合计浮动盈亏最小）排第1
   SORT_FLOAT_PROFIT = 1  // 盈利排序：最赚（合计浮动盈亏最大）排第1
};
input SortMode SortByMode = SORT_FLOAT_LOSS;

//--- 网格配置
#define GRID_ROWS  11
#define GRID_COLS  20
#define GRID_TOTAL (GRID_ROWS*GRID_COLS)

//--- 对象名称
#define CELL_PREFIX        "GridCell_"
#define CELL_LABEL_PREFIX  "GridCellTxt_"
#define PANEL_BG_NAME      "GridPanel_BG"
#define PANEL_BORDER_NAME  "GridPanel_Border"
#define TOGGLE_BTN_NAME    "GridPanel_ToggleBtn"
#define PAGINATION_PREFIX  "GridPagination_"
#define PAGE_SIZE          10

//--- 全局变量名前缀（用于跨周期/图表记忆状态 & 历史极值）
#define GV_PREFIX          "FloatStats_"

//--- 全局变量
bool   g_panelVisible = true;
long   g_currentChartID = 0;
int    g_colWidths[GRID_COLS];
int    g_rowHeights[GRID_ROWS];
bool   g_colCenter[GRID_COLS];

int    g_currentPage  = 1;
int    g_totalPages   = 1;
int    g_totalRecords = 0;

//--- 按品种实时浮动统计结构（来自 MQ4 版本）
struct SymbolStats
{
   string symbol;
   int    buyCount;
   double buyLots;
   double buyProfit;   // 多单浮动盈亏合计

   int    sellCount;
   double sellLots;
   double sellProfit;  // 空单浮动盈亏合计

   double totalLots;   // 合计手数
   double totalProfit; // 合计浮动盈亏

   double maxFloatLoss;   // 单笔最大浮亏（最小盈亏值）
   double maxFloatProfit; // 单笔最大浮盈（最大盈亏值）

   // 成本价统计（按手数加权）
   double buyPriceSum;    // 多单价格*手数 累计
   double sellPriceSum;   // 空单价格*手数 累计
   double buyAvgPrice;    // 多单成本价
   double sellAvgPrice;   // 空单成本价
   double totalAvgPrice;  // 多空合计成本价
};

SymbolStats g_stats[];
int         g_statsCount = 0;

//--- 表头（与 MQ4 版一致）
string g_row1Labels[GRID_COLS] =
{
   "序号", "时间", "品种","多单数量", "多单手数", "多单盈亏",
   "空单数量", "空单手数", "空单盈亏", "合计总单量",
   "合计总手数", "合计总盈亏", "品种最大浮亏", "品种最大浮盈",
   "多单成本价", "空单成本价", "多空成本价", "账户盈亏", "账户余额", "账户净值"
};

//--- 函数前向声明
void InitializeGridSizes();
void InitializeStats();
bool CheckAuthorization();
bool CreatePanel();
void CreateCellRect(string name, int x, int y, int width, int height, color bgColor,
                    ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, bool inBackground=false);
void CreateGridCells();
void CreateToggleButton();
void UpdatePanelVisibility();
void DeletePanel();

void ProcessOrderData();
void SortStats();
void UpdatePagination();
void UpdateGridData();
void UpdateCellText(int row, int col, string text, color clr=clrBlack);
int  FindOrCreateSymbolIndex(string symbol);
string GetBeijingTimeString();

//+------------------------------------------------------------------+
//| EA 初始化                                                        |
//+------------------------------------------------------------------+
int OnInit()
{
   g_Authorized = CheckAuthorization();
   if(!g_Authorized)
   {
      Alert(
         "此账号未授权，请联系作者获取。\n"
         "格数量化编程\n"
         "微信号：hardship56789\n"
         "QQ号：1062312168"
      );
      return(INIT_FAILED);
   }

   g_currentChartID = ChartID();

   InitializeGridSizes();
   InitializeStats();

   if(!CreatePanel())
   {
      Print("错误：创建网格面板失败");
      return(INIT_FAILED);
   }

   // 从全局变量中恢复面板可见状态与当前页
   string baseKey   = GV_PREFIX + _Symbol + "_" + IntegerToString((int)_Period);
   string keyVisible = baseKey + "_visible";
   string keyPage    = baseKey + "_page";

   if(GlobalVariableCheck(keyVisible))
      g_panelVisible = (GlobalVariableGet(keyVisible) > 0.5);

   if(GlobalVariableCheck(keyPage))
   {
      int p = (int)MathRound(GlobalVariableGet(keyPage));
      if(p >= 1)
         g_currentPage = p;
   }

   UpdatePanelVisibility();

   ProcessOrderData();
   UpdatePagination();
   UpdateGridData();

   // 定时器
   EventSetTimer(MathMax(1, RefreshInterval));

   Print("浮动实时统计面板（MT5）已启动，", GRID_ROWS, "行 × ", GRID_COLS, "列");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| EA 反初始化                                                      |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // 保存当前面板状态
   string baseKey   = GV_PREFIX + _Symbol + "_" + IntegerToString((int)_Period);
   string keyVisible = baseKey + "_visible";
   string keyPage    = baseKey + "_page";
   GlobalVariableSet(keyVisible, g_panelVisible ? 1.0 : 0.0);
   GlobalVariableSet(keyPage, (double)g_currentPage);

   EventKillTimer();
   DeletePanel();
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| OnTick 保持轻量                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
   // 刷新逻辑全部在 OnTimer 中
}

//+------------------------------------------------------------------+
//| 定时器：按秒刷新统计                                             |
//+------------------------------------------------------------------+
void OnTimer()
{
   static datetime s_lastRefresh = 0;
   datetime now = TimeCurrent();

   bool needRefresh = AutoRefresh && (now - s_lastRefresh >= RefreshInterval);
   if(needRefresh)
   {
      s_lastRefresh = now;

      int savedPage = g_currentPage;
      ProcessOrderData();

      int tempTotalPages = (g_totalRecords > 0) ? (int)MathCeil((double)g_totalRecords / PAGE_SIZE) : 1;
      if(tempTotalPages < 1) tempTotalPages = 1;

      if(savedPage > tempTotalPages) g_currentPage = tempTotalPages;
      else if(savedPage >= 1)        g_currentPage = savedPage;
      else                           g_currentPage = 1;

      UpdatePagination();
      UpdateGridData();
   }

   ChartRedraw();
}

//+------------------------------------------------------------------+
//| 初始化网格尺寸                                                   |
//+------------------------------------------------------------------+
void InitializeGridSizes()
{
   g_colWidths[0]  = Col1Width  > 0 ? Col1Width  : CellWidth;
   g_colWidths[1]  = Col2Width  > 0 ? Col2Width  : CellWidth;
   g_colWidths[2]  = Col3Width  > 0 ? Col3Width  : CellWidth;
   g_colWidths[3]  = Col4Width  > 0 ? Col4Width  : CellWidth;
   g_colWidths[4]  = Col5Width  > 0 ? Col5Width  : CellWidth;
   g_colWidths[5]  = Col6Width  > 0 ? Col6Width  : CellWidth;
   g_colWidths[6]  = Col7Width  > 0 ? Col7Width  : CellWidth;
   g_colWidths[7]  = Col8Width  > 0 ? Col8Width  : CellWidth;
   g_colWidths[8]  = Col9Width  > 0 ? Col9Width  : CellWidth;
   g_colWidths[9]  = Col10Width > 0 ? Col10Width : CellWidth;
   g_colWidths[10] = Col11Width > 0 ? Col11Width : CellWidth;
   g_colWidths[11] = Col12Width > 0 ? Col12Width : CellWidth;
   g_colWidths[12] = Col13Width > 0 ? Col13Width : CellWidth;
   g_colWidths[13] = Col14Width > 0 ? Col14Width : CellWidth;
   g_colWidths[14] = Col15Width > 0 ? Col15Width : CellWidth;
   g_colWidths[15] = Col16Width > 0 ? Col16Width : CellWidth;
   g_colWidths[16] = Col17Width > 0 ? Col17Width : CellWidth;
   g_colWidths[17] = Col18Width > 0 ? Col18Width : CellWidth;
   g_colWidths[18] = Col19Width > 0 ? Col19Width : CellWidth;
   g_colWidths[19] = Col20Width > 0 ? Col20Width : CellWidth;

   g_rowHeights[0]  = Row1Height  > 0 ? Row1Height  : CellHeight;
   g_rowHeights[1]  = Row2Height  > 0 ? Row2Height  : CellHeight;
   g_rowHeights[2]  = Row3Height  > 0 ? Row3Height  : CellHeight;
   g_rowHeights[3]  = Row4Height  > 0 ? Row4Height  : CellHeight;
   g_rowHeights[4]  = Row5Height  > 0 ? Row5Height  : CellHeight;
   g_rowHeights[5]  = Row6Height  > 0 ? Row6Height  : CellHeight;
   g_rowHeights[6]  = Row7Height  > 0 ? Row7Height  : CellHeight;
   g_rowHeights[7]  = Row8Height  > 0 ? Row8Height  : CellHeight;
   g_rowHeights[8]  = Row9Height  > 0 ? Row9Height  : CellHeight;
   g_rowHeights[9]  = Row10Height > 0 ? Row10Height : CellHeight;
   g_rowHeights[10] = Row11Height > 0 ? Row11Height : CellHeight;

   g_colCenter[0]  = Col1Center;  g_colCenter[1]  = Col2Center;  g_colCenter[2]  = Col3Center;
   g_colCenter[3]  = Col4Center;  g_colCenter[4]  = Col5Center;  g_colCenter[5]  = Col6Center;
   g_colCenter[6]  = Col7Center;  g_colCenter[7]  = Col8Center;  g_colCenter[8]  = Col9Center;
   g_colCenter[9]  = Col10Center; g_colCenter[10] = Col11Center; g_colCenter[11] = Col12Center;
   g_colCenter[12] = Col13Center; g_colCenter[13] = Col14Center; g_colCenter[14] = Col15Center;
   g_colCenter[15] = Col16Center; g_colCenter[16] = Col17Center; g_colCenter[17] = Col18Center;
   g_colCenter[18] = Col19Center; g_colCenter[19] = Col20Center;
}

//+------------------------------------------------------------------+
//| 初始化统计数据                                                   |
//+------------------------------------------------------------------+
void InitializeStats()
{
   ArrayFree(g_stats);
   g_statsCount    = 0;
   g_totalPages    = 1;
   g_totalRecords  = 0;
}

//+------------------------------------------------------------------+
//| 授权验证：本地账号/日期授权，模拟账户免费                         |
//+------------------------------------------------------------------+
bool CheckAuthorization()
{
   // 模拟账号：免费使用
   long trade_mode = AccountInfoInteger(ACCOUNT_TRADE_MODE);
   if(trade_mode == ACCOUNT_TRADE_MODE_DEMO)
   {
      Print("FloatStats: 模拟账户，免费授权使用。");
      return(true);
   }

   long acc = (long)AccountInfoInteger(ACCOUNT_LOGIN);

   // 1) 授权账号校验（如果 g_AuthAccounts 不为空，则必须在列表中）
   if(StringLen(g_AuthAccounts) > 0)
   {
      bool found = false;
      int  start = 0;
      while(true)
      {
         int pos = StringFind(g_AuthAccounts, ",", start);
         string token;
         if(pos >= 0)
         {
            token = StringSubstr(g_AuthAccounts, start, pos - start);
            start = pos + 1;
         }
         else
         {
            token = StringSubstr(g_AuthAccounts, start);
         }
         // 去掉前后空格（MQL5 中 StringTrimLeft/Right 通过引用修改字符串）
         StringTrimLeft(token);
         StringTrimRight(token);
         if(StringLen(token) > 0 && (long)StringToInteger(token) == acc)
         {
            found = true;
            break;
         }
         if(pos < 0) break;
      }

      if(!found)
      {
         Print("FloatStats: 当前账号(", acc, ") 未在授权账户列表中。");
         return(false);
      }
   }

   // 2) 到期日期校验（g_ExpiryDate 为空则视为永久）
   if(StringLen(g_ExpiryDate) > 0)
   {
      datetime exp = StringToTime(g_ExpiryDate + " 23:59");
      if(exp > 0 && TimeCurrent() > exp)
      {
         Print("FloatStats: 授权已到期（", g_ExpiryDate, "）。");
         return(false);
      }
   }

   Print("FloatStats: 本地授权通过。账号=", acc,
         ", 到期日=", (StringLen(g_ExpiryDate)>0 ? g_ExpiryDate : "永久"));
   return(true);
}

//+------------------------------------------------------------------+
//| 创建面板                                                         |
//+------------------------------------------------------------------+
bool CreatePanel()
{
   int totalWidth = 0;
   for(int col = 0; col < GRID_COLS; col++)
   {
      totalWidth += g_colWidths[col];
      if(col < GRID_COLS - 1) totalWidth += CellGapX;
   }

   int totalHeight = 0;
   for(int row = 0; row < GRID_ROWS; row++)
   {
      totalHeight += g_rowHeights[row];
      if(row < GRID_ROWS - 1) totalHeight += CellGapY;
   }

   int pad = MathMax(0, PanelPadding);
   int paginationHeight  = 22 + 5;
   int paginationSpacing = pad + 5;
   int totalPanelHeight  = totalHeight + paginationSpacing + paginationHeight;

   CreateCellRect(PANEL_BORDER_NAME,
                  PanelX - (pad + 2), PanelY - (pad + 2),
                  totalWidth + (pad + 2) * 2, totalPanelHeight + (pad + 2) * 2,
                  PanelBorderColor, CORNER_LEFT_UPPER, false);

   CreateCellRect(PANEL_BG_NAME,
                  PanelX - pad, PanelY - pad,
                  totalWidth + pad * 2, totalPanelHeight + pad * 2,
                  PanelBgColor, CORNER_LEFT_UPPER, false);

   CreateGridCells();
   CreateToggleButton();
   UpdatePanelVisibility();
   ChartRedraw();
   return(true);
}

//+------------------------------------------------------------------+
//| 创建矩形                                                         |
//+------------------------------------------------------------------+
void CreateCellRect(string name, int x, int y, int width, int height, color bgColor,
                    ENUM_BASE_CORNER corner, bool inBackground)
{
   if(ObjectFind(0, name) < 0)
   {
      if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      {
         Print("错误：创建矩形 ", name, " 失败，错误代码: ", GetLastError());
         return;
      }
      ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, CellBorderColor);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_BACK, inBackground);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
}

//+------------------------------------------------------------------+
//| 创建11×20网格单元格                                              |
//+------------------------------------------------------------------+
void CreateGridCells()
{
   int index = 0;
   for(int row = 0; row < GRID_ROWS; row++)
   {
      for(int col = 0; col < GRID_COLS; col++)
      {
         index++;
         int x = PanelX;
         for(int c = 0; c < col; c++) x += g_colWidths[c] + CellGapX;
         int y = PanelY;
         for(int r = 0; r < row; r++) y += g_rowHeights[r] + CellGapY;

         string cellName = CELL_PREFIX + IntegerToString(row + 1) + "_" + IntegerToString(col + 1);
         color  bg       = (row % 2 == 0 ? CellBgColor1 : CellBgColor2);
         CreateCellRect(cellName, x, y, g_colWidths[col], g_rowHeights[row], bg, CORNER_LEFT_UPPER, false);

         string labelName = CELL_LABEL_PREFIX + IntegerToString(index);
         string labelText;

         if(row == 0)
         {
            labelText = (StringLen(g_row1Labels[col]) > 0) ? g_row1Labels[col]
                                                           : ("方块" + IntegerToString(index));
         }
         else if(row >= 1 && row <= 10)
         {
            labelText = (col == 0) ? IntegerToString(row) : "-";
         }
         else
         {
            labelText = "-";
         }

         bool isCenter = g_colCenter[col];
         int  labelX   = isCenter ? (x + g_colWidths[col] / 2) : (x + 5);
         int  labelY   = y + g_rowHeights[row] / 2;
         int  anchor   = isCenter ? ANCHOR_CENTER : ANCHOR_LEFT;

         if(ObjectFind(0, labelName) < 0)
         {
            if(!ObjectCreate(0, labelName, OBJ_LABEL, 0, 0, 0))
            {
               Print("错误：创建标签 ", labelName, " 失败，错误代码: ", GetLastError());
               continue;
            }
            ObjectSetInteger(0, labelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(0, labelName, OBJPROP_ANCHOR, anchor);
            ObjectSetInteger(0, labelName, OBJPROP_BACK, false);
            ObjectSetInteger(0, labelName, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, labelName, OBJPROP_FONTSIZE, 8);
            ObjectSetString (0, labelName, OBJPROP_FONT, "Microsoft YaHei UI");
         }
         else
         {
            ObjectSetInteger(0, labelName, OBJPROP_ANCHOR, anchor);
         }

         ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, labelX);
         ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, labelY);
         ObjectSetString (0, labelName, OBJPROP_TEXT, labelText);
         ObjectSetInteger(0, labelName, OBJPROP_HIDDEN, false);
      }
   }
}

//+------------------------------------------------------------------+
//| 创建隐藏/展开按钮                                                |
//+------------------------------------------------------------------+
void CreateToggleButton()
{
   string buttonText = g_panelVisible ? "隐藏" : "展开";
   if(ObjectFind(0, TOGGLE_BTN_NAME) < 0)
   {
      if(!ObjectCreate(0, TOGGLE_BTN_NAME, OBJ_BUTTON, 0, 0, 0))
      {
         Print("错误：创建切换按钮失败，错误代码: ", GetLastError());
         return;
      }
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_CORNER,   CORNER_LEFT_LOWER);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_XDISTANCE,20);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_YDISTANCE,20);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_XSIZE,    80);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_YSIZE,    22);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_BACK,     false);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_BGCOLOR,  (color)0xB48246);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_COLOR,    (color)0xFFFFFF);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_BORDER_COLOR, (color)0xBEB4B4);
      ObjectSetString (0, TOGGLE_BTN_NAME, OBJPROP_FONT,     "Microsoft YaHei UI");
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_SELECTABLE, true);
   }
   ObjectSetString (0, TOGGLE_BTN_NAME, OBJPROP_TEXT, buttonText);
   ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_HIDDEN, false);
}

//+------------------------------------------------------------------+
//| 更新面板可见性                                                   |
//+------------------------------------------------------------------+
void UpdatePanelVisibility()
{
   bool visible    = g_panelVisible;
   bool hiddenFlag = !visible;
   int  hiddenX    = -10000;

   if(ObjectFind(0, PANEL_BORDER_NAME) >= 0)
   {
      ObjectSetInteger(0, PANEL_BORDER_NAME, OBJPROP_XDISTANCE,
                       visible ? (PanelX - (PanelPadding + 2)) : hiddenX);
      ObjectSetInteger(0, PANEL_BORDER_NAME, OBJPROP_YDISTANCE, PanelY - (PanelPadding + 2));
      ObjectSetInteger(0, PANEL_BORDER_NAME, OBJPROP_HIDDEN, hiddenFlag);
   }
   if(ObjectFind(0, PANEL_BG_NAME) >= 0)
   {
      ObjectSetInteger(0, PANEL_BG_NAME, OBJPROP_XDISTANCE,
                       visible ? (PanelX - PanelPadding) : hiddenX);
      ObjectSetInteger(0, PANEL_BG_NAME, OBJPROP_YDISTANCE, PanelY - PanelPadding);
      ObjectSetInteger(0, PANEL_BG_NAME, OBJPROP_HIDDEN, hiddenFlag);
   }

   int index = 0;
   for(int row = 0; row < GRID_ROWS; row++)
   {
      for(int col = 0; col < GRID_COLS; col++)
      {
         index++;
         string cellName = CELL_PREFIX + IntegerToString(row + 1) + "_" + IntegerToString(col + 1);
         if(ObjectFind(0, cellName) >= 0)
         {
            if(visible)
            {
               int x = PanelX; for(int c = 0; c < col; c++) x += g_colWidths[c] + CellGapX;
               int y = PanelY; for(int r = 0; r < row; r++) y += g_rowHeights[r] + CellGapY;
               ObjectSetInteger(0, cellName, OBJPROP_XDISTANCE, x);
               ObjectSetInteger(0, cellName, OBJPROP_YDISTANCE, y);
            }
            else
               ObjectSetInteger(0, cellName, OBJPROP_XDISTANCE, hiddenX);
            ObjectSetInteger(0, cellName, OBJPROP_HIDDEN, hiddenFlag);
         }

         string labelName = CELL_LABEL_PREFIX + IntegerToString(index);
         if(ObjectFind(0, labelName) >= 0)
         {
            if(visible)
            {
               int x = PanelX; for(int c = 0; c < col; c++) x += g_colWidths[c] + CellGapX;
               int y = PanelY; for(int r = 0; r < row; r++) y += g_rowHeights[r] + CellGapY;
               int labelX = g_colCenter[col] ? (x + g_colWidths[col] / 2) : (x + 5);
               int labelY = y + g_rowHeights[row] / 2;
               ObjectSetInteger(0, labelName, OBJPROP_ANCHOR, g_colCenter[col] ? ANCHOR_CENTER : ANCHOR_LEFT);
               ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, labelX);
               ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, labelY);
            }
            else
               ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, hiddenX);
            ObjectSetInteger(0, labelName, OBJPROP_HIDDEN, hiddenFlag);
         }
      }
   }

   if(ObjectFind(0, TOGGLE_BTN_NAME) >= 0)
   {
      ObjectSetString (0, TOGGLE_BTN_NAME, OBJPROP_TEXT, g_panelVisible ? "隐藏" : "展开");
      ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_HIDDEN, false);
   }

   UpdatePagination();
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| 删除面板                                                         |
//+------------------------------------------------------------------+
void DeletePanel()
{
   ObjectDelete(0, PANEL_BG_NAME);
   ObjectDelete(0, PANEL_BORDER_NAME);
   ObjectDelete(0, TOGGLE_BTN_NAME);
   ObjectDelete(0, PAGINATION_PREFIX + "Info");
   ObjectDelete(0, PAGINATION_PREFIX + "First");
   ObjectDelete(0, PAGINATION_PREFIX + "Prev");
   ObjectDelete(0, PAGINATION_PREFIX + "Next");
   ObjectDelete(0, PAGINATION_PREFIX + "Last");

   int index = 0;
   for(int row = 0; row < GRID_ROWS; row++)
      for(int col = 0; col < GRID_COLS; col++)
      {
         index++;
         ObjectDelete(0, CELL_PREFIX + IntegerToString(row + 1) + "_" + IntegerToString(col + 1));
         ObjectDelete(0, CELL_LABEL_PREFIX + IntegerToString(index));
      }
}

//+------------------------------------------------------------------+
//| 持仓数据统计（按品种）                                           |
//+------------------------------------------------------------------+
void ProcessOrderData()
{
   // 先保存上一轮的历史最大浮亏 / 浮盈
   static string prevSymbols[];
   static double prevMaxLoss[];
   static double prevMaxProfit[];

   int prevCount = g_statsCount;
   ArrayResize(prevSymbols,    prevCount);
   ArrayResize(prevMaxLoss,    prevCount);
   ArrayResize(prevMaxProfit,  prevCount);
   for(int iPrev = 0; iPrev < prevCount; iPrev++)
   {
      prevSymbols[iPrev]   = g_stats[iPrev].symbol;
      prevMaxLoss[iPrev]   = g_stats[iPrev].maxFloatLoss;
      prevMaxProfit[iPrev] = g_stats[iPrev].maxFloatProfit;
   }

   InitializeStats();

   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      // 在当前终端版本中没有 PositionSelectByIndex，改为通过票据选择持仓
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(!PositionSelectByTicket(ticket))
         continue;

      long  type = PositionGetInteger(POSITION_TYPE);
      if(type != POSITION_TYPE_BUY && type != POSITION_TYPE_SELL) continue;

      string sym      = PositionGetString(POSITION_SYMBOL);
      double lots     = PositionGetDouble(POSITION_VOLUME);
      double profit   = PositionGetDouble(POSITION_PROFIT)
                        + PositionGetDouble(POSITION_SWAP)
                        + PositionGetDouble(POSITION_COMMISSION);
      double price    = PositionGetDouble(POSITION_PRICE_OPEN);

      int idx = FindOrCreateSymbolIndex(sym);
      if(idx < 0) continue;

      if(type == POSITION_TYPE_BUY)
      {
         g_stats[idx].buyCount++;
         g_stats[idx].buyLots     += lots;
         g_stats[idx].buyProfit   += profit;
         g_stats[idx].buyPriceSum += price * lots;
      }
      else if(type == POSITION_TYPE_SELL)
      {
         g_stats[idx].sellCount++;
         g_stats[idx].sellLots     += lots;
         g_stats[idx].sellProfit   += profit;
         g_stats[idx].sellPriceSum += price * lots;
      }
   }

   // 合计 & 历史极值 & 成本价
   for(int k = 0; k < g_statsCount; k++)
   {
      g_stats[k].totalLots   = g_stats[k].buyLots + g_stats[k].sellLots;
      g_stats[k].totalProfit = g_stats[k].buyProfit + g_stats[k].sellProfit;

      double oldLoss   = 0.0;
      double oldProfit = 0.0;
      for(int j = 0; j < prevCount; j++)
      {
         if(prevSymbols[j] == g_stats[k].symbol)
         {
            oldLoss   = prevMaxLoss[j];
            oldProfit = prevMaxProfit[j];
            break;
         }
      }

      string glLossKey   = GV_PREFIX + "MaxLoss_"   + g_stats[k].symbol;
      string glProfitKey = GV_PREFIX + "MaxProfit_" + g_stats[k].symbol;
      if(GlobalVariableCheck(glLossKey))
      {
         double glLoss = GlobalVariableGet(glLossKey);
         if(oldLoss == 0.0 || glLoss < oldLoss)
            oldLoss = glLoss;
      }
      if(GlobalVariableCheck(glProfitKey))
      {
         double glProfit = GlobalVariableGet(glProfitKey);
         if(glProfit > oldProfit)
            oldProfit = glProfit;
      }

      double curTotal = g_stats[k].totalProfit;
      double newLoss  = oldLoss;
      if(curTotal < 0.0 && (oldLoss == 0.0 || curTotal < oldLoss))
         newLoss = curTotal;
      g_stats[k].maxFloatLoss = newLoss;

      double newProfit = oldProfit;
      if(curTotal > 0.0 && curTotal > oldProfit)
         newProfit = curTotal;
      g_stats[k].maxFloatProfit = newProfit;

      GlobalVariableSet(glLossKey,   g_stats[k].maxFloatLoss);
      GlobalVariableSet(glProfitKey, g_stats[k].maxFloatProfit);

      if(g_stats[k].buyLots > 0.0)
         g_stats[k].buyAvgPrice = g_stats[k].buyPriceSum / g_stats[k].buyLots;
      else
         g_stats[k].buyAvgPrice = 0.0;

      if(g_stats[k].sellLots > 0.0)
         g_stats[k].sellAvgPrice = g_stats[k].sellPriceSum / g_stats[k].sellLots;
      else
         g_stats[k].sellAvgPrice = 0.0;

      if(g_stats[k].totalLots > 0.0)
         g_stats[k].totalAvgPrice = (g_stats[k].buyPriceSum + g_stats[k].sellPriceSum) / g_stats[k].totalLots;
      else
         g_stats[k].totalAvgPrice = 0.0;
   }

   // 清理已经无持仓品种的历史极值全局变量
   int gvTotal = GlobalVariablesTotal();
   string lossPrefix   = GV_PREFIX + "MaxLoss_";
   string profitPrefix = GV_PREFIX + "MaxProfit_";
   int lossLen   = StringLen(lossPrefix);
   int profitLen = StringLen(profitPrefix);

   for(int gi = gvTotal - 1; gi >= 0; gi--)
   {
      string name = GlobalVariableName(gi);

      if(lossLen > 0 && StringSubstr(name, 0, lossLen) == lossPrefix)
      {
         string sym = StringSubstr(name, lossLen);
         bool exist = false;
         for(int s = 0; s < g_statsCount; s++)
         {
            if(g_stats[s].symbol == sym)
            {
               exist = true;
               break;
            }
         }
         if(!exist)
            GlobalVariableDel(name);
      }

      if(profitLen > 0 && StringSubstr(name, 0, profitLen) == profitPrefix)
      {
         string sym2 = StringSubstr(name, profitLen);
         bool exist2 = false;
         for(int s2 = 0; s2 < g_statsCount; s2++)
         {
            if(g_stats[s2].symbol == sym2)
            {
               exist2 = true;
               break;
            }
         }
         if(!exist2)
            GlobalVariableDel(name);
      }
   }

   g_totalRecords = g_statsCount;
   SortStats();
}

//+------------------------------------------------------------------+
//| 查找或创建品种索引                                               |
//+------------------------------------------------------------------+
int FindOrCreateSymbolIndex(string symbol)
{
   for(int i = 0; i < g_statsCount; i++)
   {
      if(g_stats[i].symbol == symbol)
         return(i);
   }
   int newIdx = g_statsCount;
   g_statsCount++;
   ArrayResize(g_stats, g_statsCount);

   g_stats[newIdx].symbol         = symbol;
   g_stats[newIdx].buyCount       = 0;
   g_stats[newIdx].buyLots        = 0.0;
   g_stats[newIdx].buyProfit      = 0.0;
   g_stats[newIdx].sellCount      = 0;
   g_stats[newIdx].sellLots       = 0.0;
   g_stats[newIdx].sellProfit     = 0.0;
   g_stats[newIdx].totalLots      = 0.0;
   g_stats[newIdx].totalProfit    = 0.0;
   g_stats[newIdx].maxFloatLoss   = 0.0;
   g_stats[newIdx].maxFloatProfit = 0.0;
   g_stats[newIdx].buyPriceSum    = 0.0;
   g_stats[newIdx].sellPriceSum   = 0.0;
   g_stats[newIdx].buyAvgPrice    = 0.0;
   g_stats[newIdx].sellAvgPrice   = 0.0;
   g_stats[newIdx].totalAvgPrice  = 0.0;

   return(newIdx);
}

//+------------------------------------------------------------------+
//| 按合计浮动盈亏排序                                               |
//+------------------------------------------------------------------+
void SortStats()
{
   if(g_statsCount <= 1) return;
   for(int i = 0; i < g_statsCount - 1; i++)
      for(int j = 0; j < g_statsCount - i - 1; j++)
      {
         bool needSwap = false;
         if(SortByMode == SORT_FLOAT_PROFIT)
         {
            if(g_stats[j].totalProfit < g_stats[j + 1].totalProfit)
               needSwap = true;
            else if(g_stats[j].totalProfit == g_stats[j + 1].totalProfit &&
                    g_stats[j].symbol > g_stats[j + 1].symbol)
               needSwap = true;
         }
         else // SORT_FLOAT_LOSS
         {
            if(g_stats[j].totalProfit > g_stats[j + 1].totalProfit)
               needSwap = true;
            else if(g_stats[j].totalProfit == g_stats[j + 1].totalProfit &&
                    g_stats[j].symbol > g_stats[j + 1].symbol)
               needSwap = true;
         }

         if(needSwap)
         {
            SymbolStats tmp = g_stats[j];
            g_stats[j]      = g_stats[j + 1];
            g_stats[j + 1]  = tmp;
         }
      }
}

//+------------------------------------------------------------------+
//| 更新分页信息                                                     |
//+------------------------------------------------------------------+
void UpdatePagination()
{
   if(g_totalRecords > 0)
   {
      g_totalPages = (int)MathCeil((double)g_totalRecords / PAGE_SIZE);
      if(g_totalPages < 1) g_totalPages = 1;
   }
   else
      g_totalPages = 1;

   if(g_currentPage > g_totalPages) g_currentPage = g_totalPages;
   if(g_currentPage < 1)           g_currentPage = 1;

   int totalWidth = 0;
   for(int c = 0; c < GRID_COLS; c++)
   {
      totalWidth += g_colWidths[c];
      if(c < GRID_COLS - 1) totalWidth += CellGapX;
   }
   int totalHeight = 0;
   for(int r = 0; r < GRID_ROWS; r++)
   {
      totalHeight += g_rowHeights[r];
      if(r < GRID_ROWS - 1) totalHeight += CellGapY;
   }
   int paginationY = PanelY + totalHeight + PanelPadding + 5;
   int paginationX = g_panelVisible ? PanelX : -10000;

   string pageText = "当前页 " + IntegerToString(g_currentPage) +
                     " | 总页数 " + IntegerToString(g_totalPages) +
                     " | 品种数 " + IntegerToString(g_totalRecords);
   string paginationLabelName = PAGINATION_PREFIX + "Info";

   if(ObjectFind(0, paginationLabelName) < 0)
   {
      ObjectCreate(0, paginationLabelName, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, paginationLabelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, paginationLabelName, OBJPROP_COLOR, PaginationTextColor);
      ObjectSetInteger(0, paginationLabelName, OBJPROP_FONTSIZE, 9);
      ObjectSetString (0, paginationLabelName, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSetInteger(0, paginationLabelName, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, paginationLabelName, OBJPROP_XDISTANCE, paginationX);
   ObjectSetInteger(0, paginationLabelName, OBJPROP_YDISTANCE, paginationY);
   ObjectSetInteger(0, paginationLabelName, OBJPROP_COLOR, PaginationTextColor);
   ObjectSetString (0, paginationLabelName, OBJPROP_TEXT, pageText);
   ObjectSetInteger(0, paginationLabelName, OBJPROP_HIDDEN, !g_panelVisible);

   int buttonY     = paginationY;
   int buttonX     = paginationX + 380;
   int buttonWidth = 50;
   int buttonHeight= 22;

   // 创建/更新分页按钮
   string name;
   name = PAGINATION_PREFIX + "First";
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, buttonWidth);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, buttonHeight);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, (color)0xB48246);
      ObjectSetInteger(0, name, OBJPROP_COLOR, (color)0xFFFFFF);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, (color)0xBEB4B4);
      ObjectSetString (0, name, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, buttonX);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, buttonY);
   ObjectSetString (0, name, OBJPROP_TEXT, "首页");
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, !g_panelVisible);

   name = PAGINATION_PREFIX + "Prev";
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, buttonWidth);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, buttonHeight);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, (color)0xB48246);
      ObjectSetInteger(0, name, OBJPROP_COLOR, (color)0xFFFFFF);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, (color)0xBEB4B4);
      ObjectSetString (0, name, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, buttonX + buttonWidth + 5);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, buttonY);
   ObjectSetString (0, name, OBJPROP_TEXT, "上页");
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, !g_panelVisible);

   name = PAGINATION_PREFIX + "Next";
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, buttonWidth);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, buttonHeight);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, (color)0xB48246);
      ObjectSetInteger(0, name, OBJPROP_COLOR, (color)0xFFFFFF);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, (color)0xBEB4B4);
      ObjectSetString (0, name, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, buttonX + (buttonWidth + 5) * 2);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, buttonY);
   ObjectSetString (0, name, OBJPROP_TEXT, "下页");
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, !g_panelVisible);

   name = PAGINATION_PREFIX + "Last";
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, buttonWidth);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, buttonHeight);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, (color)0xB48246);
      ObjectSetInteger(0, name, OBJPROP_COLOR, (color)0xFFFFFF);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, (color)0xBEB4B4);
      ObjectSetString (0, name, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, buttonX + (buttonWidth + 5) * 3);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, buttonY);
   ObjectSetString (0, name, OBJPROP_TEXT, "尾页");
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, !g_panelVisible);
}

//+------------------------------------------------------------------+
//| 更新网格数据（核心显示逻辑）                                     |
//+------------------------------------------------------------------+
void UpdateGridData()
{
   int startIndex = (g_currentPage - 1) * PAGE_SIZE;
   int endIndex   = MathMin(startIndex + PAGE_SIZE, g_statsCount);

   string todayStr = GetBeijingTimeString();

   double accProfit  = AccountInfoDouble(ACCOUNT_PROFIT);
   double accBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double accEquity  = AccountInfoDouble(ACCOUNT_EQUITY);
   color  accProfitColor = (accProfit >= 0.0 ? ProfitColor : LossColor);

   int    accTotalBuyCount  = 0;
   int    accTotalSellCount = 0;
   double accTotalBuyLots   = 0.0;
   double accTotalSellLots  = 0.0;

   for(int si = 0; si < g_statsCount; si++)
   {
      accTotalBuyCount  += g_stats[si].buyCount;
      accTotalSellCount += g_stats[si].sellCount;
      accTotalBuyLots   += g_stats[si].buyLots;
      accTotalSellLots  += g_stats[si].sellLots;
   }

   int    accTotalOrderCount = accTotalBuyCount + accTotalSellCount;
   double accTotalLots       = accTotalBuyLots + accTotalSellLots;

   for(int row = 1; row <= 10; row++)
   {
      int dataIndex = startIndex + (row - 1);
      if(dataIndex < endIndex && dataIndex < g_statsCount)
      {
         SymbolStats st = g_stats[dataIndex];

         UpdateCellText(row, 0, IntegerToString(startIndex + row));
         UpdateCellText(row, 1, todayStr);
         UpdateCellText(row, 2, st.symbol);

         // 多单
         UpdateCellText(row, 3, IntegerToString(st.buyCount));
         UpdateCellText(row, 4, DoubleToString(st.buyLots, 2));
         color buyClr = (st.buyProfit >= 0.0 ? ProfitColor : LossColor);
         UpdateCellText(row, 5, DoubleToString(st.buyProfit, 2), buyClr);

         // 空单
         UpdateCellText(row, 6, IntegerToString(st.sellCount));
         UpdateCellText(row, 7, DoubleToString(st.sellLots, 2));
         color sellClr = (st.sellProfit >= 0.0 ? ProfitColor : LossColor);
         UpdateCellText(row, 8, DoubleToString(st.sellProfit, 2), sellClr);

         // 合计单量
         UpdateCellText(row, 9, IntegerToString(st.buyCount + st.sellCount));

         // 合计
         UpdateCellText(row,10, DoubleToString(st.totalLots, 2));
         color totalClr = (st.totalProfit >= 0.0 ? ProfitColor : LossColor);
         UpdateCellText(row,11, DoubleToString(st.totalProfit, 2), totalClr);

         // 最大浮亏 / 最大浮盈
         UpdateCellText(row,12, DoubleToString(st.maxFloatLoss, 2),
                        (st.maxFloatLoss <= 0.0 ? LossColor : ProfitColor));
         UpdateCellText(row,13, DoubleToString(st.maxFloatProfit, 2),
                        (st.maxFloatProfit >= 0.0 ? ProfitColor : LossColor));

         // 成本价（按手数加权）
         int digits = (int)SymbolInfoInteger(st.symbol, SYMBOL_DIGITS);
         if(digits <= 0)
            digits = (int)_Digits;
         UpdateCellText(row,14, DoubleToString(st.buyAvgPrice, digits));
         UpdateCellText(row,15, DoubleToString(st.sellAvgPrice, digits));
         UpdateCellText(row,16, DoubleToString(st.totalAvgPrice, digits));
      }
      else
      {
         UpdateCellText(row, 0, "-");
         for(int col = 1; col < GRID_COLS; col++)
            UpdateCellText(row, col, "-");
      }

      // 右侧 17~20 列：账户层统计（与 MQ4 版一致）
      if(row == 1)
      {
         UpdateCellText(row,17, DoubleToString(accProfit, 2), accProfitColor);
         UpdateCellText(row,18, DoubleToString(accBalance, 2));
         UpdateCellText(row,19, DoubleToString(accEquity, 2));
      }
      else if(row == 2)
      {
         UpdateCellText(row,17, "=====");
         UpdateCellText(row,18, "=====");
         UpdateCellText(row,19, "=====");
      }
      else if(row == 3)
      {
         UpdateCellText(row,17, "总多单量");
         UpdateCellText(row,18, "总空单量");
         UpdateCellText(row,19, "总单量");
      }
      else if(row == 4)
      {
         UpdateCellText(row,17, IntegerToString(accTotalBuyCount));
         UpdateCellText(row,18, IntegerToString(accTotalSellCount));
         UpdateCellText(row,19, IntegerToString(accTotalOrderCount));
      }
      else if(row == 5)
      {
         UpdateCellText(row,17, "总多单手数");
         UpdateCellText(row,18, "总空单手数");
         UpdateCellText(row,19, "总手数");
      }
      else if(row == 6)
      {
         UpdateCellText(row,17, DoubleToString(accTotalBuyLots, 2));
         UpdateCellText(row,18, DoubleToString(accTotalSellLots, 2));
         UpdateCellText(row,19, DoubleToString(accTotalLots, 2));
      }
      else if(row == 7)
      {
         UpdateCellText(row,17, "=====");
         UpdateCellText(row,18, "=====");
         UpdateCellText(row,19, "=====");
      }
      else if(row == 8)
      {
         UpdateCellText(row,17, "格数");
         UpdateCellText(row,18, "量化");
         UpdateCellText(row,19, "编程");
      }
      else if(row == 9)
      {
         UpdateCellText(row,17, "微信号：");
         UpdateCellText(row,18, "1581187");
         UpdateCellText(row,19, "5342");
      }
      else if(row == 10)
      {
         UpdateCellText(row,17, "QQ号：");
         UpdateCellText(row,18, "106231");
         UpdateCellText(row,19, "2168");
      }
   }
}

//+------------------------------------------------------------------+
//| 更新单元格文本                                                   |
//+------------------------------------------------------------------+
void UpdateCellText(int row, int col, string text, color clr)
{
   int index = row * GRID_COLS + col + 1;
   string labelName = CELL_LABEL_PREFIX + IntegerToString(index);
   if(ObjectFind(0, labelName) >= 0)
   {
      ObjectSetString (0, labelName, OBJPROP_TEXT, text);
      ObjectSetInteger(0, labelName, OBJPROP_COLOR, clr);
   }
}

//+------------------------------------------------------------------+
//| 获取北京时间字符串（日期+分钟）                                  |
//+------------------------------------------------------------------+
string GetBeijingTimeString()
{
   datetime gmt = TimeGMT();
   if(gmt <= 0)
      gmt = TimeCurrent();
   datetime bj = gmt + 8 * 60 * 60;
   string s = TimeToString(bj, TIME_DATE | TIME_MINUTES);
   return(s);
}

//+------------------------------------------------------------------+
//| ChartEvent：按钮点击处理                                         |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(id != CHARTEVENT_OBJECT_CLICK) return;

   if(sparam == TOGGLE_BTN_NAME)
   {
      g_panelVisible = !g_panelVisible;
      UpdatePanelVisibility();
      if(ObjectFind(0, TOGGLE_BTN_NAME) >= 0)
         ObjectSetInteger(0, TOGGLE_BTN_NAME, OBJPROP_STATE, false);
      return;
   }

   string btnFirst = PAGINATION_PREFIX + "First";
   string btnPrev  = PAGINATION_PREFIX + "Prev";
   string btnNext  = PAGINATION_PREFIX + "Next";
   string btnLast  = PAGINATION_PREFIX + "Last";

   if(sparam == btnFirst)
   {
      g_currentPage = 1;
      UpdatePagination();
      UpdateGridData();
   }
   else if(sparam == btnPrev)
   {
      if(g_currentPage > 1)
      {
         g_currentPage--;
         UpdatePagination();
         UpdateGridData();
      }
   }
   else if(sparam == btnNext)
   {
      if(g_currentPage < g_totalPages)
      {
         g_currentPage++;
         UpdatePagination();
         UpdateGridData();
      }
   }
   else if(sparam == btnLast)
   {
      g_currentPage = g_totalPages;
      UpdatePagination();
      UpdateGridData();
   }

   if(ObjectFind(0, sparam) >= 0)
      ObjectSetInteger(0, sparam, OBJPROP_STATE, false);

   ChartRedraw();
}
//+------------------------------------------------------------------+