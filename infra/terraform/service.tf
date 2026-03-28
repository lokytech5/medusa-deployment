resource "aws_ecs_service" "medusa_app_service" {
  name                              = "medusa-app-service"
  cluster                           = aws_ecs_cluster.medusa_app_ecs_cluster.id
  task_definition                   = aws_ecs_task_definition.medusa_app_task_definition.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  platform_version                  = "LATEST"
  health_check_grace_period_seconds = 180

  network_configuration {
    subnets = [
      aws_subnet.medusa_private_subnet_a.id,
      aws_subnet.medusa_private_subnet_b.id
    ]

    security_groups  = [aws_security_group.medusa_ecs_task_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.medusa_app_target_group.arn
    container_name   = "medusa-app"
    container_port   = 9000
  }

  depends_on = [
    aws_lb_listener.medusa_alb_listener
  ]

  tags = {
    Name = "medusa-app-service"
  }
}
