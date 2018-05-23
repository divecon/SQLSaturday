-- sp_GetLastIntegrityCheck.sql
--
-- Stored procedure to select which persisted data should be used for SSRS report
-- Note: Using a stored procedure for the report makes tweaking the selection easier. 
--       It won't be necessary to build and deploy a report again unless the actual
--       columns change.
--

IF OBJECT_ID('GetLastIntegrityCheck', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[GetLastIntegrityCheck]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetLastIntegrityCheck] @SinceDate datetime = null
AS
BEGIN

DECLARE @CompareDate datetime,
   @LastCheck datetime

SET @LastCheck = dateadd(dd, -7, getdate())

IF @SinceDate IS NULL BEGIN
SELECT @CompareDate = DATEADD(DD,-14, getdate())
END
ELSE BEGIN
SELECT @CompareDate = @SinceDate
END

SELECT DISTINCT InstanceName, DatabaseName, max(LastCheck) as LastCheck
FROM   LastDBCCCheckDB
WHERE  LastCheck < @LastCheck
  AND  DateCaptured > @CompareDate
GROUP BY InstanceName, DatabaseName
ORDER BY InstanceName, DatabaseName

END


GO

