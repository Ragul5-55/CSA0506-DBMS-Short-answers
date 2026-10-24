-- connection: 6adc5d380f807b08919fd13d
-- database: chinook

-- ============================================================
-- HOSPITAL MANAGEMENT SYSTEM - COMPLETE EER IMPLEMENTATION
-- Supertype: Staff | Subtypes: Doctor, Nurse, Administrative_Staff
-- Weak Entity: Medical_Record (depends on Patient)
-- Specialization: DISJOINT, TOTAL (ISA)
-- ============================================================
--
-- TASK 1: Major Entities Identified
--   1. Staff (Supertype)     5. Appointment
--   2. Patient               6. Treatment
--   3. Department            7. Medical_Record (Weak Entity)
--   4. Staff Subtypes: Doctor, Nurse, Administrative_Staff
--
-- TASK 2: Specialization/Generalization
--   Staff (supertype) → Doctor, Nurse, Administrative_Staff (subtypes)
--
-- TASK 3: Inherited Attributes (from Staff)
--   All subtypes inherit: Staff_ID, Name, Address, Phone, Salary
--
-- TASK 4: Specific Attributes of Each Subtype
--   Doctor:              Specialization, License_Number
--   Nurse:               Qualification, Shift
--   Administrative_Staff: Role, Department_Assigned
--
-- TASK 5: Medical_Record as Weak Entity
--   Depends on Patient for identification (cannot exist without Patient)
--
-- TASK 6: Partial Key of Medical_Record
--   Record_ID (discriminator - unique only within a patient)
--
-- TASK 7: Identifying Relationship
--   Patient ──1:N──> Medical_Record (identifying relationship)
--
-- TASK 8: Relationships Among Entities
--   Department ──1:N──> Doctor        (one department has many doctors)
--   Doctor ──M:N──> Patient           (via Appointment)
--   Doctor ──M:N──> Patient           (via Treatment)
--   Patient ──1:N──> Medical_Record   (identifying relationship)
--   Staff ISA Doctor, Nurse, Administrative_Staff
--
-- TASK 9: Cardinalities and Participation
--   Department (1) ─── (N) Doctor        [Total participation for Doctor]
--   Doctor (M) ─── (N) Patient           [via Appointment, both partial]
--   Doctor (M) ─── (N) Patient           [via Treatment, both partial]
--   Patient (1) ─── (N) Medical_Record   [Total for Medical_Record]
--   Staff (1) ─── (1) Subtype            [Total, Disjoint]
--
-- TASK 10: Complete EER Diagram implemented below
-- ============================================================

WITH

-- ============================================================
-- ENTITY: Department (PK: Dept_ID)
-- ============================================================
Department (Dept_ID, Dept_Name, Location, Head_Of_Department) AS (
    VALUES
        ('DEP01', 'Cardiology',      'Block A, Floor 2', 'Dr. Rajesh Kumar'),
        ('DEP02', 'Orthopedics',     'Block B, Floor 1', 'Dr. Priya Sharma'),
        ('DEP03', 'Pediatrics',      'Block A, Floor 3', 'Dr. Amit Patel'),
        ('DEP04', 'General Medicine','Block C, Floor 1', 'Dr. Sneha Reddy')
),

-- ============================================================
-- SUPERTYPE: Staff (PK: Staff_ID)
-- Common attributes inherited by all subtypes
-- ============================================================
Staff (Staff_ID, Name, Address, Phone, Salary) AS (
    VALUES
        -- Doctors
        ('S001', 'Dr. Rajesh Kumar',   'Mumbai', '9876543210', 150000.00),
        ('S002', 'Dr. Priya Sharma',   'Delhi',  '9876543211', 140000.00),
        ('S003', 'Dr. Amit Patel',     'Chennai','9876543212', 135000.00),
        ('S004', 'Dr. Sneha Reddy',    'Bangalore','9876543213', 145000.00),
        -- Nurses
        ('S005', 'Anita Desai',        'Mumbai', '9876543214',  55000.00),
        ('S006', 'Vikram Singh',       'Delhi',  '9876543215',  52000.00),
        ('S007', 'Kavya Nair',         'Chennai','9876543216',  58000.00),
        -- Administrative Staff
        ('S008', 'Rohan Gupta',        'Mumbai', '9876543217',  45000.00),
        ('S009', 'Deepika Joshi',      'Bangalore','9876543218', 48000.00)
),

-- ============================================================
-- SUBTYPE: Doctor (PK: Staff_ID → Staff, FK: Dept_ID → Department)
-- Inherits: Staff_ID, Name, Address, Phone, Salary
-- Specialized: Specialization, License_Number
-- ============================================================
Doctor (Staff_ID, Dept_ID, Specialization, License_Number) AS (
    VALUES
        ('S001', 'DEP01', 'Cardiologist',       'LIC-CARD-001'),
        ('S002', 'DEP02', 'Orthopedic Surgeon', 'LIC-ORTH-002'),
        ('S003', 'DEP03', 'Pediatrician',       'LIC-PED-003'),
        ('S004', 'DEP04', 'General Physician',  'LIC-GEN-004')
),

-- ============================================================
-- SUBTYPE: Nurse (PK: Staff_ID → Staff)
-- Inherits: Staff_ID, Name, Address, Phone, Salary
-- Specialized: Qualification, Shift
-- ============================================================
Nurse (Staff_ID, Qualification, Shift_Type) AS (
    VALUES
        ('S005', 'BSc Nursing',      'Morning'),
        ('S006', 'GNM',              'Evening'),
        ('S007', 'MSc Nursing',      'Night')
),

-- ============================================================
-- SUBTYPE: Administrative_Staff (PK: Staff_ID → Staff)
-- Inherits: Staff_ID, Name, Address, Phone, Salary
-- Specialized: Role, Department_Assigned
-- ============================================================
Administrative_Staff (Staff_ID, Role, Department_Assigned) AS (
    VALUES
        ('S008', 'Receptionist',     'Front Desk'),
        ('S009', 'Billing Manager',  'Finance')
),

-- ============================================================
-- ENTITY: Patient (PK: Patient_ID)
-- ============================================================
Patient (Patient_ID, Patient_Name, Date_of_Birth, Gender, Contact_Number) AS (
    VALUES
        ('P001', 'Arjun Mehta',      '1985-03-15', 'Male',   '9123456780'),
        ('P002', 'Kavya Iyer',       '1990-07-22', 'Female', '9123456781'),
        ('P003', 'Rohan Verma',      '1978-11-08', 'Male',   '9123456782'),
        ('P004', 'Priya Nair',       '1995-05-30', 'Female', '9123456783'),
        ('P005', 'Vikram Reddy',     '1982-09-12', 'Male',   '9123456784')
),

-- ============================================================
-- WEAK ENTITY: Medical_Record (Partial Key: Record_ID)
-- Depends on Patient (identifying owner)
-- Cannot exist without a Patient
-- ============================================================
Medical_Record (Record_ID, Patient_ID, Record_Date, Diagnosis, Treatment_Details) AS (
    VALUES
        -- Patient P001's records
        ('R001', 'P001', '2024-09-01', 'Hypertension',        'Prescribed medication, lifestyle changes'),
        ('R002', 'P001', '2024-10-15', 'Follow-up',           'BP normal, continue medication'),
        -- Patient P002's records
        ('R001', 'P002', '2024-09-10', 'Fracture - Left Arm', 'Cast applied, pain medication'),
        ('R002', 'P002', '2024-10-20', 'Cast Removal',        'Healing good, physiotherapy advised'),
        -- Patient P003's records
        ('R001', 'P003', '2024-08-05', 'Diabetes Type 2',     'Insulin prescribed, diet plan'),
        -- Patient P004's records
        ('R001', 'P004', '2024-09-20', 'Pregnancy Checkup',   'Normal, next visit in 4 weeks'),
        -- Patient P005's records
        ('R001', 'P005', '2024-10-01', 'Cardiac Arrest',      'Emergency treatment, ICU admission'),
        ('R002', 'P005', '2024-10-10', 'Recovery',            'Stable, moved to general ward')
),

-- ============================================================
-- ENTITY: Appointment (Links Doctor and Patient)
-- Resolves M:N relationship between Doctor and Patient
-- ============================================================
Appointment (Appointment_ID, Patient_ID, Staff_ID, Appointment_Date, Appointment_Time, Status) AS (
    VALUES
        ('APT001', 'P001', 'S001', '2024-09-01', '10:00', 'Completed'),
        ('APT002', 'P001', 'S001', '2024-10-15', '11:00', 'Completed'),
        ('APT003', 'P002', 'S002', '2024-09-10', '14:00', 'Completed'),
        ('APT004', 'P002', 'S002', '2024-10-20', '15:00', 'Completed'),
        ('APT005', 'P003', 'S004', '2024-08-05', '09:00', 'Completed'),
        ('APT006', 'P004', 'S003', '2024-09-20', '10:30', 'Completed'),
        ('APT007', 'P005', 'S001', '2024-10-01', '08:00', 'Completed'),
        ('APT008', 'P005', 'S001', '2024-10-10', '09:00', 'Completed')
),

-- ============================================================
-- ENTITY: Treatment (Links Doctor and Patient)
-- Resolves M:N relationship between Doctor and Patient
-- ============================================================
Treatment (Treatment_ID, Patient_ID, Staff_ID, Treatment_Date, Treatment_Type, Outcome) AS (
    VALUES
        ('TR001', 'P001', 'S001', '2024-09-01', 'Medication',      'Prescribed Amlodipine'),
        ('TR002', 'P002', 'S002', '2024-09-10', 'Surgery',         'Cast application'),
        ('TR003', 'P002', 'S002', '2024-10-20', 'Procedure',       'Cast removal'),
        ('TR004', 'P003', 'S004', '2024-08-05', 'Medication',      'Insulin therapy'),
        ('TR005', 'P004', 'S003', '2024-09-20', 'Checkup',         'Prenatal care'),
        ('TR006', 'P005', 'S001', '2024-10-01', 'Emergency',       'CPR, ICU admission'),
        ('TR007', 'P005', 'S001', '2024-10-10', 'Recovery',        'Monitoring, medication adjustment')
)

-- ============================================================
-- MAIN QUERY: Complete EER Model
-- Demonstrates all 10 tasks in a comprehensive view
-- Shows: Staff specialization, weak entity, all relationships
-- ============================================================
SELECT
    -- STAFF SUPERTYPE attributes (Task 3: Inherited)
    st.Staff_ID,
    st.Name AS Staff_Name,
    st.Address,
    st.Phone,
    st.Salary,

    -- STAFF SUBTYPE classification (Task 2: Specialization)
    CASE
        WHEN d.Staff_ID IS NOT NULL THEN 'Doctor'
        WHEN n.Staff_ID IS NOT NULL THEN 'Nurse'
        WHEN a.Staff_ID IS NOT NULL THEN 'Administrative_Staff'
    END AS Staff_Type,

    -- DOCTOR specialized attributes (Task 4)
    d.Specialization,
    d.License_Number,
    dep.Dept_Name AS Department,

    -- NURSE specialized attributes (Task 4)
    n.Qualification,
    n.Shift_Type,

    -- ADMINISTRATIVE_STAFF specialized attributes (Task 4)
    a.Role,
    a.Department_Assigned,

    -- ISA Constraint validation (Task 2)
    CASE
        WHEN (CASE WHEN d.Staff_ID IS NOT NULL THEN 1 ELSE 0 END +
              CASE WHEN n.Staff_ID IS NOT NULL THEN 1 ELSE 0 END +
              CASE WHEN a.Staff_ID IS NOT NULL THEN 1 ELSE 0 END) = 1
        THEN 'VALID'
        ELSE 'ERROR'
    END AS ISA_Check

FROM Staff st
LEFT JOIN Doctor d ON st.Staff_ID = d.Staff_ID
LEFT JOIN Nurse n ON st.Staff_ID = n.Staff_ID
LEFT JOIN Administrative_Staff a ON st.Staff_ID = a.Staff_ID
LEFT JOIN Department dep ON d.Dept_ID = dep.Dept_ID

ORDER BY st.Staff_ID;
