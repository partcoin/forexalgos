// Version Sep 12/9/16 -signed by MasterGenie
extern double     lot            = 0.01; //Risk lot per trade
double a,c;
extern int xTime = 0;
extern int numberlimitbuy=2; // no.of buys
extern int numberlimitsell=2; // no. of sells
extern double    TakeProfit=60; // TP of 60pips
extern double    StopLoss=30; // SL of 30pips
extern bool      MonitorTakeProfit=true;
extern bool      MonitorStopLoss=true;
extern int startHour=1; // trade starting from 1 MT4 time
extern int endHour=22; // trade ending till 22 MT4 time
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


 
 

     double lda_0[][6];
     
     // Prev highs/lows
      a=iLow(Symbol(), PERIOD_D1, 1);
      c=iHigh(Symbol(), PERIOD_D1, 1);
     
     ArrayCopyRates(lda_0, Symbol(), PERIOD_D1);
         if (xTime != TimeDay(lda_0[0][0]) && DayOfWeek() != 1 ) {
            xTime = TimeDay(lda_0[0][0]);
           
            numberlimitbuy=2;
            numberlimitsell=2;
            }

   
   
   
  

   if (Ask > c && CountOrdersThisPairBUY() == 0  && numberlimitbuy > 0 && GetSpread() < 6.0 && Hour() >= startHour&& Hour() <=endHour) {OrderSend(Symbol(),OP_BUY,lot,Ask,3,0,0,"",0,0,Green);numberlimitbuy--;}
   if (Bid < a && CountOrdersThisPairSELL() == 0 && numberlimitsell > 0 && GetSpread() < 6.0 && Hour() >= startHour && Hour() <=endHour) {OrderSend(Symbol(),OP_SELL,lot,Bid,3,0,0,"",0,0,Green);numberlimitsell--;}

   AutoSetTPSL();


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


 double GetSpread() {
   double ld_ret_0 = MarketInfo(Symbol(), MODE_SPREAD) / 10.0;
   return (ld_ret_0);
   }
void AutoSetTPSL() {

  int StopMultd=10;
   double TP=NormalizeDouble(TakeProfit*StopMultd,Digits);
   double SL=NormalizeDouble(StopLoss*StopMultd,Digits);
   
 //-------------------------------------------------------------------+
//Check open orders
//-------------------------------------------------------------------+
if(OrdersTotal()>0){
  for(int i=1; i<=OrdersTotal(); i++)          // Cycle searching in orders
     {
      if (OrderSelect(i-1,SELECT_BY_POS)==true) // If the next is available
        {
          if((MonitorTakeProfit==true)&&(TakeProfit>0)&&(OrderSymbol()==Symbol())){ // monitor tp
          
                // Calculate take profit
                double tpb=NormalizeDouble(OrderOpenPrice()+TP*Point,Digits);
                double tps=NormalizeDouble(OrderOpenPrice()-TP*Point,Digits);
                    
                Comment("Modifying take profit");
                if((OrderType()==OP_BUY)&&(OrderTakeProfit()==0)&&(OrderSymbol()==Symbol())){ OrderModify(OrderTicket(),0,OrderStopLoss(),tpb,0,CLR_NONE); }
                if((OrderType()==OP_SELL)&&(OrderTakeProfit()==0)&&(OrderSymbol()==Symbol())){ OrderModify(OrderTicket(),0,OrderStopLoss(),tps,0,CLR_NONE); }
 
          } // monitor tp
          
          if((MonitorStopLoss==true)&&(StopLoss>0)&&(OrderSymbol()==Symbol())){ // monitor sl
          
                   // Calculate stop loss
                   double slb=NormalizeDouble(OrderOpenPrice()-SL*Point,Digits);
                   double sls=NormalizeDouble(OrderOpenPrice()+SL*Point,Digits);
 
                   Comment("Modifying stop loss");
                   if((OrderType()==OP_BUY)&&(OrderStopLoss()==0)&&(OrderSymbol()==Symbol())){ OrderModify(OrderTicket(),0,slb,OrderTakeProfit(),0,CLR_NONE); }
                   if((OrderType()==OP_SELL)&&(OrderStopLoss()==0)&&(OrderSymbol()==Symbol())){ OrderModify(OrderTicket(),0,sls,OrderTakeProfit(),0,CLR_NONE); }
 
          }// monitor sl
          Comment("");
        }
     }
}

}