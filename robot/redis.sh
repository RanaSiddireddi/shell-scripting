#!/bin/bash

COMPONENT=redis

source "robot/common.sh"

echo -n "configuring $COMPONENT repo : "
curl -L https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo -o /etc/yum.repos.d/$COMPONENT.repo
stat $?

echo -n "installing $COMPONENT repo : "
yum install $COMPONENT-6.2.9 -y &>> "$LOGFILE"
stat $?

echo -n "whitelisting mongo :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT/$COMPONENT.conf
stat $?

echo -n "starting $COMPONENT :"
systemctl daemon-reload
systemctl enable $COMPONENT
systemctl restart $COMPONENT
stat $?

systemctl status $COMPONENT -l