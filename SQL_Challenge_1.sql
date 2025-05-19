SELECT
    u.id AS owner_id,
    TRIM(CONCAT(u.first_name, ' ', u.last_name)) AS name,
    
    -- Count of distinct plans that are regular savings for this user
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    
    -- Count of distinct plans that are investment funds for this user
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    
    -- Total sum of confirmed deposit amounts across all plans for the user,
    -- converted from smallest unit to main currency (dividing by 100),
    -- rounded to 2 decimal places
    ROUND(SUM(CAST(s.confirmed_amount AS FLOAT)) / 100, 2) AS total_deposits

FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount s ON p.id = s.plan_id

WHERE s.confirmed_amount > 0 -- Only include savings with positive confirmed deposits

GROUP BY u.id, u.first_name, u.last_name

-- Only include users who have at least one regular savings plan
-- AND at least one investment fund plan
HAVING
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) > 0
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) > 0

ORDER BY total_deposits DESC; -- Sort results by total deposits in descending order




