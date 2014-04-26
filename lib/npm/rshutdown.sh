#!/bin/bash

host=$1
username=$2
password=$3

#SSH
sshpass -p "$password" ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $username@$host "echo $password | sudo -S poweroff" > /dev/null 2>&1

ssh_status=$?

#Telnet
if [[ $ssh_status != 0 ]]; then	
	echo "Shudown via SSH on $1 with user $2 failed."
	echo "Trying via Telnet (Windows)..."
	(
	echo open $host
	sleep 5
	echo -en "$username\r\n"
	sleep 4
	echo -en "$password\r\n"
	sleep 4
	echo -en "shutdown /s /t 60\r\n"
	sleep 1
	) | telnet > /dev/null 2>&1
else
	echo "Shudown via SSH seems to be successful, not sure."
fi
