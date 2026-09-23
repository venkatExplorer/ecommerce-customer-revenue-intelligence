-- ============================================================
-- E-Commerce Customer & Revenue Intelligence Platform
-- Customer Analysis
-- ============================================================


-- ============================================================
-- 1. Customer Revenue
-- ============================================================

SELECT
    customer_id,
    first_name,
    city,
    state,
    customer_segment,
    SUM(line_amount) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY
    customer_id,
    first_name,
    city,
    state,
    customer_segment
ORDER BY total_sales DESC;


-- ============================================================
-- 2. Top 20 Customers by Revenue
-- ============================================================

SELECT
    customer_id,
    first_name,
    state,
    customer_segment,
    SUM(line_amount) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY
    customer_id,
    first_name,
    state,
    customer_segment
ORDER BY total_sales DESC
LIMIT 20;


-- ============================================================
-- 3. Customer Segment Performance
-- ============================================================

SELECT
    customer_segment,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    SUM(line_amount) AS total_sales,
    AVG(order_value) AS average_order_value
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY customer_segment
ORDER BY total_sales DESC;


-- ============================================================
-- 4. Customer Revenue Ranking
-- ============================================================

WITH customer_revenue AS (

    SELECT
        customer_id,
        first_name,
        customer_segment,
        SUM(line_amount) AS total_sales
    FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
    GROUP BY
        customer_id,
        first_name,
        customer_segment
)

SELECT
    customer_id,
    first_name,
    customer_segment,
    total_sales,
    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS customer_rank
FROM customer_revenue
ORDER BY customer_rank
LIMIT 50;


-- ============================================================
-- 5. Customer Orders by State
-- ============================================================

SELECT
    state,
    customer_segment,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    SUM(line_amount) AS total_sales
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY
    state,
    customer_segment
ORDER BY
    state,
    total_sales DESC;


-- ============================================================
-- 6. Average Order Value by Customer Segment
-- ============================================================

WITH order_level AS (

    SELECT
        order_id,
        customer_id,
        customer_segment,
        MAX(order_value) AS order_value
    FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
    GROUP BY
        order_id,
        customer_id,
        customer_segment
)

SELECT
    customer_segment,
    COUNT(*) AS total_orders,
    AVG(order_value) AS average_order_value,
    MIN(order_value) AS minimum_order_value,
    MAX(order_value) AS maximum_order_value
FROM order_level
GROUP BY customer_segment
ORDER BY average_order_value DESC;


-- ============================================================
-- 7. Customer Purchase Frequency
-- ============================================================

WITH customer_orders AS (

    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
    GROUP BY customer_id
)

SELECT
    order_count,
    COUNT(*) AS number_of_customers
FROM customer_orders
GROUP BY order_count
ORDER BY order_count;


-- ============================================================
-- 8. Monthly Customer Activity
-- ============================================================

SELECT
    DATE_TRUNC(order_date, MONTH) AS sales_month,
    COUNT(DISTINCT customer_id) AS active_customers,
    COUNT(DISTINCT order_id) AS orders,
    SUM(line_amount) AS total_sales
FROM `scaler-dsml-sql-463716.dbt_bvenkat.mart_sales_performance`
GROUP BY sales_month
ORDER BY sales_month;
