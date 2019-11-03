extern double lots=0.1;
extern string Symbol1 = "AUDUSD";
extern string Symbol2 = "USDCAD";
extern double smalldollars=100;
extern double bigdollars=100;
extern double dollars=10;
extern int smallmagic=3;
extern int bigmagic=4;
bool basketdollars=true;                // enable basket dollars    
int xTime = 0;
double smallbuyorderprofit,smallsellorderprofit,bigbuyorderprofit,bigsellorderprofit,Sellorderprofit,Buyorderprofit;
bool runnable=true;
bool init=true;
bool result;
double pBid, pAsk, pp;
int i=0;
datetime timeprev=0;
double pt;



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
{
  
     
   return(0);
}


//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
  
   return(0);
}


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{  

          
  
       if (CountOrdersThisPairSmallBUY() == 0 && CountOrdersThisPairSmallSELL() == 0 )
{
   OrderSend(Symbol1,OP_SELL,lots,Ask,3,0,0,"Sell",smallmagic,0,Green);
   OrderSend(Symbol2,OP_SELL,lots,Ask,3,0,0,"Sell",bigmagic,0,Green);
   OrderSend(Symbol1,OP_BUY,lots,Bid,3,0,0,"Buy",smallmagic,0,Green);
   OrderSend(Symbol2,OP_BUY,lots,Bid,3,0,0,"Buy",bigmagic,0,Green);
  
}

  
       if (CountOrdersThisPairSmallBUY() == 1 && CountOrdersThisPairSmallSELL() == 0 )
{
   OrderSend(Symbol1,OP_BUY,lots,Bid,3,0,0,"Buy",smallmagic,0,Green);
   OrderSend(Symbol2,OP_BUY,lots,Bid,3,0,0,"Buy",bigmagic,0,Green);
  
}

  
       if (CountOrdersThisPairSmallBUY() == 0 && CountOrdersThisPairSmallSELL() == 1 )
{
   OrderSend(Symbol1,OP_SELL,lots,Ask,3,0,0,"Sell",smallmagic,0,Green);
   OrderSend(Symbol2,OP_SELL,lots,Ask,3,0,0,"Sell",bigmagic,0,Green);
  
}


//  Print("Sellorderprofit is ",Sellorderprofit);
//  Print("Buyorderprofit is ",Buyorderprofit);
  
  
if(basketdollars){
     
      smallsellorderprofit=0;
      bigbuyorderprofit=0;
      smallbuyorderprofit=0;
      bigsellorderprofit=0;
     
   }  
 
    if(OrdersTotal()>0){
      for(i=0;i<=OrdersTotal();i++){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
               
            if(OrderType()==OP_SELL && OrderMagicNumber()== smallmagic){
               if(basketdollars) smallsellorderprofit=smallsellorderprofit+ OrderProfit()+ OrderCommission() + OrderSwap(); 
                           }
                if(OrderType()==OP_BUY && OrderMagicNumber()== bigmagic){
               if(basketdollars) bigbuyorderprofit=bigbuyorderprofit+ OrderProfit()+ OrderCommission() + OrderSwap(); 

               }
               
                if(OrderType()==OP_SELL && OrderMagicNumber()== bigmagic){
               if(basketdollars) bigsellorderprofit=bigsellorderprofit+ OrderProfit()+ OrderCommission() + OrderSwap(); 
                           }
                if(OrderType()==OP_BUY && OrderMagicNumber()== smallmagic){
               if(basketdollars) smallbuyorderprofit=smallbuyorderprofit+ OrderProfit()+ OrderCommission() + OrderSwap(); 

               }
         
               
         }
      }
      
      
   Sellorderprofit = (smallsellorderprofit + bigsellorderprofit);
   Buyorderprofit = (smallbuyorderprofit + bigbuyorderprofit);
   
  
   
  if(basketdollars) {
  
  if ((smallsellorderprofit+bigsellorderprofit) >=smalldollars ) { closeallsmallsellorders(); closeallbigsellorders();
  }
  if ((smallbuyorderprofit+bigbuyorderprofit)>=bigdollars ) {closeallbigbuyorders(); closeallsmallbuyorders(); 
  }
  
  if ((smallsellorderprofit+bigsellorderprofit+smallbuyorderprofit+bigbuyorderprofit) >=dollars ) { closeallorders();
  }
  
  }
     return(0);
   
}

int CountOrdersThisPairSmallBUY() {
   int l_count_0 = 0;
   for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
      OrderSelect(l_pos_4, SELECT_BY_POS);
      if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber() == smallmagic) l_count_0++;
   }
   return (l_count_0);
}

int CountOrdersThisPairBigSELL() {
   int l_count_0;
   for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
      OrderSelect(l_pos_4, SELECT_BY_POS);
      if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber() == bigmagic) l_count_0++;
   }
   return (l_count_0);
}


int CountOrdersThisPairSmallSELL() {
   int l_count_0 = 0;
   for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
      OrderSelect(l_pos_4, SELECT_BY_POS);
      if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber() == smallmagic) l_count_0++;
   }
   return (l_count_0);
}

int CountOrdersThisPairBigBUY() {
   int l_count_0;
   for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
      OrderSelect(l_pos_4, SELECT_BY_POS);
      if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber() == bigmagic) l_count_0++;
   }
   return (l_count_0);
}


// Close all buyopen trades when in profit
void closeallsmallbuyorders(){
 for (i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
             if (OrderType()==OP_BUY && OrderMagicNumber() == smallmagic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,CLR_NONE);
             if(result!=TRUE) Print("LastError = ", GetLastError());
         }
      else Print( "Error when order select ", GetLastError());
      }
   
}

// Close all sell open trades when in profit
void closeallbigsellorders(){
 for (i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
             if (OrderType()==OP_SELL && OrderMagicNumber()== bigmagic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
             if(result!=TRUE) Print("LastError = ", GetLastError());
                }
      else Print( "Error when order select ", GetLastError());
      }
   
}

// Close all buyopen trades when in profit
void closeallbigbuyorders(){
 for (i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
             if (OrderType()==OP_BUY && OrderMagicNumber() == bigmagic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,CLR_NONE);
             if(result!=TRUE) Print("LastError = ", GetLastError());
         }
      else Print( "Error when order select ", GetLastError());
      }
   
}

// Close all sell open trades when in profit
void closeallsmallsellorders(){
 for (i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
             if (OrderType()==OP_SELL && OrderMagicNumber()== smallmagic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
                          if(result!=TRUE) Print("LastError = ", GetLastError());
                }
      else Print( "Error when order select ", GetLastError());
      }
   
}

void closeallorders(){
 for (i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
             if (OrderType()==OP_SELL && OrderMagicNumber()== smallmagic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
             if (OrderType()==OP_SELL && OrderMagicNumber()== bigmagic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
             if (OrderType()==OP_BUY && OrderMagicNumber() == bigmagic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,CLR_NONE);
             if (OrderType()==OP_BUY && OrderMagicNumber() == smallmagic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,CLR_NONE);
             if(result!=TRUE) Print("LastError = ", GetLastError());
                }
      else Print( "Error when order select ", GetLastError());
      }
   
   
}