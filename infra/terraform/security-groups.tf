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

resource "aws_security_group" "medusa_db_sg" {
  name        = "medusa_db_sg"
  description = "security group for medusa postgresql db"
  vpc_id      = aws_vpc.medusa_vpc.id

  ingress {
    description     = "Allow PostgreSQL from ECS tasks only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.medusa_ecs_task_sg.id]
  }

  tags = {
    Name = "medusa-db-sg"
  }
}

//ElasticCache Security groups
resource "aws_security_group" "medusa_elastic_cache_redis_sg" {
  name        = "medusa_elastic_cache_redis_sg"
  description = "Elastic cache security group for Redis"
  vpc_id      = aws_vpc.medusa_vpc.id

  ingress {
    description     = "Allow Redis access from ECS tasks only"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.medusa_ecs_task_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medusa-elastic-cache-redis-sg"
  }
}
