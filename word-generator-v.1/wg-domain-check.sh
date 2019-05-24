#!/bin/bash



# test variables
#verbose='1'

function options(){

	options_text="

		Word Generator Domian Check - switch options

		-a	check words found in /var/lib/word-generator/words-to-check.txt
			default setting
			overrides inididual word input check

		-i 	input word
			example: ./wg.sh -i test -v

		-v 	enables verbose output

		-h 	display options

	"
	echo "$options_text"
	exit
}



# process arguments
while getopts 'ai:v?' c
do
	case $c in 
		a) auto_check='1';;
		i) input_word=$OPTARG;;
		v) verbose='1';;
		h) options;;
		?) options;;
	esac
done	



if [ "$verbose" == '1' ]
then
	echo ""
	echo "auto_check: $auto_check"
	echo "input_word: $input_word"
	echo "verbose: $verbose"
	echo "\$1: $1"
	echo ""
fi



if [ "$input_word" == '' ]
then
	# check for switch in the inline input
	echo $1|grep -q "-"

	# if previous command not sucessful
	if [ $? != 0 ]; then 
		input_word=$1
	fi

fi



if [ -d /var/lib/word-generator/domains-available.txt ]
then
	domains_available_file='1'
fi

if [ -d /var/lib/word-generator/words-checked.txt ]
then
	words_checked_file='1'
fi

if [ -d /var/lib/word-generator/words-to-check.txt ]
then
	words_to_check_file='1'
else
	auto_check='0'
fi



#
# single input check
# no -a switch found
#
if [ "$auto_check" != '1' ]
then

	# if script input given
	if [ "$input_word" != '' ]
	then

		if [ "$verbose" == '1' ]
		then
			echo "checking domain: $input_word.com"
			echo ""
		fi

		# attempt to match output of whois with indicators of avaiable lease
		whois $input_word.com | egrep -q '^No match|^NOT FOUND|^Not fo|AVAILABLE|^No Data Fou|has not been regi|No entri' 

		# "$?" = check if last command was sucessful. 0 = sucess
		if [ $? -eq 0 ]; then 

			# log word to file
			if [ $domains_available_file=='1' ]
			then
				echo "$input_word.com" >> /var/lib/word-generator/domains-available.txt
			fi

			if [ "$verbose" == '1' ]
			then
				echo "results: $input_word.com is avaiable for lease"
				echo ""

			else
				echo $input_word.com 
			fi

		else

			if [ "$verbose" == '1' ]
			then
				echo "results: $input_word.com already taken"
				echo ""
			fi

		fi 

	else
		echo "# no input word found, exiting"
		exit
	fi


fi



#
# multiple input check from file ~/.word-generator/words_to_check.txt
# -a switch found
#
if [ "$auto_check" == '1' ]
then
	echo "# automatic check beginning"
	echo "# processing words in ~/.word-generator/words-to-check.txt"
	echo "# single word input check deactivated"
	echo ""

	if [ $words_to_check_file=='1' ]
	then
		words_to_check=$(cat /var/lib/word-generator/words-to-check.txt|sed 's/\n//g')
	fi

	for word in $words_to_check
	do
		# attempt to match output of whois with indicators of avaiable lease
		whois $word.com | egrep -q '^No match|^NOT FOUND|^Not fo|AVAILABLE|^No Data Fou|has not been regi|No entri' 

		# "$?" = check if last command was sucessful. 0 = sucess
		if [ $? -eq 0 ]; then 

			echo "$word.com"

			if [ $domains_available_file=='1' ]
			then
				echo "$word.com" >> /var/lib/word-generator/domains-available.txt
			fi
		fi 

		# remove word from words to check list
		if [ $words_to_check_file=='1' ]
		then
			sed -i "s/$word//g" /var/lib/word-generator/words-to-check.txt
		fi

		# add word to words checked list
		if [ $words_checked_file=='1' ]
		then
			echo "$word" >> /var/lib/word-generator/words-checked.txt
		fi

		sleep 3

	done

fi



exit
