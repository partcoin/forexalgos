#property copyright "Copyright 2013, www.scalpguru.com"
#property link      "coming soon.."



extern double lots = 0.01;

extern int incr=2;
extern double hedge=100;

extern int Magic=111;







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
  string l_dbl2str_12="ucad";
 



   if (CountOrdersThisPairBUY() == 0 && CountOrdersThisPairSELL() == 0  ) {
 
   
    OrderSend(Symbol(), OP_SELL,  lots , Bid, 3, 0, 0, l_dbl2str_12, Magic, 0, Red);
  
   if ( CountOrdersThisPairSELL() > 0 ) {
       OrderSend(Symbol(),OP_SELLLIMIT, (lots*incr) ,Ask+(hedge*Point*incr),3,0,0,l_dbl2str_12,Magic,0,RoyalBlue);
       OrderSend(Symbol(),OP_SELLSTOP, lots ,Bid-hedge*Point,3,0,0,l_dbl2str_12,Magic,0,Red);
 }
   }
   
   
  
  
  
 
    if ((CountOrdersThisPairSELLSTOP () == 1 &&  CountOrdersThisPairSELLLIMIT () == 0 )  ) {


   OrderSend(Symbol(),OP_SELLLIMIT, (lots*incr) ,Ask+(hedge*Point*incr),3,0,0,l_dbl2str_12,Magic,0,RoyalBlue);

   }
 
    
   if ( ( CountOrdersThisPairSELLLIMIT () == 1 &&  CountOrdersThisPairSELLSTOP ()  == 0 )   ) {
            
  OrderSend(Symbol(),OP_SELLSTOP, lots ,Bid-hedge*Point,3,0,0,l_dbl2str_12,Magic,0,Red);
  
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

int CountOrdersThisPairSELLSTOP() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_SELLSTOP && OrderMagicNumber() == Magic) l_count_0++;
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
