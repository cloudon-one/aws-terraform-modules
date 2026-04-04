output "tunnel1_preshared_key" {
  description = "The preshared key of the first VPN tunnel"
  value       = module.vpn-gateway.tunnel1_preshared_key
  sensitive   = true
}

output "tunnel2_preshared_key" {
  description = "The preshared key of the second VPN tunnel"
  value       = module.vpn-gateway.tunnel2_preshared_key
  sensitive   = true
}

output "vpn_connection_customer_gateway_configuration" {
  description = "The configuration information for the VPN connection's customer gateway"
  value       = module.vpn-gateway.vpn_connection_customer_gateway_configuration
  sensitive   = true
}

output "vpn_connection_id" {
  description = "The ID of the VPN connection"
  value       = module.vpn-gateway.vpn_connection_id
}

output "vpn_connection_transit_gateway_attachment_id" {
  description = "The ID of the transit gateway attachment for the VPN connection"
  value       = module.vpn-gateway.vpn_connection_transit_gateway_attachment_id
}

output "vpn_connection_tunnel1_address" {
  description = "The public IP address of the first VPN tunnel"
  value       = module.vpn-gateway.vpn_connection_tunnel1_address
}

output "vpn_connection_tunnel1_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (customer gateway side)"
  value       = module.vpn-gateway.vpn_connection_tunnel1_cgw_inside_address
}

output "vpn_connection_tunnel1_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (VPN gateway side)"
  value       = module.vpn-gateway.vpn_connection_tunnel1_vgw_inside_address
}

output "vpn_connection_tunnel2_address" {
  description = "The public IP address of the second VPN tunnel"
  value       = module.vpn-gateway.vpn_connection_tunnel2_address
}

output "vpn_connection_tunnel2_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (customer gateway side)"
  value       = module.vpn-gateway.vpn_connection_tunnel2_cgw_inside_address
}

output "vpn_connection_tunnel2_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (VPN gateway side)"
  value       = module.vpn-gateway.vpn_connection_tunnel2_vgw_inside_address
}
