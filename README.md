# Quick Cloud Bash Scripts

This repository contains bash scripts for quick AWS and Azure operations.

## AWS Scripts

### Scripts Overview

| Icon | Script | Summary | Usage |
|------|--------|---------|-------|
| 📄 | [1-attach-elastic-ip-ec2.sh](1-attach-elastic-ip-ec2.sh) | Associates an Elastic IP (EIP) with an EC2 instance by retrieving IDs via tags and associating them. | `./1-attach-elastic-ip-ec2.sh <REGION> <INSTANCE_NAME> <EIP_NAME>` |
| 📄 | [2-attach-eni-to-ec2.sh](2-attach-eni-to-ec2.sh) | Attaches a Network Interface (ENI) to an EC2 instance, waits for initialization, and confirms attachment. | `./2-attach-eni-to-ec2.sh <REGION> <INSTANCE_NAME> <ENI_NAME>` |

### Detailed Descriptions

#### 📄 [1-attach-elastic-ip-ec2.sh](1-attach-elastic-ip-ec2.sh)
This script associates an Elastic IP (EIP) with an EC2 instance. It retrieves the instance ID by filtering EC2 instances based on the provided instance name tag and instance state (running or pending). It also retrieves the allocation ID of the EIP by filtering addresses based on the EIP name tag. Then, it associates the EIP with the instance using the AWS CLI.

#### 📄 [2-attach-eni-to-ec2.sh](2-attach-eni-to-ec2.sh)
This script attaches a Network Interface (ENI) to an EC2 instance. It retrieves the instance ID by filtering EC2 instances based on the provided instance name tag and instance state (running or pending). It retrieves the ENI ID by filtering network interfaces based on the ENI name tag. The script waits for the instance to pass status checks, then attaches the ENI to the instance at device index 1. Finally, it waits for the ENI attachment status to become 'attached'.

## Azure Scripts

### Scripts Overview

| Icon | Script | Summary | Usage |
|------|--------|---------|-------|
| <!-- Add Azure scripts here --> |  |  |  |

### Detailed Descriptions 

<!-- Add detailed descriptions for Azure scripts here -->