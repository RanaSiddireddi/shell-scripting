#!/bin/bash

set -e

COMPONENT=frontend

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

echo -n "\e[32m___________$COMPONENT Configuration complete_____________ \e[0m"

# systemctl daemon-reload
# systemctl restart nginx