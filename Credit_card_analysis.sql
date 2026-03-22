-- Credit card analysis

SELECT *
FROM card;

-- Credit card types and how they are distributed 
SELECT
    c.type                                          AS card_type,
    COUNT(*)                                        AS num_cards,
    ROUND(COUNT(*) * 100.0
          / SUM(COUNT(*)) OVER(), 2)                AS pct_of_card_portfolio,
    ROUND(COUNT(*) * 100.0
          / (SELECT COUNT(*) FROM account), 2)      AS pct_of_all_accounts
FROM card c
GROUP BY c.type
ORDER BY num_cards DESC;

-- Default Rate by Card Type
SELECT
    COALESCE(c.type, 'NO CARD')                     AS card_type,
    COUNT(l.loan_id)                                AS total_loans,
    SUM(CASE WHEN l.status IN ('B','D')
             THEN 1 ELSE 0 END)                     AS defaults,
    ROUND(SUM(CASE WHEN l.status IN ('B','D')
              THEN 1 ELSE 0 END)
          * 100.0 / COUNT(l.loan_id), 2)            AS default_rate_pct,
    ROUND(AVG(l.amount), 2)                         AS avg_loan_amount,
    ROUND(AVG(l.duration), 2)                       AS avg_loan_duration
FROM loan l
JOIN account a      ON l.account_id  = a.account_id
JOIN disp d         ON a.account_id  = d.account_id
                    AND d.type = 'OWNER'
LEFT JOIN card c    ON d.disp_id     = c.disp_id
GROUP BY card_type
ORDER BY default_rate_pct DESC;


-- Card Holders vs Non-Card Holders — Financial Profile
SELECT
    CASE WHEN c.card_id IS NOT NULL
         THEN 'Card Holder' ELSE 'No Card' END      AS card_status,
    COUNT(DISTINCT a.account_id)                    AS num_accounts,
    ROUND(AVG(t.avg_balance), 2)                    AS avg_balance,
    ROUND(AVG(t.total_txns), 2)                     AS avg_transactions,
    ROUND(AVG(t.avg_txn_size), 2)                   AS avg_transaction_size,
    SUM(CASE WHEN l.status IN ('B','D')
             THEN 1 ELSE 0 END)                     AS defaults,
    COUNT(l.loan_id)                                AS total_loans,
    ROUND(SUM(CASE WHEN l.status IN ('B','D')
              THEN 1 ELSE 0 END)
          * 100.0 / NULLIF(COUNT(l.loan_id),0), 2) AS default_rate_pct
FROM account a
JOIN disp d         ON a.account_id = d.account_id
                    AND d.type = 'OWNER'
LEFT JOIN card c    ON d.disp_id    = c.disp_id
LEFT JOIN loan l    ON a.account_id = l.account_id
JOIN (
    SELECT
        account_id,
        ROUND(AVG(balance),2)   AS avg_balance,
        COUNT(*)                AS total_txns,
        ROUND(AVG(amount),2)    AS avg_txn_size
    FROM trans
    GROUP BY account_id
) t ON a.account_id = t.account_id
GROUP BY card_status;

-- Clients that have both loan and credit cards vs those with only one or niether
SELECT
    CASE
        WHEN l.loan_id IS NOT NULL
         AND c.card_id IS NOT NULL THEN 'Loan + Card'
        WHEN l.loan_id IS NOT NULL
         AND c.card_id IS NULL     THEN 'Loan Only'
        WHEN l.loan_id IS NULL
         AND c.card_id IS NOT NULL THEN 'Card Only'
        ELSE                            'Neither'
    END                                             AS product_holding,
    COUNT(DISTINCT a.account_id)                    AS num_accounts,
    ROUND(COUNT(DISTINCT a.account_id) * 100.0
          / SUM(COUNT(DISTINCT a.account_id)) OVER(), 2) AS pct_of_all_accounts,
    ROUND(AVG(t.avg_balance), 2)                    AS avg_balance,
    ROUND(AVG(t.total_txns), 2)                     AS avg_transactions,
    SUM(CASE WHEN l.status IN ('B','D')
             THEN 1 ELSE 0 END)                     AS defaults,
    ROUND(SUM(CASE WHEN l.status IN ('B','D') THEN 1 ELSE 0 END)
          * 100.0 / NULLIF(COUNT(l.loan_id),0), 2) AS default_rate_pct
FROM account a
JOIN disp d         ON a.account_id = d.account_id AND d.type = 'OWNER'
LEFT JOIN loan l    ON a.account_id = l.account_id
LEFT JOIN card c    ON d.disp_id    = c.disp_id
JOIN (
    SELECT account_id,
           ROUND(AVG(balance),2) AS avg_balance,
           COUNT(*) AS total_txns
    FROM trans GROUP BY account_id
) t ON a.account_id = t.account_id
GROUP BY product_holding
ORDER BY avg_balance DESC;