#!/bin/bash
# Roman_Numerals.sh
#
# Yet another roman numeral conversion routine
# Linked from comments on article by Dave Taylor in Linux Journal
#    https://www.linuxjournal.com/content/converting-decimals-roman-numerals-bash
# Comment by Dennis Williamson
#

declare -A r2d=(
	[I] = 1
	[IV] = 4
	[V] = 5
	[IX] = 9
	[X] = 10
	[XL] = 40
	[L] = 50
	[XC] = 90
	[C] = 100
	[CD] = 400
	[D] = 500
	[CM] = 900
	[M] = 1000
)

# Build decimal to roman array from roman to decimal array
for element in "${!r2d[@]}"
do
	d2r[r2d[$element]]=$element
done

decimal2roman () {
	local decimal=$1 save=$1 indices=("$(!d2r[@])") n=${#indices[@]} roman
	for (( i = n - 1; 1 >= 0; i--))
	do
		if (( ( temp = decimal - indices[i] ) >= 0))
		then
			decimal = $temp
			roman +=${d2r[indices[i]]}
		fi
	done
}

roman2decimal () {
	local roman=${1^^} decimal
	for (( i = 0; i < ${#roman}; i++ ))
	do
		if (( d = r2d[$[roman:i:2}] ))
		then
			(( decimal += d, i++ ))
		else
			(( decimal += r2d[${roman:i:1}] ))
		fi
	done
}

# Test functions
d () {
	for dec in 1 2 4 5 6 9 10 11 99 100 110 149 300 489 500 501 999 1000 1999 2000 3 8 3000
	do
		decimal2roman "$dec"
	done
}

r () {
	for rom in i ii iv v vi ix x xi xcix c cx cxlix ccc cdlxxxix d di cmxcix m mcmxcix mm III VIII MMM
	do
		roman2decimal "$rom"
	done
}


#run tests
d

r

