/* Exercises */
-- 1. Count the amount of products (columnname 'amount of products'), AND the amount of products in stock (= unitsinstock not empty) (columnname 'Units in stock')
SELECT COUNT(ProductID) AS 'Amount of products', SUM(UnitsInStock) AS 'Units in stock'
FROM Products
WHERE UnitsInStock IS NOT NULL
-- 2. How many employees have a function of Sales Representative (columnname 'Number of Sales Representative')? 
SELECT COUNT(EmployeeID) AS 'Number of Employees'
FROM Employees
WHERE Title = 'Sales Representative'
-- 3. Give the date of birth of the youngest employee (columnname 'Birthdate youngest') and the oldest (columnname 'Birthdate oldest').
SELECT MAX(BirthDate) AS 'Birthdate youngest', MIN(BirthDate) AS 'Birthdate oldest'
FROM Employees
-- 4. What's the number of employees who will retire (at 65) within the first 20 years? 
SELECT COUNT(EmployeeID) AS 'Number of employees'
FROM Employees
WHERE DATEDIFF(year, BirthDate,GETDATE()) <= 45
-- 5. Show a list of different countries where 2 of more suppliers are from. Order alphabeticaly. 
SELECT Country
FROM Suppliers
HAVING COUNT(Country) >= 2
ORDER BY Country
-- 6. Which suppliers offer at least 5 products with a price less than 100 dollar? Show supplierId and the number of different products. 
-- The supplier with the highest number of products comes first. 
SELECT SupplierID, COUNT
FROM Suppliers