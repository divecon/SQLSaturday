#shebang
#
# source: http://www.robvanderwoude.com/powershellexamples.php
# Rob van der Woude
# 

param (
	[parameter( Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Enter a 5 or six character airplane registration code:" )]
	[string]$reg,
	[switch]$OpenWebPage,
	[parameter( ValueFromRemainingArguments = $true, ValueFromPipeline = $false )]
	[object]$invalidArgs = ""
)

$OldProgressPreference = $ProgressPreference

function Show-Help {
	param ( [string]$error = "" )
	if ( $error -ne "" ) {
		Write-Host
		Write-Host "Error:`t" -ForegroundColor Red -NoNewline
		Write-Host $error
	}

	Write-Host
	Write-Host "AirReg.ps1,  Version 1.01"
	Write-Host "Search an airplane's type and model by its registration"
	Write-Host
	Write-Host "Usage:  AirReg.ps1  reg  [ -OpenWebPage ]"
	Write-Host
	Write-Host "Where:  reg            is the airplane registration `"number`", e.g. `"G-FLUG`""
	Write-Host "        -OpenWebPage   opens Airport-data.com's web page for the airplane,"
	Write-Host "                       if " -ForegroundColor White -NoNewline
	Write-Host "it exists"
	Write-Host
	Write-Host "Notes:  The script uses Airport-data.com's API to find the airplane's data."
	Write-Host "        The author of this script is not affiliated in any way with"
	Write-Host "        Airport-data.com."
	Write-Host "        The script accepts piped input for the registration `"number`", but"
	Write-Host "        not for the -OpenWebPage switch."
	Write-Host "        If multiple registrations are passed on the command line, the script"
	Write-Host "        will abort with an error message. If multiple registrations are piped,"
	Write-Host "        however, the script will handle only the last one and ignore the rest."
	Write-Host
	Write-Host "Written by Rob van der Woude"
	Write-Host "http://www.robvanderwoude.com"

	Exit 1
}


# Check if the mandatory registration "number" isn't empty
if ( $reg.Trim( ) -eq "" ) {
	Show-Help
}


# Check if too many arguments were passed on the command line or piped
if ( $invalidArgs -ne "" ) {
	if ( $invalidArgs -eq "/?" ) {
		Show-Help
	} else {
		Show-Help "Invalid or too many command line argument(s)"
	}
}


function Open-URL {
	param( [string]$url )
	if ( $HOME[0] -eq "/" ) {
		# Linux
		$browser = ( ( xdg-settings get default-web-browser ) -Split "\." )[0]
		# Redirect standard output to hide "Vector smash protection is enabled" message
		Start-Process -FilePath $browser -ArgumentList $url -RedirectStandardOutput NUL
	} else {
		# Windows
		Start-Process $url
	}   
}


function Get-Model {
	param ( [string]$reg = "", [string]$url = "" )
	$reg   = $reg.ToUpper( ).Trim( )
	$url   = $url.Trim( )
	$model = ""
	if ( ( $reg -ne "" ) -and ( $url -ne "" ) ) {
		$ProgressPreference = "SilentlyContinue"
		$html  = ( Invoke-WebRequest -URI $url ).Content
		$ProgressPreference = $OldProgressPreference
		$regex = [regex]"[\?\&]field=model[\&\`"][^>]*>([^<]+)<"
		$match = $regex.Match( $html )
		$model = $match.Groups[1].ToString( )
	}
	$model
}


function Search-PlaneByReg {
	param ( [string]$reg )
	$model  = ""
	$ProgressPreference = "SilentlyContinue"
	$result = ( Invoke-webrequest -URI "http://www.airport-data.com/api/ac_thumb.json?r=$reg" ).Content | ConvertFrom-Json -ErrorAction Stop
	$ProgressPreference = $OldProgressPreference
	if ( $result.status -eq 200 ) {
		$url = $result.data.link
		$model = Get-Model -reg $reg -url $url
		if ( $OpenWebPage ) {
			Open-URL $url
		}
	}
	$model
}


$reg = $reg.ToUpper( ).Trim( )
if ( $reg -eq "/?" ) {
	Show-Help
}
if ( ( $reg.Replace( "-", "" ).Length -lt 5 ) -or ( $reg.Replace( "-", "" ).Length -gt 6 ) ) {
	Show-Help "Invalid registration code `"$reg`""
}

try {
	$model = Search-PlaneByReg -reg $reg
	if ( $model -eq "" ) {
		$reg   = $reg.Replace( "-", "" )
		$reg   = $reg.Substring( 0, 1 ) + "-" + $reg.Substring( 1 )
		$model = Search-PlaneByReg -reg $reg
	} else {
		Write-Host "$reg`t" -NoNewline
	}
	if ( $model -eq "" ) {
		$reg   = $reg.Replace( "-", "" )
		$reg   = $reg.Substring( 0, 2 ) + "-" + $reg.Substring( 2 )
		$model = Search-PlaneByReg -reg $reg
	} else {
		Write-Host "$reg`t" -NoNewline
	}
	if ( $model -eq "" ) {
		Show-Help
	} else {
		Write-Host "$reg`t" -NoNewline
	}
}
catch {
	Show-Help $_.Exception.Message
}

Write-Host $model