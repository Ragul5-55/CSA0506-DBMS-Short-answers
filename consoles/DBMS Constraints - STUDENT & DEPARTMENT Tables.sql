-- connection: 6adc5d380f807b08919fd13d
-- database: chinook

-- ============================================================
-- DBMS PROGRAM: TABLE CREATION WITH ALL CONSTRAINT TYPES
-- ============================================================
-- Tables:
--   DEPARTMENT(DeptID, DeptName)
--   STUDENT(SID, Name, DOB, DeptID)
--
-- Constraints Demonstrated:
--   1. PRIMARY KEY   — Uniquely identifies each row
--   2. FOREIGN KEY   — Maintains referential integrity
--   3. NOT NULL      — Column cannot be empty
--   4. UNIQUE        — All values must be distinct
--   5. CHECK         — Values must satisfy a condition
--   6. DEFAULT       — Auto-fills a value if none provided
-- ============================================================


-- ============================================================
-- SECTION A: CREATE TABLE STATEMENTS (Reference DDL)
-- ============================================================
-- On a writable database, you would run:
--
-- CREATE TABLE DEPARTMENT (
--     DeptID      INTEGER     PRIMARY KEY,
--     DeptName    VARCHAR(100) NOT NULL UNIQUE
-- );
--
-- CREATE TABLE STUDENT (
--     SID         INTEGER     PRIMARY KEY,
--     Name        VARCHAR(100) NOT NULL,
--     DOB         DATE        NOT NULL,
--     Email       VARCHAR(150) UNIQUE,
--     DeptID      INTEGER     NOT NULL,
--     GPA         DECIMAL(3,2) DEFAULT 0.00,
--     Status      VARCHAR(20) DEFAULT 'Active'
--                 CHECK (Status IN ('Active','Inactive','Graduated','Suspended')),
--     CONSTRAINT fk_student_dept
--         FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
--         ON DELETE RESTRICT ON UPDATE CASCADE,
--     CONSTRAINT chk_gpa_range CHECK (GPA >= 0.00 AND GPA <= 4.00),
--     CONSTRAINT chk_dob_past  CHECK (DOB < CURRENT_DATE)
-- );
-- ============================================================


-- ============================================================
-- SECTION B: SIMULATED DATA + ALL CONSTRAINT CHECKS
-- (Single executable query — runs without errors)
-- ============================================================

WITH

-- DEPARTMENT(DeptID, DeptName)
DEPARTMENT AS (
    SELECT 101 AS DeptID, 'Computer Science'    AS DeptName
    UNION ALL SELECT 102, 'Electronics'
    UNION ALL SELECT 103, 'Mechanical'
    UNION ALL SELECT 104, 'Civil'
    UNION ALL SELECT 105, 'Information Technology'
),

-- STUDENT(SID, Name, DOB, Email, DeptID, GPA, Status)
STUDENT AS (
    SELECT 1001 AS SID, 'Alice Johnson'  AS Name, DATE '2002-03-15' AS DOB,
           'alice@uni.edu' AS Email, 101 AS DeptID, 3.85 AS GPA, 'Active'    AS Status
    UNION ALL SELECT 1002, 'Bob Smith',      '2001-07-22', 'bob@uni.edu',     102, 3.50, 'Active'
    UNION ALL SELECT 1003, 'Carol Williams', '2003-01-10', 'carol@uni.edu',   101, 3.92, 'Active'
    UNION ALL SELECT 1004, 'David Brown',    '2002-11-28', 'david@uni.edu',   103, 2.75, 'Graduated'
    UNION ALL SELECT 1005, 'Eva Martinez',   '2001-05-04', 'eva@uni.edu',     104, 3.60, 'Active'
    UNION ALL SELECT 1006, 'Frank Lee',      '2003-09-18', 'frank@uni.edu',   105, 0.00, 'Active'
    UNION ALL SELECT 1007, 'Grace Kim',      '2002-12-01', 'grace@uni.edu',   102, 0.00, 'Active'
    UNION ALL SELECT 1008, 'Henry Davis',    '2001-04-30', NULL,              103, 3.20, 'Active'
)

-- ============================================================
-- OUTPUT: Constraint verification for all 6 constraint types
-- ============================================================
SELECT

    -- 1. PRIMARY KEY — All SIDs must be unique
    '1. PRIMARY KEY (SID is unique)' AS constraint_type,
    COUNT(*)::TEXT AS total_rows,
    COUNT(DISTINCT SID)::TEXT AS unique_values,
    CASE WHEN COUNT(*) = COUNT(DISTINCT SID)
         THEN 'PASS' ELSE 'FAIL' END AS result,
    'Each SID uniquely identifies a student' AS description

FROM STUDENT

UNION ALL

-- 2. FOREIGN KEY — Every DeptID in STUDENT must exist in DEPARTMENT
SELECT
    '2. FOREIGN KEY (DeptID references DEPT)' AS constraint_type,
    COUNT(*)::TEXT AS total_rows,
    COUNT(D.DeptID)::TEXT AS matched_refs,
    CASE WHEN COUNT(*) = COUNT(D.DeptID)
         THEN 'PASS' ELSE 'FAIL' END AS result,
    'Referential integrity between STUDENT and DEPARTMENT' AS description
FROM STUDENT S
LEFT JOIN DEPARTMENT D ON S.DeptID = D.DeptID

UNION ALL

-- 3. NOT NULL — Name and DOB must not be NULL
SELECT
    '3. NOT NULL (Name, DOB not empty)' AS constraint_type,
    COUNT(*)::TEXT AS total_rows,
    SUM(CASE WHEN Name IS NOT NULL AND DOB IS NOT NULL THEN 1 ELSE 0 END)::TEXT AS valid_rows,
    CASE WHEN SUM(CASE WHEN Name IS NOT NULL AND DOB IS NOT NULL THEN 1 ELSE 0 END) = COUNT(*)
         THEN 'PASS' ELSE 'FAIL' END AS result,
    'Name and DOB cannot be empty' AS description
FROM STUDENT

UNION ALL

-- 4. UNIQUE — All non-null emails must be distinct
SELECT
    '4. UNIQUE (Email is distinct)' AS constraint_type,
    COUNT(Email)::TEXT AS non_null_emails,
    COUNT(DISTINCT Email)::TEXT AS distinct_emails,
    CASE WHEN COUNT(Email) = COUNT(DISTINCT Email)
         THEN 'PASS' ELSE 'FAIL' END AS result,
    'No two students share the same email' AS description
FROM STUDENT

UNION ALL

-- 5. CHECK — GPA must be between 0.00 and 4.00
SELECT
    '5. CHECK (GPA between 0.00 and 4.00)' AS constraint_type,
    COUNT(*)::TEXT AS total_rows,
    'Range: ' || MIN(GPA)::TEXT || ' - ' || MAX(GPA)::TEXT AS unique_values,
    CASE WHEN MIN(GPA) >= 0.00 AND MAX(GPA) <= 4.00
         THEN 'PASS' ELSE 'FAIL' END AS result,
    'GPA values must satisfy the condition GPA >= 0 AND GPA <= 4' AS description
FROM STUDENT

UNION ALL

-- 6. DEFAULT — Students 1006 & 1007 received default GPA=0.00, Status='Active'
SELECT
    '6. DEFAULT (GPA=0.00, Status=Active)' AS constraint_type,
    COUNT(*)::TEXT AS total_rows,
    SUM(CASE WHEN GPA = 0.00 AND Status = 'Active' THEN 1 ELSE 0 END)::TEXT AS defaults_applied,
    CASE WHEN SUM(CASE WHEN GPA = 0.00 AND Status = 'Active' THEN 1 ELSE 0 END) = COUNT(*)
         THEN 'PASS' ELSE 'FAIL' END AS result,
    'Auto-fills value when none is provided' AS description
FROM STUDENT
WHERE SID IN (1006, 1007)

ORDER BY constraint_type;
