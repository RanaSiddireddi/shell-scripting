#!/bin/bash

COMPONENT=rabbitmq
source "robot/common.sh"


echo -n "storing and configuring $COMPONENT repo :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>> "$LOGFILE"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> "$LOGFILE"
stat $?

echo -n "installing $COMPONENT :"
yum install rabbitmq-server -y &>> "$LOGFILE"
stat $?

echo -n "Start $COMPONENT server :" 
systemctl enable rabbitmq-server &>> "$LOGFILE"
systemctl restart rabbitmq-server &>> "$LOGFILE"
stat $?

sudo rabbitmqctl list-users | grep $APPUSER &>> "$LOGFILE"
if [ $? -ne 0 ] ; then
    echo -n "creating $COMPONENT user account :"
    rabbitmqctl add_user roboshop roboshop123 &>> "$LOGFILE"
    stat $?
fi

echo -n "configuring tags and permissions to $APPUSER :"
rabbitmqctl set_user_tags roboshop administrator &>> "$LOGFILE"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> "$LOGFILE"
stat $?


echo -e "\e[32m___________$COMPONENT Configuration complete_____________ \e[0m"
