-- Method 3: Quick primary key status check
SELECT 
    'DimCustomers' AS TableName,
    CASE WHEN EXISTS (
        SELECT 1 FROM sys.key_constraints kc 
        JOIN sys.tables t ON kc.parent_object_id = t.object_id
        WHERE t.name = 'DimCustomers' AND kc.type = 'PK' AND t.schema_id = SCHEMA_ID('dbo')
    ) THEN 'HAS PRIMARY KEY' ELSE 'NO PRIMARY KEY' END AS Status
UNION ALL
SELECT 'DimEmployees',
    CASE WHEN EXISTS (
        SELECT 1 FROM sys.key_constraints kc 
        JOIN sys.tables t ON kc.parent_object_id = t.object_id
        WHERE t.name = 'DimEmployees' AND kc.type = 'PK' AND t.schema_id = SCHEMA_ID('dbo')
    ) THEN 'HAS PRIMARY KEY' ELSE 'NO PRIMARY KEY' END
UNION ALL
SELECT 'DimProducts',
    CASE WHEN EXISTS (
        SELECT 1 FROM sys.key_constraints kc 
        JOIN sys.tables t ON kc.parent_object_id = t.object_id
        WHERE t.name = 'DimProducts' AND kc.type = 'PK' AND t.schema_id = SCHEMA_ID('dbo')
    ) THEN 'HAS PRIMARY KEY' ELSE 'NO PRIMARY KEY' END
UNION ALL
SELECT 'FactSales',
    CASE WHEN EXISTS (
        SELECT 1 FROM sys.key_constraints kc 
        JOIN sys.tables t ON kc.parent_object_id = t.object_id
        WHERE t.name = 'FactSales' AND kc.type = 'PK' AND t.schema_id = SCHEMA_ID('dbo')
    ) THEN 'HAS PRIMARY KEY' ELSE 'NO PRIMARY KEY' END;
