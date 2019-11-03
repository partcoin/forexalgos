#property copyright "alshamsi"
#property link      "fx_mt4_ea@hotmail.com"

extern bool Debug = FALSE;
extern string TradingSettings = " Order Management";
extern int Min_Step = 2;
extern int timediff = 2;
extern int StopLoss = 4;
extern int trailing = 4;
extern bool SafetyMode = FALSE;
extern int MaxSpread = 22;
extern string OrderCmt = "Chad Scalper";
extern int slippage = 3;
extern int Magic = -1;
extern string MM_Parameters = " Money Management";
extern double ManualLotsize = 0.01;
extern bool MoneyManagement = TRUE;
extern int Risk = 22;
double G_price_152;
int G_ticket_160;
int G_order_total_164;
bool Gi_168;
int G_count_172;
int G_count_176;
datetime G_time_180;
datetime G_time_184;
bool Gi_188;
bool Gi_192;
double Gd_196;
double Gd_204;
double G_pips_212 = 1.0;
double Gd_220;
double Gd_228;
int Gi_236;
double Gd_240;
double Gd_248;
double G_bid_256 = 0.0;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   if (Digits == 3 || Digits == 5) Gi_236 = 10;
   else Gi_236 = 1;
   Gd_220 = MarketInfo(Symbol(), MODE_STOPLEVEL);
   StopLoss = MathMax(StopLoss, Gd_220 / Gi_236);
   trailing = MathMax(trailing, Gd_220 / Gi_236);
   if (Magic < 0) Magic = f0_0();
   if (SafetyMode) G_pips_212 = 2;
   else G_pips_212 = 1;
   if (Debug) f0_1();
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   if (MathAbs(G_bid_256 - MarketInfo(Symbol(), MODE_BID)) / Point <= Min_Step) return (0);
   G_bid_256 = MarketInfo(Symbol(), MODE_BID);
   if (MarketInfo(Symbol(), MODE_SPREAD) >= MaxSpread) return (0);
   double ask_0 = MarketInfo(Symbol(), MODE_ASK);
   double bid_8 = MarketInfo(Symbol(), MODE_BID);
   Gd_228 = (ask_0 - bid_8) / Point / Gi_236;
   G_order_total_164 = OrdersTotal();
   if (Debug) f0_1();
   if (G_order_total_164 <= 0) {
      if (Gd_240 > 0.0 || Gd_248 > 0.0) {
         Gd_240 = 0;
         Gd_248 = 0;
      }
      if (Gd_196 < MarketInfo(Symbol(), MODE_ASK) - G_pips_212 * Point) {
         G_count_172++;
         Gd_196 = NormalizeDouble(MarketInfo(Symbol(), MODE_ASK), Digits);
         if (Gi_188 == FALSE) {
            G_time_180 = MarketInfo(Symbol(), MODE_TIME);
            Gi_188 = TRUE;
         }
      } else {
         Gd_196 = 0;
         G_count_172 = 0;
         Gi_188 = FALSE;
         G_time_180 = 0;
      }
      if (Gd_204 > MarketInfo(Symbol(), MODE_ASK) + G_pips_212 * Point) {
         G_count_176++;
         Gd_204 = NormalizeDouble(MarketInfo(Symbol(), MODE_ASK), Digits);
         if (Gi_192 == FALSE) {
            G_time_184 = MarketInfo(Symbol(), MODE_TIME);
            Gi_192 = TRUE;
         }
      } else {
         Gd_204 = 0;
         G_count_176 = 0;
         Gi_192 = FALSE;
         G_time_184 = 0;
      }
      if (G_count_172 == G_pips_212 * Gi_236 || G_count_176 == G_pips_212 * Gi_236) {
         Gi_168 = FALSE;
         if (G_count_172 < G_count_176) {
            if (MarketInfo(Symbol(), MODE_TIME) - G_time_184 <= timediff) {
               G_ticket_160 = OrderSend(Symbol(), OP_SELL, f0_2(), MarketInfo(Symbol(), MODE_BID), slippage, 0, 0, OrderCmt, Magic, 0, Red);
               if (G_ticket_160 > 0) {
                  if (StopLoss * Gi_236 > Gd_220) {
                     if (OrderSelect(G_ticket_160, SELECT_BY_TICKET, MODE_TRADES)) {
                        G_price_152 = 0;
                        if (StopLoss * Gi_236 > Gd_220) G_price_152 = NormalizeDouble(MarketInfo(Symbol(), MODE_ASK) + StopLoss * Point * Gi_236, Digits);
                        if (!OrderModify(OrderTicket(), OrderOpenPrice(), G_price_152, 0, 0, Red)) Gi_168 = TRUE;
                     }
                  }
               }
            }
         } else {
            if (MarketInfo(Symbol(), MODE_TIME) - G_time_180 <= timediff) {
               G_ticket_160 = OrderSend(Symbol(), OP_BUY, f0_2(), MarketInfo(Symbol(), MODE_ASK), slippage, 0, 0, OrderCmt, Magic, 0, Green);
               if (G_ticket_160 > 0) {
                  if (StopLoss * Gi_236 > Gd_220) {
                     if (OrderSelect(G_ticket_160, SELECT_BY_TICKET, MODE_TRADES)) {
                        G_price_152 = 0;
                        if (StopLoss * Gi_236 > Gd_220) G_price_152 = NormalizeDouble(MarketInfo(Symbol(), MODE_BID) - StopLoss * Point * Gi_236, Digits);
                        if (!OrderModify(OrderTicket(), OrderOpenPrice(), G_price_152, 0, 0, Green)) Gi_168 = TRUE;
                     }
                  }
               }
            }
         }
         Gd_196 = 0;
         Gd_204 = 0;
         G_count_172 = 0;
         G_count_176 = 0;
         Gi_188 = FALSE;
         Gi_192 = FALSE;
         G_time_180 = 0;
         G_time_184 = 0;
      }
      if (Gd_196 == 0.0) Gd_196 = NormalizeDouble(MarketInfo(Symbol(), MODE_ASK), Digits);
      if (Gd_204 == 0.0) Gd_204 = NormalizeDouble(MarketInfo(Symbol(), MODE_ASK), Digits);
   } else f0_3();
   return (0);
}

// 2569208C5E61CB15E209FFE323DB48B7
void f0_1() {
   Comment("\n     :: Server Date Time: ", Year(), ".", Month(), ".", Day(), "   ", TimeToStr(MarketInfo(Symbol(), MODE_TIME), TIME_SECONDS), 
      "\n\n\n    ------------------------------------------------------------", 
      "\n\n      :: Broker   :   ", TerminalCompany(), 
      "\n      :: Acc. Name  :  ", AccountName(), 
      "\n      :: Acc, Number   :   ", AccountNumber(), 
      "\n      :: Acc. Leverage:   1 : ", AccountLeverage(), 
      "\n      :: Equity   :   ", AccountEquity(), 
      "\n      :: Magic    :   ", OrderMagicNumber(), 
      "\n      :: Magicnumber :  ", Magic, 
      "\n\n    ------------------------------------------------------------", 
      "\n\n     :: StopLevel  :   ", DoubleToStr(Gd_220 / Gi_236, 1), " pips", 
      "\n     :: Spread  :   ", DoubleToStr(Gd_228, 1), " pips", 
   "\n     :: Next Lots  :   ", DoubleToStr(f0_2(), 2));
   ObjectCreate("oop", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("oop", "Programmed by Ponsuke" + ", http://soehoe.com", 12, "Verdana", White);
   ObjectSet("oop", OBJPROP_CORNER, 3);
   ObjectSet("oop", OBJPROP_XDISTANCE, 5);
   ObjectSet("oop", OBJPROP_YDISTANCE, 5);
}

// 6ABA3523C7A75AAEA41CC0DEC7953CC5
double f0_2() {
   double Ld_0;
   int Li_8;
   double Ld_12;
   double iopen_20 = 0;
   string str_concat_28 = "";
   int str_len_36 = StringLen(Symbol());
   int Li_40 = StringFind(Symbol(), "USD");
   double lotstep_44 = MarketInfo(Symbol(), MODE_LOTSTEP);
   double Ld_52 = MarketInfo(Symbol(), MODE_MAXLOT);
   double Ld_60 = MarketInfo(Symbol(), MODE_MINLOT);
   if (lotstep_44 == 1.0) Li_8 = 0;
   if (lotstep_44 == 0.1) Li_8 = 1;
   if (lotstep_44 == 0.01) Li_8 = 2;
   if (Li_40 >= 3) Ld_12 = MathMin(MarketInfo(Symbol(), MODE_MAXLOT), AccountFreeMargin() * AccountLeverage() / MarketInfo(Symbol(), MODE_BID) / MarketInfo(Symbol(), MODE_LOTSIZE));
   if (Li_40 == 0) Ld_12 = MathMin(MarketInfo(Symbol(), MODE_MAXLOT), AccountFreeMargin() * AccountLeverage() / MarketInfo(Symbol(), MODE_LOTSIZE));
   if (Li_40 < 0) {
      if (str_len_36 > 6) str_concat_28 = StringConcatenate(StringSubstr(Symbol(), 0, 3), "USD" + StringSubstr(Symbol(), 6, str_len_36));
      else str_concat_28 = StringConcatenate(StringSubstr(Symbol(), 0, 3), "USD");
      iopen_20 = iOpen(str_concat_28, PERIOD_H1, 0);
      if (iopen_20 <= 0.0) {
         if (str_len_36 > 6) str_concat_28 = StringConcatenate("USD", StringSubstr(Symbol(), 3, 3) + StringSubstr(Symbol(), 6, str_len_36));
         else str_concat_28 = StringConcatenate("USD", StringSubstr(Symbol(), 3, 3));
         iopen_20 = iOpen(str_concat_28, PERIOD_H1, 0);
         Ld_12 = AccountFreeMargin() * AccountLeverage() / iopen_20 / MarketInfo(Symbol(), MODE_LOTSIZE);
      } else Ld_12 = MathMin(MarketInfo(Symbol(), MODE_MAXLOT), AccountFreeMargin() * AccountLeverage() / iopen_20 / MarketInfo(Symbol(), MODE_LOTSIZE));
   }
   if (MoneyManagement) {
      Ld_0 = NormalizeDouble(AccountEquity(), Li_8) * Risk / 102.0 / 100.0;
      if (Ld_0 > Ld_12) Ld_0 = Ld_12;
      if (Ld_0 < Ld_60) Ld_0 = Ld_60;
      if (Ld_0 > Ld_52) Ld_0 = Ld_52;
   } else Ld_0 = ManualLotsize;
   return (NormalizeDouble(Ld_0, Li_8));
}

// 9B1AEE847CFB597942D106A4135D4FE6
void f0_3() {
   double bid_0;
   double ask_8;
   double order_open_price_16;
   double Ld_24;
   double Ld_32;
   int magic_40;
   double point_44 = MarketInfo(Symbol(), MODE_POINT);
   int Li_52 = 1;
   if (trailing * Gi_236 <= Gd_220) Li_52 = -1;
   for (int pos_56 = OrdersTotal() - 1; pos_56 >= 0; pos_56--) {
      if (OrderSelect(pos_56, SELECT_BY_POS, MODE_TRADES) == FALSE) break;
      if (OrderSymbol() == Symbol()) {
         magic_40 = OrderMagicNumber();
         if (magic_40 == Magic) {
            if (OrderType() == OP_BUY) {
               if (StopLoss * Gi_236 <= Gd_220 || Gi_168 == TRUE) {
                  if (OrderStopLoss() == 0.0)
                     if (Gd_240 == 0.0) Gd_240 = OrderOpenPrice() - StopLoss * Gi_236 * point_44;
                  if (OrderOpenPrice() - MarketInfo(Symbol(), MODE_ASK) >= StopLoss * Gi_236 * point_44) OrderClose(OrderTicket(), OrderLots(), MarketInfo(Symbol(), MODE_BID), 5 * Gi_236, Blue);
               }
               if (Li_52 == -1) {
                  order_open_price_16 = OrderOpenPrice();
                  bid_0 = MarketInfo(Symbol(), MODE_BID);
                  if (Gd_240 == 0.0)
                     if (bid_0 - trailing * Gi_236 * point_44 > order_open_price_16) Gd_240 = bid_0 - trailing * Gi_236 * point_44;
                  if (Gd_240 > 0.0) {
                     if (bid_0 < Gd_240)
                        if (OrderClose(OrderTicket(), OrderLots(), MarketInfo(Symbol(), MODE_BID), 5 * Gi_236, Blue)) break;
                     if (bid_0 - trailing * Gi_236 * point_44 > order_open_price_16 && bid_0 - trailing * Gi_236 * point_44 > Gd_240) Gd_240 = bid_0 - trailing * Gi_236 * point_44;
                  }
               }
               if (Li_52 == 1) {
                  order_open_price_16 = OrderOpenPrice();
                  Ld_24 = OrderStopLoss();
                  Ld_32 = Ld_24;
                  bid_0 = MarketInfo(Symbol(), MODE_BID);
                  if (bid_0 - trailing * Gi_236 * point_44 > order_open_price_16) Ld_32 = bid_0 - trailing * Gi_236 * point_44;
                  if (Ld_32 > Ld_24 && Ld_32 > order_open_price_16 && bid_0 - Ld_32 > Gd_220 * point_44) {
                     if (!OrderModify(OrderTicket(), order_open_price_16, NormalizeDouble(Ld_32, Digits), OrderTakeProfit(), 0)) Print("Error Occured :  ", GetLastError());
                     else {
                        Gd_240 = 0;
                        Gd_248 = 0;
                     }
                  }
               }
            }
            if (OrderType() == OP_SELL) {
               if (StopLoss * Gi_236 <= Gd_220 || Gi_168 == TRUE) {
                  if (OrderStopLoss() == 0.0)
                     if (Gd_248 == 0.0) Gd_248 = OrderOpenPrice() + StopLoss * Gi_236 * point_44;
                  if (MarketInfo(Symbol(), MODE_BID) - OrderOpenPrice() >= StopLoss * Gi_236 * point_44) OrderClose(OrderTicket(), OrderLots(), MarketInfo(Symbol(), MODE_ASK), 5 * Gi_236, Red);
               }
               if (Li_52 == -1) {
                  order_open_price_16 = OrderOpenPrice();
                  ask_8 = MarketInfo(Symbol(), MODE_ASK);
                  if (Gd_248 == 0.0)
                     if (order_open_price_16 - ask_8 > trailing * Gi_236 * point_44) Gd_248 = order_open_price_16 + trailing * Gi_236 * point_44;
                  if (Gd_248 > 0.0) {
                     if (ask_8 > Gd_248)
                        if (OrderClose(OrderTicket(), OrderLots(), MarketInfo(Symbol(), MODE_ASK), 5 * Gi_236, Blue)) break;
                     if (order_open_price_16 - ask_8 > trailing * Gi_236 * point_44 && ask_8 + trailing * Gi_236 * point_44 < Gd_248) Gd_248 = ask_8 + trailing * Gi_236 * point_44;
                  }
               }
               if (Li_52 == 1) {
                  order_open_price_16 = OrderOpenPrice();
                  Ld_24 = OrderStopLoss();
                  Ld_32 = Ld_24;
                  ask_8 = MarketInfo(Symbol(), MODE_ASK);
                  if (order_open_price_16 - ask_8 > trailing * Gi_236 * point_44 && Ld_24 > ask_8 + trailing * Gi_236 * point_44 || Ld_24 == 0.0) Ld_32 = ask_8 + trailing * Gi_236 * point_44;
                  if (Ld_32 < Ld_24 || Ld_24 == 0.0 && Ld_32 < order_open_price_16 && Ld_32 - ask_8 > Gd_220 * point_44) {
                     if (!OrderModify(OrderTicket(), order_open_price_16, NormalizeDouble(Ld_32, Digits), OrderTakeProfit(), 0)) {
                        Print("Error Occured : ", GetLastError());
                        continue;
                     }
                     Gd_240 = 0;
                     Gd_248 = 0;
                  }
               }
            }
         }
      }
   }
}

// 09CBB5F5CE12C31A043D5C81BF20AA4A
int f0_0() {
   int Li_ret_0;
   string Ls_4 = "";
   Ls_4 = "_" + Symbol() + "__" + Period();
   for (int Li_12 = 0; Li_12 < StringLen(Ls_4); Li_12++) {
      Li_ret_0 += StringGetChar(Ls_4, Li_12);
      Li_ret_0 += Li_ret_0 << 10;
      Li_ret_0 ^= Li_ret_0 >> 6;
   }
   Li_ret_0 += 8 * Li_ret_0;
   Li_ret_0 ^= Li_ret_0 >> 11;
   Li_ret_0 += Li_ret_0 << 15;
   Li_ret_0 = MathAbs(Li_ret_0);
   return (Li_ret_0);
}
