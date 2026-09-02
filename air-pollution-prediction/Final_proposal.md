# Final Project Proposal
** Predicting Air Pollution Levels Using EPA Monitoring Data **

---

## 1. Domain Background

Air pollution is a major public health issue — long-term exposure to pollutants like NO2, O3, SO2, and CO is linked to respiratory and cardiovascular disease. The EPA runs a national network of monitoring stations, but coverage is limited, so predictive models can help estimate pollution levels in areas or times with less direct measurement.

I have a background in Geography (GIS), so I'm especially interested in how location affects pollution patterns, not just weather or time. This connects to Land Use Regression (LUR), a method from environmental geography that predicts pollution using spatial/land-use features. I want to bring that perspective into this project.

## 2. Problem Statement

Can we predict the **NO2 Air Quality Index ** of a monitoring site on a given day, using the site's location and readings from other pollutants (O3, SO2, CO)? This is a well-defined regression problem: the target is continuous, measured consistently, and there's historical labeled data to train on.

## 3. Solution Statement

I'll build a **regression model** to predict NO2 AQI, starting with **Linear Regression** as a baseline, then comparing it to a **Random Forest Regressor** to see if it captures non-linear relationships better. I also want to test whether *location* (state/city) meaningfully improves predictions, beyond just using the other pollutant readings.

## 4. Datasets and Inputs

**Source:** [U.S. Pollution Data (2000–2016)](https://www.kaggle.com/datasets/sogun3/uspollution) — Kaggle, compiled from EPA Air Quality System data.

**Original size:** ~1.75 million rows, 29 columns, covering all 50 states from 2000–2016.

The raw file is too large and has duplicate rows per site/day (same site-date split across different measurement hours), so I'll filter it down to a handful of states and a shorter date range, then deduplicate. I expect to end up with roughly 50,000–100,000 clean rows, well above the 10,000-row minimum.

**Key features:** `State`, `City`, `O3 Mean`/`O3 AQI`, `SO2 Mean`/`SO2 AQI`, `CO Mean`/`CO AQI`, `Date Local` (for possible month/season features).

**Target variable:** `NO2 AQI` — chosen because it has no missing values in the raw data, unlike SO2/CO AQI which are missing for roughly half of all rows.

## 5. Evaluation Metrics

- **R²** — how much of the variation in NO2 AQI the model explains
- **RMSE** — typical prediction error in AQI units, penalizing large misses more
- **MAE** — average prediction error, easier to interpret directly

I'll compare these between Linear Regression and Random Forest on the test set to see which generalizes better.

## 6. Project Design

**EDA:** Look at the distribution of NO2 AQI, check correlations with the other pollutants, and compare pollution levels across states.

**Preprocessing:** Handle remaining missing values, one-hot encode categorical variables (State, City), and possibly engineer a month/season feature from the date.

**Algorithms to compare:** Linear Regression  vs. Random Forest Regressor.

**Validation:** 80/20 train-test split, comparing R²/RMSE/MAE on the test set to avoid overfitting, and checking residual plots for any obvious patterns.