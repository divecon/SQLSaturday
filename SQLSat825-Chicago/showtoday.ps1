#!/snap/bin/pwsh
#
# source: http://www.robvanderwoude.com/powershellexamples.php
# Rob van der Woude
# 
"This is totally different, well, not really totally, from ShowToday.ps1"
""
""
"Date / Format   YYYYMMDD        DD-MM-YYYY        MM/DD/YYYY"
"============================================================"
"Yesterday       " + (get-date (get-date).AddDays(-1) -uformat %Y%m%d) + "        " + (get-date (get-date).AddDays(-1) -uformat %d-%m-%Y) + "        " + (get-date (get-date).AddDays(-1) -uformat %m/%d/%Y)
"Today           " + (get-date -uformat %Y%m%d)                        + "        " + (get-date (get-date)             -uformat %d-%m-%Y) + "        " + (get-date (get-date)             -uformat %m/%d/%Y)
"Tomorrow        " + (get-date (get-date).AddDays(1)  -uformat %Y%m%d) + "        " + (get-date (get-date).AddDays(1)  -uformat %d-%m-%Y) + "        " + (get-date (get-date).AddDays(1)  -uformat %m/%d/%Y)
