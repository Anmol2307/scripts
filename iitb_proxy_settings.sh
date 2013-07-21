#!/bin/bash

echo "Please insert LDAP username:"
read username

echo "Please insert LDAP password:"
read password

echo -n "Applying settings to apt-get"
echo "Acquire::http::proxy "http://$username:$password@netmon.iitb.ac.in:80/";
Acquire::https::proxy "https://$username:$password@netmon.iitb.ac.in:80/";
Acquire::ftp::proxy "ftp://$username:$password@netmon.iitb.ac.in:80/";" > /etc/apt/apt.conf
echo "\t[Done]"

echo -n "Applying settings to bashrc"
sed -i '/.*export.*proxy.*/d' /etc/bash.bashrc
echo "export http_proxy="http://$username:$password@netmon.iitb.ac.in:80/"
export ftp_proxy="ftp://$username:$password@netmon.iitb.ac.in:80/"
export https_proxy="https://$username:$password@netmon.iitb.ac.in:80/"" >> /etc/bash.bashrc
echo "\t[Done]"

echo -n "Applying settings to wget"
echo "use_proxy=on
http_proxy=http://$username:$password@netmon.iitb.ac.in:80/
ftp_proxy=ftp://$username:$password@netmon.iitb.ac.in:80/
https_proxy=https://$username:$password@netmon.iitb.ac.in:80/" >> /etc/wgetrc
echo "\t[Done]"

echo "It is recommended that you restart the system for the settings to get applied.\nDo you want to restart now?[Y/N]"
read input
if input="Y" 
then
  echo -n "Rebooting...."
	reboot
else
	echo -n "Reboot for applying the settings!!"
	exit
fi
