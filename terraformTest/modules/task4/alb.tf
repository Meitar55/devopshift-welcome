resource "aws_lb" "meitar-alb"{
  name               = "meitar-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.meitar_alb_sg.id]
  subnets           = var.subnet_id

  enable_deletion_protection = false

  tags = {
    Name = "meitar-ALB"
  }
}

resource "aws_lb_target_group" "meitar-target-group" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.meitar-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.meitar-target-group.arn
  }
}
