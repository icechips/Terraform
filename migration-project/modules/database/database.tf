#db subnet group for aurora mysql database
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "${local.ClientName}-${var.EnvName}-${local.App}-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${local.ClientName}-${var.EnvName}-${local.App}",
    Env  = var.EnvName,
    App  = local.App
  }
}

#aurora database creation
resource "aws_rds_cluster_instance" "adobe_commerce_database" {
  count                = var.instance_count
  identifier           = "${local.ClientName}-${var.EnvName}-${local.App}-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.adobe_commerce_database_cluster.id
  instance_class       = var.db_instance_class
  engine               = aws_rds_cluster.adobe_commerce_database_cluster.engine
  engine_version       = aws_rds_cluster.adobe_commerce_database_cluster.engine_version
  db_subnet_group_name = aws_rds_cluster.adobe_commerce_database_cluster.db_subnet_group_name
  apply_immediately    = aws_rds_cluster.adobe_commerce_database_cluster.apply_immediately
}

#aurora cluster creation
resource "aws_rds_cluster" "adobe_commerce_database_cluster" {
  cluster_identifier          = "${local.ClientName}-${var.EnvName}-${local.App}-cluster"
  engine                      = "aurora-mysql"
  engine_version              = var.engine_version
  availability_zones          = var.availability_zones
  database_name               = var.database_name
  master_username             = var.master_username
  manage_master_user_password = true
  backup_retention_period     = var.backup_retention_period_days
  preferred_backup_window     = var.preferred_backup_window_utc
  storage_encrypted           = true
  apply_immediately           = var.apply_modifications_immediately
  db_subnet_group_name        = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids      = var.db_security_group_ids


  enabled_cloudwatch_logs_exports = [
    "error",
    "audit",
    "general",
    "slowquery"
  ]

  tags = {
    Name = "${local.ClientName}-${var.EnvName}-${local.App}",
    Env  = var.EnvName,
    App  = local.App
  }
}