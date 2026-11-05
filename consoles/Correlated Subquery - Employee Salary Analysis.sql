-- connection: 6adc5d380f807b08919fd13d
-- database: chinook

-- ============================================================
-- DBMS PROGRAM: CORRELATED SUBQUERY - EMPLOYEE SALARY ANALYSIS
-- ============================================================
-- Relation:
--   EMPLOYEE(Emp_ID, Emp_Name, Salary, Dept_ID)
--
-- Concept Demonstrated:
--   CORRELATED SUBQUERY — A subquery that references columns
--   from the outer query, making it dependent on the outer query.
--   The inner query executes once FOR EACH ROW of the outer query.
-- ============================================================


-- ============================================================
-- SECTION A: CREATE TABLE STATEMENT (Reference DDL)
-- ============================================================
-- On a writable database, you would run:
--
-- CREATE TABLE EMPLOYEE (
--     Emp_ID      INTEGER       PRIMARY KEY,
--     Emp_Name    VARCHAR(100)  NOT NULL,
--     Salary      DECIMAL(10,2) NOT NULL CHECK (Salary > 0),
--     Dept_ID     INTEGER       NOT NULL
-- );
-- ============================================================


-- ============================================================
-- SECTION B: SAMPLE DATA (using CTE to simulate EMPLOYEE table)
-- ============================================================
-- 12 employees across 4 departments with varying salaries
-- ============================================================

WITH

EMPLOYEE AS (
    SELECT 1001 AS Emp_ID, 'Alice Johnson'   AS Emp_Name, 75000  AS Salary, 10 AS Dept_ID
    UNION ALL SELECT 1002, 'Bob Smith',        62000,  20
    UNION ALL SELECT 1003, 'Carol Williams',   88000,  10
    UNION ALL SELECT 1004, 'David Brown',      55000,  30
    UNION ALL SELECT 1005, 'Eva Martinez',     92000,  20
    UNION ALL SELECT 1006, 'Frank Lee',        70000,  10
    UNION ALL SELECT 1007, 'Grace Kim',        68000,  30
    UNION ALL SELECT 1008, 'Henry Davis',      81000,  40
    UNION ALL SELECT 1009, 'Iris Chen',        72000,  20
    UNION ALL SELECT 1010, 'James Wilson',     58000,  30
    UNION ALL SELECT 1011, 'Karen Taylor',     95000,  10
    UNION ALL SELECT 1012, 'Leo Anderson',     85000,  40
)

-- ============================================================
-- QUERY 1: CORRELATED SUBQUERY
-- Employees earning MORE than their department's average
-- ============================================================
SELECT
    'Q1' AS query_id,
    'Employees Above Dept Average' AS query_name,
    E.Emp_ID::TEXT AS emp_id,
    E.Emp_Name AS emp_name,
    E.Salary::TEXT AS salary,
    E.Dept_ID::TEXT AS dept_id,
    (SELECT ROUND(AVG(E2.Salary), 2)
     FROM EMPLOYEE E2
     WHERE E2.Dept_ID = E.Dept_ID  -- ← CORRELATION: references outer E.Dept_ID
    )::TEXT AS dept_avg_salary,
    (E.Salary - (SELECT ROUND(AVG(E2.Salary), 2)
                 FROM EMPLOYEE E2
                 WHERE E2.Dept_ID = E.Dept_ID))::TEXT AS amount_above_avg
FROM EMPLOYEE E
WHERE E.Salary > (
    SELECT AVG(E2.Salary)
    FROM EMPLOYEE E2
    WHERE E2.Dept_ID = E.Dept_ID  -- ← CORRELATION: references outer E.Dept_ID
)

UNION ALL


-- ============================================================
-- QUERY 2: DEPARTMENT-WISE SUMMARY
-- Shows all employees with their department average for comparison
-- ============================================================
SELECT
    'Q2' AS query_id,
    'All Employees with Dept Average' AS query_name,
    E.Emp_ID::TEXT AS emp_id,
    E.Emp_Name AS emp_name,
    E.Salary::TEXT AS salary,
    E.Dept_ID::TEXT AS dept_id,
    (SELECT ROUND(AVG(E2.Salary), 2)
     FROM EMPLOYEE E2
     WHERE E2.Dept_ID = E.Dept_ID
    )::TEXT AS dept_avg_salary,
    CASE
        WHEN E.Salary > (SELECT AVG(E2.Salary) FROM EMPLOYEE E2 WHERE E2.Dept_ID = E.Dept_ID)
        THEN 'ABOVE AVG'
        WHEN E.Salary = (SELECT AVG(E2.Salary) FROM EMPLOYEE E2 WHERE E2.Dept_ID = E.Dept_ID)
        THEN 'EQUAL TO AVG'
        ELSE 'BELOW AVG'
    END AS comparison
FROM EMPLOYEE E

UNION ALL
-- ============================================================
-- QUERY 3: DEPARTMENT AVERAGES (for reference)
-- Shows the average salary for each department
-- ============================================================
SELECT
    'Q3' AS query_id,
    'Department Average Salaries' AS query_name,
    '' AS emp_id,
    'Department ' || E.Dept_ID::TEXT AS emp_name,
    ROUND(AVG(E.Salary), 2)::TEXT AS salary,
    E.Dept_ID::TEXT AS dept_id,
    COUNT(*)::TEXT || ' employees' AS dept_avg_salary,
    '' AS comparison
FROM EMPLOYEE E
GROUP BY E.Dept_ID

UNION ALL
-- ============================================================
-- QUERY 4: SECOND HIGHEST SALARY PER DEPARTMENT
-- Another correlated subquery example
-- ============================================================
SELECT
    'Q4' AS query_id,
    'Second Highest Salary Per Dept' AS query_name,
    E.Emp_ID::TEXT AS emp_id,
    E.Emp_Name AS emp_name,
    E.Salary::TEXT AS salary,
    E.Dept_ID::TEXT AS dept_id,
    (SELECT COUNT(DISTINCT E2.Salary)
     FROM EMPLOYEE E2
     WHERE E2.Dept_ID = E.Dept_ID
       AND E2.Salary > E.Salary  -- ← CORRELATION: count employees with higher salary
    )::TEXT AS rank_from_top,
    'Position from highest salary' AS comparison
FROM EMPLOYEE E
WHERE (
    SELECT COUNT(DISTINCT E2.Salary)
    FROM EMPLOYEE E2
    WHERE E2.Dept_ID = E.Dept_ID
      AND E2.Salary > E.Salary
) = 1  -- Exactly one person earns more (i.e., second highest)
ORDER BY dept_id, salary DESC;
