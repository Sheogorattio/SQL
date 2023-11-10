use master
create database University
go
use University
go
CREATE TABLE Students ( 
StudentID INT PRIMARY KEY, 
FirstName NVARCHAR(50), 
LastName NVARCHAR(50), 
	DateOfBirth DATE );

CREATE TABLE Courses ( CourseID INT PRIMARY KEY, CourseName NVARCHAR(100), ProfessorID INT );


CREATE TABLE Professors
(ProfessorID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50))

CREATE TABLE Enrollments ( EnrollmentID INT PRIMARY KEY, StudentID INT, CourseID INT, EnrollmentDate DATE );

CREATE TABLE Grades ( GradeID INT PRIMARY KEY, EnrollmentID INT, Grade INT );

go

INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth)
VALUES
(1, 'John', 'Doe', '1998-05-15'),
(2, 'Mary', 'Johnson', '1999-09-22'),
(3, 'Alex', 'Smith', '1997-03-10'),
(4, 'Catherine', 'Miller', '2000-11-05'),
(5, 'Dmitri', 'Jones', '1996-07-18');

insert into Professors (ProfessorID, FirstName, LastName)
values
(1, 'John', 'Smith'),
(2, 'Mary', 'Johnson'),
(3, 'Robert', 'Williams'),
(4, 'Jennifer', 'Brown');

insert into Courses (CourseID, CourseName, ProfessorID)
values
(1, 'Introduction to Computer Science', 1),
(2, 'Mathematics for Engineers', 2),
(3, 'History of Art', 3),
(4, 'Physics 101', 4);

insert into Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate)
values
(1, 1, 1, '2023-01-01'),
(2, 1, 2, '2023-01-05'),
(3, 2, 1, '2023-02-01'),
(4, 3, 3, '2023-02-10'),
(5, 4, 4, '2023-03-01');

insert into Grades (GradeID, EnrollmentID, Grade)
values
(6, 1, 90),
(7, 2, 88),
(8, 2, 95),
(9, 3, 80),
(10, 4, 85),
(11, 5, 92),
(12, 5, 90),
(13, 1, 86),
(14, 3, 75),
(15, 4, 89);

go

declare StudentsList cursor for select FirstName, LastName  from Students;

open StudentsList

declare @fName nvarchar(50) = ' ', @sName nvarchar(50) = ' '

while @@FETCH_STATUS = 0
begin
	fetch next from StudentsList into @fName, @sName
	print @fName + ' ' + @sName
end

close StudentsList
deallocate StudentsList

go

declare @ProfessorID int = 1;

declare CourseCursor cursor for
select CourseName
from Courses
where ProfessorID = @ProfessorID;

open CourseCursor;

declare @CourseName nvarchar(100) = ' ';

while @@FETCH_STATUS = 0
begin
	fetch next from CourseCursor into @CourseName;
	if(@@FETCH_STATUS = 0)
	begin
		print 'Professor ' + cast(@ProfessorID as nvarchar(10)) + ' teachs this course: ' + @CourseName;    
	end
end

close CourseCursor;
deallocate CourseCursor;

go

declare @StudentID int;
declare @FirstName nvarchar(50);
declare @LastName nvarchar(50);
declare @CourseName nvarchar(100);

declare StudentCourseCursor cursor for
select s.StudentID, s.FirstName, s.LastName, c.CourseName
from Students s
inner join Enrollments e on s.StudentID = e.StudentID
inner join Courses c on e.CourseID = c.CourseID;

open StudentCourseCursor;

fetch next from StudentCourseCursor into @StudentID, @FirstName, @LastName, @CourseName;

while @@FETCH_STATUS = 0
begin
    print 'Student ' + cast(@StudentID as nvarchar(10)) + ': ' + @FirstName + ' ' + @LastName + ' visits this course: ' + @CourseName;

    fetch next from StudentCourseCursor into @StudentID, @FirstName, @LastName, @CourseName;
end

close StudentCourseCursor;
deallocate StudentCourseCursor;

go

declare @StudentID int;
declare @FirstName nvarchar(50);
declare @LastName nvarchar(50);
declare @AverageGrade float;

declare AverageGradeCursor cursor for
select s.StudentID, s.FirstName, s.LastName, avg(g.Grade) as AverageGrade
from Students s
inner join Enrollments e on s.StudentID = e.StudentID
inner join Grades g on e.EnrollmentID = g.EnrollmentID
group by s.StudentID, s.FirstName, s.LastName;

open AverageGradeCursor;

fetch next from AverageGradeCursor into @StudentID, @FirstName, @LastName, @AverageGrade;

while @@FETCH_STATUS = 0
begin
    print 'Student ' + cast(@StudentID as nvarchar(10)) + ': ' + @FirstName + ' ' + @LastName + ' has an avg grade: ' + cast(@AverageGrade as nvarchar(10));

    fetch next from AverageGradeCursor into @StudentID, @FirstName, @LastName, @AverageGrade;
end

close AverageGradeCursor;
deallocate AverageGradeCursor;

go

declare @CourseID int;
declare @CourseName nvarchar(100);
declare @StudentCount int;

declare StudentCountCursor cursor for
select c.CourseID, c.CourseName, count(e.StudentID) as StudentCount
from Courses c
left join Enrollments e on c.CourseID = e.CourseID
group by c.CourseID, c.CourseName;

open StudentCountCursor;

fetch next from StudentCountCursor into @CourseID, @CourseName, @StudentCount;

while @@FETCH_STATUS = 0
begin
    print 'На курсе ' + cast(@CourseID as nvarchar(10)) + ' (' + @CourseName + ') учатся ' + cast(@StudentCount as nvarchar(10)) + ' студент(ов)';

    fetch next from StudentCountCursor into @CourseID, @CourseName, @StudentCount;
end

close StudentCountCursor;
deallocate StudentCountCursor;
