#!/bin/bash

# Configuration
POLICY_NAME=$1
POLICY_FILE="ec2-readonly-policy.json"

if [ -z "$POLICY_NAME" ]; then
    echo "Usage: $0 <POLICY_NAME>"
    exit 1
fi

echo "Step 1: Creating the Policy JSON document..."

# Define the policy: Describe actions allow viewing/reading metadata
cat <<EOF > $POLICY_FILE
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeImages",
                "ec2:DescribeSnapshots",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets"
            ],
            "Resource": "*"
        }
    ]
}
EOF

echo "Step 2: Creating IAM Policy in AWS..."

# IAM is a global service; region us-east-1 is used for the CLI context
aws iam create-policy \
    --policy-name "$POLICY_NAME" \
    --policy-document "file://$POLICY_FILE" \
    --description "Read-only access to EC2 console for Javed" \
    --region us-east-1

# Step 3: Cleanup and Verification
if [ $? -eq 0 ]; then
    echo "Success: Policy '$POLICY_NAME' created."
    rm $POLICY_FILE
else
    echo "Error: Policy creation failed."
fi

echo "------------------------------------------------"
echo "Verification: Policy Details"
aws iam list-policies --scope Local --query "Policies[?PolicyName=='$POLICY_NAME']" --output table