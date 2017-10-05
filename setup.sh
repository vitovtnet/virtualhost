#!/bin/bash

### Set Language
TEXTDOMAIN=virtualhost

if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
		exit 1;
fi

sudo apt-get update

#Install apache && test it
sudo apt-get install apache2

#Install PHP 7.`
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.1

php -v

#Install firewall
sudo apt-get install ufw
sudo ufw status verbose

#Add Firewall rules
#Allow SSH & HTTP

sudo ufw allow ssh
sudo ufw allow http

#Allow Apache

sudo ufw allow in "Apache Full"

#Install CURL

sudo apt-get install curl

#Install Sendmail

sudo apt-get install sendmail

#Install MySQL & Setup

sudo apt-get install mysql-server
sudo mysql_secure_installation

#Install PHP & Apache packages

