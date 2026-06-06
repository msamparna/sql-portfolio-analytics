-- ============================================
-- Portfolio Performance Analysis
-- Author: Samparna Mishra
-- Description: Returns, NAV, and benchmark comparison
-- ============================================

-- 1. Daily Portfolio Returns
SELECT 
    portfolio_id,
    portfolio_name,
    date,
    nav,
    LAG(nav) OVER (PARTITION BY portfolio_id ORDER BY date) AS prev_nav,
    ROUND((nav - LAG(nav) OVER (PARTITION BY portfolio_id ORDER BY date)) 
        / LAG(nav) OVER (PARTITION BY portfolio_id ORDER BY date) * 100, 2) AS daily_return_pct
FROM portfolio_nav
ORDER BY portfolio_id, date DESC;

-- 2. Monthly Portfolio vs Benchmark Return
SELECT 
    p.portfolio_name,
    DATE_FORMAT(p.date, '%Y-%m') AS month,
    ROUND(SUM(p.daily_return_pct), 2) AS portfolio_return,
    ROUND(SUM(b.benchmark_return), 2) AS benchmark_return,
    ROUND(SUM(p.daily_return_pct) - SUM(b.benchmark_return), 2) AS alpha
FROM portfolio_returns p
JOIN benchmark_returns b 
    ON p.date = b.date AND p.benchmark_id = b.benchmark_id
GROUP BY p.portfolio_name, month
ORDER BY month DESC;

-- 3. Top 10 Holdings by Weight
SELECT 
    portfolio_name,
    security_name,
    asset_class,
    ROUND(market_value / SUM(market_value) OVER (PARTITION BY portfolio_id) * 100, 2) AS weight_pct
FROM holdings
ORDER BY weight_pct DESC
LIMIT 10;
