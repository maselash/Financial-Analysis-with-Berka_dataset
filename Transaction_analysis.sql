-- Transaction Analysis
-- Analyse the 1 million+ transaction records to understand spending behaviour, account activity, and trends over time

SELECT*
FROM trans;

-- What is the total transaction volum and average transaction size per year 
SELECT (1900 +CAST(SUBSTRING(date,1,2) AS UNSIGNED))AS Year, COUNT(*) AS Transaction_year, SUM(amount) AS Total_volume, AVG(amount) AS Avg_transaction
FROM trans
GROUP BY Year
ORDER BY YEAR;

-- What are the most common transaction type and their symbols
SELECT type, k_symbol, COUNT(*) AS Frequency, SUM(amount) AS total_amount
FROM trans
WHERE k_symbol IS NOT NULL AND k_symbol != ''
GROUP BY type, k_symbol 
ORDER BY frequency DESC;

-- Where does their money go
SELECT
    k_symbol,
    COUNT(*)                                AS transaction_count,
    ROUND(SUM(amount), 2)                   AS total_amount,
    ROUND(AVG(amount), 2)                   AS avg_amount,
    ROUND(MIN(amount), 2)                   AS min_amount,
    ROUND(MAX(amount), 2)                   AS max_amount,
    ROUND(SUM(amount) * 100.0
          / SUM(SUM(amount)) OVER (), 2)    AS pct_of_total_spend
FROM trans
WHERE type = 'VYDAJ'
  AND k_symbol NOT IN ('OTHER', 'UNKNOWN', '')
GROUP BY k_symbol
ORDER BY total_amount DESC;

-- Preffered payment methods
SELECT
    operation,
    type,
    COUNT(*)                                        AS transaction_count,
    ROUND(SUM(amount), 2)                           AS total_amount,
    ROUND(AVG(amount), 2)                           AS avg_amount,
    ROUND(COUNT(*) * 100.0
          / SUM(COUNT(*)) OVER (), 2)               AS pct_of_all_transactions
FROM trans
WHERE operation NOT IN ('UNKNOWN', '')
GROUP BY operation, type
ORDER BY transaction_count DESC;

-- Where was the money coming from
SELECT
    CASE
        WHEN k_symbol = 'POJISTNE'      THEN 'Insurance Payment'
        WHEN k_symbol = 'SLUZBY'        THEN 'Services'
        WHEN k_symbol = 'UROK'          THEN 'Interest Credit'
        WHEN k_symbol = 'SANKC. UROK'   THEN 'Interest Penalty'
        WHEN k_symbol = 'SIPO'          THEN 'Household'
        WHEN k_symbol = 'DUCHOD'        THEN 'Pension'
        WHEN k_symbol = 'UVER'          THEN 'Loan Credit'
        WHEN k_symbol IN ('', 'OTHER', 'UNKNOWN')
                                        THEN 'Unspecified'
        ELSE k_symbol
    END                                             AS income_source,
    COUNT(*)                                        AS num_transactions,
    ROUND(COUNT(*) * 100.0
          / SUM(COUNT(*)) OVER(), 2)                AS pct_of_transactions,
    ROUND(SUM(amount), 2)                           AS total_amount,
    ROUND(SUM(amount) * 100.0
          / SUM(SUM(amount)) OVER(), 2)             AS pct_of_total_income,
    ROUND(AVG(amount), 2)                           AS avg_transaction,
    ROUND(MIN(amount), 2)                           AS min_amount,
    ROUND(MAX(amount), 2)                           AS max_amount
FROM trans
WHERE type = 'PRIJEM'
GROUP BY income_source
ORDER BY total_amount DESC;

-- Transactional volum by frequency 
SELECT
    a.frequency,
    COUNT(t.trans_id)                           AS total_transactions,
    ROUND(AVG(cnt.txn_per_account), 2)          AS avg_txn_per_account,
    ROUND(AVG(t.amount), 2)                     AS avg_transaction_size
FROM account a
JOIN trans t ON a.account_id = t.account_id
JOIN (
    SELECT account_id, COUNT(*) AS txn_per_account
    FROM trans GROUP BY account_id
) cnt ON a.account_id = cnt.account_id
GROUP BY a.frequency
ORDER BY avg_txn_per_account DESC;

-- Monthly spending trends overtime
SELECT
	substring(date,1,2) +1900                   AS txn_year,
    substring(date,3,2)                          AS txn_month,
    concat(substring(date,1,2) +1900 , '-',
         LPAD(substring(date,3,2), 2, '0'))             AS Year_Mon,
    COUNT(*)                                    AS num_transactions,
    ROUND(SUM(CASE WHEN type = 'PRIJEM'
              THEN amount ELSE 0 END), 2)       AS total_inflow,
    ROUND(SUM(CASE WHEN type = 'VYDAJ'
              THEN amount ELSE 0 END), 2)       AS total_outflow,
    ROUND(AVG(amount), 2)                       AS avg_transaction_size,
    COUNT(DISTINCT account_id)                  AS active_accounts
FROM trans
GROUP BY txn_year, txn_month, Year_Mon
ORDER BY txn_year, txn_month, Year_Mon;







