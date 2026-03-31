resource "aws_ecs_task_definition" "medusa_app_task_definition" {
  family                   = "medusa-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.medusa_ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.medusa_ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "medusa-app"
      image     = "${aws_ecr_repository.medusa_app_repository.repository_url}:v3"
      essential = true

      portMappings = [
        {
          containerPort = 9000
          protocol      = "tcp"
        }

      ]

      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = "${aws_secretsmanager_secret.medusa_secrets.arn}:DATABASE_URL::"
        },
        {
          name      = "JWT_SECRET"
          valueFrom = "${aws_secretsmanager_secret.medusa_secrets.arn}:JWT_SECRET::"
        },
        {
          name      = "COOKIE_SECRET"
          valueFrom = "${aws_secretsmanager_secret.medusa_secrets.arn}:COOKIE_SECRET::"
        }

      ]
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "HOST"
          value = "0.0.0.0"
        },
        {
          name  = "PORT"
          value = "9000"
        },
        {
          name  = "STORE_CORS"
          value = ""
        },
        {
          name  = "ADMIN_CORS"
          value = "http://${aws_lb.medusa_alb.dns_name}"
        },
        {
          name  = "AUTH_CORS"
          value = "http://${aws_lb.medusa_alb.dns_name}"
        },
        {
          name  = "MEDUSA_BACKEND_URL"
          value = "http://${aws_lb.medusa_alb.dns_name}"
        },
        {
          name  = "DISABLE_MEDUSA_ADMIN"
          value = "false"
        },
        {
          name  = "MEDUSA_WORKER_MODE"
          value = "server"
        },
        {
          name  = "REDIS_URL"
          value = "redis://${aws_elasticache_replication_group.medusa_redis.primary_endpoint_address}:6379"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.medusa_ecs_app_log_group.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "medusa"
        }
      }
    }
  ])

  tags = {
    Name = "medusa-app-task-definition"
  }
}
