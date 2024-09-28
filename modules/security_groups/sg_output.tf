output "instances_sg_id" {
    value = aws_security_group.instances_sg.id
}

output "nlb_sg_id" {
  value = aws_security_group.nlb_sg.id
}

