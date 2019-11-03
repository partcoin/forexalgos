#property copyright "Kinga Kovacs"
#property link      "kingask2013@gmail.com"

#include <stdlib.mqh>
//#import "stdlib.ex4"
   string IntegerToHexString(int a0); // 90267E7BE5477D1C3601D9A426F82FA1
#import "wininet.dll"
   int InternetOpenA(string a0, int a1, string a2, string a3, int a4);
   int InternetOpenUrlA(int a0, string a1, string a2, int a3, int a4, int a5);
   int InternetReadFile(int a0, string a1, int a2, int& a3[]);
   int InternetCloseHandle(int a0);
   int InternetConnectA(int a0, string a1, int a2, string a3, string a4, int a5, int a6, int a7);
   bool HttpSendRequestA(int a0, string a1, int a2, int& a3[], int a4);
   bool HttpAddRequestHeadersA(int a0, string a1, int a2, int a3);
   int HttpOpenRequestA(int a0, string a1, string a2, string a3, string a4, string& a5[], int a6, int a7);
#import

int hlobia_76[] = {33, 42, 39, 40, 41, 59, 58, 64, 38, 61, 43, 36, 47, 63, 35, 91, 93};
extern string LiveForexAccountNumber = "";
extern string Emailaddress = "";
extern string Contact = "kingask2013@gmail.com or Skype: xperya";
extern string Web = "Buy this EA at: http://mt4robots.blogspot.com";
extern string Important1 = "Use default setting with leverage 1:500!";
extern string Important2 = "Use on any time frame. But do NOT move between time frames.";
extern string DemoInfo = "To use it in demo make sure you open a demo account right from your MT4!";
extern string Currency = "Gold and Any Currency Pairs";
extern string EA_Setting = "------ EA Setting ------";
extern int MaxSpreads_Points = 1000;
int hlobi_156 = 99999;
int hlobi_160;
extern bool AutomaticCalculateMagic = TRUE;
extern bool Enabel_ECN_Broker = TRUE;
extern bool Enable_5Digit_Broker = TRUE;
extern bool KeepTrading = TRUE;
extern string Hidden_Pending_Setting = "------ Hidden Pending Setting ------";
extern int Hidden_Pending_Distane_Pips = 10;
extern bool Close_PendingIfNotInTrade = TRUE;
extern double Close_PendingAfterMinutes = 0.3;
string hlobs_204 = "              ----- News Setting -----";
int hlobi_212 = 2;
bool hlobi_216 = FALSE;
bool hlobi_220 = TRUE;
int hlobi_224 = 3;
int hlobi_228 = 5;
int hlobi_232 = 0;
bool hlobi_236 = TRUE;
bool hlobi_240 = TRUE;
bool hlobi_244 = FALSE;
bool hlobi_248 = FALSE;
bool hlobi_252 = FALSE;
bool hlobi_256 = FALSE;
bool hlobi_260 = FALSE;
bool hlobi_264 = FALSE;
bool hlobi_268 = FALSE;
int hlobi_272 = 1;
int hlobi_276 = 1;
bool hlobi_280 = TRUE;
bool hlobi_284 = FALSE;
bool hlobi_288 = TRUE;
int hlobi_292 = 1;
int hlobi_296 = 20;
int hlobi_300 = 20;
extern string Profit_Settings = "              ----- Trarget Profit and Steps Setting -----";
extern double TotalProfit_Target = 0.01;
extern double TotalProfit_Step_Target = 0.01;
extern int Keep_TradeOpen = 0;
extern string Lot_Settings = "              ----- Lots size & Auto Lots Setting -----";
extern double LotSize = 0.1;
extern double MaxLot = 90.0;
extern bool AutoLot = TRUE;
extern double Amount_Per_baseLot = 15.0;
int hlobi_368 = 3;
string hlobs_buyline_372 = "buyline";
string hlobs_sellline_380 = "sellline";
int hlobi_388;
double hlobd_392;
double hlobd_400;
double hlobd_408;
double hlobd_416;
int hlobi_424 = 0;
int hlobi_428;
string hlobsa_432[];
bool hlobi_436 = TRUE;
double hlobd_448;
double hlobd_456;
bool hlobi_464 = FALSE;
bool hlobi_468 = TRUE;
bool hlobi_472 = FALSE;

// AB2FC3C3886182B6A0B76424CB7612E5
int f0_9(string hargs_0, string &hargs_8) {
   int hloki_16 = InternetOpenA("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)", 0, "0", "0", 0);
   int hloki_20 = InternetOpenUrlA(hloki_16, hargs_0, "0", 0, -2080374528, 0);
   if (hloki_20 == 0) return (0);
   int hlokia_24[] = {1};
   string hloks_28 = "";
   while (true) {
      if (InternetReadFile(hloki_20, hloks_28, 128, hlokia_24) <= 0 || hlokia_24[0] == 0) break;
      hargs_8 = StringConcatenate(hargs_8, StringSubstr(hloks_28, 0, hlokia_24[0]));
   }
   InternetCloseHandle(hloki_20);
   InternetCloseHandle(hloki_16);
   return (1);
}
	  	  		 					   	    	  	   		   	 		  							  	     		 	 	   	 	      	  	  		 		 					   	      			  	 		 		  	 	 	  	       	  	    	 							 					   	 	    	   			    			 
// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   string hloks_0;
   if (Enable_5Digit_Broker) {
      Hidden_Pending_Distane_Pips = 10 * Hidden_Pending_Distane_Pips;
      hlobi_368 = 10 * hlobi_368;
   }
   hlobi_428 = TimeCurrent() - 5;
   f0_6();
   if (AutomaticCalculateMagic) hlobi_160 = f0_12();
   else hlobi_160 = hlobi_156;
   int hloki_8 = 0;
   bool hloki_12 = FALSE;
   hloki_8 = f0_9("http://mt4robots.info/admin/usercheck.php?Email=" + Emailaddress + "&Account=" + LiveForexAccountNumber, hloks_0);
   if (hloki_8 <= 0) Print("Get function no conection");
   if (StringFind(hloks_0, "1", 0) >= 0) hloki_12 = TRUE;
  /* if (!IsDemo() && hloki_12 == FALSE) {
      Alert("If you want use this EA for free please contact kingask2013@gmail.com or Skype: xperya");
      hlobi_436 = FALSE;
   }*/
   if (ObjectFind(hlobs_buyline_372) != -1) ObjectDelete(hlobs_buyline_372);
   if (ObjectFind(hlobs_sellline_380) != -1) ObjectDelete(hlobs_sellline_380);
   return (0);
}
	 			   		 	 						 	  				 		 		    			 	 	 	 				 	 	       		    	 					   	    			   		 					 	  	 					    	      				 	 					   						 	   			 	  	 							   	     	 		  	
// 52D46093050F38C27267BCE42543EF60
int deinit() {
   if (ObjectFind(hlobs_buyline_372) != -1) ObjectDelete(hlobs_buyline_372);
   if (ObjectFind(hlobs_sellline_380) != -1) ObjectDelete(hlobs_sellline_380);
   return (0);
}
				 	 	   		 	   	  	    	      	  	 	 	  		     	  					  			 		   		   	 						 	   		 	   	  		 	     				 	 	  		    	  		   	 			   			  		 			  	 			  	  	   	 				    	 
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   int hloki_0;
   int hloki_4;
   int hloki_8;
   int hloki_12;
   double hlokd_16;
   double hlokd_24;
   if (hlobi_436) {
      if (hlobi_216 && hlobi_468) {
         if (hlobi_220) {
            hloki_0 = iCustom(NULL, 0, "FFCal_04", hlobi_272, hlobi_276, hlobi_280, hlobi_284, 1, hlobi_236, hlobi_240, hlobi_256, hlobi_260, hlobi_252, hlobi_244, hlobi_264,
               hlobi_248, hlobi_268, hlobi_288, hlobi_292, hlobi_296, hlobi_300, 1, 0);
            if (hloki_0 >= hlobi_224 && hloki_0 <= hlobi_228 && (!hlobi_464)) {
               Print("make set");
               hlobd_448 = Ask + Hidden_Pending_Distane_Pips * Point;
               hlobd_456 = Bid - Hidden_Pending_Distane_Pips * Point;
               f0_14(hlobs_buyline_372, hlobd_448);
               f0_14(hlobs_sellline_380, hlobd_456);
               hlobi_388 = TimeCurrent();
               hlobi_464 = TRUE;
            }
         } else {
            hloki_0 = iCustom(NULL, 0, "FFCal_04", hlobi_272, hlobi_276, hlobi_280, hlobi_284, 1, hlobi_236, hlobi_240, hlobi_256, hlobi_260, hlobi_252, hlobi_244, hlobi_264,
               hlobi_248, hlobi_268, hlobi_288, hlobi_292, hlobi_296, hlobi_300, 1, 1);
            if (hloki_0 <= hlobi_232 && (!hlobi_464)) {
               Print("make set");
               hlobd_448 = Ask + Hidden_Pending_Distane_Pips * Point;
               hlobd_456 = Bid - Hidden_Pending_Distane_Pips * Point;
               f0_14(hlobs_buyline_372, hlobd_448);
               f0_14(hlobs_sellline_380, hlobd_456);
               hlobi_388 = TimeCurrent();
               hlobi_464 = TRUE;
            }
         }
      } else {
         if (!hlobi_464) {
            Print("make set");
            hlobd_448 = Ask + Hidden_Pending_Distane_Pips * Point;
            hlobd_456 = Bid - Hidden_Pending_Distane_Pips * Point;
            f0_14(hlobs_buyline_372, hlobd_448);
            f0_14(hlobs_sellline_380, hlobd_456);
            hlobi_388 = TimeCurrent();
            hlobi_464 = TRUE;
         }
      }
      if (!(hlobi_464)) return (0);
      hloki_4 = f0_13();
      hloki_8 = f0_0();
      hloki_12 = f0_3();
      if (hloki_4 == 0 && hloki_8 == 0) {
         if (NormalizeDouble(Ask - Bid, Digits) < NormalizeDouble(MaxSpreads_Points * Point, Digits))
            if (Ask >= hlobd_448) f0_8();
         if (Bid <= hlobd_456) f0_10();
      }
      if (hloki_4 == 1 && hloki_8 == 0) f0_1();
      if (Close_PendingIfNotInTrade) {
         if (TimeCurrent() >= hlobi_388 + 60.0 * Close_PendingAfterMinutes) {
            if (hloki_12 == 0) {
               Print("1");
               if (ObjectFind(hlobs_buyline_372) != -1) ObjectDelete(hlobs_buyline_372);
               if (ObjectFind(hlobs_sellline_380) != -1) ObjectDelete(hlobs_sellline_380);
               hlobi_464 = FALSE;
               if (hloki_8 > 0) {
                  if (KeepTrading) hlobi_468 = TRUE;
                  else hlobi_468 = FALSE;
               }
            }
         }
      }
      if (hloki_12 == 0) {
         if (hloki_8 > 0) {
            Print("2");
            if (ObjectFind(hlobs_buyline_372) != -1) ObjectDelete(hlobs_buyline_372);
            if (ObjectFind(hlobs_sellline_380) != -1) ObjectDelete(hlobs_sellline_380);
            hlobi_464 = FALSE;
            if (KeepTrading) hlobi_468 = TRUE;
            else hlobi_468 = FALSE;
         }
      } else {
         hlokd_16 = f0_5();
         if (f0_7()) {
            hlokd_24 = f0_11();
            if (!hlobi_472) {
               hlobd_392 = TotalProfit_Target * hlokd_16;
               hlobd_408 = hlobd_392;
               hlobd_416 = TotalProfit_Step_Target * hlokd_16;
               hlobi_472 = TRUE;
            }
            if (hlokd_24 > hlobd_392) {
               hlobd_392 = hlokd_24;
               Print("trade profit  ", hlobd_392);
               if (hlobi_424 > 0) hlobd_400 = hlobd_392 - hlobd_416;
            }
            if (hlobi_424 == 0 && hlobd_392 - hlobd_408 >= hlobd_416) {
               hlobd_400 = hlobd_392 - hlobd_416;
               Print("profit for close  ", hlobd_400);
               Print("add step ");
               hlobi_424++;
            }
            if (hlobi_424 > 0 && hlokd_24 <= hlobd_400) {
               f0_2();
               Print("close with profit", hlobd_400);
               hlobi_424 = 0;
               hlobi_472 = FALSE;
            }
         }
      }
      return (0);
   }
}
	   	  	 		  		  	 		    	 			    		 		 			  	   	 		 			 		  	 	 			 	  	 	  			 	 		 			 				    	 	   	     	  		     	 		 	  	 	  	  	   	 			   	 	    			   			  		  			 	 
// FFCAA643B493573EC6A0A6AFE59C37B8
void f0_14(string hargs_0, double hargd_8) {
   string hloks_16 = hargs_0;
   if (ObjectFind(hloks_16) != -1) {
      ObjectMove(hloks_16, 0, Time[0], hargd_8);
      return;
   }
   ObjectCreate(hloks_16, OBJ_HLINE, 0, 0, hargd_8);
   ObjectSet(hloks_16, OBJPROP_COLOR, Blue);
   ObjectSet(hloks_16, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(hloks_16, OBJPROP_WIDTH, 1);
   ObjectSet(hloks_16, OBJPROP_BACK, TRUE);
}
		 	 	    			 		     	 	       	 		 	 			 			  	     		 			 							  			    			 				    	     		 	  	  	   			   		 		 	     			    				   		   	  		    	 	  		 		  	  		       
// 2208AB04CCD91A8303FE0D7679EA198F
void f0_2() {
   while (f0_3() > 0) {
      for (int hloki_0 = 0; hloki_0 < OrdersTotal(); hloki_0++) {
         if (OrderSelect(hloki_0, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == Symbol() && OrderType() <= OP_SELL && OrderMagicNumber() == hlobi_160) {
               if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, hlobi_368, Black);
               if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, hlobi_368, Black);
            }
         }
      }
   }
}
	 		 		  	 		  	 		  			 		   		    	  			 		 		 		  	  	   		 		    	 	 		 		  	  	  	 			    	  	 	 		 						     				 		  	 	 		 		 	 				 	 					 	   		   	     		 	 	   	  
// 5E6381046EEFD4FF2270BD9B9CB2DF3A
int f0_5() {
   int hloki_0 = NormalizeDouble(f0_4() / MarketInfo(Symbol(), MODE_MINLOT), 0);
   return (hloki_0);
}
	 	 		 			    	 						  					   	  	  	  	      								   	 		    				 				 			    	  	 				 	 	 		    			  	 		  	 	  							 				 		 			    	 		    		 	 	 	 	  			 	  			  		
// 00B85795831A6FEF4DF6C8A164D0D548
int f0_0() {
   int hloki_0 = 0;
   for (int hloki_4 = 0; hloki_4 < OrdersHistoryTotal(); hloki_4++) {
      if (OrderSelect(hloki_4, SELECT_BY_POS, MODE_HISTORY)) {
         if (OrderSymbol() == Symbol() && OrderType() <= OP_SELL)
            if (OrderMagicNumber() == hlobi_160 && OrderOpenTime() >= hlobi_388) hloki_0++;
      }
   }
   return (hloki_0);
}
	 	  	 	 	  	 	  			 	   			       		 	 		  	    			 				  				 	  	 		  								      					  	   			    		 		 	   			   			 		  						  		 	  				 	  	  	   	    	 	 		 		   	 
// 17D772DE8C0915B0BB0EBDD567883DF7
void f0_1() {
   for (int hloki_0 = 0; hloki_0 < OrdersTotal(); hloki_0++) {
      if (OrderSelect(hloki_0, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderType() <= OP_SELL && OrderMagicNumber() == hlobi_160) {
            if (OrderType() == OP_BUY) {
               if (Bid <= hlobd_456)
                  if (OrderClose(OrderTicket(), OrderLots(), Bid, hlobi_368, Black)) break;
            }
            if (OrderType() == OP_SELL) {
               if (Ask >= hlobd_448)
                  if (OrderClose(OrderTicket(), OrderLots(), Ask, hlobi_368, Black)) break;
            }
         }
      }
   }
}
	     	  		 		 	 	 	  		 	 	 			  				 				 				 	 	    	 			  		 		   	 	 		   	 	  		 		 	 	 	   					 	  	 	   			 		 	 	   	 	 		  	 	  			 		  			      	 	  		  	 	  	 		  
// 33206DE718A258471B12F91D380A844C
int f0_3() {
   int hloki_0 = 0;
   for (int hloki_4 = 0; hloki_4 < OrdersTotal(); hloki_4++) {
      if (OrderSelect(hloki_4, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderType() <= OP_SELL)
            if (OrderMagicNumber() == hlobi_160) hloki_0++;
      }
   }
   return (hloki_0);
}
		 			    		  		    		 	    	  	 		   			 		   	    			 			  						 				     		 					   	   	 		 	     	   	 	   		  	 	    				     			   	    	  	     	 		 		 		 		  		  	    
// EBF10DC6D0336C6D28DD08CBCA76C625
int f0_13() {
   int hloki_0 = 0;
   for (int hloki_4 = 0; hloki_4 < OrdersTotal(); hloki_4++) {
      if (OrderSelect(hloki_4, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderType() <= OP_SELL)
            if (OrderMagicNumber() == hlobi_160 && OrderOpenTime() >= hlobi_388) hloki_0++;
      }
   }
   return (hloki_0);
}
	  				 				   			  						  	 			 	    	 			  				  		    	  	 	  	 		 			   	    			 	  	  	  		     				 	 		 	 	  					  		 			   	 			 	  	  	 	  	 	  		  		 	 			     	 	 	
// A5475BEEA729819A4699A3F14CBC7B39
void f0_8() {
   int hloki_4;
   int hloki_0 = 0;
   bool hloki_8 = TRUE;
   while (hloki_8) {
      RefreshRates();
      hloki_0 = OrderSend(Symbol(), OP_BUY, f0_4(), NormalizeDouble(Ask, Digits), hlobi_368, 0, 0, "", hlobi_160, 16711680);
      Sleep(200);
      if (hloki_0 > 0) hloki_8 = FALSE;
      else {
         hloki_4 = GetLastError();
         if (hloki_4 == 129/* INVALID_PRICE */ || hloki_4 == 138/* REQUOTE */) {
            Sleep(200);
            RefreshRates();
            continue;
         }
         hloki_8 = FALSE;
      }
   }
   if (hloki_0 <= 0) Print(GetLastError());
}
		  			 	 	    		  						  		 						   	  	   			  			   			 	 	 					 		  	 	   		 	 	    		  			 	  			    		 				 				  			 		  	 	 		     	       	 		  	  								  	 		 	 	
// B6832796D33422B67F3123C913057ADB
void f0_10() {
   int hloki_4;
   int hloki_0 = 0;
   bool hloki_8 = TRUE;
   while (hloki_8) {
      RefreshRates();
      hloki_0 = OrderSend(Symbol(), OP_SELL, f0_4(), NormalizeDouble(Bid, Digits), hlobi_368, 0, 0, "", hlobi_160, 255);
      Sleep(200);
      if (hloki_0 > 0) hloki_8 = FALSE;
      else {
         hloki_4 = GetLastError();
         if (hloki_4 == 129/* INVALID_PRICE */ || hloki_4 == 138/* REQUOTE */) {
            Sleep(200);
            RefreshRates();
            continue;
         }
         hloki_8 = FALSE;
      }
   }
   if (hloki_0 <= 0) Print(GetLastError());
}
	    	  			 	 				 	 	 			 	   		 			 		 		 	  			 	 		   						  		 					 				   	      	 	  			  		  			  		  	 				 			 	 					 							  	    	  	   	     			 		 	     	    	
// 4CA46AAB119D6115222154B9DE991BEE
double f0_4() {
   double hlokd_0;
   if (!AutoLot) hlokd_0 = LotSize;
   else hlokd_0 = MathFloor(AccountEquity() / Amount_Per_baseLot) * MarketInfo(Symbol(), MODE_MINLOT);
   if (hlokd_0 < MarketInfo(Symbol(), MODE_MINLOT)) hlokd_0 = MarketInfo(Symbol(), MODE_MINLOT);
   if (hlokd_0 > MarketInfo(Symbol(), MODE_MAXLOT)) hlokd_0 = MarketInfo(Symbol(), MODE_MAXLOT);
   if (hlokd_0 > MaxLot) hlokd_0 = MaxLot;
   if (MarketInfo(Symbol(), MODE_MINLOT) == 0.1) hlokd_0 = NormalizeDouble(hlokd_0, 1);
   if (MarketInfo(Symbol(), MODE_MINLOT) == 0.01) hlokd_0 = NormalizeDouble(hlokd_0, 2);
   return (hlokd_0);
}
			    		   			 	 		    	 		 	  		 				     		  	 		  		 	 		 	  	 	  	 	 			 		 	   	 	  		 		 						  	 	 	  			 		   	 		  	 	 			 	 	 	 		 	  	 		 				  		 		 	   	 			 	 		
// 7AA1EC0A310DF29C6D98B0354710655D
int f0_7() {
   int hloki_0 = 0;
   for (int hloki_4 = 0; hloki_4 < OrdersTotal(); hloki_4++) {
      if (OrderSelect(hloki_4, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == hlobi_160 && OrderType() <= OP_SELL)
            if (OrderOpenTime() > hloki_0 && OrderOpenTime() > hlobi_428) hloki_0 = OrderOpenTime();
      }
   }
   if (hloki_0 != 0) {
      if (TimeCurrent() - hloki_0 > Keep_TradeOpen) return (1);
      return (0);
   }
   return (0);
}
	   			  		    	 	 					 	 		 		  		   				   		 	 			  	 		 	 		 				 	 	 	 	  	 	 	 	 		 		  	   	  		 	   		   		 			 	 			 	 	 	 	 	 	    	 		    	     	  	  					 	  		 	  
// C9E339AC8E524CA7C6F5AA6D3A63450F
double f0_11() {
   double hlokd_0 = 0;
   for (int hloki_8 = 0; hloki_8 < OrdersTotal(); hloki_8++) {
      if (OrderSelect(hloki_8, SELECT_BY_POS, MODE_TRADES))
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == hlobi_160 && OrderType() <= OP_SELL) hlokd_0 = hlokd_0 + OrderProfit() + OrderSwap() + OrderCommission();
   }
   return (hlokd_0);
}
	  	   								 		      		   	  	 	 			  					  		    		  	 	 	   	   	 		  	 		  		 	 	 	   		 	   		  		 		  		 	 	   		    	 		  	 	 		 			 	 	 			 		  	 		 	 	    	     	 		
// CC280CABE49899B45BCA03607341629A
int f0_12() {
   int hloki_0 = 0;
   int hloki_4 = ArraySize(hlobsa_432);
   for (int hloki_8 = 0; hloki_8 < hloki_4; hloki_8++)
      if (hlobsa_432[hloki_8] == Symbol()) hloki_0 = hlobi_156 + hloki_8;
   return (hloki_0);
}
		 	 				 			   	    		 	     	 			 	     			 	 	    	 	 		 		   		  	  	   		 	 			  		        		  	 	 	  								 			 	    	  	   		  	  		 		   		 				 	    			  			 	    			
// 7A1A5F3E79FDC91EDF2F5EAD9D66ABB4
void f0_6() {
   int hloki_4;
   int hloki_0 = FileOpenHistory("symbols.raw", FILE_BIN|FILE_READ);
   if (hloki_0 >= 0) {
      hloki_4 = FileSize(hloki_0) / 1936;
      ArrayResize(hlobsa_432, hloki_4);
      for (int hloki_8 = 0; hloki_8 < hloki_4; hloki_8++) {
         hlobsa_432[hloki_8] = FileReadString(hloki_0, 12);
         FileSeek(hloki_0, 1924, SEEK_CUR);
      }
   }
}
