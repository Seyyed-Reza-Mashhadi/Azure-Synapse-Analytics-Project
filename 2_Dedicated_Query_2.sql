-- Top 5 products by revenue

SELECT TOP 5
    p.ProductName,
    SUM(s.TotalPrice) AS TotalRevenue
FROM dbo.FactSales as s
JOIN dbo.DimProducts as p ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;