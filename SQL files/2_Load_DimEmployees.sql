IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'DimEmployees' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.DimEmployees
	(
	 [EmployeeID] int,
	 [FirstName] nvarchar(4000),
	 [MiddleInitial] nvarchar(4000),
	 [LastName] nvarchar(4000),
	 [BirthDate] datetime2(7),
	 [Gender] nvarchar(4000),
	 [HireDate] datetime2(7),
	 [FullName] nvarchar(4000),
	 [AgeYears] float,
	 [ExperienceYears] float,
	 [CityID] int,
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
--CREATE PROC bulk_load_DimEmployees
--AS
--BEGIN
COPY INTO dbo.DimEmployees
(EmployeeID 1, FirstName 2, MiddleInitial 3, LastName 4, BirthDate 5, Gender 6, HireDate 7, FullName 8, AgeYears 9, ExperienceYears 10, CityID 11, CityName 12, Zipcode 13, CountryID 14, CountryName 15, CountryCode 16)
FROM 'https://adlsgrocery.dfs.core.windows.net/processeddata/DimEmployees.parquet'
WITH
(
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 0
	,CREDENTIAL = ( IDENTITY = 'Managed Identity' )
)
--END
GO

SELECT TOP 100 * FROM dbo.DimEmployees
GO