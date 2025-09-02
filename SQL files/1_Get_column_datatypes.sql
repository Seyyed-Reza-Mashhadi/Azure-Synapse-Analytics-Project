EXEC sp_describe_first_result_set N'
    SELECT TOP 1 *
    FROM OPENROWSET(
        BULK ''https://adlsgrocery.dfs.core.windows.net/processeddata/FactSales.parquet'',
        FORMAT = ''PARQUET''
    ) AS r;
';

EXEC sp_describe_first_result_set N'
    SELECT TOP 1 *
    FROM OPENROWSET(
        BULK ''https://adlsgrocery.dfs.core.windows.net/processeddata/DimProducts.parquet'',
        FORMAT = ''PARQUET''
    ) AS r;
';


EXEC sp_describe_first_result_set N'
    SELECT TOP 1 *
    FROM OPENROWSET(
        BULK ''https://adlsgrocery.dfs.core.windows.net/processeddata/DimCustomers.parquet'',
        FORMAT = ''PARQUET''
    ) AS r;
';


EXEC sp_describe_first_result_set N'
    SELECT TOP 1 *
    FROM OPENROWSET(
        BULK ''https://adlsgrocery.dfs.core.windows.net/processeddata/DimEmployees.parquet'',
        FORMAT = ''PARQUET''
    ) AS r;
';