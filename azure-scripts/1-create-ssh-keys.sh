#!/bin/bash

# Configuration
KEY_NAME=$1
LOCATION=$2
RG_NAME=$3

if [ -z "$KEY_NAME" ] || [ -z "$LOCATION" ] || [ -z "$RG_NAME" ]; then
    echo "Usage: $0 <KEY_NAME> <LOCATION> <RG_NAME>"
    exit 1
fi

echo "Using Resource Group: $RG_NAME"

# 2. Create the SSH Key Pair
# The 'az sshkey create' command defaults to RSA.
echo "Creating RSA SSH Key Pair: $KEY_NAME..."
az sshkey create \
    --name "$KEY_NAME" \
    --resource-group "$RG_NAME" \
    --location "$LOCATION"

# 3. Final Verification
echo "Verifying key creation..."
KEY_ID=$(az sshkey show \
    --name "$KEY_NAME" \
    --resource-group "$RG_NAME" \
    --query "id" \
    --output tsv)

if [ -n "$KEY_ID" ] && [ "$KEY_ID" != "None" ]; then
    echo "Success: Key '$KEY_NAME' created successfully."
    echo "Resource ID: $KEY_ID"
else
    echo "Error: Failed to verify key creation."
    exit 1
fi