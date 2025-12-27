/*
============================================================
Create Database and Schemas
============================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database--
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database--
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;

-- Create Table bronze layer -- 
IF OBJECT_ID('bronze.crm_cust_info1','U') IS NOT NULL  -- U for user and creating table related to customer information--
	DROP TABLE bronze.crm_cust_info1 ;

CREATE TABLE bronze.crm_cust_info1 (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date NVARCHAR(50) -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	) ;

IF OBJECT_ID('bronze.crm_prd_info1','U') IS NOT NULL  -- U for user and creating table related to product information--
	DROP TABLE bronze.crm_prd_info1 ;

CREATE TABLE bronze.crm_prd_info1 (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt NVARCHAR(50), -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	prd_end_dt NVARCHAR(50)     -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	);

IF OBJECT_ID('bronze.crm_sales_details1','U') IS NOT NULL  -- U for user and creating table related to sales information--
	DROP TABLE bronze.crm_sales_details1 ;

CREATE TABLE bronze.crm_sales_details1 (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt NVARCHAR(50),    -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	sls_ship_dt NVARCHAR(50),     -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	sls_due_dt NVARCHAR(50),      -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
	);

IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL  -- U for user and creating table related to custID& Country information--
	DROP TABLE bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
	cid NVARCHAR(50),
	cntry NVARCHAR(50)   -- table with no date -- 
	);

IF OBJECT_ID('bronze.erp_cust_az12a','U') IS NOT NULL  -- U for user and creating table related to custID & bday information--
	DROP TABLE bronze.erp_cust_az12a;

CREATE TABLE bronze.erp_cust_az12a (
	cid NVARCHAR(50),
	bdate NVARCHAR(50),   -- if the column has date we cannot directly add date datatype, instead use NVARCHAR
	gen NVARCHAR(50)
	);
	
IF OBJECT_ID('bronze.px_cat_g1v2','U') IS NOT NULL  -- U for user and creating table related to category information--
	DROP TABLE bronze.px_cat_g1v2;

CREATE TABLE bronze.px_cat_g1v2 (
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
	);

TRUNCATE TABLE bronze.crm_cust_info1;	
BULK INSERT bronze.crm_cust_info1
FROM 'D:\data with bara\datawarehouse\datawarehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',', -- run the load only once as we may get duplicate rows & columns -- 
	TABLOCK
	);

select * from bronze.crm_cust_info1;
select cst_marital_status, count(*) from bronze.crm_cust_info
group by cst_marital_status;
select cst_gndr, count(*) from bronze.crm_cust_info
group by cst_gndr;

DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date NVARCHAR(50) -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	) ;
INSERT INTO bronze.crm_cust_info
SELECT
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    TRY_CONVERT(DATE, cst_create_date, 105) -- based on the format in the excel we need to use the conversion --
FROM bronze.crm_cust_info1;                 -- if we use dd-mm-yyyy format use conversion (TRY_CONVERT(DATE, cst_create_date, 105)--

select * from bronze.crm_cust_info;

-- bulk upload of product information -- 
TRUNCATE TABLE bronze.crm_prd_info1;	
BULK INSERT bronze.crm_prd_info1
FROM 'D:\data with bara\datawarehouse\datawarehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',', -- run the load only once as we may get duplicate rows & columns -- 
	TABLOCK
	);
select * from bronze.crm_prd_info1;

-- bulk upload of sales information -- 
TRUNCATE TABLE bronze.crm_sales_details1;	
BULK INSERT bronze.crm_sales_details1
FROM 'D:\data with bara\datawarehouse\datawarehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',', -- run the load only once as we may get duplicate rows & columns -- 
	TABLOCK
	);

	
DROP TABLE bronze.crm_prd_info ;
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt NVARCHAR(50), -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	prd_end_dt NVARCHAR(50)     -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	);

INSERT INTO bronze.crm_prd_info
SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    TRY_CONVERT(DATE, prd_start_dt, 105),   -- if we use dd-mm-yyyy format use conversion (TRY_CONVERT(DATE, cst_create_date, 105)--
    TRY_CONVERT(DATE, prd_end_dt, 105) -- based on the format in the excel we need to use the conversion --
FROM bronze.crm_prd_info1;  

DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt NVARCHAR(50),    -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	sls_ship_dt NVARCHAR(50),     -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	sls_due_dt NVARCHAR(50),      -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
	);

INSERT INTO bronze.crm_sales_details
SELECT
	sls_ord_num ,
	sls_prd_key ,
	sls_cust_id ,
	TRY_CONVERT(DATE, sls_order_dt, 112) ,    -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	TRY_CONVERT(DATE, sls_ship_dt, 112) ,     -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	TRY_CONVERT(DATE, sls_due_dt, 112) ,      -- if the column has date we cannot directly add date datatype, instead use NVARCHAR--
	sls_sales ,
	sls_quantity ,
	sls_price 
FROM bronze.crm_sales_details1;

select * from bronze.crm_sales_details;

DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate NVARCHAR(50),   -- if the column has date we cannot directly add date datatype, instead use NVARCHAR
	gen NVARCHAR(50)
	);

-- bulk upload of customer az12 information -- 
TRUNCATE TABLE bronze.erp_cust_az12a;	
BULK INSERT bronze.erp_cust_az12a
FROM 'D:\data with bara\datawarehouse\datawarehouse\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',', -- run the load only once as we may get duplicate rows & columns -- 
	TABLOCK
	);
select * from bronze.erp_cust_az12a;

-- bulk upload of local a101 information -- 
TRUNCATE TABLE bronze.erp_loc_a101;	
BULK INSERT bronze.erp_loc_a101
FROM 'D:\data with bara\datawarehouse\datawarehouse\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',', -- run the load only once as we may get duplicate rows & columns -- 
	TABLOCK
	);
select * from bronze.erp_loc_a101;

-- bulk upload of category information -- 
TRUNCATE TABLE bronze.px_cat_g1v2;	
BULK INSERT bronze.px_cat_g1v2
FROM 'D:\data with bara\datawarehouse\datawarehouse\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',', -- run the load only once as we may get duplicate rows & columns -- 
	TABLOCK
	);
select * from bronze.px_cat_g1v2;
-- ALL 6 layers are formed -- 
