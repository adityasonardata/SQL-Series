-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 08 | SQL Joins Mastery
-- Topic: Multi-Table JOINs
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- 3-TABLE JOIN — customers + orders + products
-- Always alias every table
-- Always prefix every column with alias
-- ─────────────────────────────────────

SELECT
    c.first_name,
    c.last_name,
    c.city,
    p.product_name,
    p.category,
    p.price,
    o.quantity,
    o.order_date,
    o.status
FROM   customers c
INNER JOIN orders   o ON c.customer_id = o.customer_id
INNER JOIN products p ON o.product_id  = p.product_id
ORDER BY o.order_date DESC;

-- ─────────────────────────────────────
-- 3-TABLE JOIN + WHERE
-- ─────────────────────────────────────

-- All delivered Electronics orders
SELECT
    c.first_name,
    p.product_name,
    p.category,
    o.quantity,
    o.status
FROM   customers c
INNER JOIN orders   o ON c.customer_id = o.customer_id
INNER JOIN products p ON o.product_id  = p.product_id
WHERE  o.status    = 'Delivered'
AND    p.category  = 'Electronics'
ORDER BY c.first_name;

-- ─────────────────────────────────────
-- 3-TABLE JOIN + GROUP BY
-- ─────────────────────────────────────

-- Total quantity sold per product with category
SELECT
    p.product_name,
    p.category,
    COUNT(o.order_id)  AS times_ordered,
    SUM(o.quantity)    AS total_qty_sold,
    ROUND(p.price * SUM(o.quantity), 2) AS total_revenue
FROM   products p
INNER JOIN orders   o ON p.product_id  = o.product_id
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY p.product_id, p.product_name, p.category, p.price
ORDER BY total_qty_sold DESC;

-- Total orders + total items per customer + city
SELECT
    c.first_name,
    c.last_name,
    c.city,
    COUNT(o.order_id)  AS total_orders,
    SUM(o.quantity)    AS total_items
FROM   customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_orders DESC
LIMIT 10;

-- ─────────────────────────────────────
-- 3-TABLE JOIN + GROUP BY + HAVING
-- ─────────────────────────────────────

-- Customers who ordered more than 3 times
SELECT
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM   customers c
INNER JOIN orders   o ON c.customer_id = o.customer_id
INNER JOIN products p ON o.product_id  = p.product_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 3
ORDER BY total_orders DESC;
