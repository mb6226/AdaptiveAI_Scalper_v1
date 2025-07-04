# AdaptiveAI Scalper v1 - Source Code

This directory contains the complete source code for the AdaptiveAI Scalper v1 Expert Advisor, built with a modular architecture for MetaTrader 5.

## File Structure

```
Code/
├── README.md                    # This documentation file
├── AdaptiveAI_Scalper_v1.mq5   # Main Expert Advisor file
├── Dashboard.mqh                # Chart dashboard display module
├── MarketData.mqh               # Market data and indicators module
├── RiskManager.mqh              # Risk management and controls
├── SignalAnalyzer.mqh           # Signal analysis and scoring
└── TradeManager.mqh             # Trade execution and management
```

## Main Expert Advisor

### AdaptiveAI_Scalper_v1.mq5
**Purpose:** Main EA file that orchestrates all modules

**Key Features:**
- 25+ configurable input parameters
- Modular architecture with clean separation of concerns
- Real-time signal scoring system
- Advanced risk management integration
- Professional dashboard display

**Core Logic:**
- Signal analysis using multiple indicators (RSI, EMA, Bollinger Bands)
- Multi-timeframe analysis (M5 primary, M15 higher timeframe)
- Scoring-based trade decision system (60+ score threshold)
- Automated trade management with trailing stops and breakeven

## Module Documentation

### Dashboard.mqh
**Purpose:** Real-time chart information display

**Features:**
- Live signal status display
- Current spread monitoring
- Account equity tracking
- Buy/Sell score visualization
- Customizable position and styling

**Methods:**
- `SetPosition(x, y)` - Set dashboard position
- `SetFontSize(size)` - Configure font size
- `SetTextColor(color)` - Set text color
- `Show(text)` - Display information
- `Remove()` - Clean up dashboard

### MarketData.mqh
**Purpose:** Technical indicator calculations and market data

**Indicators Supported:**
- **RSI:** Relative Strength Index (14 period default)
- **ATR:** Average True Range for volatility
- **Bollinger Bands:** 20 period, 2 deviation
- **EMA:** Exponential Moving Averages (Fast/Slow)
- **Spread:** Real-time spread monitoring

**Scoring Methods:**
- `CalculateBuyScore()` - Analyze bullish conditions
- `CalculateSellScore()` - Analyze bearish conditions
- Multi-factor scoring system with configurable weights

### RiskManager.mqh
**Purpose:** Comprehensive risk control system

**Risk Controls:**
- **Trading Hours:** Configurable start/end times (8 AM - 6 PM default)
- **News Filter:** Avoid trading during news events (30 min buffer)
- **Equity Guard:** Stop trading if equity drops below threshold (70% default)
- **Spread Limits:** Maximum spread filtering

**Methods:**
- `IsTradingHour()` - Check if within trading hours
- `IsNewsTime()` - Detect news event proximity
- `IsEquityOk()` - Validate account equity levels

### SignalAnalyzer.mqh
**Purpose:** Advanced signal analysis and scoring

**Signal Components:**
- **RSI Analysis:** Overbought/Oversold detection with buffers
- **EMA Crossover:** Fast/Slow EMA relationship analysis
- **Bollinger Bands:** Price position relative to bands
- **Multi-Timeframe:** M5 and M15 timeframe confirmation
- **Spread Quality:** Trade execution cost analysis
- **EMA Convergence:** Price consolidation detection

**Scoring System:**
- Configurable weights for each indicator
- Positive scores for favorable conditions
- Negative scores for unfavorable conditions
- Threshold-based trade triggers (60+ score)

### TradeManager.mqh
**Purpose:** Complete trade lifecycle management

**Trade Execution:**
- **ATR-Based SL/TP:** Dynamic stop loss and take profit calculation
- **Order Validation:** Proper stop level and spread checking
- **Magic Number:** Trade identification and management
- **Slippage Control:** Maximum acceptable slippage

**Advanced Features:**
- **Trailing Stop:** Profit protection with configurable parameters
- **Breakeven:** Automatic breakeven when profit targets met
- **Position Management:** Real-time trade monitoring
- **Error Handling:** Comprehensive trade error management

## Configuration Parameters

### Risk Management
- `Lots` - Fixed lot size (0.1 default)
- `UseAutoLot` - Enable automatic lot sizing
- `RiskPercent` - Risk percentage per trade (20% default)
- `EquityStopPercent` - Equity protection threshold (70% default)

### Technical Analysis
- `RSI_Period` - RSI calculation period (14 default)
- `RSI_Overbought/Oversold` - RSI signal thresholds (60/40 default)
- `EMASlow/EMAFast` - EMA periods (50/20 default)
- `ATR_Period` - ATR calculation period (14 default)

### Trade Management
- `ATR_SL_Multiplier` - Stop loss distance (2.0x ATR default)
- `ATR_TP_Multiplier` - Take profit distance (15.0x ATR default)
- `UseTrailingStop` - Enable trailing stop functionality
- `TrailingStart/Step` - Trailing stop parameters (30/10 pips default)

### Signal Scoring
- `Score_RSI` - RSI indicator weight (35 default)
- `Score_EMA` - EMA crossover weight (50 default)
- `Score_BB` - Bollinger Bands weight (15 default)
- `Score_EMA_HTF` - Higher timeframe weight (10 default)
- `Score_Spread` - Spread quality weight (10 default)
- `Score_EMA_Close` - EMA convergence weight (-10 default)

## Usage Instructions

1. **Installation:**
   - Copy all .mqh files to the same directory as the .mq5 file
   - Compile AdaptiveAI_Scalper_v1.mq5 in MetaEditor
   - Load the EA on desired chart (M5 timeframe recommended)

2. **Configuration:**
   - Use provided .set file for optimized parameters
   - Adjust risk parameters based on account size
   - Configure trading hours for your timezone

3. **Monitoring:**
   - Watch dashboard for real-time signal information
   - Monitor equity protection levels
   - Review trade logs for performance analysis

## Development Notes

- **Architecture:** Clean modular design for easy maintenance
- **Error Handling:** Comprehensive error checking and logging
- **Performance:** Optimized for real-time tick processing
- **Scalability:** Easy to add new indicators or risk controls
- **Testing:** Compatible with Strategy Tester optimization

## Version History

- **v1.0:** Initial release with complete modular architecture
- Full signal analysis system implementation
- Advanced risk management integration
- Professional dashboard and monitoring
