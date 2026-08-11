-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 11 | Conditional Logic and CTEs
-- Topic: CASE Statement
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- CASE STATEMENT
-- Adds conditional logic inside a SQL query
-- Like IF/ELSE but inside SELECT
--
-- SYNTAX:
-- CASE
--   WHEN condition1 THEN result1
--   WHEN condition2 THEN result2
--   ELSE default_result
-- END AS alias
-- ─────────────────────────────────────

-- Basic CASE — label products by price tier
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
ORDER BY price DESC;

-- CASE with GROUP BY — count products per tier
SELECT
    CASE
        WHEN price >= 50000 THEN 'Premium'
        WHEN price >= 10000 THEN 'Mid-Range'
        ELSE                     'Budget'
    END AS price_tier,
    COUNT(*) AS total_products
FROM products
GROUP BY price_tier
ORDER BY total_products DESC;

-- CASE on order status — friendlier labels
SELECT
    order_id,
    customer_id,
    order_date,
    status,
    CASE status
        WHEN 'Delivered'  THEN '✓ Complete'
        WHEN 'Shipped'    THEN '⟳ On the way'
        WHEN 'Processing' THEN '⚙ Being prepared'
        WHEN 'Pending'    THEN '⌛ Waiting'
        ELSE                   'Unknown'
    END AS status_label
FROM orders
ORDER BY order_date DESC
LIMIT 10;

-- CASE in ORDER BY — custom sort order
SELECT product_name, category, price
FROM products
ORDER BY
    CASE category
        WHEN 'Electronics' THEN 1
        WHEN 'Furniture'   THEN 2
        WHEN 'Books'       THEN 3
        ELSE                    4
    END,
    price DESC;
