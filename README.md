# Quick Cloud Bash Scripts

📅 **Last Updated:** December 27, 2025

This repository contains bash scripts for quick AWS and Azure operations.

## Table of Contents

- [<img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" width="20" height="12" style="vertical-align: middle;"> AWS Scripts](#aws-scripts)
  - [Scripts Overview](#scripts-overview)
  - [Detailed Descriptions](#detailed-descriptions)
- [<img src="https://upload.wikimedia.org/wikipedia/commons/a/a8/Microsoft_Azure_Logo.svg" width="20" height="12" style="vertical-align: middle;"> Azure Scripts](#azure-scripts)
  - [Scripts Overview](#scripts-overview-1)
  - [Detailed Descriptions](#detailed-descriptions-1)

---

## <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" width="25" height="15" style="vertical-align: middle;"> <span style="color: #FF9900;">AWS Scripts</span>

### Scripts Overview

| Icon | Script | Summary | Level | Usage |
|------|--------|---------|-------|-------|
| 📡 | **[Attach Elastic IP to EC2 Instance](aws-scripts/1-attach-elastic-ip-ec2.sh)** | Associates an Elastic IP (EIP) with an EC2 instance by retrieving IDs via tags and associating them. | Intermediate | `./aws-scripts/1-attach-elastic-ip-ec2.sh <REGION> <INSTANCE_NAME> <EIP_NAME>` |
| 🔌 | **[Attach ENI to EC2 Instance](aws-scripts/2-attach-eni-to-ec2.sh)** | Attaches a Network Interface (ENI) to an EC2 instance, waits for initialization, and confirms attachment. | Intermediate | `./aws-scripts/2-attach-eni-to-ec2.sh <REGION> <INSTANCE_NAME> <ENI_NAME>` |
| 💾 | **[Attach Volume to EC2 Instance](aws-scripts/3-attach-volume-to-ec2.sh)** | Attaches an EBS volume to an EC2 instance by retrieving IDs via tags and attaching it at a specified device. | Intermediate | `./aws-scripts/3-attach-volume-to-ec2.sh <REGION> <INSTANCE_NAME> <VOLUME_NAME> <DEVICE_NAME>` |
| 🖼️ | **[Create AMI from EC2 Instance](aws-scripts/4-create-ami-from-ec2.sh)** | Creates an Amazon Machine Image (AMI) from a running or stopped EC2 instance and waits for it to be available. | Advanced | `./aws-scripts/4-create-ami-from-ec2.sh <REGION> <INSTANCE_NAME> <AMI_NAME>` |
| 🗑️ | **[Terminate EC2 Instance](aws-scripts/5-terminate-ec2.sh)** | Terminates an EC2 instance by retrieving its ID via tags and waits for the termination to complete. | Beginner | `./aws-scripts/5-terminate-ec2.sh <REGION> <INSTANCE_NAME>` |
| 📸 | **[Create Volume Snapshot](aws-scripts/6-create-volume-snapshot.sh)** | Creates a snapshot of an EBS volume with a given description and waits for completion. | Intermediate | `./aws-scripts/6-create-volume-snapshot.sh <REGION> <VOLUME_NAME> <SNAPSHOT_NAME> <DESCRIPTION>` |
| 🔄 | **[Create Volume from Snapshot](aws-scripts/7-create-volume-from-snapshot.sh)** | Creates a new EBS volume from an existing snapshot in a specified availability zone and waits for availability. | Intermediate | `./aws-scripts/7-create-volume-from-snapshot.sh <REGION> <SNAPSHOT_NAME> <NEW_VOLUME_NAME> <AVAILABILITY_ZONE>` |
| 🔐 | **[Create IAM Policy for EC2 Read-Only](aws-scripts/8-create-iamrole-ec2.sh)** | Creates an IAM policy with read-only access to EC2 resources and verifies the policy creation. | Advanced | `./aws-scripts/8-create-iamrole-ec2.sh <POLICY_NAME>` |
| 🔑 | **[Create IAM Role and Attach Policy](aws-scripts/9-iamrole-ec2-policy.sh)** | Creates an IAM role for EC2 with a trust policy and attaches a specified IAM policy. | Advanced | `./aws-scripts/9-iamrole-ec2-policy.sh <ROLE_NAME> <POLICY_NAME>` |
| 🚀 | **[Launch EC2 Instance with Elastic IP](aws-scripts/10-create-ec2-eip-application.sh)** | Launches an EC2 instance with the latest Ubuntu AMI, allocates and associates an EIP, and provides the public IP. | Intermediate | `./aws-scripts/10-create-ec2-eip-application.sh <INSTANCE_NAME> <EIP_NAME> <INSTANCE_TYPE>` |

### Detailed Descriptions

#### 📡 [Attach Elastic IP to EC2 Instance](aws-scripts/1-attach-elastic-ip-ec2.sh)
This script associates an Elastic IP (EIP) with an EC2 instance. It retrieves the instance ID by filtering EC2 instances based on the provided instance name tag and instance state (running or pending). It also retrieves the allocation ID of the EIP by filtering addresses based on the EIP name tag. Then, it associates the EIP with the instance using the AWS CLI.

#### 🔌 [Attach ENI to EC2 Instance](aws-scripts/2-attach-eni-to-ec2.sh)
This script attaches a Network Interface (ENI) to an EC2 instance. It retrieves the instance ID by filtering EC2 instances based on the provided instance name tag and instance state (running or pending). It retrieves the ENI ID by filtering network interfaces based on the ENI name tag. The script waits for the instance to pass status checks, then attaches the ENI to the instance at device index 1. Finally, it waits for the ENI attachment status to become 'attached'.

#### 💾 [Attach Volume to EC2 Instance](aws-scripts/3-attach-volume-to-ec2.sh)
This script attaches an EBS volume to an EC2 instance. It retrieves the instance ID by filtering EC2 instances based on the provided instance name tag and instance state (running or pending). It retrieves the volume ID by filtering volumes based on the volume name tag. The script waits for the instance to be in a running state, then attaches the volume to the instance at the specified device name. Finally, it waits for the volume status to become 'in-use'.

#### 🖼️ [Create AMI from EC2 Instance](aws-scripts/4-create-ami-from-ec2.sh)
This script creates an Amazon Machine Image (AMI) from an EC2 instance. It retrieves the instance ID by filtering EC2 instances based on the provided instance name tag and instance state (running or stopped). It then creates the AMI with the specified name and description, without rebooting the instance. The script waits for the AMI to become available before confirming success.

#### 🗑️ [Terminate EC2 Instance](aws-scripts/5-terminate-ec2.sh)
This script terminates an EC2 instance. It retrieves the instance ID by filtering EC2 instances based on the provided instance name tag and various instance states (running, stopped, stopping, pending). If the instance is found, it initiates termination and waits for the instance to reach the 'terminated' state. If the instance is not found, it assumes it's already terminated and exits gracefully.

#### 📸 [Create Volume Snapshot](aws-scripts/6-create-volume-snapshot.sh)
This script creates a snapshot of an EBS volume. It retrieves the volume ID by filtering volumes based on the provided volume name tag. It then creates the snapshot with the specified name, description, and tags the snapshot accordingly. The script waits for the snapshot to reach the 'completed' state before confirming success.

#### 🔄 [Create Volume from Snapshot](aws-scripts/7-create-volume-from-snapshot.sh)
This script creates a new EBS volume from an existing snapshot. It retrieves the snapshot ID by filtering snapshots based on the provided snapshot name tag. It then creates the volume in the specified availability zone, tags it with the new volume name, and waits for the volume to reach the 'available' state before confirming success.

#### 🔐 [Create IAM Policy for EC2 Read-Only](aws-scripts/8-create-iamrole-ec2.sh)
This script creates an IAM policy with read-only permissions for various EC2 resources. It generates a JSON policy document allowing actions like describing instances, images, snapshots, and more, creates the policy in AWS, cleans up the temporary file, and verifies the policy creation by listing it.

#### 🔑 [Create IAM Role and Attach Policy](aws-scripts/9-iamrole-ec2-policy.sh)
This script creates an IAM role that can be assumed by EC2 instances. It generates a trust policy allowing EC2 to assume the role, creates the role, attaches a specified IAM policy to it, and verifies the role and attached policies.

#### 🚀 [Launch EC2 Instance with Elastic IP](aws-scripts/10-create-ec2-eip-application.sh)
This script launches a new EC2 instance using the latest Ubuntu 22.04 AMI, waits for it to be running, allocates a new Elastic IP, tags it, associates it with the instance, and outputs the static public IP for access.

---

## <img src="https://upload.wikimedia.org/wikipedia/commons/a/a8/Microsoft_Azure_Logo.svg" width="25" height="15" style="vertical-align: middle;"> <span style="color: #0078D4;">Azure Scripts</span>

### Scripts Overview

| Icon | Script | Summary | Level | Usage |
|------|--------|---------|-------|-------|
| 🔑 | **[Create SSH Key Pair](azure-scripts/1-create-ssh-keys.sh)** | Creates an RSA SSH key pair in Azure using a specified resource group and verifies creation. | Beginner | `./azure-scripts/1-create-ssh-keys.sh <KEY_NAME> <LOCATION> <RG_NAME>` |
| 💻 | **[Create Virtual Machine](azure-scripts/2-create-vm.sh)** | Creates an Azure VM with specified image, size, and storage, opens SSH port, and verifies status. | Intermediate | `./azure-scripts/2-create-vm.sh <VM_NAME> <LOCATION> <IMAGE> <SIZE> <STORAGE_TYPE> <OS_DISK_SIZE>` |
| 🌐 | **[Create Virtual Network](azure-scripts/3-create-vnet.sh)** | Creates an Azure Virtual Network with a specified address prefix and verifies creation. | Beginner | `./azure-scripts/3-create-vnet.sh <VNET_NAME> <LOCATION> <ADDRESS_PREFIX>` |
| 💰 | **[Create Budget via REST API](azure-scripts/4-create-budgets-restapi.sh)** | Creates an Azure budget with email notifications using the REST API and verifies the budget. | Advanced | `./azure-scripts/4-create-budgets-restapi.sh <BUDGET_NAME> <AMOUNT> <EMAIL_ADDRESS>` |
| 🌐 | **[Create Virtual Network IPv4](azure-scripts/5-create-vn-ipv4.sh)** | Creates an Azure Virtual Network with an IPv4 address prefix and displays the details. | Beginner | `./azure-scripts/5-create-vn-ipv4.sh <VNET_NAME> <LOCATION> <ADDRESS_PREFIX>` |
| 🏗️ | **[Create Subnet in Virtual Network](azure-scripts/6-create-subnets-network.sh)** | Creates an Azure Virtual Network with a subnet and verifies the network setup. | Intermediate | `./azure-scripts/6-create-subnets-network.sh <VNET_NAME> <SUBNET_NAME> <LOCATION> <VNET_PREFIX> <SUBNET_PREFIX>` |

### Detailed Descriptions

#### 🔑 [Create SSH Key Pair](azure-scripts/1-create-ssh-keys.sh)
This script creates an RSA SSH key pair in Azure using the specified resource group. It creates the SSH key pair with the given name in the provided location and verifies the creation by checking the resource ID.

#### 💻 [Create Virtual Machine](azure-scripts/2-create-vm.sh)
This script creates an Azure Virtual Machine with the specified parameters. It detects the first available resource group, creates the VM with the given image, size, storage type, and OS disk size, generates SSH keys, opens port 22 for SSH, and verifies that the VM is running by checking its status and retrieving the public IP address.

#### 🌐 [Create Virtual Network](azure-scripts/3-create-vnet.sh)
This script creates an Azure Virtual Network with the specified name, location, and address prefix. It detects the first available resource group, creates the VNet, and verifies the creation by checking the resource ID.

#### 💰 [Create Budget via REST API](azure-scripts/4-create-budgets-restapi.sh)
This script creates an Azure budget using the REST API to bypass CLI limitations. It sets up a monthly budget with the specified amount, start and end dates (current month to 2 years ahead), and email notifications at 80% threshold. It then verifies the budget creation by displaying its details.

#### 🌐 [Create Virtual Network IPv4](azure-scripts/5-create-vn-ipv4.sh)
This script creates an Azure Virtual Network with the specified name, location, and IPv4 address prefix. It detects the first available resource group, creates the VNet, and displays the VNet details including name, address space, and location.

#### 🏗️ [Create Subnet in Virtual Network](azure-scripts/6-create-subnets-network.sh)
This script creates an Azure Virtual Network along with a subnet in a single operation. It detects the first available resource group, sets up the VNet with the specified address prefix and creates the subnet with its own prefix, then displays the VNet and subnet details for verification.