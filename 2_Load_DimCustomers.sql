IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'DimCustomers' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.DimCustomers
	(
	 [CustomerID] int,
	 [FirstName] nvarchar(4000),
	 [MiddleInitial] nvarchar(4000),
	 [LastName] nvarchar(4000),
	 [Address] nvarchar(4000),
	 [FullName] nvarchar(4000),
	 [CityID] smallint,
	 [CityName] nvarchar(4000),
	 [Zipcode] int,
	 [CountryID] int,
	 [CountryName] nvarchar(4000),
	 [CountryCode] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_DimCustomers
--AS
--BEGIN
COPY INTO dbo.DimCustomers
(CustomerID 1, FirstName 2, MiddleInitial 3, LastName 4, Address 5, FullName 6, CityID 7, CityName 8, Zipcode 9, CountryID 10, CountryName 11, CountryCode 12)
FROM 'https://adlsgrocery.dfs.core.windows.net/processeddata/DimCustomers.parquet'
WITH
(
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 0
	,CREDENTIAL = ( IDENTITY = 'Managed Identity' )
)
--END
GO

SELECT TOP 100 * FROM dbo.DimCustomers
GO