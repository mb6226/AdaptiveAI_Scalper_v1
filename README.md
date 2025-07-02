# AdaptiveAI_Scalper_v1

## Project Overview  
AdaptiveAI_Scalper_v1 is an advanced trading EA designed to smartly scalp markets by combining rule-based scoring logic with AI-driven signals. This project aims to optimize, modularize, and enhance the scalping strategy with machine learning integration step-by-step.

---

## Development Plan

### 1️⃣ Step 1: Optimize and Test Current EA  
- Run the EA with all designed modules (scoring system, adaptive SL/TP, trailing stop, break-even, time and news filters, cooldown, etc.)  
- Perform precise backtests on real data and demo account tests  
- Review dashboard outputs, signals, and risk management  
- Apply fixes and improvements  

### 2️⃣ Step 2: Data Collection and Storage  
- Save price data, indicators, and EA signals (e.g., in CSV files) every tick  
- Store trade results (entries, exits, profit/loss) for precise AI training  
- Prepare datasets for model training  

### 3️⃣ Step 3: Train Machine Learning Model Outside MT5  
- Analyze collected data and train simple ML models (regression, decision trees, neural nets)  
- Evaluate model accuracy on new data  
- Output signals or entry probabilities  

### 4️⃣ Step 4: Design Signal File Format for EA Input  
- Create CSV or JSON files containing timestamp, signal type, and signal strength  
- Develop EA code to read and update signals from these files  

### 5️⃣ Step 5: Integrate ML Logic with EA Scoring System  
- Combine ML model signals with rule-based scoring  
- Weight or condition entry based on combined score  
- Test and optimize decision logic  

### 6️⃣ Step 6: Real-Time Connection of EA to ML Model (Optional, Advanced)  
- Link EA to Python or ML service via DLL or API  
- Receive live signals and respond quickly  
- Ensure security and performance  

### 7️⃣ Step 7: Continuous Improvement and Expansion  
- Add more filters (news, volume, candlestick patterns)  
- Implement online learning  
- Enhance risk management and automated reporting  

---

## Getting Started

- Clone this repository  
- Review modularized code in each folder/module  
- Run tests starting from `MarketData` module to ensure data accuracy  
- Follow development plan step-by-step  

---

## Contact

For questions or contributions, please open an issue or contact the maintainer.
