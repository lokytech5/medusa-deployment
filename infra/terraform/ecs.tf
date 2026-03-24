resource "aws_ecs_cluster" "medusa_app_ecs_cluster" {
  name = "medusa-app-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "medusa-app-ecs-cluster"
  }
}
