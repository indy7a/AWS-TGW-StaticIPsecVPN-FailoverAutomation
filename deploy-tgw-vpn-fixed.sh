#!/bin/bash

# Exit on error
set -e

# Default region
REGION="us-west-2"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. It's recommended for parsing AWS CLI output."
    echo "Continuing without jq..."
fi

# Get VPC ID
echo "Fetching available VPCs..."
aws ec2 describe-vpcs --region $REGION --query "Vpcs[*].{VpcId:VpcId,CidrBlock:CidrBlock,Name:Tags[?Key=='Name'].Value|[0]}" --output table

echo ""
echo "Please enter the VPC ID to use:"
read VPC_ID

if [ -z "$VPC_ID" ]; then
    echo "VPC ID is required. Exiting."
    exit 1
fi

# Get Customer Gateway IPs
echo "Please enter the primary customer gateway IP address:"
read PRIMARY_CGW_IP

if [ -z "$PRIMARY_CGW_IP" ]; then
    echo "Primary customer gateway IP is required. Exiting."
    exit 1
fi

echo "Please enter the standby customer gateway IP address:"
read STANDBY_CGW_IP

if [ -z "$STANDBY_CGW_IP" ]; then
    echo "Standby customer gateway IP is required. Exiting."
    exit 1
fi

# Set stack name
STACK_NAME="tgw-vpn-monitoring"

# Deploy the CloudFormation stack
echo "Deploying CloudFormation stack $STACK_NAME..."
aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://tgw-vpn-simplified-fixed.yaml \
    --parameters \
        ParameterKey=VpcId,ParameterValue=$VPC_ID \
        ParameterKey=PrimaryCustomerGatewayIp,ParameterValue=$PRIMARY_CGW_IP \
        ParameterKey=StandbyCustomerGatewayIp,ParameterValue=$STANDBY_CGW_IP \
    --capabilities CAPABILITY_IAM \
    --region $REGION

echo "Stack creation initiated. You can monitor the progress in the AWS CloudFormation console."
echo "Stack name: $STACK_NAME"
echo "Region: $REGION"

# Wait for stack creation to complete
echo "Waiting for stack creation to complete. This may take several minutes..."
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region $REGION

if [ $? -eq 0 ]; then
    echo "Stack creation completed successfully!"
    
    # Get stack outputs
    echo "Stack outputs:"
    aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query "Stacks[0].Outputs" --output table
else
    echo "Stack creation failed or timed out. Please check the AWS CloudFormation console for details."
fi
