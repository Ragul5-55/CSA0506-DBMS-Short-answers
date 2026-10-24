// connection: 6adc5d380f807b08919fd13d
// database: chinook

-- ============================================================
-- E-COMMERCE DATABASE - COMPLETE EER IMPLEMENTATION
-- Supertype: Product | Subtypes: Electronics, Clothing, Grocery
-- Specialization: DISJOINT, TOTAL (ISA)
-- ============================================================
--
-- TASK 1: Major Entities
--   1. Customer        5. Order_Items (junction for M:N)
--   2. Product         6. Payment
--   3. Category        7. Delivery
--   4. Order
--   + 3 Product Subtypes: Electronics, Clothing, Grocery
--
-- TASK 2: Attributes and Primary Keys
--   Customer:      PK → Customer_ID, Name, Email, Phone, Address
--   Product:       PK → Product_ID, Product_Name, Price,
--                  Stock_Quantity, Description, Category_ID
--   Category:      PK → Category_ID, Category_Name
--   Order:         PK → Order_ID, Customer_ID, Order_Date,
--                  Order_Status, Total_Amount
--   Order_Items:   PK → (Order_ID, Product_ID), Quantity, Unit_Price
--   Payment:       PK → Payment_ID, Order_ID, Payment_Date,
--                  Payment_Mode, Payment_Status
--   Delivery:      PK → Delivery_ID, Order_ID, Delivery_Date,
--                  Delivery_Status, Delivery_Address
--   Electronics:   PK → Product_ID (FK), Warranty_Period, Brand
--   Clothing:      PK → Product_ID (FK), Size, Material, Gender
--   Grocery:       PK → Product_ID (FK), Expiry_Date, Weight_Kg
--
-- TASK 3: Order-Product M:N Relationship
--   Resolved via Order_Items junction table with relationship
--   attributes: Quantity, Unit_Price
--
-- TASK 4: Specialization/Generalization
--   Product (supertype) → Electronics, Clothing, Grocery (subtypes)
--
-- TASK 5: Inherited Attributes
--   All subtypes inherit: Product_ID, Product_Name, Price,
--   Stock_Quantity, Description, Category_ID
--   Electronics adds: Warranty_Period, Brand
--   Clothing adds: Size, Material, Gender
--   Grocery adds: Expiry_Date, Weight_Kg
--
-- TASK 6: Specialization Constraints
--   DISJOINT — a product is ONE type only
--   TOTAL — every product must be classified into a subtype
--
-- TASK 7: Relationships
--   Customer ──1:N──> Order
--   Order ──1:1──> Payment
--   Order ──1:1──> Delivery
--   Order ──M:N──> Product (via Order_Items)
--   Product ──N:1──> Category
--   Product ISA Electronics, Clothing, Grocery
--
-- TASK 8: Cardinalities
--   Customer (1) ─── (N) Order
--   Order (1) ─── (1) Payment
--   Order (1) ─── (1) Delivery
--   Order (M) ─── (N) Product  [via Order_Items]
--   Category (1) ─── (N) Product
-- ============================================================

WITH

-- ENTITY: Category (PK: Category_ID)
Category (Category_ID, Category_Name) AS (
    VALUES
        ('CAT01', 'Electronics'),
        ('CAT02', 'Clothing'),
        ('CAT03', 'Grocery')
),

-- SUPERTYPE: Product (PK: Product_ID, FK: Category_ID → Category)
Product (Product_ID, Product_Name, Price, Stock_Quantity, Description, Category_ID) AS (
    VALUES
        -- Electronics
        ('P001', 'iPhone 15',       79999.00,  50, 'Apple smartphone',        'CAT01'),
        ('P002', 'Samsung TV',      45999.00,  20, '55-inch Smart TV',        'CAT01'),
        -- Clothing
        ('P003', 'Cotton T-Shirt',    799.00, 200, 'Round neck t-shirt',      'CAT02'),
        ('P004', 'Denim Jeans',      1499.00, 150, 'Slim fit jeans',         'CAT02'),
        -- Grocery
        ('P005', 'Basmati Rice',      550.00, 500, '5kg premium rice',        'CAT03'),
        ('P006', 'Olive Oil',         890.00, 100, '1L extra virgin oil',     'CAT03')
),

-- SUBTYPE: Electronics (PK: Product_ID → Product, inherits all Product attrs)
Electronics (Product_ID, Warranty_Period, Brand) AS (
    VALUES
        ('P001', '1 Year', 'Apple'),
        ('P002', '2 Years', 'Samsung')
),

-- SUBTYPE: Clothing (PK: Product_ID → Product, inherits all Product attrs)
Clothing (Product_ID, Size, Material, Gender) AS (
    VALUES
        ('P003', 'L',  'Cotton', 'Unisex'),
        ('P004', '32', 'Denim',  'Men')
),

-- SUBTYPE: Grocery (PK: Product_ID → Product, inherits all Product attrs)
Grocery (Product_ID, Expiry_Date, Weight_Kg) AS (
    VALUES
        ('P005', '2025-12-31', 5.0),
        ('P006', '2025-06-30', 1.0)
),

-- ENTITY: Customer (PK: Customer_ID)
Customer (Customer_ID, Name, Email, Phone, Address) AS (
    VALUES
        ('C001', 'Rajesh Kumar',  'rajesh@mail.com',  '9876543210', 'Mumbai'),
        ('C002', 'Sita Sharma',   'sita@mail.com',    '9123456780', 'Delhi'),
        ('C003', 'Arjun Reddy',   'arjun@mail.com',   '9988776655', 'Bangalore')
),

-- ENTITY: Order (PK: Order_ID, FK: Customer_ID → Customer)
-- Relationship: Customer 1:N Order
"Order" (Order_ID, Customer_ID, Order_Date, Order_Status, Total_Amount) AS (
    VALUES
        ('O001', 'C001', '2024-10-01', 'Delivered',  125998.00),
        ('O002', 'C001', '2024-10-10', 'Shipped',      2298.00),
        ('O003', 'C002', '2024-10-12', 'Processing',  46549.00),
        ('O004', 'C003', '2024-10-15', 'Pending',      1440.00)
),

-- ENTITY: Order_Items (PK: Order_ID + Product_ID)
-- Resolves M:N between Order and Product
-- Relationship attributes: Quantity, Unit_Price
Order_Items (Order_ID, Product_ID, Quantity, Unit_Price) AS (
    VALUES
        -- Order O001: Rajesh buys iPhone + Samsung TV
        ('O001', 'P001', 1, 79999.00),
        ('O001', 'P002', 1, 45999.00),
        -- Order O002: Rajesh buys T-Shirt + Jeans
        ('O002', 'P003', 1,   799.00),
        ('O002', 'P004', 1,  1499.00),
        -- Order O003: Sita buys Samsung TV + Rice
        ('O003', 'P002', 1, 45999.00),
        ('O003', 'P005', 1,   550.00),
        -- Order O004: Arjun buys Rice + Olive Oil
        ('O004', 'P005', 1,   550.00),
        ('O004', 'P006', 1,   890.00)
),

-- ENTITY: Payment (PK: Payment_ID, FK: Order_ID → Order)
-- Relationship: Order 1:1 Payment
Payment (Payment_ID, Order_ID, Payment_Date, Payment_Mode, Payment_Status) AS (
    VALUES
        ('PAY001', 'O001', '2024-10-01', 'Credit Card',      'Completed'),
        ('PAY002', 'O002', '2024-10-10', 'UPI',              'Completed'),
        ('PAY003', 'O003', '2024-10-12', 'Debit Card',       'Pending'),
        ('PAY004', 'O004', '2024-10-15', 'Cash on Delivery', 'Pending')
),

-- ENTITY: Delivery (PK: Delivery_ID, FK: Order_ID → Order)
-- Relationship: Order 1:1 Delivery
Delivery (Delivery_ID, Order_ID, Delivery_Date, Delivery_Status, Delivery_Address) AS (
    VALUES
        ('D001', 'O001', '2024-10-05', 'Delivered',   'Mumbai, 400001'),
        ('D002', 'O002', '2024-10-14', 'In Transit',  'Mumbai, 400001'),
        ('D003', 'O003', NULL,         'Not Shipped', 'Delhi, 110001'),
        ('D004', 'O004', NULL,         'Not Shipped', 'Bangalore, 560001')
)

-- ============================================================
-- MAIN QUERY: Complete E-Commerce ER Model
-- Demonstrates ALL entities, relationships, cardinalities,
-- and EER specialization in a single comprehensive view
-- ============================================================
SELECT
    -- CUSTOMER attributes (Task 2)
    c.Customer_ID,
    c.Name AS Customer_Name,
    c.Email,
    c.Phone,
    c.Address,

    -- ORDER attributes (Task 2, 7: Customer 1:N Order)
    o.Order_ID,
    o.Order_Date,
    o.Order_Status,
    o.Total_Amount,

    -- ORDER_ITEMS: M:N relationship attributes (Task 3)
    oi.Quantity,
    oi.Unit_Price,
    (oi.Quantity * oi.Unit_Price) AS Line_Total,

    -- PRODUCT attributes (Task 2, inherited by subtypes)
    p.Product_ID,
    p.Product_Name,
    p.Price,
    p.Stock_Quantity,
    p.Description,

    -- CATEGORY (Task 2)
    cat.Category_Name,

    -- PRODUCT SUBTYPE classification (Task 4, 6: DISJOINT, TOTAL)
    CASE
        WHEN e.Product_ID IS NOT NULL THEN 'Electronics'
        WHEN cl.Product_ID IS NOT NULL THEN 'Clothing'
        WHEN g.Product_ID IS NOT NULL THEN 'Grocery'
    END AS Product_Subtype,

    -- Specialized attributes: Electronics (Task 5)
    e.Warranty_Period,
    e.Brand,

    -- Specialized attributes: Clothing (Task 5)
    cl.Size,
    cl.Material,
    cl.Gender,

    -- Specialized attributes: Grocery (Task 5)
    g.Expiry_Date,
    g.Weight_Kg,

    -- PAYMENT attributes (Task 2, 7: Order 1:1 Payment)
    pay.Payment_ID,
    pay.Payment_Date,
    pay.Payment_Mode,
    pay.Payment_Status,

    -- DELIVERY attributes (Task 2, 7: Order 1:1 Delivery)
    d.Delivery_ID,
    d.Delivery_Date,
    d.Delivery_Status,
    d.Delivery_Address,

    -- ISA Constraint validation (Task 6)
    CASE
        WHEN (CASE WHEN e.Product_ID IS NOT NULL THEN 1 ELSE 0 END +
              CASE WHEN cl.Product_ID IS NOT NULL THEN 1 ELSE 0 END +
              CASE WHEN g.Product_ID IS NOT NULL THEN 1 ELSE 0 END) = 1
        THEN 'VALID'
        ELSE 'ERROR'
    END AS ISA_Check

FROM Customer c

-- Customer 1:N Order (Task 7, 8)
JOIN "Order" o ON c.Customer_ID = o.Customer_ID

-- Order M:N Product via Order_Items (Task 3, 7, 8)
JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
JOIN Product p ON oi.Product_ID = p.Product_ID

-- Product N:1 Category (Task 8)
JOIN Category cat ON p.Category_ID = cat.Category_ID

-- Product ISA subtypes (Task 4, 5, 6)
LEFT JOIN Electronics e  ON p.Product_ID = e.Product_ID
LEFT JOIN Clothing cl    ON p.Product_ID = cl.Product_ID
LEFT JOIN Grocery g      ON p.Product_ID = g.Product_ID

-- Order 1:1 Payment (Task 7, 8)
JOIN Payment pay ON o.Order_ID = pay.Order_ID

-- Order 1:1 Delivery (Task 7, 8)
JOIN Delivery d ON o.Order_ID = d.Order_ID

ORDER BY c.Customer_ID, o.Order_ID, p.Product_ID;
