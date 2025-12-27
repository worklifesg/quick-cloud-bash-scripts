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

| Icon | Script | Summary | Usage |
|------|--------|---------|-------|
| 📡 | **[Attach Elastic IP to EC2 Instance](aws-scripts/1-attach-elastic-ip-ec2.sh)** | Associates an Elastic IP (EIP) with an EC2 instance by retrieving IDs via tags and associating them. | `./aws-scripts/1-attach-elastic-ip-ec2.sh <REGION> <INSTANCE_NAME> <EIP_NAME>` |
| 🔌 | **[Attach ENI to EC2 Instance](aws-scripts/2-attach-eni-to-ec2.sh)** | Attaches a Network Interface (ENI) to an EC2 instance, waits for initialization, and confirms attachment. | `./aws-scripts/2-attach-eni-to-ec2.sh <REGION> <INSTANCE_NAME> <ENI_NAME>` |
| 💾 | **[Attach Volume to EC2 Instance](aws-scripts/3-attach-volume-to-ec2.sh)** | Attaches an EBS volume to an EC2 instance by retrieving IDs via tags and attaching it at a specified device. | `./aws-scripts/3-attach-volume-to-ec2.sh <REGION> <INSTANCE_NAME> <VOLUME_NAME> <DEVICE_NAME>` |
| 🖼️ | **[Create AMI from EC2 Instance](aws-scripts/4-create-ami-from-ec2.sh)** | Creates an Amazon Machine Image (AMI) from a running or stopped EC2 instance and waits for it to be available. | `./aws-scripts/4-create-ami-from-ec2.sh <REGION> <INSTANCE_NAME> <AMI_NAME>` |
| 🗑️ | **[Terminate EC2 Instance](aws-scripts/5-terminate-ec2.sh)** | Terminates an EC2 instance by retrieving its ID via tags and waits for the termination to complete. | `./aws-scripts/5-terminate-ec2.sh <REGION> <INSTANCE_NAME>` |
| 📸 | **[Create Volume Snapshot](aws-scripts/6-create-volume-snapshot.sh)** | Creates a snapshot of an EBS volume with a given description and waits for completion. | `./aws-scripts/6-create-volume-snapshot.sh <REGION> <VOLUME_NAME> <SNAPSHOT_NAME> <DESCRIPTION>` |
| 🔄 | **[Create Volume from Snapshot](aws-scripts/7-create-volume-from-snapshot.sh)** | Creates a new EBS volume from an existing snapshot in a specified availability zone and waits for availability. | `./aws-scripts/7-create-volume-from-snapshot.sh <REGION> <SNAPSHOT_NAME> <NEW_VOLUME_NAME> <AVAILABILITY_ZONE>` |

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

---

## <img src="https://upload.wikimedia.org/wikipedia/commons/a/a8/Microsoft_Azure_Logo.svg" width="25" height="15" style="vertical-align: middle;"> <span style="color: #0078D4;">Azure Scripts</span>

### Scripts Overview

| Icon | Script | Summary | Usage |
|------|--------|---------|-------|
| <!-- Add Azure scripts here --> |  |  |  |

### Detailed Descriptions 

<!-- Add detailed descriptions for Azure scripts here -->