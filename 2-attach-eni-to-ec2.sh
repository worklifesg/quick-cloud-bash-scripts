#!/bin/bash

# Configuration
REGION=$1
INSTANCE_NAME=$2
ENI_NAME=$3

if [ -z "$REGION" ] || [ -z "$INSTANCE_NAME" ] || [ -z "$ENI_NAME" ]; then
    echo "Usage: $0 <REGION> <INSTANCE_NAME> <ENI_NAME>"
    exit 1
fi

echo "Retrieving IDs for $INSTANCE_NAME and $ENI_NAME..."

# 1. Get Instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
    --region $REGION \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=running,pending" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

# 2. Get ENI ID
ENI_ID=$(aws ec2 describe-network-interfaces \
    --region $REGION \
    --filters "Name=tag:Name,Values=$ENI_NAME" \
    --query "NetworkInterfaces[*].NetworkInterfaceId" \
    --output text)

if [ -z "$INSTANCE_ID" ] || [ -z "$ENI_ID" ]; then
    echo "Error: Could not find Instance ID or ENI ID."
    exit 1
fi

# 3. Wait for Instance initialization (Status Checks to pass)
echo "Waiting for instance $INSTANCE_ID to complete initialization..."
aws ec2 wait instance-status-ok --region $REGION --instance-ids $INSTANCE_ID
echo "Instance is initialized."

# 4. Attach the Network Interface
# Note: DeviceIndex 1 is typically used for the second interface
echo "Attaching ENI $ENI_ID to Instance $INSTANCE_ID..."
ATTACHMENT_ID=$(aws ec2 attach-network-interface \
    --region $REGION \
    --network-interface-id $ENI_ID \
    --instance-id $INSTANCE_ID \
    --device-index 1 \
    --query "AttachmentId" \
    --output text)

# 5. Wait for the ENI status to be 'attached'
echo "Waiting for ENI attachment status to be 'attached'..."
while true; do
    STATUS=$(aws ec2 describe-network-interfaces \
        --region $REGION \
        --network-interface-ids $ENI_ID \
        --query "NetworkInterfaces[*].Attachment.Status" \
        --output text)
    
    if [ "$STATUS" == "attached" ]; then
        echo "Success: ENI is now attached."
        break
    else
        echo "Current status: $STATUS. Waiting..."
        sleep 5
    fi
done