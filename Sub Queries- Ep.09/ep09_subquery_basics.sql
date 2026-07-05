-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 09 | Deep Dive into Subqueries
-- Topic: Subquery Basics — WHERE, SELECT, FROM
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- WHAT IS A SUBQUERY?
-- A SELECT statement nested inside another SQL statement
-- Subquery runs FIRST — result passed to outer query
-- Must be wrapped in parentheses ( )
-- ─────────────────────────────────────

-- ════════════════════════════════════════
-- SUBQUERY IN WHERE — most common use
-- Filter rows based on a subquery result
-- ════════════════════════════════════════

-- Products priced above average
SELECT product_name, price
FROM   products
WHERE  price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- Products priced below average
SELECT product_name, price
FROM   products
WHERE  price < (SELECT AVG(price) FROM products)
ORDER BY price;

-- Customers who placed orders in January 2024
SELECT first_name, last_name, email
FROM   customers
WHERE  customer_id IN (
    SELECT customer_id
    FROM   orders
    WHERE  MONTH(order_date) = 1
    AND    YEAR(order_date)  = 2024
);

-- Most expensive product in Electronics
SELECT product_name, price
FROM   products
WHERE  price = (
    SELECT MAX(price)
    FROM   products
    WHERE  category = 'Electronics'
);

-- Orders with quantity above average
SELECT order_id, customer_id, quantity
FROM   orders
WHERE  quantity > (SELECT AVG(quantity) FROM orders)
ORDER BY quantity DESC;


-- ════════════════════════════════════════
-- SUBQUERY IN SELECT — scalar subquery
-- Returns one value per row
-- ════════════════════════════════════════

-- Each product + overall avg price for comparison
SELECT
    product_name,
    price,
    (SELECT ROUND(AVG(price), 2) FROM products) AS overall_avg,
    price - (SELECT ROUND(AVG(price), 2) FROM products) AS diff_from_avg
FROM products
ORDER BY diff_from_avg DESC;

-- Each customer + their total order count
SELECT
    first_name,
    last_name,
    (SELECT COUNT(*)
     FROM   orders o
     WHERE  o.customer_id = c.customer_id) AS total_orders
FROM customers c
ORDER BY total_orders DESC;


-- ════════════════════════════════════════
-- SUBQUERY IN FROM — derived table
-- Subquery used as a temporary table
-- Must always give it an alias
-- ════════════════════════════════════════

-- Average orders per city using a derived table
SELECT
    city,
    total_customers,
    ROUND(total_customers / (SELECT COUNT(*) FROM customers) * 100, 1) AS pct
FROM (
    SELECT city, COUNT(*) AS total_customers
    FROM   customers
    WHERE  city IS NOT NULL
    GROUP BY city
) AS city_summary
ORDER BY total_customers DESC;

-- Top 3 most ordered products using derived table
SELECT product_id, total_sold
FROM (
    SELECT   product_id, SUM(quantity) AS total_sold
    FROM     orders
    GROUP BY product_id
    ORDER BY total_sold DESC
    LIMIT 3
) AS top_products;


-- ════════════════════════════════════════
-- SUBQUERY IN HAVING
-- Filter groups based on a subquery result
-- ════════════════════════════════════════

-- Cities with more customers than the average city size
SELECT city, COUNT(*) AS total
FROM   customers
WHERE  city IS NOT NULL
GROUP BY city
HAVING COUNT(*) > (
    SELECT AVG(city_count)
    FROM (
        SELECT COUNT(*) AS city_count
        FROM   customers
        WHERE  city IS NOT NULL
        GROUP BY city
    ) AS avg_calc
)
ORDER BY total DESC;
