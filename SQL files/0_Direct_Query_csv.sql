SELECT
    COUNT(DISTINCT c.CityID) AS NumberOfCitiesWithSales
FROM
    OPENROWSET(
        BULK 'https://adlsgrocery.dfs.core.windows.net/rawdata/customers.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS c
INNER JOIN
    OPENROWSET(
        BULK 'https://adlsgrocery.dfs.core.windows.net/rawdata/sales.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS s
ON
    c.CustomerID = s.CustomerID;