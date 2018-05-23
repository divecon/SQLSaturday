USE [EPMF]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertLastDBCCCheckDB]    Script Date: 5/23/2018 2:29:08 PM ******/
DROP PROCEDURE [dbo].[usp_InsertLastDBCCCheckDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertLastDBCCCheckDB]    Script Date: 5/23/2018 2:29:08 PM ******/
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

