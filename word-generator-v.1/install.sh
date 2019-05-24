#!/bin/bash



# installs list functionality

if [ ! -d /var/lib/word-generator/ ]
then
	mkdir /var/lib/word-generator/
fi

if [ ! -f /var/lib/word-generator/words-raw.txt ]
then
	touch /var/lib/word-generator/words-raw.txt
fi

if [ ! -f /var/lib/word-generator/words-to-check.txt ]
then
	touch /var/lib/word-generator/words-to-check.txt
fi

if [ ! -f /var/lib/word-generator/words-checked.txt ]
then
	touch /var/lib/word-generator/words-checked.txt
fi



# copy program files to /var/lib

cp `pwd` -r /var/lib/word-generator/



# install the word generator man page

if [ -f ./manual/wg.1 ]
then
	if [ -d /usr/local/share/man/man1/ ]
	then
		# copy manual file
		cp ./manual/wg.1 /usr/local/share/man/man1/

		# refresh system man pages
		mandb
	fi
fi



# get current version

version=$(echo `pwd`|cut -d'/' -f7)



# create soft links in /usr/bin

if [ ! -f /usr/bin/wg ]
then
	ln -s /var/lib/word-generator/$version/wg.sh /usr/bin/wg
fi

if [ ! -f /usr/bin/wg-domain-check ]
then
	ln -s /var/lib/word-generator/$version/wg-domain-check.sh /usr/bin/wg-domain-check
fi

if [ ! -f /usr/bin/wg-cycle ]
then
	ln -s /var/lib/word-generator/$version/wg-cycle.sh /usr/bin/wg-cycle
fi



exit
