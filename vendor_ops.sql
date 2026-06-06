-- ============================================
-- Vendor Operations & Spend Analysis
-- Author: Samparna Mishra
-- Description: Vendor performance tracking and 
--              spend analysis for ops reporting
-- ============================================

-- 1. Vendor Spend Summary by Category
SELECT 
    vendor_name,
    category,
    DATE_FORMAT(invoice_date, '%Y-%m') AS month,
    COUNT(invoice_id) AS invoice_count,
    SUM(invoice_amount) AS total_spend,
    ROUND(AVG(invoice_amount), 2) AS avg_invoice_value
FROM vendor_invoices
GROUP BY vendor_name, category, month
ORDER BY month DESC, total_spend DESC;

-- 2. Vendor Payment Performance (On-Time vs Delayed)
SELECT 
    vendor_name,
    COUNT(invoice_id) AS total_invoices,
    SUM(CASE WHEN payment_date <= due_date THEN 1 ELSE 0 END) AS on_time_payments,
    SUM(CASE WHEN payment_date > due_date THEN 1 ELSE 0 END) AS delayed_payments,
    ROUND(SUM(CASE WHEN payment_date <= due_date THEN 1 ELSE 0 END) 
        / COUNT(invoice_id) * 100, 2) AS on_time_pct
FROM vendor_invoices
GROUP BY vendor_name
ORDER BY on_time_pct ASC;

-- 3. Top Vendors by Annual Spend
SELECT 
    vendor_name,
    category,
    YEAR(invoice_date) AS year,
    SUM(invoice_amount) AS annual_spend,
    RANK() OVER (PARTITION BY YEAR(invoice_date) ORDER BY SUM(invoice_amount) DESC) AS spend_rank
FROM vendor_invoices
GROUP BY vendor_name, category, year
ORDER BY year DESC, spend_rank;

-- 4. Vendor Contracts Expiring in Next 90 Days
SELECT 
    vendor_name,
    contract_value,
    contract_start,
    contract_end,
    DATEDIFF(contract_end, CURDATE()) AS days_to_expiry
FROM vendor_contracts
WHERE contract_end BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 90 DAY)
ORDER BY days_to_expiry ASC;
