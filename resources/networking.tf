//create locals variable to only use this var in this file
locals {
  common_tags = {
    ManagedBy = "Terraform"
    Project   = "resources"
  }
}



//Create vpc

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(local.common_tags, {
    Name = "resources-vpc"
  })
}

// Create public subnet in above vpc
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = merge(local.common_tags, {
    Name = "resources-public-subnet"
  })
}

//Create internet gateway for public subnet can connect to internet and internet can call to public subnet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "resources-iw"
  })
}

//Create route table to attach with iw
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "resources-rt-public"
  })
}

//Connect route table with subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}