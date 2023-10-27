
--task 1
begin
  DECLARE @name nvarchar(25), @price float
  DECLARE cur_ice CURSOR SCROLL
  FOR SELECT Name, Price FROM IceCream
 
  OPEN cur_ice
  FETCH ABSOLUTE 2 FROM	cur_ice InTO @name, @price
  PRINT @name + ' ' + CAST(@price AS nvarchar(10))

  FETCH LAST  FROM cur_ice INTO @name, @price
  FETCH RELATIVE -1 FROM cur_ice INTO @name, @price
  PRINT @name + ' ' + CAST(@price AS nvarchar(10))

  CLOSE cur_ice
  DEALLOCATE cur_ice
end
 
 go
--task 2
begin
 	declare @name nvarchar(25), @price float

	declare cur_ice cursor scroll
	for select Name, Price from IceCream

	open cur_ice
	declare @i int=2
	while @@FETCH_STATUS =0
	begin
		fetch absolute @i from cur_ice into @name, @price
		if(@@FETCH_STATUS =0)
		begin
			print @name + ' ' + CAST(@price AS nvarchar(10))
		end
		set @i+=2
	end

	close cur_ice
  	deallocate cur_ice
end
 

