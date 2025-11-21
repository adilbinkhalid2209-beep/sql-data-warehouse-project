/*
=========================================================================
Quality Checks
=========================================================================
Script Purpose:
  This Script performas various quality checks for data consistency, accuracy,
  and standardization across the 'silver' schema. It includes cehcks for:
  - Null or duplicate primary keys.
  - Unwnated spaces in string fields.
  - Data standardization and consistency.
  - Invalid date ranges and orders.
  - Date consistency between related fields.

Usage Notes:
  - Run these checks after data loading Silver Layer.
  - Investigate and resolve any disrepancies found during the checks.
=========================================================================
*/

-- =================================================
-- Checking for silver.crm_prd_info
-- =================================================
--Check for Nulls or duplicates in Primary Key
-- Expectation: No Result
SELECT
	prd_id,
	COUNT(*) AS prd_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for NULL or Negative Numbers
-- Expectation: No Results
SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0

--Data Standardization & Consistency
SELECT DISTINCT prd_line FROM silver.crm_prd_info

--Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- =================================================
-- Checking for silver.sales_details
-- =================================================
--Check for spaces in sls_order_num
SELECT
	sls_order_num
FROM silver.crm_sales_details
WHERE sls_order_num != TRIM(sls_order_num)

--Check for invalid dates (sls_order_dt)
SELECT
	NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0 or LEN(sls_order_dt) != 8

--Check for invalid dates (sls_ship_dt)
SELECT
	NULLIF(sls_ship_dt, 0) AS sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8

--Check for invalid dates (sls_due_dt)
SELECT
	NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt <=0 OR LEN(sls_due_dt) != 8

--Check for invalid dates (if sls_order_dt is earliest of the other dates)
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--Check for Invalid Sales
SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity*sls_price
OR sls_sales <= 0
OR sls_sales IS NULL

--Check for Invalid quantity
SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_quantity <=0 
OR sls_quantity IS NULL

--Check for Invalid Price
SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_price <=0
OR sls_price IS NULL

-- =================================================
-- Checking for silver.erp_cust_az12
-- =================================================
--Identify Out of Range Dates
--Identify out of range dates
SELECT DISTINCT
	bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

--Data Standardization & Consistency
SELECT DISTINCT gen
FROM silver.erp_cust_az12

-- =================================================
-- Checking for silver.erp_loc_a101
-- =================================================
--Data Standardization & Consistency
SELECT
	DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry

-- =================================================
-- Checking for silver.erp_px_cat_g1v2
-- =================================================
--Check for unwanted spaces
SELECT *
FROM silver.erp_px_cat_g1v2 
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

--Data Standardization & Consistency
SELECT
	Distinct Maintenance
FROM silver.erp_px_cat_g1v2
