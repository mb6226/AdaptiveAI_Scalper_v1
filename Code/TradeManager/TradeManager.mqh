//+------------------------------------------------------------------+
//| Module: TradeManager.mqh                                         |
//| Purpose: Manage trade entry, exit, stop loss, take profit,       |
//|          trailing stop, and breakeven logic                      |
//+------------------------------------------------------------------+

#ifndef __TRADEMANAGER_MQH__
#define __TRADEMANAGER_MQH__

#include <Trade\Trade.mqh>

class TradeManager
{
private:
    CTrade trade;

    int magicNumber;
    int slippage;
    double atrSLMultiplier;
    double atrTPMultiplier;
    bool useTrailingStop;
    double trailingStart;
    double trailingStep;
    bool useBreakEven;
    double breakEvenTrigger;
    double breakEvenOffset;

    string symbol;

    int atrHandle;

public:
    // Constructor: initialize parameters and indicator handles
    TradeManager(string symbolName,
                 int magicNum,
                 int slip,
                 double atrSLMult,
                 double atrTPMult,
                 bool trailing,
                 double trailStart,
                 double trailStep,
                 bool breakEven,
                 double breakEvenTrig,
                 double breakEvenOffs)
    {
        symbol = symbolName;
        magicNumber = magicNum;
        slippage = slip;
        atrSLMultiplier = atrSLMult;
        atrTPMultiplier = atrTPMult;
        useTrailingStop = trailing;
        trailingStart = trailStart;
        trailingStep = trailStep;
        useBreakEven = breakEven;
        breakEvenTrigger = breakEvenTrig;
        breakEvenOffset = breakEvenOffs;

        atrHandle = iATR(symbol, PERIOD_M5, 14); // ATR period 14 as example
    }

    ~TradeManager();

    // Open a trade (buy or sell)
    bool OpenTrade(int orderType, double lotSize);

    // Manage trailing stop and breakeven for current position
    void ManageTrailingStop();

    void Configure(double atrSLMult, double atrTPMult, int slip, int magicNum,
                   bool autoLot, double lots, double riskPercent,
                   bool trailing, double trailStart, double trailStep,
                   bool breakEven, double breakEvenTrig, double breakEvenOffs)
    {
        atrSLMultiplier = atrSLMult;
        atrTPMultiplier = atrTPMult;
        slippage = slip;
        magicNumber = magicNum;
        useTrailingStop = trailing;
        trailingStart = trailStart;
        trailingStep = trailStep;
        useBreakEven = breakEven;
        breakEvenTrigger = breakEvenTrig;
        breakEvenOffset = breakEvenOffs;
        // mitavanid autoLot, lots, riskPercent ra ham zakhire konid agar lazem ast
    }

    void ManageOpenPosition()
    {
        // Logic baraye trailing stop, break even, ya digar modiriat position-ha
        // Misal:
        // if(useTrailingStop) { ... }
        // if(useBreakEven) { ... }
    }

private:
    // Calculate stop loss and take profit prices based on ATR
    bool CalculateSLTP(int orderType, double &sl, double &tp);

    // Helper to copy ATR value
    double GetATR();
};

//---------------- Implementation -------------------

TradeManager::~TradeManager()
{
    if(atrHandle != INVALID_HANDLE)
        IndicatorRelease(atrHandle);
}

double TradeManager::GetATR()
{
    double atrBuffer[1];
    if(CopyBuffer(atrHandle, 0, 0, 1, atrBuffer) > 0)
        return atrBuffer[0];
    return 0.0;
}

bool TradeManager::CalculateSLTP(int orderType, double &sl, double &tp)
{
    double priceAsk = SymbolInfoDouble(symbol, SYMBOL_ASK);
    double priceBid = SymbolInfoDouble(symbol, SYMBOL_BID);
    double atrValue = GetATR();

    if(atrValue <= 0)
        return false;

    double minStopLevel = SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;
    if(minStopLevel <= 0) minStopLevel = 10 * _Point;

    double stopDist = atrValue * atrSLMultiplier;
    double takeDist = atrValue * atrTPMultiplier;

    if(orderType == ORDER_TYPE_BUY)
    {
        sl = priceAsk - stopDist;
        tp = priceAsk + takeDist;

        if((priceAsk - sl) < minStopLevel)
            sl = priceAsk - minStopLevel;
        if((tp - priceAsk) < minStopLevel)
            tp = priceAsk + minStopLevel;
    }
    else if(orderType == ORDER_TYPE_SELL)
    {
        sl = priceBid + stopDist;
        tp = priceBid - takeDist;

        if((sl - priceBid) < minStopLevel)
            sl = priceBid + minStopLevel;
        if((priceBid - tp) < minStopLevel)
            tp = priceBid - minStopLevel;
    }
    else
        return false;

    return true;
}

bool TradeManager::OpenTrade(int orderType, double lotSize)
{
    trade.SetExpertMagicNumber(magicNumber);
    trade.SetDeviationInPoints(slippage);

    double sl, tp;
    if(!CalculateSLTP(orderType, sl, tp))
        return false;

    bool result = false;
    if(orderType == ORDER_TYPE_BUY)
        result = trade.Buy(lotSize, NULL, sl, tp);
    else if(orderType == ORDER_TYPE_SELL)
        result = trade.Sell(lotSize, NULL, sl, tp);

    if(result)
    {
        Print("Trade opened: ", (orderType == ORDER_TYPE_BUY ? "BUY" : "SELL"), 
              " Lot: ", DoubleToString(lotSize, 2), " SL: ", DoubleToString(sl, 5), " TP: ", DoubleToString(tp, 5));
    }
    else
    {
        Print("Failed to open trade: ", GetLastError());
    }

    return result;
}

void TradeManager::ManageTrailingStop()
{
    if(!useTrailingStop)
        return;

    if(!PositionSelect(symbol))
        return;

    int posType = (int)PositionGetInteger(POSITION_TYPE);
    double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
    double sl = PositionGetDouble(POSITION_SL);
    double tp = PositionGetDouble(POSITION_TP);
    double currentPrice = (posType == POSITION_TYPE_BUY) ? SymbolInfoDouble(symbol, SYMBOL_BID) : SymbolInfoDouble(symbol, SYMBOL_ASK);

    double profitPoints = (posType == POSITION_TYPE_BUY) ? (currentPrice - openPrice) / _Point : (openPrice - currentPrice) / _Point;

    if(profitPoints > trailingStart)
    {
        double newSL = 0;
        if(posType == POSITION_TYPE_BUY)
        {
            newSL = currentPrice - trailingStep * _Point;
            if(newSL > sl)
                trade.PositionModify(symbol, newSL, tp);
        }
        else if(posType == POSITION_TYPE_SELL)
        {
            newSL = currentPrice + trailingStep * _Point;
            if(newSL < sl)
                trade.PositionModify(symbol, newSL, tp);
        }
    }

    // Breakeven logic
    if(useBreakEven && profitPoints > breakEvenTrigger)
    {
        double newSL = openPrice;
        if(posType == POSITION_TYPE_BUY)
            newSL += breakEvenOffset * _Point;
        else if(posType == POSITION_TYPE_SELL)
            newSL -= breakEvenOffset * _Point;

        if((posType == POSITION_TYPE_BUY && sl < newSL) || (posType == POSITION_TYPE_SELL && sl > newSL))
            trade.PositionModify(symbol, newSL, tp);
    }
}

#endif // __TRADEMANAGER_MQH__

