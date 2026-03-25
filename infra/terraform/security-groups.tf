resource "aws_security_group" "medusa_alb_sg" {
  name        = "medusa_alb_sg"
  description = "Security group for Medusa ALB"
  vpc_id      = aws_vpc.medusa_vpc.id

  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "medusa_ecs_task_sg" {
  name        = "medusa_ecs_task_sg"
  description = "Security group for Medusa app container"
  vpc_id      = aws_vpc.medusa_vpc.id

  ingress {
    description     = "Allow inbound traffic from medusa Application"
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = [aws_security_group.medusa_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
