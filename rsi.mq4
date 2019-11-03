#property description "HS Expert Advisor M5 Chart - 1 to 3 Risk to Reward"
#property copyright "Copyright © 2016,pjag"
#property version "2.0" // current version of the expert advisor
#property strict
extern double lot=0.01;
extern double    TakeProfit=15; // TP
extern double    StopLoss=5; // SL
extern bool      MonitorTakeProfit=true;
extern bool      MonitorStopLoss=true;


double  BuyLevel=0.8;                                //RSI3 value for buying
double  SellLevel=99.2;                              //RSI3 value for selling
double         rsi3;
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

    rsi3 = iRSI(Symbol(),PERIOD_M5,3,PRICE_CLOSE,0);
 
   bool rsi3buysignal=false;
   bool rsi3sellsignal=false;

   if(rsi3<BuyLevel){rsi3buysignal=true;}
   if(rsi3>SellLevel){rsi3sellsignal=true;}
 
   
   if ( rsi3buysignal && CountOrdersThisPairBUY() ==0)
   {
   OrderSend(Symbol(),OP_BUY,lot,Ask,3,0,0,"",0,0,Green);
 
   }
   if (rsi3sellsignal && CountOrdersThisPairSELL() ==0) {
  
   OrderSend(Symbol(),OP_SELL,lot,Bid,3,0,0,"",0,0,Green);
 
  
   }
   
 

if (CountOrdersThisPairBUY()> 0 || CountOrdersThisPairSELL() > 0)

{

 
         AutoSetTPSL();
       
      }


   return(0);
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

//----
int Error=GetLastError();
  if(Error==130){Alert("Wrong stops. Retrying."); RefreshRates();}
  if(Error==133){Alert("Trading prohibited.");}
  if(Error==2){Alert("Common error.");}
  if(Error==146){Alert("Trading subsystem is busy. Retrying."); Sleep(500); RefreshRates();}
 
//----------
   return;
  }
//----------


int CountOrdersThisPairBUY() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_BUY ) l_count_0++;
  }
  return (l_count_0);
}

int CountOrdersThisPairSELL() {
  int l_count_0 = 0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_SELL ) l_count_0++;
  }
  return (l_count_0);
}
