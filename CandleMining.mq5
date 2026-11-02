//+------------------------------------------------------------------+
//|                                       Candles_BidAsk_Export.mq5  |
//|  Strategy Tester EA: saves every closed M1 candle with Bid/Ask   |
//+------------------------------------------------------------------+
#property copyright "M1 Bid/Ask exporter"
#property version   "1.00"
#property description "Saves each closed M1 candle (OHLC + Bid + Ask + Spread) to a CSV file."
#property description "Run it in the Strategy Tester. Bid/Ask = last tick of the candle."

input string Output_File       = "Candles1Min_BidAsk.csv"; // output file name
input bool   Use_Common_Folder = true;                     // true -> Terminal/Common/Files

int      g_fh      = INVALID_HANDLE;
datetime g_curBar  = 0;       // open time of the candle currently forming
double   g_lastBid = 0.0;     // bid of the previous tick
double   g_lastAsk = 0.0;     // ask of the previous tick
long     g_count   = 0;

//+------------------------------------------------------------------+
int OnInit()
  {
   int flags=FILE_WRITE|FILE_CSV|FILE_ANSI;
   if(Use_Common_Folder)
      flags|=FILE_COMMON;

   g_fh=FileOpen(Output_File,flags,',');
   if(g_fh==INVALID_HANDLE)
     {
      PrintFormat("Cannot create '%s' (error %d)",Output_File,GetLastError());
      return INIT_FAILED;
     }
   FileWrite(g_fh,"DateTime","Open","High","Low","Close","Bid","Ask","Spread");
   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
void WriteClosedCandle()
  {
   MqlRates r[];
   if(CopyRates(_Symbol,PERIOD_M1,1,1,r)!=1)   // index 1 = the candle that just closed
      return;

   string ts=TimeToString(r[0].time,TIME_DATE|TIME_MINUTES);
   StringReplace(ts,".","-");

   FileWrite(g_fh,
             ts,
             DoubleToString(r[0].open, _Digits),
             DoubleToString(r[0].high, _Digits),
             DoubleToString(r[0].low,  _Digits),
             DoubleToString(r[0].close,_Digits),
             DoubleToString(g_lastBid, _Digits),
             DoubleToString(g_lastAsk, _Digits),
             r[0].spread);

   g_count++;
   if((g_count%1000)==0)
      FileFlush(g_fh);
  }
//+------------------------------------------------------------------+
void OnTick()
  {
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return;

   datetime bar=iTime(_Symbol,PERIOD_M1,0);
   if(bar==0)
      return;

   if(g_curBar==0)
      g_curBar=bar;                       // first tick of the test
   else
      if(bar!=g_curBar)                   // a new M1 candle just started
        {
         WriteClosedCandle();             // g_lastBid/g_lastAsk still hold the previous candle's last tick
         g_curBar=bar;
        }

   g_lastBid=tick.bid;
   g_lastAsk=tick.ask;
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(g_fh!=INVALID_HANDLE)
     {
      FileClose(g_fh);
      g_fh=INVALID_HANDLE;
     }
   PrintFormat("Done. %I64d candles written to %s",g_count,Output_File);
  }
//+------------------------------------------------------------------+
