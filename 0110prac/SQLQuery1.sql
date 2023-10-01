use Office

create table Tasks(
	TaskID int identity (1,1) primary key,
	Title nvarchar(max) not null,
	Description nvarchar(max) not null,
	AssignedTo int  not null foreign Key (AssignedTo) references dbo.Employees(EmployeeID),
	DueDate DateTime not null
)


go 

create function GetTasksNumber (@EmployeeID int)
returns int
as
begin
	declare @res int =0
	set @res = (select count(*) 
			   from Tasks
			   where AssignedTo = @EmployeeID and DueDate > getdate())
	return @res
	
end

go
 create table Meetings(
	MeetingID int identity(1,1) primary key not null,
	Title nvarchar(max) not null,
	Date_Time datetime not null check (Date_Time > getdate()),
	Loaction nvarchar(max) not null
 )

 go 
 create function GetMeetings(@FirstDate datetime, @SecondDate datetime)
 returns table
 as
	return (select *
			from Meetings		
			where Date_Time >= @FirstDate and Date_Time <= @SecondDate
	)