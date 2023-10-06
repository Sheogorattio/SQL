--task1 

select concat('I ','love ', 'SQL ', '(read with suspicioun)');

--task 2

select right('It is a string for substracting a substring', 4);

--task 3
declare @str nvarchar(max) = 'I have an apple and she has an apple'
select concat(replace(left(@str, 15), 'an apple', 'a banana'),right(@str,21))

--task 4
select substring('examle', 3,1);

--task 5
declare @_str nvarchar(max) = ' this is a string with spaces '
select replace(trim(@_str), ' ', '')