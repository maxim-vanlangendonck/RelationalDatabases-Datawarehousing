/* Exercise 9
If there is an update of the Musical_Preferences table where the PreferenceSeq is adjusted, it must be
checked whether the new PreferenceSeq is an allowed value (between 1 and 3)
If not, the transaction must be rolled back and an error should be thrown
In the testcode below, CustomerID = 10001 and StyleID = 10 get's PreferenceSeq = 10
begin try
begin transaction
UPDATE Musical_Preferences
SET PreferenceSeq = 10
WHERE CustomerID = 10001 and StyleID = 10
print 'Update PreferenceSeq = 10 for CustomerID = 10001 and styleID = 10'
select * from Musical_Preferences
WHERE CustomerID = 10001
rollback;
end try
begin catch
DECLARE @e int;
SET @e = ERROR_NUMBER();
PRINT N'Error Procedure = ' + ERROR_PROCEDURE();
PRINT N'Error Message = ' + ERROR_MESSAGE();
end catch */