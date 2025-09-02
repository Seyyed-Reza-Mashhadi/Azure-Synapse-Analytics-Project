IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'FactSales' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.FactSales
	(
	 [SalesID] int,
	 [EmployeeID] int,
	 [CustomerID] int,
	 [ProductID] int,
	 [Quantity] smallint,
	 [Discount] float,
	 [TotalPrice] float,
	 [SalesDate] datetime2(7),
	 [TransactionNumber] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_FactSales
--AS
--BEGIN
COPY INTO dbo.FactSales
(SalesID 1, EmployeeID 2, CustomerID 3, ProductID 4, Quantity 5, Discount 6, TotalPrice 7, SalesDate 8, TransactionNumber 9)
FROM 'https://adlsgrocery.dfs.core.windows.net/processeddata/FactSales.parquet'
WITH
(
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 0
	,CREDENTIAL = ( IDENTITY = 'Managed Identity' )
)
--END
GO

SELECT TOP 100 * FROM dbo.FactSales
GO