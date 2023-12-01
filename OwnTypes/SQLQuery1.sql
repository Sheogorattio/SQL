use master;

go

use LibraryDB;

go

create type MyBookTitle from nvarchar(100);

go

drop table Books;

go

create table Books
(
	BookID INT PRIMARY KEY IDENTITY(1,1), 
	Title MyBookTitle NOT NULL,
	Author NVARCHAR(100) NOT NULL, 
	PublicationYear INT, 
	Genre NVARCHAR(50) NOT NULL, 
	CopiesAvailable INT
);

go

create rule CopiesLimit as
@range >= 0 and @range < 10;

go

exec sp_bindrule CopiesLimit, 'Books.CopiesAvailable';

go

create rule AgeLimit as 
@age >= 1600;

go

exec sp_bindrule AgeLimit, 'Books.PublicationYear';

go

exec sp_unbindrule 'Books.PublicationYear';

go
drop rule AgeLimit;

go
create rule AgeLimit as 
@age >= 1800;

go

exec sp_bindrule AgeLimit, 'Books.PublicationYear';

go


go
INSERT INTO Books ( Title, Author, PublicationYear, Genre, CopiesAvailable) VALUES
( 'To Kill a Mockingbird', 'Harper Lee', 1960, 'Fiction', 5),
( '1984', 'George Orwell', 1949, 'Science Fiction', 7),
( 'The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'Fiction', 3),
( 'Pride and Prejudice', 'Jane Austen', 1813, 'Fiction', 8),
( 'The Catcher in the Rye', 'J.D. Salinger', 1951, 'Fiction', 4),
( 'The Hobbit', 'J.R.R. Tolkien', 1937, 'Fantasy', 6),
--( 'The Lord of the Rings', 'J.R.R. Tolkien', 1954, 'Fantasy', 10),
( 'Brave New World', 'Aldous Huxley', 1932, 'Science Fiction', 5),
( 'Fahrenheit 451', 'Ray Bradbury', 1953, 'Science Fiction', 6),
( 'The Alchemist', 'Paulo Coelho', 1988, 'Fiction', 4),
( 'Moby-Dick', 'Herman Melville', 1851, 'Adventure', 2),
( 'War and Peace', 'Leo Tolstoy', 1869, 'Historical Fiction', 3),
--( 'The Odyssey', 'Homer', -800, 'Epic', 7),
( 'Crime and Punishment', 'Fyodor Dostoevsky', 1866, 'Crime', 5),
( 'The Shining', 'Stephen King', 1977, 'Horror', 4)


create table #HorrorTable(
	BookTitle nvarchar(100) not null,
	Genre nvarchar(50) NOT NULL
);

go

create table ##After1982
(
	BookTitle nvarchar(100) not null,	
	PublicationYear int 
);

go

declare horror_cur cursor scroll for
select Title, Genre from Books;

open horror_cur
declare @i int = 8;
declare @title nvarchar(100), @genre nvarchar(50);
while @@FETCH_STATUS =0 
begin 
	fetch absolute @i from horror_cur into @title, @genre;
	print(@@fetch_status);
	if(@genre = 'Horror')
	begin
		insert into #HorrorTable (BookTitle,Genre) values
		(@title, @genre)
	end
	set @i+=1;
end
close horror_cur;
deallocate horror_cur;


go

	declare @year int;
	declare @name nvarchar(100);
	declare publication_cur cursor scroll
	for select Title, PublicationYear from Books;
 
	open cur_ice
	declare @i int=1
	while @@FETCH_STATUS =0
	begin
		fetch absolute @i from publication_cur into @name, @year
		if(@@FETCH_STATUS =0 and @year>1982) 
		begin
			insert into ##After1982 (BookTitle,PublicationYear) values
			(@name, @year)
		end
		set @i+=1
	end
 
	close publication_cur
	deallocate publication_cur

--print(@@fetch_status);
--select * from #HorrorTable