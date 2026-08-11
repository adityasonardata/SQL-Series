-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 10 | Advanced SQL — Window Functions
-- Topic: Window Function Basics + OVER clause
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- WHAT IS A WINDOW FUNCTION?
-- Performs a calculation across a set of rows
-- WITHOUT collapsing them into one row
-- Key difference from GROUP BY:
--   GROUP BY → reduces rows (1 row per group)
--   WINDOW   → keeps all rows + adds a new column
-- ─────────────────────────────────────

-- GROUP BY — collapses rows
SELECT   city, COUNT(*) AS total
FROM     customers
GROUP BY city;
-- Returns 1 row per city

-- WINDOW FUNCTION — keeps all rows
SELECT
    first_name,
    city,
    COUNT(*) OVER (PARTITION BY city) AS city_total
FROM customers;
-- Returns ALL customers + their city count alongside

-- ─────────────────────────────────────
-- SYNTAX
-- function_name() OVER (
--   PARTITION BY col   -- optional: divide into groups
--   ORDER BY col       -- optional: sort within window
-- )
-- ─────────────────────────────────────

-- Running total of orders by date
SELECT
    order_id,
    order_date,
    quantity,
    SUM(quantity) OVER (ORDER BY order_date) AS running_total
FROM orders
ORDER BY order_date;

-- Running total RESET per customer (PARTITION BY)
SELECT
    customer_id,
    order_id,
    order_date,
    quantity,
    SUM(quantity) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS customer_running_total
FROM orders
ORDER BY customer_id, order_date;

-- Average price per category using window
SELECT
    product_name,
    category,
    price,
    ROUND(AVG(price) OVER (PARTITION BY category), 2) AS category_avg,
    price - ROUND(AVG(price) OVER (PARTITION BY category), 2) AS diff_from_avg
FROM products
ORDER BY category, price DESC;
