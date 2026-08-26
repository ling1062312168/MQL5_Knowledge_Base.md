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

// 自定义颜色常量 (hex 整数，MQL4 全版本兼容)
#define CLR_PANEL_BG     0x352525
#define CLR_CARD_BG      0x422D2D
#define CLR_FRAME        0x553A3A
#define CLR_BORDER       0x5A3E3E
#define CLR_SIG_BG       0x3E2A2A
#define CLR_INACTIVE_BG  0x4A3535
#define CLR_INNER_BAND   0x775555
#define CLR_ALT_ROW      0x402828
#define CLR_HEADER_BG     0x452F2F
#define CLR_TOTAL_ROW    0x5A3A3A
#define CLR_SIDE_BUY      0x32CD32
#define CLR_SIDE_SELL     0x3232FF
#define CLR_SIDE_CORR     0x00D7FF
#define CLR_TEXT_DIM      0x808080
#define CLR_TEXT_META     0xDEC4B0
#define CLR_TEXT_WARN     0x00D7FF
#define CLR_TEXT_PROFIT   0x32CD32
#define CLR_TEXT_LOSS     0x3232FF
#define CLR_CARD_BORDER   0x6A4A4A
#define CLR_ALT_ROW2      0x382525

// 辅助：创建/刷新 OBJ_LABEL。MQL4 无 OBJPROP_ANCHOR，anchor 参数用于模拟右对齐（扣减字符宽度）
void SetLabel(string id,string text,int fsize=9,string fname="Arial Bold",color clr=White,int corner=0,int x=0,int y=0,int anchor=0) {
   int actualX=x, tw=0;
   if ( anchor>=6 ) {
      tw=StringLen(text)*(fsize+1);
      actualX=x-tw;
   }
   if ( ObjectFind(id) < 0 ) {
      ObjectCreate(id,OBJ_LABEL,0,0,0,0,0,0,0);
      ObjectSet(id,OBJPROP_CORNER,corner);
   }
   ObjectSet(id,OBJPROP_XDISTANCE,actualX);
   ObjectSet(id,OBJPROP_YDISTANCE,y);
   ObjectSetText(id,text,fsize,fname,clr);
}
// 辅助：创建/刷新 OBJ_RECTANGLE_LABEL 背景板
void SetRect(string id,int x,int y,int w,int h,int corner=0,color bg=DarkSlateGray,color brd=Gray,int borderType=1) {
   if ( ObjectFind(id) < 0 ) {
      ObjectCreate(id,OBJ_RECTANGLE_LABEL,0,0,0,0,0,0,0);
      ObjectSet(id,OBJPROP_CORNER,corner);
      ObjectSet(id,OBJPROP_XDISTANCE,x);
      ObjectSet(id,OBJPROP_YDISTANCE,y);
      ObjectSet(id,OBJPROP_XSIZE,w);
      ObjectSet(id,OBJPROP_YSIZE,h);
      ObjectSet(id,OBJPROP_COLOR,brd);
      ObjectSet(id,OBJPROP_BGCOLOR,bg);
      ObjectSet(id,OBJPROP_BORDER_TYPE,borderType);
   }
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
   // Step 1 & 2：首次初始化 + 每组一次缓存刷新（后续模块只读缓存）
   EnsurePanelObjects();
   RefreshGroupCache();

 int         dfz_in_1=0;
 color       dfz_ui_2    =clrNONE;
 color       dfz_ui_3    =clrNONE;
 string      dfz_st_4;
 string      dfz_st_5;
 string      dfz_st_6;
 string      dfz_st_7;

 double     aa_do_169;
 string     aa_st_205;
 string     aa_st_207;
 string     aa_st_206;
 string     aa_st_208;
 string     aa_st_210;
 string     aa_st_209;
 string     aa_st_211;
 string     aa_st_213;
 string     aa_st_212;
 string     aa_st_215;
 string     aa_st_217;
 string     aa_st_218;
 string     aa_st_219;
 string     aa_st_221;
 string     aa_st_220;
 string     aa_st_222;
 string     aa_st_223;
 string     aa_st_224;
 string     aa_st_225;
 string     aa_st_227;
 string     aa_st_228;
 string     aa_st_230;
 string     aa_st_233;
 string     aa_st_234;
 string     aa_st_235;
 string     aa_st_238;
 string     aa_st_239;
 string     aa_st_240;
 string     aa_st_242;
 string     aa_st_241;
 string     aa_st_243;
 string     aa_st_246;
 string     aa_st_245;
 string     aa_st_247;
 string     aa_st_249;
 string     aa_st_248;
 string     aa_st_250;
 string     aa_st_252;
 string     aa_st_251;
 string     aa_st_253;
 string     aa_st_255;
 string     aa_st_254;
 string     aa_st_256;
 string     aa_st_258;
 string     aa_st_257;
 string     aa_st_263;
 string     aa_st_264;
 string     aa_st_265;
 string     aa_st_269;
 string     aa_st_270;
 string     aa_st_271;
 string     aa_st_275;
 string     aa_st_276;
 string     aa_st_277;
 string     aa_st_281;
 string     aa_st_282;
 string     aa_st_283;
 string     aa_st_287;
 string     aa_st_288;
 string     aa_st_289;
 string     aa_st_293;
 string     aa_st_294;
 string     aa_st_295;
 string     aa_st_299;
 string     aa_st_300;
 string     aa_st_301;
 string     aa_st_305;
 string     aa_st_306;
 string     aa_st_307;
 string     aa_st_311;
 string     aa_st_312;
 string     aa_st_313;
 string     aa_st_317;
 string     aa_st_318;
 string     aa_st_319;
 string     aa_st_323;
 string     aa_st_324;
 string     aa_st_325;
 string     aa_st_329;
 string     aa_st_330;
 string     aa_st_331;
 string     aa_st_335;
 string     aa_st_336;
 string     aa_st_337;
 string     aa_st_341;
 string     aa_st_342;
 string     aa_st_343;
 string     aa_st_347;
 string     aa_st_348;
 string     aa_st_349;
 string     aa_st_353;
 string     aa_st_354;
 string     aa_st_355;
 string     aa_st_359;
 string     aa_st_360;
 string     aa_st_361;
 string     aa_st_365;
 string     aa_st_366;
 string     aa_st_367;
 string     aa_st_371;
 string     aa_st_372;
 string     aa_st_373;
 string     aa_st_377;
 string     aa_st_378;
 string     aa_st_379;
 string     aa_st_383;
 string     aa_st_384;
 string     aa_st_385;
 string     aa_st_389;
 string     aa_st_390;
 string     aa_st_391;
 string     aa_st_395;
 string     aa_st_396;
 string     aa_st_397;
 string     aa_st_401;
 string     aa_st_402;
 string     aa_st_403;
 string     aa_st_407;
 string     aa_st_408;
 string     aa_st_409;
 string     aa_st_413;
 string     aa_st_414;
 string     aa_st_415;
 string     aa_st_419;
 string     aa_st_420;
 string     aa_st_421;
 string     aa_st_425;
 string     aa_st_426;
 string     aa_st_427;
 string     aa_st_431;
 string     aa_st_432;
 string     aa_st_433;
 string     aa_st_437;
 string     aa_st_438;
 string     aa_st_439;
 string     aa_st_443;
 string     aa_st_444;
 string     aa_st_445;
 string     aa_st_449;
 string     aa_st_450;
 string     aa_st_451;

 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 ObjectCreate("10021",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10021",Symbol(),16,"Arial Bold",Red); 
 ObjectSet("10021",OBJPROP_CORNER,1); 
 ObjectSet("10021",OBJPROP_XDISTANCE,80); 
 ObjectSet("10021",OBJPROP_YDISTANCE,15); 
 ObjectCreate("10022",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10022","------------------------------------------",9,"Arial Bold",White); 
 ObjectSet("10022",OBJPROP_CORNER,1); 
 ObjectSet("10022",OBJPROP_XDISTANCE,25); 
 ObjectSet("10022",OBJPROP_YDISTANCE,29); 
 ObjectCreate("10050",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10050","挂单对冲系列",8,"Arial Bold",Gold); 
 ObjectSet("10050",OBJPROP_CORNER,1); 
 ObjectSet("10050",OBJPROP_XDISTANCE,50); 
 ObjectSet("10050",OBJPROP_YDISTANCE,39); 
 ObjectCreate("10023",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10023","------------------------------------------",9,"Arial Bold",White); 
 ObjectSet("10023",OBJPROP_CORNER,1); 
 ObjectSet("10023",OBJPROP_XDISTANCE,25); 
 ObjectSet("10023",OBJPROP_YDISTANCE,45); 
 ObjectCreate("10024",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10024",StringConcatenate(Year(),"年",Month(),"月",Day(),"日",TimeToString(TimeCurrent(),TIME_MINUTES)),13,"Arial Bold",Red); 
 ObjectSet("10024",OBJPROP_CORNER,1); 
 ObjectSet("10024",OBJPROP_XDISTANCE,36); 
 ObjectSet("10024",OBJPROP_YDISTANCE,55); 
 ObjectCreate("10025",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10025","------------------------------------------",9,"Arial Bold",White); 
 ObjectSet("10025",OBJPROP_CORNER,1); 
 ObjectSet("10025",OBJPROP_XDISTANCE,25); 
 ObjectSet("10025",OBJPROP_YDISTANCE,62); 
 ObjectCreate("10026",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10026","【组·监控】",14,"Arial Bold",LightSteelBlue); 
 ObjectSet("10026",OBJPROP_CORNER,1); 
 ObjectSet("10026",OBJPROP_XDISTANCE,55); 
 ObjectSet("10026",OBJPROP_YDISTANCE,21); 
 ObjectCreate("10027",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10027","【信号·活跃】",14,"Arial Bold",Red); 
 ObjectSet("10027",OBJPROP_CORNER,1); 
 ObjectSet("10027",OBJPROP_XDISTANCE,-5); 
 ObjectSet("10027",OBJPROP_YDISTANCE,13); 
 ObjectCreate("10028",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10028","------------------------------------------",9,"Arial Bold",White); 
 ObjectSet("10028",OBJPROP_CORNER,1); 
 ObjectSet("10028",OBJPROP_XDISTANCE,25); 
 ObjectSet("10028",OBJPROP_YDISTANCE,115); 
 ObjectCreate("10029",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10029","● R",10,"Arial Bold",Red); 
 ObjectSet("10029",OBJPROP_CORNER,1); 
 ObjectSet("10029",OBJPROP_XDISTANCE,25); 
 ObjectSet("10029",OBJPROP_YDISTANCE,113); 
 ObjectCreate("10030",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10030","● R",10,"Arial Bold",Red); 
 ObjectSet("10030",OBJPROP_CORNER,1); 
 ObjectSet("10030",OBJPROP_XDISTANCE,60); 
 ObjectSet("10030",OBJPROP_YDISTANCE,113); 
 ObjectCreate("10031",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10031","● G",10,"Arial Bold",SpringGreen); 
 ObjectSet("10031",OBJPROP_CORNER,1); 
 ObjectSet("10031",OBJPROP_XDISTANCE,110); 
 ObjectSet("10031",OBJPROP_YDISTANCE,113); 
 ObjectCreate("10032",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10032","● G",10,"Arial Bold",SpringGreen); 
 ObjectSet("10032",OBJPROP_CORNER,1); 
 ObjectSet("10032",OBJPROP_XDISTANCE,145); 
 ObjectSet("10032",OBJPROP_YDISTANCE,113); 
 ObjectCreate("10033",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10033","● B",10,"Arial Bold",LightBlue); 
 ObjectSet("10033",OBJPROP_CORNER,1); 
 ObjectSet("10033",OBJPROP_XDISTANCE,25); 
 ObjectSet("10033",OBJPROP_YDISTANCE,158); 
 ObjectCreate("10034",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10034","● B",10,"Arial Bold",LightBlue); 
 ObjectSet("10034",OBJPROP_CORNER,1); 
 ObjectSet("10034",OBJPROP_XDISTANCE,60); 
 ObjectSet("10034",OBJPROP_YDISTANCE,158); 
 ObjectCreate("10035",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10035","● ○",10,"Arial Bold",LightSteelBlue); 
 ObjectSet("10035",OBJPROP_CORNER,1); 
 ObjectSet("10035",OBJPROP_XDISTANCE,110); 
 ObjectSet("10035",OBJPROP_YDISTANCE,158); 
 ObjectCreate("10036",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10036","● ○",10,"Arial Bold",LightSteelBlue); 
 ObjectSet("10036",OBJPROP_CORNER,1); 
 ObjectSet("10036",OBJPROP_XDISTANCE,145); 
 ObjectSet("10036",OBJPROP_YDISTANCE,158); 
 ObjectCreate("10037",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10037","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10037",OBJPROP_CORNER,1); 
 ObjectSet("10037",OBJPROP_XDISTANCE,25); 
 ObjectSet("10037",OBJPROP_YDISTANCE,203); 
 ObjectCreate("10038",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10038","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10038",OBJPROP_CORNER,1); 
 ObjectSet("10038",OBJPROP_XDISTANCE,50); 
 ObjectSet("10038",OBJPROP_YDISTANCE,203); 
 ObjectCreate("10039",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10039","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10039",OBJPROP_CORNER,1); 
 ObjectSet("10039",OBJPROP_XDISTANCE,75); 
 ObjectSet("10039",OBJPROP_YDISTANCE,203); 
 ObjectCreate("10040",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10040","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10040",OBJPROP_CORNER,1); 
 ObjectSet("10040",OBJPROP_XDISTANCE,100); 
 ObjectSet("10040",OBJPROP_YDISTANCE,203); 
 ObjectCreate("10041",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10041","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10041",OBJPROP_CORNER,1); 
 ObjectSet("10041",OBJPROP_XDISTANCE,125); 
 ObjectSet("10041",OBJPROP_YDISTANCE,203); 
 ObjectCreate("10042",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10042","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10042",OBJPROP_CORNER,1); 
 ObjectSet("10042",OBJPROP_XDISTANCE,150); 
 ObjectSet("10042",OBJPROP_YDISTANCE,203); 
 ObjectCreate("10043",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10043","-----------------------------------------",9,"Arial Bold",White); 
 ObjectSet("10043",OBJPROP_CORNER,1); 
 ObjectSet("10043",OBJPROP_XDISTANCE,25); 
 ObjectSet("10043",OBJPROP_YDISTANCE,206); 
 ObjectCreate("10044",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10044","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10044",OBJPROP_CORNER,1); 
 ObjectSet("10044",OBJPROP_XDISTANCE,25); 
 ObjectSet("10044",OBJPROP_YDISTANCE,239); 
 ObjectCreate("10045",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10045","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10045",OBJPROP_CORNER,1); 
 ObjectSet("10045",OBJPROP_XDISTANCE,50); 
 ObjectSet("10045",OBJPROP_YDISTANCE,239); 
 ObjectCreate("10046",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10046","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10046",OBJPROP_CORNER,1); 
 ObjectSet("10046",OBJPROP_XDISTANCE,75); 
 ObjectSet("10046",OBJPROP_YDISTANCE,239); 
 ObjectCreate("10047",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10047","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10047",OBJPROP_CORNER,1); 
 ObjectSet("10047",OBJPROP_XDISTANCE,100); 
 ObjectSet("10047",OBJPROP_YDISTANCE,239); 
 ObjectCreate("10048",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10048","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10048",OBJPROP_CORNER,1); 
 ObjectSet("10048",OBJPROP_XDISTANCE,125); 
 ObjectSet("10048",OBJPROP_YDISTANCE,239); 
 ObjectCreate("10049",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10049","●",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10049",OBJPROP_CORNER,1); 
 ObjectSet("10049",OBJPROP_XDISTANCE,150); 
 ObjectSet("10049",OBJPROP_YDISTANCE,239); 
 ObjectCreate("10051",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10051","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10051",OBJPROP_CORNER,1); 
 ObjectSet("10051",OBJPROP_XDISTANCE,25); 
 ObjectSet("10051",OBJPROP_YDISTANCE,281); 
 ObjectCreate("10052",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10052","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10052",OBJPROP_CORNER,1); 
 ObjectSet("10052",OBJPROP_XDISTANCE,40); 
 ObjectSet("10052",OBJPROP_YDISTANCE,281); 
 ObjectCreate("10053",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10053","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10053",OBJPROP_CORNER,1); 
 ObjectSet("10053",OBJPROP_XDISTANCE,55); 
 ObjectSet("10053",OBJPROP_YDISTANCE,281); 
 ObjectCreate("10054",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10054","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10054",OBJPROP_CORNER,1); 
 ObjectSet("10054",OBJPROP_XDISTANCE,70); 
 ObjectSet("10054",OBJPROP_YDISTANCE,281); 
 ObjectCreate("10055",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10055","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10055",OBJPROP_CORNER,1); 
 ObjectSet("10055",OBJPROP_XDISTANCE,85); 
 ObjectSet("10055",OBJPROP_YDISTANCE,281); 
 ObjectCreate("10056",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10056","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10056",OBJPROP_CORNER,1); 
 ObjectSet("10056",OBJPROP_XDISTANCE,100); 
 ObjectSet("10056",OBJPROP_YDISTANCE,281); 
 ObjectCreate("10057",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10057","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10057",OBJPROP_CORNER,1); 
 ObjectSet("10057",OBJPROP_XDISTANCE,115); 
 ObjectSet("10057",OBJPROP_YDISTANCE,281); 
 ObjectCreate("10059",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10059","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10059",OBJPROP_CORNER,1); 
 ObjectSet("10059",OBJPROP_XDISTANCE,130); 
 ObjectSet("10059",OBJPROP_YDISTANCE,281); 
 ObjectCreate("10060",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10060","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10060",OBJPROP_CORNER,1); 
 ObjectSet("10060",OBJPROP_XDISTANCE,145); 
 ObjectSet("10060",OBJPROP_YDISTANCE,281); 
 ObjectCreate("10063",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10063","·",9,"Arial Bold",LightSteelBlue); 
 ObjectSet("10063",OBJPROP_CORNER,1); 
 ObjectSet("10063",OBJPROP_XDISTANCE,164); 
 ObjectSet("10063",OBJPROP_YDISTANCE,282); 
 ObjectCreate("10064",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10064","------------------------------------------",10,"Arial Bold",White); 
 ObjectSet("10064",OBJPROP_CORNER,1); 
 ObjectSet("10064",OBJPROP_XDISTANCE,25); 
 ObjectSet("10064",OBJPROP_YDISTANCE,304); 
 ObjectCreate("10065",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10065","对冲(02)",18,"Arial Bold",Gold); 
 ObjectSet("10065",OBJPROP_CORNER,1); 
 ObjectSet("10065",OBJPROP_XDISTANCE,40); 
 ObjectSet("10065",OBJPROP_YDISTANCE,312); 
 ObjectCreate("10066",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10066","------------------------------------------",10,"Arial Bold",White); 
 ObjectSet("10066",OBJPROP_CORNER,1); 
 ObjectSet("10066",OBJPROP_XDISTANCE,25); 
 ObjectSet("10066",OBJPROP_YDISTANCE,330); 
 ObjectCreate("10067",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10067","HOLYGRAIL EA",10,"Arial Bold",LightSteelBlue); 
 ObjectSet("10067",OBJPROP_CORNER,1); 
 ObjectSet("10067",OBJPROP_XDISTANCE,75); 
 ObjectSet("10067",OBJPROP_YDISTANCE,340); 
 ObjectCreate("10068",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10068","------------------------------------------",10,"Arial Bold",White); 
 ObjectSet("10068",OBJPROP_CORNER,1); 
 ObjectSet("10068",OBJPROP_XDISTANCE,25); 
 ObjectSet("10068",OBJPROP_YDISTANCE,345); 
 ObjectCreate("10069",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10069","适合所有货币对",10,"Arial Bold",LightSteelBlue); 
 ObjectSet("10069",OBJPROP_CORNER,1); 
 ObjectSet("10069",OBJPROP_XDISTANCE,70); 
 ObjectSet("10069",OBJPROP_YDISTANCE,360); 
 ObjectCreate("10070",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10070","------------------------------------------",10,"Arial Bold",White); 
 ObjectSet("10070",OBJPROP_CORNER,1); 
 ObjectSet("10070",OBJPROP_XDISTANCE,25); 
 ObjectSet("10070",OBJPROP_YDISTANCE,365); 
 ObjectCreate("10071",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10071","同时下注32货币对",10,"Arial Bold",LightSteelBlue); 
 ObjectSet("10071",OBJPROP_CORNER,1); 
 ObjectSet("10071",OBJPROP_XDISTANCE,55); 
 ObjectSet("10071",OBJPROP_YDISTANCE,380); 
 ObjectCreate("10072",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10072","------------------------------------------",10,"Arial Bold",White); 
 ObjectSet("10072",OBJPROP_CORNER,1); 
 ObjectSet("10072",OBJPROP_XDISTANCE,25); 
 ObjectSet("10072",OBJPROP_YDISTANCE,385); 
 ObjectCreate("10073",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10073",StringConcatenate("G.SELL(",DoubleToString(by_do_246,2),")"),8,"Arial Bold",0); 
 ObjectSet("10073",OBJPROP_CORNER,1); 
 ObjectSet("10073",OBJPROP_XDISTANCE,45); 
 ObjectSet("10073",OBJPROP_YDISTANCE,76); 
 ObjectCreate("10074",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10074",DoubleToString(by_do_190,0),11,"Arial Bold",0); 
 ObjectSet("10074",OBJPROP_CORNER,1); 
 ObjectSet("10074",OBJPROP_XDISTANCE,76); 
 ObjectSet("10074",OBJPROP_YDISTANCE,95); 
 ObjectCreate("10075",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10075",StringConcatenate("G.BUY(",DoubleToString(by_do_247,2),")"),8,"Arial Bold",0); 
 ObjectSet("10075",OBJPROP_CORNER,1); 
 ObjectSet("10075",OBJPROP_XDISTANCE,110); 
 ObjectSet("10075",OBJPROP_YDISTANCE,106); 
 ObjectCreate("10076",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10076",DoubleToString(by_do_189,0),11,"Arial Bold",0); 
 ObjectSet("10076",OBJPROP_CORNER,1); 
 ObjectSet("10076",OBJPROP_XDISTANCE,134); 
 ObjectSet("10076",OBJPROP_YDISTANCE,90); 
 aa_do_169 = by_do_226 + by_do_227;
if (by_do_226 + by_do_227>0)  
 {
 by_do_264 = aa_do_169 ;
 by_do_265 = 0 ;
 }
 else
 {
 by_do_265 = by_do_226 + by_do_227 ;
 by_do_264 = 0 ;
 }
 ObjectCreate("10077",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10077","G.LOSS",9,"Arial Bold",0); 
 ObjectSet("10077",OBJPROP_CORNER,1); 
 ObjectSet("10077",OBJPROP_XDISTANCE,56); 
 ObjectSet("10077",OBJPROP_YDISTANCE,153); 
 ObjectCreate("10078",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10078",DoubleToString(by_do_265,1),12,"Arial Bold",0); 
 ObjectSet("10078",OBJPROP_CORNER,1); 
 ObjectSet("10078",OBJPROP_XDISTANCE,48); 
 ObjectSet("10078",OBJPROP_YDISTANCE,138); 
 ObjectCreate("10079",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10079","G.PROFIT",9,"Arial Bold",0); 
 ObjectSet("10079",OBJPROP_CORNER,1); 
 ObjectSet("10079",OBJPROP_XDISTANCE,125); 
 ObjectSet("10079",OBJPROP_YDISTANCE,153); 
 ObjectCreate("10080",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10080",DoubleToString(by_do_264,1),12,"Arial Bold",0); 
 ObjectSet("10080",OBJPROP_CORNER,1); 
 ObjectSet("10080",OBJPROP_XDISTANCE,131); 
 ObjectSet("10080",OBJPROP_YDISTANCE,138); 
 ObjectCreate("10081",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10081","G.MAGIC",9,"Arial Bold",0); 
 ObjectSet("10081",OBJPROP_CORNER,1); 
 ObjectSet("10081",OBJPROP_XDISTANCE,51); 
 ObjectSet("10081",OBJPROP_YDISTANCE,200); 
 ObjectCreate("10082",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10082",DoubleToString(g_MagicNumber,0),12,"Arial Bold",0); 
 ObjectSet("10082",OBJPROP_CORNER,1); 
 ObjectSet("10082",OBJPROP_XDISTANCE,48); 
 ObjectSet("10082",OBJPROP_YDISTANCE,180); 
 ObjectCreate("10083",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10083","G.RUNING",9,"Arial Bold",0); 
 ObjectSet("10083",OBJPROP_CORNER,1); 
 ObjectSet("10083",OBJPROP_XDISTANCE,126); 
 ObjectSet("10083",OBJPROP_YDISTANCE,200); 
 ObjectCreate("10084",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10084",DoubleToString(by_in_169,0),12,"Arial Bold",0); 
 ObjectSet("10084",OBJPROP_CORNER,1); 
 ObjectSet("10084",OBJPROP_XDISTANCE,128); 
 ObjectSet("10084",OBJPROP_YDISTANCE,180); 
 ObjectCreate("10085",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10085",DoubleToString(AccountBalance(),2),20,"Arial Bold",0); 
 ObjectSet("10085",OBJPROP_CORNER,1); 
 ObjectSet("10085",OBJPROP_XDISTANCE,60); 
 ObjectSet("10085",OBJPROP_YDISTANCE,225); 
 ObjectCreate("10086",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10086",DoubleToString(AccountEquity(),2),20,"Arial Bold",0); 
 ObjectSet("10086",OBJPROP_CORNER,1); 
 ObjectSet("10086",OBJPROP_XDISTANCE,60); 
 ObjectSet("10086",OBJPROP_YDISTANCE,260); 
 ObjectCreate("10087",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10087","多货币对冲",14,"Regular script",0); 
 ObjectSet("10087",OBJPROP_CORNER,1); 
 ObjectSet("10087",OBJPROP_XDISTANCE,36); 
 ObjectSet("10087",OBJPROP_YDISTANCE,293); 
 if ( OrdersTotal()!=0 )
  {
  dfz_ui_2 = Chocolate ;
  }
 else
  {
  dfz_ui_2 = White ;
  }
 if ( by_lo_151 != Day() )
  {
  by_in_115=by_in_115 + 1;
  by_lo_151 = Day() ;
  }
 aa_st_205 = "Regular script";
 aa_st_207 = "EA名称 :: " + WindowExpertName() + "\n";
 aa_st_206 = "10088";
 if ( dfz_in_1 != -1 )
  { 
  ObjectCreate(aa_st_206,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_206,aa_st_207,9,"Arial Bold",White); 
  ObjectSet(aa_st_206,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_206,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_206,OBJPROP_YDISTANCE,95); 
  }
 aa_st_208 = "Regular script";
 aa_st_210 = "当前品种行情:: " + Symbol() + "//ASK=" + DoubleToString(Ask,5) + "//BID=" + DoubleToString(Bid,5);
 aa_st_209 = "10089";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_209,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_209,aa_st_210,10,aa_st_208,White); 
  ObjectSet(aa_st_209,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_209,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_209,OBJPROP_YDISTANCE,110); 
  }
 aa_st_211 = "Regular script";
 aa_st_213 = "累计运行天数:: D" + DoubleToString(by_in_115,0) + "," + StringConcatenate("K线周期:",Period()) + "," + "星期:" + "W" + DoubleToString(DayOfWeek(),0) + "";
 aa_st_212 = "10090";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_212,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_212,aa_st_213,10,aa_st_211,White); 
  ObjectSet(aa_st_212,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_212,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_212,OBJPROP_YDISTANCE,125); 
  }
 by_st_275 = Symbol() ;
 CalcSpreadSignal(); 
 if ( by_in_166==1 )
  {
  by_st_255 = "   多头信号  上下上    " + DoubleToString((Close[0] - by_do_96) / Point(),0) + " P   只多不空" ;
  }
 if ( by_in_166==2 )
  {
  by_st_255 = "   空头信号  下上下    " + DoubleToString((by_do_96 - Close[0]) / Point(),0) + " P   只空不多" ;
  }
 if ( by_in_166==0 )
  {
  by_st_255 = "   无方向  ——  等待" ;
  }
 aa_st_215 = "Regular script";
 aa_st_217 = StringConcatenate("交易信号:: ",WindowExpertName() + by_st_255);
 aa_st_218 = "10091";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_218,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_218,aa_st_217,10,aa_st_215,DarkKhaki); 
  ObjectSet(aa_st_218,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_218,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_218,OBJPROP_YDISTANCE,140); 
  }
 aa_st_219 = "Regular script";
 aa_st_221 = "累计开仓手数:: " + DoubleToString(by_do_237,2) + "  " + "总订单上限::" + DoubleToString(OrdersTotal(),0) + "//" + DoubleToString(AccountInfoInteger(47),0);
 aa_st_220 = "10092";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_220,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_220,aa_st_221,10,aa_st_219,dfz_ui_2); 
  ObjectSet(aa_st_220,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_220,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_220,OBJPROP_YDISTANCE,155); 
  }
 aa_st_222 = "Regular script";
 aa_st_223=DoubleToString(by_do_241,2) + "USD \n"; 
 aa_st_224=DoubleToString( -by_do_240,2) + "+"; 
 aa_st_225=DoubleToString(by_do_237,2) + "//历史手续费:: "; 
 g_BaseLot = lot ;
 aa_st_227 = StringConcatenate("基础手数(lot)::",DoubleToString(lot,2)," 实开手数和:: ",aa_st_225,aa_st_224,aa_st_223);
 aa_st_228 = "10093";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_228,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_228,aa_st_227,10,aa_st_222,dfz_ui_2); 
  ObjectSet(aa_st_228,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_228,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_228,OBJPROP_YDISTANCE,170); 
  }
 aa_do_169 = by_do_226 + by_do_227;
 if ( by_do_226 + by_do_227<0 )
  {
  by_do_250 = ( -aa_do_169) / AccountEquity() * 100 ;
  }
 else
  {
  by_do_250 = 0 ;
  }
 aa_st_230 = "Regular script";
 aa_st_233 = StringConcatenate("仓位风险率:: ",DoubleToString(by_do_198 / (AccountEquity() * 0.1 / MarketInfo(Symbol(),32)) * 100,2),"%   ","浮亏回撤率::",DoubleToString(by_do_250,2) + "%");
 aa_st_234 = "10094";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_234,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_234,aa_st_233,10,aa_st_230,dfz_ui_2); 
  ObjectSet(aa_st_234,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_234,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_234,OBJPROP_YDISTANCE,185); 
  }
 aa_st_235 = "Regular script";
 aa_st_238 = StringConcatenate("累计占用保证金:: ",DoubleToString(by_do_237 + by_do_238,2),"//历史保证金:: ",DoubleToString(by_do_238,2));
 aa_st_239 = "10095";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_239,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_239,aa_st_238,10,aa_st_235,dfz_ui_2); 
  ObjectSet(aa_st_239,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_239,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_239,OBJPROP_YDISTANCE,200); 
  }
 aa_st_240 = "Regular script";
 aa_st_242 = "历史平仓盈亏::" + DoubleToString(by_do_239,2) + "//账户余额::" + DoubleToString(AccountBalance(),2) + "//账户净值::" + DoubleToString(AccountEquity(),2);
 aa_st_241 = "10096";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_241,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_241,aa_st_242,10,aa_st_240,dfz_ui_2); 
  ObjectSet(aa_st_241,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_241,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_241,OBJPROP_YDISTANCE,215); 
  }
 if ( by_in_182==1 )
  {
  by_in_123 = by_in_182 ;
  }
 if ( by_in_182>1 )
  {
  by_in_123=by_in_182 / 4 + 1;
  }
 aa_st_243 = "Regular script";
 aa_st_246 = StringConcatenate("网格分布:: 总层数=",DoubleToString(by_do_286,0),",上方挂单：",by_do_287,",下方挂单：",by_do_288) + "   活跃网格组数: " + DoubleToString(by_in_123,0);
 aa_st_245 = "10097";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_245,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_245,aa_st_246,10,aa_st_243,dfz_ui_2); 
  ObjectSet(aa_st_245,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_245,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_245,OBJPROP_YDISTANCE,230); 
  }
 aa_st_247 = "Regular script";
 aa_st_249 = "预期盈亏目标::" + DoubleToString((by_do_190 + by_do_189 + 1) * by_do_225 * 100,2) + "USD  " + "已解锁货币对:: " + DoubleToString(by_in_90,0);
 aa_st_248 = "124689";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_248,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_248,aa_st_249,10,aa_st_247,White); 
  ObjectSet(aa_st_248,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_248,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_248,OBJPROP_YDISTANCE,245); 
  }
 aa_st_250 = "Regular script";
 aa_st_252 = "最大单笔浮亏::" + DoubleToString( -by_do_248,2) + "USD" + " 最大单笔浮盈::" + DoubleToString(by_do_249,2) + "USD";
 aa_st_251 = "124699";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_251,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_251,aa_st_252,10,aa_st_250,White); 
  ObjectSet(aa_st_251,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_251,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_251,OBJPROP_YDISTANCE,260); 
  }
 aa_st_253 = "Regular script";
 aa_st_255 = "经纪商:: " + AccountCompany();
 aa_st_254 = "1245";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_254,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_254,aa_st_255,10,aa_st_253,White); 
  ObjectSet(aa_st_254,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_254,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_254,OBJPROP_YDISTANCE,275); 
  }
 aa_st_256 = "Regular script";
aa_st_258 = "交易账号:: " + DoubleToString(AccountNumber(),0);
 aa_st_257 = "124687";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_257,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_257,aa_st_258,10,aa_st_256,White); 
  ObjectSet(aa_st_257,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_257,OBJPROP_XDISTANCE,77); 
  ObjectSet(aa_st_257,OBJPROP_YDISTANCE,290); 
  }
 dfz_st_5 = "启动自我关闭" ;
 dfz_st_6 = "" ;
 dfz_st_7 = "" ;
 by_st_275 = H01Symbol ;
 g_GroupName = "第1组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_8==true )
  {
  dfz_ui_3 = Gold ;
  }
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 ObjectCreate("10122",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10122","(01)" + H01Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10122",OBJPROP_CORNER,0); 
 ObjectSet("10122",OBJPROP_XDISTANCE,498); 
 ObjectSet("10122",OBJPROP_YDISTANCE,95); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_263 = "Regular script";
 aa_st_264 = dfz_st_4;
 aa_st_265 = "10123";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_265,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_265,aa_st_264,9,aa_st_263,dfz_ui_3); 
  ObjectSet(aa_st_265,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_265,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_265,OBJPROP_YDISTANCE,95); 
  }
 by_st_275 = H02Symbol ;
 g_GroupName = "第1组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_9==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10124",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10124","(01)" + H02Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10124",OBJPROP_CORNER,0); 
 ObjectSet("10124",OBJPROP_XDISTANCE,498); 
 ObjectSet("10124",OBJPROP_YDISTANCE,105); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_269 = "Regular script";
 aa_st_270 = dfz_st_4;
 aa_st_271 = "10125";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_271,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_271,aa_st_270,9,aa_st_269,dfz_ui_3); 
  ObjectSet(aa_st_271,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_271,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_271,OBJPROP_YDISTANCE,105); 
  }
 by_st_275 = H03Symbol ;
 g_GroupName = "第2组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_10==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10126",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10126","(02)" + H03Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10126",OBJPROP_CORNER,0); 
 ObjectSet("10126",OBJPROP_XDISTANCE,498); 
 ObjectSet("10126",OBJPROP_YDISTANCE,115); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_275 = "Regular script";
 aa_st_276 = dfz_st_4;
 aa_st_277 = "10127";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_277,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_277,aa_st_276,9,aa_st_275,dfz_ui_3); 
  ObjectSet(aa_st_277,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_277,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_277,OBJPROP_YDISTANCE,115); 
  }
 by_st_275 = H04Symbol ;
 g_GroupName = "第2组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_11==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10128",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10128","(02)" + H04Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10128",OBJPROP_CORNER,0); 
 ObjectSet("10128",OBJPROP_XDISTANCE,498); 
 ObjectSet("10128",OBJPROP_YDISTANCE,125); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_281 = "Regular script";
 aa_st_282 = dfz_st_4;
 aa_st_283 = "10129";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_283,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_283,aa_st_282,9,aa_st_281,dfz_ui_3); 
  ObjectSet(aa_st_283,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_283,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_283,OBJPROP_YDISTANCE,125); 
  }
 by_st_275 = H05Symbol ;
 g_GroupName = "第3组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_12==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10130",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10130","(03)" + H05Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10130",OBJPROP_CORNER,0); 
 ObjectSet("10130",OBJPROP_XDISTANCE,498); 
 ObjectSet("10130",OBJPROP_YDISTANCE,135); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_287 = "Regular script";
 aa_st_288 = dfz_st_4;
 aa_st_289 = "10131";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_289,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_289,aa_st_288,9,aa_st_287,dfz_ui_3); 
  ObjectSet(aa_st_289,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_289,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_289,OBJPROP_YDISTANCE,135); 
  }
 by_st_275 = H06Symbol ;
 g_GroupName = "第3组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_13==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10132",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10132","(03)" + H06Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10132",OBJPROP_CORNER,0); 
 ObjectSet("10132",OBJPROP_XDISTANCE,498); 
 ObjectSet("10132",OBJPROP_YDISTANCE,145); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_293 = "Regular script";
 aa_st_294 = dfz_st_4;
 aa_st_295 = "10133";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_295,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_295,aa_st_294,9,aa_st_293,dfz_ui_3); 
  ObjectSet(aa_st_295,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_295,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_295,OBJPROP_YDISTANCE,145); 
  }
 by_st_275 = H07Symbol ;
 g_GroupName = "第4组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_14==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10134",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10134","(04)" + H07Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10134",OBJPROP_CORNER,0); 
 ObjectSet("10134",OBJPROP_XDISTANCE,498); 
 ObjectSet("10134",OBJPROP_YDISTANCE,155); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_299 = "Regular script";
 aa_st_300 = dfz_st_4;
 aa_st_301 = "10135";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_301,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_301,aa_st_300,9,aa_st_299,dfz_ui_3); 
  ObjectSet(aa_st_301,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_301,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_301,OBJPROP_YDISTANCE,155); 
  }
 by_st_275 = H08Symbol ;
 g_GroupName = "第4组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_15==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10136",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10136","(04)" + H08Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10136",OBJPROP_CORNER,0); 
 ObjectSet("10136",OBJPROP_XDISTANCE,498); 
 ObjectSet("10136",OBJPROP_YDISTANCE,165); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_305 = "Regular script";
 aa_st_306 = dfz_st_4;
 aa_st_307 = "10137";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_307,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_307,aa_st_306,9,aa_st_305,dfz_ui_3); 
  ObjectSet(aa_st_307,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_307,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_307,OBJPROP_YDISTANCE,165); 
  }
 by_st_275 = H09Symbol ;
 g_GroupName = "第5组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_16==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10138",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10138","(05)" + H09Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10138",OBJPROP_CORNER,0); 
 ObjectSet("10138",OBJPROP_XDISTANCE,498); 
 ObjectSet("10138",OBJPROP_YDISTANCE,175); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_311 = "Regular script";
 aa_st_312 = dfz_st_4;
 aa_st_313 = "10139";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_313,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_313,aa_st_312,9,aa_st_311,dfz_ui_3); 
  ObjectSet(aa_st_313,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_313,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_313,OBJPROP_YDISTANCE,175); 
  }
 by_st_275 = H10Symbol ;
 g_GroupName = "第5组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_17==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10140",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10140","(05)" + H10Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10140",OBJPROP_CORNER,0); 
 ObjectSet("10140",OBJPROP_XDISTANCE,498); 
 ObjectSet("10140",OBJPROP_YDISTANCE,185); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_317 = "Regular script";
 aa_st_318 = dfz_st_4;
 aa_st_319 = "10141";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_319,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_319,aa_st_318,9,aa_st_317,dfz_ui_3); 
  ObjectSet(aa_st_319,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_319,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_319,OBJPROP_YDISTANCE,185); 
  }
 by_st_275 = H11Symbol ;
 g_GroupName = "第6组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_18==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10142",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10142","(06)" + H11Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10142",OBJPROP_CORNER,0); 
 ObjectSet("10142",OBJPROP_XDISTANCE,498); 
 ObjectSet("10142",OBJPROP_YDISTANCE,195); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_323 = "Regular script";
 aa_st_324 = dfz_st_4;
 aa_st_325 = "10143";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_325,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_325,aa_st_324,9,aa_st_323,dfz_ui_3); 
  ObjectSet(aa_st_325,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_325,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_325,OBJPROP_YDISTANCE,195); 
  }
 by_st_275 = H12Symbol ;
 g_GroupName = "第6组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_19==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10144",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10144","(06)" + H12Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10144",OBJPROP_CORNER,0); 
 ObjectSet("10144",OBJPROP_XDISTANCE,498); 
 ObjectSet("10144",OBJPROP_YDISTANCE,205); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_329 = "Regular script";
 aa_st_330 = dfz_st_4;
 aa_st_331 = "10145";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_331,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_331,aa_st_330,9,aa_st_329,dfz_ui_3); 
  ObjectSet(aa_st_331,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_331,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_331,OBJPROP_YDISTANCE,205); 
  }
 by_st_275 = H13Symbol ;
 g_GroupName = "第7组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_20==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10189",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10189","(07)" + H13Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10189",OBJPROP_CORNER,0); 
 ObjectSet("10189",OBJPROP_XDISTANCE,498); 
 ObjectSet("10189",OBJPROP_YDISTANCE,215); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_335 = "Regular script";
 aa_st_336 = dfz_st_4;
 aa_st_337 = "10146";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_337,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_337,aa_st_336,9,aa_st_335,dfz_ui_3); 
  ObjectSet(aa_st_337,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_337,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_337,OBJPROP_YDISTANCE,215); 
  }
 by_st_275 = H14Symbol ;
 g_GroupName = "第7组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_21==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10147",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10147","(07)" + H14Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10147",OBJPROP_CORNER,0); 
 ObjectSet("10147",OBJPROP_XDISTANCE,498); 
 ObjectSet("10147",OBJPROP_YDISTANCE,225); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_341 = "Regular script";
 aa_st_342 = dfz_st_4;
 aa_st_343 = "10148";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_343,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_343,aa_st_342,9,aa_st_341,dfz_ui_3); 
  ObjectSet(aa_st_343,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_343,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_343,OBJPROP_YDISTANCE,225); 
  }
 by_st_275 = H15Symbol ;
 g_GroupName = "第8组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 else
  {
  if ( by_bo_22==true )
   {
   dfz_ui_3 = Gold ;
  }}
 ObjectCreate("10149",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10149","(08)" + H15Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10149",OBJPROP_CORNER,0); 
 ObjectSet("10149",OBJPROP_XDISTANCE,498); 
 ObjectSet("10149",OBJPROP_YDISTANCE,235); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_347 = "Regular script";
 aa_st_348 = dfz_st_4;
 aa_st_349 = "10150";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_349,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_349,aa_st_348,9,aa_st_347,dfz_ui_3); 
  ObjectSet(aa_st_349,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_349,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_349,OBJPROP_YDISTANCE,235); 
  }
 by_st_275 = H16Symbol ;
 g_GroupName = "第8组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10151",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10151","(08)" + H16Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10151",OBJPROP_CORNER,0); 
 ObjectSet("10151",OBJPROP_XDISTANCE,498); 
 ObjectSet("10151",OBJPROP_YDISTANCE,245); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_353 = "Regular script";
 aa_st_354 = dfz_st_4;
 aa_st_355 = "10152";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_355,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_355,aa_st_354,9,aa_st_353,dfz_ui_3); 
  ObjectSet(aa_st_355,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_355,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_355,OBJPROP_YDISTANCE,245); 
  }
 by_st_275 = H17Symbol ;
 g_GroupName = "第9组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_22==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10153",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10153","(09)" + H17Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10153",OBJPROP_CORNER,0); 
 ObjectSet("10153",OBJPROP_XDISTANCE,498); 
 ObjectSet("10153",OBJPROP_YDISTANCE,255); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_359 = "Regular script";
 aa_st_360 = dfz_st_4;
 aa_st_361 = "10154";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_361,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_361,aa_st_360,9,aa_st_359,dfz_ui_3); 
  ObjectSet(aa_st_361,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_361,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_361,OBJPROP_YDISTANCE,255); 
  }
 by_st_275 = H18Symbol ;
 g_GroupName = "第9组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10155",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10155","(09)" + H18Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10155",OBJPROP_CORNER,0); 
 ObjectSet("10155",OBJPROP_XDISTANCE,498); 
 ObjectSet("10155",OBJPROP_YDISTANCE,265); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_365 = "Regular script";
 aa_st_366 = dfz_st_4;
 aa_st_367 = "10156";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_367,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_367,aa_st_366,9,aa_st_365,dfz_ui_3); 
  ObjectSet(aa_st_367,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_367,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_367,OBJPROP_YDISTANCE,265); 
  }
 by_st_275 = H19Symbol ;
 g_GroupName = "第10组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10157",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10157","(10)" + H19Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10157",OBJPROP_CORNER,0); 
 ObjectSet("10157",OBJPROP_XDISTANCE,498); 
 ObjectSet("10157",OBJPROP_YDISTANCE,275); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_371 = "Regular script";
 aa_st_372 = dfz_st_4;
 aa_st_373 = "10158";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_373,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_373,aa_st_372,9,aa_st_371,dfz_ui_3); 
  ObjectSet(aa_st_373,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_373,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_373,OBJPROP_YDISTANCE,275); 
  }
 by_st_275 = H20Symbol ;
 g_GroupName = "第10组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_22==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10159",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10159","(10)" + H20Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10159",OBJPROP_CORNER,0); 
 ObjectSet("10159",OBJPROP_XDISTANCE,498); 
 ObjectSet("10159",OBJPROP_YDISTANCE,285); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_377 = "Regular script";
 aa_st_378 = dfz_st_4;
 aa_st_379 = "10160";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_379,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_379,aa_st_378,9,aa_st_377,dfz_ui_3); 
  ObjectSet(aa_st_379,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_379,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_379,OBJPROP_YDISTANCE,285); 
  }
 by_st_275 = H21Symbol ;
 g_GroupName = "第11组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10161",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10161","(11)" + H21Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10161",OBJPROP_CORNER,0); 
 ObjectSet("10161",OBJPROP_XDISTANCE,498); 
 ObjectSet("10161",OBJPROP_YDISTANCE,295); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_383 = "Regular script";
 aa_st_384 = dfz_st_4;
 aa_st_385 = "10162";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_385,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_385,aa_st_384,9,aa_st_383,dfz_ui_3); 
  ObjectSet(aa_st_385,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_385,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_385,OBJPROP_YDISTANCE,295); 
  }
 by_st_275 = H22Symbol ;
 g_GroupName = "第11组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_22==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10163",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10163","(11)" + H22Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10163",OBJPROP_CORNER,0); 
 ObjectSet("10163",OBJPROP_XDISTANCE,498); 
 ObjectSet("10163",OBJPROP_YDISTANCE,305); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_389 = "Regular script";
 aa_st_390 = dfz_st_4;
 aa_st_391 = "10164";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_391,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_391,aa_st_390,9,aa_st_389,dfz_ui_3); 
  ObjectSet(aa_st_391,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_391,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_391,OBJPROP_YDISTANCE,305); 
  }
 by_st_275 = H23Symbol ;
 g_GroupName = "第12组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10165",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10165","(12)" + H23Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10165",OBJPROP_CORNER,0); 
 ObjectSet("10165",OBJPROP_XDISTANCE,498); 
 ObjectSet("10165",OBJPROP_YDISTANCE,315); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_395 = "Regular script";
 aa_st_396 = dfz_st_4;
 aa_st_397 = "10166";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_397,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_397,aa_st_396,9,aa_st_395,dfz_ui_3); 
  ObjectSet(aa_st_397,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_397,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_397,OBJPROP_YDISTANCE,315); 
  }
 by_st_275 = H24Symbol ;
 g_GroupName = "第12组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_22==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10167",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10167","(12)" + H24Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10167",OBJPROP_CORNER,0); 
 ObjectSet("10167",OBJPROP_XDISTANCE,498); 
 ObjectSet("10167",OBJPROP_YDISTANCE,325); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_401 = "Regular script";
 aa_st_402 = dfz_st_4;
 aa_st_403 = "10168";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_403,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_403,aa_st_402,9,aa_st_401,dfz_ui_3); 
  ObjectSet(aa_st_403,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_403,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_403,OBJPROP_YDISTANCE,325); 
  }
 by_st_275 = H25Symbol ;
 g_GroupName = "第13组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10169",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10169","(13)" + H25Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10169",OBJPROP_CORNER,0); 
 ObjectSet("10169",OBJPROP_XDISTANCE,498); 
 ObjectSet("10169",OBJPROP_YDISTANCE,335); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_407 = "Regular script";
 aa_st_408 = dfz_st_4;
 aa_st_409 = "10170";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_409,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_409,aa_st_408,9,aa_st_407,dfz_ui_3); 
  ObjectSet(aa_st_409,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_409,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_409,OBJPROP_YDISTANCE,335); 
  }
 by_st_275 = H26Symbol ;
 g_GroupName = "第13组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_22==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10171",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10171","(13)" + H26Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10171",OBJPROP_CORNER,0); 
 ObjectSet("10171",OBJPROP_XDISTANCE,498); 
 ObjectSet("10171",OBJPROP_YDISTANCE,345); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_413 = "Regular script";
 aa_st_414 = dfz_st_4;
 aa_st_415 = "10172";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_415,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_415,aa_st_414,9,aa_st_413,dfz_ui_3); 
  ObjectSet(aa_st_415,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_415,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_415,OBJPROP_YDISTANCE,345); 
  }
 by_st_275 = H27Symbol ;
 g_GroupName = "第14组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10173",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10173","(14)" + H27Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10173",OBJPROP_CORNER,0); 
 ObjectSet("10173",OBJPROP_XDISTANCE,498); 
 ObjectSet("10173",OBJPROP_YDISTANCE,355); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_419 = "Regular script";
 aa_st_420 = dfz_st_4;
 aa_st_421 = "10174";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_421,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_421,aa_st_420,9,aa_st_419,dfz_ui_3); 
  ObjectSet(aa_st_421,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_421,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_421,OBJPROP_YDISTANCE,355); 
  }
 by_st_275 = H28Symbol ;
 g_GroupName = "第14组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10175",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10175","(14)" + H28Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10175",OBJPROP_CORNER,0); 
 ObjectSet("10175",OBJPROP_XDISTANCE,498); 
 ObjectSet("10175",OBJPROP_YDISTANCE,365); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_425 = "Regular script";
 aa_st_426 = dfz_st_4;
 aa_st_427 = "10176";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_427,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_427,aa_st_426,9,aa_st_425,dfz_ui_3); 
  ObjectSet(aa_st_427,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_427,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_427,OBJPROP_YDISTANCE,365); 
  }
 by_st_275 = H29Symbol ;
 g_GroupName = "第15组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10177",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10177","(15)" + H29Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10177",OBJPROP_CORNER,0); 
 ObjectSet("10177",OBJPROP_XDISTANCE,498); 
 ObjectSet("10177",OBJPROP_YDISTANCE,375); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_431 = "Regular script";
 aa_st_432 = dfz_st_4;
 aa_st_433 = "10178";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_433,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_433,aa_st_432,9,aa_st_431,dfz_ui_3); 
  ObjectSet(aa_st_433,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_433,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_433,OBJPROP_YDISTANCE,375); 
  }
 by_st_275 = H30Symbol ;
 g_GroupName = "第15组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10179",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10179","(15)" + H30Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10179",OBJPROP_CORNER,0); 
 ObjectSet("10179",OBJPROP_XDISTANCE,498); 
 ObjectSet("10179",OBJPROP_YDISTANCE,385); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_437 = "Regular script";
 aa_st_438 = dfz_st_4;
 aa_st_439 = "10180";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_439,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_439,aa_st_438,9,aa_st_437,dfz_ui_3); 
  ObjectSet(aa_st_439,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_439,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_439,OBJPROP_YDISTANCE,385); 
  }
 by_st_275 = H31Symbol ;
 g_GroupName = "第16组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10181",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10181","(16)" + H31Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10181",OBJPROP_CORNER,0); 
 ObjectSet("10181",OBJPROP_XDISTANCE,498); 
 ObjectSet("10181",OBJPROP_YDISTANCE,395); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_443 = "Regular script";
 aa_st_444 = dfz_st_4;
 aa_st_445 = "10182";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_445,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_445,aa_st_444,9,aa_st_443,dfz_ui_3); 
  ObjectSet(aa_st_445,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_445,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_445,OBJPROP_YDISTANCE,395); 
  }
 by_st_275 = H32Symbol ;
 g_GroupName = "第16组2" ;
 UpdateRiskParams(); 
 CalcSpreadSignal(); 
 dfz_st_6 = "::挂单::OBL=" + DoubleToString(by_in_173,0) + "挂单::OSL=" + DoubleToString(by_in_172,0) + "::挂单::OBS=" + DoubleToString(by_in_174,0) + "挂单::OSS=" + DoubleToString(by_in_171,0) ;
 dfz_st_7 = "开单::B " + DoubleToString(by_in_117,0) + "  S " + DoubleToString(by_in_118,0) + " Blots:: " + DoubleToString(by_do_232,2) + "  Slots:: " + DoubleToString(by_do_199,2) + " 盈亏::" + DoubleToString(by_do_197,2) ;
 if ( by_do_197>0 )
  {
  dfz_ui_3 = LimeGreen ;
  }
 else
  {
  dfz_ui_3 = White ;
  }
 if ( by_do_197!=0 )
  {
  dfz_st_4 = dfz_st_5 ;
  }
 if ( by_bo_23==true )
  {
  dfz_ui_3 = Gold ;
  }
 ObjectCreate("10183",OBJ_LABEL,0,0,0,0,0,0,0); 
 ObjectSetText("10183","(16)" + H32Symbol + dfz_st_7,9,"Regular script",dfz_ui_3); 
 ObjectSet("10183",OBJPROP_CORNER,0); 
 ObjectSet("10183",OBJPROP_XDISTANCE,498); 
 ObjectSet("10183",OBJPROP_YDISTANCE,405); 
 if ( by_bo_165 )
  {
  dfz_ui_3 = Red ;
  dfz_st_4 = "开锁" ;
  }
 else
  {
  dfz_ui_3 = LimeGreen ;
  dfz_st_4 = "$$" ;
  }
 aa_st_449 = "Regular script";
 aa_st_450 = dfz_st_4;
 aa_st_451 = "10184";
 if ( dfz_in_1 != -1 )
  {
  ObjectCreate(aa_st_451,OBJ_LABEL,0,0,0,0,0,0,0); 
  ObjectSetText(aa_st_451,aa_st_450,9,aa_st_449,dfz_ui_3); 
  ObjectSet(aa_st_451,OBJPROP_CORNER,dfz_in_1); 
  ObjectSet(aa_st_451,OBJPROP_XDISTANCE,919); 
  ObjectSet(aa_st_451,OBJPROP_YDISTANCE,405); 
  }
 // ===== v2 模块化面板（新增监控模块，对象ID 20000–20663，与旧版 10xxx 完全并行互不影响）=====
 RenderAccountKPI();
 RenderSignalMatrix();
 RenderStatusPillars();
 RenderPositionTable();
 RenderRiskMonitor();
 RenderActivityLog();
 return(0); 
}

// ====== 模块 ① RenderAccountKPI：顶部 KPI 条（CORNER=1）背景卡 + 文字对齐 ======
void RenderAccountKPI() {
   int kpiY=22, kpiH=38;
   int kpiX[6]={8,168,328,498,668,838};
   int kpiW[6]={155,155,155,155,155,135};
   color valC;
   string tmpS;
   SetRect("20000",5,5,980,58,1,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20001","  账户监控 · 多品种对冲套利 EA  ",9,"Arial Bold",Gold,1,8,10,0);
   SetRect("20010",kpiX[0],kpiY,kpiW[0],kpiH,1,CLR_CARD_BG,CLR_CARD_BORDER,2);
   SetLabel("20011","余额 Balance",8,"Arial",LightSteelBlue,1,kpiX[0]+6,kpiY+5,0);
   valC = AccountBalance()>0?SpringGreen:Red;
   SetLabel("20012","$"+DoubleToString(AccountBalance(),2),11,"Arial Bold",valC,1,kpiX[0]+kpiW[0]-6,kpiY+26,8);
   SetRect("20013",kpiX[1],kpiY,kpiW[1],kpiH,1,CLR_CARD_BG,CLR_CARD_BORDER,2);
   SetLabel("20014","净值 Equity",8,"Arial",LightSteelBlue,1,kpiX[1]+6,kpiY+5,0);
   valC = AccountEquity()>=AccountBalance()?SpringGreen:Red;
   SetLabel("20015","$"+DoubleToString(AccountEquity(),2),11,"Arial Bold",valC,1,kpiX[1]+kpiW[1]-6,kpiY+26,8);
   SetRect("20016",kpiX[2],kpiY,kpiW[2],kpiH,1,CLR_CARD_BG,CLR_CARD_BORDER,2);
   SetLabel("20017","浮动盈亏",8,"Arial",LightSteelBlue,1,kpiX[2]+6,kpiY+5,0);
   valC = AccountProfit()>=0?SpringGreen:Red;
   tmpS = (AccountProfit()>=0?"+":"")+DoubleToString(AccountProfit(),2)+" USD";
   SetLabel("20018",tmpS,11,"Arial Bold",valC,1,kpiX[2]+kpiW[2]-6,kpiY+26,8);
   SetRect("20019",kpiX[3],kpiY,kpiW[3],kpiH,1,CLR_CARD_BG,CLR_CARD_BORDER,2);
   SetLabel("2001A","已用保证金",8,"Arial",LightSteelBlue,1,kpiX[3]+6,kpiY+5,0);
   SetLabel("2001B","$"+DoubleToString(AccountMargin(),2),11,"Arial Bold",Gold,1,kpiX[3]+kpiW[3]-6,kpiY+26,8);
   SetRect("2001C",kpiX[4],kpiY,kpiW[4],kpiH,1,CLR_CARD_BG,CLR_CARD_BORDER,2);
   SetLabel("2001D","可用 FreeMargin",8,"Arial",LightSteelBlue,1,kpiX[4]+6,kpiY+5,0);
   valC = AccountFreeMargin()>0?White:Red;
   SetLabel("2001E","$"+DoubleToString(AccountFreeMargin(),2),11,"Arial Bold",valC,1,kpiX[4]+kpiW[4]-6,kpiY+26,8);
   SetRect("2001F",kpiX[5],kpiY,kpiW[5],kpiH,1,CLR_CARD_BG,CLR_CARD_BORDER,2);
   SetLabel("20020","开仓/杠杆",8,"Arial",LightSteelBlue,1,kpiX[5]+6,kpiY+5,0);
   tmpS = DoubleToString(OrdersTotal(),0)+"单 1:"+DoubleToString(AccountLeverage(),0);
   SetLabel("20021",tmpS,10,"Arial Bold",Gold,1,kpiX[5]+kpiW[5]-6,kpiY+26,8);
}

// ====== 模块 ② RenderSignalMatrix：4×4 网格（CORNER=1）背景格 + 左边框色条 ======
void RenderSignalMatrix() {
   int baseY=72, cellW=118, cellH=36;
   int baseX=5, gridY;
   gridY=baseY+12;
   int col,row,gi,X,Y;
   color bgC, brdC, sideC, txtC, metaC;
   string sigTxt, bgId, nmId, stId, mtId;
   SetLabel("20100","  信号矩阵 · 16 组 ",9,"Arial Bold",Gold,1,5,baseY,0);
   SetLabel("20101","Signal 1=偏低▼  2=偏高▲  0=带内  Corr=拒绝",7,"Arial",Gray,1,80,baseY+2,0);
   for ( gi=1; gi<=16; gi++ ) {
      col=(gi-1)%4; row=(gi-1)/4;
      X=baseX+col*(cellW+4);
      Y=gridY+row*(cellH+3);
      bgC=CLR_SIG_BG; brdC=CLR_BORDER; sideC=Gray;
      txtC=White; metaC=LightSteelBlue; sigTxt="  带内";
      if ( !g_GC_active[gi] ) {
         bgC=CLR_PANEL_BG; brdC=CLR_INACTIVE_BG; sideC=Gray; txtC=Gray; sigTxt="  关闭"; metaC=Gray;
      } else if ( g_GC_corrReject[gi] ) {
         sideC=Gold; sigTxt="  Corr拒绝"; metaC=Gold;
      } else if ( g_GC_signal[gi]==1 ) {
         sideC=SpringGreen; sigTxt="  ▼ Signal 1";
      } else if ( g_GC_signal[gi]==2 ) {
         sideC=Red; sigTxt="  ▲ Signal 2";
      } else {
         sideC=CLR_INNER_BAND; sigTxt="  带内";
      }
      bgId="201"+DoubleToString(gi,0);
      nmId="211"+DoubleToString(gi,0);
      stId="221"+DoubleToString(gi,0);
      mtId="231"+DoubleToString(gi,0);
      SetRect(bgId,X,Y,cellW,cellH,1,bgC,brdC,2);
      SetRect(bgId+"s",X,Y,3,cellH,1,sideC,sideC,0);
      SetLabel(nmId,"G"+DoubleToString(gi,0)+" "+g_GC_sym1[gi]+"·"+g_GC_sym2[gi],8,"Arial Bold",txtC,1,X+6,Y+3,0);
      SetLabel(stId,sigTxt,8,"Arial Bold",sideC,1,X+6,Y+14,0);
      SetLabel(mtId,"β="+DoubleToString(g_GC_beta[gi],3)+" 偏离="+DoubleToString(g_GC_devPts[gi],2),7,"Arial",metaC,1,X+6,Y+25,0);
   }
}

// ====== 模块 ③ RenderStatusPillars：状态监控条（CORNER=1）======
void RenderStatusPillars() {
   int panelX=5, panelY=280, panelW=155, panelH=170;
   int y;
   color valC;
   string sigStr;
   double dd;
   SetRect("20200",panelX,panelY,panelW,panelH,1,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20201","  运行状态 ",9,"Arial Bold",Gold,1,panelX+6,panelY+5,0);
   y=panelY+20;
   SetRect("20202",panelX+5,y,panelW-10,18,1,CLR_CARD_BG,CLR_BORDER,2);
   SetLabel("20203","EA 运行",8,"Arial",LightSteelBlue,1,panelX+10,y+5,0);
   SetLabel("20204","● 正常",9,"Arial Bold",SpringGreen,1,panelX+panelW-10,y+5,8);
   y+=22;
   SetRect("20205",panelX+5,y,panelW-10,18,1,CLR_CARD_BG,CLR_BORDER,2);
   SetLabel("20206","强制清仓",8,"Arial",LightSteelBlue,1,panelX+10,y+5,0);
   valC = 清仓?Red:White;
   SetLabel("20207",清仓?"● 启用":"○ 关闭",9,"Arial Bold",valC,1,panelX+panelW-10,y+5,8);
   y+=22;
   SetRect("20208",panelX+5,y,panelW-10,18,1,CLR_CARD_BG,CLR_BORDER,2);
   SetLabel("20209","只平不开",8,"Arial",LightSteelBlue,1,panelX+10,y+5,0);
   valC = 只平不开?Gold:White;
   SetLabel("2020A",只平不开?"● 启用":"○ 关闭",9,"Arial Bold",valC,1,panelX+panelW-10,y+5,8);
   y+=22;
   SetRect("2020B",panelX+5,y,panelW-10,18,1,CLR_CARD_BG,CLR_BORDER,2);
   SetLabel("2020C","当前信号",8,"Arial",LightSteelBlue,1,panelX+10,y+5,0);
   sigStr="0=中性"; valC=White;
   if ( g_SpreadSignal==1 ) { sigStr="1=偏低▼"; valC=SpringGreen; }
   if ( g_SpreadSignal==2 ) { sigStr="2=偏高▲"; valC=Red; }
   SetLabel("2020D",sigStr,9,"Arial Bold",valC,1,panelX+panelW-10,y+5,8);
   y+=22;
   SetRect("2020E",panelX+5,y,panelW-10,18,1,CLR_CARD_BG,CLR_BORDER,2);
   SetLabel("2020F","回撤比",8,"Arial",LightSteelBlue,1,panelX+10,y+5,0);
   dd=0; if ( AccountBalance()>0 ) dd=(AccountEquity()-AccountBalance())/AccountBalance()*100;
   valC = dd>=-2?SpringGreen:(dd>=-5?Gold:Red);
   SetLabel("20210",DoubleToString(dd,2)+"%",9,"Arial Bold",valC,1,panelX+panelW-10,y+5,8);
   y+=22;
   SetRect("20211",panelX+5,y,panelW-10,18,1,CLR_CARD_BG,CLR_BORDER,2);
   SetLabel("20212","服务器时间",8,"Arial",LightSteelBlue,1,panelX+10,y+5,0);
   SetLabel("20213",TimeToString(TimeCurrent(),TIME_MINUTES),9,"Arial Bold",White,1,panelX+panelW-10,y+5,8);
}

// ====== 模块 ④ RenderPositionTable：仓位表（CORNER=0）带背景 + 列对齐 ======
void RenderPositionTable() {
   int tblX=5, tblY=5, tblW=490, tblH=280;
   int hdrY, rowH=14, sumY;
   hdrY=tblY+20;
   int colX[6];
   colX[0]=tblX+6; colX[1]=tblX+46; colX[2]=tblX+200;
   colX[3]=tblX+240; colX[4]=tblX+280; colX[5]=tblX+320;
   int gi, Y;
   double totLots=0, totPnl=0; int totB=0, totS=0;
   color rowBg, pnlC, bC, totC;
   SetRect("20300",tblX,tblY,tblW,tblH,0,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20301","  仓位矩阵 · 16 组 ",9,"Arial Bold",Gold,0,tblX+6,tblY+5,0);
   SetRect("20302",tblX+4,hdrY-2,tblW-8,18,0,CLR_HEADER_BG,CLR_BORDER,2);
   SetLabel("20303","组",8,"Arial Bold",LightSteelBlue,0,colX[0]+2,hdrY+4,0);
   SetLabel("20304","币对 1 · 币对 2",8,"Arial Bold",LightSteelBlue,0,colX[1]+2,hdrY+4,0);
   SetLabel("20305","B单",8,"Arial Bold",LightSteelBlue,0,colX[2]+2,hdrY+4,0);
   SetLabel("20306","S单",8,"Arial Bold",LightSteelBlue,0,colX[3]+2,hdrY+4,0);
   SetLabel("20307","手数",8,"Arial Bold",LightSteelBlue,0,colX[4]+2,hdrY+4,0);
   SetLabel("20308","盈亏 USD",8,"Arial Bold",LightSteelBlue,0,colX[5]+2,hdrY+4,0);
   for ( gi=1; gi<=16; gi++ ) {
      Y = hdrY + 2 + gi*rowH;
      rowBg = (gi%2==0)?CLR_ALT_ROW:CLR_ALT_ROW2;
      pnlC = g_GC_pnl[gi]>=0?SpringGreen:Red;
      bC = g_GC_active[gi]?White:Gray;
      SetRect("2031"+DoubleToString(gi,0),tblX+4,Y-1,tblW-8,rowH-1,0,rowBg,rowBg,0);
      SetLabel("2032"+DoubleToString(gi,0),"G"+DoubleToString(gi,0),7,"Arial",bC,0,colX[0]+2,Y+2,0);
      SetLabel("2033"+DoubleToString(gi,0),g_GC_sym1[gi]+"·"+g_GC_sym2[gi],7,"Arial",bC,0,colX[1]+2,Y+2,0);
      SetLabel("2034"+DoubleToString(gi,0),DoubleToString(g_GC_bCnt[gi],0),7,"Arial Bold",SpringGreen,0,colX[2]+2,Y+2,0);
      SetLabel("2035"+DoubleToString(gi,0),DoubleToString(g_GC_sCnt[gi],0),7,"Arial Bold",Red,0,colX[3]+2,Y+2,0);
      SetLabel("2036"+DoubleToString(gi,0),DoubleToString(g_GC_lots[gi],2),7,"Arial",White,0,colX[4]+2,Y+2,0);
      SetLabel("2037"+DoubleToString(gi,0),DoubleToString(g_GC_pnl[gi],2),7,"Arial Bold",pnlC,0,colX[5]+2,Y+2,0);
      totB+=g_GC_bCnt[gi]; totS+=g_GC_sCnt[gi];
      totLots+=g_GC_lots[gi]; totPnl+=g_GC_pnl[gi];
   }
   sumY = hdrY + 2 + 17*rowH;
   totC = totPnl>=0?SpringGreen:Red;
   SetRect("20390",tblX+4,sumY-2,tblW-8,rowH+2,0,CLR_TOTAL_ROW,Gold,1);
   SetLabel("20391","Σ",8,"Arial Bold",Gold,0,colX[0]+2,sumY+3,0);
   SetLabel("20392","16 组合计",8,"Arial Bold",Gold,0,colX[1]+2,sumY+3,0);
   SetLabel("20393",DoubleToString(totB,0),8,"Arial Bold",SpringGreen,0,colX[2]+2,sumY+3,0);
   SetLabel("20394",DoubleToString(totS,0),8,"Arial Bold",Red,0,colX[3]+2,sumY+3,0);
   SetLabel("20395",DoubleToString(totLots,2),8,"Arial Bold",White,0,colX[4]+2,sumY+3,0);
   SetLabel("20396",DoubleToString(totPnl,2),8,"Arial Bold",totC,0,colX[5]+2,sumY+3,0);
}

// ====== 模块 ⑤ RenderRiskMonitor：风险监控（CORNER=0）带进度色条 ======
void RenderRiskMonitor() {
   int rx=500, ry=5, rw=495, rh=150;
   int hdrY, rowH=12;
   hdrY=ry+20;
   int cX[4];
   cX[0]=rx+6; cX[1]=rx+120; cX[2]=rx+230; cX[3]=rx+340;
   int gi, Y;
   double addPct, thr;
   color rowBg, addC, relC, limC;
   string addTxt, relTxt, limTxt;
   SetRect("20500",rx,ry,rw,rh,0,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20501","  风险触发监控 · 16 组 ",9,"Arial Bold",Gold,0,rx+6,ry+5,0);
   SetRect("20502",rx+4,hdrY-2,rw-8,16,0,CLR_HEADER_BG,CLR_BORDER,2);
   SetLabel("20503","组",8,"Arial Bold",LightSteelBlue,0,cX[0]+2,hdrY+3,0);
   SetLabel("20504","距加仓",8,"Arial Bold",LightSteelBlue,0,cX[1]+2,hdrY+3,0);
   SetLabel("20505","距减仓",8,"Arial Bold",LightSteelBlue,0,cX[2]+2,hdrY+3,0);
   SetLabel("20506","信号/限频",8,"Arial Bold",LightSteelBlue,0,cX[3]+2,hdrY+3,0);
   for ( gi=1; gi<=16; gi++ ) {
      Y = hdrY + 2 + gi*rowH;
      rowBg = (gi%2==0)?CLR_ALT_ROW:CLR_ALT_ROW2;
      addPct=100; addTxt="— 无仓"; addC=LightSteelBlue;
      if ( g_GC_lots[gi]>0 && g_GC_pnl[gi]<0 ) {
         thr=g_GC_lots[gi]*6.8*100;
         addPct=(-g_GC_pnl[gi])/MathMax(thr,0.01)*100;
         addTxt=DoubleToString(addPct,0)+"%";
         addC = addPct>=100?Red:(addPct>=70?Gold:SpringGreen);
      } else if ( g_GC_lots[gi]>0 && g_GC_pnl[gi]>=0 ) { addTxt="+"+DoubleToString(g_GC_pnl[gi],1); addC=SpringGreen; }
      relTxt=g_GC_signal[gi]!=0?"待命":"无信号"; relC=g_GC_signal[gi]!=0?Gold:Gray;
      limTxt="新bar"; limC=White;
      SetRect("2051"+DoubleToString(gi,0),rx+4,Y-1,rw-8,rowH-1,0,rowBg,rowBg,0);
      SetLabel("2052"+DoubleToString(gi,0),"G"+DoubleToString(gi,0),7,"Arial",White,0,cX[0]+2,Y+2,0);
      SetLabel("2053"+DoubleToString(gi,0),addTxt,7,"Arial Bold",addC,0,cX[1]+2,Y+2,0);
      SetLabel("2054"+DoubleToString(gi,0),relTxt+" "+limTxt,7,"Arial Bold",relC,0,cX[2]+2,Y+2,0);
      SetLabel("2055"+DoubleToString(gi,0),"手:"+DoubleToString(g_GC_lots[gi],2),7,"Arial",limC,0,cX[3]+2,Y+2,0);
   }
}

// ====== 模块 ⑥ RenderActivityLog：活动日志（CORNER=0）带滚动背景 ======
void RenderActivityLog() {
   int logX=5, logY=450, logW=990, logH=90;
   int baseY, rowH, colX[4];
   int i, idx, Y;
   string line, tm, bd;
   color rowBg;
   logY = 5+280+150+15;
   if ( logY+logH > 470 ) logY = 470-logH;
   baseY=logY+20; rowH=9;
   colX[0]=logX+6; colX[1]=logX+80; colX[2]=logX+200; colX[3]=logX+400;
   SetRect("20600",logX,logY,logW,logH,0,CLR_PANEL_BG,CLR_FRAME,1);
   SetLabel("20601","  活动日志 · 最近事件 ",9,"Arial Bold",Gold,0,logX+6,logY+5,0);
   SetLabel("20602","时间",7,"Arial Bold",LightSteelBlue,0,colX[0],baseY+6,0);
   SetLabel("20603","事件",7,"Arial Bold",LightSteelBlue,0,colX[1],baseY+6,0);
   SetLabel("20604","详情",7,"Arial Bold",LightSteelBlue,0,colX[2],baseY+6,0);
   SetLabel("20605","状态",7,"Arial Bold",LightSteelBlue,0,colX[3],baseY+6,0);
   for ( i=0; i<8; i++ ) {
      idx=(g_LogPtr-1-i+8)%8;
      Y=baseY+8+i*rowH;
      line=g_LogLine[idx];
      rowBg=(i%2==0)?CLR_ALT_ROW:CLR_ALT_ROW2;
      SetRect("2061"+DoubleToString(i,0),logX+4,Y-1,logW-8,rowH,0,rowBg,rowBg,0);
      if ( StringLen(line)<3 ) {
         SetLabel("2062"+DoubleToString(i,0),"",7,"Arial",Gray,0,colX[0],Y+2,0);
         SetLabel("2063"+DoubleToString(i,0),"— 无记录 —",7,"Arial",Gray,0,colX[1],Y+2,0);
         continue;
      }
      tm=StringSubstr(line,0,StringFind(line,"| "));
      bd=StringSubstr(line,StringFind(line,"| ")+2);
      SetLabel("2064"+DoubleToString(i,0),tm,7,"Arial",White,0,colX[0],Y+2,0);
      SetLabel("2065"+DoubleToString(i,0),bd,7,"Arial",LightSteelBlue,0,colX[1],Y+2,0);
   }
}


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
