use Sales

go

create table Sellers(
	ID int primary key identity(1,1),
	FullName nvarchar(max) not null,
	Email nvarchar(100) not null,
	PhoneNum nvarchar(15) not null
)

create table Customers(
	ID int primary key identity(1,1),
	FullName nvarchar(max) not null,
	Email nvarchar(100) not null,
	PhoneNum nvarchar(15) not null
)

create table Sales(
	ID int primary key identity(1,1),
	CustomerID int foreign key references Customers(ID) not null,
	SellerID int foreign key references Sellers(ID) not null,
	ProductName nvarchar(255) not null,
	Price money not null,
	DealDate datetime not null
)

go


create nonclustered index IX_Sellers_Email on Sellers(Email);

go

create nonclustered index IX_Sellers_PhoneNum on Sellers(PhoneNum);

go

create nonclustered index IX_Customers_Email on Customers(Email);

go

create nonclustered index IX_Customers_PhoneNum on Customers(PhoneNum);

go

create nonclustered index IX_Sales_CustomerID on Sales(CustomerID);

go

create nonclustered index IX_Sales_SellerID on Sales(SellerID);

go

create nonclustered index IX_Sales_DealDate on Sales(DealDate);

go

create nonclustered index IX_Sales_Customer_Seller_DealDate on Sales(CustomerID, SellerID, DealDate);

go

create nonclustered index IX_Sales_ProductName_IncludedColumns on Sales(ProductName) include (Price);

go
