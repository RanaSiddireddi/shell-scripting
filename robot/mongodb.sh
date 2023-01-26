#!/bin/bash

COMPONENT=mongodb

#source loads a file and this has all common patterns

source "robot/common.sh" 

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
unzip -o mongodb.zip   &>> $LOGFILE
stat $?

echo -n "injecting $COMPONENT schema :"
cd mongodb-main
mongo < catalogue.js    &>> $LOGFILE
mongo < users.js    &>> $LOGFILE
stat $?