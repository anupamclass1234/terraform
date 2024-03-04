terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.13.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Change this to your desired region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Replace with your desired CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}
  resource "aws_vpc" "my_vpc1" {
  cidr_block = "10.1.0.0/16"  # Replace with your desired CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC1"
}
  }
resource "aws_subnet" "my_subnet" {
  count = 1

  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.${count.index}.0/24"  # Adjust CIDR blocks for each subnet

  availability_zone = "ap-south-1a"  # Replace with desired availability zone

  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet-${count.index}"
  }
}

resource "aws_subnet" "my_subnet_1" {
  count = 1

  vpc_id     = aws_vpc.my_vpc1.id
  cidr_block = "10.1.${count.index}.0/24"  # Adjust CIDR blocks for each subnet

  availability_zone = "ap-south-1b"  # Replace with desired availability zone

  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet1-${count.index}"
  }
}
resource "aws_instance" "my_instances" {
  count = 1

  ami           = "ami-03bb6d83c60fc5f7c"  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type
  subnet_id     = aws_subnet.my_subnet[count.index].id

  tags = {
    Name = "MyInstance-${count.index}"
  }
}
resource "aws_instance" "my_instances_1" {
  count = 1

  ami           = "ami-03bb6d83c60fc5f7c"  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type
  subnet_id     = aws_subnet.my_subnet_1[count.index].id

  tags = {
    Name = "MyInstance-1${count.index}"
  }
}
resource "aws_vpc_peering_connection" "mypeering" {
  #peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.my_vpc.id
  vpc_id        = aws_vpc.my_vpc1.id
}
