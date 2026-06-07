-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 06 | Working with SQL Built-in Functions
-- Topic: Date & Time Functions
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- CURRENT DATE AND TIME
-- ─────────────────────────────────────
SELECT NOW()      AS current_datetime;   -- 2024-04-30 14:35:22
SELECT CURDATE()  AS current_date;       -- 2024-04-30
SELECT CURTIME()  AS current_time;       -- 14:35:22
SELECT SYSDATE()  AS sys_datetime;       -- same as NOW()


-- ─────────────────────────────────────
-- YEAR, MONTH, DAY — extract date parts
-- ─────────────────────────────────────
SELECT
    order_date,
    YEAR(order_date)    AS yr,
    MONTH(order_date)   AS mo,
    DAY(order_date)     AS dy,
    DAYNAME(order_date) AS day_name,
    MONTHNAME(order_date) AS month_name
FROM orders LIMIT 5;

-- Filter by month
SELECT * FROM orders WHERE MONTH(order_date) = 1;

-- Filter by year
SELECT * FROM orders WHERE YEAR(order_date) = 2024;

-- Orders per month
SELECT
    MONTH(order_date)     AS month,
    MONTHNAME(order_date) AS month_name,
    COUNT(*)              AS total_orders
FROM orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month;


-- ─────────────────────────────────────
-- EXTRACT — cleaner date part extraction
-- ─────────────────────────────────────
SELECT
    order_date,
    EXTRACT(YEAR    FROM order_date) AS yr,
    EXTRACT(MONTH   FROM order_date) AS mo,
    EXTRACT(DAY     FROM order_date) AS dy,
    EXTRACT(QUARTER FROM order_date) AS quarter,
    EXTRACT(WEEK    FROM order_date) AS week_num
FROM orders LIMIT 5;

-- Orders per quarter
SELECT
    EXTRACT(QUARTER FROM order_date) AS quarter,
    COUNT(*) AS total_orders
FROM orders
GROUP BY EXTRACT(QUARTER FROM order_date)
ORDER BY quarter;


-- ─────────────────────────────────────
-- DATE_FORMAT — format dates for display
-- ─────────────────────────────────────

-- Common format codes:
-- %Y → 4-digit year      (2024)
-- %y → 2-digit year      (24)
-- %M → full month name   (January)
-- %b → short month name  (Jan)
-- %m → month number      (01)
-- %d → day number        (05)
-- %D → day with suffix   (5th)
-- %W → weekday name      (Monday)

SELECT
    order_date,
    DATE_FORMAT(order_date, '%d %M %Y')   AS formatted,
    DATE_FORMAT(order_date, '%M %Y')      AS month_year,
    DATE_FORMAT(order_date, '%d-%m-%Y')   AS indian_format,
    DATE_FORMAT(order_date, '%W, %d %b')  AS day_short
FROM orders LIMIT 5;


-- ─────────────────────────────────────
-- DATEDIFF — days between two dates
-- DATEDIFF(end_date, start_date)
-- ─────────────────────────────────────
SELECT DATEDIFF('2024-04-30', '2024-01-01') AS days;   -- 120

SELECT
    order_id,
    order_date,
    DATEDIFF(CURDATE(), order_date) AS days_since_order
FROM orders
ORDER BY days_since_order
LIMIT 5;

-- Orders placed in last 90 days
SELECT * FROM orders
WHERE DATEDIFF(CURDATE(), order_date) <= 90;


-- ─────────────────────────────────────
-- DATE_ADD & DATE_SUB
-- ─────────────────────────────────────
-- Intervals: DAY, WEEK, MONTH, YEAR, HOUR, MINUTE

SELECT DATE_ADD('2024-01-05', INTERVAL 30  DAY)   AS delivery_date;
SELECT DATE_ADD('2024-01-05', INTERVAL 3   MONTH) AS three_months;
SELECT DATE_SUB(CURDATE(),    INTERVAL 7   DAY)   AS one_week_ago;
SELECT DATE_SUB(CURDATE(),    INTERVAL 1   YEAR)  AS one_year_ago;

-- Add 30 days to order date — estimated delivery
SELECT
    order_id,
    order_date,
    DATE_ADD(order_date, INTERVAL 30 DAY) AS estimated_delivery
FROM orders LIMIT 5;

-- Orders from last 30 days
SELECT * FROM orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);


-- ─────────────────────────────────────
-- TIMESTAMPDIFF — difference in any unit
-- TIMESTAMPDIFF(unit, start, end)
-- ─────────────────────────────────────
SELECT TIMESTAMPDIFF(DAY,   '2024-01-01', '2024-04-30') AS days;
SELECT TIMESTAMPDIFF(MONTH, '2024-01-01', '2024-04-30') AS months;
SELECT TIMESTAMPDIFF(YEAR,  '2000-06-15', CURDATE())    AS age;

-- How old is each order in months?
SELECT
    order_id,
    order_date,
    TIMESTAMPDIFF(MONTH, order_date, CURDATE()) AS months_old
FROM orders
ORDER BY months_old DESC
LIMIT 5;


-- ─────────────────────────────────────
-- COMBINING STRING + DATE FUNCTIONS
-- ─────────────────────────────────────

SELECT
    CONCAT(c.first_name, ' ', c.last_name)       AS customer,
    DATE_FORMAT(o.order_date, '%d %M %Y')         AS order_on,
    DATEDIFF(CURDATE(), o.order_date)             AS days_ago,
    UPPER(o.status)                               AS status
FROM   orders    o
JOIN   customers c ON o.customer_id = c.customer_id
ORDER  BY days_ago ASC
LIMIT 10;
-- Note: JOINs covered fully in Ep.07
