//+------------------------------------------------------------------+
//|      安全分批对冲EA（多品种监控+盈利保护）MQL5版                  |
//+------------------------------------------------------------------+
#property copyright "MQL5"
#property link      ""
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

// === 安全分批对冲EA参数 ===
input double LossThreshold = 1000;         // 启动对冲的总浮亏阈值
input double MinRemainProfit = 5;          // 当天最小保留盈利（始终保留）
input double MaxProfitConsumeRatio = 0.9;  // 当天盈利最多消耗比例
input double MinHedgeLots = 0.01;          // 每次最小对冲手数
input int    CheckInterval = 30;           // 检测周期（分钟）
input bool   UseMarketClose = true;        // 是否用市价平仓
input bool   EnableAlert = true;           // 是否弹窗提示
input double DailyProfitThreshold = 50;    // 当天盈利阈值
input bool   UseFloatingProfitHedge = false; // 是否开启持单的浮盈金额来对冲
input string CryptoSymbols = "BTCUSDm,ETHUSDm"; // 数字加密货币品种列表（逗号分隔），周六日仅当其中单品种浮亏>阈值才启动对冲
input int    PanelUpdateSeconds = 1;        // 面板与盈利计算刷新间隔（秒），避免高 tick 品种卡盘

datetime lastCheck = 0;
datetime lastPanelUpdate = 0;               // 上次面板/盈利计算时间，用于节流
string   PanelPrefix = "HedgeEA_";         // 面板对象名前缀

// 当日盈利修正
datetime g_LastProfitDate = 0;
double   g_MaxTodayProfit = 0;
string   g_ProfitFileName = "HedgeEA_TodayProfit.txt";

int      g_TradeableTicket = -1;
int      g_ClosedTicket = -1;
string   g_TradeableText = "";
string   g_ClosedText = "";

CTrade         trade;
CPositionInfo  posInfo;

//+------------------------------------------------------------------+
double GetPositionNetProfitByTicket(ulong ticket) {
   if(!posInfo.SelectByTicket(ticket))
      return 0.0;
   return posInfo.Profit() + posInfo.Swap() + posInfo.Commission();
}

//+------------------------------------------------------------------+
double NormalizeVolumeBySymbol(string sym, double lots) {
   double step = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   if(step <= 0) step = MinHedgeLots;
   double minVol = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   if(minVol <= 0) minVol = MinHedgeLots;
   double v = MathFloor(lots / step) * step;
   if(v < minVol || v < MinHedgeLots) return 0.0;
   return NormalizeDouble(v, 2);
}

//+------------------------------------------------------------------+
int ArrayFind(string &arr[], string val) {
   for(int i = 0; i < ArraySize(arr); i++)
      if(arr[i] == val) return i;
   return -1;
}

//+------------------------------------------------------------------+
bool IsWeekend() {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   return (dt.day_of_week == 0 || dt.day_of_week == 6);
}

//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
void CreatePanel() {
   int x = 10, y = 25;
   string name;

   name = PanelPrefix + "Background";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, 5);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, 20);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, 390);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, 175);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'30,35,40');
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, C'60,65,70');
   ObjectSetInteger(0, name, OBJPROP_BACK, false);

   name = PanelPrefix + "Title";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, name, OBJPROP_TEXT, "===== 安全分批对冲 EA =====");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");

   name = PanelPrefix + "Profit";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y + 18);
   ObjectSetString(0, name, OBJPROP_TEXT, "当天盈利: --  |  阈值: --");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");

   name = PanelPrefix + "NextCheck";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y + 36);
   ObjectSetString(0, name, OBJPROP_TEXT, "下一个检测周期【00:30:00】");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrGold);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");

   name = PanelPrefix + "Status";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y + 54);
   ObjectSetString(0, name, OBJPROP_TEXT, "未达到当天盈利阈值");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrYellow);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");

   name = PanelPrefix + "FloatingPool";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y + 72);
   ObjectSetString(0, name, OBJPROP_TEXT, "");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrAqua);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");

   name = PanelPrefix + "MaxLoss";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y + 90);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetString(0, name, OBJPROP_TEXT, "可交易最大净亏: 无");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrOrange);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");

   name = PanelPrefix + "MaxLossTicketLine";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y + 108);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetString(0, name, OBJPROP_TEXT, "");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrOrange);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");

   name = PanelPrefix + "MaxLossClosed";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y + 126);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetString(0, name, OBJPROP_TEXT, "休市品种: 无");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrGray);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");

   name = PanelPrefix + "MaxLossClosedTicketLine";
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y + 144);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetString(0, name, OBJPROP_TEXT, "");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrGray);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");
}

//+------------------------------------------------------------------+
string FormatNextCheckCountdownLine() {
   datetime now = TimeCurrent();
   datetime nextAt = now;
   if(lastCheck > 0)
      nextAt = lastCheck + CheckInterval * 60;
   long secLeft = (long)(nextAt - now);
   if(secLeft < 0) secLeft = 0;
   int h = (int)(secLeft / 3600);
   int m = (int)((secLeft % 3600) / 60);
   int s = (int)(secLeft % 60);
   string tim = StringFormat("%02d:%02d:%02d", h, m, s);
   return "下一个检测周期【" + tim + "】";
}

//+------------------------------------------------------------------+
// 仅当品种可正常交易时返回 true。周末：仅“加密货币列表”内品种可视为可交易，外汇等一律休市
bool IsSymbolTradeable(string sym) {
   if(IsWeekend()) {
      // 周末仅加密货币（参数列表内）算可交易，其余全部归为休市，避免外汇显示在“可交易”
      if(!IsInCryptoSymbols(sym)) return false;
   }
   long mode = SymbolInfoInteger(sym, SYMBOL_TRADE_MODE);
   if(mode == SYMBOL_TRADE_MODE_DISABLED) return false;
   if(mode != SYMBOL_TRADE_MODE_FULL) return false;
   double bid = SymbolInfoDouble(sym, SYMBOL_BID);
   double ask = SymbolInfoDouble(sym, SYMBOL_ASK);
   return (bid > 0 && ask > 0);
}

//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
void UpdatePanel(double todayProfit) {
   string profitText = "当天盈利: " + DoubleToString(todayProfit, 2) + "  |  阈值: " + DoubleToString(DailyProfitThreshold, 2);
   ObjectSetString(0, PanelPrefix + "Title", OBJPROP_TEXT, "===== 安全分批对冲 EA =====");
   ObjectSetString(0, PanelPrefix + "Profit", OBJPROP_TEXT, profitText);
   ObjectSetString(0, PanelPrefix + "NextCheck", OBJPROP_TEXT, FormatNextCheckCountdownLine());
   if(todayProfit < DailyProfitThreshold) {
      ObjectSetString(0, PanelPrefix + "Status", OBJPROP_TEXT, "未达到当天盈利阈值，当前盈利: " + DoubleToString(todayProfit, 2) + "，阈值: " + DoubleToString(DailyProfitThreshold, 2));
      ObjectSetInteger(0, PanelPrefix + "Status", OBJPROP_COLOR, clrYellow);
   } else {
      ObjectSetString(0, PanelPrefix + "Status", OBJPROP_TEXT, "已达当天盈利阈值，可启动对冲");
      ObjectSetInteger(0, PanelPrefix + "Status", OBJPROP_COLOR, clrLime);
   }
   if(UseFloatingProfitHedge) {
      double floatingPool = CalculateTotalFloatingProfitPool();
      ObjectSetString(0, PanelPrefix + "FloatingPool", OBJPROP_TEXT, "当前浮盈池: " + DoubleToString(floatingPool, 2) + "  |  模式: 浮盈对冲");
      ObjectSetInteger(0, PanelPrefix + "FloatingPool", OBJPROP_COLOR, clrAqua);
   } else {
      ObjectSetString(0, PanelPrefix + "FloatingPool", OBJPROP_TEXT, "模式: 当天盈利对冲");
      ObjectSetInteger(0, PanelPrefix + "FloatingPool", OBJPROP_COLOR, clrSilver);
   }

   string tradeableText;
   long tradeableTicket;
   GetMaxFloatingLossOrderInfo(tradeableText, tradeableTicket);
   g_TradeableTicket = (int)tradeableTicket;
   g_TradeableText = tradeableTicket >= 0 ? tradeableText + " 订单号：" + IntegerToString((int)tradeableTicket) : tradeableText;
   ObjectSetString(0, PanelPrefix + "MaxLoss", OBJPROP_TEXT, tradeableText);
   ObjectSetString(0, PanelPrefix + "MaxLossTicketLine", OBJPROP_TEXT, tradeableTicket >= 0 ? "订单号：" + IntegerToString((int)tradeableTicket) : "");

   string closedText;
   long closedTicket;
   GetMaxFloatingLossOrderInfoClosedMarket(closedText, closedTicket);
   g_ClosedTicket = (int)closedTicket;
   g_ClosedText = closedTicket >= 0 ? closedText + " 订单号：" + IntegerToString((int)closedTicket) : closedText;
   ObjectSetString(0, PanelPrefix + "MaxLossClosed", OBJPROP_TEXT, closedText);
   if(closedTicket >= 0) {
      ObjectSetString(0, PanelPrefix + "MaxLossClosedTicketLine", OBJPROP_TEXT, "订单号：" + IntegerToString((int)closedTicket));
      ObjectSetInteger(0, PanelPrefix + "MaxLossClosedTicketLine", OBJPROP_COLOR, clrGray);
   } else {
      ObjectSetString(0, PanelPrefix + "MaxLossClosedTicketLine", OBJPROP_TEXT, "（无可平仓的休市持仓）");
      ObjectSetInteger(0, PanelPrefix + "MaxLossClosedTicketLine", OBJPROP_COLOR, clrGray);
   }

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
void DeletePanel() {
   ObjectDelete(0, PanelPrefix + "Background");
   ObjectDelete(0, PanelPrefix + "Title");
   ObjectDelete(0, PanelPrefix + "Profit");
   ObjectDelete(0, PanelPrefix + "NextCheck");
   ObjectDelete(0, PanelPrefix + "Status");
   ObjectDelete(0, PanelPrefix + "FloatingPool");
   ObjectDelete(0, PanelPrefix + "MaxLoss");
   ObjectDelete(0, PanelPrefix + "MaxLossTicketLine");
   ObjectDelete(0, PanelPrefix + "MaxLossClosed");
   ObjectDelete(0, PanelPrefix + "MaxLossClosedTicketLine");
}

//+------------------------------------------------------------------+
int OnInit() {
   trade.SetExpertMagicNumber(0);
   trade.SetDeviationInPoints(50);
   Print("安全分批对冲EA(MQL5)已启动");
   LoadMaxTodayProfit();
   CreatePanel();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   DeletePanel();
}

//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam) {
   if(id != CHARTEVENT_OBJECT_CLICK) return;
   if((sparam == PanelPrefix + "MaxLoss" || sparam == PanelPrefix + "MaxLossTicketLine") && g_TradeableTicket >= 0)
      Alert(g_TradeableText);
   if((sparam == PanelPrefix + "MaxLossClosed" || sparam == PanelPrefix + "MaxLossClosedTicketLine") && g_ClosedTicket >= 0)
      Alert(g_ClosedText);
}

//+------------------------------------------------------------------+
void OnTick() {
   // 节流：高 tick 品种（如 BTC）每 tick 都跑历史+面板会导致卡盘，仅按间隔刷新
   datetime now = TimeCurrent();
   int updateSec = (PanelUpdateSeconds < 1) ? 1 : PanelUpdateSeconds;
   if(now - lastPanelUpdate >= updateSec) {
      lastPanelUpdate = now;
      double todayProfit = CalculateTodayProfit();
      UpdatePanel(todayProfit);

      if(now - lastCheck >= CheckInterval * 60) {
         lastCheck = now;

         if(todayProfit < DailyProfitThreshold) {
            Print("未达到当天盈利阈值，当前盈利: ", todayProfit, "，阈值: ", DailyProfitThreshold);
            return;
         }

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
         if(profitBase <= MinRemainProfit || maxProfitConsume <= 0) {
            if(UseFloatingProfitHedge)
               Print("浮盈池不足，暂停对冲。当前浮盈池=", profitBase, "，最小保留盈利=", MinRemainProfit);
            else
               Print("盈利不足，暂停对冲。当天盈利=", todayProfit, "，最小保留盈利=", MinRemainProfit);
            return;
         }

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

         if(ticket == 0 || maxLoss >= 0) {
            Print("当前可交易品种中无浮亏单可平，本周期跳过。");
            break;
         }

         // === 智能计算本次对冲手数 ===
         double lossNeed = totalFloatingLoss - LossThreshold;
         if(lossNeed < 0) lossNeed = 0;

         double lotsByProfit    = 0.0;
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

         if(hedgeLots <= 0.0) {
            Print("可用于本次对冲的盈利或浮亏不足，本周期跳过。");
            break;
         }

         hedgeLots = NormalizeVolumeBySymbol(maxSymbol, hedgeLots);

         if(hedgeLots < MinHedgeLots) {
            Print("智能计算后的对冲手数小于最小对冲手数，本周期跳过。");
            break;
         }

         double profitConsume = hedgeLots * (-maxLoss / orderLots);

         if(AccountInfoDouble(ACCOUNT_BALANCE) <= 1.0) {
            Print("对冲过程中余额不足1美金，停止操作");
            break;
         }

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

            if(profitTicket == 0 || maxProfit <= 0 || profitOrderLots <= 0) {
               Print("未找到可交易的浮盈单用于对冲，本周期跳过。");
               break;
            }

            double lossMoneyPerLot = (-maxLoss / orderLots);
            double profitMoneyPerLot = (maxProfit / profitOrderLots);
            if(lossMoneyPerLot <= 0 || profitMoneyPerLot <= 0) {
               Print("金额换算失败，本周期跳过。");
               break;
            }

            double profitCloseLots = NormalizeVolumeBySymbol(profitSymbol, profitConsume / profitMoneyPerLot);
            if(profitCloseLots <= 0) {
               Print("浮盈单可平仓手数不足（步进或最小手数限制），本周期跳过。");
               break;
            }

            // 按浮盈单实际可释放金额回算亏损单手数，避免亏损侧超过盈利侧释放
            double profitReleaseMoney = profitCloseLots * profitMoneyPerLot;
            hedgeLots = NormalizeVolumeBySymbol(maxSymbol, MathMin(hedgeLots, profitReleaseMoney / lossMoneyPerLot));
            if(hedgeLots <= 0) {
               Print("亏损单可平仓手数不足（步进或最小手数限制），本周期跳过。");
               break;
            }

            profitConsume = hedgeLots * lossMoneyPerLot;
            profitCloseLots = NormalizeVolumeBySymbol(profitSymbol, profitConsume / profitMoneyPerLot);
            if(profitCloseLots <= 0) {
               Print("浮盈单最终可平仓手数不足，本周期跳过。");
               break;
            }

            bool closeProfitOK = trade.PositionClosePartial((ulong)profitTicket, profitCloseLots, 50);
            if(!closeProfitOK) {
               Print("浮盈单对冲失败，订单号：", profitTicket);
               break;
            }

            bool closeLossOK = trade.PositionClosePartial((ulong)ticket, hedgeLots, 50);
            if(closeLossOK) {
               if(EnableAlert) {
                  string lossDirStr = (orderType == POSITION_TYPE_SELL) ? "空单" : "多单";
                  string profitDirStr = (profitOrderType == POSITION_TYPE_SELL) ? "空单" : "多单";
                  Alert("已启用浮盈对冲：先平浮盈单 " + profitSymbol + " " + profitDirStr + " " + DoubleToString(profitCloseLots, 2) + "手，再平亏损单 " +
                        maxSymbol + " " + lossDirStr + " " + DoubleToString(hedgeLots, 2) + "手，已覆盖亏损金额≈" + DoubleToString(-profitConsume, 2) + "$");
               }
               remainProfitConsume -= profitConsume;
               totalFloatingLoss = CalculateTotalFloatingLoss();
            } else {
               Print("亏损单对冲失败，订单号：", ticket, "（浮盈单已执行部分平仓）");
               break;
            }
         } else if(trade.PositionClosePartial((ulong)ticket, hedgeLots, 50)) {
            if(EnableAlert) {
               string dirStr = (orderType == POSITION_TYPE_SELL) ? "空单" : "多单";
               double remainLots = orderLots - hedgeLots;
               double remainTodayProfit = CalculateTodayProfit();
               Alert(maxSymbol + "最大浮亏的" + dirStr + DoubleToString(orderLots, 2) + "手被对冲掉" +
                     DoubleToString(hedgeLots, 2) + "手，剩余" + DoubleToString(remainLots, 2) + "手。消耗盈利" +
                     DoubleToString(profitConsume, 2) + "$，已覆盖亏损金额≈" + DoubleToString(-profitConsume, 2) + "$当天剩余盈利=" +
                     DoubleToString(remainTodayProfit, 2) + "$当前余额≈" + DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE), 2) + "$");
            }
            remainProfitConsume -= profitConsume;
            totalFloatingLoss = CalculateTotalFloatingLoss();
         } else {
            Print("对冲失败，订单号：", ticket);
            break;
         }
         }
      }
   }
}

//+------------------------------------------------------------------+
double CalculateTotalFloatingLoss() {
   double loss = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      if(PositionGetTicket(i) != 0)
         loss += PositionGetDouble(POSITION_PROFIT);
   }
   return -loss;
}

//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
void SaveMaxTodayProfit() {
   int h = FileOpen(g_ProfitFileName, FILE_WRITE | FILE_TXT | FILE_COMMON);
   if(h == INVALID_HANDLE) return;
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   FileWrite(h, StringFormat("%04d.%02d.%02d", dt.year, dt.mon, dt.day));
   FileWrite(h, DoubleToString(g_MaxTodayProfit, 2));
   FileClose(h);
}

//+------------------------------------------------------------------+
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
      if(HistoryDealGetInteger(dealTicket, DEAL_TYPE) == DEAL_TYPE_BUY || HistoryDealGetInteger(dealTicket, DEAL_TYPE) == DEAL_TYPE_SELL)
         profit += HistoryDealGetDouble(dealTicket, DEAL_PROFIT);
   }

   if(profit > g_MaxTodayProfit) {
      g_MaxTodayProfit = profit;
      SaveMaxTodayProfit();
   }
   // 返回当前实际当天盈利（含对冲后的平仓），面板与对冲逻辑均用此值，对冲后会变少
   return profit;
}

//+------------------------------------------------------------------+
