-- udtt_LastDBCCCheckDB.sql
--
-- Create User Defined Table Type for staging information about last execution of DBCC CheckDB

IF OBJECT_ID('dbo.LastDBCCCheckDB', 'TT') IS NOT NULL
	DROP TYPE [dbo].[LastDBCCCheckDB]
GO

CREATE TYPE [dbo].[LastDBCCCheckDB] AS TABLE(
	[InstanceName] [varchar](256) NOT NULL,
	[DatabaseName] [varchar](256) NOT NULL,
	[LastCheck] [datetime] NULL
)
GO

