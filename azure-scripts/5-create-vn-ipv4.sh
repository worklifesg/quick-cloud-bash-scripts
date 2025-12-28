#!/bin/bash

# Configuration
VNET_NAME=$1
LOCATION=$2
ADDRESS_PREFIX=$3

if [ -z "$VNET_NAME" ] || [ -z "$LOCATION" ] || [ -z "$ADDRESS_PREFIX" ]; then
    echo "Usage: $0 <VNET_NAME> <LOCATION> <ADDRESS_PREFIX>"
    exit 1
fi

echo "Step 1: Identifying Resource Group..."

# Automatically retrieve the first available Resource Group
RG_NAME=$(az group list --query "[0].name" -o tsv)

if [ -z "$RG_NAME" ] || [ "$RG_NAME" == "None" ]; then
    echo "Error: No Resource Group detected. Please ensure you are logged into Azure."
    exit 1
fi

echo "Using Resource Group: $RG_NAME"

# 2. Create the Virtual Network
echo "Creating Virtual Network '$VNET_NAME' with CIDR $ADDRESS_PREFIX..."
az network vnet create \
    --resource-group "$RG_NAME" \
    --name "$VNET_NAME" \
    --location "$LOCATION" \
    --address-prefixes "$ADDRESS_PREFIX"

# 3. Verify the creation
echo "Verifying VNet details..."
az network vnet show \
    --name "$VNET_NAME" \
    --resource-group "$RG_NAME" \
    --query "{Name:name, AddressSpace:addressSpace.addressPrefixes[0], Location:location}" \
    -o table