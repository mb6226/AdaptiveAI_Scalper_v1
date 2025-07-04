# AdaptiveAI Scalper Expert Advisor Setup Guide

This guide provides step-by-step instructions to correctly set up and run the AdaptiveAI Scalper Expert Advisor (EA). Follow these steps carefully to ensure proper functionality.

## Important Note
All `.mq5` and `.mqh` files **must be placed in the same folder**. If these files are scattered across different folders, the EA will not function correctly.

---

## Step 1: Add the EA and Supporting Files to MetaTrader
1. Copy all files from the `Code` folder, including:
   - `AdaptiveAI_Scalper_v1.mq5`
   - All `.mqh` files
2. Open your MetaTrader 5 platform.
3. In the MetaTrader menu, go to **File > Open Data Folder**.
4. Navigate to the `MQL5/Experts/` directory.
5. Paste all copied files into this folder.
6. Restart MetaTrader 5 to load the EA and supporting files.

---

## Step 2: Attach the EA to a Chart
1. Open a chart of the desired currency pair and timeframe in MetaTrader 5.
2. Drag and drop the `AdaptiveAI_Scalper_v1` EA from the **Navigator** window onto the chart.
3. Enable **Algo Trading** by clicking on the `Algo Trading` button in the toolbar.

---

## Step 3: Load the Optimized Settings File
The optimized settings file for the EA, `AdaptiveAI_Scalper_v1.set`, is located in the following path:

```
Backtests/Settings/AdaptiveAI_Scalper_v1.set
```

### How to Load the Settings File:
1. After attaching the EA to the chart, a settings window will appear.
2. Click on the **Load** button in the bottom-right corner of the settings window.
3. Navigate to the `Backtests/Settings` folder where the `.set` file is located.
4. Select the `AdaptiveAI_Scalper_v1.set` file and click **Open**.
5. Click **OK** to apply the settings.

---

## Step 4: Run the EA
1. Ensure that the `Algo Trading` button in the MetaTrader toolbar is enabled.
2. Monitor the EA's performance directly on the chart or through the **Strategy Tester**.

---

## Notes and Recommendations
- Always test the EA in the **Strategy Tester** before running it on a live account.
- Regularly update the `.set` file when new optimizations are available.
- For any issues or questions, please refer to the [GitHub Repository](https://github.com/mb6226/AdaptiveAI_Scalper_v1) or contact the developer.

Happy Trading!