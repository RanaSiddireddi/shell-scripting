#!/bin/bash

COMPONENT=payment
source "robot/common.sh"
PYTHON








# useradd roboshop
# $ cd /home/roboshop
# $ curl -L -s -o /tmp/payment.zip "https://github.com/stans-robot-project/payment/archive/main.zip"
# $ unzip /tmp/payment.zip
# $ mv payment-main payment
# cd /home/roboshop/payment 


# pip3 install -r requirements.txt
# ```

# ### **Note: Above command may fail with permission denied, So run as root user**

# 1. Update the `roboshop` user id and group id in `payment.ini` file .

# ```sql
# # id roboshop 
# (Copy uid and gid of the user which needs to be updated in the payment.ini file )
# ```

# 1. Update SystemD service file with `CART` , `USER` , `RABBITMQ` Server IP Address.

# ```sql
# # vim systemd.service
# ```

# Update `CARTHOST` with cart server ip

# Update `USERHOST` with user server ip 

# Update `AMQPHOST` with RabbitMQ server ip.

# 1. Setup the service

# ```sql
# # mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
# # systemctl daemon-reload
# # systemctl enable payment 
# # systemctl start payment
# # systemctl status payment -l
# ```

# 1. Now we are good with payment. Update the `PAYMENT` server IP ADDRESS in the FRONTEND Reverse Proxy File