#!/bin/bash

APPUSER=roboshop
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

JAVA() {
    echo -s "installing Maven :"
    yum install maven -y &>> "$LOGFILE"
    stat $?

    USER_ADD

    DOWNLOAD_AND_EXTRACT

    echo -n "generating the artifact :"
    cd /home/$APPUSER/$COMPONENT
    mvn clean package   &>> "$LOGFILE"
    mv target/shipping-1.0.jar shipping.jar

    SERVICE_CONFIGURING
}

PYTHON(){
    echo -n "installing python :"
    yum install python36 gcc python3-devel -y &>> "$LOGFILE"
    stat $?

    USER_ADD

    DOWNLOAD_AND_EXTRACT

    echo -n "installing dependancies :"
    cd /home/$APPUSER/$COMPONENT
    pip3 install -r requirements.txt &>> "$LOGFILE"
    stat $?

    USER_ID=$(id -u roboshop)
    GROUP_ID=$(id -g roboshop)

    echo -n "updating the UID and GID in $COMPONENT.ini file:"
    sed -i -e "/^uid/ c uid=${USER_ID}" -e "/^gid/ c uid=${GROUP_ID}" /home/$APPUSER/$COMPONENT/$COMPONENT.ini &>> "$LOGFILE"
    stat $?

    SERVICE_CONFIGURING


}

NODEJS() {
    echo -n "configuring and installing nodejs repo : "
    curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -    &>> "$LOGFILE"
    stat $?

    echo -n "installing nodejs :"
    yum install nodejs -y &>> "$LOGFILE"
    stat $?

    USER_ADD

    DOWNLOAD_AND_EXTRACT

    INSTALL_NPM

    SERVICE_CONFIGURING
}

USER_ADD() {
    id $APPUSER &>> "$LOGFILE"
    if [ $? -ne 0 ] ; then
        echo -n "creating Application user $APPUSER :"
        useradd $APPUSER &>> "$LOGFILE"
        stat $?
    fi
}

DOWNLOAD_AND_EXTRACT() {
    echo -n "downloading the $COMPONENT :"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
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
}

INSTALL_NPM() {
    echo -n " Installing catalogue dependancies :"
    cd /home/$APPUSER/$COMPONENT
    npm install &>> "$LOGFILE"
    stat $?
}

SERVICE_CONFIGURING() {
    echo -n "configuring the $COMPONENT service :"
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service &>> "$LOGFILE"
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $?

    echo -n "starting the $COMPONENT :"
    systemctl daemon-reload &>> "$LOGFILE"
    systemctl enable $COMPONENT &>> "$LOGFILE"
    systemctl restart $COMPONENT &>> "$LOGFILE"
    stat $?

    echo -e "\e[32m___________$COMPONENT Configuration complete_____________ \e[0m"
}