resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnets" {
  count  = local.len_azs
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name    = "public-${substr(var.azs[count.index], -1, -1)}"
    Public  = true
    Private = false
  }
}

resource "aws_subnet" "private_subnets" {
  count             = local.len_azs
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    {
      Name    = "private-${substr(var.azs[count.index], -1, -1)}"
      Public  = false
      Private = true
    },
    var.azs[count.index] == "us-east-1e" ? {} : {
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
  count          = local.len_azs
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_eip" "natgw-eip" {
  count = local.len_azs
  tags = {
    Name = "${var.vpc_name}-eip-${substr(var.azs[count.index], -1, -1)}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count  = local.len_azs
  allocation_id = aws_eip.natgw-eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags = {
    Name = "${var.vpc_name}-natgw-${substr(var.azs[count.index], -1, -1)}"
  }
}

resource "aws_route_table" "natgw_route_table" {
  count  = local.len_azs
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }
  tags = {
    Name = "${var.vpc_name}-rt-natgw-private-${substr(var.azs[count.index], -1, -1)}"
  }
}

resource "aws_route_table_association" "natgw_private_association" {
  count          = local.len_azs
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.natgw_route_table[count.index].id
}
