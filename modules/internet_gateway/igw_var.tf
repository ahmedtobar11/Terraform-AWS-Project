variable "vpc_id" {
  description = "The ID of the VPC to create the subnets in."
  type        = string
}

variable "igw_name" {
  default = "internet_gw"
}

variable "igw_rt_name" {
  default = "public_rt"
}

variable "public_sub_a_id" {
  description = "The ID of the public_subnet_a to associate it in public routing table"
  type        = string
}

variable "public_sub_b_id" {
  description = "The ID of the public_subnet_b to associate it in public routing table"
  type        = string
}