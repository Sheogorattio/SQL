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


