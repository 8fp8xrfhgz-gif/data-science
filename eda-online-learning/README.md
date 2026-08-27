# EDA: Online Learning Platform

Exploratory data analysis on a 500-student dataset from an online learning platform, examining what factors are associated with student performance.

## Problem

An online learning platform wants to understand what drives student performance — do study hours, subscription tier, or education level actually predict how well students do on their final exam?

## Data

500 students, 15 features covering demographics (age, gender, education level, country), engagement (hours studied per week, videos watched, quizzes completed, forum posts), and outcomes (assignment score, final exam score, course completion).

## Approach

- Cleaned missing values with different strategies depending on what the missingness meant: median imputation for `age` (likely random), zero-fill for `forum_posts` (likely means "never posted"), and row removal for `final_exam_score` (can't be estimated — it's the target of interest)
- Explored relationships between engagement/demographic variables and exam performance using correlation analysis, groupby comparisons, and visualizations (histograms, scatter plots, box plots)

## Key Findings

- **Study hours barely mattered.** Correlation between `hours_per_week` and `final_exam_score` was only 0.18 — students studying 1-2 hrs/week scored anywhere from 40 to 100, same range as students studying 15+ hrs/week.
- **Subscription tier had only a modest effect.** Premium averaged 74.2, Basic 71.8, Free 70.9 — about a 3-point gap. Free-tier students also had the widest score spread (std = 18.1) and the lowest minimum score (18.8).
- **Education level was a weak predictor**, with a surprising twist: High School students (72.9) actually outscored Bachelor's degree holders (71.6). Master's scored highest overall (73.8).

## Recommendation

Since Free-tier students showed the widest score spread and included the lowest scorers, the platform should prioritize support for this group specifically (e.g., flagging low quiz-completion Free users early) rather than assuming all students need the same level of intervention.

## Tools

pandas, seaborn, matplotlib

See [`eda_analysis.ipynb`](./eda_analysis.ipynb) for the full analysis.
