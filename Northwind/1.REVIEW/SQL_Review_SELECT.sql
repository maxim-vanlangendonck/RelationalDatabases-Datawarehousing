-- Exercises
-- 1. Give the names of all products containing the word 'bröd' or with a name of 7 characters.
SELECT ProductName
FROM Products
WHERE ProductName LIKE 'bröd' OR len(ProductName) = 7

-- 2. Show the productname and the reorderlevel of all products with a level between 10 and 50 (boundaries included)
SELECT ProductName, ReorderLevel
FROM Products
WHERE ReorderLevel BETWEEN 10 AND 50