from aws_cdk import (
    Stack,
    aws_ec2 as ec2,
    aws_lambda as lambda_,
    aws_iam as iam,
    aws_sns as sns,
    aws_events as events,
    aws_events_targets as targets,
    CfnOutput,
    Duration,
    CustomResource,
    RemovalPolicy,
    custom_resources as cr
)
from constructs import Construct

class TransitGatewayVpnStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, 
                 vpc_id: str, 
                 primary_cgw_ip: str, 
                 standby_cgw_ip: str, 
                 on_premise_cidr: str = "192.168.0.0/16",
                 lambda_schedule: str = "rate(5 minutes)",
                 **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Import the VPC
        vpc = ec2.Vpc.from_lookup(self, "VPC", vpc_id=vpc_id)
        
        # Create Transit Gateway
        transit_gateway = ec2.CfnTransitGateway(self, "TransitGateway",
            description="Transit Gateway for VPN connections",
            default_route_table_association="enable",
            default_route_table_propagation="enable",
            auto_accept_shared_attachments="disable",
            tags=[{"key": "Name", "value": f"{construct_id}-TGW"}]
        )
        
        # Create a custom resource to get subnet IDs from the VPC
        subnet_provider = cr.Provider(self, "SubnetProvider",
            on_event_handler=lambda_.Function(self, "SubnetLookupFunction",
                runtime=lambda_.Runtime.PYTHON_3_9,
                handler="index.handler",
                code=lambda_.Code.from_inline("""
import boto3
import cfnresponse

def handler(event, context):
    if event['RequestType'] in ['Create', 'Update']:
        try:
            vpc_id = event['ResourceProperties']['VpcId']
            ec2 = boto3.client('ec2')
            
            # Get all subnets in the VPC
            response = ec2.describe_subnets(
                Filters=[{'Name': 'vpc-id', 'Values': [vpc_id]}]
            )
            
            # Get subnet IDs
            subnet_ids = [subnet['SubnetId'] for subnet in response['Subnets']]
            
            if not subnet_ids:
                cfnresponse.send(event, context, cfnresponse.FAILED, 
                                {'Error': f'No subnets found in VPC {vpc_id}'})
                return
            
            # Take up to 3 subnets for TGW attachment
            selected_subnets = subnet_ids[:3]
            
            cfnresponse.send(event, context, cfnresponse.SUCCESS, 
                            {'SubnetIds': selected_subnets})
        except Exception as e:
            cfnresponse.send(event, context, cfnresponse.FAILED, 
                            {'Error': str(e)})
    else:
        cfnresponse.send(event, context, cfnresponse.SUCCESS, 
                        {'Message': 'No action required for Delete'})
                """),
                initial_policy=[
                    iam.PolicyStatement(
                        actions=["ec2:DescribeSubnets"],
                        resources=["*"]
                    )
                ]
            )
        )
        
        subnet_ids_resource = CustomResource(self, "SubnetIdsResource",
            service_token=subnet_provider.service_token,
            properties={
                "VpcId": vpc_id
            }
        )
        
        # Get subnet IDs from the custom resource
        subnet_ids = subnet_ids_resource.get_att_string("SubnetIds").split(",")
        
        # Create Transit Gateway Attachment
        tgw_attachment = ec2.CfnTransitGatewayAttachment(self, "TransitGatewayAttachment",
            transit_gateway_id=transit_gateway.ref,
            vpc_id=vpc_id,
            subnet_ids=subnet_ids,
            tags=[{"key": "Name", "value": f"{construct_id}-TGW-Attachment"}]
        )
        
        # Create Customer Gateways
        primary_cgw = ec2.CfnCustomerGateway(self, "PrimaryCustomerGateway",
            type="ipsec.1",
            bgp_asn=65000,
            ip_address=primary_cgw_ip,
            tags=[{"key": "Name", "value": f"{construct_id}-Primary-CGW"}]
        )
        
        standby_cgw = ec2.CfnCustomerGateway(self, "StandbyCustomerGateway",
            type="ipsec.1",
            bgp_asn=65000,
            ip_address=standby_cgw_ip,
            tags=[{"key": "Name", "value": f"{construct_id}-Standby-CGW"}]
        )
        
        # Create VPN Connections
        primary_vpn = ec2.CfnVPNConnection(self, "PrimaryVpnConnection",
            type="ipsec.1",
            customer_gateway_id=primary_cgw.ref,
            transit_gateway_id=transit_gateway.ref,
            static_routes_only=True,
            tags=[{"key": "Name", "value": f"{construct_id}-Primary-VPN"}]
        )
        
        standby_vpn = ec2.CfnVPNConnection(self, "StandbyVpnConnection",
            type="ipsec.1",
            customer_gateway_id=standby_cgw.ref,
            transit_gateway_id=transit_gateway.ref,
            static_routes_only=True,
            tags=[{"key": "Name", "value": f"{construct_id}-Standby-VPN"}]
        )
        
        # Create Static Routes for VPN Connections
        primary_vpn_route = ec2.CfnVPNConnectionRoute(self, "PrimaryVpnStaticRoute",
            vpn_connection_id=primary_vpn.ref,
            destination_cidr_block=on_premise_cidr
        )
        
        standby_vpn_route = ec2.CfnVPNConnectionRoute(self, "StandbyVpnStaticRoute",
            vpn_connection_id=standby_vpn.ref,
            destination_cidr_block=on_premise_cidr
        )
        
        # Create SNS Topic for Lambda notifications
        monitoring_topic = sns.Topic(self, "VpnMonitoringTopic",
            display_name="VPN Monitoring Alerts",
            topic_name=f"{construct_id}-vpn-monitoring-alerts"
        )
        
        # Create Lambda Role for VPN Monitoring
        lambda_role = iam.Role(self, "VpnMonitoringLambdaRole",
            assumed_by=iam.ServicePrincipal("lambda.amazonaws.com"),
            managed_policies=[
                iam.ManagedPolicy.from_aws_managed_policy_name("service-role/AWSLambdaBasicExecutionRole")
            ]
        )
        
        # Add permissions to Lambda Role
        lambda_role.add_to_policy(
            iam.PolicyStatement(
                actions=[
                    "ec2:DescribeVpnConnections",
                    "ec2:DescribeTransitGatewayAttachments",
                    "ec2:DescribeTransitGatewayRouteTables",
                    "ec2:SearchTransitGatewayRoutes",
                    "ec2:ReplaceTransitGatewayRoute"
                ],
                resources=["*"]
            )
        )
        
        lambda_role.add_to_policy(
            iam.PolicyStatement(
                actions=["sns:Publish"],
                resources=[monitoring_topic.topic_arn]
            )
        )
        
        # Create Lambda Function for VPN Monitoring
        monitoring_lambda = lambda_.Function(self, "VpnMonitoringLambda",
            function_name=f"{construct_id}-vpn-monitoring",
            runtime=lambda_.Runtime.PYTHON_3_9,
            handler="index.lambda_handler",
            code=lambda_.Code.from_inline("""
import boto3
import json
import logging
import os

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS clients
ec2 = boto3.client('ec2')
sns = boto3.client('sns')

# Get environment variables
PRIMARY_VPN_CONNECTION_ID = os.environ.get('PRIMARY_VPN_CONNECTION_ID')
STANDBY_VPN_CONNECTION_ID = os.environ.get('STANDBY_VPN_CONNECTION_ID')
TRANSIT_GATEWAY_ID = os.environ.get('TRANSIT_GATEWAY_ID')
DESTINATION_CIDR_BLOCK = os.environ.get('DESTINATION_CIDR_BLOCK')
SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')

def lambda_handler(event, context):
    """
    Monitor VPN connections to Transit Gateway and reconfigure routes when primary VPN is down.
    """
    logger.info(f"Received event: {json.dumps(event)}")
    
    try:
        # Check if this is a CloudWatch Event for VPN state change
        if 'detail-type' in event and event['detail-type'] == 'AWS Health Event':
            # Process AWS Health event
            process_health_event(event)
        else:
            # Regular scheduled check
            check_vpn_status()
            
        return {
            'statusCode': 200,
            'body': json.dumps('VPN monitoring completed successfully')
        }
    except Exception as e:
        logger.error(f"Error in lambda_handler: {str(e)}")
        send_notification(f"Error monitoring VPN connections: {str(e)}")
        raise

def process_health_event(event):
    """Process AWS Health events related to VPN connections"""
    if 'detail' in event and 'eventTypeCode' in event['detail']:
        if 'VPN' in event['detail']['eventTypeCode']:
            logger.info(f"Processing VPN health event: {event['detail']['eventTypeCode']}")
            check_vpn_status()

def check_vpn_status():
    """Check the status of primary and standby VPN connections"""
    # Get VPN connection status
    primary_vpn_status = get_vpn_status(PRIMARY_VPN_CONNECTION_ID)
    standby_vpn_status = get_vpn_status(STANDBY_VPN_CONNECTION_ID)
    
    logger.info(f"Primary VPN status: {primary_vpn_status}")
    logger.info(f"Standby VPN status: {standby_vpn_status}")
    
    # Get current route table for the transit gateway
    tgw_route_tables = ec2.describe_transit_gateway_route_tables(
        Filters=[
            {
                'Name': 'transit-gateway-id',
                'Values': [TRANSIT_GATEWAY_ID]
            }
        ]
    )
    
    if not tgw_route_tables['TransitGatewayRouteTables']:
        logger.error(f"No route tables found for Transit Gateway {TRANSIT_GATEWAY_ID}")
        send_notification(f"No route tables found for Transit Gateway {TRANSIT_GATEWAY_ID}")
        return
    
    route_table_id = tgw_route_tables['TransitGatewayRouteTables'][0]['TransitGatewayRouteTableId']
    
    # Check current routes
    current_routes = ec2.search_transit_gateway_routes(
        TransitGatewayRouteTableId=route_table_id,
        Filters=[
            {
                'Name': 'route-search.exact-match',
                'Values': [DESTINATION_CIDR_BLOCK]
            }
        ]
    )
    
    # Determine which attachment is currently active
    current_active_attachment = None
    if 'Routes' in current_routes and current_routes['Routes']:
        for route in current_routes['Routes']:
            if route['State'] == 'active':
                current_active_attachment = route['TransitGatewayAttachments'][0]['TransitGatewayAttachmentId'] if route['TransitGatewayAttachments'] else None
    
    # Get attachment IDs for both VPN connections
    primary_attachment_id = get_tgw_attachment_id(PRIMARY_VPN_CONNECTION_ID)
    standby_attachment_id = get_tgw_attachment_id(STANDBY_VPN_CONNECTION_ID)
    
    # Logic to determine if we need to switch routes
    if primary_vpn_status == 'available' and current_active_attachment != primary_attachment_id:
        # Primary is healthy but not active, switch to primary
        update_route(route_table_id, DESTINATION_CIDR_BLOCK, primary_attachment_id)
        send_notification(f"Switched route for {DESTINATION_CIDR_BLOCK} to primary VPN connection")
    elif primary_vpn_status != 'available' and standby_vpn_status == 'available' and current_active_attachment != standby_attachment_id:
        # Primary is down, standby is healthy, switch to standby
        update_route(route_table_id, DESTINATION_CIDR_BLOCK, standby_attachment_id)
        send_notification(f"Primary VPN connection is down. Switched route for {DESTINATION_CIDR_BLOCK} to standby VPN connection")
    elif primary_vpn_status != 'available' and standby_vpn_status != 'available':
        # Both connections are down
        send_notification(f"CRITICAL: Both primary and standby VPN connections are down. No healthy path available for {DESTINATION_CIDR_BLOCK}")

def get_vpn_status(vpn_connection_id):
    """Get the status of a VPN connection"""
    response = ec2.describe_vpn_connections(
        VpnConnectionIds=[vpn_connection_id]
    )
    
    if not response['VpnConnections']:
        logger.error(f"VPN connection {vpn_connection_id} not found")
        return 'not_found'
    
    # Check tunnel status - both tunnels should be UP for the connection to be considered healthy
    vpn_connection = response['VpnConnections'][0]
    tunnel_statuses = [tunnel['Status'] for tunnel in vpn_connection['VgwTelemetry']]
    
    # If any tunnel is UP, consider the connection available for routing
    if 'UP' in tunnel_statuses:
        return 'available'
    else:
        return 'unavailable'

def get_tgw_attachment_id(vpn_connection_id):
    """Get the Transit Gateway attachment ID for a VPN connection"""
    response = ec2.describe_transit_gateway_attachments(
        Filters=[
            {
                'Name': 'resource-id',
                'Values': [vpn_connection_id]
            },
            {
                'Name': 'transit-gateway-id',
                'Values': [TRANSIT_GATEWAY_ID]
            }
        ]
    )
    
    if not response['TransitGatewayAttachments']:
        logger.error(f"No Transit Gateway attachment found for VPN connection {vpn_connection_id}")
        return None
    
    return response['TransitGatewayAttachments'][0]['TransitGatewayAttachmentId']

def update_route(route_table_id, cidr_block, attachment_id):
    """Update a Transit Gateway route to use the specified attachment"""
    try:
        ec2.replace_transit_gateway_route(
            DestinationCidrBlock=cidr_block,
            TransitGatewayRouteTableId=route_table_id,
            TransitGatewayAttachmentId=attachment_id
        )
        logger.info(f"Updated route for {cidr_block} to use attachment {attachment_id}")
        return True
    except Exception as e:
        logger.error(f"Error updating route: {str(e)}")
        return False

def send_notification(message):
    """Send an SNS notification"""
    if SNS_TOPIC_ARN:
        try:
            sns.publish(
                TopicArn=SNS_TOPIC_ARN,
                Subject="Transit Gateway VPN Monitoring Alert",
                Message=message
            )
            logger.info(f"Notification sent: {message}")
        except Exception as e:
            logger.error(f"Error sending notification: {str(e)}")
            """),
            role=lambda_role,
            timeout=Duration.seconds(60),
            environment={
                "PRIMARY_VPN_CONNECTION_ID": primary_vpn.ref,
                "STANDBY_VPN_CONNECTION_ID": standby_vpn.ref,
                "TRANSIT_GATEWAY_ID": transit_gateway.ref,
                "DESTINATION_CIDR_BLOCK": on_premise_cidr,
                "SNS_TOPIC_ARN": monitoring_topic.topic_arn
            }
        )
        
        # Create CloudWatch Event Rule to trigger Lambda on schedule
        schedule_rule = events.Rule(self, "VpnMonitoringSchedule",
            description="Schedule for VPN monitoring Lambda function",
            schedule=events.Schedule.expression(lambda_schedule),
            targets=[targets.LambdaFunction(monitoring_lambda)]
        )
        
        # Create CloudWatch Event Rule for AWS Health Events
        health_event_rule = events.Rule(self, "VpnHealthEventRule",
            description="Rule to capture AWS Health events for VPN connections",
            event_pattern=events.EventPattern(
                source=["aws.health"],
                detail_type=["AWS Health Event"],
                detail={
                    "service": ["VPN"]
                }
            ),
            targets=[targets.LambdaFunction(monitoring_lambda)]
        )
        
        # Outputs
        CfnOutput(self, "TransitGatewayIdOutput",
            description="Transit Gateway ID",
            value=transit_gateway.ref
        )
        
        CfnOutput(self, "PrimaryVpnConnectionIdOutput",
            description="Primary VPN Connection ID",
            value=primary_vpn.ref
        )
        
        CfnOutput(self, "StandbyVpnConnectionIdOutput",
            description="Standby VPN Connection ID",
            value=standby_vpn.ref
        )
        
        CfnOutput(self, "VpnMonitoringLambdaArnOutput",
            description="ARN of the VPN Monitoring Lambda function",
            value=monitoring_lambda.function_arn
        )
        
        CfnOutput(self, "VpnMonitoringTopicArnOutput",
            description="ARN of the SNS Topic for VPN monitoring alerts",
            value=monitoring_topic.topic_arn
        )
