#property copyright "Copyright 2013, www.scalpguru.com"
#property link      "coming soon.."


// version 2.0 williamsmillions sep 14th,2016
// Courtesy:Ichimoku Masuta Kotaro

extern double lots = 0.01;


extern int Magic=33;

double william1,william2,prevwilliam1;
double williamprofithigh=-6.25;
double williamprofitlow=-93.75;
double willhigh=-87.5;
double willlow=-12.5;
bool result;
extern double    StopLoss=30; // SL of 30pips
extern double    TakeProfit=0; // TP open
extern bool      MonitorTakeProfit=false;
extern bool      MonitorStopLoss=true;
double maNrml,maShift;
 string sig="";

int init() {
  return (0);
}

int deinit() {
  return (0);
}

int start() {

  RefreshRates();

william1=iWPR(NULL,0,128,0);
prevwilliam1=iWPR(NULL,0,128,1);

william2=iWPR(NULL,0,64,0); // Not in use



maNrml=iMA(NULL,0,128,0,MODE_SMA,PRICE_WEIGHTED,128);
maShift=iMA(NULL,0,128,0,MODE_SMA,PRICE_WEIGHTED,0);



Strategy_1();

   
  
   
   
   
     
return(0);
 }          
             
 



int Strategy_1() {
  string l_dbl2str_12="willmillma";

   
    RefreshRates();
    
   // Entry conditions
   
   
    
    if (maShift > maNrml && william1 > willhigh && prevwilliam1 <=willhigh ) { sig="buy"; }
    
    if (maShift < maNrml && william1 < willlow && prevwilliam1 >= willlow) { sig="sell";}
    
    
    
   
    
    if (CountOrdersThisPairBUY() ==0  && sig == "buy" && CountOrdersThisPairSELL() ==0) {
   
   OrderSend(Symbol(), OP_BUY,  lots , Ask, 3, 0,0, l_dbl2str_12, Magic, 0, RoyalBlue);
   sig="";
    }

   
    
    if (CountOrdersThisPairSELL() ==0 && sig == "sell" && CountOrdersThisPairBUY() ==0 ) {
    OrderSend(Symbol(), OP_SELL,  lots , Bid, 3, 0, 0, l_dbl2str_12, Magic, 0, Red);
    sig="";
   }
   
   // take profit logic
   
   if (CountOrdersThisPairBUY()>0 && william1 < williamprofithigh && prevwilliam1 >=williamprofithigh) {

   CloseAllBuyTrades();
   
   }
   if (CountOrdersThisPairSELL()>0 && william1 > williamprofitlow && prevwilliam1 <=williamprofitlow) {

   CloseAllSellTrades();
   
   }
   
   // stoploss logic
   
    AutoSetTPSL();
  
 
 
     
   return (0);
}

int CountOrdersThisPairBUY() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber() == Magic) l_count_0++;
  }
  return (l_count_0);
}

int CountOrdersThisPairSELL() {
  int l_count_0 = 0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_SELL  && OrderMagicNumber() == Magic) l_count_0++;
  }
  return (l_count_0);
}


// Close all open sell trades 
void CloseAllSellTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            
            if (OrderType()==OP_SELL  && OrderSymbol()== Symbol() && OrderMagicNumber() == Magic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_BID),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            
            
        }
     else Print( "Error when order select ", GetLastError());
     }
}   


// Close all open buy trades 
void CloseAllBuyTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            
            if (OrderType()==OP_BUY && OrderSymbol()== Symbol() && OrderMagicNumber() == Magic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_BID),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            
            
        }
     else Print( "Error when order select ", GetLastError());
     }
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
          if((MonitorTakeProfit==true)&&(TakeProfit>0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == Magic){ // monitor tp
          
                // Calculate take profit
                double tpb=NormalizeDouble(OrderOpenPrice()+TP*Point,Digits);
                double tps=NormalizeDouble(OrderOpenPrice()-TP*Point,Digits);
                    
                Comment("Modifying take profit");
                if((OrderType()==OP_BUY)&&(OrderTakeProfit()==0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == Magic){ OrderModify(OrderTicket(),0,OrderStopLoss(),tpb,0,CLR_NONE); }
                if((OrderType()==OP_SELL)&&(OrderTakeProfit()==0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == Magic){ OrderModify(OrderTicket(),0,OrderStopLoss(),tps,0,CLR_NONE); }
 
          } // monitor tp
          
          if((MonitorStopLoss==true)&&(StopLoss>0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == Magic){ // monitor sl
          
                   // Calculate stop loss
                   double slb=NormalizeDouble(OrderOpenPrice()-SL*Point,Digits);
                   double sls=NormalizeDouble(OrderOpenPrice()+SL*Point,Digits);
 
                   Comment("Modifying stop loss");
                   if((OrderType()==OP_BUY)&&(OrderStopLoss()==0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == Magic){ OrderModify(OrderTicket(),0,slb,OrderTakeProfit(),0,CLR_NONE); }
                   if((OrderType()==OP_SELL)&&(OrderStopLoss()==0)&&(OrderSymbol()==Symbol()) && OrderMagicNumber() == Magic){ OrderModify(OrderTicket(),0,sls,OrderTakeProfit(),0,CLR_NONE); }
 
          }// monitor sl
          Comment("");
        }
     }
}

}

