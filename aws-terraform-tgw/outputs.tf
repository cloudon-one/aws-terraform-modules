output "transit_gateway_id" {
  description = "ID of the created Transit Gateway"
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_attachment_id" {
  description = "ID of the Transit Gateway VPC attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}
