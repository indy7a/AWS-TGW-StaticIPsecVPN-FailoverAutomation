#!/usr/bin/env python3
import os
from aws_cdk import App

from tgw_vpn_stack import TransitGatewayVpnStack

app = App()

TransitGatewayVpnStack(app, "TgwVpnMonitoring",
    vpc_id=app.node.try_get_context("vpc_id"),
    primary_cgw_ip=app.node.try_get_context("primary_cgw_ip"),
    standby_cgw_ip=app.node.try_get_context("standby_cgw_ip"),
    on_premise_cidr=app.node.try_get_context("on_premise_cidr") or "192.168.0.0/16",
    lambda_schedule=app.node.try_get_context("lambda_schedule") or "rate(5 minutes)"
)

app.synth()
