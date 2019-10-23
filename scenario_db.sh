#!/bin/bash

yum install -y wget
yum install -y unzip
yum install -y mc
yum install yum-utils -y

# MySql

rpm -Uvh  https://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-release-el7-7.noarch.rpm
yum-config-manager -q -y --enable mysql57-community
yum-config-manager -q -y --disable mysql56-community
yum install -y mysql-community-server
systemctl enable mysqld.service
systemctl start mysqld.service

# conf connect to MySql
# password - Passw0rd!  
MYSQL_TEMP_PWD=`sudo cat /var/log/mysqld.log | grep 'A temporary password is generated' | awk -F'root@localhost: ' '{print $2}'`
 mysqladmin -u root -p`echo $MYSQL_TEMP_PWD` password 'Passw0rd!'

# mysql --defaults-file=~/.my.cnf     use for connect to mysql

# echo "SET PASSWORD FOR root@localhost=PASSWORD('Passw0rd!')" | mysql
cat << EOF > ~/.my.cnf
 [client]
user=root
password=Passw0rd!
EOF
chmod 600 ~/.my.cnf
echo "CREATE DATABASE wp DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; "  | mysql
# echo "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON wp.* TO wp@localhost IDENTIFIED BY 'Passw0rd!'; " | mysql
echo "GRANT ALL PRIVILEGES ON wp.* TO 'wp' IDENTIFIED BY 'Passw0rd('; " | mysql

