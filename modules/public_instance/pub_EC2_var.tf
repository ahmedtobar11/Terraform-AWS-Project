variable "sub_id" {
  description = "Subnet ID to launch public_instance_a in"
}

variable "instances_sg_id" {
}

variable "instance_type" {
  default = "t2.micro"
}

variable "alb_dns_name" {
}

variable "instance_name" {
}

variable "image_id" {
}

variable "path_to_key_pair" {
  default = "/home/ahmed/tobar.pem"
}