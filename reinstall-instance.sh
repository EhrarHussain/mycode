#!/bin/bash

systemctl stop mysql

mv /var/lib/mysql/ /var/lib/mysql.orig

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

systemctl restart mysql
