#!/bin/bash

# Configuration
REGION=$1
INSTANCE_NAME=$2
EIP_NAME=$3

if [ -z "$REGION" ] || [ -z "$INSTANCE_NAME" ] || [ -z "$EIP_NAME" ]; then
    echo "Usage: $0 <REGION> <INSTANCE_NAME> <EIP_NAME>"
    exit 1
fi

echo "Retrieving IDs for $INSTANCE_NAME and $EIP_NAME..."

# 1. Get Instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
    --region $REGION \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=running,pending" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

# 2. Get Allocation ID of the Elastic IP
ALLOCATION_ID=$(aws ec2 describe-addresses \
    --region $REGION \
    --filters "Name=tag:Name,Values=$EIP_NAME" \
    --query "Addresses[*].AllocationId" \
    --output text)

# 3. Associate the Elastic IP
if [ -n "$INSTANCE_ID" ] && [ -n "$ALLOCATION_ID" ]; then
    echo "Associating EIP ($ALLOCATION_ID) with Instance ($INSTANCE_ID)..."
    aws ec2 associate-address \
        --region $REGION \
        --instance-id $INSTANCE_ID \
        --allocation-id $ALLOCATION_ID
    echo "Success: Elastic IP associated."
else
    echo "Error: Could not find Instance ID or Allocation ID. Please check your resource names."
    exit 1
fi