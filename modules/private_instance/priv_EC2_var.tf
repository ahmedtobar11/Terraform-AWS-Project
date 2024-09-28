variable "sub_id" {
  description = "Subnet ID to launch public_instance_a in"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "path_to_key_pair" {
  default = "/home/ahmed/tobar.pem"
}

variable "instances_sg_id" {
}

variable "instance_name" {
}

variable "image_id" {
}

variable "bastion_host_public_ip" {
}
