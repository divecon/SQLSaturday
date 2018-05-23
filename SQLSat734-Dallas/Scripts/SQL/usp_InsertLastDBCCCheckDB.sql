-- usp_InsertLastDBCCCheckDB.sql
--
-- Stored procedure to move data from Table Value Parameter to persisted table
--

IF OBJECT_ID('usp_InsertLastDBCCCheckDB', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[usp_InsertLastDBCCCheckDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_InsertLastDBCCCheckDB] (@TVP  dbo.LastDBCCCheckDB readonly)
AS
BEGIN
 DECLARE @DateCollected datetime 
 SET @DateCollected = getdate()
 PRINT 'Executing usp_InsertLastDBCCCheckDB'

 SELECT  
    InstanceName,
	DatabaseName,
	LastCheck,
	@DateCollected
FROM    @TVP

INSERT INTO dbo.LastDBCCCheckDB (
    InstanceName,
	DatabaseName,
	LastCheck)
SELECT  
    InstanceName,
	DatabaseName,
	LastCheck
FROM    @TVP
END

GO

