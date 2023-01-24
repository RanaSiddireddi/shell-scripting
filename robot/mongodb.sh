#!/bin/bash

set -e

COMPONENT=mongodb

LOGFILE=/tmp/$COMPONENT.log

ID=$(id -u)

if [ $ID -ne 0 ] ; then
    echo -e "\e[31m you need to be root user or with sudo priviledge \e[0m"
    exit 1
fi

stat() {
    if [ $1 -eq 0 ] ; then
        echo -e "\e[32m success \e[0m"
    else
        echo -e "\e[31m failed \e[0m"
    fi
}

echo -n "downloading the $COMPONENT :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?


echo -n "installing $COMPONENT :"
yum install -y mongodb-org &>> $LOGFILE
stat $?

echo -n "starting $COMPONENT :"
systemctl enable mongod
systemctl start mongod
stat $?

echo -n "downloading $COMPONENT schema :"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Extracting $COMPONENT schema file :"
cd /tmp &>> $LOGFILE
unzip mongodb.zip   &>> $LOGFILE
stat $?

echo -n "injecting $COMPONENT schema :"
cd mongodb-main &>> $LOGFILE
mongo < catalogue.js    &>> $LOGFILE
mongo < users.js