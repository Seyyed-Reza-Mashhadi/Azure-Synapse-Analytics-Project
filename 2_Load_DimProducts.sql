IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'DimProducts' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.DimProducts
	(
	 [ProductID] int,
	 [ProductName] nvarchar(4000),
	 [Price] float,
	 [Class] nvarchar(4000),
	 [ModifyDate] nvarchar(4000),
	 [Resistant] nvarchar(4000),
	 [IsAllergic] nvarchar(4000),
	 [VitalityDays] smallint,
	 [CategoryID] int,
	 [CategoryName] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_DimProducts
--AS
--BEGIN
COPY INTO dbo.DimProducts
(ProductID 1, ProductName 2, Price 3, Class 4, ModifyDate 5, Resistant 6, IsAllergic 7, VitalityDays 8, CategoryID 9, CategoryName 10)
FROM 'https://adlsgrocery.dfs.core.windows.net/processeddata/DimProducts.parquet'
WITH
(
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 0
	,CREDENTIAL = ( IDENTITY = 'Managed Identity' )
)
--END
GO

SELECT TOP 100 * FROM dbo.DimProducts
GO