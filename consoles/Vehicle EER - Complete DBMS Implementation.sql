-- connection: 6adc5d380f807b08919fd13d
-- database: chinook

-- ============================================================
-- VEHICLE MANAGEMENT SYSTEM - COMPLETE EER IMPLEMENTATION
-- Supertype: Vehicle | Subtypes: Car, Truck
-- Specialization: DISJOINT, TOTAL (ISA)
-- ============================================================
--
-- TASK 1: Supertype = Vehicle | Subtypes = Car, Truck
--
-- TASK 2: Common Attributes of Vehicle:
--   Vehicle_ID, Registration_Number, Manufacturer, Model, Year, Purchase_Price
--
-- TASK 3: Specialized Attributes:
--   Car   -> Number_of_Doors, Fuel_Type, Seating_Capacity
--   Truck -> Load_Capacity, Truck_Type, Number_of_Axles
--
-- TASK 4: Primary Key = Vehicle_ID (inherited by both subtypes)
--
-- TASK 5: ISA Relationship via FK from subtypes to supertype
--
-- TASK 6: DISJOINT — a vehicle is EITHER a Car OR a Truck (not both)
--
-- TASK 7: TOTAL — every vehicle MUST be classified as Car or Truck
--
-- TASK 8: Complete EER Diagram with constraint verification
-- ============================================================

WITH

-- ============================================================
-- SUPERTYPE TABLE: Vehicle
-- Holds all common attributes. Vehicle_ID is the PK.
-- ============================================================
Vehicle (Vehicle_ID, Registration_Number, Manufacturer, Model, Year, Purchase_Price) AS (
    VALUES
        (1, 'MH-12-AB-1234', 'Toyota',    'Camry',       2023,  28000.00),
        (2, 'DL-05-CD-5678', 'Honda',     'Civic',       2024,  25000.00),
        (3, 'TN-07-EF-9012', 'Ford',      'F-150',       2023,  45000.00),
        (4, 'KA-01-GH-3456', 'Volvo',     'FH16',        2022, 120000.00),
        (5, 'MH-04-IJ-7890', 'Tesla',     'Model 3',     2024,  40000.00),
        (6, 'UP-32-KL-2345', 'Mercedes',  'Actros',      2023, 135000.00),
        (7, 'RJ-14-MN-6789', 'Hyundai',   'Creta',       2024,  22000.00),
        (8, 'GJ-08-OP-0123', 'Tata',      'Signa 4825',  2023,  95000.00)
),

-- ============================================================
-- SUBTYPE TABLE: Car
-- PK = Vehicle_ID (also FK -> Vehicle)
-- Inherits: Vehicle_ID, Registration_Number, Manufacturer,
--           Model, Year, Purchase_Price
-- Specialized: Number_of_Doors, Fuel_Type, Seating_Capacity
-- ============================================================
Car (Vehicle_ID, Number_of_Doors, Fuel_Type, Seating_Capacity) AS (
    VALUES
        (1, 4, 'Petrol',   5),   -- Toyota Camry
        (2, 4, 'Petrol',   5),   -- Honda Civic
        (5, 4, 'Electric', 5),   -- Tesla Model 3
        (7, 5, 'Hybrid',   5)    -- Hyundai Creta
),

-- ============================================================
-- SUBTYPE TABLE: Truck
-- PK = Vehicle_ID (also FK -> Vehicle)
-- Inherits: Vehicle_ID, Registration_Number, Manufacturer,
--           Model, Year, Purchase_Price
-- Specialized: Load_Capacity, Truck_Type, Number_of_Axles
-- ============================================================
Truck (Vehicle_ID, Load_Capacity, Truck_Type, Number_of_Axles) AS (
    VALUES
        (3,  5.00, 'Light',        4),   -- Ford F-150
        (4, 25.00, 'Heavy',        6),   -- Volvo FH16
        (6, 30.00, 'Semi-Trailer', 8),   -- Mercedes Actros
        (8, 18.50, 'Heavy',        6)    -- Tata Signa 4825
)

-- ============================================================
-- MAIN QUERY: Complete EER Model
-- Shows ALL inherited + specialized attributes
-- Demonstrates ISA relationship via JOINs
-- Validates DISJOINT and TOTAL constraints
-- ============================================================
SELECT
    -- === INHERITED ATTRIBUTES FROM SUPERTYPE (Vehicle) ===
    v.Vehicle_ID,
    v.Registration_Number,
    v.Manufacturer,
    v.Model,
    v.Year,
    v.Purchase_Price,

    -- === SUBTYPE CLASSIFICATION (TASK 5: ISA) ===
    CASE
        WHEN c.Vehicle_ID IS NOT NULL THEN 'Car'
        WHEN t.Vehicle_ID IS NOT NULL THEN 'Truck'
    END AS Vehicle_Type,

    -- === SPECIALIZED ATTRIBUTES: Car (TASK 3) ===
    c.Number_of_Doors,
    c.Fuel_Type,
    c.Seating_Capacity,

    -- === SPECIALIZED ATTRIBUTES: Truck (TASK 3) ===
    t.Load_Capacity,
    t.Truck_Type,
    t.Number_of_Axles,

    -- === CONSTRAINT VALIDATION (TASK 6 & 7) ===
    CASE
        WHEN c.Vehicle_ID IS NOT NULL AND t.Vehicle_ID IS NOT NULL
            THEN 'ERROR: Violates DISJOINT'
        WHEN c.Vehicle_ID IS NULL AND t.Vehicle_ID IS NULL
            THEN 'ERROR: Violates TOTAL'
        ELSE 'VALID'
    END AS Constraint_Status

FROM Vehicle v
LEFT JOIN Car   c ON v.Vehicle_ID = c.Vehicle_ID   -- ISA: Car IS A Vehicle
LEFT JOIN Truck t ON v.Vehicle_ID = t.Vehicle_ID   -- ISA: Truck IS A Vehicle

ORDER BY v.Vehicle_ID;
