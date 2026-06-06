-- ============================================
-- KPI Tracking Across Business Units
-- Author: Samparna Mishra
-- Description: KPI monitoring and performance tracking
-- ============================================

-- 1. Monthly KPI Summary by Business Unit
SELECT 
    business_unit,
    DATE_FORMAT(report_date, '%Y-%m') AS month,
    kpi_name,
    target_value,
    actual_value,
    ROUND((actual_value / target_value) * 100, 2) AS achievement_pct,
    CASE 
        WHEN actual_value >= target_value THEN 'On Track'
        WHEN actual_value >= target_value * 0.85 THEN 'At Risk'
        ELSE 'Off Track'
    END AS status
FROM kpi_data
ORDER BY month DESC, business_unit;

-- 2. Quarter-on-Quarter KPI Trend
SELECT 
    business_unit,
    kpi_name,
    CONCAT('Q', QUARTER(report_date), ' ', YEAR(report_date)) AS quarter,
    ROUND(AVG(actual_value), 2) AS avg_actual,
    ROUND(AVG(target_value), 2) AS avg_target,
    ROUND(AVG(actual_value / target_value) * 100, 2) AS avg_achievement_pct
FROM kpi_data
GROUP BY business_unit, kpi_name, quarter
ORDER BY quarter DESC;

-- 3. Underperforming KPIs (Below 85% Achievement)
SELECT 
    business_unit,
    kpi_name,
    report_date,
    target_value,
    actual_value,
    ROUND((actual_value / target_value) * 100, 2) AS achievement_pct
FROM kpi_data
WHERE (actual_value / target_value) < 0.85
ORDER BY achievement_pct ASC;
