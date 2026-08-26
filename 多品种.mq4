//EA交易     =>  ...\MT4\MQL4\Experts
//双币16对冲套利.mq4 -- 多品种对冲套利EA
#property version    "1.00"
#property strict

extern double lot=0.02  ;   
extern bool 清仓=false ;   
extern bool 只平不开=false ;   
extern string 时间类型说明="时间类型:1平台时间,2北京时间"  ;  
extern int   时间类型=2  ;   
extern string 开始时间="00:00"  ;  
extern string 截止时间="24:00"  ;  
extern bool H01=true  ;   
extern string H01Symbol="EURCAD"  ;  
extern string H02Symbol="AUDCAD"  ;  
extern bool H02=true  ;   
extern string H03Symbol="AUDCHF"  ;  
extern string H04Symbol="NZDCHF"  ;  
extern bool H03=true  ;   
extern string H05Symbol="EURCAD"  ;  
extern string H06Symbol="GBPCAD"  ;  
extern bool H04=true  ;   
extern string H07Symbol="AUDCAD"  ;  
extern string H08Symbol="NZDCAD"  ;  
extern bool H05=true  ;   
extern string H09Symbol="EURUSD"  ;  
extern string H10Symbol="GBPUSD"  ;  
extern bool H06=true  ;   
extern string H11Symbol="EURAUD"  ;  
extern string H12Symbol="GBPAUD"  ;  
extern bool H07=true  ;   
extern string H13Symbol="AUDUSD"  ;  
extern string H14Symbol="NZDUSD"  ;  
extern bool H08=true  ;   
extern string H15Symbol="EURAUD"  ;  
extern string H16Symbol="EURNZD"  ;  
extern bool H09=true  ;   
extern string H17Symbol="AUDJPY"  ;  
extern string H18Symbol="NZDJPY"  ;  
extern bool H10=true  ;   
extern string H19Symbol="EURJPY"  ;  
extern string H20Symbol="AUDJPY"  ;  
extern bool H11=true  ;   
extern string H21Symbol="GBPNZD"  ;  
extern string H22Symbol="EURAUD"  ;  
extern bool H12=true  ;   
extern string H23Symbol="EURCHF"  ;  
extern string H24Symbol="GBPCHF"  ;  
extern bool H13=true  ;   
extern string H25Symbol="EURJPY"  ;  
extern string H26Symbol="GBPJPY"  ;  
extern bool H14=true  ;   
extern string H27Symbol="EURUSD"  ;  
extern string H28Symbol="NZDUSD"  ;  
extern bool H15=true  ;   
extern string H29Symbol="EURJPY"  ;  
extern string H30Symbol="NZDJPY"  ;  
extern bool H16=true  ;   
extern string H31Symbol="EURCAD"  ;  
extern string H32Symbol="NZDCAD"  ;

// ==========================================
// Panel 模块全局（兼容 MQL4：数组方式，不用 struct）
// ==========================================
string    g_GC_sym1[17];        // 第 1..16 组币对 1
string    g_GC_sym2[17];        // 第 1..16 组币对 2
int       g_GC_signal[17];      // 0=带内 / 1=偏低 / 2=偏高
double    g_GC_beta[17];        // 线性回归斜率
double    g_GC_alpha[17];       // 截距
double    g_GC_devPts[17];      // 偏离点数
int       g_GC_bCnt[17];        // BUY 单数
int       g_GC_sCnt[17];        // SELL 单数
double    g_GC_lots[17];        // 总手数
double    g_GC_pnl[17];         // 盈亏
bool      g_GC_corrReject[17];  // 相关性拒绝
bool      g_GC_active[17];      // H01–H16 对应组的开关
bool      g_PanelInited=false;  // Panel 对象只创建一次
// Activity Log 环形缓冲（最近 8 条事件）
string    g_LogLine[8];
datetime  g_LogTime[8];
int       g_LogPtr=0;

// ========== 颜色常量（hex 整数，MQL4 全版本兼容，0x00BBGGRR）==========
#define CLR_PANEL_BG     0x3F3330
#define CLR_HEADER_BG    0x5C4A44
#define CLR_ALT_ROW      0x4A3C38
#define CLR_ALT_ROW2     0x443632
#define CLR_TOTAL_ROW    0x705850
#define CLR_FRAME        0x70605A
#define CLR_SIDE_BUY     0x50DC50
#define CLR_SIDE_SELL    0x5050FF
#define CLR_SIDE_CORR    0x00E0FF
#define CLR_SIDE_NEUTRAL 0x888888
#define CLR_TEXT_DIM     0x909090
#define CLR_TEXT_META    0xDCDCB0
#define CLR_TEXT_WARN    0x00E0FF
#define CLR_TEXT_PROFIT  0x50DC50
#define CLR_TEXT_LOSS    0x5050FF

// ========== 面板布局常量（全部绝对常量，CORNER=0 左上角坐标系）==========
#define PANEL_LEFT_X     5
#define PANEL_RIGHT_X    505
#define PANEL_TOP_Y      5
#define PANEL_ROW_H      14
#define PANEL_FONT       "Arial"
#define PANEL_FONT_B     "Arial Bold"
// 顶部 KPI 条
#define TOPBAR_Y         5
#define TOPBAR_H         60
#define POS_X            5
#define POS_Y            70
#define POS_W            495
#define POS_HDR_H        18
#define POS_SUM_H        18
#define RISK_X           5
#define RISK_W           495
#define RISK_HDR_H       16
#define SIG_X            505
#define SIG_Y            70
#define SIG_CELL_W       118
#define SIG_CELL_H       40
#define SIG_GAP          4
#define STA_X            505
#define STA_W            490
#define STA_ROW_H        18
#define LOG_X            5
#define LOG_W            990
#define LOG_HDR_H        16
#define LOG_ROW_H        10

// ========== 辅助：标签（统一 CORNER=0，OBJPROP_BACK=false）==========
void SetLabel(string id,string text,int fsize,string fname,color clr,int x,int y) {
   if ( ObjectFind(id) < 0 ) {
      ObjectCreate(id,OBJ_LABEL,0,0,0,0,0,0,0);
      ObjectSet(id,OBJPROP_CORNER,0);
   }
   ObjectSet(id,OBJPROP_XDISTANCE,x);
   ObjectSet(id,OBJPROP_YDISTANCE,y);
   ObjectSetText(id,text,fsize,fname,clr);
}
// ========== 辅助：矩形背景（OBJPROP_BACK=true，背景层，坐标每次都更新）==========
void SetRect(string id,int x,int y,int w,int h,color bg,color brd,int back=1) {
   if ( ObjectFind(id) < 0 ) {
      ObjectCreate(id,OBJ_RECTANGLE_LABEL,0,0,0,0,0,0,0);
      ObjectSet(id,OBJPROP_CORNER,0);
      ObjectSet(id,OBJPROP_XSIZE,w);
      ObjectSet(id,OBJPROP_YSIZE,h);
      ObjectSet(id,OBJPROP_COLOR,brd);
      ObjectSet(id,OBJPROP_BGCOLOR,bg);
      ObjectSet(id,OBJPROP_BORDER_TYPE,1);
      ObjectSet(id,OBJPROP_BACK,back);
   }
   ObjectSet(id,OBJPROP_XDISTANCE,x);
   ObjectSet(id,OBJPROP_YDISTANCE,y);
}
// ========== 辅助：画 1 像素分隔线 ==========
void SetLine(string id,int x,int y,int w,color clr) {
   SetRect(id,x,y,w,1,clr,clr,1);
}

// 环形写一条日志（供 RenderActivityLog 展示）
void PushPanelLog(string line) {
   g_LogLine[g_LogPtr] = TimeToString(TimeCurrent(),TIME_MINUTES)+"| "+line;
   g_LogTime[g_LogPtr] = TimeCurrent();
   g_LogPtr = (g_LogPtr + 1) % 8;
}

// ===== Panel 模块函数原型（SetLabel/SetRect 已在前文定义，此处声明后文定义的函数）=====
void EnsurePanelObjects();
void RefreshGroupCache();
void RenderAccountKPI();
void RenderSignalMatrix();
void RenderStatusPillars();
void RenderPositionTable();
void RenderRiskMonitor();
void RenderActivityLog();

 string    g_Symbol1 = "";
 string    g_Symbol2 = "";
 int       by_in_3 = 0;
 int       by_in_4 = 0;
 int       by_in_5 = 0;
 bool      by_bo_6 = true;
 bool      by_bo_7 = false;
 bool      by_bo_8 = false;
 bool      by_bo_9 = false;
 bool      by_bo_10 = false;
 bool      by_bo_11 = false;
 bool      by_bo_12 = false;
 bool      by_bo_13 = false;
 bool      by_bo_14 = false;
 bool      by_bo_15 = false;
 bool      by_bo_16 = false;
 bool      by_bo_17 = false;
 bool      by_bo_18 = false;
 bool      by_bo_19 = false;
 bool      by_bo_20 = false;
 bool      by_bo_21 = false;
 bool      by_bo_22 = false;
 bool      by_bo_23 = false;
 bool      by_bo_24 = false;
 bool      by_bo_25 = false;
 bool      by_bo_26 = false;
 bool      by_bo_27 = false;
 bool      by_bo_28 = false;
 bool      by_bo_29 = false;
 bool      by_bo_30 = false;
 bool      by_bo_31 = false;
 bool      by_bo_32 = false;
 bool      by_bo_33 = false;
 bool      by_bo_34 = false;
 bool      by_bo_35 = false;
 bool      by_bo_36 = false;
 bool      by_bo_37 = false;
 bool      by_bo_38 = false;
 bool      by_bo_39 = false;
 bool      by_bo_40 = false;
 bool      by_bo_41 = false;
 bool      by_bo_42 = false;
 bool      by_bo_43 = false;
 bool      by_bo_44 = false;
 bool      by_bo_45 = false;
 bool      by_bo_46 = false;
 bool      by_bo_47 = false;
 bool      by_bo_48 = false;
 bool      by_bo_49 = false;
 bool      by_bo_50 = false;
 bool      by_bo_51 = false;
 bool      by_bo_52 = false;
 bool      by_bo_53 = false;
 bool      by_bo_54 = false;
 bool      by_bo_55 = false;
 bool      by_bo_56 = false;
 bool      by_bo_57 = false;
 int       by_in_58 = 0;
 int       by_in_59 = 0;
 int       by_in_60 = 0;
 int       by_in_61 = 0;
 int       by_in_62 = 0;
 int       by_in_63 = 0;
 int       by_in_64 = 0;
 int       by_in_65 = 0;
 int       by_in_66 = 0;
 int       by_in_67 = 0;
 int       by_in_68 = 0;
 int       by_in_69 = 0;
 int       by_in_70 = 0;
 int       by_in_71 = 0;
 int       by_in_72 = 0;
 int       by_in_73 = 0;
 int       by_in_74 = 0;
 int       by_in_75 = 0;
 int       by_in_76 = 0;
 int       by_in_77 = 0;
 int       by_in_78 = 0;
 int       by_in_79 = 0;
 int       by_in_80 = 0;
 int       by_in_81 = 0;
 int       by_in_82 = 0;
 int       by_in_83 = 0;
 int       by_in_84 = 0;
 int       by_in_85 = 0;
 int       by_in_86 = 0;
 int       by_in_87 = 0;
 int       by_in_88 = 0;
 int       by_in_89 = 0;
 int       by_in_90 = 0;
 int       by_in_91 = 0;
 double    by_do_92 = 0;
 int       by_in_93 = 0;
 double    by_do_94 = 0;
 int       by_in_95 = 0;
 double    by_do_96 = 0;
 int       by_in_97 = 0;
 double    by_do_98 = 0;
 int       by_in_99 = 0;
 double    by_do_100 = 0;
 bool      by_bo_101 = false;
 bool      by_bo_102 = false;
 int       by_in_103 = 1;
 string    g_GroupName = "";
 int       by_in_105[3392];
 int       by_in_106[3392];
 int       g_SpreadSignal = 0;
double    g_RegressionBeta = 0.0;   // 最近一次 CalcSpreadSignal：线性回归斜率 β
double    g_RegressionAlpha = 0.0;  // 截距 α
double    g_RegressionDev = 0.0;    // 实际偏离点数（带符号）
int       by_in_108 = 0;
 int       by_in_109 = 0;
 double    by_do_110 = 0;
 double    by_do_111 = 0;
 double    by_do_112 = 0;
 double    by_do_113 = 0;
 double    by_do_114 = 0;
 int       by_in_115 = 0;
 int       by_in_116 = 0;
 int       by_in_117 = 0;
 int       by_in_118 = 0;
 int       by_in_119 = 0;
 int       by_in_120 = 0;
 int       by_in_121 = 0;
 int       by_in_122 = 0;
 int       by_in_123 = 0;
 double    by_do_124 = 0;
 double    by_do_125 = 0;
 double    by_do_126 = 0;
 double    by_do_127 = 0;
 double    by_do_128 = 0;
 double    by_do_129 = 0;
 double    by_do_130 = 0;
 double    by_do_131 = 0;
 double    by_do_132 = 0;
 double    by_do_133 = 0;
 double    by_do_134 = 0;
 double    by_do_135 = 0;
 double    by_do_136 = 0;
 double    by_do_137 = 0;
 double    by_do_138 = 0;
 double    by_do_139 = 0;
 double    by_do_140 = 0;
 double    by_do_141 = 0;
 double    by_do_142 = 0;
 double    by_do_143 = 0;
 double    by_do_144 = 0;
 double    by_do_145 = 0;
 double    by_do_146 = 0;
 double    by_do_147 = 0;
 long      by_lo_148 = 0;
 long      by_lo_149 = 0;
 long      by_lo_150 = 0;
 long      by_lo_151 = 0;
 long      by_lo_152 = 0;
 long      by_lo_153 = 0;
 double    by_do_154 = 0;
 double    by_do_155 = 0;
 double    by_do_156 = 0;
 double    by_do_157 = 0;
 double    by_do_158 = 0;
 double    by_do_159 = 0;
 double    by_do_160 = 0;
 double    by_do_161 = 0;
 double    by_do_162 = 0;
 double    by_do_163 = 0;
 double    by_do_164 = 0;
 bool      by_bo_165 = false;
 int       by_in_166 = 0;
 int       by_in_167 = 0;
 int       by_in_168 = 0;
 int       by_in_169 = 0;
 int       by_in_170 = 0;
 int       by_in_171 = 0;
 int       by_in_172 = 0;
 int       by_in_173 = 0;
 int       by_in_174 = 0;
 int       by_in_175 = 0;
 int       by_in_176 = 0;
 int       by_in_177 = 0;
 int       by_in_178 = 0;
 int       by_in_179 = 0;
 int       by_in_180 = 0;
 int       by_in_181 = 0;
 int       by_in_182 = 0;
 double    by_do_183 = 0;
 double    by_do_184 = 0;
 double    by_do_185 = 0;
 double    by_do_186 = 0;
 double    by_do_187 = 0;
 double    by_do_188 = 0;
 double    by_do_189 = 0;
 double    by_do_190 = 0;
 double    by_do_191 = 0;
 double    by_do_192 = 0;
 double    by_do_193 = 0;
 double    by_do_194 = 0;
 double    by_do_195 = 0;
 double    by_do_196 = 0;
 double    by_do_197 = 0;
 double    by_do_198 = 0;
 double    by_do_199 = 0;
 double    by_do_200 = 0;
 double    by_do_201 = 0;
 double    by_do_202 = 0;
 double    by_do_203 = 0;
 double    by_do_204 = 0;
 double    by_do_205 = 0;
 double    by_do_206 = 0;
 double    by_do_207 = 0;
 double    by_do_208 = 0;
 double    by_do_209 = 0;
 double    by_do_210 = 0;
 double    by_do_211 = 0;
 double    by_do_212 = 0;
 double    by_do_213 = 0;
 double    by_do_214 = 0;
 double    by_do_215 = 0;
 double    by_do_216 = 0;
 double    by_do_217 = 0;
 double    by_do_218 = 0;
 double    by_do_219 = 0;
 double    by_do_220 = 0;
 double    by_do_221 = 0;
 double    by_do_222 = 0;
 double    by_do_223 = 0;
 double    by_do_224 = 0;
 double    by_do_225 = 0;
 double    by_do_226 = 0;
 double    by_do_227 = 0;
 double    by_do_228 = 0;
 double    by_do_229 = 0;
 double    by_do_230 = 0;
 double    by_do_231 = 0;
 double    by_do_232 = 0;
 double    by_do_233 = 0;
 double    by_do_234 = 0;
 double    by_do_235 = 0;
 double    by_do_236 = 0;
 double    by_do_237 = 0;
 double    by_do_238 = 0;
 double    by_do_239 = 0;
 double    by_do_240 = 0;
 double    by_do_241 = 0;
 double    by_do_242 = 0;
 double    by_do_243 = 0;
 double    by_do_244 = 0;
 double    by_do_245 = 0;
 double    by_do_246 = 0;
 double    by_do_247 = 0;
 double    by_do_248 = 0;
 double    by_do_249 = 0;
 double    by_do_250 = 0;
 string    by_st_251 = "";
 string    by_st_252;
 string    by_st_253;
 string    by_st_254;
 string    by_st_255;
 double    by_do_256 = 0;
 double    by_do_257 = 0;
 double    by_do_258 = 0;
 double    by_do_259 = 0;
 double    by_do_260 = 0;
 double    by_do_261 = 0;
 double    by_do_262 = 0;
 double    by_do_263 = 0;
 double    by_do_264 = 0;
 double    by_do_265 = 0;
 double    by_do_266 = 0;
 double    by_do_267 = 0;
 double    by_do_268 = 0;
 double    by_do_269 = 0;
 double    g_BaseLot = 0;
 double    g_RiskLot = 0;
 string    by_st_272;
 string    by_st_273;
 string    by_st_274;
 string    by_st_275;
 string    by_st_276 = "";
 string    by_st_277 = "";
 double    by_do_278 = 0;
 double    by_do_279 = 0;
 double    by_do_280 = 0;
 double    by_do_281 = 0;
 double    by_do_282 = 0;
 double    by_do_283 = 0;
 double    by_do_284 = 0;
 double    by_do_285 = 0;
 double    by_do_286 = 0;
 double    by_do_287 = 0;
 double    by_do_288 = 0;
 int       by_in_289 = -1;
 int       by_in_290 = -1;
 int       by_in_291 = -1;
 int       g_MagicNumber = 0; // 魔术吗
 double    by_do_293 = MarketInfo(H01Symbol,18);
 double    by_do_294 = MarketInfo(H01Symbol,19);
 double    by_do_295 = MarketInfo(H02Symbol,18);
 double    by_do_296 = MarketInfo(H02Symbol,19);
 double    by_do_297 = MarketInfo(H03Symbol,18);
 double    by_do_298 = MarketInfo(H03Symbol,19);
 double    by_do_299 = MarketInfo(H04Symbol,18);
 double    by_do_300 = MarketInfo(H04Symbol,19);
 double    by_do_301 = MarketInfo(H05Symbol,18);
 double    by_do_302 = MarketInfo(H05Symbol,19);
 double    by_do_303 = MarketInfo(H06Symbol,18);
 double    by_do_304 = MarketInfo(H06Symbol,19);
 double    by_do_305 = MarketInfo(H07Symbol,18);
 double    by_do_306 = MarketInfo(H07Symbol,19);
 double    by_do_307 = MarketInfo(H08Symbol,18);
 double    by_do_308 = MarketInfo(H08Symbol,19);
 double    by_do_309 = MarketInfo(H09Symbol,18);
 double    by_do_310 = MarketInfo(H09Symbol,19);
 double    by_do_311 = MarketInfo(H10Symbol,18);
 double    by_do_312 = MarketInfo(H10Symbol,19);
 double    by_do_313 = MarketInfo(H11Symbol,18);
 double    by_do_314 = MarketInfo(H11Symbol,19);
 double    by_do_315 = MarketInfo(H12Symbol,18);
 double    by_do_316 = MarketInfo(H12Symbol,19);
 double    by_do_317 = MarketInfo(H13Symbol,18);
 double    by_do_318 = MarketInfo(H13Symbol,19);
 double    by_do_319 = MarketInfo(H14Symbol,18);
 double    by_do_320 = MarketInfo(H14Symbol,19);
 double    by_do_321 = MarketInfo(H15Symbol,18);
 double    by_do_322 = MarketInfo(H15Symbol,19);
 double    by_do_323 = MarketInfo(H16Symbol,18);
 double    by_do_324 = MarketInfo(H16Symbol,19);
 double    by_do_325 = MarketInfo(H17Symbol,18);
 double    by_do_326 = MarketInfo(H17Symbol,19);
 double    by_do_327 = MarketInfo(H18Symbol,18);
 double    by_do_328 = MarketInfo(H18Symbol,19);
 double    by_do_329 = MarketInfo(H19Symbol,18);
 double    by_do_330 = MarketInfo(H19Symbol,19);
 double    by_do_331 = MarketInfo(H20Symbol,19);
 double    by_do_332 = MarketInfo(H20Symbol,18);
 double    by_do_333 = MarketInfo(H21Symbol,19);
 double    by_do_334 = MarketInfo(H21Symbol,18);
 double    by_do_335 = MarketInfo(H22Symbol,19);
 double    by_do_336 = MarketInfo(H22Symbol,18);
 double    by_do_337 = MarketInfo(H23Symbol,19);
 double    by_do_338 = MarketInfo(H23Symbol,18);
 double    by_do_339 = MarketInfo(H24Symbol,19);
 double    by_do_340 = MarketInfo(H24Symbol,18);
 double    by_do_341 = MarketInfo(H25Symbol,18);
 double    by_do_342 = MarketInfo(H25Symbol,19);
 double    by_do_343 = MarketInfo(H26Symbol,18);
 double    by_do_344 = MarketInfo(H26Symbol,19);
 double    by_do_345 = MarketInfo(H27Symbol,18);
 double    by_do_346 = MarketInfo(H27Symbol,19);
 double    by_do_347 = MarketInfo(H28Symbol,18);
 double    by_do_348 = MarketInfo(H28Symbol,19);
 double    by_do_349 = MarketInfo(H29Symbol,18);
 double    by_do_350 = MarketInfo(H29Symbol,19);
 double    by_do_351 = MarketInfo(H30Symbol,18);
 double    by_do_352 = MarketInfo(H30Symbol,19);
 double    by_do_353 = MarketInfo(H31Symbol,18);
 double    by_do_354 = MarketInfo(H31Symbol,19);
 double    by_do_355 = MarketInfo(H32Symbol,18);
 double    by_do_356 = MarketInfo(H32Symbol,19);

 int OnInit ()
 {

 double     aa_do_2;
 double     aa_do_3;

 if ( ( Symbol()=="EURAUD.sm" || Symbol()=="EURAUD.s" ) )
  {
  g_MagicNumber = 101101 ;
  }
 if ( ( Symbol()=="AUDUSDm.s" || Symbol()=="AUDUSD.s" ) )
  {
  g_MagicNumber = 101102 ;
  }
 if ( ( Symbol()=="GBPAUD.sm" || Symbol()=="GBPAUD.s" ) )
  {
  g_MagicNumber = 101103 ;
  }
 if ( ( Symbol()=="NZDUSD.sm" || Symbol()=="NZDUSD.s" ) )
  {
  g_MagicNumber = 101104 ;
  }
 if ( ( Symbol()=="EURUSD.sm" || Symbol()=="EURUSD.s" ) )
  {
  g_MagicNumber = 101105 ;
  }
 if ( ( Symbol()=="USDCHF.sm" || Symbol()=="USDCHF.s" ) )
  {
  g_MagicNumber = 101106 ;
  }
 if ( ( Symbol()=="GBPUSD.sm" || Symbol()=="GBPUSD.s" ) )
  {
  g_MagicNumber = 101107 ;
  }
 if ( ( Symbol()=="USDCAD.sm" || Symbol()=="USDCAD.s" ) )
  {
  g_MagicNumber = 101108 ;
  }
 if ( ( Symbol()=="GBPCAD.sm" || Symbol()=="GBPCAD.s" ) )
  {
  g_MagicNumber = 101109 ;
  }
 if ( ( Symbol()=="USDJPY.sm" || Symbol()=="USDJPY.s" ) )
  {
  g_MagicNumber = 101110 ;
  }
 if ( ( Symbol()=="EURGBP.sm" || Symbol()=="EURGBP.s" ) )
  {
  g_MagicNumber = 101111 ;
  }
 if ( ( Symbol()=="NZDJPY.sm" || Symbol()=="NZDJPY.s" ) )
  {
  g_MagicNumber = 101112 ;
  }
 if ( ( Symbol()=="AUDCHF.sm" || Symbol()=="AUDCHF.s" ) )
  {
  g_MagicNumber = 101113 ;
  }
 if ( ( Symbol()=="EURCHF.sm" || Symbol()=="EURCHF.s" ) )
  {
  g_MagicNumber = 101115 ;
  }
 if ( ( Symbol()=="EURNZD.sm" || Symbol()=="EURNZD.s" ) )
  {
  g_MagicNumber = 101116 ;
  }
 if ( ( Symbol()=="AUDNZD.sm" || Symbol()=="AUDNZD.s" ) )
  {
  g_MagicNumber = 101117 ;
  }
 if ( ( Symbol()=="CADCHF.sm" || Symbol()=="CADCHF.s" ) )
  {
  g_MagicNumber = 101118 ;
  }
 if ( ( Symbol()=="NZDCHF.sm" || Symbol()=="NZDCHF.s" ) )
  {
  g_MagicNumber = 101119 ;
  }
 if ( ( Symbol()=="GBPCHF.sm" || Symbol()=="GBPCHF.s" ) )
  {
  g_MagicNumber = 101120 ;
  }
 if ( ( Symbol()=="AUDCAD.sm" || Symbol()=="AUDCAD.s" ) )
  {
  g_MagicNumber = 101121 ;
  }
 if ( ( Symbol()=="NZDCAD.sm" || Symbol()=="NZDCAD.s" ) )
  {
  g_MagicNumber = 101122 ;
  }
 if ( ( Symbol()=="EURCAD.sm" || Symbol()=="EURCAD.s" ) )
  {
  g_MagicNumber = 101123 ;
  }
 if ( ( Symbol()=="EURJPY.sm" || Symbol()=="EURJPY.s" ) )
  {
  g_MagicNumber = 101124 ;
  }
 if ( ( Symbol()=="GBPJPY.sm" || Symbol()=="GBPJPY.s" ) )
  {
  g_MagicNumber = 101125 ;
  }
 if ( ( Symbol()=="AUDJPY.sm" || Symbol()=="AUDJPY.s" ) )
  {
  g_MagicNumber = 101126 ;
  }
 if ( ( Symbol()=="CHFJPY.sm" || Symbol()=="CHFJPY.s" ) )
  {
  g_MagicNumber = 101129 ;
  }
 if ( ( Symbol()=="CADJPY.sm" || Symbol()=="CADJPY.s" ) )
  {
  g_MagicNumber = 101130 ;
  }
 if ( ( Symbol()=="GBPNZD.sm" || Symbol()=="GBPNZD.s" ) )
  {
  g_MagicNumber = 101131 ;
  }
 aa_do_2 = MarketInfo(Symbol(),33);
 if ( aa_do_2<=MarketInfo(Symbol(),14) )
  {
  aa_do_3 = MarketInfo(Symbol(),14);
  }
 else
  {
  aa_do_3 = aa_do_2;
  }
 by_do_111 = aa_do_3 * Point() ;
 return(0); 
 }

 void OnTick ()
 {

 int        aa_in_10;
 int        aa_in_12;
 long       aa_lo_13;
 long       aa_lo_18;
 bool       aa_bo_21;
 int        aa_in_17;

  RefreshPositions(); 
  g_BaseLot = lot ;
  ObjectDelete("QIAN"); 
  ObjectCreate("QIAN",OBJ_HLINE,0,0,0,0,0,0,0); 
  ObjectSet("QIAN",OBJPROP_PRICE1,Ask); 
  ObjectSet("QIAN",OBJPROP_COLOR,Yellow); 
  ObjectDelete("11"); 
  ObjectCreate("11",OBJ_TEXT,0,Time[0],Ask + by_do_110,0,0,0,0); 
  ObjectSetText("11","状态：挂单对冲系列运行中",12,"Regular script",Red); 
  UpdateStatusDisplay(); 
  UpdateRiskParams(); 
  aa_in_10 = 0;
  for (aa_in_12 = HistoryTotal() - 1 ; aa_in_12>=0 ; aa_in_12=aa_in_12 - 1)
   {
   if ( OrderSelect(aa_in_12,SELECT_BY_POS,MODE_HISTORY)!=false && OrderSymbol()==Symbol() && OrderMagicNumber()==g_MagicNumber )
    {
    aa_lo_13 = OrderCloseTime();
    aa_lo_18=StringToTime(TimeToString(TimeCurrent() - (1 - 1) * 86400,TIME_DATE)) + 86400; 
    if ( StringToTime(TimeToString(TimeCurrent() - (1 - 1) * 86400,TIME_DATE))< OrderOpenTime() && aa_lo_18>aa_lo_13 )
     {
     aa_bo_21 = true;
     }
    else
     {
     aa_bo_21 = false;
     }
    if ( aa_bo_21 )
     {
     if ( OrderProfit()<0 )
      {
      aa_in_10=aa_in_10 + 1; 
      }
     else
      {
      aa_in_17 = aa_in_10;
      break;
    }}}
   }
  aa_in_17 = aa_in_10;
  if ( aa_in_17<=10 )
   {
   RefreshPositions(); 
   ProcessAllGroups(); 
  }
 }

 void OnTimer ()
 {

 int        aa_in_10;
 int        aa_in_12;
 long       aa_lo_13;
 long       aa_lo_18;
 bool       aa_bo_21;
 int        aa_in_17;
   
 
RefreshPositions(); 
g_BaseLot = lot ;
ObjectDelete("QIAN"); 
ObjectCreate("QIAN",OBJ_HLINE,0,0,0,0,0,0,0); 
ObjectSet("QIAN",OBJPROP_PRICE1,Ask); 
ObjectSet("QIAN",OBJPROP_COLOR,Yellow); 
ObjectDelete("11"); 
ObjectCreate("11",OBJ_TEXT,0,Time[0],Ask + by_do_110,0,0,0,0); 
ObjectSetText("11","状态：挂单对冲系列运行中",12,"Regular script",Red); 
UpdateStatusDisplay(); 
UpdateRiskParams(); 
aa_in_10 = 0;
for (aa_in_12 = HistoryTotal() - 1 ; aa_in_12>=0 ; aa_in_12=aa_in_12 - 1)
 {
 if ( OrderSelect(aa_in_12,SELECT_BY_POS,MODE_HISTORY)!=false && OrderSymbol()==Symbol() && OrderMagicNumber()==g_MagicNumber )
  {
  aa_lo_13 = OrderCloseTime();
  aa_lo_18=StringToTime(TimeToString(TimeCurrent() - (1 - 1) * 86400,TIME_DATE)) + 86400; 
  if ( StringToTime(TimeToString(TimeCurrent() - (1 - 1) * 86400,TIME_DATE))< OrderOpenTime() && aa_lo_18>aa_lo_13 )
   {
   aa_bo_21 = true;
   }
  else
   {
   aa_bo_21 = false;
   }
  if ( aa_bo_21 )
   {
   if ( OrderProfit()<0 )
    {
    aa_in_10=aa_in_10 + 1; 
    }
   else
    {
    aa_in_17 = aa_in_10;
    break;
  }}}
 }
aa_in_17 = aa_in_10;
if ( aa_in_17<=10 )
 {
 RefreshPositions(); 
 ProcessAllGroups(); 
}
 }

 void OnDeinit (const int bsw_0)
 {

 ObjectsDeleteAll(-1,-1); 
 Comment(""); 
 }

 int ProcessAllGroups()
 {
 double      dfz_do_1=0.0;
 double      dfz_do_2=0.0;
 double      dfz_do_3=0.0;
 double      dfz_do_4=0.0;
 double      dfz_do_5=0.0;
 double      dfz_do_6=0.0;
 double      dfz_do_7=0.0;
 double      dfz_do_8=0.0;

 int        aa_in_9;
 int        aa_in_11;
 long       aa_lo_12;
 long       aa_lo_17;
 bool       aa_bo_20;
 int        aa_in_16;

 dfz_do_1 = GetCurrencyStrength("USD",0) ;
 dfz_do_2 = GetCurrencyStrength("GBP",0) ;
 dfz_do_3 = GetCurrencyStrength("EUR",0) ;
 dfz_do_4 = GetCurrencyStrength("AUD",0) ;
 dfz_do_5 = GetCurrencyStrength("CAD",0) ;
 dfz_do_6 = GetCurrencyStrength("JPY",0) ;
 dfz_do_7 = GetCurrencyStrength("CHF",0) ;
 dfz_do_8 = GetCurrencyStrength("NZD",0) ;
 aa_in_9 = 0;
 for (aa_in_11 = HistoryTotal() - 1 ; aa_in_11>=0 ; aa_in_11=aa_in_11 - 1)
  {
  if ( OrderSelect(aa_in_11,SELECT_BY_POS,MODE_HISTORY)!=false && OrderSymbol()==Symbol() && OrderMagicNumber()==g_MagicNumber )
   {
   aa_lo_12 = OrderCloseTime();
   aa_lo_17=StringToTime(TimeToString(TimeCurrent() - (1 - 1) * 86400,TIME_DATE)) + 86400; 
   if ( StringToTime(TimeToString(TimeCurrent() - (1 - 1) * 86400,TIME_DATE))< OrderOpenTime() && aa_lo_17>aa_lo_12 )
    {
    aa_bo_20 = true;
    }
   else
    {
    aa_bo_20 = false;
    }
   if ( aa_bo_20 )
    {
    if ( OrderProfit()<0 )
     {
     aa_in_9=aa_in_9 + 1; 
     }
    else
     {
     aa_in_16 = aa_in_9;
     break;
   }}}
  }
 aa_in_16 = aa_in_9;
 if ( aa_in_16>=10 )
  {
  return(0); 
  }
 if ( 清仓 )
  {
  return(0); 
  }
 if ( H01 )
  {
  g_GroupName = "第1组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第1组2"); 
  }
 if ( H02 )
  {
  g_GroupName = "第2组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第2组2"); 
  }
 if ( H03 )
  {
  g_GroupName = "第3组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第3组2"); 
  }
 if ( H04 )
  {
  g_GroupName = "第4组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第4组2"); 
  }
 if ( H05 )
  {
  g_GroupName = "第5组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第5组2"); 
  }
 if ( H06 )
  {
  g_GroupName = "第6组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第6组2"); 
  }
 if ( H07 )
  {
  g_GroupName = "第7组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第7组2"); 
  }
 if ( H08 )
  {
  g_GroupName = "第8组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第8组2"); 
  }
 if ( H09 )
  {
  g_GroupName = "第9组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第9组2"); 
  }
 if ( H10 )
  {
  g_GroupName = "第10组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第10组2"); 
  }
 if ( H11 )
  {
  g_GroupName = "第11组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第11组2"); 
  }
 if ( H12 )
  {
  g_GroupName = "第12组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第12组2"); 
  }
 if ( H13 )
  {
  g_GroupName = "第13组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第13组2"); 
  }
 if ( H14 )
  {
  g_GroupName = "第14组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第14组2"); 
  }
 if ( H15 )
  {
  g_GroupName = "第15组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第15组2"); 
  }
 if ( H16 )
  {
  g_GroupName = "第16组2" ;
  CalcSpreadSignal(); 
  ManageGroup("第16组2"); 
  }
 return(0); 
 }

 int RefreshPositions()
 {
 double      dfz_do_1=0.0;
 double      dfz_do_2=0.0;
 double      dfz_do_3=0.0;
 double      dfz_do_4=0.0;
 double      dfz_do_5=0.0;
 double      dfz_do_6=0.0;
 double      dfz_do_7=0.0;
 double      dfz_do_8=0.0;
 double      dfz_do_9=0.0;
 double      dfz_do_10=0.0;
 double      dfz_do_11=0.0;
 double      dfz_do_12=0.0;
 double      dfz_do_13=0.0;
 double      dfz_do_14=0.0;
 double      dfz_do_15=0.0;
 double      dfz_do_16=0.0;
 double      dfz_do_17=0.0;
 double      dfz_do_18=0.0;
 double      dfz_do_19=0.0;
 double      dfz_do_20=0.0;
 double      dfz_do_21=0.0;
 double      dfz_do_22=0.0;
 double      dfz_do_23=0.0;
 double      dfz_do_24=0.0;
 double      dfz_do_25=0.0;
 double      dfz_do_26=0.0;
 double      dfz_do_27=0.0;
 double      dfz_do_28=0.0;
 double      dfz_do_29=0.0;
 double      dfz_do_30=0.0;
 double      dfz_do_31=0.0;
 double      dfz_do_32=0.0;
 bool        dfz_bo_33;

 double     aa_do_2;
 int        aa_in_5;
 int        aa_in_6;
 long       aa_lo_7;
 long       aa_lo_12;
 bool       aa_bo_15;
 double     aa_do_21;
 string     aa_st_22;
 double     aa_do_23;
 int        aa_in_24;
 string     aa_st_27;
 bool       aa_bo_28;
 int        aa_in_25;
 double     aa_do_30;
 string     aa_st_41;
 double     aa_do_31;
 int        aa_in_32;
 string     aa_st_44;
 bool       aa_bo_45;
 int        aa_in_42;
 double     aa_do_47;
 string     aa_st_59;
 double     aa_do_48;
 int        aa_in_49;
 string     aa_st_62;
 bool       aa_bo_54;
 int        aa_in_60;
 double     aa_do_64;
 string     aa_st_76;
 double     aa_do_65;
 int        aa_in_66;
 string     aa_st_79;
 bool       aa_bo_71;
 int        aa_in_77;
 double     aa_do_81;
 string     aa_st_93;
 double     aa_do_82;
 int        aa_in_83;
 string     aa_st_96;
 int        aa_in_85;
 double     aa_do_98;
 string     aa_st_108;
 double     aa_do_99;
 int        aa_in_100;
 string     aa_st_111;
 bool       aa_bo_95;
 int        aa_in_109;
 double     aa_do_113;
 string     aa_st_125;
 double     aa_do_114;
 int        aa_in_115;
 string     aa_st_128;
 bool       aa_bo_120;
 int        aa_in_126;
 double     aa_do_130;
 string     aa_st_142;
 double     aa_do_131;
 int        aa_in_132;
 string     aa_st_145;
 bool       aa_bo_137;
 int        aa_in_143;
 double     aa_do_147;
 string     aa_st_159;
 double     aa_do_148;
 int        aa_in_149;
 string     aa_st_162;
 bool       aa_bo_154;
 int        aa_in_160;
 double     aa_do_164;
 string     aa_st_176;
 double     aa_do_165;
 int        aa_in_166;
 string     aa_st_179;
 bool       aa_bo_171;
 int        aa_in_177;
 double     aa_do_181;
 string     aa_st_193;
 double     aa_do_182;
 int        aa_in_183;
 string     aa_st_196;
 bool       aa_bo_188;
 int        aa_in_194;
 double     aa_do_198;
 string     aa_st_210;
 double     aa_do_199;
 int        aa_in_200;
 string     aa_st_213;
 bool       aa_bo_205;
 int        aa_in_211;
 double     aa_do_215;
 string     aa_st_227;
 double     aa_do_216;
 int        aa_in_217;
 string     aa_st_230;
 bool       aa_bo_222;
 int        aa_in_228;
 double     aa_do_232;
 string     aa_st_244;
 double     aa_do_233;
 int        aa_in_234;
 string     aa_st_247;
 bool       aa_bo_239;
 int        aa_in_245;
 double     aa_do_249;
 string     aa_st_261;
 double     aa_do_250;
 int        aa_in_251;
 string     aa_st_264;
 bool       aa_bo_256;
 int        aa_in_262;
 double     aa_do_266;
 string     aa_st_278;
 double     aa_do_267;
 int        aa_in_268;
 string     aa_st_281;
 bool       aa_bo_273;
 int        aa_in_279;

 dfz_bo_33 = false ;
 if (by_do_226 + by_do_227>( -g_BaseLot) * 20000 )  
 {
 dfz_bo_33 = true ;
 }
 else
 {
 dfz_bo_33 = false ;
 }
 if ( 清仓 )
  {
  CloseAllPositions(); 
  }
 if ( ( MarketInfo(by_st_275,12)==5 || MarketInfo(by_st_275,12)==3 ) )
  {
  by_do_278 = 10 ;
  }
 else
  {
  by_do_278 = 1 ;
  }
 if ( by_do_226 + by_do_227>g_BaseLot * 40000 )
  {
  CloseAllPositions(); 
  if ( by_do_190 + by_do_189==0 )
   {
   aa_do_2 = 0;
   aa_in_5 = 1;
   for (aa_in_6 = 0 ; aa_in_6<HistoryTotal() ; aa_in_6=aa_in_6 + 1)
    {
    if ( OrderSelect(aa_in_6,SELECT_BY_POS,MODE_HISTORY)!=false )
     {
     aa_lo_7 = OrderCloseTime();
     aa_lo_12=StringToTime(TimeToString(TimeCurrent() - (aa_in_5 - 1) * 86400,TIME_DATE)) + 86400; 
     if ( StringToTime(TimeToString(TimeCurrent() - (aa_in_5 - 1) * 86400,TIME_DATE))< OrderOpenTime() && aa_lo_12>aa_lo_7 )
      {
      aa_bo_15 = true;
      }
     else
      {
      aa_bo_15 = false;
      }
     if ( aa_bo_15 )
      {
      aa_do_2 = aa_do_2 + OrderProfit();
     }}
    }
   Alert("整体平仓完成,日内盈利:",DoubleToString(aa_do_2,2)); 
   }
  by_bo_7 = false ;
  }
 CalcGroupProfit(H01Symbol,"第1组2"); 
 dfz_do_1 = by_do_211 ;
 CalcGroupProfit(H02Symbol,"第1组2"); 
 dfz_do_2 = by_do_211 ;
 aa_do_21 = dfz_do_1 + by_do_211;
 aa_st_22 = "第1组2";
 aa_do_23 = 0;
 for (aa_in_24 = 0 ; aa_in_24<=OrdersTotal() - 1 ; aa_in_24=aa_in_24 + 1)
  {
  if ( OrderSelect(aa_in_24,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_22 )
   {
   aa_do_23 = OrderLots();
   }
  }
 if ( aa_do_21>aa_do_23 * 100 )
  {
  aa_st_27 = "第1组2";
  aa_bo_28 = false;
  for (aa_in_25 = OrdersTotal() ; aa_in_25>=0 ; aa_in_25=aa_in_25 - 1)
   {
   if ( OrderSelect(aa_in_25,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_27 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_28 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_28 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_28 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_28==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲1组平仓：",StringConcatenate(H01Symbol + "," + H02Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 CalcGroupProfit(H03Symbol,"第2组2"); 
 dfz_do_3 = by_do_211 ;
 CalcGroupProfit(H04Symbol,"第2组2"); 
 dfz_do_4 = by_do_211 ;
 aa_do_30 = dfz_do_3 + by_do_211;
 aa_st_41 = "第2组2";
 aa_do_31 = 0;
 for (aa_in_32 = 0 ; aa_in_32<=OrdersTotal() - 1 ; aa_in_32=aa_in_32 + 1)
  {
  if ( OrderSelect(aa_in_32,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_41 )
   {
   aa_do_31 = OrderLots();
   }
  }
 if ( aa_do_30>aa_do_31 * 100 )
  {
  aa_st_44 = "第2组2";
  aa_bo_45 = false;
  for (aa_in_42 = OrdersTotal() ; aa_in_42>=0 ; aa_in_42=aa_in_42 - 1)
   {
   if ( OrderSelect(aa_in_42,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_44 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_45 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_45 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_45 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_45==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲2组平仓：",StringConcatenate(H03Symbol + "," + H04Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_3<( -g_BaseLot) * 10000 )
  {
  by_bo_28 = true ;
  }
 else
  {
  by_bo_28 = false ;
  }
 if ( dfz_do_4<( -g_BaseLot) * 10000 )
  {
  by_bo_29 = true ;
  }
 else
  {
  by_bo_29 = false ;
  }
 CalcGroupProfit(H05Symbol,"第3组2"); 
 dfz_do_5 = by_do_211 ;
 CalcGroupProfit(H06Symbol,"第3组2"); 
 dfz_do_6 = by_do_211 ;
 aa_do_47 = dfz_do_5 + by_do_211;
 aa_st_59 = "第3组2";
 aa_do_48 = 0;
 for (aa_in_49 = 0 ; aa_in_49<=OrdersTotal() - 1 ; aa_in_49=aa_in_49 + 1)
  {
  if ( OrderSelect(aa_in_49,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_59 )
   {
   aa_do_48 = OrderLots();
   }
  }
 if ( aa_do_47>aa_do_48 * 100 )
  {
  aa_st_62 = "第3组2";
  aa_bo_54 = false;
  for (aa_in_60 = OrdersTotal() ; aa_in_60>=0 ; aa_in_60=aa_in_60 - 1)
   {
   if ( OrderSelect(aa_in_60,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_62 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_54 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_54 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_54 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_54==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲3组平仓：",StringConcatenate(H05Symbol + "," + H06Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_5<( -g_BaseLot) * 10000 )
  {
  by_bo_30 = true ;
  }
 else
  {
  by_bo_30 = false ;
  }
 if ( dfz_do_6<( -g_BaseLot) * 10000 )
  {
  by_bo_31 = true ;
  }
 else
  {
  by_bo_31 = false ;
  }
 CalcGroupProfit(H07Symbol,"第4组2"); 
 dfz_do_7 = by_do_211 ;
 CalcGroupProfit(H08Symbol,"第4组2"); 
 dfz_do_8 = by_do_211 ;
 aa_do_64 = dfz_do_7 + by_do_211;
 aa_st_76 = "第4组2";
 aa_do_65 = 0;
 for (aa_in_66 = 0 ; aa_in_66<=OrdersTotal() - 1 ; aa_in_66=aa_in_66 + 1)
  {
  if ( OrderSelect(aa_in_66,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_76 )
   {
   aa_do_65 = OrderLots();
   }
  }
 if ( aa_do_64>aa_do_65 * 100 )
  {
  aa_st_79 = "第4组2";
  aa_bo_71 = false;
  for (aa_in_77 = OrdersTotal() ; aa_in_77>=0 ; aa_in_77=aa_in_77 - 1)
   {
   if ( OrderSelect(aa_in_77,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_79 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_71 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_71 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_71 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_71==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲4组平仓：",StringConcatenate(H07Symbol + "," + H08Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_7<( -g_BaseLot) * 10000 )
  {
  by_bo_32 = true ;
  }
 else
  {
  by_bo_32 = false ;
  }
 if ( dfz_do_8<( -g_BaseLot) * 10000 )
  {
  by_bo_33 = true ;
  }
 else
  {
  by_bo_33 = false ;
  }
 CalcGroupProfit(H09Symbol,"第5组2"); 
 dfz_do_9 = by_do_211 ;
 CalcGroupProfit(H10Symbol,"第5组2"); 
 dfz_do_10 = by_do_211 ;
 aa_do_81 = dfz_do_9 + by_do_211;
 aa_st_93 = "第5组2";
 aa_do_82 = 0;
 for (aa_in_83 = 0 ; aa_in_83<=OrdersTotal() - 1 ; aa_in_83=aa_in_83 + 1)
  {
  if ( OrderSelect(aa_in_83,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_93 )
   {
   aa_do_82 = OrderLots();
   }
  }
 if ( aa_do_81>aa_do_82 * 100 )
  {
  aa_st_96 = "第5组2";
  for (aa_in_85 = OrdersTotal() ; aa_in_85>=0 ; aa_in_85=aa_in_85 - 1)
   {
   if ( OrderSelect(aa_in_85,SELECT_BY_POS,MODE_TRADES)!=false && OrderComment()==aa_st_96 && OrderMagicNumber()==g_MagicNumber )
    {
    if ( OrderType()==0 )
     {
     if(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,0xFFFFFFFF)) { }
     }
    if ( OrderType()==1 )
     {
     if(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,0xFFFFFFFF)) { }
     }
    if ( ( OrderType()==2 || OrderType()==3 || OrderType()==4 || OrderType()==5 ) )
     {
     if(OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  Alert("对冲5组平仓：",StringConcatenate(H09Symbol + "," + H10Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_9<( -g_BaseLot) * 10000 )
  {
  by_bo_34 = true ;
  }
 else
  {
  by_bo_34 = false ;
  }
 if ( dfz_do_10<( -g_BaseLot) * 10000 )
  {
  by_bo_35 = true ;
  }
 else
  {
  by_bo_35 = false ;
  }
 CalcGroupProfit(H11Symbol,"第6组2"); 
 dfz_do_11 = by_do_211 ;
 CalcGroupProfit(H12Symbol,"第6组2"); 
 dfz_do_12 = by_do_211 ;
 aa_do_98 = dfz_do_11 + by_do_211;
 aa_st_108 = "第6组2";
 aa_do_99 = 0;
 for (aa_in_100 = 0 ; aa_in_100<=OrdersTotal() - 1 ; aa_in_100=aa_in_100 + 1)
  {
  if ( OrderSelect(aa_in_100,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_108 )
   {
   aa_do_99 = OrderLots();
   }
  }
 if ( aa_do_98>aa_do_99 * 100 )
  {
  aa_st_111 = "第6组2";
  aa_bo_95 = false;
  for (aa_in_109 = OrdersTotal() ; aa_in_109>=0 ; aa_in_109=aa_in_109 - 1)
   {
   if ( OrderSelect(aa_in_109,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_111 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_95 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_95 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_95 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_95==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲6组平仓:",StringConcatenate(H11Symbol + "," + H12Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_11<( -g_BaseLot) * 10000 )
  {
  by_bo_36 = true ;
  }
 else
  {
  by_bo_36 = false ;
  }
 if ( dfz_do_12<( -g_BaseLot) * 10000 )
  {
  by_bo_37 = true ;
  }
 else
  {
  by_bo_37 = false ;
  }
 CalcGroupProfit(H13Symbol,"第7组2"); 
 dfz_do_13 = by_do_211 ;
 CalcGroupProfit(H14Symbol,"第7组2"); 
 dfz_do_14 = by_do_211 ;
 aa_do_113 = dfz_do_13 + by_do_211;
 aa_st_125 = "第7组2";
 aa_do_114 = 0;
 for (aa_in_115 = 0 ; aa_in_115<=OrdersTotal() - 1 ; aa_in_115=aa_in_115 + 1)
  {
  if ( OrderSelect(aa_in_115,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_125 )
   {
   aa_do_114 = OrderLots();
   }
  }
 if ( aa_do_113>aa_do_114 * 100 )
  {
  aa_st_128 = "第7组2";
  aa_bo_120 = false;
  for (aa_in_126 = OrdersTotal() ; aa_in_126>=0 ; aa_in_126=aa_in_126 - 1)
   {
   if ( OrderSelect(aa_in_126,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_128 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_120 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_120 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_120 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_120==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲7组平仓:",StringConcatenate(H13Symbol + "," + H14Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_13<( -g_BaseLot) * 10000 )
  {
  by_bo_38 = true ;
  }
 else
  {
  by_bo_38 = false ;
  }
 if ( dfz_do_14<( -g_BaseLot) * 10000 )
  {
  by_bo_39 = true ;
  }
 else
  {
  by_bo_39 = false ;
  }
 CalcGroupProfit(H15Symbol,"第8组2"); 
 dfz_do_15 = by_do_211 ;
 CalcGroupProfit(H16Symbol,"第8组2"); 
 dfz_do_16 = by_do_211 ;
 aa_do_130 = dfz_do_15 + by_do_211;
 aa_st_142 = "第8组2";
 aa_do_131 = 0;
 for (aa_in_132 = 0 ; aa_in_132<=OrdersTotal() - 1 ; aa_in_132=aa_in_132 + 1)
  {
  if ( OrderSelect(aa_in_132,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_142 )
   {
   aa_do_131 = OrderLots();
   }
  }
 if ( aa_do_130>aa_do_131 * 100 )
  {
  aa_st_145 = "第8组2";
  aa_bo_137 = false;
  for (aa_in_143 = OrdersTotal() ; aa_in_143>=0 ; aa_in_143=aa_in_143 - 1)
   {
   if ( OrderSelect(aa_in_143,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_145 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_137 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_137 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_137 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_137==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲8组平仓:",StringConcatenate(H15Symbol + "," + H16Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_15<( -g_BaseLot) * 10000 )
  {
  by_bo_40 = true ;
  }
 else
  {
  by_bo_40 = false ;
  }
 if ( dfz_do_16<( -g_BaseLot) * 10000 )
  {
  by_bo_41 = true ;
  }
 else
  {
  by_bo_41 = false ;
  }
 CalcGroupProfit(H17Symbol,"第9组2"); 
 dfz_do_17 = by_do_211 ;
 CalcGroupProfit(H18Symbol,"第9组2"); 
 dfz_do_18 = by_do_211 ;
 aa_do_147 = dfz_do_17 + by_do_211;
 aa_st_159 = "第9组2";
 aa_do_148 = 0;
 for (aa_in_149 = 0 ; aa_in_149<=OrdersTotal() - 1 ; aa_in_149=aa_in_149 + 1)
  {
  if ( OrderSelect(aa_in_149,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_159 )
   {
   aa_do_148 = OrderLots();
   }
  }
 if ( aa_do_147>aa_do_148 * 100 )
  {
  aa_st_162 = "第9组2";
  aa_bo_154 = false;
  for (aa_in_160 = OrdersTotal() ; aa_in_160>=0 ; aa_in_160=aa_in_160 - 1)
   {
   if ( OrderSelect(aa_in_160,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_162 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_154 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_154 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_154 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_154==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲9组平仓:",StringConcatenate(H17Symbol + "," + H18Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_17<( -g_BaseLot) * 10000 )
  {
  by_bo_42 = true ;
  }
 else
  {
  by_bo_42 = false ;
  }
 if ( dfz_do_18<( -g_BaseLot) * 10000 )
  {
  by_bo_43 = true ;
  }
 else
  {
  by_bo_43 = false ;
  }
 CalcGroupProfit(H19Symbol,"第10组2"); 
 dfz_do_19 = by_do_211 ;
 CalcGroupProfit(H20Symbol,"第10组2"); 
 dfz_do_25 = by_do_211 ;
 aa_do_164 = dfz_do_19 + by_do_211;
 aa_st_176 = "第10组2";
 aa_do_165 = 0;
 for (aa_in_166 = 0 ; aa_in_166<=OrdersTotal() - 1 ; aa_in_166=aa_in_166 + 1)
  {
  if ( OrderSelect(aa_in_166,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_176 )
   {
   aa_do_165 = OrderLots();
   }
  }
 if ( aa_do_164>aa_do_165 * 100 )
  {
  aa_st_179 = "第10组2";
  aa_bo_171 = false;
  for (aa_in_177 = OrdersTotal() ; aa_in_177>=0 ; aa_in_177=aa_in_177 - 1)
   {
   if ( OrderSelect(aa_in_177,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_179 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_171 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_171 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_171 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_171==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲10-2组平仓:",StringConcatenate(H19Symbol + "," + H20Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_19<( -g_BaseLot) * 10000 )
  {
  by_bo_44 = true ;
  }
 else
  {
  by_bo_44 = false ;
  }
 if ( dfz_do_25<( -g_BaseLot) * 10000 )
  {
  by_bo_45 = true ;
  }
 else
  {
  by_bo_45 = false ;
  }
 CalcGroupProfit(H21Symbol,"第11组2"); 
 dfz_do_26 = by_do_211 ;
 CalcGroupProfit(H22Symbol,"第11组2"); 
 dfz_do_27 = by_do_211 ;
 aa_do_181 = dfz_do_26 + by_do_211;
 aa_st_193 = "第11组2";
 aa_do_182 = 0;
 for (aa_in_183 = 0 ; aa_in_183<=OrdersTotal() - 1 ; aa_in_183=aa_in_183 + 1)
  {
  if ( OrderSelect(aa_in_183,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_193 )
   {
   aa_do_182 = OrderLots();
   }
  }
 if ( aa_do_181>aa_do_182 * 100 )
  {
  aa_st_196 = "第11组2";
  aa_bo_188 = false;
  for (aa_in_194 = OrdersTotal() ; aa_in_194>=0 ; aa_in_194=aa_in_194 - 1)
   {
   if ( OrderSelect(aa_in_194,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_196 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_188 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_188 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_188 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_188==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲11-2组平仓:",StringConcatenate(H21Symbol + "," + H22Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_26<( -g_BaseLot) * 10000 )
  {
  by_bo_46 = true ;
  }
 else
  {
  by_bo_46 = false ;
  }
 if ( dfz_do_27<( -g_BaseLot) * 10000 )
  {
  by_bo_47 = true ;
  }
 else
  {
  by_bo_47 = false ;
  }
 CalcGroupProfit(H23Symbol,"第12组2"); 
 dfz_do_28 = by_do_211 ;
 CalcGroupProfit(H24Symbol,"第12组2"); 
 dfz_do_29 = by_do_211 ;
 aa_do_198 = dfz_do_28 + by_do_211;
 aa_st_210 = "第12组2";
 aa_do_199 = 0;
 for (aa_in_200 = 0 ; aa_in_200<=OrdersTotal() - 1 ; aa_in_200=aa_in_200 + 1)
  {
  if ( OrderSelect(aa_in_200,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_210 )
   {
   aa_do_199 = OrderLots();
   }
  }
 if ( aa_do_198>aa_do_199 * 100 )
  {
  aa_st_213 = "第12组2";
  aa_bo_205 = false;
  for (aa_in_211 = OrdersTotal() ; aa_in_211>=0 ; aa_in_211=aa_in_211 - 1)
   {
   if ( OrderSelect(aa_in_211,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_213 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_205 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_205 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_205 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_205==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲12组平仓:",StringConcatenate(H23Symbol + "," + H24Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_28<( -g_BaseLot) * 10000 )
  {
  by_bo_48 = true ;
  }
 else
  {
  by_bo_48 = false ;
  }
 if ( dfz_do_29<( -g_BaseLot) * 10000 )
  {
  by_bo_49 = true ;
  }
 else
  {
  by_bo_49 = false ;
  }
 CalcGroupProfit(H25Symbol,"第13组2"); 
 dfz_do_30 = by_do_211 ;
 CalcGroupProfit(H26Symbol,"第13组2"); 
 dfz_do_31 = by_do_211 ;
 aa_do_215 = dfz_do_30 + by_do_211;
 aa_st_227 = "第13组2";
 aa_do_216 = 0;
 for (aa_in_217 = 0 ; aa_in_217<=OrdersTotal() - 1 ; aa_in_217=aa_in_217 + 1)
  {
  if ( OrderSelect(aa_in_217,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_227 )
   {
   aa_do_216 = OrderLots();
   }
  }
 if ( aa_do_215>aa_do_216 * 100 )
  {
  aa_st_230 = "第13组2";
  aa_bo_222 = false;
  for (aa_in_228 = OrdersTotal() ; aa_in_228>=0 ; aa_in_228=aa_in_228 - 1)
   {
   if ( OrderSelect(aa_in_228,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_230 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_222 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_222 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_222 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_222==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲13组平仓:",StringConcatenate(H25Symbol + "," + H26Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_30<( -g_BaseLot) * 10000 )
  {
  by_bo_50 = true ;
  }
 else
  {
  by_bo_50 = false ;
  }
 if ( dfz_do_31<( -g_BaseLot) * 10000 )
  {
  by_bo_51 = true ;
  }
 else
  {
  by_bo_51 = false ;
  }
 CalcGroupProfit(H27Symbol,"第14组2"); 
 dfz_do_32 = by_do_211 ;
 CalcGroupProfit(H28Symbol,"第14组2"); 
 dfz_do_20 = by_do_211 ;
 aa_do_232 = dfz_do_32 + by_do_211;
 aa_st_244 = "第14组2";
 aa_do_233 = 0;
 for (aa_in_234 = 0 ; aa_in_234<=OrdersTotal() - 1 ; aa_in_234=aa_in_234 + 1)
  {
  if ( OrderSelect(aa_in_234,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_244 )
   {
   aa_do_233 = OrderLots();
   }
  }
 if ( aa_do_232>aa_do_233 * 100 )
  {
  aa_st_247 = "第14组2";
  aa_bo_239 = false;
  for (aa_in_245 = OrdersTotal() ; aa_in_245>=0 ; aa_in_245=aa_in_245 - 1)
   {
   if ( OrderSelect(aa_in_245,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_247 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_239 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_239 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_239 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_239==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲14组平仓:",StringConcatenate(H27Symbol + "," + H28Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_32<( -g_BaseLot) * 10000 )
  {
  by_bo_52 = true ;
  }
 else
  {
  by_bo_52 = false ;
  }
 if ( dfz_do_20<( -g_BaseLot) * 10000 )
  {
  by_bo_53 = true ;
  }
 else
  {
  by_bo_53 = false ;
  }
 CalcGroupProfit(H29Symbol,"第15组2"); 
 dfz_do_21 = by_do_211 ;
 CalcGroupProfit(H30Symbol,"第15组2"); 
 dfz_do_22 = by_do_211 ;
 aa_do_249 = dfz_do_21 + by_do_211;
 aa_st_261 = "第15组2";
 aa_do_250 = 0;
 for (aa_in_251 = 0 ; aa_in_251<=OrdersTotal() - 1 ; aa_in_251=aa_in_251 + 1)
  {
  if ( OrderSelect(aa_in_251,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_261 )
   {
   aa_do_250 = OrderLots();
   }
  }
 if ( aa_do_249>aa_do_250 * 100 )
  {
  aa_st_264 = "第15组2";
  aa_bo_256 = false;
  for (aa_in_262 = OrdersTotal() ; aa_in_262>=0 ; aa_in_262=aa_in_262 - 1)
   {
   if ( OrderSelect(aa_in_262,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_264 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_256 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_256 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_256 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_256==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲15组平仓:",StringConcatenate(H29Symbol + "," + H30Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_21<( -g_BaseLot) * 10000 )
  {
  by_bo_54 = true ;
  }
 else
  {
  by_bo_54 = false ;
  }
 if ( dfz_do_22<( -g_BaseLot) * 10000 )
  {
  by_bo_55 = true ;
  }
 else
  {
  by_bo_55 = false ;
  }
 CalcGroupProfit(H31Symbol,"第16组2"); 
 dfz_do_23 = by_do_211 ;
 CalcGroupProfit(H32Symbol,"第16组2"); 
 dfz_do_24 = by_do_211 ;
 aa_do_266 = dfz_do_23 + by_do_211;
 aa_st_278 = "第16组2";
 aa_do_267 = 0;
 for (aa_in_268 = 0 ; aa_in_268<=OrdersTotal() - 1 ; aa_in_268=aa_in_268 + 1)
  {
  if ( OrderSelect(aa_in_268,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_278 )
   {
   aa_do_267 = OrderLots();
   }
  }
 if ( aa_do_266>aa_do_267 * 100 )
  {
  aa_st_281 = "第16组2";
  aa_bo_273 = false;
  for (aa_in_279 = OrdersTotal() ; aa_in_279>=0 ; aa_in_279=aa_in_279 - 1)
   {
   if ( OrderSelect(aa_in_279,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_281 )
    {
    if ( OrderType()==0 )
     {
     if(aa_bo_273 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
     }
    if ( OrderType()==1 )
     {
     if(aa_bo_273 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
     }
    if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
     {
     if(aa_bo_273 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
    }}
   }
  if ( aa_bo_273==false )
   {
   Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
   }
  Alert("对冲16组平仓:",StringConcatenate(H31Symbol + "," + H32Symbol + "账单未结::",by_do_189 + by_do_190)); 
  }
 if ( dfz_do_23<( -g_BaseLot) * 10000 )
  {
  by_bo_56 = true ;
  }
 else
  {
  by_bo_56 = false ;
  }
 if ( dfz_do_24<( -g_BaseLot) * 10000 )
  {
  by_bo_57 = true ;
  }
 else
  {
  by_bo_57 = false ;
  }
 return(0); 
 }

 int CalcSpreadSignal()
 {
 int         dfz_in_1=0;
 double      dfz_do_2=0.0;

 double     aa_do_1;
 double     aa_do_2;
 double     aa_do_3;
 double     aa_do_4;
 double     aa_do_5;
 double     aa_do_6;
 double     aa_do_7;
 int        aa_in_8;
 double     aa_do_10;
 double     aa_do_12;
 double     aa_do_14;
 double     aa_do_15;
 double     aa_do_16;
 double     aa_do_17;
 double     aa_do_18;
 int        aa_in_19;

 dfz_in_1 = 5 ;
 dfz_do_2 = iWPR(by_st_275,15,14,0) ;
 if ( g_GroupName=="第1组2" )
  {
  g_Symbol1 = H01Symbol ;
  g_Symbol2 = H02Symbol ;
  }
 if ( g_GroupName=="第2组2" )
  {
  g_Symbol1 = H03Symbol ;
  g_Symbol2 = H04Symbol ;
  }
 if ( g_GroupName=="第3组2" )
  {
  g_Symbol1 = H05Symbol ;
  g_Symbol2 = H06Symbol ;
  }
 if ( g_GroupName=="第4组2" )
  {
  g_Symbol1 = H07Symbol ;
  g_Symbol2 = H08Symbol ;
  }
 if ( g_GroupName=="第5组2" )
  {
  g_Symbol1 = H09Symbol ;
  g_Symbol2 = H10Symbol ;
  }
 if ( g_GroupName=="第6组2" )
  {
  g_Symbol1 = H11Symbol ;
  g_Symbol2 = H12Symbol ;
  }
 if ( g_GroupName=="第7组2" )
  {
  g_Symbol1 = H13Symbol ;
  g_Symbol2 = H14Symbol ;
  }
 if ( g_GroupName=="第8组2" )
  {
  g_Symbol1 = H15Symbol ;
  g_Symbol2 = H16Symbol ;
  }
 if ( g_GroupName=="第9组2" )
  {
  g_Symbol1 = H17Symbol ;
  g_Symbol2 = H18Symbol ;
  }
 if ( g_GroupName=="第10组2" )
  {
  g_Symbol1 = H19Symbol ;
  g_Symbol2 = H20Symbol ;
  }
 if ( g_GroupName=="第11组2" )
  {
  g_Symbol1 = H21Symbol ;
  g_Symbol2 = H22Symbol ;
  }
 if ( g_GroupName=="第12组2" )
  {
  g_Symbol1 = H23Symbol ;
  g_Symbol2 = H24Symbol ;
  }
 if ( g_GroupName=="第13组2" )
  {
  g_Symbol1 = H25Symbol ;
  g_Symbol2 = H26Symbol ;
  }
 if ( g_GroupName=="第14组2" )
  {
  g_Symbol1 = H27Symbol ;
  g_Symbol2 = H28Symbol ;
  }
 if ( g_GroupName=="第15组2" )
  {
  g_Symbol1 = H29Symbol ;
  g_Symbol2 = H30Symbol ;
  }
 if ( g_GroupName=="第16组2" )
  {
  g_Symbol1 = H31Symbol ;
  g_Symbol2 = H32Symbol ;
  }
 aa_do_1 = 0;
 aa_do_2 = 0;
 aa_do_3 = 0;
 aa_do_4 = 0;
 aa_do_5 = 0;
 aa_do_6 = 0;
 aa_do_7 = 0;
 for (aa_in_8 = 0 ; aa_in_8<200 ; aa_in_8=aa_in_8 + 1)
  {
  aa_do_4 = aa_do_4 + iClose(g_Symbol2,240,aa_in_8);
  aa_do_6 = iClose(g_Symbol1,240,aa_in_8) * iClose(g_Symbol2,240,aa_in_8) + aa_do_6;
  aa_do_5 = aa_do_5 + iClose(g_Symbol1,240,aa_in_8);
  aa_do_7 = iClose(g_Symbol1,240,aa_in_8) * iClose(g_Symbol1,240,aa_in_8) + aa_do_7;
  }
 if ( aa_do_7!=0 && aa_do_5!=0 )
  {
  aa_do_3 = aa_do_7 * 200 - aa_do_5 * aa_do_5;
  }
 if ( aa_do_3!=0 )
  {
  aa_do_2 = (aa_do_6 * 200 - aa_do_5 * aa_do_4) / aa_do_3;
  aa_do_1 = (aa_do_4 - aa_do_5 * (aa_do_6 * 200 - aa_do_5 * aa_do_4) / aa_do_3) / 200;
  }
 if ( NormalizeDouble(aa_do_2 * iClose(g_Symbol1,240,1) + aa_do_1 - iClose(g_Symbol2,240,1),2)<-0.02 )
  {
  g_SpreadSignal = 1 ;
  }
 aa_do_10 = 0;
 aa_do_12 = 0;
 aa_do_14 = 0;
 aa_do_15 = 0;
 aa_do_16 = 0;
 aa_do_17 = 0;
 aa_do_18 = 0;
 for (aa_in_19 = 0 ; aa_in_19<200 ; aa_in_19=aa_in_19 + 1)
  {
  aa_do_15 = aa_do_15 + iClose(g_Symbol2,240,aa_in_19);
  aa_do_17 = iClose(g_Symbol1,240,aa_in_19) * iClose(g_Symbol2,240,aa_in_19) + aa_do_17;
  aa_do_16 = aa_do_16 + iClose(g_Symbol1,240,aa_in_19);
  aa_do_18 = iClose(g_Symbol1,240,aa_in_19) * iClose(g_Symbol1,240,aa_in_19) + aa_do_18;
  }
 if ( aa_do_18!=0 && aa_do_16!=0 )
  {
  aa_do_14 = aa_do_18 * 200 - aa_do_16 * aa_do_16;
  }
 if ( aa_do_14!=0 )
  {
  aa_do_12 = (aa_do_17 * 200 - aa_do_16 * aa_do_15) / aa_do_14;
  aa_do_10 = (aa_do_15 - aa_do_16 * (aa_do_17 * 200 - aa_do_16 * aa_do_15) / aa_do_14) / 200;
  }
 if ( NormalizeDouble(aa_do_12 * iClose(g_Symbol1,240,1) + aa_do_10 - iClose(g_Symbol2,240,1),2)>0.02 )
 {
 g_SpreadSignal = 2 ;
 }
// 将本次回归的 β/α/偏离写到全局，供 RefreshGroupCache 面板缓存读取
if ( g_SpreadSignal == 1 ) {
   g_RegressionBeta  = aa_do_2;
   g_RegressionAlpha = aa_do_1;
   g_RegressionDev   = NormalizeDouble(aa_do_2 * iClose(g_Symbol1,240,1) + aa_do_1 - iClose(g_Symbol2,240,1), 2);
} else if ( g_SpreadSignal == 2 ) {
   g_RegressionBeta  = aa_do_12;
   g_RegressionAlpha = aa_do_10;
   g_RegressionDev   = NormalizeDouble(aa_do_12 * iClose(g_Symbol1,240,1) + aa_do_10 - iClose(g_Symbol2,240,1), 2);
} else {
   // 无信号时仍保存第一次回归的斜率（用于显示），偏离用第二次和第一次中绝对值较大的
   double dev1 = NormalizeDouble(aa_do_2  * iClose(g_Symbol1,240,1) + aa_do_1  - iClose(g_Symbol2,240,1), 2);
   double dev2 = NormalizeDouble(aa_do_12 * iClose(g_Symbol1,240,1) + aa_do_10 - iClose(g_Symbol2,240,1), 2);
   g_RegressionBeta  = aa_do_2;
   g_RegressionAlpha = aa_do_1;
   g_RegressionDev   = MathAbs(dev1) > MathAbs(dev2) ? dev1 : dev2;
}
return(g_SpreadSignal); 
}

 void UpdateRiskParams()
 {
 int         dfz_in_1=0;
 int         dfz_in_2=0;
 int         dfz_in_3=0;

 double     aa_do_2;

 g_RiskLot = NormalizeDouble(AccountBalance() * 0.005 / 1000,2) ;
 by_do_183 = 0 ;
 by_do_184 = 0 ;
 by_do_185 = 0 ;
 by_do_186 = 0 ;
 by_in_171 = 0 ;
 by_in_172 = 0 ;
 by_in_174 = 0 ;
 by_in_173 = 0 ;
 by_in_117 = 0 ;
 by_in_118 = 0 ;
 by_do_187 = 0 ;
 by_do_188 = 0 ;
 by_do_189 = 0 ;
 by_do_190 = 0 ;
 by_do_191 = 0 ;
 by_do_192 = 0 ;
 by_do_193 = 0 ;
 by_do_194 = 0 ;
 by_do_195 = 0 ;
 by_do_196 = 0 ;
 by_do_197 = 0 ;
 by_do_198 = 0 ;
 by_do_199 = 0 ;
 by_do_232 = 0 ;
 by_do_214 = 0 ;
 by_do_222 = 0 ;
 by_do_223 = 0 ;
 by_do_224 = 0 ;
 by_in_180 = 0 ;
 by_in_178 = 0 ;
 by_in_181 = 0 ;
 by_in_179 = 0 ;
 by_do_225 = 0 ;
 by_do_226 = 0 ;
 by_do_227 = 0 ;
 by_do_230 = 0 ;
 by_do_231 = 0 ;
 by_do_233 = 0 ;
 by_do_234 = 0 ;
 by_do_235 = 0 ;
 by_do_236 = 0 ;
 by_in_182 = 1 ;
 by_do_237 = 0 ;
 by_do_246 = 0 ;
 by_do_247 = 0 ;
 by_st_251 = "" ;
 by_in_175 = 0 ;
 for (dfz_in_2 =0 ; dfz_in_2<HistoryTotal() ; dfz_in_2 = dfz_in_2 + 1)
  {
  if ( OrderSelect(dfz_in_2,SELECT_BY_POS,MODE_HISTORY)!=false && OrderMagicNumber()==g_MagicNumber && dfz_in_1 != OrderTicket() )
   {
      //Print("size=",ArraySize(by_in_106),"  dfz=",dfz_in_2);
   if ( by_in_106[dfz_in_2] != OrderTicket() )
    {
    by_do_238 = by_do_238 + OrderLots() ;
    by_do_239 = OrderProfit() + OrderCommission() + OrderSwap() + by_do_239 ;
    by_do_240 = OrderCommission() + OrderSwap() + by_do_240 ;
    by_do_241 = MarketInfo(OrderSymbol(),13) * OrderLots() + by_do_241 ;
    by_in_106[dfz_in_2] = OrderTicket();
    }
   dfz_in_1 = OrderTicket() ;
   }
  }
 for ( ; dfz_in_3<OrdersTotal() ; dfz_in_3 = dfz_in_3 + 1)
  {
  if ( OrderSelect(dfz_in_3,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber )
   {
   if ( by_in_105[dfz_in_3] != OrderTicket() )
    {
    by_in_169=by_in_169 + 1;
    by_in_105[dfz_in_3] = OrderTicket();
    }
   if ( ( OrderType()==2 || OrderType()==4 || OrderType()==3 || OrderType()==5 ) )
    {
    by_in_175=by_in_175 + 1;
    }
   if ( OrderType()==0 )
    {
    by_do_189 = by_do_189 + 1 ;
    by_do_235 = by_do_235 + 1 ;
    by_do_192 = by_do_192 + 1 ;
    by_do_266 = by_do_266 + OrderLots() ;
    by_do_247 = by_do_247 + OrderLots() ;
    by_do_226 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_226 ;
    }
   if ( OrderType()==1 )
    {
    by_do_190 = by_do_190 + 1 ;
    by_do_236 = by_do_236 + 1 ;
    by_do_191 = by_do_191 + 1 ;
    by_do_267 = by_do_267 + OrderLots() ;
    by_do_246 = by_do_246 + OrderLots() ;
    by_do_227 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_227 ;
    }
   aa_do_2 = by_do_226 + by_do_227;
   if ( by_do_226 + by_do_227<by_do_248 )
    {
    by_do_248 = aa_do_2 ;
    }
   aa_do_2 = by_do_226 + by_do_227;
   if ( by_do_226 + by_do_227>by_do_249 )
    {
    by_do_249 = aa_do_2 ;
    }
   if ( OrderSymbol() != Symbol() )
    {
    by_in_182=by_in_182 + 1;
    }
   by_do_237 = by_do_237 + OrderLots() ;
   if ( OrderSymbol()==Symbol() && OrderMagicNumber()==g_MagicNumber )
    {
    if ( OrderType()==0 )
     {
     by_do_195 = by_do_195 + 1 ;
     by_do_193 = by_do_193 + 1 ;
     by_do_233 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_233 ;
     }
    if ( OrderType()==1 )
     {
     by_do_196 = by_do_196 + 1 ;
     by_do_194 = by_do_194 + 1 ;
     by_do_234 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_234 ;
     }
    if ( OrderType()==5 )
     {
     by_in_180=by_in_180 + 1;
     by_do_223 = by_do_223 + 1 ;
     }
    if ( OrderType()==3 )
     {
     by_in_178=by_in_178 + 1;
     by_do_224 = by_do_224 + 1 ;
     }
    if ( OrderType()==4 )
     {
     by_in_181=by_in_181 + 1;
     by_do_222 = by_do_222 + 1 ;
     }
    if ( OrderType()==2 )
     {
     by_in_179=by_in_179 + 1;
     by_do_214 = by_do_214 + 1 ;
     }
    by_do_286 = by_do_195 + by_do_196 + by_in_180 + by_in_178 + by_in_181 + by_in_179 ;
    by_do_287 = by_do_195 + by_in_181 + by_in_179 ;
    by_do_288 = by_do_196 + by_in_180 + by_in_178 ;
    }
   if ( OrderComment()==g_GroupName && OrderSymbol()==by_st_275 && OrderMagicNumber()==g_MagicNumber )
    {
    by_do_242 = OrderOpenPrice() ;
    by_do_225 = OrderLots() ;
    if ( OrderType()==1 )
     {
     by_do_199 = by_do_199 + OrderLots() ;
     by_in_118=by_in_118 + 1;
     by_do_188 = by_do_188 + 1 ;
     by_do_231 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_231 ;
     by_do_244 = OrderOpenPrice() ;
     }
    if ( OrderType()==0 )
     {
     by_do_232 = by_do_232 + OrderLots() ;
     by_in_117=by_in_117 + 1;
     by_do_187 = by_do_187 + 1 ;
     by_do_230 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_230 ;
     by_do_245 = OrderOpenPrice() ;
     }
    if ( ( OrderType()==1 || OrderType()==0 ) )
     {
     by_do_198 = by_do_198 + OrderLots() ;
     }
    if ( OrderType()==5 )
     {
     by_in_171=by_in_171 + 1;
     by_do_185 = by_do_185 + 1 ;
     }
    if ( OrderType()==3 )
     {
     by_in_172=by_in_172 + 1;
     by_do_186 = by_do_186 + 1 ;
     }
    if ( OrderType()==4 )
     {
     by_in_174=by_in_174 + 1;
     by_do_184 = by_do_184 + 1 ;
     }
    if ( OrderType()==2 )
     {
     by_in_173=by_in_173 + 1;
     by_do_183 = by_do_183 + 1 ;
     }
    by_do_197 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_197 ;
   }}
  }
 }

 void CalcGroupProfit (string bsw_0,string bsw_1)
 {
 int         dfz_in_1=0;

 by_do_215 = 0 ;
 by_do_216 = 0 ;
 by_do_217 = 0 ;
 by_do_218 = 0 ;
 by_do_219 = 0 ;
 by_do_221 = 0 ;
 by_do_210 = 0 ;
 by_do_208 = 0 ;
 by_do_206 = 0 ;
 by_do_209 = 0 ;
 by_do_207 = 0 ;
 by_do_205 = 0 ;
 by_do_211 = 0 ;
 for ( ; dfz_in_1<=OrdersTotal() ; dfz_in_1 = dfz_in_1 + 1)
  {
  if ( OrderSelect(dfz_in_1,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==bsw_0 && OrderMagicNumber()==g_MagicNumber && OrderComment()==bsw_1 )
   {
   if ( by_in_105[dfz_in_1] != OrderTicket() )
    {
    by_in_169=by_in_169 + 1;
    by_in_105[dfz_in_1] = OrderTicket();
    }
   if ( OrderType()==1 )
    {
    by_do_216 = by_do_216 + 1 ;
    by_do_210 = by_do_210 + 1 ;
    by_do_208 = by_do_208 + 1 ;
    by_do_206 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_206 ;
    }
   if ( OrderType()==0 )
    {
    by_do_215 = by_do_215 + 1 ;
    by_do_209 = by_do_209 + 1 ;
    by_do_207 = by_do_207 + 1 ;
    by_do_205 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_205 ;
    }
   if ( OrderType()==3 )
    {
    by_do_217 = by_do_217 + 1 ;
    }
   if ( OrderType()==5 )
    {
    by_do_218 = by_do_218 + 1 ;
    }
   if ( OrderType()==2 )
    {
    by_do_219 = by_do_219 + 1 ;
    }
   if ( OrderType()==4 )
    {
    by_do_221 = by_do_221 + 1 ;
    }
   by_do_211 = OrderProfit() + OrderSwap() + OrderCommission() + by_do_211 ;
   }
  }
 }

// EnsurePanelObjects：面板对象只创建一次（首次 tick 执行），后续 tick 只 SetText 不改结构
void EnsurePanelObjects() {
   if ( g_PanelInited ) return;
   // 删除旧版 10xxx 系列对象（与新版面板共存会重叠，直接删除）
   int oldId;
   for ( oldId=10000; oldId<=10200; oldId++ ) {
      if ( ObjectFind(DoubleToString(oldId,0)) >= 0 ) {
         ObjectDelete(DoubleToString(oldId,0));
      }
   }
   // 初始化 16 组缓存的币对（ProcessAllGroups 的顺序映射）
   g_GC_sym1[1]  = H01Symbol;  g_GC_sym2[1]  = H02Symbol;  g_GC_active[1]  = H01;
   g_GC_sym1[2]  = H03Symbol;  g_GC_sym2[2]  = H04Symbol;  g_GC_active[2]  = H02;
   g_GC_sym1[3]  = H05Symbol;  g_GC_sym2[3]  = H06Symbol;  g_GC_active[3]  = H03;
   g_GC_sym1[4]  = H07Symbol;  g_GC_sym2[4]  = H08Symbol;  g_GC_active[4]  = H04;
   g_GC_sym1[5]  = H09Symbol;  g_GC_sym2[5]  = H10Symbol;  g_GC_active[5]  = H05;
   g_GC_sym1[6]  = H11Symbol;  g_GC_sym2[6]  = H12Symbol;  g_GC_active[6]  = H06;
   g_GC_sym1[7]  = H13Symbol;  g_GC_sym2[7]  = H14Symbol;  g_GC_active[7]  = H07;
   g_GC_sym1[8]  = H15Symbol;  g_GC_sym2[8]  = H16Symbol;  g_GC_active[8]  = H08;
   g_GC_sym1[9]  = H17Symbol;  g_GC_sym2[9]  = H18Symbol;  g_GC_active[9]  = H09;
   g_GC_sym1[10] = H19Symbol;  g_GC_sym2[10] = H20Symbol;  g_GC_active[10] = H10;
   g_GC_sym1[11] = H21Symbol;  g_GC_sym2[11] = H22Symbol;  g_GC_active[11] = H11;
   g_GC_sym1[12] = H23Symbol;  g_GC_sym2[12] = H24Symbol;  g_GC_active[12] = H12;
   g_GC_sym1[13] = H25Symbol;  g_GC_sym2[13] = H26Symbol;  g_GC_active[13] = H13;
   g_GC_sym1[14] = H27Symbol;  g_GC_sym2[14] = H28Symbol;  g_GC_active[14] = H14;
   g_GC_sym1[15] = H29Symbol;  g_GC_sym2[15] = H30Symbol;  g_GC_active[15] = H15;
   g_GC_sym1[16] = H31Symbol;  g_GC_sym2[16] = H32Symbol;  g_GC_active[16] = H16;
   g_PanelInited = true;
}

// RefreshGroupCache：16 组依次 CalcSpreadSignal+UpdateRiskParams 各一次，写入 g_GC_* 数组
// 后续 6 个 Render 模块只读 g_GC_*，避免 UpdateStatusDisplay 重复 32 次回归计算
void RefreshGroupCache() {
   string saveG = g_GroupName;
   string saveS = g_Symbol1;
   string saveS2 = g_Symbol2;
   string save275 = by_st_275;
   int i;
   for ( i = 1; i <= 16; i++ ) {
      if ( !g_GC_active[i] ) { g_GC_signal[i]=0; g_GC_bCnt[i]=0; g_GC_sCnt[i]=0; g_GC_lots[i]=0; g_GC_pnl[i]=0; continue; }
      g_GroupName = "第" + DoubleToString(i,0) + "组2";
      g_Symbol1   = g_GC_sym1[i];
      g_Symbol2   = g_GC_sym2[i];
      by_st_275   = g_GC_sym1[i];   // 与 ManageGroup 保持一致：币对 1 作为订单过滤 Symbol
      UpdateRiskParams();
      CalcSpreadSignal();
      g_GC_signal[i] = g_SpreadSignal;
      g_GC_beta[i]   = g_RegressionBeta;
      g_GC_alpha[i]  = g_RegressionAlpha;
      g_GC_devPts[i] = g_RegressionDev;
      g_GC_bCnt[i]   = by_in_117;
      g_GC_sCnt[i]   = by_in_118;
      g_GC_lots[i]   = by_do_232;
      g_GC_pnl[i]    = by_do_197;
      g_GC_corrReject[i] = ( by_in_166 == -1 );
   }
   g_GroupName = saveG;
   g_Symbol1   = saveS;
   g_Symbol2   = saveS2;
   by_st_275   = save275;
}

 int UpdateStatusDisplay()
 {
   // Step 1 & 2：首次初始化 + 每组一次缓存刷新
   EnsurePanelObjects();
   RefreshGroupCache();

   // ===== 清理旧版残留对象（防止新旧共存导致重叠）=====
   int __oldId;
   string __oldName;
   for(__oldId=10000; __oldId<=19999; __oldId++) {
      __oldName = DoubleToString(__oldId, 0);
      if(ObjectFind(__oldName) >= 0) {
         ObjectDelete(__oldName);
      }
   }
   if(ObjectFind("QIAN") >= 0) ObjectDelete("QIAN");
   if(ObjectFind("11") >= 0) ObjectDelete("11");

   // ===== v2 模块化面板（6 个 Render 函数）=====
   RenderAccountKPI();
   RenderSignalMatrix();
   RenderStatusPillars();
   RenderPositionTable();
   RenderRiskMonitor();
   RenderActivityLog();
   return(0);
}


// ====== 模块 ① RenderAccountKPI：顶部 KPI 条（CORNER=1）背景卡 + 文字对齐 ======

 void CloseAllPositions()
 {
 bool        dfz_bo_1;
 int         dfz_in_2=0;

 int        aa_in_7;

 dfz_bo_1 = false ;
 for (dfz_in_2 = OrdersTotal() ; dfz_in_2>=0 ; dfz_in_2 = dfz_in_2 - 1)
  {
  if ( OrderSelect(dfz_in_2,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber )
   {
   if ( OrderType()==0 )
    {
    if(dfz_bo_1 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
    by_st_252 = StringConcatenate("关闭全部::",OrdersTotal(),"账单未结::",AccountBalance(),"") ;
    SendStatusMail(); 
    }
   if ( OrderType()==1 )
    {
    if(dfz_bo_1 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
    by_st_252 = StringConcatenate("关闭全部::",OrdersTotal(),"账单未结::",AccountBalance(),"") ;
    SendStatusMail(); 
    }
   if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
    {
    if(dfz_bo_1 = OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
   }}
  }
 if (dfz_bo_1)  return;
 for (aa_in_7 = OrdersTotal() ; aa_in_7>=0 ; aa_in_7=aa_in_7 - 1)
  {
  if ( OrderSelect(aa_in_7,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber )
   {
   if ( OrderType()==0 )
    {
    if(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),0,Red)) { }
    }
   if ( OrderType()==1 )
    {
    if(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),0,Red)) { }
    }
   if ( ( OrderType()==4 || OrderType()==2 || OrderType()==5 || OrderType()==3 ) )
    {
    if(OrderDelete(OrderTicket(),0xFFFFFFFF)) { }
   }}
  }
 Alert("Order failed to Close.Balance :: ",OrdersTotal(),""); 
 by_st_252 = StringConcatenate("关闭失败::",OrdersTotal(),"账单未结::",AccountBalance(),"") ;
 SendStatusMail(); 
 }

 void SendStatusMail()
 {

 by_st_253 = StringConcatenate("",AccountNumber(),"/余额::",DoubleToString(AccountBalance(),0) + "/净值::",DoubleToString(AccountEquity(),0) + "/浮盈::",DoubleToString(AccountProfit(),0) + "/订单::",OrdersTotal(),"/智能手数:: ",by_do_256,"/",ServerAddress() + "") ;
 by_st_254 = " // " + by_st_252 + "\n" + " // EA名称::" + WindowExpertName() + "\n" + " // 图表品种:: " + Symbol() + "\n" + " // 两组盈亏:: " + DoubleToString(by_do_233 + by_do_234,2) + "\n" + StringConcatenate(" // 账户浮盈:: ",AccountProfit(),"\n") + StringConcatenate(" // 基础手数:: ",g_BaseLot,"\n") + StringConcatenate(" // 实开手数和:: ",by_do_237,"\n") + StringConcatenate(" // 持仓单量:: ",DoubleToString(by_in_118 + by_in_117,2),"\n") + " // 估算单量:: " + DoubleToString(by_do_190 + by_do_189,2) + "\n" + " // 智能调节手数:: " + DoubleToString(by_do_256,2) + " \n" + " // 历史手续费:: " + DoubleToString(by_do_240,2) + "+" + DoubleToString(by_do_241,2) + "USD \n" + " // 历史累计保证金:: " + DoubleToString(by_do_238,2) + " \n" + " // 账户余额:: " + DoubleToString(AccountBalance(),2) + " \n" + " // 账户净值:: " + DoubleToString(AccountEquity(),2) + " \n" + " // 历史平仓盈亏:: " + DoubleToString(by_do_239,2) + " \n" + " // 经纪商:: " + AccountCompany() + "\n" + " // 服务器:: " + ServerAddress() + "\n" + StringConcatenate(" // 可用保证金:: ",AccountFreeMargin(),"\n") + StringConcatenate(" // 已用保证金:: ",AccountMargin(),"\n") + StringConcatenate(" // 标准保证金=",MarketInfo(Symbol(),32),"\n") + StringConcatenate(" // 杠杆:: ",AccountLeverage(),"\n") + StringConcatenate(" // 账户姓名:: ",AccountName(),"\n") + StringConcatenate(" // 账户号码:: ",AccountNumber(),"\n") + StringConcatenate(" // 账户余额:: ",AccountBalance(),"\n") + StringConcatenate(" // 账户净值:: ",AccountEquity(),"\n") + StringConcatenate(" // 本地时间::",TimeToString(TimeLocal(),3),"\n") + StringConcatenate(" // 服务器时间::",TimeToString(TimeCurrent(),3),"\n") + StringConcatenate("MODE_POINT=",MarketInfo(Symbol(),11),"\n") + StringConcatenate("MODE_SPREAD=",MarketInfo(Symbol(),13),"\n") + StringConcatenate("MODE_STOPLEVEL=",MarketInfo(Symbol(),14),"\n") + StringConcatenate("MODE_LOTSIZE=",MarketInfo(Symbol(),15),"\n") + StringConcatenate("MODE_SWAPLONGbuy order=",MarketInfo(Symbol(),18),"\n") + StringConcatenate("MODE_SWAPSHORT sell order=",MarketInfo(Symbol(),19),"\n") + StringConcatenate("MODE_MINLOT=",MarketInfo(Symbol(),23),"\n") + StringConcatenate("MODE_LOTSTEP=",MarketInfo(Symbol(),24),"\n") + StringConcatenate("MODE_MAXLOT=",MarketInfo(Symbol(),25),"\n") + StringConcatenate("MODE_PROFITCALCMODE=",MarketInfo(Symbol(),27),"\n") + StringConcatenate("MODE_MARGININIT for 1 lot=",MarketInfo(Symbol(),29),"\n") + StringConcatenate("MODE_MARGINMAINTENANCEt=",MarketInfo(Symbol(),30),"\n") + StringConcatenate("MODE_MARGINHEDGED=",MarketInfo(Symbol(),31),"\n") + StringConcatenate("MODE_MARGINREQUIREDt=",MarketInfo(Symbol(),32),"\n") + StringConcatenate("MODE_FREEZELEVEL=",MarketInfo(Symbol(),33),"\n") + " " ;
 SendMail(by_st_253,by_st_254); 
 }

 double GetCurrencyStrength (string bsw_0,int bsw_1)
 {
 int         dfz_in_1=0;
 int         dfz_in_2=0;
 int         dfz_in_3=0;
 int         dfz_in_4=0;
 double      dfz_do_5=0.0;
 double      dfz_do_6=0.0;
 double      dfz_do_7=0.0;
 double      dfz_do_8=0.0;
 double      dfz_do_9=0.0;
 double      dfz_do_10=0.0;
 double      dfz_do_11=0.0;
 double      dfz_do_12=0.0;
 double      dfz_do_13=0.0;
 double      dfz_do_14=0.0;
 double      dfz_do_15=0.0;
 double      dfz_do_16=0.0;
 double      dfz_do_17=0.0;
 double      dfz_do_18=0.0;
 int         dfz_in_19=0;
 double      dfz_do_20=0.0;

 dfz_in_1 = 3 ;
 dfz_in_2 = 6 ;
 dfz_in_3 = 2 ;
 dfz_in_4 = 5 ;
 dfz_in_19 = -1 ;
 dfz_do_5 = GetMultiTimeframeMA("EURUSD",2,3,6,bsw_1) ;
 dfz_do_6 = GetMultiTimeframeMA("EURUSD",5,3,6,bsw_1) ;
 if ( ( dfz_do_5<=0 || dfz_do_6<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_7 = GetMultiTimeframeMA("GBPUSD",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_8 = GetMultiTimeframeMA("GBPUSD",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_7<=0 || dfz_do_8<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_9 = GetMultiTimeframeMA("AUDUSD",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_10 = GetMultiTimeframeMA("AUDUSD",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_9<=0 || dfz_do_10<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_11 = GetMultiTimeframeMA("NZDUSD",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_12 = GetMultiTimeframeMA("NZDUSD",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_11<=0 || dfz_do_12<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_13 = GetMultiTimeframeMA("USDCAD",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_14 = GetMultiTimeframeMA("USDCAD",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_13<=0 || dfz_do_14<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_15 = GetMultiTimeframeMA("USDCHF",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_16 = GetMultiTimeframeMA("USDCHF",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_15<=0 || dfz_do_16<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_17 = GetMultiTimeframeMA("USDJPY",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_18 = GetMultiTimeframeMA("USDJPY",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_17<=0 || dfz_do_18<=0 ) )
  {
  return(dfz_in_19); 
  }
 if ( bsw_0=="USD" )
  {
  dfz_do_20 = dfz_do_6 / dfz_do_5 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 / dfz_do_7 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 / dfz_do_9 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_12 / dfz_do_11 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_15 / dfz_do_16 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_13 / dfz_do_14 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_17 / dfz_do_18 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="GBP" )
  {
  dfz_do_20 = dfz_do_7 / dfz_do_8 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 / dfz_do_8 / (dfz_do_5 / dfz_do_7) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 / dfz_do_9 / (dfz_do_8 / dfz_do_10) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 / dfz_do_11 / (dfz_do_8 / dfz_do_12) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 * dfz_do_15 / (dfz_do_8 * dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 * dfz_do_13 / (dfz_do_8 * dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 * dfz_do_17 / (dfz_do_8 * dfz_do_18) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="EUR" )
  {
  dfz_do_20 = dfz_do_5 / dfz_do_6 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 / dfz_do_7 / (dfz_do_6 / dfz_do_8) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 / dfz_do_9 / (dfz_do_6 / dfz_do_10) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 / dfz_do_11 / (dfz_do_6 / dfz_do_12) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 * dfz_do_15 / (dfz_do_6 * dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 * dfz_do_13 / (dfz_do_6 * dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 * dfz_do_17 / (dfz_do_6 * dfz_do_18) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="AUD" )
  {
  dfz_do_20 = dfz_do_9 / dfz_do_10 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 / dfz_do_10 / (dfz_do_5 / dfz_do_9) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 / dfz_do_10 / (dfz_do_7 / dfz_do_9) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_9 / dfz_do_11 / (dfz_do_10 / dfz_do_12) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_9 * dfz_do_15 / (dfz_do_10 * dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_9 * dfz_do_13 / (dfz_do_10 * dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_9 * dfz_do_17 / (dfz_do_10 * dfz_do_18) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="CAD" )
  {
  dfz_do_20 = dfz_do_14 / dfz_do_13 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 * dfz_do_14 / (dfz_do_5 * dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 * dfz_do_14 / (dfz_do_7 * dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 * dfz_do_14 / (dfz_do_9 * dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_12 * dfz_do_14 / (dfz_do_11 * dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_15 / dfz_do_13 / (dfz_do_16 / dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_17 / dfz_do_13 / (dfz_do_18 / dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="JPY" )
  {
  dfz_do_20 = dfz_do_18 / dfz_do_17 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 * dfz_do_18 / (dfz_do_5 * dfz_do_17) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 * dfz_do_18 / (dfz_do_7 * dfz_do_17) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 * dfz_do_18 / (dfz_do_10 * dfz_do_17) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_12 * dfz_do_18 / (dfz_do_11 * dfz_do_17) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_18 / dfz_do_14 / (dfz_do_17 / dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_18 / dfz_do_16 / (dfz_do_18 / dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="CHF" )
  {
  dfz_do_20 = dfz_do_16 / dfz_do_15 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 * dfz_do_16 / (dfz_do_5 * dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 * dfz_do_16 / (dfz_do_7 * dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 * dfz_do_16 / (dfz_do_9 * dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_12 * dfz_do_16 / (dfz_do_11 * dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_16 / dfz_do_14 / (dfz_do_15 / dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_17 / dfz_do_15 / (dfz_do_18 / dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="NZD" )
  {
  dfz_do_20 = dfz_do_11 / dfz_do_12 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 / dfz_do_12 / (dfz_do_5 / dfz_do_11) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 / dfz_do_12 / (dfz_do_7 / dfz_do_11) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 / dfz_do_12 / (dfz_do_9 / dfz_do_11) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_11 * dfz_do_15 / (dfz_do_12 * dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_11 * dfz_do_13 / (dfz_do_12 * dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_11 * dfz_do_17 / (dfz_do_12 * dfz_do_18) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 return(NormalizeDouble(dfz_do_20,4)); 

 }

 double GetMultiTimeframeMA (string bsw_0,int bsw_1,int bsw_2,int bsw_3,int bsw_4)
 {
 double      dfz_do_1=0.0;
 int         dfz_in_2=0;
 int         dfz_in_3=0;
 int         dfz_in_4=0;

 dfz_in_2 = 4 ;
 switch(Period())
 {
 case 1 :
  dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
  dfz_in_2 = dfz_in_2 + 5;
  case 5 :
   dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
   dfz_in_2 = dfz_in_2 + 3;
   case 15 :
    dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
    dfz_in_2 = dfz_in_2 + 2;
    case 30 :
     dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
     dfz_in_2 = dfz_in_2 + 2;
     case 60 :
      dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
      dfz_in_2 = dfz_in_2 + 4;
      case 240 :
       dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
       dfz_in_2 = dfz_in_2 + 6;
       case 1440 :
        dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
        dfz_in_2 = dfz_in_2 + 5;
        case 10080 :
         dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
         dfz_in_2 = dfz_in_2 + 4;
         case 43200 :
          dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
          }
         return(dfz_do_1); 
         }

         int ManageGroup (string bsw_0)
         {
 int         dfz_in_1=0;
 int         dfz_in_2=0;
 color       dfz_ui_3    =clrNONE;
 color       dfz_ui_4    =clrNONE;
 color       dfz_ui_5    =clrNONE;
 double      dfz_do_6=0.0;
 double      dfz_do_7=0.0;
 double      dfz_do_8=0.0;
 double      dfz_do_9=0.0;
 double      dfz_do_10=0.0;
 double      dfz_do_11=0.0;
 double      dfz_do_12=0.0;
 double      dfz_do_13=0.0;
 double      dfz_do_14=0.0;
 double      dfz_do_15=0.0;

 string     aa_st_3;
 string     aa_st_4;

 string     aa_st_22;
 string     aa_st_23;
 string     aa_st_38;
 string     aa_st_39;
 int        aa_in_53;
 int        aa_in_54;
 int        aa_in_55;
 bool       aa_bo_59;
 bool       aa_bo_62;
 double     aa_do_63;
 int        aa_in_64;
 int        aa_in_65;
 double     aa_do_66;
 double     aa_do_67;
 int        aa_in_69;
 double     aa_do_70;
 double     aa_do_71;
 string     aa_st_74;
 int        aa_in_68;
 int        aa_in_75;
 int        aa_in_76;
 string     aa_st_79;
 int        aa_in_77;
 int        aa_in_80;
 int        aa_in_81;
 int        aa_in_82;
 int        aa_in_84;
 int        aa_in_85;
 string     aa_st_87;
 double     aa_do_88;
 int        aa_in_89;
 double     aa_do_90;
 int        aa_in_91;
 int        aa_in_92;
 int        aa_in_93;
 double     aa_do_96;
 int        aa_in_97;
 bool       aa_bo_99;
 bool       aa_bo_104;
 string     aa_st_105;
 int        aa_in_106;
 int        aa_in_107;
 string     aa_st_109;
 int        aa_in_108;
 int        aa_in_110;
 string     aa_st_112;
 int        aa_in_111;
 int        aa_in_113;
 string     aa_st_115;
 int        aa_in_114;
 int        aa_in_116;
 string     aa_st_118;
 int        aa_in_117;
 int        aa_in_119;
 int        aa_in_120;
 string     aa_st_122;
 double     aa_do_123;
 int        aa_in_124;
 double     aa_do_126;
 string     aa_st_127;
 int        aa_in_128;
 int        aa_in_129;
 string     aa_st_132;
 int        aa_in_125;
 int        aa_in_130;
 int        aa_in_133;
 string     aa_st_135;
 double     aa_do_136;
 int        aa_in_137;
 double     aa_do_139;
 string     aa_st_140;
 int        aa_in_141;
 int        aa_in_142;
 bool       aa_bo_146;
 string     aa_st_147;
 string     aa_st_148;
 double     aa_do_149;
 int        aa_in_150;
 string     aa_st_153;
 double     aa_do_151;
 int        aa_in_154;
 double     aa_do_155;
 string     aa_st_156;
 double     aa_do_157;
 int        aa_in_158;
 double     aa_do_160;
 string     aa_st_161;
 double     aa_do_162;
 int        aa_in_163;
 double     aa_do_164;
 string     aa_st_165;
 double     aa_do_166;
 int        aa_in_167;
 bool       aa_bo_159;
 string     aa_st_171;
 string     aa_st_172;
 double     aa_do_168;
 int        aa_in_173;
 string     aa_st_176;
 double     aa_do_174;
 int        aa_in_177;
 double     aa_do_178;
 string     aa_st_179;
 double     aa_do_180;
 int        aa_in_181;
 double     aa_do_183;
 string     aa_st_184;
 double     aa_do_185;
 int        aa_in_186;
 double     aa_do_187;
 string     aa_st_188;
 double     aa_do_189;
 int        aa_in_190;
 bool       aa_bo_182;
 string     aa_st_194;
 string     aa_st_195;
 double     aa_do_191;
 int        aa_in_196;
 string     aa_st_199;
 double     aa_do_197;
 int        aa_in_200;
 double     aa_do_201;
 string     aa_st_202;
 double     aa_do_203;
 int        aa_in_204;
 double     aa_do_206;
 string     aa_st_207;
 double     aa_do_208;
 int        aa_in_209;
 double     aa_do_210;
 string     aa_st_211;
 double     aa_do_212;
 int        aa_in_213;
 bool       aa_bo_205;
 string     aa_st_217;
 string     aa_st_218;
 double     aa_do_214;
 int        aa_in_219;
 string     aa_st_222;
 double     aa_do_220;
 int        aa_in_223;
 double     aa_do_224;
 string     aa_st_225;
 double     aa_do_226;
 int        aa_in_227;
 double     aa_do_229;
 string     aa_st_230;
 double     aa_do_231;
 int        aa_in_232;
 double     aa_do_233;
 string     aa_st_234;
 double     aa_do_235;
 int        aa_in_236;

 g_GroupName = bsw_0 ;
 CalcSpreadSignal(); 
 by_bo_165 = false ;
 if ( g_GroupName=="第1组2" )
  {
  g_Symbol1 = H01Symbol ;
  g_Symbol2 = H02Symbol ;
  }
 if ( g_GroupName=="第2组2" )
  {
  g_Symbol1 = H03Symbol ;
  g_Symbol2 = H04Symbol ;
  }
 if ( g_GroupName=="第3组2" )
  {
  g_Symbol1 = H05Symbol ;
  g_Symbol2 = H06Symbol ;
  }
 if ( g_GroupName=="第4组2" )
  {
  g_Symbol1 = H07Symbol ;
  g_Symbol2 = H08Symbol ;
  }
 if ( g_GroupName=="第5组2" )
  {
  g_Symbol1 = H09Symbol ;
  g_Symbol2 = H10Symbol ;
  }
 if ( g_GroupName=="第6组2" )
  {
  g_Symbol1 = H11Symbol ;
  g_Symbol2 = H12Symbol ;
  }
 if ( g_GroupName=="第7组2" )
  {
  g_Symbol1 = H13Symbol ;
  g_Symbol2 = H14Symbol ;
  }
 if ( g_GroupName=="第8组2" )
  {
  g_Symbol1 = H15Symbol ;
  g_Symbol2 = H16Symbol ;
  }
 if ( g_GroupName=="第9组2" )
  {
  g_Symbol1 = H17Symbol ;
  g_Symbol2 = H18Symbol ;
  }
 if ( g_GroupName=="第10组2" )
  {
  g_Symbol1 = H19Symbol ;
  g_Symbol2 = H20Symbol ;
  }
 if ( g_GroupName=="第11组2" )
  {
  g_Symbol1 = H21Symbol ;
  g_Symbol2 = H22Symbol ;
  }
 if ( g_GroupName=="第12组2" )
  {
  g_Symbol1 = H23Symbol ;
  g_Symbol2 = H24Symbol ;
  }
 if ( g_GroupName=="第13组2" )
  {
  g_Symbol1 = H25Symbol ;
  g_Symbol2 = H26Symbol ;
  }
 if ( g_GroupName=="第14组2" )
  {
  g_Symbol1 = H27Symbol ;
  g_Symbol2 = H28Symbol ;
  }
 if ( g_GroupName=="第15组2" )
  {
  g_Symbol1 = H29Symbol ;
  g_Symbol2 = H30Symbol ;
  }
 if ( g_GroupName=="第16组2" )
  {
  g_Symbol1 = H31Symbol ;
  g_Symbol2 = H32Symbol ;
  }
 by_bo_165 = false ;
 dfz_in_1 = (int)MarketInfo(g_Symbol1,13) ;
 dfz_in_2 = (int)MarketInfo(g_Symbol2,13) ;
 dfz_do_6 = MarketInfo(g_Symbol1,18) ;
 dfz_do_7 = MarketInfo(g_Symbol1,19) ;
 dfz_do_8 = MarketInfo(g_Symbol2,18) ;
 dfz_do_9 = MarketInfo(g_Symbol2,19) ;
 
  
 if ( CalcCorrelation(30,15,g_Symbol2,g_Symbol1)>0.7 && 
      CalcCorrelation(30,60,g_Symbol2,g_Symbol1)>0.7  &&  
      CalcCorrelation(30,240,g_Symbol2,g_Symbol1)>0.7
    ){}else
    {return(0); }
  
 
 if ( dfz_in_1< 70 && dfz_in_2< 70 && ( ( g_SpreadSignal==1 && dfz_do_6 + dfz_do_9>dfz_do_7 + dfz_do_8 ) || (g_SpreadSignal==2 && dfz_do_7 + dfz_do_8>dfz_do_6 + dfz_do_9) ) && !只平不开 )
  {
  aa_in_53 = 0;
  aa_in_54 = 0;
  for (aa_in_55 = 0 ; aa_in_55<OrdersTotal() ; aa_in_55=aa_in_55 + 1)
   {
   if ( OrderSelect(aa_in_55,SELECT_BY_POS,MODE_TRADES)!=false && ( OrderSymbol()==g_Symbol1 || OrderSymbol()==g_Symbol2 ) && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
    {
    if ( OrderType()==0 )
     {
     aa_in_53=aa_in_53 + 1; 
     }
    if ( OrderType()==1 )
     {
     aa_in_54=aa_in_54 + 1; 
    }}
   }
  if ( aa_in_53 + aa_in_54==0 )
   {
   if ( ((MathAbs(iClose(g_Symbol1,0,0) - iLow(g_Symbol1,PERIOD_D1,0))) / MarketInfo(g_Symbol1,11)) / 10>400 )
    {
    aa_bo_59 = true;
    }
   else
    {
    aa_bo_59 = false;
    }
   if ( !aa_bo_59 )
    {
    if ( ((MathAbs(iClose(g_Symbol2,0,0) - iLow(g_Symbol2,PERIOD_D1,0))) / MarketInfo(g_Symbol2,11)) / 10>400 )
     {
     aa_bo_62 = true;
     }
    else
     {
     aa_bo_62 = false;
     }
    if ( !aa_bo_62 )
     {
     if ( g_SpreadSignal==1 )
      {
      by_in_290 = 0 ;
      by_in_291 = 1 ;
      dfz_do_10 = MarketInfo(g_Symbol1,10) ;
      dfz_do_11 = MarketInfo(g_Symbol2,9) ;
      dfz_ui_3 = Green ;
      dfz_ui_4 = Green ;
      dfz_ui_5 = Red ;
      }
     else
      {
      if ( g_SpreadSignal==2 )
       {
       by_in_290 = 1 ;
       by_in_291 = 0 ;
       dfz_do_10 = MarketInfo(g_Symbol1,9) ;
       dfz_do_11 = MarketInfo(g_Symbol2,10) ;
       dfz_ui_3 = Red ;
       dfz_ui_4 = Red ;
       dfz_ui_5 = Green ;
       }
      else
       {
       return(0); 
      }}
     by_do_154 = NormalizeDouble(lot,2) ;
     aa_do_63 = 0;
     by_st_273 = g_Symbol1 ;
     by_st_274 = g_Symbol2 ;
     aa_in_64 = 60;
     aa_in_65 = 200;
     aa_do_66 = 0;
     aa_do_67 = 0;
     for (aa_in_69 = 200 - 1 ; aa_in_69>=0 ; aa_in_69=aa_in_69 - 1)
      {
      aa_do_66 = (iHigh(by_st_273,aa_in_64,aa_in_69) - iLow(by_st_273,aa_in_64,aa_in_69)) / MarketInfo(by_st_273,11) + aa_do_66;
      aa_do_67 = (iHigh(by_st_274,aa_in_64,aa_in_69) - iLow(by_st_274,aa_in_64,aa_in_69)) / MarketInfo(by_st_274,11) + aa_do_67;
      }
     aa_do_70 = aa_do_66 / aa_in_65 * MarketInfo(by_st_273,16);
     aa_do_71 = aa_do_67 / aa_in_65 * MarketInfo(by_st_274,16);
     if ( aa_do_67 / aa_in_65 * MarketInfo(by_st_274,16)!=0 )
      {
      aa_do_63 = aa_do_70 / aa_do_71;
      }
     by_do_155 = NormalizeDouble(aa_do_63 * lot,2) ;
     if ( by_do_154<0.01 )
      {
      by_do_154 = 0.01 ;
      }
     if ( by_do_155<0.01 )
      {
      by_do_155 = 0.01 ;
      }
     RefreshRates(); 
     aa_st_74 = g_Symbol1;
     aa_in_68 = 0;
     aa_in_75 = 0;
     for (aa_in_76 = 0 ; aa_in_76<OrdersTotal() ; aa_in_76=aa_in_76 + 1)
      {
      if ( OrderSelect(aa_in_76,SELECT_BY_POS,MODE_TRADES)!=false && OrderComment()==g_GroupName && OrderMagicNumber()==g_MagicNumber && OrderSymbol()==aa_st_74 )
       {
       if ( OrderType()==0 )
        {
        aa_in_68=aa_in_68 + 1; 
        }
       if ( OrderType()==1 )
        {
        aa_in_75=aa_in_75 + 1; 
       }}
      }
     if ( aa_in_68 + aa_in_75==0 && !OrderSend(g_Symbol1,by_in_290,by_do_154,dfz_do_10,50,0,0,g_GroupName,g_MagicNumber,0,dfz_ui_3) )
      {
      Print(g_Symbol1 + "开仓",GetLastError()); 
      }
     aa_st_79 = g_Symbol2;
     aa_in_77 = 0;
     aa_in_80 = 0;
     for (aa_in_81 = 0 ; aa_in_81<OrdersTotal() ; aa_in_81=aa_in_81 + 1)
      {
      if ( OrderSelect(aa_in_81,SELECT_BY_POS,MODE_TRADES)!=false && OrderComment()==g_GroupName && OrderMagicNumber()==g_MagicNumber && OrderSymbol()==aa_st_79 )
       {
       if ( OrderType()==0 )
        {
        aa_in_77=aa_in_77 + 1; 
        }
       if ( OrderType()==1 )
        {
        aa_in_80=aa_in_80 + 1; 
       }}
      }
     if ( aa_in_77 + aa_in_80==0 && !OrderSend(g_Symbol2,by_in_291,by_do_155,dfz_do_11,50,0,0,g_GroupName,g_MagicNumber,0,dfz_ui_4) )
      {
      Print(g_Symbol2 + "开仓",GetLastError()); 
      }
     by_bo_165 = false ;
  }}}}
 aa_in_82 = 0;
 aa_in_84 = 0;
 for (aa_in_85 = 0 ; aa_in_85<OrdersTotal() ; aa_in_85=aa_in_85 + 1)
  {
  if ( OrderSelect(aa_in_85,SELECT_BY_POS,MODE_TRADES)!=false && ( OrderSymbol()==g_Symbol1 || OrderSymbol()==g_Symbol2 ) && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
   {
   if ( OrderType()==0 )
    {
    aa_in_82=aa_in_82 + 1; 
    }
   if ( OrderType()==1 )
    {
    aa_in_84=aa_in_84 + 1; 
   }}
  }
 if ( aa_in_82 + aa_in_84>=2 )
  {
  aa_st_87 = bsw_0;
  aa_do_88 = 0;
  for (aa_in_89 = 0 ; aa_in_89<OrdersTotal() ; aa_in_89=aa_in_89 + 1)
   {
   if ( OrderSelect(aa_in_89,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_87 )
    {
    aa_do_88 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_88;
    }
   }
  aa_do_90 = aa_do_88;
  aa_in_91 = 0;
  aa_in_92 = 0;
  for (aa_in_93 = 0 ; aa_in_93<OrdersTotal() ; aa_in_93=aa_in_93 + 1)
   {
   if ( OrderSelect(aa_in_93,SELECT_BY_POS,MODE_TRADES)!=false && ( OrderSymbol()==g_Symbol1 || OrderSymbol()==g_Symbol2 ) && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
    {
    if ( OrderType()==0 )
     {
     aa_in_91=aa_in_91 + 1; 
     }
    if ( OrderType()==1 )
     {
     aa_in_92=aa_in_92 + 1; 
    }}
   }
  aa_do_96 = 0;
  for (aa_in_97 = 0 ; aa_in_97<=OrdersTotal() - 1 ; aa_in_97=aa_in_97 + 1)
   {
   if ( OrderSelect(aa_in_97,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
    {
    aa_do_96 = OrderLots();
    }
   }
  if ( aa_do_90<( -(aa_in_91 + aa_in_92) / 2) * aa_do_96 * 100 * 6 * 1.4 )
   {
   if ( ((MathAbs(iClose(g_Symbol1,0,0) - iLow(g_Symbol1,PERIOD_D1,0))) / MarketInfo(g_Symbol1,11)) / 10>400 )
    {
    aa_bo_99 = true;
    }
   else
    {
    aa_bo_99 = false;
    }
   if ( !aa_bo_99 )
    {
    if ( ((MathAbs(iClose(g_Symbol2,0,0) - iLow(g_Symbol2,PERIOD_D1,0))) / MarketInfo(g_Symbol2,11)) / 10>400 )
     {
     aa_bo_104 = true;
     }
    else
     {
     aa_bo_104 = false;
     }
    if ( !aa_bo_104 )
     {
     aa_st_105 = g_Symbol1;
     aa_in_106 = -1;
     for (aa_in_107 = 0 ; aa_in_107<=OrdersTotal() - 1 ; aa_in_107=aa_in_107 + 1)
      {
      if ( OrderSelect(aa_in_107,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_105 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
       {
       aa_in_106 = OrderType();
       }
      }
     if ( aa_in_106==0 )
      {
      aa_st_109 = g_Symbol2;
      aa_in_108 = -1;
      for (aa_in_110 = 0 ; aa_in_110<=OrdersTotal() - 1 ; aa_in_110=aa_in_110 + 1)
       {
       if ( OrderSelect(aa_in_110,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_109 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_in_108 = OrderType();
        }
       }
      if ( aa_in_108==1 )
       {
       dfz_do_10 = MarketInfo(g_Symbol1,10) ;
       dfz_do_11 = MarketInfo(g_Symbol2,9) ;
       dfz_ui_3 = Green ;
       dfz_ui_4 = Red ;
      }}
     aa_st_112 = g_Symbol1;
     aa_in_111 = -1;
     for (aa_in_113 = 0 ; aa_in_113<=OrdersTotal() - 1 ; aa_in_113=aa_in_113 + 1)
      {
      if ( OrderSelect(aa_in_113,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_112 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
       {
       aa_in_111 = OrderType();
       }
      }
     if ( aa_in_111==1 )
      {
      aa_st_115 = g_Symbol2;
      aa_in_114 = -1;
      for (aa_in_116 = 0 ; aa_in_116<=OrdersTotal() - 1 ; aa_in_116=aa_in_116 + 1)
       {
       if ( OrderSelect(aa_in_116,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_115 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_in_114 = OrderType();
        }
       }
      if ( aa_in_114==0 )
       {
       dfz_do_10 = MarketInfo(g_Symbol1,9) ;
       dfz_do_11 = MarketInfo(g_Symbol2,10) ;
       dfz_ui_3 = Red ;
       dfz_ui_4 = Green ;
      }}
     RefreshRates(); 
     aa_st_118 = g_Symbol1;
     aa_in_117 = 0;
     aa_in_119 = 0;
     for (aa_in_120 = 0 ; aa_in_120<OrdersTotal() ; aa_in_120=aa_in_120 + 1)
      {
      if ( OrderSelect(aa_in_120,SELECT_BY_POS,MODE_TRADES)!=false && OrderComment()==g_GroupName && OrderMagicNumber()==g_MagicNumber && OrderSymbol()==aa_st_118 )
       {
       if ( OrderType()==0 )
        {
        aa_in_117=aa_in_117 + 1; 
        }
       if ( OrderType()==1 )
        {
        aa_in_119=aa_in_119 + 1; 
       }}
      }
     if ( aa_in_117 + aa_in_119>=1 && by_lo_148 != iTime(g_Symbol1,0,0) )
      {
      aa_st_122 = g_Symbol1;
      aa_do_123 = 0;
      for (aa_in_124 = 0 ; aa_in_124<=OrdersTotal() - 1 ; aa_in_124=aa_in_124 + 1)
       {
       if ( OrderSelect(aa_in_124,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_122 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_do_123 = OrderLots();
        }
       }
      aa_do_126 = NormalizeDouble(aa_do_123 * 1.5,2);
      aa_st_127 = g_Symbol1;
      aa_in_128 = -1;
      for (aa_in_129 = 0 ; aa_in_129<=OrdersTotal() - 1 ; aa_in_129=aa_in_129 + 1)
       {
       if ( OrderSelect(aa_in_129,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_127 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_in_128 = OrderType();
        }
       }
      if ( !OrderSend(g_Symbol1,aa_in_128,aa_do_126,dfz_do_10,50,0,0,g_GroupName,g_MagicNumber,0,dfz_ui_3) )
       {
       by_lo_148 = iTime(g_Symbol1,0,0) ;
       }
      Print(g_Symbol1 + "加仓",GetLastError()); 
      }
     aa_st_132 = g_Symbol2;
     aa_in_125 = 0;
     aa_in_130 = 0;
     for (aa_in_133 = 0 ; aa_in_133<OrdersTotal() ; aa_in_133=aa_in_133 + 1)
      {
      if ( OrderSelect(aa_in_133,SELECT_BY_POS,MODE_TRADES)!=false && OrderComment()==g_GroupName && OrderMagicNumber()==g_MagicNumber && OrderSymbol()==aa_st_132 )
       {
       if ( OrderType()==0 )
        {
        aa_in_125=aa_in_125 + 1; 
        }
       if ( OrderType()==1 )
        {
        aa_in_130=aa_in_130 + 1; 
       }}
      }
     if ( aa_in_125 + aa_in_130>=1 && by_lo_149 != iTime(g_Symbol2,0,0) )
      {
      aa_st_135 = g_Symbol2;
      aa_do_136 = 0;
      for (aa_in_137 = 0 ; aa_in_137<=OrdersTotal() - 1 ; aa_in_137=aa_in_137 + 1)
       {
       if ( OrderSelect(aa_in_137,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_135 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_do_136 = OrderLots();
        }
       }
      aa_do_139 = NormalizeDouble(aa_do_136 * 1.5,2);
      aa_st_140 = g_Symbol2;
      aa_in_141 = -1;
      for (aa_in_142 = 0 ; aa_in_142<=OrdersTotal() - 1 ; aa_in_142=aa_in_142 + 1)
       {
       if ( OrderSelect(aa_in_142,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_140 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_in_141 = OrderType();
        }
       }
      if ( !OrderSend(g_Symbol2,aa_in_141,aa_do_139,dfz_do_11,50,0,0,g_GroupName,g_MagicNumber,0,dfz_ui_4) )
       {
       by_lo_149 = iTime(g_Symbol2,0,0) ;
       }
      Print(g_Symbol2 + "加仓",GetLastError()); 
  }}}}}
 if ( ((MathAbs(iClose(g_Symbol1,0,0) - iLow(g_Symbol1,PERIOD_D1,0))) / MarketInfo(g_Symbol1,11)) / 10>400 )
  {
  aa_bo_146 = true;
  }
 else
  {
  aa_bo_146 = false;
  }
 if ( aa_bo_146 )
  {
  aa_st_147 = bsw_0;
  aa_st_148 = g_Symbol1;
  aa_do_149 = 0;
  for (aa_in_150 = 0 ; aa_in_150<OrdersTotal() ; aa_in_150=aa_in_150 + 1)
   {
   if ( OrderSelect(aa_in_150,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_148 && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_147 )
    {
    aa_do_149 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_149;
    }
   }
  if ( aa_do_149<0 )
   {
   aa_st_153 = g_Symbol1;
   aa_do_151 = 0;
   for (aa_in_154 = 0 ; aa_in_154<=OrdersTotal() ; aa_in_154=aa_in_154 + 1)
    {
    if ( OrderSelect(aa_in_154,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_153 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
     {
     aa_do_151 = aa_do_151 + OrderLots();
     }
    }
   aa_do_155 = aa_do_151;
   aa_st_156 = g_Symbol1;
   aa_do_157 = 0;
   for (aa_in_158 = 0 ; aa_in_158<=OrdersTotal() ; aa_in_158=aa_in_158 + 1)
    {
    if ( OrderSelect(aa_in_158,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_156 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
     {
     aa_do_157 = aa_do_157 + OrderLots();
     }
    }
   if ( aa_do_155>aa_do_157 && by_lo_148 != iTime(g_Symbol1,0,0) )
    {
    aa_do_160 = MarketInfo(g_Symbol1,9);
    aa_st_161 = g_Symbol1;
    aa_do_162 = 0;
    for (aa_in_163 = 0 ; aa_in_163<=OrdersTotal() ; aa_in_163=aa_in_163 + 1)
     {
     if ( OrderSelect(aa_in_163,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_161 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
      {
      aa_do_162 = aa_do_162 + OrderLots();
      }
     }
    aa_do_164 = aa_do_162;
    aa_st_165 = g_Symbol1;
    aa_do_166 = 0;
    for (aa_in_167 = 0 ; aa_in_167<=OrdersTotal() ; aa_in_167=aa_in_167 + 1)
     {
     if ( OrderSelect(aa_in_167,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_165 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
      {
      aa_do_166 = aa_do_166 + OrderLots();
      }
     }
    if ( !OrderSend(g_Symbol1,OP_SELL,aa_do_164 - aa_do_166,aa_do_160,50,0,0,g_GroupName,g_MagicNumber,0,Red) )
     {
     PrintFormat("锁单S",GetLastError()); 
     }
    by_lo_148 = iTime(g_Symbol1,0,0) ;
    by_bo_165 = true ;
  }}}
 if ( ((MathAbs(iClose(g_Symbol1,0,0) - iLow(g_Symbol1,PERIOD_D1,0))) / MarketInfo(g_Symbol1,11)) / 10>400 )
  {
  aa_bo_159 = true;
  }
 else
  {
  aa_bo_159 = false;
  }
 if ( aa_bo_159 )
  {
  aa_st_171 = bsw_0;
  aa_st_172 = g_Symbol1;
  aa_do_168 = 0;
  for (aa_in_173 = 0 ; aa_in_173<OrdersTotal() ; aa_in_173=aa_in_173 + 1)
   {
   if ( OrderSelect(aa_in_173,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_172 && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_171 )
    {
    aa_do_168 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_168;
    }
   }
  if ( aa_do_168<0 )
   {
   aa_st_176 = g_Symbol1;
   aa_do_174 = 0;
   for (aa_in_177 = 0 ; aa_in_177<=OrdersTotal() ; aa_in_177=aa_in_177 + 1)
    {
    if ( OrderSelect(aa_in_177,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_176 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
     {
     aa_do_174 = aa_do_174 + OrderLots();
     }
    }
   aa_do_178 = aa_do_174;
   aa_st_179 = g_Symbol1;
   aa_do_180 = 0;
   for (aa_in_181 = 0 ; aa_in_181<=OrdersTotal() ; aa_in_181=aa_in_181 + 1)
    {
    if ( OrderSelect(aa_in_181,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_179 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
     {
     aa_do_180 = aa_do_180 + OrderLots();
     }
    }
   if ( aa_do_178<aa_do_180 && by_lo_148 != iTime(g_Symbol1,0,0) )
    {
    aa_do_183 = MarketInfo(g_Symbol1,10);
    aa_st_184 = g_Symbol1;
    aa_do_185 = 0;
    for (aa_in_186 = 0 ; aa_in_186<=OrdersTotal() ; aa_in_186=aa_in_186 + 1)
     {
     if ( OrderSelect(aa_in_186,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_184 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
      {
      aa_do_185 = aa_do_185 + OrderLots();
      }
     }
    aa_do_187 = aa_do_185;
    aa_st_188 = g_Symbol1;
    aa_do_189 = 0;
    for (aa_in_190 = 0 ; aa_in_190<=OrdersTotal() ; aa_in_190=aa_in_190 + 1)
     {
     if ( OrderSelect(aa_in_190,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_188 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
      {
      aa_do_189 = aa_do_189 + OrderLots();
      }
     }
    if ( !OrderSend(g_Symbol1,OP_BUY,aa_do_187 - aa_do_189,aa_do_183,50,0,0,g_GroupName,g_MagicNumber,0,LimeGreen) )
     {
     PrintFormat("锁单B",GetLastError()); 
     }
    by_lo_148 = iTime(g_Symbol1,0,0) ;
    by_bo_165 = true ;
  }}}
 if ( ((MathAbs(iClose(g_Symbol2,0,0) - iLow(g_Symbol2,PERIOD_D1,0))) / MarketInfo(g_Symbol2,11)) / 10>400 )
  {
  aa_bo_182 = true;
  }
 else
  {
  aa_bo_182 = false;
  }
 if ( aa_bo_182 )
  {
  aa_st_194 = bsw_0;
  aa_st_195 = g_Symbol2;
  aa_do_191 = 0;
  for (aa_in_196 = 0 ; aa_in_196<OrdersTotal() ; aa_in_196=aa_in_196 + 1)
   {
   if ( OrderSelect(aa_in_196,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_195 && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_194 )
    {
    aa_do_191 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_191;
    }
   }
  if ( aa_do_191<0 )
   {
   aa_st_199 = g_Symbol2;
   aa_do_197 = 0;
   for (aa_in_200 = 0 ; aa_in_200<=OrdersTotal() ; aa_in_200=aa_in_200 + 1)
    {
    if ( OrderSelect(aa_in_200,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_199 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
     {
     aa_do_197 = aa_do_197 + OrderLots();
     }
    }
   aa_do_201 = aa_do_197;
   aa_st_202 = g_Symbol2;
   aa_do_203 = 0;
   for (aa_in_204 = 0 ; aa_in_204<=OrdersTotal() ; aa_in_204=aa_in_204 + 1)
    {
    if ( OrderSelect(aa_in_204,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_202 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
     {
     aa_do_203 = aa_do_203 + OrderLots();
     }
    }
   if ( aa_do_201>aa_do_203 && by_lo_149 != iTime(g_Symbol2,0,0) )
    {
    aa_do_206 = MarketInfo(g_Symbol2,9);
    aa_st_207 = g_Symbol2;
    aa_do_208 = 0;
    for (aa_in_209 = 0 ; aa_in_209<=OrdersTotal() ; aa_in_209=aa_in_209 + 1)
     {
     if ( OrderSelect(aa_in_209,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_207 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
      {
      aa_do_208 = aa_do_208 + OrderLots();
      }
     }
    aa_do_210 = aa_do_208;
    aa_st_211 = g_Symbol2;
    aa_do_212 = 0;
    for (aa_in_213 = 0 ; aa_in_213<=OrdersTotal() ; aa_in_213=aa_in_213 + 1)
     {
     if ( OrderSelect(aa_in_213,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_211 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
      {
      aa_do_212 = aa_do_212 + OrderLots();
      }
     }
    if ( !OrderSend(g_Symbol2,OP_SELL,aa_do_210 - aa_do_212,aa_do_206,50,0,0,g_GroupName,g_MagicNumber,0,Red) )
     {
     PrintFormat("锁单S",GetLastError()); 
     }
    by_lo_149 = iTime(g_Symbol2,0,0) ;
    by_bo_165 = true ;
  }}}
 if ( ((MathAbs(iClose(g_Symbol2,0,0) - iLow(g_Symbol2,PERIOD_D1,0))) / MarketInfo(g_Symbol2,11)) / 10>400 )
  {
  aa_bo_205 = true;
  }
 else
  {
  aa_bo_205 = false;
  }
 if ( aa_bo_205 )
  {
  aa_st_217 = bsw_0;
  aa_st_218 = g_Symbol2;
  aa_do_214 = 0;
  for (aa_in_219 = 0 ; aa_in_219<OrdersTotal() ; aa_in_219=aa_in_219 + 1)
   {
   if ( OrderSelect(aa_in_219,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_218 && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_217 )
    {
    aa_do_214 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_214;
    }
   }
  if ( aa_do_214<0 )
   {
   aa_st_222 = g_Symbol2;
   aa_do_220 = 0;
   for (aa_in_223 = 0 ; aa_in_223<=OrdersTotal() ; aa_in_223=aa_in_223 + 1)
    {
    if ( OrderSelect(aa_in_223,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_222 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
     {
     aa_do_220 = aa_do_220 + OrderLots();
     }
    }
   aa_do_224 = aa_do_220;
   aa_st_225 = g_Symbol2;
   aa_do_226 = 0;
   for (aa_in_227 = 0 ; aa_in_227<=OrdersTotal() ; aa_in_227=aa_in_227 + 1)
    {
    if ( OrderSelect(aa_in_227,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_225 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
     {
     aa_do_226 = aa_do_226 + OrderLots();
     }
    }
   if ( aa_do_224<aa_do_226 && by_lo_149 != iTime(g_Symbol2,0,0) )
    {
    aa_do_229 = MarketInfo(g_Symbol2,10);
    aa_st_230 = g_Symbol2;
    aa_do_231 = 0;
    for (aa_in_232 = 0 ; aa_in_232<=OrdersTotal() ; aa_in_232=aa_in_232 + 1)
     {
     if ( OrderSelect(aa_in_232,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_230 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
      {
      aa_do_231 = aa_do_231 + OrderLots();
      }
     }
    aa_do_233 = aa_do_231;
    aa_st_234 = g_Symbol2;
    aa_do_235 = 0;
    for (aa_in_236 = 0 ; aa_in_236<=OrdersTotal() ; aa_in_236=aa_in_236 + 1)
     {
     if ( OrderSelect(aa_in_236,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_234 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
      {
      aa_do_235 = aa_do_235 + OrderLots();
      }
     }
    if ( !OrderSend(g_Symbol2,OP_BUY,aa_do_233 - aa_do_235,aa_do_229,50,0,0,g_GroupName,g_MagicNumber,0,LimeGreen) )
     {
     PrintFormat("锁单B",GetLastError()); 
     }
    by_lo_149 = iTime(g_Symbol2,0,0) ;
    by_bo_165 = true ;
  }}}
 return(0); 
 }

// ====== 模块 ① RenderAccountKPI：顶部 KPI 条（CORNER=1）背景卡 + 文字对齐 ======
void RenderAccountKPI() {
   int x0,x1,x2,x3,x4,x5;
   int w0,w1,w2,w3,w4,w5;
   int yTop,yLbl,yVal;
   color valC;
   string s;
   x0=5;   x1=170; x2=335; x3=500; x4=665; x5=830;
   w0=160; w1=160; w2=160; w3=160; w4=160; w5=155;
   yTop=5; yLbl=24; yVal=38;
   SetRect("20000",5,yTop,985,58,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20001","  账户监控 · 多品种对冲套利 EA",9,PANEL_FONT_B,CLR_TEXT_WARN,8,yTop+4);
   SetRect("20010",x0+3,yLbl,w0-6,22,CLR_ALT_ROW,CLR_FRAME,1);
   SetLabel("20011","余额 $"+DoubleToString(AccountBalance(),2),9,PANEL_FONT_B,CLR_TEXT_PROFIT,x0+6,yLbl+4);
   SetRect("20013",x1+3,yLbl,w1-6,22,CLR_ALT_ROW,CLR_FRAME,1);
   SetLabel("20014","净值 $"+DoubleToString(AccountEquity(),2),9,PANEL_FONT_B,CLR_TEXT_PROFIT,x1+6,yLbl+4);
   SetRect("20016",x2+3,yLbl,w2-6,22,CLR_ALT_ROW,CLR_FRAME,1);
   valC=(AccountProfit()>=0)?CLR_TEXT_PROFIT:CLR_TEXT_LOSS;
   if(AccountProfit()>=0) s="+"+DoubleToString(AccountProfit(),2);
   else                 s=DoubleToString(AccountProfit(),2);
   SetLabel("20017","浮盈 "+s+" USD",9,PANEL_FONT_B,valC,x2+6,yLbl+4);
   SetRect("20019",x3+3,yLbl,w3-6,22,CLR_ALT_ROW,CLR_FRAME,1);
   SetLabel("2001A","保证金 $"+DoubleToString(AccountMargin(),2),8,PANEL_FONT_B,CLR_TEXT_WARN,x3+6,yLbl+5);
   SetRect("2001C",x4+3,yLbl,w4-6,22,CLR_ALT_ROW,CLR_FRAME,1);
   valC=(AccountFreeMargin()>0)?White:CLR_TEXT_LOSS;
   SetLabel("2001D","可用 $"+DoubleToString(AccountFreeMargin(),2),8,PANEL_FONT_B,valC,x4+6,yLbl+5);
   SetRect("2001F",x5+3,yLbl,w5-6,22,CLR_ALT_ROW,CLR_FRAME,1);
   s=DoubleToString(OrdersTotal(),0)+"单 1:"+DoubleToString(AccountLeverage(),0);
   SetLabel("20020",s,8,PANEL_FONT_B,CLR_TEXT_WARN,x5+6,yLbl+5);
}
void RenderSignalMatrix() {
   int gi,col,row,cx,cy;
   color bgC,sdC,tC,mC;
   string sig,sid;
   SetRect("20100",505,68,490,200,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20101","  信号矩阵 · 16 组",9,PANEL_FONT_B,CLR_TEXT_WARN,511,72);
   SetLabel("20102","1=偏低 2=偏高 0=带内 Corr=拒绝",7,PANEL_FONT,CLR_TEXT_DIM,640,74);
   for(gi=1;gi<=16;gi++) {
      col=(gi-1)%4; row=(gi-1)/4;
      cx=511+col*120;
      cy=90+row*44;
      bgC=CLR_ALT_ROW; tC=White; mC=CLR_TEXT_META; sdC=CLR_SIDE_NEUTRAL; sig="带内";
      if(!g_GC_active[gi]) { bgC=CLR_PANEL_BG; tC=CLR_TEXT_DIM; mC=CLR_TEXT_DIM; sdC=CLR_SIDE_NEUTRAL; sig="关闭"; }
      else if(g_GC_corrReject[gi]) { sdC=CLR_SIDE_CORR; sig="Corr拒绝"; mC=CLR_TEXT_WARN; }
      else if(g_GC_signal[gi]==1) { sdC=CLR_SIDE_BUY; sig="偏低 Signal1"; }
      else if(g_GC_signal[gi]==2) { sdC=CLR_SIDE_SELL; sig="偏高 Signal2"; }
      sid="201"+DoubleToString(gi,0);
      SetRect(sid,cx,cy,114,40,bgC,CLR_FRAME,1);
      SetRect(sid+"s",cx,cy,3,40,sdC,sdC,1);
      SetLabel("211"+DoubleToString(gi,0),"G"+DoubleToString(gi,0)+" "+g_GC_sym1[gi]+" "+g_GC_sym2[gi],8,PANEL_FONT_B,tC,cx+6,cy+2);
      SetLabel("221"+DoubleToString(gi,0),sig,8,PANEL_FONT_B,sdC,cx+6,cy+13);
      SetLabel("231"+DoubleToString(gi,0),"B="+DoubleToString(g_GC_beta[gi],3)+" D="+DoubleToString(g_GC_devPts[gi],2),7,PANEL_FONT,mC,cx+6,cy+25);
   }
}
void RenderStatusPillars() {
   int px,py,pw,ph,y;
   color vC;
   string sSig,sVal;
   double dd;
   px=505; py=274; pw=490; ph=154;
   SetRect("20200",px,py,pw,ph,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20201","  运行状态",9,PANEL_FONT_B,CLR_TEXT_WARN,px+6,py+4);
   y=py+22;
   SetRect("20202",px+5,y,pw-10,20,CLR_ALT_ROW,CLR_FRAME,1);
   SetLabel("20203","EA 运行",8,PANEL_FONT,CLR_TEXT_META,px+10,y+5);
   SetLabel("20204","● 正常",9,PANEL_FONT_B,CLR_SIDE_BUY,px+pw-70,y+5);
   y+=22;
   SetRect("20205",px+5,y,pw-10,20,CLR_ALT_ROW,CLR_FRAME,1);
   SetLabel("20206","强制清仓",8,PANEL_FONT,CLR_TEXT_META,px+10,y+5);
   vC=清仓?CLR_TEXT_LOSS:White;
   sVal=清仓?"● 启用":"○ 关闭";
   SetLabel("20207",sVal,9,PANEL_FONT_B,vC,px+pw-70,y+5);
   y+=22;
   SetRect("20208",px+5,y,pw-10,20,CLR_ALT_ROW,CLR_FRAME,1);
   SetLabel("20209","只平不开",8,PANEL_FONT,CLR_TEXT_META,px+10,y+5);
   vC=只平不开?CLR_TEXT_WARN:White;
   sVal=只平不开?"● 启用":"○ 关闭";
   SetLabel("2020A",sVal,9,PANEL_FONT_B,vC,px+pw-70,y+5);
   y+=22;
   SetRect("2020B",px+5,y,pw-10,20,CLR_ALT_ROW,CLR_FRAME,1);
   SetLabel("2020C","当前信号",8,PANEL_FONT,CLR_TEXT_META,px+10,y+5);
   sSig="中性"; vC=White;
   if(g_SpreadSignal==1) { sSig="偏低▼"; vC=CLR_SIDE_BUY; }
   if(g_SpreadSignal==2) { sSig="偏高▲"; vC=CLR_SIDE_SELL; }
   SetLabel("2020D",sSig,9,PANEL_FONT_B,vC,px+pw-70,y+5);
   y+=22;
   SetRect("2020E",px+5,y,pw-10,20,CLR_ALT_ROW,CLR_FRAME,1);
   SetLabel("2020F","回撤比",8,PANEL_FONT,CLR_TEXT_META,px+10,y+5);
   dd=0;
   if(AccountBalance()>0) dd=(AccountEquity()-AccountBalance())/AccountBalance()*100;
   if(dd>=-2)      vC=CLR_SIDE_BUY;
   else if(dd>=-5) vC=CLR_TEXT_WARN;
   else            vC=CLR_TEXT_LOSS;
   SetLabel("20210",DoubleToString(dd,2)+"%",9,PANEL_FONT_B,vC,px+pw-70,y+5);
   y+=22;
   SetRect("20211",px+5,y,pw-10,20,CLR_ALT_ROW,CLR_FRAME,1);
   SetLabel("20212","服务器时间",8,PANEL_FONT,CLR_TEXT_META,px+10,y+5);
   SetLabel("20213",TimeToString(TimeCurrent(),TIME_MINUTES),9,PANEL_FONT_B,White,px+pw-70,y+5);
}
void RenderPositionTable() {
   int tx,ty,tw,hdrY,rowH,sumY;
   int c0,c1,c2,c3,c4,c5;
   int gi,Y;
   double totLots,totPnl; int totB,totS;
   color rbg,pC,bC,tC;
   tx=5; ty=68; tw=495; hdrY=88; rowH=14;
   c0=tx+8;  c1=tx+48;  c2=tx+210;
   c3=tx+250; c4=tx+290; c5=tx+330;
   totLots=0; totPnl=0; totB=0; totS=0;
   SetRect("20300",tx,ty,tw,288,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20301","  仓位矩阵 · 16 组",9,PANEL_FONT_B,CLR_TEXT_WARN,tx+6,ty+4);
   SetRect("20302",tx+4,hdrY-2,tw-8,18,CLR_HEADER_BG,CLR_FRAME,1);
   SetLabel("20303","组",8,PANEL_FONT_B,CLR_TEXT_META,c0,hdrY+3);
   SetLabel("20304","币对 1 · 币对 2",8,PANEL_FONT_B,CLR_TEXT_META,c1,hdrY+3);
   SetLabel("20305","B单",8,PANEL_FONT_B,CLR_TEXT_META,c2,hdrY+3);
   SetLabel("20306","S单",8,PANEL_FONT_B,CLR_TEXT_META,c3,hdrY+3);
   SetLabel("20307","手数",8,PANEL_FONT_B,CLR_TEXT_META,c4,hdrY+3);
   SetLabel("20308","盈亏 USD",8,PANEL_FONT_B,CLR_TEXT_META,c5,hdrY+3);
   for(gi=1;gi<=16;gi++) {
      Y=hdrY+2+gi*rowH;
      rbg=(gi%2==0)?CLR_ALT_ROW:CLR_ALT_ROW2;
      pC=(g_GC_pnl[gi]>=0)?CLR_TEXT_PROFIT:CLR_TEXT_LOSS;
      bC=g_GC_active[gi]?White:CLR_TEXT_DIM;
      SetRect("2031"+DoubleToString(gi,0),tx+4,Y-1,tw-8,rowH-1,rbg,rbg,1);
      SetLabel("2032"+DoubleToString(gi,0),"G"+DoubleToString(gi,0),7,PANEL_FONT,bC,c0,Y+1);
      SetLabel("2033"+DoubleToString(gi,0),g_GC_sym1[gi]+" "+g_GC_sym2[gi],7,PANEL_FONT,bC,c1,Y+1);
      SetLabel("2034"+DoubleToString(gi,0),DoubleToString(g_GC_bCnt[gi],0),7,PANEL_FONT_B,CLR_SIDE_BUY,c2,Y+1);
      SetLabel("2035"+DoubleToString(gi,0),DoubleToString(g_GC_sCnt[gi],0),7,PANEL_FONT_B,CLR_SIDE_SELL,c3,Y+1);
      SetLabel("2036"+DoubleToString(gi,0),DoubleToString(g_GC_lots[gi],2),7,PANEL_FONT,White,c4,Y+1);
      SetLabel("2037"+DoubleToString(gi,0),DoubleToString(g_GC_pnl[gi],2),7,PANEL_FONT_B,pC,c5,Y+1);
      totB+=g_GC_bCnt[gi]; totS+=g_GC_sCnt[gi];
      totLots+=g_GC_lots[gi]; totPnl+=g_GC_pnl[gi];
   }
   sumY=hdrY+2+17*rowH;
   tC=(totPnl>=0)?CLR_TEXT_PROFIT:CLR_TEXT_LOSS;
   SetRect("20390",tx+4,sumY-2,tw-8,18,CLR_TOTAL_ROW,CLR_TEXT_WARN,1);
   SetLabel("20391","S",8,PANEL_FONT_B,CLR_TEXT_WARN,c0,sumY+2);
   SetLabel("20392","16组合计",8,PANEL_FONT_B,CLR_TEXT_WARN,c1,sumY+2);
   SetLabel("20393",DoubleToString(totB,0),8,PANEL_FONT_B,CLR_SIDE_BUY,c2,sumY+2);
   SetLabel("20394",DoubleToString(totS,0),8,PANEL_FONT_B,CLR_SIDE_SELL,c3,sumY+2);
   SetLabel("20395",DoubleToString(totLots,2),8,PANEL_FONT_B,White,c4,sumY+2);
   SetLabel("20396",DoubleToString(totPnl,2),8,PANEL_FONT_B,tC,c5,sumY+2);
}
void RenderRiskMonitor() {
   int rx,ry,rw,hdrY,rowH;
   int c0,c1,c2,c3;
   int gi,Y;
   double addPct,thr;
   color rbg,aC,rC,lC;
   string aTxt,rTxt,lTxt;
   rx=5; ry=362; rw=495; hdrY=ry+20; rowH=12;
   c0=rx+8;  c1=rx+130; c2=rx+240; c3=rx+350;
   SetRect("20500",rx,ry,rw,234,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20501","  风险触发监控 · 16 组",9,PANEL_FONT_B,CLR_TEXT_WARN,rx+6,ry+4);
   SetRect("20502",rx+4,hdrY-2,rw-8,16,CLR_HEADER_BG,CLR_FRAME,1);
   SetLabel("20503","组",8,PANEL_FONT_B,CLR_TEXT_META,c0,hdrY+2);
   SetLabel("20504","距加仓",8,PANEL_FONT_B,CLR_TEXT_META,c1,hdrY+2);
   SetLabel("20505","距减仓",8,PANEL_FONT_B,CLR_TEXT_META,c2,hdrY+2);
   SetLabel("20506","限频/手数",8,PANEL_FONT_B,CLR_TEXT_META,c3,hdrY+2);
   for(gi=1;gi<=16;gi++) {
      Y=hdrY+2+gi*rowH;
      rbg=(gi%2==0)?CLR_ALT_ROW:CLR_ALT_ROW2;
      SetRect("2051"+DoubleToString(gi,0),rx+4,Y-1,rw-8,rowH-1,rbg,rbg,1);
      addPct=100; aTxt="- 无仓"; aC=CLR_TEXT_META;
      if(g_GC_lots[gi]>0 && g_GC_pnl[gi]<0) {
         thr=g_GC_lots[gi]*6.8*100;
         addPct=(-g_GC_pnl[gi])/((thr>0.01)?thr:0.01)*100;
         aTxt=DoubleToString(addPct,0)+"%";
         if(addPct>=100)      aC=CLR_TEXT_LOSS;
         else if(addPct>=70) aC=CLR_TEXT_WARN;
         else                 aC=CLR_SIDE_BUY;
      } else if(g_GC_lots[gi]>0 && g_GC_pnl[gi]>=0) {
         aTxt="+"+DoubleToString(g_GC_pnl[gi],1); aC=CLR_SIDE_BUY;
      }
      rTxt=(g_GC_signal[gi]!=0)?"待命":"无信号";
      rC  =(g_GC_signal[gi]!=0)?CLR_TEXT_WARN:CLR_TEXT_DIM;
      lTxt="手:"+DoubleToString(g_GC_lots[gi],2); lC=White;
      SetLabel("2052"+DoubleToString(gi,0),"G"+DoubleToString(gi,0),7,PANEL_FONT,White,c0,Y+1);
      SetLabel("2053"+DoubleToString(gi,0),aTxt,7,PANEL_FONT_B,aC,c1,Y+1);
      SetLabel("2054"+DoubleToString(gi,0),rTxt,7,PANEL_FONT_B,rC,c2,Y+1);
      SetLabel("2055"+DoubleToString(gi,0),lTxt,7,PANEL_FONT,lC,c3,Y+1);
   }
}
void RenderActivityLog() {
   int lx,lw,ly,rowH;
   int c0,c1,c2,c3;
   int i,idx,Y;
   string line,tm,bd;
   color rbg;
   lx=5; lw=990; ly=602; rowH=10;
   c0=lx+8;  c1=lx+85;  c2=lx+210; c3=lx+410;
   SetRect("20600",lx,ly,lw,106,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20601","  活动日志 · 最近事件",9,PANEL_FONT_B,CLR_TEXT_WARN,lx+6,ly+4);
   SetLabel("20602","时间",7,PANEL_FONT_B,CLR_TEXT_META,c0,ly+20);
   SetLabel("20603","事件",7,PANEL_FONT_B,CLR_TEXT_META,c1,ly+20);
   SetLabel("20604","详情",7,PANEL_FONT_B,CLR_TEXT_META,c2,ly+20);
   SetLabel("20605","状态",7,PANEL_FONT_B,CLR_TEXT_META,c3,ly+20);
   for(i=0;i<8;i++) {
      idx=(g_LogPtr-1-i+8)%8;
      Y=ly+32+i*rowH;
      line=g_LogLine[idx];
      rbg=(i%2==0)?CLR_ALT_ROW:CLR_ALT_ROW2;
      SetRect("2061"+DoubleToString(i,0),lx+4,Y-1,lw-8,rowH,rbg,rbg,1);
      if(StringLen(line)<3) {
         SetLabel("2062"+DoubleToString(i,0),"",7,PANEL_FONT,CLR_TEXT_DIM,c0,Y+1);
         SetLabel("2063"+DoubleToString(i,0),"- 无记录 -",7,PANEL_FONT,CLR_TEXT_DIM,c1,Y+1);
         continue;
      }
      tm=StringSubstr(line,0,StringFind(line,"| "));
      bd=StringSubstr(line,StringFind(line,"| ")+2);
      SetLabel("2064"+DoubleToString(i,0),tm,7,PANEL_FONT,White,c0,Y+1);
      SetLabel("2065"+DoubleToString(i,0),bd,7,PANEL_FONT,CLR_TEXT_META,c1,Y+1);
   }
}


 double GetCurrencyStrength (string bsw_0,int bsw_1)
 {
 int         dfz_in_1=0;
 int         dfz_in_2=0;
 int         dfz_in_3=0;
 int         dfz_in_4=0;
 double      dfz_do_5=0.0;
 double      dfz_do_6=0.0;
 double      dfz_do_7=0.0;
 double      dfz_do_8=0.0;
 double      dfz_do_9=0.0;
 double      dfz_do_10=0.0;
 double      dfz_do_11=0.0;
 double      dfz_do_12=0.0;
 double      dfz_do_13=0.0;
 double      dfz_do_14=0.0;
 double      dfz_do_15=0.0;
 double      dfz_do_16=0.0;
 double      dfz_do_17=0.0;
 double      dfz_do_18=0.0;
 int         dfz_in_19=0;
 double      dfz_do_20=0.0;

 dfz_in_1 = 3 ;
 dfz_in_2 = 6 ;
 dfz_in_3 = 2 ;
 dfz_in_4 = 5 ;
 dfz_in_19 = -1 ;
 dfz_do_5 = GetMultiTimeframeMA("EURUSD",2,3,6,bsw_1) ;
 dfz_do_6 = GetMultiTimeframeMA("EURUSD",5,3,6,bsw_1) ;
 if ( ( dfz_do_5<=0 || dfz_do_6<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_7 = GetMultiTimeframeMA("GBPUSD",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_8 = GetMultiTimeframeMA("GBPUSD",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_7<=0 || dfz_do_8<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_9 = GetMultiTimeframeMA("AUDUSD",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_10 = GetMultiTimeframeMA("AUDUSD",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_9<=0 || dfz_do_10<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_11 = GetMultiTimeframeMA("NZDUSD",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_12 = GetMultiTimeframeMA("NZDUSD",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_11<=0 || dfz_do_12<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_13 = GetMultiTimeframeMA("USDCAD",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_14 = GetMultiTimeframeMA("USDCAD",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_13<=0 || dfz_do_14<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_15 = GetMultiTimeframeMA("USDCHF",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_16 = GetMultiTimeframeMA("USDCHF",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_15<=0 || dfz_do_16<=0 ) )
  {
  return(dfz_in_19); 
  }
 dfz_do_17 = GetMultiTimeframeMA("USDJPY",dfz_in_3,dfz_in_1,dfz_in_2,bsw_1) ;
 dfz_do_18 = GetMultiTimeframeMA("USDJPY",dfz_in_4,dfz_in_1,dfz_in_2,bsw_1) ;
 if ( ( dfz_do_17<=0 || dfz_do_18<=0 ) )
  {
  return(dfz_in_19); 
  }
 if ( bsw_0=="USD" )
  {
  dfz_do_20 = dfz_do_6 / dfz_do_5 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 / dfz_do_7 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 / dfz_do_9 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_12 / dfz_do_11 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_15 / dfz_do_16 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_13 / dfz_do_14 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_17 / dfz_do_18 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="GBP" )
  {
  dfz_do_20 = dfz_do_7 / dfz_do_8 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 / dfz_do_8 / (dfz_do_5 / dfz_do_7) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 / dfz_do_9 / (dfz_do_8 / dfz_do_10) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 / dfz_do_11 / (dfz_do_8 / dfz_do_12) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 * dfz_do_15 / (dfz_do_8 * dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 * dfz_do_13 / (dfz_do_8 * dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_7 * dfz_do_17 / (dfz_do_8 * dfz_do_18) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="EUR" )
  {
  dfz_do_20 = dfz_do_5 / dfz_do_6 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 / dfz_do_7 / (dfz_do_6 / dfz_do_8) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 / dfz_do_9 / (dfz_do_6 / dfz_do_10) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 / dfz_do_11 / (dfz_do_6 / dfz_do_12) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 * dfz_do_15 / (dfz_do_6 * dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 * dfz_do_13 / (dfz_do_6 * dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_5 * dfz_do_17 / (dfz_do_6 * dfz_do_18) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="AUD" )
  {
  dfz_do_20 = dfz_do_9 / dfz_do_10 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 / dfz_do_10 / (dfz_do_5 / dfz_do_9) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 / dfz_do_10 / (dfz_do_7 / dfz_do_9) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_9 / dfz_do_11 / (dfz_do_10 / dfz_do_12) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_9 * dfz_do_15 / (dfz_do_10 * dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_9 * dfz_do_13 / (dfz_do_10 * dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_9 * dfz_do_17 / (dfz_do_10 * dfz_do_18) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="CAD" )
  {
  dfz_do_20 = dfz_do_14 / dfz_do_13 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 * dfz_do_14 / (dfz_do_5 * dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 * dfz_do_14 / (dfz_do_7 * dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 * dfz_do_14 / (dfz_do_9 * dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_12 * dfz_do_14 / (dfz_do_11 * dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_15 / dfz_do_13 / (dfz_do_16 / dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_17 / dfz_do_13 / (dfz_do_18 / dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="JPY" )
  {
  dfz_do_20 = dfz_do_18 / dfz_do_17 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 * dfz_do_18 / (dfz_do_5 * dfz_do_17) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 * dfz_do_18 / (dfz_do_7 * dfz_do_17) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 * dfz_do_18 / (dfz_do_10 * dfz_do_17) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_12 * dfz_do_18 / (dfz_do_11 * dfz_do_17) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_18 / dfz_do_14 / (dfz_do_17 / dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_18 / dfz_do_16 / (dfz_do_18 / dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="CHF" )
  {
  dfz_do_20 = dfz_do_16 / dfz_do_15 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 * dfz_do_16 / (dfz_do_5 * dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 * dfz_do_16 / (dfz_do_7 * dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 * dfz_do_16 / (dfz_do_9 * dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_12 * dfz_do_16 / (dfz_do_11 * dfz_do_15) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_16 / dfz_do_14 / (dfz_do_15 / dfz_do_13) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_17 / dfz_do_15 / (dfz_do_18 / dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 if ( bsw_0=="NZD" )
  {
  dfz_do_20 = dfz_do_11 / dfz_do_12 - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_6 / dfz_do_12 / (dfz_do_5 / dfz_do_11) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_8 / dfz_do_12 / (dfz_do_7 / dfz_do_11) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_10 / dfz_do_12 / (dfz_do_9 / dfz_do_11) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_11 * dfz_do_15 / (dfz_do_12 * dfz_do_16) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_11 * dfz_do_13 / (dfz_do_12 * dfz_do_14) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_11 * dfz_do_17 / (dfz_do_12 * dfz_do_18) - 1 + dfz_do_20 ;
  dfz_do_20 = dfz_do_20 * 1000 ;
  }
 return(NormalizeDouble(dfz_do_20,4)); 

 }

 double GetMultiTimeframeMA (string bsw_0,int bsw_1,int bsw_2,int bsw_3,int bsw_4)
 {
 double      dfz_do_1=0.0;
 int         dfz_in_2=0;
 int         dfz_in_3=0;
 int         dfz_in_4=0;

 dfz_in_2 = 4 ;
 switch(Period())
 {
 case 1 :
  dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
  dfz_in_2 = dfz_in_2 + 5;
  case 5 :
   dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
   dfz_in_2 = dfz_in_2 + 3;
   case 15 :
    dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
    dfz_in_2 = dfz_in_2 + 2;
    case 30 :
     dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
     dfz_in_2 = dfz_in_2 + 2;
     case 60 :
      dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
      dfz_in_2 = dfz_in_2 + 4;
      case 240 :
       dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
       dfz_in_2 = dfz_in_2 + 6;
       case 1440 :
        dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
        dfz_in_2 = dfz_in_2 + 5;
        case 10080 :
         dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
         dfz_in_2 = dfz_in_2 + 4;
         case 43200 :
          dfz_do_1 = dfz_do_1 + iMA(bsw_0,dfz_in_4,bsw_1 * dfz_in_2,dfz_in_3,bsw_2,bsw_3,bsw_4) ;
          }
         return(dfz_do_1); 
         }

         int ManageGroup (string bsw_0)
         {
 int         dfz_in_1=0;
 int         dfz_in_2=0;
 color       dfz_ui_3    =clrNONE;
 color       dfz_ui_4    =clrNONE;
 color       dfz_ui_5    =clrNONE;
 double      dfz_do_6=0.0;
 double      dfz_do_7=0.0;
 double      dfz_do_8=0.0;
 double      dfz_do_9=0.0;
 double      dfz_do_10=0.0;
 double      dfz_do_11=0.0;
 double      dfz_do_12=0.0;
 double      dfz_do_13=0.0;
 double      dfz_do_14=0.0;
 double      dfz_do_15=0.0;

 string     aa_st_3;
 string     aa_st_4;

 string     aa_st_22;
 string     aa_st_23;
 string     aa_st_38;
 string     aa_st_39;
 int        aa_in_53;
 int        aa_in_54;
 int        aa_in_55;
 bool       aa_bo_59;
 bool       aa_bo_62;
 double     aa_do_63;
 int        aa_in_64;
 int        aa_in_65;
 double     aa_do_66;
 double     aa_do_67;
 int        aa_in_69;
 double     aa_do_70;
 double     aa_do_71;
 string     aa_st_74;
 int        aa_in_68;
 int        aa_in_75;
 int        aa_in_76;
 string     aa_st_79;
 int        aa_in_77;
 int        aa_in_80;
 int        aa_in_81;
 int        aa_in_82;
 int        aa_in_84;
 int        aa_in_85;
 string     aa_st_87;
 double     aa_do_88;
 int        aa_in_89;
 double     aa_do_90;
 int        aa_in_91;
 int        aa_in_92;
 int        aa_in_93;
 double     aa_do_96;
 int        aa_in_97;
 bool       aa_bo_99;
 bool       aa_bo_104;
 string     aa_st_105;
 int        aa_in_106;
 int        aa_in_107;
 string     aa_st_109;
 int        aa_in_108;
 int        aa_in_110;
 string     aa_st_112;
 int        aa_in_111;
 int        aa_in_113;
 string     aa_st_115;
 int        aa_in_114;
 int        aa_in_116;
 string     aa_st_118;
 int        aa_in_117;
 int        aa_in_119;
 int        aa_in_120;
 string     aa_st_122;
 double     aa_do_123;
 int        aa_in_124;
 double     aa_do_126;
 string     aa_st_127;
 int        aa_in_128;
 int        aa_in_129;
 string     aa_st_132;
 int        aa_in_125;
 int        aa_in_130;
 int        aa_in_133;
 string     aa_st_135;
 double     aa_do_136;
 int        aa_in_137;
 double     aa_do_139;
 string     aa_st_140;
 int        aa_in_141;
 int        aa_in_142;
 bool       aa_bo_146;
 string     aa_st_147;
 string     aa_st_148;
 double     aa_do_149;
 int        aa_in_150;
 string     aa_st_153;
 double     aa_do_151;
 int        aa_in_154;
 double     aa_do_155;
 string     aa_st_156;
 double     aa_do_157;
 int        aa_in_158;
 double     aa_do_160;
 string     aa_st_161;
 double     aa_do_162;
 int        aa_in_163;
 double     aa_do_164;
 string     aa_st_165;
 double     aa_do_166;
 int        aa_in_167;
 bool       aa_bo_159;
 string     aa_st_171;
 string     aa_st_172;
 double     aa_do_168;
 int        aa_in_173;
 string     aa_st_176;
 double     aa_do_174;
 int        aa_in_177;
 double     aa_do_178;
 string     aa_st_179;
 double     aa_do_180;
 int        aa_in_181;
 double     aa_do_183;
 string     aa_st_184;
 double     aa_do_185;
 int        aa_in_186;
 double     aa_do_187;
 string     aa_st_188;
 double     aa_do_189;
 int        aa_in_190;
 bool       aa_bo_182;
 string     aa_st_194;
 string     aa_st_195;
 double     aa_do_191;
 int        aa_in_196;
 string     aa_st_199;
 double     aa_do_197;
 int        aa_in_200;
 double     aa_do_201;
 string     aa_st_202;
 double     aa_do_203;
 int        aa_in_204;
 double     aa_do_206;
 string     aa_st_207;
 double     aa_do_208;
 int        aa_in_209;
 double     aa_do_210;
 string     aa_st_211;
 double     aa_do_212;
 int        aa_in_213;
 bool       aa_bo_205;
 string     aa_st_217;
 string     aa_st_218;
 double     aa_do_214;
 int        aa_in_219;
 string     aa_st_222;
 double     aa_do_220;
 int        aa_in_223;
 double     aa_do_224;
 string     aa_st_225;
 double     aa_do_226;
 int        aa_in_227;
 double     aa_do_229;
 string     aa_st_230;
 double     aa_do_231;
 int        aa_in_232;
 double     aa_do_233;
 string     aa_st_234;
 double     aa_do_235;
 int        aa_in_236;

 g_GroupName = bsw_0 ;
 CalcSpreadSignal(); 
 by_bo_165 = false ;
 if ( g_GroupName=="第1组2" )
  {
  g_Symbol1 = H01Symbol ;
  g_Symbol2 = H02Symbol ;
  }
 if ( g_GroupName=="第2组2" )
  {
  g_Symbol1 = H03Symbol ;
  g_Symbol2 = H04Symbol ;
  }
 if ( g_GroupName=="第3组2" )
  {
  g_Symbol1 = H05Symbol ;
  g_Symbol2 = H06Symbol ;
  }
 if ( g_GroupName=="第4组2" )
  {
  g_Symbol1 = H07Symbol ;
  g_Symbol2 = H08Symbol ;
  }
 if ( g_GroupName=="第5组2" )
  {
  g_Symbol1 = H09Symbol ;
  g_Symbol2 = H10Symbol ;
  }
 if ( g_GroupName=="第6组2" )
  {
  g_Symbol1 = H11Symbol ;
  g_Symbol2 = H12Symbol ;
  }
 if ( g_GroupName=="第7组2" )
  {
  g_Symbol1 = H13Symbol ;
  g_Symbol2 = H14Symbol ;
  }
 if ( g_GroupName=="第8组2" )
  {
  g_Symbol1 = H15Symbol ;
  g_Symbol2 = H16Symbol ;
  }
 if ( g_GroupName=="第9组2" )
  {
  g_Symbol1 = H17Symbol ;
  g_Symbol2 = H18Symbol ;
  }
 if ( g_GroupName=="第10组2" )
  {
  g_Symbol1 = H19Symbol ;
  g_Symbol2 = H20Symbol ;
  }
 if ( g_GroupName=="第11组2" )
  {
  g_Symbol1 = H21Symbol ;
  g_Symbol2 = H22Symbol ;
  }
 if ( g_GroupName=="第12组2" )
  {
  g_Symbol1 = H23Symbol ;
  g_Symbol2 = H24Symbol ;
  }
 if ( g_GroupName=="第13组2" )
  {
  g_Symbol1 = H25Symbol ;
  g_Symbol2 = H26Symbol ;
  }
 if ( g_GroupName=="第14组2" )
  {
  g_Symbol1 = H27Symbol ;
  g_Symbol2 = H28Symbol ;
  }
 if ( g_GroupName=="第15组2" )
  {
  g_Symbol1 = H29Symbol ;
  g_Symbol2 = H30Symbol ;
  }
 if ( g_GroupName=="第16组2" )
  {
  g_Symbol1 = H31Symbol ;
  g_Symbol2 = H32Symbol ;
  }
 by_bo_165 = false ;
 dfz_in_1 = (int)MarketInfo(g_Symbol1,13) ;
 dfz_in_2 = (int)MarketInfo(g_Symbol2,13) ;
 dfz_do_6 = MarketInfo(g_Symbol1,18) ;
 dfz_do_7 = MarketInfo(g_Symbol1,19) ;
 dfz_do_8 = MarketInfo(g_Symbol2,18) ;
 dfz_do_9 = MarketInfo(g_Symbol2,19) ;
 
  
 if ( CalcCorrelation(30,15,g_Symbol2,g_Symbol1)>0.7 && 
      CalcCorrelation(30,60,g_Symbol2,g_Symbol1)>0.7  &&  
      CalcCorrelation(30,240,g_Symbol2,g_Symbol1)>0.7
    ){}else
    {return(0); }
  
 
 if ( dfz_in_1< 70 && dfz_in_2< 70 && ( ( g_SpreadSignal==1 && dfz_do_6 + dfz_do_9>dfz_do_7 + dfz_do_8 ) || (g_SpreadSignal==2 && dfz_do_7 + dfz_do_8>dfz_do_6 + dfz_do_9) ) && !只平不开 )
  {
  aa_in_53 = 0;
  aa_in_54 = 0;
  for (aa_in_55 = 0 ; aa_in_55<OrdersTotal() ; aa_in_55=aa_in_55 + 1)
   {
   if ( OrderSelect(aa_in_55,SELECT_BY_POS,MODE_TRADES)!=false && ( OrderSymbol()==g_Symbol1 || OrderSymbol()==g_Symbol2 ) && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
    {
    if ( OrderType()==0 )
     {
     aa_in_53=aa_in_53 + 1; 
     }
    if ( OrderType()==1 )
     {
     aa_in_54=aa_in_54 + 1; 
    }}
   }
  if ( aa_in_53 + aa_in_54==0 )
   {
   if ( ((MathAbs(iClose(g_Symbol1,0,0) - iLow(g_Symbol1,PERIOD_D1,0))) / MarketInfo(g_Symbol1,11)) / 10>400 )
    {
    aa_bo_59 = true;
    }
   else
    {
    aa_bo_59 = false;
    }
   if ( !aa_bo_59 )
    {
    if ( ((MathAbs(iClose(g_Symbol2,0,0) - iLow(g_Symbol2,PERIOD_D1,0))) / MarketInfo(g_Symbol2,11)) / 10>400 )
     {
     aa_bo_62 = true;
     }
    else
     {
     aa_bo_62 = false;
     }
    if ( !aa_bo_62 )
     {
     if ( g_SpreadSignal==1 )
      {
      by_in_290 = 0 ;
      by_in_291 = 1 ;
      dfz_do_10 = MarketInfo(g_Symbol1,10) ;
      dfz_do_11 = MarketInfo(g_Symbol2,9) ;
      dfz_ui_3 = Green ;
      dfz_ui_4 = Green ;
      dfz_ui_5 = Red ;
      }
     else
      {
      if ( g_SpreadSignal==2 )
       {
       by_in_290 = 1 ;
       by_in_291 = 0 ;
       dfz_do_10 = MarketInfo(g_Symbol1,9) ;
       dfz_do_11 = MarketInfo(g_Symbol2,10) ;
       dfz_ui_3 = Red ;
       dfz_ui_4 = Red ;
       dfz_ui_5 = Green ;
       }
      else
       {
       return(0); 
      }}
     by_do_154 = NormalizeDouble(lot,2) ;
     aa_do_63 = 0;
     by_st_273 = g_Symbol1 ;
     by_st_274 = g_Symbol2 ;
     aa_in_64 = 60;
     aa_in_65 = 200;
     aa_do_66 = 0;
     aa_do_67 = 0;
     for (aa_in_69 = 200 - 1 ; aa_in_69>=0 ; aa_in_69=aa_in_69 - 1)
      {
      aa_do_66 = (iHigh(by_st_273,aa_in_64,aa_in_69) - iLow(by_st_273,aa_in_64,aa_in_69)) / MarketInfo(by_st_273,11) + aa_do_66;
      aa_do_67 = (iHigh(by_st_274,aa_in_64,aa_in_69) - iLow(by_st_274,aa_in_64,aa_in_69)) / MarketInfo(by_st_274,11) + aa_do_67;
      }
     aa_do_70 = aa_do_66 / aa_in_65 * MarketInfo(by_st_273,16);
     aa_do_71 = aa_do_67 / aa_in_65 * MarketInfo(by_st_274,16);
     if ( aa_do_67 / aa_in_65 * MarketInfo(by_st_274,16)!=0 )
      {
      aa_do_63 = aa_do_70 / aa_do_71;
      }
     by_do_155 = NormalizeDouble(aa_do_63 * lot,2) ;
     if ( by_do_154<0.01 )
      {
      by_do_154 = 0.01 ;
      }
     if ( by_do_155<0.01 )
      {
      by_do_155 = 0.01 ;
      }
     RefreshRates(); 
     aa_st_74 = g_Symbol1;
     aa_in_68 = 0;
     aa_in_75 = 0;
     for (aa_in_76 = 0 ; aa_in_76<OrdersTotal() ; aa_in_76=aa_in_76 + 1)
      {
      if ( OrderSelect(aa_in_76,SELECT_BY_POS,MODE_TRADES)!=false && OrderComment()==g_GroupName && OrderMagicNumber()==g_MagicNumber && OrderSymbol()==aa_st_74 )
       {
       if ( OrderType()==0 )
        {
        aa_in_68=aa_in_68 + 1; 
        }
       if ( OrderType()==1 )
        {
        aa_in_75=aa_in_75 + 1; 
       }}
      }
     if ( aa_in_68 + aa_in_75==0 && !OrderSend(g_Symbol1,by_in_290,by_do_154,dfz_do_10,50,0,0,g_GroupName,g_MagicNumber,0,dfz_ui_3) )
      {
      Print(g_Symbol1 + "开仓",GetLastError()); 
      }
     aa_st_79 = g_Symbol2;
     aa_in_77 = 0;
     aa_in_80 = 0;
     for (aa_in_81 = 0 ; aa_in_81<OrdersTotal() ; aa_in_81=aa_in_81 + 1)
      {
      if ( OrderSelect(aa_in_81,SELECT_BY_POS,MODE_TRADES)!=false && OrderComment()==g_GroupName && OrderMagicNumber()==g_MagicNumber && OrderSymbol()==aa_st_79 )
       {
       if ( OrderType()==0 )
        {
        aa_in_77=aa_in_77 + 1; 
        }
       if ( OrderType()==1 )
        {
        aa_in_80=aa_in_80 + 1; 
       }}
      }
     if ( aa_in_77 + aa_in_80==0 && !OrderSend(g_Symbol2,by_in_291,by_do_155,dfz_do_11,50,0,0,g_GroupName,g_MagicNumber,0,dfz_ui_4) )
      {
      Print(g_Symbol2 + "开仓",GetLastError()); 
      }
     by_bo_165 = false ;
  }}}}
 aa_in_82 = 0;
 aa_in_84 = 0;
 for (aa_in_85 = 0 ; aa_in_85<OrdersTotal() ; aa_in_85=aa_in_85 + 1)
  {
  if ( OrderSelect(aa_in_85,SELECT_BY_POS,MODE_TRADES)!=false && ( OrderSymbol()==g_Symbol1 || OrderSymbol()==g_Symbol2 ) && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
   {
   if ( OrderType()==0 )
    {
    aa_in_82=aa_in_82 + 1; 
    }
   if ( OrderType()==1 )
    {
    aa_in_84=aa_in_84 + 1; 
   }}
  }
 if ( aa_in_82 + aa_in_84>=2 )
  {
  aa_st_87 = bsw_0;
  aa_do_88 = 0;
  for (aa_in_89 = 0 ; aa_in_89<OrdersTotal() ; aa_in_89=aa_in_89 + 1)
   {
   if ( OrderSelect(aa_in_89,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_87 )
    {
    aa_do_88 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_88;
    }
   }
  aa_do_90 = aa_do_88;
  aa_in_91 = 0;
  aa_in_92 = 0;
  for (aa_in_93 = 0 ; aa_in_93<OrdersTotal() ; aa_in_93=aa_in_93 + 1)
   {
   if ( OrderSelect(aa_in_93,SELECT_BY_POS,MODE_TRADES)!=false && ( OrderSymbol()==g_Symbol1 || OrderSymbol()==g_Symbol2 ) && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
    {
    if ( OrderType()==0 )
     {
     aa_in_91=aa_in_91 + 1; 
     }
    if ( OrderType()==1 )
     {
     aa_in_92=aa_in_92 + 1; 
    }}
   }
  aa_do_96 = 0;
  for (aa_in_97 = 0 ; aa_in_97<=OrdersTotal() - 1 ; aa_in_97=aa_in_97 + 1)
   {
   if ( OrderSelect(aa_in_97,SELECT_BY_POS,MODE_TRADES)!=false && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
    {
    aa_do_96 = OrderLots();
    }
   }
  if ( aa_do_90<( -(aa_in_91 + aa_in_92) / 2) * aa_do_96 * 100 * 6 * 1.4 )
   {
   if ( ((MathAbs(iClose(g_Symbol1,0,0) - iLow(g_Symbol1,PERIOD_D1,0))) / MarketInfo(g_Symbol1,11)) / 10>400 )
    {
    aa_bo_99 = true;
    }
   else
    {
    aa_bo_99 = false;
    }
   if ( !aa_bo_99 )
    {
    if ( ((MathAbs(iClose(g_Symbol2,0,0) - iLow(g_Symbol2,PERIOD_D1,0))) / MarketInfo(g_Symbol2,11)) / 10>400 )
     {
     aa_bo_104 = true;
     }
    else
     {
     aa_bo_104 = false;
     }
    if ( !aa_bo_104 )
     {
     aa_st_105 = g_Symbol1;
     aa_in_106 = -1;
     for (aa_in_107 = 0 ; aa_in_107<=OrdersTotal() - 1 ; aa_in_107=aa_in_107 + 1)
      {
      if ( OrderSelect(aa_in_107,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_105 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
       {
       aa_in_106 = OrderType();
       }
      }
     if ( aa_in_106==0 )
      {
      aa_st_109 = g_Symbol2;
      aa_in_108 = -1;
      for (aa_in_110 = 0 ; aa_in_110<=OrdersTotal() - 1 ; aa_in_110=aa_in_110 + 1)
       {
       if ( OrderSelect(aa_in_110,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_109 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_in_108 = OrderType();
        }
       }
      if ( aa_in_108==1 )
       {
       dfz_do_10 = MarketInfo(g_Symbol1,10) ;
       dfz_do_11 = MarketInfo(g_Symbol2,9) ;
       dfz_ui_3 = Green ;
       dfz_ui_4 = Red ;
      }}
     aa_st_112 = g_Symbol1;
     aa_in_111 = -1;
     for (aa_in_113 = 0 ; aa_in_113<=OrdersTotal() - 1 ; aa_in_113=aa_in_113 + 1)
      {
      if ( OrderSelect(aa_in_113,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_112 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
       {
       aa_in_111 = OrderType();
       }
      }
     if ( aa_in_111==1 )
      {
      aa_st_115 = g_Symbol2;
      aa_in_114 = -1;
      for (aa_in_116 = 0 ; aa_in_116<=OrdersTotal() - 1 ; aa_in_116=aa_in_116 + 1)
       {
       if ( OrderSelect(aa_in_116,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_115 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_in_114 = OrderType();
        }
       }
      if ( aa_in_114==0 )
       {
       dfz_do_10 = MarketInfo(g_Symbol1,9) ;
       dfz_do_11 = MarketInfo(g_Symbol2,10) ;
       dfz_ui_3 = Red ;
       dfz_ui_4 = Green ;
      }}
     RefreshRates(); 
     aa_st_118 = g_Symbol1;
     aa_in_117 = 0;
     aa_in_119 = 0;
     for (aa_in_120 = 0 ; aa_in_120<OrdersTotal() ; aa_in_120=aa_in_120 + 1)
      {
      if ( OrderSelect(aa_in_120,SELECT_BY_POS,MODE_TRADES)!=false && OrderComment()==g_GroupName && OrderMagicNumber()==g_MagicNumber && OrderSymbol()==aa_st_118 )
       {
       if ( OrderType()==0 )
        {
        aa_in_117=aa_in_117 + 1; 
        }
       if ( OrderType()==1 )
        {
        aa_in_119=aa_in_119 + 1; 
       }}
      }
     if ( aa_in_117 + aa_in_119>=1 && by_lo_148 != iTime(g_Symbol1,0,0) )
      {
      aa_st_122 = g_Symbol1;
      aa_do_123 = 0;
      for (aa_in_124 = 0 ; aa_in_124<=OrdersTotal() - 1 ; aa_in_124=aa_in_124 + 1)
       {
       if ( OrderSelect(aa_in_124,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_122 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_do_123 = OrderLots();
        }
       }
      aa_do_126 = NormalizeDouble(aa_do_123 * 1.5,2);
      aa_st_127 = g_Symbol1;
      aa_in_128 = -1;
      for (aa_in_129 = 0 ; aa_in_129<=OrdersTotal() - 1 ; aa_in_129=aa_in_129 + 1)
       {
       if ( OrderSelect(aa_in_129,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_127 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_in_128 = OrderType();
        }
       }
      if ( !OrderSend(g_Symbol1,aa_in_128,aa_do_126,dfz_do_10,50,0,0,g_GroupName,g_MagicNumber,0,dfz_ui_3) )
       {
       by_lo_148 = iTime(g_Symbol1,0,0) ;
       }
      Print(g_Symbol1 + "加仓",GetLastError()); 
      }
     aa_st_132 = g_Symbol2;
     aa_in_125 = 0;
     aa_in_130 = 0;
     for (aa_in_133 = 0 ; aa_in_133<OrdersTotal() ; aa_in_133=aa_in_133 + 1)
      {
      if ( OrderSelect(aa_in_133,SELECT_BY_POS,MODE_TRADES)!=false && OrderComment()==g_GroupName && OrderMagicNumber()==g_MagicNumber && OrderSymbol()==aa_st_132 )
       {
       if ( OrderType()==0 )
        {
        aa_in_125=aa_in_125 + 1; 
        }
       if ( OrderType()==1 )
        {
        aa_in_130=aa_in_130 + 1; 
       }}
      }
     if ( aa_in_125 + aa_in_130>=1 && by_lo_149 != iTime(g_Symbol2,0,0) )
      {
      aa_st_135 = g_Symbol2;
      aa_do_136 = 0;
      for (aa_in_137 = 0 ; aa_in_137<=OrdersTotal() - 1 ; aa_in_137=aa_in_137 + 1)
       {
       if ( OrderSelect(aa_in_137,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_135 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_do_136 = OrderLots();
        }
       }
      aa_do_139 = NormalizeDouble(aa_do_136 * 1.5,2);
      aa_st_140 = g_Symbol2;
      aa_in_141 = -1;
      for (aa_in_142 = 0 ; aa_in_142<=OrdersTotal() - 1 ; aa_in_142=aa_in_142 + 1)
       {
       if ( OrderSelect(aa_in_142,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_140 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName )
        {
        aa_in_141 = OrderType();
        }
       }
      if ( !OrderSend(g_Symbol2,aa_in_141,aa_do_139,dfz_do_11,50,0,0,g_GroupName,g_MagicNumber,0,dfz_ui_4) )
       {
       by_lo_149 = iTime(g_Symbol2,0,0) ;
       }
      Print(g_Symbol2 + "加仓",GetLastError()); 
  }}}}}
 if ( ((MathAbs(iClose(g_Symbol1,0,0) - iLow(g_Symbol1,PERIOD_D1,0))) / MarketInfo(g_Symbol1,11)) / 10>400 )
  {
  aa_bo_146 = true;
  }
 else
  {
  aa_bo_146 = false;
  }
 if ( aa_bo_146 )
  {
  aa_st_147 = bsw_0;
  aa_st_148 = g_Symbol1;
  aa_do_149 = 0;
  for (aa_in_150 = 0 ; aa_in_150<OrdersTotal() ; aa_in_150=aa_in_150 + 1)
   {
   if ( OrderSelect(aa_in_150,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_148 && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_147 )
    {
    aa_do_149 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_149;
    }
   }
  if ( aa_do_149<0 )
   {
   aa_st_153 = g_Symbol1;
   aa_do_151 = 0;
   for (aa_in_154 = 0 ; aa_in_154<=OrdersTotal() ; aa_in_154=aa_in_154 + 1)
    {
    if ( OrderSelect(aa_in_154,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_153 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
     {
     aa_do_151 = aa_do_151 + OrderLots();
     }
    }
   aa_do_155 = aa_do_151;
   aa_st_156 = g_Symbol1;
   aa_do_157 = 0;
   for (aa_in_158 = 0 ; aa_in_158<=OrdersTotal() ; aa_in_158=aa_in_158 + 1)
    {
    if ( OrderSelect(aa_in_158,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_156 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
     {
     aa_do_157 = aa_do_157 + OrderLots();
     }
    }
   if ( aa_do_155>aa_do_157 && by_lo_148 != iTime(g_Symbol1,0,0) )
    {
    aa_do_160 = MarketInfo(g_Symbol1,9);
    aa_st_161 = g_Symbol1;
    aa_do_162 = 0;
    for (aa_in_163 = 0 ; aa_in_163<=OrdersTotal() ; aa_in_163=aa_in_163 + 1)
     {
     if ( OrderSelect(aa_in_163,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_161 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
      {
      aa_do_162 = aa_do_162 + OrderLots();
      }
     }
    aa_do_164 = aa_do_162;
    aa_st_165 = g_Symbol1;
    aa_do_166 = 0;
    for (aa_in_167 = 0 ; aa_in_167<=OrdersTotal() ; aa_in_167=aa_in_167 + 1)
     {
     if ( OrderSelect(aa_in_167,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_165 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
      {
      aa_do_166 = aa_do_166 + OrderLots();
      }
     }
    if ( !OrderSend(g_Symbol1,OP_SELL,aa_do_164 - aa_do_166,aa_do_160,50,0,0,g_GroupName,g_MagicNumber,0,Red) )
     {
     PrintFormat("锁单S",GetLastError()); 
     }
    by_lo_148 = iTime(g_Symbol1,0,0) ;
    by_bo_165 = true ;
  }}}
 if ( ((MathAbs(iClose(g_Symbol1,0,0) - iLow(g_Symbol1,PERIOD_D1,0))) / MarketInfo(g_Symbol1,11)) / 10>400 )
  {
  aa_bo_159 = true;
  }
 else
  {
  aa_bo_159 = false;
  }
 if ( aa_bo_159 )
  {
  aa_st_171 = bsw_0;
  aa_st_172 = g_Symbol1;
  aa_do_168 = 0;
  for (aa_in_173 = 0 ; aa_in_173<OrdersTotal() ; aa_in_173=aa_in_173 + 1)
   {
   if ( OrderSelect(aa_in_173,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_172 && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_171 )
    {
    aa_do_168 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_168;
    }
   }
  if ( aa_do_168<0 )
   {
   aa_st_176 = g_Symbol1;
   aa_do_174 = 0;
   for (aa_in_177 = 0 ; aa_in_177<=OrdersTotal() ; aa_in_177=aa_in_177 + 1)
    {
    if ( OrderSelect(aa_in_177,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_176 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
     {
     aa_do_174 = aa_do_174 + OrderLots();
     }
    }
   aa_do_178 = aa_do_174;
   aa_st_179 = g_Symbol1;
   aa_do_180 = 0;
   for (aa_in_181 = 0 ; aa_in_181<=OrdersTotal() ; aa_in_181=aa_in_181 + 1)
    {
    if ( OrderSelect(aa_in_181,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_179 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
     {
     aa_do_180 = aa_do_180 + OrderLots();
     }
    }
   if ( aa_do_178<aa_do_180 && by_lo_148 != iTime(g_Symbol1,0,0) )
    {
    aa_do_183 = MarketInfo(g_Symbol1,10);
    aa_st_184 = g_Symbol1;
    aa_do_185 = 0;
    for (aa_in_186 = 0 ; aa_in_186<=OrdersTotal() ; aa_in_186=aa_in_186 + 1)
     {
     if ( OrderSelect(aa_in_186,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_184 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
      {
      aa_do_185 = aa_do_185 + OrderLots();
      }
     }
    aa_do_187 = aa_do_185;
    aa_st_188 = g_Symbol1;
    aa_do_189 = 0;
    for (aa_in_190 = 0 ; aa_in_190<=OrdersTotal() ; aa_in_190=aa_in_190 + 1)
     {
     if ( OrderSelect(aa_in_190,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_188 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
      {
      aa_do_189 = aa_do_189 + OrderLots();
      }
     }
    if ( !OrderSend(g_Symbol1,OP_BUY,aa_do_187 - aa_do_189,aa_do_183,50,0,0,g_GroupName,g_MagicNumber,0,LimeGreen) )
     {
     PrintFormat("锁单B",GetLastError()); 
     }
    by_lo_148 = iTime(g_Symbol1,0,0) ;
    by_bo_165 = true ;
  }}}
 if ( ((MathAbs(iClose(g_Symbol2,0,0) - iLow(g_Symbol2,PERIOD_D1,0))) / MarketInfo(g_Symbol2,11)) / 10>400 )
  {
  aa_bo_182 = true;
  }
 else
  {
  aa_bo_182 = false;
  }
 if ( aa_bo_182 )
  {
  aa_st_194 = bsw_0;
  aa_st_195 = g_Symbol2;
  aa_do_191 = 0;
  for (aa_in_196 = 0 ; aa_in_196<OrdersTotal() ; aa_in_196=aa_in_196 + 1)
   {
   if ( OrderSelect(aa_in_196,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_195 && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_194 )
    {
    aa_do_191 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_191;
    }
   }
  if ( aa_do_191<0 )
   {
   aa_st_199 = g_Symbol2;
   aa_do_197 = 0;
   for (aa_in_200 = 0 ; aa_in_200<=OrdersTotal() ; aa_in_200=aa_in_200 + 1)
    {
    if ( OrderSelect(aa_in_200,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_199 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
     {
     aa_do_197 = aa_do_197 + OrderLots();
     }
    }
   aa_do_201 = aa_do_197;
   aa_st_202 = g_Symbol2;
   aa_do_203 = 0;
   for (aa_in_204 = 0 ; aa_in_204<=OrdersTotal() ; aa_in_204=aa_in_204 + 1)
    {
    if ( OrderSelect(aa_in_204,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_202 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
     {
     aa_do_203 = aa_do_203 + OrderLots();
     }
    }
   if ( aa_do_201>aa_do_203 && by_lo_149 != iTime(g_Symbol2,0,0) )
    {
    aa_do_206 = MarketInfo(g_Symbol2,9);
    aa_st_207 = g_Symbol2;
    aa_do_208 = 0;
    for (aa_in_209 = 0 ; aa_in_209<=OrdersTotal() ; aa_in_209=aa_in_209 + 1)
     {
     if ( OrderSelect(aa_in_209,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_207 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
      {
      aa_do_208 = aa_do_208 + OrderLots();
      }
     }
    aa_do_210 = aa_do_208;
    aa_st_211 = g_Symbol2;
    aa_do_212 = 0;
    for (aa_in_213 = 0 ; aa_in_213<=OrdersTotal() ; aa_in_213=aa_in_213 + 1)
     {
     if ( OrderSelect(aa_in_213,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_211 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
      {
      aa_do_212 = aa_do_212 + OrderLots();
      }
     }
    if ( !OrderSend(g_Symbol2,OP_SELL,aa_do_210 - aa_do_212,aa_do_206,50,0,0,g_GroupName,g_MagicNumber,0,Red) )
     {
     PrintFormat("锁单S",GetLastError()); 
     }
    by_lo_149 = iTime(g_Symbol2,0,0) ;
    by_bo_165 = true ;
  }}}
 if ( ((MathAbs(iClose(g_Symbol2,0,0) - iLow(g_Symbol2,PERIOD_D1,0))) / MarketInfo(g_Symbol2,11)) / 10>400 )
  {
  aa_bo_205 = true;
  }
 else
  {
  aa_bo_205 = false;
  }
 if ( aa_bo_205 )
  {
  aa_st_217 = bsw_0;
  aa_st_218 = g_Symbol2;
  aa_do_214 = 0;
  for (aa_in_219 = 0 ; aa_in_219<OrdersTotal() ; aa_in_219=aa_in_219 + 1)
   {
   if ( OrderSelect(aa_in_219,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_218 && OrderMagicNumber()==g_MagicNumber && OrderComment()==aa_st_217 )
    {
    aa_do_214 = OrderProfit() + OrderSwap() + OrderCommission() + aa_do_214;
    }
   }
  if ( aa_do_214<0 )
   {
   aa_st_222 = g_Symbol2;
   aa_do_220 = 0;
   for (aa_in_223 = 0 ; aa_in_223<=OrdersTotal() ; aa_in_223=aa_in_223 + 1)
    {
    if ( OrderSelect(aa_in_223,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_222 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
     {
     aa_do_220 = aa_do_220 + OrderLots();
     }
    }
   aa_do_224 = aa_do_220;
   aa_st_225 = g_Symbol2;
   aa_do_226 = 0;
   for (aa_in_227 = 0 ; aa_in_227<=OrdersTotal() ; aa_in_227=aa_in_227 + 1)
    {
    if ( OrderSelect(aa_in_227,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_225 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
     {
     aa_do_226 = aa_do_226 + OrderLots();
     }
    }
   if ( aa_do_224<aa_do_226 && by_lo_149 != iTime(g_Symbol2,0,0) )
    {
    aa_do_229 = MarketInfo(g_Symbol2,10);
    aa_st_230 = g_Symbol2;
    aa_do_231 = 0;
    for (aa_in_232 = 0 ; aa_in_232<=OrdersTotal() ; aa_in_232=aa_in_232 + 1)
     {
     if ( OrderSelect(aa_in_232,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_230 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==1 )
      {
      aa_do_231 = aa_do_231 + OrderLots();
      }
     }
    aa_do_233 = aa_do_231;
    aa_st_234 = g_Symbol2;
    aa_do_235 = 0;
    for (aa_in_236 = 0 ; aa_in_236<=OrdersTotal() ; aa_in_236=aa_in_236 + 1)
     {
     if ( OrderSelect(aa_in_236,SELECT_BY_POS,MODE_TRADES)!=false && OrderSymbol()==aa_st_234 && OrderMagicNumber()==g_MagicNumber && OrderComment()==g_GroupName && OrderType()==0 )
      {
      aa_do_235 = aa_do_235 + OrderLots();
      }
     }
    if ( !OrderSend(g_Symbol2,OP_BUY,aa_do_233 - aa_do_235,aa_do_229,50,0,0,g_GroupName,g_MagicNumber,0,LimeGreen) )
     {
     PrintFormat("锁单B",GetLastError()); 
     }
    by_lo_149 = iTime(g_Symbol2,0,0) ;
    by_bo_165 = true ;
  }}}
 return(0); 
 }
double       CalcCorrelation(int bsw_0,int bsw_1,string bsw_2, string bsw_3)
{

double aa_do_5 = 0;
double aa_do_6 = 0;
double aa_do_7 = 0;
double aa_do_8 = 0;
double aa_do_9 = 0;
double aa_do_10 = 0;
double aa_do_11 = 0;
double aa_do_12 = 0;
int aa_in_13;
int aa_in_16;

 for (aa_in_13 = 0 ; aa_in_13<bsw_0 ; aa_in_13=aa_in_13 + 1)
  {
  aa_do_9 = aa_do_9 + iClose(bsw_3,bsw_1,aa_in_13);
  aa_do_10 = aa_do_10 + iClose(bsw_2,bsw_1,aa_in_13);
  }
 aa_do_11 = aa_do_9 / bsw_0;
 aa_do_12 = aa_do_10 / bsw_0;
 for (aa_in_16 = 0 ; aa_in_16<bsw_0 ; aa_in_16=aa_in_16 + 1)
  {
  aa_do_5 = (iClose(bsw_2,bsw_1,aa_in_16) - aa_do_12) * (iClose(bsw_3,bsw_1,aa_in_16) - aa_do_11) + aa_do_5;
  aa_do_6 = (iClose(bsw_3,bsw_1,aa_in_16) - aa_do_11) * (iClose(bsw_3,bsw_1,aa_in_16) - aa_do_11) + aa_do_6;
  aa_do_7 = (iClose(bsw_2,bsw_1,aa_in_16) - aa_do_12) * (iClose(bsw_2,bsw_1,aa_in_16) - aa_do_12) + aa_do_7;
  }
 if ( MathSqrt(aa_do_6) * MathSqrt(aa_do_7)!=0 )
  {
  aa_do_8 = aa_do_5 / (MathSqrt(aa_do_6) * MathSqrt(aa_do_7));
  }
  return(aa_do_8);
 }
