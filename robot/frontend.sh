#!/bin/bash

COMPONENT=frontend

source "robot/common.sh"

echo -n "installing nginx :"
yum install nginx -y    &>> /tmp/$COMPONENT.log
stat $?

echo -n "downloading the $COMPONENT :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "clearing default content :"
cd /usr/share/nginx/html
rm -rf *    &>> /tmp/$COMPONENT.log
stat $?

echo -n "extracting $COMPONENT :"
unzip /tmp/$COMPONENT.zip   &>> /tmp/$COMPONENT.log
stat $?

echo -n "copying the content : "
mv frontend-main/* .    &>> /tmp/$COMPONENT.log
mv static/* .   &>> /tmp/$COMPONENT.log
rm -rf frontend-main README.md  &>> /tmp/$COMPONENT.log
mv localhost.conf /etc/nginx/default.d/roboshop.conf    &>> /tmp/$COMPONENT.log
stat $?

echo -n "starting nginx :"
systemctl enable nginx  &>> /tmp/$COMPONENT.log
systemctl restart nginx   &>> /tmp/$COMPONENT.log
stat $?

echo -e "\e[32m___________$COMPONENT Configuration complete_____________ \e[0m"

# systemctl daemon-reload
# systemctl restart nginx