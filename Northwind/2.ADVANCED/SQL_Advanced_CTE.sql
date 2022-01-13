/* Exercises */

-- 1. Give per region the number of orders (region USA + Canada = North America, rest = Rest of World).
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

-- Solution 3 (with CTE's)
WITH Totals(Regionclass, OrderId) AS
(SELECT 
CASE c.Country
WHEN 'USA' THEN 'Northern America'
WHEN 'Canada' THEN 'Northern America'
ELSE 'Rest of world' 
END AS Regionclass, o.OrderID
FROM Customers c JOIN Orders o 
ON c.CustomerID = o.CustomerID)

SELECT RegionClass, COUNT(OrderID)
FROM Totals
GROUP BY RegionClass


-- 2 Make a histogram of the number of orders per customer, so show how many times each number occurs. 
-- E.g. in the graph below: 1 customer placed 1 order, 2 customers placed 2 orders, 7 customers placed 3 orders, etc. 

/*

nr	NumberOfCustomers
1	1
2	2
3	7
4	6
5	10
6	8
7	7
...

*/

WITH NumberOfOrders(nr) AS
(SELECT count(*)
from orders
group by CustomerID)

SELECT nr, Count(*) as NumberOfCustomers
FROM NumberOfOrders
GROUP BY nr
Order by nr;
-- 3. Give the customers of the Country in which most customers live
WITH cte1(Country, NumberOfCustomers)
AS
(SELECT Country, COUNT(CustomerID)
FROM Customers
GROUP BY Country),

cte2(MaximumNumberOfCustomers)
AS
(SELECT MAX(NumberOfCustomers)
FROM cte1)

SELECT CustomerID, CompanyName, c.Country
FROM Customers c JOIN cte1 ON c.Country = cte1.Country
JOIN cte2 ON cte1.NumberOfCustomers = cte2.MaximumNumberOfCustomers


-- 4. Give all employees except for the eldest
-- Solution 1 (using Subqueries)
SELECT EmployeeID, FirstName + ' ' + LastName AS EmployeeName, BirthDate
FROM Employees
WHERE Birthdate > (SELECT MIN(BirthDate) FROM Employees)

-- Solution 2 (using CTE's)
WITH eldest(min_birtdate) AS
(SELECT min(BirthDate)
FROM Employees)

SELECT EmployeeID, FirstName + ' ' + LastName AS EmployeeName, BirthDate
FROM Employees CROSS JOIN eldest
WHERE BirthDate > eldest.min_birtdate



-- 5.  What is the total number of customers and suppliers?
WITH totalNumberOfCustomers(nrOfCust) AS
(SELECT COUNT(CustomerID) FROM Customers),
totalNumberOfSuppliers(nrOfSup) AS
(SELECT COUNT(SupplierID) FROM Suppliers)

SELECT ((SELECT nrOfCust FROM totalNumberOfCustomers) + 
(SELECT nrOfSup FROM totalNumberOfSuppliers)) AS 'Total number of Customers en Suppliers'

-- 6. Give per title the eldest employee
WITH eldestPerTitle(title, min_birtdate) AS
(SELECT Title, min(BirthDate)
FROM Employees
GROUP BY Title)

SELECT e.EmployeeID, ept.Title, ept.min_birtdate
FROM Employees e JOIN eldestPerTitle ept ON e.Title = ept.title
WHERE e.BirthDate = ept.min_birtdate

-- 7. Give per title the employee that earns most
WITH mostEarningTitle(Title, max_salary) AS
(SELECT Title, MAX(Salary)
FROM Employees
GROUP BY Title)

SELECT e.EmployeeID, FirstName + ' ' + LastName AS EmployeeName, met.max_salary, met.Title
FROM Employees e JOIN mostEarningTitle met ON e.Title = met.Title
WHERE e.Salary = met.max_salary
-- 8. Give the titles for which the eldest employee is also the employee who earns most
WITH eldestPerTitle(title, min_birthdate) AS
(SELECT Title, min(BirthDate)
FROM Employees
GROUP BY Title),

mostEarningTitle(Title, max_salary) AS
(SELECT Title, MAX(Salary)
FROM Employees
GROUP BY Title)

SELECT EmployeeID, ept.Title, ept.min_birthdate, met.max_salary
FROM Employees e JOIN eldestPerTitle ept ON e.Title = ept.title
JOIN mostEarningTitle met ON ept.title = met.Title
WHERE e.BirthDate = ept.min_birthdate AND e.Salary = met.max_salary

-- 9. Execute the following script:
CREATE TABLE Parts 
(
    [Super]   CHAR(3) NOT NULL,
    [Sub]     CHAR(3) NOT NULL,
    [Amount]  INT NOT NULL,
    PRIMARY KEY(Super, Sub)
);

INSERT INTO Parts VALUES ('O1','O2',10);
INSERT INTO Parts VALUES ('O1','O3',5);
INSERT INTO Parts VALUES ('O1','O4',10);
INSERT INTO Parts VALUES ('O2','O5',25);
INSERT INTO Parts VALUES ('O2','O6',5);
INSERT INTO Parts VALUES ('O3','O7',10);
INSERT INTO Parts VALUES ('O6','O8',15);
INSERT INTO Parts VALUES ('O8','O11',5);
INSERT INTO Parts VALUES ('O9','O10',20);
INSERT INTO Parts VALUES ('O10','O11',25);

-- Show all parts that are directly or indirectly part of O2, so all parts of which O2 is composed.
-- Add an extra column with the path as below: 

/*
SUPER	SUB		PAD
O2		O5		O2 <-O5
O2		O6		O2 <-O6
O6		O8		O2 <-O6 <-O8
O8		O11		O2 <-O6 <-O8 <-O11

*/

WITH Relation(Super, Sub, [Path]) AS
(
-- Default
SELECT Super, Sub, [Path] = CAST(CONCAT(Super, ' <- ', Sub) AS nvarchar(MAX))
FROM Parts
WHERE Super = '02'

-- Recursion
UNION ALL
SELECT Parts.Super, Parts.Sub, [Path] = CONCAT(Relation.[PATH], ' <- ', Parts.Sub)
FROM Parts JOIN Relation ON Parts.Super = Relation.Sub )

SELECT * FROM Relation;