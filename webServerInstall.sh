#!/bin/bash

# ram
# install lamp script
# 16 sep, 2020 / 17:54


# check for a network connection:
function  connectivity {
ping -c 4 google.com > install.log
cat install.log | sed -n '6 p' < install.log | awk '{print $6}'
if [ $? != 0 ];
then
	echo "Check dns" | tee -a install.log
	exit 1
fi
}

connectivity

# update server && install apps:v r
sudo apt update -y | tee -a install.log
sudo apt upgrade -y | tee -a install.log
sudo apt install vim apache2 apache2-utils ufw php libapache2-mod-php certbot python3-certbot-apache mariadb-server mariadb-client php-mysql -y | tee -a install.log

# config apache2
sudo systemctl  enable apache2
sudo systemctl reload apache2
sudo systemctl start apache2
sudo systemctl status apache2
echo
echo -n "Is status loaded and active, y/n: "
read active
	if [ $? == n ]
	then
		exit
	fi

echo
echo "Open a browser, http://ipaddress/index.html:"
echo -n "Check to make sure you can access the default Apache page: y/n: "
read running
      if [ $? == n ]
      then
              exit
      fi

# configure marikadb	
sudo systemctl start mariadb
sleep 5
sudo systemctl enable mariadb
sudo mysql_secure_installation
sudo systemctl status mysql
echo
echo -n "Is status loaded and active, y/n: "
read active
        if [ $? == n ]
	then
                exit
	fi

# allow application thru the firewall:
sudo ufw allow "WWW Full"
sudo ufw allow "WWW"
sudo ufw allow "OpenSSH"
sudo ufw enable
sudo ufw reload
sudo ufw status
echo
echo -n "Is status loaded and active, y/n: "
read active
        if [ $? == n ]
        then
                exit
	fi

# xonfig php
sudo cp -v info.php /var/www/html/
sudo systemctl restart apache2
sudo systemctl status apache2
echo
echo -n "Is status loaded and active, y/n: "
read active
        if [ $? == n ]
        then
                exit
	fi
echo "Verify php is working. Go to http://ipaddress/info.php."
echo "Done."
