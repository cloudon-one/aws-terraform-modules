# AWS VPC Terraform Module

This Terraform module creates a Virtual Private Cloud (VPC) in AWS using the `terraform-aws-modules/vpc/aws` module. It provides a flexible and customizable way to set up your VPC with various subnet types and NAT gateway options.

## Features

- Create a VPC with customizable CIDR block
- Create multiple subnet types: private, public, intra, database, and elasticache
- Optional NAT gateway for internet access from private subnets
- Customizable subnet names
- Flexible tagging options

## Usage

```hcl
module "vpc" {
  source  = "path/to/this/module"

  vpc_name = "my-vpc"
  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-west-2a", "us-west-2b", "us-west-2c"]

  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  intra_subnets    = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  elasticache_subnets = ["10.0.31.0/24", "10.0.32.0/24", "10.0.33.0/24"]

  enable_nat_gateway = true

  private_subnet_names     = ["Private Subnet 1", "Private Subnet 2", "Private Subnet 3"]
  public_subnet_names      = ["Public Subnet 1", "Public Subnet 2", "Public Subnet 3"]
  intra_subnet_names       = ["Intra Subnet 1", "Intra Subnet 2", "Intra Subnet 3"]
  database_subnet_names    = ["DB Subnet 1", "DB Subnet 2", "DB Subnet 3"]
  elasticache_subnet_names = ["Cache Subnet 1", "Cache Subnet 2", "Cache Subnet 3"]

  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_name | Name of the VPC | `string` | n/a | yes |
| vpc_cidr | CIDR block for the VPC | `string` | n/a | yes |
| azs | List of Availability Zones | `list(string)` | n/a | yes |
| private_subnets | List of private subnet CIDR blocks | `list(string)` | n/a | yes |
| public_subnets | List of public subnet CIDR blocks | `list(string)` | n/a | yes |
| intra_subnets | List of intra subnet CIDR blocks | `list(string)` | `[]` | no |
| database_subnets | List of database subnet CIDR blocks | `list(string)` | `[]` | no |
| elasticache_subnets | List of elasticache subnet CIDR blocks | `list(string)` | `[]` | no |
| enable_nat_gateway | Enable NAT gateway for private subnets | `bool` | `false` | no |
| private_subnet_names | List of names for private subnets | `list(string)` | `[]` | no |
| public_subnet_names | List of names for public subnets | `list(string)` | `[]` | no |
| intra_subnet_names | List of names for intra subnets | `list(string)` | `[]` | no |
| database_subnet_names | List of names for database subnets | `list(string)` | `[]` | no |
| elasticache_subnet_names | List of names for elasticache subnets | `list(string)` | `[]` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_arn | ARN of the VPC |
| private_subnets | List of IDs of private subnets |
| public_subnets | List of IDs of public subnets |
| intra_subnets | List of IDs of intra subnets |
| database_subnets | List of IDs of database subnets |
| elasticache_subnets | List of IDs of elasticache subnets |
| elasticache_subnet_group_name | Name of the elasticache subnet group |
| nat_gateway_ids | List of NAT Gateway IDs |
| redis_sg_id | ID of the Redis ingress security group |

## Notes

1. This module uses the `terraform-aws-modules/vpc/aws` module version 5.15.0. Make sure this version is compatible with your Terraform version.
2. The number of subnets created will match the number of Availability Zones specified, for each subnet type.
3. If `enable_nat_gateway` is set to `true`, a NAT gateway will be created in each public subnet for use by private subnets.
4. Intra subnets are private subnets with no internet routing.

## Limitations

1. This module doesn't support all possible configurations of the underlying VPC module. For advanced use cases, you may need to use the `terraform-aws-modules/vpc/aws` module directly.
2. The module doesn't create any VPC endpoints. If you need VPC endpoints, you'll need to add them separately or extend this module.
3. Custom route tables and network ACLs are not supported in this version of the module.

## License

This module is open-source software licensed under the [MIT license](https://opensource.org/licenses/MIT).