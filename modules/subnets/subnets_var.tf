variable "subnets_name" {
    type = map
    default = {
        "sub1" = "public_subnet_a",
        "sub2" = "public_subnet_b",
        "sub3" = "private_subnet_a",
        "sub4" = "private_subnet_b"
    }
}

variable "subnets_cider" {
    type = map
    default = {
        "sub1" = "10.0.1.0/24",
        "sub2" = "10.0.2.0/24",
        "sub3" = "10.0.3.0/24",
        "sub4" = "10.0.4.0/24"
    }
}

variable "az" {
  type = list
  default = ["us-east-1a","us-east-1b"]
}

variable "vpc_id" {
  description = "The ID of the VPC to create the subnets in."
  type        = string
}