USE [EPMF]
GO

ALTER TABLE [dbo].[LastDBCCCheckDB] DROP CONSTRAINT [DF__LastDBCCC__DateC__5CD6CB2B]
GO

/****** Object:  Table [dbo].[LastDBCCCheckDB]    Script Date: 5/23/2018 2:27:51 PM ******/
DROP TABLE [dbo].[LastDBCCCheckDB]
GO

/****** Object:  Table [dbo].[LastDBCCCheckDB]    Script Date: 5/23/2018 2:27:51 PM ******/
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

ALTER TABLE [dbo].[LastDBCCCheckDB] ADD  DEFAULT (getdate()) FOR [DateCaptured]
GO

