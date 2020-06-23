Create DATABASE [test-db]

create table AccountType (
    YearOpened int not null,
    AccountType NVARCHAR(5) default NULL,
    Description NVARCHAR(30)
)


create table Account(
    YearOpened int not null,
    AccountType NVARCHAR(5) default NULL,
    UserId int not null
)
--inserting 6 records in Accounts table out of which 2 have NULLS in Account Type column
insert into AccountType VALUES (2018,NULL,'this is the A account')
insert into AccountType VALUES (2018,'A','this is the B account')
insert into AccountType VALUES (2018,'B','this is the default account')
insert into AccountType VALUES (2019,NULL,'this is the default account')
insert into AccountType VALUES (2019,'A','this is the A account')
insert into AccountType VALUES (2019,'B','this is the B account')

--inserting 10 records in Accounts table out of which 4 have NULLS in Account Type column
insert into Account VALUES (2018,NULL,1)
insert into Account VALUES (2018,NULL,2)
insert into Account VALUES (2018,'A',1)
insert into Account VALUES (2018,'B',2)
insert into Account VALUES (2018,'A',1)
insert into Account VALUES (2018,'B',3)
insert into Account VALUES (2019,NULL,1)
insert into Account VALUES (2019,NULL,3)
insert into Account VALUES (2019,'A',1)
insert into Account VALUES (2019,'B',2)

select * from Account
select * from AccountType

-- Joining two tables together would filter out the rows that contains AccountType as NULL
Select a.UserId,t.AccountType,t.YearOpened,t.[Description] from AccountType t join Account a 
    on t.YearOpened = a.YearOpened AND t.AccountType = a.AccountType order by a.UserId


-- 1st Approach USE ISNULL in join condition to fill same value in both tables which wont filter out rows then
Select a.UserId,t.AccountType,t.YearOpened,t.[Description] from AccountType t join Account a 
    on t.YearOpened = a.YearOpened AND 
    ISNULL(t.AccountType,'`') = ISNULL(a.AccountType,'`') order by a.UserId

-- even though the above approach works well and rows with NULL values are also present in result set
-- there are two fundamental problems, firstly we are replacing NULL value with any random value 
-- Secondly query performance can suffer because we have to check every single row for NULL value & convert 
-- it to some other value & would prevent SQL Server to seek indexes


--2nd Approach
Select a.UserId,t.AccountType,t.YearOpened,t.[Description] from AccountType t join Account a 
    on t.YearOpened = a.YearOpened AND 
    (t.AccountType = a.AccountType OR (a.AccountType IS NULL OR t.AccountType IS NULL))
    order by a.UserId
-- efficient approach. Will allow SQL Server to seek indexes still and not scan data row by row

-- Key idea is not to do something that prevents SQL Server to seek indexes
