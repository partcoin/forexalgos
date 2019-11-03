#property copyright "Copyright 2013, www.scalpguru.com"
#property link      "coming soon.."



extern double lots = 0.01;

extern int incr=1;
extern double hedge=1000;

extern int Magic=200;

double buyorderprofit,sellorderprofit;
bool basketdollars=true;


bool result;


 extern double dollars=10;
extern double oned=1;




int init() {
  return (0);
}

int deinit() {
  return (0);
}

int start() {


Strategy_1();

 

return(0);
 }          
             
 



int Strategy_1() {
  string l_dbl2str_12="slom";
 



   if (CountOrdersThisPairBUY() == 0 && CountOrdersThisPairSELL() == 0  ) {
 
      OrderSend(Symbol(), OP_SELL,  lots , Bid, 3, 0, 0, l_dbl2str_12, Magic, 0, Red);
       OrderSend(Symbol(), OP_BUY,  lots , Ask, 3, 0,0, l_dbl2str_12, Magic, 0, RoyalBlue);
       
         if ( CountOrdersThisPairSELL() > 0 && CountOrdersThisPairBUY() > 0) {
       OrderSend(Symbol(),OP_SELLLIMIT, (lots*incr) ,Ask+(hedge*Point*incr),3,0,0,l_dbl2str_12,Magic,0,RoyalBlue);
       OrderSend(Symbol(),OP_BUYLIMIT, (lots*incr) ,Bid-(hedge*Point*incr),3,0,0,l_dbl2str_12,Magic,0,Red);

   }
   
   }
  
  
  
 
    if ((CountOrdersThisPairBUYLIMIT () == 1 &&  CountOrdersThisPairSELLLIMIT () == 0 )  ) {


   OrderSend(Symbol(),OP_SELLLIMIT, (lots*incr) ,Ask+(hedge*Point*incr*2),3,0,0,l_dbl2str_12,Magic,0,RoyalBlue);

   }
 
    
   if ( ( CountOrdersThisPairSELLLIMIT () == 1 &&  CountOrdersThisPairBUYLIMIT ()  == 0 )   ) {
            
  OrderSend(Symbol(),OP_BUYLIMIT, (lots*incr) ,Bid-(hedge*Point*incr*2),3,0,0,l_dbl2str_12,Magic,0,Red);
  
   }
 
  // Order Close Logic
   
      if(basketdollars){
   
     sellorderprofit=0;
     buyorderprofit=0;
   
  }  

   if(OrdersTotal()>0){
     for(int i=0;i<=OrdersTotal();i++){
        OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
             
           if(OrderType()==OP_SELL && OrderSymbol()== Symbol() && OrderMagicNumber() == Magic ){
              if(basketdollars) sellorderprofit=sellorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();
                          }
               if(OrderType()==OP_BUY  && OrderSymbol()== Symbol() && OrderMagicNumber() == Magic){
              if(basketdollars) buyorderprofit=buyorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();

              }
              
         
             
        }
     }
     
     
 
 
 if(basketdollars) {
 
 
 if ((buyorderprofit ) > dollars) {
  CloseAllBuyTrades();
    buyorderprofit=0;
    }
if ((sellorderprofit ) > dollars) {
  CloseAllSellTrades();
   sellorderprofit=0;
    }
   
  if ((buyorderprofit+ sellorderprofit ) > oned) {
  CloseAllTrades();
   
     
   sellorderprofit=0;
   buyorderprofit=0;
    
    }
    
    }
 
    
 
     
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

int  CountOrdersThisPairBUYLIMIT () {
  int l_count_0 = 0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_BUYLIMIT  && OrderMagicNumber() == Magic) l_count_0++;
  }
  return (l_count_0);
}
  


int CountOrdersThisPairSELLLIMIT() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_SELLLIMIT && OrderMagicNumber() == Magic) l_count_0++;
  }
  return (l_count_0);
}

// Close all open trades when in profit
void CloseAllTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            if (OrderType()==OP_SELL  && OrderSymbol()== Symbol() && OrderMagicNumber() == Magic )result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if (OrderType()==OP_BUY  && OrderSymbol()== Symbol() && OrderMagicNumber() == Magic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_BID),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if ((OrderType()==OP_BUYSTOP ||OrderType()==OP_BUYLIMIT && OrderMagicNumber() == Magic)  && OrderSymbol()== Symbol() )result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if ((OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT && OrderMagicNumber() == Magic)  && OrderSymbol()== Symbol())result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
        }
     else Print( "Error when order select ", GetLastError());
     }
   

  }
  
  
// Close all open trades when in profit
void CloseAllBuyTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
           
            if (OrderType()==OP_BUY  && OrderSymbol()== Symbol() && OrderMagicNumber() == Magic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_BID),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if ((OrderType()==OP_BUYSTOP ||OrderType()==OP_BUYLIMIT && OrderMagicNumber() == Magic)  && OrderSymbol()== Symbol() )result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
           
        }
     else Print( "Error when order select ", GetLastError());
     }
   

  }
  
  void CloseAllSellTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            if (OrderType()==OP_SELL  && OrderSymbol()== Symbol() && OrderMagicNumber() == Magic )result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            
            if ((OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT && OrderMagicNumber() == Magic)  && OrderSymbol()== Symbol())result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
        }
     else Print( "Error when order select ", GetLastError());
     }
   

  }
  