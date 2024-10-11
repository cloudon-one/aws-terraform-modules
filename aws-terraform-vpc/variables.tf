variable "vpcs" {
  description = "List of VPC configurations"
  type = list(object({
    vpc_name           = string
    vpc_cidr           = string
    private_subnets    = list(string)
    public_subnets     = list(string)
    azs                = list(string)
    enable_nat_gateway = bool
    tags               = map(string)
  }))
}