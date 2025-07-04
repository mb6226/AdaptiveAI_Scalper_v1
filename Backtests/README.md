# Backtests

This directory contains backtest results and settings for the AdaptiveAI Scalper v1 Expert Advisor.

## Directory Structure

```
Backtests/
├── README.md                    # This file
├── EURUSD_2024_2025/           # EURUSD backtest results
│   └── Strategy Tester Report.mhtml  # Main backtest report
└── Settings/
    └── AdaptiveAI_Scalper_v1.set     # EA optimization settings
```

## Backtest Results

### EURUSD_2024_2025
- **Period:** 2024-2025
- **Symbol:** EURUSD
- **Timeframe:** M5 (5-minute)
- **Report:** Complete Strategy Tester Report with detailed analysis

## Settings Files

### AdaptiveAI_Scalper_v1.set
- **Purpose:** Parameter optimization settings for MetaTrader 5
- **Format:** Standard MT5 .set file format
- **Usage:** Load in Strategy Tester → Inputs → Load
- **Optimization:** Configured for ATR_TP_Multiplier optimization

## How to Use

1. **Load Settings:**
   - Open MetaTrader 5 Strategy Tester
   - Select AdaptiveAI_Scalper_v1 EA
   - Go to Inputs tab
   - Right-click → Load → Select `AdaptiveAI_Scalper_v1.set`

2. **Run Backtest:**
   - Configure date range and symbol
   - Run single test or optimization
   - Compare results with existing reports

3. **View Results:**
   - Open `Strategy Tester Report.mhtml` in browser
   - Analyze performance metrics and charts

## Notes

- All backtest results are generated with optimized parameters
- Settings file includes optimization ranges for key parameters
- Reports contain detailed trade analysis and performance metrics
