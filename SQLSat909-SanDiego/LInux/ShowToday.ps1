#shebang
#
# source: http://www.robvanderwoude.com/powershellexamples.php
# Rob van der Woude
# 

""
"Date / Format   YYYYMMDD        DD-MM-YYYY        MM/DD/YYYY"
"============================================================"
"Yesterday       " + (get-date (get-date).AddDays(-1) -uformat %Y%m%d) + "        " + (get-date (get-date).AddDays(-1) -uformat %d-%m-%Y) + "        " + (get-date (get-date).AddDays(-1) -uformat %m/%d/%Y)
"Today           " + (get-date -uformat %Y%m%d)                        + "        " + (get-date (get-date)             -uformat %d-%m-%Y) + "        " + (get-date (get-date)             -uformat %m/%d/%Y)
"Tomorrow        " + (get-date (get-date).AddDays(1)  -uformat %Y%m%d) + "        " + (get-date (get-date).AddDays(1)  -uformat %d-%m-%Y) + "        " + (get-date (get-date).AddDays(1)  -uformat %m/%d/%Y)