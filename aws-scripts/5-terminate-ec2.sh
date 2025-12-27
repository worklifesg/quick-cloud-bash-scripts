#!/bin/bash

# Configuration
REGION=$1
INSTANCE_NAME=$2

if [ -z "$REGION" ] || [ -z "$INSTANCE_NAME" ]; then
    echo "Usage: $0 <REGION> <INSTANCE_NAME>"
    exit 1
fi

echo "Retrieving ID for instance: $INSTANCE_NAME..."

# 1. Get Instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
    --region $REGION \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=running,stopped,stopping,pending" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

if [ -z "$INSTANCE_ID" ]; then
    echo "Error: Could not find Instance ID for $INSTANCE_NAME. It may already be terminated."
    exit 0
fi

# 2. Terminate the Instance
echo "Terminating instance $INSTANCE_ID..."
aws ec2 terminate-instances \
    --region $REGION \
    --instance-ids $INSTANCE_ID

# 3. Wait for 'terminated' state
echo "Waiting for instance to reach 'terminated' state..."
aws ec2 wait instance-terminated \
    --region $REGION \
    --instance-ids $INSTANCE_ID

echo "Success: Instance $INSTANCE_NAME ($INSTANCE_ID) has been terminated."