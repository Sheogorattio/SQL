--use master

--create database Bank

--go

--use Bank

--create table Clients(
--	ID int identity(1,1) primary key not null,
--	Name nvarchar(max) not null,
--	Address text not null,
--	PhoneNumber varchar(20) not null
--)

--create table Accounts(
--	ID int identity(1,1) primary key not null,
--	Number varchar(20) not null,
--	ClientID int unique not null foreign key (ClientID) references Clients(ID),
--	Balance decimal(10,2) not null
--)

--create table TransactionTypes(
--	ID int identity(1,1) primary key,
--	Name varchar(50)
--)

--create table Transactions(
--	ID int identity(1,1) primary key not null,
--	SenderID int not null foreign key (SenderID) references Accounts(ID),
--	ReceiverID int not null foreign key (ReceiverID) references Accounts(ID),
--	Amount decimal(10,2) not null,
--	Date datetime not null,
--	ID_type int not null foreign key (ID_type) references TransactionTypes(ID)
--)

go
drop procedure dbo.addClient

go

create procedure addClient @Name nvarchar(max), @Address text, @PhoneNumber varchar(20)
as
begin
insert into Clients(Name, Address, PhoneNumber) values (@Name, @Address, @PhoneNumber)
select SCOPE_IDENTITY()
end

go
addClient 'Mykhailo', 'Frunze 3', '0668765432'