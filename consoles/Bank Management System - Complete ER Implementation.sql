-- connection: 6adc5d380f807b08919fd13d
-- database: chinook

-- ============================================================
-- BANK MANAGEMENT SYSTEM - COMPLETE ER IMPLEMENTATION
-- 7 Entities, 6 Relationships, All Cardinalities: 1:N
-- ============================================================
--
-- TASK 1: Major Entities Identified
--   1. Customer        5. Transaction
--   2. Bank_Account    6. Loan
--   3. Branch          7. Loan_Payment
--   4. Employee
--
-- TASK 2: Attributes for Each Entity
--   Customer:      Customer_ID, Customer_Name, Phone, Email, Address
--   Bank_Account:  Account_No, Customer_ID, Branch_ID, Account_Type,
--                  Balance, Opening_Date
--   Branch:        Branch_ID, Branch_Name, Location, IFSC_Code
--   Employee:      Employee_ID, Branch_ID, Employee_Name,
--                  Designation, Salary
--   Transaction:   Transaction_ID, Account_No, Transaction_Date,
--                  Transaction_Type, Amount
--   Loan:          Loan_ID, Customer_ID, Loan_Type, Loan_Amount,
--                  Interest_Rate, Loan_Status
--   Loan_Payment:  Payment_ID, Loan_ID, Payment_Date, Payment_Amount
--
-- TASK 3: Primary Keys
--   Customer → Customer_ID
--   Bank_Account → Account_No
--   Branch → Branch_ID
--   Employee → Employee_ID
--   Transaction → Transaction_ID
--   Loan → Loan_ID
--   Loan_Payment → Payment_ID
--
-- TASK 4 & 5: Relationships and Cardinalities
--   Branch ──1:N──> Employee      (one branch has many employees)
--   Branch ──1:N──> Bank_Account  (one branch maintains many accounts)
--   Customer ──1:N──> Bank_Account (one customer holds many accounts)
--   Bank_Account ──1:N──> Transaction (one account has many transactions)
--   Customer ──1:N──> Loan        (one customer can have many loans)
--   Loan ──1:N──> Loan_Payment    (one loan has many payments)
--
-- TASK 6: Complete ER Diagram implemented below
-- ============================================================

WITH

-- ============================================================
-- ENTITY 1: BRANCH (PK: Branch_ID)
-- ============================================================
Branch (Branch_ID, Branch_Name, Location, IFSC_Code) AS (
    VALUES
        ('B001', 'Main Branch',      'Mumbai',   'HDFC0001'),
        ('B002', 'North Branch',     'Delhi',    'HDFC0002'),
        ('B003', 'South Branch',     'Chennai',  'HDFC0003')
),

-- ============================================================
-- ENTITY 2: EMPLOYEE (PK: Employee_ID, FK: Branch_ID → Branch)
-- Relationship: Branch 1:N Employee
-- ============================================================
Employee (Employee_ID, Branch_ID, Employee_Name, Designation, Salary) AS (
    VALUES
        ('E001', 'B001', 'Rahul Sharma',    'Manager',    95000.00),
        ('E002', 'B001', 'Priya Patel',     'Cashier',    45000.00),
        ('E003', 'B002', 'Amit Kumar',      'Manager',    92000.00),
        ('E004', 'B002', 'Sneha Reddy',     'Clerk',      38000.00),
        ('E005', 'B003', 'Vikram Singh',    'Manager',    98000.00),
        ('E006', 'B003', 'Anita Desai',     'Cashier',    42000.00)
),

-- ============================================================
-- ENTITY 3: CUSTOMER (PK: Customer_ID)
-- ============================================================
Customer (Customer_ID, Customer_Name, Phone, Email, Address) AS (
    VALUES
        ('C001', 'Arjun Mehta',     '9876543210', 'arjun@mail.com',     'Mumbai'),
        ('C002', 'Kavya Nair',      '9123456780', 'kavya@mail.com',     'Delhi'),
        ('C003', 'Rohan Gupta',     '9988776655', 'rohan@mail.com',     'Chennai'),
        ('C004', 'Deepika Joshi',   '9001234567', 'deepika@mail.com',   'Mumbai')
),

-- ============================================================
-- ENTITY 4: BANK_ACCOUNT (PK: Account_No)
-- FK: Customer_ID → Customer, FK: Branch_ID → Branch
-- Relationships: Customer 1:N Account, Branch 1:N Account
-- ============================================================
Bank_Account (Account_No, Customer_ID, Branch_ID, Account_Type, Balance, Opening_Date) AS (
    VALUES
        ('A1001', 'C001', 'B001', 'Savings', 125000.00, '2022-01-15'),
        ('A1002', 'C001', 'B001', 'Current',  85000.00, '2023-03-20'),
        ('A1003', 'C002', 'B002', 'Savings',  62000.00, '2021-07-10'),
        ('A1004', 'C003', 'B003', 'Savings', 210000.00, '2020-11-05'),
        ('A1005', 'C003', 'B003', 'Current', 150000.00, '2023-06-18'),
        ('A1006', 'C004', 'B001', 'Savings',  45000.00, '2024-02-28')
),

-- ============================================================
-- ENTITY 5: TRANSACTION (PK: Transaction_ID, FK: Account_No → Bank_Account)
-- Relationship: Account 1:N Transaction
-- ============================================================
Transaction (Transaction_ID, Account_No, Transaction_Date, Transaction_Type, Amount) AS (
    VALUES
        ('T0001', 'A1001', '2024-09-01', 'Deposit',    25000.00),
        ('T0002', 'A1001', '2024-09-10', 'Withdrawal',  5000.00),
        ('T0003', 'A1002', '2024-09-05', 'Deposit',    40000.00),
        ('T0004', 'A1003', '2024-09-12', 'Withdrawal',  8000.00),
        ('T0005', 'A1004', '2024-09-15', 'Deposit',    60000.00),
        ('T0006', 'A1004', '2024-09-20', 'Withdrawal', 15000.00),
        ('T0007', 'A1005', '2024-09-18', 'Deposit',    30000.00),
        ('T0008', 'A1006', '2024-09-22', 'Withdrawal',  3000.00)
),

-- ============================================================
-- ENTITY 6: LOAN (PK: Loan_ID, FK: Customer_ID → Customer)
-- Relationship: Customer 1:N Loan
-- ============================================================
Loan (Loan_ID, Customer_ID, Loan_Type, Loan_Amount, Interest_Rate, Loan_Status) AS (
    VALUES
        ('L001', 'C001', 'Home Loan',     5000000.00, 8.50,  'Active'),
        ('L002', 'C001', 'Personal Loan',  500000.00, 11.00, 'Active'),
        ('L003', 'C002', 'Vehicle Loan',  1200000.00, 9.25,  'Active'),
        ('L004', 'C003', 'Home Loan',     7500000.00, 8.00,  'Active'),
        ('L005', 'C004', 'Education Loan', 300000.00, 7.50,  'Closed')
),

-- ============================================================
-- ENTITY 7: LOAN_PAYMENT (PK: Payment_ID, FK: Loan_ID → Loan)
-- Relationship: Loan 1:N Payment
-- ============================================================
Loan_Payment (Payment_ID, Loan_ID, Payment_Date, Payment_Amount) AS (
    VALUES
        ('P001', 'L001', '2024-09-01', 45000.00),
        ('P002', 'L001', '2024-10-01', 45000.00),
        ('P003', 'L002', '2024-09-15', 15000.00),
        ('P004', 'L003', '2024-09-10', 22000.00),
        ('P005', 'L004', '2024-09-05', 65000.00),
        ('P006', 'L004', '2024-10-05', 65000.00),
        ('P007', 'L005', '2024-08-01', 10000.00),
        ('P008', 'L005', '2024-09-01', 10000.00)
)

-- ============================================================
-- MAIN QUERY: Complete ER Model — Customer-Centric View
-- Joins all 7 entities to demonstrate every relationship
-- ============================================================
SELECT
    -- CUSTOMER attributes (Task 2)
    cu.Customer_ID,
    cu.Customer_Name,
    cu.Phone,
    cu.Email,
    cu.Address,

    -- BANK_ACCOUNT attributes (Task 2)
    -- Relationship: Customer 1:N Account (Task 4, 5)
    ba.Account_No,
    ba.Account_Type,
    ba.Balance,
    ba.Opening_Date,

    -- BRANCH attributes (Task 2)
    -- Relationship: Branch 1:N Account (Task 4, 5)
    br.Branch_Name,
    br.Location,
    br.IFSC_Code,

    -- LOAN attributes (Task 2)
    -- Relationship: Customer 1:N Loan (Task 4, 5)
    l.Loan_ID,
    l.Loan_Type,
    l.Loan_Amount,
    l.Interest_Rate,
    l.Loan_Status,

    -- LOAN_PAYMENT attributes (Task 2)
    -- Relationship: Loan 1:N Payment (Task 4, 5)
    lp.Payment_ID,
    lp.Payment_Date,
    lp.Payment_Amount

FROM Customer cu

-- Customer 1:N Account (Task 4, 5)
LEFT JOIN Bank_Account ba ON cu.Customer_ID = ba.Customer_ID

-- Branch 1:N Account (Task 4, 5)
LEFT JOIN Branch br ON ba.Branch_ID = br.Branch_ID

-- Customer 1:N Loan (Task 4, 5)
LEFT JOIN Loan l ON cu.Customer_ID = l.Customer_ID

-- Loan 1:N Payment (Task 4, 5)
LEFT JOIN Loan_Payment lp ON l.Loan_ID = lp.Loan_ID

ORDER BY cu.Customer_ID, ba.Account_No, l.Loan_ID, lp.Payment_ID;
