#!/bin/bash

COMPONENT=catalogue

source "robot/common.sh"

echo -n "configuring and installing nodejs repo : "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -    &>> "$LOGFILE"
yum install nodejs -y &>> "$LOGFILE"
stat $?

id $APPUSER &>> "$LOGFILE"
if [ $? -ne 0 ] ; then
    echo -n "creating Application user $APPUSER :"
    useradd $APPUSER &>> "$LOGFILE"
    stat $?
fi


echo -n "downloading the $COMPONENT :"
$ curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"

echo -n "Extracting the $COMPONENT :"
$ cd /home/$APPUSER &>> "$LOGFILE"
$ unzip -o /tmp/catalogue.zip   &>> "$LOGFILE"
stat $?

echo -n "changing ownership to $APPUSER :"
$ mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
$ cd /home/roboshop/catalogue
chown $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?

# echo -n " :"

# $ npm install
