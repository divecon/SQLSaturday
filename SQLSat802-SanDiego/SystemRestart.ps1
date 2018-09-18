#!/snap/bin/pwsh
#
# source: http://www.robvanderwoude.com/powershellexamples.php
# Rob van der Woude
# 

if ( $HOME[0] -eq "/" ) {
	# Linux
    Write-Host 'Time to do a linux restart'
	#shutdown -r
} else {
	# Windows
    Write-Host 'Time to do a windows restart'
	#( Get-WMIObject -Query "Select * From Win32_OperatingSystem Where Primary=True" ).Reboot( )
}