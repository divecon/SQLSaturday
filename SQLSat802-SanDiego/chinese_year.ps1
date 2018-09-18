#!/snap/bin/pwsh
param(
	[parameter( Mandatory = $true, HelpMessage = "Enter a year between 1900 and 2100:" )]
	[ValidateRange(1900,2100)]
	[int]$myYear
)

$names = "Rat","Ox","Tiger","Rabbit","Dragon","Snake","Horse","Goat","Monkey","Rooster","Dog","Pig"

Write-Host $myYear -ForegroundColor White -NoNewline
if ( $myYear -lt ( Get-Date ).Year ) {
	Write-Host " was" -NoNewline
} elseif ( $myYear -gt ( Get-Date ).Year ) {
	Write-Host " will be" -NoNewline
} else {
	Write-Host " is" -NoNewline
}
Write-Host " a Chinese year of the " -NoNewline
Write-Host $names[ ( $myYear - 1900 ) % 12 ] -ForegroundColor White