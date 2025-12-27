#!/bin/bash

# Configuration
REGION=$1
SNAPSHOT_NAME=$2
NEW_VOLUME_NAME=$3
AVAILABILITY_ZONE=$4

if [ -z "$REGION" ] || [ -z "$SNAPSHOT_NAME" ] || [ -z "$NEW_VOLUME_NAME" ] || [ -z "$AVAILABILITY_ZONE" ]; then
    echo "Usage: $0 <REGION> <SNAPSHOT_NAME> <NEW_VOLUME_NAME> <AVAILABILITY_ZONE>"
    exit 1
fi

echo "Retrieving Snapshot ID for: $SNAPSHOT_NAME..."

# 1. Get Snapshot ID
SNAPSHOT_ID=$(aws ec2 describe-snapshots \
    --region $REGION \
    --filters "Name=tag:Name,Values=$SNAPSHOT_NAME" \
    --query "Snapshots[*].SnapshotId" \
    --output text)

if [ -z "$SNAPSHOT_ID" ]; then
    echo "Error: Could not find Snapshot ID for $SNAPSHOT_NAME."
    exit 1
fi

# 2. Create Volume from Snapshot
echo "Creating new volume from snapshot $SNAPSHOT_ID..."
VOLUME_ID=$(aws ec2 create-volume \
    --region $REGION \
    --availability-zone $AVAILABILITY_ZONE \
    --snapshot-id $SNAPSHOT_ID \
    --tag-specifications "ResourceType=volume,Tags=[{Key=Name,Value=$NEW_VOLUME_NAME}]" \
    --query "VolumeId" \
    --output text)

if [ -z "$VOLUME_ID" ]; then
    echo "Error: Failed to create volume."
    exit 1
fi

echo "New Volume ID: $VOLUME_ID"

# 3. Wait for 'available' state
echo "Waiting for volume to reach 'available' state..."
aws ec2 wait volume-available \
    --region $REGION \
    --volume-ids $VOLUME_ID

echo "Success: Volume '$NEW_VOLUME_NAME' ($VOLUME_ID) is ready in $AVAILABILITY_ZONE."