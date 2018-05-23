Included in this group of files:

1) EPMFReports - This folder contains a SSRS report solution ready to be run using the included table and collection script 
	included for LastDBCCCheckDB. There is also a generic EPMF report included but you would need to install EPMF first,
	and then run the correct collection routine.
2) Scripts - This folder contains the necessary PowerShell and SQL scripts to collect data for the Integrity Check solution.
	By following the comments, it would be easy to build tables and scripts for others items you might care to capture.
	a) PowerShell - PowerShell scripts to capture and persist database integrity check data
		i) GetDBCCCheckDB.ps1 - The script to actually scan across istances and collect/persist the integrity check info
		ii) Out-DataTable.ps1 - A PowerShell script that creates a data table for transfer to SQL Server
	b) SQL - SQL scripts to create necessary stored procedures, table value data type, and table for persisting data
		i) sp_GetLastIntegrityCheck.sql - Drives data to SSRS 
		ii) tbl_LastDBCCCheckDB.sql -  Table for persisting data collected
		iii) udtt_LastDBCCCheckDB.sql - Create table type for use in staging collected data per server/instance
		iv) usp_InsertLastDBCCCheckDB.sql - Move data from the table value type to the persistence table


These demo files can also be obtain from github:

https://github.com/divecon/SQLSaturday

