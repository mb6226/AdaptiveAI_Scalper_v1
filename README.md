# Adaptive AI-Driven Scalper v1

A modular and adaptive Expert Advisor (EA) designed for smart high-frequency scalping in the Forex market. Built in MQL5 with rule-based logic and future-ready AI integration capabilities.

---

## ✅ Project Goals

- Build a reliable and rule-driven scalping system in MQL5
- Use dynamic scoring logic from RSI, EMA, ATR, and Bollinger Bands
- Implement solid risk control (equity guard, time filters, news filter)
- Enable backtest optimization with tunable input weights
- Prepare base logic for AI-enhanced decision-making

---

## 🧩 Modules Overview

- `MarketData.mqh`: Fetches technical indicators and price data.
- `SignalAnalyzer.mqh`: Calculates buy/sell signal scores.
- `TradeManager.mqh`: Handles trade entry, SL/TP, trailing stop, and breakeven.
- `RiskManager.mqh`: Manages time filters, news avoidance, and equity guard.
- `Dashboard.mqh`: Displays real-time strategy signals and trade stats on chart.

---

## 📂 Project Structure

AdaptiveAI_Scalper_v1/
│
├── Docs/
│ └── project_description.md
│
├── Code/
│ ├── AdaptiveAI_Scalper_v1.mq5
│ ├── MarketData.mqh
│ ├── SignalAnalyzer.mqh
│ ├── TradeManager.mqh
│ ├── RiskManager.mqh
│ └── Dashboard.mqh
│
├── Tests/
│ ├── MarketDataTest.mq5
│ ├── SignalAnalyzerTest.mq5
│ └── TradeManagerTest.mq5

yaml
Copy
Edit

---

## 📊 Backtest Summary (1-Year on EURUSD, M5)

| Metric                     | Result       |
|---------------------------|--------------|
| Total Net Profit          | $54,485.87   |
| Profit Factor             | 1.49         |
| Total Trades              | 5,767        |
| Win Rate (Long/Short)     | 90.8% / 90.2%|
| Max Drawdown              | 3.65%        |
| Expected Payoff           | $9.45        |
| Sharpe Ratio              | 8.67         |

> Backtested from 2024.07.02 to 2025.07.02 using fixed lot (1.0) and optimized scoring inputs.

---

## 🛡 Risk Management Features

- Trailing stop with dynamic logic
- Breakeven after configurable profit trigger
- Time-based trading window
- High-impact news avoidance (manual input for now)
- Equity Guard: stop trading if equity drops below defined % (e.g., 70%)

---

## 🛠 Development Roadmap

- [x] Initial modular design and main EA logic (v1)
- [x] One-year backtest and validation
- [ ] Version 2 with AI-based adaptive scoring
- [ ] Improved chart dashboard UI
- [ ] Enhanced RiskManager with behavioral filters
- [ ] Walk Forward Testing & Monte Carlo simulations
- [ ] Deployment and optimization utilities

---

## 🔮 Planned Features (v2+)

- Dynamic learning model for scoring (via TensorFlow Lite or ONNX)
- Auto-adjusting trade filters based on market regime
- Multi-timeframe signal fusion (M5 + M15 + H1)
- Remote signal monitoring dashboard (e.g., via Flask API or TradingView webhook)

---

## 📖 License

MIT License — open to contributors & researchers.

---

## 👤 Author

**Mahdi Bagheri**  
📧 GitHub: [@mb6226](https://github.com/mb6226)  
🔬 Focus: AI-Driven Trading, Scalping Strategies, MQL5 Automation
