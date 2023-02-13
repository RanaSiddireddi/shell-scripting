#!/bin/bash

COMPONENT=$1
HOSTED_ZONE_ID="Z08504361Q1M69BII5VS1"

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=b52-ansible-dev-20Jan2023" --region us-east-1 | jq .Images[].ImageId | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b52-allow-all --region us-east-1 |jq .SecurityGroups[].GroupId | sed -e 's/"//g')

echo "AMI ID to launch the instance is $AMI_ID "
echo "security group id used to launch instance is $SG_ID"
echo "****____$COMPONENT launch is in progress____****"

PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro --security-group-ids ${SG_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')


echo -n "Creating Internal DNS record for $COMPONENT"
aws route53 change-resource-record-sets --hosted-zone-id Z1R8UBAEXAMPLE --change-batch file://