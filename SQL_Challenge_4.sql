/*
 * Customer Lifetime Value (CLV) Estimation
 * Produces clean output with exactly the requested columns:
 * - customer_id
 * - name
 * - tenure_months
 * - total_transactions
 * - estimated_clv (formatted to 2 decimal places)
 */

WITH customer_transactions AS (
    SELECT
        u.id AS customer_id,
        TRIM(CONCAT(u.first_name, ' ', u.last_name)) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        SUM(s.confirmed_amount) / 100 AS total_deposits
    FROM
        users_customuser u
    JOIN
        savings_savingsaccount s ON u.id = s.owner_id
    JOIN
        plans_plan p ON s.plan_id = p.id
    WHERE
        s.confirmed_amount > 0      -- Only confirmed transactions
        AND p.is_deleted = 0        -- Exclude deleted plans
        AND p.is_archived = 0       -- Exclude archived plans
    GROUP BY
        u.id, u.first_name, u.last_name, u.date_joined
)

SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    -- Final CLV calculation formatted to 2 decimal places
    ROUND(
        CASE
            WHEN tenure_months > 0 THEN (total_deposits * 0.001) * (12 / tenure_months)
            ELSE 0
        END,
    2) AS estimated_clv
FROM
    customer_transactions
ORDER BY
    estimated_clv DESC;
