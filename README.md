# 🏦 SA Bank Customer Churn Analysis
**Portfolio Project | SQL · MySQL · Data Analysis**

---

## 📌 Overview

This project analyses a synthetic dataset of **15,000 South African retail banking customers** to identify the strongest predictors of customer churn. Using MySQL, the analysis progresses from data quality checks through demographic segmentation into financial and behavioural drivers, concluding with a composite multi-factor risk scoring model.

---

## 🗂️ Dataset

| Detail | Info |
|---|---|
| **File** | `sa_bank_churn_15000.csv` |
| **Rows** | 15,000 customers |
| **Columns** | 15 features |
| **Source** | Synthetic data generated with Python (pandas / numpy) |
| **Churn logic** | Based on employment status, credit score, account balance, product count, and tenure |

### Columns

`CustomerID` · `Age` · `Gender` · `Province` · `Bank` · `Product` · `EmploymentStatus` · `EducationLevel` · `TenureYears` · `NumProducts` · `HasCreditCard` · `AccountBalance` · `EstimatedSalary` · `CreditScore` · `Churn`

---

## 🔍 Analysis Structure

### ✅ Data Quality
- NULL checks across all 15 columns
- Duplicate CustomerID detection

### 📊 Queries

| # | Query | Focus |
|---|---|---|
| 1 | Overall Churn Rate | Baseline churn metric |
| 2 | Churn by Province & Gender | Geographic and demographic segmentation |
| 3 | Churn by Employment Status | Income stability as a churn driver |
| 4 | Churn by Age Band | Under 30 / 30–45 / 46–60 / Over 60 |
| 5 | Churn by Credit Score Band | Poor / Fair / Good / Excellent |
| 6 | Churn by Tenure & Product Count | Loyalty and engagement cross-analysis |
| 7 | Churn by Account Balance Tier | Low / Medium / High / Very High (ZAR) |
| 8 | Multi-Factor Risk Score (CTE) | Composite 5-factor churn risk model |

---

## 🔑 Key Finding

A composite **5-factor risk score** reveals a near-perfect relationship with churn:

| Risk Segment | Churn Rate |
|---|---|
| No Risk Factors (0) | 0% |
| Low Risk (1–2 factors) | Low |
| High Risk (3–4 factors) | High |
| Critical Risk (5 factors) | 100% |

The five risk factors are:
1. Unemployed
2. Credit score below 500
3. Account balance below R10,000
4. Only 1 product held
5. Tenure less than 2 years

---

## ⚠️ Data Limitations

> **Bank-level comparisons were intentionally excluded.** The `Bank` column was randomly assigned during data generation and has no underlying relationship with churn. Any apparent differences between banks are statistical noise and should not be interpreted as real performance differences.

---

## 🛠️ Tools Used

- **MySQL** — database creation, querying, and CTE-based risk modelling
- **Python (pandas / numpy)** — synthetic dataset generation

---

## 📁 Repository Structure

```
sa-bank-churn-analysis/
├── README.md
└── sa_bank_churn_analysis.sql
```

---

## 👤 Author

**Bulelwa Bisholo**  
Aspiring Data Analyst | Portfolio Project 2

[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-black?logo=github)](https://github.com/)
