output "accepter_accept_status" {
  description = "The status of the VPC peering connection on the accepter side"
  value       = module.vpc-peering-multi-account.accepter_accept_status
}

output "accepter_connection_id" {
  description = "The VPC peering connection ID on the accepter side"
  value       = module.vpc-peering-multi-account.accepter_connection_id
}

output "accepter_subnet_route_table_map" {
  description = "Map of accepter subnet route table associations"
  value       = module.vpc-peering-multi-account.nameaccepter_subnet_route_table_map
}

output "requester_accept_status" {
  description = "The status of the VPC peering connection on the requester side"
  value       = module.vpc-peering-multi-account.requester_accept_status
}

output "requester_connection_id" {
  description = "The VPC peering connection ID on the requester side"
  value       = module.vpc-peering-multi-account.requester_connection_id
}
