#create loggroup for redis logs
resource "aws_cloudwatch_log_group" "redis_log_group" {
  name              = "${local.ClientName}-${var.EnvName}-${local.App}-log-group"
  retention_in_days = 731 #needs to be commented out in initial build because SEA env controls dont allow us to set retention

  tags = {
    Env = var.EnvName
    App = local.App
  }

}

#create elasticaceh subnet group for redis
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${local.ClientName}-${var.EnvName}-${local.App}-subnet-group"
  subnet_ids = [var.redis_subnet_aza, var.redis_subnet_azb]
}

#create redis-cluster service with logging to cloudwatch
resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id       = "${local.ClientName}-${var.EnvName}-${local.App}-cluster"
  description                = "bakery redis cluster"
  engine                     = "redis"
  node_type                  = var.redis_node_type
  port                       = 6379
  parameter_group_name       = var.redis_parameter_group_name
  engine_version             = var.redis_engine_version
  automatic_failover_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids         = [var.redis_security_group]
  multi_az_enabled           = true
  num_node_groups            = var.num_shards
  replicas_per_node_group    = var.num_replicas_per_shard

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis_log_group.name
    #destination = "bakery-uat-redis-log-group"
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  tags = {
    Env  = var.EnvName
    App  = local.App
  }

  depends_on = [aws_elasticache_subnet_group.redis_subnet_group,aws_cloudwatch_log_group.redis_log_group]
}
