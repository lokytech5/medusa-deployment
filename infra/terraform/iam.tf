resource "aws_iam_role" "medusa_ecs_task_execution_role" {
  name = "medusa-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "medusa-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "medusa_ecs_task_execution_role_policy" {
  role       = aws_iam_role.medusa_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

//iam policy to allow ECS task execution role to read secrets from Secrets Manager
resource "aws_iam_policy" "medusa_ecs_secrets_policy" {
  name        = "medusa-ecs-secrets-policy"
  description = "Allow ECS task execution role to read Medusa secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.medusa_secrets.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "medusa_ecs_secrets_policy_attachment" {
  role       = aws_iam_role.medusa_ecs_task_execution_role.name
  policy_arn = aws_iam_policy.medusa_ecs_secrets_policy.arn
}

//IAM role for ECS TASK
resource "aws_iam_role" "medusa_ecs_task_role" {
  name = "medusa-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "medusa-ecs-task-role"
  }
}

//IAM policy to allow access to ECS EXE to containers
resource "aws_iam_policy" "medusa_ecs_exec_policy" {
  name        = "medusa-ecs-exec-policy"
  description = "Allow ECS Exec access to Medusa containers"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "medusa_ecs_exec_policy_attachment" {
  role       = aws_iam_role.medusa_ecs_task_role.name
  policy_arn = aws_iam_policy.medusa_ecs_exec_policy.arn
}
