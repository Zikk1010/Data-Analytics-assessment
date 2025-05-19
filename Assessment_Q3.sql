-- q3_account_inactivity.sql
-- Find active accounts (savings or investment) with no deposit in the past 365 days.
SELECT
    u.id AS user_id,
    u.name AS user_name,
    sa.id AS account_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings Plan'
        WHEN p.is_a_fund = 1 THEN 'Investment Plan'
        ELSE 'Other'
    END AS account_type,
    sa.last_deposit_date
FROM users_customuser AS u
JOIN savings_savingsaccount AS sa 
    ON sa.user_id = u.id
JOIN plans_plan AS p 
    ON sa.plan_id = p.id
WHERE sa.is_active = 1
  AND (
       sa.last_deposit_date IS NULL
       OR sa.last_deposit_date < DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY)
      );