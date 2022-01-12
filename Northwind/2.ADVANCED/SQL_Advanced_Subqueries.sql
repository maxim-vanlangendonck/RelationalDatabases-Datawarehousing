/* SUBQUERYS */

/* SUBQUERY that returns a single value */

-- What is the UnitPrice of the most expensive product?
SELECT MAX(UnitPrice) As MaxPrice FROM Products

-- What is the most expensive product?
SELECT ProductID, ProductName, UnitPrice As MaxPrice 
FROM Products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products)

-- Alternative?
SELECT TOP 1 ProductID, ProductName, UnitPrice As MaxPrice 
FROM Products ORDER BY UnitPrice DESC


-- Give the products that cost more than average
SELECT ProductID, ProductName, UnitPrice As MaxPrice 
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)


-- Who is the youngest employee from the USA?
SELECT LastName, FirstName
FROM Employees
WHERE Country = 'USA'
AND BirthDate = (SELECT MAX(BirthDate) FROM Employees WHERE Country = 'USA')


/* SUBQUERY that returns a single colum */

-- Give all employees that have processed orders 
SELECT e.EmployeeID, e.FirstName + ' ' + e.LastName As Name
FROM Employees e
WHERE e.EmployeeID IN (SELECT DISTINCT EmployeeID FROM Orders)

-- Alternative?
SELECT DISTINCT e.EmployeeID, e.FirstName + ' ' + e.LastName As Name
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID



-- Give a list of all customers that not yet placed an order
SELECT *
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders)

-- Alternative?
SELECT *
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID is NULL

-- ALL
-- Give all products that are more expensive than the most expensive product with CategoryName = 'Seafood'
SELECT *
FROM Products
WHERE UnitPrice > ALL(SELECT p.UnitPrice FROM Products p INNER JOIN Categories c ON p.CategoryID = c.CategoryID AND c.CategoryName = 'Seafood')

-- Alternatvie?
SELECT *
FROM Products
WHERE UnitPrice > (SELECT MAX(UnitPrice) FROM Products p INNER JOIN Categories c ON p.CategoryID = c.CategoryID AND c.CategoryName = 'Seafood')


-- Give the most expensive product. 
SELECT *
FROM products
WHERE unitprice >= ALL(SELECT unitprice from products)

-- Alternative?
SELECT *
FROM products
WHERE unitprice = (SELECT MAX(unitprice) from products)

-- ANY
-- Give all products that are more expensive than one of the products with CategoryName = 'Seafood'
SELECT *
FROM Products
WHERE UnitPrice > ANY(SELECT p.UnitPrice FROM Products p INNER JOIN Categories c ON p.CategoryID = c.CategoryID AND c.CategoryName = 'Seafood')

-- Alternative?
SELECT *
FROM Products
WHERE UnitPrice > (SELECT MIN(p.UnitPrice) FROM Products p INNER JOIN Categories c ON p.CategoryID = c.CategoryID AND c.CategoryName = 'Seafood')


/* Correlated subquerys */
/*
In a correlated subquery the inner query depends on information from the outer query.
The subquery contains a search condition that refers to the main query, 
which makes the subquery depends on the main query
*/

-- Give employees with a salary larger than the average salary
SELECT FirstName + ' ' + LastName As FullName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)



-- Give the employees whose salary is larger than the average salary of the employees who report to the same boss.
SELECT FirstName + ' ' + LastName As FullName, ReportsTo, Salary
FROM Employees As e
WHERE Salary > (SELECT AVG(Salary) FROM Employees WHERE ReportsTo = e.ReportsTo)


/* Subqueries and the EXISTS operator */
-- Give a list of customers that did not place an order yet
SELECT *
FROM Customers As c
WHERE EXISTS 
(SELECT * FROM Orders WHERE CustomerID = c.customerID)

-- Give all customers that have not placed any orders yet
SELECT *
FROM Customers As c
WHERE NOT EXISTS 
(SELECT * FROM Orders WHERE CustomerID = c.customerID)

-- Alternative?
SELECT *
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID is NULL


-- Alternative?
SELECT *
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders)





/* Subqueries in the FROM clause */
-- Give per region the number of orders (region USA + Canada = North America, rest = Rest of World).
-- Solution 1
SELECT 
CASE c.Country
WHEN 'USA' THEN 'Northern America'
WHEN 'Canada' THEN 'Northern America'
ELSE 'Rest of world' 
END AS Regionclass, COUNT(o.OrderID) As NumberOfOrders
FROM Customers c JOIN Orders o 
ON c.CustomerID = o.CustomerID
GROUP BY
CASE c.Country
WHEN 'USA' then 'Northern America'
WHEN 'Canada' then 'Northern America'
ELSE 'Rest of world' 
END

-- Solution 2 -> avoid copy-paste (subquery in FROM)
SELECT Regionclass, COUNT(OrderID)
FROM
(
SELECT 
CASE c.Country
WHEN 'USA' THEN 'Northern America'
WHEN 'Canada' THEN 'Northern America'
ELSE 'Rest of world' 
END AS Regionclass, o.OrderID
FROM Customers c JOIN Orders o 
ON c.CustomerID = o.CustomerID
) 
AS Totals(Regionclass, OrderID)
GROUP BY Regionclass


/* Subqueries in the SELECT clause */
-- give for each employee how much they earn more (or less) than the average salary of all employees with the same supervisor

SELECT Lastname, Firstname, Salary, 
Salary -
(
    SELECT AVG(Salary)
    FROM Employees
    WHERE ReportsTo = e.ReportsTo
)
FROM Employees e


/* Subqueries in the SELECT and in the FROM clause */

-- Give per productclass the price of the cheapest product and a product that has that price. 


SELECT Category, MinUnitPrice,
(
    SELECT TOP 1 ProductID
    FROM Products
    WHERE CategoryID = Category AND UnitPrice = MinUnitPrice
) As ProductID
FROM
(
    SELECT CategoryID, MIN(UnitPrice)
    FROM Products p
    GROUP BY CategoryID
) AS CategoryMinPrice(Category, MinUnitPrice);


/* Application: running totals */

-- Give the cumulative sum of freight per year
SELECT OrderID, OrderDate, Freight,
(
	SELECT SUM(Freight) 
	FROM Orders
	WHERE YEAR(OrderDate) = YEAR(o.OrderDate) and OrderID <= o.OrderID
) As TotalFreight
FROM Orders o
ORDER BY Orderid;


/* Exercises */

-- 1. Give the id and name of the products that have not been purchased yet. 
SELECT productid, ProductName 
FROM Products
where ProductID NOT IN (Select ProductID from Orders)
-- 2. Select the names of the suppliers who supply products that have not been ordered yet.
select s.CompanyName
from Suppliers s join Products p on s.SupplierID = p.SupplierID
where ProductID not in (select ProductID from OrderDetails)
-- 3. Give a list of all customers from the same country as the customer Maison Dewey
select CompanyName, Country
from Customers
where Country = (select country from Customers where CompanyName = 'Maison Dewey')
-- 4. Calculate how much is earned by the management (like 'president' or 'manager'), the submanagement (like 'coordinator') and the rest
select titleClass, Sum(salary) AS TotalSalary
FROM
(
	SELECT
	CASE
	WHEN title LIKE '%President%' OR title LIKE '%Manager%' THEN 'Management'
	WHEN title LIKE '%Coordinator%' THEN 'SubManagment'
	ELSE 'Rest'
	END, Salary
	FROM Employees
)
AS Totals(TitleClass, Salary)
GROUP BY TitleClass
-- 5. Give for each product how much the price differs from the average price of all products of the same category
SELECT ProductID, ProductName, UnitPrice,
UnitPrice -
(
	SELECT AVG(unitPrice)
	FROM Products
	WHERE CategoryID = p.categoryID
) AS differenceToCategory
FROM Products p
-- 6. Give per title the employee that was last hired
SELECT Title, firstname + ' ' + lastname AS 'name', HireDate
FROM Employees e
WHERE HireDate = (SELECT MAX(Hiredate) From Employees where Title = e.title)
-- 7. Which employee has processed most orders? 
Select e.FirstName + ' '+ e.LastName AS Name, count(*)
from employees e join orders o on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.LastName, e.FirstName
having count(*) = 
(select top 1 count(*)
from employees e join orders o on e.EmployeeID = o.EmployeeID
group by e.FirstName + ' ' + e.LastName
order by count(*) desc);
-- 8. What's the most common ContactTitle in Customers?
SELECT DISTINCT contactTitle
FROM Customers
where ContactTitle = (SELECT top 1 ContactTitle FROM Customers
GROUP BY ContactTitle ORDER BY COUNT(contacttitle) DESC)
-- 9. Is there a supplier that has the same name as a customer?
SELECT CompanyName
FROM Suppliers
where CompanyName IN (SELECT CompanyName FROM Customers)