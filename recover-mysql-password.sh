#!/bin/bash

echo "Please enter the username for whom you want to recover the password: "

read user

echo "Please type your new password:"
stty -echo
read password
stty echo

echo "Please type your password again:"
stty -echo
read newPass
stty echo

if [ "$password" == "$newPass" ]
then
  echo "password matched"
else
	echo "passwords dont match, run again"
	exit
fi

if [  -f "/etc/init.d/mysql" ]
then
	# stopping the process, if its running
	echo "stopping mysql process"
	sudo /etc/init.d/mysql stop
	#start to mysql server w/o password
	sudo mysqld_safe --skip-grant-tables &
	## setting up new mysql root user password
	
	
fi
