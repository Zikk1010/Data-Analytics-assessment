# Data-Analytics-assessment

# Assessment Solutions

This repository contains detailed explanation and solutions to the tasks described. Each question is addressed with the SQL query provided. The queries are clearly written with comments to explain key steps.

## Q1: High Value Customers with Multiple Products

**Task:** Identify customers who have at least one *funded savings plan* (`is_regular_savings = 1`) **and** at least one *funded investment plan* (`is_a_fund = 1`), sorted by total deposits (the sum of `confirmed_amount`).

**Approach and Logic:**

- **Tables and Joins:** Given that `users_customuser` has fields like `id`, `name`, etc. The `savings_savingsaccount` table records account transactions or deposits, with columns such as `user_id`, `plan_id`, and `confirmed_amount`. The `plans_plan` table has plan details, `is_regular_savings` and `is_a_fund`.
- **Filtering Conditions:** A "funded" plan implies the account has a deposit, so we include only rows where `confirmed_amount > 0`. 
- **Grouping:** Let's join the three tables (`users_customuser` → `savings_savingsaccount` → `plans_plan`) and group by each customer (`user_id`). 
- **Conditions in HAVING:** Let's use conditional aggregation to ensure each grouped customer has **at least one** savings plan and **at least one** investment plan. For example, `SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) >= 1` ensures there is at least one savings account. 
- **Total Deposits:** Let's sum `confirmed_amount` across all qualifying accounts for each user to compute total deposits, and sort the final result descending by this sum.  

*See the SQL query in* [`Assessment_Q1.sql`](q1_high_value_customers.sql) *for implementation details.*  

## Q2: Transaction Frequency Analysis

**Task:** Calculate the average number of transactions per customer per month, and categorize customers into **High (>=10/month)**, **Medium (3–9/month)**, or **Low (<=2/month)** frequency.

**Approach and Logic:**

- **Interpreting Transactions:** Given that each row in `savings_savingsaccount` represents a transaction or deposit linked to a user (through `user_id`), with a date (e.g., `transaction_date` or `confirmed_date`). The problem statement did not provide a separate transactions table, so we treat each account/deposit record as one transaction event for simplicity.
- **Timeframe (Months Active):** We use the `signup_date` from `users_customuser` to compute how many months each user has been active.
- **Average Transactions:** For each user, we `COUNT` the number of transactions and divide by the number of months active (using 1 month minimum to avoid division by zero) to get the average transactions per month.
- **Categorization:** We apply a `CASE` statement to bucket the average into 'High', 'Medium', or 'Low' based on the thresholds.  
- **Grouping:** We join `users_customuser` with their transactions (`savings_savingsaccount`), group by user, and compute the metrics.

*See the SQL query in* [`Assessment_Q2.sql`](q2_transaction_frequency.sql) *for the detailed query.*  

## Q3: Account Inactivity Alert

**Task:** Find all *active accounts* (both savings and investment) that have **no inflow transactions in the past 365 days**.

**Approach and Logic:**

- **Active Accounts:** Given that the `savings_savingsaccount` table has an `is_active` boolean column indicating whether an account is active, and also has a `last_deposit_date` (or similar) indicating the date of the most recent incoming transaction (deposit).
- **No Inflows in 365 Days:** We check where `last_deposit_date` is either `NULL` or older than one year from the current date. This effectively means no deposit has occurred in the last 365 days.
- **SQL Filtering:** We join `users_customuser` → `savings_savingsaccount` → `plans_plan` (to identify if it’s savings or investment plan, if needed for reporting). The WHERE clause filters `sa.is_active = 1` and `sa.last_deposit_date < (CURRENT_DATE - 365 days) OR sa.last_deposit_date IS NULL`. In the example query we demonstrate using SQL date functions (e.g., `DATE_SUB`) to subtract 365 days; use your SQL dialect’s equivalent.
- **Columns:** We then select the user, account ID, plan name or type, and the last deposit date for context.

*See the SQL query in* [`Assessment_Q3.sql`](q3_account_inactivity.sql) *for implementation details.*  

## Q4: Customer Lifetime Value (CLV) Estimation

**Task:** For each customer, compute:
- **Account tenure (months since signup)**
- **Total number of transactions**
- **Estimated CLV** using:  
  \[(total transactions ÷ tenure in months) × 12 × (avg profit per transaction)\],  
  where profit per transaction is 0.1% (0.001 × transaction amount). Order results by CLV descending.

**Approach and Logic:**

- **Tenure Calculation:** We compute the number of months since `signup_date` until the current date. Again, we illustrate using a date-diff function (`TIMESTAMPDIFF(MONTH, ...)` in MySQL) or an equivalent. If tenure is 0 (sign-up this month), we treat it as 1 month to avoid division by zero.
- **Transaction Metrics:** We join each user to their transactions (`savings_savingsaccount`), group by user, and count the transactions. We also calculate the sum of transaction values to derive average transaction value.
- **Profit and CLV:** Profit per transaction = 0.001 × (transaction value). We use the average or sum to compute total profit. The CLV formula given is effectively:
  \[
    CLV = \frac{\text{Total Transactions}}{\text{Tenure Months}} \times 12 \times (\text{Avg Profit per Transaction}) 
        = \frac{\text{Total Transactions} \times 12 \times 0.001 \times \text{Avg Transaction Amount}}{\text{Tenure Months}}.
  \]
  Equivalently, using sum of amounts: \(0.001 \times 12 \times \text{SUM(amount)} / \text{Tenure Months}\).
- **Grouping and Ordering:** The query groups by customer and computes these fields. We order the final output by the computed CLV in descending order.

*See the SQL query in* [`Assessment_Q4.sql`](q4_clv_estimation.sql) *for the detailed implementation.*  
