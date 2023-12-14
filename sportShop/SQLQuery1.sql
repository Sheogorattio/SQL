use SportStore;

create table Products(
    product_id int primary key identity(1,1),
    product_name nvarchar(255) not null,
    product_type nvarchar(255) not null,
    quantity_in_stock int not null,
    cost money not null,
    manufacturer nvarchar(255) not null,
    selling_price money not null
);

create table Customers(
    customer_id int primary key identity(1,1),
    full_name nvarchar(255) not null,
    email nvarchar(100) not null,
    phone_number nvarchar(15) not null,
    gender nvarchar(10) not null,
    order_history nvarchar(255),
    discount_percent int not null,
    subscribed_to_newsletter bit not null
);

create table Employees(
    employee_id int primary key identity(1,1),
    full_name nvarchar(255) not null,
    position nvarchar(255) not null,
    hire_date datetime not null,
    gender nvarchar(10) not null,
    salary money not null
);

create table Sales(
    sale_id int primary key identity(1,1),
    product_id int foreign key references Products(product_id) not null,
    selling_price money not null,
    quantity int not null,
    sale_date datetime not null,
    employee  int foreign key references Employees(employee_id) not null,
    customer int foreign key references Customers(customer_id)
);

create nonclustered index IX_Products_product_name on Products(product_name);
create nonclustered index IX_Sales_product_id on Sales(product_id);
create nonclustered index IX_Sales_sale_date on Sales(sale_date);
create nonclustered index IX_Employees_full_name on Employees(full_name);
create nonclustered index IX_Customers_full_name on Customers(full_name);

create nonclustered index IX_Sales_Product_Customer_Date on Sales(product_id, customer, sale_date);

--тут включение столбцов
create nonclustered index IX_Sales_employee_full_name_included_columns on Sales(employee) include (quantity);
create nonclustered index IX_Customers_phone_number_included_columns on Customers(phone_number) include (email);

--тут создание отфильтрованного индекса
create nonclustered index IX_Employees_female_filter on Employees(employee_id) where gender = 'female';

--создание кластерных индексов через код заменил на написание primary key в полях таблиц, а то не получилось бы связать таблицы внешними ключами
