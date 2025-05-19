-- q1_high_value_customers.sql
-- Find customers who have at least one funded savings plan and one funded investment plan,
-- and compute their total deposit amount, sorting by highest deposits.
SELECT 
    u.id AS user_id, 
    u.name AS user_name,
    SUM(sa.confirmed_amount) AS total_deposits
FROM users_customuser AS u
JOIN savings_savingsaccount AS sa 
    ON sa.user_id = u.id
JOIN plans_plan AS p 
    ON sa.plan_id = p.id
WHERE sa.confirmed_amount > 0
GROUP BY u.id, u.name
HAVING 
    -- At least one savings plan (flag = 1)
    SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) >= 1
    -- At least one investment plan (flag = 1)
    AND SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) >= 1
ORDER BY total_deposits DESC;
