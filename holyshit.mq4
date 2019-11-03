#property copyright "Copyright 2016, "
#property link      "forexminerpro.com"




extern double Lots;
extern double  RiskPercent=0.01;

double Risk;
extern int     LotDigits=2;                                 
extern int xTime = 0;

extern int GVari_96 = 111; // magic number
extern double TredeWithSpreadUnder = 4.0;
int GVari_100;
double GVard_104;
double GVard_112;
double GVard_120;
int GVari_152;
double GVard_136;
double GVard_144;
int GVari_156;
int GVari_160 = 0;
int GVari_164 = 0;
int GVari_168 = 0;
string GVars_172 = "";
 double  b_close,s_close;
extern double    TakeProfit=20; // TP of 20pips
extern double    StopLoss=20; // SL of 20pips
extern bool      MonitorTakeProfit=true;
extern bool      MonitorStopLoss=true;
extern double LastBuy = 0.0;
extern double LastSell = 0.0;
bool result;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
  
    Risk=RiskPercent;
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   
   
  double lda_0[][6];
   ArrayCopyRates(lda_0, Symbol(), PERIOD_D1);
   if (xTime != TimeDay(lda_0[0][0]) && DayOfWeek() != 1 ) {
      xTime = TimeDay(lda_0[0][0]);
      LastBuy = lda_0[1][3] + 10.0 * (0.0 * Point);
      LastSell = lda_0[1][2] - 10.0 * (0.0 * Point);
      
      }
   
      b_close = iClose(Symbol(),PERIOD_D1,0);
      s_close = iClose(Symbol(),PERIOD_D1,1);
   
    
    if ( CountOrdersThisPairBUY() == 0 && Ask > LastBuy && GetSpread() < TredeWithSpreadUnder  &&  b_close > s_close) { f0_0(); LastBuy = Ask;
       }
     
    if (CountOrdersThisPairSELL() == 0  && Bid < LastSell && GetSpread() < TredeWithSpreadUnder && b_close < s_close ) { f0_3();LastSell = Bid;
        }
  
   
     AutoSetTPSL();
     
    
      

   
   return (0);
}

double GetSpread() {
   double ld_ret_0 = MarketInfo(Symbol(), MODE_SPREAD) / 10.0;
   return (ld_ret_0);
}



double CalcLotsBasedLoss() {
  
     
 
     if (OrderProfit() >= 0) {  RiskPercent = Risk;}
     if (OrderProfit() < 0) { RiskPercent = Risk + (RiskPercent*2)  ;  }
    
      
   
     
     if(NormalizeDouble(MarketInfo(Symbol(),MODE_LOTSTEP),2)==0.01)LotDigits=2; else LotDigits=1;
      Lots=AccountBalance()*(RiskPercent/100)/(100*Point/MarketInfo(Symbol(),MODE_TICKSIZE)*MarketInfo(Symbol(),MODE_TICKVALUE));
     
     return(Lots);
}

//+------------------------------------------------------------------+
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
          if((MonitorTakeProfit==true)&&(TakeProfit>0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == GVari_96){ // monitor tp
          
                // Calculate take profit
                double tpb=NormalizeDouble(OrderOpenPrice()+TP*Point,Digits);
                double tps=NormalizeDouble(OrderOpenPrice()-TP*Point,Digits);
                    
                Comment("Modifying take profit");
                if((OrderType()==OP_BUY)&&(OrderTakeProfit()==0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == GVari_96){ OrderModify(OrderTicket(),0,OrderStopLoss(),tpb,0,CLR_NONE); }
                if((OrderType()==OP_SELL)&&(OrderTakeProfit()==0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == GVari_96){ OrderModify(OrderTicket(),0,OrderStopLoss(),tps,0,CLR_NONE); }
 
          } // monitor tp
          
          if((MonitorStopLoss==true)&&(StopLoss>0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == GVari_96){ // monitor sl
          
                   // Calculate stop loss
                   double slb=NormalizeDouble(OrderOpenPrice()-SL*Point,Digits);
                   double sls=NormalizeDouble(OrderOpenPrice()+SL*Point,Digits);
 
                   Comment("Modifying stop loss");
                   if((OrderType()==OP_BUY)&&(OrderStopLoss()==0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == GVari_96){ OrderModify(OrderTicket(),0,slb,OrderTakeProfit(),0,CLR_NONE); }
                   if((OrderType()==OP_SELL)&&(OrderStopLoss()==0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == GVari_96){ OrderModify(OrderTicket(),0,sls,OrderTakeProfit(),0,CLR_NONE); }
 
          }// monitor sl
          Comment("");
        }
     }
}

}

// 09CBB5F5CE12C31A043D5C81BF20AA4A
void f0_0() {
   OrderSend(Symbol(), OP_BUY,CalcLotsBasedLoss(), Ask, 3, 0, 0, "Buy ", GVari_96, 0, Green);
}

// 689C35E4872BA754D7230B8ADAA28E48
void f0_3() {
   OrderSend(Symbol(), OP_SELL, CalcLotsBasedLoss(), Bid, 3, 0, 0, " Sell ", GVari_96, 0, Red);
}



// Close all buy  trades when in profit
void CloseAllBuyTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            
            if (OrderType()==OP_BUY && OrderMagicNumber()== GVari_96)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_BID),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if ((OrderType()==OP_BUYSTOP ||OrderType()==OP_BUYLIMIT) && OrderMagicNumber()== GVari_96 )result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
           
        }
     else Print( "Error when order select ", GetLastError());
     }
   

  }
  
  int CountOrdersThisPairBUY() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber() == GVari_96) l_count_0++;
  }
  return (l_count_0);
}

int CountOrdersThisPairSELL() {
  int l_count_0 = 0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_SELL  && OrderMagicNumber() == GVari_96) l_count_0++;
  }
  return (l_count_0);
}

  // Close all sell trades when in profit
void CloseAllSellTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            if (OrderType()==OP_SELL && OrderMagicNumber()== GVari_96 )result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());            
            if ((OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT) && OrderMagicNumber()== GVari_96)result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
        }
     else Print( "Error when order select ", GetLastError());
     }
   

  }