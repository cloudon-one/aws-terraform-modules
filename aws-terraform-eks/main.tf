resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.iam_role_arn
  version  = var.eks_version

  vpc_config {
    subnet_ids                        = var.subnet_ids
    endpoint_public_access            = var.cluster_endpoint_public_access
    security_group_ids                = var.cluster_additional_security_group_ids
  }

  tags = var.tags
}

resource "aws_eks_node_group" "this" {
  count           = length(var.eks_managed_node_groups)
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.eks_managed_node_groups[count.index].name
  node_role_arn   = var.iam_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.eks_managed_node_groups[count.index].desired_size
    max_size     = var.eks_managed_node_groups[count.index].max_size
    min_size     = var.eks_managed_node_groups[count.index].min_size
  }

  instance_types = var.eks_managed_node_groups[count.index].instance_types
  ami_type       = var.eks_managed_node_groups[count.index].ami_type
  capacity_type  = var.eks_managed_node_groups[count.index].capacity_type

  tags = merge(var.tags, var.eks_managed_node_groups[count.index].tags)
}

resource "aws_eks_access_entry" "this" {
  count            = length(var.eks_managed_node_groups[0].access_entries)
  cluster_name     = aws_eks_cluster.this.name
  principal_arn    = var.eks_managed_node_groups[0].access_entries[count.index].principal
  type             = var.eks_managed_node_groups[0].access_entries[count.index].type
  kubernetes_groups = var.eks_managed_node_groups[0].access_entries[count.index].kubernetes_groups

  dynamic "access_policy" {
    for_each = var.eks_managed_node_groups[0].access_entries[count.index].access_policies
    content {
      policy_arn = "arn:aws:eks::aws:policy/${access_policy.value}"
    }
  }
}