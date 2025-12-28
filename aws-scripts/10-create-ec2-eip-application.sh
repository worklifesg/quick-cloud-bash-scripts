#!/bin/bash

# Configuration
INSTANCE_NAME=$1
EIP_NAME=$2
INSTANCE_TYPE=$3

if [ -z "$INSTANCE_NAME" ] || [ -z "$EIP_NAME" ] || [ -z "$INSTANCE_TYPE" ]; then
    echo "Usage: $0 <INSTANCE_NAME> <EIP_NAME> <INSTANCE_TYPE>"
    exit 1
fi

echo "Step 1: Finding latest Ubuntu 22.04 AMI..."
AMI_ID=$(aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
    --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
    --output text)

echo "Using AMI: $AMI_ID"

echo "Step 2: Launching EC2 instance '$INSTANCE_NAME'..."
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type "$INSTANCE_TYPE" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "Instance ID: $INSTANCE_ID"
echo "Waiting for instance to enter 'running' state..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

echo "Step 3: Allocating Elastic IP '$EIP_NAME'..."
ALLOCATION_JSON=$(aws ec2 allocate-address --domain vpc --output json)
ALLOCATION_ID=$(echo $ALLOCATION_JSON | jq -r '.AllocationId')
PUBLIC_IP=$(echo $ALLOCATION_JSON | jq -r '.PublicIp')

# Tag the EIP with the requested name
aws ec2 create-tags \
    --resources "$ALLOCATION_ID" \
    --tags "Key=Name,Value=$EIP_NAME"

echo "Allocated IP: $PUBLIC_IP (Allocation ID: $ALLOCATION_ID)"

echo "Step 4: Associating Elastic IP with instance..."
aws ec2 associate-address \
    --instance-id "$INSTANCE_ID" \
    --allocation-id "$ALLOCATION_ID"

echo "------------------------------------------------"
echo "Success! Setup Complete."
echo "Instance Name: $INSTANCE_NAME"
echo "Static Public IP: $PUBLIC_IP"
echo "------------------------------------------------"