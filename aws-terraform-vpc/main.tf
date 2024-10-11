locals {
  vpcs = { for v in var.vpcs : v.vpc_name => v }
}

resource "aws_vpc" "this" {
  for_each = local.vpcs

  cidr_block           = each.value.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    each.value.tags,
    {
      Name = each.value.vpc_name
    }
  )
}

resource "aws_subnet" "private" {
  for_each = { for i in flatten([
    for vpc_key, vpc in local.vpcs : [
      for idx, cidr in vpc.private_subnets : {
        vpc_key = vpc_key
        idx     = idx
        cidr    = cidr
        az      = vpc.azs[idx]
      }
    ]
  ]) : "${i.vpc_key}-private-${i.idx}" => i }

  vpc_id            = aws_vpc.this[each.value.vpc_key].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    local.vpcs[each.value.vpc_key].tags,
    {
      Name = "${each.value.vpc_key}-private-${each.value.az}"
    }
  )
}

resource "aws_subnet" "public" {
  for_each = { for i in flatten([
    for vpc_key, vpc in local.vpcs : [
      for idx, cidr in vpc.public_subnets : {
        vpc_key = vpc_key
        idx     = idx
        cidr    = cidr
        az      = vpc.azs[idx]
      }
    ]
  ]) : "${i.vpc_key}-public-${i.idx}" => i }

  vpc_id            = aws_vpc.this[each.value.vpc_key].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    local.vpcs[each.value.vpc_key].tags,
    {
      Name = "${each.value.vpc_key}-public-${each.value.az}"
    }
  )
}

resource "aws_internet_gateway" "this" {
  for_each = local.vpcs

  vpc_id = aws_vpc.this[each.key].id

  tags = merge(
    each.value.tags,
    {
      Name = "igw-${each.value.vpc_name}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  for_each = { for k, v in local.vpcs : k => v if v.enable_nat_gateway }

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public["${each.key}-public-0"].id

  tags = merge(
    each.value.tags,
    {
      Name = "nat-${each.value.vpc_name}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_eip" "nat" {
  for_each = { for k, v in local.vpcs : k => v if v.enable_nat_gateway }
  domain   = "vpc"

  tags = merge(
    each.value.tags,
    {
      Name = "eip-${each.value.vpc_name}-nat"
    }
  )
}

resource "aws_route_table" "public" {
  for_each = local.vpcs

  vpc_id = aws_vpc.this[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[each.key].id
  }

  tags = merge(
    each.value.tags,
    {
      Name = "rt-${each.value.vpc_name}-public"
    }
  )
}

resource "aws_route_table" "private" {
  for_each = local.vpcs

  vpc_id = aws_vpc.this[each.key].id

  dynamic "route" {
    for_each = each.value.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[each.key].id
    }
  }

  tags = merge(
    each.value.tags,
    {
      Name = "rt-${each.value.vpc_name}-private"
    }
  )
}

resource "aws_route_table_association" "private" {
  for_each = { for i in flatten([
    for vpc_key, vpc in local.vpcs : [
      for idx, _ in vpc.private_subnets : {
        vpc_key  = vpc_key
        subnet_id = aws_subnet.private["${vpc_key}-private-${idx}"].id
      }
    ]
  ]) : "${i.vpc_key}-private-${i.subnet_id}" => i }

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.private[each.value.vpc_key].id
}

resource "aws_route_table_association" "public" {
  for_each = { for i in flatten([
    for vpc_key, vpc in local.vpcs : [
      for idx, _ in vpc.public_subnets : {
        vpc_key  = vpc_key
        subnet_id = aws_subnet.public["${vpc_key}-public-${idx}"].id
      }
    ]
  ]) : "${i.vpc_key}-public-${i.subnet_id}" => i }

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.public[each.value.vpc_key].id
}