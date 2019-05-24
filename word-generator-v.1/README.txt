# Program:	Word Generator
# Created:	2018-03-15
# Version:	.1
# Language:	Shell

# Author:	Scott Forsberg
# Contact:	contact.scottforsberg@gmail.com
# Website:	https://github.com/pinebase/



Description

This program generates words of various lengths and composition. Types include randomly generated words, and compound words made op of smaller terms.



Installation

Change directory to the folder which contains the word generator program. Then, access the program via the "./" command prefix to specify filed located in the current working directory.

example:

cd /home/username/Downloads/word-generator
$ ./wg.sh 



Copywrite

MIT Liscense



Options

		Word Generator - (wg)

		switch options

		-l 	set number of letters per word 5-7
			default is 6

		-r	use real words, combinations of 3 and 4 letter random words

		-v 	enables verbose output

		-w 	set number of words to generate, default is 1

		-? 	display options



		Word Generator Domian Check - (wg-domain-check)

		switch options

		-a	check words found in ~/.word-generator/words_to_check.txt
			default setting
			overrides inididual word input check

		-i 	input word
			example: ./check.sh i test -v

		-v 	enables verbose output

		-? 	display options






