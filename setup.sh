#!/bin/bash

### Set Language
TEXTDOMAIN=virtualhost

### Set default parameters
apacheDirConf='/etc/apache2/mods-enabled/dir.conf'

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
sudo apt-get install php-intl php-curl php-mysql php-xml
sudo apt-get install php-memcached


sudo php -v

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

sudo systemctl restart apache2

#Install SSL

sudo apt-get install python-certbot-apache

cd /usr/local/bin
wget -O virtualhost https://raw.githubusercontent.com/vitovtnet/virtualhost/master/vh.sh
sudo chmod +x virtualhost

#Install MC

sudo apt-get install mc

#Install Htop

sudo apt-get install htop

#Install composer
cd /usr/local/bin
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
