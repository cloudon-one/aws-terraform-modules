output "vpcs" {
  description = "Map of VPC details"
  value = { for k, v in aws_vpc.this : k => {
    id         = v.id
    cidr_block = v.cidr_block
    private_subnet_ids = [for s in aws_subnet.private : s.id if split("-", s.tags.Name)[0] == k]
    public_subnet_ids  = [for s in aws_subnet.public : s.id if split("-", s.tags.Name)[0] == k]
    nat_gateway_id     = try(aws_nat_gateway.this[k].id, null)
    internet_gateway_id = aws_internet_gateway.this[k].id
    public_route_table_id  = aws_route_table.public[k].id
    private_route_table_id = aws_route_table.private[k].id
  } }
}