#create public subnet in AZ (us-east-1a) 
resource "aws_subnet" "public_subnet_a" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnets_cider["sub1"]
  availability_zone = var.az[0]
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnets_name["sub1"]
  }
}

#create public subnet in AZ (us-east-1b) 
resource "aws_subnet" "public_subnet_b" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnets_cider["sub2"]
  availability_zone = var.az[1]
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnets_name["sub2"]
  }
}

#create private subnet in AZ (us-east-1a) 
resource "aws_subnet" "private_subnet_a" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnets_cider["sub3"]
  availability_zone = var.az[0]
  tags = {
    Name = var.subnets_name["sub3"]
  }
}

#create private subnet in AZ (us-east-1b) 
resource "aws_subnet" "private_subnet_b" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnets_cider["sub4"]
  availability_zone = var.az[1]
  tags = {
    Name = var.subnets_name["sub4"]
  }
}

