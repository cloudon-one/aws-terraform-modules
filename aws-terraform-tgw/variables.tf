variable "name" {
  description = "Name of the Transit Gateway"
  type        = string
}

variable "description" {
  description = "Description of the Transit Gateway"
  type        = string
}

variable "vpc_attachments" {
  description = "List of VPC attachments"
  type = list(object({
    vpc_id     = string
    subnet_ids = list(string)
    tgw_routes = list(object({
      destination_cidr_block = string
    }))
  }))
}