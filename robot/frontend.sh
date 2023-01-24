#!/bin/bash

COMPONENT=frontend

stat() {
    if [ $1 -eq 0 ] ; then
        echo -e "\e[32m success \e[0m"
    else
        echo -e "\e[31m failed \e[0m"
    fi
}

ID=$(id -u)

if [ $ID -ne 0 ] ; then
    echo -e "\e[31m you need to be root user or with sudo priviledge \e[0m"
    exit 1
fi

echo -n "installing nginx :"
yum install nginx -y    &>> /tmp/frontend.log
stat $?

echo -n "downloading the $COMPONENT :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "clearing default content :"
cd /usr/share/nginx/html
rm -rf *    &>> /tmp/frontend.log
stat $?

echo -n "extracting $COMPONENT :"
unzip /tmp/$COMPONENT.zip   &>> /tmp/frontend.log
stat $?

echo -n "copying the content : "
mv frontend-main/* .    &>> /tmp/frontend.log
mv static/* .   &>> /tmp/frontend.log
rm -rf frontend-main README.md  &>> /tmp/frontend.log
mv localhost.conf /etc/nginx/default.d/roboshop.conf    &>> /tmp/frontend.log
stat $?

echo -n "starting nginx :"
systemctl enable nginx  &>> /tmp/frontend.log
systemctl start nginx   &>> /tmp/frontend.log
stat $?


# systemctl daemon-reload
# systemctl restart nginx