# sql-data-warehouse-project
Building a modern data warehouse with SQL server, including ETL processes, data modeling & analytics.

**🚀 Project Overview**

This project demonstrates an end-to-end data warehousing and analytics solution using SQL Server, covering data ingestion, data quality handling, dimensional modeling, and analytical reporting.

The objective is to transform raw ERP and CRM CSV data into a clean, analytics-ready data warehouse and generate business-driven insights through SQL-based analysis.
This project mirrors real-world enterprise data engineering and BI workflows and is built as a portfolio project for data analyst / BI roles.

          CSV Files (ERP + CRM)
                  ↓
          Staging Tables (Raw Layer)
                  ↓
          Data Cleansing & Validation
                  ↓
          Dimensional Data Model (Star Schema)
                  ↓
          SQL-Based Analytics & Reporting

**🎯 Project Objectives**

**1️⃣ Data Engineering**

Consolidate sales data from multiple source systems (ERP & CRM)
Resolve data quality issues such as:
Missing customer IDs
Duplicate records
Inconsistent country values
Design a star schema optimized for analytical queries
Build a single source of truth for reporting

**2️⃣ Data Analytics & BI**

Create SQL-driven insights on:

Customer behavior
Product performance
Sales trends
Enable business stakeholders to make data-driven decisions

**🗂️ Data Sources**

ERP System (CSV)
Sales transactions
Product information
CRM System (CSV)
Customer details
Geography and demographics
Data was ingested using SQL Server bulk load techniques and staged before transformation.

**🧹 Data Quality & Transformation**

Key data quality challenges addressed:

Removed records with null or invalid Customer IDs
Deduplicated customers appearing across multiple source systems
Standardized country and date formats
Enforced primary and foreign key integrity
Filtered invalid sales transactions (negative quantity, zero price)
All transformations were performed using SQL (CTEs, window functions, aggregations).

**🧱 Data Model (Star Schema)**

Fact Table
Fact_Sales
Sales amount
Quantity
Invoice date
Foreign keys to dimensions
Dimension Tables
Dim_Customer
Dim_Product
Dim_Date
Dim_Country

This structure ensures:

Faster analytical queries
Simplified reporting
Scalability for BI tools

🛠️ **Tools & Technologies**

Database: SQL Server
Language: SQL
Data Modeling: Dimensional (Star Schema)
Data Source Format: CSV
BI Consumption: Designed for Power BI / Tableau integration
