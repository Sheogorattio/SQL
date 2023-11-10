use University

go

declare @StudentID int;
declare @FirstName nvarchar(50);
declare @LastName nvarchar(50);
declare @RandomNumber int = rand()*(1-5)+5;

declare RandomStudentCursor scroll cursor for
select StudentID, FirstName, LastName
from Students where StudentID = @RandomNumber

open RandomStudentCursor;

while @@FETCH_STATUS = 0
begin

	set @RandomNumber = rand()*(1-5)+5;
	
    fetch absolute @RandomNumber from RandomStudentCursor into @StudentID, @FirstName, @LastName;
	if(@@FETCH_STATUS = 0)
	begin
		print 'Студент: ' + cast(@StudentID as nvarchar(10)) + ', ' + @FirstName + ' ' + @LastName;
	end
end


close RandomStudentCursor;
deallocate RandomStudentCursor;

go

declare @i int = 1;
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

    fetch absolute @i from AverageGradeCursor into @StudentID, @FirstName, @LastName, @AverageGrade;
	set @i +=2;
end

close AverageGradeCursor;
deallocate AverageGradeCursor;
