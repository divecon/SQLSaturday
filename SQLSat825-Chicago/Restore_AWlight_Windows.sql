USE [master]
RESTORE DATABASE [AdventureWorksLT2017] 
FROM  DISK = N'C:\SQLBackups\AdventureWorksLT2017.bak' 
WITH  FILE = 1,  
MOVE N'AdventureWorksLT2012_Data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorksLT2012.mdf',  
MOVE N'AdventureWorksLT2012_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorksLT2012_log.ldf',  
NOUNLOAD,  
STATS = 5

GO


