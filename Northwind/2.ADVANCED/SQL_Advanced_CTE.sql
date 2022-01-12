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
GROUP BY Region


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
FROM NumbersOfOrders
GROUP BY nr
Order by nr;
-- 3. Give the customers of the Country in which most customers live



-- 4. Give all employees except for the eldest
-- Solution 1 (using Subqueries)


-- Solution 2 (using CTE's)




-- 5.  What is the total number of customers and suppliers?


-- 6. Give per title the eldest employee


-- 7. Give per title the employee that earns most

-- 8. Give the titles for which the eldest employee is also the employee who earns most


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