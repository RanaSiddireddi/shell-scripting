#!/bin/bash

COMPONENT=user

source "robot/common.sh"

echo -n "configuring and installing nodejs repo : "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -    &>> "$LOGFILE"
stat $?

echo -n "installing nodejs :"
yum install nodejs -y &>> "$LOGFILE"
stat $?

id $APPUSER &>> "$LOGFILE"
if [ $? -ne 0 ] ; then
    echo -n "creating Application user $APPUSER :"
    useradd $APPUSER &>> "$LOGFILE"
    stat $?
fi

echo -n "downloading the $COMPONENT :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/user/archive/main.zip"
stat $?

echo -n "Cleanup and Extracting the $COMPONENT :"
rm -rf /home/$APPUSER/$COMPONENT
cd /home/$APPUSER
unzip -o /tmp/$COMPONENT.zip   &>> "$LOGFILE"
stat $?

echo -n "changing ownership to $APPUSER :"
mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
cd /home/$APPUSER/$COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?

echo -n " Installing catalogue dependancies :"
cd /home/$APPUSER/$COMPONENT
npm install &>> "$LOGFILE"
stat $?

echo -n "configuring the $COMPONENT serice :"
sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  /home/$APPUSER/$COMPONENT/systemd.service &>> "$LOGFILE"
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "starting the component :"
systemctl daemon-reload &>> "$LOGFILE"
systemctl enable $COMPONENT &>> "$LOGFILE"
systemctl restart $COMPONENT &>> "$LOGFILE"
stat $?

echo -e "\e[32m___________$COMPONENT Configuration complete_____________ \e[0m"

