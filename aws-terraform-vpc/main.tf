locals {
  vpc_subnets = flatten([
    for vpc_key, vpc in var.vpcs : [
      for subnet_type in ["private", "public"] :
      [
        for idx, cidr in vpc["${subnet_type}_subnets"] : {
          vpc_key     = vpc_key
          subnet_type = subnet_type
          cidr        = cidr
          az          = vpc.azs[idx % length(vpc.azs)]
          index       = idx
        }
      ]
    ]
  ])
}

resource "aws_vpc" "this" {
  for_each = { for vpc in var.vpcs : vpc.vpc_name => vpc }

  cidr_block           = each.value.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    each.value.tags,
    {
      Name = each.key
    }
  )
}

resource "aws_subnet" "this" {
  for_each = { for subnet in local.vpc_subnets : "${subnet.vpc_key}-${subnet.subnet_type}-${subnet.index}" => subnet }

  vpc_id            = aws_vpc.this[each.value.vpc_key].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    var.vpcs[index(var.vpcs.*.vpc_name, each.value.vpc_key)].tags,
    {
      Name = "${each.value.vpc_key}-${each.value.subnet_type}-${each.value.az}"
    }
  )
}

resource "aws_internet_gateway" "this" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  tags = merge(
    var.vpcs[index(var.vpcs.*.vpc_name, each.key)].tags,
    {
      Name = "igw-${each.key}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  for_each = { for vpc in var.vpcs : vpc.vpc_name => vpc if vpc.enable_nat_gateway }

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = [for s in aws_subnet.this : s.id if s.tags["Name"] == "${each.key}-public-${each.value.azs[0]}"][0]

  tags = merge(
    each.value.tags,
    {
      Name = "nat-${each.key}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_eip" "nat" {
  for_each = { for vpc in var.vpcs : vpc.vpc_name => vpc if vpc.enable_nat_gateway }
  domain   = "vpc"

  tags = merge(
    each.value.tags,
    {
      Name = "eip-${each.key}-nat"
    }
  )
}

resource "aws_route_table" "public" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[each.key].id
  }

  tags = merge(
    var.vpcs[index(var.vpcs.*.vpc_name, each.key)].tags,
    {
      Name = "rt-${each.key}-public"
    }
  )
}

resource "aws_route_table" "private" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  dynamic "route" {
    for_each = var.vpcs[index(var.vpcs.*.vpc_name, each.key)].enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[each.key].id
    }
  }

  tags = merge(
    var.vpcs[index(var.vpcs.*.vpc_name, each.key)].tags,
    {
      Name = "rt-${each.key}-private"
    }
  )
}

resource "aws_route_table_association" "private" {
  for_each = { for subnet in local.vpc_subnets : "${subnet.vpc_key}-${subnet.subnet_type}-${subnet.index}" => subnet if subnet.subnet_type == "private" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private[each.value.vpc_key].id
}

resource "aws_route_table_association" "public" {
  for_each = { for subnet in local.vpc_subnets : "${subnet.vpc_key}-${subnet.subnet_type}-${subnet.index}" => subnet if subnet.subnet_type == "public" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public[each.value.vpc_key].id
}