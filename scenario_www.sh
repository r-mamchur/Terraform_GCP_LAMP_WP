#!/bin/bash

yum install -y wget
yum install -y unzip
yum install -y mc
yum install yum-utils -y

#  Apache
yum install -y httpd
systemctl start  httpd
systemctl enable httpd


# PHP
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php73
yum install -y epel-release
yum install -y php php-zip php-gd php-intl php-mbstring php-soap php-xmlrpc php-pgsql \
   php-opcache libsemanage-python libselinux-python php-pecl-redis 
# it's need for moodle
yum install -y php-mysqli
# "Nothing to do" but ....
yum install -y  php-iconv php-curl php-ctype php-simplexml php-spl                

systemctl restart httpd.service

# wordpress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz -C /var/
mv -f /var/wordpress/* /var/www/html
cp /tmp/wp-config.php /var/www/html

#  SELinux
chcon -t httpd_sys_rw_content_t /var/www/html -R
setsebool -P httpd_can_network_connect on
setsebool -P httpd_can_network_memcache on
setsebool -P httpd_can_network_connect_db on    # if DB in other host


