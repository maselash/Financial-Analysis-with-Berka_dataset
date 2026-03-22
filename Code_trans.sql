CREATE TABLE trans (
    trans_id    INT PRIMARY KEY,
    account_id  INT,
    date        INT,
    type        VARCHAR(10),
    operation   VARCHAR(50),
    amount      DECIMAL(12,2),
    balance     DECIMAL(12,2),
    k_symbol    VARCHAR(20),
    bank        VARCHAR(10),
    account     VARCHAR(20)
    );
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trans.csv'
INTO TABLE trans
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(trans_id, account_id, date, type, operation, amount, balance, k_symbol, bank, account);

-- 1. Check where MySQL allows files to be loaded from
SHOW VARIABLES LIKE 'secure_file_priv';

-- 2. Check if LOCAL INFILE is enabled
SHOW VARIABLES LIKE 'local_infile';
