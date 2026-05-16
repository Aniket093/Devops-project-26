#VPC MODULE 
resource "aws_vpc" "main" { # aws_vpc.main.id-- defined in subnets, igw, route-table, 
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true #Allows resources to get DNS names(ip-10-0-1-15.ec2.internal)
  enable_dns_support   = true #services cannot resolve names properly.

  tags = {

    Name = "main-vpc"
  }
}

#SUBNET MODULE
resource "aws_subnet" "public_subnet_1" {
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.availability_zone_1
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

#IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

#ROUTES
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Send all internet traffic to Internet Gateway
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }

}


#ROUTES ASSOSIATION TO SUBNETS ---------Without association: subnets won't use internet gateway
resource "aws_route_table_association" "public_subnet_1_assosiation" {
  subnet_id      = aws_subnet.public_subnet_1.id #subnets must know which routes to use
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_assosiation" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_2.id
}



