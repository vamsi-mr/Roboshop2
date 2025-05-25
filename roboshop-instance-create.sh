#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP_ID="sg-02d7436ae856ae341"
ZONE_ID="Z06734122W0TQFHN7RZBR"

instances=("frontend" "mongodb" "catalogue" "redis" "user" "cart" "shipping" "payment" "dispatch" "mysql" "rabbitmq")

# Checking if AWS CLI is installed
if aws --version &> /dev/null; then
  echo "AWS CLI is installed"
else
  echo "AWS CLI is NOT installed"
  dnf install awscli -y
  echo "AWS CLI installed successfully"
fi

if git --version &> /dev/null; then
  echo "Git is installed"
else
  echo "Git is NOT installed"
  dnf install git -y
  echo "Git installed successfully"
fi
git clone https://github.com/vamsi-mr/Roboshop2.git

for instance in "${instances[@]}"; do
  echo "Creating $instance instance"

  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance-latest},{Key=service,Value=$instance}]" \
    --query "Instances[0].InstanceId" \
    --output text)

  echo "Created instance with ID: $INSTANCE_ID"
done