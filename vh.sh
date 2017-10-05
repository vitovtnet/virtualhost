#!/bin/bash
### Set Language
TEXTDOMAIN=virtualhost

### Set default parameters
action=$1
domain=$2
rootDir=$3
owner=$(who am i | awk '{print $1}')
email='webmaster@localhost'
sitesEnable='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
homeDir='/home/'
sitesAvailabledomain=$sitesAvailable$domain.conf

### don't modify from here unless you know what you are doing ####

if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
		exit 1;
fi

if [ "$action" != 'create' ] && [ "$action" != 'delete' ]
	then
		echo $"You need to prompt for action (create or delete) -- Lower-case only"
		exit 1;
fi

while [ "$domain" == "" ]
do
	echo -e $"Please provide domain. e.g.dev,staging"
	read domain
done

if [ "$rootDir" == "" ]; then
	rootDir=${domain//./}
fi

### if root dir starts with '/', don't use /var/www as default starting point
if [[ "$rootDir" =~ ^/ ]]; then
	homeDir=''
fi

rootDir=$homeDir$rootDir
wwwDir=$rootDir/www
logDir=$rootDir/logs

echo -e $"Root directory: $rootDir\n"
echo -e $"WWW directory: $wwwDir\n"
echo -e $"Logs directory: $logDir\n"
echo -e $"\n\n===================\n\n"

if [ "$action" == 'create' ]
	then
		### check if domain already exists
		if [ -e $sitesAvailabledomain ]; then
			echo -e $"This domain already exists.\nPlease Try Another one"
			exit;
		fi

		### check if directory exists or not
		if ! [ -d $rootDir ]; then

		    echo -e $"Creating root directory: $rootDir\n"
			### create the directory
			sudo mkdir $rootDir
			### give permission to root dir
			sudo chmod 755 $rootDir

            echo -e $"Creating www directory: $wwwDir\n"

			sudo mkdir $wwwDir

			sudo chmod 755 $wwwDir

			echo -e $"Creating logs directory: $logDir\n"

			sudo mkdir $logDir

			sudo chmod 755 $logDir

			### write test file in the new domain dir
			if ! echo "<?php echo phpinfo(); ?>" > $wwwDir/phpinfo.php
			then
				echo $"ERROR: Not able to write in file $wwwDir/phpinfo.php. Please check permissions"
				exit;
			else
				echo $"Added content to $wwwDir/phpinfo.php"
			fi
		fi

		### create virtual host rules file
		if ! echo "
<VirtualHost *:80>
        ServerAdmin $email
        ServerName $domain

        DocumentRoot $wwwDir/
        ErrorLog $logDir/error.log
        CustomLog $logDir/access.log combined
        DocumentRoot $wwwDir
        \n
        <Directory $wwwDir>
            Options Indexes FollowSymLinks
            AllowOverride All
            Order Allow,Deny
            Allow from All
            Require all granted
        </Directory>
</VirtualHost>" > $sitesAvailabledomain
		then
			echo -e $"There is an ERROR creating $domain file"
			exit;
		else
			echo -e $"\nNew Virtual Host Created\n"
		fi

		### Add domain in /etc/hosts
		#if ! echo "127.0.0.1	$domain" >> /etc/hosts
		#then
	#		echo $"ERROR: Not able to write in /etc/hosts"
	#		exit;
#		else
#			echo -e $"Host added to /etc/hosts file \n"
	#	fi

		if [ "$owner" == "" ]; then
			chown -R $(whoami):$(whoami) $rootDir
		else
			chown -R $owner:$owner $rootDir
		fi

		exit;

		### enable website
		sudo a2ensite $domain

		### restart Apache
		/etc/init.d/apache2 reload

		### show the finished message
		echo -e $"Complete! \nYou now have a new Virtual Host \nYour new host is: http://$domain \nAnd its located at $rootDir"
		exit;
	else
		### check whether domain already exists
		if ! [ -e $sitesAvailabledomain ]; then
			echo -e $"This domain does not exist.\nPlease try another one"
			exit;
		else
			### Delete domain in /etc/hosts
			newhost=${domain//./\\.}
			sed -i "/$newhost/d" /etc/hosts

			### disable website
			sudo a2dissite $domain

			### restart Apache
			/etc/init.d/apache2 reload

			### Delete virtual host rules files
			rm $sitesAvailabledomain
		fi

		### check if directory exists or not
		if [ -d $rootDir ]; then
			echo -e $"Delete host root directory ? (y/n)"
			read deldir

			if [ "$deldir" == 'y' -o "$deldir" == 'Y' ]; then
				### Delete the directory
				rm -rf $rootDir
				echo -e $"Directory deleted"
			else
				echo -e $"Host directory conserved"
			fi
		else
			echo -e $"Host directory not found. Ignored"
		fi

		### show the finished message
		echo -e $"Complete!\nYou just removed Virtual Host $domain"
		exit 0;
fi
