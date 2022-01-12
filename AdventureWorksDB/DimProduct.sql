USE [AdventureWorksDW]
GO

/****** Object:  Table [dbo].[DimProduct]    Script Date: 12/01/2022 13:09:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimProduct](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Color] [nvarchar](50) NULL,
	[ListPrice] [money] NULL,
	[Size] [nvarchar](50) NULL,
	[Weight] [decimal](8, 2) NULL,
	[Start] [date] NULL,
	[End] [date] NULL,
 CONSTRAINT [PK_DimProduct] PRIMARY KEY CLUSTERED 
(
	[ProductKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


