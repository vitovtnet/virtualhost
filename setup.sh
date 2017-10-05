#!/bin/bash

### Set Language
TEXTDOMAIN=virtualhost

if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
		exit 1;
fi

sudo add-apt-repository ppa:certbot/certbot
sudo add-apt-repository ppa:ondrej/php

sudo apt-get update

#Install apache && test it
sudo apt-get install apache2

#Install PHP 7.`
sudo apt-get install python-software-properties
sudo apt install -y language-pack-en-base
sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get install php7.1

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

apacheDirConf = "/etc/apache2/mods-enabled/dir.conf"

    if !echo "
    <IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
    </IfModule>
    " > $apacheDirConf
    then
        echo -e $"Error with creating $apacheDirConf "
        exit;
    else
        echo -e $"\nNew $apacheDirConf Created\n"
    fi

#Install SSL

sudo apt-get install python-certbot-apache

cd /usr/local/bin
wget -O virtualhost https://raw.githubusercontent.com/vitovtnet/virtualhost/master/vh.sh
sudo chmod +x virtualhost



