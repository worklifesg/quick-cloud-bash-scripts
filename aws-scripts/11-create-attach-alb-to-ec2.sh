#!/bin/bash

# Configuration
ALB_NAME=$1
TG_NAME=$2
SG_NAME=$3
INSTANCE_NAME=$4

if [ -z "$ALB_NAME" ] || [ -z "$TG_NAME" ] || [ -z "$SG_NAME" ] || [ -z "$INSTANCE_NAME" ]; then
    echo "Usage: $0 <ALB_NAME> <TG_NAME> <SG_NAME> <INSTANCE_NAME>"
    exit 1
fi

echo "🚀 Starting Deployment for $INSTANCE_NAME..."

# 1. Resource Discovery (Finding the specific Subnet and AZ of your instance)
INSTANCE_DATA=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=running" --query "Reservations[0].Instances[0].{Id:InstanceId,Vpc:VpcId,SG:SecurityGroups[0].GroupId,Subnet:SubnetId,AZ:Placement.AvailabilityZone}" --output json)

INSTANCE_ID=$(echo $INSTANCE_DATA | jq -r '.Id')
VPC_ID=$(echo $INSTANCE_DATA | jq -r '.Vpc')
EC2_SG_ID=$(echo $INSTANCE_DATA | jq -r '.SG')
INSTANCE_SUBNET=$(echo $INSTANCE_DATA | jq -r '.Subnet')
INSTANCE_AZ=$(echo $INSTANCE_DATA | jq -r '.AZ')

if [ "$INSTANCE_ID" == "null" ]; then echo "❌ Instance $INSTANCE_NAME not found!"; exit 1; fi

# 2. Get a SECOND subnet in a DIFFERENT AZ (ALB requires 2 AZs minimum)
OTHER_SUBNET=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query "Subnets[?AvailabilityZone!='$INSTANCE_AZ'].SubnetId | [0]" --output text)

echo "📍 Instance is in $INSTANCE_AZ. Using subnets: $INSTANCE_SUBNET and $OTHER_SUBNET"

# 3. Create Security Group for ALB (Instruction: xfusion-sg / Port 80 Public)
echo "🛡️ Configuring $SG_NAME..."
ALB_SG_ID=$(aws ec2 create-security-group --group-name $SG_NAME --description "xfusion ALB SG" --vpc-id $VPC_ID --query 'GroupId' --output text 2>/dev/null || aws ec2 describe-security-groups --filters "Name=group-name,Values=$SG_NAME" --query "SecurityGroups[0].GroupId" --output text)
aws ec2 authorize-security-group-ingress --group-id $ALB_SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 2>/dev/null

# 4. MODIFY EC2 DEFAULT SECURITY GROUP (Instruction: Make appropriate changes)
# Crucial: Allow ALB SG to reach EC2 SG on port 80 to fix 503 errors.
echo "🔗 Authorizing ALB SG in EC2 Default SG..."
aws ec2 authorize-security-group-ingress --group-id $EC2_SG_ID --protocol tcp --port 80 --source-group $ALB_SG_ID 2>/dev/null

# 5. Create Target Group (Instruction: xfusion-tg)
echo "🎯 Creating $TG_NAME..."
TG_ARN=$(aws elbv2 create-target-group --name $TG_NAME --protocol HTTP --port 80 --vpc-id $VPC_ID --target-type instance --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null || aws elbv2 describe-target-groups --names $TG_NAME --query "TargetGroups[0].TargetGroupArn" --output text)

# 6. Register Instance
aws elbv2 register-targets --target-group-arn $TG_ARN --targets Id=$INSTANCE_ID

# 7. Create ALB (Instruction: xfusion-alb)
echo "🚀 Creating ALB..."
ALB_ARN=$(aws elbv2 create-load-balancer --name $ALB_NAME --subnets $INSTANCE_SUBNET $OTHER_SUBNET --security-groups $ALB_SG_ID --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null || aws elbv2 describe-load-balancers --names $ALB_NAME --query "LoadBalancers[0].LoadBalancerArn" --output text)

# 8. Create Listener
aws elbv2 create-listener --load-balancer-arn $ALB_ARN --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$TG_ARN 2>/dev/null

echo "⏳ Waiting for Target Health to become 'healthy'..."

while true; do
    STATUS=$(aws elbv2 describe-target-health --target-group-arn $TG_ARN --query "TargetHealthDescriptions[?Target.Id=='$INSTANCE_ID'].TargetHealth.State" --output text)
    echo "Current Target Status: $STATUS"
    [[ "$STATUS" == "healthy" ]] && break
    sleep 10
done

ALB_DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns $ALB_ARN --query 'LoadBalancers[0].DNSName' --output text)
echo "------------------------------------------------"
echo "✅ DEPLOYMENT COMPLETE!"
echo "ALB URL: http://$ALB_DNS"
echo "------------------------------------------------"