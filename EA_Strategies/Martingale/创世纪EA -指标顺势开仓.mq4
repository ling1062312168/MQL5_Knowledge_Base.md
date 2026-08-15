//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

int 启用账户限制=0;//不启用设置0 启用设置1
int 启用时间限制=0;//不启用设置0 启用设置1

string 賬戶="12525,252262,255256,454545";//每个账号用逗号隔开
datetime 到期時間=D'2099.03.08 15:17';

#property version "1.00";
#property strict
#resource "\\Indicators\\Gold trading_code.ex4"

#include <ChartObjects/ChartObjectsTxtControls.mqh>
#include <Arrays/ArrayString.mqh>
#include <Controls/Label.mqh>
#include <Controls/Edit.mqh>
#include <Controls/Button.mqh>
#include <Canvas/Canvas.mqh>

extern int 加仓间隔点数=300;
extern double 加仓手数倍数=1.25;
extern int 最大加仓次数=12;
extern int 最大止损金额=0;

extern string sPosComm = "EA"; //EA系列
extern double dVol = 0.01; // 首单手数
double MM = 1.3; // 加仓倍数
int iDist = 150; //加仓间距
extern double dML = 0.3; //单笔最大开仓手数
extern int TP = 1500; // 止盈点数
extern int SL=0; // 止损点数 (0 - 为无止损)
extern double 单品种止盈金额=150.0;
extern bool Reduction=true;//首尾对冲平仓
extern int Magic = 2025214; // EA识别码
extern double 超过此浮盈金额开启移动止损=300.0;
extern double 移动止损保金额=100.0;

struct sGetInfo
  {
public:
   double            m_0;
   double            m_8;
   double            m_16;
   double            m_24;
   double            m_32;
   double            m_40;
   double            m_48;
   double            m_56;
   double            m_64;
   double            m_72;
   double            m_80;
   double            m_88;
   double            m_96;
   bool              m_104;
   bool              m_105;
   double            m_106;
   double            m_114;
  };

struct sInfoOrder
  {
public:
   double            m_0;
   double            m_8;
   double            m_16;
   double            m_24;
   double            m_32;
   int               m_40;
   int               m_44;
   datetime          m_48;
   string            m_56;
   void              FUN_1574()
     {
     }

                     sInfoOrder()
     {
     }

   void              FUN_1605()
     {
     }

  };


long Il_0E98;
long Il_0EA0;
bool Ib_0EA8;
int returned_i;
string Is_0B50;
string Is_0E30;
string Is_0B60;
string Is_0B70;
string Is_0B80;
string Is_0B90;
string Is_0BB0;
string Is_0BA0;
string Is_0BC0;
string Is_0BE0;
string Is_0BD0;
string Is_0BF0;
string Gs_0001;
int Gi_0002;
int Ii_0E80;
bool Ib_0E64;
bool Ib_0E65;
long Il_0E88;
long Il_0E90;
double Gd_0002;
double Ind_000;
double Ind_002;
int Ii_0E68;
int Ii_0E6C;
bool Gb_0002;
bool returned_b;
int Gi_0003;
int Gi_0004;
int Gi_0005;
int Gi_0006;
int Gi_0007;
int Gi_0008;
long Gl_0009;
int Gi_000A;
bool Gb_000A;
int Gi_000B;
int Gi_000C;
int Gi_000D;
int Gi_000E;
int Gi_000F;
int Gi_0010;
long Gl_0011;
int Gi_0012;
long Gl_0012;
long Gl_000A;
long Gl_0000;
long returned_l;
string Is_0A58;
double Id_0E50;
double Id_0E58;
double Id_0E40;
double Id_0E48;
bool Gb_0000;
double Gd_0000;
int Ii_0E60;
int Gi_0000;
long Il_0FD0;
int Gi_0001;
long Gl_0001;
int Ii_0E0C;
bool Ib_0E1D;
bool Ib_0E1C;
double Gd_0003;
bool Gb_0004;
long Gl_0004;
bool Ib_0E00;
double Gd_0004;
int Ii_0CF8;
int Ii_0CFC;
string Gs_0002;
string Gs_0003;
string Gs_0005;
string Gs_0006;

int Gi_0009;
int Gi_0011;
int Gi_0013;
int Gi_0014;
int Gi_0015;
int Gi_0016;
int Gi_0017;
int Gi_0018;
long Gl_0019;
int Gi_0019;
long Gl_001A;
int Gi_001A;
long Gl_001B;
int Gi_001B;
long Gl_001C;
int Gi_001C;
int Gi_001E;
string Gs_001D;
string Gs_001E;
long Gl_001F;
int Gi_001F;
int Gi_0021;
string Gs_0020;
string Gs_0021;
long Gl_0022;
int Gi_0022;
int Gi_0024;
string Gs_0023;
string Gs_0024;
int Gi_0025;
int Gi_0027;
string Gs_0027;
int Gi_0028;
int Gi_002A;
string Gs_0029;
string Gs_002A;
int Gi_002B;
int Gi_002D;
string Gs_002D;
int Gi_002E;
int Gi_0030;
string Gs_002F;
string Gs_0030;
string Is_0C00;
long Gl_002D;
string Gs_002C;
long Gl_0027;
string Gs_0026;
int Ii_0EE0;
string Is_0000;
int Ii_0D7C;
int Ii_0D80;
double Id_0DF0;
double Id_0DF8;
int Ii_0E04;
int Ii_0E08;
string Is_0E10;
int Ii_0E20;
int Ii_0E24;
int Ii_0E28;
int Ii_0E2C;
double Id_0E70;
double Id_0E78;
long Il_0FC0;
long Il_0FC8;
long Il_0FD8;
struct Input_Struct_00000EAC;
long Gl_0002;
bool Gb_0003;
bool Gb_0006;
bool Gb_0008;
long Gl_0007;
bool Gb_0005;
bool Gb_0007;
bool Gb_0009;
bool Gb_000B;
long Gl_000C;
long Gl_0008;
long Gl_0006;
bool Gb_0001;
string Gs_0000;
double Gd_0006;
double Gd_000B;
string Gs_000B;
double Gd_000F;
long Gl_0010;
double Gd_0014;
bool Gb_0014;
double Ind_004;
double Gd_0015;
long Gl_0015;
long Gl_0017;
double Gd_0018;
double Gd_0017;
double Gd_0019;
bool Gb_0018;
bool Gb_001A;
double Gd_001A;
long Gl_001D;
int Gi_001D;
double Gd_001E;
double Gd_001D;
double Gd_001F;
long Gl_001E;
long Gl_0020;
double Gd_0020;
bool Gb_0020;
int Gi_0020;
bool Gb_0021;
long Gl_0021;
double Gd_0022;
bool Gb_0022;
int Gi_0023;
double Gd_0025;
long Gl_0026;
bool Gb_0027;
int Gi_0029;
double Gd_002A;
long Gl_002B;
int Gi_002C;
bool Gb_002C;
double Gd_002F;
long Gl_0030;
int Gi_0031;
bool Gb_0031;
int Gi_0032;
int Gi_0033;
double Gd_0034;
long Gl_0035;
int Gi_0036;
bool Gb_0036;
int Gi_0037;
int Gi_0038;
double Gd_0039;
long Gl_003A;
int Gi_003B;
bool Gb_003B;
int Gi_003C;
int Gi_003D;
double Gd_003E;
long Gl_003F;
int Gi_0040;
bool Gb_0040;
int Gi_0041;
int Gi_0042;
double Gd_0043;
long Gl_0044;
int Gi_0045;
bool Gb_0045;
int Gi_0046;
int Gi_0047;
double Gd_0048;
long Gl_0049;
int Gi_004A;
bool Gb_004A;
int Gi_004B;
int Gi_004C;
double Gd_004D;
long Gl_004E;
long Gl_004F;
int Gi_0050;
bool Gb_0050;
int Gi_0051;
int Gi_0052;
double Gd_0053;
long Gl_0054;
long Gl_0055;
int Gi_0056;
bool Gb_0056;
int Gi_0057;
int Gi_0058;
double Gd_0059;
long Gl_005A;
long Gl_005B;
int Gi_005C;
bool Gb_005C;
int Gi_005D;
int Gi_005E;
double Gd_005F;
long Gl_0060;
long Gl_0061;
int Gi_0062;
bool Gb_0062;
int Gi_0063;
int Gi_0064;
double Gd_0065;
long Gl_0066;
long Gl_0067;
int Gi_0068;
bool Gb_0068;
int Gi_0069;
int Gi_006A;
double Gd_006B;
long Gl_006C;
long Gl_006D;
int Gi_006E;
bool Gb_006E;
int Gi_006F;
int Gi_0070;
double Gd_0071;
long Gl_0072;
long Gl_0073;
int Gi_0074;
bool Gb_0074;
int Gi_0075;
int Gi_0076;
double Gd_0077;
long Gl_0078;
long Gl_0079;
int Gi_007A;
long Gl_007A;
long Gl_0074;
long Gl_006E;
long Gl_0068;
long Gl_0062;
long Gl_005C;
long Gl_0056;
long Gl_0050;
long Gl_004A;
long Gl_0045;
long Gl_0040;
long Gl_003B;
long Gl_0036;
long Gl_0031;
long Gl_002C;
double Gd_0001;
double Gd_0007;
double Gd_0008;
bool Gb_000C;
long Gl_000D;
bool Gb_000D;
double Gd_000D;
long Gl_000F;
double Gd_0011;
double Gd_0010;
long Gl_0014;
long Gl_0016;
bool Gb_0017;
bool Gb_001B;
bool Gb_001C;
long Gl_0023;
bool Gb_0024;
double Gd_0026;
int Gi_0026;
bool Gb_0029;
long Gl_002A;
long Gl_0029;
bool Gb_002A;
double Gd_002C;
double Gd_002B;
bool Gb_002F;
int Gi_002F;
long Gl_002F;
bool Gb_0030;
long Gl_0032;
double Gd_0033;
int Gi_0034;
int Gi_0035;
bool Gb_0037;
long Gl_0038;
long Gl_0037;
long Gl_0003;
double Gd_000A;
double Gd_0009;
double Gd_000E;
double Gd_0005;
string Gs_0007;
string Gs_0008;
string Gs_000C;
bool Gb_0010;
string Gs_000D;
string Gs_0011;
bool Gb_0015;
string Gs_0012;
string Gs_0016;
string Gs_0017;
string Gs_001B;
bool Gb_001F;
string Gs_001C;
string Gs_0025;
long Gl_004B;
long Gl_004C;
long Gl_004D;
int Gi_004E;
int Gi_004F;
long Gl_0051;
int Gi_0053;
int Gi_0054;
int Gi_0055;
bool Gb_0055;
int Gi_0059;
int Gi_005A;
int Gi_005B;
bool Gb_005D;
int Gi_005F;
int Gi_0060;
int Gi_0061;
long Gl_0064;
int Gi_0065;
int Gi_0066;
int Gi_0067;
int Gi_006B;
int Gi_006C;
int Gi_006D;
long Gl_0065;
long Gl_005D;
bool Gb_0025;
bool Gb_0016;
bool Gb_0011;
int Gi_003E;
int Gi_0044;
int Gi_0049;
string Gs_0048;
string Gs_0049;
string Gs_0045;
string Gs_0046;
int Gi_0043;
string Gs_0042;
string Gs_0043;
string Gs_003F;
string Gs_0040;
string Gs_003C;
string Gs_003D;
int Gi_003A;
string Gs_0039;
string Gs_003A;
string Gs_0036;
string Gs_0037;
string Gs_0033;
string Gs_0034;
string Gs_002E;
string Gs_0004;
string Gs_0013;
long Gl_0018;
bool Gb_0026;
long Gl_002E;
bool Gb_0035;
int Gi_0039;
int Gi_003F;
bool Gb_0041;
bool Gb_0042;
int Gi_0048;
string Gs_0009;
string Gs_000E;
bool Gb_000F;
double Ind_003;

double Id_0F18[4];
int Ii_0F6C[4];
int Ii_0FB0[4];
CEdit Input_Struct_000000A4[10];
sInfoOrder Input_Struct_00000D84[];
sInfoOrder Input_Struct_00000DB8[];
sGetInfo Input_Struct_00000D00;
CEdit Input_Pointer_00000A58;
CEdit Input_Pointer_00000C00;
CArrayString *Input_Pointer_00000068;
double returned_double;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   int Li_FFFC;

   Is_0000 = "v01";
   Ii_0EE0 = 0;

   Ii_0CF8 = 0;
   Ii_0CFC = 0;
   Ii_0D7C = 0;
   Ii_0D80 = 0;
   Id_0DF0 = 0;
   Id_0DF8 = 1.79769313486232E+308;
   Ib_0E00 = false;
   Ii_0E04 = 0;
   Ii_0E08 = 0;
   Ii_0E0C = 1;
   Is_0E10 = "22:30";
   Ib_0E1C = false;
   Ib_0E1D = false;
   Ii_0E20 = 32768;
   Ii_0E24 = 255;
   Ii_0E28 = 42495;
   Ii_0E2C = 7504122;
   Is_0E30 = "vx:jyjr007";
   Id_0E40 = 0;
   Id_0E48 = 0;
   Id_0E50 = 0;
   Id_0E58 = 0;
   Ii_0E60 = 0;
   Ib_0E64 = false;
   Ib_0E65 = false;
   Ii_0E68 = 0;
   Ii_0E6C = 0;
   Id_0E70 = 0;
   Id_0E78 = 0;
   Ii_0E80 = 0;
   Il_0E88 = 0;
   Il_0E90 = 0;
   Il_0E98 = 0;
   Il_0EA0 = 0;
   Ib_0EA8 = false;
   Il_0FC0 = 0;
   Il_0FC8 = 0;
   Il_0FD0 = 0;
   Il_0FD8 = 0;

   Il_0E98 = 0;
   Il_0EA0 = 0;
   Ib_0EA8 = true;
   _RandomSeed = GetTickCount();
   Is_0B50 = Is_0E30 + "ControlPanel_recar";
   Is_0B60 = Is_0E30 + "text_Buy_Profit";
   Is_0B70 = Is_0E30 + "text_Sell_Profit";
   Is_0B80 = Is_0E30 + "Button_Trade_Buy";
   Is_0B90 = Is_0E30 + "Button_Trade_Sell";
   Is_0BB0 = Is_0E30 + "Button_Close_Buy";
   Is_0BA0 = Is_0E30 + "Button_Close_Sell";
   Is_0BC0 = Is_0E30 + "Button_New_Series";
   Is_0BE0 = Is_0E30 + "Button_Open_Buy";
   Is_0BD0 = Is_0E30 + "Button_Open_Sell";
   Is_0BF0 = Is_0E30 + "Edit_Lot";
   Input_Pointer_00000068 = new CArrayString();

   EventSetTimer(1);
   Ii_0E80 = -1;
   Ib_0E64 = false;
   Ib_0E65 = false;
   Il_0E88 = 0;
   Il_0E90 = 0;
   Gd_0002 = log(MarketInfo(_Symbol, MODE_MINLOT));
   Gd_0002 = fabs((Gd_0002 / 2.30258509299405));
   Gd_0002 = round(Gd_0002);
   Ii_0E68 = (int)Gd_0002;
   Gd_0002 = log(MarketInfo(_Symbol, MODE_LOTSTEP));
   Gd_0002 = fabs((Gd_0002 / 2.30258509299405));
   Gd_0002 = round(Gd_0002);
   Ii_0E6C = (int)Gd_0002;
   if(fA_MM && iAuLot == 0)
     {
      Print("Money Management Disabled");
      fA_MM = false;
     }
   if(_Digits == 2 || _Digits == 4)
     {

      TP = TP / 10;
      SL = SL / 10;
      IStop = IStop / 10;
      ISTart =  ISTart / 10;
     }
   if((dVol < MarketInfo(_Symbol, MODE_MINLOT)))
     {
      Print("dVol uncorrect");
      dVol = MarketInfo(_Symbol, MODE_MINLOT);
     }
   if((MM < 0))
     {
      Print("MM uncorrect");
      MM = 1;
     }
   Gb_0002 = (dML > MarketInfo(_Symbol, MODE_MAXLOT));
   if(dML < MarketInfo(_Symbol, MODE_MINLOT) || Gb_0002 != false)
     {

      Print("dML uncorrect");
      dML = MarketInfo(_Symbol, MODE_MAXLOT);
     }
   if(TP < 0)
     {
      Print("TP uncorrect");
      TP = 100;
     }
   if(SL < 0)
     {
      Print("SL uncorrect");
      SL = 2000;
     }
   if(iDist < 1)
     {
      Print("iDist uncorrect");
      iDist = 100;
     }
   if(ISTart < 0)
     {
      Print(" ISTart uncorrect");
      ISTart = 400;
     }
   if(IStop < 1 || IStop >=  ISTart)
     {

      Print("TraiiDistance uncorrect");
      IStop = 200;
     }
   if(Magic < 0)
     {
      Print("Magic uncorrect");
      Magic = 1;
     }
   if(IsTesting() != true)
     {
      FUN_1595();
      return 0;
     }
   iDist=加仓间隔点数;
   MM=加仓手数倍数;
   Gb_0002 = false;
   Gi_0003 = 1;
   Gi_0004 = 16711680;
   Gi_0005 = FontSize;
   Ls0_str0000 = "多单盈亏: 0";
   Gi_0006 = 0;
   Gi_0007 = Y1;
   Gi_0008 = X1 + 5;
   Ls0_str0001 = Is_0B60;
   Gl_0009 = 0;
   if(ObjectFind(0, Ls0_str0001) == -1 && ObjectCreate(0, Ls0_str0001, OBJ_LABEL, 0, 0, 0) == false)
     {
      Print("DrawLabel", "Error: ", GetLastError());
     }
   else
     {
      ObjectSetInteger(Gl_0009, Ls0_str0001, 102, Gi_0008);
      ObjectSetInteger(Gl_0009, Ls0_str0001, 103, Gi_0007);
      ObjectSetInteger(Gl_0009, Ls0_str0001, 101, Gi_0006);
      ObjectSetString(Gl_0009, Ls0_str0001, 999, Ls0_str0000);
      ObjectSetInteger(Gl_0009, Ls0_str0001, 100, Gi_0005);
      ObjectSetInteger(Gl_0009, Ls0_str0001, 1011, Gi_0003);
      ObjectSetInteger(Gl_0009, Ls0_str0001, 6, Gi_0004);
      ObjectSetInteger(Gl_0009, Ls0_str0001, 1000, Gb_0002);
     }
   Gb_000A = false;
   Gi_000B = 1;
   Gi_000C = 16711680;
   Gi_000D = FontSize;
   Ls0_str0002 = "空单盈亏: 0";
   Gi_000E = 0;
   Gi_000F = Y1 + 20;
   Gi_0010 = X1 + 5;
   Ls0_str0003 = Is_0B70;
   Gl_0011 = 0;
   if(ObjectFind(0, Ls0_str0003) == -1 && ObjectCreate(0, Ls0_str0003, OBJ_LABEL, 0, 0, 0) == false)
     {
      Print("DrawLabel", "Error: ", GetLastError());
      return 0;
     }
   ObjectSetInteger(Gl_0011, Ls0_str0003, 102, Gi_0010);
   ObjectSetInteger(Gl_0011, Ls0_str0003, 103, Gi_000F);
   ObjectSetInteger(Gl_0011, Ls0_str0003, 101, Gi_000E);
   ObjectSetString(Gl_0011, Ls0_str0003, 999, Ls0_str0002);
   ObjectSetInteger(Gl_0011, Ls0_str0003, 100, Gi_000D);
   ObjectSetInteger(Gl_0011, Ls0_str0003, 1011, Gi_000B);
   ObjectSetInteger(Gl_0011, Ls0_str0003, 6, Gi_000C);
   ObjectSetInteger(Gl_0011, Ls0_str0003, 1000, Gb_000A);

   Li_FFFC = 0;
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |

//+------------------------------------------------------------------+
//|                                                                  |
void FUN_X0215()
  {
   bool li_0;
   bool li_4;
   for(int li_80=0; li_80<100; li_80++)
      for(int li_8=0; li_8<OrdersTotal(); li_8++)
        {
         RefreshRates();
         li_0=OrderSelect(li_8,SELECT_BY_POS,MODE_TRADES);
         if(li_0)
           {
            if(OrderMagicNumber()==Magic  && OrderSymbol()==Symbol())
              {
               if(OrderType()<2)
                 {
                  li_4=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,Yellow);

                 }
              }
           }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

   HideTestIndicators(0);
   if(chexk()!=1)
      return;
   if(IsTesting())
     {
      // ExpertRemove();
      //  return;

     }
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;

   FUN_0252a("净值", "账户净值："+DoubleToStr(AccountEquity(),2)+"＄",  10,  358);

   FUN_0252a("余额", "账户余额："+DoubleToStr(AccountBalance(),2)+"＄",  10,  313);

   FUN_0252a("手数", "总持仓："+DoubleToStr(FUN_lox01(0)+FUN_lox01(1),2)+"手",  10,  278);

   FUN_0252a("盈亏", "浮盈亏："+DoubleToStr(FUN_po01(0)+FUN_po01(1),2)+"＄",  240,  278);

   FUN_0252a("duodan", "多单："+DoubleToStr(FUN_lox01(0),2)+"手",  10,  233);

   FUN_0252a("duodans", "浮盈亏："+DoubleToStr(FUN_po01(0),2)+"＄",  205,  233);

   FUN_0252a("kongdan", "空单："+DoubleToStr(FUN_lox01(1),2)+"手",  10,  193);

   FUN_0252a("kongdand", "浮盈亏："+DoubleToStr(FUN_po01(1),2)+"＄",  205,  193);
   FUN_025152();
   func_1600();
   FUN_02526() ;

   if(单品种止盈金额>0)
      if(FUN_po01(0)+FUN_po01(1)>单品种止盈金额)
         FUN_X0215();


   if(最大止损金额>0)
      if(FUN_po01(0)+FUN_po01(1)<-最大止损金额)
         FUN_X0215();

   static double mf0125=0;
   if(FUN_po01(0)+FUN_po01(1)>mf0125)
      mf0125=FUN_po01(0)+FUN_po01(1);


   if(mf0125>超过此浮盈金额开启移动止损)
      if(FUN_po01(0)+FUN_po01(1)<=移动止损保金额)
        {
         mf0125=0;
         FUN_X0215();

        }

   Input_Pointer_00000A58.Text("平台时间: " + TimeToString(TimeCurrent(), 6));
   RefreshRates();
   Id_0E50 = NormalizeDouble(Ask, _Digits);
   Id_0E58 = NormalizeDouble(Bid, _Digits);
   Id_0E40 = (MarketInfo(_Symbol, MODE_STOPLEVEL) * _Point);
   Id_0E48 = (MarketInfo(_Symbol, MODE_SPREAD) * _Point);
   if((Id_0E40 == 0))
     {
      Id_0E40 = NormalizeDouble((Id_0E48 * 1.5), _Digits);
     }
   Ii_0E60 = (int)MarketInfo(_Symbol, MODE_SPREAD);
   if(Ii_0E60 < 0)
     {
      Ii_0E60 = 0;
     }
   if(Ii_0E80 != -1)
     {
      FUN_1594();
      return ;
     }
   if(Il_0FD0 != Time[0])
     {
      Il_0FD0 = Time[0];
      Ib_0E64 = false;
      Ib_0E65 = false;
     }
//if(Il_0EA0 != iTime(NULL, 0, 0))
     {
      HideTestIndicators(0);
      if(Ii_0E0C == 1)
        {
         Il_0EA0 = iTime(NULL, 0, 0);
        }
      Gd_0002 = iCustom(NULL, TF, "::Indicators\\Gold trading_code.ex4", Ib_0E1C, Deviation, Ib_0E1D, 0, 1);
      Gd_0003 = iCustom(NULL, TF, "::Indicators\\Gold trading_code.ex4", Ib_0E1C, Deviation, Ib_0E1D, 1, 1);
      if((Gd_0002 != EMPTY_VALUE))
        {
         if(Bid>Gd_0002)
            Ib_0E64 = true;
         else
            Ib_0E65 = true;
        }
      if((Gd_0003 != EMPTY_VALUE))
        {

         if(Bid>Gd_0003)
            Ib_0E64 = true;
         else
            Ib_0E65 = true;


        }
     }



   FUN_1579();
   if((Input_Struct_00000D00.m_0 >= 0))
     {
      Gi_0004 = 16711680;
     }
   else
     {
      Gi_0004 = 255;
     }
   Ls0_str0000 = "多单盈亏: " + DoubleToString(Input_Struct_00000D00.m_0, 2);
   Ls0_str0001 = Is_0B60;
   if(ObjectFind(0, Ls0_str0001) != -1)
     {
      ObjectSetString(0, Ls0_str0001, 999, Ls0_str0000);
      ObjectSetInteger(0, Ls0_str0001, 6, Gi_0004);
     }
   if((Input_Struct_00000D00.m_8 >= 0))
     {
      Gi_0004 = 16711680;
     }
   else
     {
      Gi_0004 = 255;
     }
   Ls0_str0002 = "空单盈亏: " + DoubleToString(Input_Struct_00000D00.m_8, 2);
   Ls0_str0003 = Is_0B70;
   if(ObjectFind(0, Ls0_str0003) != -1)
     {
      ObjectSetString(0, Ls0_str0003, 999, Ls0_str0002);
      ObjectSetInteger(0, Ls0_str0003, 6, Gi_0004);
     }
   if(Ib_0E00)
     {
      Gd_0004 = (Ask - Bid);
      Ls0_str0004 = DoubleToString((Gd_0004 / _Point), 0);
      Comment("GetInfo.LastOrderBuyPrice = ", Input_Struct_00000D00.m_106, " \nGetInfo.LastOrderSellPrice = ", Input_Struct_00000D00.m_114, " \n iDist = ", iDist, " \n Ask-Bid = ", Ls0_str0004, "\n Flag_Open_Buy = ", Ib_0E64, "\n Flag_Open_Sell = ", Ib_0E65);
     }
   FUN_1580();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
//  ObjectsDeleteAll();
   Gi_0001 = CheckPointer(Input_Pointer_00000068);
   if(Gi_0001 == 1)
     {
      delete Input_Pointer_00000068;
     }

  }


//+------------------------------------------------------------------+
void FUN_0252a(string Name,string Text,int XOffset,int YLine)
  {


   ObjectCreate(0,Name,OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,Name,OBJPROP_CORNER,2);
   ObjectSetInteger(0,Name,OBJPROP_XDISTANCE,XOffset);
   ObjectSetInteger(0,Name,OBJPROP_YDISTANCE,YLine);
   ObjectSetInteger(0,Name,OBJPROP_BACK,1);
   ObjectSetInteger(0,Name,OBJPROP_HIDDEN,1);

   ObjectSetInteger(0,Name,OBJPROP_COLOR,DeepPink);
   ObjectSetInteger(0,Name,OBJPROP_FONTSIZE,15);
   ObjectSetString(0,Name,OBJPROP_FONT,"微软雅黑");

   ObjectSetInteger(0,Name,OBJPROP_ANCHOR,2);


   ObjectSetString(0,Name,OBJPROP_TEXT,Text);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   Input_Pointer_00000A58.Text("平台时间: " + TimeToString(TimeCurrent(), 6));


   FUN_0252a("净值", "账户净值："+DoubleToStr(AccountEquity(),2)+"＄",  10,  358);

   FUN_0252a("余额", "账户余额："+DoubleToStr(AccountBalance(),2)+"＄",  10,  313);

   FUN_0252a("手数", "总持仓："+DoubleToStr(FUN_lox01(0)+FUN_lox01(1),2)+"手",  10,  278);

   FUN_0252a("盈亏", "浮盈亏："+DoubleToStr(FUN_po01(0)+FUN_po01(1),2)+"＄",  240,  278);

   FUN_0252a("duodan", "多单："+DoubleToStr(FUN_lox01(0),2)+"手",  10,  233);

   FUN_0252a("duodans", "浮盈亏："+DoubleToStr(FUN_po01(0),2)+"＄",  205,  233);

   FUN_0252a("kongdan", "空单："+DoubleToStr(FUN_lox01(1),2)+"手",  10,  193);

   FUN_0252a("kongdand", "浮盈亏："+DoubleToStr(FUN_po01(1),2)+"＄",  205,  193);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls0_str0008;
   string Ls0_str0009;
   string Ls0_str000A;
   int Li_FFFC;
   long Ll_FFF0;
   int Li_FFEC;
   int Li_FFE8;
   double Ld_FFE0;
   double Ld_FFD8;

   Li_FFFC = (int)ChartGetInteger(0, 107, 0);
   Gi_0000 = Li_FFFC - 31;


   Input_Pointer_00000C00.Move(70, Gi_0000);
   Ll_FFF0 = 0;
   if(sparam == Is_0B50)
     {
      X1 = (int)ObjectGetInteger(0, Is_0B50, 102, 0);
      Y1 = (int)ObjectGetInteger(0, Is_0B50, 103, 0);
      if(X1 != Ii_0CF8 || Y1 != Ii_0CFC)
        {

         Ls0_str0000 = (string)X1;
         Input_Pointer_00000068.Update(0, Ls0_str0000);

         Ls0_str0000 = (string)Y1;
         Input_Pointer_00000068.Update(1, Ls0_str0000);

         FUN_1598(2);
         Gi_0008 = Y1;
         Gi_0009 = X1;

         Input_Struct_000000A4[0].Move(Gi_0009, Gi_0008);
         Gi_000A = Y1 + 130;
         Gi_000B = X1 + 5;

         Input_Struct_000000A4[1].Move(Gi_000B, Gi_000A);
         Gi_000B = Y1 + 130;
         Gi_000E = X1 + 85;

         Input_Struct_000000A4[2].Move(Gi_000E, Gi_000B);
         Gi_000E = Y1 + 150;
         Gi_0011 = X1 + 5;

         Input_Struct_000000A4[3].Move(Gi_0011, Gi_000E);
         Gi_0011 = Y1 + 150;
         Gi_0014 = X1 + 85;

         Input_Struct_000000A4[4].Move(Gi_0014, Gi_0011);
         Gi_0014 = Y1 + 35;
         Gi_0017 = X1 + 5;

         Input_Pointer_00000A58.Move(Gi_0017, Gi_0014);
         Gi_0018 = X1 + 5;
         ObjectSetInteger(Ll_FFF0, Is_0B60, 102, Gi_0018);
         Gi_0019 = Y1 + 65;
         ObjectSetInteger(Ll_FFF0, Is_0B60, 103, Gi_0019);
         ObjectSetInteger(Ll_FFF0, Is_0B70, 102, Gi_0018);
         Gi_0019 = Y1 + 83;
         ObjectSetInteger(Ll_FFF0, Is_0B70, 103, Gi_0019);
         Gi_0019 = X1 + 85;
         ObjectSetInteger(Ll_FFF0, Is_0B90, 102, Gi_0019);
         Gi_001A = Y1 + 100;
         ObjectSetInteger(Ll_FFF0, Is_0B90, 103, Gi_001A);
         ObjectSetInteger(Ll_FFF0, Is_0B80, 102, Gi_0018);
         ObjectSetInteger(Ll_FFF0, Is_0B80, 103, Gi_001A);
         ObjectSetInteger(Ll_FFF0, Is_0BB0, 102, Gi_0018);
         Gi_001B = Y1 + 185;
         ObjectSetInteger(Ll_FFF0, Is_0BB0, 103, Gi_001B);
         ObjectSetInteger(Ll_FFF0, Is_0BA0, 102, Gi_0019);
         ObjectSetInteger(Ll_FFF0, Is_0BA0, 103, Gi_001B);
         ObjectSetInteger(Ll_FFF0, Is_0BC0, 102, Gi_0018);
         Gi_001C = Y1 + 215;
         ObjectSetInteger(Ll_FFF0, Is_0BC0, 103, Gi_001C);
        }
     }
   if(sparam == Is_0B80 && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {
      if(fTrBuy)
        {
         fTrBuy = false;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr2);
        }
      else
        {
         fTrBuy = true;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr1);
        }
      Ls0_str0000 = (string)fTrBuy;
      Input_Pointer_00000068.Update(3, Ls0_str0000);
      FUN_1598(2);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   if(sparam == Is_0B90 && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {
      if(fTrSell)
        {
         fTrSell = false;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr2);
        }
      else
        {
         fTrSell = true;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr1);
        }
      Ls0_str0000 = (string)fTrSell;
      Input_Pointer_00000068.Update(4, Ls0_str0000);
      FUN_1598(2);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   if(sparam == Is_0BC0 && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {
      if(fNS)
        {
         fNS = false;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr2);
        }
      else
        {
         fNS = true;
         ObjectSetInteger(Ll_FFF0, sparam, 1025, cTrNSStr1);
        }
      Ls0_str0000 = (string)fNS;
      Input_Pointer_00000068.Update(7, Ls0_str0000);
      FUN_1598(2);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   Ls0_str0000 = Is_0E30 + "Start Hour_3";
   if(sparam == Ls0_str0000)
     {

      Ls0_str0001 = Input_Struct_000000A4[3].Text();
      Li_FFEC = (int)StringToInteger(Ls0_str0001);
      if(Li_FFEC < 0)
        {
         Li_FFEC = 0;
        }
      else
        {
         if(Li_FFEC > 23)
           {
            Li_FFEC = 23;
           }
        }
      Ls0_str0002 = (string)Li_FFEC;
      Input_Struct_000000A4[3].Text(Ls0_str0002);;
      iStart_H = Li_FFEC;
      Ls0_str0002 = (string)Li_FFEC;

      Input_Pointer_00000068.Update(5, Ls0_str0002);
      FUN_1598(2);
     }
   Ls0_str0002 = Is_0E30 + "End Hour_4";
   if(sparam == Ls0_str0002)
     {

      Ls0_str0003 = Input_Struct_000000A4[4].Text();
      Li_FFE8 = (int)StringToInteger(Ls0_str0003);
      if(Li_FFE8 < 0)
        {
         Li_FFE8 = 0;
        }
      else
        {
         if(Li_FFE8 > 24)
           {
            Li_FFE8 = 24;
           }
        }
      Ls0_str0004 = (string)Li_FFE8;
      Input_Struct_000000A4[4].Text(Ls0_str0004);
      iEnd_H = Li_FFE8;
      Ls0_str0004 = (string)Li_FFE8;
      Input_Pointer_00000068.Update(6, Ls0_str0004);
      FUN_1598(2);
     }
   if(sparam == Is_0BE0 && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {

      Ls0_str0005 = Input_Pointer_00000C00.Text();
      returned_double = StringToDouble(Ls0_str0005);
      Ld_FFE0 = returned_double;
      Ls0_str0006 = DoubleToString(returned_double, 2);
      Print("Open manual Buy order, Lot = ", Ls0_str0006);
      FUN_1586(0, Ld_FFE0);
      Sleep(300);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   if(sparam == Is_0BD0 && ObjectGetInteger(0, sparam, 1018, 0) == 1)
     {

      Ls0_str0008 = Input_Pointer_00000C00.Text();
      returned_double = StringToDouble(Ls0_str0008);
      Ld_FFD8 = returned_double;
      Ls0_str0009 = DoubleToString(returned_double, 2);
      Print("Open manual Sell order, Lot = ", Ls0_str0009);
      FUN_1586(1, Ld_FFD8);
      Sleep(300);
      ObjectSetInteger(0, sparam, 1018, 0);
     }
   RefreshRates();
   Ls0_str000A = Is_0BB0;
   if(ObjectGetInteger(0, Ls0_str000A, 1018, 0) == 1)
     {
      Ii_0E80 = 0;
      FUN_1594();
      Sleep(300);
      ObjectSetInteger(0, Ls0_str000A, 1018, 0);
     }
   Ls0_str000A = Is_0BA0;
   if(ObjectGetInteger(0, Ls0_str000A, 1018, 0) != 1)
      return;
   Ii_0E80 = 1;
   FUN_1594();
   Sleep(300);
   ObjectSetInteger(0, Ls0_str000A, 1018, 0);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FUN_lox01(int t)
  {
   double li_4=0;
   int li_8=OrdersTotal();
   for(int li_12=0; li_12<li_8; li_12++)
     {
      int t00=OrderSelect(li_12,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==t)
         li_4=li_4+OrderLots();
     }
   return (li_4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FUN_po01(int t)
  {
   double li_4=0;
   int li_8=OrdersTotal();
   for(int li_12=0; li_12<li_8; li_12++)
     {
      int t00=OrderSelect(li_12,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==t)
         li_4=li_4+OrderProfit()+OrderCommission()+OrderSwap();
     }
   return (li_4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1579()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls0_str0008;
   string Ls0_str0009;
   string Ls0_str000A;
   string Ls0_str000B;
   string Ls0_str000C;
   string Ls0_str000D;
   string Ls0_str000E;
   string Ls0_str000F;
   string Ls0_str0010;
   string Ls0_str0011;
   string Ls0_str0012;
   string Ls0_str0013;
   string Ls0_str0014;
   string Ls0_str0015;
   string Ls0_str0016;
   string Ls0_str0017;
   int Li_FFFC;
   double Ld_FFF0;
   double Ld_FFE8;
   double Ld_FFE0;
   double Ld_FFD8;
   int Li_FF6C;
   double Ld_FF60;
   double Ld_FF58;
   int Li_FF54;
   long Ll_FF48;

   Li_FFFC = 0;
   Ld_FFF0 = 0;
   Ii_0D7C = 0;
   Ii_0D80 = 0;
   ArrayResize(Input_Struct_00000D84, OrdersTotal(), 0);
   ArrayResize(Input_Struct_00000DB8, OrdersTotal(), 0);

   Input_Struct_00000D00.m_0 = 0;
   Input_Struct_00000D00.m_32 = 0;
   Input_Struct_00000D00.m_8 = 0;
   Input_Struct_00000D00.m_40 = 0;
   Input_Struct_00000D00.m_96 = 0;

   Input_Struct_00000D00.m_106 = 1.79769313486232E+308;
   Input_Struct_00000D00.m_114 = 0;
   Li_FFFC = 0;
   if(OrdersTotal() > 0)
     {
      do
        {
         if(OrderSelect(Li_FFFC, 0, 0) && OrderSymbol() == _Symbol)
           {
            if(OrderMagicNumber() == Magic || (OrderMagicNumber() == 0 && fHO))
              {

               if(OrderType() == OP_BUY)
                 {
                  Gl_0000 = OrderOpenTime();
                  if(Gl_0000 >= Time[0] && Il_0FC0 < OrderOpenTime())
                    {
                     Il_0FC0 = OrderOpenTime();
                     Id_0DF0 = 0;
                    }
                 }
               if(OrderType() == OP_SELL)
                 {
                  Gl_0000 = OrderOpenTime();
                  if(Gl_0000 >= Time[0] && Il_0FC8 < OrderOpenTime())
                    {
                     Il_0FC8 = OrderOpenTime();
                     Id_0DF8 = 1.79769313486232E+308;
                    }
                 }
               if(OrderType() == OP_BUY)
                 {
                  if((NormalizeDouble(OrderOpenPrice(), _Digits) < Input_Struct_00000D00.m_106))
                    {
                     Input_Struct_00000D00.m_106 = NormalizeDouble(OrderOpenPrice(), _Digits);
                    }
                  Gd_0000 = OrderProfit();
                  Gd_0000 = (Gd_0000 + OrderCommission());
                  Ld_FFF0 = (Gd_0000 + OrderSwap());
                  Input_Struct_00000D00.m_0 = (Ld_FFF0 + Input_Struct_00000D00.m_0);
                  Input_Struct_00000D00.m_32 = (Input_Struct_00000D00.m_32 + OrderLots());
                  Gi_0000 = OrderTicket();
                  Input_Struct_00000D84[Ii_0D7C].m_40 = Gi_0000;
                  Gi_0000 = OrderType();
                  Input_Struct_00000D84[Ii_0D7C].m_44 = Gi_0000;
                  Input_Struct_00000D84[Ii_0D7C].m_56 = OrderComment();
                  Input_Struct_00000D84[Ii_0D7C].m_16 = OrderTakeProfit();
                  Input_Struct_00000D84[Ii_0D7C].m_0 = NormalizeDouble(OrderOpenPrice(), _Digits);
                  Gl_0007 = OrderOpenTime();
                  Input_Struct_00000D84[Ii_0D7C].m_48 = (datetime)Gl_0007;
                  Input_Struct_00000D84[Ii_0D7C].m_8 = OrderLots();
                  Input_Struct_00000D84[Ii_0D7C].m_32 = OrderStopLoss();
                  Input_Struct_00000D84[Ii_0D7C].m_24 = Ld_FFF0;
                  Ii_0D7C = Ii_0D7C + 1;
                 }
               if(OrderType() == OP_SELL)
                 {
                  if((NormalizeDouble(OrderOpenPrice(), _Digits) > Input_Struct_00000D00.m_114))
                    {
                     Input_Struct_00000D00.m_114 = NormalizeDouble(OrderOpenPrice(), _Digits);
                    }
                  Gd_000B = OrderProfit();
                  Gd_000B = (Gd_000B + OrderCommission());
                  Ld_FFF0 = (Gd_000B + OrderSwap());
                  Input_Struct_00000D00.m_8 = (Ld_FFF0 + Input_Struct_00000D00.m_8);
                  Input_Struct_00000D00.m_40 = (Input_Struct_00000D00.m_40 + OrderLots());
                  Gi_000B = OrderTicket();
                  Input_Struct_00000DB8[Ii_0D80].m_40 = Gi_000B;
                  Gi_000B = OrderType();
                  Input_Struct_00000DB8[Ii_0D80].m_44 = Gi_000B;
                  Input_Struct_00000DB8[Ii_0D80].m_56 = OrderComment();
                  Input_Struct_00000DB8[Ii_0D80].m_16 = OrderTakeProfit();
                  Input_Struct_00000DB8[Ii_0D80].m_0 = NormalizeDouble(OrderOpenPrice(), _Digits);
                  Gl_0010 = OrderOpenTime();
                  Input_Struct_00000DB8[Ii_0D80].m_48 = (datetime)Gl_0010;
                  Input_Struct_00000DB8[Ii_0D80].m_8 = OrderLots();
                  Input_Struct_00000DB8[Ii_0D80].m_32 = OrderStopLoss();
                  Input_Struct_00000DB8[Ii_0D80].m_24 = Ld_FFF0;
                  Ii_0D80 = Ii_0D80 + 1;
                 }
              }
           }
         Li_FFFC = Li_FFFC + 1;
        }
      while(Li_FFFC < OrdersTotal());
     }
   Ld_FFE8 = 0;
   Ld_FFE0 = 0;
   Ld_FFD8 = MarketInfo(_Symbol, MODE_TICKVALUE);
   Gd_0014 = (Input_Struct_00000D00.m_32 - Input_Struct_00000D00.m_40);
   Ld_FFE8 = NormalizeDouble(Gd_0014, 2);
   Ld_FFE0 = NormalizeDouble(Gd_0014, 2);
   RefreshRates();
   if((Input_Struct_00000D00.m_32 > 0) && (Ld_FFD8 > 0))
     {
      Gd_0014 = ((Input_Struct_00000D00.m_0 / (Ld_FFD8 * Input_Struct_00000D00.m_32)) * _Point);
      Input_Struct_00000D00.m_16 = NormalizeDouble((Bid - Gd_0014), _Digits);
     }
   if((Input_Struct_00000D00.m_40 > 0) && (Ld_FFD8 > 0))
     {
      Gd_0014 = -Input_Struct_00000D00.m_40;
      Gd_0014 = ((Input_Struct_00000D00.m_8 / (Ld_FFD8 * Gd_0014)) * _Point);
      Input_Struct_00000D00.m_24 = NormalizeDouble((Ask - Gd_0014), _Digits);
     }
   Li_FFFC = HistoryTotal() - 1;
   if(Li_FFFC >= 0)
     {
      do
        {
         if(OrderSelect(Li_FFFC, 0, 1) && OrderMagicNumber() == Magic && OrderSymbol() == _Symbol)
           {
            if(OrderType() == OP_BUY || OrderType() == OP_SELL)
              {

               Gd_0014 = OrderProfit();
               Gd_0014 = (Gd_0014 + OrderSwap());
               if(((Gd_0014 + OrderCommission()) >= 0))
                  break;
               Input_Struct_00000D00.m_96 = OrderLots();
               break;
              }
           }
         Li_FFFC = Li_FFFC - 1;
        }
      while(Li_FFFC >= 0);
     }
   double Ld_FFA4[];
   double Ld_FF70[];
   Li_FF6C = 0;
   if(Ii_0D7C > 0)
     {
      if(TP != 0)
        {
         Input_Struct_00000D00.m_64 = ((TP * _Point) + Input_Struct_00000D00.m_16);
        }
      if(SL != 0)
        {
         Gd_0015 = (SL * _Point);
         Input_Struct_00000D00.m_48 = (Input_Struct_00000D84[0].m_0 - Gd_0015);
        }
      if(ISTart != 0 &&  ISTart < TP)
        {
         ArrayInitialize(Ld_FFA4, 2147483647);
         Gi_0016 = Ii_0D7C - 1;
         Li_FF6C = CopyHigh(NULL, 0, Input_Struct_00000D84[Gi_0016].m_48, TimeCurrent(), Ld_FFA4);
         if(Li_FF6C < 1)
           {
            Gd_0018 = Close[0];
            if(Gd_0018 <= Id_0DF0)
              {
               Gd_0019 = Id_0DF0;
              }
            else
              {
               Gd_0019 = Gd_0018;
              }
            Id_0DF0 = Gd_0019;
            if((Gd_0019 > ((ISTart * _Point) + Input_Struct_00000D00.m_16)))
              {
               Gd_0018 = (IStop * _Point);
               Input_Struct_00000D00.m_80 = (Gd_0019 - Gd_0018);
               Input_Struct_00000D00.m_104 = true;
              }
            else
              {
               Input_Struct_00000D00.m_80 = ((ISTart * _Point) + Input_Struct_00000D00.m_16);
               Input_Struct_00000D00.m_104 = false;
              }
           }
         if(Li_FF6C > 0)
           {
            Gi_0018 = ArrayMaximum(Ld_FFA4, Li_FF6C, 0);
            Ld_FF60 = Ld_FFA4[Gi_0018];
            if((Ld_FF60 > ((ISTart * _Point) + Input_Struct_00000D00.m_16)))
              {
               Gd_001A = (IStop * _Point);
               Input_Struct_00000D00.m_80 = (Ld_FF60 - Gd_001A);
               Input_Struct_00000D00.m_104 = true;
              }
            else
              {
               Input_Struct_00000D00.m_80 = ((ISTart * _Point) + Input_Struct_00000D00.m_16);
               Input_Struct_00000D00.m_104 = false;
              }
           }
        }
     }
   if(Ii_0D80 > 0)
     {
      if(TP != 0)
        {
         Gd_001A = (TP * _Point);
         Input_Struct_00000D00.m_72 = (Input_Struct_00000D00.m_24 - Gd_001A);
        }
      if(SL != 0)
        {
         Input_Struct_00000D00.m_56 = ((SL * _Point) + Input_Struct_00000DB8[0].m_0);
        }
      if(ISTart != 0 &&  ISTart < TP)
        {
         ArrayInitialize(Ld_FF70, 2147483647);
         Gi_001C = Ii_0D80 - 1;
         Li_FF6C = CopyLow(NULL, 0, Input_Struct_00000DB8[Gi_001C].m_48, TimeCurrent(), Ld_FF70);
         if(Li_FF6C < 1)
           {
            Gd_001E = Close[0];
            if(Gd_001E >= Id_0DF8)
              {
               Gd_001F = Id_0DF8;
              }
            else
              {
               Gd_001F = Gd_001E;
              }
            Id_0DF8 = Gd_001F;
            Gl_001E = SymbolInfoInteger(NULL, SYMBOL_SPREAD);
            Gl_0020 =  ISTart;
            Gl_0020 = Gl_0020 + Gl_001E;
            Gd_0020 = (Gl_0020 * _Point);
            if((Gd_001F < (Input_Struct_00000D00.m_24 - Gd_0020)))
              {
               Input_Struct_00000D00.m_88 = ((IStop * _Point) + Gd_001F);
               Input_Struct_00000D00.m_105 = true;
              }
            else
              {
               Gd_0020 = (ISTart * _Point);
               Input_Struct_00000D00.m_88 = (Input_Struct_00000D00.m_24 - Gd_0020);
               Input_Struct_00000D00.m_105 = false;
              }
           }
         if(Li_FF6C > 0)
           {
            Gi_0020 = ArrayMinimum(Ld_FF70, Li_FF6C, 0);
            Ld_FF58 = Ld_FF70[Gi_0020];
            Gl_0021 = SymbolInfoInteger(NULL, SYMBOL_SPREAD);
            Gl_0022 =  ISTart;
            Gl_0022 = Gl_0022 + Gl_0021;
            Gd_0022 = (Gl_0022 * _Point);
            Gb_0022 = (Ld_FF58 < (Input_Struct_00000D00.m_24 - Gd_0022));
            if((Ld_FF58 > 0) && Gb_0022 != false)
              {
               Input_Struct_00000D00.m_88 = ((IStop * _Point) + Ld_FF58);
               Input_Struct_00000D00.m_105 = true;
              }
            else
              {
               Gd_0022 = (ISTart * _Point);
               Input_Struct_00000D00.m_88 = (Input_Struct_00000D00.m_24 - Gd_0022);
               Input_Struct_00000D00.m_105 = false;
              }
           }
        }
     }
   Li_FF54 = 10;
   Ll_FF48 = iTime(_Symbol, _Period, (WindowFirstVisibleBar() - 2));
   Gb_0022 = false;
   Gi_0023 = Ii_0E28;
   Gi_0024 = 1;
   Ls0_str0000 = Is_0E30 + "FlNoLossBuy";
   Gl_0026 = 0;
   if(ObjectFind(0, Ls0_str0000) == -1 && ObjectCreate(0, Ls0_str0000, OBJ_HLINE, 0, 0, Input_Struct_00000D00.m_16) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0000, 0, 0, Input_Struct_00000D00.m_16);
      ObjectSetInteger(Gl_0026, Ls0_str0000, 6, Gi_0023);
      ObjectSetInteger(Gl_0026, Ls0_str0000, 8, Gi_0024);
      ObjectSetInteger(Gl_0026, Ls0_str0000, 1000, Gb_0022);
     }
   Gb_0027 = false;
   Gi_0028 = Ii_0E28;
   Gi_0029 = 1;
   Ls0_str0001 = Is_0E30 + "FltNoLossSell";
   Gl_002B = 0;
   if(ObjectFind(0, Ls0_str0001) == -1 && ObjectCreate(0, Ls0_str0001, OBJ_HLINE, 0, 0, Input_Struct_00000D00.m_24) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0001, 0, 0, Input_Struct_00000D00.m_24);
      ObjectSetInteger(Gl_002B, Ls0_str0001, 6, Gi_0028);
      ObjectSetInteger(Gl_002B, Ls0_str0001, 8, Gi_0029);
      ObjectSetInteger(Gl_002B, Ls0_str0001, 1000, Gb_0027);
     }
   Gb_002C = false;
   Gi_002D = Ii_0E20;
   Gi_002E = 2;
   Ls0_str0002 = Is_0E30 + "FlTPBuy";
   Gl_0030 = 0;
   if(ObjectFind(0, Ls0_str0002) == -1 && ObjectCreate(0, Ls0_str0002, OBJ_HLINE, 0, 0, Input_Struct_00000D00.m_64) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0002, 0, 0, Input_Struct_00000D00.m_64);
      ObjectSetInteger(Gl_0030, Ls0_str0002, 6, Gi_002D);
      ObjectSetInteger(Gl_0030, Ls0_str0002, 8, Gi_002E);
      ObjectSetInteger(Gl_0030, Ls0_str0002, 1000, Gb_002C);
     }
   Gb_0031 = false;
   Gi_0032 = Ii_0E20;
   Gi_0033 = 2;
   Ls0_str0003 = Is_0E30 + "FlTPSell";
   Gl_0035 = 0;
   if(ObjectFind(0, Ls0_str0003) == -1 && ObjectCreate(0, Ls0_str0003, OBJ_HLINE, 0, 0, Input_Struct_00000D00.m_72) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0003, 0, 0, Input_Struct_00000D00.m_72);
      ObjectSetInteger(Gl_0035, Ls0_str0003, 6, Gi_0032);
      ObjectSetInteger(Gl_0035, Ls0_str0003, 8, Gi_0033);
      ObjectSetInteger(Gl_0035, Ls0_str0003, 1000, Gb_0031);
     }
   Gb_0036 = false;
   Gi_0037 = Ii_0E24;
   Gi_0038 = 2;
   Ls0_str0004 = Is_0E30 + "FlSLBuy";
   Gl_003A = 0;
   if(ObjectFind(0, Ls0_str0004) == -1 && ObjectCreate(0, Ls0_str0004, OBJ_HLINE, 0, 0, Input_Struct_00000D00.m_48) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0004, 0, 0, Input_Struct_00000D00.m_48);
      ObjectSetInteger(Gl_003A, Ls0_str0004, 6, Gi_0037);
      ObjectSetInteger(Gl_003A, Ls0_str0004, 8, Gi_0038);
      ObjectSetInteger(Gl_003A, Ls0_str0004, 1000, Gb_0036);
     }
   Gb_003B = false;
   Gi_003C = Ii_0E24;
   Gi_003D = 2;
   Ls0_str0005 = Is_0E30 + "FlSLSell";
   Gl_003F = 0;
   if(ObjectFind(0, Ls0_str0005) == -1 && ObjectCreate(0, Ls0_str0005, OBJ_HLINE, 0, 0, Input_Struct_00000D00.m_56) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0005, 0, 0, Input_Struct_00000D00.m_56);
      ObjectSetInteger(Gl_003F, Ls0_str0005, 6, Gi_003C);
      ObjectSetInteger(Gl_003F, Ls0_str0005, 8, Gi_003D);
      ObjectSetInteger(Gl_003F, Ls0_str0005, 1000, Gb_003B);
     }
   Gb_0040 = false;
   Gi_0041 = Ii_0E2C;
   Gi_0042 = 1;
   Ls0_str0006 = Is_0E30 + "FlTSBuy";
   Gl_0044 = 0;
   if(ObjectFind(0, Ls0_str0006) == -1 && ObjectCreate(0, Ls0_str0006, OBJ_HLINE, 0, 0, Input_Struct_00000D00.m_80) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0006, 0, 0, Input_Struct_00000D00.m_80);
      ObjectSetInteger(Gl_0044, Ls0_str0006, 6, Gi_0041);
      ObjectSetInteger(Gl_0044, Ls0_str0006, 8, Gi_0042);
      ObjectSetInteger(Gl_0044, Ls0_str0006, 1000, Gb_0040);
     }
   Gb_0045 = false;
   Gi_0046 = Ii_0E2C;
   Gi_0047 = 1;
   Ls0_str0007 = Is_0E30 + "FlTSSell";
   Gl_0049 = 0;
   if(ObjectFind(0, Ls0_str0007) == -1 && ObjectCreate(0, Ls0_str0007, OBJ_HLINE, 0, 0, Input_Struct_00000D00.m_88) == false)
     {
      Print("DrawHLine", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0007, 0, 0, Input_Struct_00000D00.m_88);
      ObjectSetInteger(Gl_0049, Ls0_str0007, 6, Gi_0046);
      ObjectSetInteger(Gl_0049, Ls0_str0007, 8, Gi_0047);
      ObjectSetInteger(Gl_0049, Ls0_str0007, 1000, Gb_0045);
     }
   Gb_004A = false;
   Gi_004B = 0;
   Gi_004C = Ii_0E28;
   Ls0_str0008 = "Breakeven Buy";
   Ls0_str0009 = Is_0E30 + "FlNoLossBuyText";
   Gl_004F = 0;
   if(ObjectFind(0, Ls0_str0009) == -1 && ObjectCreate(0, Ls0_str0009, OBJ_TEXT, 0, Ll_FF48, Input_Struct_00000D00.m_16) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0009, 0, Ll_FF48, Input_Struct_00000D00.m_16);
      ObjectSetInteger(Gl_004F, Ls0_str0009, 6, Gi_004C);
      ObjectSetText(Ls0_str0009, Ls0_str0008, 0, NULL, 4294967295);
      ObjectSetInteger(Gl_004F, Ls0_str0009, 1011, Gi_004B);
      ObjectSetInteger(Gl_004F, Ls0_str0009, 1000, Gb_004A);
     }
   Gb_0050 = false;
   Gi_0051 = 0;
   Gi_0052 = Ii_0E28;
   Ls0_str000A = "Breakeven Sell";
   Ls0_str000B = Is_0E30 + "FlNoLossSellText";
   Gl_0055 = 0;
   if(ObjectFind(0, Ls0_str000B) == -1 && ObjectCreate(0, Ls0_str000B, OBJ_TEXT, 0, Ll_FF48, Input_Struct_00000D00.m_24) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str000B, 0, Ll_FF48, Input_Struct_00000D00.m_24);
      ObjectSetInteger(Gl_0055, Ls0_str000B, 6, Gi_0052);
      ObjectSetText(Ls0_str000B, Ls0_str000A, 0, NULL, 4294967295);
      ObjectSetInteger(Gl_0055, Ls0_str000B, 1011, Gi_0051);
      ObjectSetInteger(Gl_0055, Ls0_str000B, 1000, Gb_0050);
     }
   Gb_0056 = false;
   Gi_0057 = 0;
   Gi_0058 = Ii_0E20;
   Ls0_str000C = "TP Buy";
   Ls0_str000D = Is_0E30 + "FlTPBuyText";
   Gl_005B = 0;
   if(ObjectFind(0, Ls0_str000D) == -1 && ObjectCreate(0, Ls0_str000D, OBJ_TEXT, 0, Ll_FF48, Input_Struct_00000D00.m_64) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str000D, 0, Ll_FF48, Input_Struct_00000D00.m_64);
      ObjectSetInteger(Gl_005B, Ls0_str000D, 6, Gi_0058);
      ObjectSetText(Ls0_str000D, Ls0_str000C, 0, NULL, 4294967295);
      ObjectSetInteger(Gl_005B, Ls0_str000D, 1011, Gi_0057);
      ObjectSetInteger(Gl_005B, Ls0_str000D, 1000, Gb_0056);
     }
   Gb_005C = false;
   Gi_005D = 0;
   Gi_005E = Ii_0E20;
   Ls0_str000E = "TP Sell";
   Ls0_str000F = Is_0E30 + "FlTPSellText";
   Gl_0061 = 0;
   if(ObjectFind(0, Ls0_str000F) == -1 && ObjectCreate(0, Ls0_str000F, OBJ_TEXT, 0, Ll_FF48, Input_Struct_00000D00.m_72) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str000F, 0, Ll_FF48, Input_Struct_00000D00.m_72);
      ObjectSetInteger(Gl_0061, Ls0_str000F, 6, Gi_005E);
      ObjectSetText(Ls0_str000F, Ls0_str000E, 0, NULL, 4294967295);
      ObjectSetInteger(Gl_0061, Ls0_str000F, 1011, Gi_005D);
      ObjectSetInteger(Gl_0061, Ls0_str000F, 1000, Gb_005C);
     }
   Gb_0062 = false;
   Gi_0063 = 0;
   Gi_0064 = Ii_0E24;
   Ls0_str0010 = "SL Buy";
   Ls0_str0011 = Is_0E30 + "FlSLBuyText";
   Gl_0067 = 0;
   if(ObjectFind(0, Ls0_str0011) == -1 && ObjectCreate(0, Ls0_str0011, OBJ_TEXT, 0, Ll_FF48, Input_Struct_00000D00.m_48) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0011, 0, Ll_FF48, Input_Struct_00000D00.m_48);
      ObjectSetInteger(Gl_0067, Ls0_str0011, 6, Gi_0064);
      ObjectSetText(Ls0_str0011, Ls0_str0010, 0, NULL, 4294967295);
      ObjectSetInteger(Gl_0067, Ls0_str0011, 1011, Gi_0063);
      ObjectSetInteger(Gl_0067, Ls0_str0011, 1000, Gb_0062);
     }
   Gb_0068 = false;
   Gi_0069 = 0;
   Gi_006A = Ii_0E24;
   Ls0_str0012 = "SL Sell";
   Ls0_str0013 = Is_0E30 + "FlSLSellText";
   Gl_006D = 0;
   if(ObjectFind(0, Ls0_str0013) == -1 && ObjectCreate(0, Ls0_str0013, OBJ_TEXT, 0, Ll_FF48, Input_Struct_00000D00.m_56) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0013, 0, Ll_FF48, Input_Struct_00000D00.m_56);
      ObjectSetInteger(Gl_006D, Ls0_str0013, 6, Gi_006A);
      ObjectSetText(Ls0_str0013, Ls0_str0012, 0, NULL, 4294967295);
      ObjectSetInteger(Gl_006D, Ls0_str0013, 1011, Gi_0069);
      ObjectSetInteger(Gl_006D, Ls0_str0013, 1000, Gb_0068);
     }
   Gb_006E = false;
   Gi_006F = 0;
   Gi_0070 = Ii_0E2C;
   if(Input_Struct_00000D00.m_104 == true)
     {
      Ls0_str0014 = "Trailing stop buy";
     }
   else
     {
      Ls0_str0014 = "Trailing stop buy start";
     }
   Ls0_str0015 = Is_0E30 + "FlTSBuyText";
   Gl_0073 = 0;
   if(ObjectFind(0, Ls0_str0015) == -1 && ObjectCreate(0, Ls0_str0015, OBJ_TEXT, 0, Ll_FF48, Input_Struct_00000D00.m_80) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0015, 0, Ll_FF48, Input_Struct_00000D00.m_80);
      ObjectSetInteger(Gl_0073, Ls0_str0015, 6, Gi_0070);
      ObjectSetText(Ls0_str0015, Ls0_str0014, 0, NULL, 4294967295);
      ObjectSetInteger(Gl_0073, Ls0_str0015, 1011, Gi_006F);
      ObjectSetInteger(Gl_0073, Ls0_str0015, 1000, Gb_006E);
     }
   Gb_0074 = false;
   Gi_0075 = 0;
   Gi_0076 = Ii_0E2C;
   if(Input_Struct_00000D00.m_105 == true)
     {
      Ls0_str0016 = "Trailing stop sell";
     }
   else
     {
      Ls0_str0016 = "Trailing stop sell start";
     }
   Ls0_str0017 = Is_0E30 + "FlTSSellText";
   Gl_0079 = 0;
   if(ObjectFind(0, Ls0_str0017) == -1 && ObjectCreate(0, Ls0_str0017, OBJ_TEXT, 0, Ll_FF48, Input_Struct_00000D00.m_88) == false)
     {
      Print("DrawText", "Error: ", GetLastError());
     }
   else
     {
      ObjectMove(0, Ls0_str0017, 0, Ll_FF48, Input_Struct_00000D00.m_88);
      ObjectSetInteger(Gl_0079, Ls0_str0017, 6, Gi_0076);
      ObjectSetText(Ls0_str0017, Ls0_str0016, 0, NULL, 4294967295);
      ObjectSetInteger(Gl_0079, Ls0_str0017, 1011, Gi_0075);
      ObjectSetInteger(Gl_0079, Ls0_str0017, 1000, Gb_0074);
     }
   ArrayFree(Ld_FF70);
   ArrayFree(Ld_FFA4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FUN_052526(double ss,double bb,int Count)
  {

   double tLots=0;
//   if(Count<=5)
//  Count=1;
// else
//  Count=Count-5;
   tLots=NormalizeDouble(ss*MathPow(bb,Count),2);
   if(tLots>=dML)
      tLots=dML;
   return (tLots);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1580()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls0_str0008;
   string Ls0_str0009;
   string Ls0_str000A;
   string Ls0_str000B;
   string Ls0_str000C;
   string Ls0_str000D;
   string Ls0_str000E;
   string Ls0_str000F;
   double Ld_FFF8;
   int Li_FFF4;
   bool Lb_FFF3;
   double Ld_FFE8;
   int Li_FFE4;
   double Ld_FFD8;
   string Ls_FFC8;
   string Ls_FFB8;
   bool Lb_FFB7;
   string Ls_FFA8;
   string Ls_FF98;
   string Ls_FF88;
   string Ls_FF78;
   string Ls_FF68;
   string Ls_FF58;

   Ld_FFF8 = 0;
   Li_FFF4 = 0;
   Lb_FFF3 = true;
   if(iMaxS != 0)
     {
      Gl_0000 = SymbolInfoInteger(NULL, SYMBOL_SPREAD);
      Gl_0001 = iMaxS;
      if(Gl_0000 > Gl_0001)
        {
         Lb_FFF3 = false;
        }
     }
   Ld_FFE8 = 0;
   Li_FFE4 = -1;
   Ld_FFD8 = -1;
   if(Ib_0E64 && Ii_0D7C == 0 && Ii_0D80 != 0)
     {
      Gd_0002 = fabs((Input_Struct_00000DB8[0].m_0 - Ask));
      if((Gd_0002 > (iDist * _Point)))
        {

         Ld_FFE8 = 0;
         Li_FFF4 = 0;
         if(Ii_0D80 > 0)
           {
            do
              {
               if(Input_Struct_00000DB8[Li_FFF4].m_40 != 0)
                 {
                  Ld_FFE8 = (Ld_FFE8 + Input_Struct_00000DB8[Li_FFF4].m_24);
                  Ld_FFD8 = FUN_1591(Input_Struct_00000DB8[Li_FFF4].m_40);
                  Li_FFE4 = Input_Struct_00000DB8[Li_FFF4].m_44;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     FUN_1599(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < Ii_0D80);
           }
         if(fDraw)
           {
            Ls0_str0000 = Is_0E30 + "Rez_";
            Ls0_str0001 = (string)TimeCurrent();
            Ls0_str0000 = Ls0_str0000 + Ls0_str0001;
            Ls_FFC8 = Ls0_str0000;
            Ls0_str0001 = "$" + DoubleToString(Ld_FFE8, 2);
            FUN_1600(Ls0_str0000, Time[0], Ld_FFD8, Ls0_str0001, Color_Fon_Metki, Li_FFE4);
           }
         FUN_1579();
        }
      else
        {
         Ib_0E64 = false;

        }
     }
   if(Ib_0E65 && Ii_0D80 == 0 && Ii_0D7C != 0)
     {
      Gd_0008 = fabs((Input_Struct_00000D84[0].m_0 - Bid));
      if((Gd_0008 > (iDist * _Point)))
        {

         Ld_FFE8 = 0;
         Li_FFF4 = 0;
         if(Ii_0D7C > 0)
           {
            do
              {
               if(Input_Struct_00000D84[Li_FFF4].m_40 != 0)
                 {
                  Ld_FFE8 = (Ld_FFE8 + Input_Struct_00000D84[Li_FFF4].m_24);
                  Ld_FFD8 = FUN_1591(Input_Struct_00000D84[Li_FFF4].m_40);
                  Li_FFE4 = Input_Struct_00000D84[Li_FFF4].m_44;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     FUN_1599(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < Ii_0D7C);
           }
         if(fDraw)
           {
            Ls0_str0002 = Is_0E30 + "Rez_";
            Ls0_str0003 = (string)TimeCurrent();
            Ls0_str0002 = Ls0_str0002 + Ls0_str0003;
            Ls_FFB8 = Ls0_str0002;
            Ls0_str0003 = "$" + DoubleToString(Ld_FFE8, 2);
            FUN_1600(Ls0_str0002, Time[0], Ld_FFD8, Ls0_str0003, Color_Fon_Metki, Li_FFE4);
           }
         FUN_1579();
        }
      else
        {

         Ib_0E65 = false;
        }
     }
   if(Ii_0D7C != 0)
     {
      Ib_0E64 = false;
     }
   if(Ii_0D80 != 0)
     {
      Ib_0E65 = false;
     }
   Lb_FFB7 = true;
   if(iStart_H != 0 && iEnd_H != 0)
     {
      if(iStart_H < iEnd_H)
        {
         if(Hour() < iStart_H || Hour() >= iEnd_H)
           {

            Lb_FFB7 = false;
           }
        }
      if(iStart_H > iEnd_H && Hour() < iStart_H && Hour() >= iEnd_H)
        {
         Lb_FFB7 = false;
        }
     }

   Ib_0E64 = 0;

   Ib_0E65 = 0;

   Gd_0002 = iCustom(NULL, TF, "::Indicators\\Gold trading_code.ex4", Ib_0E1C, Deviation, Ib_0E1D, 0, 1);
   Gd_0003 = iCustom(NULL, TF, "::Indicators\\Gold trading_code.ex4", Ib_0E1C, Deviation, Ib_0E1D, 1, 1);
   if((Gd_0002 != EMPTY_VALUE))
     {

      Ib_0E64 = true;

     }
   if((Gd_0003 != EMPTY_VALUE))
     {


      Ib_0E65 = true;


     }


   if(fTrBuy && Ib_0E64 && Ii_0D7C == 0 && Lb_FFB7 && Lb_FFF3 && fNS && Ii_0D80 == 0)
     {
      if((Input_Struct_00000D00.m_96 != 0))
        {
         Ld_FFF8 = (Input_Struct_00000D00.m_96 * MM);
        }
      else
        {
         Ld_FFF8 = dVol;
         if(fA_MM)
           {
            Ld_FFF8 = ((AccountFreeMargin() / iAuLot) * 0.01);
           }
        }
      if((Ld_FFF8 > dML))
        {
         Ld_FFF8 = dML;
        }



        {

         if(FUN_COit0252(1)==0)
           {

            //  FUN_de02352(OP_SELLSTOP);

            //   int      Ld_FFF802 =   OrderSend(_Symbol, OP_SELLSTOP, dVol, Bid-  50*Point, Ii_0E60, 0, 0, sPosComm+"SELL0", Magic, 0, 255);

           }

        }

      Id_0DF0 = 0;
     }

   if(Ib_0E64 ==true)
      if(FUN_COit0252(0)==0)
         FUN_1586(0, dVol);

   if(Ib_0E64 ==true)
      FUN_1586g(0, FUN_052526(dVol,MM,FUN_COit0252(0)));
   else
      FUN_de02352(OP_BUYSTOP);


   if(fTrSell && Ib_0E65 && Ii_0D80 == 0 && Lb_FFB7 && Lb_FFF3 && fNS && Ii_0D7C == 0)
     {
      if((Input_Struct_00000D00.m_96 != 0))
        {
         Ld_FFF8 = (Input_Struct_00000D00.m_96 * MM);
        }
      else
        {
         Ld_FFF8 = dVol;
         if(fA_MM)
           {
            Ld_FFF8 = ((AccountFreeMargin() / iAuLot) * 0.01);
           }
        }
      if((Ld_FFF8 > dML))
        {
         Ld_FFF8 = dML;
        }

        {




         if(FUN_COit0252(0)==0)
           {

            //   FUN_de02352(OP_BUYSTOP);
            //    int      Ld_FFF802  = OrderSend(_Symbol, OP_BUYSTOP, dVol, Ask+ 50*Point, Ii_0E60, 0, 0, sPosComm+"Buy0", Magic, 0, 255);

           }

        }


      Id_0DF8 = 1.79769313486232E+308;
     }

   if(Ib_0E65 ==true)
      if(FUN_COit0252(1)==0)
         FUN_1586(1, dVol);
   if(Ib_0E65 ==true)
      FUN_1586g(1, FUN_052526(dVol,MM,FUN_COit0252(1)));
   else
      FUN_de02352(OP_SELLSTOP);
   if(Input_Struct_00000D00.m_104 && (Bid <= Input_Struct_00000D00.m_80))
     {
      Gd_000D = (_Point * 100);
      if((Bid > (Input_Struct_00000D00.m_80 - Gd_000D)))
        {
         Ld_FFE8 = 0;
         Li_FFF4 = 0;
         if(Ii_0D7C > 0)
           {
            do
              {
               if(Input_Struct_00000D84[Li_FFF4].m_40 != 0)
                 {
                  Print("Close Position ts, tf: ", Input_Struct_00000D00.m_104, " ts: ", Input_Struct_00000D00.m_80, " OpenPrice: ", Input_Struct_00000D84[Li_FFF4].m_0, " Bid: ", Bid, " LastTime: ", Input_Struct_00000D84[Li_FFF4].m_48);
                  Ld_FFE8 = (Ld_FFE8 + Input_Struct_00000D84[Li_FFF4].m_24);
                  Ld_FFD8 = FUN_1591(Input_Struct_00000D84[Li_FFF4].m_40);
                  Li_FFE4 = Input_Struct_00000D84[Li_FFF4].m_44;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     FUN_1599(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < Ii_0D7C);
           }
         if(fDraw)
           {
            Ls0_str0004 = Is_0E30 + "Rez_";
            Ls0_str0005 = (string)TimeCurrent();
            Ls0_str0004 = Ls0_str0004 + Ls0_str0005;
            Ls_FFA8 = Ls0_str0004;
            Ls0_str0005 = "$" + DoubleToString(Ld_FFE8, 2);
            FUN_1600(Ls0_str0004, Time[0], Ld_FFD8, Ls0_str0005, Color_Fon_Metki, Li_FFE4);
           }
        }
     }
   if(Il_0E88 != Time[0])
     {
      Ld_FFE8 = 0;
      if(Ii_0E04 == 1)
        {
         Il_0E88 = Time[0];
        }
      if((Input_Struct_00000D00.m_64 != 0) && (Bid >= Input_Struct_00000D00.m_64))
        {
         Li_FFF4 = 0;
         if(Ii_0D7C > 0)
           {
            do
              {
               if(Input_Struct_00000D84[Li_FFF4].m_40 != 0)
                 {
                  Ld_FFE8 = (Ld_FFE8 + Input_Struct_00000D84[Li_FFF4].m_24);
                  Ld_FFD8 = FUN_1591(Input_Struct_00000D84[Li_FFF4].m_40);
                  Li_FFE4 = Input_Struct_00000D84[Li_FFF4].m_44;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     FUN_1599(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < Ii_0D7C);
           }
         if(fDraw)
           {
            Ls0_str0006 = Is_0E30 + "Rez_";
            Ls0_str0007 = (string)TimeCurrent();
            Ls0_str0006 = Ls0_str0006 + Ls0_str0007;
            Ls_FF98 = Ls0_str0006;
            Ls0_str0007 = "$" + DoubleToString(Ld_FFE8, 2);
            FUN_1600(Ls0_str0006, Time[0], Ld_FFD8, Ls0_str0007, Color_Fon_Metki, Li_FFE4);
           }
        }
      if((Input_Struct_00000D00.m_72 != 0) && (Ask <= Input_Struct_00000D00.m_72))
        {
         Li_FFF4 = 0;
         if(Ii_0D80 > 0)
           {
            do
              {
               if(Input_Struct_00000DB8[Li_FFF4].m_40 != 0)
                 {
                  Print("Close Position tp, tp: ", Input_Struct_00000D00.m_72, " OpenPrice: ", Input_Struct_00000DB8[Li_FFF4].m_0, " Bid: ", Bid);
                  Ld_FFE8 = (Ld_FFE8 + Input_Struct_00000DB8[Li_FFF4].m_24);
                  Ld_FFD8 = FUN_1591(Input_Struct_00000DB8[Li_FFF4].m_40);
                  Li_FFE4 = Input_Struct_00000DB8[Li_FFF4].m_44;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     FUN_1599(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < Ii_0D80);
           }
         if(fDraw)
           {
            Ls0_str0008 = Is_0E30 + "Rez_";
            Ls0_str0009 = (string)TimeCurrent();
            Ls0_str0008 = Ls0_str0008 + Ls0_str0009;
            Ls_FF88 = Ls0_str0008;
            Ls0_str0009 = "$" + DoubleToString(Ld_FFE8, 2);
            FUN_1600(Ls0_str0008, Time[0], Ld_FFD8, Ls0_str0009, Color_Fon_Metki, Li_FFE4);
           }
        }
     }
   if(Il_0E90 != Time[0])
     {
      Ld_FFE8 = 0;
      if(Ii_0E08 == 1)
        {
         Il_0E90 = Time[0];
        }
      if((Input_Struct_00000D00.m_48 != 0) && (Bid <= Input_Struct_00000D00.m_48))
        {
         Li_FFF4 = 0;
         if(Ii_0D7C > 0)
           {
            do
              {
               if(Input_Struct_00000D84[Li_FFF4].m_40 != 0)
                 {
                  Print("Close Position sl, sl: ", Input_Struct_00000D00.m_48, " OpenPrice: ", Input_Struct_00000D84[Li_FFF4].m_0, " Bid: ", Bid);
                  Ld_FFE8 = (Ld_FFE8 + Input_Struct_00000D84[Li_FFF4].m_24);
                  Ld_FFD8 = FUN_1591(Input_Struct_00000D84[Li_FFF4].m_40);
                  Li_FFE4 = Input_Struct_00000D84[Li_FFF4].m_44;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     FUN_1599(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < Ii_0D7C);
           }
         if(fDraw)
           {
            Ls0_str000A = Is_0E30 + "Rez_";
            Ls0_str000B = (string)TimeCurrent();
            Ls0_str000A = Ls0_str000A + Ls0_str000B;
            Ls_FF78 = Ls0_str000A;
            Ls0_str000B = "$" + DoubleToString(Ld_FFE8, 2);
            FUN_1600(Ls0_str000A, Time[0], Ld_FFD8, Ls0_str000B, Color_Fon_Metki, Li_FFE4);
           }
        }
      if((Input_Struct_00000D00.m_56 != 0) && (Ask >= Input_Struct_00000D00.m_56))
        {
         Li_FFF4 = 0;
         if(Ii_0D80 > 0)
           {
            do
              {
               if(Input_Struct_00000DB8[Li_FFF4].m_40 != 0)
                 {
                  Print("Close Position sl, sl: ", Input_Struct_00000D00.m_56, " OpenPrice: ", Input_Struct_00000DB8[Li_FFF4].m_0, " Bid: ", Bid);
                  Ld_FFE8 = (Ld_FFE8 + Input_Struct_00000DB8[Li_FFF4].m_24);
                  Ld_FFD8 = FUN_1591(Input_Struct_00000DB8[Li_FFF4].m_40);
                  Li_FFE4 = Input_Struct_00000DB8[Li_FFF4].m_44;
                  if((Ld_FFD8 != -1) && fDraw)
                    {
                     FUN_1599(Ld_FFD8);
                    }
                 }
               Li_FFF4 = Li_FFF4 + 1;
              }
            while(Li_FFF4 < Ii_0D80);
           }
         if(fDraw)
           {
            Ls0_str000C = Is_0E30 + "Rez_";
            Ls0_str000D = (string)TimeCurrent();
            Ls0_str000C = Ls0_str000C + Ls0_str000D;
            Ls_FF68 = Ls0_str000C;
            Ls0_str000D = "$" + DoubleToString(Ld_FFE8, 2);
            FUN_1600(Ls0_str000C, Time[0], Ld_FFD8, Ls0_str000D, Color_Fon_Metki, Li_FFE4);
           }
        }
     }
   if(Input_Struct_00000D00.m_105 == false)
      return;
   if((Ask < Input_Struct_00000D00.m_88))
      return;
   if((Ask >= ((_Point * 100) + Input_Struct_00000D00.m_88)))
      return;
   Ld_FFE8 = 0;
   Li_FFF4 = 0;
   if(Ii_0D80 > 0)
     {
      do
        {
         if(Input_Struct_00000DB8[Li_FFF4].m_40 != 0)
           {
            Print("Close Position ts, tf: ", Input_Struct_00000D00.m_105, " ts: ", Input_Struct_00000D00.m_88, "  OpenPrice: ", Input_Struct_00000DB8[Li_FFF4].m_0, " Bid: ", Bid, " LastTime: ", Input_Struct_00000DB8[Li_FFF4].m_48);
            Ld_FFE8 = (Ld_FFE8 + Input_Struct_00000DB8[Li_FFF4].m_24);
            Ld_FFD8 = FUN_1591(Input_Struct_00000DB8[Li_FFF4].m_40);
            Li_FFE4 = Input_Struct_00000DB8[Li_FFF4].m_44;
            if((Ld_FFD8 != -1) && fDraw)
              {
               FUN_1599(Ld_FFD8);
              }
           }
         Li_FFF4 = Li_FFF4 + 1;
        }
      while(Li_FFF4 < Ii_0D80);
     }
   if(fDraw == false)
      return;
   Ls0_str000E = Is_0E30 + "Rez_";
   Ls0_str000F = (string)TimeCurrent();
   Ls0_str000E = Ls0_str000E + Ls0_str000F;
   Ls_FF58 = Ls0_str000E;
   Ls0_str000F = "$" + DoubleToString(Ld_FFE8, 2);
   FUN_1600(Ls0_str000E, Time[0], Ld_FFD8, Ls0_str000F, Color_Fon_Metki, Li_FFE4);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1586(int Fa_i_00, double Fa_d_01)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   int Li_FFFC;
   double Ld_FFF0;
   double Ld_FFE8;
   int Li_FFE4;
   int Li_FFE0;
   int Li_FFDC;
   int Li_FFD8;
   int Li_FFD4;

   if(!IsTradeAllowed())
      return;
   Gi_0000 = (int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   Gi_0001 = Gi_0000;
   if(Gi_0000 == 0)
     {
      Gb_0000 = true;
     }
   else
     {
      Gb_0002 = (OrdersTotal() < Gi_0001);
      Gb_0000 = Gb_0002;
     }
   if(Gb_0000 == false)
      return;
   Li_FFFC = 0;
   Ld_FFF0 = Fa_d_01;
   if((Fa_d_01 < MarketInfo(_Symbol, MODE_MINLOT)))
     {
      Ld_FFF0 = MarketInfo(_Symbol, MODE_MINLOT);
      Print("Lot less than the minimum. Order will open with minimum lot");
     }
   if((Ld_FFF0 > MarketInfo(_Symbol, MODE_MAXLOT)))
     {
      Ld_FFF0 = MarketInfo(_Symbol, MODE_MAXLOT);
      Print("Lot more than the maximum. Order opens maximum lot");
     }
   returned_double = SymbolInfoDouble(NULL, 36);
   Ld_FFE8 = returned_double;
   if(Ld_FFE8 == 0)
      return;
   Gd_0002 = round((Ld_FFF0 / returned_double));
   Li_FFE4 = (int)Gd_0002;
   if(Li_FFE4 == 0)
     {
      Li_FFE4 = 1;
     }
   Ld_FFF0 = (Li_FFE4 * Ld_FFE8);
   if(Ib_0E00)
     {
      Print("----- В олпен ордер прийшов Ask: ", Ask, "  Bid = ", Bid);
     }
   Li_FFE0 = 0;
   Li_FFDC = 1;
   do
     {
      RefreshRates();
      if(Fa_i_00 == 0)
        {
         Gd_0002 = AccountFreeMargin();
         Gd_0003 = ((MarketInfo(_Symbol, MODE_MARGINREQUIRED) * Ld_FFF0) * Id_0E70);
         if(AccountFreeMarginCheck(_Symbol, Fa_i_00, Ld_FFF0) < 0
            || ((Gd_0002 - Gd_0003) < 0))
           {

            if(Il_0E98 != Time[0])
              {
               Print("Not enouth money to open position");
              }
            Il_0E98 = Time[0];
            return ;
           }
         if(Ld_FFF0==dVol)
            Li_FFE0 = OrderSend(_Symbol, Fa_i_00, Ld_FFF0, Ask, Ii_0E60, 0, 0, sPosComm+"Buy", Magic, 0, 16711680);
         else
            Li_FFE0 = OrderSend(_Symbol, Fa_i_00, Ld_FFF0, Ask, Ii_0E60, 0, 0, sPosComm+DoubleToStr(Ask+iDist*Point*2,Digits), Magic, 0, 16711680);
         if(Li_FFE0 == -1)
           {
            Print(923, "  ERR open Buy Order. Err: ", GetLastError());
           }
        }
      else
        {
         if(Fa_i_00 == 1)
           {
            Gd_0005 = AccountFreeMargin();
            Gd_0006 = ((MarketInfo(_Symbol, MODE_MARGINREQUIRED) * Ld_FFF0) * Id_0E78);
            if(AccountFreeMarginCheck(_Symbol, Fa_i_00, Ld_FFF0) < 0
               || ((Gd_0005 - Gd_0006) < 0))
              {

               if(Il_0E98 != Time[0])
                 {
                  Print("Not enouth money to open position");
                 }
               Il_0E98 = Time[0];
               return ;
              }
            if(Ld_FFF0==dVol)
               Li_FFE0 = OrderSend(_Symbol, Fa_i_00, Ld_FFF0, Bid, Ii_0E60, 0, 0, sPosComm+"Sell", Magic, 0, 255);

            else
               Li_FFE0 = OrderSend(_Symbol, Fa_i_00, Ld_FFF0, Bid, Ii_0E60, 0, 0, sPosComm+DoubleToStr(Ask-iDist*Point*2,Digits), Magic, 0, 255);

            if(Li_FFE0 == -1)
              {
               Print(938, "  ERR open Sell Order. Err: ", GetLastError());
              }
           }
        }
      if(Li_FFE0 > 0)
        {
         if(Ib_0E00 == false)
            return;
         Print("---- Order #", Li_FFE0, " open. lot: ", Ld_FFF0, " type: ", Fa_i_00, " CountTry = ", Li_FFDC, " Ask = ", Ask, " Bid = ", Bid);
         Print("----  GetInfo.LastOrderBuyPrice = ", Input_Struct_00000D00.m_106, " GetInfo.LastOrderSellPrice = ", Input_Struct_00000D00.m_114, " iDist = ", iDist);
         if(Fa_i_00 == 0)
           {
            Li_FFD8 = 0;
            if(Ii_0D7C > 0)
              {
               do
                 {
                  Ls0_str0000 = TimeToString(Input_Struct_00000D84[Li_FFD8].m_48, 7);
                  Print(" Tic Buy = ", Input_Struct_00000D84[Li_FFD8].m_40, " OpPr = ", Input_Struct_00000D84[Li_FFD8].m_0, " OpTim = ", Ls0_str0000);
                  Li_FFD8 = Li_FFD8 + 1;
                 }
               while(Li_FFD8 < Ii_0D7C);
              }
           }
         if(Fa_i_00 == 1)
           {
            Li_FFD4 = 0;
            if(Ii_0D80 > 0)
              {
               do
                 {
                  Ls0_str0001 = TimeToString(Input_Struct_00000DB8[Li_FFD4].m_48, 7);
                  Print(" Tic Sell = ", Input_Struct_00000DB8[Li_FFD4].m_40, " OpPr = ", Input_Struct_00000DB8[Li_FFD4].m_0, " OpTim = ", Ls0_str0001);
                  Li_FFD4 = Li_FFD4 + 1;
                 }
               while(Li_FFD4 < Ii_0D80);
              }
           }
         Print("==========");
         return ;
        }
      Gi_0010 = GetLastError();
      Li_FFFC = Gi_0010;
      if(Il_0FD8 != Time[0])
        {
         Il_0FD8 = Time[0];
         returned_i = Gi_0010;
         if(returned_i >= 2 && returned_i <= 149)
           {

            if(returned_i == 2)
              {

               Alert("Total mistake");
               return ;
              }
            if(returned_i == 3)
              {

               Alert("Wrong trading parameters");
               return ;
              }
            if(returned_i == 4)
              {

               Sleep(60000);
              }
            if(returned_i == 5)
              {

               Alert("The client terminal is out of date");
               return ;
              }
            if(returned_i == 6)
              {

               Sleep(5000);
              }
            if(returned_i == 8)
              {

               Alert("Too frequent queries");
               return ;
              }
            if(returned_i == 64)
              {

               Alert("Account is blocked");
               return ;
              }
            if(returned_i == 65)
              {

               Alert("Wrong account number");
               return ;
              }
            if(returned_i == 128)
              {

               Sleep(60000);
              }
            if(returned_i == 129)
              {

               Sleep(5000);
              }
            if(returned_i == 130)
              {

               Sleep(1000);
              }
            if(returned_i == 131)
              {

               Alert("Wrong Lots");
               return ;
              }
            if(returned_i == 132)
              {

               Alert("Market Close");
               return ;
              }
            if(returned_i == 133)
              {

               Alert("trade is disabled");
               return ;
              }
            if(returned_i == 134)
              {

               Alert("Not enough money");
               return ;
              }
            if(returned_i == 135)
              {

              }
            if(returned_i == 136)
              {

               Sleep(1000);
              }
            if(returned_i == 138)
              {

              }
            if(returned_i == 139)
              {

               return ;
              }
            if(returned_i == 140)
              {

               Alert("Allowed only buying");
               return ;
              }
            if(returned_i == 141)
              {

               Alert("Too many requests");
               return ;
              }
            if(returned_i == 142)
              {

               Sleep(60000);
              }
            if(returned_i == 143)
              {

               Sleep(60000);
              }
            if(returned_i == 144)
              {

               Alert("Order canceled customer");
               return ;
              }
            if(returned_i == 146)
              {

               if(IsTradeContextBusy())
                 {
                  do
                    {
                    }
                  while(IsTradeContextBusy());
                 }
              }
            if(returned_i == 148)
              {

               Alert("Too many orders");
               return ;
              }
            if(returned_i == 149)
              {

               Alert("hedging is disabled");
               return ;
              }
           }
        }
      Li_FFDC = Li_FFDC + 1;
     }
   while(Li_FFDC < 6);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FUN_COit0252(int t)
  {
   bool b=0;
   int li_4 = 0;
   int li_8 = OrdersTotal();
   for(int li_12=0; li_12<li_8; li_12++)
     {
      b=OrderSelect(li_12,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==t)
         li_4++;
     }
   return (li_4);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1586g(int Fa_i_00, double Fa_d_01)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   int Li_FFFC;
   double Ld_FFF0;
   double Ld_FFE8;
   int Li_FFE4;
   int Li_FFE0;
   int Li_FFDC;
   int Li_FFD8;
   int Li_FFD4;

   if(!IsTradeAllowed())
      return;
   Gi_0000 = (int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   Gi_0001 = Gi_0000;
   if(Gi_0000 == 0)
     {
      Gb_0000 = true;
     }
   else
     {
      Gb_0002 = (OrdersTotal() < Gi_0001);
      Gb_0000 = Gb_0002;
     }
   if(Gb_0000 == false)
      return;
   Li_FFFC = 0;
   Ld_FFF0 = Fa_d_01;
   if((Fa_d_01 < MarketInfo(_Symbol, MODE_MINLOT)))
     {
      Ld_FFF0 = MarketInfo(_Symbol, MODE_MINLOT);
      Print("Lot less than the minimum. Order will open with minimum lot");
     }
   if((Ld_FFF0 > MarketInfo(_Symbol, MODE_MAXLOT)))
     {
      Ld_FFF0 = MarketInfo(_Symbol, MODE_MAXLOT);
      Print("Lot more than the maximum. Order opens maximum lot");
     }
   returned_double = SymbolInfoDouble(NULL, 36);
   Ld_FFE8 = returned_double;
   if(Ld_FFE8 == 0)
      return;
   Gd_0002 = round((Ld_FFF0 / returned_double));
   Li_FFE4 = (int)Gd_0002;
   if(Li_FFE4 == 0)
     {
      Li_FFE4 = 1;
     }
   Ld_FFF0 = (Li_FFE4 * Ld_FFE8);
   if(Ib_0E00)
     {
      Print("----- В олпен ордер прийшов Ask: ", Ask, "  Bid = ", Bid);
     }
   Li_FFE0 = 0;
   Li_FFDC = 1;
   do
     {
      RefreshRates();
      if(Fa_i_00 == 0)
         if(FUN_COit0252(OP_BUYSTOP)==0)
            if(FUN_COit0252(0)>0)
               if(FUN_COit0252(0)<最大加仓次数)
                 {
                  Gd_0002 = AccountFreeMargin();
                  Gd_0003 = ((MarketInfo(_Symbol, MODE_MARGINREQUIRED) * Ld_FFF0) * Id_0E70);
                  if(AccountFreeMarginCheck(_Symbol, Fa_i_00, Ld_FFF0) < 0
                     || ((Gd_0002 - Gd_0003) < 0))
                    {

                     if(Il_0E98 != Time[0])
                       {
                        Print("Not enouth money to open position");
                       }
                     Il_0E98 = Time[0];
                     return ;
                    }
                  if(A_125250())
                     Li_FFE0 = OrderSend(_Symbol, OP_BUYSTOP, Ld_FFF0, Ask+iDist*Point, Ii_0E60, 0, 0, sPosComm+DoubleToStr(Ask+iDist*Point*2,Digits), Magic, 0, clrNONE);
                  if(Li_FFE0 == -1)
                    {
                     // Print(923, "  ERR open Buy Order. Err: ", GetLastError());
                    }
                 }

        {
         if(Fa_i_00 == 1)
            if(FUN_COit0252(OP_SELLSTOP)==0)
               if(FUN_COit0252(1)>0)
                  if(FUN_COit0252(0)<最大加仓次数)
                    {
                     Gd_0005 = AccountFreeMargin();
                     Gd_0006 = ((MarketInfo(_Symbol, MODE_MARGINREQUIRED) * Ld_FFF0) * Id_0E78);
                     if(AccountFreeMarginCheck(_Symbol, Fa_i_00, Ld_FFF0) < 0
                        || ((Gd_0005 - Gd_0006) < 0))
                       {

                        if(Il_0E98 != Time[0])
                          {
                           Print("Not enouth money to open position");
                          }
                        Il_0E98 = Time[0];
                        return ;
                       }
                     if(A_125250a())
                        Li_FFE0 = OrderSend(_Symbol, OP_SELLSTOP, Ld_FFF0, Bid-iDist*Point, Ii_0E60, 0, 0, sPosComm+DoubleToStr(Bid-iDist*Point*2,Digits), Magic, 0, clrNONE);
                     if(Li_FFE0 == -1)
                       {
                        Print(938, "  ERR open Sell Order. Err: ", GetLastError());
                       }
                    }
        }
      if(Li_FFE0 > 0)
        {
         if(Ib_0E00 == false)
            return;
         Print("---- Order #", Li_FFE0, " open. lot: ", Ld_FFF0, " type: ", Fa_i_00, " CountTry = ", Li_FFDC, " Ask = ", Ask, " Bid = ", Bid);
         Print("----  GetInfo.LastOrderBuyPrice = ", Input_Struct_00000D00.m_106, " GetInfo.LastOrderSellPrice = ", Input_Struct_00000D00.m_114, " iDist = ", iDist);
         if(Fa_i_00 == 0)
           {
            Li_FFD8 = 0;
            if(Ii_0D7C > 0)
              {
               do
                 {
                  Ls0_str0000 = TimeToString(Input_Struct_00000D84[Li_FFD8].m_48, 7);
                  Print(" Tic Buy = ", Input_Struct_00000D84[Li_FFD8].m_40, " OpPr = ", Input_Struct_00000D84[Li_FFD8].m_0, " OpTim = ", Ls0_str0000);
                  Li_FFD8 = Li_FFD8 + 1;
                 }
               while(Li_FFD8 < Ii_0D7C);
              }
           }
         if(Fa_i_00 == 1)
           {
            Li_FFD4 = 0;
            if(Ii_0D80 > 0)
              {
               do
                 {
                  Ls0_str0001 = TimeToString(Input_Struct_00000DB8[Li_FFD4].m_48, 7);
                  Print(" Tic Sell = ", Input_Struct_00000DB8[Li_FFD4].m_40, " OpPr = ", Input_Struct_00000DB8[Li_FFD4].m_0, " OpTim = ", Ls0_str0001);
                  Li_FFD4 = Li_FFD4 + 1;
                 }
               while(Li_FFD4 < Ii_0D80);
              }
           }
         Print("==========");
         return ;
        }
      Gi_0010 = GetLastError();
      Li_FFFC = Gi_0010;
      if(Il_0FD8 != Time[0])
        {
         Il_0FD8 = Time[0];
         returned_i = Gi_0010;
         if(returned_i >= 2 && returned_i <= 149)
           {

            if(returned_i == 2)
              {

               Alert("Total mistake");
               return ;
              }
            if(returned_i == 3)
              {

               Alert("Wrong trading parameters");
               return ;
              }
            if(returned_i == 4)
              {

               Sleep(60000);
              }
            if(returned_i == 5)
              {

               Alert("The client terminal is out of date");
               return ;
              }
            if(returned_i == 6)
              {

               Sleep(5000);
              }
            if(returned_i == 8)
              {

               Alert("Too frequent queries");
               return ;
              }
            if(returned_i == 64)
              {

               Alert("Account is blocked");
               return ;
              }
            if(returned_i == 65)
              {

               Alert("Wrong account number");
               return ;
              }
            if(returned_i == 128)
              {

               Sleep(60000);
              }
            if(returned_i == 129)
              {

               Sleep(5000);
              }
            if(returned_i == 130)
              {

               Sleep(1000);
              }
            if(returned_i == 131)
              {

               Alert("Wrong Lots");
               return ;
              }
            if(returned_i == 132)
              {

               Alert("Market Close");
               return ;
              }
            if(returned_i == 133)
              {

               Alert("trade is disabled");
               return ;
              }
            if(returned_i == 134)
              {

               Alert("Not enough money");
               return ;
              }
            if(returned_i == 135)
              {

              }
            if(returned_i == 136)
              {

               Sleep(1000);
              }
            if(returned_i == 138)
              {

              }
            if(returned_i == 139)
              {

               return ;
              }
            if(returned_i == 140)
              {

               Alert("Allowed only buying");
               return ;
              }
            if(returned_i == 141)
              {

               Alert("Too many requests");
               return ;
              }
            if(returned_i == 142)
              {

               Sleep(60000);
              }
            if(returned_i == 143)
              {

               Sleep(60000);
              }
            if(returned_i == 144)
              {

               Alert("Order canceled customer");
               return ;
              }
            if(returned_i == 146)
              {

               if(IsTradeContextBusy())
                 {
                  do
                    {
                    }
                  while(IsTradeContextBusy());
                 }
              }
            if(returned_i == 148)
              {

               Alert("Too many orders");
               return ;
              }
            if(returned_i == 149)
              {

               Alert("hedging is disabled");
               return ;
              }
           }
        }
      Li_FFDC = Li_FFDC + 1;
     }
   while(Li_FFDC < 6);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FUN_1591(int Fa_i_00)
  {
   return 0;
   double Ld_FFF8;
   int Li_FFF4;
   double Ld_FFE8;
   int Li_FFE4;
   int Li_FFE0;
   double Ld_FFD8;

   RefreshRates();
   Id_0E50 = NormalizeDouble(Ask, _Digits);
   Id_0E58 = NormalizeDouble(Bid, _Digits);
   Id_0E40 = (MarketInfo(_Symbol, MODE_STOPLEVEL) * _Point);
   Id_0E48 = (MarketInfo(_Symbol, MODE_SPREAD) * _Point);
   if((Id_0E40 == 0))
     {
      Id_0E40 = NormalizeDouble((Id_0E48 * 1.5), _Digits);
     }
   Ii_0E60 = (int)MarketInfo(_Symbol, MODE_SPREAD);
   if(Ii_0E60 < 0)
     {
      Ii_0E60 = 0;
     }
   if(iMaxS != 0 && (Id_0E48 > (iMaxS * _Point)))
     {
      Print("Spread is more than maximum. Can not close.");
      Ld_FFF8 = -1;
      return Ld_FFF8;
     }
   Li_FFF4 = 0;
   Ld_FFE8 = 0;
   Li_FFE4 = 0;
   Li_FFE0 = 1;
   if(OrderSelect(Fa_i_00, 1, 0) != true)
     {
      Alert("order#", Fa_i_00, " not found");
      Ld_FFF8 = -1;
      return Ld_FFF8;
     }
   Ld_FFD8 = OrderLots();
   if(Li_FFE0 < 6)
     {
      do
        {
         if(OrderSelect(Fa_i_00, 1, 0) != true)
           {
            Alert("order#", Fa_i_00, " not found");
            Ld_FFF8 = -1;
            return Ld_FFF8;
           }
         Print("Closing orders #", Fa_i_00, " try ", Li_FFE0);
         RefreshRates();
         if(OrderType() == OP_BUY)
           {
            Ld_FFE8 = Bid;
            Li_FFE4 = 16711680;
           }
         else
           {
            if(OrderType() == OP_SELL)
              {
               Ld_FFE8 = Ask;
               Li_FFE4 = 255;
              }
            else
              {
               Ld_FFF8 = -1;
               return Ld_FFF8;
              }
           }
         if(OrderClose(Fa_i_00, Ld_FFD8, Ld_FFE8, Ii_0E60, Li_FFE4))
           {
            Print("order #", Fa_i_00, "  Close");
            Ld_FFF8 = Ld_FFE8;
            return Ld_FFF8;
           }
         Gi_0000 = GetLastError();
         Li_FFF4 = Gi_0000;
         Print("Order #", Fa_i_00, " Try ", Li_FFE0, " Error ", Gi_0000);
         Li_FFE0 = Li_FFE0 + 1;
        }
      while(Li_FFE0 < 6);
     }
   Print("Failed close the order #", Fa_i_00, " completed by TimeOut Error ", Li_FFF4);
   Gi_0000 = -Li_FFF4;
   Ld_FFF8 = Gi_0000;

   return Ld_FFF8;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1592(string Fa_s_00,
              int Fa_i_01,
              int Fa_i_02,
              int Fa_i_03,
              int Fa_i_04,
              string Fa_s_05,
              string Fa_s_06,
              int Fa_i_07,
              int Fa_i_08,
              int Fa_i_09,
              bool FuncArg_Boolean_0000000A,
              bool FuncArg_Boolean_0000000B,
              bool FuncArg_Boolean_0000000C,
              bool FuncArg_Boolean_0000000D,
              bool FuncArg_Boolean_0000000E,
              long Fa_l_0F,
              int Fa_i_10)
  {
   int Li_FFFC;
   long Ll_FFF0;

   Li_FFFC = 0;
   Ll_FFF0 = 0;
   if(ObjectFind(0, Fa_s_00) == -1 && ObjectCreate(0, Fa_s_00, OBJ_BUTTON, 0, 0, 0) == false)
     {
      Print("ButtonCreate", "Error: ", GetLastError());
      return ;
     }
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 102, Fa_i_01);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 103, Fa_i_02);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1019, Fa_i_03);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1020, Fa_i_04);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 101, Fa_i_10);
   ObjectSetString(Ll_FFF0, Fa_s_00, 999, Fa_s_05);
   ObjectSetString(Ll_FFF0, Fa_s_00, 1001, Fa_s_06);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 100, Fa_i_07);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 6, Fa_i_08);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1025, Fa_i_09);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1035, cCB);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 9, FuncArg_Boolean_0000000C);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1018, FuncArg_Boolean_0000000B);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 1000, FuncArg_Boolean_0000000D);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 17, FuncArg_Boolean_0000000D);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 208, FuncArg_Boolean_0000000E);
   ObjectSetInteger(Ll_FFF0, Fa_s_00, 207, Fa_l_0F);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int A_125250a()
  {
   static datetime dx=0;
   if(dx!=iTime(Symbol(),30,0))
     {
      dx=iTime(Symbol(),30,0);
      return (1);
     }
   return (0);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int A_125250()
  {
   static datetime dx=0;
   if(dx!=iTime(Symbol(),30,0))
     {
      dx=iTime(Symbol(),30,0);
      return (1);
     }
   return (0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1594()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   double Ld_FFF8;
   int Li_FFF4;
   double Ld_FFE8;
   int Li_FFE4;
   int Li_FFE0;
   bool Lb_FFDF;
   int Li_FFA4;
   int Li_FFA0;
   string Ls_FF90;

   RefreshRates();
   Id_0E50 = NormalizeDouble(Ask, _Digits);
   Id_0E58 = NormalizeDouble(Bid, _Digits);
   Id_0E40 = (MarketInfo(_Symbol, MODE_STOPLEVEL) * _Point);
   Id_0E48 = (MarketInfo(_Symbol, MODE_SPREAD) * _Point);
   if((Id_0E40 == 0))
     {
      Id_0E40 = NormalizeDouble((Id_0E48 * 1.5), _Digits);
     }
   Ii_0E60 = (int)MarketInfo(_Symbol, MODE_SPREAD);
   if(Ii_0E60 < 0)
     {
      Ii_0E60 = 0;
     }
   if(iMaxS != 0 && (Id_0E48 > (iMaxS * _Point)))
     {
      Print("Spread is more than maximum. Can not close.");
      return ;
     }
   Ld_FFF8 = 0;
   Li_FFF4 = -1;
   Ld_FFE8 = -1;
   Li_FFE4 = 0;
   Li_FFE0 = 0;
   Lb_FFDF = false;
   int Li_FFA8[];
   Li_FFA4 = 0;
   Li_FFA0 = Ii_0E80;
   Ii_0E80 = -1;
   ArrayResize(Li_FFA8, OrdersTotal(), 0);
   ArrayInitialize(Li_FFA8, -1);
   Li_FFE4 = OrdersTotal() - 1;
   if(Li_FFE4 >= 0)
     {
      do
        {
         if(OrderSelect(Li_FFE4, 0, 0))
           {
            if(OrderMagicNumber() == Magic || (OrderMagicNumber() == 0 && fHO))
              {

               if(OrderSymbol() == _Symbol)
                 {
                  Lb_FFDF = false;
                  if(Li_FFA0 == 2)
                    {
                     Lb_FFDF = true;
                    }
                  if(Li_FFA0 == 0 && OrderType() == OP_BUY)
                    {
                     Lb_FFDF = true;
                    }
                  if(Li_FFA0 == 1 && OrderType() == OP_SELL)
                    {
                     Lb_FFDF = true;
                    }
                  if(Lb_FFDF)
                    {
                     Gi_0000 = OrderTicket();
                     Li_FFA8[Li_FFA4] = Gi_0000;
                     Li_FFA4 = Li_FFA4 + 1;
                    }
                 }
              }
           }
         Li_FFE4 = Li_FFE4 - 1;
        }
      while(Li_FFE4 >= 0);
     }
   Li_FFE4 = 0;
   if(Li_FFA4 > 0)
     {
      do
        {
         if(OrderSelect(Li_FFA8[Li_FFE4], 1, 0))
           {
            Lb_FFDF = false;
            Li_FFE0 = 0;
            do
              {
               RefreshRates();
               Id_0E50 = NormalizeDouble(Ask, _Digits);
               Id_0E58 = NormalizeDouble(Bid, _Digits);
               Id_0E40 = (MarketInfo(_Symbol, MODE_STOPLEVEL) * _Point);
               Id_0E48 = (MarketInfo(_Symbol, MODE_SPREAD) * _Point);
               if((Id_0E40 == 0))
                 {
                  Id_0E40 = NormalizeDouble((Id_0E48 * 1.5), _Digits);
                 }
               Ii_0E60 = (int)MarketInfo(_Symbol, MODE_SPREAD);
               if(Ii_0E60 < 0)
                 {
                  Ii_0E60 = 0;
                 }
               if(IsTradeContextBusy())
                 {
                  Sleep(500);
                 }
               else
                 {
                  Ld_FFE8 = OrderClosePrice();
                  Gd_0002 = OrderProfit();
                  Gd_0002 = (Gd_0002 + OrderSwap());
                  Ld_FFF8 = ((Gd_0002 + OrderCommission()) + Ld_FFF8);
                  Li_FFF4 = OrderType();
                  if(OrderType() > OP_SELL)
                    {
                     Lb_FFDF = OrderDelete(Li_FFA8[Li_FFE4], 2139610);
                    }
                  else
                    {
                     Lb_FFDF = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), Ii_0E60, 2139610);
                    }
                  if(Lb_FFDF != true)
                    {
                     Sleep(500);
                    }
                  else
                    {
                     if(fDraw)
                       {
                        FUN_1599(Ld_FFE8);
                       }
                    }
                  Li_FFE0 = Li_FFE0 + 1;
                 }
               if(Lb_FFDF)
                  break;
              }
            while(Li_FFE0 < 5);

            if(Lb_FFDF != true)
              {
               Ls0_str0000 = OrderSymbol();
               Print("F: ", "DEL_ALL_ORDER", "()  L: ", 1505, "  ", Ls0_str0000, ".  Failed close the order #", Li_FFA8[Li_FFE4], "  _LastError = ", GetLastError());
               Ii_0E80 = Li_FFA0;
              }
           }
         Li_FFE4 = Li_FFE4 + 1;
        }
      while(Li_FFE4 < Li_FFA4);
     }
   if(fDraw)
     {
      Ls0_str0001 = Is_0E30 + "Rez_";
      Ls0_str0002 = (string)TimeCurrent();
      Ls0_str0001 = Ls0_str0001 + Ls0_str0002;
      Ls_FF90 = Ls0_str0001;
      Ls0_str0002 = "$" + DoubleToString(Ld_FFF8, 2);
      FUN_1600(Ls0_str0001, Time[0], Ld_FFE8, Ls0_str0002, Color_Fon_Metki, Li_FFF4);
     }
   ArrayFree(Li_FFA8);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FUN_1595()
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls0_str0008;
   string Ls0_str0009;
   string Ls0_str000A;
   string Ls0_str000B;
   string Ls0_str000C;
   string Ls0_str000D;
   string Ls0_str000E;
   string Ls0_str000F;
   string Ls0_str0010;
   string Ls0_str0011;
   string Ls0_str0012;
   string Ls0_str0013;
   string Ls0_str0014;
   string Ls0_str0015;
   string Ls0_str0016;
   string Ls0_str0017;
   string Ls0_str0018;
   string Ls0_str0019;
   string Ls0_str001A;
   string Ls0_str001B;
   int Li_FFF8;
   string Ls_FFE8;
   int Li_FFE4;
   bool Lb_FFFF;
   int Li_FFE0;

   Li_FFF8 = 0;
   Ls_FFE8 = Is_0B50;
   Li_FFE4 = 0;
   FUN_1598(1);
   Gi_0002 = Input_Pointer_00000068.Total();
   if(Gi_0002 == 0)
     {
      Print("---- Initial string initialization ----");
      Ls0_str0000 = IntegerToString(X1, 0, 32);
      Gi_0004 = 1;
      Gi_0005 = 0;
      Input_Pointer_00000068.Add(Ls0_str0000);

      Ls0_str0001 = IntegerToString(Y1, 0, 32);
      Input_Pointer_00000068.Add(Ls0_str0001);

      Ls0_str0002 = "1";
      Input_Pointer_00000068.Add(Ls0_str0002);

      Ls0_str0003 = (string)fTrBuy;
      Input_Pointer_00000068.Add(Ls0_str0003);

      Ls0_str0004 = (string)fTrSell;
      Input_Pointer_00000068.Add(Ls0_str0004);

      Ls0_str0005 = (string)iStart_H;
      Input_Pointer_00000068.Add(Ls0_str0005);

      Ls0_str0006 = (string)iEnd_H;
      Input_Pointer_00000068.Add(Ls0_str0006);

      Ls0_str0007 = (string)fNS;
      Input_Pointer_00000068.Add(Ls0_str0007);

      FUN_1598(2);
     }
   else
     {
      Li_FFF8 = 0;
      Gi_002C = Input_Pointer_00000068.Total();
      if(Gi_002C > 0)
        {
         do
           {
            Gi_002D = Li_FFF8;

            Ls0_str0008 = Input_Pointer_00000068.At(Gi_002D);
            Print("i = ", Li_FFF8, "  Prop = ", Ls0_str0008);
            Li_FFF8 = Li_FFF8 + 1;
            Gi_0031 = Input_Pointer_00000068.Total();
           }
         while(Li_FFF8 < Gi_0031);
        }

      Ls0_str0009 = Input_Pointer_00000068.At(0);
      X1 = (int)StringToInteger(Ls0_str0009);

      Ls0_str000A = Input_Pointer_00000068.At(1);
      Y1 = (int)StringToInteger(Ls0_str000A);

      Ls0_str000B = Input_Pointer_00000068.At(2);
      Li_FFE0 = (int)StringToInteger(Ls0_str000B);
      fTrBuy = true;

      Ls0_str000C = Input_Pointer_00000068.At(3);
      if(Ls0_str000C == "false")
        {
         fTrBuy = false;
        }
      fTrSell = true;
      Ls0_str000D = Input_Pointer_00000068.At(4);
      if(Ls0_str000D == "false")
        {
         fTrSell = false;
        }

      Ls0_str000E = Input_Pointer_00000068.At(5);
      iStart_H = (int)StringToInteger(Ls0_str000E);
      Ls0_str000F = Input_Pointer_00000068.At(6);
      iEnd_H = (int)StringToInteger(Ls0_str000F);
      fNS = true;
      Ls0_str0010 = Input_Pointer_00000068.At(7);
      if(Ls0_str0010 == "false")
        {
         fNS = false;
        }
     }
   ObjectCreate(0, Ls_FFE8, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 102, X1);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 103, Y1);
   Ii_0CF8 = X1;
   Ii_0CFC = Y1;
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1019, 165);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1020, 245);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 6, 0);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1025, cCIP);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1035, cCB);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 1000, 1);
   ObjectSetInteger(Li_FFE4, Ls_FFE8, 17, 0);
   Gi_004E = Y1 + 10;
   Gi_004F = X1 + 10;
   Gi_0050 = Y1 + 35;
   Gi_0051 = X1 + 5;
   Ls0_str0011 = Is_0E30 + "LabTime";
   Ls0_str0012 = Ls0_str0011;

   if(Input_Pointer_00000A58.Create(0, Ls0_str0012, 0, Gi_0051, Gi_0050, Gi_0051 + 155, Gi_0050 + 18))
     {
     }
   Input_Pointer_00000A58.Text("平台时间: " + TimeToString(TimeCurrent(), 6));
   Input_Pointer_00000A58.Color(cTimeTerminal);
   Input_Pointer_00000A58.FontSize(FontSize);
   Input_Pointer_00000A58.ColorBackground(cCIP);
   Input_Pointer_00000A58.ColorBorder(cCIP);


   ObjectSetInteger(0,"ke_GSr_LabTime",OBJPROP_XDISTANCE,11);
   Ls0_str0011 = "QQ：1062312168";
   FUN_1596(0, Ls0_str0011, X1, Y1, 165, 30);
   Ls0_str0013 = "开始时间";
   FUN_1596(1, Ls0_str0013, (X1 + 5), (Y1 + 130), 75, 20);
   Ls0_str0014 = "结束时间";
   FUN_1596(2, Ls0_str0014, (X1 + 85), (Y1 + 130), 75, 20);
   Ls0_str0015 = "开始时间";
   FUN_1596(3, Ls0_str0015, (X1 + 5), (Y1 + 150), 75, 25);
   Ls0_str0016 = "结束时间";
   FUN_1596(4, Ls0_str0016, (X1 + 85), (Y1 + 150), 75, 25);
   Gb_0055 = false;
   Gi_0056 = 1;
   Gi_0057 = 16711680;
   Gi_0058 = FontSize;
   Ls0_str0017 = "多单盈亏: 0";
   Gi_0059 = 0;
   Gi_005A = Y1 + 65;
   Gi_005B = X1 + 5;
   Ls0_str0018 = Is_0B60;
   Gl_005C = 0;
   if(ObjectFind(0, Ls0_str0018) == -1 && ObjectCreate(0, Ls0_str0018, OBJ_LABEL, 0, 0, 0) == false)
     {
      Print("DrawLabel", "Error: ", GetLastError());
     }
   else
     {
      ObjectSetInteger(Gl_005C, Ls0_str0018, 102, Gi_005B);
      ObjectSetInteger(Gl_005C, Ls0_str0018, 103, Gi_005A);
      ObjectSetInteger(Gl_005C, Ls0_str0018, 101, Gi_0059);
      ObjectSetString(Gl_005C, Ls0_str0018, 999, Ls0_str0017);
      ObjectSetInteger(Gl_005C, Ls0_str0018, 100, Gi_0058);
      ObjectSetInteger(Gl_005C, Ls0_str0018, 1011, Gi_0056);
      ObjectSetInteger(Gl_005C, Ls0_str0018, 6, Gi_0057);
      ObjectSetInteger(Gl_005C, Ls0_str0018, 1000, Gb_0055);
     }
   Gb_005D = false;
   Gi_005E = 1;
   Gi_005F = 16711680;
   Gi_0060 = FontSize;
   Ls0_str0019 = "空单盈亏: 0";
   Gi_0061 = 0;
   Gi_0062 = Y1 + 83;
   Gi_0063 = X1 + 5;
   Ls0_str001A = Is_0B70;
   Gl_0064 = 0;
   if(ObjectFind(0, Ls0_str001A) == -1 && ObjectCreate(0, Ls0_str001A, OBJ_LABEL, 0, 0, 0) == false)
     {
      Print("DrawLabel", "Error: ", GetLastError());
     }
   else
     {
      ObjectSetInteger(Gl_0064, Ls0_str001A, 102, Gi_0063);
      ObjectSetInteger(Gl_0064, Ls0_str001A, 103, Gi_0062);
      ObjectSetInteger(Gl_0064, Ls0_str001A, 101, Gi_0061);
      ObjectSetString(Gl_0064, Ls0_str001A, 999, Ls0_str0019);
      ObjectSetInteger(Gl_0064, Ls0_str001A, 100, Gi_0060);
      ObjectSetInteger(Gl_0064, Ls0_str001A, 1011, Gi_005E);
      ObjectSetInteger(Gl_0064, Ls0_str001A, 6, Gi_005F);
      ObjectSetInteger(Gl_0064, Ls0_str001A, 1000, Gb_005D);
     }
   if(fTrBuy)
     {
      Gi_0065 = cTrNSStr1;
     }
   else
     {
      Gi_0065 = cTrNSStr2;
     }
   FUN_1592(Is_0B80, (X1 + 5), (Y1 + 100), 75, 25, "多单开关", Font, FontSize, 16777215, Gi_0065, 65535, false, false, false, true, 0, 0);
   if(fTrSell)
     {
      Gi_0067 = cTrNSStr1;
     }
   else
     {
      Gi_0067 = cTrNSStr2;
     }
   FUN_1592(Is_0B90, (X1 + 85), (Y1 + 100), 75, 25, "空单开关", Font, FontSize, 16777215, Gi_0067, 65535, false, false, false, true, 0, 0);
   FUN_1592(Is_0BB0, (X1 + 5), (Y1 + 185), 75, 25, "平仓多单", Font, FontSize, 16777215, cOpClBut, 65535, false, false, false, true, 0, 0);
   FUN_1592(Is_0BA0, (X1 + 85), (Y1 + 185), 75, 25, "平仓空单", Font, FontSize, 16777215, cOpClBut, 65535, false, false, false, true, 0, 0);
   if(fNS)
     {
      Gi_006B = cTrNSStr1;
     }
   else
     {
      Gi_006B = cTrNSStr2;
     }
   FUN_1592(Is_0BC0, (X1 + 5), (Y1 + 215), 155, 25, "新批次", Font, FontSize, 16777215, Gi_006B, 65535, false, false, false, true, 0, 0);
   FUN_1592(Is_0BE0, 5, 30, 65, 22, "开仓多单", Font, FontSize, 16777215, cOpClBut, 65535, false, false, false, true, 0, 2);
   FUN_1592(Is_0BD0, 120, 30, 65, 22, "开仓空单", Font, FontSize, 16777215, cOpClBut, 65535, false, false, false, true, 0, 2);
   Ls0_str001B = Is_0BF0;
   FUN_1597(Ls0_str001B, 70, 30, 50, 22);
   Lb_FFFF = true;
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1596(int Fa_i_00, string Fa_s_01, int Fa_i_02, int Fa_i_03, int Fa_i_04, int Fa_i_05)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   string Ls0_str0004;
   string Ls0_str0005;
   string Ls0_str0006;
   string Ls0_str0007;
   string Ls_FFF0;

   if(Fa_i_00 == 0)
     {
      Ls0_str0000 = Is_0E30 + Fa_s_01;
      Ls0_str0000 = Ls0_str0000 + "edit";
      Ls0_str0000 = Ls0_str0000 + IntegerToString(Fa_i_00, 0, 32);
      Ls0_str0001 = Ls0_str0000;
      Gi_0006 = Fa_i_05;
      Gi_0007 = Fa_i_04;
      Gi_0008 = Fa_i_03;
      Gi_0009 = Fa_i_02;
      Gi_000A = 0;

      if(Input_Struct_000000A4[Fa_i_00].Create(0, Ls0_str0001, 0, Fa_i_02, Fa_i_03, Fa_i_02 + Fa_i_04, Fa_i_03 + Fa_i_05))
        {
        }
      Ls0_str0002 = Fa_s_01;
      Input_Struct_000000A4[Fa_i_00].Text(Ls0_str0002);
      Input_Struct_000000A4[Fa_i_00].ColorBackground(16711680);
      Input_Struct_000000A4[Fa_i_00].ColorBorder(cCIP);
      Input_Struct_000000A4[Fa_i_00].Color(16777215);
      Gi_0011 = FontSize + 3;
      Input_Struct_000000A4[Fa_i_00].FontSize(Gi_0011);
      Gi_0011 = 2;
      Input_Struct_000000A4[Fa_i_00].ZOrder(2);
      Input_Struct_000000A4[Fa_i_00].TextAlign(2);

      Gb_0015 = true;
      Input_Struct_000000A4[Fa_i_00].ReadOnly(true);
      Input_Struct_000000A4[Fa_i_00].Move(Fa_i_02, Fa_i_03);
     }
   if(Fa_i_00 == 1 || Fa_i_00 == 2)
     {

      Ls0_str0003 = Is_0E30 + Fa_s_01;
      Ls0_str0003 = Ls0_str0003 + "edit";
      Ls0_str0003 = Ls0_str0003 + IntegerToString(Fa_i_00, 0, 32);
      Ls0_str0004 = Ls0_str0003;
      Gi_0020 = Fa_i_05;
      Gi_0021 = Fa_i_04;
      Gi_0022 = Fa_i_03;
      Gi_0023 = Fa_i_02;
      Gi_0024 = 0;
      if(Input_Struct_000000A4[Fa_i_00].Create(0, Ls0_str0004, 0, Fa_i_02, Fa_i_03, Fa_i_02 + Fa_i_04, Fa_i_03 + Fa_i_05))
        {
        }
      Ls0_str0005 = Fa_s_01;
      Input_Struct_000000A4[Fa_i_00].Text(Ls0_str0005);
      Input_Struct_000000A4[Fa_i_00].ColorBackground(cCIP);
      Input_Struct_000000A4[Fa_i_00].ColorBorder(cCIP);
      Input_Struct_000000A4[Fa_i_00].Color(cCT);
      Input_Struct_000000A4[Fa_i_00].FontSize(FontSize);
      Gi_002C = 2;
      Input_Struct_000000A4[Fa_i_00].ZOrder(2);
      Input_Struct_000000A4[Fa_i_00].TextAlign(2);
      Input_Struct_000000A4[Fa_i_00].ReadOnly(true);
      Input_Struct_000000A4[Fa_i_00].Move(Fa_i_02, Fa_i_03);
     }
   if(Fa_i_00 != 3 && Fa_i_00 != 4)
     {
      if(Fa_i_00 != 5)
         return;
     }
   Ls0_str0006 = Is_0E30 + Fa_s_01;
   Ls0_str0006 = Ls0_str0006 + "_";
   Ls0_str0006 = Ls0_str0006 + IntegerToString(Fa_i_00, 0, 32);
   Ls0_str0007 = Ls0_str0006;
   Gi_003B = Fa_i_05;
   Gi_003C = Fa_i_04;
   Gi_003D = Fa_i_03;
   Gi_003E = Fa_i_02;
   Gi_003F = 0;
   if(Input_Struct_000000A4[Fa_i_00].Create(0, Ls0_str0007, 0, Fa_i_02, Fa_i_03, Fa_i_04 + Fa_i_02, Fa_i_05 + Fa_i_03))
     {
     }
   if(Fa_i_00 == 3)
     {
      Ls_FFF0 = (string)iStart_H;
     }
   if(Fa_i_00 == 4)
     {
      Ls_FFF0 = (string)iEnd_H;
     }
   if(Fa_i_00 == 5)
     {
      Ls_FFF0 = "";
     }
   Input_Struct_000000A4[Fa_i_00].Text(Ls_FFF0);
   Input_Struct_000000A4[Fa_i_00].ColorBackground(16777215);
   Input_Struct_000000A4[Fa_i_00].ColorBorder(cCIP);
   Input_Struct_000000A4[Fa_i_00].Color(cCT);
   Input_Struct_000000A4[Fa_i_00].FontSize(FontSize);
   Gi_0047 = 2;
   Input_Struct_000000A4[Fa_i_00].TextAlign(2);
   Input_Struct_000000A4[Fa_i_00].Move(Fa_i_02, Fa_i_03);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1597(string Fa_s_00, int Fa_i_01, int Fa_i_02, int Fa_i_03, int Fa_i_04)
  {
   string Ls0_str0000;
   string Ls_FFF0;
   int Li_FFEC;

   Li_FFEC = (int)ChartGetInteger(0, 107, 0);
   Gi_0000 = Li_FFEC - 31;
   Ls0_str0000 = Fa_s_00;
   if(Input_Pointer_00000C00.Create(0, Ls0_str0000, 0, Fa_i_01, Gi_0000, Fa_i_03 + Fa_i_01, Fa_i_04 + Gi_0000))
     {
     }
   Ls_FFF0 = DoubleToString(MarketInfo(_Symbol, MODE_MINLOT), 2);
   Input_Pointer_00000C00.Text(Ls_FFF0);
   Input_Pointer_00000C00.ColorBackground(16777215);
   Input_Pointer_00000C00.ColorBorder(15631086);
   Input_Pointer_00000C00.Color(cCT);
   Input_Pointer_00000C00.FontSize(FontSize);
   Input_Pointer_00000C00.TextAlign(2);
   Input_Pointer_00000C00.Move(Fa_i_01, Gi_0000);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FUN_1598(int Fa_i_00)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls_FFF0;
   int Li_FFEC;
   bool Lb_FFFF;
   int Li_FFE8;

   Ls0_str0000 = _Symbol + "_";
   Ls0_str0001 = (string)Magic;
   Ls0_str0000 = Ls0_str0000 + Ls0_str0001;
   Ls0_str0000 = Ls0_str0000 + "_GoldStuff_";
   Ls0_str0000 = Ls0_str0000 + Is_0000;
   Ls0_str0000 = Ls0_str0000 + ".bin";
   Ls_FFF0 = Ls0_str0000;
   if(Fa_i_00 == 1)
     {
      Li_FFEC = FileOpen(Ls_FFF0, 37);
      if(Li_FFEC >= 0)
        {
         Gi_0000 = Li_FFEC;
         Gi_0002 = 0;
         Gi_0003 = 0;
         Gi_0004 = 0;
         Gb_0005 = Input_Pointer_00000068.Load(Li_FFEC);


         if(Gb_0005 != true)
           {
            PrintFormat("File %s read: Error %d!", Ls_FFF0, GetLastError());
            FileClose(Li_FFEC);
            Lb_FFFF = false;
            return Lb_FFFF;
           }
         FileClose(Li_FFEC);
         Lb_FFFF = true;
         return Lb_FFFF;
        }
     }
   if(Fa_i_00 != 2)
      return false;
   Li_FFE8 = FileOpen(Ls_FFF0, 38);
   if(Li_FFE8 < 0)
      return false;
   Gi_0008 = Li_FFE8;
   Gi_000A = 0;
   Gi_000B = 0;

   Gb_000C = Input_Pointer_00000068.Load(Li_FFE8);
   if(Gb_000C != true)
     {
      PrintFormat("File %s read: Error %d!", Ls_FFF0, GetLastError());
      FileClose(Li_FFE8);
      Lb_FFFF = true;
      return Lb_FFFF;
     }
   FileClose(Li_FFE8);

   Lb_FFFF = false;

   return Lb_FFFF;
  }

int  ISTart =1400;
int IStop = 100;

//+------------------------------------------------------------------+
int iMaxS; // Max spread (0 - not use)
int iStart_H; // Start Hour
int iEnd_H; // End Hour
bool fDraw = true; // Draw on-off
string Font_Metki = "Verdana"; // Font Result
int Size_Metki = 14; // Font size Result
color ColorText_Metki = White; // Font color Result
color Color_Fon_Metki = Green; // Background color Result
int MinuteStop; // Pause between orders (min. 0 - not use)

ENUM_TIMEFRAMES TF = PERIOD_CURRENT;
int Deviation = 2;
int X1 = 10;
int Y1 = 100;
color cCIP = Gainsboro; // Info panel background color
color cCB = DarkGray; // Border color
color cCT = DimGray; // Border text color
color cOpClBut = DarkOrchid; // Button Open, Close color
color cTrNSStr1 = Green; // Button On: Trade and 新批次 color
color cTrNSStr2 = Red; // Button Off: Trade and 新批次 color
color cTimeTerminal = Blue; // 平台时间
string Font = "Arial";
int FontSize = 10;
bool fA_MM=0; // Use Money Management
int iAuLot = 1000; // Autolot. Free margin for each 0.01 Lots

bool fNS = true; // Open new series
bool fTrBuy = true; // 多单开关
bool fTrSell = true; // 空单开关
bool fHO = true; // Support manual orders
int loc_x02152in,loc_x02152ax,loc_x02152ax2;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FUN_02c(int t,int MagicNumber)
  {
   bool b=0;
   loc_x02152ax=0;
   double l_ord_open_price_8=0;
   double l_ticket_24=0;

   double l_ticket_20=-999999;
   for(int l_pos_16=OrdersTotal()-1; l_pos_16>=0; l_pos_16--)
     {
      b=OrderSelect(l_pos_16,SELECT_BY_POS,MODE_TRADES);

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()<2)
        {
         l_ticket_24=OrderProfit();
         if(l_ticket_24>l_ticket_20)
           {
            l_ord_open_price_8=OrderProfit();
            loc_x02152ax=OrderTicket();
            l_ticket_20 = l_ticket_24;
           }
        }
     }
   return (l_ord_open_price_8);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FUN_02b(int t,int MagicNumber)
  {
   bool b=0;
   loc_x02152ax2=0;
   double l_ord_open_price_8=0;
   double l_ticket_24=0;

   double l_ticket_20=-99990;
   for(int l_pos_16=OrdersTotal()-1; l_pos_16>=0; l_pos_16--)
     {
      b=OrderSelect(l_pos_16,SELECT_BY_POS,MODE_TRADES);
      if(OrderTicket()!=loc_x02152ax)
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()<2)
           {
            l_ticket_24=OrderProfit();
            if(l_ticket_24>l_ticket_20)
              {
               l_ord_open_price_8=OrderProfit();
               loc_x02152ax2=OrderTicket();
               l_ticket_20 = l_ticket_24;
              }
           }
     }
   return (l_ord_open_price_8);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FUN_02a(int t,int MagicNumber)
  {
   bool b=0;
   loc_x02152in=0;
   double l_ord_open_price_8=0;
   double l_ticket_24=0;

   double l_ticket_20=EMPTY_VALUE;
   for(int l_pos_16=OrdersTotal()-1; l_pos_16>=0; l_pos_16--)
     {
      b=OrderSelect(l_pos_16,SELECT_BY_POS,MODE_TRADES);

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()<2)
        {
         l_ticket_24=OrderProfit();
         if(l_ticket_24<l_ticket_20)
           {
            l_ord_open_price_8=OrderProfit();
            loc_x02152in=OrderTicket();
            l_ticket_20 = l_ticket_24;
           }
        }
     }
   return (l_ord_open_price_8);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int chexk()
  {

   if(启用时间限制==1 && TimeCurrent()>到期時間)
     {

      Alert("已停止：请联系QQ，获取使用权限。");
      ExpertRemove();

      return -1;

     }

   if(StringFind(賬戶,(string)AccountNumber())==-1 && 启用账户限制==1)
     {

      Alert("已停止：请联系QQ，获取使用权限。");
      ExpertRemove();

      return -1;

     }
   label_XX("Label1_YCEA","使用期限："+TimeToStr(到期時間),20,18,DeepSkyBlue,11,1);
   return 1;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void label_XX(string 名称,string 内容,int XX,int YX,color C,int 字体大小,int 固定角内)
  {

   if(ObjectFind(名称)==-1)
     {
      ObjectDelete(名称);
      ObjectCreate(名称,OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,名称,OBJPROP_BACK,0);
      ObjectSetInteger(0,名称,OBJPROP_HIDDEN,1);
      ObjectSetInteger(0,名称,OBJPROP_SELECTABLE,0);
      ObjectSetString(0,名称,OBJPROP_TOOLTIP,"\n");
     }

   ObjectSet(名称,OBJPROP_XDISTANCE,XX);
   ObjectSet(名称,OBJPROP_YDISTANCE,YX);
   ObjectSetText(名称,内容,字体大小,"宋体",C);
   ObjectSet(名称,OBJPROP_CORNER,固定角内);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_de02352(int t)
  {
   RefreshRates();
   for(int i=OrdersTotal() -1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
        }
      else
        {
         continue;
        }

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        {

         if(OrderType()==t)
            bool b=OrderDelete(OrderTicket());

        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FUN_02c01(int tik)
  {
   bool li_0=0;
   bool li_4=0;
   for(int li_81=0; li_81<15; li_81++)
      for(int li_8=0; li_8<OrdersTotal(); li_8++)
        {
         RefreshRates();
         li_0=OrderSelect(li_8,SELECT_BY_POS,MODE_TRADES);
         if(li_0)
           {
            if(OrderTicket()==tik)
              {
               if(OrderType()<2)
                 {
                  li_4=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,clrNONE);

                  if(li_4>0)
                     break;
                 }

              }
           }
        }

   return li_4;
  }
//|                                                                  |
//+------------------------------------------------------------------+
void func_1599(double Fa_d_00)
  {
   string tmp_str0000;
   string tmp_str0001;
   string tmp_str0002;
   string tmp_str0003;
   double Ld_FFF8;
   string Ls_FFE8;
   double Ld_FF90;
   int Li_FF8C;
   long Ll_FF80;
   long Ll_FF78;
   int Li_FF74;
   Ld_FFF8 = 0;
   int Li_FFD0[6] = { 16711680, 255, 16711680, 255, 16711680, 255 };
   Ld_FF90 = 0;
   Li_FF8C = OrderTicket();
   Ll_FF80 = 0;
   Ll_FF78 = 0;
   Ld_FF90 = OrderOpenPrice();
   Ll_FF78 = Time[0];
   Ll_FF80 = OrderOpenTime();
   Li_FF74 = OrderType();
   tmp_str0000 = Is_0E30 + "Ord_";
   tmp_str0001 = (string)Li_FF8C;
   tmp_str0000 = tmp_str0000 + tmp_str0001;
   Ls_FFE8 = tmp_str0000;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      ObjectCreate(0, Ls_FFE8, OBJ_ARROW, 0, Ll_FF80, Ld_FF90, 0, 0, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_ARROWCODE, 1);
      Gi_0002 = Li_FFD0[Li_FF74];
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, Gi_0002);
     }
   tmp_str0001 = Is_0E30 + "Close_";
   tmp_str0002 = (string)Li_FF8C;
   tmp_str0001 = tmp_str0001 + tmp_str0002;
   Ls_FFE8 = tmp_str0001;
   Ld_FFF8 = Fa_d_00;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      ObjectCreate(0, Ls_FFE8, OBJ_ARROW, 0, Ll_FF78, Fa_d_00, 0, 0, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_ARROWCODE, 3);
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, 2139610);
     }
   tmp_str0002 = Is_0E30 + "Ord_Line_";
   tmp_str0003 = (string)Li_FF8C;
   tmp_str0002 = tmp_str0002 + tmp_str0003;
   Ls_FFE8 = tmp_str0002;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      //  ObjectCreate(0, Ls_FFE8, OBJ_TREND, 0, Ll_FF80, Ld_FF90, Ll_FF78, Ld_FFF8, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_RAY, 0);
      ObjectSet(Ls_FFE8, OBJPROP_STYLE, 2);
      Gi_0003 = Li_FFD0[Li_FF74];
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, Gi_0003);
     }
   ArrayFree(Li_FFD0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double func_1591(int Fa_i_00)
  {

   return 0;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void func_1600()
  {
   int ReductionOrderNumber = 4; //
   int ReductionPercent = 3; //


   string tmp_str0000;
   string tmp_str0001;
   string tmp_str0002;
   string tmp_str0003;
   double Ld_FFF8;
   double Ld_FFF0;
   int Li_FFEC;
   int Li_FFE8;
   double Ld_FFE0;
   double Ld_FFD8;
   int Li_FFD4;
   int Li_FFD0;
   int Li_FFCC;
   int Li_FFC8;
   long Ll_FFC0;
   long Ll_FFB8;
   long Ll_FFB0;
   long Ll_FFA8;
   int Li_FFA4;
   double Ld_FF98;
   bool Lb_FF97;
   int Li_FF90;
   double Ld_FF88;
   string Ls_FF78;
   string Ls_FF68;
   Ld_FFF8 = 0;
   Ld_FFF0 = 0;
   Li_FFEC = 0;
   Li_FFE8 = 0;
   Ld_FFE0 = 0;
   Ld_FFD8 = 0;
   Li_FFD4 = 0;
   Li_FFD0 = 0;
   Li_FFCC = 0;
   Li_FFC8 = 0;
   Ll_FFC0 = TimeCurrent();
   Ll_FFB8 = 0;
   Ll_FFB0 = TimeCurrent();
   Ll_FFA8 = 0;
   Li_FFA4 = 0;
   if(OrdersTotal() > 0)
     {
      do
        {
         if(OrderSelect(Li_FFA4, 0, 0))
           {
            if(OrderMagicNumber() == Magic || (OrderMagicNumber() == 0 && fHO))
              {
               if(OrderSymbol() == _Symbol)
                 {
                  if(OrderType() == OP_BUY)
                    {
                     Li_FFCC = Li_FFCC + 1;
                     if(OrderOpenTime() <= Ll_FFC0)
                       {
                        Ll_FFC0 = OrderOpenTime();
                        Gd_0000 = OrderProfit();
                        Gd_0000 = (Gd_0000 + OrderSwap());
                        Ld_FFF8 = (Gd_0000 + OrderCommission());
                        Li_FFEC = OrderTicket();
                       }
                     if(OrderOpenTime() >= Ll_FFB8)
                       {
                        Ll_FFB8 = OrderOpenTime();
                        Gd_0000 = OrderProfit();
                        Gd_0000 = (Gd_0000 + OrderSwap());
                        Ld_FFF0 = (Gd_0000 + OrderCommission());
                        Li_FFE8 = OrderTicket();
                       }
                    }
                  if(OrderType() == OP_SELL)
                    {
                     Li_FFC8 = Li_FFC8 + 1;
                     if(OrderOpenTime() <= Ll_FFB0)
                       {
                        Ll_FFB0 = OrderOpenTime();
                        Gd_0000 = OrderProfit();
                        Gd_0000 = (Gd_0000 + OrderSwap());
                        Ld_FFE0 = (Gd_0000 + OrderCommission());
                        Li_FFD4 = OrderTicket();
                       }
                     if(OrderOpenTime() >= Ll_FFA8)
                       {
                        Ll_FFA8 = OrderOpenTime();
                        Gd_0000 = OrderProfit();
                        Gd_0000 = (Gd_0000 + OrderSwap());
                        Ld_FFD8 = (Gd_0000 + OrderCommission());
                        Li_FFD0 = OrderTicket();
                       }
                    }
                 }
              }
           }
         Li_FFA4 = Li_FFA4 + 1;
        }
      while(Li_FFA4 < OrdersTotal());
     }
   Ld_FF98 = 0;
   Lb_FF97 = false;
   Li_FF90 = -1;
   Ld_FF88 = -1;
   if(Li_FFCC >= ReductionOrderNumber && Reduction == true && (Ld_FFF0 > 0))
     {
      Gd_0000 = -Ld_FFF8;
      Gi_0001 = ReductionPercent + 100;
      if((Ld_FFF0 >= ((Gd_0000 * Gi_0001) / 100)))
        {
         Print("Close overlap last order, ticket first order: ", Li_FFEC, " profit first order: ", Ld_FFF8, " ticket last order: ", Li_FFE8, " profit last order: ", Ld_FFF0, " Bid: ", Bid, " Ask: ", Ask);
         Lb_FF97 = OrderSelect(Li_FFE8, 1, 0);
         Li_FF90 = OrderType();
         Gd_0001 = OrderProfit();
         Gd_0001 = (Gd_0001 + OrderSwap());
         Ld_FF98 = (Gd_0001 + OrderCommission());
         Ld_FF88 = func_1591(OrderTicket());
         if((Ld_FF88 != -1) && fDraw)
           {
            func_1599(Ld_FF88);
           }
         Lb_FF97 = OrderSelect(Li_FFEC, 1, 0);
         Gd_0001 = OrderProfit();
         Gd_0001 = (Gd_0001 + OrderSwap());
         Ld_FF98 = ((Gd_0001 + OrderCommission()) + Ld_FF98);
         Ld_FF88 = func_1591(OrderTicket());
         if((Ld_FF88 != -1) && fDraw)
           {
            func_1599(Ld_FF88);
           }
         if(fDraw)
           {
            tmp_str0000 = Is_0E30 + "Rez_";
            tmp_str0001 = (string)TimeCurrent();
            tmp_str0000 = tmp_str0000 + tmp_str0001;
            Ls_FF78 = tmp_str0000;
            tmp_str0001 = "$" + DoubleToString(Ld_FF98, 2);
           }
        }
     }
   if(Li_FFC8 < ReductionOrderNumber)
      return;
   if(Reduction != true)
      return;
   if((Ld_FFD8 <= 0))
      return;
   Gd_0002 = -Ld_FFE0;
   Gi_0003 = ReductionPercent + 100;
   if((Ld_FFD8 < ((Gd_0002 * Gi_0003) / 100)))
      return;
   Print("Close overlap last order, ticket first order: ", Li_FFD4, " profit first order: ", Ld_FFE0, " ticket last order: ", Li_FFD0, " profit last order: ", Ld_FFD8, " Bid: ", Bid, " Ask: ", Ask);
   Lb_FF97 = OrderSelect(Li_FFD0, 1, 0);
   Li_FF90 = OrderType();
   Gd_0003 = OrderProfit();
   Gd_0003 = (Gd_0003 + OrderSwap());
   Ld_FF98 = ((Gd_0003 + OrderCommission()) + Ld_FF98);
   Ld_FF88 = func_1591(OrderTicket());
   if((Ld_FF88 != -1) && fDraw)
     {
      func_1599(Ld_FF88);
     }
   Lb_FF97 = OrderSelect(Li_FFD4, 1, 0);
   Gd_0003 = OrderProfit();
   Gd_0003 = (Gd_0003 + OrderSwap());
   Ld_FF98 = ((Gd_0003 + OrderCommission()) + Ld_FF98);
   Ld_FF88 = func_1591(OrderTicket());
   if((Ld_FF88 != -1) && fDraw)
     {
      func_1599(Ld_FF88);
     }
   if(fDraw == false)
      return;
   tmp_str0002 = Is_0E30 + "Rez_";
   tmp_str0003 = (string)TimeCurrent();
   tmp_str0002 = tmp_str0002 + tmp_str0003;
   Ls_FF68 = tmp_str0002;
   tmp_str0003 = "$" + DoubleToString(Ld_FF98, 2);
  }
//+-------------------------------



double GOl_Dopf0212=2;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_025152()
  {


   loc_x02152in=0;
   loc_x02152ax=0;
   loc_x02152ax2=0;

   double ppf=FUN_02c(0,Magic)+FUN_02a(0,Magic);
   if(ppf>GOl_Dopf0212)
     {

      FUN_02c01(loc_x02152ax);
      FUN_02c01(loc_x02152in);
     }

   double ppf1=FUN_02c(1,Magic)+FUN_02a(1,Magic);
   if(ppf1>GOl_Dopf0212)
     {

      FUN_02c01(loc_x02152ax);
      FUN_02c01(loc_x02152in);
     }


   ppf=FUN_02c(0,Magic)+FUN_02a(0,Magic)+FUN_02b(0,Magic);
   if(ppf>GOl_Dopf0212)
     {

      FUN_02c01(loc_x02152ax);
      FUN_02c01(loc_x02152ax2);
      FUN_02c01(loc_x02152in);
     }

   ppf1=FUN_02c(1,Magic)+FUN_02a(1,Magic)+FUN_02b(1,Magic);
   if(ppf1>GOl_Dopf0212)
     {

      FUN_02c01(loc_x02152ax);
      FUN_02c01(loc_x02152ax2);
      FUN_02c01(loc_x02152in);
     }


  }


//+------------------------------------------------------------------+
void FUN_02526()  //
  {
   double li_16;
   int ai_0=iDist;
   double order_stoploss_20;
   double points=Point;
   if(1)
     {
      for(int pos_36 = OrdersTotal() - 1; pos_36 >= 0; pos_36--)
        {
         if(OrderSelect(pos_36, SELECT_BY_POS, MODE_TRADES))
           {

            if(OrderSymbol() == Symbol() && OrderMagicNumber()==Magic)
              {
               if(OrderType() == OP_BUYSTOP)
                 {
                  li_16 = NormalizeDouble((OrderOpenPrice() -Bid) / points, 0);
                  if(li_16 < ai_0)
                     continue;

                  order_stoploss_20 = OrderStopLoss();
                  if(OrderOpenPrice()>Bid+iDist*points+100*Point)
                     int  a021=OrderModify(OrderTicket(), Bid+iDist*points, 0, 0, 0, clrNONE);
                 }
               if(OrderType() == OP_SELLSTOP)
                 {
                  li_16 = NormalizeDouble((Ask-OrderOpenPrice()) / points, 0);
                  if(li_16 < ai_0)
                     continue;

                  order_stoploss_20 = OrderStopLoss();
                  if(OrderOpenPrice()<Ask-iDist*points-100*Point)
                     int  a021=     OrderModify(OrderTicket(),  Ask-iDist*points, 0, 0, 0, clrNONE);
                 }
              }

           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1599(double Fa_d_00)
  {
   string Ls0_str0000;
   string Ls0_str0001;
   string Ls0_str0002;
   string Ls0_str0003;
   double Ld_FFF8;
   string Ls_FFE8;
   double Ld_FF90;
   int Li_FF8C;
   long Ll_FF80;
   long Ll_FF78;
   int Li_FF74;

   Ld_FFF8 = 0;
   int Li_FFD0[6] = { 16711680, 255, 16711680, 255, 16711680, 255 };
   Ld_FF90 = 0;
   Li_FF8C = OrderTicket();
   Ll_FF80 = 0;
   Ll_FF78 = 0;
   Ld_FF90 = OrderOpenPrice();
   Ll_FF78 = Time[0];
   Ll_FF80 = OrderOpenTime();
   Li_FF74 = OrderType();
   Ls0_str0000 = Is_0E30 + "Ord_";
   Ls0_str0001 = (string)Li_FF8C;
   Ls0_str0000 = Ls0_str0000 + Ls0_str0001;
   Ls_FFE8 = Ls0_str0000;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      ObjectCreate(0, Ls_FFE8, OBJ_ARROW, 0, Ll_FF80, Ld_FF90, 0, 0, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_ARROWCODE, 1);
      //  Gi_0002 = Li_FFD0[Li_FF74];
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, Gi_0002);
     }
   Ls0_str0001 = Is_0E30 + "Close_";
   Ls0_str0002 = (string)Li_FF8C;
   Ls0_str0001 = Ls0_str0001 + Ls0_str0002;
   Ls_FFE8 = Ls0_str0001;
   Ld_FFF8 = Fa_d_00;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      ObjectCreate(0, Ls_FFE8, OBJ_ARROW, 0, Ll_FF78, Fa_d_00, 0, 0, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_ARROWCODE, 3);
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, 2139610);
     }
   Ls0_str0002 = Is_0E30 + "Ord_Line_";
   Ls0_str0003 = (string)Li_FF8C;
   Ls0_str0002 = Ls0_str0002 + Ls0_str0003;
   Ls_FFE8 = Ls0_str0002;
   if(ObjectFind(Ls_FFE8) == -1)
     {
      //  ObjectCreate(0, Ls_FFE8, OBJ_TREND, 0, Ll_FF80, Ld_FF90, Ll_FF78, Ld_FFF8, 0, 0);
      ObjectSet(Ls_FFE8, OBJPROP_RAY, 0);
      ObjectSet(Ls_FFE8, OBJPROP_STYLE, 2);
      //    Gi_0003 = Li_FFD0[Li_FF74];
      ObjectSet(Ls_FFE8, OBJPROP_COLOR, Gi_0003);
     }
   ArrayFree(Li_FFD0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FUN_1600(string Fa_s_00, long Fa_l_01, double Fa_d_02, string Fa_s_03, color  arg4, int Fa_i_05)
  {
   string Ls0_str0002;
   string Ls0_str0004;
   CCanvas Local_Pointer_FFFFFF68;
   int Li_FF64;
   int Li_FF60;
   bool Lb_FF5F;
   int Li_FF58;
   int Li_FF54;
   int Li_FF50;
   int Li_FF4C;
   int Li_FF48;


   Li_FF64 = 2;
   Li_FF60 = 18;
   Lb_FF5F = false;
   Li_FF58 = 0;
   if(Fa_i_05 == 0)
     {
      Fa_d_02 = ((Ask - Bid) + Fa_d_02);
      Li_FF58 = 2;
     }
   else
     {
      Gd_0000 = (Ask - Bid);
      Fa_d_02 = (Fa_d_02 - Gd_0000);
     }
   Local_Pointer_FFFFFF68.FontNameSet(Font_Metki);
   Local_Pointer_FFFFFF68.FontFlagsSet(7);
   Local_Pointer_FFFFFF68.FontSizeSet(Size_Metki);
   Gi_0000 = 0;
   Gi_0001 = 0;
   Local_Pointer_FFFFFF68.TextSize(Fa_s_03, Gi_0000, Gi_0001);

   Gi_0003 = Li_FF64 * 2;
   Li_FF54 = Gi_0000 + Gi_0003;
   Li_FF50 = 0;
   Li_FF4C = 0;
   Li_FF48 = 0;
   ChartTimePriceToXY(0, 0, Fa_l_01, Fa_d_02, Li_FF50, Li_FF4C);
   Li_FF50 = Li_FF50 - Li_FF54;
   ChartXYToTimePrice(0, Li_FF50, Li_FF4C, Li_FF48, Fa_l_01, Fa_d_02);
   Ls0_str0002 = Fa_s_00;

//Local_Pointer_FFFFFF68.CreateBitmap(0, 0, Ls0_str0002, Fa_l_01, Fa_d_02, Li_FF54, Li_FF60, 0);
   Local_Pointer_FFFFFF68.Erase(arg4);
   Local_Pointer_FFFFFF68.TextOut((Li_FF54 / 2), (Li_FF60 / 2), Fa_s_03, ColorText_Metki, 5);

   ObjectSetInteger(0, Fa_s_00, 1000, 1);
   Ls0_str0004 = StringConcatenate("Profit: ", Fa_s_03);
   ObjectSetString(0, Fa_s_00, 206, Ls0_str0004);
   ObjectSetInteger(0, Fa_s_00, 1011, Li_FF58);
   Local_Pointer_FFFFFF68.Update(true);

  }


//+------------------------------------------------------------------+
