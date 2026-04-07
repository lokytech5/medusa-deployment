resource "aws_elasticache_subnet_group" "medusa_elastic_cache_subnet_group" {
  name        = "medusa-elastic-cache-subnet-group"
  description = "Subnet group for Medusa ElasticCache Redis cluster"
  subnet_ids = [
    module.networking.private_subnet_a_id,
    module.networking.private_subnet_b_id
  ]
}

resource "aws_elasticache_replication_group" "medusa_redis" {
  replication_group_id = "medusa-redis"
  description          = "Redis for Medusa application"

  engine         = "redis"
  engine_version = "7.0"
  node_type      = "cache.t4g.micro"
  port           = 6379

  parameter_group_name = "default.redis7"

  subnet_group_name  = aws_elasticache_subnet_group.medusa_elastic_cache_subnet_group.name
  security_group_ids = [aws_security_group.medusa_elastic_cache_redis_sg.id]

  automatic_failover_enabled = false
  multi_az_enabled           = false
  num_cache_clusters         = 1

  at_rest_encryption_enabled = false
  transit_encryption_enabled = false

  tags = {
    Name = "medusa-redis"
  }
}




