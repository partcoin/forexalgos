#property link      "basket"


int GVari_100;
int GVari_160 = 0;
int GVari_164 = 0;
int GVari_168 = 0;
string GVars_172 = "";
extern double netprofit = 2.5;
 
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
   
if (OrdersTotal() == 0) GVari_100 = AccountBalance();

    if (AccountEquity() > GVari_100 + netprofit && GVari_100 > 0) GVari_160 = 2;
   if (GVari_160 == 2) f0_6();
   
   Comment("\nBalance = ", AccountBalance(), 
      "\nEquity = ", AccountEquity(), 
      "\nFree = ", AccountFreeMargin(), 
      "\nProfit = ", AccountProfit(),       
      "\nTotalClosed = ", OrdersHistoryTotal(), 
      "\nAB = ", GVari_100, 
   "\nHour = ", Hour());
  
 
 
     return(0);

 
  }
// 9B1AEE847CFB597942D106A4135D4FE6
int f0_6() {
   int Lcali_0 = OrdersTotal();
   int Lcali_4 = 0;
   GVari_160 = 0;
   RefreshRates();
   if (OrderType() != OP_BUY && OrderType() != OP_SELL) OrderDelete(OrderTicket());
   switch (GVari_164) {
   case 0:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
         if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
         if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
      }
      break;
   case 1:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
         if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
      }
      break;
   case 2:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
      }
      break;
   case 3:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderMagicNumber() == GVari_168) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
      break;
   case 4:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderComment() == GVars_172) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
      break;
   case 5:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderProfit() > 0.0) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
      break;
   case 6:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderProfit() < 0.0) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
      break;
   case 7:
      for (Lcali_4 = 0; Lcali_4 <= Lcali_0; Lcali_4++) {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (TimeDay(OrderOpenTime()) < TimeDay(TimeCurrent())) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Violet);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Violet);
            if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
         }
      }
   }
   return (0);
}