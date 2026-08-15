//+------------------------------------------------------------------+
//|                                                      网格面板.mq4 |
//|             MQ4 指标版本：11行×20列网格面板（仅UI，无单元按钮功能） |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window

//--- 输入参数：面板位置
input int   PanelX      = 20;      // 面板左上角X偏移
input int   PanelY      = 20;      // 面板左上角Y偏移

//--- 面板外观（与参考一致：C'245,245,250' 等）
input color PanelBgColor     = 0xFAF5F5;    // 面板背景色 C'245,245,250'
input color PanelBorderColor = 0xBEB4B4;    // 面板边框色 C'180,180,190'
input int   PanelPadding     = 5;          // 网格区到面板边缘的内边距（像素）

//--- 网格单元格样式（默认值）
input int   CellWidth    = 60;      // 默认单元格宽度
input int   CellHeight   = 24;      // 默认单元格高度
input int   CellGapX     = 2;       // 单元格左右间距
input int   CellGapY     = 2;       // 单元格上下间距
input color CellBgColor1 = 0xF5EBE6;  // 单元格背景色1 C'230,235,245' 奇数行
input color CellBgColor2 = 0xF0E1DC;  // 单元格背景色2 C'220,225,240' 偶数行
input color CellBorderColor = 0xD2C8C8; // 单元格边框色 C'200,200,210'

//--- 每列宽度（列1-10）
input int   Col1Width = 35;
input int   Col2Width = 80;
input int   Col3Width = 60;
input int   Col4Width = 80;
input int   Col5Width = 80;
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

//--- 统计设置
input int    RefreshInterval    = 1;       // 刷新间隔（秒）
input bool   AutoRefresh        = true;    // 自动刷新
input int    HistoryDays        = 0;      // 统计回溯天数（0=全历史）
input double InitialBalance     = 0.0;     // 初始账户余额（0=自动以第一天为基准）
input color  ProfitColor        = 0x0000FF; // 盈利颜色（红色）
input color  LossColor          = 0x238E6B; // 亏损颜色 （绿色）
input color  PaginationTextColor = 0;      // 分页信息文本颜色 clrBlack

//--- 网格配置
#define GRID_ROWS  11
#define GRID_COLS  20
#define GRID_TOTAL (GRID_ROWS*GRID_COLS)

#define CELL_PREFIX        "GridCell_"
#define CELL_LABEL_PREFIX  "GridCellTxt_"
#define PANEL_BG_NAME      "GridPanel_BG"
#define PANEL_BORDER_NAME  "GridPanel_Border"
#define TOGGLE_BTN_NAME    "GridPanel_ToggleBtn"
#define PAGINATION_PREFIX  "GridPagination_"
#define PAGE_SIZE          10
#define GV_PREFIX          "GridPanel_"

//--- 全局变量
bool g_panelVisible = true;
int g_colWidths[20];
int g_rowHeights[11];
bool g_colCenter[20];

//--- 日统计结构（MQ4 无 deposit/withdrawal 历史 API，仅交易相关）
struct DailyStats
{
   datetime date;
   double profit;
   double balance;
   int    tradeCount;
   int    winCount;
   double volume;
   int    maxHoldTime;
   int    minHoldTime;
   double maxVolume;
   double minVolume;
};

DailyStats g_dailyStats[];
int g_dailyStatsCount = 0;
datetime g_lastStatsUpdate = 0;

int g_currentPage = 1;
int g_totalPages = 1;
int g_totalRecords = 0;

// 账户级最大浮亏/浮盈（有持仓时更新，无持仓时归零）
double g_accMaxFloatLoss  = 0.0;
double g_accMaxFloatProfit = 0.0;

string g_row1Labels[20] = {
   "序号", "日期", "盈亏", "余额", "当前净值", "胜率%",
   "最大浮亏", "浮亏%", "浮盈%", "最大浮盈", "总笔数",
   "总手数", "最大持仓时间", "最小持仓时间", "单笔最大手数",
   "单笔最小手数", "出入金", "账户盈亏", "账户余额", "账户净值"
};

void InitializeGridSizes();
void InitializeStats();
bool CreatePanel();
void CreateCellRect(string name, int x, int y, int width, int height, color bgColor, int corner, bool inBackground);
void CreateGridCells();
void CreateToggleButton();
void UpdatePanelVisibility();
void DeletePanel();
void ProcessOrderData();
void ProcessTradeHistoryMQ4();
void SortDailyStats();
void UpdatePagination();
void UpdateGridData();
void UpdateCellText(int row, int col, string text, color clr);
void CreatePaginationButton(string name, string text, int x, int y, int width, int height);
string FormatCompactFloat(double val, int maxDecimals);

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   InitializeGridSizes();
   InitializeStats();
   if(!CreatePanel())
   {
      Print("错误：创建网格面板失败");
      return(INIT_FAILED);
   }
   ProcessOrderData();
   UpdatePagination();
   UpdateGridData();
   Print("网格面板指标已启动，", GRID_ROWS, "行 × ", GRID_COLS, "列");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
int deinit(const int reason)
{
   DeletePanel();
   ChartRedraw(0);
   return(0);
}

//+------------------------------------------------------------------+
int start()
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
      else if(savedPage >= 1) g_currentPage = savedPage;
      else g_currentPage = 1;
      UpdatePagination();
      UpdateGridData();
   }
   ChartRedraw(0);
   return(0);
}

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
void InitializeStats()
{
   ArrayFree(g_dailyStats);
   g_dailyStatsCount = 0;
   g_lastStatsUpdate = 0;
   g_totalPages = 1;
   g_totalRecords = 0;
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
   int paginationHeight = 22 + 5;
   int paginationSpacing = pad + 5;
   int totalPanelHeight = totalHeight + paginationSpacing + paginationHeight;

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
   ChartRedraw(0);
   return true;
}

//+------------------------------------------------------------------+
void CreateCellRect(string name, int x, int y, int width, int height, color bgColor, int corner, bool inBackground)
{
   if(ObjectFind(0, name) < 0)
   {
      if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      {
         Print("错误：创建矩形 ", name, " 失败");
         return;
      }
      ObjectSet(name, OBJPROP_CORNER, corner);
   }
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
   ObjectSet(name, OBJPROP_XSIZE, width);
   ObjectSet(name, OBJPROP_YSIZE, height);
   ObjectSet(name, OBJPROP_BGCOLOR, bgColor);
   ObjectSet(name, OBJPROP_BORDER_COLOR, CellBorderColor);
   ObjectSet(name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSet(name, OBJPROP_BACK, inBackground);
   ObjectSet(name, OBJPROP_HIDDEN, false);
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
         color bg = (row % 2 == 0 ? CellBgColor1 : CellBgColor2);
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
         int labelX = isCenter ? (x + g_colWidths[col] / 2) : (x + 5);
         int labelY = y + g_rowHeights[row] / 2;
         int anchorType = isCenter ? ANCHOR_CENTER : ANCHOR_LEFT;

         if(ObjectFind(0, labelName) < 0)
         {
            if(!ObjectCreate(0, labelName, OBJ_LABEL, 0, 0, 0))
            {
               Print("错误：创建标签 ", labelName);
               continue;
            }
            ObjectSet(labelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSet(labelName, OBJPROP_ANCHOR, anchorType);
            ObjectSet(labelName, OBJPROP_BACK, false);
            ObjectSet(labelName, OBJPROP_COLOR, Black);
            ObjectSet(labelName, OBJPROP_FONTSIZE, 8);
            ObjectSetString(0, labelName, OBJPROP_FONT, "Microsoft YaHei UI");
         }
         else
            ObjectSet(labelName, OBJPROP_ANCHOR, anchorType);

         ObjectSet(labelName, OBJPROP_XDISTANCE, labelX);
         ObjectSet(labelName, OBJPROP_YDISTANCE, labelY);
         ObjectSetString(0, labelName, OBJPROP_TEXT, labelText);
         ObjectSet(labelName, OBJPROP_HIDDEN, false);
      }
   }
}

//+------------------------------------------------------------------+
void CreateToggleButton()
{
   string buttonText = g_panelVisible ? "隐藏" : "展开";
   if(ObjectFind(0, TOGGLE_BTN_NAME) < 0)
   {
      if(!ObjectCreate(0, TOGGLE_BTN_NAME, OBJ_BUTTON, 0, 0, 0, 80, 22))
      {
         Print("错误：创建切换按钮失败");
         return;
      }
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_XDISTANCE, 20);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_YDISTANCE, 20);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_XSIZE, 80);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_YSIZE, 22);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_BACK, false);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_BGCOLOR, 0xB48246);   // C'70,130,180'
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_COLOR, 0xFFFFFF);     // C'255,255,255'
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_BORDER_COLOR, 0xBEB4B4); // C'180,180,190'
      ObjectSetString(0, TOGGLE_BTN_NAME, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_FONTSIZE, 9);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_SELECTABLE, true);
   }
   ObjectSetString(0, TOGGLE_BTN_NAME, OBJPROP_TEXT, buttonText);
   ObjectSet(TOGGLE_BTN_NAME, OBJPROP_HIDDEN, false);
}

//+------------------------------------------------------------------+
void UpdatePanelVisibility()
{
   bool visible = g_panelVisible;
   bool hiddenFlag = !visible;
   int hiddenX = -10000;

   if(ObjectFind(0, PANEL_BORDER_NAME) >= 0)
   {
      ObjectSet(PANEL_BORDER_NAME, OBJPROP_XDISTANCE, visible ? (PanelX - (PanelPadding + 2)) : hiddenX);
      ObjectSet(PANEL_BORDER_NAME, OBJPROP_YDISTANCE, PanelY - (PanelPadding + 2));
      ObjectSet(PANEL_BORDER_NAME, OBJPROP_HIDDEN, hiddenFlag);
   }
   if(ObjectFind(0, PANEL_BG_NAME) >= 0)
   {
      ObjectSet(PANEL_BG_NAME, OBJPROP_XDISTANCE, visible ? (PanelX - PanelPadding) : hiddenX);
      ObjectSet(PANEL_BG_NAME, OBJPROP_YDISTANCE, PanelY - PanelPadding);
      ObjectSet(PANEL_BG_NAME, OBJPROP_HIDDEN, hiddenFlag);
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
               ObjectSet(cellName, OBJPROP_XDISTANCE, x);
               ObjectSet(cellName, OBJPROP_YDISTANCE, y);
            }
            else
               ObjectSet(cellName, OBJPROP_XDISTANCE, hiddenX);
            ObjectSet(cellName, OBJPROP_HIDDEN, hiddenFlag);
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
               ObjectSet(labelName, OBJPROP_ANCHOR, g_colCenter[col] ? ANCHOR_CENTER : ANCHOR_LEFT);
               ObjectSet(labelName, OBJPROP_XDISTANCE, labelX);
               ObjectSet(labelName, OBJPROP_YDISTANCE, labelY);
            }
            else
               ObjectSet(labelName, OBJPROP_XDISTANCE, hiddenX);
            ObjectSet(labelName, OBJPROP_HIDDEN, hiddenFlag);
         }
      }
   }

   if(ObjectFind(0, TOGGLE_BTN_NAME) >= 0)
   {
      ObjectSetString(0, TOGGLE_BTN_NAME, OBJPROP_TEXT, g_panelVisible ? "隐藏" : "展开");
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_HIDDEN, false);
   }
   UpdatePagination();
   ChartRedraw(0);
}

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
void ProcessOrderData()
{
   InitializeStats();
   ProcessTradeHistoryMQ4();
   SortDailyStats();

   // 账户级最大浮亏/浮盈：有持仓时更新极值，无持仓时归零（与浮动实时统计逻辑一致）
   string keyMaxLoss  = GV_PREFIX + "AcctMaxFloatLoss";
   string keyMaxProfit = GV_PREFIX + "AcctMaxFloatProfit";

   int tradeCount = 0;
   double curTotalFloat = 0.0;
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderType() != OP_BUY && OrderType() != OP_SELL) continue;
      tradeCount++;
      curTotalFloat += OrderProfit() + OrderSwap() + OrderCommission();
   }

   if(tradeCount == 0)
   {
      g_accMaxFloatLoss  = 0.0;
      g_accMaxFloatProfit = 0.0;
      if(GlobalVariableCheck(keyMaxLoss))   GlobalVariableDel(keyMaxLoss);
      if(GlobalVariableCheck(keyMaxProfit)) GlobalVariableDel(keyMaxProfit);
   }
   else
   {
      double oldLoss  = 0.0;
      double oldProfit = 0.0;
      if(GlobalVariableCheck(keyMaxLoss))   oldLoss  = GlobalVariableGet(keyMaxLoss);
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
}

//+------------------------------------------------------------------+
//| MQ4：用 OrdersHistoryTotal + OrderSelect 按平仓日汇总（全部品种）  |
//+------------------------------------------------------------------+
void ProcessTradeHistoryMQ4()
{
   datetime endTime = TimeCurrent();
   datetime startTime = (HistoryDays > 0) ? (endTime - (datetime)(HistoryDays * 86400)) : 0;

   int total = OrdersHistoryTotal();
   if(total == 0) return;

   // 为了保证“每个日期一行”，不要依赖历史订单的顺序；遇到同一天就累加到同一条记录
   for(int i = 0; i < total; i++)
   {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) continue;
      if(OrderCloseTime() <= 0) continue;
      int oType = OrderType();
      if(oType != OP_BUY && oType != OP_SELL) continue;

      datetime closeTime = (datetime)OrderCloseTime();
      if(closeTime < startTime) continue;

      datetime dealDate = StringToTime(TimeToString(closeTime, TIME_DATE));
      double profit = OrderProfit() + OrderSwap() + OrderCommission();
      double vol = OrderLots();
      int holdTime = (int)(closeTime - (datetime)OrderOpenTime());
      if(holdTime < 0) holdTime = 0;

      int idx = -1;
      for(int k = 0; k < g_dailyStatsCount; k++)
      {
         if(g_dailyStats[k].date == dealDate) { idx = k; break; }
      }
      if(idx < 0)
      {
         idx = g_dailyStatsCount;
         g_dailyStatsCount++;
         ArrayResize(g_dailyStats, g_dailyStatsCount);
         g_dailyStats[idx].date = dealDate;
         g_dailyStats[idx].profit = 0.0;
         g_dailyStats[idx].balance = 0.0;
         g_dailyStats[idx].tradeCount = 0;
         g_dailyStats[idx].winCount = 0;
         g_dailyStats[idx].volume = 0.0;
         g_dailyStats[idx].maxHoldTime = 0;
         g_dailyStats[idx].minHoldTime = 0;
         g_dailyStats[idx].maxVolume = 0.0;
         g_dailyStats[idx].minVolume = 0.0;
      }

      g_dailyStats[idx].profit += profit;
      g_dailyStats[idx].volume += vol;
      g_dailyStats[idx].tradeCount++;
      if(profit > 0.0) g_dailyStats[idx].winCount++;

      if(g_dailyStats[idx].maxVolume == 0.0 || vol > g_dailyStats[idx].maxVolume) g_dailyStats[idx].maxVolume = vol;
      if(g_dailyStats[idx].minVolume == 0.0 || vol < g_dailyStats[idx].minVolume) g_dailyStats[idx].minVolume = vol;

      if(holdTime > 0)
      {
         if(g_dailyStats[idx].maxHoldTime == 0 || holdTime > g_dailyStats[idx].maxHoldTime) g_dailyStats[idx].maxHoldTime = holdTime;
         if(g_dailyStats[idx].minHoldTime == 0 || holdTime < g_dailyStats[idx].minHoldTime) g_dailyStats[idx].minHoldTime = holdTime;
      }
   }

   // 先按日期升序计算“累计余额”，再按日期倒序用于显示
   if(g_dailyStatsCount > 1)
   {
      for(int i = 0; i < g_dailyStatsCount - 1; i++)
         for(int j = 0; j < g_dailyStatsCount - i - 1; j++)
            if(g_dailyStats[j].date > g_dailyStats[j + 1].date)
            {
               DailyStats tmp = g_dailyStats[j];
               g_dailyStats[j] = g_dailyStats[j + 1];
               g_dailyStats[j + 1] = tmp;
            }
   }

   // 计算累计余额：InitialBalance>0 用设定值，否则用 当前余额-历史总盈亏 反推初始余额（与图一一致）
   double totalProfit = 0.0;
   for(int i = 0; i < g_dailyStatsCount; i++)
      totalProfit += g_dailyStats[i].profit;

   double runningBalance;
   if(InitialBalance > 0.0)
      runningBalance = InitialBalance;
   else
      runningBalance = AccountBalance() - totalProfit;  // 反推：使最新日余额=AccountBalance()

   for(int i = 0; i < g_dailyStatsCount; i++)
   {
      runningBalance += g_dailyStats[i].profit;
      g_dailyStats[i].balance = runningBalance;
   }

   g_totalRecords = g_dailyStatsCount;
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
   if(g_currentPage < 1) g_currentPage = 1;

   int totalWidth = 0;
   for(int c = 0; c < GRID_COLS; c++) { totalWidth += g_colWidths[c]; if(c < GRID_COLS - 1) totalWidth += CellGapX; }
   int totalHeight = 0;
   for(int r = 0; r < GRID_ROWS; r++) { totalHeight += g_rowHeights[r]; if(r < GRID_ROWS - 1) totalHeight += CellGapY; }
   int paginationY = PanelY + totalHeight + PanelPadding + 5;
   int paginationX = g_panelVisible ? PanelX : -10000;

   string pageText = "当前页 " + IntegerToString(g_currentPage) + " | 总页数 " +
                     IntegerToString(g_totalPages) + " | 记录行数 " + IntegerToString(g_totalRecords);
   string paginationLabelName = PAGINATION_PREFIX + "Info";
   if(ObjectFind(0, paginationLabelName) < 0)
   {
      ObjectCreate(0, paginationLabelName, OBJ_LABEL, 0, 0, 0);
      ObjectSet(paginationLabelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSet(paginationLabelName, OBJPROP_COLOR, PaginationTextColor);
      ObjectSet(paginationLabelName, OBJPROP_FONTSIZE, 9);
      ObjectSetString(0, paginationLabelName, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSet(paginationLabelName, OBJPROP_BACK, false);
   }
   ObjectSet(paginationLabelName, OBJPROP_XDISTANCE, paginationX);
   ObjectSet(paginationLabelName, OBJPROP_YDISTANCE, paginationY);
   ObjectSet(paginationLabelName, OBJPROP_COLOR, PaginationTextColor);
   ObjectSetString(0, paginationLabelName, OBJPROP_TEXT, pageText);
   ObjectSet(paginationLabelName, OBJPROP_HIDDEN, !g_panelVisible);

   int buttonY = paginationY, buttonX = paginationX + 380, buttonWidth = 50, buttonHeight = 22;
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
      ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0, width, height);
      ObjectSet(name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSet(name, OBJPROP_BGCOLOR, 0xB48246);   // C'70,130,180'
      ObjectSet(name, OBJPROP_COLOR, 0xFFFFFF);     // C'255,255,255'
      ObjectSet(name, OBJPROP_BORDER_COLOR, 0xBEB4B4); // C'180,180,190'
      ObjectSetString(0, name, OBJPROP_FONT, "Microsoft YaHei UI");
      ObjectSet(name, OBJPROP_FONTSIZE, 9);
      ObjectSet(name, OBJPROP_SELECTABLE, true);
      ObjectSet(name, OBJPROP_BACK, false);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
   }
   else
   {
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
   }
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
   ObjectSet(name, OBJPROP_HIDDEN, !g_panelVisible);
}

//+------------------------------------------------------------------+
void UpdateGridData()
{
   int startIndex = (g_currentPage - 1) * PAGE_SIZE;
   int endIndex = MathMin(startIndex + PAGE_SIZE, g_dailyStatsCount);

   double currentEquity = AccountEquity();
   double accProfit     = AccountProfit();
   double accBalance    = AccountBalance();
   color  accProfitColor = (accProfit >= 0.0 ? ProfitColor : LossColor);

   // 账户层面：统计当前持仓总多/空单数量与手数
   int    accTotalBuyCount  = 0;
   int    accTotalSellCount = 0;
   double accTotalBuyLots   = 0.0;
   double accTotalSellLots  = 0.0;
   int total = OrdersTotal();
   for(int i = 0; i < total; i++)
   {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      int type = OrderType();
      if(type != OP_BUY && type != OP_SELL) continue;
      double lots = OrderLots();
      if(type == OP_BUY)  { accTotalBuyCount++;  accTotalBuyLots  += lots; }
      else                { accTotalSellCount++; accTotalSellLots += lots; }
   }
   int    accTotalOrderCount = accTotalBuyCount + accTotalSellCount;
   double accTotalLots       = accTotalBuyLots + accTotalSellLots;

   for(int row = 1; row <= 10; row++)
   {
      int dataIndex = startIndex + (row - 1);
      if(dataIndex < endIndex && dataIndex < g_dailyStatsCount)
      {
         UpdateCellText(row, 0, IntegerToString(startIndex + row));
         UpdateCellText(row, 1, TimeToString(g_dailyStats[dataIndex].date, TIME_DATE));
         string profitText = DoubleToString(g_dailyStats[dataIndex].profit, 2);
         color profitColor = (g_dailyStats[dataIndex].profit >= 0) ? ProfitColor : LossColor;
         UpdateCellText(row, 2, profitText, profitColor);
         double displayBalance = g_dailyStats[dataIndex].balance;
         if(dataIndex == 0)
            displayBalance = AccountBalance();
         UpdateCellText(row, 3, DoubleToString(displayBalance, 2));

         // 当前净值：最新日期行用实时净值，其它日期用该日收盘后的累计余额
         double netValue = (dataIndex == 0) ? currentEquity : g_dailyStats[dataIndex].balance;
         UpdateCellText(row, 4, DoubleToString(netValue, 2));
         string winRateText = "-";
         if(g_dailyStats[dataIndex].tradeCount > 0)
         {
            double winRate = 100.0 * (double)g_dailyStats[dataIndex].winCount / (double)g_dailyStats[dataIndex].tradeCount;
            winRateText = DoubleToString(winRate, 2) + "%";
         }
         UpdateCellText(row, 5, winRateText);
         UpdateCellText(row, 10, IntegerToString(g_dailyStats[dataIndex].tradeCount));
         UpdateCellText(row, 11, DoubleToString(g_dailyStats[dataIndex].volume, 2));

         string maxHoldTimeStr = "-";
         if(g_dailyStats[dataIndex].maxHoldTime > 0)
         {
            int d = g_dailyStats[dataIndex].maxHoldTime / 86400;
            int h = (g_dailyStats[dataIndex].maxHoldTime % 86400) / 3600;
            int m = (g_dailyStats[dataIndex].maxHoldTime % 3600) / 60;
            if(d > 0) maxHoldTimeStr = IntegerToString(d) + "天" + IntegerToString(h) + "时";
            else if(h > 0) maxHoldTimeStr = IntegerToString(h) + "时" + IntegerToString(m) + "分";
            else maxHoldTimeStr = IntegerToString(m) + "分";
         }
         UpdateCellText(row, 12, maxHoldTimeStr);

         string minHoldTimeStr = "-";
         if(g_dailyStats[dataIndex].minHoldTime > 0)
         {
            int d = g_dailyStats[dataIndex].minHoldTime / 86400;
            int h = (g_dailyStats[dataIndex].minHoldTime % 86400) / 3600;
            int m = (g_dailyStats[dataIndex].minHoldTime % 3600) / 60;
            if(d > 0) minHoldTimeStr = IntegerToString(d) + "天" + IntegerToString(h) + "时";
            else if(h > 0) minHoldTimeStr = IntegerToString(h) + "时" + IntegerToString(m) + "分";
            else minHoldTimeStr = IntegerToString(m) + "分";
         }
         UpdateCellText(row, 13, minHoldTimeStr);

         string maxVolStr = (g_dailyStats[dataIndex].maxVolume > 0) ? DoubleToString(g_dailyStats[dataIndex].maxVolume, 2) : "-";
         UpdateCellText(row, 14, maxVolStr);
         string minVolStr = (g_dailyStats[dataIndex].minVolume > 0) ? DoubleToString(g_dailyStats[dataIndex].minVolume, 2) : "-";
         UpdateCellText(row, 15, minVolStr);
         UpdateCellText(row, 16, "-");
      }
      else
      {
         UpdateCellText(row, 0, "-");
         for(int col = 1; col <= 16; col++) UpdateCellText(row, col, "-");
      }

      // 第7~10列：有序号的数据行才显示账户级最大浮亏/浮盈；无序号行显示"-"（框选位置不受影响）
      if(dataIndex < endIndex && dataIndex < g_dailyStatsCount)
      {
         string maxLossStr   = (g_accMaxFloatLoss < 0.0) ? FormatCompactFloat(g_accMaxFloatLoss, 2) : "0";
         string maxProfitStr = (g_accMaxFloatProfit > 0.0) ? FormatCompactFloat(g_accMaxFloatProfit, 2) : "0";
         string lossPctStr   = "-";
         string profitPctStr = "-";
         double bal = AccountBalance();
         if(bal > 0.0)
         {
            if(g_accMaxFloatLoss < 0.0)   lossPctStr  = DoubleToString(100.0 * g_accMaxFloatLoss / bal, 1) + "%";
            if(g_accMaxFloatProfit > 0.0) profitPctStr = DoubleToString(100.0 * g_accMaxFloatProfit / bal, 1) + "%";
         }
         UpdateCellText(row, 6, maxLossStr,   (g_accMaxFloatLoss < 0.0 ? LossColor : Black));
         UpdateCellText(row, 7, lossPctStr);
         UpdateCellText(row, 8, profitPctStr);
         UpdateCellText(row, 9, maxProfitStr, (g_accMaxFloatProfit > 0.0 ? ProfitColor : Black));
      }
      else
      {
         UpdateCellText(row, 6, "-");
         UpdateCellText(row, 7, "-");
         UpdateCellText(row, 8, "-");
         UpdateCellText(row, 9, "-");
      }

      // 第18、19、20列固定布局（账户信息、分隔线、总单量/手数、格数量化编程、微信号、QQ）
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
// 紧凑格式：大数用万/千显示，避免溢出单元格
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
void UpdateCellText(int row, int col, string text, color clr = Black)
{
   int index = row * GRID_COLS + col + 1;
   string labelName = CELL_LABEL_PREFIX + IntegerToString(index);
   if(ObjectFind(0, labelName) >= 0)
   {
      ObjectSetString(0, labelName, OBJPROP_TEXT, text);
      ObjectSet(labelName, OBJPROP_COLOR, clr);
   }
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
         ObjectSet(TOGGLE_BTN_NAME, OBJPROP_STATE, false);
      return;
   }

   string btnFirst = PAGINATION_PREFIX + "First";
   string btnPrev  = PAGINATION_PREFIX + "Prev";
   string btnNext  = PAGINATION_PREFIX + "Next";
   string btnLast  = PAGINATION_PREFIX + "Last";

   if(sparam == btnFirst)      { g_currentPage = 1; UpdatePagination(); UpdateGridData(); }
   else if(sparam == btnPrev)  { if(g_currentPage > 1) { g_currentPage--; UpdatePagination(); UpdateGridData(); } }
   else if(sparam == btnNext)  { if(g_currentPage < g_totalPages) { g_currentPage++; UpdatePagination(); UpdateGridData(); } }
   else if(sparam == btnLast)  { g_currentPage = g_totalPages; UpdatePagination(); UpdateGridData(); }

   if(ObjectFind(0, sparam) >= 0)
      ObjectSet(sparam, OBJPROP_STATE, false);
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
