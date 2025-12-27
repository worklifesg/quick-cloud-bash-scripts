#!/bin/bash

# Configuration
REGION=$1
INSTANCE_NAME=$2
VOLUME_NAME=$3
DEVICE_NAME=$4

if [ -z "$REGION" ] || [ -z "$INSTANCE_NAME" ] || [ -z "$VOLUME_NAME" ] || [ -z "$DEVICE_NAME" ]; then
    echo "Usage: $0 <REGION> <INSTANCE_NAME> <VOLUME_NAME> <DEVICE_NAME>"
    exit 1
fi

echo "Retrieving IDs for $INSTANCE_NAME and $VOLUME_NAME..."

# 1. Get Instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
    --region $REGION \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=running,pending" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

# 2. Get Volume ID
VOLUME_ID=$(aws ec2 describe-volumes \
    --region $REGION \
    --filters "Name=tag:Name,Values=$VOLUME_NAME" \
    --query "Volumes[*].VolumeId" \
    --output text)

if [ -z "$INSTANCE_ID" ] || [ -z "$VOLUME_ID" ]; then
    echo "Error: Could not find Instance ID or Volume ID. Verify your tags."
    exit 1
fi

# 3. Wait for Instance initialization
echo "Waiting for instance $INSTANCE_ID to be in a running state..."
aws ec2 wait instance-running --region $REGION --instance-ids $INSTANCE_ID

# 4. Attach the Volume
echo "Attaching volume $VOLUME_ID to $INSTANCE_ID at $DEVICE_NAME..."
aws ec2 attach-volume \
    --region $REGION \
    --volume-id $VOLUME_ID \
    --instance-id $INSTANCE_ID \
    --device $DEVICE_NAME

# 5. Wait for the volume to be 'in-use'
echo "Verifying attachment status..."
aws ec2 wait volume-in-use --region $REGION --volume-ids $VOLUME_ID

echo "Success: Volume $VOLUME_NAME attached to $INSTANCE_NAME as $DEVICE_NAME."