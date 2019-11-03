
#property copyright "Copyright © 2012, TechCougar"
#property link      "www.techcougar.com"

extern string OrderCmt = "Bengal Impulsive Scalper";
extern int Magic = 201210231;
extern double Lots = 0.1;
extern double Risk = 0.0;
extern bool DeletePending = TRUE;
extern int HardSL = 30;
extern int HardTP = 160;
extern string MA_methods = "0 -> simple, 1 -> exponential, 2 -> smoothed, 3 -> linear weighted";
extern int MA_method = 3;
extern int MA_period = 3;
extern int MA_shift = 0;
extern int TrailingOrderTrigger = 60;
extern int TrailingOrderDistance = 30;
extern int TrailingOrderStep = 5;
extern int TrailingStopStart = 30;
extern int TrailingStopDistance = 40;
extern int TrailingStopStep = 10;
extern int Slippage = 3;
extern int MaxSpread = 20;
extern bool ECN_mode = TRUE;
extern int RetryCount = 5;
extern int RetryTime = 10;
int G_ticket_180 = 0;
bool Gi_184 = FALSE;
double Gd_188 = 0.0;
int Gi_196 = 0;
int Gi_200 = 0;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   if (!IsExpertEnabled() && !IsTesting()) return;
   if (IsTradeContextBusy() == FALSE) {
      Gd_188 = (Ask - Bid) / Point;
      Comment("Spread: ", NormalizeDouble(Gd_188, 2), 
         "\nPending exec: ", Gi_196, 
      "\nModify exec: ", Gi_200);
      if (Gi_184 == FALSE) f0_7();
      if (Gi_184 == FALSE) return (0);
      f0_4();
      return (0);
   }
}

// F80117A9A517D53EF4DA2EF4D5BF21C9
void f0_7() {
   double ima_0;
   double ima_8;
   RefreshRates();
   if (Gd_188 <= MaxSpread) {
      ima_0 = iMA(NULL, 0, MA_period, 0, MA_method, PRICE_HIGH, MA_shift);
      if (Bid > ima_0 + TrailingOrderTrigger * Point) f0_0(1);
      ima_8 = iMA(NULL, 0, MA_period, 0, MA_method, PRICE_LOW, MA_shift);
      if (Ask < ima_8 - TrailingOrderTrigger * Point) f0_0(-1);
   }
}

// 764CAF889A4E92F0F31A08E16B47FC92
void f0_0(int Ai_0) {
   if (Ai_0 == 1) {
      G_ticket_180 = f0_5(Symbol(), OP_SELLSTOP, f0_6(), NormalizeDouble(Bid - TrailingOrderDistance * Point, Digits), Slippage, NormalizeDouble(Bid - TrailingOrderDistance * Point +
         HardSL * Point, Digits), NormalizeDouble(Bid - TrailingOrderDistance * Point - HardTP * Point, Digits), OrderCmt, Magic, 0, Blue);
   }
   if (Ai_0 == -1) {
      G_ticket_180 = f0_5(Symbol(), OP_BUYSTOP, f0_6(), NormalizeDouble(Ask + TrailingOrderDistance * Point, Digits), Slippage, NormalizeDouble(Ask + TrailingOrderDistance * Point - HardSL * Point,
         Digits), NormalizeDouble(Ask + TrailingOrderDistance * Point + HardTP * Point, Digits), OrderCmt, Magic, 0, Green);
   }
   if (G_ticket_180 > 0) Gi_184 = Ai_0;
}

// A220E800CE860CFDD493F246032B514E
void f0_4() {
   OrderSelect(G_ticket_180, SELECT_BY_TICKET);
   if (OrderCloseTime() != 0) {
      Print("Order Closed. Profit pips: ", OrderProfit() / OrderLots() / 10.0);
      G_ticket_180 = 0;
      Gi_184 = FALSE;
      return;
   }
   if (OrderType() == OP_BUY || OrderType() == OP_SELL) f0_3();
   if (OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP) f0_2();
}

// 86B0205F5C20BDA2E6C396B4DEEECF4C
void f0_2() {
   double ima_0;
   double ima_8;
   OrderSelect(G_ticket_180, SELECT_BY_TICKET);
   if (OrderType() == OP_BUYSTOP) {
      if (DeletePending) {
         ima_0 = iMA(NULL, 0, MA_period, 0, MA_method, PRICE_LOW, MA_shift);
         if (Ask > ima_0 - TrailingOrderTrigger * Point) {
            OrderDelete(G_ticket_180);
            Gi_184 = FALSE;
            G_ticket_180 = -1;
            Print("Pending deleted");
            return;
         }
      }
      if (OrderOpenPrice() > Ask + TrailingOrderDistance * Point + TrailingOrderStep * Point) {
         f0_1(G_ticket_180, NormalizeDouble(Ask + TrailingOrderDistance * Point, Digits), NormalizeDouble(Ask + TrailingOrderDistance * Point - HardSL * Point, Digits), NormalizeDouble(Ask +
            TrailingOrderDistance * Point + HardTP * Point, Digits), 0, Green);
      }
   }
   if (OrderType() == OP_SELLSTOP) {
      if (DeletePending) {
         ima_8 = iMA(NULL, 0, MA_period, 0, MA_method, PRICE_HIGH, MA_shift);
         if (Bid < ima_8 + TrailingOrderTrigger * Point) {
            OrderDelete(G_ticket_180);
            Gi_184 = FALSE;
            G_ticket_180 = -1;
            Print("Pending deleted");
            return;
         }
      }
      if (OrderOpenPrice() < Bid - TrailingOrderDistance * Point - TrailingOrderStep * Point) {
         f0_1(G_ticket_180, NormalizeDouble(Bid - TrailingOrderDistance * Point, Digits), NormalizeDouble(Bid - TrailingOrderDistance * Point + HardSL * Point, Digits), NormalizeDouble(Bid - TrailingOrderDistance * Point - HardTP * Point,
            Digits), 0, Blue);
      }
   }
}

// D60DFB2BE7F7B8D82CE6AEF129404E6E
double f0_6() {
   if (Lots != 0.0) return (Lots);
   double Ld_0 = AccountEquity() * Risk / 100.0;
   double Ld_8 = 10.0 * (Ld_0 / HardSL) / 10.0;
   double Ld_ret_16 = MathRound(100.0 * Ld_8) / 100.0;
   Print("calculated volume: " + Ld_ret_16);
   if (MarketInfo(Symbol(), MODE_MINLOT) > Ld_ret_16) {
      Ld_ret_16 = MarketInfo(Symbol(), MODE_MINLOT);
      Alert("Too small capital! Using minimum lotsize!");
   }
   return (Ld_ret_16);
}

// 8BE75C90D2A023F9107445F37B52BA8B
void f0_3() {
   OrderSelect(G_ticket_180, SELECT_BY_TICKET);
   if (OrderType() == OP_BUY && OrderOpenPrice() < Bid + TrailingStopStart * Point)
      if (OrderStopLoss() < Bid - TrailingStopDistance * Point - TrailingStopStep * Point) f0_1(G_ticket_180, OrderOpenPrice(), NormalizeDouble(Bid - TrailingStopDistance * Point, Digits), 0, 0, Green);
   if (OrderType() == OP_SELL && OrderOpenPrice() > Ask - TrailingStopStart * Point)
      if (OrderStopLoss() > Ask + TrailingStopDistance * Point + TrailingStopStep * Point) f0_1(G_ticket_180, OrderOpenPrice(), NormalizeDouble(Ask + TrailingStopDistance * Point, Digits), 0, 0, Blue);
}

// 809CA4C631EC6105523E81A554585145
void f0_1(int A_ticket_0, double A_price_4, double A_price_12, double A_price_20, int A_datetime_28, color A_color_32) {
   int Li_36 = GetTickCount();
   OrderSelect(A_ticket_0, SELECT_BY_TICKET);
   for (int Li_40 = 1; Li_40 <= RetryCount; Li_40++) {
      if (OrderModify(A_ticket_0, A_price_4, A_price_12, A_price_20, A_datetime_28, A_color_32)) break;
      Print("ordermodify error: ", GetLastError());
      Sleep(RetryTime);
   }
   Gi_200 = GetTickCount() - Li_36;
}

// AA1204ED2A7D03897BF86AE175E346E5
int f0_5(string A_symbol_0, int A_cmd_8, double A_lots_12, double A_price_20, int A_slippage_28, double A_price_32, double A_price_40, string A_comment_48, int A_magic_56, int A_datetime_60, color A_color_64) {
   int Li_76;
   int ticket_68 = 0;
   for (int Li_72 = 1; Li_72 <= RetryCount; Li_72++) {
      RefreshRates();
      if (A_cmd_8 == OP_BUY) A_price_20 = Ask;
      if (A_cmd_8 == OP_SELL) A_price_20 = Bid;
      Li_76 = GetTickCount();
      if (ECN_mode == FALSE) ticket_68 = OrderSend(A_symbol_0, A_cmd_8, A_lots_12, A_price_20, A_slippage_28, A_price_32, A_price_40, A_comment_48, A_magic_56, A_datetime_60, A_color_64);
      else {
         ticket_68 = OrderSend(A_symbol_0, A_cmd_8, A_lots_12, A_price_20, A_slippage_28, 0, 0, A_comment_48, A_magic_56, A_datetime_60, A_color_64);
         if (OrderSelect(ticket_68, SELECT_BY_TICKET)) {
            for (int Li_80 = 1; Li_80 <= RetryCount; Li_80++) {
               if (OrderModify(ticket_68, OrderOpenPrice(), A_price_32, A_price_40, A_datetime_60, A_color_64)) break;
               Sleep(RetryTime);
            }
         }
      }
      Gi_196 = GetTickCount() - Li_76;
      if (OrderSelect(ticket_68, SELECT_BY_TICKET)) break;
      Sleep(RetryTime);
      Print("Order Open Error: ", GetLastError());
   }
   return (ticket_68);
}
