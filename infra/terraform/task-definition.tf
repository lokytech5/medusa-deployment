resource "aws_ecs_task_definition" "medusa_app_task_definition" {
  family                   = "medusa-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.medusa_ecs_task_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "medusa-app"
      image     = "${aws_ecr_repository.medusa_app_repository.repository_url}:v2"
      essential = true

      portMappings = [
        {
          containerPort = 9000
          protocol      = "tcp"
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
