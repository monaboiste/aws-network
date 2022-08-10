# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({ Name = var.vpc_name }, var.tags)
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = "${var.vpc_name}-igw" }, var.tags)
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
  tags       = merge({ Name = "${var.vpc_name}-eip" }, var.tags)
}

# Public subnets
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr_block)
  cidr_block              = element(var.public_subnets_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags                    = merge({ Name = "${var.vpc_name}-public-subnet-${element(var.availability_zones, count.index)}" }, var.tags)
}

# Private subnets
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr_block)
  cidr_block              = element(var.private_subnets_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags                    = merge({ Name = "${var.vpc_name}-private-subnet-${element(var.availability_zones, count.index)}" }, var.tags)
}

# Private routing tables
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = "${var.vpc_name}-rtb-private" }, var.tags)
}

resource "aws_route_table_association" "private_rtb_association" {
  count          = length(var.private_subnets_cidr_block)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_rtb.id
}

# Public routing tables
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = "${var.vpc_name}-rtb-public" }, var.tags)
}

resource "aws_route_table_association" "public_rtb_association" {
  count          = length(var.public_subnets_cidr_block)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rtb.id
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# Uncomment when resources from private subnets must have an access to the Internet
# NAT for the private subnet
#resource "aws_nat_gateway" "nat_gateway" {
#  allocation_id = aws_eip.nat_eip.id
#  subnet_id     = element(aws_subnet.public_subnets.*.id, 0)
#
#  tags = merge({ Name = "${var.vpc_name}-nat" }, var.tags)
#}
#
#resource "aws_route" "private_nat_gateway" {
#  route_table_id         = aws_route_table.public_rtb.id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
#}

# Default Security Group of VPC
resource "aws_security_group" "default_security_group" {
  name        = "${var.vpc_name}-default-sg"
  description = "Default SG to allow traffic from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc
  ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags = merge({}, var.tags)
}