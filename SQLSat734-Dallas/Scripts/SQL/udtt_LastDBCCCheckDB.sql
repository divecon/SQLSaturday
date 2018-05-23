USE [EPMF]
GO

/****** Object:  UserDefinedTableType [dbo].[LastDBCCCheckDB]    Script Date: 5/23/2018 2:29:51 PM ******/
DROP TYPE [dbo].[LastDBCCCheckDB]
GO

/****** Object:  UserDefinedTableType [dbo].[LastDBCCCheckDB]    Script Date: 5/23/2018 2:29:51 PM ******/
CREATE TYPE [dbo].[LastDBCCCheckDB] AS TABLE(
	[InstanceName] [varchar](256) NOT NULL,
	[DatabaseName] [varchar](256) NOT NULL,
	[LastCheck] [datetime] NULL
)
GO

