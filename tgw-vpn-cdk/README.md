# Transit Gateway VPN Monitoring CDK Project

This CDK project deploys a Transit Gateway with VPN attachments and a Lambda function that monitors VPN connections and automatically reconfigures routes when failures occur.

## Architecture

The project creates the following resources:

- AWS Transit Gateway
- VPC attachment to the Transit Gateway
- Primary and standby Customer Gateways
- Primary and standby VPN connections with static routes
- Lambda function for VPN monitoring
- SNS topic for alerts and notifications
- CloudWatch Event rules to trigger the Lambda function

## Prerequisites

- Node.js and npm installed (required for AWS CDK)
- AWS CDK installed (`npm install -g aws-cdk`)
- Python 3.9 or later
- AWS CLI configured with appropriate credentials
- A VPC in your AWS account

## Installation

1. Install Node.js and npm (required for CDK):
   - For macOS: `brew install node`
   - For Linux: `sudo apt install nodejs npm` or equivalent for your distribution
   - For Windows: Download from https://nodejs.org/

2. Install AWS CDK globally:
   ```bash
   npm install -g aws-cdk
   ```

3. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Update the `cdk.json` file with your configuration:
   ```json
   {
     "context": {
       "vpc_id": "vpc-12345678",
       "primary_cgw_ip": "203.0.113.1",
       "standby_cgw_ip": "203.0.113.2",
       "on_premise_cidr": "192.168.0.0/16",
       "lambda_schedule": "rate(5 minutes)"
     }
   }
   ```

5. Bootstrap your AWS environment (one-time setup):
   ```bash
   cdk bootstrap
   ```

6. Deploy the stack:
   ```bash
   cdk deploy
   ```

## Manual Deployment with CloudFormation

If you prefer not to install Node.js and CDK, you can synthesize the CloudFormation template and deploy it manually:

1. Use the AWS CloudFormation console
2. Create a new stack
3. Upload the template file from this repository
4. Fill in the required parameters
5. Create the stack

## Usage

After deployment:

1. Configure your on-premises VPN devices using the configuration information from the AWS Console
2. The Lambda function will automatically monitor the VPN connections and switch routes as needed
3. You'll receive notifications via SNS when route changes occur

## Parameters

- `vpc_id`: The ID of the VPC to attach to the Transit Gateway
- `primary_cgw_ip`: The IP address of the primary customer gateway
- `standby_cgw_ip`: The IP address of the standby customer gateway
- `on_premise_cidr`: The CIDR block for the on-premises network (default: 192.168.0.0/16)
- `lambda_schedule`: The schedule expression for Lambda function execution (default: rate(5 minutes))

## Outputs

- `TransitGatewayIdOutput`: The ID of the Transit Gateway
- `PrimaryVpnConnectionIdOutput`: The ID of the primary VPN connection
- `StandbyVpnConnectionIdOutput`: The ID of the standby VPN connection
- `VpnMonitoringLambdaArnOutput`: The ARN of the VPN monitoring Lambda function
- `VpnMonitoringTopicArnOutput`: The ARN of the SNS topic for VPN monitoring alerts
