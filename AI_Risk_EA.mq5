//+------------------------------------------------------------------+
//|                                                  AI_Risk_EA.mq5  |
//|        Hedging6.7+ AI智能风控通信控制中心 + 网格 + 篮子止盈止损    |
//|        信号源：自定义指标"均线交叉4"(EMA交叉+日线EMA14过滤)        |
//|        工作流：信号拦截-冷却校验-打包-Prompt-API-评分判断-容灾     |
//+------------------------------------------------------------------+
#property copyright "AI Quant EA"
#property version   "1.10"
#property strict

#include <Trade\Trade.mqh>

//===================== 一、AI风控面板输入参数 =====================
input bool          Inp_AI_EnableSwitch          = true;       // AI开仓总开关
input int           Inp_TimeoutSec               = 30;         // 超时(秒)
input int           Inp_ScoreThreshold           = 50;         // 返回值打分阈值
input int           Inp_CoolDownMin              = 3;          // 冷却周期(分钟)
input bool          Inp_SendFullDataNPlus        = true;       // 发送数据范围N+:true多周期/false精简2周期
input bool          Inp_FailMode_OpenImmediately = false;      // 通信失败处理:true立即开仓(激进) false放弃(稳健)
input bool          Inp_AI_GateGridOrders        = false;      // 网格加仓是否也需AI审核(默认否,机械加仓)
input string        Inp_Prompt1_SystemRole       = "You are top Wall Street trader, risk averse."; // 提示词1 系统角色
input string        Inp_Prompt2_StrategyRule     = "My strategy is EMA crossover with D1 EMA14 trend filter. If ADX<20 give score<30, only strong trend get score>=80. Return ONLY single integer 0-100, no other text."; // 提示词2 策略规则

// AI API配置(OpenAI兼容,适配DeepSeek/豆包/通义/Gemini)
input string        Inp_API_Key                  = "sk-xxx";
input string        Inp_API_Url                  = "https://api.deepseek.com/v1/chat/completions";
input string        Inp_ModelName                = "deepseek-chat";

//===================== 二、信号源：均线交叉4指标参数 =====================
input int           Inp_FastEMA                  = 5;          // 快速EMA周期(对应指标"快速EMA周期")
input int           Inp_SlowEMA                  = 8;          // 慢速EMA周期(对应指标"慢速EMA周期")
input bool          Inp_OnlyLong                 = true;       // 只显示多单信号
input bool          Inp_OnlyShort                = true;       // 只显示空单信号

//===================== 三、交易基础参数 =====================
input double        Inp_Lot                      = 0.01;       // 首单手数
input ulong         Inp_Magic                    = 20260801;   // 魔术数(区分本EA订单)
input int           Inp_Slippage                 = 10;         // 滑点(点)

//===================== 四、网格策略参数 =====================
input bool          Inp_GridEnable               = true;       // 启用网格
input double        Inp_GridStepPips             = 200;        // 网格间距(点)
input int           Inp_GridMaxOrders            = 5;          // 网格最大单数(含首单)
input double        Inp_GridLotMultiplier        = 1.0;        // 加仓倍数(1=等额,2=马丁)
input bool          Inp_GridAveraging            = true;       // true=逆势加仓(摊均价) false=顺势加仓

//===================== 五、篮子止盈/止损参数 =====================
input bool          Inp_BasketEnable             = true;       // 启用篮子止盈止损
input double        Inp_BasketTakeProfit         = 50.0;       // 篮子止盈(账户货币)
input double        Inp_BasketStopLoss           = 200.0;      // 篮子止损(账户货币)
input bool          Inp_BasketCloseOnReverseSig  = false;      // 反向信号出现时平掉篮子

//===================== 六、全局状态变量 =====================
CTrade              g_trade;                       // 交易对象
int                 g_handleInd      = INVALID_HANDLE; // 均线交叉4指标句柄
int                 g_handleADX      = INVALID_HANDLE;
int                 g_handleATR      = INVALID_HANDLE;
int                 g_handleBands    = INVALID_HANDLE;

datetime g_lastLongAICallTime  = 0;                 // 上一次多单AI请求时间
datetime g_lastShortAICallTime = 0;                 // 上一次空单AI请求时间
bool     g_isRequestRunning    = false;            // 通信锁定标记
string   g_lastFullPromptDump  = "";               // 缓存完整Prompt(预览用)

datetime g_lastSigBarTime       = 0;               // 已处理过的信号K线时间(防同bar重复)
datetime g_lastProcessedBar     = 0;               // 新bar判断
double   g_gridLastEntryPrice   = 0.0;            // 网格最后一单开仓价
int      g_gridCount            = 0;              // 当前网格已开单数

//+------------------------------------------------------------------+
//| EA初始化                                                          |
//+------------------------------------------------------------------+
int OnInit()
{
   g_trade.SetExpertMagicNumber(Inp_Magic);
   g_trade.SetDeviationInPoints((ulong)Inp_Slippage);
   g_trade.SetTypeFillingBySymbol(_Symbol);

   // 创建均线交叉4指标句柄(参数顺序严格对应指标input声明)
   g_handleInd = iCustom(_Symbol, _Period, "均线交叉4",
                         Inp_FastEMA, Inp_SlowEMA,
                         Inp_OnlyLong, Inp_OnlyShort,
                         false, false, false); // 关闭指标自身的报警/推送/邮件,避免EA运行时刷屏
   if(g_handleInd == INVALID_HANDLE)
   {
      Print("[初始化失败] 无法加载自定义指标'均线交叉4',请确认该指标已编译并在MQL5/Indicators目录下");
      return(INIT_FAILED);
   }

   // 创建辅助指标句柄(用于AI行情数据打包)
   g_handleADX   = iADX(_Symbol, _Period, 14);
   g_handleATR   = iATR(_Symbol, _Period, 14);
   g_handleBands = iBands(_Symbol, _Period, 20, 0, 2.0, PRICE_CLOSE);
   if(g_handleADX==INVALID_HANDLE || g_handleATR==INVALID_HANDLE || g_handleBands==INVALID_HANDLE)
   {
      Print("[初始化警告] 辅助指标句柄创建失败,AI数据打包将缺失部分指标");
   }

   EventSetTimer(5);
   Print("AI风控通信控制中心EA加载完成。信号源:均线交叉4(EMA",Inp_FastEMA,"/",Inp_SlowEMA,"+D1 EMA14过滤)");
   Print("【重要】请确认MT5已将 ",Inp_API_Url," 域名加入 工具→选项→EA交易→WebRequest白名单");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| EA卸载                                                            |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(g_handleInd   != INVALID_HANDLE) IndicatorRelease(g_handleInd);
   if(g_handleADX   != INVALID_HANDLE) IndicatorRelease(g_handleADX);
   if(g_handleATR   != INVALID_HANDLE) IndicatorRelease(g_handleATR);
   if(g_handleBands != INVALID_HANDLE) IndicatorRelease(g_handleBands);
   EventKillTimer();
   Print("EA卸载,AI通信控制中心停止工作");
}

//+------------------------------------------------------------------+
//| 新K线判断                                                         |
//+------------------------------------------------------------------+
bool IsNewBar()
{
   datetime t = iTime(_Symbol, _Period, 0);
   if(t != g_lastProcessedBar)
   {
      g_lastProcessedBar = t;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| 七、信号源：读取均线交叉4指标(缓冲区0=上箭头多,1=下箭头空)         |
//| 读取最近2根已收盘K线的箭头值,返回 1=多 -1=空 0=无                  |
//+------------------------------------------------------------------+
int GetIndicatorSignal()
{
   if(g_handleInd == INVALID_HANDLE) return 0;
   double upBuf[2];
   double dnBuf[2];
   // 读取shift 1(刚收盘K线)与shift 2(再前一根),用于新bar防重复
   if(CopyBuffer(g_handleInd, 0, 1, 2, upBuf) < 2) return 0;
   if(CopyBuffer(g_handleInd, 1, 1, 2, dnBuf) < 2) return 0;
   // 信号在shift1(上一根收盘K线)出现且非空值
   bool longSig  = (upBuf[0] != EMPTY_VALUE && upBuf[0] != 0.0);
   bool shortSig = (dnBuf[0] != EMPTY_VALUE && dnBuf[0] != 0.0);
   if(longSig)  return 1;
   if(shortSig) return -1;
   return 0;
}

//+------------------------------------------------------------------+
//| 八、通信控制中心模块1：冷却周期限流校验                             |
//+------------------------------------------------------------------+
bool CheckCoolDownPass(bool direction)
{
   int coolSec = Inp_CoolDownMin * 60;
   datetime now = TimeCurrent();
   datetime lastCall = direction ? g_lastLongAICallTime : g_lastShortAICallTime;
   if(now - lastCall < coolSec)
   {
      Print("[AI控制中心] 冷却周期未结束,跳过AI查询");
      return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| 九、通信控制中心模块2：行情数据打包(N+数据范围)                    |
//+------------------------------------------------------------------+
string BuildMarketDataReport()
{
   string report = "\n==== MARKET INDICATOR DATA REPORT ====\n";
   double close0 = iClose(_Symbol, _Period, 1); // 用已收盘K线
   double adx=0, atr=0, bbMid=0;
   double adxBuf[1], atrBuf[1], bbBuf[1];
   if(g_handleADX!=INVALID_HANDLE && CopyBuffer(g_handleADX,0,1,1,adxBuf)>0) adx=adxBuf[0];
   if(g_handleATR!=INVALID_HANDLE && CopyBuffer(g_handleATR,0,1,1,atrBuf)>0) atr=atrBuf[0];
   if(g_handleBands!=INVALID_HANDLE && CopyBuffer(g_handleBands,0,1,1,bbBuf)>0) bbMid=bbBuf[0];
   report += StringFormat("Symbol:%s  TF:%s\nClose[1]:%.5f\nADX(14):%.2f\nATR(14):%.5f\nBB Middle:%.5f\n",
                          _Symbol, EnumToString(_Period), close0, adx, atr, bbMid);
   report += "Signal Source: EMA crossover(均线交叉4) with D1 EMA14 trend filter\n";

   if(Inp_SendFullDataNPlus)
   {
      report += "\n--- M15 TF Data ---\n" + GetSingleTFData(PERIOD_M15);
      report += "\n--- H1 TF Data ---\n"  + GetSingleTFData(PERIOD_H1);
      report += "\n--- H4 TF Data ---\n"  + GetSingleTFData(PERIOD_H4);
   }
   else
   {
      report += "\n--- M15 & H1 Simplified Data ---\n";
      report += GetSingleTFData(PERIOD_M15) + GetSingleTFData(PERIOD_H1);
   }
   report += "\n==== END DATA REPORT ====\n";
   return report;
}

string GetSingleTFData(ENUM_TIMEFRAMES tf)
{
   double c = iClose(_Symbol, tf, 1);
   int hADX = iADX(_Symbol, tf, 14);
   int hBnd = iBands(_Symbol, tf, 20, 0, 2.0, PRICE_CLOSE);
   double aBuf[1], bBuf[1];
   double adx=0, bmid=0;
   if(hADX!=INVALID_HANDLE && CopyBuffer(hADX,0,1,1,aBuf)>0) adx=aBuf[0];
   if(hBnd!=INVALID_HANDLE && CopyBuffer(hBnd,0,1,1,bBuf)>0) bmid=bBuf[0];
   if(hADX!=INVALID_HANDLE) IndicatorRelease(hADX);
   if(hBnd!=INVALID_HANDLE) IndicatorRelease(hBnd);
   return StringFormat("TF:%s Close:%.5f ADX:%.2f BB_MID:%.5f\n",
                       EnumToString(tf), c, adx, bmid);
}

//+------------------------------------------------------------------+
//| 十、通信控制中心模块3：双提示词拼接                                 |
//+------------------------------------------------------------------+
string BuildFullPrompt(string marketData)
{
   string fullPrompt;
   fullPrompt  = Inp_Prompt1_SystemRole + "\n\n";
   fullPrompt += marketData + "\n\n";
   fullPrompt += "Trading Rule: " + Inp_Prompt2_StrategyRule + "\n";
   fullPrompt += "Return ONLY a single integer between 0 and 100.";
   g_lastFullPromptDump = fullPrompt;
   return fullPrompt;
}

//+------------------------------------------------------------------+
//| JSON字符串安全转义                                                 |
//+------------------------------------------------------------------+
string JsonEscape(string s)
{
   StringReplace(s, "\\", "\\\\"); // 必须先转义反斜杠
   StringReplace(s, "\"", "\\\"");
   StringReplace(s, "\r", "\\r");
   StringReplace(s, "\n", "\\n");
   StringReplace(s, "\t", "\\t");
   return s;
}

//+------------------------------------------------------------------+
//| 十一、通信控制中心模块4：WebRequest发起AI API请求                   |
//| 返回: -1=超时/网络失败, 0~100=AI有效评分                           |
//+------------------------------------------------------------------+
int CallAIModelAPI(string fullPrompt)
{
   if(g_isRequestRunning)
   {
      Print("[AI控制中心] 当前存在未完成API请求,锁定面板,禁止重复调用");
      return -1;
   }
   g_isRequestRunning = true;
   ResetLastError();

   string sysRole  = JsonEscape(Inp_Prompt1_SystemRole);
   string userText = JsonEscape(fullPrompt);

   // 构造OpenAI兼容JSON请求体
   string jsonBody = StringFormat(
      "{\"model\":\"%s\",\"messages\":["
      "{\"role\":\"system\",\"content\":\"%s\"},"
      "{\"role\":\"user\",\"content\":\"%s\"}"
      "],\"stream\":false,\"temperature\":0.2}",
      Inp_ModelName, sysRole, userText);

   string headers = "Content-Type: application/json\r\n";
   headers += "Authorization: Bearer " + Inp_API_Key + "\r\n";

   uchar postBuf[];
   uchar respBuf[];
   string respHeaders;
   StringToCharArray(jsonBody, postBuf, 0, WHOLE_ARRAY, CP_UTF8);
   // 去掉末尾的\0
   if(ArraySize(postBuf) > 0 && postBuf[ArraySize(postBuf)-1] == 0)
      ArrayResize(postBuf, ArraySize(postBuf)-1);

   int timeoutMs = Inp_TimeoutSec * 1000;

   // MQL5 WebRequest 9参数版本(含cookie/referer)
   int httpCode = WebRequest("POST", Inp_API_Url, "", "", headers, timeoutMs,
                             postBuf, respBuf, respHeaders);
   g_isRequestRunning = false;

   if(httpCode == -1)
   {
      int err = GetLastError();
      Print("[AI通信失败] WebRequest错误码:", err, " 超时秒:", Inp_TimeoutSec,
            " 请检查:1)域名白名单 2)URL 3)API Key 4)网络");
      return -1;
   }
   if(httpCode != 200)
   {
      string respText = CharArrayToString(respBuf, 0, WHOLE_ARRAY, CP_UTF8);
      Print("[AI API返回异常] HTTP码:", httpCode, " 响应:", respText);
      return -1;
   }

   string respText = CharArrayToString(respBuf, 0, WHOLE_ARRAY, CP_UTF8);
   int score = ParseAIScoreFromJSON(respText);
   return score;
}

//+------------------------------------------------------------------+
//| 解析AI返回JSON,提取数字评分                                        |
//+------------------------------------------------------------------+
int ParseAIScoreFromJSON(string json)
{
   // 定位 choices[0].message.content
   int pos = StringFind(json, "\"content\"");
   if(pos < 0) { Print("[解析失败] 未找到content字段,原文:",json); return -1; }
   pos = StringFind(json, "\"", pos + 9); // 跳过 "content":
   if(pos < 0) return -1;
   int valStart = pos + 1;
   int valEnd   = StringFind(json, "\"", valStart);
   if(valEnd < 0) return -1;
   string content = StringSubstr(json, valStart, valEnd - valStart);

   // 从content中提取首个连续数字串
   string cleanNum;
   bool started = false;
   for(int i = 0; i < StringLength(content); i++)
   {
      ushort c = StringGetCharacter(content, i);
      if(c >= '0' && c <= '9')
      {
         cleanNum += ShortToString(c);
         started = true;
      }
      else if(started) break;
   }
   if(cleanNum == "") { Print("[解析失败] content无数字,原文:",content); return -1; }
   int score = (int)StringToInteger(cleanNum);
   return (int)MathMax(0, MathMin(100, score));
}

//+------------------------------------------------------------------+
//| 十二、通信控制中心总调度：信号全流程处理                             |
//+------------------------------------------------------------------+
void ProcessTradeSignal(bool direction)
{
   // 阶段1：AI总开关关闭 → 直接放行(纯机械)
   if(!Inp_AI_EnableSwitch)
   {
      Print("[AI总开关关闭] 走纯机械交易,直接开首单");
      OpenAnchorOrder(direction);
      return;
   }

   // 阶段2：冷却周期校验
   if(!CheckCoolDownPass(direction))
   {
      if(Inp_FailMode_OpenImmediately) OpenAnchorOrder(direction);
      return;
   }

   // 阶段3：打包行情 + 拼接Prompt
   string marketData = BuildMarketDataReport();
   string fullPrompt = BuildFullPrompt(marketData);
   Print("[提示词预览完整报文]\n", g_lastFullPromptDump);

   // 阶段4：发起AI请求
   int aiScore = CallAIModelAPI(fullPrompt);
   datetime now = TimeCurrent();
   if(direction) g_lastLongAICallTime = now;
   else          g_lastShortAICallTime = now;

   if(aiScore >= 0)
   {
      Print("[AI评分结果] Score:", aiScore, " 阈值:", Inp_ScoreThreshold);
      if(aiScore >= Inp_ScoreThreshold)
      {
         Print("[AI审核通过] 执行开首单");
         OpenAnchorOrder(direction);
      }
      else
      {
         Print("[AI过滤假信号] 评分不足阈值,放弃开仓");
         return;
      }
   }
   else
   {
      Print("[AI通信故障,执行容灾策略]");
      if(Inp_FailMode_OpenImmediately) OpenAnchorOrder(direction);
      else Print("容灾模式:稳健-放弃本次开仓");
   }
}

//+------------------------------------------------------------------+
//| 十三、网格策略模块                                                 |
//+------------------------------------------------------------------+
// 首单开仓(锚定单),重置网格状态
void OpenAnchorOrder(bool isLong)
{
   if(HasOppositePositions(isLong))
   {
      Print("[网格] 存在反向持仓,跳过开首单(待篮子平仓后重置)");
      return;
   }
   if(CountMyPositions() > 0)
   {
      Print("[网格] 已有同向持仓,跳过重复开首单");
      return;
   }
   if(ExecuteOrder(isLong, Inp_Lot))
   {
      g_gridCount = 1;
      g_gridLastEntryPrice = isLong ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                                    : SymbolInfoDouble(_Symbol, SYMBOL_BID);
      Print("[网格] 首单开仓成功,方向:", (isLong?"多":"空"), " 网格计数:", g_gridCount);
   }
}

// 网格加仓判断与执行(每tick检测)
void ManageGrid()
{
   if(!Inp_GridEnable) return;
   if(g_gridCount <= 0) return;            // 无锚定单,不开网格
   if(g_gridCount >= Inp_GridMaxOrders) return;

   // 取本EA最后一单的方向与开仓价
   double lastPrice = 0.0;
   bool   lastIsLong = true;
   if(!GetLastMyPosition(lastIsLong, lastPrice)) return;
   g_gridLastEntryPrice = lastPrice;

   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double stepPrice = Inp_GridStepPips * point;
   if(stepPrice <= 0) return;

   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   bool trigger = false;

   if(Inp_GridAveraging)
   {
      // 逆势加仓:价格向不利方向移动网格间距时加仓
      if(lastIsLong  && (lastPrice - ask) >= stepPrice) trigger = true;
      if(!lastIsLong && (bid - lastPrice) >= stepPrice) trigger = true;
   }
   else
   {
      // 顺势加仓:价格向有利方向移动网格间距时加仓
      if(lastIsLong  && (ask - lastPrice) >= stepPrice) trigger = true;
      if(!lastIsLong && (lastPrice - bid) >= stepPrice) trigger = true;
   }

   if(!trigger) return;

   // 加仓手数(等比放大)
   double lot = Inp_Lot * MathPow(Inp_GridLotMultiplier, g_gridCount);
   lot = NormalizeLot(lot);

   if(Inp_AI_GateGridOrders && Inp_AI_EnableSwitch)
   {
      // 可选:网格加仓也走AI审核
      if(!CheckCoolDownPass(lastIsLong)) return;
      string md = BuildMarketDataReport();
      string fp = BuildFullPrompt(md);
      fp += "\n[Grid add-on order #" + IntegerToString(g_gridCount+1) + "]";
      int sc = CallAIModelAPI(fp);
      if(lastIsLong) g_lastLongAICallTime = TimeCurrent();
      else           g_lastShortAICallTime = TimeCurrent();
      if(sc < Inp_ScoreThreshold)
      {
         Print("[网格AI审核未通过] Score:", sc, " 跳过本次加仓");
         return;
      }
   }

   if(ExecuteOrder(lastIsLong, lot))
   {
      g_gridCount++;
      Print("[网格] 加仓成功 #", g_gridCount, " 手数:", lot, " 方向:", (lastIsLong?"多":"空"));
   }
}

//+------------------------------------------------------------------+
//| 十四、篮子止盈/止损模块(按magic统计总浮盈亏)                        |
//+------------------------------------------------------------------+
void ManageBasket()
{
   if(!Inp_BasketEnable) return;
   if(CountMyPositions() == 0)
   {
      // 篮子已空,重置网格
      if(g_gridCount != 0) g_gridCount = 0;
      return;
   }

   double totalProfit = 0.0;
   for(int i = PositionsTotal()-1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(!PositionSelectByTicket(tk)) continue;
      if(PositionGetInteger(POSITION_MAGIC) != (long)Inp_Magic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      totalProfit += PositionGetDouble(POSITION_PROFIT)
                   + PositionGetDouble(POSITION_SWAP);
   }

   if(totalProfit >= Inp_BasketTakeProfit)
   {
      Print("[篮子止盈] 总浮盈:", DoubleToString(totalProfit,2), " >= ", Inp_BasketTakeProfit, " 全部平仓");
      CloseAllMyPositions();
      g_gridCount = 0;
   }
   else if(totalProfit <= -Inp_BasketStopLoss)
   {
      Print("[篮子止损] 总浮亏:", DoubleToString(totalProfit,2), " <= -", Inp_BasketStopLoss, " 全部平仓");
      CloseAllMyPositions();
      g_gridCount = 0;
   }
}

//+------------------------------------------------------------------+
//| 持仓辅助函数                                                       |
//+------------------------------------------------------------------+
int CountMyPositions()
{
   int cnt = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(!PositionSelectByTicket(tk)) continue;
      if(PositionGetInteger(POSITION_MAGIC) != (long)Inp_Magic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      cnt++;
   }
   return cnt;
}

bool HasOppositePositions(bool isLong)
{
   for(int i = PositionsTotal()-1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(!PositionSelectByTicket(tk)) continue;
      if(PositionGetInteger(POSITION_MAGIC) != (long)Inp_Magic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      long type = PositionGetInteger(POSITION_TYPE);
      if(isLong  && type == POSITION_TYPE_SELL) return true;
      if(!isLong && type == POSITION_TYPE_BUY)  return true;
   }
   return false;
}

bool GetLastMyPosition(bool &isLong, double &price)
{
   datetime lastTime = 0;
   bool found = false;
   for(int i = PositionsTotal()-1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(!PositionSelectByTicket(tk)) continue;
      if(PositionGetInteger(POSITION_MAGIC) != (long)Inp_Magic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      datetime t = (datetime)PositionGetInteger(POSITION_TIME);
      if(t > lastTime)
      {
         lastTime = t;
         long type = PositionGetInteger(POSITION_TYPE);
         isLong = (type == POSITION_TYPE_BUY);
         price  = PositionGetDouble(POSITION_PRICE_OPEN);
         found = true;
      }
   }
   return found;
}

void CloseAllMyPositions()
{
   for(int i = PositionsTotal()-1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(!PositionSelectByTicket(tk)) continue;
      if(PositionGetInteger(POSITION_MAGIC) != (long)Inp_Magic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(!g_trade.PositionClose(tk))
         Print("[平仓失败] ticket:", tk, " 错误:", g_trade.ResultRetcode(), " ", g_trade.ResultRetcodeDescription());
   }
}

//+------------------------------------------------------------------+
//| 下单执行(完善字段)                                                 |
//+------------------------------------------------------------------+
bool ExecuteOrder(bool isLong, double lot)
{
   lot = NormalizeLot(lot);
   double price = isLong ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                         : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   price = NormalizeDouble(price, digits);

   bool ok = false;
   if(isLong) ok = g_trade.Buy(lot, _Symbol, price, 0, 0, "AI_Risk_EA");
   else       ok = g_trade.Sell(lot, _Symbol, price, 0, 0, "AI_Risk_EA");

   if(!ok)
      Print("[下单失败] ", g_trade.ResultRetcode(), " ", g_trade.ResultRetcodeDescription(),
            " 手数:", lot, " 方向:", (isLong?"多":"空"));
   else
      Print("[下单成功] 订单号:", g_trade.ResultOrder(), " 手数:", lot, " 方向:", (isLong?"多":"空"));
   return ok;
}

// 手数规范化(按品种最小/最大/步长)
double NormalizeLot(double lot)
{
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(stepLot <= 0) stepLot = 0.01;
   lot = MathFloor(lot / stepLot) * stepLot;
   if(lot < minLot) lot = minLot;
   if(lot > maxLot) lot = maxLot;
   return NormalizeDouble(lot, 2);
}

//+------------------------------------------------------------------+
//| 十五、EA主Tick循环                                                 |
//+------------------------------------------------------------------+
void OnTick()
{
   // 1) 篮子止盈止损(每tick最高优先级)
   ManageBasket();
   if(CountMyPositions() == 0) g_gridCount = 0;

   // 2) 网格加仓管理(已有持仓时优先加仓)
   ManageGrid();

   // 3) 信号检测(仅在新K线时,避免重复触发)
   if(!IsNewBar()) return;

   int sig = GetIndicatorSignal();
   if(sig == 0) return;

   datetime sigBarTime = iTime(_Symbol, _Period, 1); // 信号所在收盘K线
   if(sigBarTime == g_lastSigBarTime) return;        // 同一根K线已处理
   g_lastSigBarTime = sigBarTime;

   // 反向信号:可选平掉篮子再反手
   if(Inp_BasketCloseOnReverseSig)
   {
      if(sig == 1 && HasOppositePositions(true))
      {
         Print("[反向信号] 出现多头信号但有空头持仓,先平篮子");
         CloseAllMyPositions(); g_gridCount = 0;
      }
      else if(sig == -1 && HasOppositePositions(false))
      {
         Print("[反向信号] 出现空头信号但有多头持仓,先平篮子");
         CloseAllMyPositions(); g_gridCount = 0;
      }
   }

   // 已有持仓则不再开新首单(由网格模块负责加仓)
   if(CountMyPositions() > 0) return;

   if(sig == 1)
   {
      Print("==== 均线交叉4触发多头信号(EMA金叉+D1过滤) ====");
      ProcessTradeSignal(true);
   }
   else if(sig == -1)
   {
      Print("==== 均线交叉4触发空头信号(EMA死叉+D1过滤) ====");
      ProcessTradeSignal(false);
   }
}

//+------------------------------------------------------------------+
//| 定时器(辅助)                                                      |
//+------------------------------------------------------------------+
void OnTimer()
{
   // 定时复检篮子(防止tick稀疏时漏判)
   ManageBasket();
}
//+------------------------------------------------------------------+
