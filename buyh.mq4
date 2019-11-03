#property copyright "Copyright 2013, www.scalpguru.com"
#property link      "coming soon.."



extern double lots = 0.01;

 extern int orderlimit=1;
extern double hedge=200;
extern int incr=1;

extern int magic=1;
double buyorderprofit;
bool basketdollars=true;


bool result;


 extern double dollars=200;





int init() {
  return (0);
}

int deinit() {
  return (0);
}

int start() {
    
Strategy_1();


// Order Close Logic
   
      if(basketdollars){
   
     
     buyorderprofit=0;
   
  }  

   if(OrdersTotal()>0){
     for(int i=0;i<=OrdersTotal();i++){
        OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
             
           
               if(OrderType()==OP_BUY  && OrderSymbol()== Symbol() && OrderMagicNumber() == magic    ){
              if(basketdollars) buyorderprofit=buyorderprofit+ OrderProfit()+ OrderSwap() + OrderCommission();

              }
              
         
             
        }
     }
     
     
 
 
 if(basketdollars) {
 
 
 if ((buyorderprofit) > dollars) {
  CloseAllTrades();
   
     
   
   buyorderprofit=0;
    
    }
    }
    
   
  
 
return(0);
 }          
             
 



int Strategy_1() {
  string l_dbl2str_12="oil";
 

  
 


   if (CountOrdersThisPairBUY() == 0 && CountOrdersThisPairSELL() == 0 && orderlimit > 0 ) {
 
   
    OrderSend(Symbol(), OP_BUY,  lots , Ask, 3, 0,0, l_dbl2str_12, magic, 0, RoyalBlue);
    orderlimit--;
 
  
   if ( CountOrdersThisPairBUY() > 0 ) {
    OrderSend(Symbol(),OP_BUYLIMIT, (lots*incr) ,Bid-(hedge*Point*incr),3,0,0,l_dbl2str_12,magic,0,Red);
     
 }
   
   
   
  }
  
  
 
    if ( CountOrdersThisPairBUY() > 0 && CountOrdersThisPairBUYLIMIT () == 0 ) {


  OrderSend(Symbol(),OP_BUYLIMIT, (lots*incr) ,Bid-(hedge*Point*incr),3,0,0,l_dbl2str_12,magic,0,Red);


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

// Close all open trades when in profit
void CloseAllTrades(){

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