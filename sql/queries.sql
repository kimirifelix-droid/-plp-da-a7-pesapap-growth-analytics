-- DATA VALIDATION: How many transactions occurred before the user's signup date?
SELECT COUNT(*) AS transactions_before_signup
FROM transactions t
JOIN users u ON t.user_id = u.user_id
WHERE date(t.txn_date) < date(u.signup_date);

-- QUESTION A: What is the total transaction value and transaction count by product?
SELECT product, COUNT(*) AS transaction_count,
       ROUND(SUM(amount), 2) AS total_value_kes
FROM transactions
GROUP BY product
ORDER BY total_value_kes DESC;

-- QUESTION B: Which five counties have the highest transaction value?
SELECT u.county, ROUND(SUM(t.amount), 2) AS total_value_kes
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY u.county
ORDER BY total_value_kes DESC
LIMIT 5;

-- QUESTION C: What is monthly transaction value and its running total?
WITH monthly_value AS (
    SELECT strftime('%Y-%m', txn_date) AS month,
           SUM(amount) AS monthly_value
    FROM transactions
    GROUP BY strftime('%Y-%m', txn_date)
)
SELECT month,
       ROUND(monthly_value, 2) AS monthly_value_kes,
       ROUND(SUM(monthly_value) OVER (ORDER BY month), 2) AS running_total_kes
FROM monthly_value
ORDER BY month;

-- QUESTION D: What is transaction value by acquisition channel?
SELECT u.acquisition_channel,
       COUNT(t.txn_id) AS transaction_count,
       ROUND(SUM(t.amount), 2) AS total_value_kes
FROM users u
JOIN transactions t ON u.user_id = t.user_id
GROUP BY u.acquisition_channel
ORDER BY total_value_kes DESC;

-- QUESTION E: Who are the ten users with the highest transaction value?
WITH user_value AS (
    SELECT user_id, SUM(amount) AS total_value
    FROM transactions
    GROUP BY user_id
),
ranked_users AS (
    SELECT user_id, total_value,
           RANK() OVER (ORDER BY total_value DESC) AS value_rank
    FROM user_value
)
SELECT user_id, ROUND(total_value, 2) AS total_value_kes, value_rank
FROM ranked_users
WHERE value_rank <= 10
ORDER BY value_rank, user_id;

-- QUESTION F: Which products have an average transaction above KES 1,300?
SELECT product, COUNT(*) AS transaction_count,
       ROUND(AVG(amount), 2) AS average_transaction_kes
FROM transactions
GROUP BY product
HAVING AVG(amount) > 1300
ORDER BY average_transaction_kes DESC;

-- QUESTION G: How many users fall into each lifetime transaction-value tier?
WITH user_value AS (
    SELECT u.user_id, COALESCE(SUM(t.amount), 0) AS total_value
    FROM users u
    LEFT JOIN transactions t ON u.user_id = t.user_id
    GROUP BY u.user_id
),
user_tiers AS (
    SELECT user_id, total_value,
           CASE
               WHEN total_value >= 10000 THEN 'High'
               WHEN total_value >= 4000 THEN 'Medium'
               ELSE 'Low'
           END AS value_tier
    FROM user_value
)
SELECT value_tier, COUNT(*) AS user_count,
       ROUND(SUM(total_value), 2) AS total_value_kes
FROM user_tiers
GROUP BY value_tier
ORDER BY CASE value_tier
    WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 ELSE 3
END;

-- QUESTION H: How does the number of monthly active users change month over month?
WITH monthly_active AS (
    SELECT strftime('%Y-%m', txn_date) AS month,
           COUNT(DISTINCT user_id) AS active_users
    FROM transactions
    GROUP BY strftime('%Y-%m', txn_date)
),
previous_month AS (
    SELECT month, active_users,
           LAG(active_users) OVER (ORDER BY month) AS previous_active_users
    FROM monthly_active
)
SELECT month, active_users, previous_active_users,
       active_users - previous_active_users AS change_in_users,
       ROUND(
           100.0 * (active_users - previous_active_users)
           / NULLIF(previous_active_users, 0), 2
       ) AS mom_growth_pct
FROM previous_month
ORDER BY month;
