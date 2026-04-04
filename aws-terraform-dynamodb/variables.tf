variable "dynamodb_tables" {
  description = "Configuration for DynamoDB tables"
  type = list(object({
    name                = string
    billing_mode        = string
    read_capacity       = optional(number)
    write_capacity      = optional(number)
    autoscaling_enabled = optional(bool, false)
    autoscaling_read = optional(object({
      min_capacity = number
      max_capacity = number
    }))
    autoscaling_write = optional(object({
      min_capacity = number
      max_capacity = number
    }))
  }))
}