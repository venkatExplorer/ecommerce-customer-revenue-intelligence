-- ============================================================
-- E-Commerce Customer & Revenue Intelligence Platform
-- Sales Analysis
-- ============================================================


-- ============================================================
-- 1. Overall Sales Performance
-- ============================================================

SELECT
    SUM(line_amount) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT seller_id) AS total_sellers,
    SUM(quantity) AS total_quantity
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`;


-- ============================================================
-- 2. Monthly Sales Trend
-- ============================================================

SELECT
    DATE_TRUNC(order_date, MONTH) AS sales_month,
    SUM(line_amount) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY sales_month
ORDER BY sales_month;


-- ============================================================
-- 3. Sales by Category
-- ============================================================

SELECT
    category,
    SUM(line_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY category
ORDER BY total_sales DESC;


-- ============================================================
-- 4. Sales by State
-- ============================================================

SELECT
    state,
    SUM(line_amount) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY state
ORDER BY total_sales DESC;


-- ============================================================
-- 5. Sales by Customer Segment
-- ============================================================

SELECT
    customer_segment,
    SUM(line_amount) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY customer_segment
ORDER BY total_sales DESC;


-- ============================================================
-- 6. Top Products by Sales
-- ============================================================

SELECT
    product_id,
    product_name,
    category,
    brand,
    SUM(line_amount) AS total_sales,
    SUM(quantity) AS total_quantity
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY
    product_id,
    product_name,
    category,
    brand
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 7. Customer Sales Ranking
-- ============================================================

WITH customer_sales AS (

    SELECT
        customer_id,
        first_name,
        state,
        customer_segment,
        SUM(line_amount) AS total_sales
    FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
    GROUP BY
        customer_id,
        first_name,
        state,
        customer_segment
)

SELECT
    customer_id,
    first_name,
    state,
    customer_segment,
    total_sales,
    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_sales
ORDER BY sales_rank
LIMIT 20;


-- ============================================================
-- 8. Category Revenue Contribution
-- ============================================================

WITH category_sales AS (

    SELECT
        category,
        SUM(line_amount) AS total_sales
    FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
    GROUP BY category
)

SELECT
    category,
    total_sales,
    ROUND(
        total_sales * 100.0 /
        SUM(total_sales) OVER (),
        2
    ) AS sales_contribution_pct
FROM category_sales
ORDER BY total_sales DESC;


-- ============================================================
-- 9. Average Order Value by Customer Segment
-- ============================================================

SELECT
    customer_segment,
    AVG(order_value) AS average_order_value,
    COUNT(DISTINCT order_id) AS total_orders
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY customer_segment
ORDER BY average_order_value DESC;


-- ============================================================
-- 10. Category and State Performance
-- ============================================================

SELECT
    category,
    state,
    SUM(line_amount) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY
    category,
    state
ORDER BY total_sales DESC;
