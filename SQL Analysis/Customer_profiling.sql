-- Customer & Account Profiling 
-- Understand who the bank's customers are: Their demographics, locations, and account types. 
-- Look at accounts, client2, demograph

-- How many clients do we have in the bank and how are they split by gender 
SELECT gender, COUNT(*) AS gender_count, 
COUNT(gender)/(SELECT COUNT(*) FROM client2) *100 AS Percentage
FROM client2
GROUP BY gender;

-- What is the age distribution of clients at the time of account opening 
SELECT
  CASE
    WHEN age BETWEEN 18 AND 30 THEN '18-30'
    WHEN age BETWEEN 31 AND 45 THEN '31-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+' END AS age_band,
  COUNT(*) AS clients
FROM (
  SELECT c.client_id,
    CAST(SUBSTR(a.date,1,2) AS unsigned) + 1900 -
    (SUBSTRING(c.birth_date, 1,4)) AS age
  FROM client2 c
  JOIN disp d ON c.client_id = d.client_id
  JOIN account a ON d.account_id = a.account_id
  WHERE d.type = 'OWNER'
) sub
GROUP BY age_band ORDER BY age_band;

select *
from disp;

-- Looking at disponenet 
SELECT
  CASE
    WHEN age BETWEEN 18 AND 30 THEN '18-30'
    WHEN age BETWEEN 31 AND 45 THEN '31-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+' END AS age_band,
  COUNT(*) AS clients
FROM (
  SELECT c.client_id,
    CAST(SUBSTR(a.date,1,2) AS unsigned) + 1900 -
    (SUBSTRING(c.birth_date, 1,4)) AS age
  FROM client2 c
  JOIN disp d ON c.client_id = d.client_id
  JOIN account a ON d.account_id = a.account_id
  WHERE d.type = 'DISPONENT'
) sub
GROUP BY age_band ORDER BY age_band;

-- Which districts have the most accounts? Show the top 10 with average salary 
SELECT
  d.A2 AS district_name,
  COUNT(a.account_id) AS num_accounts,
  d.A11 AS avg_salary
FROM account a
JOIN demograph d ON a.district_id = d.A1
GROUP BY d.A1, d.A2, d.A11
ORDER BY num_accounts DESC;


-- Look at disposition, how many people are owners of accounts vs users
SELECT `type`, COUNT(*) AS count
FROM disp
GROUP BY `type`;

-- How many accounts have a credit card and what type are they
SELECT c.type, COUNT(*) AS count, ROUND(COUNT(DISTINCT d.account_id) * 100.0 /
    (SELECT COUNT(*) FROM account), 2) AS pct_of_all_accounts
FROM account a
JOIN disp d
	ON a.account_id = d.account_id
JOIN card c
	ON d.disp_id = c.disp_id
GROUP BY c.type;


  -- What is the frequency of each account and how is it distributed 
  SELECT *
  FROM account;
  
  SELECT frequency, COUNT(*)
  FROM account
  GROUP BY frequency;