/******************/
/**** Exercises  **/
/******************/

-- Exercise 1
-- Create a trigger that, when adding a new employee, sets the reportsTo attribute 
-- to the employee to whom the least number of employees already report.
CREATE OR ALTER TRIGGER trigger_1 ON Employees FOR INSERT 
As
DECLARE @ReportsTo int

SELECT TOP 1 @ReportsTo = ReportsTo
FROM Employees
WHERE ReportsTo IS NOT NULL
GROUP BY ReportsTo
ORDER BY COUNT(EmployeeID) ASC

DECLARE @NewEmployee int

SELECT @NewEmployee = EmployeeID FROM inserted

UPDATE Employees SET ReportsTo = @ReportsTo
WHERE EmployeeID = @NewEmployee

-- Testcode
BEGIN TRANSACTION
INSERT INTO Employees(LastName,FirstName)
VALUES ('New','Emplo');

SELECT EmployeeID, LastName, FirstName, ReportsTo
FROM Employees
ROLLBACK

-- Exercise 2
/* 
Create a new table called ProductsAudit with the following columns:
AuditID --> Primary Key + Identity
UserName --> NVARCHAR(128) + Default value = SystemUser
CreatedAt --> DateTime + Default value = UTC Time
Operation --> NVARCHAR(10): The name of the operation we performed on a row (Updated, Created, Deleted)

If the table is already present, drop it.
Create a trigger for all actions (Update, Delete, Insert) to persist the mutation of the Products table.
Use system functions to populate the UserName and CreatedAt.
*/
DROP TABLE IF EXISTS ProductsAudit;
CREATE TABLE ProductsAudit(
	AutditID int primary key identity,
	username nvarchar(128) default user,
	createdate datetime default getdate(),
	productid int,
	operation nvarchar(20)
)

CREATE OR ALTER TRIGGER trigger_2 ON Products
FOR INSERT, UPDATE, DELETE
AS

DECLARE @productID int, @operation nvarchar(20)

IF NOT EXISTS(SELECT * FROM inserted)
BEGIN
	SET @operation = 'DELETED'
	SELECT @productID = ProductID FROM deleted
END

ELSE IF NOT EXISTS (SELECT * FROM deleted)
BEGIN
	SET @operation = 'INSERTED'
	SELECT @productID = ProductID FROM inserted
END
else
begin
	set @operation = 'UPDATED'
	select @productid = ProductID from inserted
end

INSERT INTO ProductsAudit(productid, operation)
VALUES(@productid, @operation)

-- TestCode
BEGIN TRANSACTION
DECLARE @productId INT;

SET @productId = 100;
INSERT INTO Products(ProductName, Discontinued)
VALUES('New product100', 0)

UPDATE Products
SET productName = 'abc'
WHERE ProductID = @productId

DELETE FROM Products
WHERE ProductID = @productId

SELECT * FROM ProductsAudit -- Changes should be seen here.
ROLLBACK