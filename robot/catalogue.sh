#!/bin/bash

COMPONENT=catalogue

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
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
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
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service &>> "$LOGFILE"
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "starting the component :"
systemctl daemon-reload &>> "$LOGFILE"
systemctl enable catalogue &>> "$LOGFILE"
systemctl restart catalogue &>> "$LOGFILE"
stat $?

echo -e "\e[32m___________$COMPONENT Configuration complete_____________ \e[0m"


# echo -n "whitelisting mongo :"
# sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
# stat $?
