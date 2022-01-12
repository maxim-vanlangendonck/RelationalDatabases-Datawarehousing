USE [AdventureWorksDW]
GO

/****** Object:  Table [dbo].[FactSales]    Script Date: 12/01/2022 13:09:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FactSales](
	[SalesOrderLineNumber] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [decimal](8, 2) NOT NULL,
	[ExtendedAmount] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_FactSales] PRIMARY KEY CLUSTERED 
(
	[SalesOrderLineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Date] FOREIGN KEY([OrderDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO

ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_Date]
GO

ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Product] FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])
GO

ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_Product]
GO

ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_SalesTerritory] FOREIGN KEY([SalesTerritoryKey])
REFERENCES [dbo].[DimSalesTerritory] ([SalesTerritoryKey])
GO

ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_SalesTerritory]
GO


