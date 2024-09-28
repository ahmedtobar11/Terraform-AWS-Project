output "vpc_id" {
  value = module.vpc.id
}

output "network_lb_dns_name" {
  value = module.Network_Load_Balancer.dns_name
}