-- Find savings or investment plans with no deposits in the last 365 days
SELECT
    p.id AS plan_id,
    p.owner_id,

    -- Label the plan as either Savings, Investment, or Other
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,

    -- Most recent deposit (if any)
    MAX(s.transaction_date) AS last_transaction_date,

    -- Days since last deposit
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days

FROM plans_plan p
LEFT JOIN savings_savingsaccount s 
    ON s.plan_id = p.id AND s.confirmed_amount > 0  -- Only inflow transactions

-- Focus only on plans that are either Savings or Investment
WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1

GROUP BY p.id, p.owner_id, type

-- Flag accounts that have:
-- (1) never had any deposit, or (2) last deposit was over 1 year ago
HAVING 
    MAX(s.transaction_date) IS NULL
    OR MAX(s.transaction_date) < DATE_SUB(CURDATE(), INTERVAL 365 DAY)

ORDER BY inactivity_days DESC;
