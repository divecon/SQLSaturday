Import-Module Sqlps -DisableNameChecking
. C:\EPMF\Scripts\Out-DataTable.ps1

# GetDBCCCheckDB.ps1
$FileName = "C:\EPMF\Scripts\SQL\GetLastGoodDBCCCheckDB.sql"
$CMSHost = "EPMFDemo"
$sqlSP = "dbo.usp_InsertLastDBCCCheckDB"
$typeName = "LastDBCCCheckDB"

$Result = Invoke-sqlcmd -ServerInstance $CMSHost -Database "EPMF" -Query "SELECT Server_Name AS ServerName FROM [policy].[pfn_ServerGroupInstances]('Demo')"
#$Result
 #$dt = Invoke-sqlcmd -ServerInstance "EPMFDEMO\DEMO1" -Database "tempdb" -InputFile "$Filename" -ErrorVariable badOuput | out-DataTable
 #$dt


foreach ($Server in $Result)
{
   $ServerName = ""
   $dt=""
   $ServerName = $Server.ServerName
  # $ServerName
   try {
      try {
         #$dt = Invoke-sqlcmd -ServerInstance "$($Server.ServerName)" -Database "tempdb" -InputFile "$Filename" -ErrorVariable badOuput | out-DataTable
         $dt = Invoke-sqlcmd -ServerInstance "$ServerName" -Database "tempdb" -InputFile "$Filename" -ErrorVariable badOuput | out-DataTable
   #  $dt
      } 
      catch {
         Write-Output "Error invoking $Filename for server $($Server.ServerName)"
         Continue
      }
   
      #Remove unneeded columns
      $dt.Columns.Remove("RowError")
      $dt.Columns.Remove("RowState")
      $dt.Columns.Remove("Table")
      $dt.Columns.Remove("ItemArray")
      $dt.Columns.Remove("HasErrors")
  
      #$dt
      # Write data table to database using TVP
      $conn = new-Object System.Data.SqlClient.SqlConnection("Server=EPMFDEMO;DataBase=EPMF;Integrated Security=SSPI")
      try {
         $conn.Open() | out-null
      }
      catch {
         Write-Output "Unable to connect to remote server."
         Continue
      }
      #"Connected"
      $cmd = new-Object System.Data.SqlClient.SqlCommand("dbo.usp_InsertLastDBCCCheckDB", $conn)
      #$cmd = new-Object System.Data.SqlClient.SqlCommand($sqlSP, $conn)

      $cmd.CommandType = [System.Data.CommandType]'StoredProcedure'
      #SQLParameter
      $spParam = new-Object System.Data.SqlClient.SqlParameter
      $spParam.ParameterName = "@TVP"
      $spParam.Value = $dt
      $spParam.SqlDbType = "Structured" #SqlDbType.Structured
      $spParam.TypeName = "LastDBCCCheckDB"
      #$spParam.TypeName = $typeName

      $spParam2 = new-Object System.Data.SqlClient.SqlParameter
      $spParam2.ParameterName = "@ServerName"
      $spParam2.Value = $ServerName


      $cmd.Parameters.Add($spParam) | out-Null
      #$cmd.Parameters.Add($spParam2) | out-Null
      # Debug output
      #$cmd

      try {
         $cmd.ExecuteNonQuery() | out-Null
      } 
      catch {
         Write-Output "Error invoking $cmd"
         Continue
      }
      try {
         $conn.Close() | out-Null
      }
      catch {
         Write-Output "Unabled to close connection."
      }

   } #endof Try
   catch { 
      Write-Output "Couldn't upload data for $($Server.ServerName) "
   }

}