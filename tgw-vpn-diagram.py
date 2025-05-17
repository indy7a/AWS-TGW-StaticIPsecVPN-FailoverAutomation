from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import TransitGateway, VpnConnection, InternetGateway, PrivateSubnet, RouteTable
from diagrams.aws.compute import Lambda
from diagrams.aws.integration import SNS
from diagrams.aws.management import Cloudwatch
from diagrams.onprem.network import Internet
from diagrams.onprem.compute import Server

with Diagram("Transit Gateway VPN Monitoring Architecture", show=True, direction="LR"):
    # On-premises components
    with Cluster("On-Premises Network (192.168.0.0/16)"):
        on_prem_router = Internet("On-Premises Router")
        with Cluster("On-Premises Resources"):
            servers = [Server("Server 1"),
                      Server("Server 2"),
                      Server("Server 3")]
        
        primary_cgw = InternetGateway("Primary CGW\n203.0.113.1")
        standby_cgw = InternetGateway("Standby CGW\n203.0.113.2")
        
        on_prem_router >> servers
        on_prem_router >> primary_cgw
        on_prem_router >> standby_cgw
    
    # AWS Cloud components
    with Cluster("AWS Cloud"):
        # Transit Gateway and VPN connections
        tgw = TransitGateway("Transit Gateway\ntgw-06cfcd82615995f5f")
        
        primary_vpn = VpnConnection("Primary VPN\nvpn-02ea060346660d981")
        standby_vpn = VpnConnection("Standby VPN\nvpn-0b795c8bfae6d0e9d")
        
        primary_cgw >> primary_vpn
        standby_cgw >> standby_vpn
        
        primary_vpn >> tgw
        standby_vpn >> tgw
        
        # VPC and subnets
        with Cluster("VPC (10.10.0.0/16)"):
            vpc_router = RouteTable("VPC Router")
            
            with Cluster("Private Subnets"):
                subnets = [PrivateSubnet("Subnet 1"),
                          PrivateSubnet("Subnet 2"),
                          PrivateSubnet("Subnet 3")]
            
            vpc_router >> subnets
        
        # Monitoring components
        with Cluster("VPN Monitoring"):
            lambda_fn = Lambda("VPN Monitoring\nLambda Function")
            sns = SNS("Alerts\nSNS Topic")
            cloudwatch = Cloudwatch("CloudWatch\nEvents")
            
            cloudwatch >> lambda_fn
            lambda_fn >> sns
        
        # Connect VPC to Transit Gateway
        tgw >> vpc_router
        
        # Lambda monitors VPN connections
        lambda_fn >> Edge(color="blue", style="dashed", label="monitor") >> primary_vpn
        lambda_fn >> Edge(color="blue", style="dashed", label="monitor") >> standby_vpn
        lambda_fn >> Edge(color="green", style="dashed", label="update routes") >> tgw
