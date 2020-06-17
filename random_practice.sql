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
