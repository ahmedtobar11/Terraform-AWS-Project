resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cider

  tags = {
    Name = var.vpc_name
  }

  provisioner "local-exec" {
    command = "echo ID of vpc ${self.id} >> ./vpc_id.txt"
  }
}



