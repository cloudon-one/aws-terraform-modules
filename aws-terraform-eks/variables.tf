variable "region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "clusters" {
  description = "List of EKS cluster configurations"
  type = list(object({
    cluster_name = string
    version = string
    vpc_id = string
    subnet_ids = list(string)
    iam_role_arn = string
    node_security_group_name = string
    cluster_additional_security_group_ids = list(string)
    cluster_endpoint_public_access = bool
    eks_managed_node_groups = list(object({
      name = string
      instance_types = list(string)
      min_size = number
      max_size = number
      desired_size = number
      ami_type = string
      capacity_type = string
    }))
    access_entries = optional(list(object({
      principal = string
      type = string
      access_policies = optional(list(string))
      kubernetes_groups = optional(list(string))
      access = optional(string)
    })))
    tags = map(string)
  }))
}

