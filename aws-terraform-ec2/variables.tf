variable "instances" {
  description = "List of EC2 instances to create"
  type = list(object({
    name                        = string
    ami                         = string
    availability_zone           = string
    private_ip                  = string
    associate_public_ip_address = optional(bool, false)
    subnet_id                   = string
    instance_type               = string
    ebs_block_device = optional(list(object({
      device_name = string
      volume_size = number
    })), [])
    tags = map(string)
  }))
}

variable "enable_root_block_device_encryption" {
  description = "Whether to encrypt the root block device"
  type        = bool
  default     = true
}

variable "enable_ebs_encryption" {
  description = "Whether to encrypt EBS volumes"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID to use for encryption (leave empty to use AWS managed key)"
  type        = string
  default     = null
}