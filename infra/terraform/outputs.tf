output "medusa_ecr_repository_url" {
  value = aws_ecr_repository.medusa_app_repository.repository_url
}

output "medusa_ecs_task_execution_role_arn" {
  value = aws_iam_role.medusa_ecs_task_execution_role.arn
}
