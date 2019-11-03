#include <stderror.mqh>
#include <stdlib.mqh>
extern double willlevel = -50;
extern int IN_MagicNo = 32587975;
//extern string IN_SymbolExtension = "pro";
extern double IN_Lots = 1;
extern int IN_Slippage = 3;
bool result;
extern bool IN_ByTick = true;

extern int IN_MA1  = 128;
extern int IN_MA2  = 128;
extern int IN_WPR1 = 128;
double m_dblMA1_Pre = 0;
double m_dblMA2_Pre = 0;

double m_dblWPR1_Pre = 0;


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
 
   
  
   if(!IN_ByTick){
      //go trading only for first tiks of new bar
      if(Volume[0] > 1) {return(0);}  
   }
  
   double dOpenPrice;     

   //Movning Average
   double dblMA1 = iMA(NULL, 0, IN_MA1, 0, MODE_SMA, PRICE_WEIGHTED, 0);
   double dblMA2 = iMA(NULL, 0, IN_MA1, 0, MODE_SMA, PRICE_WEIGHTED, IN_MA2);
   
  
   //W%R
   double dblWPR1 = iWPR(NULL, 0, IN_WPR1, 0);      
  
                      
   //buy position
   bool hasBuyPos = ExistPositions("", OP_BUY, IN_MagicNo);
   //sell position
   bool hasSellPos = ExistPositions("", OP_SELL, IN_MagicNo);
                         
   //Buy Logic
   bool goBuy = false;
  
   if(  dblMA1 > dblMA2 && dblWPR1 > willlevel && m_dblWPR1_Pre <=willlevel ){     
      goBuy= true;
      }
  
 
   if(goBuy && !hasBuyPos ){
        
      if(hasSellPos){
         //Close short position
         ClosePositions("", OP_SELL, IN_MagicNo);           
        }
     
           
      dOpenPrice = NormalizeDouble(MarketInfo(GetTureSymbole(), MODE_ASK), MarketInfo(GetTureSymbole(), MODE_DIGITS));              
      OrderSend(GetTureSymbole(), OP_BUY, IN_Lots, dOpenPrice, IN_Slippage, 0, 0, "", IN_MagicNo, 0, Lime);  
       
        }     
             
  
   //Sell Logic    
   bool goSell = false;
  
   if(  dblMA1 < dblMA2  && dblWPR1 < willlevel && m_dblWPR1_Pre >=willlevel){
      goSell = true;
   }
 
        
   //Sell
   if(goSell && !hasSellPos ){
     
       if(hasBuyPos){
         //Close long position
         ClosePositions("", OP_BUY, IN_MagicNo);  
 
      }
           
      dOpenPrice = NormalizeDouble(MarketInfo(GetTureSymbole(), MODE_BID), MarketInfo(GetTureSymbole(), MODE_DIGITS));              
      OrderSend(GetTureSymbole(), OP_SELL, IN_Lots, dOpenPrice, IN_Slippage, 0, 0, "", IN_MagicNo, 0, Red);  
               

   }  
  

  
   
   m_dblMA1_Pre = dblMA1;
   m_dblMA2_Pre = dblMA2;
    
   m_dblWPR1_Pre = dblWPR1;
  
//----
   return(0);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Get ture symbol
//+------------------------------------------------------------------+
string GetTureSymbole(string symbol = "")
{
   if(symbol=="") symbol = Symbol();
   int pos = StringFind(symbol, "_", 0);
  
   if(pos >= 0){
      symbol = StringSubstr(symbol, 0, pos);
     
      //symbol = symbol + IN_SymbolExtension;
   }
   return (symbol);
}


//+------------------------------------------------------------------+
//| Get The current symbol point value in the quote currency.
//+------------------------------------------------------------------+
double GetPoint(string symbol = "")
{
   if(symbol=="") symbol = Symbol();

   double dblDigit = MarketInfo(symbol, MODE_DIGITS);
  
   if(dblDigit == 2 || dblDigit == 3){
      return (0.01);
   }else if(dblDigit == 4 || dblDigit == 5){
      return (0.0001);
  }
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Get pips from rate
//+------------------------------------------------------------------+
double GetPipsFromRate(double dblRate)
{
   int m_intDigits = Digits;
  
   if(m_intDigits == 3 || m_intDigits == 5)
   {
      m_intDigits = m_intDigits - 1;
   }
  
   return(dblRate / MathPow(0.1, m_intDigits));
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Check position Exits
//+------------------------------------------------------------------+
bool ExistPositions(string sym = "", int op = -1, int mn = -1)
{
   int i, k = OrdersTotal();

   if (sym == "") sym = GetTureSymbole();
 
   for (i = 0; i < k; i++)
   {     
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
       
        if(sym != "" && OrderSymbol() != sym) continue;   
       
        if(OrderType() != OP_BUY && OrderType() != OP_SELL) continue;  
           
      if (op < 0 || OrderType() == op)
      {
         if (mn < 0 || OrderMagicNumber() == mn)
         {                             
            return(True);
         }
      }            
   }
   return(False);
}

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Close position
//+------------------------------------------------------------------+
void ClosePositions(string sym = "", int op = -1, int mn = -1)
{
  int i;

  if (sym == "") sym = GetTureSymbole();
 
  for (i = OrdersTotal() - 1; i >= 0; i--)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderSymbol() == sym && (op < 0 || OrderType() == op))
      {
        if (mn < 0 || OrderMagicNumber() == mn)
        {
          if (OrderType() == OP_BUY)
          {
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), IN_Slippage, LightBlue);
          }
          if (OrderType() == OP_SELL)
          {
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), IN_Slippage, LightCoral);
          }
        }
      }
    }
  }
}

