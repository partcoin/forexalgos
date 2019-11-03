#property copyright "Copyright 2013, www.scalpguru.com"
#property link      "coming soon.."



extern double lots = 0.01;

 
extern double hedge=100;
extern int incr=2;

extern int magic=1;






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
  string l_dbl2str_12="oil";
 

  
 


   if (CountOrdersThisPairBUY() == 0 && CountOrdersThisPairSELL() == 0  ) {
 
   
    OrderSend(Symbol(), OP_BUY,  lots , Ask, 3, 0,0, l_dbl2str_12, magic, 0, RoyalBlue);
 
  
   if ( CountOrdersThisPairBUY() > 0 ) {
    OrderSend(Symbol(),OP_BUYLIMIT, (lots*incr) ,Bid-(hedge*Point*incr),3,0,0,l_dbl2str_12,magic,0,Red);
      OrderSend(Symbol(),OP_BUYSTOP, lots ,Ask+hedge*Point,3,0,0,l_dbl2str_12,magic,0,RoyalBlue);
   
 }
   
   
   
  }
  
  
 
    if ((CountOrdersThisPairBUYSTOP () == 1 &&  CountOrdersThisPairBUYLIMIT () == 0 )  ) {


  OrderSend(Symbol(),OP_BUYLIMIT, (lots*incr) ,Bid-(hedge*Point*incr),3,0,0,l_dbl2str_12,magic,0,Red);


   }
 
    
   if ( ( CountOrdersThisPairBUYLIMIT () == 1 &&  CountOrdersThisPairBUYSTOP ()  == 0 )   ) {
            
     OrderSend(Symbol(),OP_BUYSTOP, lots ,Ask+hedge*Point,3,0,0,l_dbl2str_12,magic,0,Red);
   
  
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

int CountOrdersThisPairBUYSTOP() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_BUYSTOP && OrderMagicNumber() == magic) l_count_0++;
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

