resource "aws_cloudwatch_log_group" "medusa_ecs_app_log_group" {
  name              = "/ecs/medusa-app"
  retention_in_days = 7
}
