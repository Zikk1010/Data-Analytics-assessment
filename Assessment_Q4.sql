-- q4_clv_estimation.sql
-- Calculate tenure (months since signup), total transactions, and estimated CLV for each customer.
SELECT
    u.id AS user_id,
    u.name AS user_name,
    -- Calculate tenure in months (using MySQL TIMESTAMPDIFF as example)
    TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE) AS tenure_months,
    COUNT(sa.id) AS total_transactions,
    -- Compute estimated CLV:
    -- CLV = (transactions / tenure_months) * 12 * (avg_profit_per_txn)
    -- profit per txn = 0.001 * txn_amount, so avg_profit_per_txn = 0.001 * AVG(amount)
    -- Simplify: CLV = 0.001 * 12 * SUM(amount) / tenure_months
    CASE
        WHEN TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE) = 0 THEN 0
        ELSE ROUND(
             0.001 * 12 * SUM(sa.confirmed_amount) 
             / TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE), 2
        )
    END AS estimated_clv
FROM users_customuser AS u
LEFT JOIN savings_savingsaccount AS sa 
    ON sa.user_id = u.id
GROUP BY u.id, u.name
ORDER BY estimated_clv DESC;
