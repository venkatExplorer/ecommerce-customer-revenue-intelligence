-- ============================================================
-- E-Commerce Customer & Revenue Intelligence Platform
-- Operational Analysis
-- ============================================================


-- ============================================================
-- 1. Order Status Distribution
-- ============================================================

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(line_amount) AS total_sales
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY order_status
ORDER BY total_orders DESC;


-- ============================================================
-- 2. Orders by Payment Method
-- ============================================================

SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(line_amount) AS total_sales
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY payment_method
ORDER BY total_orders DESC;


-- ============================================================
-- 3. Seller Performance
-- ============================================================

SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    SUM(line_amount) AS total_sales
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY seller_id
ORDER BY total_sales DESC
LIMIT 20;


-- ============================================================
-- 4. Monthly Order Status Analysis
-- ============================================================

SELECT
    DATE_TRUNC(order_date, MONTH) AS order_month,
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(line_amount) AS total_sales
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY
    order_month,
    order_status
ORDER BY
    order_month,
    total_orders DESC;


-- ============================================================
-- 5. State-Level Order Status
-- ============================================================

SELECT
    state,
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(line_amount) AS total_sales
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY
    state,
    order_status
ORDER BY
    state,
    total_orders DESC;


-- ============================================================
-- 6. Seller Revenue Ranking
-- ============================================================

WITH seller_sales AS (

    SELECT
        seller_id,
        SUM(line_amount) AS total_sales,
        COUNT(DISTINCT order_id) AS total_orders
    FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
    GROUP BY seller_id
)

SELECT
    seller_id,
    total_sales,
    total_orders,
    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS seller_rank
FROM seller_sales
ORDER BY seller_rank
LIMIT 50;


-- ============================================================
-- 7. Quantity and Revenue by Category
-- ============================================================

SELECT
    category,
    SUM(quantity) AS total_quantity,
    SUM(line_amount) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY category
ORDER BY total_quantity DESC;


-- ============================================================
-- 8. Daily Order Activity
-- ============================================================

SELECT
    order_date,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(line_amount) AS total_sales,
    SUM(quantity) AS total_quantity
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY order_date
ORDER BY order_date;
