use master

create database Bank

go

use Bank

create table Clients(
	ID int identity(1,1) primary key not null,
	Name nvarchar(max) not null,
	Address text not null,
	PhoneNumber varchar(20) not null
)

create table Accounts(
	ID int identity(1,1) primary key not null,
	Number varchar(20) unique not null,
	ClientID int unique not null foreign key (ClientID) references Clients(ID),
	Balance decimal(10,2) not null
)

create table TransactionTypes(
	ID int identity(1,1) primary key,
	Name varchar(50)
)

create table Transactions(
	ID int identity(1,1) primary key not null,
	SenderID int not null foreign key (SenderID) references Accounts(ID),
	ReceiverID int not null foreign key (ReceiverID) references Accounts(ID),
	Amount decimal(10,2) not null,
	Date datetime not null,
	ID_type int not null foreign key (ID_type) references TransactionTypes(ID)
)

go

insert into TransactionTypes(Name) values ('MoneyTransfer')

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
insert into Accounts(Number,ClientID, Balance) values (rand()*(99999-10000)+10000, @ClientID, 0)
return select Number from Accounts where ID = SCOPE_IDENTITY()
end

go

exec addAccount 1


--go
--drop procedure transferMoney
go
create procedure transferMoney @senderNum varchar(20), @receiverNum varchar(20), @amount money
as
begin
declare @state bit =0
if (@amount < (select Balance from Accounts where Number = @senderNum)) set  @state = 1
if(@state =1 )
begin
update Accounts
set Balance -= @amount
where Number = @senderNum
update Accounts
set Balance += @amount
where Number = @receiverNum

insert into Transactions(SenderID, ReceiverID, Amount,Date, ID_type) values ((select ClientID from Accounts where Number = @senderNum),
																			(select ClientID from Accounts where Number = @receiverNum),
																			@amount,GETDATE() ,1)
end
return @state
end

go
declare @result bit
exec @result =transferMoney '23456', '12345', 400 
select @result


go
create procedure getTransactionList @accountNum varchar(20)
as
begin
select * from Transactions where SenderID = (select ClientID from Accounts where Number = @accountNum)
end

go
exec getTransactionList '23456'	

go 

create procedure getBalance @UserID int 
as
begin
return select sum(Balance) from Accounts where ClientID = @UserID
end

go
create procedure loadFunds @Amount money, @AccountNumber varchar(20)
as
begin
update Accounts
set Balance += @Amount
where Number = @AccountNumber
end

go
create procedure cancelAccountTransferMoney @CanceledAccount varchar(20), @ReveiverAccount varchar(20)
as
begin
update Accounts
set Balance = (select Balance from Accounts where Number = @CanceledAccount)
where Number = @ReveiverAccount

update Accounts
set Balance =0
where Number = @CanceledAccount
end