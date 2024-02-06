#!bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE= ""
IMAGE_ID=ami-0f3c7d07486cad139
SECURITY_GROUP_ID=sg-01284a2efbbf19211


for i in "${NAMES[@]}"
do  
    if [ [ $i == "mongodb"  || $i == "mysql" ] ]
    then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    echo "creating $i instance"
    aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]"
done