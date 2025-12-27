#!/bin/bash

# Configuration
REGION=$1
INSTANCE_NAME=$2
AMI_NAME=$3

if [ -z "$REGION" ] || [ -z "$INSTANCE_NAME" ] || [ -z "$AMI_NAME" ]; then
    echo "Usage: $0 <REGION> <INSTANCE_NAME> <AMI_NAME>"
    exit 1
fi

echo "Retrieving ID for instance: $INSTANCE_NAME..."

# 1. Get Instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
    --region $REGION \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=running,stopped" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

if [ -z "$INSTANCE_ID" ]; then
    echo "Error: Could not find Instance ID for $INSTANCE_NAME."
    exit 1
fi

# 2. Create the AMI
echo "Creating AMI '$AMI_NAME' from instance $INSTANCE_ID..."
AMI_ID=$(aws ec2 create-image \
    --region $REGION \
    --instance-id $INSTANCE_ID \
    --name "$AMI_NAME" \
    --description "AMI created" \
    --no-reboot \
    --query "ImageId" \
    --output text)

if [ -z "$AMI_ID" ]; then
    echo "Error: Failed to initiate AMI creation."
    exit 1
fi

echo "AMI ID created: $AMI_ID"

# 3. Wait for AMI to be in 'available' state
echo "Waiting for AMI to become available (this may take a few minutes)..."
aws ec2 wait image-available \
    --region $REGION \
    --image-ids $AMI_ID

echo "Success: AMI '$AMI_NAME' ($AMI_ID) is now in 'available' state."