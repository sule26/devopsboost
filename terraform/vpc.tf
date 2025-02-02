resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnets" {
  for_each                = local.azs_map
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidr[each.key]
  availability_zone       = each.value
  map_public_ip_on_launch = true
  tags = {
    Name    = "public-${substr(data.aws_availability_zones.available.names[each.key], -1, -1)}"
    Public  = true
    Private = false
  }
}

resource "aws_subnet" "private_subnets" {
  for_each          = local.azs_map
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr[each.key]
  availability_zone = each.value
  tags = merge(
    {
      Name    = "private-${substr(data.aws_availability_zones.available.names[each.key], -1, -1)}"
      Public  = false
      Private = true
    },
    each.value == "us-east-1e" ? {} : {
      "karpenter.sh/discovery" = var.cluster_name
    }
  )
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.vpc_name}-rt-public"
  }
}

resource "aws_route_table_association" "igw_public_association" {
  for_each       = local.azs_map
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_eip" "ngw-eip" {
  for_each = local.azs_map
  tags = {
    Name = "${var.vpc_name}-eip-${substr(data.aws_availability_zones.available.names[each.key], -1, -1)}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each      = local.azs_map
  allocation_id = aws_eip.ngw-eip[each.key].id
  subnet_id     = aws_subnet.public_subnets[each.key].id
  tags = {
    Name = "${var.vpc_name}-natgw-${substr(data.aws_availability_zones.available.names[each.key], -1, -1)}"
  }
}

resource "aws_route_table" "ngw_route_table" {
  for_each = local.azs_map
  vpc_id   = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[each.key].id
  }
  tags = {
    Name = "${var.vpc_name}-rt-natgw-private-${substr(data.aws_availability_zones.available.names[each.key], -1, -1)}"
  }
}

resource "aws_route_table_association" "ngw_private_association" {
  for_each       = local.azs_map
  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.ngw_route_table[each.key].id
}
