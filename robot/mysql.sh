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
DEFAULT_ROOT_PWD=$(sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
stat $?


echo "show databases" | mysql -uroot -pRoboShop@1 &>> "$LOGFILE"
if [ $? -ne 0 ] ; then
    echo -n "resetting default root password :"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1' ;" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT_PWD}   &>> "$LOGFILE"
    stat $?
fi
 
echo "show plugins" | mysql -uroot -pRoboShop | grep validate_password; &>> "$LOGFILE"
if [ $? -ne 0 ] ; then
    echo -n "uninstalling validate passowrd plugin :"
    echo "uninstall plugin validate_password ;" | mysql -uroot -pRoboShop@1 &>> "$LOGFILE"
    stat $?
fi

echo -n "downloading schema $COMPONENT :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"  &>> "$LOGFILE"
cd /tmp
unzip $COMPONENT.zip &>> "$LOGFILE"
stat $?

echo -n "injecting $COMPONENT schema :"
cd $COMPONENT-main
mysql -uroot -pRoboShop@1 <shipping.sql
stat $?

echo -e "\e[32m___________$COMPONENT Configuration complete_____________ \e[0m"
