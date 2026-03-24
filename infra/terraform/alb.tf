resource "aws_lb" "medusa_alb" {
  name                       = "medusa-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.medusa_alb_sg.id]
  subnets                    = [aws_subnet.medusa_public_subnet_a.id, aws_subnet.medusa_public_subnet_b.id]
  enable_deletion_protection = false

  tags = {
    Name = "medusa-alb"
  }
}


resource "aws_lb_target_group" "medusa_app_target_group" {
  name        = "medusa-app-target-group"
  port        = 9000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.medusa_vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "medusa-app-target-group"
  }
}

resource "aws_lb_listener" "medusa_alb_listener" {
  load_balancer_arn = aws_lb.medusa_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.medusa_app_target_group.arn
  }
}
