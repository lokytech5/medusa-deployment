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
