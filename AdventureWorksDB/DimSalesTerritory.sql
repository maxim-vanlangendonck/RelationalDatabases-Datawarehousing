USE [AdventureWorksDW]
GO

/****** Object:  Table [dbo].[DimSalesTerritory]    Script Date: 12/01/2022 13:09:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimSalesTerritory](
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesTerritoryRegion] [nvarchar](50) NULL,
	[SalesTerritoryCountry] [nvarchar](50) NULL,
	[SalesTerritoryGroup] [nvarchar](50) NULL,
 CONSTRAINT [PK_DimSalesTerritory] PRIMARY KEY CLUSTERED 
(
	[SalesTerritoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


