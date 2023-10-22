use master 
create database Shop_TriggerPrac

go

use Shop_TriggerPrac

create table Category(
	id int identity(1,1) primary key not null,
	discount float not null
)
	
CREATE TABLE Products (
id INT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
price money not null,
quantity INT NOT NULL,
category_id int not null, foreign key (category_id) references Category(id)
);
-- Создаем таблицу "Заказы"
CREATE TABLE Orders (
id INT PRIMARY KEY,
order_date DATE NOT NULL,
product_id INT,
quantity INT NOT NULL,
FOREIGN KEY (product_id) REFERENCES Products(id)
);
-- Создаем таблицу "Stock"
CREATE TABLE Stock (
id INT PRIMARY KEY,
product_id INT,
quantity INT NOT NULL,
FOREIGN KEY (product_id) REFERENCES Products(id)
);
-- Создаем триггер для уменьшения количества продуктов на складе при новом заказе
go
CREATE TRIGGER trUpdateStock
ON Orders
AFTER INSERT 
AS
BEGIN
UPDATE Stock
SET quantity = quantity - (select inserted.quantity from inserted)
WHERE product_id = (select inserted.product_id from inserted)
END;

go
create trigger trDiscountUpdate
on Category
after update
as
begin
if(0!=(select inserted.discount from inserted))
begin
update Products
set price -= (select inserted.discount from inserted) * price
where category_id = (select inserted.id from inserted)
end
end

insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);
insert into Category (discount) values (0);

insert into Products (id, name, price, quantity, category_id) values (1, 'Tarragon - Fresh', 93, 804, 7);
insert into Products (id, name, price, quantity, category_id) values (2, 'Danishes - Mini Raspberry', 83, 505, 6);
insert into Products (id, name, price, quantity, category_id) values (3, 'Bread - Burger', 95, 486, 2);
insert into Products (id, name, price, quantity, category_id) values (4, 'Sauce - Hoisin', 62, 825, 6);
insert into Products (id, name, price, quantity, category_id) values (5, 'Mcguinness - Blue Curacao', 18, 820, 4);
insert into Products (id, name, price, quantity, category_id) values (6, 'Roe - Flying Fish', 26, 844, 13);
insert into Products (id, name, price, quantity, category_id) values (7, 'Soupcontfoam16oz 116con', 98, 356, 9);
insert into Products (id, name, price, quantity, category_id) values (8, 'Parsley Italian - Fresh', 98, 242, 13);

go 
update Category
set discount = 0.1
where id =7



