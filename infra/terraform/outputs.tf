output "medusa_ecr_repository_url" {
  value = data.aws_ecr_repository.medusa_app_repository.repository_url
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

output "medusa_postgres_endpoint" {
  value = aws_db_instance.medusa_postgres_db.address
}

output "medusa_postgres_port" {
  value = aws_db_instance.medusa_postgres_db.port
}

output "medusa_redis_primary_endpoint" {
  value = aws_elasticache_replication_group.medusa_redis.primary_endpoint_address
}
