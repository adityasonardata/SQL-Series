-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 06 | Working with SQL Built-in Functions
-- Topic: String Functions
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- UPPER & LOWER — change text case
-- ─────────────────────────────────────
SELECT UPPER('rahul sharma')  AS upper_result;   -- RAHUL SHARMA
SELECT LOWER('RAHUL SHARMA')  AS lower_result;   -- rahul sharma

SELECT UPPER(first_name) AS first_name FROM customers LIMIT 5;
SELECT LOWER(email)      AS email      FROM customers LIMIT 5;

-- Real use: standardise before comparison
SELECT * FROM customers
WHERE LOWER(city) = 'mumbai';


-- ─────────────────────────────────────
-- LENGTH — count characters
-- ─────────────────────────────────────
SELECT LENGTH('Rahul') AS len;   -- 5

SELECT first_name, LENGTH(first_name) AS name_length
FROM customers
ORDER BY name_length DESC
LIMIT 5;

-- Find emails longer than 25 chars
SELECT email, LENGTH(email) AS email_length
FROM customers
WHERE LENGTH(email) > 25
ORDER BY email_length DESC;


-- ─────────────────────────────────────
-- CONCAT & CONCAT_WS — join strings
-- ─────────────────────────────────────
SELECT CONCAT('Rahul', ' ', 'Sharma') AS full_name;

-- Full name from two columns
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers LIMIT 5;

-- CONCAT_WS — With Separator (cleaner)
SELECT CONCAT_WS(' ', first_name, last_name) AS full_name
FROM customers LIMIT 5;

SELECT CONCAT_WS(', ', city, first_name) AS location_name
FROM customers LIMIT 5;


-- ─────────────────────────────────────
-- TRIM, LTRIM, RTRIM — remove spaces
-- ─────────────────────────────────────
SELECT TRIM('   Rahul Sharma   ') AS cleaned;      -- 'Rahul Sharma'
SELECT LTRIM('   Rahul')          AS left_trim;    -- 'Rahul'
SELECT RTRIM('Rahul   ')          AS right_trim;   -- 'Rahul'

-- Real use: clean dirty imported data
SELECT * FROM customers
WHERE TRIM(city) = 'Mumbai';


-- ─────────────────────────────────────
-- SUBSTRING — extract part of string
-- SUBSTRING(str, start_pos, length)
-- Position starts at 1
-- ─────────────────────────────────────
SELECT SUBSTRING('Rahul Sharma', 1, 5)  AS result;   -- Rahul
SELECT SUBSTRING('Rahul Sharma', 7)     AS result;   -- Sharma

SELECT first_name, SUBSTRING(first_name, 1, 3) AS short_name
FROM customers LIMIT 5;

-- Extract domain from email
SELECT
    email,
    SUBSTRING(email, LOCATE('@', email) + 1) AS domain
FROM customers LIMIT 5;


-- ─────────────────────────────────────
-- REPLACE — swap text inside string
-- ─────────────────────────────────────
SELECT REPLACE('rahul@gmail.com', 'gmail', 'yahoo') AS new_email;

SELECT
    product_name,
    REPLACE(product_name, 'Sony ', '') AS short_name
FROM products
WHERE product_name LIKE 'Sony%';


-- ─────────────────────────────────────
-- LOCATE / INSTR — find position
-- ─────────────────────────────────────
SELECT LOCATE('@', 'rahul@gmail.com')  AS position;   -- 6
SELECT INSTR('rahul@gmail.com', '@')   AS position;   -- 6

SELECT email, LOCATE('@', email) AS at_pos
FROM customers LIMIT 5;


-- ─────────────────────────────────────
-- LEFT & RIGHT — first/last n chars
-- ─────────────────────────────────────
SELECT LEFT('Rahul Sharma', 5)   AS result;   -- Rahul
SELECT RIGHT('Rahul Sharma', 6)  AS result;   -- Sharma

SELECT LEFT(first_name, 3)  AS initials FROM customers LIMIT 5;
SELECT RIGHT(email, 3)      AS tld      FROM customers LIMIT 5;


-- ─────────────────────────────────────
-- LPAD & RPAD — pad to fixed length
-- LPAD(str, total_length, pad_char)
-- ─────────────────────────────────────
SELECT LPAD(7, 6, '0')    AS padded;   -- 000007
SELECT RPAD('SQL', 8, '.') AS padded;  -- SQL.....

-- Format order IDs with leading zeros
SELECT
    order_id,
    LPAD(order_id, 6, '0') AS formatted_id
FROM orders LIMIT 5;
