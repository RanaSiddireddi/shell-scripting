#!/bin/bash

COMPONENT=mysql

source "robot/common.sh" #Loads source

echo -n "Setting $COMPONENT repos :"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo   &>> "$LOGFILE"
stat $?

echo -n "installing $COMPONENT :"
yum install mysql-community-server -y &>> "$LOGFILE"
stat $?

echo -n "starting $COMPONENT :"
systemctl enable mysqld 
systemctl start mysqld

echo -n "fetching default password :"
DEFAULT_ROOT_PWD=$(sudo grep 'A temporary password' /var/log/mysqld.log | awk -F ' ' '{print $NF}')



echo show databases | mysql -uroot -pRoboShop@1 &>> "$LOGFILE"
if [ $? -ne 0 ] ; then
    echo -n "resetting default root password :"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1' ;" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT_PWD}
fi