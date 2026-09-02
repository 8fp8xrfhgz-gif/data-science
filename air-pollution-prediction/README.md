# Air Pollution Prediction — NO2 AQI

Final project for UCLA Extension's Data Science Fundamentals program. Predicts NO2 Air Quality Index using other pollutant readings (O3, SO2, CO) and location (state), combining a regression modeling approach with a GIS/geography perspective from my undergraduate background.

## Problem

Can NO2 AQI be predicted from other pollutant readings, and does adding geographic location (state) meaningfully improve the prediction — or is location just noise?

## Data

Sourced from the [U.S. Pollution Data (2000–2016)](https://www.kaggle.com/datasets/sogun3/uspollution) dataset (EPA Air Quality System). Cleaned down from ~1.75M rows to 73,516 rows covering 4 states (California, Texas, New York, Arizona) from 2010–2015, one row per monitoring station per day.

## Approach

- Time-based train/test split (not random) to avoid data leakage between nearby days
- One-hot encoded `State` (not `City`, to avoid too many sparse columns)
- Compared three models: Linear Regression (pollutants only), Linear Regression (+ state), and Random Forest (+ state)
- Residual analysis and feature importance to evaluate where the model succeeds and where it doesn't

## Results

| Model | R² | RMSE | MAE |
|---|---|---|---|
| Linear Regression (pollutants only) | 0.408 | 10.90 | 8.65 |
| Linear Regression (+ state) | 0.462 | 10.39 | 8.21 |
| Random Forest (+ state) | 0.550 | 9.50 | 7.43 |

Adding geography improved R² meaningfully, and the effect was concentrated almost entirely in California rather than being an even effect across all states. Random Forest outperformed linear regression, suggesting the relationship between pollutants isn't purely linear. The model is less reliable at high pollution levels — a limitation discussed in the notebook along with future work.

## Tools

pandas, scikit-learn (LinearRegression, RandomForestRegressor), seaborn, matplotlib

See [`Air_Pollution_Prediction.ipynb`](./Air_Pollution_Prediction.ipynb) for the full analysis, and [`Final_proposal.md`](./Final_proposal.md) for the original project proposal.
