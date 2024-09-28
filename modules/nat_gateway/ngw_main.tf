#create elastic ip
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat_eip"
  }
}

#create nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet_id

  tags = {
    Name = var.ngw_name
  }
}

#create routing table for internet gateway
resource "aws_route_table" "nat_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = var.ngw_rt_name
  }
}

# Associate the Route Table with private_sub_a
resource "aws_route_table_association" "private_a" {
  subnet_id      = var.private_sub_a_id
  route_table_id = aws_route_table.nat_rt.id
}

# Associate the Route Table with public_sub_a
resource "aws_route_table_association" "public_b" {
  subnet_id      = var.private_sub_b_id
  route_table_id = aws_route_table.nat_rt.id
}

