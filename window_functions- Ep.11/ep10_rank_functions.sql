-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 10 | Advanced SQL — Window Functions
-- Topic: RANK, DENSE_RANK, ROW_NUMBER
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- THREE RANKING FUNCTIONS
-- All three assign a number to each row
-- They differ ONLY in how they handle TIES
--
-- ROW_NUMBER  → 1,2,3,4,5   always unique
-- RANK        → 1,2,2,4,5   gaps after ties
-- DENSE_RANK  → 1,2,2,3,4   no gaps after ties
-- ─────────────────────────────────────

-- All three side by side on products
SELECT
    product_name,
    category,
    price,
    ROW_NUMBER()  OVER (ORDER BY price DESC) AS row_num,
    RANK()        OVER (ORDER BY price DESC) AS rnk,
    DENSE_RANK()  OVER (ORDER BY price DESC) AS dense_rnk
FROM products
ORDER BY price DESC;

-- ─────────────────────────────────────
-- ROW_NUMBER — always unique
-- Good for: pagination, deduplication
-- ─────────────────────────────────────

-- Number all orders per customer chronologically
SELECT
    customer_id,
    order_id,
    order_date,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS order_sequence
FROM orders
ORDER BY customer_id, order_date;

-- Get each customer's FIRST order only
SELECT * FROM (
    SELECT
        customer_id,
        order_id,
        order_date,
        status,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date ASC
        ) AS rn
    FROM orders
) ranked
WHERE rn = 1
ORDER BY customer_id;

-- ─────────────────────────────────────
-- RANK — gaps after ties
-- Good for: leaderboards, sports rankings
-- ─────────────────────────────────────

-- Rank products by price within each category
SELECT
    product_name,
    category,
    price,
    RANK() OVER (
        PARTITION BY category
        ORDER BY price DESC
    ) AS price_rank
FROM products
ORDER BY category, price_rank;

-- Top 3 products per category
SELECT * FROM (
    SELECT
        product_name,
        category,
        price,
        RANK() OVER (
            PARTITION BY category
            ORDER BY price DESC
        ) AS price_rank
    FROM products
) ranked
WHERE price_rank <= 3
ORDER BY category, price_rank;

-- ─────────────────────────────────────
-- DENSE_RANK — no gaps after ties
-- Good for: medal tables, grade rankings
-- ─────────────────────────────────────

SELECT
    product_name,
    category,
    price,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY price DESC
    ) AS dense_rank_in_cat
FROM products
ORDER BY category, dense_rank_in_cat;

-- ─────────────────────────────────────
-- RANK vs DENSE_RANK — when does it matter?
-- ─────────────────────────────────────
-- If two products tie at rank 2:
-- RANK       → next product is rank 4 (skips 3)
-- DENSE_RANK → next product is rank 3 (no skip)
-- Use RANK for "positions" (sports, leaderboards)
-- Use DENSE_RANK for "levels" (grades, tiers)
