#!/bin/bash

# Configuration
VNET_NAME=$1
SUBNET_NAME=$2
LOCATION=$3
VNET_PREFIX=$4
SUBNET_PREFIX=$5

if [ -z "$VNET_NAME" ] || [ -z "$SUBNET_NAME" ] || [ -z "$LOCATION" ] || [ -z "$VNET_PREFIX" ] || [ -z "$SUBNET_PREFIX" ]; then
    echo "Usage: $0 <VNET_NAME> <SUBNET_NAME> <LOCATION> <VNET_PREFIX> <SUBNET_PREFIX>"
    exit 1
fi

echo "Step 1: Identifying Resource Group..."
RG_NAME=$(az group list --query "[0].name" -o tsv)

if [ -z "$RG_NAME" ] || [ "$RG_NAME" == "None" ]; then
    echo "Error: No Resource Group detected."
    exit 1
fi

echo "Step 2: Creating VNet and Subnet..."
# Creating the VNet and the Subnet in one command
az network vnet create \
    --resource-group "$RG_NAME" \
    --name "$VNET_NAME" \
    --location "$LOCATION" \
    --address-prefixes "$VNET_PREFIX" \
    --subnet-name "$SUBNET_NAME" \
    --subnet-prefixes "$SUBNET_PREFIX"

echo "------------------------------------------------"
echo "Verification: Details for $VNET_NAME"
az network vnet show --name "$VNET_NAME" --resource-group "$RG_NAME" \
    --query "{Name:name, AddressSpace:addressSpace.addressPrefixes[0], Subnet:subnets[0].name}" \
    -o table