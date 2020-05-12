USE [master];
GO

-- Checking to see if our database exists and if it does drop it
IF DATABASEPROPERTYEX ('ABCCompany','Version') IS NOT NULL
BEGIN
	ALTER DATABASE [ABCCompany] SET SINGLE_USER
	WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [ABCCompany];
END
GO

CREATE DATABASE [ABCCompany];
GO

ALTER DATABASE [ABCCompany] SET RECOVERY SIMPLE;
GO

USE [ABCCompany];
GO

CREATE SCHEMA [Sales];
GO

CREATE SCHEMA [Bank];
GO

CREATE TABLE [Sales].[SalesPersonLevel] (
	[Id] int identity(1,1) NOT NULL,
	[LevelName] nvarchar(500) NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesPersonLevel] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
	VALUES	('President'),
			('Manager'),
			('Staff');
GO
	
CREATE TABLE [Sales].[SalesPerson] (
	[Id] int identity(1,1) NOT NULL,
	[FirstName] nvarchar(500) NOT NULL,
	[LastName] nvarchar(500) NOT NULL,
	[SalaryHr] decimal(32,2) NULL,
	[ManagerId] int NULL,
	[LevelId] int NOT NULL,
	[Email] nvarchar(500) NULL,
	[StartDate] date NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesPerson] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [FK_SalesPersonLevel] FOREIGN KEY ([LevelId]) REFERENCES [Sales].[SalesPersonLevel] ([Id]),
	CONSTRAINT [FK_SalesPersonManagerId] FOREIGN KEY ([ManagerId]) REFERENCES [Sales].[SalesPerson] ([Id]));
GO

INSERT INTO [Sales].[SalesPerson] ([FirstName],[LastName],[SalaryHr],[ManagerId],[LevelId],[Email],[StartDate]) 
	VALUES	('Tom','Jones',300,1,1,'Tom.Jones@ABCCorp.com','1/5/2016'),
			('Sally','Smith',175,1,2,'Sally.Smith@ABCCorp.com','1/7/2018'),
			('Bill','House',100,2,3,'Bill.House@ABCCorp.com','1/8/2018'),
			('Karen','Knocks',100,2,3,'Karen.Knocks@ABCCorp.com','1/15/2017'),
			('Lisa','James',75,2,3,'Lisa.James@ABCCorp.com','6/1/2018'),
			('Kerrie','Friend',125,2,3,'Kerrie.Friend@ABCCorp.com','8/14/2018'),
			('Jason','Henderson',55,2,3,'Jason.Henderson@ABCCorp.com','1/14/2017'),
			('Wanda','Jones',55,2,3,'Tom.Jones@ABCCorp.com','9/1/2017'),
			('Jared','Lee',65,2,3,'Jared.Lee@ABCCorp.com','9/8/2018'),
			('Tammy','Smith',75,2,3,NULL,'2/5/2018');
GO

ALTER INDEX ALL ON [Sales].[SalesPerson] REBUILD;
GO

CREATE TABLE [Sales].[SalesTerritoryStatus] (
	[Id] int identity(1,1) NOT NULL,
	[StatusName] nvarchar(500) NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesTerritoryStatus] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Sales].[SalesTerritoryStatus] ([StatusName])
	VALUES	('On Hold'),
			('In Progress'),
			('Closed');
GO

CREATE TABLE [Sales].[SalesTerritory] (
	[Id] int identity(1,1) NOT NULL,
	[TerritoryName] nvarchar(500) NOT NULL,
	[Group] nvarchar(500) NULL,
	[StatusId] int NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesTerritory] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [FK_StatusId] FOREIGN KEY ([StatusId]) REFERENCES [Sales].[SalesTerritoryStatus] ([Id]));
GO

INSERT INTO [Sales].[SalesTerritory] ([TerritoryName],[Group],[StatusId]) 
	VALUES	('Northwest','North America',2),
			('Northeast','North America',2),
			('Southwest','North America',2),
			('Southeast','North America',1),
			('Canada','North America',3),
			('France','Europe',1),
			('Germany','Europe',2),
			('Australia','Pacific',2),
			('United Kingdom','Europe',3),
			('Spain','Europe',1);

ALTER INDEX ALL ON [Sales].[SalesTerritory] REBUILD;
GO

CREATE TABLE [Sales].[SalesOrder] (
	[Id] int identity(1,1) NOT NULL,
	[SalesPerson] int NOT NULL,
	[SalesAmount] decimal(36,2) NOT NULL,
	[SalesDate] datetime NOT NULL,
	[SalesTerritory] int NOT NULL,
	[OrderDescription] nvarchar(MAX) NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesOrder] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [FK_SalesPerson] FOREIGN KEY ([SalesPerson]) REFERENCES [Sales].[SalesPerson] ([Id]),
	CONSTRAINT [FK_SalesTerritory] FOREIGN KEY ([SalesTerritory]) REFERENCES [Sales].[SalesTerritory] ([Id]));
GO

INSERT INTO [Sales].[SalesOrder] ([SalesPerson],[SalesAmount],[SalesDate],[SalesTerritory],[OrderDescription]) 
	VALUES (1,2500,'04/05/2019',1,REPLICATE('Sales Description ',10)),
		   (2,3000,'03/02/2019',4,REPLICATE('Sales Description ',10)),
		   (3,4200,'06/02/2019',3,REPLICATE('Sales Description ',10)),
		   (4,1900,'07/01/2019',7,REPLICATE('Sales Description ',10)),
		   (7,2200,'05/15/2019',6,REPLICATE('Sales Description ',10)),
		   (9,5200,'06/03/2019',5,REPLICATE('Sales Description ',10)),
		   (10,7800,'04/13/2019',4,REPLICATE('Sales Description ',10)),
		   (3,4400,'03/23/2019',3,REPLICATE('Sales Description ',10)),
		   (5,1900,'02/15/2019',2,REPLICATE('Sales Description ',10)),
		   (5,7000,'6/09/2019',1,REPLICATE('Sales Description ',10));
GO

ALTER INDEX ALL ON [Sales].[SalesOrder] REBUILD;
GO

-- Create our banking information
CREATE TABLE [Bank].[Savings] (
	[Id] int identity(1,1) NOT NULL,
	[TransactionNotes] nvarchar(50) NOT NULL,
	[Amount] decimal(36,2) NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_Savings] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Bank].[Savings] ([TransactionNotes], [Amount])
	VALUES ('Just Started', 5000.00),
		   ('Mowing Lawns', 500.00),
		   ('Short this month', -1400.00);
GO

CREATE TABLE [Bank].[Checking] (
	[Id] int identity(1,1) NOT NULL,
	[TransactionNotes] nvarchar(50) NOT NULL,
	[Amount] decimal(36,2) NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_Checking] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Bank].[Checking] ([TransactionNotes], [Amount])
	VALUES ('Rent', -1200.00),
		   ('Paycheck', 2000.00),
		   ('Car Payment', -450.00);
GO

-------------****************** environment setup script ends here----------------******************

USE [ABCCompany]


select sum(amount) as Balance, 'Checking'  as [Account Type] from bank.Checking
union all 
select sum(amount) as Balance,'Savings' as [Account Type] from bank.Savings
GO

-- it will insert 1st row but won't insert second because string exceeds the length that could fit in column
insert into Bank.Savings (Amount, TransactionNotes) VALUEs (-500, 'Sorry mom i really needed this')
insert into Bank.Checking (Amount, TransactionNotes) VALUEs (500, 'adding funds adding funds adding funds adding funds adding funds adding funds adding funds')
GO

DELETE FROM Bank.Savings WHERE Amount=-500 AND TransactionNotes='Sorry mom i really needed this'
GO


BEGIN TRY
	BEGIN TRANSACTION;

		insert into Bank.Savings (Amount, TransactionNotes) VALUEs (-500, 'Sorry mom i really needed this')
		insert into Bank.Checking (Amount, TransactionNotes) VALUEs (500, 'adding funds adding funds adding funds adding funds adding funds adding funds adding funds')
	COMMIT TRANSACTION;

END TRY

BEGIN CATCH
	IF(@@trancount > 0)
		ROLLBACK TRANSACTION

		THROW;
END catch



-- cast & try_cast()
select CAST('31 Dec 12' as date) as 'First Date',
		CAST('Dec 12 1776 12:28AM' as date) as 'Second Date',
		CAST('Dec 12 1400 12:28AM' as datetime) as 'Third Date',
		CAST('Number 3' as int) as 'Number 3'


select TRY_CAST('31 Dec 12' as date) as 'First Date',
		TRY_CAST('Dec 12 1776 12:28AM' as date) as 'Second Date',
		TRY_CAST('Dec 12 1400 12:28AM' as datetime) as 'Third Date',
		TRY_CAST('Number 3' as int) as 'Number 3'

--convert & try_convert()
select convert(date,'30 Dec 06',101) as 'First Date',
		convert(int, '00002A') AS '00002A'

select TRY_CONVERT(date,'30 Dec 06',101) as 'First Date',
		TRY_CONVERT(int, '00002A') AS '00002A'

-- Explicit conversion from data type int to xml is not allowed.
select TRY_CONVERT(XML,123) 

-- return some label using case statement when try_convert/try_Cast return NULL 
select case when TRY_CONVERT(int,'00002A') IS NULL THEN 99 END
 


 -- Transactions
 select * from sales.SalesPerson

 -- Autocommit - default mode of SQL Server
 -- these are 3 different transactions executing in a batch
INSERT INTO Sales.SalesPerson (FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
	VALUES	('Susan','Jobes',300,1,2,'Susan.Jobes@ABCCorp.com','6/5/2019');

INSERT INTO Sales.SalesPerson (FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
	VALUES	('Harry','Martin',300,1,2,'Harry.Martin@ABCCorp.com','6/5/2019');

-- this will cause an insert error because foreigin key value 4 does not exist in SalesPersonLevel table
INSERT INTO Sales.SalesPerson (FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
	VALUES	('Karen','Wright',300,1,4,'Karen.Wright@ABCCorp.com','6/5/2019');
GO

select * from sales.SalesPersonLevel where Id=4


--inserting all values in one transaction  this wont insert any value in table because error occurs and everything will be rolled back 
--as opposed to previous scenarion where first two inserts were successful as they belog to different transactions
INSERT INTO Sales.SalesPerson (FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
	VALUES	('Susan','Jobes',300,1,2,'Susan.Jobes@ABCCorp.com','6/5/2019')
			,('Harry','Martin',300,1,2,'Harry.Martin@ABCCorp.com','6/5/2019')
			,('Karen','Wright',300,1,4,'Karen.Wright@ABCCorp.com','6/5/2019');
GO

select count(1) from sales.SalesPerson

-- Implicit transaction
SET IMPLICIT_TRANSACTIONS ON;

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES	('Sr Staff');

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES	('Sr Director');
GO

--check your open transactions
-- Method-1
DBCC OPENTRAN;

--Method-2  using data management view (DMV)
-- open transaction will have 1 with it
SELECT	s.session_id
		,s.open_transaction_count
FROM [sys].[dm_exec_sessions] s
ORDER BY last_request_start_time DESC;

ROLLBACK TRANSACTION

-- at this point even we have rolled back transaction to close it but we still have implicity transaction on
SET IMPLICIT_TRANSACTIONS OFF;

-- another method to check if implicit transaction is truned on
SELECT @@OPTIONS & 2 


-- Explicit transaction
BEGIN TRANSACTION;

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES	('Sr Staff');

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES	('Sr Director');

COMMIT TRANSACTION;
GO

-- Can we rollback DDL statements? YES WE CANT
select * from sales.SalesPersonLevel
select * from sales.SalesOrder
BEGIN TRANSACTION;

	ALTER TABLE Sales.SalesPersonLevel ADD isActive bit NOT NULL DEFAULT 1;

	TRUNCATE TABLE Sales.SalesOrder;

ROLLBACK TRANSACTION;
GO

--for verification
SELECT * 
FROM Sales.SalesPersonLevel;
GO

SELECT *
FROM Sales.SalesOrder;
GO

--check which isolation level we are using
DBCC USEROPTIONS

-- Perform some updates on our salesorder table
BEGIN TRANSACTION;
	UPDATE Sales.SalesOrder SET OrderDescription = NULL;
--run till this point only and then run select statement in isolationtest_read.sql file. select will keep running because table is locked.

-- now run the rollback and again run the select statement in isolationtest_read.sql file
ROLLBACK TRANSACTION;

DBCC OPENTRAN

-- Only try and update one row
BEGIN TRANSACTION;
	UPDATE Sales.SalesOrder SET OrderDescription = NULL WHERE Id = 1;
--run till this point only and then run select statement in isolationtest_read.sql file. selecting row with ID=2 will give us result this time because lock 
-- is placed only on that one row.

-- but still lets rollback the transaction
ROLLBACK TRANSACTION;
GO

--SAVE POINTS
SELECT * FROM SALES.SalesPersonLevel

BEGIN TRANSACTION;
	
	SAVE TRANSACTION Level1;
		INSERT INTO SALES.SalesPersonLevel(LEVELNAME) VALUES ('Vice President')

	SAVE TRANSACTION level2
		INSERT INTO SALES.SalesPersonLevel(LEVELNAME) VALUES ('CIO')

	SAVE TRANSACTION level3
		INSERT INTO SALES.SalesPersonLevel(LEVELNAME) VALUES ('Intern')
GO

SELECT * FROM SALES.SalesPersonLevel -- this would have president, cio and intern in it 

-- gives the count of open transactions in the current session
SELECT @@TRANCOUNT -- this would be 1 because we have issued only one begin transaction command
GO

--lets say we want to rollback till level 3 and remove intern
ROLLBACK TRANSACTION level3
GO

SELECT * FROM SALES.SalesPersonLevel ----- this would only give president and CIO now
GO

COMMIT TRANSACTION LEVEL3
GO

SELECT @@TRANCOUNT
GO


--add custom message to the sys.messages catalog view
exec sp_addmessage 
	@msgnum=50010, 
	@severity=16, 
	@msgtext='Row count does not match'
GO


select message_id, language_id,severity,is_event_logged,text from sys.messages where message_id=50010 -- is_event_logged=0
GO

-- WE ALSO want this message to be logged in error log. for this is_event_logged should be set to 1
EXEC sp_altermessage
	@message_id=50010,
	@parameter='WITH_LOG',
	@parameter_value='TRUE'
GO

select message_id, language_id,severity,is_event_logged,text from sys.messages where message_id=50010 -- is_event_logged=1
GO

-- dropping message we just added
EXEC sp_dropmessage @msgnum=50010
GO


--RAISE ERROR METHOD
 RAISERROR('this is a custom log',16,1) WITH LOG 
 GO


 --TRY Catch

-- we should not enter in the catch block because try block successfully executed
 BEGIN TRY 	
	-- explicit values to be inserted into the identity column of a table.
	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,1,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;

END TRY

BEGIN CATCH

	PRINT 'Does this execute?';

END CATCH
GO

DELETE FROM SALES.SalesPerson WHERE Id IN (13,14,15)
GO

-- preseving error details in variables and using them in raise error
BEGIN TRY 
	
	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	-- this statement is problamatic
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;
	
END TRY

BEGIN CATCH

	DECLARE @ErrorMessage nvarchar(250);
	DECLARE @ErrorSeverity int;
	DECLARE @ErrorState int;
	DECLARE @ErrorLine int;
	
	SELECT	@ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE()
			,@ErrorLine = ERROR_LINE();

	RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState,@ErrorLine);

END CATCH
GO

DELETE FROM SALES.SalesPerson WHERE Id IN (13,14,15)
GO

--XACT_ABORT Behavior
SELECT * FROM Sales.SalesPerson;
GO


-- Using XACT_ABORT ON ***** without an explicit transaction *****
SET XACT_ABORT ON;
	
	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	-- this statement is problamatic
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;
GO

-- xact_abort will insert first row and after it throws error on second insert it does not insert anything from that point onwards
SELECT * FROM Sales.SalesPerson;
GO

DELETE FROM SALES.SalesPerson WHERE Id IN (13,14,15)
GO

-- Using XACT_ABORT ON **** with an explicit transaction ****
SET XACT_ABORT ON;

BEGIN TRANSACTION;
	
	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;

COMMIT TRANSACTION;
GO

-- xact_abort will not insert anything. it rollsback when an exception occurs
SELECT * FROM Sales.SalesPerson;
GO

DELETE FROM SALES.SalesPerson WHERE Id IN (13,14,15)
GO

-- XACT_STATE() and XACT_ABORT() function with each other
SET XACT_ABORT OFF;
BEGIN TRY
	BEGIN TRANSACTION;
	
		SELECT XACT_STATE(); -- Should be 1

		SET IDENTITY_INSERT Sales.Salesperson ON;
	
			INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
			VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

			INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
			VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

			INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
			VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

		SET IDENTITY_INSERT Sales.Salesperson OFF;

	COMMIT TRANSACTION;
END TRY

BEGIN CATCH

	SELECT XACT_STATE(); -- xact_State() returns number (1 for success and -1 for failure)

	IF (XACT_STATE() = -1)
		BEGIN
			PRINT 'Things are not looking good';
			ROLLBACK TRANSACTION;
		END

	IF (XACT_STATE() = 1)
		BEGIN
			PRINT 'At least something works';
			COMMIT TRANSACTION;
		END

END CATCH
GO


-- scenario: ensure that sales order table is not added with inactive sales people (Enforcing business logic)
create or alter PROC [sales].[Insert_SalesOrder]
	@SalesPerson int,
	@SalesAmount DECIMAL(36,2),
	@SalesDate DATE,
	@SalesTerritory INT,
	@OrderDescription NVARCHAR(max)
AS
	BEGIN TRY

		SET XACT_ABORT ON;

			BEGIN TRANSACTION
				IF EXISTS (SELECT 1 FROM Sales.SalesPerson where isActive=0 and Id=@SalesPerson)
					BEGIN
						;THROW 65001, 'please select an active sales person',1
					END
				ELSE
					INSERT INTO sales.SalesOrder (SalesPerson,SalesAmount,SalesDate,SalesTerritory,OrderDescription)
					VALUEs (@SalesPerson,@SalesAmount,@SalesDate,@SalesTerritory,@OrderDescription)
			COMMIT TRANSACTION

	END TRY

	BEGIN CATCH
		--approach 1
		IF(@@TRANCOUNT>0)
			ROLLBACK TRANSACTION;
			THROW;

		--approach 2
		-- SELECT XACT_STATE(); 
		-- IF (XACT_STATE() = -1)
		-- 		ROLLBACK TRANSACTION;
		-- 		THROW;

	END CATCH


EXEC [sales].[Insert_SalesOrder] @SalesPerson=9,@SalesAmount=7500,@SalesDate= '6/1/2019',@SalesTerritory=2, @OrderDescription='regular order'
GO

-- row count mismatch 
create or ALTER PROC [Sales].[Update_SalesPerson_Status]
	@EmployeeNumber VARCHAR(10)
AS
	BEGIN TRY
		SET XACT_ABORT ON;
			DECLARE @RowCount int;

			BEGIN TRANSACTION
				UPDATE sales.SalesPerson SET IsActive=0 where Id = @EmployeeNumber

				SET @ROWCOUNT = @@ROWCOUNT

				IF (@ROWCOUNT > 1 )
					BEGIN
						;THROW 65002,'trying to update more than one row',1
					END
				IF(@RowCount=0)
					BEGIN
						;THROW 65003,'Employee Id does not exist',1
					END
			COMMIT TRANSACTION


	END TRY

	BEGIN CATCH
		IF(XACT_STATE()=-1)
			ROLLBACK TRANSACTION
			;THROW
	END CATCH


EXEC [Sales].[Update_SalesPerson_Status] @EmployeeNumber='100'  -- employee id does not exist


--Error logging table to hold our error messages
drop TABLE if EXISTS [dbo].[ErrorLog]
GO

--creating error log table
CREATE TABLE [dbo].[ErrorLog] (
	[Id] int identity(1,1) NOT NULL,
	[MessageId] int NOT NULL,
	[MessageText] nvarchar(2047) NULL,
	[SeverityLevel] int NOT NULL,
	[State] int NOT NULL,
	[LineNumber] int NOT NULL,
	[ProcedureName] nvarchar(2500) NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_ErrorLogId] PRIMARY KEY CLUSTERED ([Id]));
GO

-- trying to insert in the salesperson table
create or alter proc Insert_SalesPerson_Error_In_ErrorLog
AS
BEGIN TRY
	SET XACT_ABORT ON;
		BEGIN TRANSACTION;
			set IDENTITY_INSERT sales.Salesperson on;

				INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
				VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

			set IDENTITY_INSERT sales.salesperson off;
		COMMIT TRANSACTION;
END TRY

BEGIN CATCH
	IF(XACT_STATE()=-1)
			ROLLBACK TRANSACTION;
				-- we can potentially create an another proc responsible for inserting data into the log table and run it here in catch block
				insert into ErrorLog (MessageId,MessageText,SeverityLevel,[State],LineNumber,ProcedureName)
				values(ERROR_NUMBER(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_LINE(),ERROR_PROCEDURE());

			THROW;
END CATCH

exec Insert_SalesPerson_Error_In_ErrorLog

--CHECK THE ERROR LOG TABLE
SELECT * FROM ErrorLog

