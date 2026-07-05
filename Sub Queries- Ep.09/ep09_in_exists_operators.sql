-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 09 | Deep Dive into Subqueries
-- Topic: IN, NOT IN, EXISTS, NOT EXISTS
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ════════════════════════════════════════
-- IN — value matches any in subquery list
-- ════════════════════════════════════════

-- Customers who placed at least one order
SELECT first_name, last_name
FROM   customers
WHERE  customer_id IN (
    SELECT DISTINCT customer_id FROM orders
)
ORDER BY first_name;

-- Customers who ordered Electronics products
SELECT DISTINCT c.first_name, c.last_name
FROM   customers c
WHERE  c.customer_id IN (
    SELECT o.customer_id
    FROM   orders   o
    JOIN   products p ON o.product_id = p.product_id
    WHERE  p.category = 'Electronics'
)
ORDER BY c.first_name;

-- Orders for products priced over ₹50,000
SELECT order_id, product_id, quantity
FROM   orders
WHERE  product_id IN (
    SELECT product_id
    FROM   products
    WHERE  price > 50000
)
ORDER BY order_id;


-- ════════════════════════════════════════
-- NOT IN — value NOT in subquery list
-- ⚠️ Be careful with NULLs in NOT IN
-- ════════════════════════════════════════

-- Customers who have NEVER placed an order
SELECT first_name, last_name
FROM   customers
WHERE  customer_id NOT IN (
    SELECT DISTINCT customer_id FROM orders
)
ORDER BY first_name;

-- Products that have never been ordered
SELECT product_name, category, price
FROM   products
WHERE  product_id NOT IN (
    SELECT DISTINCT product_id FROM orders
)
ORDER BY product_name;

-- ⚠️ NOT IN NULL trap
-- If subquery returns any NULL, NOT IN returns no rows at all
-- Always filter NULLs when using NOT IN:

SELECT first_name FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders
    WHERE  customer_id IS NOT NULL   -- ← always add this
);


-- ════════════════════════════════════════
-- EXISTS — true if subquery returns any rows
-- More efficient than IN for large datasets
-- Stops searching as soon as one match found
-- ════════════════════════════════════════

-- Customers who have placed at least one order
SELECT c.first_name, c.last_name
FROM   customers c
WHERE  EXISTS (
    SELECT 1
    FROM   orders o
    WHERE  o.customer_id = c.customer_id
)
ORDER BY c.first_name;

-- Note: SELECT 1 is a convention — we only care
-- whether any rows exist, not what columns they have

-- Customers who ordered a product over ₹50,000
SELECT c.first_name, c.last_name
FROM   customers c
WHERE  EXISTS (
    SELECT 1
    FROM   orders   o
    JOIN   products p ON o.product_id = p.product_id
    WHERE  o.customer_id = c.customer_id
    AND    p.price > 50000
)
ORDER BY c.first_name;


-- ════════════════════════════════════════
-- NOT EXISTS — true if subquery returns NO rows
-- ════════════════════════════════════════

-- Customers who have NEVER placed an order
SELECT c.first_name, c.last_name
FROM   customers c
WHERE  NOT EXISTS (
    SELECT 1
    FROM   orders o
    WHERE  o.customer_id = c.customer_id
)
ORDER BY c.first_name;

-- Products that have never been ordered
SELECT p.product_name, p.category
FROM   products p
WHERE  NOT EXISTS (
    SELECT 1
    FROM   orders o
    WHERE  o.product_id = p.product_id
)
ORDER BY p.product_name;


-- ════════════════════════════════════════
-- IN vs EXISTS — which to use?
-- ════════════════════════════════════════

-- Both return the same result — different performance:
-- IN      → fetches ALL matching values into memory first
-- EXISTS  → stops at first match — faster on large tables

-- Use IN when:    subquery list is small
-- Use EXISTS when: subquery result set is large
-- Use NOT EXISTS instead of NOT IN to avoid NULL issues
