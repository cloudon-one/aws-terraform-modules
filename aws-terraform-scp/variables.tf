variable "policies" {
  description = "Map of SCP policies to deploy. Each policy should contain name, description, content, and target_ids"
  type = map(object({
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