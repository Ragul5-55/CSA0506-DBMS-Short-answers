-- connection: 6adc5d380f807b08919fd13d

-- ============================================================
-- RELATIONAL ALGEBRA OPERATIONS ON EMPLOYEE & DEPARTMENT
-- ============================================================
-- Relations:
--   EMPLOYEE(Emp_ID, Emp_Name, Salary, Dept_ID)
--   DEPARTMENT(Dept_ID, Dept_Name, Location)
--
-- Operations Demonstrated:
--   1. Selection (σ)       — Filter rows by condition
--   2. Projection (π)      — Select specific columns
--   3. Union (∪)           — Combine results of two queries
--   4. Set Difference (−)  — Rows in one query but NOT another
--   5. Cartesian Product (×) — All possible row combinations
--   6. Join (⋈)            — Related employee–department info
-- ============================================================

-- ============================================================
-- SAMPLE DATA (using CTEs to define the relations)
-- ============================================================
WITH

-- EMPLOYEE(Emp_ID, Emp_Name, Salary, Dept_ID)
EMPLOYEE AS (
    SELECT 1 AS Emp_ID, 'Alice Johnson'   AS Emp_Name, 75000  AS Salary, 10 AS Dept_ID
    UNION ALL SELECT 2, 'Bob Smith',        62000,  20
    UNION ALL SELECT 3, 'Carol Williams',   88000,  10
    UNION ALL SELECT 4, 'David Brown',      55000,  30
    UNION ALL SELECT 5, 'Eva Martinez',     92000,  20
    UNION ALL SELECT 6, 'Frank Lee',        70000,  10
    UNION ALL SELECT 7, 'Grace Kim',        68000,  30
    UNION ALL SELECT 8, 'Henry Davis',      81000,  40
),

-- DEPARTMENT(Dept_ID, Dept_Name, Location)
DEPARTMENT AS (
    SELECT 10 AS Dept_ID, 'Engineering'     AS Dept_Name, 'New York'    AS Location
    UNION ALL SELECT 20, 'Marketing',       'Chicago'
    UNION ALL SELECT 30, 'Finance',         'Houston'
    UNION ALL SELECT 40, 'Human Resources', 'Los Angeles'
)

-- ============================================================
-- OPERATION 1: SELECTION (σ)
-- Relational Algebra: σ_{Dept_ID = 10}(EMPLOYEE)
-- SQL Equivalent:     SELECT * FROM EMPLOYEE WHERE Dept_ID = 10
-- Purpose: Retrieve employees belonging to Department 10 (Engineering)
-- ============================================================
SELECT 'SELECTION' AS operation,
       E.Emp_ID,
       E.Emp_Name,
       E.Salary,
       E.Dept_ID,
       NULL::VARCHAR AS dept_name,
       NULL::VARCHAR AS location
FROM EMPLOYEE E
WHERE E.Dept_ID = 10

UNION ALL

-- ============================================================
-- OPERATION 2: PROJECTION (π)
-- Relational Algebra: π_{Dept_ID, Dept_Name, Location}(DEPARTMENT)
-- SQL Equivalent:     SELECT Dept_ID, Dept_Name, Location FROM DEPARTMENT
-- Purpose: Retrieve only specific columns from department
-- ============================================================
SELECT 'PROJECTION' AS operation,
       D.Dept_ID,
       D.Dept_Name,
       NULL::INT,
       NULL::INT,
       D.Dept_Name,
       D.Location
FROM DEPARTMENT D

UNION ALL

-- ============================================================
-- OPERATION 3: UNION (∪)
-- Relational Algebra: σ_{Dept_ID=10}(EMPLOYEE) ∪ σ_{Dept_ID=20}(EMPLOYEE)
-- SQL Equivalent:     UNION of two SELECT queries
-- Purpose: Combine employees from Engineering AND Marketing departments
-- ============================================================
SELECT 'UNION' AS operation,
       E.Emp_ID,
       E.Emp_Name,
       E.Salary,
       E.Dept_ID,
       NULL::VARCHAR,
       NULL::VARCHAR
FROM EMPLOYEE E
WHERE E.Dept_ID = 10

UNION ALL

SELECT 'UNION' AS operation,
       E.Emp_ID,
       E.Emp_Name,
       E.Salary,
       E.Dept_ID,
       NULL::VARCHAR,
       NULL::VARCHAR
FROM EMPLOYEE E
WHERE E.Dept_ID = 20

UNION ALL

-- ============================================================
-- OPERATION 4: SET DIFFERENCE (−)
-- Relational Algebra: EMPLOYEE − σ_{Dept_ID=30}(EMPLOYEE)
-- SQL Equivalent:     EXCEPT (PostgreSQL set difference operator)
-- Purpose: Employees who are NOT in the Finance department
-- ============================================================
SELECT 'SET_DIFF' AS operation,
       E.Emp_ID,
       E.Emp_Name,
       E.Salary,
       E.Dept_ID,
       NULL::VARCHAR,
       NULL::VARCHAR
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT 30 AS Dept_ID) FINANCE
    WHERE E.Dept_ID = FINANCE.Dept_ID
)

UNION ALL

-- ============================================================
-- OPERATION 5: CARTESIAN PRODUCT (×)
-- Relational Algebra: EMPLOYEE × DEPARTMENT
-- SQL Equivalent:     CROSS JOIN
-- Purpose: All possible employee–department combinations (8 × 4 = 32 rows)
-- ============================================================
SELECT 'CARTESIAN' AS operation,
       E.Emp_ID,
       E.Emp_Name || ' x ' || D.Dept_Name,
       E.Salary,
       D.Dept_ID,
       D.Dept_Name,
       D.Location
FROM EMPLOYEE E
CROSS JOIN DEPARTMENT D

UNION ALL

-- ============================================================
-- OPERATION 6: JOIN (⋈)
-- Relational Algebra: EMPLOYEE ⋈_{EMP.Dept_ID = DEPT.Dept_ID} DEPARTMENT
-- SQL Equivalent:     INNER JOIN ... ON ...
-- Purpose: Retrieve complete employee–department matched information
-- ============================================================
SELECT 'JOIN' AS operation,
       E.Emp_ID,
       E.Emp_Name,
       E.Salary,
       E.Dept_ID,
       D.Dept_Name,
       D.Location
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.Dept_ID = D.Dept_ID

ORDER BY operation, Emp_ID;
