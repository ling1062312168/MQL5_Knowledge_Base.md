//+------------------------------------------------------------------+
//|                                          HedgingAI_Strategy.mq5   |
//|                              天图EMA14定向 + 5分钟EMA6对冲马丁EA  |
//|                                                                  |
//|  策略核心：                                                       |
//|  1. 天图 EMA14 判定方向（仅多 / 仅空）                            |
//|  2. 5分钟 收盘价穿越 EMA6 触发开仓/锁仓                          |
//|  3. 加仓：1.6 倍倍投；解锁后末单累加 0.01 手                     |
//|  4. 平仓：整体止盈（单方向）+ 整体净盈利（多空合并）              |
//+------------------------------------------------------------------+
#property copyright "AI Hedging Strategy"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>

//+------------------------------------------------------------------+
//| 输入参数                                                          |
//+------------------------------------------------------------------+
input group "=== 基础设置 ==="
input double   InitialLots        = 0.01;        // 初始开仓手数
input double   Multiplier         = 1.6;         // 加仓倍投倍数
input double   UnlockAddLots      = 0.01;        // 解锁后末单累加手数
input int      MaxOrders          = 100;         // 最大订单数
input long     MagicNumber        = 20260731;    // EA魔术号
input int      Slippage           = 30;          // 滑点（点）

input group "=== 指标参数 ==="
input int      EMA14_Period_D1    = 14;          // 天图 EMA14 周期
input int      EMA6_Period_M5     = 6;           // 5分钟 EMA6 周期

input group "=== 整体止盈（单方向，点数） ==="
input int      TP_1to5            = 100;         // 1-5单 止盈点数
input int      TP_6to8            = 80;          // 6-8单 止盈点数
input int      TP_9to10           = 50;          // 9-10单 止盈点数
input int      TP_11to15          = 30;          // 11-15单 止盈点数
input int      TP_16to100         = 10;          // 16-100单 止盈点数

input group "=== 整体净盈利（多空合并，点数） ==="
input int      NetTP_1to7         = 100;         // 1-7单 净止盈点数
input int      NetTP_8to15        = 80;          // 8-15单 净止盈点数
input int      NetTP_16to20       = 50;          // 16-20单 净止盈点数
input int      NetTP_21to30       = 30;          // 21-30单 净止盈点数
input int      NetTP_31to100      = 10;          // 31-100单 净止盈点数

input group "=== AI 智能风控 ==="
input bool     AI_Enabled         = false;       // AI 风控总开关
input string   AI_ApiKey          = "sk-623fa48b2bac4e52b1b6ebe95e6a453e";    // API Key
input string   AI_ApiUrl          = "https://api.deepseek.com/chat/completions"; // API URL
input string   AI_Model           = "deepseek-v4-pro"; // 大模型名称
input int      AI_TimeoutSec      = 90;          // 超时(秒)
input int      AI_ScoreThreshold = 50;           // 打分阈值(0-100)
input bool     AI_FailOpen        = true;        // 容灾: true=立即开仓(激进) false=放弃开仓(稳妥)
input int      AI_CooldownMin     = 3;           // 冷却周期(分钟)
input int      AI_DataRange       = 2;           // 数据范围: 1=基础 2=N+(含多周期/箱体/布林/ADX)
input string   AI_SystemPrompt   = "你是华尔街顶尖操盘手"; // 提示词1(系统角色)
input string   AI_UserPrompt     = "我的策略是做均线突破"; // 提示词2(策略规则)

input group "=== 面板显示 ==="
input int      PanelX             = 15;          // 面板左上角 X
input int      PanelY             = 30;          // 面板左上角 Y
input color    PanelBGColor       = clrBlack;    // 面板背景色
input color    PanelTextColor     = clrWhite;     // 面板文字色
input bool     AutoTrade          = true;        // EA启动后自动开启

//+------------------------------------------------------------------+
//| 全局对象与变量                                                    |
//+------------------------------------------------------------------+
CTrade         trade;
CPositionInfo  posInfo;
CSymbolInfo    symInfo;

int            g_handle_EMA14_D1 = INVALID_HANDLE;
int            g_handle_EMA6_M5  = INVALID_HANDLE;

datetime       g_lastBarTime      = 0;            // 上一根5分钟K线时间
bool           g_eaEnabled       = true;         // EA运行开关
bool           g_panelCreated    = false;        // 面板是否已创建

// AI 风控相关全局状态
datetime       g_aiLastTime      = 0;             // 上次 AI 请求时间
int            g_aiLastDecision  = 0;             // 上次 AI 决定: 1=放行 -1=拒绝 0=未请求
int            g_aiLastDirection = 0;             // 上次 AI 决定的方向: 1=多 -1=空
int            g_aiLastScore     = -1;            // 上次 AI 评分(-1=请求失败)
string         g_aiLastError     = "";            // 上次 AI 错误描述

// AI 运行时可变状态（面板可改）
bool           g_aiEnabled       = false;          // AI 开关(运行时)
string         g_aiSystemPrompt  = "";             // 提示词1(运行时)
string         g_aiUserPrompt    = "";             // 提示词2(运行时)

#define        PREFIX             "AIH_"
#define        EDIT_SYS_PROMPT   PREFIX + "EDIT_SYS"
#define        EDIT_USR_PROMPT   PREFIX + "EDIT_USR"
string         BTN_AI_ONOFF      = PREFIX + "BTN_AI_ONOFF";
string         BTN_EA_ONOFF       = PREFIX + "BTN_EA_ONOFF";
string         BTN_CLOSE_ALL      = PREFIX + "BTN_CLOSE_ALL";
string         BTN_RESET          = PREFIX + "BTN_RESET";
string         BTN_AI_PREVIEW      = PREFIX + "BTN_AI_PREVIEW";

//+------------------------------------------------------------------+
//| 订单统计结构体                                                    |
//+------------------------------------------------------------------+
struct OrderStats
{
   int      buyCount;            // 多单数
   int      sellCount;           // 空单数
   double   buyProfit;           // 多单总盈利（金额，含手续费/库存费）
   double   sellProfit;          // 空单总盈利
   double   buyPoints;           // 多单均价对应盈亏点数（Bid - BuyAvg）/Point
   double   sellPoints;          // 空单均价对应盈亏点数（SellAvg - Ask）/Point
   double   buyTotalLots;        // 多单总手数
   double   sellTotalLots;       // 空单总手数
   double   buyLastLots;          // 多单末单手数（最新一笔）
   double   sellLastLots;         // 空单末单手数
   double   buyAvgPrice;         // 多单加权均价
   double   sellAvgPrice;        // 空单加权均价
   datetime buyLastTime;         // 多单末单开仓时间
   datetime sellLastTime;        // 空单末单开仓时间
};

//+------------------------------------------------------------------+
//| 初始化                                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(Slippage);
   trade.SetMarginMode();
   trade.SetTypeFillingBySymbol(_Symbol);

   if(!symInfo.Name(_Symbol)) return INIT_FAILED;

   // 创建指标句柄
   g_handle_EMA14_D1 = iMA(_Symbol, PERIOD_D1, EMA14_Period_D1, 0, MODE_EMA, PRICE_CLOSE);
   g_handle_EMA6_M5  = iMA(_Symbol, PERIOD_M5,  EMA6_Period_M5,  0, MODE_EMA, PRICE_CLOSE);

   if(g_handle_EMA14_D1 == INVALID_HANDLE || g_handle_EMA6_M5 == INVALID_HANDLE)
   {
      Print("指标创建失败");
      return INIT_FAILED;
   }

   g_eaEnabled      = AutoTrade;
   g_lastBarTime    = 0;
   g_panelCreated   = false;

   // 初始化 AI 运行时变量（从输入参数同步到面板可改状态）
   g_aiEnabled      = AI_Enabled;
   g_aiSystemPrompt = AI_SystemPrompt;
   g_aiUserPrompt   = AI_UserPrompt;

   CreatePanel();

   EventSetTimer(1);
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| 反初始化                                                            |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   DeletePanel();
   if(g_handle_EMA14_D1 != INVALID_HANDLE) IndicatorRelease(g_handle_EMA14_D1);
   if(g_handle_EMA6_M5  != INVALID_HANDLE) IndicatorRelease(g_handle_EMA6_M5);
}

//+------------------------------------------------------------------+
//| 定时器事件（每秒刷新面板）                                          |
//+------------------------------------------------------------------+
void OnTimer()
{
   UpdatePanelInfo();
}

//+------------------------------------------------------------------+
//| 主 Tick 事件                                                       |
//+------------------------------------------------------------------+
void OnTick()
{
   // 1. 实时检查平仓条件（每 tick 都检查）
   CheckCloseConditions();

   if(!g_eaEnabled)
   {
      UpdatePanelInfo();
      return;
   }

   // 2. 检测新 5 分钟 K 线
   datetime curBar = iTime(_Symbol, PERIOD_M5, 0);
   bool newM5Bar = (curBar != g_lastBarTime);
   if(newM5Bar) g_lastBarTime = curBar;

   // 3. 开仓/加仓/锁仓/解锁逻辑（仅新 K 线时执行）
   if(newM5Bar)
      HandleOpenLogic();

   // 4. 刷新面板
   UpdatePanelInfo();
}

//+------------------------------------------------------------------+
//| 图表事件（按钮点击 + 编辑框保存）                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   // ===== 编辑框完成事件: 用户输入完提示词后保存到全局变量 =====
   if(id == CHARTEVENT_OBJECT_ENDEDIT)
   {
      if(sparam == EDIT_SYS_PROMPT)
      {
         g_aiSystemPrompt = ObjectGetString(0, EDIT_SYS_PROMPT, OBJPROP_TEXT);
         Print("[AI] System Prompt 已保存: ", g_aiSystemPrompt);
      }
      else if(sparam == EDIT_USR_PROMPT)
      {
         g_aiUserPrompt = ObjectGetString(0, EDIT_USR_PROMPT, OBJPROP_TEXT);
         Print("[AI] User Prompt 已保存: ", g_aiUserPrompt);
      }
      return;
   }

   // ===== 按钮点击事件 =====
   if(id != CHARTEVENT_OBJECT_CLICK) return;

   if(sparam == BTN_AI_ONOFF)
   {
      g_aiEnabled = !g_aiEnabled;
      ObjectSetInteger(0, BTN_AI_ONOFF, OBJPROP_BGCOLOR, g_aiEnabled ? clrDarkGreen : clrMaroon);
      ObjectSetString (0, BTN_AI_ONOFF, OBJPROP_TEXT,    g_aiEnabled ? "AI: ON" : "AI: OFF");
      Print("[AI] AI 风控已 ", (g_aiEnabled ? "开启" : "关闭"));
      ChartRedraw();
   }
   else if(sparam == BTN_EA_ONOFF)
   {
      g_eaEnabled = !g_eaEnabled;
      ObjectSetInteger(0, BTN_EA_ONOFF, OBJPROP_BGCOLOR, g_eaEnabled ? clrDarkGreen : clrMaroon);
      ObjectSetString (0, BTN_EA_ONOFF, OBJPROP_TEXT,    g_eaEnabled ? "EA: ON" : "EA: OFF");
      ChartRedraw();
   }
   else if(sparam == BTN_CLOSE_ALL)
   {
      CloseAllOrders();
   }
   else if(sparam == BTN_RESET)
   {
      g_lastBarTime = 0;
   }
   else if(sparam == BTN_AI_PREVIEW)
   {
      ShowAIPromptPreview();
   }
}

//+------------------------------------------------------------------+
//| 显示 AI 提示词预览（弹窗显示完整请求体）                            |
//+------------------------------------------------------------------+
void ShowAIPromptPreview()
{
   int direction = GetTradeDirection();
   int sig       = GetM5Signal();
   OrderStats stats;
   GetOrderStats(stats);

   if(direction == 0)
   {
      MessageBox("当前无方向，无法生成预览。", "AI Prompt Preview", MB_OK | MB_ICONINFORMATION);
      return;
   }

   g_aiLastDirection = direction;
   string report = BuildAIReport(direction, sig, stats);
   string userContent = g_aiUserPrompt + " | DATA: " + report +
      " | TASK: 请根据上述盘面数据评估当前开" +
      (direction == 1 ? "多" : "空") +
      "仓的胜率，仅返回0-100之间的整数分值。";

   string msg = "===== System Prompt =====\n" + g_aiSystemPrompt +
                "\n\n===== User Prompt =====\n" + userContent +
                "\n\n===== API =====\nURL: " + AI_ApiUrl +
                "\nModel: " + AI_Model +
                "\nTimeout: " + IntegerToString(AI_TimeoutSec) + "s" +
                "\nThreshold: " + IntegerToString(AI_ScoreThreshold) +
                "\nAI Status: " + (g_aiEnabled ? "ON" : "OFF");

   MessageBox(msg, "AI Prompt Preview", MB_OK | MB_ICONINFORMATION);
}

//+------------------------------------------------------------------+
//|=====================  策略核心函数区  =============================|
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 获取交易方向：1=多  -1=空  0=无方向                                |
//+------------------------------------------------------------------+
int GetTradeDirection()
{
   double ema14[];
   ArraySetAsSeries(ema14, true);
   if(CopyBuffer(g_handle_EMA14_D1, 0, 0, 2, ema14) < 2) return 0;

   double d1_open0  = iOpen (_Symbol, PERIOD_D1, 0);
   double d1_close1 = iClose(_Symbol, PERIOD_D1, 1);

   // 多单方向：当前K开盘价 > EMA14 且 前一根K收盘价 > EMA14
   if(d1_open0 > ema14[0] && d1_close1 > ema14[1]) return 1;
   // 空单方向：相反
   if(d1_open0 < ema14[0] && d1_close1 < ema14[1]) return -1;
   return 0;
}

//+------------------------------------------------------------------+
//| 获取上一根5分钟K线信号                                              |
//|   返回： 1=收盘价>EMA6  -1=收盘价<EMA6  0=数据不足                 |
//+------------------------------------------------------------------+
int GetM5Signal()
{
   double ema6[];
   ArraySetAsSeries(ema6, true);
   if(CopyBuffer(g_handle_EMA6_M5, 0, 0, 3, ema6) < 3) return 0;

   double m5_close1 = iClose(_Symbol, PERIOD_M5, 1);
   if(m5_close1 > ema6[1]) return 1;
   if(m5_close1 < ema6[1]) return -1;
   return 0;
}

//+------------------------------------------------------------------+
//| 统计订单数据                                                       |
//+------------------------------------------------------------------+
void GetOrderStats(OrderStats &stats)
{
   stats.buyCount       = 0;
   stats.sellCount      = 0;
   stats.buyProfit      = 0;
   stats.sellProfit     = 0;
   stats.buyPoints      = 0;
   stats.sellPoints     = 0;
   stats.buyTotalLots   = 0;
   stats.sellTotalLots  = 0;
   stats.buyLastLots    = 0;
   stats.sellLastLots   = 0;
   stats.buyAvgPrice    = 0;
   stats.sellAvgPrice   = 0;
   stats.buyLastTime    = 0;
   stats.sellLastTime   = 0;

   double buyWeighted  = 0;
   double sellWeighted = 0;
   datetime buyLatestTime  = 0;
   datetime sellLatestTime = 0;

   int total = (int)PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;

      double vol    = PositionGetDouble(POSITION_VOLUME);
      double profit = PositionGetDouble(POSITION_PROFIT)
                    + PositionGetDouble(POSITION_SWAP);
      double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
      datetime pt   = (datetime)PositionGetInteger(POSITION_TIME);

      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
      {
         stats.buyCount++;
         stats.buyProfit     += profit;
         stats.buyTotalLots  += vol;
         buyWeighted         += openP * vol;
         if(pt > buyLatestTime)
         {
            buyLatestTime       = pt;
            stats.buyLastLots    = vol;
            stats.buyLastTime    = pt;
         }
      }
      else
      {
         stats.sellCount++;
         stats.sellProfit    += profit;
         stats.sellTotalLots += vol;
         sellWeighted        += openP * vol;
         if(pt > sellLatestTime)
         {
            sellLatestTime       = pt;
            stats.sellLastLots    = vol;
            stats.sellLastTime    = pt;
         }
      }
   }

   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double bid   = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask   = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   if(stats.buyTotalLots  > 0)
   {
      stats.buyAvgPrice = buyWeighted / stats.buyTotalLots;
      stats.buyPoints   = (bid - stats.buyAvgPrice) / point;
   }
   if(stats.sellTotalLots > 0)
   {
      stats.sellAvgPrice = sellWeighted / stats.sellTotalLots;
      stats.sellPoints   = (stats.sellAvgPrice - ask) / point;
   }
}

//+==================================================================+
//|                  AI 智能风控模块（新增）                          |
//+==================================================================+

//+------------------------------------------------------------------+
//| 判断当前是否在 AI 冷却期内（同方向）                               |
//|   返回: true=在冷却期内(直接沿用上次决定)  false=可发起请求       |
//+------------------------------------------------------------------+
bool IsInAICooldown(int direction)
{
   if(g_aiLastTime == 0) return false;
   if(g_aiLastDirection != direction) return false;
   datetime expire = g_aiLastTime + (datetime)(AI_CooldownMin * 60);
   return (TimeCurrent() < expire);
}

//+------------------------------------------------------------------+
//| 构建发送给 AI 的盘面数据报告（全英文压缩格式）                    |
//|   direction: 1=多 -1=空                                          |
//|   sig: 5分钟信号 1/-1                                            |
//+------------------------------------------------------------------+
string BuildAIReport(int direction, int sig, OrderStats &stats)
{
   string dirStr  = (direction == 1  ? "BUY"  : "SELL");
   string sigStr = (sig == 1 ? "close>EMA6" : "close<EMA6");

   // 基础数据：品种、当前价、各周期EMA、订单情况、信号
   string report = StringFormat(
      "SYM=%s; PRICE=%.5f; "
      "D1_EMA14=%.5f; D1_OPEN0=%.5f; D1_CLOSE1=%.5f; "
      "M5_EMA6=%.5f; M5_CLOSE1=%.5f; M5_SIG=%s; "
      "DIR=%s; BUY_CNT=%d; SELL_CNT=%d; "
      "BUY_LOTS=%.2f; SELL_LOTS=%.2f; "
      "BUY_PROFIT=%.2f; SELL_PROFIT=%.2f; "
      "BUY_PTS=%.1f; SELL_PTS=%.1f",
      _Symbol,
      SymbolInfoDouble(_Symbol, SYMBOL_BID),
      GetEMAValue(g_handle_EMA14_D1, 0),
      iOpen (_Symbol, PERIOD_D1, 0),
      iClose(_Symbol, PERIOD_D1, 1),
      GetEMAValue(g_handle_EMA6_M5, 1),
      iClose(_Symbol, PERIOD_M5, 1),
      sigStr,
      dirStr,
      stats.buyCount, stats.sellCount,
      stats.buyTotalLots, stats.sellTotalLots,
      stats.buyProfit, stats.sellProfit,
      stats.buyPoints, stats.sellPoints
   );

   // N+ 扩展数据：多周期K线高低、布林带、ADX
   if(AI_DataRange >= 2)
   {
      double h1_h = iHigh(_Symbol, PERIOD_H1, 1);
      double h1_l = iLow (_Symbol, PERIOD_H1, 1);
      double h4_h = iHigh(_Symbol, PERIOD_H4, 1);
      double h4_l = iLow (_Symbol, PERIOD_H4, 1);
      double d1_h = iHigh(_Symbol, PERIOD_D1, 1);
      double d1_l = iLow (_Symbol, PERIOD_D1, 1);

      int bbHandle = iBands(_Symbol, PERIOD_M5, 20, 0, 2.0, PRICE_CLOSE);
      int adxHandle = iADX(_Symbol, PERIOD_M5, 14);
      double bbUp = 0, bbMd = 0, bbLo = 0, adxMain = 0;
      if(bbHandle != INVALID_HANDLE)
      {
         double bb[];
         ArraySetAsSeries(bb, true);
         if(CopyBuffer(bbHandle, 1, 0, 3, bb) == 3) bbUp = bb[0];
         if(CopyBuffer(bbHandle, 0, 0, 3, bb) == 3) bbMd = bb[0];
         if(CopyBuffer(bbHandle, 2, 0, 3, bb) == 3) bbLo = bb[0];
         IndicatorRelease(bbHandle);
      }
      if(adxHandle != INVALID_HANDLE)
      {
         double adx[];
         ArraySetAsSeries(adx, true);
         if(CopyBuffer(adxHandle, 0, 0, 2, adx) == 2) adxMain = adx[0];
         IndicatorRelease(adxHandle);
      }

      report += StringFormat(
         "; H1_HL=%.5f/%.5f; H4_HL=%.5f/%.5f; D1_HL=%.5f/%.5f; "
         "BB_UP=%.5f; BB_MD=%.5f; BB_LO=%.5f; ADX=%.1f",
         h1_h, h1_l, h4_h, h4_l, d1_h, d1_l,
         bbUp, bbMd, bbLo, adxMain
      );
   }

   return report;
}

//+------------------------------------------------------------------+
//| 辅助：取 EMA 指定索引的值                                         |
//+------------------------------------------------------------------+
double GetEMAValue(int handle, int shift)
{
   if(handle == INVALID_HANDLE) return 0;
   double buf[];
   ArraySetAsSeries(buf, true);
   if(CopyBuffer(handle, 0, 0, shift + 2, buf) < shift + 1) return 0;
   return buf[shift];
}

//+------------------------------------------------------------------+
//| 调用大模型 API，返回 0-100 评分                                   |
//|   返回: 0-100 = 成功  -1 = 失败/超时                              |
//+------------------------------------------------------------------+
int RequestAIScore(string report)
{
   // 拼装 OpenAI 兼容格式 JSON（使用运行时变量 g_aiSystemPrompt / g_aiUserPrompt）
   string userContent = g_aiUserPrompt +
      " | DATA: " + report +
      " | TASK: 请根据上述盘面数据评估当前开" +
      (g_aiLastDirection == 1 ? "多" : "空") +
      "仓的胜率，仅返回0-100之间的整数分值，不要其他任何文字。";

   string payload = "{";
   payload += "\"model\":\"" + AI_Model + "\",";
   payload += "\"messages\":[";
   payload += "{\"role\":\"system\",\"content\":\"" + EscapeJson(g_aiSystemPrompt) + "\"},";
   payload += "{\"role\":\"user\",\"content\":\"" + EscapeJson(userContent) + "\"}";
   payload += "],";
   payload += "\"temperature\":0.3,";
   payload += "\"max_tokens\":50";
   payload += "}";

   // 提取基础域名(到 .com 或 .com 之前)
   string host, path;
   ParseUrl(AI_ApiUrl, host, path);
   if(host == "")
   {
      g_aiLastError = "URL解析失败: " + AI_ApiUrl;
      Print("[AI] ", g_aiLastError);
      return -1;
   }

   string headers = "Content-Type: application/json\r\n";
   headers += "Authorization: Bearer " + AI_ApiKey + "\r\n";

   char post[], result[];
   StringToCharArray(payload, post, 0, StringLen(payload));
   // 去掉末尾 \0
   ArrayResize(post, ArraySize(post) - 1);

   string resultHeaders;
   ResetLastError();
   int code = WebRequest("POST", AI_ApiUrl, headers, 5000,
                         AI_TimeoutSec * 1000, post, ArraySize(post),
                         result, resultHeaders);

   if(code == -1)
   {
      int err = GetLastError();
      g_aiLastError = "WebRequest失败 err=" + IntegerToString(err) +
                      "（请检查MT5选项->EA交易->允许WebRequest并加入 " + host + "）";
      Print("[AI] ", g_aiLastError);
      return -1;
   }

   if(code != 200)
   {
      g_aiLastError = "HTTP " + IntegerToString(code) + ": " + CharArrayToString(result);
      Print("[AI] ", g_aiLastError);
      return -1;
   }

   string response = CharArrayToString(result);
   string content  = ExtractJsonContent(response);
   if(content == "")
   {
      g_aiLastError = "JSON解析失败: " + response;
      Print("[AI] ", g_aiLastError);
      return -1;
   }

   // 提取内容中的数字
   int score = ExtractScore(content);
   if(score < 0)
   {
      g_aiLastError = "无法提取评分: " + content;
      Print("[AI] ", g_aiLastError);
      return -1;
   }

   g_aiLastError = "";
   return score;
}

//+------------------------------------------------------------------+
//| 解析 URL 为 host + path                                           |
//|   例: https://api.deepseek.com/chat/completions                  |
//|       host=api.deepseek.com  path=/chat/completions               |
//+------------------------------------------------------------------+
void ParseUrl(string url, string &host, string &path)
{
   host = ""; path = "";
   string s = url;
   int pos = StringFind(s, "://", 0);
   if(pos >= 0) s = StringSubstr(s, pos + 3);

   int slash = StringFind(s, "/", 0);
   if(slash < 0)
   {
      host = s;
      path = "/";
   }
   else
   {
      host = StringSubstr(s, 0, slash);
      path = StringSubstr(s, slash);
   }
}

//+------------------------------------------------------------------+
//| JSON 字符串转义                                                    |
//+------------------------------------------------------------------+
string EscapeJson(string s)
{
   StringReplace(s, "\\", "\\\\");
   StringReplace(s, "\"", "\\\"");
   StringReplace(s, "\n", "\\n");
   StringReplace(s, "\r", "\\r");
   StringReplace(s, "\t", "\\t");
   return s;
}

//+------------------------------------------------------------------+
//| 从 OpenAI 响应中提取 choices[0].message.content                  |
//+------------------------------------------------------------------+
string ExtractJsonContent(string json)
{
   int p1 = StringFind(json, "\"content\"", 0);
   if(p1 < 0) return "";
   p1 = StringFind(json, "\"", p1 + 9);   // 第二个引号(开始)
   if(p1 < 0) return "";
   int p2 = p1 + 1;
   while(p2 < StringLen(json))
   {
      if(StringGetCharacter(json, p2) == '"' &&
         StringGetCharacter(json, p2 - 1) != '\\')
         break;
      p2++;
   }
   if(p2 >= StringLen(json)) return "";
   string content = StringSubstr(json, p1 + 1, p2 - p1 - 1);
   // 反转义
   StringReplace(content, "\\n", "\n");
   StringReplace(content, "\\\"", "\"");
   StringReplace(content, "\\\\", "\\");
   return content;
}

//+------------------------------------------------------------------+
//| 从 AI 回复内容中提取 0-100 整数评分                                |
//+------------------------------------------------------------------+
int ExtractScore(string content)
{
   string num = "";
   for(int i = 0; i < StringLen(content); i++)
   {
      ushort c = StringGetCharacter(content, i);
      if(c >= '0' && c <= '9')
         num += CharToString(c);
      else if(num != "")
         break;
   }
   if(num == "") return -1;
   int score = (int)StringToInteger(num);
   if(score < 0)   score = 0;
   if(score > 100) score = 100;
   return score;
}

//+------------------------------------------------------------------+
//| AI 风控总入口：判定是否允许开仓                                   |
//|   返回: true=允许开仓  false=拒绝                                |
//+------------------------------------------------------------------+
bool AIFilter(int direction, int sig, OrderStats &stats)
{
   // 未启用 AI → 直接通过（使用运行时变量 g_aiEnabled）
   if(!g_aiEnabled) return true;

   g_aiLastDirection = direction;

   // 冷却期内 → 沿用上次决定
   if(IsInAICooldown(direction))
   {
      bool pass = (g_aiLastDecision == 1);
      Print("[AI] 冷却期内, 沿用上次决定: ", pass ? "放行" : "拒绝");
      return pass;
   }

   // 构建报告
   string report = BuildAIReport(direction, sig, stats);

   // 请求 AI 评分
   g_aiLastTime = TimeCurrent();
   int score = RequestAIScore(report);
   g_aiLastScore = score;

   if(score < 0)
   {
      // 请求失败 → 容灾机制
      g_aiLastDecision = AI_FailOpen ? 1 : -1;
      Print("[AI] 请求失败, 容灾: ", AI_FailOpen ? "立即开仓" : "放弃开仓");
      return AI_FailOpen;
   }

   // 评分判定
   g_aiLastDecision = (score >= AI_ScoreThreshold) ? 1 : -1;
   Print("[AI] 评分=", score, " 阈值=", AI_ScoreThreshold,
         " 决定=", (g_aiLastDecision == 1 ? "放行" : "拒绝"));
   return (g_aiLastDecision == 1);
}

//+------------------------------------------------------------------+
//| 判断本根 5 分钟 K 线是否已开过仓                                    |
//+------------------------------------------------------------------+
bool HasOrderThisBar(datetime barTime)
{
   int total = (int)PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;

      datetime pt = (datetime)PositionGetInteger(POSITION_TIME);
      if(pt >= barTime) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 主状态机：开仓 / 加仓 / 锁仓 / 解锁                                 |
//+------------------------------------------------------------------+
void HandleOpenLogic()
{
   int direction = GetTradeDirection();
   if(direction == 0) return;

   int sig = GetM5Signal();
   if(sig == 0) return;

   OrderStats stats;
   GetOrderStats(stats);

   // 防止超订单数
   if((stats.buyCount + stats.sellCount) >= MaxOrders) return;

   datetime curBar = iTime(_Symbol, PERIOD_M5, 0);
   if(HasOrderThisBar(curBar)) return; // 本根 K 线已开过仓

   // ===== AI 风控过滤（仅对首单开仓过滤，加仓/解锁不受影响） =====
   // 首单 = 既无多单也无空单；锁仓首单也走 AI 审核
   bool isFirstEntry = (stats.buyCount == 0 && stats.sellCount == 0);
   bool isLockEntry  = ((direction == 1 && sig == -1 && stats.buyCount > 0  && stats.sellCount == 0) ||
                        (direction == -1 && sig == 1  && stats.sellCount > 0 && stats.buyCount == 0));
   if((isFirstEntry || isLockEntry) && !AIFilter(direction, sig, stats))
   {
      Print("[AI] 开仓被拒绝 direction=", direction, " sig=", sig);
      return;
   }

   if(direction == 1)
   {
      //========== 多单方向 ==========
      if(sig == 1)
      {
         // 收盘价 > EMA6 → 开仓 / 加仓 / 解锁
         if(stats.buyCount == 0 && stats.sellCount == 0)
         {
            // 初始开仓
            OpenBuyOrder(InitialLots);
         }
         else if(stats.buyCount > 0 && stats.sellCount == 0)
         {
            // 末单 1.6 倍加仓
            double newLots = NormalizeLot(stats.buyLastLots * Multiplier);
            OpenBuyOrder(newLots);
         }
         else if(stats.buyCount > 0 && stats.sellCount > 0)
         {
            // 有锁仓空单 → 检查是否解锁
            if(stats.sellProfit > 0)
            {
               // 空单整体盈利 > 0 → 平掉所有空单，多单末单累加 0.01 加仓
               CloseAllSellOrders();
               double newLots = NormalizeLot(stats.buyLastLots + UnlockAddLots);
               OpenBuyOrder(newLots);
            }
            else
            {
               // 空单盈利 ≤ 0 → 不平仓，多单末单 1.6 倍加仓
               double newLots = NormalizeLot(stats.buyLastLots * Multiplier);
               OpenBuyOrder(newLots);
            }
         }
      }
      else if(sig == -1)
      {
         // 收盘价 < EMA6 → 锁仓
         if(stats.buyCount > 0 && stats.sellCount == 0)
         {
            // 已有多单未平仓，开锁仓空单
            OpenSellOrder(InitialLots);
         }
      }
   }
   else // direction == -1
   {
      //========== 空单方向 ==========
      if(sig == -1)
      {
         if(stats.buyCount == 0 && stats.sellCount == 0)
         {
            OpenSellOrder(InitialLots);
         }
         else if(stats.sellCount > 0 && stats.buyCount == 0)
         {
            double newLots = NormalizeLot(stats.sellLastLots * Multiplier);
            OpenSellOrder(newLots);
         }
         else if(stats.sellCount > 0 && stats.buyCount > 0)
         {
            if(stats.buyProfit > 0)
            {
               CloseAllBuyOrders();
               double newLots = NormalizeLot(stats.sellLastLots + UnlockAddLots);
               OpenSellOrder(newLots);
            }
            else
            {
               double newLots = NormalizeLot(stats.sellLastLots * Multiplier);
               OpenSellOrder(newLots);
            }
         }
      }
      else if(sig == 1)
      {
         if(stats.sellCount > 0 && stats.buyCount == 0)
         {
            OpenBuyOrder(InitialLots);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 平仓检查：先检查整体止盈，再检查整体净盈利                          |
//+------------------------------------------------------------------+
void CheckCloseConditions()
{
   if(CheckSingleDirectionTP()) return;
   if(CheckNetProfitTP())       return;
}

//+------------------------------------------------------------------+
//| 整体止盈（单方向）                                                  |
//|   只多单时不能有锁仓的空单；只空单时不能有锁仓的多单                 |
//+------------------------------------------------------------------+
bool CheckSingleDirectionTP()
{
   OrderStats stats;
   GetOrderStats(stats);

   // 多单整体止盈
   if(stats.buyCount > 0 && stats.sellCount == 0)
   {
      int tp = GetSingleTPPoints(stats.buyCount);
      if(tp > 0 && stats.buyPoints >= tp)
      {
         Print("整体止盈(多单): 订单数=", stats.buyCount, " 点数=", stats.buyPoints, " 阈值=", tp);
         CloseAllBuyOrders();
         return true;
      }
   }

   // 空单整体止盈
   if(stats.sellCount > 0 && stats.buyCount == 0)
   {
      int tp = GetSingleTPPoints(stats.sellCount);
      if(tp > 0 && stats.sellPoints >= tp)
      {
         Print("整体止盈(空单): 订单数=", stats.sellCount, " 点数=", stats.sellPoints, " 阈值=", tp);
         CloseAllSellOrders();
         return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| 根据订单数返回整体止盈点数                                         |
//+------------------------------------------------------------------+
int GetSingleTPPoints(int orderCount)
{
   if(orderCount >= 1  && orderCount <= 5)  return TP_1to5;
   if(orderCount >= 6  && orderCount <= 8)  return TP_6to8;
   if(orderCount >= 9  && orderCount <= 10) return TP_9to10;
   if(orderCount >= 11 && orderCount <= 15) return TP_11to15;
   if(orderCount >= 16)                      return TP_16to100;
   return 0;
}

//+------------------------------------------------------------------+
//| 整体净盈利（多空合并）                                              |
//|   前提：多空合并净盈利 > 0 且 主方向订单数 ≥ 2                     |
//|         主方向手数必须大于锁仓方向手数                              |
//+------------------------------------------------------------------+
bool CheckNetProfitTP()
{
   OrderStats stats;
   GetOrderStats(stats);

   int totalOrders = stats.buyCount + stats.sellCount;
   if(totalOrders < 2) return false;

   double netProfit = stats.buyProfit + stats.sellProfit;
   if(netProfit <= 0) return false;

   int tp = GetNetTPPoints(totalOrders);
   if(tp <= 0) return false;

   // 多单为主的情况
   if(stats.buyCount > 0 && stats.buyTotalLots > stats.sellTotalLots)
   {
      if(stats.buyCount < 2) return false;            // 多单必须有加仓
      if(stats.buyPoints >= tp)
      {
         Print("整体净盈利(多单主导): 总单=", totalOrders,
               " 多单点数=", stats.buyPoints, " 阈值=", tp,
               " 净盈利=", netProfit);
         CloseAllOrders();
         return true;
      }
   }
   // 空单为主的情况
   else if(stats.sellCount > 0 && stats.sellTotalLots > stats.buyTotalLots)
   {
      if(stats.sellCount < 2) return false;
      if(stats.sellPoints >= tp)
      {
         Print("整体净盈利(空单主导): 总单=", totalOrders,
               " 空单点数=", stats.sellPoints, " 阈值=", tp,
               " 净盈利=", netProfit);
         CloseAllOrders();
         return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| 根据多空总订单数返回整体净盈利点数阈值                              |
//+------------------------------------------------------------------+
int GetNetTPPoints(int totalOrders)
{
   if(totalOrders >= 1  && totalOrders <= 7)  return NetTP_1to7;
   if(totalOrders >= 8  && totalOrders <= 15) return NetTP_8to15;
   if(totalOrders >= 16 && totalOrders <= 20) return NetTP_16to20;
   if(totalOrders >= 21 && totalOrders <= 30) return NetTP_21to30;
   if(totalOrders >= 31)                       return NetTP_31to100;
   return 0;
}

//+------------------------------------------------------------------+
//|=====================  交易操作函数区  =============================|
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 规范化手数                                                          |
//+------------------------------------------------------------------+
double NormalizeLot(double lots)
{
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(stepLot <= 0) stepLot = 0.01;

   lots = MathMax(minLot, MathMin(maxLot, lots));
   lots = MathRound(lots / stepLot) * stepLot;
   return NormalizeDouble(lots, 2);
}

//+------------------------------------------------------------------+
//| 开多单                                                             |
//+------------------------------------------------------------------+
void OpenBuyOrder(double lots)
{
   lots = NormalizeLot(lots);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   if(!trade.Buy(lots, _Symbol, ask, 0, 0, "AI Hedging Buy"))
      Print("开多单失败: ", trade.ResultRetcode(), " ", trade.ResultRetcodeDescription(),
            " lots=", lots);
}

//+------------------------------------------------------------------+
//| 开空单                                                             |
//+------------------------------------------------------------------+
void OpenSellOrder(double lots)
{
   lots = NormalizeLot(lots);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(!trade.Sell(lots, _Symbol, bid, 0, 0, "AI Hedging Sell"))
      Print("开空单失败: ", trade.ResultRetcode(), " ", trade.ResultRetcodeDescription(),
            " lots=", lots);
}

//+------------------------------------------------------------------+
//| 平掉所有多单                                                       |
//+------------------------------------------------------------------+
void CloseAllBuyOrders()
{
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         trade.PositionClose(ticket);
   }
}

//+------------------------------------------------------------------+
//| 平掉所有空单                                                       |
//+------------------------------------------------------------------+
void CloseAllSellOrders()
{
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
         trade.PositionClose(ticket);
   }
}

//+------------------------------------------------------------------+
//| 平掉所有订单                                                       |
//+------------------------------------------------------------------+
void CloseAllOrders()
{
   for(int i = (int)PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if((long)PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      trade.PositionClose(ticket);
   }
}

//+------------------------------------------------------------------+
//|=====================  面板 UI 函数区  ============================|
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 创建面板                                                           |
//+------------------------------------------------------------------+
void CreatePanel()
{
   // 背景面板（扩展高度容纳 AI 输入框）
   CreateRect(PREFIX + "BG", PanelX, PanelY, 260, 540, PanelBGColor);

   // 标题栏
   CreateRect(PREFIX + "TITLE_BG", PanelX, PanelY, 260, 26, clrDimGray);
   CreateLabel(PREFIX + "TITLE", PanelX + 10, PanelY + 5, "AI Hedging Strategy v1.2", clrGold, 11, "Consolas");

   // 状态行
   int y = PanelY + 35;
   CreateLabel(PREFIX + "STATUS",    PanelX + 10, y,       "Status:    --",        PanelTextColor, 10);
   CreateLabel(PREFIX + "DIRECTION", PanelX + 10, y + 18, "Direction: --",        clrCyan,        10);
   CreateLabel(PREFIX + "SIGNAL",    PanelX + 10, y + 36, "M5 Signal: --",        clrCyan,        10);

   CreateLabel(PREFIX + "SEP1",     PanelX + 10, y + 56, "---------- 多单 ----------", clrYellow, 10);

   CreateLabel(PREFIX + "BUYCOUNT",  PanelX + 10, y + 74, "Buy Count: 0",       clrAqua, 10);
   CreateLabel(PREFIX + "BUYLOTS",   PanelX + 10, y + 92, "Buy Lots:  0.00",    clrAqua, 10);
   CreateLabel(PREFIX + "BUYPROFIT", PanelX + 10, y + 110,"Buy Profit:0.00",    clrAqua, 10);
   CreateLabel(PREFIX + "BUYPOINTS", PanelX + 10, y + 128,"Buy Points:0",       clrAqua, 10);

   CreateLabel(PREFIX + "SEP2",     PanelX + 10, y + 148,"---------- 空单 ----------", clrYellow, 10);

   CreateLabel(PREFIX + "SELLCOUNT",  PanelX + 10, y + 166,"Sell Count: 0",     clrAqua, 10);
   CreateLabel(PREFIX + "SELLLOTS",   PanelX + 10, y + 184,"Sell Lots:  0.00",   clrAqua, 10);
   CreateLabel(PREFIX + "SELLPROFIT", PanelX + 10, y + 202,"Sell Profit:0.00",  clrAqua, 10);
   CreateLabel(PREFIX + "SELLPOINTS", PanelX + 10, y + 220,"Sell Points:0",     clrAqua, 10);

   // 净盈亏
   CreateLabel(PREFIX + "NET",        PanelX + 10, y + 240,"Net Profit:0.00",   clrWhite, 10);

   // ===== AI 智能风控区块（新增开关按钮 + 提示词输入框） =====
   CreateLabel(PREFIX + "SEP_AI",     PanelX + 10, y + 262,"---------- AI ----------", clrYellow, 10);

   // AI 开关按钮（独立行）
   CreateButton(BTN_AI_ONOFF,  PanelX + 10,  y + 280, 110, 22,
                g_aiEnabled ? "AI: ON" : "AI: OFF",
                g_aiEnabled ? clrDarkGreen : clrMaroon);
   // 提示词预览按钮（同行右侧）
   CreateButton(BTN_AI_PREVIEW, PanelX + 130, y + 280, 120, 22, "Preview Prompt", clrDarkSlateGray);

   // AI 状态信息
   CreateLabel(PREFIX + "AI_STATUS",  PanelX + 10, y + 306,"Model: --",        clrGray,  10);
   CreateLabel(PREFIX + "AI_SCORE",    PanelX + 10, y + 324,"Score: --/" + IntegerToString(AI_ScoreThreshold), clrGray,  10);
   CreateLabel(PREFIX + "AI_LAST",    PanelX + 10, y + 342,"Last: --",          clrGray,  10);

   // 提示词1 标签 + 输入框
   CreateLabel(PREFIX + "LBL_SYS",     PanelX + 10, y + 364,"System Prompt:",   clrSilver, 9);
   CreateEdit(EDIT_SYS_PROMPT,        PanelX + 10, y + 380, 240, 40, g_aiSystemPrompt);

   // 提示词2 标签 + 输入框
   CreateLabel(PREFIX + "LBL_USR",     PanelX + 10, y + 426,"User Prompt:",     clrSilver, 9);
   CreateEdit(EDIT_USR_PROMPT,        PanelX + 10, y + 442, 240, 40, g_aiUserPrompt);

   // 底部操作按钮行
   CreateButton(BTN_EA_ONOFF,    PanelX + 10,  PanelY + 500, 70,  24, g_eaEnabled ? "EA: ON" : "EA: OFF", g_eaEnabled ? clrDarkGreen : clrMaroon);
   CreateButton(BTN_CLOSE_ALL,   PanelX + 85,  PanelY + 500, 75,  24, "CLOSE ALL", clrMaroon);
   CreateButton(BTN_RESET,       PanelX + 165, PanelY + 500, 60,  24, "RESET",    clrDarkBlue);

   g_panelCreated = true;
}

//+------------------------------------------------------------------+
//| 创建可编辑输入框                                                    |
//+------------------------------------------------------------------+
bool CreateEdit(string name, int x, int y, int w, int h, string defaultValue)
{
   if(!ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0)) return false;
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clrDarkGray);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_READONLY, false);    // 关键: 允许编辑
   ObjectSetInteger(0, name, OBJPROP_ALIGN, ALIGN_LEFT);
   ObjectSetString (0, name, OBJPROP_FONT, "Consolas");
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
   ObjectSetString (0, name, OBJPROP_TEXT, defaultValue);
   return true;
}

//+------------------------------------------------------------------+
//| 创建矩形标签（背景）                                                |
//+------------------------------------------------------------------+
void CreateRect(string name, int x, int y, int w, int h, color bgClr)
{
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE,     w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE,     h);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR,   bgClr);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_CORNER,    CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_BACK,      false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN,    true);
}

//+------------------------------------------------------------------+
//| 创建文字标签                                                       |
//+------------------------------------------------------------------+
void CreateLabel(string name, int x, int y, string text, color clr, int fontSize, string font = "Consolas")
{
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_CORNER,    CORNER_LEFT_UPPER);
   ObjectSetString (0, name, OBJPROP_TEXT,      text);
   ObjectSetInteger(0, name, OBJPROP_COLOR,     clr);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE,  fontSize);
   ObjectSetString (0, name, OBJPROP_FONT,      font);
   ObjectSetInteger(0, name, OBJPROP_BACK,      false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN,    true);
}

//+------------------------------------------------------------------+
//| 创建按钮                                                           |
//+------------------------------------------------------------------+
void CreateButton(string name, int x, int y, int w, int h, string text, color bgClr)
{
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE,     w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE,     h);
   ObjectSetInteger(0, name, OBJPROP_CORNER,    CORNER_LEFT_UPPER);
   ObjectSetString (0, name, OBJPROP_TEXT,      text);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR,   bgClr);
   ObjectSetInteger(0, name, OBJPROP_COLOR,     clrWhite);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE,  10);
   ObjectSetString (0, name, OBJPROP_FONT,      "Consolas");
   ObjectSetInteger(0, name, OBJPROP_BACK,      false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN,    true);
}

//+------------------------------------------------------------------+
//| 更新面板信息                                                       |
//+------------------------------------------------------------------+
void UpdatePanelInfo()
{
   if(!g_panelCreated) return;

   OrderStats stats;
   GetOrderStats(stats);

   int direction = GetTradeDirection();
   string dirStr = (direction == 1  ? "BUY ONLY"  :
                    direction == -1 ? "SELL ONLY" : "NONE");

   int sig = GetM5Signal();
   string sigStr = (sig == 1  ? "Close>EMA6 (多)"  :
                    sig == -1 ? "Close<EMA6 (空)" : "--");

   string status = g_eaEnabled ? "RUNNING" : "STOPPED";

   ObjectSetString(0, PREFIX + "STATUS",    OBJPROP_TEXT, "Status:    " + status);
   ObjectSetString(0, PREFIX + "DIRECTION", OBJPROP_TEXT, "Direction: " + dirStr);
   ObjectSetString(0, PREFIX + "SIGNAL",    OBJPROP_TEXT, "M5 Signal: " + sigStr);

   ObjectSetString(0, PREFIX + "BUYCOUNT",  OBJPROP_TEXT, "Buy Count: " + IntegerToString(stats.buyCount));
   ObjectSetString(0, PREFIX + "BUYLOTS",   OBJPROP_TEXT, "Buy Lots:  " + DoubleToString(stats.buyTotalLots, 2));
   ObjectSetString(0, PREFIX + "BUYPROFIT", OBJPROP_TEXT, "Buy Profit:" + DoubleToString(stats.buyProfit, 2));
   ObjectSetString(0, PREFIX + "BUYPOINTS", OBJPROP_TEXT, "Buy Points:" + DoubleToString(stats.buyPoints, 1));

   ObjectSetString(0, PREFIX + "SELLCOUNT",  OBJPROP_TEXT, "Sell Count: " + IntegerToString(stats.sellCount));
   ObjectSetString(0, PREFIX + "SELLLOTS",   OBJPROP_TEXT, "Sell Lots:  " + DoubleToString(stats.sellTotalLots, 2));
   ObjectSetString(0, PREFIX + "SELLPROFIT", OBJPROP_TEXT, "Sell Profit:" + DoubleToString(stats.sellProfit, 2));
   ObjectSetString(0, PREFIX + "SELLPOINTS", OBJPROP_TEXT, "Sell Points:" + DoubleToString(stats.sellPoints, 1));

   double netProfit = stats.buyProfit + stats.sellProfit;
   ObjectSetString(0, PREFIX + "NET", OBJPROP_TEXT, "Net Profit:" + DoubleToString(netProfit, 2));

   // ===== AI 区块更新（使用运行时变量 g_aiEnabled） =====
   string aiStatus = g_aiEnabled ? "ON" : "OFF";
   string aiModel  = (AI_Model != "" ? AI_Model : "未配置");
   ObjectSetString(0, PREFIX + "AI_STATUS", OBJPROP_TEXT,
                   "AI: " + aiStatus + "  Model: " + aiModel);
   ObjectSetInteger(0, PREFIX + "AI_STATUS", OBJPROP_COLOR,
                    g_aiEnabled ? clrLimeGreen : clrGray);

   // 同步 AI 开关按钮显示（防止外部修改状态后按钮颜色不更新）
   ObjectSetInteger(0, BTN_AI_ONOFF, OBJPROP_BGCOLOR, g_aiEnabled ? clrDarkGreen : clrMaroon);
   ObjectSetString (0, BTN_AI_ONOFF, OBJPROP_TEXT,    g_aiEnabled ? "AI: ON" : "AI: OFF");

   string scoreStr = (g_aiLastScore >= 0 ?
                      IntegerToString(g_aiLastScore) : "--");
   ObjectSetString(0, PREFIX + "AI_SCORE", OBJPROP_TEXT,
                   "Score: " + scoreStr + "/" + IntegerToString(AI_ScoreThreshold));
   ObjectSetInteger(0, PREFIX + "AI_SCORE", OBJPROP_COLOR,
                    (g_aiLastScore >= AI_ScoreThreshold && g_aiLastScore >= 0) ? clrLimeGreen :
                    (g_aiLastScore >= 0 ? clrTomato : clrGray));

   string lastStr = "Last: ";
   if(g_aiLastTime == 0)
      lastStr += "无";
   else
   {
      string dec = (g_aiLastDecision == 1 ? "放行" :
                    g_aiLastDecision == -1 ? "拒绝" : "--");
      int secAgo = (int)(TimeCurrent() - g_aiLastTime);
      lastStr += dec + " (" + IntegerToString(secAgo) + "s ago)";
   }
   ObjectSetString(0, PREFIX + "AI_LAST", OBJPROP_TEXT, lastStr);
   ObjectSetInteger(0, PREFIX + "AI_LAST", OBJPROP_COLOR,
                    g_aiLastDecision == 1  ? clrLimeGreen :
                    g_aiLastDecision == -1 ? clrTomato  : clrGray);

   // 颜色动态变化
   ObjectSetInteger(0, PREFIX + "BUYPROFIT",  OBJPROP_COLOR, stats.buyProfit  >= 0 ? clrLimeGreen : clrTomato);
   ObjectSetInteger(0, PREFIX + "SELLPROFIT", OBJPROP_COLOR, stats.sellProfit >= 0 ? clrLimeGreen : clrTomato);
   ObjectSetInteger(0, PREFIX + "NET",        OBJPROP_COLOR, netProfit        >= 0 ? clrLimeGreen : clrTomato);
}

//+------------------------------------------------------------------+
//| 删除面板                                                           |
//+------------------------------------------------------------------+
void DeletePanel()
{
   ObjectsDeleteAll(0, PREFIX);
   g_panelCreated = false;
}
//+------------------------------------------------------------------+
