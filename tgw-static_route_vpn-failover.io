<mxfile host="app.diagrams.net" modified="2023-05-17T07:00:00.000Z" agent="5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" etag="abc123" version="14.7.7" type="device">
  <diagram id="tgw-vpn-failover" name="Transit Gateway VPN Failover">
    <mxGraphModel dx="1422" dy="798" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1100" pageHeight="850" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- On-premises Network -->
        <mxCell id="2" value="On-Premises Network (192.168.0.0/16)" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_corporate_data_center;strokeColor=#5A6C86;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#5A6C86;dashed=0;" vertex="1" parent="1">
          <mxGeometry x="40" y="120" width="320" height="280" as="geometry" />
        </mxCell>
        <!-- On-premises Router -->
        <mxCell id="3" value="On-Premises Router" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.router;fillColor=#F58534;gradientColor=none;" vertex="1" parent="2">
          <mxGeometry x="140" y="70" width="69" height="72" as="geometry" />
        </mxCell>
        <!-- Server 1 -->
        <mxCell id="4" value="Server 1" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.generic_database;fillColor=#7D7C7C;gradientColor=none;" vertex="1" parent="2">
          <mxGeometry x="60" y="190" width="46.5" height="61" as="geometry" />
        </mxCell>
        <!-- Server 2 -->
        <mxCell id="5" value="Server 2" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.generic_database;fillColor=#7D7C7C;gradientColor=none;" vertex="1" parent="2">
          <mxGeometry x="150" y="190" width="46.5" height="61" as="geometry" />
        </mxCell>
        <!-- Server 3 -->
        <mxCell id="6" value="Server 3" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.generic_database;fillColor=#7D7C7C;gradientColor=none;" vertex="1" parent="2">
          <mxGeometry x="240" y="190" width="46.5" height="61" as="geometry" />
        </mxCell>
        <!-- Primary CGW -->
        <mxCell id="7" value="Primary CGW&#xa;203.0.113.1" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.customer_gateway;fillColor=#F58534;gradientColor=none;" vertex="1" parent="1">
          <mxGeometry x="240" y="40" width="69" height="72" as="geometry" />
        </mxCell>
        <!-- Standby CGW -->
        <mxCell id="8" value="Standby CGW&#xa;203.0.113.2" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.customer_gateway;fillColor=#F58534;gradientColor=none;" vertex="1" parent="1">
          <mxGeometry x="90" y="40" width="69" height="72" as="geometry" />
        </mxCell>
        <!-- AWS Cloud -->
        <mxCell id="9" value="AWS Cloud" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_aws_cloud_alt;strokeColor=#232F3E;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#232F3E;dashed=0;" vertex="1" parent="1">
          <mxGeometry x="400" y="40" width="640" height="440" as="geometry" />
        </mxCell>
        <!-- Transit Gateway -->
        <mxCell id="10" value="Transit Gateway" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.transit_gateway;fillColor=#F58534;gradientColor=none;" vertex="1" parent="9">
          <mxGeometry x="160" y="160" width="69" height="72" as="geometry" />
        </mxCell>
        <!-- Primary VPN Connection -->
        <mxCell id="11" value="Primary VPN" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.vpn_connection;fillColor=#F58534;gradientColor=none;" vertex="1" parent="9">
          <mxGeometry x="60" y="80" width="58.5" height="48" as="geometry" />
        </mxCell>
        <!-- Standby VPN Connection -->
        <mxCell id="12" value="Standby VPN" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.vpn_connection;fillColor=#F58534;gradientColor=none;" vertex="1" parent="9">
          <mxGeometry x="60" y="240" width="58.5" height="48" as="geometry" />
        </mxCell>
        <!-- VPC -->
        <mxCell id="13" value="VPC (10.10.0.0/16)" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_vpc;strokeColor=#248814;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#AAB7B8;dashed=0;" vertex="1" parent="9">
          <mxGeometry x="280" y="40" width="320" height="280" as="geometry" />
        </mxCell>
        <!-- VPC Router -->
        <mxCell id="14" value="VPC Router" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.route_table;fillColor=#F58536;gradientColor=none;" vertex="1" parent="13">
          <mxGeometry x="140" y="70" width="75" height="69" as="geometry" />
        </mxCell>
        <!-- Subnet 1 -->
        <mxCell id="15" value="Subnet 1" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.permissions;fillColor=#759C3E;gradientColor=none;" vertex="1" parent="13">
          <mxGeometry x="60" y="190" width="46.5" height="61" as="geometry" />
        </mxCell>
        <!-- Subnet 2 -->
        <mxCell id="16" value="Subnet 2" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.permissions;fillColor=#759C3E;gradientColor=none;" vertex="1" parent="13">
          <mxGeometry x="150" y="190" width="46.5" height="61" as="geometry" />
        </mxCell>
        <!-- Subnet 3 -->
        <mxCell id="17" value="Subnet 3" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.permissions;fillColor=#759C3E;gradientColor=none;" vertex="1" parent="13">
          <mxGeometry x="240" y="190" width="46.5" height="61" as="geometry" />
        </mxCell>
        <!-- VPN Monitoring -->
        <mxCell id="18" value="VPN Monitoring" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_aws_cloud_alt;strokeColor=#232F3E;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#232F3E;dashed=1;" vertex="1" parent="9">
          <mxGeometry x="40" y="340" width="560" height="80" as="geometry" />
        </mxCell>
        <!-- Lambda Function -->
        <mxCell id="19" value="VPN Monitoring&#xa;Lambda Function" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.lambda_function;fillColor=#F58534;gradientColor=none;" vertex="1" parent="18">
          <mxGeometry x="240" y="30" width="69" height="72" as="geometry" />
        </mxCell>
        <!-- CloudWatch Events -->
        <mxCell id="20" value="CloudWatch&#xa;Events" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.cloudwatch;fillColor=#759C3E;gradientColor=none;" vertex="1" parent="18">
          <mxGeometry x="120" y="30" width="69" height="72" as="geometry" />
        </mxCell>
        <!-- SNS Topic -->
        <mxCell id="21" value="Alerts&#xa;SNS Topic" style="outlineConnect=0;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws3.sns;fillColor=#D9A741;gradientColor=none;" vertex="1" parent="18">
          <mxGeometry x="360" y="30" width="69" height="72" as="geometry" />
        </mxCell>
        <!-- Connections -->
        <!-- Router to Servers -->
        <mxCell id="22" value="" style="endArrow=classic;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="3" target="4">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="23" value="" style="endArrow=classic;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="3" target="5">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="24" value="" style="endArrow=classic;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="3" target="6">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <!-- Router to CGWs -->
        <mxCell id="25" value="" style="endArrow=classic;html=1;exitX=0.5;exitY=0;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="3" target="7">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="26" value="" style="endArrow=classic;html=1;exitX=0.5;exitY=0;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="3" target="8">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <!-- CGWs to VPN Connections -->
        <mxCell id="27" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="7" target="11">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="28" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="8" target="12">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <!-- VPN Connections to Transit Gateway -->
        <mxCell id="29" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.25;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="11" target="10">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="30" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.75;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="12" target="10">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <!-- Transit Gateway to VPC Router -->
        <mxCell id="31" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="10" target="14">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <!-- VPC Router to Subnets -->
        <mxCell id="32" value="" style="endArrow=classic;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="14" target="15">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="33" value="" style="endArrow=classic;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="14" target="16">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="34" value="" style="endArrow=classic;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="14" target="17">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <!-- CloudWatch to Lambda -->
        <mxCell id="35" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="20" target="19">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <!-- Lambda to SNS -->
        <mxCell id="36" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="19" target="21">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <!-- Lambda monitors VPN connections -->
        <mxCell id="37" value="" style="endArrow=classic;html=1;exitX=0.25;exitY=0;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;entryPerimeter=0;dashed=1;strokeColor=#0000FF;labelBackgroundColor=#FFFFFF;" edge="1" parent="1" source="19" target="11">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="38" value="monitor" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];labelBackgroundColor=#FFFFFF;" vertex="1" connectable="0" parent="37">
          <mxGeometry x="-0.3" y="1" relative="1" as="geometry">
            <mxPoint as="offset" />
          </mxGeometry>
        </mxCell>
        <mxCell id="39" value="" style="endArrow=classic;html=1;exitX=0.25;exitY=0;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;entryPerimeter=0;dashed=1;strokeColor=#0000FF;" edge="1" parent="1" source="19" target="12">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="40" value="monitor" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];labelBackgroundColor=#FFFFFF;" vertex="1" connectable="0" parent="39">
          <mxGeometry x="-0.3" y="1" relative="1" as="geometry">
            <mxPoint as="offset" />
          </mxGeometry>
        </mxCell>
        <!-- Lambda updates routes -->
        <mxCell id="41" value="" style="endArrow=classic;html=1;exitX=0.5;exitY=0;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;entryPerimeter=0;dashed=1;strokeColor=#00CC00;" edge="1" parent="1" source="19" target="10">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="520" y="410" as="sourcePoint" />
            <mxPoint x="570" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="42" value="update routes" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];labelBackgroundColor=#FFFFFF;" vertex="1" connectable="0" parent="41">
          <mxGeometry x="-0.3" y="1" relative="1" as="geometry">
            <mxPoint as="offset" />
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
