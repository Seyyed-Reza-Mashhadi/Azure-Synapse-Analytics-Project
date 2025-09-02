SELECT
    dp.CategoryName,
    SUM(fs.TotalPrice) AS TotalRevenue
FROM
    dbo.FactSales AS fs
JOIN
    dbo.DimProducts AS dp ON fs.ProductID = dp.ProductID
GROUP BY
    dp.CategoryName
ORDER BY
    TotalRevenue DESC;