variable "subnet_id" {
  description = "The Subnet ID of the subnet in which to place the NAT Gateway"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to create Routing Table in."
  type        = string
}

variable "ngw_name" {
  default = "nat_gw"
}

variable "ngw_rt_name" {
  default = "private_rt"
}

variable "private_sub_a_id" {
  description = "The ID of the private_subnet_a to associate it in private routing table"
  type        = string
}

variable "private_sub_b_id" {
  description = "The ID of the private_subnet_b to associate it in private routing table"
  type        = string
}