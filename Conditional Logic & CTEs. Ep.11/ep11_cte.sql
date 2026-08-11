-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 11 | Conditional Logic and CTEs
-- Topic: CTEs — Common Table Expressions
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- WHAT IS A CTE?
-- A named temporary result set defined before the main query
-- Write once — use in the query below
-- Cleaner and more readable than subqueries
--
-- SYNTAX:
-- WITH cte_name AS (
--   SELECT ...
-- )
-- SELECT ... FROM cte_name;
-- ─────────────────────────────────────

-- Basic CTE — customers with more than 3 orders
WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS total_orders
    FROM   orders
    GROUP BY customer_id
)
SELECT
    c.first_name,
    c.last_name,
    oc.total_orders
FROM customers c
JOIN order_counts oc ON c.customer_id = oc.customer_id
WHERE oc.total_orders > 3
ORDER BY oc.total_orders DESC;

-- CTE vs Subquery — same result, CTE is cleaner
-- Subquery version (harder to read):
SELECT c.first_name, c.last_name, sub.total_orders
FROM customers c
JOIN (
    SELECT customer_id, COUNT(*) AS total_orders
    FROM   orders GROUP BY customer_id
) sub ON c.customer_id = sub.customer_id
WHERE sub.total_orders > 3
ORDER BY sub.total_orders DESC;

-- CTE with CASE — label then filter
WITH product_tiers AS (
    SELECT
        product_name,
        category,
        price,
        CASE
            WHEN price >= 50000 THEN 'Premium'
            WHEN price >= 10000 THEN 'Mid-Range'
            ELSE                     'Budget'
        END AS price_tier
    FROM products
)
SELECT * FROM product_tiers
WHERE price_tier = 'Premium'
ORDER BY price DESC;

-- Multiple CTEs — chained together
WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS total_orders
    FROM   orders
    GROUP BY customer_id
),
top_customers AS (
    SELECT customer_id, total_orders
    FROM   order_counts
    WHERE  total_orders > 3
)
SELECT
    c.first_name,
    c.last_name,
    c.city,
    tc.total_orders
FROM customers c
JOIN top_customers tc ON c.customer_id = tc.customer_id
ORDER BY tc.total_orders DESC;

-- CTE + Window Function — rank customers by orders
WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS total_orders
    FROM   orders
    GROUP BY customer_id
),
ranked AS (
    SELECT
        customer_id,
        total_orders,
        RANK() OVER (ORDER BY total_orders DESC) AS rnk
    FROM order_counts
)
SELECT
    c.first_name,
    c.last_name,
    r.total_orders,
    r.rnk
FROM customers c
JOIN ranked r ON c.customer_id = r.customer_id
WHERE r.rnk <= 5;
