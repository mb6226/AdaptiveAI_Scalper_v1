//+------------------------------------------------------------------+
//| RiskManager.mqh                                                  |
//| Handles risk controls: trading hours, news filter, equity guard|
//+------------------------------------------------------------------+

#ifndef __RISKMANAGER_MQH__
#define __RISKMANAGER_MQH__

#include <Trade\Trade.mqh>

class RiskManager
{
private:
    int tradeStartHour;
    int tradeEndHour;
    bool equityGuardEnabled;
    double equityStopPercent;
    datetime newsTimes[];
    int newsAvoidMinutes;

public:
    RiskManager()
    {
        // Default values
        tradeStartHour = 8;
        tradeEndHour = 21;
        equityGuardEnabled = true;
        equityStopPercent = 70.0;
        newsAvoidMinutes = 30;
        ArrayResize(newsTimes, 0);
    }

    // Setters for configuration
    void SetTradeHours(int startHour, int endHour)
    {
        tradeStartHour = startHour;
        tradeEndHour = endHour;
    }

    void EnableEquityGuard(bool enable, double stopPercent)
    {
        equityGuardEnabled = enable;
        equityStopPercent = stopPercent;
    }

    void SetNewsTimes(datetime &times[], int size)
    {
        ArrayResize(newsTimes, size);
        for(int i=0; i<size; i++)
            newsTimes[i] = times[i];
    }

    void SetNewsAvoidMinutes(int minutes)
    {
        newsAvoidMinutes = minutes;
    }

    // Check if current time is within trading hours
    bool IsTradingHour()
    {
        MqlDateTime tm;
        TimeToStruct(TimeCurrent(), tm);
        int hour = tm.hour;
        return (hour >= tradeStartHour && hour < tradeEndHour);
    }

    // Check if current time is near any news event
    bool IsNewsTime()
    {
        datetime now = TimeCurrent();
        for(int i=0; i<ArraySize(newsTimes); i++)
        {
            if(MathAbs(int(now - newsTimes[i])) < newsAvoidMinutes * 60)
                return true;
        }
        return false;
    }

    // Check if equity is above stop threshold
    bool IsEquityOk(double initialEquity)
    {
        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
        if(!equityGuardEnabled) return true;
        return (currentEquity >= initialEquity * equityStopPercent / 100.0);
    }
};

#endif

