//+------------------------------------------------------------------+
//| Expert Advisor: Adaptive AI-Driven Scalper v1                   |
//| Description: Modular EA with rule-based logic and dashboard     |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include "MarketData.mqh"
#include "TradeManager.mqh"
#include "Dashboard.mqh"
#include "RiskManager.mqh"
#include "SignalAnalyzer.mqh"

#property strict

input double Lots = 0.1;
input bool UseAutoLot = true;
input double RiskPercent = 20.0;
input int Slippage = 3;
input double ATR_SL_Multiplier = 2.0;
input double ATR_TP_Multiplier = 15.0;
input int MagicNumber = 123456;
input int ATR_Period = 14;
input int RSI_Period = 14;
input double RSI_Overbought = 60;
input double RSI_Oversold = 40;
input int EMASlow = 50;
input int EMAFast = 20;
input double SpreadLimit = 20;
input bool UseTrailingStop = true;
input double TrailingStart = 30;
input double TrailingStep = 10;
input bool UseBreakEven = true;
input double BreakEvenTrigger = 30;
input double BreakEvenOffset = 2;
input int TradeStartHour = 8;
input int TradeEndHour = 18;
input bool EnableEquityGuard = true;
input double EquityStopPercent = 70;
input int CooldownMinutes = 15;

// Scores for indicators
input int Score_RSI = 35;
input int Score_EMA = 50;
input int Score_BB = 15;
input int Score_EMA_HTF = 10;
input int Score_Spread = 10;
input int Score_EMA_Close = -10;

CTrade trade;
MarketData market;
TradeManager manager(_Symbol, MagicNumber, Slippage, ATR_SL_Multiplier, ATR_TP_Multiplier,
                     UseTrailingStop, TrailingStart, TrailingStep, UseBreakEven,
                     BreakEvenTrigger, BreakEvenOffset);
Dashboard dash;

datetime lastTradeTime = 0;
double initialEquity;
bool canTrade = false;
string currentSignal = "None";

datetime NewsTimes[] = { D'2025.07.01 14:30', D'2025.07.02 09:00' };
int MinutesToAvoid = 30;

//+------------------------------------------------------------------+
int OnInit()
{
    initialEquity = AccountInfoDouble(ACCOUNT_EQUITY);

    market.Setup(_Symbol, ATR_Period, RSI_Period, EMASlow, EMAFast);
    manager.Configure(ATR_SL_Multiplier, ATR_TP_Multiplier, Slippage, MagicNumber,
                      UseAutoLot, Lots, RiskPercent, UseTrailingStop,
                      TrailingStart, TrailingStep, UseBreakEven, BreakEvenTrigger, BreakEvenOffset);

    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnTick()
{
    if(!IsTradingHour() || IsNewsTime() || IsEquityTooLow())
        return;

    manager.ManageOpenPosition();

    if(PositionSelect(_Symbol) || TimeCurrent() - lastTradeTime < CooldownMinutes * 60)
        return;

    int buyScore = market.CalculateBuyScore(Score_RSI, Score_EMA, Score_BB,
                                            Score_EMA_HTF, Score_Spread, Score_EMA_Close,
                                            RSI_Oversold, EMASlow, EMAFast, SpreadLimit);
    int sellScore = market.CalculateSellScore(Score_RSI, Score_EMA, Score_BB,
                                              Score_EMA_HTF, Score_Spread, Score_EMA_Close,
                                              RSI_Overbought, EMASlow, EMAFast, SpreadLimit);

    int signal = 0;
    if(buyScore >= 60 && buyScore > sellScore)
        signal = 1;
    else if(sellScore >= 60 && sellScore > buyScore)
        signal = -1;

    if(signal != 0)
    {
        currentSignal = (signal == 1 ? "BUY" : "SELL");
        if(manager.OpenTrade(signal, Lots))
            lastTradeTime = TimeCurrent();
    }
    else
    {
        currentSignal = "None";
    }

    ShowDashboard(buyScore, sellScore);
}

//+------------------------------------------------------------------+
bool IsTradingHour()
{
    MqlDateTime tm;
    TimeToStruct(TimeCurrent(), tm);
    int hour = tm.hour;
    canTrade = (hour >= TradeStartHour && hour < TradeEndHour);
    return canTrade;
}

//+------------------------------------------------------------------+
bool IsEquityTooLow()
{
    double eq = AccountInfoDouble(ACCOUNT_EQUITY);
    return (EnableEquityGuard && eq < (initialEquity * EquityStopPercent / 100.0));
}

//+------------------------------------------------------------------+
bool IsNewsTime()
{
    datetime now = TimeCurrent();
    for(int i = 0; i < ArraySize(NewsTimes); i++)
    {
        if(MathAbs(int(now - NewsTimes[i])) < MinutesToAvoid * 60)
            return true;
    }
    return false;
}

//+------------------------------------------------------------------+
void ShowDashboard(int buyScore, int sellScore)
{
    string text = StringFormat(
        "Adaptive AI Scalper v1\nSignal: %s\nSpread: %d pips\nEquity: %.2f\nBuyScore: %d  SellScore: %d",
        currentSignal,
        (int)(SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) * _Point / 0.0001),
        AccountInfoDouble(ACCOUNT_EQUITY),
        buyScore,
        sellScore
    );

    dash.Show(text);
}

