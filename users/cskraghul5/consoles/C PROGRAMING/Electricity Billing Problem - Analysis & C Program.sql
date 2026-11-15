-- connection: 6adc5d380f807b08919fd13d

/*
 * ============================================================================
 *  ELECTRICITY BILLING PROBLEM — FULL ANALYSIS & C PROGRAM
 * ============================================================================
 *
 * ────────────────────────────────────────────────────────────────────────────
 *  PART 1: DATA ANALYSIS
 * ────────────────────────────────────────────────────────────────────────────
 *
 * 1. INPUTS (data the program must READ)
 * ───────────────────────────────────────
 *
 *   a) Previous Reading (int)
 *      - The meter reading at the start of the billing period.
 *      - Justification: Needed to compute how many units were consumed.
 *      - Range: 0 to ~999999 (6-digit meters). Always non-negative.
 *      - Can be very large on older meters but never negative.
 *
 *   b) Current Reading (int)
 *      - The meter reading at the end of the billing period.
 *      - Justification: Needed together with previous reading to find units.
 *      - Range: same as previous reading. Must be >= previous reading.
 *      - Can be very large; must be >= previous reading (validated).
 *
 *   c) Household Number (int or string)
 *      - Unique identifier for the consumer.
 *      - Justification: Each bill must be tied to a specific household.
 *      - Stored as int for simplicity; could be a string for IDs like "A-102".
 *      - Never negative.
 *
 *   d) Category (int code: 1=Domestic, 2=Commercial, 3=Industrial)
 *      - Determines which tariff rates apply.
 *      - Justification: Different consumer types pay different rates.
 *      - Stored as a small integer (1, 2, or 3).
 *      - Must be validated to be one of the allowed values.
 *
 * 2. OUTPUTS (data the program must COMPUTE and DISPLAY)
 * ──────────────────────────────────────────────────────
 *
 *   a) Units Consumed (int)
 *      - Computed as: current_reading - previous_reading
 *      - Justification: This is the core quantity the bill is based on.
 *      - Always >= 0 (enforced by validation).
 *      - Can be large (thousands of units for industrial).
 *
 *   b) Energy Charge (float/double)
 *      - Computed using tiered/slab rates based on units and category.
 *      - Justification: This is the variable cost proportional to consumption.
 *      - Always >= 0. Can be fractional (e.g., 234.50 currency units).
 *      - Can be very large for industrial consumers.
 *
 *   c) Fixed Charge (float/double)
 *      - A flat fee determined by category, independent of consumption.
 *      - Justification: Covers infrastructure/meter maintenance costs.
 *      - Always >= 0. Typically a small value.
 *      - Never negative.
 *
 *   d) Total Bill (float/double)
 *      - Computed as: energy_charge + fixed_charge
 *      - Justification: The final amount the household must pay.
 *      - RULE: total == energy_charge + fixed_charge (invariant).
 *      - RULE: total >= 0 (a bill is never negative).
 *      - Can be very large for high-consumption industrial users.
 *
 * 3. CONSTANTS (values that NEVER change during a run)
 * ─────────────────────────────────────────────────────
 *
 *   a) Tariff rates per category per slab
 *      - e.g., Domestic: 5.00/unit for first 100, 7.00/unit for next 200, 10.00/unit above 300
 *      - Justification: These are set by the utility company and don't change per-bill.
 *      - Defined as #define or const in the program.
 *
 *   b) Fixed charge per category
 *      - e.g., Domestic: 50.00, Commercial: 100.00, Industrial: 200.00
 *      - Justification: Determined by policy, not by individual consumption.
 *
 *   c) Slab boundaries
 *      - e.g., 100 units, 200 units, 300 units
 *      - Justification: The tier thresholds are fixed by regulation.
 *
 *   d) Category codes
 *      - 1 = Domestic, 2 = Commercial, 3 = Industrial
 *      - Justification: Mapping is fixed and known at compile time.
 *
 * 4. RULES (invariants every correct bill MUST satisfy)
 * ─────────────────────────────────────────────────────
 *
 *   R1: units_consumed = current_reading - previous_reading
 *   R2: units_consumed >= 0  (current must be >= previous)
 *   R3: energy_charge >= 0   (never negative)
 *   R4: fixed_charge >= 0    (never negative)
 *   R5: total_bill = energy_charge + fixed_charge  (exact sum)
 *   R6: total_bill >= 0      (a bill is never negative)
 *   R7: Category must be valid (1, 2, or 3)
 *   R8: Readings must be non-negative integers
 *
 * 5. ASSUMPTIONS
 * ──────────────
 *
 *   A1: Meter readings are cumulative (never reset to zero mid-life).
 *   A2: Current reading is always >= previous reading (no meter tampering).
 *   A3: All monetary values are in the same currency unit (e.g., dollars/rupees).
 *   A4: There are exactly 3 categories with fixed tariff slabs.
 *   A5: The billing period is one month (no pro-rating needed).
 *   A6: No surcharges, taxes, or discounts are applied (can be added later).
 *   A7: Meter readings are integers (whole units).
 *
 * ────────────────────────────────────────────────────────────────────────────
 *  PART 2: ALTERNATIVE CONCEPT — TEXT (STRING) REPRESENTATION
 * ────────────────────────────────────────────────────────────────────────────
 *
 *  If meter readings were stored as character strings (e.g., "01530"):
 *
 *  TIME COMPLEXITY:
 *  ────────────────
 *  - Converting string to int: O(d) where d = number of digits
 *    (each character must be processed: digit = char - '0', accumulate)
 *  - Comparing two readings as strings: O(d) for lexicographic compare,
 *    BUT this is WRONG for numeric comparison ("9" > "10" lexicographically!)
 *    So we MUST convert to integers first: O(d) conversion + O(1) int compare.
 *  - Computing units (subtraction): O(d) to convert both, O(1) to subtract.
 *  - Overall per reading: O(d) for conversion, which is unavoidable.
 *
 *  SPACE COMPLEXITY:
 *  ─────────────────
 *  - String representation: O(d) bytes per reading (d characters + null terminator)
 *    For a 6-digit meter: 7 bytes (6 digits + '\0')
 *  - Integer representation: O(1) bytes per reading (fixed 4 bytes for int)
 *    regardless of the magnitude of the number.
 *  - String wastes space for small readings ("00042" = 6 bytes vs 4 bytes for int)
 *  - For very large readings (>10 digits), string could exceed int range,
 *    requiring long long (still fixed 8 bytes).
 *
 *  CONCLUSION: Integer representation is superior in both time and space:
 *  - Time: O(1) arithmetic vs O(d) string conversion
 *  - Space: O(1) fixed 4 bytes vs O(d) variable bytes
 *  - Correctness: Native integer comparison is correct; string comparison is not
 *
 * ============================================================================
 *  PART 3: C PROGRAM
 * ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>

/* ── CONSTANTS (tariff rates and fixed charges) ── */

/* Domestic (Category 1) */
#define DOMESTIC_SLAB1_LIMIT   100
#define DOMESTIC_SLAB2_LIMIT   200
#define DOMESTIC_RATE1          5.00   /* first 100 units */
#define DOMESTIC_RATE2          7.00   /* next 200 units */
#define DOMESTIC_RATE3         10.00   /* above 300 units */
#define DOMESTIC_FIXED_CHARGE  50.00

/* Commercial (Category 2) */
#define COMMERCIAL_SLAB1_LIMIT 100
#define COMMERCIAL_SLAB2_LIMIT 200
#define COMMERCIAL_RATE1        8.00
#define COMMERCIAL_RATE2       12.00
#define COMMERCIAL_RATE3       18.00
#define COMMERCIAL_FIXED_CHARGE 100.00

/* Industrial (Category 3) */
#define INDUSTRIAL_SLAB1_LIMIT 100
#define INDUSTRIAL_SLAB2_LIMIT 200
#define INDUSTRIAL_RATE1       12.00
#define INDUSTRIAL_RATE2       18.00
#define INDUSTRIAL_RATE3       25.00
#define INDUSTRIAL_FIXED_CHARGE 200.00

/* ── Function: Calculate energy charge based on category and units ── */
double calculate_energy_charge(int units, int category) {
    double charge = 0.0;
    double rate1, rate2, rate3;
    int slab1, slab2;

    /* Select rates based on category */
    switch (category) {
        case 1: /* Domestic */
            rate1 = DOMESTIC_RATE1;
            rate2 = DOMESTIC_RATE2;
            rate3 = DOMESTIC_RATE3;
            slab1 = DOMESTIC_SLAB1_LIMIT;
            slab2 = DOMESTIC_SLAB1_LIMIT + DOMESTIC_SLAB2_LIMIT;
            break;
        case 2: /* Commercial */
            rate1 = COMMERCIAL_RATE1;
            rate2 = COMMERCIAL_RATE2;
            rate3 = COMMERCIAL_RATE3;
            slab1 = COMMERCIAL_SLAB1_LIMIT;
            slab2 = COMMERCIAL_SLAB1_LIMIT + COMMERCIAL_SLAB2_LIMIT;
            break;
        case 3: /* Industrial */
            rate1 = INDUSTRIAL_RATE1;
            rate2 = INDUSTRIAL_RATE2;
            rate3 = INDUSTRIAL_RATE3;
            slab1 = INDUSTRIAL_SLAB1_LIMIT;
            slab2 = INDUSTRIAL_SLAB1_LIMIT + INDUSTRIAL_SLAB2_LIMIT;
            break;
        default:
            return -1.0; /* Error: invalid category */
    }

    /* Tiered (slab-based) calculation */
    if (units <= slab1) {
        charge = units * rate1;
    } else if (units <= slab2) {
        charge = (slab1 * rate1) + ((units - slab1) * rate2);
    } else {
        charge = (slab1 * rate1) + ((slab2 - slab1) * rate2) + ((units - slab2) * rate3);
    }

    return charge;  /* RULE R3: always >= 0 since units >= 0 and rates > 0 */
}

/* ── Function: Get fixed charge based on category ── */
double get_fixed_charge(int category) {
    switch (category) {
        case 1: return DOMESTIC_FIXED_CHARGE;
        case 2: return COMMERCIAL_FIXED_CHARGE;
        case 3: return INDUSTRIAL_FIXED_CHARGE;
        default: return -1.0;
    }
}

/* ── Function: Get category name ── */
const char* get_category_name(int category) {
    switch (category) {
        case 1: return "Domestic";
        case 2: return "Commercial";
        case 3: return "Industrial";
        default: return "Unknown";
    }
}

/* ── Function: Validate inputs ── */
int validate_inputs(int prev_reading, int curr_reading, int category) {
    if (prev_reading < 0) {
        printf("ERROR: Previous reading cannot be negative.\n");
        return 0;
    }
    if (curr_reading < 0) {
        printf("ERROR: Current reading cannot be negative.\n");
        return 0;
    }
    if (curr_reading < prev_reading) {
        printf("ERROR: Current reading (%d) cannot be less than previous reading (%d).\n",
               curr_reading, prev_reading);
        return 0;
    }
    if (category < 1 || category > 3) {
        printf("ERROR: Invalid category %d. Choose 1 (Domestic), 2 (Commercial), or 3 (Industrial).\n",
               category);
        return 0;
    }
    return 1; /* All valid */
}

/* ── Function: Generate and print bill ── */
void generate_bill(int household_no, int prev_reading, int curr_reading, int category) {
    int units;
    double energy_charge, fixed_charge, total_bill;

    /* Validate inputs (Rules R2, R7, R8) */
    if (!validate_inputs(prev_reading, curr_reading, category)) {
        return;
    }

    /* Compute units consumed (Rule R1) */
    units = curr_reading - prev_reading;

    /* Compute energy charge (Rule R3) */
    energy_charge = calculate_energy_charge(units, category);

    /* Get fixed charge (Rule R4) */
    fixed_charge = get_fixed_charge(category);

    /* Compute total (Rules R5, R6) */
    total_bill = energy_charge + fixed_charge;

    /* ── Print the bill ── */
    printf("\n");
    printf("============================================================\n");
    printf("              ELECTRICITY BILL                              \n");
    printf("============================================================\n");
    printf("  Household Number   : %d\n", household_no);
    printf("  Category           : %d (%s)\n", category, get_category_name(category));
    printf("  Previous Reading   : %d\n", prev_reading);
    printf("  Current Reading    : %d\n", curr_reading);
    printf("------------------------------------------------------------\n");
    printf("  Units Consumed     : %d\n", units);
    printf("  Energy Charge      : %.2f\n", energy_charge);
    printf("  Fixed Charge       : %.2f\n", fixed_charge);
    printf("------------------------------------------------------------\n");
    printf("  TOTAL BILL         : %.2f\n", total_bill);
    printf("============================================================\n");

    /* Verification: assert invariants */
    printf("\n  [Verification]\n");
    printf("  Units >= 0?              %s\n", (units >= 0) ? "PASS" : "FAIL");
    printf("  Energy Charge >= 0?      %s\n", (energy_charge >= 0) ? "PASS" : "FAIL");
    printf("  Fixed Charge >= 0?       %s\n", (fixed_charge >= 0) ? "PASS" : "FAIL");
    printf("  Total >= 0?              %s\n", (total_bill >= 0) ? "PASS" : "FAIL");
    printf("  Total = Energy + Fixed?  %s\n",
           (total_bill == energy_charge + fixed_charge) ? "PASS" : "FAIL");
    printf("============================================================\n");
}

/* ── MAIN: Demonstrate with multiple test cases ── */
int main(void) {
    printf("============================================================\n");
    printf("  ELECTRICITY BILLING SYSTEM\n");
    printf("  Analysis & Implementation\n");
    printf("============================================================\n");

    /* Test Case 1: Domestic, low usage (within slab 1) */
    printf("\n--- Test Case 1: Domestic, 75 units (Slab 1 only) ---");
    generate_bill(101, 1200, 1275, 1);
    /* Expected: 75 * 5.00 = 375.00 + 50.00 = 425.00 */

    /* Test Case 2: Domestic, medium usage (crosses into slab 2) */
    printf("\n--- Test Case 2: Domestic, 250 units (Slabs 1 + 2) ---");
    generate_bill(102, 500, 750, 1);
    /* Expected: 100*5 + 150*7 = 500 + 1050 = 1550.00 + 50.00 = 1600.00 */

    /* Test Case 3: Domestic, high usage (all 3 slabs) */
    printf("\n--- Test Case 3: Domestic, 450 units (All 3 slabs) ---");
    generate_bill(103, 1000, 1450, 1);
    /* Expected: 100*5 + 200*7 + 150*10 = 500+1400+1500 = 3400.00 + 50.00 = 3450.00 */

    /* Test Case 4: Commercial, 300 units */
    printf("\n--- Test Case 4: Commercial, 300 units ---");
    generate_bill(201, 2000, 2300, 2);
    /* Expected: 100*8 + 200*12 = 800+2400 = 3200.00 + 100.00 = 3300.00 */

    /* Test Case 5: Industrial, 500 units */
    printf("\n--- Test Case 5: Industrial, 500 units ---");
    generate_bill(301, 5000, 5500, 3);
    /* Expected: 100*12 + 200*18 + 200*25 = 1200+3600+5000 = 9800.00 + 200.00 = 10000.00 */

    /* Test Case 6: Zero consumption */
    printf("\n--- Test Case 6: Domestic, 0 units (same readings) ---");
    generate_bill(104, 1500, 1500, 1);
    /* Expected: 0.00 + 50.00 = 50.00 */

    /* Test Case 7: Error case — current < previous */
    printf("\n--- Test Case 7: Error case (current < previous) ---");
    generate_bill(999, 2000, 1900, 1);
    /* Expected: ERROR message */

    /* Test Case 8: Error case — invalid category */
    printf("\n--- Test Case 8: Error case (invalid category) ---");
    generate_bill(998, 1000, 1100, 5);
    /* Expected: ERROR message */

    printf("\n\n============================================================\n");
    printf("  ALL TEST CASES COMPLETED\n");
    printf("============================================================\n");

    return 0;
}

/*
 * ============================================================================
 *  EXPECTED OUTPUT:
 * ============================================================================
 *
 *  ============================================================
 *    ELECTRICITY BILLING SYSTEM
 *    Analysis & Implementation
 *  ============================================================
 *
 *  --- Test Case 1: Domestic, 75 units (Slab 1 only) ---
 *  ============================================================
 *                ELECTRICITY BILL
 *  ============================================================
 *    Household Number   : 101
 *    Category           : 1 (Domestic)
 *    Previous Reading   : 1200
 *    Current Reading    : 1275
 *  ------------------------------------------------------------
 *    Units Consumed     : 75
 *    Energy Charge      : 375.00
 *    Fixed Charge       : 50.00
 *  ------------------------------------------------------------
 *    TOTAL BILL         : 425.00
 *  ============================================================
 *
 *    [Verification]
 *    Units >= 0?              PASS
 *    Energy Charge >= 0?      PASS
 *    Fixed Charge >= 0?       PASS
 *    Total >= 0?              PASS
 *    Total = Energy + Fixed?  PASS
 *  ============================================================
 *
 *  --- Test Case 2: Domestic, 250 units (Slabs 1 + 2) ---
 *  ... (similar output for each test case)
 *
 *  --- Test Case 7: Error case (current < previous) ---
 *  ERROR: Current reading (1900) cannot be less than previous reading (2000).
 *
 *  --- Test Case 8: Error case (invalid category) ---
 *  ERROR: Invalid category 5. Choose 1 (Domestic), 2 (Commercial), or 3 (Industrial).
 *
 * ============================================================================
 */
