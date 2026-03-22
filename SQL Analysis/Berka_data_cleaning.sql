-- Data cleaning

-- 1. Check for duplicates and removing them

-- Demograph table
SELECT A1, COUNT(*) AS cnt
FROM demograph
GROUP BY A1
HAVING cnt >1;
-- No duplicates

-- Account 
SELECT account_id, COUNT(*) AS cnt
FROM account
GROUP BY account_id
HAVING cnt >1;
-- No duplicates

-- Credit Card
SELECT card_id, COUNT(*) AS cnt
FROM card
GROUP BY card_id
HAVING cnt >1;
-- No duplicates

-- Client
SELECT client_id, COUNT(*) AS cnt
FROM client
GROUP BY client_id
HAVING cnt >1;
-- No duplicates

-- Disposition
SELECT disp_id, COUNT(*) AS cnt
FROM disp
GROUP BY disp_id
HAVING cnt >1;
-- No duplicates

-- Loan
SELECT loan_id, COUNT(*) AS cnt
FROM loan
GROUP BY loan_id
HAVING cnt >1;
-- No duplicates

-- Permenant Orders
SELECT order_id, COUNT(*) AS cnt
FROM orders
GROUP BY order_id
HAVING cnt >1;
-- No duplicates

-- Trans
SELECT trans_id, COUNT(*) AS cnt
FROM trans
GROUP BY trans_id
HAVING cnt >1;
-- No duplicates

-- Gender is encoded in the birth. 
-- For femamle:	YYMM+50DD
SELECT birth_number, SUBSTRING(birth_number, 3,2) as Month
FROM client
WHERE SUBSTRING(birth_number, 3,2) >50;
-- Create new column to show gender and remove the encoding
-- For better analysis 

-- Create a new client table as backup table to do edits: Client2
CREATE TABLE `client2` (
  `client_id` int,
  `birth_number` int,
  `district_id` int )
;

-- Insert the data
Insert into client2 
select *
from client;

-- Check the table 
select *
from client2;

select COUNT(*)
from client2;

-- Insert Gender column in client2 table
ALTER TABLE client2 ADD COLUMN gender VARCHAR(6);

-- Update the table with the gender values
UPDATE client2
SET gender = 
	CASE
    WHEN CAST(SUBSTRING(birth_number, 3, 2) AS UNSIGNED) > 50 THEN 'FEMALE'
    ELSE 'MALE'
    END;

-- Verify the gender count
SELECT gender, COUNT(*) AS Num_gender, (COUNT(gender)/(select count(*) from client2))*100 AS gender_percentage
FROM client2
GROUP BY gender;

-- Add birth_number column that is not encoded to do age calculations 
-- But first seperate year, month and date to make some queries easier in analysis 
-- Have a combined birth_date colum and drop the intial birth_number column
ALTER TABLE client2
  ADD COLUMN birth_year  INT,
  ADD COLUMN birth_month INT,
  ADD COLUMN birth_day   INT;

-- Update birth_year column
UPDATE client2
SET birth_year = 1900 + CAST(SUBSTRING(birth_number, 1, 2) AS UNSIGNED);

-- Update birth_minth column
UPDATE client2
SET birth_month = 
	CASE
    WHEN CAST(SUBSTRING(birth_number, 3,2) AS UNSIGNED) >50 
    THEN CAST(SUBSTRING(birth_number, 3,2) AS UNSIGNED) - 50
    ELSE CAST(SUBSTRING(birth_number, 3, 2) AS UNSIGNED)
  END;

UPDATE client2
SET birth_day = CAST(SUBSTRING(birth_number, 5,2) AS UNSIGNED);

-- Add the birth_date column
ALTER TABLE client2 
ADD COLUMN birth_date DATE;

-- Combine the columns into one date
UPDATE client2
SET birth_date = STR_TO_DATE(
  CONCAT(birth_year, '-',
         LPAD(birth_month, 2, '0'), '-',
         LPAD(birth_day,   2, '0')
  ),
  '%Y-%m-%d'
);

