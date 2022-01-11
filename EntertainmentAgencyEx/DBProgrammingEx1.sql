-- Exercise 1
-- Write a SP add_musical_style to add a new musical style, given the stylename of the new musical style (=
-- parameter).
-- First check if the stylename doesn't already exist. If so throw an exception.
-- Use an output parameter to pass the result back to the user: 1 if the insert succeeded and 0 if the insert
-- didn't succeed
-- Use the following testcode

-- Testcode 1: add Dance music => no problem
begin try
begin transaction
DECLARE @result tinyint
EXEC add_musical_style 'Dance music', @result
print 'Dance music inserted or not: ' + str(@result)
select * from Musical_Styles
rollback;
end try
begin catch
DECLARE @e int;
SET @e = ERROR_NUMBER();
PRINT N'Error Procedure = ' + ERROR_PROCEDURE();
PRINT N'Error Message = ' + ERROR_MESSAGE();
end catch
-- Testcode 2: add Classical => Error because Classical already exists
begin try
begin transaction
DECLARE @result tinyint
EXEC add_musical_style 'Classical', @result
print 'Classical inserted or not: ' + str(@result)
select * from Musical_Styles
rollback
end try
begin catch
DECLARE @e int;
SET @e = ERROR_NUMBER();
PRINT N'Error Procedure = ' + ERROR_PROCEDURE();
PRINT N'Error Message = ' + ERROR_MESSAGE();
end catch