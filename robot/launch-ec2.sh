#!/bin/bash


COMPONENT=$1
ENV=$2
HOSTED_ZONE_ID="Z08504361Q1M69BII5VS1"

if [ -z "$COMPONENT" ] || [ -z "$ENV" ]; then
    echo -e "\e[31m component name is required \n sample usage: \n\n\t\t bash launch-ec2.sh componentname \e[0m "
    exit 1
fi

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=b52-ansible-dev-20Jan2023" --region us-east-1 | jq .Images[].ImageId | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b52-allow-all --region us-east-1 |jq .SecurityGroups[].GroupId | sed -e 's/"//g')

echo "AMI ID to launch the instance is $AMI_ID "
echo "security group id used to launch instance is $SG_ID"


launch_ec2() {
    echo "****____$COMPONENT launch is in progress____****"
    PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro --security-group-ids ${SG_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}-$ENV}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')

    echo -n "Creating Internal DNS record for $COMPONENT-$ENV"

    sed -e "s/IPADDRESS/$PRIVATE_IP/" -e "s/COMPONENT/${COMPONENT}-${ENV}/" route53.json > /tmp/r53.json
    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file:///tmp/r53.json

    echo -n "****____DNS record for $COMPONENT-$ENV is complete____****"
}


if ["$1" == "all"]; then
    for component in frontend catalogue cart user shipping payment mysql rabbitmq redis mongodb; do
        COMPONENT=$component
        launch_ec2
    done
else 
        launch_ec2
fi



