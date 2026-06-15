-- ============================================
-- SA BANK CUSTOMER CHURN ANALYSIS
-- Bulelwa Bisholo | Portfolio Project 2
-- ============================================
-- 
-- OVERVIEW:
-- This SQL script analyzes a synthetic dataset of 15,000 South African 
-- retail banking customers to identify the strongest predictors of 
-- customer churn. The analysis progresses from data quality checks, 
-- through demographic segmentation, into financial/behavioural drivers, 
-- and concludes with a composite multi-factor risk score (CTE).
--
-- DATASET: sa_bank_churn_15000.csv (15,000 rows, 15 columns)
-- Generated using Python (pandas/numpy) with embedded churn logic based 
-- on employment status, credit score, account balance, product count, 
-- and tenure.
--
-- KEY FINDING: A composite 5-factor risk score shows a near-perfect 
-- relationship with churn — customers with 0 risk factors never churned, 
-- while customers with all 5 factors always churned.
-- ============================================

-- ============================================
-- DATA LIMITATIONS / NOTES
-- ============================================
-- 'Bank' was randomly assigned during data generation 
-- and has no underlying relationship with churn.
-- Any apparent differences between banks in this dataset 
-- are statistical noise and should not be interpreted 
-- as real bank performance differences.
-- A Bank-level churn comparison was therefore intentionally 
-- excluded from this analysis.



CREATE DATABASE sa_bank_churn;

USE sa_bank_churn;

CREATE TABLE customers (
    CustomerID VARCHAR(10),
    Age INT,
    Gender VARCHAR(10),
    Province VARCHAR(50),
    Bank VARCHAR(50),
    Product VARCHAR(50),
    EmploymentStatus VARCHAR(50),
    EducationLevel VARCHAR(50),
    TenureYears INT,
    NumProducts INT,
    HasCreditCard INT,
    AccountBalance DECIMAL(12,2),
    EstimatedSalary DECIMAL(12,2),
    CreditScore INT,
    Churn INT
);

ALTER TABLE customers ADD PRIMARY KEY (CustomerID);

SHOW TABLES;

SELECT COUNT(*)
FROM CUSTOMERS;

-- Checking for missing NULLs
SELECT 
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Missing_Age,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Missing_Gender,
    SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS Missing_Province,
    SUM(CASE WHEN Bank IS NULL THEN 1 ELSE 0 END) AS Missing_Bank,
    SUM(CASE WHEN Product IS NULL THEN 1 ELSE 0 END) AS Missing_Product,
    SUM(CASE WHEN EmploymentStatus IS NULL THEN 1 ELSE 0 END) AS Missing_Employment,
    SUM(CASE WHEN EducationLevel IS NULL THEN 1 ELSE 0 END) AS Missing_Education,
    SUM(CASE WHEN TenureYears IS NULL THEN 1 ELSE 0 END) AS Missing_Tenure,
    SUM(CASE WHEN NumProducts IS NULL THEN 1 ELSE 0 END) AS Missing_NumProducts,
    SUM(CASE WHEN HasCreditCard IS NULL THEN 1 ELSE 0 END) AS Missing_CreditCard,
    SUM(CASE WHEN AccountBalance IS NULL THEN 1 ELSE 0 END) AS Missing_Balance,
    SUM(CASE WHEN EstimatedSalary IS NULL THEN 1 ELSE 0 END) AS Missing_Salary,
    SUM(CASE WHEN CreditScore IS NULL THEN 1 ELSE 0 END) AS Missing_CreditScore,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS Missing_Churn
FROM customers;

-- Checking for duplicates
SELECT CustomerID, COUNT(*) AS Count 
FROM CUSTOMERS
GROUP BY CUSTOMERID
HAVING COUNT(*) > 1;

-- Query 1: Overall Churn Rate
SELECT 
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Churned_Customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM customers;

-- Query 2: Churn by Province & Gender

SELECT 
    Province,
    Gender,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Churned_Customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM customers
GROUP BY Province, Gender
ORDER BY Churn_Rate_Percent DESC;


-- Query 3: Churn by Employment Status
SELECT 
    EmploymentStatus,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Churned_Customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM customers
GROUP BY EmploymentStatus
ORDER BY Churn_Rate_Percent DESC;


-- Query 4: Churn by Age Band Analysis
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 45 THEN '30-45'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'Over 60'
    END AS Age_Group,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Churned_Customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM customers
GROUP BY Age_Group
ORDER BY Churn_Rate_Percent DESC;

-- Query 5: Churn rate by Credit Score Bands 
SELECT 
    CASE 
        WHEN CreditScore < 500 THEN 'Poor (300-499)'
        WHEN CreditScore BETWEEN 500 AND 649 THEN 'Fair (500-649)'
        WHEN CreditScore BETWEEN 650 AND 749 THEN 'Good (650-749)'
        ELSE 'Excellent (750-850)'
    END AS Credit_Score_Band,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Churned_Customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM customers
GROUP BY Credit_Score_Band
ORDER BY Churn_Rate_Percent DESC;


-- Query 6: Churn tenure and number of products 
SELECT 
    CASE 
        WHEN TenureYears < 2 THEN 'New (0-1 yrs)'
        WHEN TenureYears BETWEEN 2 AND 5 THEN 'Established (2-5 yrs)'
        WHEN TenureYears BETWEEN 6 AND 10 THEN 'Loyal (6-10 yrs)'
        ELSE 'Long-term (11+ yrs)'
    END AS Tenure_Group,
    NumProducts,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Churned_Customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM customers
GROUP BY Tenure_Group, NumProducts
ORDER BY Churn_Rate_Percent DESC;

-- Query 7: Churn by Account Balance Tiers
SELECT 
    CASE 
        WHEN AccountBalance < 10000 THEN 'Low (R0 - R9,999)'
        WHEN AccountBalance BETWEEN 10000 AND 99999 THEN 'Medium (R10,000 - R99,999)'
        WHEN AccountBalance BETWEEN 100000 AND 299999 THEN 'High (R100,000 - R299,999)'
        ELSE 'Very High (R300,000+)'
    END AS Balance_Tier,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Churned_Customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM customers
GROUP BY Balance_Tier
ORDER BY Churn_Rate_Percent DESC;

-- Query 8: Multi-Factor Risk Segmentation (using CTE)

WITH risk_scoring AS (
    SELECT 
        CustomerID,
        Churn,
        (CASE WHEN EmploymentStatus = 'Unemployed' THEN 1 ELSE 0 END +
         CASE WHEN CreditScore < 500 THEN 1 ELSE 0 END +
         CASE WHEN AccountBalance < 10000 THEN 1 ELSE 0 END +
         CASE WHEN NumProducts = 1 THEN 1 ELSE 0 END +
         CASE WHEN TenureYears < 2 THEN 1 ELSE 0 END) AS Risk_Score
    FROM customers
)
SELECT 
    CASE 
        WHEN Risk_Score = 0 THEN 'No Risk Factors'
        WHEN Risk_Score BETWEEN 1 AND 2 THEN 'Low Risk (1-2 factors)'
        WHEN Risk_Score BETWEEN 3 AND 4 THEN 'High Risk (3-4 factors)'
        ELSE 'Critical Risk (5 factors)'
    END AS Risk_Segment,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Churned_Customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM risk_scoring
GROUP BY Risk_Segment
ORDER BY Churn_Rate_Percent DESC;



