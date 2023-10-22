USE [IceCream]
GO
/****** Object:  Table [dbo].[IceCream]    Script Date: 20.10.2023 9:24:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IceCream](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](255) NULL,
	[Price] [decimal](10, 2) NULL,
	[StockQuantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderHistory]    Script Date: 20.10.2023 9:24:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderHistory](
	[HistoryID] [int] NOT NULL,
	[OrderID] [int] NULL,
	[IceCreamID] [int] NULL,
	[Quantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 20.10.2023 9:24:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] NOT NULL,
	[OrderDate] [datetime] NULL,
	[Quantity] [int] NULL,
	[TotalCost] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[IceCream] ([ID], [Name], [Price], [StockQuantity]) VALUES (1, N'Ваниль', CAST(2.50 AS Decimal(10, 2)), 100)
INSERT [dbo].[IceCream] ([ID], [Name], [Price], [StockQuantity]) VALUES (2, N'Шоколад', CAST(3.00 AS Decimal(10, 2)), 120)
INSERT [dbo].[IceCream] ([ID], [Name], [Price], [StockQuantity]) VALUES (3, N'Клубника', CAST(2.75 AS Decimal(10, 2)), 90)
INSERT [dbo].[IceCream] ([ID], [Name], [Price], [StockQuantity]) VALUES (4, N'Манго', CAST(3.50 AS Decimal(10, 2)), 80)
INSERT [dbo].[IceCream] ([ID], [Name], [Price], [StockQuantity]) VALUES (5, N'Пломбир', CAST(2.25 AS Decimal(10, 2)), 110)
INSERT [dbo].[IceCream] ([ID], [Name], [Price], [StockQuantity]) VALUES (6, N'Мятное мороженое', CAST(2.75 AS Decimal(10, 2)), 95)
INSERT [dbo].[IceCream] ([ID], [Name], [Price], [StockQuantity]) VALUES (7, N'Тирамису', CAST(3.25 AS Decimal(10, 2)), 85)
GO
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (1, 1, 1, 1)
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (2, 1, 2, 1)
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (3, 1, 3, 1)
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (4, 2, 2, 2)
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (5, 2, 4, 2)
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (6, 2, 5, 1)
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (7, 3, 1, 1)
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (8, 3, 6, 1)
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (9, 4, 7, 2)
INSERT [dbo].[OrderHistory] ([HistoryID], [OrderID], [IceCreamID], [Quantity]) VALUES (10, 4, 5, 2)
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [Quantity], [TotalCost]) VALUES (1, CAST(N'2023-10-13T15:34:00.000' AS DateTime), 3, CAST(110.00 AS Decimal(10, 2)))
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [Quantity], [TotalCost]) VALUES (2, CAST(N'2023-10-13T16:12:00.000' AS DateTime), 5, CAST(334.00 AS Decimal(10, 2)))
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [Quantity], [TotalCost]) VALUES (3, CAST(N'2023-10-14T10:25:00.000' AS DateTime), 2, CAST(87.00 AS Decimal(10, 2)))
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [Quantity], [TotalCost]) VALUES (4, CAST(N'2023-10-14T12:15:00.000' AS DateTime), 4, CAST(240.00 AS Decimal(10, 2)))
GO
ALTER TABLE [dbo].[OrderHistory]  WITH CHECK ADD FOREIGN KEY([IceCreamID])
REFERENCES [dbo].[IceCream] ([ID])
GO
ALTER TABLE [dbo].[OrderHistory]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------- Создание триггера--------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create trigger InsteadOfInsertOrderHistory
on OrderHistory
instead of insert
as
begin
    declare @IceCreamID int, @Quantity int, @StockQuantity int, @OrderID int
    select @IceCreamID = IceCreamID, @Quantity = Quantity, @OrderID = OrderID
    from INSERTED
    select @StockQuantity = StockQuantity
    from  IceCream
    where ID = @IceCreamID
    if @StockQuantity >= @Quantity
    begin
        update IceCream
        set StockQuantity = StockQuantity - @Quantity
        where ID = @IceCreamID
        insert into OrderHistory (HistoryID, OrderID, IceCreamID, Quantity)
        values ((select HistoryID from inserted), @OrderID, @IceCreamID, @Quantity)
    end
    else
    begin
        delete from Orders
        where OrderID = @OrderID
    end
end

--GO

--drop trigger InsteadOfInsertOrderHistory

GO

insert into dbo.Orders (OrderID, OrderDate, Quantity, TotalCost)
values (5, GETDATE(), 3, 14.00)

insert into dbo.OrderHistory (HistoryID, OrderID, IceCreamID, Quantity)
values (11, 5, 1, 1)

GO

insert into dbo.Orders (OrderID, OrderDate, Quantity, TotalCost)
values (6, GETDATE(), 5, 51.00)

insert into dbo.OrderHistory (HistoryID, OrderID, IceCreamID, Quantity)
values (12, 6, 1, 100)