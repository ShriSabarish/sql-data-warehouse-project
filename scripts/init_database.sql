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

IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL  -- U for user and creating table related to customer information--
	DROP TABLE bronze.crm_cust_info ;

CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
	) ;

IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL  -- U for user and creating table related to product information--
	DROP TABLE bronze.crm_prd_info ;

CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
	);

IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL  -- U for user and creating table related to sales information--
	DROP TABLE bronze.crm_sales_details ;

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
	);

IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL  -- U for user and creating table related to custID& Country information--
	DROP TABLE bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
	);

IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL  -- U for user and creating table related to custID & bday information--
	DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate DATE,
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

