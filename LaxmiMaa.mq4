//+------------------------------------------------------------------+
//|                                                   SWingerEA.mq4 |
//|                                  
//+------------------------------------------------------------------+
#property copyright "Copyright © 2015, swinger"
#property link      "swinger"
extern double     MaxRiskPercent             = 0.02; //Risk % per trade
double a;
double b;
double c;
double d;
extern int xTime = 0;
extern bool       AccountIsMicro          = true;
extern int orderlimit=1;
extern int buylimit=0;
extern int selllimit=0;
bool result;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----

 int    decimalPlaces=1;
 
 
if (Period() >= 1440)
{

     double lda_0[][6];
   
     ArrayCopyRates(lda_0, Symbol(), PERIOD_W1);
         if (xTime != TimeDay(lda_0[0][0]) && DayOfWeek() != 1 ) {
            xTime = TimeDay(lda_0[0][0]);
            a=iLow(Symbol(), PERIOD_W1, 1);
            c=iHigh(Symbol(), PERIOD_W1, 1);
            buylimit=orderlimit;
            selllimit=orderlimit;
            double  b_close = iClose(Symbol(),PERIOD_W1,0);
            double  s_close = iClose(Symbol(),PERIOD_W1,1);

            }

   double H1 = iHigh(Symbol(),PERIOD_W1,1);
   double L1 = iLow(Symbol(),PERIOD_W1,1);
   double H0 = iHigh(Symbol(),PERIOD_W1,0);
   double L0 = iLow(Symbol(),PERIOD_W1,0);
   double DH1 = iHigh(Symbol(),PERIOD_D1,1);
   double DL1 = iLow(Symbol(),PERIOD_D1,1);
   double DH0 = iHigh(Symbol(),PERIOD_D1,0);
   double DL0 = iLow(Symbol(),PERIOD_D1,0);
 
  
  // Lots Calculation
      if(AccountIsMicro==true) decimalPlaces=2;
 
      double lot = NormalizeDouble(AccountFreeMargin()*MaxRiskPercent/1000.0,decimalPlaces);
      
      Comment("\nBalance = ", AccountBalance(),
      "\nEquity = ", AccountEquity(),
      "\nFree = ", AccountFreeMargin(),
      "\nProfit = ", AccountProfit(),
      "\nBuy if >= ", H1,
      "\nSell if <= ", L1,
      "\n Initial Stop for buy = ", L0,
      "\n Initial Stop for sell = ", H0,
   "\nLot to be used = ", lot);
     b=iLow(Symbol(), PERIOD_M1, 1);
if (b < a) a=b;
  d=iHigh(Symbol(), PERIOD_M1, 1);
if (d > c) c=d;
   
   if (Ask > c && CountOrdersThisPairBUY() == 0 &&  buylimit > 0 ) {OrderSend(Symbol(),OP_BUY,lot,Ask,3,L1,0,"",0,0,Green); buylimit--;}
   if (Bid < a && CountOrdersThisPairSELL() == 0 &&  selllimit > 0 ) {OrderSend(Symbol(),OP_SELL,lot,Bid,3,H1,0,"",0,0,Green); selllimit--;}
  

  if(OrdersTotal()>0){
     for(int i=0;i<=OrdersTotal();i++){
        OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
             
           if(OrderType()==OP_SELL && OrderSymbol()== Symbol() && b_close > s_close){
             CloseAllBuyTrades();
                          }
               if(OrderType()==OP_BUY && OrderSymbol()== Symbol() && b_close < s_close){
              CloseAllSellTrades();

              }
              
         
             
        }
     }
}
}
int CountOrdersThisPairBUY() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_BUY) l_count_0++;
  }
  return (l_count_0);
}

int CountOrdersThisPairSELL() {
  int l_count_0 = 0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_SELL  ) l_count_0++;
  }
  return (l_count_0);
}

// Close all buy  trades when in profit
void CloseAllBuyTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            
            if (OrderType()==OP_BUY && OrderSymbol()== Symbol())result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_BID),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if ((OrderType()==OP_BUYSTOP ||OrderType()==OP_BUYLIMIT) && OrderSymbol()== Symbol() )result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
           
        }
     else Print( "Error when order select ", GetLastError());
     }
   

  }
  
  
  // Close all sell trades when in profit
void CloseAllSellTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            if (OrderType()==OP_SELL && OrderSymbol() == Symbol() )result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());            
            if ((OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT) && OrderSymbol()== Symbol())result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
        }
     else Print( "Error when order select ", GetLastError());
     }
   

  }