-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 10 | Advanced SQL — Window Functions
-- Topic: LEAD & LAG
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- LEAD — look at the NEXT row's value
-- LAG  — look at the PREVIOUS row's value
--
-- LEAD(column, offset, default)
-- LAG(column,  offset, default)
--   offset  → how many rows to look (default 1)
--   default → what to return if no row exists
-- ─────────────────────────────────────

-- ─────────────────────────────────────
-- LAG — most common use: previous value comparison
-- ─────────────────────────────────────

-- Each order + the previous order date for same customer
SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS prev_order_date
FROM orders
ORDER BY customer_id, order_date;

-- Days between consecutive orders per customer
SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS prev_order_date,
    DATEDIFF(
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        )
    ) AS days_since_last_order
FROM orders
ORDER BY customer_id, order_date;

-- Month-over-month order count comparison
SELECT
    MONTH(order_date)     AS order_month,
    COUNT(*)              AS total_orders,
    LAG(COUNT(*)) OVER (
        ORDER BY MONTH(order_date)
    )                     AS prev_month_orders,
    COUNT(*) - LAG(COUNT(*)) OVER (
        ORDER BY MONTH(order_date)
    )                     AS mom_change
FROM orders
GROUP BY MONTH(order_date)
ORDER BY order_month;

-- ─────────────────────────────────────
-- LEAD — look ahead at next row
-- ─────────────────────────────────────

-- Each order + the NEXT order date for same customer
SELECT
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS next_order_date
FROM orders
ORDER BY customer_id, order_date;

-- Time until next order (days)
SELECT
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS next_order_date,
    DATEDIFF(
        LEAD(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ),
        order_date
    ) AS days_to_next_order
FROM orders
ORDER BY customer_id, order_date;

-- ─────────────────────────────────────
-- LEAD/LAG with OFFSET and DEFAULT
-- ─────────────────────────────────────

-- Look back 2 orders (offset = 2)
SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date, 2, 'No previous') OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS two_orders_ago
FROM orders
ORDER BY customer_id, order_date;

-- ─────────────────────────────────────
-- Price change detection using LAG
-- ─────────────────────────────────────

-- Compare each product price to category average
-- (using a simple ordering by price)
SELECT
    product_name,
    category,
    price,
    LAG(price) OVER (
        PARTITION BY category
        ORDER BY price DESC
    ) AS prev_price_in_category,
    price - LAG(price) OVER (
        PARTITION BY category
        ORDER BY price DESC
    ) AS price_diff
FROM products
ORDER BY category, price DESC;
