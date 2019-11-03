#property copyright "Copyright 2016, scoobidoobi"
#property link      "http://www.forexfactory.com/scoobidoobi"

extern double FixLot = 0.02;


double a,b,c,d;
extern int xTime = 0;

extern int GVari_96 = 111; // magic number
double buyorderprofit,sellorderprofit;
bool basketdollars=true;

int GVari_100;
double GVard_104;
double GVard_112;
double GVard_120;
double GVard_128;
int GVari_152;
double GVard_136;
double GVard_144;
int GVari_156;
int GVari_160 = 0;
int GVari_164 = 0;
int GVari_168 = 0;
string GVars_172 = "";
extern double GVari_92 = 200;//distance between orders

bool result;
extern double dollars=4;// profit target to close all orders and start afresh

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
   f0_1();
   f0_4();
   f0_8();
   f0_2();
   if (OrdersTotal() == 0) GVari_100 = AccountBalance();
   int Lcali_0 = GVari_92 - 13;
   
    double lda_0[][6];
     
      ArrayCopyRates(lda_0, Symbol(), PERIOD_D1);
         if (xTime != TimeDay(lda_0[0][0]) && DayOfWeek() != 1 ) {
            xTime = TimeDay(lda_0[0][0]);
            a=iLow(Symbol(), PERIOD_D1, 1);
            c=iHigh(Symbol(), PERIOD_D1, 1);
            }
     b=iLow(Symbol(), PERIOD_M1, 1);
      if (b < a) a=b;
   if (OrdersTotal() < 1) {
   
      

     if (Ask > c)  f0_0();
     if (Bid < a) f0_3();
   }
   if (GVard_112 < 2500.0 && Ask > GVard_104 + GVari_92 * Point) f0_0();
   if (GVard_120 < 2500.0 && Bid < GVard_104 - GVari_92 * Point) f0_3();
   
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
               if(OrderType()==OP_BUY && OrderMagicNumber()== GVari_96){
              if(basketdollars) buyorderprofit=buyorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();

              }
              
         
             
        }
     }
     
     
 
 
 if(basketdollars) {
 
// Comment("Total order profit is",(sellorderprofit + buyorderprofit));
 if ((buyorderprofit+ sellorderprofit ) > dollars) {
  CloseAllTrades();
   
     
   sellorderprofit=0;
   buyorderprofit=0;
    
    }
    }
  
 
 
 
   
   return (0);
}

// 09CBB5F5CE12C31A043D5C81BF20AA4A
void f0_0() {
   OrderSend(Symbol(), OP_BUY, GVard_128, Ask, 3, 0, 0, "Buy ", GVari_96, 0, Green);
}

// 689C35E4872BA754D7230B8ADAA28E48
void f0_3() {
   OrderSend(Symbol(), OP_SELL, GVard_128, Bid, 3, 0, 0, " Sell ", GVari_96, 0, Red);
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
      if (OrderSymbol() == Symbol() && OrderType() == OP_BUY) {
         GVard_136 = NormalizeDouble(OrderProfit(), 2);
         GVari_152 = OrderTicket();
      }
   }
}

// 5710F6E623305B2C1458238C9757193B
void f0_2() {
   for (int Lcali_0 = 0; Lcali_0 < OrdersTotal(); Lcali_0++) {
      OrderSelect(Lcali_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderType() == OP_SELL) {
         GVard_144 = NormalizeDouble(OrderProfit(), 2);
         GVari_156 = OrderTicket();
      }
   }
}

// 9B1AEE847CFB597942D106A4135D4FE6
int f0_6() {
   int Lcali_0 = OrdersTotal();
   int Lcali_4 = 0;
   GVari_160 = 0;
   RefreshRates();
   if (OrderType() != OP_BUY && OrderType() != OP_SELL) OrderDelete(OrderTicket());
   switch (GVari_164) {
   case 0:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
         if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
         if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
      }
      break;
   case 1:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
         if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
      }
      break;
   case 2:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
      }
      break;
   case 3:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderMagicNumber() == GVari_168) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
      break;
   case 4:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderComment() == GVars_172) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
      break;
   case 5:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderProfit() > 0.0) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
      break;
   case 6:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderProfit() < 0.0) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
      break;
   case 7:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (TimeDay(OrderOpenTime()) < TimeDay(TimeCurrent())) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
   }
   return (0);
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