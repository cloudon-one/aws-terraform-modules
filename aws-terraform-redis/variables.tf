variable "cluster_id" {
  description = "The ID of the ElastiCache cluster"
  type        = string
}

variable "description" {
  description = "Description of the ElastiCache cluster"
  type        = string
  default     = "Managed by Terraform"
}

variable "engine_version" {
  description = "Version number of the Redis engine (format: <major>.<minor> for Redis v6 or higher)"
  type        = string
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the cluster"
  type        = list(string)
}

variable "subnet_group_name" {
  description = "Name of the subnet group to be used for the cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to create the subnet group"
  type        = list(string)
}

variable "num_cache_nodes" {
  description = "The number of cache nodes in the cluster"
  type        = number
  default     = 1
}

variable "parameter_group_name" {
  description = "The name of the parameter group to associate with this cache cluster"
  type        = string
  default     = "default.redis7"
}

variable "port" {
  description = "The port number on which the cache accepts connections"
  type        = number
  default     = 6379
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
