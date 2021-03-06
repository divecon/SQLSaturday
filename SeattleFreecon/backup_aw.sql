USE MASTER
GO
BACKUP DATABASE [AdventureWorks2017] 
TO  DISK = N'/var/opt/mssql/backup/AdventureWorks2017_20180324.bak' 
WITH FORMAT, INIT,  MEDIANAME = N'AdventureWorks2017',  
NAME = N'AdventureWorks2017-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position 
from msdb..backupset 
where database_name=N'AdventureWorks2017' 
and backup_set_id=(select max(backup_set_id) 
from msdb..backupset 
where database_name=N'AdventureWorks2017' )
if @backupSetId is null 
begin 
   raiserror(N'Verify failed. Backup information for database ''AdventureWorks2017'' not found.', 16, 1) 
end
RESTORE VERIFYONLY 
FROM  DISK = N'/var/opt/mssql/backup/AdventureWorks2017_20180324.bak' 
WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
