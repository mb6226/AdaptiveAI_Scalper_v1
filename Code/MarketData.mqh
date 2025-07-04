//+------------------------------------------------------------------+
//| MarketData.mqh                                                   |
//| Handles indicators and market data reading                        |
//+------------------------------------------------------------------+

#ifndef __MARKETDATA_MQH__
#define __MARKETDATA_MQH__

class MarketData
{
private:
    int rsiHandle;
    int atrHandle;
    int bbHandle;
    string symbol;
    int atrPeriod, rsiPeriod, emaSlow, emaFast;

    // Helper: get indicator value from handle
    bool GetBufferValue(int handle, int bufferNum, double &value)
    {
        double buf[1];
        if(CopyBuffer(handle, bufferNum, 0, 1, buf) > 0)
        {
            value = buf[0];
            return true;
        }
        return false;
    }

public:
    MarketData() {}

    void Setup(string _symbol, int _atrPeriod, int _rsiPeriod, int _emaSlow, int _emaFast)
    {
        symbol = _symbol;
        atrPeriod = _atrPeriod;
        rsiPeriod = _rsiPeriod;
        emaSlow = _emaSlow;
        emaFast = _emaFast;
        rsiHandle = iRSI(symbol, PERIOD_M5, rsiPeriod, PRICE_CLOSE);
        atrHandle = iATR(symbol, PERIOD_M5, atrPeriod);
        bbHandle = iBands(symbol, PERIOD_M5, 20, 2, 0, PRICE_CLOSE);
    }

    double GetRSI()
    {
        double val = 0;
        if(GetBufferValue(rsiHandle, 0, val))
            return val;
        return -1;
    }

    double GetATR()
    {
        double val = 0;
        if(GetBufferValue(atrHandle, 0, val))
            return val;
        return -1;
    }

    double GetBBLower()
    {
        double val = 0;
        if(GetBufferValue(bbHandle, 2, val))
            return val;
        return -1;
    }

    double GetBBUpper()
    {
        double val = 0;
        if(GetBufferValue(bbHandle, 1, val))
            return val;
        return -1;
    }

    double GetEMA(int period, ENUM_TIMEFRAMES tf = PERIOD_M5)
    {
        int handle = iMA(symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE);
        if(handle == INVALID_HANDLE)
            return -1;
        double val[1];
        if(CopyBuffer(handle, 0, 0, 1, val) > 0)
        {
            IndicatorRelease(handle);
            return val[0];
        }
        IndicatorRelease(handle);
        return -1;
    }

    double GetSpread()
    {
        return SymbolInfoInteger(symbol, SYMBOL_SPREAD);
    }

    int CalculateBuyScore(int scoreRSI, int scoreEMA, int scoreBB, int scoreEMA_HTF, int scoreSpread, int scoreEMAClose,
                          double rsiOversold, int emaSlow, int emaFast, double spreadLimit)
    {
        int score = 0;
        double rsi = GetRSI();
        if(rsi >= 0 && rsi < rsiOversold + 5)
            score += scoreRSI;

        double emaFastVal = GetEMA(emaFast);
        double emaSlowVal = GetEMA(emaSlow);
        if(emaFastVal > emaSlowVal)
            score += scoreEMA;

        double bbLower = GetBBLower();
        double closePrice = SymbolInfoDouble(symbol, SYMBOL_BID);
        if(closePrice < bbLower)
            score += scoreBB;

        double emaFastHTF = GetEMA(emaFast, PERIOD_M15);
        double emaSlowHTF = GetEMA(emaSlow, PERIOD_M15);
        if(emaFastHTF > emaSlowHTF)
            score += scoreEMA_HTF;

        double spread = GetSpread();
        if(spread < spreadLimit)
            score += scoreSpread;

        if(MathAbs(emaFastVal - emaSlowVal) < _Point * 20)
            score += scoreEMAClose;

        return score;
    }

    int CalculateSellScore(int scoreRSI, int scoreEMA, int scoreBB, int scoreEMA_HTF, int scoreSpread, int scoreEMAClose,
                           double rsiOverbought, int emaSlow, int emaFast, double spreadLimit)
    {
        int score = 0;
        double rsi = GetRSI();
        if(rsi >= 0 && rsi > rsiOverbought - 5)
            score += scoreRSI;

        double emaFastVal = GetEMA(emaFast);
        double emaSlowVal = GetEMA(emaSlow);
        if(emaFastVal < emaSlowVal)
            score += scoreEMA;

        double bbUpper = GetBBUpper();
        double closePrice = SymbolInfoDouble(symbol, SYMBOL_ASK);
        if(closePrice > bbUpper)
            score += scoreBB;

        double emaFastHTF = GetEMA(emaFast, PERIOD_M15);
        double emaSlowHTF = GetEMA(emaSlow, PERIOD_M15);
        if(emaFastHTF < emaSlowHTF)
            score += scoreEMA_HTF;

        double spread = GetSpread();
        if(spread < spreadLimit)
            score += scoreSpread;

        if(MathAbs(emaFastVal - emaSlowVal) < _Point * 20)
            score += scoreEMAClose;

        return score;
    }
};

#endif // __MARKETDATA_MQH__

