#!/usr/bin/env python3
"""
This script synthesizes the CloudFormation template from the CDK app
without requiring the CDK CLI to be installed.
"""

import os
import json
from aws_cdk import App
from tgw_vpn_stack import TransitGatewayVpnStack

# Load context from cdk.json
with open('cdk.json', 'r') as f:
    cdk_json = json.load(f)
    context = cdk_json.get('context', {})

# Create the app and stack
app = App()
stack = TransitGatewayVpnStack(app, "TgwVpnMonitoring",
    vpc_id=context.get("vpc_id", ""),
    primary_cgw_ip=context.get("primary_cgw_ip", ""),
    standby_cgw_ip=context.get("standby_cgw_ip", ""),
    on_premise_cidr=context.get("on_premise_cidr", "192.168.0.0/16"),
    lambda_schedule=context.get("lambda_schedule", "rate(5 minutes)")
)

# Synthesize the CloudFormation template
cloud_assembly = app.synth()
template_path = os.path.join(cloud_assembly.directory, "TgwVpnMonitoring.template.json")

# Copy the template to the current directory
import shutil
shutil.copy(template_path, "TgwVpnMonitoring.template.json")

print(f"CloudFormation template synthesized to: TgwVpnMonitoring.template.json")
