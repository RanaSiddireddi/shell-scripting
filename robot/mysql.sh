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

