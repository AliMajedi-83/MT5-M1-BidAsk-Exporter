# MetaTrader 5 M1 Candle & Bid/Ask Data Exporter

A clean, lightweight MQL5 Expert Advisor designed to run in the MetaTrader 5 **Strategy Tester** and export every completed 1-minute (M1) candle to a CSV file. Along with standard OHLC and Spread data, it captures the **last Bid and Ask price** of each closed candle.

---

## 🌟 Features

- **Accurate Last Tick Data:** Captures the exact `Bid` and `Ask` prices from the final tick before the candle closes.
- **Full OHLC + Spread:** Exports `DateTime`, `Open`, `High`, `Low`, `Close`, `Bid`, `Ask`, and `Spread`.
- **Strategy Tester Ready:** Optimized to extract historical tick/candle data during backtesting.
- **Automated ISO-style Formatting:** Formats dates (`YYYY-MM-DD HH:MM`) for smooth parsing in Python (Pandas), Excel, or R.
- **Flexible Storage:** Option to save files directly in the shared MetaTrader `Common/Files` directory or the default tester files folder.

---

## 📂 CSV Output Format

The generated CSV file will have the following structure:

```csv
DateTime,Open,High,Low,Close,Bid,Ask,Spread
2023-10-25 10:00,1.05820,1.05850,1.05810,1.05840,1.05839,1.05841,2
```

---

## ⚙️ EA Inputs & Configuration

| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `Output_File` | `"Candles1Min_BidAsk.csv"` | Name of the output CSV file |
| `Use_Common_Folder` | `true` | `true` saves file to `Terminal/Common/Files`, `false` saves to local tester folder |

---

## 🚀 Installation & Usage

1. **Download / Copy:** Place `CandleMining.mq5` into your MetaTrader 5 directory:
   `MQL5/Experts/`
2. **Compile:** Open **MetaEditor** (F4 in MT5), open `CandleMining.mq5`, and click **Compile** (F7).
3. **Run in Strategy Tester:**
   - Open Strategy Tester (`Ctrl + R`) in MT5.
   - Select `CandleMining.ex5` as the Expert.
   - Select your desired symbol (e.g., `EURUSD`) and date range.
   - Set Modeling Mode to **Every Tick** or **Every Tick based on real ticks** (recommended for exact Bid/Ask precision).
   - Start the test.

---

## 📄 Finding your CSV File

If `Use_Common_Folder` is set to `true` (default):
- Open MT5 $\rightarrow$ **File** $\rightarrow$ **Open Data Folder**.
- Navigate up one directory level to `Terminal/Common/Files/`.
- Your `Candles1Min_BidAsk.csv` file will be located there.

---
