-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 09 | Deep Dive into Subqueries
-- Topic: Correlated Subqueries
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- CORRELATED SUBQUERY
-- References a column from the outer query
-- Runs ONCE PER ROW in the outer query
-- More flexible — but slower than regular subqueries
-- ─────────────────────────────────────

-- Each customer + their personal order count
SELECT
    c.first_name,
    c.last_name,
    (SELECT COUNT(*)
     FROM   orders o
     WHERE  o.customer_id = c.customer_id) AS total_orders
FROM customers c
ORDER BY total_orders DESC;

-- Each product + how many times it was ordered
SELECT
    p.product_name,
    p.price,
    (SELECT SUM(o.quantity)
     FROM   orders o
     WHERE  o.product_id = p.product_id) AS total_sold
FROM products p
ORDER BY total_sold DESC;

-- ─────────────────────────────────────
-- Find rows where value is above the
-- group average — classic correlated pattern
-- ─────────────────────────────────────

-- Products priced above their OWN category average
SELECT
    p1.product_name,
    p1.category,
    p1.price,
    ROUND((SELECT AVG(p2.price)
           FROM   products p2
           WHERE  p2.category = p1.category), 2) AS category_avg
FROM products p1
WHERE p1.price > (
    SELECT AVG(p2.price)
    FROM   products p2
    WHERE  p2.category = p1.category
)
ORDER BY p1.category, p1.price DESC;

-- ─────────────────────────────────────
-- Correlated subquery with EXISTS
-- ─────────────────────────────────────

-- Customers who ordered EVERY product in Electronics
-- (customers who have at least 3 Electronics orders)
SELECT c.first_name, c.last_name
FROM   customers c
WHERE  (
    SELECT COUNT(DISTINCT p.product_id)
    FROM   orders   o
    JOIN   products p ON o.product_id = p.product_id
    WHERE  o.customer_id = c.customer_id
    AND    p.category = 'Electronics'
) >= 2;

-- ─────────────────────────────────────
-- Most recent order per customer
-- ─────────────────────────────────────
SELECT
    c.first_name,
    c.last_name,
    o.order_date AS latest_order,
    o.status
FROM   customers c
JOIN   orders o ON c.customer_id = o.customer_id
WHERE  o.order_date = (
    SELECT MAX(o2.order_date)
    FROM   orders o2
    WHERE  o2.customer_id = c.customer_id
)
ORDER BY latest_order DESC;

-- ─────────────────────────────────────
-- Correlated vs JOIN — performance note
-- The correlated version above can be rewritten
-- with GROUP BY + JOIN for better performance:
-- ─────────────────────────────────────

SELECT
    c.first_name,
    c.last_name,
    MAX(o.order_date) AS latest_order
FROM   customers c
JOIN   orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY latest_order DESC;

-- Both return same result — JOIN version is faster
-- Use correlated subqueries when JOIN isn't possible
