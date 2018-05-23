-- tbl_LastDBCCCheckDB.sql
--
-- Create table LastDBCCCheckDB to hold persisted data on last time DBCC CHECKDB was executed
--

IF OBJECT_ID('DF_LastDBCCC_DateCaptured', 'D') IS NOT NULL
    ALTER TABLE [dbo].[LastDBCCCheckDB] DROP CONSTRAINT [DF_LastDBCCC_DateCaptured]
GO
IF OBJECT_ID('[dbo].[LastDBCCCheckDB]', 'U') IS NOT NULL
    DROP TABLE [dbo].[LastDBCCCheckDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LastDBCCCheckDB](
	[InstanceName] [varchar](256) NOT NULL,
	[DatabaseName] [varchar](256) NOT NULL,
	[LastCheck] [datetime] NULL,
	[DateCaptured] [datetime] NULL
)
GO

ALTER TABLE [dbo].[LastDBCCCheckDB] ADD CONSTRAINT [DF_LastDBCCC_DateCaptured] DEFAULT (getdate()) FOR [DateCaptured]
GO

