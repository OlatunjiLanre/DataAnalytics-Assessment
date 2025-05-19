-- Step 1: Get number of transactions each user made per month
WITH monthly_txn AS (
    SELECT
        p.owner_id AS user_id,  -- pulling the user ID through the plan
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS txn_month,  -- get the year-month of the transaction
        COUNT(*) AS monthly_transaction_count  -- how many transactions in that month
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id  -- join to get access to the user
    WHERE s.transaction_date IS NOT NULL
    GROUP BY p.owner_id, DATE_FORMAT(s.transaction_date, '%Y-%m')
),

-- Step 2: Now we calculate the average number of transactions each user does per month
average_txn AS (
    SELECT
        user_id,
        ROUND(AVG(monthly_transaction_count), 2) AS avg_txn_per_month  -- round to keep it clean
    FROM monthly_txn
    GROUP BY user_id
),

-- Step 3: Categorize users based on their transaction habits
categorized_users AS (
    SELECT
        user_id,
        avg_txn_per_month,
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'     -- 10 or more transactions/month
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'  -- between 3 and 9
            ELSE 'Low Frequency'                                   -- 2 or fewer
        END AS frequency_category
    FROM average_txn
)

-- Step 4: For each frequency category, show how many users and their average transaction frequency
SELECT
    frequency_category,
    COUNT(*) AS customer_count,  -- how many users fall into this category
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month  -- average for that group
FROM categorized_users
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');  -- custom order

