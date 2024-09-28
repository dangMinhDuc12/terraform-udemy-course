//Define providers and version of the provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

//Define provider and region of the provider
provider "aws" {
  region = "ap-southeast-1"
}

//Create resource vpc and cidr block, as well as name tag for the vpc
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraform Demo VPC"
  }
}

//Create resource subnet and cidr block appropriate for each subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.0/24"
  
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"
  
}

//Create internet gateway and attach to the vpc

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo_vpc.id
  
}

//Create route table and route to the internet gateway
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

//Associate route table to the subnet
resource "aws_route_table_association" "public_subnet" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
  
}