#property copyright "Copyright 2013, www.topforexrobot.net"
#property link      "http://www.topforexrobot.net"

extern double FixLot = 0.3;
extern string Website = "www.topforexrobot.net";
extern double GVari_92 = 550;
string time,sig;
extern double hedge=1100.0;
extern int GVari_96 = 111;
int GVari_100;
double GVard_104;
double GVard_112;
double GVard_120;
double GVard_128;
double GVard_136;
double GVard_144;
int GVari_152;
int GVari_156;
int GVari_160 = 0;
int GVari_164 = 0;
int GVari_168 = 0;
string GVars_172 = "";
double buyorderprofit,sellorderprofit;
bool basketdollars=true;
extern double dollars=82.5;
bool result;


// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   GVard_128 = FixLot;
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   f0_7();
   
   f0_4();
   f0_8();
   f0_2();
   sig=ObjectDescription("Type_mslin10");
  
    sig=StringSubstr(sig,0,3);
   
     time=ObjectDescription("Time_mslin10");
    
    time=StringSubstr(time,14,StringLen(time)-1);
    
   if (OrdersTotal() == 0) GVari_100 = AccountBalance();
   int Lcali_0 = GVari_92 - 13;
   if (CountOrdersThisPair() < 1 && currentorder(time, TimeCurrent())==1) {
      if ( sig=="BUY" && CountOrdersThisPairBUY() == 0) f0_0();
       if ( sig=="SEL" && CountOrdersThisPairSELL() == 0) f0_3();
   }
   
   f0_1();
   
   if (CountOrdersThisPairMainBUY() > 0 || CountOrdersThisPairMainSELL() > 0) {
   if (GVard_112 < 2500.0 && Ask > GVard_104 + GVari_92 * Point) f0_0();
   if (GVard_120 < 2500.0 && Bid < GVard_104 - GVari_92 * Point) f0_3();
  }  
   
   
   for (int Lcali_4 = 0; Lcali_4 < OrdersTotal(); Lcali_4++) {
      OrderSelect(Lcali_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderStopLoss() == 0.0 && OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == GVari_96 && Bid > OrderOpenPrice() + hedge * Point) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() + 30.0 * Point, OrderTakeProfit(), 0, Blue);
   }
   for (int Lcali_8 = 0; Lcali_8 < OrdersTotal(); Lcali_8++) {
      OrderSelect(Lcali_8, SELECT_BY_POS, MODE_TRADES);
      if (OrderStopLoss() == 0.0 && OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == GVari_96 && Bid < OrderOpenPrice() - hedge * Point) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - 30.0 * Point, OrderTakeProfit(), 0, Blue);
   }
  
   Comment("\nBalance = ", AccountBalance(), 
      "\nEquity = ", AccountEquity(), 
      "\nFree = ", AccountFreeMargin(), 
      "\nProfit = ", AccountProfit(), 
      "\nBuy = ", GVard_112, 
      "\nSell = ", GVard_120, 
      "\nTotalClosed = ", OrdersHistoryTotal(), 
      "\nAB = ", GVari_100, 
   "\nHour = ", Hour() );
   
   
   // Order Close Logic
   
      if(basketdollars){
   
     sellorderprofit=0;
     buyorderprofit=0;
   
  }  

   if(OrdersTotal()>0){
     for(int i=0;i<=OrdersTotal();i++){
        OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
             
           if(OrderType()==OP_SELL && OrderMagicNumber()== GVari_96 ){
              if(basketdollars) sellorderprofit=sellorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();
                          }
               if(OrderType()==OP_BUY && OrderMagicNumber()== GVari_96 ){
              if(basketdollars) buyorderprofit=buyorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();

              }
              
         
             
        }
     }
     
     
 
 
 if(basketdollars) {
 
 
 if ((buyorderprofit+ sellorderprofit ) > dollars) {
   RefreshRates();
   CloseAllTrades();
     
   sellorderprofit=0;
   buyorderprofit=0;
    
    }
    }

   
   
   
   return (0);
}

// 09CBB5F5CE12C31A043D5C81BF20AA4A
void f0_0() {
   OrderSend(Symbol(), OP_BUY, GVard_128, Ask, 3, 0, 0, "stpbuy", GVari_96, 0, Green);
}

// 689C35E4872BA754D7230B8ADAA28E48
void f0_3() {
   OrderSend(Symbol(), OP_SELL, GVard_128, Bid, 3, 0, 0, "stpsell", GVari_96, 0, Red);
}

// 945D754CB0DC06D04243FCBA25FC0802
int f0_5(int Argmi_0, string Argms_4, int Argmi_12) {
   int Lcali_16 = 0;
   for (int Lcali_20 = OrdersTotal() - 1; Lcali_20 >= 0; Lcali_20--) {
      if (OrderSelect(Lcali_20, SELECT_BY_POS, MODE_TRADES))
         if (OrderType() == Argmi_0 && OrderSymbol() == Argms_4 && OrderMagicNumber() == Argmi_12) Lcali_16++;
   }
   return (Lcali_16);
}

// A9B24A824F70CC1232D1C2BA27039E8D
void f0_7() {
   GVard_112 = f0_5(OP_BUY, Symbol(), GVari_96);
   GVard_120 = f0_5(OP_SELL, Symbol(), GVari_96);
}

// 2569208C5E61CB15E209FFE323DB48B7
void f0_1() {
   for (int Lcali_0 = 0; Lcali_0 < OrdersTotal(); Lcali_0++) {
      OrderSelect(Lcali_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == GVari_96) GVard_104 = OrderOpenPrice();
   }
}

// 6ABA3523C7A75AAEA41CC0DEC7953CC5
void f0_4() {
   for (int Lcali_0 = 0; Lcali_0 < OrdersTotal(); Lcali_0++) OrderSelect(Lcali_0, SELECT_BY_POS, MODE_TRADES);
}

// D1DDCE31F1A86B3140880F6B1877CBF8
void f0_8() {
   for (int Lcali_0 = 0; Lcali_0 < OrdersTotal(); Lcali_0++) {
      OrderSelect(Lcali_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderType() == OP_BUY  && OrderMagicNumber() == GVari_96) {
         GVard_136 = NormalizeDouble(OrderProfit(), 2);
         GVari_152 = OrderTicket();
      }
   }
}

// 5710F6E623305B2C1458238C9757193B
void f0_2() {
   for (int Lcali_0 = 0; Lcali_0 < OrdersTotal(); Lcali_0++) {
      OrderSelect(Lcali_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderType() == OP_SELL  && OrderMagicNumber() == GVari_96) {
         GVard_144 = NormalizeDouble(OrderProfit(), 2);
         GVari_156 = OrderTicket();
      }
   }
}

// Close all open trades when in profit
void CloseAllTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            if (OrderType()==OP_SELL && OrderMagicNumber()== GVari_96 )result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if (OrderType()==OP_BUY && OrderMagicNumber()== GVari_96)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_BID),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if ((OrderType()==OP_BUYSTOP ||OrderType()==OP_BUYLIMIT) && OrderMagicNumber()== GVari_96 )result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if ((OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT) && OrderMagicNumber()== GVari_96)result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
        }
     else Print( "Error when order select ", GetLastError());
     }
   

  }
  

int CountOrdersThisPair() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if ( OrderSymbol() == Symbol()  && OrderMagicNumber() == GVari_96 ) l_count_0++;
  }
  return (l_count_0);
}

int CountOrdersThisPairBUY() {
int l_count_0;
for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
OrderSelect(l_pos_4, SELECT_BY_POS);
if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber() == GVari_96 ) l_count_0++;
}
return (l_count_0);
}
int CountOrdersThisPairSELL() {
int l_count_0 = 0;
for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
OrderSelect(l_pos_4, SELECT_BY_POS);
if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber() == GVari_96 ) l_count_0++;
}
return (l_count_0);
}

int CountOrdersThisPairMainBUY() {
int l_count_0;
for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
OrderSelect(l_pos_4, SELECT_BY_POS);
if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber() == GVari_96 && OrderComment() == "stpbuy") l_count_0++;
}
return (l_count_0);
}
int CountOrdersThisPairMainSELL() {
int l_count_0 = 0;
for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
OrderSelect(l_pos_4, SELECT_BY_POS);
if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber() == GVari_96 && OrderComment() == "stpsell") l_count_0++;
}
return (l_count_0);
}

int currentorder(string ttv, datetime nowtime)
{
if(StringLen(ttv)<1) return 0;
int h,m,d;
int th, tm, td;
h=TimeHour(nowtime);
m=TimeMinute(nowtime);
d=TimeDay(nowtime);

th=StringSubstr(ttv,11,2);
tm=StringSubstr(ttv,14,2);
td=StringSubstr(ttv,8,2);
if(h==th && m==tm && d==td) return 1;

return 0;

}
