#!/bin/bash

set -e

COMPONENT=catalogue

source common.sh

echo -n "configuring and installing nodejs repo : "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install nodejs -y   &>> $LOGFILE
stat $?

echo -n "creating application user $APPUSER : "
useradd roboshop    &>> $LOGFILE
stat $?
