-- ============================================
-- Variance Reporting: Actual vs Budget
-- Author: Samparna Mishra
-- Description: Financial variance analysis for 
--              strategic planning and FP&A cycles
-- ============================================

-- 1. Monthly Actual vs Budget Variance
SELECT 
    department,
    DATE_FORMAT(report_date, '%Y-%m') AS month,
    SUM(actual_amount) AS actual,
    SUM(budget_amount) AS budget,
    SUM(actual_amount - budget_amount) AS variance,
    ROUND((SUM(actual_amount - budget_amount) / SUM(budget_amount)) * 100, 2) AS variance_pct,
    CASE
        WHEN SUM(actual_amount) <= SUM(budget_amount) THEN 'Favourable'
        ELSE 'Unfavourable'
    END AS variance_flag
FROM financial_data
GROUP BY department, month
ORDER BY month DESC, variance_pct;

-- 2. Year-to-Date Variance Summary
SELECT
    department,
    YEAR(report_date) AS year,
    SUM(actual_amount) AS ytd_actual,
    SUM(budget_amount) AS ytd_budget,
    SUM(actual_amount - budget_amount) AS ytd_variance,
    ROUND((SUM(actual_amount - budget_amount) / SUM(budget_amount)) * 100, 2) AS ytd_variance_pct
FROM financial_data
WHERE report_date <= CURDATE()
GROUP BY department, year
ORDER BY year DESC, ytd_variance_pct;

-- 3. Top 5 Overspent Departments
SELECT 
    department,
    SUM(actual_amount) AS actual,
    SUM(budget_amount) AS budget,
    SUM(actual_amount - budget_amount) AS overspend
FROM financial_data
WHERE actual_amount > budget_amount
GROUP BY department
ORDER BY overspend DESC
LIMIT 5;
