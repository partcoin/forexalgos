#property copyright "Copyright 2016, MB"
#property link      "MB"



extern double lots = 0.01;

 
extern double hedge=1000; // 1000 for majors and 2500 for cross
extern int incr1=1;
extern int incr2=1;

extern int magic=1;
double buyorderprofit,sellorderprofit;
bool basketdollars=true;


bool result;


extern double dollars1=10; //10 for majors and 25 for cross
extern double dollars2=2; //2 for majors and 5 for cross




int init() {
  return (0);
}

int deinit() {
  return (0);
}

int start() {
    
    // order entry logic 
Strategy_1();


// Order Close Logic
   
      if(basketdollars){
   
     
     buyorderprofit=0;
     sellorderprofit=0;
    
   
       }  
//buy basket based on magic no.
   if(OrdersTotal()>0){
     for(int i=0;i<=OrdersTotal();i++){
        OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
             
           
               if(OrderType()==OP_BUY  && OrderSymbol()== Symbol() && OrderMagicNumber() == magic    ){
              if(basketdollars) buyorderprofit=buyorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();
              }
              
               if(OrderType()==OP_SELL  && OrderSymbol()== Symbol() && OrderMagicNumber() == magic    ){
              if(basketdollars) sellorderprofit=sellorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();

              }
            
             
        }
     }
     
    
     
     
 if(basketdollars) {
 
 
 if ((buyorderprofit) > (dollars1)) {
  CloseAllBuyTrades();
   
     
   
   buyorderprofit=0;
   incr1=1;
   
    
    }
    
     
 if ((sellorderprofit) > (dollars1)) {
  CloseAllSellTrades();
   
     
   
   sellorderprofit=0;
   incr2=1;
  
    
    }
    
    if ((buyorderprofit+sellorderprofit) > (dollars2)) {
    
      CloseAllBuyTrades();
      CloseAllSellTrades();
      buyorderprofit=0;     
     sellorderprofit=0;     
     incr1=1;
     incr2=1;
     
   
    }
    
   
  }
 
return(0);
 }          
             
 



int Strategy_1() {
  string l_dbl2str_12="mb";
 
  
   
  // buys and sell

   if (CountOrdersThisPairBUY() == 0  ) {
 
   
    OrderSend(Symbol(), OP_BUY,  lots , Ask, 3, 0,0, l_dbl2str_12, magic, 0, RoyalBlue);
    
      if ( CountOrdersThisPairBUY() > 0 ) {
    incr1= CountOrdersThisPairBUY();
    OrderSend(Symbol(),OP_BUYLIMIT, (lots*incr1) ,Bid-(hedge*Point*incr1),3,0,0,l_dbl2str_12,magic,0,Red);
     
   }
 }
 
    if ( CountOrdersThisPairSELL() == 0  ) {
    OrderSend(Symbol(), OP_SELL,  lots , Bid, 3, 0, 0, l_dbl2str_12, magic, 0, Red);
   
 
    if ( CountOrdersThisPairSELL() > 0 ) {
       incr2= CountOrdersThisPairSELL();
       OrderSend(Symbol(),OP_SELLLIMIT, (lots*incr2) ,Ask+(hedge*Point*incr2),3,0,0,l_dbl2str_12,magic,0,RoyalBlue);
       
 }
  
 
   
   
   }
  
  
     if (CountOrdersThisPairSELL() > 0 && CountOrdersThisPairSELLLIMIT () == 0 ) {

   incr2= CountOrdersThisPairSELL();
   OrderSend(Symbol(),OP_SELLLIMIT, (lots*incr2) ,Ask+(hedge*Point*incr2),3,0,0,l_dbl2str_12,magic,0,RoyalBlue);

   }
 
 
    if ( CountOrdersThisPairBUY() > 0 && CountOrdersThisPairBUYLIMIT () == 0 ) {

  incr1= CountOrdersThisPairBUY();
  OrderSend(Symbol(),OP_BUYLIMIT, (lots*incr1) ,Bid-(hedge*Point*incr1),3,0,0,l_dbl2str_12,magic,0,Red);


   }
 
    
  
 
 
     
   return (0);
}

int CountOrdersThisPairBUY() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber() == magic) l_count_0++;
  }
  return (l_count_0);
}

int CountOrdersThisPairSELL() {
  int l_count_0 = 0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_SELL  && OrderMagicNumber() == magic) l_count_0++;
  }
  return (l_count_0);
}


int  CountOrdersThisPairBUYLIMIT () {
  int l_count_0 = 0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_BUYLIMIT  && OrderMagicNumber() == magic) l_count_0++;
  }
  return (l_count_0);
}




int CountOrdersThisPairSELLLIMIT() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_SELLLIMIT && OrderMagicNumber() == magic) l_count_0++;
  }
  return (l_count_0);
}

// Close all open trades when in profit
void CloseAllBuyTrades(){

  for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            
            if (OrderType()==OP_BUY  && OrderSymbol()== Symbol() && OrderMagicNumber() == magic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_BID),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if (OrderType()==OP_BUYLIMIT && OrderMagicNumber() == magic  && OrderSymbol()== Symbol() )result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
            
        }
     else Print( "Error when order select ", GetLastError());
     }
}   


void CloseAllSellTrades(){

 for (int i=OrdersTotal()-1;i>=0;i--){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            
            if (OrderType()==OP_SELL  && OrderSymbol()== Symbol() && OrderMagicNumber() == magic)result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol() ,MODE_ASK),3,CLR_NONE);
            if(result!=TRUE) Print("LastError = ", GetLastError());
            if (OrderType()==OP_SELLLIMIT && OrderMagicNumber() == magic  && OrderSymbol()== Symbol() )result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
            
        }
     else Print( "Error when order select ", GetLastError());
     }
     
    }
     
     
