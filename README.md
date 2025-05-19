**Assessment_Q1.sql** - High-Value Customers with Multiple Products
Objective:
Identify customers who have both funded savings and investment plans, and calculate their total deposits.

Approach:

Joined users_customuser, plans_plan, and savings_savingsaccount using foreign keys.

Used conditional aggregation to separately count savings (is_regular_savings = 1) and investment plans (is_a_fund = 1).

Filtered deposits where confirmed_amount > 0 to ensure only funded accounts were counted.

Converted confirmed_amount from kobo to naira using / 100.

Concatenated first_name and last_name to form full customer names.

Applied HAVING to include only those with at least one of each plan type.

Sorted the results by total_deposits in descending order.

Challenges:

Ensuring accurate grouping when joining across multiple plans per customer.

Filtering only funded accounts while maintaining both plan types.

Formatting the name properly with spacing and trimming.



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



Assessment\_Q2.sql – Transaction Frequency Analysis

Objective:
Segment customers into frequency categories based on their average monthly deposit transactions.

Approach:
 Used a CTE to calculate the number of transactions per customer per month.
 Computed each customer’s average transactions per month.
 
Categorized customers as:

High Frequency** (≥10/month)

Medium Frequency (3–9/month)

Low Frequency (≤2/month)

Aggregated results to show the number of customers in each category and their average transaction rates.

Challenges:

Formatting transaction dates correctly for monthly grouping.

Maintaining clarity with nested CTEs while ensuring performance and readability.



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



Assessment_Q3.sql – Account Inactivity Alert
Objective:
Identify active savings or investment plans that haven’t had any deposit in the last 365 days.

Approach:

Queried plans_plan for plans marked as either Savings or Investment.

Joined with savings_savingsaccount on plan_id, filtering only confirmed deposit transactions.

Grouped by plan to find the most recent transaction date.

Used DATEDIFF to calculate inactivity in days.

Filtered out plans with:

No deposit history, or

Last deposit older than 365 days.

Classified each plan as Savings, Investment, or Other.

Challenges:

Ensured LEFT JOIN was used to retain plans with no transaction history.

Accounted for both zero and outdated deposits without excluding valid plan types.



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



Objective:
Estimate each customer's CLV based on account tenure and transaction volume using the simplified formula provided.

Approach:

Joined users_customuser, savings_savingsaccount, and plans_plan to retrieve relevant data.

Filtered out archived and deleted plans, and included only confirmed deposit transactions.

Calculated:

Tenure in months since date_joined

Total number of transactions

Total deposits in Naira (converted from Kobo)


Rounded the final CLV to two decimal places.

Challenges:

Ensured tenure months calculation handled division correctly.

Safeguarded against divide-by-zero errors for new users.

Converted monetary values from Kobo to Naira cleanly within aggregations.




