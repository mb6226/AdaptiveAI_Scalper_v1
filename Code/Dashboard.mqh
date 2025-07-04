//+------------------------------------------------------------------+
//| Dashboard.mqh                                                    |
//| Displays real-time info about strategy on the chart             |
//+------------------------------------------------------------------+

#ifndef __DASHBOARD_MQH__
#define __DASHBOARD_MQH__

class Dashboard
{
private:
    string name;
    int xPos;
    int yPos;
    int fontSize;
    color textColor;

public:
    Dashboard()
    {
        name = "AdaptiveAIScalperDashboard";
        xPos = 10;
        yPos = 20;
        fontSize = 11;
        textColor = clrWhite;
    }

    void SetPosition(int x, int y)
    {
        xPos = x;
        yPos = y;
    }

    void SetFontSize(int size)
    {
        fontSize = size;
    }

    void SetTextColor(color clr)
    {
        textColor = clr;
    }

    void Show(string text)
    {
        if(ObjectFind(0, name) == -1)
            ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);

        ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, name, OBJPROP_XDISTANCE, xPos);
        ObjectSetInteger(0, name, OBJPROP_YDISTANCE, yPos);
        ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
        ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

        ObjectSetString(0, name, OBJPROP_TEXT, text);
        ChartRedraw(0);
    }

    void Remove()
    {
        if(ObjectFind(0, name) != -1)
            ObjectDelete(0, name);
    }
};

#endif

