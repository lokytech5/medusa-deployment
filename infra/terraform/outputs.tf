output "medusa_ecr_repository_url" {
  value = aws_ecr_repository.medusa_app_repository.repository_url
}

output "medusa_ecs_task_execution_role_arn" {
  value = aws_iam_role.medusa_ecs_task_execution_role.arn
}

output "medusa_alb_dns_name" {
  value = aws_lb.medusa_alb.dns_name
}

output "medusa_ecs_service_name" {
  value = aws_ecs_service.medusa_app_service.name
}
