#!/bin/bash

# Configuration
REGION=$1
VOLUME_NAME=$2
SNAPSHOT_NAME=$3
DESCRIPTION=$4

if [ -z "$REGION" ] || [ -z "$VOLUME_NAME" ] || [ -z "$SNAPSHOT_NAME" ] || [ -z "$DESCRIPTION" ]; then
    echo "Usage: $0 <REGION> <VOLUME_NAME> <SNAPSHOT_NAME> <DESCRIPTION>"
    exit 1
fi

echo "Retrieving Volume ID for: $VOLUME_NAME..."

# 1. Get Volume ID
VOLUME_ID=$(aws ec2 describe-volumes \
    --region $REGION \
    --filters "Name=tag:Name,Values=$VOLUME_NAME" \
    --query "Volumes[*].VolumeId" \
    --output text)

if [ -z "$VOLUME_ID" ]; then
    echo "Error: Could not find Volume ID for $VOLUME_NAME."
    exit 1
fi

# 2. Create the Snapshot
echo "Creating snapshot for volume $VOLUME_ID..."
SNAPSHOT_ID=$(aws ec2 create-snapshot \
    --region $REGION \
    --volume-id $VOLUME_ID \
    --description "$DESCRIPTION" \
    --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$SNAPSHOT_NAME}]" \
    --query "SnapshotId" \
    --output text)

if [ -z "$SNAPSHOT_ID" ]; then
    echo "Error: Failed to initiate snapshot creation."
    exit 1
fi

echo "Snapshot ID: $SNAPSHOT_ID"

# 3. Wait for 'completed' state
echo "Waiting for snapshot to reach 'completed' state (this may take a few minutes)..."
aws ec2 wait snapshot-completed \
    --region $REGION \
    --snapshot-ids $SNAPSHOT_ID

echo "Success: Snapshot '$SNAPSHOT_NAME' ($SNAPSHOT_ID) is now completed."