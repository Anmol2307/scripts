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
#creating a temp file
sudo touch temp.sql
echo "use mysql;
update user set password=PASSWORD(\"$password\") where User='root';
flush privileges;
exit;" > temp.sql

if [ -f "/etc/init.d/mysql" ]
then
# stopping the process, if its running
echo "stopping mysql process"
sudo service mysql stop
echo "starting  mysql process again safely"
#start to mysql server w/o password
sudo mysqld_safe --skip-grant-tables
## setting up new mysql root user password
mysql -u root < temp.sql
echo "stopping process again"
sudo service mysql stop
echo "password rest done"
sudo rm temp.sql
echo "starting your mysql server"
sudo service mysql start
echo "login to the root with your new password"
fi
