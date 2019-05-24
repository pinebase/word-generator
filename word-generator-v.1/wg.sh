#!/bin/bash



# test variables
#verbose='1'

function options(){

	options_text="

		Word Generator - switch options

		-l 	set number of letters per word 5-7
			default is 6

		-r	use real words, combinations of 3 and 4 letter random words

		-v 	enables verbose output

		-w 	set number of words to generate, default is 1

		-h 	display options

	"
	echo "$options_text"
	exit
}



# process arguments
while getopts 'l:w:rv?' c
do
	case $c in 
		l) length=$OPTARG;;
		r) real_words='1';;
		v) verbose='1';;
		w) words=$OPTARG;;
		h) options;;
		?) options;;
	esac
done	



# select random vowel
function vowel(){

	list="
	a
	e
	i
	o
	u
	"
	echo "$list"|sed 's/	//g;/^$/d;'|sort -R|head -n 1
}

# select random consonant
function consonant(){

	list="
	b
	c
	d
	f
	g
	h
	j
	l
	m
	n
	r
	s
	v
	w
	z
	"
	echo "$list"|sed 's/	//g;/^$/d;'|sort -R|head -n 1
}



if [ -d /var/lib/word-generator/words-raw.txt ]
then
	words_raw_file='1'
fi



# set default length
if [ "$length" == '' ]
then
	length=6
fi

# set default number of words to generate
if [ "$words" == '' ]
then
	words=1
fi



if [ "$verbose" == '1' ]
then
	echo "length: " $length
	echo "words: " $words
fi



while [[ $counter -lt "$words" ]]
do
	let counter=$counter+1

	if [ "$real_words" == '1' ]
	then
		# real word combinations

		if [ "$length" == '5' ]
		then
			w1=$(cat ./lib/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			w2=$(cat ./lib/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			output_string=$w1$w2
		fi

		if [ "$length" == '6' ]
		then
			w1=$(cat ./lib/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			w2=$(cat ./lib/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			output_string=$w1$w2
		fi

		if [ "$length" == '7' ]
		then
			w1=$(cat ./lib/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			w2=$(cat ./lib/4letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)

			rannum=$(( ( RANDOM % 2 )  + 1 ))

			if [ "$rannum" == '1' ]
			then
				output_string=$w1$w2
			else
				output_string=$w2$w1
			fi
		fi

	else
		# random letters

		if [ "$length" == '5' ]
		then
			l1=`consonant`
			l2=`vowel`
			l3=`consonant`
			l4=`vowel`
			l5=`consonant`
			output_string=$l1$l2$l3$l4$l5
		fi

		if [ "$length" == '6' ]
		then
			l1=`consonant`
			l2=`vowel`
			l3=`consonant`
			l4=`vowel`
			l5=`consonant`
			l6=`vowel`
			output_string=$l1$l2$l3$l4$l5$l6
		fi

		if [ "$length" == '7' ]
		then
			l1=`consonant`
			l2=`vowel`
			l3=`consonant`
			l4=`vowel`
			l5=`consonant`
			l6=`vowel`
			l7=`consonant`
			output_string=$l1$l2$l3$l4$l5$l6$l7
		fi
	fi

	echo $output_string

	# log word to file
	if [ $words_raw_file=='1' ]
	then
		echo $output_string >> /var/lib/word-generator/words-raw.txt
	fi

done


# add space to log file
if [ $words_raw_file=='1' ]
then
	echo "" >> /var/lib/word-generator/words-raw.txt
fi



exit
