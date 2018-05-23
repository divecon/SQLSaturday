USE [EPMF]
GO

/****** Object:  StoredProcedure [dbo].[GetLastIntegrityCheck]    Script Date: 5/23/2018 2:28:39 PM ******/
DROP PROCEDURE [dbo].[GetLastIntegrityCheck]
GO

/****** Object:  StoredProcedure [dbo].[GetLastIntegrityCheck]    Script Date: 5/23/2018 2:28:39 PM ******/
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

