resource "aws_ec2_transit_gateway" "this" {
  description = var.description
  tags = {
    Name = var.name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = var.vpc_attachments[0].subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_attachments[0].vpc_id
  tags = {
    Name = "${var.name}-attachment"
  }
}

resource "aws_ec2_transit_gateway_route" "this" {
  count                          = length(var.vpc_attachments[0].tgw_routes)
  destination_cidr_block         = var.vpc_attachments[0].tgw_routes[count.index].destination_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.this.association_default_route_table_id
}