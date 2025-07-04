//+------------------------------------------------------------------+
//| Module: SignalAnalyzer.mqh                                       |
//| Purpose: Calculate buy/sell signal scores based on indicators    |
//+------------------------------------------------------------------+

#ifndef __SIGNALANALYZER_MQH__
#define __SIGNALANALYZER_MQH__

#include <Trade\Trade.mqh>

class SignalAnalyzer
{
private:
    int rsiPeriod;
    double rsiOverbought;
    double rsiOversold;
    int emaFastPeriod;
    int emaSlowPeriod;
    int atrPeriod;
    double spreadLimit;

    int scoreRSI;
    int scoreEMA;
    int scoreBB;
    int scoreEMA_HTF;
    int scoreSpread;
    int scoreEMAClose;

    string symbol;

    int rsiHandle;
    int atrHandle;
    int bbHandle;

public:
    // Constructor: initialize parameters and create indicator handles
    SignalAnalyzer(string symbolName,
                   int rsiPer, double rsiOB, double rsiOS,
                   int emaFast, int emaSlow,
                   int atrPer,
                   double spreadLim,
                   int scoreRsi, int scoreEma, int scoreBb,
                   int scoreEmaHtf, int scoreSpreadScore, int scoreEmaClose);

    ~SignalAnalyzer();

    // Calculate buy signal score
    int CalculateBuyScore();

    // Calculate sell signal score
    int CalculateSellScore();

private:
    // Helper functions to fetch indicator values
    double GetRSI();
    double GetEMA(int period, ENUM_TIMEFRAMES timeframe);
    double GetBBLower();
    double GetBBUpper();
    double GetSpread();

    // Utility to copy indicator buffers safely
    bool CopyBufferSafe(int handle, int bufferNum, double &value);
};

//---------------- Implementation -------------------

SignalAnalyzer::SignalAnalyzer(string symbolName,
                               int rsiPer, double rsiOB, double rsiOS,
                               int emaFast, int emaSlow,
                               int atrPer,
                               double spreadLim,
                               int scoreRsi, int scoreEma, int scoreBb,
                               int scoreEmaHtf, int scoreSpreadScore, int scoreEmaClose)
{
    symbol = symbolName;
    rsiPeriod = rsiPer;
    rsiOverbought = rsiOB;
    rsiOversold = rsiOS;
    emaFastPeriod = emaFast;
    emaSlowPeriod = emaSlow;
    atrPeriod = atrPer;
    spreadLimit = spreadLim;

    scoreRSI = scoreRsi;
    scoreEMA = scoreEma;
    scoreBB = scoreBb;
    scoreEMA_HTF = scoreEmaHtf;
    scoreSpread = scoreSpreadScore;
    scoreEMAClose = scoreEmaClose;

    rsiHandle = iRSI(symbol, PERIOD_M5, rsiPeriod, PRICE_CLOSE);
    atrHandle = iATR(symbol, PERIOD_M5, atrPeriod);
    bbHandle = iBands(symbol, PERIOD_M5, 20, 2, 0, PRICE_CLOSE);
}

SignalAnalyzer::~SignalAnalyzer()
{
    if(rsiHandle != INVALID_HANDLE)
        IndicatorRelease(rsiHandle);
    if(atrHandle != INVALID_HANDLE)
        IndicatorRelease(atrHandle);
    if(bbHandle != INVALID_HANDLE)
        IndicatorRelease(bbHandle);
}

double SignalAnalyzer::GetRSI()
{
    double rsiValue = 0.0;
    if(!CopyBufferSafe(rsiHandle, 0, rsiValue))
        return -1;
    return rsiValue;
}

double SignalAnalyzer::GetEMA(int period, ENUM_TIMEFRAMES timeframe)
{
    int emaHandle = iMA(symbol, timeframe, period, 0, MODE_EMA, PRICE_CLOSE);
    if(emaHandle == INVALID_HANDLE)
        return -1.0;
    double ema[1];
    if(CopyBuffer(emaHandle, 0, 0, 1, ema) < 0)
    {
        IndicatorRelease(emaHandle);
        return -1.0;
    }
    IndicatorRelease(emaHandle);
    return ema[0];
}

double SignalAnalyzer::GetBBLower()
{
    double bbLower = 0.0;
    if(!CopyBufferSafe(bbHandle, 2, bbLower))
        return -1;
    return bbLower;
}

double SignalAnalyzer::GetBBUpper()
{
    double bbUpper = 0.0;
    if(!CopyBufferSafe(bbHandle, 1, bbUpper))
        return -1;
    return bbUpper;
}

double SignalAnalyzer::GetSpread()
{
    return SymbolInfoInteger(symbol, SYMBOL_SPREAD);
}

bool SignalAnalyzer::CopyBufferSafe(int handle, int bufferNum, double &value)
{
    double buffer[1];
    if(CopyBuffer(handle, bufferNum, 0, 1, buffer) > 0)
    {
        value = buffer[0];
        return true;
    }
    return false;
}

int SignalAnalyzer::CalculateBuyScore()
{
    int score = 0;

    double rsi = GetRSI();
    if(rsi >= 0 && rsi < rsiOversold + 5)
        score += scoreRSI;

    double emaFast = GetEMA(emaFastPeriod, PERIOD_M5);
    double emaSlow = GetEMA(emaSlowPeriod, PERIOD_M5);
    if(emaFast > emaSlow)
        score += scoreEMA;

    double bbLower = GetBBLower();
    double closePrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    if(closePrice < bbLower)
        score += scoreBB;

    double emaFastHTF = GetEMA(emaFastPeriod, PERIOD_M15);
    double emaSlowHTF = GetEMA(emaSlowPeriod, PERIOD_M15);
    if(emaFastHTF > emaSlowHTF)
        score += scoreEMA_HTF;

    double spread = GetSpread();
    if(spread < spreadLimit)
        score += scoreSpread;

    if(MathAbs(emaFast - emaSlow) < _Point * 20)
        score += scoreEMAClose;

    return score;
}

int SignalAnalyzer::CalculateSellScore()
{
    int score = 0;

    double rsi = GetRSI();
    if(rsi >= 0 && rsi > rsiOverbought - 5)
        score += scoreRSI;

    double emaFast = GetEMA(emaFastPeriod, PERIOD_M5);
    double emaSlow = GetEMA(emaSlowPeriod, PERIOD_M5);
    if(emaFast < emaSlow)
        score += scoreEMA;

    double bbUpper = GetBBUpper();
    double closePrice = SymbolInfoDouble(symbol, SYMBOL_ASK);
    if(closePrice > bbUpper)
        score += scoreBB;

    double emaFastHTF = GetEMA(emaFastPeriod, PERIOD_M15);
    double emaSlowHTF = GetEMA(emaSlowPeriod, PERIOD_M15);
    if(emaFastHTF < emaSlowHTF)
        score += scoreEMA_HTF;

    double spread = GetSpread();
    if(spread < spreadLimit)
        score += scoreSpread;

    if(MathAbs(emaFast - emaSlow) < _Point * 20)
        score += scoreEMAClose;

    return score;
}

#endif // __SIGNALANALYZER_MQH__

