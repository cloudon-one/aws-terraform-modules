output "cluster_endpoints" {
  description = "Endpoints of the EKS clusters"
  value = [for cluster in aws_eks_cluster.this : cluster.endpoint]
}

output "cluster_names" {
  description = "Names of the EKS clusters"
  value = [for cluster in aws_eks_cluster.this : cluster.name]
}

output "node_group_arns" {
  description = "ARNs of the EKS node groups"
  value = [for ng in aws_eks_node_group.this : ng.arn]
}