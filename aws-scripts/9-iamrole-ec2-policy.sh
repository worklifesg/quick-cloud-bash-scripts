#!/bin/bash

# Configuration
ROLE_NAME=$1
POLICY_NAME=$2
TRUST_POLICY_FILE="trust-policy.json"

if [ -z "$ROLE_NAME" ] || [ -z "$POLICY_NAME" ]; then
    echo "Usage: $0 <ROLE_NAME> <POLICY_NAME>"
    exit 1
fi

echo "Step 1: Identifying AWS Account ID..."
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Construct the Policy ARN
POLICY_ARN="arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME"

echo "Step 2: Creating the Trust Policy for EC2..."
# This JSON allows the EC2 service to assume this role
cat <<EOF > $TRUST_POLICY_FILE
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

echo "Step 3: Creating the IAM Role '$ROLE_NAME'..."
aws iam create-role \
    --role-name "$ROLE_NAME" \
    --assume-role-policy-document "file://$TRUST_POLICY_FILE"

echo "Step 4: Attaching the policy '$POLICY_NAME' to the role..."
aws iam attach-role-policy \
    --role-name "$ROLE_NAME" \
    --policy-arn "$POLICY_ARN"

# Step 5: Cleanup and Verification
rm $TRUST_POLICY_FILE
echo "------------------------------------------------"
echo "Verification: Role Details"
aws iam get-role --role-name "$ROLE_NAME" --query 'Role.[RoleName, Arn]' --output table
echo "Verification: Attached Policies"
aws iam list-attached-role-policies --role-name "$ROLE_NAME" --output table