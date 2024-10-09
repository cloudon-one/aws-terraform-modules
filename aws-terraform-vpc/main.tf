module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  intra_subnets   = var.intra_subnets
  database_subnets = var.database_subnets
  elasticache_subnets = var.elasticache_subnets

  enable_nat_gateway = var.enable_nat_gateway

  private_subnet_names = var.private_subnet_names
  public_subnet_names  = var.public_subnet_names
  intra_subnet_names   = var.intra_subnet_names
  database_subnet_names = var.database_subnet_names
  elasticache_subnet_names = var.elasticache_subnet_names

  tags = var.tags
}