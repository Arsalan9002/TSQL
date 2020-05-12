USE [ABCCompany]

-- Can we perform a select
-- this will run infinite because we have ran the transaction on Sales order table as a result of which lock is placed on it and
-- as it is in read committed mode we are not able to select
SELECT * 
FROM Sales.SalesOrder;
GO

-- selecing row with ID=1 since we have transaction open on this row from tsql_error_handling.sql file
SELECT *
FROM Sales.SalesOrder WHERE Id = 1;
GO 

-- What about a different row
-- This will give result because lock is placed on row where id=1 
SELECT *
FROM Sales.SalesOrder WHERE Id = 2;
GO

-- selecting record using NOlock where there is lock on row
select * from sales.SalesOrder with (nolock)  where Id=1

-- change the isolation level to read uncommitted 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT *
FROM Sales.SalesOrder WHERE Id = 1;
GO 

SET TRANSACTION ISOLATION LEVEL READ committed
GO

