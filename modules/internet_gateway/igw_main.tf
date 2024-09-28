#create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.igw_name
  }
}

#create routing table for internet gateway
resource "aws_route_table" "igw_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.igw_rt_name
  }
}

# Associate the Route Table with public_sub_a
resource "aws_route_table_association" "public_a" {
  subnet_id      = var.public_sub_a_id
  route_table_id = aws_route_table.igw_rt.id
}

# Associate the Route Table with public_sub_a
resource "aws_route_table_association" "public_b" {
  subnet_id      = var.public_sub_b_id
  route_table_id = aws_route_table.igw_rt.id
}