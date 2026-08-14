#public vpc
resource "aws_vpc" "vpc-1" {

  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC-1"
  }
}

resource "aws_subnet" "subnet-1" {

  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.vpc-1.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "Public_subnet"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "IGW-1"
  }
}

resource "aws_route_table" "rt-1" {

  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "public-RT"
  }

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "asa" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt-1.id
}

#private subnet section

resource "aws_subnet" "subnet-2" {
  vpc_id                  = aws_vpc.vpc-1.id
  availability_zone       = "ap-south-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet"
  }

}

resource "aws_route_table" "rt-2" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "Private-RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

}

resource "aws_route_table_association" "rta-2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt-2.id

}

resource "aws_nat_gateway" "nat" {

  subnet_id = aws_subnet.subnet-2.id
  allocation_id = aws_eip.eip.id
  tags = {
    Name = "NAT-Gateway"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}
