// VPC 
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = merge(
    { Name = format(local.name, "vpc") }, local.common_tags
  )
}

//Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.AZs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    { Name = format(local.name, "public-subnet-${count.index + 1}") }, local.common_tags
  )
}

// Private Subnets
resource "aws_subnet" "private" {
  count             = length((var.private_subnet_cidrs))
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.AZs[count.index]

  tags = merge(
    { Name = format(local.name, "private-subnet-${count.index + 1}") }, local.common_tags
  )
}

//Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = format(local.name, "igw") }, local.common_tags
  )
}

//Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = merge(
    { Name = format(local.name, "public-rt") }, local.common_tags
  )
}

//Public Route Table Assosiation
resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

// Elastic IP
resource "aws_eip" "lb" {
  domain = "vpc"


}

//NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    {Name = format(local.name, "nat-gw")},local.common_tags
  )
}

//Private Route Table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = merge(
    { Name = format(local.name, "private-rt") }, local.common_tags
  )
}

//Private Route Table Assosiation
resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private-rt.id
}