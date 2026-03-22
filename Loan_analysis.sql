-- Loan profile analysis 
-- Analyse the bank's loan book. Understand the distribution of loan sizes, durations, repayment statuses, and the profile of borrowers. 

SELECT *
FROM loan;

-- What is the overall loan book summary by status
SELECT status,
CASE status
    WHEN 'A' THEN 'Contract finished - Good'
    WHEN 'B' THEN 'Contract finished - Default'
    WHEN 'C' THEN 'Running active - Good'
    WHEN 'D' THEN 'Running active - Default'
  END AS status_label,
  COUNT(*) AS num_loans, SUM(amount) AS total_amount,AVG(amount)AS avg_loan_size
FROM loan
GROUP BY status
ORDER BY status;


-- What is the default rate by loan duration bucket
SELECT
CASE
    WHEN duration <= 12 THEN '0-12 months'
    WHEN duration <= 24 THEN '13-24 months'
    WHEN duration <= 48 THEN '25-48 months'
    ELSE '49+ months' END AS duration_bucket,
  COUNT(*) AS total_loans,
  SUM(CASE WHEN status IN ('B','D') THEN 1 ELSE 0 END) AS defaults,
  ROUND(SUM(CASE WHEN status IN ('B','D') THEN 1.0 ELSE 0 END)
    / COUNT(*) * 100, 2) AS default_rate_pct
FROM loan
GROUP BY duration_bucket
ORDER BY MIN(duration); 


-- Join loans to accounts and districts to find default rates by region.
SELECT d.A2 AS district_name, d.A12 AS unemployment_95,
COUNT(l.loan_id) AS total_loans,
SUM(CASE WHEN l.status IN ('B','D') THEN 1 ELSE 0 END) AS defaults,
ROUND(SUM(CASE WHEN l.status IN ('B','D') THEN 1.0 ELSE 0 END)/ COUNT(l.loan_id) * 100, 2) AS default_rate_pct
FROM loan l
JOIN account a ON l.account_id = a.account_id
JOIN demograph d ON a.district_id = d.A1
GROUP BY d.A1, d.A2, d.A12
HAVING total_loans >= 5
ORDER BY default_rate_pct DESC
LIMIT 15;


-- What is the average account balance in the 3 months before a loan was issued?
SELECT l.loan_id, l.account_id, l.status,l.amount AS loan_amount, 
ROUND(AVG(t.balance), 2) AS avg_balance_pre_loan
FROM loan l
JOIN trans t ON l.account_id = t.account_id
WHERE STR_TO_DATE(CONCAT('19', t.date), '%Y%m%d') 
      BETWEEN DATE_SUB(STR_TO_DATE(CONCAT('19', l.date), '%Y%m%d'), INTERVAL 3 MONTH)
          AND STR_TO_DATE(CONCAT('19', l.date), '%Y%m%d')GROUP BY l.loan_id, l.account_id, l.status, l.amount
ORDER BY l.loan_id;


-- Identify customers who have both a loan and credit cards
SELECT c.client_id,
a.account_id, l.amount AS loan_amount, l.status AS loan_status, card.type AS card_type
FROM client c
JOIN disp d    
	ON c.client_id  = d.client_id  AND d.type = 'OWNER'
JOIN account a 
	ON d.account_id = a.account_id
JOIN loan l    
	ON a.account_id = l.account_id
JOIN card   
	ON d.disp_id    = card.disp_id
ORDER BY l.amount DESC;


-- Loan book composition
SELECT
    status,
    COUNT(*)                                        AS num_loans,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_of_portfolio,
    ROUND(AVG(amount), 2)                           AS avg_loan_amount,
    ROUND(MIN(amount), 2)                           AS min_loan_amount,
    ROUND(MAX(amount), 2)                           AS max_loan_amount,
    ROUND(SUM(amount), 2)                           AS total_exposure,
    ROUND(AVG(duration), 2)                         AS avg_duration_months,
    ROUND(AVG(payments), 2)                         AS avg_monthly_payment
FROM loan
GROUP BY status
ORDER BY FIELD(status, 'A','B','C','D');


-- Default Rate by Loan Size Band
SELECT
    CASE
        WHEN amount < 50000  THEN '1. Under 50K'
        WHEN amount < 100000 THEN '2. 50K–100K'
        WHEN amount < 200000 THEN '3. 100K–200K'
        WHEN amount < 300000 THEN '4. 200K–300K'
        ELSE                      '5. Over 300K'
    END                                             AS loan_size_band,
    COUNT(*)                                        AS total_loans,
    SUM(CASE WHEN status IN ('B','D') THEN 1 ELSE 0 END) AS defaults,
    ROUND(SUM(CASE WHEN status IN ('B','D') THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                    AS default_rate_pct,
    ROUND(AVG(amount), 2)                           AS avg_loan_amount,
    ROUND(AVG(duration), 2)                         AS avg_duration_months
FROM loan
GROUP BY loan_size_band
ORDER BY loan_size_band;


-- Gender and defalut of loans
SELECT
    c.gender,
    COUNT(l.loan_id)                                        AS total_loans,
    SUM(CASE WHEN l.status IN ('B','D') THEN 1 ELSE 0 END) AS total_defaults,
    SUM(CASE WHEN l.status = 'A'        THEN 1 ELSE 0 END) AS finished_good,
    SUM(CASE WHEN l.status = 'B'        THEN 1 ELSE 0 END) AS finished_default,
    SUM(CASE WHEN l.status = 'C'        THEN 1 ELSE 0 END) AS active_good,
    SUM(CASE WHEN l.status = 'D'        THEN 1 ELSE 0 END) AS active_default,
    ROUND(SUM(CASE WHEN l.status IN ('B','D') THEN 1 ELSE 0 END)
          * 100.0 / COUNT(l.loan_id), 2)                    AS default_rate_pct,
    ROUND(AVG(l.amount), 2)                                 AS avg_loan_amount,
    ROUND(AVG(l.duration), 2)                               AS avg_loan_duration_months,
    ROUND(AVG(l.payments), 2)                               AS avg_monthly_payment
FROM loan l
JOIN account a      ON l.account_id    = a.account_id
JOIN disp d         ON a.account_id    = d.account_id
                    AND d.type         = 'OWNER'
JOIN client2 c       ON d.client_id     = c.client_id
GROUP BY c.gender
ORDER BY default_rate_pct DESC;


-- loan defualt vs district
SELECT
    d.A2                                                    AS district_name,
    d.A11                                                   AS avg_salary,
    d.A12                                                   AS unemployment_rate,
    COUNT(l.loan_id)                                        AS total_loans,
    SUM(CASE WHEN l.status IN ('B','D') THEN 1 ELSE 0 END) AS total_defaults,
    SUM(CASE WHEN l.status = 'A'        THEN 1 ELSE 0 END) AS finished_good,
    SUM(CASE WHEN l.status = 'B'        THEN 1 ELSE 0 END) AS finished_default,
    SUM(CASE WHEN l.status = 'C'        THEN 1 ELSE 0 END) AS active_good,
    SUM(CASE WHEN l.status = 'D'        THEN 1 ELSE 0 END) AS active_default,
    ROUND(SUM(CASE WHEN l.status IN ('B','D') THEN 1 ELSE 0 END)
          * 100.0 / COUNT(l.loan_id), 2)                    AS default_rate_pct,
    ROUND(AVG(l.amount), 2)                                 AS avg_loan_amount,
    ROUND(AVG(l.duration), 2)                               AS avg_loan_duration_months,
    ROUND(AVG(l.payments), 2)                               AS avg_monthly_payment,
    ROUND(AVG(l.payments) / d.A11 * 100, 2)                AS avg_payment_to_salary_pct
FROM loan l
JOIN account a      ON l.account_id    = a.account_id
JOIN demograph d     ON a.district_id   = d.A1
GROUP BY
    d.A1,
    d.A2,
    d.A11,
    d.A12
HAVING total_loans >= 3
ORDER BY default_rate_pct DESC
limit 10;
