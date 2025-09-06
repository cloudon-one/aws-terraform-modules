variable "policies" {
  description = "List of SCP policies to deploy. Each policy should contain name, description, content path, and target_ids"
  type = list(object({
    name        = string
    description = string
    content     = string
    target_ids  = list(string)
  }))
}

variable "tags" {
  description = "Tags to apply to the SCPs"
  type        = map(string)
  default     = {}
}