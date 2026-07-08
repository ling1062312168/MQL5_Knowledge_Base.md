//+------------------------------------------------------------------+
//|             MQ4 指标版本：11行×20列网格面板（按品种实时浮动统计） |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window

//--- 输入参数：面板位置
input int   PanelX      = 20;      // 面板左上角X偏移
input int   PanelY      = 20;      // 面板左上角Y偏移

//--- 面板外观
input color PanelBgColor     = 0xFAF5F5;    // 面板背景色
input color PanelBorderColor = 0xBEB4B4;    // 面板边框色
input int   PanelPadding     = 5;          // 网格区到面板边缘的内边距（像素）

//--- 网格单元格样式（默认值）
input int   CellWidth    = 60;      // 默认单元格宽度
input int   CellHeight   = 24;      // 默认单元格高度
input int   CellGapX     = 2;       // 单元格左右间距
input int   CellGapY     = 2;       // 单元格上下间距
input color CellBgColor1 = 0xF5EBE6;  // 单元格背景色1 奇数行
input color CellBgColor2 = 0xF0E1DC;  // 单元格背景色2 偶数行
input color CellBorderColor = 0xD2C8C8; // 单元格边框色

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
input int   Col16Width = 60;
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

//--- 刷新设置
input int    RefreshInterval    = 1;       // 刷新间隔（秒）
input bool   AutoRefresh        = true;    // 自动刷新
input color  ProfitColor        = 0x0000FF; // 盈利颜色
input color  LossColor          = 0x238E6B; // 亏损颜色
input color  PaginationTextColor = 0;      // 分页信息文本颜色

//--- 排序设置
enum SortMode
{
   SORT_FLOAT_LOSS  = 0, // 浮亏排序：最亏（合计浮动盈亏最小）排第1
   SORT_FLOAT_PROFIT= 1  // 盈利排序：最赚（合计浮动盈亏最大）排第1
};
input SortMode SortByMode = SORT_FLOAT_LOSS;

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
//--- 全局变量名前缀（用于跨周期/图表记忆状态）
#define GV_PREFIX          "FloatStats_"

//--- 全局变量
bool g_panelVisible = true;
int  g_colWidths[20];
int  g_rowHeights[11];
bool g_colCenter[20];

//--- 按品种实时浮动统计结构
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

int g_currentPage  = 1;
int g_totalPages   = 1;
int g_totalRecords = 0;

//--- 表头
string g_row1Labels[20] =
{
   "序号", "时间", "品种","多单数量", "多单手数", "多单盈亏",
   "空单数量", "空单手数", "空单盈亏", "合计总单量",
   "合计总手数", "合计总盈亏", "品种最大浮亏", "品种最大浮盈",
   "多单成本价", "空单成本价", "多空成本价", "账户盈亏", "账户余额", "账户净值"
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
void SortStats();
void UpdatePagination();
void UpdateGridData();
void UpdateCellText(int row, int col, string text, color clr = Black);
void CreatePaginationButton(string name, string text, int x, int y, int width, int height);
int  FindOrCreateSymbolIndex(string symbol);
string GetBeijingTimeString();

//+------------------------------------------------------------------+
//| init                                                             |
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

   // 从全局变量中恢复面板可见状态与当前页（用于切换周期/图表后的记忆）
   string baseKey = GV_PREFIX + Symbol() + "_" + IntegerToString(Period());
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
   Print("实时浮动统计面板已启动，", GRID_ROWS, "行 × ", GRID_COLS, "列");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
int deinit()
{
   // 仅保存面板状态到全局变量，便于切换周期/图表后恢复
   string baseKey   = GV_PREFIX + Symbol() + "_" + IntegerToString(Period());
   string keyVisible = baseKey + "_visible";
   string keyPage    = baseKey + "_page";
   GlobalVariableSet(keyVisible, g_panelVisible ? 1.0 : 0.0);
   GlobalVariableSet(keyPage, (double)g_currentPage);

   DeletePanel();
   ChartRedraw(0);
   return(0);
}

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
      else if(savedPage >= 1)        g_currentPage = savedPage;
      else                           g_currentPage = 1;
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
   ArrayFree(g_stats);
   g_statsCount    = 0;
   g_totalPages    = 1;
   g_totalRecords  = 0;
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
         int  anchor   = isCenter ? ANCHOR_CENTER : ANCHOR_LEFT;

         if(ObjectFind(0, labelName) < 0)
         {
            if(!ObjectCreate(0, labelName, OBJ_LABEL, 0, 0, 0))
            {
               Print("错误：创建标签 ", labelName);
               continue;
            }
            ObjectSet(labelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSet(labelName, OBJPROP_ANCHOR, anchor);
            ObjectSet(labelName, OBJPROP_BACK, false);
            ObjectSet(labelName, OBJPROP_COLOR, Black);
            ObjectSet(labelName, OBJPROP_FONTSIZE, 8);
            ObjectSetString(0, labelName, OBJPROP_FONT, "Microsoft YaHei UI");
         }
         else
            ObjectSet(labelName, OBJPROP_ANCHOR, anchor);

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
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_BGCOLOR, 0xB48246);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_COLOR, 0xFFFFFF);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_BORDER_COLOR, 0xBEB4B4);
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
   bool visible    = g_panelVisible;
   bool hiddenFlag = !visible;
   int  hiddenX    = -10000;

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
// 按当前持仓实时统计
//+------------------------------------------------------------------+
void ProcessOrderData()
{
   // 在刷新前先保存上一轮的“历史最大浮亏 / 浮盈”
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

   InitializeStats();

   int total = OrdersTotal();
   for(int i = 0; i < total; i++)
   {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;

      int    type   = OrderType();
      if(type != OP_BUY && type != OP_SELL) continue;

      string sym    = OrderSymbol();
      double lots   = OrderLots();
      double profit = OrderProfit() + OrderSwap() + OrderCommission(); // 浮动盈亏
      double price  = OrderOpenPrice();

      int idx = FindOrCreateSymbolIndex(sym);
      if(idx < 0) continue;

      // 统计多空（当前时刻的合计）
      if(type == OP_BUY)
      {
         g_stats[idx].buyCount++;
         g_stats[idx].buyLots   += lots;
         g_stats[idx].buyProfit += profit;
         g_stats[idx].buyPriceSum += price * lots;
      }
      else if(type == OP_SELL)
      {
         g_stats[idx].sellCount++;
         g_stats[idx].sellLots   += lots;
         g_stats[idx].sellProfit += profit;
         g_stats[idx].sellPriceSum += price * lots;
      }
   }

   // 合计当前时刻每个品种的总手数 / 总浮盈亏，并更新历史极值
   for(int k = 0; k < g_statsCount; k++)
   {
      g_stats[k].totalLots   = g_stats[k].buyLots + g_stats[k].sellLots;
      g_stats[k].totalProfit = g_stats[k].buyProfit + g_stats[k].sellProfit;

      // 找到该品种上一轮的历史记录（本次指标运行内）
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

      // 叠加全局变量中的历史记录（跨周期 / 跨图表记忆，仅在该品种仍有持仓时保留）
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

      // 历史最大浮亏：以“合计总浮盈亏”为基准，记录绝对值最大的负数
      double curTotal = g_stats[k].totalProfit;
      double newLoss  = oldLoss;
      if(curTotal < 0.0 && (oldLoss == 0.0 || curTotal < oldLoss))
         newLoss = curTotal;
      g_stats[k].maxFloatLoss = newLoss;

      // 历史最大浮盈：以“合计总浮盈亏”为基准，记录最大的正数
      double newProfit = oldProfit;
      if(curTotal > 0.0 && curTotal > oldProfit)
         newProfit = curTotal;
      g_stats[k].maxFloatProfit = newProfit;

      // 将最新的历史极值写回全局变量（仅对当前仍有持仓的品种）
      GlobalVariableSet(glLossKey,   g_stats[k].maxFloatLoss);
      GlobalVariableSet(glProfitKey, g_stats[k].maxFloatProfit);

      // 计算成本价（按手数加权）
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

   // 如果某个品种已经没有任何持仓，则清除其历史最大浮亏 / 浮盈的全局变量记录
   int gvTotal = GlobalVariablesTotal();
   string lossPrefix   = GV_PREFIX + "MaxLoss_";
   string profitPrefix = GV_PREFIX + "MaxProfit_";
   int lossLen   = StringLen(lossPrefix);
   int profitLen = StringLen(profitPrefix);

   for(int gi = gvTotal - 1; gi >= 0; gi--)
   {
      string name = GlobalVariableName(gi);

      // 处理 MaxLoss_ 记录
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

      // 处理 MaxProfit_ 记录
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
int FindOrCreateSymbolIndex(string symbol)
{
   for(int i = 0; i < g_statsCount; i++)
   {
      if(g_stats[i].symbol == symbol)
         return i;
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

   return newIdx;
}

//+------------------------------------------------------------------+
// 按合计浮动盈亏从大到小排序
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
            // 盈利排序：从大到小
            if(g_stats[j].totalProfit < g_stats[j + 1].totalProfit)
               needSwap = true;
            else if(g_stats[j].totalProfit == g_stats[j + 1].totalProfit && g_stats[j].symbol > g_stats[j + 1].symbol)
               needSwap = true;
         }
         else // SORT_FLOAT_LOSS
         {
            // 浮亏排序：从小到大（更负的在前面）
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

   int buttonY     = paginationY;
   int buttonX     = paginationX + 380;
   int buttonWidth = 50;
   int buttonHeight= 22;
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
      ObjectSet(name, OBJPROP_BGCOLOR, 0xB48246);
      ObjectSet(name, OBJPROP_COLOR, 0xFFFFFF);
      ObjectSet(name, OBJPROP_BORDER_COLOR, 0xBEB4B4);
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
   int endIndex   = MathMin(startIndex + PAGE_SIZE, g_statsCount);

   string todayStr = GetBeijingTimeString();
   double accProfit     = AccountProfit();
   double accBalance    = AccountBalance();
   double accEquity     = AccountEquity();
   color  accProfitColor = (accProfit >= 0.0 ? ProfitColor : LossColor);

   // 账户层面：统计总多/空单数量与手数
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

         // 合计单量（多单数量 + 空单数量）
         UpdateCellText(row, 9, IntegerToString(st.buyCount + st.sellCount));

         // 合计
         UpdateCellText(row,10, DoubleToString(st.totalLots, 2));
         color totalClr = (st.totalProfit >= 0.0 ? ProfitColor : LossColor);
         UpdateCellText(row,11, DoubleToString(st.totalProfit, 2), totalClr);

         // 最大浮亏 / 最大浮盈
         UpdateCellText(row,12, DoubleToString(st.maxFloatLoss, 2), (st.maxFloatLoss <= 0.0 ? LossColor : ProfitColor));
         UpdateCellText(row,13, DoubleToString(st.maxFloatProfit, 2), (st.maxFloatProfit >= 0.0 ? ProfitColor : LossColor));

         // 成本价（按手数加权）
         int digits = (int)MarketInfo(st.symbol, MODE_DIGITS);
         if(digits < 0)
            digits = Digits;
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

      // 第1行：账户盈亏 / 余额 / 净值
      if(row == 1)
      {
         UpdateCellText(row,17, DoubleToString(accProfit, 2), accProfitColor);
         UpdateCellText(row,18, DoubleToString(accBalance, 2));
         UpdateCellText(row,19, DoubleToString(accEquity, 2));
      }
      // 第2行：分隔线（1）
      else if(row == 2)
      {
         UpdateCellText(row,17, "=====");
         UpdateCellText(row,18, "=====");
         UpdateCellText(row,19, "=====");
      }
      // 第3行：账户总多/空单量 标题
      else if(row == 3)
      {
         UpdateCellText(row,17, "总多单量");
         UpdateCellText(row,18, "总空单量");
         UpdateCellText(row,19, "总单量");
      }
      // 第4行：账户总多/空单量 数值
      else if(row == 4)
      {
         UpdateCellText(row,17, IntegerToString(accTotalBuyCount));
         UpdateCellText(row,18, IntegerToString(accTotalSellCount));
         UpdateCellText(row,19, IntegerToString(accTotalOrderCount));
      }
      // 第5行：账户总多/空手数 标题
      else if(row == 5)
      {
         UpdateCellText(row,17, "总多单手数");
         UpdateCellText(row,18, "总空单手数");
         UpdateCellText(row,19, "总手数");
      }
      // 第6行：账户总多/空手数 数值
      else if(row == 6)
      {
         UpdateCellText(row,17, DoubleToString(accTotalBuyLots, 2));
         UpdateCellText(row,18, DoubleToString(accTotalSellLots, 2));
         UpdateCellText(row,19, DoubleToString(accTotalLots, 2));
      }
      // 第7行：分隔线（2）
      else if(row == 7)
      {
         UpdateCellText(row,17, "=====");
         UpdateCellText(row,18, "=====");
         UpdateCellText(row,19, "=====");
      }
      // 第8行：格数 / 量化 / 编程
      else if(row == 8)
      {
         UpdateCellText(row,17, "格数");
         UpdateCellText(row,18, "量化");
         UpdateCellText(row,19, "编程");
      }
      // 第9行：微信号
      else if(row == 9)
      {
         UpdateCellText(row,17, "微信号：");
         UpdateCellText(row,18, "1581187");
         UpdateCellText(row,19, "5342");
      }
      // 第10行：QQ
      else if(row == 10)
      {
         UpdateCellText(row,17, "QQ号：");
         UpdateCellText(row,18, "106231");
         UpdateCellText(row,19, "2168");
      }
      // 其余行保留行列占位，方便以后扩展（当前不会走到）
      else
      {
         string rcText;
         rcText = "行列" + IntegerToString(row) + IntegerToString(17);
         UpdateCellText(row,17, rcText);
         rcText = "行列" + IntegerToString(row) + IntegerToString(18);
         UpdateCellText(row,18, rcText);
         rcText = "行列" + IntegerToString(row) + IntegerToString(19);
         UpdateCellText(row,19, rcText);
      }
   }
}

//+------------------------------------------------------------------+
void UpdateCellText(int row, int col, string text, color clr)
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

   if(sparam == btnFirst)      { g_currentPage = 1;           UpdatePagination(); UpdateGridData(); }
   else if(sparam == btnPrev)  { if(g_currentPage > 1)        { g_currentPage--; UpdatePagination(); UpdateGridData(); } }
   else if(sparam == btnNext)  { if(g_currentPage < g_totalPages) { g_currentPage++; UpdatePagination(); UpdateGridData(); } }
   else if(sparam == btnLast)  { g_currentPage = g_totalPages; UpdatePagination(); UpdateGridData(); }

   if(ObjectFind(0, sparam) >= 0)
      ObjectSet(sparam, OBJPROP_STATE, false);
   ChartRedraw(0);
}
//+------------------------------------------------------------------+