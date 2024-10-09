terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

resource "aws_eks_cluster" "this" {
  count = length(var.clusters)
  
  name     = var.clusters[count.index].cluster_name
  role_arn = var.clusters[count.index].iam_role_arn
  version  = var.clusters[count.index].version

  vpc_config {
    subnet_ids = var.clusters[count.index].subnet_ids
    endpoint_public_access = var.clusters[count.index].cluster_endpoint_public_access
    security_group_ids = var.clusters[count.index].cluster_additional_security_group_ids
  }

  tags = var.clusters[count.index].tags
}

resource "aws_eks_node_group" "this" {
  count = length(var.clusters)

  cluster_name    = aws_eks_cluster.this[count.index].name
  node_group_name = var.clusters[count.index].eks_managed_node_groups[0].name
  node_role_arn   = var.clusters[count.index].iam_role_arn
  subnet_ids      = var.clusters[count.index].subnet_ids

  scaling_config {
    desired_size = var.clusters[count.index].eks_managed_node_groups[0].desired_size
    max_size     = var.clusters[count.index].eks_managed_node_groups[0].max_size
    min_size     = var.clusters[count.index].eks_managed_node_groups[0].min_size
  }

  instance_types = var.clusters[count.index].eks_managed_node_groups[0].instance_types
  capacity_type  = var.clusters[count.index].eks_managed_node_groups[0].capacity_type
  ami_type       = var.clusters[count.index].eks_managed_node_groups[0].ami_type

  tags = var.clusters[count.index].tags
}

resource "aws_eks_access_entry" "this" {
  for_each = {
    for entry in flatten([
      for cluster_index, cluster in var.clusters : [
        for access_entry in coalesce(cluster.access_entries, []) : {
          cluster_index = cluster_index
          cluster_name  = cluster.cluster_name
          principal     = access_entry.principal
          type          = access_entry.type
          policies      = coalesce(access_entry.access_policies, [])
        }
      ]
    ]) : "${entry.cluster_name}-${entry.principal}" => entry
  }

  cluster_name  = aws_eks_cluster.this[each.value.cluster_index].name
  principal_arn = each.value.principal
  type          = each.value.type
}

resource "aws_eks_access_policy_association" "this" {
  for_each = {
    for entry in flatten([
      for cluster_index, cluster in var.clusters : [
        for access_entry in coalesce(cluster.access_entries, []) : [
          for policy in coalesce(access_entry.access_policies, []) : {
            cluster_index = cluster_index
            cluster_name  = cluster.cluster_name
            principal     = access_entry.principal
            policy        = policy
          }
        ]
      ]
    ]) : "${entry.cluster_name}-${entry.principal}-${entry.policy}" => entry
  }

  cluster_name  = aws_eks_cluster.this[each.value.cluster_index].name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/${each.value.policy}"
  principal_arn = each.value.principal

  access_scope {
    type = "cluster"
  }
}