#!/bin/bash

UID= $(id -u)

if [$UID -ne 0 ] ; then
    echo -e "\e[32m you need to be root user or with sudo priviledge \e[0m"
    exit 1
fi

yum install nginx -y
systemctl enable nginx
systemctl start nginx
