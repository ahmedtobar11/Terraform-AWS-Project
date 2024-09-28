resource "aws_lb" "lb" {
  name               = var.lb_name
  internal           = var.lb_state
  load_balancer_type = var.lb_type
  security_groups    = [var.lb-sg]
  subnets            = [var.sub_id_1, var.sub_id_2]

  enable_deletion_protection = false

  tags = {
    Name = var.lb_name
  }
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = var.lb_protocol

  default_action {
    type             = "forward"
    target_group_arn = var.tg_attached_arn
  }
}


#--------------------------------------------------------------
#Create Network Load Balancer

# resource "aws_lb" "my_nlb" {
#   name               = "my-nlb"
#   internal           = false
#   load_balancer_type = "network"
#   security_groups    = [var.alb-sg]
#   subnets            = [var.public_sub_a_id, var.public_sub_b_id]

#   enable_deletion_protection = false
# }

# # Target Group for proxy Instances
# resource "aws_lb_target_group" "nlb_proxy_tg" {
#   name     = "proxy-target-group"
#   port     = 80
#   protocol = "TCP"
#   vpc_id   = var.vpc_id

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold  = 2
#     unhealthy_threshold = 2
#   }
# }

# # Listener that forward traffic to the proxy instances
# resource "aws_lb_listener" "nlb_listener_proxy" {
#   load_balancer_arn = aws_lb.my_nlb.arn
#   port              = 80
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.nlb_proxy_tg.arn
#   }
# }

# # Attach proxy servers to Target Group
# resource "aws_lb_target_group_attachment" "tg_attach_public_ins_a" {
#   target_group_arn = aws_lb_target_group.nlb_proxy_tg.arn
#   target_id        = var.public_instance_a_id
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "tg_attach_public_ins_b" {
#   target_group_arn = aws_lb_target_group.nlb_proxy_tg.arn
#   target_id        = var.public_instance_b_id
#   port             = 80
# }
