use master

drop database Office

create database Office

go

use Office

create table Departments(
  DepartmentID int primary key identity(1,1) not null,
  DepartmentName nvarchar(max) not null,
  ManagerID int --unique
 )

  --Во время ввода информации в таблицу Departments невозможно создать больше одной записи со значением NULL в столбце ManagerID, так как 
  --для него(столбца) установлено свойство unique, которое не позволяет добавить запись, если значение дублируется, даже если это NULL.
  --Потому я решил не устанавливать его в этой таблице, хоть это косвенно и нарушает задание.

create table Emloyees(
  EmployeeID int primary key identity(1,1) not null,
  FirstName nvarchar(max) not null,
  LastName nvarchar(max) not null,
  Position nvarchar(max) not null,
  DepartmentId int not null foreign key (DepartmentId) references Departments(DepartmentID)
)

alter table Departments
add constraint FK_ManagerIDToEmloyeeID foreign key (ManagerID) references Emloyees(EmployeeID)

go

insert into Departments ( DepartmentName) values ('Services');
insert into Departments ( DepartmentName) values ('Accounting');
insert into Departments ( DepartmentName) values ('Research and Development');
insert into Departments ( DepartmentName) values ('Legal');
insert into Departments ( DepartmentName) values ('Accounting');

set identity_insert dbo.Emloyees on
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (1, 'Elyssa', 'Anetts', 'Associate Professor', 3);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (2, 'Ruperta', 'Guyver', 'Administrative Assistant III', 5);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (3, 'Jocelin', 'Blackler', 'Accounting Assistant III', 4);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (4, 'Austen', 'Beamson', 'VP Marketing', 2);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (5, 'Sanderson', 'Markovich', 'Database Administrator IV', 5);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (6, 'Margareta', 'Weale', 'General Manager', 1);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (7, 'Gradeigh', 'Conkie', 'Desktop Support Technician', 5);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (8, 'Denver', 'Haselwood', 'GIS Technical Architect', 3);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (9, 'Jacquelynn', 'Pratty', 'Business Systems Development Analyst', 3);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (10, 'Boot', 'Cruddas', 'Chemical Engineer', 5);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (11, 'Anna', 'Castilla', 'General Manager', 1);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (12, 'Eben', 'Blackett', 'Director of Sales', 3);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (13, 'Ernst', 'Tomasian', 'VP Sales', 5);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (14, 'Claretta', 'Hully', 'Programmer II', 2);
insert into Emloyees (EmployeeID, FirstName, LastName, Position, DepartmentId) values (15, 'Ardelis', 'Worgen', 'Geological Engineer', 1);
set identity_insert Emloyees off





go 

create function GetDepartmentManagerName (@DepartmentID INT)
returns nvarchar(max)
as
begin
    declare @ManagerName nvarchar(255)
    select @ManagerName = E.FirstName + ' ' + E.LastName
    from Employees AS E
    INNER JOIN Departments as D on E.EmployeeID = D.ManagerID
    where D.DepartmentID = @DepartmentID
    return @ManagerName
end


go 

create function GetEmployeeFullName (@EmployeeID INT)
returns nvarchar(max)
as
begin
    declare @FullName nvarchar(255)
    select @FullName = FirstName + ' ' + LastName
    from Employees
    where EmployeeID = @EmployeeID
    return @FullName
end