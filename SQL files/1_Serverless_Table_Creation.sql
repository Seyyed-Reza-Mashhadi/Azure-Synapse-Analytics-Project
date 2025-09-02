USE Serverless_SQL_Database;
GO

-- Step 1: Create Master Key (if not exists)
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourStrongPassword123!';
END

GO

-- Step 2: Create Database Scoped Credential for Managed Identity
IF NOT EXISTS (SELECT * FROM sys.database_scoped_credentials WHERE name = 'ManagedIdentity')
BEGIN
    CREATE DATABASE SCOPED CREDENTIAL [ManagedIdentity]
    WITH IDENTITY = 'Managed Identity';
END
GO

-- Create External Data Source 
CREATE EXTERNAL DATA SOURCE Serverless_ExternalData
WITH (
    LOCATION = 'https://adlsgrocery.dfs.core.windows.net/processeddata/',
    CREDENTIAL = [ManagedIdentity]
);
GO

-- Create External File Format
CREATE EXTERNAL FILE FORMAT ParquetFormat
WITH (
    FORMAT_TYPE = PARQUET
);
GO

-- Create External Tables with Corrected Data Types

-- Customer Dimension (Based on `image_bcdf5b.png`)
CREATE EXTERNAL TABLE dbo.DimCustomers (
    CustomerID INT,
    FirstName VARCHAR(8000),
    MiddleInitial VARCHAR(8000),
    LastName VARCHAR(8000),
    Address VARCHAR(8000),
    FullName VARCHAR(8000),
    CityID INT,
    CityName VARCHAR(8000),
    Zipcode INT,
    CountryID INT,
    CountryName VARCHAR(8000),
    CountryCode VARCHAR(8000)
)
WITH (
    LOCATION = 'DimCustomers.parquet',
    DATA_SOURCE = Serverless_ExternalData,  
    FILE_FORMAT = ParquetFormat
);
GO

-- Employee Dimension (Based on `image_bcdf38.png`)
CREATE EXTERNAL TABLE dbo.DimEmployees (
    EmployeeID INT,
    FirstName VARCHAR(8000),
    MiddleInitial VARCHAR(8000),
    LastName VARCHAR(8000),
    BirthDate DATETIME2,
    Gender VARCHAR(8000),
    HireDate DATETIME2,
    FullName VARCHAR(8000),
    AgeYears FLOAT,
    ExperienceYears FLOAT,
    CityID INT,
    CityName VARCHAR(8000),
    Zipcode INT,
    CountryID INT,
    CountryName VARCHAR(8000),
    CountryCode VARCHAR(8000)
)
WITH (
    LOCATION = 'DimEmployees.parquet',
    DATA_SOURCE = Serverless_ExternalData, 
    FILE_FORMAT = ParquetFormat
);
GO

-- Product Dimension (Based on `image_bcdf94.png`)
CREATE EXTERNAL TABLE dbo.DimProducts (
    ProductID INT,
    ProductName VARCHAR(8000),
    Price FLOAT,
    Class VARCHAR(8000),
    ModifyDate DATETIME2,
    Resistant VARCHAR(8000),
    IsAllergic VARCHAR(8000),
    VitalityDays SMALLINT,
    CategoryID INT,
    CategoryName VARCHAR(8000)
)
WITH (
    LOCATION = 'DimProducts.parquet',
    DATA_SOURCE = Serverless_ExternalData,  
    FILE_FORMAT = ParquetFormat
);
GO

-- Fact Table (Based on `image_bcdfd7.png`)
CREATE EXTERNAL TABLE dbo.FactSales (
    SalesID INT,
    EmployeeID INT, 
    CustomerID INT,  
    ProductID INT,  
    Quantity SMALLINT,
    Discount FLOAT,
    TotalPrice FLOAT,
    SalesDate DATETIME2,
    TransactionNumber VARCHAR(8000)
)
WITH (
    LOCATION = 'FactSales.parquet',
    DATA_SOURCE = Serverless_ExternalData,  
    FILE_FORMAT = ParquetFormat
);
GO
