module "vpc" {
  source = "./modules/vpc"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.id
}

module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.id
  public_sub_a_id = module.subnets.public_sub_a_id
  public_sub_b_id = module.subnets.public_sub_b_id
}

module "nat_gateway" {
  source = "./modules/nat_gateway"
  subnet_id = module.subnets.public_sub_a_id
  vpc_id = module.vpc.id
  depends_on = [ module.internet_gateway ]
  private_sub_a_id = module.subnets.private_sub_a_id
  private_sub_b_id = module.subnets.private_sub_b_id
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.id
}

module "ami" {
  source = "./modules/source_data"
}

module "public_EC2_proxy_a" {
  source = "./modules/public_instance"
  image_id = module.ami.image_id
  sub_id = module.subnets.public_sub_a_id
  instances_sg_id = module.security_groups.instances_sg_id
  alb_dns_name = module.Application_Load_Balancer.dns_name
  instance_name = "proxy_a"
}

module "public_EC2_proxy_b" {
  source = "./modules/public_instance"
  image_id = module.ami.image_id
  sub_id = module.subnets.public_sub_b_id
  instances_sg_id = module.security_groups.instances_sg_id
  alb_dns_name = module.Application_Load_Balancer.dns_name
  instance_name = "proxy_b"
}

module "private_EC2_webserver_a" {
  source = "./modules/private_instance"
  image_id = module.ami.image_id
  sub_id = module.subnets.private_sub_a_id
  instances_sg_id = module.security_groups.instances_sg_id
  instance_name = "webserver_a"
  bastion_host_public_ip = module.public_EC2_proxy_a.public_ip
}

module "private_EC2_webserver_b" {
  source = "./modules/private_instance"
  image_id = module.ami.image_id
  sub_id = module.subnets.private_sub_b_id
  instances_sg_id = module.security_groups.instances_sg_id
  instance_name = "webserver_b"
  bastion_host_public_ip = module.public_EC2_proxy_a.public_ip
}

module "alb_target_group" {
  source = "./modules/target_groups"
  tg_name = "alb-tg"
  tg_protocol = "HTTP"
  vpc_id = module.vpc.id
  attached_instance_1 = module.private_EC2_webserver_a.instance_id
  attached_instance_2 = module.private_EC2_webserver_b.instance_id
  }

module "Application_Load_Balancer" {
  source = "./modules/load_balancers"
  lb_name = "my-alb"
  lb_type = "application"
  lb_protocol = "HTTP"
  lb_state = true         #internal
  lb-sg = module.security_groups.nlb_sg_id
  sub_id_1 = module.subnets.private_sub_a_id
  sub_id_2 = module.subnets.private_sub_b_id
  tg_attached_arn = module.alb_target_group.tg_arn
}

module "nlb_target_group" {
  source = "./modules/target_groups"
  tg_name = "nlb-tg"
  tg_protocol = "TCP"
  vpc_id = module.vpc.id
  attached_instance_1 = module.public_EC2_proxy_a.instance_id
  attached_instance_2 = module.public_EC2_proxy_b.instance_id
}

module "Network_Load_Balancer" {
  source = "./modules/load_balancers"
  lb_name = "my-nlb"
  lb_type = "network"
  lb_protocol = "TCP"
  lb_state = false  #internet
  lb-sg = module.security_groups.nlb_sg_id
  sub_id_1 = module.subnets.public_sub_a_id
  sub_id_2 = module.subnets.public_sub_b_id
  tg_attached_arn = module.nlb_target_group.tg_arn
}
