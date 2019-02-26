#!/bin/bash
#
# From E Frank Ball III
#
# https://pastebin.com/5bsnvA3e
#
# roman_numerals.sh
# output is now two lines, use $2 = x to get one line output
# Convert arabic numbers to roman numerals
#
# Symbol 	I 	V 	X 	L 	C 	D 	M
# Value 	1 	5 	10 	50 	100 	500 	1,000
#               _	_	_	_	_	_      
# Symbol 	V 	X 	L 	C 	D 	M
# Value 	5000 	10,000	50,000	100,000	500,000	1,000,000
# "IC" it not valid for 99.  "VL" is not valid for 45. "IL" is not valid for 49.
# Valid subtractions:  IV = 4, IX = 9, XL = 40, XC = 90, CD = 400, CM, = 900
# 1. Only powers of ten (I, X, C, M) can be subtracted.
# 2. The smaller letter must be 1/5th or 1/10th of the larger one.
# 3. The smaller letter must either be the first letter or preceded
# by a letter at least ten times larger than it.
# 4. If another letter follows the larger one, it must be smaller
# than the number preceding the larger one.

rones () { case $1 in
		0) x="";;
		1) x="I";;
		2) x="II";;
		3) x="III";;
		4) x="IV";;
		5) x="V";;
		6) x="VI";;
		7) x="VII";;
		8) x="VIII";;
		9) x="IX";;
	esac
	xb=""
}

rtens () {
	a=`echo ${1:0:1}`	# 1st digit
	b=`echo ${1:1:1}`	# 2nd digit
	case $a in
		0) y="";;
		1) y="X";;
		2) y="XX";;
		3) y="XXX";;
		4) y="XL";;
		5) y="L";;
		6) y="LX";;
		7) y="LXX";;
		8) y="LXXX";;
		9) y="XC";;
	esac
	rones $b
	x="$y$x"
}

rhundreds (){
	a=`echo ${1:0:1}`	# 1st digit
	b=`echo ${1:1:1}`	# 2nd digit
	c=`echo ${1:2:1}`	# 3rd digit
	case $a in
		0) z="";;
		1) z="C";;
		2) z="CC";;
		3) z="CCC";;
		4) z="CD";;
		5) z="D";;
		6) z="DC";;
		7) z="DCC";;
		8) z="DCCC";;
		9) z="CM";;
	esac
	rtens $b$c
	x="$z$x"
} 

rthousands (){
	# 5000 = V with a bar, but it's not on my keyboard
	a=`echo ${1:0:1}`	# 1st digit
	b=`echo ${1:1:1}`	# 2nd digit
	c=`echo ${1:2:1}`	# 3rd digit
	d=`echo ${1:3:1}`	# 4th digit
	case $a in
		0) m="" 
		   w="" ;;
		1) m=" " 
		   w="M" ;;
		2) m="  " 
		   w="MM" ;;
		3) m="  "
		   w="MMM" ;;
		4) m="__"
		   w="IV" ;;
		5) m="_"
		   w="V" ;;
		6) m="__"
		   w="VI" ;;
		7) m="___"
		   w="VII" ;;
		8) m="____"
		   w="VIII" ;;
		9) m="__"
		   w="IX" ;;
	esac
	rhundreds $b$c$d
	xb="$m"
	x="$w$x"
} 

rtenthousands (){
	a=`echo ${1:0:1}`	# 1st digit
	b=`echo ${1:1:1}`	# 2nd digit
	c=`echo ${1:2:1}`	# 3rd digit
	d=`echo ${1:3:1}`	# 4th digit
	e=`echo ${1:4:1}`	# 5th digit
	case $a in
		0) n="" 
		   v="";;
		1) n="_"
		   v="X" ;;
		2) n="__" 
                   v="XX" ;;
		3) n="___"
                   v="XXX" ;;
		4) n="__" 
                   v="XL" ;;
		5) n="_" 
                   v="L" ;;
		6) n="__"
		   v="LX" ;;
		7) n="___" 
		   v="LXX" ;;
		8) n="____" 
		   v="LXXX" ;;
		9) n="__" 
		   v="XC" ;;
	esac
	rthousands $b$c$d$e
	xb="$n$m"
	x="$v$x"
} 

rhundredthousands (){
	a=`echo ${1:0:1}`	# 1st digit
	b=`echo ${1:1:1}`	# 2nd digit
	c=`echo ${1:2:1}`	# 3rd digit
	d=`echo ${1:3:1}`	# 4th digit
	e=`echo ${1:4:1}`	# 5th digit
	f=`echo ${1:5:1}`	# 6th digit
	case $a in
		0) o="" 
		   u="";;
		1) o="_"
		   u="C" ;;
		2) o="__" 
                   u="CC" ;;
		3) o="___"
                   u="CCC" ;;
		4) o="__" 
                   u="CD" ;;
		5) o="_" 
                   u="D" ;;
		6) o="__"
		   u="DC" ;;
		7) o="___" 
		   u="DCC" ;;
		8) o="____" 
		   u="DCCC" ;;
		9) o="__" 
		   u="CM" ;;
	esac
	rtenthousands $b$c$d$e$f
	xb="$o$xb"
	x="$u$x"
} 

rmillions (){
	a=`echo ${1:0:1}`	# 1st digit
	b=`echo ${1:1:1}`	# 2nd digit
	c=`echo ${1:2:1}`	# 3rd digit
	d=`echo ${1:3:1}`	# 4th digit
	e=`echo ${1:4:1}`	# 5th digit
	f=`echo ${1:5:1}`	# 6th digit
	g=`echo ${1:6:1}`	# 7th digit
	case $a in
		0) p="" 
		   t="";;
		1) p="_"
		   t="M" ;;
		2) p="__" 
                   t="MM" ;;
		3) p="___"
                   t="MMM" ;;
		4) p="____" 
                   t="MMMM" ;;
		5) p="_____" 
                   t="MMMMM" ;;
		6) p="______"
		   t="MMMMMM" ;;
		7) p="_______" 
		   t="MMMMMMM" ;;
		8) p="________" 
		   t="MMMMMMMM" ;;
		9) p="_________" 
		   t="MMMMMMMMM" ;;
	esac
	rhundredthousands $b$c$d$e$f$g
	xb="$p$xb"
	x="$t$x"
} 

toRoman () {
	length=${#answr}
	case $length in
		1) rones $answr;;
		2) rtens $answr;;
		3) rhundreds $answr;;
		4) rthousands $answr;;
		5) rtenthousands $answr;;
		6) rhundredthousands $answr;;
		7) rmillions $answr;;
		*) echo "Too big:  maximum=3,999,999"
		   xb="PANIC!"
		   x="Run Away!";;
	esac
}

###################################################

if [ $1 ]; then
	answr=$1
	toRoman $answr
	if [ ! $2 ]; then
		echo "$xb"
	fi
	echo $x
else
	q=1
	while [ $q = 1 ]; do
		read -p "enter arabic number: " answr
		if [ $answr = "exit" -o $answr = "bye" -o $answr = "quit" ]; then
			q=2
		else
			toRoman $answr
			echo "$xb"
			echo "$x"
		fi
	done
fi