












//+------------------------------------------------------------------+
//|                                                           MM.mq4 |
//|                              Copyright © 2013, Forex Chrome Ltd. |
//|                                          http://www.fxchrome.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2013, Forex Chrome Ltd."
#property link      "http://www.fxchrome.com"


extern string  Options1="Money Management";
extern double  Lots=0.1;                                    //Lot size
extern bool    MM=true;                                     //Money management
extern double  RiskPercent=1.05;                            //Risk percentage, MM needs to be true
extern bool    Martingale=true;                             //Enable the martingale
extern double  Multiplier=1.2;                              //Multiplier for the martingale
extern double  MinLot=0.01;                                 //Minimun lot
extern double  MaxLot=100;                                  //Maximun lot
extern int     LotDigits=2;                                 //Lot digits, 1=0.1, 2=0.01

extern string  Options2="Signals Options";
extern double  BuyLevel=0.7;                                //RSI3 value for buying
extern double  SellLevel=99.3;                              //RSI3 value for selling

extern string  Options3="Order Management";
extern int     StopLoss=0;                                  //Stop loss
extern double  TakeProfit=12;                               //Take profit
extern double  GridTPInPercentage=0.12;                     //Close all the buy or sell orders if a profit of X USD has been reached
extern bool    HideSL=true;                                 //Hide stop loss
extern bool    HideTP=true;                                 //Hide take profit
extern int     MaxLongPositions=10;                         //Maximum open positions allowed for long
extern int     MaxShortPositions=10;                        //Maximum open positions allowed for short
extern int     MaxOpenPositions=20;                         //Maximum total open positions allowed
extern double  PipStep=50;                                  //Minimum quantity of pips for new grid orders
extern double  BreakevenGain=62;                            //Gain in pips required to enable the break even
extern double  Breakeven=12;                                //Break even

extern string  Options4="Time Filter";
extern bool    UseTimeFilter=true;                          //Enable Time Filter
extern int     StartHour=5;                                 //Start trade hour
extern int     StartMinute=58;                              //Minutes of the start trade hour
extern int     EndHour=18;                                  //Stop trade hour
extern int     EndMinute=0;                                 //Minutes of the stop trade hour

extern string  Options5="Extras";
extern bool		AlwaysOn = true;		                        //The EA runs every delay(ms) when it is true or every ticks(false)
extern int		Delay = 1000;		                           //Time(ms) restart the EA in AlwaysOn mode
extern int     MagicNumber=12345;                           //Magic number
extern int     Slippage=3;                                  //Slippage
extern double  MaxSpread=3;                                 //Maximum spread allowed by the EA, 0 = disabled
extern string  EAName="MM";                                 //Order comment

datetime       tstart,tend;
int            nstarthour,nendhour;
string         istarthour,istartminute,iendhour,iendminute;
bool           tradetime;

double         pt,mt,blots,slots,mblots, mslots,sl,tp;
double         rsi3, nextbuylevel, nextselllevel;
int            expire=0,dg,totalbuy,totalsell,total,totalbuystop,totalsellstop,totalpending,ticket,i,cnt;

double         lastbuyopenprice,lastsellopenprice,percentprofit,buyorderprofit,sellorderprofit,totalprofit;
string         screenmessage,status,hedgegrid;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
   
   if(Digits==3 || Digits==5)
   {
      pt=Point*10;
      mt=10;
   }
   else
   {
      pt=Point;
      mt=1;
   }
   
   if (AlwaysOn == true) 
	{
		while (IsExpertEnabled())
		{
			main();
			Sleep(Delay);
			WindowRedraw();
		}
	} 
	else 
	{
		main(); 
	}
   return(0);
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
{
   return(0);
}
  
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   
//Main function
   main();
   
   return(0);
}
//+------------------------------------------------------------------+

void main()
{
//Clear the chart if there isn't any open position
   //if(total==0)ObjectsDeleteAll();

//Time filter
   tradetime=true;
      if(UseTimeFilter)
      {
         if(checktime()){tradetime=false;}
      }

//Comments
   comments();   

//Signal conditions  
   rsi3 = iRSI(NULL,0,3,PRICE_CLOSE,0);
   
   bool rsi3buysignal=false;
   bool rsi3sellsignal=false;

   if(rsi3<BuyLevel){rsi3buysignal=true;}
   if(rsi3>SellLevel){rsi3sellsignal=true;}
   
   double sig_buy=iWPR(NULL,0,26,0);
   double sig_sell=iWPR(NULL,0,27,0);
   double sig_high=iWPR(NULL,0,29,0);
   double sig_low=iWPR(NULL,0,30,0);
   
   bool masterbuysignal=false;
   bool mastersellsignal=false;
 
   if (sig_buy<-99.99 && sig_sell<-99.99 && sig_high<-99.99 && sig_low<-99.99){masterbuysignal=true;} 
   if (sig_buy>-0.01 && sig_sell>-0.01 && sig_high>-0.01 && sig_low>-0.01){mastersellsignal=true;}


   int signal=0;
      
   if((rsi3buysignal)&&(masterbuysignal)) {signal=1;} 
   if((rsi3sellsignal)&&(mastersellsignal)) {signal=2;}   

         
//Orders manager
   totalbuy=count(OP_BUY);
   totalsell=count(OP_SELL);
   total=totalbuy+totalsell;
   
   totalbuystop=count(OP_BUYSTOP);
   totalsellstop=count(OP_SELLSTOP);
   totalpending=totalbuystop+totalsellstop;
   
   lastbuyopenprice=0;
   lastsellopenprice=0;
   
   buyorderprofit=0;
   sellorderprofit=0;

      if(OrdersTotal()>0)
      {
         for(i=0;i<=OrdersTotal();i++)
         {
            OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
               
               if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderCloseTime()==0)
               {
                  if(OrderType()==OP_BUY)
                  {
                     lastbuyopenprice=OrderOpenPrice();
                     buyorderprofit=buyorderprofit+OrderProfit()+OrderSwap()+OrderCommission();
                  }
                  if(OrderType()==OP_SELL)
                  {
                     lastsellopenprice=OrderOpenPrice();
                     sellorderprofit=sellorderprofit+OrderProfit()+OrderSwap()+OrderCommission();
                  }
               }
         }
      }

   percentprofit=AccountBalance()*GridTPInPercentage*0.01;
   totalprofit=buyorderprofit+sellorderprofit;
   
   bool newbuy=false;
   bool newsell=false;
   
   nextbuylevel=lastbuyopenprice-PipStep*pt*MathPow(1.02,totalbuy);
   nextselllevel=lastsellopenprice+PipStep*pt*MathPow(1.02,totalsell);
   
   if(totalbuy>0&&Ask<=nextbuylevel){newbuy=true;}
   if(totalsell>0&&Bid>=nextselllevel){newsell=true;}
   
   bool buy=false;
   bool sell=false;
   
   if(signal==1&&(total<1||(newbuy))){buy=true;}
   if(signal==2&&(total<1||(newsell))){sell=true;}
   
   if(total<2&&(HideSL||HideTP)){hideclose(OP_BUY);hideclose(OP_SELL);}
   
   if((totalbuy==1&&totalsell==1)&&(buy)){close(OP_SELL);}
   if((totalbuy==1&&totalsell==1)&&(sell)){close(OP_BUY);}
   
   if(total>1||total<2){if(totalprofit>=percentprofit){close(OP_BUY);close(OP_SELL);}}
  
   if(total<1&&totalpending>0){delete();}
   
//Breakeven      
   if(BreakevenGain>0)movebreakeven(BreakevenGain,Breakeven);

//Spread      
   if(MaxSpread!=0)if((Ask-Bid)>MaxSpread*pt)return(0);
   
//MM and Martingale
   if(MM){Lots=lotsoptimized(); blots=Lots; slots=Lots;}
   if(Martingale){mblots=(blots/3)*MathPow(Multiplier,totalbuy);mslots=(slots/3)*MathPow(Multiplier,totalsell);}
   
//Maximum open orders
   if(MaxOpenPositions<100)if((total)>=MaxOpenPositions)return(0);
       
//Opening orders
   if((total<1)&&(tradetime))
   {
      if((buy)&&(totalbuy<MaxLongPositions))
      {
         RefreshRates();
         ticket=open(OP_BUY,blots,Ask,StopLoss,TakeProfit,expire,Blue);
         ticket=open(OP_SELLSTOP,blots,Bid-(12*pt),StopLoss,TakeProfit,expire,Red);
      }
   
      if((sell)&&(totalsell<MaxShortPositions))
      {
         RefreshRates();
         ticket=open(OP_SELL,slots,Bid,StopLoss,TakeProfit,expire,Red);
         ticket=open(OP_BUYSTOP,slots,Ask+(12*pt),StopLoss,TakeProfit,expire,Blue);
      }
   }
   
   if(total>1)
   {   
      if((buy)&&(totalbuy<MaxLongPositions))
      {
         RefreshRates();
         ticket=open(OP_BUY,mblots,Ask,StopLoss,TakeProfit,expire,Blue);
      }
      
      if((sell)&&(totalsell<MaxShortPositions))
      {
         RefreshRates();
         ticket=open(OP_SELL,mslots,Bid,StopLoss,TakeProfit,expire,Red);
      }
   }      
}
//+------------------------------------------------------------------+

//Time filter
bool checktime()
{
   string svrdate=Year()+"."+Month()+"."+Day();
   
      nstarthour=StartHour;if(nstarthour>23)nstarthour=nstarthour-24;
      if(nstarthour<10)istarthour="0"+nstarthour;
      if(nstarthour>9)istarthour=nstarthour;
      if(StartMinute<10)istartminute="0"+StartMinute;
      if(StartMinute>9)istartminute=StartMinute;
      tstart=StrToTime(svrdate+" "+istarthour+":"+istartminute);

      nendhour=EndHour;if(nendhour>23)nendhour=nendhour-24;
      if(EndHour<10)iendhour="0"+nendhour;
      if(EndHour>9)iendhour=nendhour;
      if(EndMinute<10)iendminute="0"+EndMinute;
      if(EndMinute>9)iendminute=EndMinute;
      tend=StrToTime(svrdate+" "+iendhour+":"+iendminute);
   
      if((nstarthour<=nendhour && TimeCurrent()<tstart || TimeCurrent()>tend) || (nstarthour>nendhour && TimeCurrent()<tstart && TimeCurrent()>tend))return(true);

   return(false);
}

//Comments
void comments()
{ 
   screenmessage="";
   status="";
   hedgegrid="";
   
   if(tradetime){status="Trading";}else{status="Managing";}
   if(totalbuy==1&&totalsell==1){hedgegrid=" the hedge";}
   if(totalbuy>1&&totalsell<1){hedgegrid=" the long grid";}
   if(totalbuy<1&&totalsell>1){hedgegrid=" the short grid";}
   
   if(totalbuy<1&&totalsell<1){screenmessage = StringConcatenate("| Server time: ",TimeToStr(TimeCurrent(),TIME_MINUTES)," | ", " | Local time : ",TimeToStr(TimeLocal(),TIME_MINUTES)," | "," | RSI3: ",rsi3," | ",status, " |");}
   if(totalbuy>0&&totalsell<1){screenmessage = StringConcatenate("| Server time: ",TimeToStr(TimeCurrent(),TIME_MINUTES)," | ", " | Local time : ",TimeToStr(TimeLocal(),TIME_MINUTES)," | "," | RSI3: ",rsi3," | ", " | Next buy level: ",nextbuylevel," | "," | Total buy profit: ",buyorderprofit," | ",status,hedgegrid," |");}
   if(totalsell>0&&totalbuy<1){screenmessage = StringConcatenate("| Server time: ",TimeToStr(TimeCurrent(),TIME_MINUTES)," | ", " | Local time : ",TimeToStr(TimeLocal(),TIME_MINUTES)," | "," | RSI3: ",rsi3," | ", " | Next sell level: ",nextselllevel," | "," | Total sell profit: ",sellorderprofit," | ",status,hedgegrid," |");}
   if(totalbuy>0&&totalsell>0){screenmessage = StringConcatenate("| Server time: ",TimeToStr(TimeCurrent(),TIME_MINUTES)," | ", " | Local time : ",TimeToStr(TimeLocal(),TIME_MINUTES)," | "," | RSI3: ",rsi3," | ", " | Next buy level: ",nextbuylevel," | "," | Next sell level: ",nextselllevel," | ", " | Total profit: ",totalprofit," | ",status,hedgegrid," |");}
   
   //screenmessage = StringConcatenate("Value: ",blots," ",slots," ",mblots," ",mslots);
   
   Comment(screenmessage);
}

//Orders manager
int count(int type)
{
   cnt=0;
   if(OrdersTotal()>0)
   {
      for(i=OrdersTotal();i>=0;i--)
      {
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderType()==type && OrderMagicNumber()==MagicNumber)cnt++;
      }
      return(cnt);
   }
}

void hideclose(int type)
{
   bool result = false;
   if(OrdersTotal()>0)
   {
      for(i=OrdersTotal()-1;i>=0;i--)
      {
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type==OP_BUY && OrderType()==OP_BUY)
         {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && (HideSL && StopLoss>0 && OrderProfit()<=(-1)*StopLoss*OrderLots()*10-MarketInfo(Symbol(),MODE_SPREAD)*OrderLots()*10/mt) || (HideTP && TakeProfit>0 && OrderProfit()>=TakeProfit*OrderLots()*10))
            {
               RefreshRates();
               result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),Slippage*mt);
               if (!result) hideclose(OP_BUY);
               else i++;
            }
         }
         if(type==OP_SELL && OrderType()==OP_SELL)
         {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && (HideSL && StopLoss>0 && OrderProfit()<=(-1)*StopLoss*OrderLots()*10-MarketInfo(Symbol(),MODE_SPREAD)*OrderLots()*10/mt) || (HideTP && TakeProfit>0 && OrderProfit()>=TakeProfit*OrderLots()*10))
            {
               RefreshRates();
               result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),Slippage*mt);
               if (!result) hideclose(OP_SELL);
               else i++;
            }
         }
      }
   }
}

void close(int type)
{
   bool result = false;
   if(OrdersTotal()>0)
   {
      for(i=OrdersTotal()-1;i>=0;i--)
      {
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type==OP_BUY && OrderType()==OP_BUY)
         {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
            {
               RefreshRates();
               result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),Slippage*mt);
               if (!result) close(OP_BUY);
               else i++;
            }
         }
         if(type==OP_SELL && OrderType()==OP_SELL)
         {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
            {
               RefreshRates();
               result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),Slippage*mt);
               if (!result) close(OP_SELL);
               else i++;
            }
         }
      }
   }
}         

void delete()
{
   if(OrdersTotal()>0)
   {
      for(i=OrdersTotal();i>=0;i--)
      {
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT)
         {
            OrderDelete(OrderTicket());
         }
      }
   }
}

//Breakeven
void movebreakeven(double breakevengain,double breakeven)
{
   RefreshRates();
   if(OrdersTotal()>0)
   {
      for(i=OrdersTotal();i>=0;i--)
      {
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
         {
            if(OrderType()==OP_BUY)
            {
               if(NormalizeDouble((Bid-OrderOpenPrice()),Digits)>=NormalizeDouble(breakevengain*pt,Digits))
               {
                  if((NormalizeDouble((OrderStopLoss()-OrderOpenPrice()),Digits)<NormalizeDouble(breakeven*pt,Digits)) || OrderStopLoss()==0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+breakeven*pt,Digits),OrderTakeProfit(),0,Blue);
                     return(0);
                  }
               }
            }
            else
            {
               if(NormalizeDouble((OrderOpenPrice()-Ask),Digits)>=NormalizeDouble(breakevengain*pt,Digits))
               {
                  if((NormalizeDouble((OrderOpenPrice()-OrderStopLoss()),Digits)<NormalizeDouble(breakeven*pt,Digits)) || OrderStopLoss()==0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-breakeven*pt,Digits),OrderTakeProfit(),0,Red);
                     return(0);
                  }
               }
            }
         }
      }
   }
}

//Lots Optimized
double lotsoptimized()
{
   double lot;
      
      if(NormalizeDouble(MarketInfo(Symbol(),MODE_LOTSTEP),2)==0.01)LotDigits=2; else LotDigits=1;
      lot=AccountBalance()*(RiskPercent/100)/(100*pt/MarketInfo(Symbol(),MODE_TICKSIZE)*MarketInfo(Symbol(),MODE_TICKVALUE));
   
   return(lot);
}

//Open Orders
int open(int type,double lots,double price,double stoploss,double takeprofit,int expire,color clr)
{
   int ticket=0;
   
   if(Lots<MinLot)Lots=MinLot;
   if(Lots>MaxLot)Lots=MaxLot;
   
   if(type==OP_BUY || type==OP_BUYSTOP || type==OP_BUYLIMIT)
   {
      if(HideSL==false && stoploss>0){sl=price-stoploss*pt;}else{sl=0;}
      if(HideTP==false && takeprofit>0){tp=price+takeprofit*pt;}else{tp=0;}
   }
   
   if(type==OP_SELL || type==OP_SELLSTOP || type==OP_SELLLIMIT)
   {
      if(HideSL==false && stoploss>0){sl=price+stoploss*pt;}else{sl=0;}
      if(HideTP==false && takeprofit>0){tp=price-takeprofit*pt;}else{tp=0;}
   }
   
      ticket=OrderSend(Symbol(),type,NormalizeDouble(lots,LotDigits),NormalizeDouble(price,Digits),Slippage*mt,sl,tp,EAName+" - "+DoubleToStr(MagicNumber,0),MagicNumber,expire,clr);

   return(ticket);
}