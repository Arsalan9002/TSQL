-- three types of user defined funcions in TSQL, Scalar Functions (returns single value) and Inline Table Valued functions (returns Table)

-- Usecase SCALAR FUNCTION: Calculating Full Age 
Select DATEDIFF(YEAR, '11/30/1995','01/31/2006') -- difference in years between these two dates is 11 years, which is OK
Select DATEDIFF(YEAR, '11/30/2005','01/31/2006') -- difference in years between these two dates is 1 year, but looking at both dates difference is not 1 year

Alter FUNCTION fn_ComputeFullAge(@DOB datetime)
RETURNS NVARCHAR(50)
    AS
    BEGIN
        Declare @tempdate datetime, @years int ,@days int, @months int
        SET @tempdate = @DOB

        SELECT @years = DATEDIFF(YEAR,@DOB, GETDATE()) - 
                        (CASE WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB)> DAY(GETDATE())) THEN 1 ELSE 0 END)
        SELECT @tempdate = DATEADD(YEAR,@years,@tempdate)


        SELECT @months = DATEDIFF(MONTH, @DOB, GETDATE()) - (CASE WHEN DAY(@DOB) > DAY(GETDATE()) THEN 1 ELSE 0 END)
        SELECT @tempdate = DATEADD(MONTH,@months,@tempdate)

        SELECT @days = DATEDIFF(DAY,@DOB,GETDATE())

        DECLARE @Age NVARCHAR(100)
        Set @Age = CAST(@years AS nvarchar(4))+ ' Years '+ CAST(@months AS nvarchar(2))+ ' Months ' + CAST(@days as nvarchar(3)) + ' Days '
        RETURN @Age

    END


select dbo.fn_ComputeFullAge ('12/30/2019') -- we can also use the function in the where clause to do the comparison


--Table Valued Inline Function
Create table Department
(
    Id int primary key,
    DepartmentName nvarchar(50)
)
Go

Insert into Department values (1, 'IT')
Insert into Department values (2, 'HR')
Insert into Department values (3, 'Payroll')
Insert into Department values (4, 'Administration')
Insert into Department values (5, 'Sales')
Go

Create table Employee
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10),
    Salary int,
    DepartmentId int foreign key references Department(Id)
)
Go

Insert into Employee values (1, 'Mark', 'Male', 50000, 1)
Insert into Employee values (2, 'Mary', 'Female', 60000, 3)
Insert into Employee values (3, 'Steve', 'Male', 45000, 2)
Insert into Employee values (4, 'John', 'Male', 56000, 1)
Insert into Employee values (5, 'Sara', 'Female', 39000, 2)
Go

select * from Department
select * from Employee

-- Cannot use Begin & End clause in Table valued inline function
-- the structure of the returned table (columns etc) will be determined by the Select statement

Alter FUNCTION fn_GetEmployeeDetails (@Salary int)
RETURNS TABLE
as 
RETURN (SELECT Id,Name,Gender,Salary FROM Employee WHERE Salary>=@Salary)

SELECT * from   fn_GetEmployeeDetails(50000) -- we can use any field from fn_GetEmployeeDetails to filter data in where clause

-- it is possible to update the data using 
update fn_GetEmployeeDetails('5000') set Name='Mark_updated' where Id=1
SELECT * from   fn_GetEmployeeDetails(50000)


-- Using table valued functions in combination with OUTER and CROSS APPLY operators
select d.DepartmentName,e.Name,e.Gender,e.Salary from Department d Inner join Employee e on d.Id = e.DepartmentId
select d.DepartmentName,e.Name,e.Gender,e.Salary from Department d Left join Employee e on d.Id = e.DepartmentId

--lets say we dont have access physical table for Employee. Infact we are provided with a function (table-valued function)
Create FUNCTION fn_ReturnDepartmentName (@departmentid int)
RETURNS TABLE
as
RETURN (Select * from Employee where DepartmentId=@departmentid)

--Now lets replace employee table with this function and see results
select d.DepartmentName,e.Name,e.Gender,e.Salary from Department d left join fn_ReturnDepartmentName(d.Id) e on d.Id = e.DepartmentId -- would give error
-- we cannot do a join between a physical table and a table valued function


--Cross Apply (symentically equal to inner join ) and Outer Apply (symentically equal to left outer join) operators 
--Replace inner join operator with cross apply operator. Dont need join condition.
select d.DepartmentName,e.Name,e.Gender,e.Salary from Department d cross apply fn_ReturnDepartmentName(d.Id) e
select d.DepartmentName,e.Name,e.Gender,e.Salary from Department d Outer apply fn_ReturnDepartmentName(d.Id) e




-- Multi-Statement Table Valued Functions
-- we can specify the structure of the table to returned and also we can use Begin & End clause
-- it is not possible to update data using multi statement table valued functions

Alter FUNCTION fn_GetEmployeeList(@Salary int)
RETURNS @Table Table (EmployeeId int, EmployeeName nvarchar(20),Gender NVARCHAR(10), MonthlySalary int)
as 
BEGIN
    INSERT INTO @Table
    SELECT Id, Name,Gender,Salary from Employee where Salary>=@Salary

    RETURN

END

select * from fn_GetEmployeeList(5000) 
update fn_GetEmployeeList('5000') set Name='Mark' where Id=1  
-- invalid column because it is not running update against actual underlying table.
-- cannot modify objects even if we use the column names of the temporary table that is returned by the function

sp_helptext fn_GetEmployeeList -- get the function definition as text


--Schema Binding
-- If the underlying table gets deleted, then function would also become invalid. So, we need to prevent changes (like drop table) for the underlying tables

drop table Employee  -- execute it 
SELECT * from   fn_GetEmployeeDetails(50000)  -- calling function now would give invalid object error

--lets re-create the table again and schema bind it
Create table Employee
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10),
    Salary int,
    DepartmentId int foreign key references Department(Id)
)
Go

Insert into Employee values (1, 'Mark', 'Male', 50000, 1)
Insert into Employee values (2, 'Mary', 'Female', 60000, 3)
Insert into Employee values (3, 'Steve', 'Male', 45000, 2)
Insert into Employee values (4, 'John', 'Male', 56000, 1)
Insert into Employee values (5, 'Sara', 'Female', 39000, 2)
Go


Alter FUNCTION fn_GetEmployeeDetails (@Salary int)
RETURNS TABLE
WITH SCHEMABINDING
as 
RETURN (SELECT Id,Name,Gender,Salary FROM dbo.Employee WHERE Salary>=@Salary)  -- remember to use dbo in select when schemabinding


drop table Employee  -- executing it would not allow to drop the underlying table now


