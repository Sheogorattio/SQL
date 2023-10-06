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
--	Number varchar(20) unique not null,
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

create procedure addClient @Name nvarchar(max), @Address text, @PhoneNumber varchar(20)
as
begin
insert into Clients(Name, Address, PhoneNumber) values (@Name, @Address, @PhoneNumber)
return SCOPE_IDENTITY()
end

go
declare @_ int =0
exec @_ = addClient 'Valeriy', 'Yadova 2', '0638775633'
select @_

go
create procedure addAccount @ClientID int
as
begin
insert into Accounts(Number,ClientID, Balance) values (rand()*(9999999999-1000000000)+1000000000, @ClientID, 0)
return select Number from Accounts where ID = SCOPE_IDENTITY()
end

go

exec addAccount 1

go
create procedure transferMoney @senderNum int, @receiverNum int , @amount money
as
begin

end
