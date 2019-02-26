
#
# Demo from LinuxJournal
# 2/18/2019
#
# Converting Decimals to Roman Numerals with Bash
# by Dave Taylor
#
#
$decvalue = $1

mapit() {
   case $1 in
     I|i) value=1 ;;
     V|v) value=5 ;;
     X|x) value=10 ;;
     L|l) value=50 ;;
     C|c) value=100 ;;
     D|d) value=500 ;;
     M|m) value=1000 ;;
      * ) echo "Error: Value $1 unknown" >&2 ; exit 2 ;;
   esac
}

SubValue()
{
  # add $3 to romanvalue and subtract $2 from decvalue

  romanvalue="${romanvalue}$2"
  decvalue=$(( $decvalue - $1 ))

}

if [ $decvalue -ge 1000 ] ; then
  SubValue 1000 "M"
elif [ $decvalue -ge 900 ] ; then
  SubValue 900 "CM"
elif [ $decvalue -ge 500 ] ; then
  SubValue 500 "D"
elif [ $decvalue -ge 400 ] ; then
  SubValue 400 "CD"
elif [ $decvalue -ge 100 ] ; then
  SubValue 100 "C"
elif [ $decvalue -ge 90 ] ; then
  SubValue 90 "XC"
elif [ $decvalue -ge 50 ] ; then
  SubValue 50 "L"
elif [ $decvalue -ge 40 ] ; then
  SubValue 40 "XL"
elif [ $decvalue -ge 10 ] ; then
  SubValue 10 "X"
elif [ $decvalue -ge 9 ] ; then
  SubValue 9 "IX"
elif [ $decvalue -ge 5 ] ; then
  SubValue 5 "V"
elif [ $decvalue -ge 4 ] ; then
  SubValue 4 "IV"
elif [ $decvalue -ge 1 ] ; then
  SubValue 1 "I"
fi


