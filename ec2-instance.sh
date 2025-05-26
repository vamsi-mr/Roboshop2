#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
INSTANCE_TYPE="t2.micro"
SG_ID="sg-02d7436ae856ae341"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")

for INSTANCE in "${INSTNACES[@]}"; 
do
  echo "Creating $INSTANCE instance"

  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance-latest},{Key=service,Value=$instance}]" \
    --query "Instances[0].InstanceId" \
    --output text)

  echo "Created instance with ID: $INSTANCE_ID"
done