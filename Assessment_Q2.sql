-- q2_transaction_frequency.sql
-- Calculate average number of transactions per customer per month,
-- and categorize into High, Medium, Low frequency.
SELECT 
    u.id AS user_id,
    u.name AS user_name,
    COUNT(sa.id) AS total_transactions,
    -- Calculate months active (using MySQL TIMESTAMPDIFF as an example)
    TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE) AS tenure_months,
    -- Compute average transactions per month
    CASE 
        WHEN TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE) = 0 THEN 0
        ELSE ROUND(COUNT(sa.id) * 1.0 / TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE), 2)
    END AS avg_txn_per_month,
    -- Categorize frequency
    CASE 
        WHEN (COUNT(sa.id) * 1.0 / 
              CASE WHEN TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE) = 0 THEN 1 
                   ELSE TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE) END
             ) >= 10 THEN 'High Frequency'
        WHEN (COUNT(sa.id) * 1.0 / 
              CASE WHEN TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE) = 0 THEN 1 
                   ELSE TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE) END
             ) BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category
FROM users_customuser AS u
LEFT JOIN savings_savingsaccount AS sa 
    ON sa.user_id = u.id
GROUP BY u.id, u.name
ORDER BY u.id;
