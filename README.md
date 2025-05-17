# Transit Gateway VPN Monitoring Solution

This solution deploys a Transit Gateway with VPN attachments and a Lambda function that monitors VPN connections and automatically reconfigures routes when failures occur.

## Architecture

The solution creates the following resources:

- AWS Transit Gateway
- VPC attachment to the Transit Gateway
- Primary and standby Customer Gateways
- Primary and standby VPN connections with static routes
- Lambda function for VPN monitoring
- SNS topic for alerts and notifications
- CloudWatch Event rules to trigger the Lambda function

## Deployment Instructions

### Prerequisites

- AWS CLI installed and configured with appropriate credentials
- A VPC in your AWS account
- Two public IP addresses for your customer gateways (on-premises VPN devices)

### Deploy using the script

1. Run the deployment script:
   ```bash
   ./deploy-tgw-vpn.sh
   ```

2. The script will:
   - Show available VPCs in your account
   - Prompt you to enter a VPC ID
   - Prompt you for primary and standby customer gateway IP addresses
   - Deploy the CloudFormation stack
   - Wait for the deployment to complete
   - Display the stack outputs

### Deploy manually

If you prefer to deploy manually:

1. Open the AWS CloudFormation console
2. Create a new stack
3. Upload the `tgw-vpn-simplified.yaml` template
4. Enter the required parameters:
   - VPC ID
   - Primary customer gateway IP
   - Standby customer gateway IP
5. Create the stack

## Post-Deployment Steps

After deployment:

1. Configure your on-premises VPN devices using the configuration information from the AWS Console
2. The Lambda function will automatically monitor the VPN connections and switch routes as needed
3. You'll receive notifications via SNS when route changes occur

## Parameters

- `VpcId`: The ID of the VPC to attach to the Transit Gateway
- `PrimaryCustomerGatewayIp`: The IP address of the primary customer gateway
- `StandbyCustomerGatewayIp`: The IP address of the standby customer gateway
- `OnPremiseCidr`: The CIDR block for the on-premises network (default: 192.168.0.0/16)
- `LambdaSchedule`: The schedule expression for Lambda function execution (default: rate(5 minutes))

## Outputs

- `TransitGatewayId`: The ID of the Transit Gateway
- `PrimaryVpnConnectionId`: The ID of the primary VPN connection
- `StandbyVpnConnectionId`: The ID of the standby VPN connection
- `VpnMonitoringLambdaArn`: The ARN of the VPN monitoring Lambda function
- `VpnMonitoringTopicArn`: The ARN of the SNS topic for VPN monitoring alerts
