-- connection: 6adc5d380f807b08919fd13d
-- database: chinook

-- ============================================================
-- DBMS PROGRAM: GROUP BY, HAVING & AGGREGATE FUNCTIONS
-- ============================================================
-- Relation:
--   SALES(Sale_ID, Product_ID, Customer_ID, Quantity,
--         Unit_Price, Sale_Date)
--
-- Concepts Demonstrated:
--   1. GROUP BY        — Groups rows for aggregate computation
--   2. HAVING          — Filters groups (like WHERE for groups)
--   3. COUNT           — Counts rows in each group
--   4. SUM             — Adds numeric values in each group
--   5. AVG             — Computes average of numeric values
--   6. MAX             — Finds maximum value in each group
--   7. MIN             — Finds minimum value in each group
-- ============================================================


-- ============================================================
-- SECTION A: CREATE TABLE STATEMENT (Reference DDL)
-- ============================================================
-- On a writable database, you would run:
--
-- CREATE TABLE SALES (
--     Sale_ID      INTEGER       PRIMARY KEY,
--     Product_ID   INTEGER       NOT NULL,
--     Customer_ID  INTEGER       NOT NULL,
--     Quantity     INTEGER       NOT NULL CHECK (Quantity > 0),
--     Unit_Price   DECIMAL(10,2) NOT NULL CHECK (Unit_Price >= 0),
--     Sale_Date    DATE          NOT NULL
-- );
-- ============================================================


-- ============================================================
-- SECTION B: SAMPLE DATA (using CTE to simulate SALES table)
-- ============================================================
-- 15 sales records across 6 products, 10 customers, 5 months
-- ============================================================

WITH

SALES AS (
    -- Sale_ID, Product_ID, Customer_ID, Quantity, Unit_Price, Sale_Date
    SELECT  1 AS Sale_ID, 101 AS Product_ID, 501 AS Customer_ID,
            2 AS Quantity, 500.00  AS Unit_Price, DATE '2025-01-15' AS Sale_Date
    UNION ALL SELECT  2, 102, 502, 1, 1200.00, '2025-01-18'
    UNION ALL SELECT  3, 101, 503, 5, 500.00,  '2025-02-02'
    UNION ALL SELECT  4, 103, 501, 3, 300.00,  '2025-02-10'
    UNION ALL SELECT  5, 104, 504, 2, 750.00,  '2025-02-14'
    UNION ALL SELECT  6, 102, 505, 4, 1200.00, '2025-03-01'
    UNION ALL SELECT  7, 105, 502, 1, 2500.00, '2025-03-05'
    UNION ALL SELECT  8, 101, 506, 3, 500.00,  '2025-03-12'
    UNION ALL SELECT  9, 103, 503, 2, 300.00,  '2025-03-20'
    UNION ALL SELECT 10, 104, 507, 1, 750.00,  '2025-04-01'
    UNION ALL SELECT 11, 102, 501, 2, 1200.00, '2025-04-10'
    UNION ALL SELECT 12, 105, 508, 3, 2500.00, '2025-04-15'
    UNION ALL SELECT 13, 101, 504, 4, 500.00,  '2025-05-02'
    UNION ALL SELECT 14, 103, 509, 1, 300.00,  '2025-05-18'
    UNION ALL SELECT 15, 106, 510, 2, 150.00,  '2025-05-25'
)

-- ============================================================
-- Q1: PRODUCT-WISE SALES SUMMARY
-- Uses: GROUP BY Product_ID, COUNT, SUM
-- Purpose: For each product, show number of sales, total
--          quantity sold, and total revenue generated
-- ============================================================
SELECT
    'Q1' AS query_id,
    'Product-Wise Sales Summary' AS query_name,
    Product_ID::TEXT AS group_key,
    COUNT(*)::TEXT AS num_sales,
    SUM(Quantity)::TEXT AS total_qty,
    SUM(Quantity * Unit_Price)::TEXT AS total_revenue,
    '' AS extra1,
    '' AS extra2
FROM SALES
GROUP BY Product_ID

UNION ALL

-- ============================================================
-- Q2: HIGH-VALUE PRODUCTS (Revenue > 2000)
-- Uses: GROUP BY, HAVING, SUM
-- Purpose: Identify products whose total revenue exceeds 2000
--          HAVING filters groups AFTER aggregation
-- ============================================================
SELECT
    'Q2' AS query_id,
    'High-Value Products (Revenue > 2000)' AS query_name,
    Product_ID::TEXT AS group_key,
    COUNT(*)::TEXT AS num_sales,
    SUM(Quantity)::TEXT AS total_qty,
    SUM(Quantity * Unit_Price)::TEXT AS total_revenue,
    '' AS extra1,
    '' AS extra2
FROM SALES
GROUP BY Product_ID
HAVING SUM(Quantity * Unit_Price) > 2000

UNION ALL

-- ============================================================
-- Q3: MONTHLY SALES STATISTICS
-- Uses: GROUP BY (month), COUNT, SUM, AVG
-- Purpose: For each month, compute number of sales, total
--          quantity, and average sale value
-- ============================================================
SELECT
    'Q3' AS query_id,
    'Monthly Sales Statistics' AS query_name,
    TO_CHAR(Sale_Date, 'YYYY-MM') AS group_key,
    COUNT(*)::TEXT AS num_sales,
    SUM(Quantity)::TEXT AS total_qty,
    ROUND(AVG(Quantity * Unit_Price), 2)::TEXT AS avg_sale_value,
    '' AS extra1,
    '' AS extra2
FROM SALES
GROUP BY TO_CHAR(Sale_Date, 'YYYY-MM')

UNION ALL

-- ============================================================
-- Q4: PRODUCT PRICE ANALYSIS (MIN, MAX, AVG)
-- Uses: GROUP BY, MIN, MAX, AVG
-- Purpose: For each product, show minimum, maximum, and
--          average unit price across all its sales
-- ============================================================
SELECT
    'Q4' AS query_id,
    'Product Price Analysis (MIN/MAX/AVG)' AS query_name,
    Product_ID::TEXT AS group_key,
    MIN(Unit_Price)::TEXT AS min_price,
    MAX(Unit_Price)::TEXT AS max_price,
    ROUND(AVG(Unit_Price), 2)::TEXT AS avg_price,
    '' AS extra1,
    '' AS extra2
FROM SALES
GROUP BY Product_ID

UNION ALL

-- ============================================================
-- Q5: HIGH-ACTIVITY MONTHS (More than 3 sales)
-- Uses: GROUP BY, HAVING, COUNT
-- Purpose: Find months where the company recorded more than
--          3 sales transactions
-- ============================================================
SELECT
    'Q5' AS query_id,
    'High-Activity Months (> 3 sales)' AS query_name,
    TO_CHAR(Sale_Date, 'YYYY-MM') AS group_key,
    COUNT(*)::TEXT AS num_sales,
    SUM(Quantity)::TEXT AS total_qty,
    ROUND(AVG(Quantity * Unit_Price), 2)::TEXT AS avg_sale_value,
    '' AS extra1,
    '' AS extra2
FROM SALES
GROUP BY TO_CHAR(Sale_Date, 'YYYY-MM')
HAVING COUNT(*) > 3

UNION ALL

-- ============================================================
-- Q6: CUSTOMER-WISE SPENDING SUMMARY
-- Uses: GROUP BY, COUNT, SUM, MAX, MIN
-- Purpose: For each customer, show total orders, total spent,
--          largest and smallest single purchase
-- ============================================================
SELECT
    'Q6' AS query_id,
    'Customer-Wise Spending Summary' AS query_name,
    Customer_ID::TEXT AS group_key,
    COUNT(*)::TEXT AS num_orders,
    SUM(Quantity * Unit_Price)::TEXT AS total_spent,
    MAX(Quantity * Unit_Price)::TEXT AS largest_order,
    MIN(Quantity * Unit_Price)::TEXT AS smallest_order,
    '' AS extra2
FROM SALES
GROUP BY Customer_ID

UNION ALL

-- ============================================================
-- Q7: PRODUCTS WITH AVG REVENUE PER SALE > 1500
-- Uses: GROUP BY, HAVING, AVG
-- Purpose: Find products whose average revenue per sale
--          exceeds 1500 (premium products)
-- ============================================================
SELECT
    'Q7' AS query_id,
    'Premium Products (Avg Revenue/Sale > 1500)' AS query_name,
    Product_ID::TEXT AS group_key,
    COUNT(*)::TEXT AS num_sales,
    ROUND(AVG(Quantity * Unit_Price), 2)::TEXT AS avg_revenue,
    SUM(Quantity * Unit_Price)::TEXT AS total_revenue,
    '' AS extra1,
    '' AS extra2
FROM SALES
GROUP BY Product_ID
HAVING AVG(Quantity * Unit_Price) > 1500

UNION ALL

-- ============================================================
-- Q8: OVERALL SALES STATISTICS (No GROUP BY — full table)
-- Uses: COUNT, SUM, AVG, MAX, MIN (without GROUP BY)
-- Purpose: Show overall statistics for the entire SALES table
-- ============================================================
SELECT
    'Q8' AS query_id,
    'Overall Sales Statistics (Full Table)' AS query_name,
    'ALL' AS group_key,
    COUNT(*)::TEXT AS total_sales,
    SUM(Quantity * Unit_Price)::TEXT AS total_revenue,
    ROUND(AVG(Quantity * Unit_Price), 2)::TEXT AS avg_sale_value,
    MAX(Quantity * Unit_Price)::TEXT AS max_single_sale,
    MIN(Quantity * Unit_Price)::TEXT AS min_single_sale
FROM SALES

ORDER BY query_id, group_key;
