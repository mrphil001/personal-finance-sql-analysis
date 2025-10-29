# 💰 Personal Finance SQL Data Analysis

## 📋 Overview
This project performs an end-to-end **personal finance analysis** using SQL.  
It explores income, expenses, category-wise spending, and budget variance to uncover **financial insights** and **spending patterns**.  
The dataset was sourced from **Kaggle** and analyzed using **MySQL**, with final visualizations created in **Excel dashboards**.

---

## 🧠 Objectives
- Understand income and expense distribution.
- Identify top spending categories.
- Analyze trends across months and quarters.
- Compare actual spending vs. predefined budgets.
- Build reusable SQL views and reports for long-term financial tracking.

---

## 🗂️ Project Structure

| File | Description |
|------|--------------|
| `personal_transactions.sql` | Contains all raw transactions (credits & debits). |
| `Budget.sql` | Holds monthly budget limits for each expense category. |
| `finance_analysis.sql` | Main analysis script with transformations, KPIs, and reporting queries. |
| `Personal Finance Dashboard.xlsx` | Excel visualization of monthly trends and savings. |
| `Financial_Excel_Visualization.xlsx` | Additional charts and category-wise visual summaries. |

---

## ⚙️ PHASE-WISE APPROACH

### **PHASE 1: Database Setup & Data Exploration**
**Why:** To set up the environment and verify data integrity.  
**How:**
```sql
CREATE DATABASE personal_fin;
USE personal_fin;
SELECT * FROM personal_transactions;
SELECT * FROM budget;
Outcome: Database ready with clean tables and initial understanding of data.

PHASE 2: Data Cleaning & Transformation
Why: Raw data had inconsistent date formats and missing derived columns.
How:

Converted string dates to SQL DATE type.

Added year, month, quarter, and month_name columns.

Standardized categories and validated data consistency.

PHASE 3: Core Analysis Queries
Why: To derive insights on income, expenses, and savings.
Example:

sql
Copy code
SELECT 
  year,
  ROUND(SUM(CASE WHEN `Transaction Type` = 'credit' THEN amount ELSE 0 END)) AS total_income,
  ROUND(SUM(CASE WHEN `Transaction Type` = 'debit' THEN amount ELSE 0 END)) AS total_expense,
  ROUND(SUM(CASE WHEN `Transaction Type` = 'credit' THEN amount ELSE -amount END)) AS net_savings
FROM personal_transactions
GROUP BY year
ORDER BY year;
PHASE 4: Advanced Analytics
Why: To extract deeper insights and performance against budgets.
Example:

sql
Copy code
SELECT 
  b.category,
  b.budget AS monthly_budget,
  ROUND(IFNULL(AVG(actual.monthly_spends), 0), 2) AS avg_monthly_actual,
  ROUND(IFNULL(AVG(actual.monthly_spends), 0) - b.budget, 2) AS variance,
  CASE 
    WHEN (IFNULL(AVG(actual.monthly_spends), 0) > b.budget) THEN 'Over Budget'
    ELSE 'Within Budget'
  END AS status
FROM budget b
LEFT JOIN (
  SELECT category,
         YEAR(transaction_date) AS year,
         MONTH(transaction_date) AS month,
         SUM(amount) AS monthly_spends
  FROM personal_transactions
  WHERE `Transaction Type` = 'debit'
  GROUP BY category, year(transaction_date), month(transaction_date)
) actual 
ON b.category = actual.category 
GROUP BY b.category, b.budget
ORDER BY variance DESC;
PHASE 5: Views & Reports
Created reusable SQL views for quick insights:

monthly_summary → Monthly income, expense, and balance

Category_Performance_Summary → Budget vs. actual by category

Example:

sql
Copy code
CREATE VIEW monthly_summary AS 
SELECT
  Year,
  Month,
  Month_Name,
  ROUND(SUM(CASE WHEN `Transaction Type` = 'credit' THEN amount ELSE 0 END)) AS Income,
  ROUND(SUM(CASE WHEN `Transaction Type` = 'debit' THEN amount ELSE 0 END)) AS Expense,
  ROUND(SUM(CASE WHEN `Transaction Type` = 'credit' THEN amount ELSE -amount END)) AS Net_Balance
FROM personal_transactions 
GROUP BY year, month, month_name;
PHASE 6: Documentation & Presentation
Detailed README explaining workflow, SQL logic, and results.

All SQL queries well-commented and modular.

Excel dashboards summarize key metrics.

PHASE 7: Portfolio Presentation
Why: To showcase professional SQL workflow and data analysis capability.
How:

Uploaded project files to GitHub.

Shared visual summaries on LinkedIn.

Discussed real-world business use cases during interviews.

📊 Key Insights
Top Expense Categories: Mortgage & Rent, Home Improvement, and Groceries.

Overspending Detected: Restaurants and Shopping exceeded budget limits.

Quarterly Trends: Increased expenses in Q2 due to home improvement activities.

Savings Rate: Consistent income enabled steady monthly savings.

🧰 Tech Stack
SQL (MySQL): Data loading, cleaning, and analytics

Excel: Visualization dashboards

Kaggle: Data source

🚀 Future Improvements
Add Power BI dashboard for advanced visualization.

Automate monthly import and summary generation using Python scripts.

Implement stored procedures for real-time KPI generation.

📈 Sample Dashboards
You can include screenshots here after uploading your Excel dashboards to GitHub:

yaml
Copy code
📊 Monthly Summary Example:
![Monthly Summary Dashboard](images/monthly_summary.png)

💡 Category Spending vs. Budget:
![Budget Variance Chart](images/budget_variance.png)
🧑‍💻 Author
Phil Sunuwar
Customer Experience Specialist | Financial Data Enthusiast | Aspiring Data Analyst
🔗 LinkedIn
🐙 GitHub
📧 phil.sunuwar@example.com

⭐ How to Run
Clone the repository:

bash
Copy code
git clone https://github.com/YOUR-GITHUB-USERNAME/personal-finance-sql-analysis.git
Import the .sql files into MySQL Workbench or phpMyAdmin.

Run finance_analysis.sql sequentially after loading the datasets.

View insights and export CSVs for visualization in Excel.

🏁 Result
A complete end-to-end SQL Finance Analytics Portfolio Project, demonstrating:

Data cleaning, transformation & reporting

SQL analytical and visualization capabilities

Real-world application of data-driven financial insights
