use master
use IceCream
go

create trigger task1
on IceCream
after update
as
begin
	declare message_cur cursor scroll
	for select Name, StockQuantity from  dbo.IceCream

	open message_cur

	declare @i int = 1
	declare @name nvarchar(25), @quantity int
	while @@FETCH_STATUS =0
	begin
		fetch absolute @i from message_cur into @name, @quantity
		if(@@FETCH_STATUS =0)
		begin
			print @name + ' ' + CAST(@quantity AS nvarchar(10))
		end
		set @i+=1
	end
	close message_cur
	deallocate message_cur
end
go
update IceCream
set StockQuantity = 17
where Name = 'Ваниль'

--go

--drop trigger task1

go

create trigger task2
on OrderHistory
after insert
as
begin
	declare @total_cost float = 0
	set @total_cost = (select Price from IceCream where ID = (select inserted.IceCream from inserted)) * (select inserted.Quantity from inserted)
	print cast(@total_cost as nvarchar(max))
	update Orders
	set TotalCost = @total_cost
	where OrderId = (select inserted.OrderID from inserted)
	select TotalCost from Orders
end

go
insert into Orders (OrderID,OrderDate, Quantity) values (5,GETDATE(),3)
insert into OrderHistory (HistoryId,OrderID, IceCream, Quantity) values (5, 5, 3, 3)

--go
--drop trigger task2

go

create trigger task3
on Orders
after insert
as
begin
	declare cur_index cursor scroll
	for select HistoryId from OrderHistory

	declare @last_index int = 0, @i int =0
	open cur_index

	while @@FETCH_STATUS = 0
	begin
		fetch absolute @i from message_cur into @last_index
		--if(@@FETCH_STATUS =1 )
		--begin
		--end
		set @i+=1
	end
	close cur_index
	deallocate cur_index


	insert into OrderHistory (HistoryId, OrderID, IceCream, Quantity)
	values (@last_index, (select inserted.OrderId from inserted), null, (select inserted.Quantity from inserted) )
end

go
insert into Orders (OrderId, OrderDate, Quantity, TotalCost) values (7 , getdate() , 9, null)

--go
--drop trigger task3
go
drop table OrderHistory -- тут нужно было пересо=зать таблицу заказов, чтобы добавить поле с именем мороженого
drop table Orders
go
create table Orders(
	OrderId int primary key not null,
	OrderDate datetime,
	Quantity int ,
	TotalCost decimal(10,2),
	IceCreamName nvarchar(50)
)
create table OrderHsitory(
	HistoryId int primary key not null,
	OrderID int foreign key references Orders(OrderId),
	IceCream int foreign key references IceCream(ID),
	Quantity int
)

go
create trigger task4
on Orders
instead of insert
as
begin
	
		
	if(( select inserted.Quantity from inserted)> (select StockQuantity from IceCream where Name = (select inserted.IceCreamName from inserted)))
	begin
		declare @ice_quant int = (select inserted.Quantity from inserted)
		raiserror( 'Недостатньо морозива на складі. Замовлення не може бути оформлене.',16,1)
		rollback;
	end
end
go

insert into Orders (OrderId, OrderDate, Quantity, TotalCost, IceCreamName) values (3, getdate(), 2000, 98, 'Ваниль')
insert into Orders (OrderId, OrderDate, Quantity, TotalCost, IceCreamName) values (4, getdate(), 2, 98, 'Ваниль')

--go
--drop trigger task4

go
create trigger task5
on IceCream
after update
as
begin
	declare @ice_name nvarchar(25) = (select inserted.Name from inserted), @price decimal(10,2) =(select inserted.Price from inserted), @quant int = (select inserted.Quantity from inserted)
	print 'Data has been updated: ' + cast(@ice_name as nvarchar(max)) + cast(@price as nvarchar(max)) + cast(@quant as nvarchar(max))
end