/*************************/
/********Exercises *******/
/*************************/

-- Exercise 1
-- Create the following overview of the number of products per category
/**
Category:          1 Beverages -->         13
Category:          2 Condiments -->         13
Category:          3 Confections -->         13
Category:          4 Dairy Products -->         10
Category:          5 Grains/Cereals -->          7
Category:          6 Meat/Poultry -->          6
Category:          7 Produce -->          5
Category:          8 Seafood -->         12
**/

DECLARE @categoryID INT, @categoryName NVARCHAR(15),
@numberOfProducts INT

-- Declare cursor
DECLARE category_cursor CURSOR
FOR
SELECT c.CategoryID, c.CategoryName, COUNT(p.ProductID)
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, CategoryName


--open cursor
OPEN category_cursor

--fetch data
FETCH NEXT FROM category_cursor INTO @categoryID, @categoryName, @numberOfProducts

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Category: ' + str(@categoryID) + ' --> ' + str(@numberOfProducts)
	FETCH NEXT FROM category_cursor INTO @categoryID, @categoryName, @numberOfProducts
END

-- Exercise 2
-- Give an overview of the employees per country. Use a nested cursor.
/*

* UK
    -          5 Steven Buchanan London
    -          6 Michael Suyama London
    -          7 Robert King London
    -          9 Anne Dodsworth London
* USA
    -          1 Nancy Davolio Seattle
    -          2 Andrew Fuller Tacoma
    -          3 Janet Leverling Kirkland
    -          4 Margaret Peacock Redmond
    -          8 Laura Callahan Seattle
*/
DECLARE @country NVARCHAR(30)
DECLARE @employeeID INT, @fullName NVARCHAR(50), @city NVARCHAR(15)
-- Declare cursor
DECLARE country_cursor CURSOR
FOR
SELECT DISTINCT country
FROM Employees

-- open cursor
OPEN country_cursor

-- fetch data
FETCH NEXT FROM country_cursor INTO @country

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '* ' + @country
	-- begin inner cursor
	DECLARE employees_cursor CURSOR
	FOR
	SELECT EmployeeID, FirstName + ' ' + LastName, City
	FROM Employees
	WHERE Country = @country

	-- open cursor
	OPEN emloyees_cursor

	-- fetch data
	FETCH NEXT FROM employees_cursor INTO @employeeID, @fullName, @city

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT '    - ' + STR(@employeeID) + ' ' + @fullName + ' ' + @fullName + ' ' + @city
		FETCH NEXT FROM employees_cursor INTO @employeeID, @fullName, @city
	END
	
	CLOSE employees_cursor

	-- deallocate cursor
	DEALLOCATE employees_cursor

	-- end inner cursor
	FETCH NEXT FROM country_cursor INTO @country
END

-- close cursor
CLOSE country_cursor

-- deallocate cursor
DEALLOCATE country_cursor




-- Exercise 3
/*
Create an overview of bosses and employees who have
to report to this boss and 
also give the number of employees who have to report to this boss.
Use a nested cursor.

* Andrew Fuller
    -          1 Nancy Davolio
    -          3 Janet Leverling
    -          4 Margaret Peacock
    -          5 Steven Buchanan
    -          8 Laura Callahan
Total number of employees =          5
* Steven Buchanan
    -          6 Michael Suyama
    -          7 Robert King
    -          9 Anne Dodsworth
Total number of employees =          3
*/
DECLARE @reportsTo INT, @bossName NVARCHAR(50), @employeeID INT, @fullName NVARCHAR(50), @numberOfEmployees INT = 0

DECLARE boss_cursor CURSOR
FOR
SELECT DISTINCT reportsTo
FROM Employees
WHERE reportsTo IS NOT NULL

OPEN boss_cursor

FETCH NEXT FROM boss_cursor into @reportsTo

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @bossName = FirstName + ' ' + LastName 
	FROM Employees WHERE EmployeeID = @reportsTo
	PRINT '* ' + @bossName

	SET @numberOfEmployees = 0

	-- begin inner cursor
	DECLARE employees_cursor CURSOR FOR
	SELECT EmployeeID, FirstName + ' ' + LastName
	FROM Employees
	WHERE ReportsTo = @reportsTo

	-- open cursor
	OPEN employees_cursor

	-- fetch data
	FETCH NEXT FROM employees_cursor INTO @employeeID, @fullName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT '        - ' + str(@employeeID) + ' ' + @fullName
		SET @numberOfEmployees += 1
		FETCH NEXT FROM employees_cursor INTO @employeeID, @fullName
	END

	CLOSE employees_cursor
	DEALLOCATE employees_cursor
	PRINT 'Total number of employees = ' + str(@numberOfEmployees)

	FETCH NEXT FROM boss_cursor INTO @reportsTo
END

CLOSE boss_cursor

DEALLOCATE boss_cursor