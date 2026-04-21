locals {
  medusa_alarm_prefix = "medusa"
}

resource "aws_sns_topic" "medusa_alerts" {
  name = "${local.medusa_alarm_prefix}-alerts"

  tags = {
    Name = "${local.medusa_alarm_prefix}-alerts"
  }
}

# Replace the email below with your real email before apply
resource "aws_sns_topic_subscription" "medusa_alert_email" {
  topic_arn = aws_sns_topic.medusa_alerts.arn
  protocol  = "email"
  endpoint  = "rukydiakodue@gmail.com"
}

#
# ECS alarms
#

resource "aws_cloudwatch_metric_alarm" "medusa_ecs_cpu_high" {
  alarm_name          = "${local.medusa_alarm_prefix}-ecs-cpu-high"
  alarm_description   = "High ECS CPU utilization for Medusa service"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 80
  period              = 300
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.medusa_app_ecs_cluster.name
    ServiceName = aws_ecs_service.medusa_app_service.name
  }

  alarm_actions = [aws_sns_topic.medusa_alerts.arn]
  ok_actions    = [aws_sns_topic.medusa_alerts.arn]

  tags = {
    Name = "${local.medusa_alarm_prefix}-ecs-cpu-high"
  }
}

resource "aws_cloudwatch_metric_alarm" "medusa_ecs_memory_high" {
  alarm_name          = "${local.medusa_alarm_prefix}-ecs-memory-high"
  alarm_description   = "High ECS memory utilization for Medusa service"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 80
  period              = 300
  namespace           = "AWS/ECS"
  metric_name         = "MemoryUtilization"
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.medusa_app_ecs_cluster.name
    ServiceName = aws_ecs_service.medusa_app_service.name
  }

  alarm_actions = [aws_sns_topic.medusa_alerts.arn]
  ok_actions    = [aws_sns_topic.medusa_alerts.arn]

  tags = {
    Name = "${local.medusa_alarm_prefix}-ecs-memory-high"
  }
}

#
# ALB alarms
#

resource "aws_cloudwatch_metric_alarm" "medusa_alb_unhealthy_targets" {
  alarm_name          = "${local.medusa_alarm_prefix}-alb-unhealthy-targets"
  alarm_description   = "ALB target group has unhealthy Medusa targets"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 0
  period              = 60
  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Minimum"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.medusa_alb.arn_suffix
    TargetGroup  = aws_lb_target_group.medusa_app_target_group.arn_suffix
  }

  alarm_actions = [aws_sns_topic.medusa_alerts.arn]
  ok_actions    = [aws_sns_topic.medusa_alerts.arn]

  tags = {
    Name = "${local.medusa_alarm_prefix}-alb-unhealthy-targets"
  }
}

resource "aws_cloudwatch_metric_alarm" "medusa_alb_target_5xx" {
  alarm_name          = "${local.medusa_alarm_prefix}-alb-target-5xx"
  alarm_description   = "ALB target group is returning 5XX responses"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 5
  period              = 300
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.medusa_alb.arn_suffix
    TargetGroup  = aws_lb_target_group.medusa_app_target_group.arn_suffix
  }

  alarm_actions = [aws_sns_topic.medusa_alerts.arn]
  ok_actions    = [aws_sns_topic.medusa_alerts.arn]

  tags = {
    Name = "${local.medusa_alarm_prefix}-alb-target-5xx"
  }
}

#
# RDS alarms
#

resource "aws_cloudwatch_metric_alarm" "medusa_rds_cpu_high" {
  alarm_name          = "${local.medusa_alarm_prefix}-rds-cpu-high"
  alarm_description   = "High CPU utilization on Medusa PostgreSQL RDS instance"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 80
  period              = 300
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.medusa_postgres_db.id
  }

  alarm_actions = [aws_sns_topic.medusa_alerts.arn]
  ok_actions    = [aws_sns_topic.medusa_alerts.arn]

  tags = {
    Name = "${local.medusa_alarm_prefix}-rds-cpu-high"
  }
}

resource "aws_cloudwatch_metric_alarm" "medusa_rds_free_storage_low" {
  alarm_name          = "${local.medusa_alarm_prefix}-rds-free-storage-low"
  alarm_description   = "Low free storage on Medusa PostgreSQL RDS instance"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 10737418240
  period              = 300
  namespace           = "AWS/RDS"
  metric_name         = "FreeStorageSpace"
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.medusa_postgres_db.id
  }

  alarm_actions = [aws_sns_topic.medusa_alerts.arn]
  ok_actions    = [aws_sns_topic.medusa_alerts.arn]

  tags = {
    Name = "${local.medusa_alarm_prefix}-rds-free-storage-low"
  }
}

#
# Redis / ElastiCache alarms
#

resource "aws_cloudwatch_metric_alarm" "medusa_redis_engine_cpu_high" {
  alarm_name          = "${local.medusa_alarm_prefix}-redis-engine-cpu-high"
  alarm_description   = "High Redis engine CPU on Medusa ElastiCache primary"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 75
  period              = 300
  namespace           = "AWS/ElastiCache"
  metric_name         = "EngineCPUUtilization"
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.medusa_redis.replication_group_id
    Role               = "Primary"
  }

  alarm_actions = [aws_sns_topic.medusa_alerts.arn]
  ok_actions    = [aws_sns_topic.medusa_alerts.arn]

  tags = {
    Name = "${local.medusa_alarm_prefix}-redis-engine-cpu-high"
  }
}

resource "aws_cloudwatch_metric_alarm" "medusa_redis_memory_high" {
  alarm_name          = "${local.medusa_alarm_prefix}-redis-memory-high"
  alarm_description   = "High Redis memory usage on Medusa ElastiCache replication group"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 80
  period              = 300
  namespace           = "AWS/ElastiCache"
  metric_name         = "DatabaseMemoryUsageCountedForEvictPercentage"
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.medusa_redis.replication_group_id
  }

  alarm_actions = [aws_sns_topic.medusa_alerts.arn]
  ok_actions    = [aws_sns_topic.medusa_alerts.arn]

  tags = {
    Name = "${local.medusa_alarm_prefix}-redis-memory-high"
  }
}

#
# CloudWatch dashboard
#

resource "aws_cloudwatch_dashboard" "medusa_operations" {
  dashboard_name = "medusa-operations"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title   = "ECS Service - CPU and Memory"
          region  = "us-east-1"
          view    = "timeSeries"
          stacked = false
          stat    = "Average"
          period  = 300
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              aws_ecs_cluster.medusa_app_ecs_cluster.name,
              "ServiceName",
              aws_ecs_service.medusa_app_service.name,
              { label = "ECS CPU %" }
            ],
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              aws_ecs_cluster.medusa_app_ecs_cluster.name,
              "ServiceName",
              aws_ecs_service.medusa_app_service.name,
              { label = "ECS Memory %" }
            ]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title   = "ALB - Target Health and 5XX"
          region  = "us-east-1"
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            [
              "AWS/ApplicationELB",
              "UnHealthyHostCount",
              "LoadBalancer",
              aws_lb.medusa_alb.arn_suffix,
              "TargetGroup",
              aws_lb_target_group.medusa_app_target_group.arn_suffix,
              { label = "Unhealthy Targets", stat = "Minimum" }
            ],
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_5XX_Count",
              "LoadBalancer",
              aws_lb.medusa_alb.arn_suffix,
              "TargetGroup",
              aws_lb_target_group.medusa_app_target_group.arn_suffix,
              { label = "Target 5XX", stat = "Sum" }
            ]
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title   = "RDS - CPU and Connections"
          region  = "us-east-1"
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              aws_db_instance.medusa_postgres_db.id,
              { label = "RDS CPU %", stat = "Average" }
            ],
            [
              "AWS/RDS",
              "DatabaseConnections",
              "DBInstanceIdentifier",
              aws_db_instance.medusa_postgres_db.id,
              { label = "DB Connections", stat = "Average", yAxis = "right" }
            ]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title   = "RDS - Free Storage"
          region  = "us-east-1"
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            [
              "AWS/RDS",
              "FreeStorageSpace",
              "DBInstanceIdentifier",
              aws_db_instance.medusa_postgres_db.id,
              { label = "Free Storage (bytes)", stat = "Average" }
            ]
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          title   = "Redis - Engine CPU"
          region  = "us-east-1"
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            [
              "AWS/ElastiCache",
              "EngineCPUUtilization",
              "ReplicationGroupId",
              aws_elasticache_replication_group.medusa_redis.replication_group_id,
              "Role",
              "Primary",
              { label = "Redis Engine CPU %", stat = "Average" }
            ]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6

        properties = {
          title   = "Redis - Memory Pressure"
          region  = "us-east-1"
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            [
              "AWS/ElastiCache",
              "DatabaseMemoryUsageCountedForEvictPercentage",
              "ReplicationGroupId",
              aws_elasticache_replication_group.medusa_redis.replication_group_id,
              { label = "Redis Memory %", stat = "Average" }
            ]
          ]
        }
      }
    ]
  })
}
