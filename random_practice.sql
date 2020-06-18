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

select d.DepartmentName,e.Name,e.Gender,e.Salary from Department d Inner join Employee e on d.Id = e.DepartmentId
select d.DepartmentName,e.Name,e.Gender,e.Salary from Department d Left join Employee e on d.Id = e.DepartmentId

--lets say we dont have access physical table for Employee. Infact we are provided with a function (table-valued function)
-- Run this function after creating it
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


-- Calculating Age properly 
Select DATEDIFF(YEAR, '11/30/1995','01/31/2006') -- difference in years between these two dates is 11 years, which is OK
Select DATEDIFF(YEAR, '11/30/2005','01/31/2006') -- difference in years between these two dates is 1 year, but looking at both dates difference is not 1 year



CREATE FUNCTION fn_ComputeFullAge (@DOB datetime)
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

        DECLARE @Age NVARCHAR(50)
        Set @Age = CONCAT_WS(' ',@years,@months,@days)
        RETURN @Age

    END


select fn_ComputeFullAge('12/30/2019')

