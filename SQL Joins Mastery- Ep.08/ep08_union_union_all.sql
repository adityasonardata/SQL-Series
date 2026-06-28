-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 08 | SQL Joins Mastery
-- Topic: UNION & UNION ALL
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- UNION — combine queries, remove duplicates
-- UNION ALL — combine queries, keep duplicates
-- Both SELECT statements must have:
--   → Same number of columns
--   → Same order
--   → Compatible data types
-- ─────────────────────────────────────

-- ─────────────────────────────────────
-- Basic UNION
-- ─────────────────────────────────────

-- Combine all cities from customers and a second table
-- (illustrative — using subsets)
SELECT first_name, city FROM customers WHERE city = 'Mumbai'
UNION
SELECT first_name, city FROM customers WHERE city = 'Pune'
ORDER BY city, first_name;

-- ─────────────────────────────────────
-- UNION to combine different queries
-- ─────────────────────────────────────

-- VIP customers (5+ orders) UNION new customers (1 order)
SELECT
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders,
    'VIP' AS customer_type
FROM   customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) >= 5

UNION

SELECT
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders,
    'New' AS customer_type
FROM   customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) = 1

ORDER BY customer_type, total_orders DESC;

-- ─────────────────────────────────────
-- UNION ALL — keeps duplicates
-- ─────────────────────────────────────
SELECT first_name, city FROM customers WHERE city = 'Mumbai'
UNION ALL
SELECT first_name, city FROM customers WHERE city = 'Mumbai'
ORDER BY first_name;
-- Returns Mumbai customers twice — UNION ALL keeps all rows

-- ─────────────────────────────────────
-- FULL OUTER JOIN workaround using UNION
-- ─────────────────────────────────────
SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.status
FROM   customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id

UNION

SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.status
FROM   customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id

ORDER BY customer_id;

-- ─────────────────────────────────────
-- UNION with ORDER BY and LIMIT
-- ORDER BY and LIMIT go at the very end
-- They apply to the entire combined result
-- ─────────────────────────────────────
SELECT first_name, 'Delivered' AS category FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'

UNION ALL

SELECT first_name, 'Pending' AS category FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Pending'

ORDER BY first_name
LIMIT 20;
