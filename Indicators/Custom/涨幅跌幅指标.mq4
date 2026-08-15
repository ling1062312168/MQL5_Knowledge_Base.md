//+------------------------------------------------------------------+
//|                                                   涨幅跌幅指标.mq4 |
//|                     11行×10列网格面板（UI + 分页 + 涨跌幅%）         |
//+------------------------------------------------------------------+
#property strict
#property version   "1.10"
//--- 网格配置
#define GRID_ROWS  11
#define GRID_COLS  11
#define GRID_TOTAL (GRID_ROWS * GRID_COLS)
//--- 对象名称定义
#define CELL_PREFIX       "GridCell_"
#define CELL_LABEL_PREFIX "GridCellTxt_"
#define PANEL_BG_NAME      "GridPanel_BG"
#define PANEL_BORDER_NAME  "GridPanel_Border"
#define TOGGLE_BTN_NAME    "GridPanel_ToggleBtn"
#define PAGINATION_PREFIX  "GridPagination_"
#define PAGE_SIZE          10
//--- 输入参数：面板位置
input int   PanelX = 20;      // 面板左上角X偏移
input int   PanelY = 20;      // 面板左上角Y偏移
//--- 输入参数：面板外观
input group "=== 面板外观 ==="
input color PanelBgColor     = C'245, 245, 250';  // 面板背景色
input color PanelBorderColor = C'180, 180, 190';  // 面板边框色
input int   PanelPadding     = 5;                 // 内边距（像素）
//--- 输入参数：网格间距
input group "=== 网格间距 ==="
input int CellGapX = 2;
input int CellGapY = 2;
//--- 输入参数：单元格样式
input group "=== 网格单元格样式 ==="
input int   CellFontSize = 8;
input color CellBgColor1 = C'230, 235, 245';      // 奇数行
input color CellBgColor2 = C'220, 225, 240';      // 偶数行
input color CellBorderColor = C'200, 200, 210';   // 单元格边框色
//--- 输入参数：每列宽度（11列）
input group "=== 每列宽度设置（列1-11） ==="
input int Col1Width  = 35;
input int Col2Width  = 120;
input int Col3Width  = 65;
input int Col4Width  = 85;
input int Col5Width  = 60;
input int Col6Width  = 60;
input int Col7Width  = 60;
input int Col8Width  = 60;
input int Col9Width  = 60;
input int Col10Width = 60;
input int Col11Width = 60;
//--- 输入参数：每行高度（11行）
input group "=== 每行高度设置（行1-11） ==="
input int Row1Height  = 24;  // 表头
input int Row2Height  = 24;
input int Row3Height  = 24;
input int Row4Height  = 24;
input int Row5Height  = 24;
input int Row6Height  = 24;
input int Row7Height  = 24;
input int Row8Height  = 24;
input int Row9Height  = 24;
input int Row10Height = 24;
input int Row11Height = 24;
//--- 输入参数：每列文本水平居中（11列）
input group "=== 每列文本水平居中设置（列1-11） ==="
input bool Col1Center  = true;
input bool Col2Center  = true;
input bool Col3Center  = true;
input bool Col4Center  = true;
input bool Col5Center  = true;
input bool Col6Center  = true;
input bool Col7Center  = true;
input bool Col8Center  = true;
input bool Col9Center  = true;
input bool Col10Center = true;
input bool Col11Center = true;
//--- 输入参数：统计设置
input group "=== 统计设置 ==="
input string InpSymbols       = "XAUUSD,EURUSD,GBPUSD,AUDUSD,USDCHF,USDJPY"; // 多品种（逗号/分号/空格分隔）
input int    RefreshInterval  = 5;                // 刷新间隔（秒）
input bool   AutoRefresh      = true;             // 自动刷新
input color  ProfitColor      = clrRed;     // 涨色
input color  LossColor        = clrLimeGreen;           // 跌色
input color  PaginationTextColor = clrBlack;      // 分页信息文本颜色
//--- 数据结构：每个品种的当前涨跌幅（相对昨收）
struct SymRec
{
   string   sym; // 品种
   double   pct; // 涨跌幅%
};
//--- 全局变量
bool     g_panelVisible = true;
int      g_colWidths[GRID_COLS];
int      g_rowHeights[GRID_ROWS];
bool     g_colCenter[GRID_COLS];
SymRec   g_records[];
int      g_totalRecords = 0;
int      g_currentPage  = 1;
int      g_totalPages   = 1;
datetime g_lastUpdate   = 0;
//--- 表头（11列）
string g_row1Labels[GRID_COLS] =
{
   "序号", "当前时间", "品种", "涨跌幅%", "M5", "M15", "M30", "1H", "4H", "D1", "W1"
};
//--- 前向声明
void InitializeGridSizes();
bool CreatePanel();
void CreateCellRect(string name, int x, int y, int w, int h, color bgColor, color borderColor);
void CreateGridCells();
void CreateToggleButton();
void UpdatePanelVisibility();
void DeletePanel();
void ProcessData(); // 兼容旧名字：现在统计多品种当前涨跌幅
void UpdatePagination();
void UpdateGridData();
void UpdateCellText(int row, int col, string text, color clr);
void CreatePaginationButton(string name, string text, int x, int y, int width, int height);
void SetObjVisible(const string name, const bool visible);
int  BuildSymbolList(string src, string &outSyms[]);
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   InitializeGridSizes();
   if(!CreatePanel())
   {
      Print("错误：创建网格面板失败");
      return(INIT_FAILED);
   }
   ProcessData();
   UpdatePagination();
   UpdateGridData();
   if(AutoRefresh)
      EventSetTimer(MathMax(1, RefreshInterval));
   Print("涨幅跌幅指标EA已启动：", InpSymbols, "（当前行情 vs 昨收） 网格 ", GRID_ROWS, "x", GRID_COLS);
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason)
{
   EventKillTimer();
   DeletePanel();
   ChartRedraw();
}
void OnTick()
{
   // 数据刷新由 OnTimer 完成
}
void OnTimer()
{
   if(!AutoRefresh)
      return;
   datetime now = TimeCurrent();
   if(g_lastUpdate != 0 && (now - g_lastUpdate) < RefreshInterval)
      return;
   g_lastUpdate = now;
   int savedPage = g_currentPage;
   ProcessData();
   if(savedPage < 1) savedPage = 1;
   if(savedPage > g_totalPages) savedPage = g_totalPages;
   g_currentPage = savedPage;
   UpdatePagination();
   UpdateGridData();
   ChartRedraw();
}
//+------------------------------------------------------------------+
//| 数据处理：统计多品种当前涨跌幅%（相对昨收）                       |
//| pct = (Bid - D1昨日收盘) / D1昨日收盘 * 100                        |
//+------------------------------------------------------------------+
void ProcessData()
{
   string syms[];
   int nSyms = BuildSymbolList(InpSymbols, syms);
   if(nSyms <= 0)
   {
      g_totalRecords = 0;
      g_totalPages   = 1;
      ArrayResize(g_records, 0);
      return;
   }

   ArrayResize(g_records, nSyms);
   g_totalRecords = nSyms;

   for(int i = 0; i < nSyms; i++)
   {
      string sym = syms[i];
      g_records[i].sym = sym;

      double prevClose = iClose(sym, PERIOD_D1, 1); // 昨日收盘
      double curBid    = MarketInfo(sym, MODE_BID);
      if(curBid <= 0.0)
      {
         // MT4 环境下无 MODE_LAST：用 ASK 或 M1 最新收盘兜底
         double ask = MarketInfo(sym, MODE_ASK);
         if(ask > 0.0)
            curBid = ask;
         else
            curBid = iClose(sym, PERIOD_M1, 0);
      }

      if(prevClose > 0.0 && curBid > 0.0)
         g_records[i].pct = (curBid - prevClose) / prevClose * 100.0;
      else
         g_records[i].pct = 0.0;
   }

   g_totalPages = (g_totalRecords > 0) ? (int)MathCeil((double)g_totalRecords / PAGE_SIZE) : 1;
   if(g_totalPages < 1) g_totalPages = 1;
}

// 解析多品种字符串：逗号/分号/空格/换行分隔，去空，去重（保序）
int BuildSymbolList(string src, string &outSyms[])
{
   string s = src;
   StringReplace(s, ";", ",");
   StringReplace(s, "\r", ",");
   StringReplace(s, "\n", ",");
   StringReplace(s, "\t", ",");
   StringReplace(s, " ", ",");

   string parts[];
   int n = StringSplit(s, ',', parts);
   if(n <= 0)
   {
      ArrayResize(outSyms, 0);
      return 0;
   }

   ArrayResize(outSyms, 0);
   int outN = 0;
   for(int i = 0; i < n; i++)
   {
      string sym = StringTrimLeft(StringTrimRight(parts[i]));
      if(sym == "")
         continue;

      // 去重（保序）
      bool exists = false;
      for(int j = 0; j < outN; j++)
      {
         if(outSyms[j] == sym) { exists = true; break; }
      }
      if(exists) continue;

      // 允许不在市场报价窗口也能取价（若失败 pct 会=0）
      SymbolSelect(sym, true);

      outN++;
      ArrayResize(outSyms, outN);
      outSyms[outN - 1] = sym;
   }
   return outN;
}
//+------------------------------------------------------------------+
//| 初始化网格尺寸                                                   |
//+------------------------------------------------------------------+
void InitializeGridSizes()
{
   g_colWidths[0] = Col1Width;
   g_colWidths[1] = Col2Width;
   g_colWidths[2] = Col3Width;
   g_colWidths[3] = Col4Width;
   g_colWidths[4] = Col5Width;
   g_colWidths[5] = Col6Width;
   g_colWidths[6] = Col7Width;
   g_colWidths[7] = Col8Width;
   g_colWidths[8] = Col9Width;
   g_colWidths[9] = Col10Width;
   g_colWidths[10] = Col11Width;
   g_rowHeights[0]  = Row1Height;
   g_rowHeights[1]  = Row2Height;
   g_rowHeights[2]  = Row3Height;
   g_rowHeights[3]  = Row4Height;
   g_rowHeights[4]  = Row5Height;
   g_rowHeights[5]  = Row6Height;
   g_rowHeights[6]  = Row7Height;
   g_rowHeights[7]  = Row8Height;
   g_rowHeights[8]  = Row9Height;
   g_rowHeights[9]  = Row10Height;
   g_rowHeights[10] = Row11Height;
   g_colCenter[0] = Col1Center;
   g_colCenter[1] = Col2Center;
   g_colCenter[2] = Col3Center;
   g_colCenter[3] = Col4Center;
   g_colCenter[4] = Col5Center;
   g_colCenter[5] = Col6Center;
   g_colCenter[6] = Col7Center;
   g_colCenter[7] = Col8Center;
   g_colCenter[8] = Col9Center;
   g_colCenter[9] = Col10Center;
   g_colCenter[10] = Col11Center;
}
//+------------------------------------------------------------------+
//| 创建面板（背景 + 网格单元 + 按钮）                               |
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
   int paginationHeight = 22;
   int paginationSpacing = 5 + pad;
   int totalPanelHeight = totalHeight + paginationSpacing + paginationHeight;
   // 外边框
   CreateCellRect(PANEL_BORDER_NAME,
                  PanelX - (pad + 2),
                  PanelY - (pad + 2),
                  totalWidth + (pad + 2) * 2,
                  totalPanelHeight + (pad + 2) * 2,
                  PanelBorderColor,
                  PanelBorderColor);
   // 内背景
   CreateCellRect(PANEL_BG_NAME,
                  PanelX - pad,
                  PanelY - pad,
                  totalWidth + pad * 2,
                  totalPanelHeight + pad * 2,
                  PanelBgColor,
                  PanelBorderColor);
   CreateGridCells();
   CreateToggleButton();
   UpdatePanelVisibility();
   ChartRedraw();
   return(true);
}
void CreateCellRect(string name, int x, int y, int w, int h, color bgColor, color borderColor)
{
   if(ObjectFind(name) < 0)
   {
      if(!ObjectCreate(name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
         return;
      ObjectSet(name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSet(name, OBJPROP_SELECTABLE, false);
      ObjectSet(name, OBJPROP_BACK, false);
      ObjectSet(name, OBJPROP_HIDDEN, false);
   }
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
   ObjectSet(name, OBJPROP_XSIZE, w);
   ObjectSet(name, OBJPROP_YSIZE, h);
   ObjectSet(name, OBJPROP_BGCOLOR, bgColor);
   ObjectSet(name, OBJPROP_COLOR, borderColor);
   ObjectSet(name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSet(name, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
}
void CreateGridCells()
{
   int index = 0;
   for(int row = 0; row < GRID_ROWS; row++)
   {
      for(int col = 0; col < GRID_COLS; col++)
      {
         index++;
         int x = PanelX;
         for(int c = 0; c < col; c++)
            x += g_colWidths[c] + CellGapX;
         int y = PanelY;
         for(int r = 0; r < row; r++)
            y += g_rowHeights[r] + CellGapY;
         string cellName = CELL_PREFIX + IntegerToString(row + 1) + "_" + IntegerToString(col + 1);
         color bg = (row % 2 == 0 ? CellBgColor1 : CellBgColor2);
         if(ObjectFind(cellName) < 0)
         {
            if(!ObjectCreate(cellName, OBJ_RECTANGLE_LABEL, 0, 0, 0))
               continue;
            ObjectSet(cellName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSet(cellName, OBJPROP_SELECTABLE, false);
            ObjectSet(cellName, OBJPROP_BACK, false);
            ObjectSet(cellName, OBJPROP_HIDDEN, false);
         }
         ObjectSet(cellName, OBJPROP_XDISTANCE, x);
         ObjectSet(cellName, OBJPROP_YDISTANCE, y);
         ObjectSet(cellName, OBJPROP_XSIZE, g_colWidths[col]);
         ObjectSet(cellName, OBJPROP_YSIZE, g_rowHeights[row]);
         ObjectSet(cellName, OBJPROP_BGCOLOR, bg);
         ObjectSet(cellName, OBJPROP_COLOR, CellBorderColor);
         ObjectSet(cellName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
         ObjectSet(cellName, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
         string labelName = CELL_LABEL_PREFIX + IntegerToString(index);
         string labelText = "";
         if(row == 0)
         {
            labelText = g_row1Labels[col];
         }
         else
         {
            if(col == 0) labelText = IntegerToString(row);
            else if(col >= 4) labelText = "";
            else labelText = "-";
         }
         if(ObjectFind(labelName) < 0)
         {
            if(!ObjectCreate(labelName, OBJ_LABEL, 0, 0, 0))
               continue;
            ObjectSet(labelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
         }
         if(g_colCenter[col])
         {
            ObjectSet(labelName, OBJPROP_ANCHOR, ANCHOR_CENTER);
            ObjectSet(labelName, OBJPROP_XDISTANCE, x + g_colWidths[col] / 2);
         }
         else
         {
            ObjectSet(labelName, OBJPROP_ANCHOR, ANCHOR_LEFT);
            ObjectSet(labelName, OBJPROP_XDISTANCE, x + 5);
         }
         ObjectSet(labelName, OBJPROP_YDISTANCE, y + g_rowHeights[row] / 2);
         ObjectSetText(labelName, labelText, CellFontSize, "Arial", clrBlack);
         ObjectSet(labelName, OBJPROP_HIDDEN, false);
         ObjectSet(labelName, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
      }
   }
}
void CreateToggleButton()
{
   string buttonText = g_panelVisible ? "隐藏" : "展开";
   if(ObjectFind(TOGGLE_BTN_NAME) < 0)
   {
      if(!ObjectCreate(TOGGLE_BTN_NAME, OBJ_BUTTON, 0, 0, 0))
         return;
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_XDISTANCE, 20);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_YDISTANCE, 20);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_XSIZE, 80);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_YSIZE, 22);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_SELECTABLE, true);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_HIDDEN, false);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_COLOR, C'70,130,180');
   }
   ObjectSetText(TOGGLE_BTN_NAME, buttonText, 9, "Arial", clrWhite);
   ObjectSet(TOGGLE_BTN_NAME, OBJPROP_HIDDEN, false);
   ObjectSet(TOGGLE_BTN_NAME, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
}
void UpdatePanelVisibility()
{
   bool visible    = g_panelVisible;
   bool hiddenFlag = !visible;
   int  hiddenX    = -10000;

   // 背景与边框：隐藏时整体移出屏幕
   if(ObjectFind(PANEL_BORDER_NAME) >= 0)
   {
      int pad = MathMax(0, PanelPadding);
      ObjectSet(PANEL_BORDER_NAME, OBJPROP_XDISTANCE, visible ? (PanelX - (pad + 2)) : hiddenX);
      ObjectSet(PANEL_BORDER_NAME, OBJPROP_YDISTANCE, PanelY - (pad + 2));
      ObjectSet(PANEL_BORDER_NAME, OBJPROP_HIDDEN, hiddenFlag);
   }
   if(ObjectFind(PANEL_BG_NAME) >= 0)
   {
      int pad2 = MathMax(0, PanelPadding);
      ObjectSet(PANEL_BG_NAME, OBJPROP_XDISTANCE, visible ? (PanelX - pad2) : hiddenX);
      ObjectSet(PANEL_BG_NAME, OBJPROP_YDISTANCE, PanelY - pad2);
      ObjectSet(PANEL_BG_NAME, OBJPROP_HIDDEN, hiddenFlag);
   }

   // 网格单元与文字：隐藏时移出屏幕，显示时恢复坐标
   int index = 0;
   for(int row = 0; row < GRID_ROWS; row++)
   {
      for(int col = 0; col < GRID_COLS; col++)
      {
         index++;
         int x = PanelX;
         for(int c = 0; c < col; c++)
            x += g_colWidths[c] + CellGapX;
         int y = PanelY;
         for(int r = 0; r < row; r++)
            y += g_rowHeights[r] + CellGapY;

         string cellName = CELL_PREFIX + IntegerToString(row + 1) + "_" + IntegerToString(col + 1);
         if(ObjectFind(cellName) >= 0)
         {
            ObjectSet(cellName, OBJPROP_XDISTANCE, visible ? x : hiddenX);
            ObjectSet(cellName, OBJPROP_YDISTANCE, y);
            ObjectSet(cellName, OBJPROP_HIDDEN, hiddenFlag);
         }

         string labelName = CELL_LABEL_PREFIX + IntegerToString(index);
         if(ObjectFind(labelName) >= 0)
         {
            int labelX = g_colCenter[col] ? (x + g_colWidths[col] / 2) : (x + 5);
            int labelY = y + g_rowHeights[row] / 2;
            ObjectSet(labelName, OBJPROP_ANCHOR, g_colCenter[col] ? ANCHOR_CENTER : ANCHOR_LEFT);
            ObjectSet(labelName, OBJPROP_XDISTANCE, visible ? labelX : hiddenX);
            ObjectSet(labelName, OBJPROP_YDISTANCE, labelY);
            ObjectSet(labelName, OBJPROP_HIDDEN, hiddenFlag);
         }
      }
   }

   // 分页控件也跟随隐藏/显示
   UpdatePagination();

   // 切换按钮始终可见
   if(ObjectFind(TOGGLE_BTN_NAME) >= 0)
   {
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_HIDDEN, false);
      ObjectSet(TOGGLE_BTN_NAME, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
   }
}
void DeletePanel()
{
   ObjectDelete(PANEL_BG_NAME);
   ObjectDelete(PANEL_BORDER_NAME);
   ObjectDelete(TOGGLE_BTN_NAME);
   ObjectDelete(PAGINATION_PREFIX + "Info");
   ObjectDelete(PAGINATION_PREFIX + "First");
   ObjectDelete(PAGINATION_PREFIX + "Prev");
   ObjectDelete(PAGINATION_PREFIX + "Next");
   ObjectDelete(PAGINATION_PREFIX + "Last");
   for(int row = 0; row < GRID_ROWS; row++)
   {
      for(int col = 0; col < GRID_COLS; col++)
      {
         string cellName = CELL_PREFIX + IntegerToString(row + 1) + "_" + IntegerToString(col + 1);
         ObjectDelete(cellName);
         int idx = row * GRID_COLS + col + 1;
         string labelName = CELL_LABEL_PREFIX + IntegerToString(idx);
         ObjectDelete(labelName);
      }
   }
}
//+------------------------------------------------------------------+
//| 分页控件                                                        |
//+------------------------------------------------------------------+
void UpdatePagination()
{
   // 计算总页数
   g_totalPages = (g_totalRecords > 0) ? (int)MathCeil((double)g_totalRecords / PAGE_SIZE) : 1;
   if(g_totalPages < 1) g_totalPages = 1;
   if(g_currentPage > g_totalPages) g_currentPage = g_totalPages;
   if(g_currentPage < 1) g_currentPage = 1;
   int totalHeight = 0;
   for(int row = 0; row < GRID_ROWS; row++)
   {
      totalHeight += g_rowHeights[row];
      if(row < GRID_ROWS - 1) totalHeight += CellGapY;
   }
   int pad = MathMax(0, PanelPadding);
   int paginationY = PanelY + totalHeight + pad + 5;
   int hiddenX = -10000;
   int paginationX = g_panelVisible ? PanelX : hiddenX;
   string pageText = "当前页 " + IntegerToString(g_currentPage) +
                     " | 总页数 " + IntegerToString(g_totalPages) +
                     " | 记录数 " + IntegerToString(g_totalRecords);
   string labelName = PAGINATION_PREFIX + "Info";
   if(ObjectFind(labelName) < 0)
   {
      ObjectCreate(labelName, OBJ_LABEL, 0, 0, 0);
      ObjectSet(labelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   }
   ObjectSet(labelName, OBJPROP_XDISTANCE, paginationX);
   ObjectSet(labelName, OBJPROP_YDISTANCE, paginationY);
   ObjectSetText(labelName, pageText, 9, "Arial", PaginationTextColor);
   ObjectSet(labelName, OBJPROP_HIDDEN, !g_panelVisible);
   int buttonX = paginationX + 380;
   int buttonY = paginationY;
   int w = 50, h = 22;
   CreatePaginationButton(PAGINATION_PREFIX + "First", "首页", buttonX, buttonY, w, h);
   CreatePaginationButton(PAGINATION_PREFIX + "Prev",  "上页", buttonX + (w + 5) * 1, buttonY, w, h);
   CreatePaginationButton(PAGINATION_PREFIX + "Next",  "下页", buttonX + (w + 5) * 2, buttonY, w, h);
   CreatePaginationButton(PAGINATION_PREFIX + "Last",  "尾页", buttonX + (w + 5) * 3, buttonY, w, h);
}
void CreatePaginationButton(string name, string text, int x, int y, int width, int height)
{
   if(ObjectFind(name) < 0)
   {
      ObjectCreate(name, OBJ_BUTTON, 0, 0, 0);
      ObjectSet(name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSet(name, OBJPROP_SELECTABLE, true);
   }
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
   ObjectSet(name, OBJPROP_XSIZE, width);
   ObjectSet(name, OBJPROP_YSIZE, height);
   ObjectSet(name, OBJPROP_HIDDEN, !g_panelVisible);
   ObjectSet(name, OBJPROP_COLOR, C'70,130,180');
   ObjectSetText(name, text, 9, "Arial", clrWhite);
}

// 可见性控制：用 TIMEFRAMES=0 真正隐藏（兼容同时设置 HIDDEN）
void SetObjVisible(const string name, const bool visible)
{
   if(ObjectFind(name) < 0)
      return;
   ObjectSet(name, OBJPROP_TIMEFRAMES, visible ? OBJ_ALL_PERIODS : 0);
   ObjectSet(name, OBJPROP_HIDDEN, visible ? false : true);
}
//+------------------------------------------------------------------+
//| 网格填充                                                        |
//+------------------------------------------------------------------+
void UpdateGridData()
{
   int startIndex = (g_currentPage - 1) * PAGE_SIZE;
   for(int row = 1; row <= 10; row++)
   {
      int dataIndex = startIndex + (row - 1);
      if(dataIndex >= 0 && dataIndex < g_totalRecords)
      {
         UpdateCellText(row, 0, IntegerToString(dataIndex + 1), clrBlack);
         string tStr = TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS);
         UpdateCellText(row, 1, tStr, clrBlack);
         UpdateCellText(row, 2, g_records[dataIndex].sym, clrBlack);
         double pct = g_records[dataIndex].pct;
         string sign = (pct >= 0.0) ? "+" : "";
         string pctText = sign + DoubleToString(pct, 2) + "%";
         color pctColor = (pct >= 0.0) ? ProfitColor : LossColor;
         UpdateCellText(row, 3, pctText, pctColor);
         for(int col = 4; col < GRID_COLS; col++)
            UpdateCellText(row, col, "", clrBlack);
      }
      else
      {
         for(int col = 0; col < GRID_COLS; col++)
            UpdateCellText(row, col, "", clrBlack);
      }
   }
}
void UpdateCellText(int row, int col, string text, color clr)
{
   int idx = row * GRID_COLS + col + 1;
   string labelName = CELL_LABEL_PREFIX + IntegerToString(idx);
   if(ObjectFind(labelName) >= 0)
      ObjectSetText(labelName, text, CellFontSize, "Arial", clr);
}
//+------------------------------------------------------------------+
//| ChartEvent: 按钮点击                                             |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id != CHARTEVENT_OBJECT_CLICK)
      return;
   if(sparam == TOGGLE_BTN_NAME)
   {
      g_panelVisible = !g_panelVisible;
      CreateToggleButton();
      UpdatePanelVisibility();
      UpdateGridData();
      ChartRedraw();
      return;
   }
   string btnFirst = PAGINATION_PREFIX + "First";
   string btnPrev  = PAGINATION_PREFIX + "Prev";
   string btnNext  = PAGINATION_PREFIX + "Next";
   string btnLast  = PAGINATION_PREFIX + "Last";
   if(sparam == btnFirst)
      g_currentPage = 1;
   else if(sparam == btnPrev && g_currentPage > 1)
      g_currentPage--;
   else if(sparam == btnNext && g_currentPage < g_totalPages)
      g_currentPage++;
   else if(sparam == btnLast)
      g_currentPage = g_totalPages;
   else
      return;
   UpdatePagination();
   UpdateGridData();
   ChartRedraw();
}
