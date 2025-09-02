-- Top 5 durable most expensive products 
SELECT top 5 *
FROM
    OPENROWSET(
        BULK 'https://adlsgrocery.dfs.core.windows.net/processeddata/DimProducts.parquet',
        FORMAT = 'PARQUET'
    ) AS DimProducts
WHERE DimProducts.Resistant = 'Durable'
ORDER BY
    DimProducts.Price DESC;
