# Logistic Regression: Customer Churn Prediction

A classification model predicting whether a customer will churn, using scikit-learn.

## Problem

Can we predict which customers are at risk of churning (`churned` = 1) based on their demographics, account type, and usage behavior? A reliable model would let a business proactively target at-risk customers with retention offers.

## Data

1,000 customers, 15 features including demographics (age, gender), account info (account type, tenure), usage (total purchases, avg. purchase value, website visits, email open rate), and satisfaction (customer service calls, satisfaction score). Target: `churned` (751 retained / 249 churned — roughly 75/25 split).

## Approach

- One-hot encoded categorical variables (`gender`, `account_type`)
- Split data 80/20 with stratification to preserve the churn ratio in both sets
- Trained a `LogisticRegression` model and evaluated with accuracy, AUC, and ROC curve
- Interpreted the model's coefficients to identify the most influential features

## Results

- **Accuracy: 75.0%** — but this exactly matches the baseline rate of non-churned customers (751/1000), meaning it isn't clear the model learned anything beyond predicting the majority class.
- **AUC: 0.522** — barely above 0.5 (random guessing), confirming the model has very limited real predictive power.

## Key Finding (and a caveat)

The two largest coefficients were `account_type_Premium` (-0.281, lower churn risk) and `gender_Male` (+0.266, higher churn risk). However, given the AUC of 0.522, these coefficients should be treated with caution rather than as reliable business signals — the available features (demographics, account type) may simply not be strong predictors of churn on their own. Engagement-based features not included among the top predictors here (e.g., `customer_service_calls`, `satisfaction_score`, `days_since_last_purchase`) would be worth testing in a follow-up model.

## Tools

pandas, scikit-learn (LogisticRegression, train_test_split, ROC/AUC metrics), matplotlib

See [`logistic_regression_analysis.ipynb`](./logistic_regression_analysis.ipynb) for the full analysis.
