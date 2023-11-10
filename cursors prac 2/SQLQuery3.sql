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