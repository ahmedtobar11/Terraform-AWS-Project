resource "aws_lb_target_group" "tg" {
  name     = var.tg_name
  port     = 80
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "tg_attach_instance_1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id       = var.attached_instance_1
  port            = 80
}

resource "aws_lb_target_group_attachment" "tg_attach_instance_2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id       = var.attached_instance_2
  port            = 80
}
