CREATE DATABASE personal_fin;
USE personal_fin;
SELECT * FROM personal_transactions;
SELECT * FROM budget;

SELECT COUNT(*) FROM personal_transactions;
SELECT COUNT(*) FROM budget;

SELECT MIN(STR_TO_DATE(DATE, '%m/%d?%y')) AS first_date,
MAX(STR_TO_DATE(DATE,'%m/%d/%y')) AS last_date
FROM personal_transactions;

SELECT 
SUM(CASE WHEN DATE IS NULL THEN 1 ELSE 0 END) AS null_dates,
SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS null_amounts,
SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_categories
FROM personal_transactions;

SELECT DISTINCT category FROM `personal_transactions` ORDER BY category;
SELECT DISTINCT `Account Name` FROM personal_transactions;

UPDATE personal_transactions
SET transaction_date = STR_TO_DATE(`DATE`, '%m/%d/%Y');

ALTER TABLE personal_transactions
ADD COLUMN year INT,
ADD COLUMN month INT,
ADD COLUMN QUATER INT,
ADD COLUMN month_name VARCHAR(20);

UPDATE personal_transactions
SET year = YEAR(transaction_date),
	month = MONTH(transaction_date),
    quarter = QUARTER(transaction_date),
    month_name = DATE_FORMAT(transaction_date, '%b');
    
ALTER TABLE personal_transactions
CHANGE COLUMN quater quarter INT;

SELECT 
	year,
    ROUND(SUM(CASE WHEN `Transaction Type` = 'credit' THEN amount ELSE 0 END)) AS total_income,
    ROUND(SUM(CASE WHEN `Transaction Type` = 'debit' THEN amount ELSE 0 END)) AS total_expense,
    ROUND(SUM(CASE WHEN `transaction Type` = 'credit' THEN amount ELSE -amount END)) AS net_savings 
    FROM personal_transactions
    GROUP BY year
    ORDER BY year;
    
SELECT
	year,
    month,
    month_name,
    ROUND(SUM(CASE WHEN `Transaction Type` = 'debit' THEN amount ELSE 0 END)) AS total_expense,
    COUNT(*) AS transaction_count
    FROM personal_transactions
    WHERE `transaction type` = 'debit'
    GROUP BY year, month, month_name
    ORDER BY year, month;

SELECT category,
ROUND(SUM(amount)) AS total_spents,
COUNT(*) AS num_transactions,
ROUND(AVG(amount)) AS avg_transaction,
ROUND(SUM(amount) * 100 / (SELECT SUM(amount) FROM personal_transactions
WHERE `Transaction Type` = 'debit'), 2) AS percentage_of_total
FROM personal_transactions
WHERE `Transaction Type` = 'debit'
GROUP BY category
ORDER BY total_spents DESC;

SELECT * FROM personal_transactions;
SELECT * FROM budget;

SELECT 
	b.category,
    b.budget AS monthly_budget,
	ROUND(IFNULL(AVG(actual.monthly_spends), 0), 2) AS avg_monthly_actual,
	ROUND(IFNULL(AVG(actual.monthly_spends), 0) - b.budget, 2) AS variance,
    CASE 
		WHEN (IFNULL(AVG(actual.monthly_spends), 0) > b.budget) THEN 'over budget' 
        ELSE 'within budget'
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
        ) actual ON b.category = actual.category 
	    GROUP BY b.category, b.budget 
        ORDER BY variance DESC;
        

        SELECT 
`Account Name`,
		year,
ROUND(SUM(CASE WHEN `Transaction Type` = 'debit' THEN amount ELSE 0 END)) AS total_spents,
COUNT(CASE WHEN `Transaction Type` = 'debit' THEN 1 END) AS debit_count
FROM personal_transactions
GROUP BY `Account Name`, year
ORDER BY year, total_spents DESC;

SELECT * FROM personal_transactions;
SELECT * FROM budget;


SELECT
year,
quarter,
CASE quarter
WHEN 1 THEN 'Q1 (Jan-Mar)'
WHEN 2 THEN 'Q2 (Apr-June)'
WHEN 3 THEN 'Q3 (Jul-Sep)'
WHEN 4 THEN 'Q4 (Oct-Dec)'
END AS quarter_name,
	ROUND(SUM(amount)) AS total_spents,
	COUNT(*) AS transactions
	FROM personal_transactions
	WHERE `transaction type` = 'debit'
	GROUP BY year, quarter
	ORDER BY year, quarter;

SELECT
	Description,
    Category, 
    COUNT(*) AS Visit_Count,
    ROUND(SUM(amount)) AS Total_Spents,
    ROUND(AVG(amount)) AS Avg_Spends
    FROM personal_transactions
    WHERE `Transaction Type` = 'debit'
GROUP BY Description, Category
ORDER BY total_spents DESC
LIMIT 10;


CREATE VIEW monthly_summary AS 
SELECT
	Year,
    Month,
    Month_Name,
ROUND(SUM(CASE WHEN `Transaction Type` = 'credit' THEN 1 ELSE 0 END)) AS Income,
ROUND(SUM(CASE WHEN `Transaction Type`= 'debit' THEN 1 ELSE 0 END)) AS Expense,
ROUND(SUM(CASE WHEN `Transaction Type` = 'credit' THEN 1 ELSE -amount END)) AS `Net Balance`
FROM personal_transactions 
GROUP BY year, month, month_name;

SELECT * FROM monthly_summary;

CREATE VIEW Category_Performance_Summary AS
SELECT
	pt.Category,
    b.Budget,
    ROUND(SUM(pt.amount)) AS Actual_Spents,
    ROUND(SUM(pt.amount)) - b.budget AS Variance
    FROM personal_transactions pt
    JOIN budget b ON pt.category = b.category
    WHERE pt. `Transaction Type` = 'debit'
    GROUP BY pt.category, b.budget
    ORDER BY Actual_Spents DESC;
    
    SELECT * FROM Category_Performance_Summary;
    
    




