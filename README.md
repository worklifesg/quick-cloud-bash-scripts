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
| 📡 | **[Attach Elastic IP to EC2 Instance](1-attach-elastic-ip-ec2.sh)** | Associates an Elastic IP (EIP) with an EC2 instance by retrieving IDs via tags and associating them. | `./1-attach-elastic-ip-ec2.sh <REGION> <INSTANCE_NAME> <EIP_NAME>` |
| 🔌 | **[Attach ENI to EC2 Instance](2-attach-eni-to-ec2.sh)** | Attaches a Network Interface (ENI) to an EC2 instance, waits for initialization, and confirms attachment. | `./2-attach-eni-to-ec2.sh <REGION> <INSTANCE_NAME> <ENI_NAME>` |

### Detailed Descriptions

#### 📡 [Attach Elastic IP to EC2 Instance](1-attach-elastic-ip-ec2.sh)
This script associates an Elastic IP (EIP) with an EC2 instance. It retrieves the instance ID by filtering EC2 instances based on the provided instance name tag and instance state (running or pending). It also retrieves the allocation ID of the EIP by filtering addresses based on the EIP name tag. Then, it associates the EIP with the instance using the AWS CLI.

#### 🔌 [Attach ENI to EC2 Instance](2-attach-eni-to-ec2.sh)
This script attaches a Network Interface (ENI) to an EC2 instance. It retrieves the instance ID by filtering EC2 instances based on the provided instance name tag and instance state (running or pending). It retrieves the ENI ID by filtering network interfaces based on the ENI name tag. The script waits for the instance to pass status checks, then attaches the ENI to the instance at device index 1. Finally, it waits for the ENI attachment status to become 'attached'.

---

## <img src="https://upload.wikimedia.org/wikipedia/commons/a/a8/Microsoft_Azure_Logo.svg" width="25" height="15" style="vertical-align: middle;"> <span style="color: #0078D4;">Azure Scripts</span>

### Scripts Overview

| Icon | Script | Summary | Usage |
|------|--------|---------|-------|
| <!-- Add Azure scripts here --> |  |  |  |

### Detailed Descriptions 

<!-- Add detailed descriptions for Azure scripts here -->