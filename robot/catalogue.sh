#!/bin/bash

COMPONENT=catalogue

source "robot/common.sh"

echo -n "configuring and installing nodejs repo : "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install nodejs -y   
stat $?

# echo -n "creating application user $APPUSER : "
# useradd roboshop   
