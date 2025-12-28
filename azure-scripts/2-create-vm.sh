#!/bin/bash

# Configuration
VM_NAME=$1
LOCATION=$2
IMAGE=$3
SIZE=$4
STORAGE_TYPE=$5
OS_DISK_SIZE=$6

if [ -z "$VM_NAME" ] || [ -z "$LOCATION" ] || [ -z "$IMAGE" ] || [ -z "$SIZE" ] || [ -z "$STORAGE_TYPE" ] || [ -z "$OS_DISK_SIZE" ]; then
    echo "Usage: $0 <VM_NAME> <LOCATION> <IMAGE> <SIZE> <STORAGE_TYPE> <OS_DISK_SIZE>"
    exit 1
fi

echo "Step 1: Identifying Resource Group..."
RG_NAME=$(az group list --query "[0].name" -o tsv)

if [ -z "$RG_NAME" ] || [ "$RG_NAME" == "None" ]; then
    echo "Error: No Resource Group detected."
    exit 1
fi
echo "Using Resource Group: $RG_NAME"

echo "Step 2: Creating Virtual Machine $VM_NAME..."
# Creating the VM with specified requirements
# --os-disk-delete-option Detach is used to keep it simple, 
# but the lab asks for a 30GB Standard HDD.
az vm create \
    --resource-group "$RG_NAME" \
    --name "$VM_NAME" \
    --location "$LOCATION" \
    --image "$IMAGE" \
    --size "$SIZE" \
    --admin-username azureuser \
    --generate-ssh-keys \
    --storage-sku "$STORAGE_TYPE" \
    --os-disk-size-gb "$OS_DISK_SIZE" \
    --public-ip-sku Standard

echo "Step 3: Opening Port 22 (SSH) in the NSG..."
az vm open-port \
    --resource-group "$RG_NAME" \
    --name "$VM_NAME" \
    --port 22 \
    --priority 1001

echo "Step 4: Verifying VM Status..."
STATUS=$(az vm get-instance-view \
    --name "$VM_NAME" \
    --resource-group "$RG_NAME" \
    --query "instanceView.statuses[1].displayStatus" \
    --output tsv)

if [[ "$STATUS" == *"VM running"* ]]; then
    IP_ADDRESS=$(az vm list-ip-addresses --resource-group "$RG_NAME" --name "$VM_NAME" --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)
    echo "Success: VM is running at $IP_ADDRESS"
    echo "You can SSH using: ssh azureuser@$IP_ADDRESS"
else
    echo "Error: VM status is $STATUS"
    exit 1
fi