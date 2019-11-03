/*********************************************/
/*Varaible for FFCALC goes here

/********************************************/


string time,sig;
  
    
     extern double lot=0.02;
     

extern double hedge=250; // hedge=250
 

//
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
     

   
    sig=ObjectDescription("Type_mslin10");
  
    sig=StringSubstr(sig,0,3);
   
     time=ObjectDescription("Time_mslin10");
    
    time=StringSubstr(time,14,StringLen(time)-1);
    
   if(currentorder(time, TimeCurrent())==1)
         {
         
         
    
            if ( sig=="SEL" && CountOrdersThisPairSELL() == 0) {OrderSend(Symbol(),OP_SELL,lot,Bid,3,0,0,"stp sell",0,0,Green);  

 if ( CountOrdersThisPairSELL() > 0 ) {
   
    OrderSend(Symbol(),OP_BUYSTOP, lot ,Ask+hedge*Point,3,0,0,"pendngbuy",0,0,RoyalBlue);
    OrderSend(Symbol(),OP_SELLSTOP, lot ,Bid-hedge*Point,3,0,0,"pendingsell",0,0,Red);
}
}
            if ( sig=="BUY" && CountOrdersThisPairBUY() == 0) {OrderSend(Symbol(),OP_BUY,lot,Ask,3,0,0,"stp buy",0,0,Green);
    if ( CountOrdersThisPairBUY() > 0 ) {
   OrderSend(Symbol(),OP_SELLSTOP, lot ,Bid-hedge*Point,3,0,0,"pendingsell",0,0,Red);
   OrderSend(Symbol(),OP_BUYSTOP, lot ,Ask+hedge*Point,3,0,0,"pendngbuy",0,0,RoyalBlue);

   }
}
 
    
     }
     
     if (CountOrdersThisPairBUY() > 0 || CountOrdersThisPairSELL() > 0)
     {
     if (CountOrdersThisPairSELLSTOP () == 1 &&  CountOrdersThisPairBUYSTOP() == 0 ) {



 OrderSend(Symbol(),OP_BUYSTOP, lot, Ask+hedge*Point,3,0,0,"pendingbuy",0,0,RoyalBlue);
   }
 
    
   if ( CountOrdersThisPairBUYSTOP() == 1 &&  CountOrdersThisPairSELLSTOP ()  == 0 ) {
            
  OrderSend(Symbol(),OP_SELLSTOP, lot ,Bid-hedge*Point,3,0,0,"pendingsell",0,0,Red);
  
   }    
   
  }   
 
     return(0);

 
  
  }


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
if (OrderSymbol() == Symbol() && OrderType() == OP_SELL  ) l_count_0++;
}
return (l_count_0);
}


int currentorder(string ttv, datetime nowtime)
{
if(StringLen(ttv)<1) return 0;
int h,m,d;
int th, tm, td;
h=TimeHour(nowtime);
m=TimeMinute(nowtime);
d=TimeDay(nowtime);

th=StringSubstr(ttv,11,2);
tm=StringSubstr(ttv,14,2);
td=StringSubstr(ttv,8,2);
if(h==th && m==tm && d==td) return 1;

return 0;

}


  int CountOrdersThisPairSELLSTOP() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_SELLSTOP ) l_count_0++;
  }
  return (l_count_0);
}

int CountOrdersThisPairBUYSTOP() {
  int l_count_0;
  for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
     OrderSelect(l_pos_4, SELECT_BY_POS);
     if (OrderSymbol() == Symbol() && OrderType() == OP_BUYSTOP ) l_count_0++;
  }
  return (l_count_0);
}
  
