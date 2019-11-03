double buyorderprofit,sellorderprofit;
bool basketdollars=true;
extern int magic=1110;

bool result;


 extern double dollars=11;
 
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



 // Order Close Logic
   
      if(basketdollars){
   
     sellorderprofit=0;
     buyorderprofit=0;
   
  }  

   if(OrdersTotal()>0){
     for(int i=0;i<=OrdersTotal();i++){
        OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
             
           if(OrderType()==OP_SELL && OrderMagicNumber()== magic ){
              if(basketdollars) sellorderprofit=sellorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();
                          }
               if(OrderType()==OP_BUY && OrderMagicNumber()== magic){
              if(basketdollars) buyorderprofit=buyorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();

              }
              
         
             
        }
     }
     
     
 
 
 if(basketdollars) {
 
 Comment("Total order profit is",(sellorderprofit + buyorderprofit));
 if ((buyorderprofit+ sellorderprofit ) > dollars) {
  CloseAllTrades();
   
     
   sellorderprofit=0;
   buyorderprofit=0;
    
    }
    }
  
 
 
     return(0);

 
  }

   
 



// Close all open trades when in profit
void CloseAllTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            if (OrderType()==OP_SELL && OrderMagicNumber()== magic )result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if (OrderType()==OP_BUY && OrderMagicNumber()== magic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_BID),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if ((OrderType()==OP_BUYSTOP ||OrderType()==OP_BUYLIMIT) && OrderMagicNumber()== magic )result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if ((OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT) && OrderMagicNumber()== magic)result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
        }
     else Print( "Error when order select ", GetLastError());
     }
   

  }