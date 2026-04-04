variable "name_prefix" {
  description = "Prefix to be added to each bucket name"
  type        = string
  default     = ""
}

variable "kms_key_id" {
  description = "KMS key ID to use for server-side encryption. If null, AES256 encryption is used."
  type        = string
  default     = null
}

variable "buckets" {
  description = "List of bucket configurations"
  type = list(object({
    bucket_name = string
    tags = object({
      Environment = string
      Owner       = string
      Description = string
      Terraform   = string
      Name        = string
    })
  }))
}

