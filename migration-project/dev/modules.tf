### building of modules called form here ###

###keypair build
#commented out due to moduel renaming messing up state
/*module "Keypair" {
  source = "../modules/ec2-keypair/"

  EnvName   = local.Env  
}*/

###Redis Build
module "Redis" {
  source = "../modules/redis/"

  EnvName                      = local.Env
  redis_subnet_aza             = local.data_dev_aza_subnet_id
  redis_node_type              = "cache.t4g.medium"
  num_cache_nodes              = 1
  redis_parameter_group_name   = "default.redis7"
  redis_engine_version         = "7.0"
  redis_security_group         = local.data_dev_sg
}

###Bastion Build
module "Bastion" {
  source = "../modules/bastion/"

  EnvName              = local.Env
  ami                  = local.rhel_ami
  instance_type        = "t3.small"
  bastion_subnet       = local.app_dev_aza_subnet_id
  bastion_sg_ids       = [local.mgmt_dev_sg]
  #bastion_key_name     = module.Keypair.bastion_key_name
  bastion_key_name     = "bakery-dev-ansible-bastion-Private-Key" #should be a variable but module renaming messed up state, dosent support import
  user_keys            = local.user_keys
}

###Web Build
module "Web" {
  source = "../modules/web/"

  EnvName            = local.Env
  server_count       = "1"
  ami                = local.rhel_ami
  instance_type      = "t3.medium"
  web_subnet_a       = local.app_dev_aza_subnet_id
  web_subnet_b       = local.app_dev_azb_subnet_id
  web_sg_ids         = [local.mgmt_dev_sg,local.app_dev_sg]
  #web_key_name      = module.Keypair.web_key_name
  web_key_name       = "bakery-dev-web-Private-Key" #should be a variable but module renaming messed up state, dosent support import
  user_keys          = local.user_keys
  root_volume_size   = "50"
}

###Database build
module "Database" {
  source = "../modules/database/"

  EnvName                           = local.Env
  database_subnet_ids               = [local.data_dev_aza_subnet_id,local.data_dev_azb_subnet_id]
  instance_count                    = 1
  db_instance_class                 = "db.t4g.medium"
  engine_version                    = "5.7.mysql_aurora.2.11.2"
  availability_zones                = ["ca-central-1a","ca-central-1b","ca-central-1d"]
  database_name                     = "recipe_book"
  master_username                   = "bakery_admin"
  backup_retention_period_days      = 3
  preferred_backup_window_utc       = "10:00-12:00"
  apply_modifications_immediately   = true
  db_security_group_ids             = [local.mgmt_dev_sg,local.data_dev_sg]
}

###Opensearch Build
module "Opensearch" {
  source = "../modules/opensearch/"

  EnvName                         = local.Env
  opensearch_engine_version       = "OpenSearch_1.2"
  opensearch_instance_type        = "t3.small.search"
  master_instance_type            = "t3.small.search" #needed regardless of master_enabled value
  opensearch_instance_count       = 1
  multi_az                        = false
  master_enabled                  = false
  opensearch_log_type             = "INDEX_SLOW_LOGS"
  opensearch_volume_size          = 50
  opensearch_subnet_ids           = [local.app_dev_aza_subnet_id]
  opensearch_security_group_ids   = [local.mgmt_dev_sg,local.app_dev_sg]
  #opensearch_policy_source_ip     = [local.bakery_dev_vpc_cidr]
}

###Codepipeline Build
module "Codepipeline" {
  source = "../modules/aws-codepipeline/"

  EnvName               = local.Env
  branch_name           = "dev"
  connection_arn        = "arn:aws:codestar-connections:ca-central-1:660491123327:connection/e2358a31-202d-4b85-9c7d"
  full_repository_id    = "Icechips/bakery"
  AccountNumber         = "660491123327"
}

###ALB Build
module "ALB" {
  source = "../modules/load-balancer/"

  EnvName               = local.Env
  alb_security_groups   = [local.app_dev_sg,local.web_dev_sg,"sg-0f6b68c05f860ddbb"]
  subnet_ids            = [local.app_dev_aza_subnet_id,local.app_dev_azb_subnet_id]
  access_logs_bucket    = "pbmmaccel-logarchive-phase0-aescacentral1" #bakery controlled value which cannot be seen until after resource creation
  access_logs_prefix    = "660491123327/elb-bakery-dev-alb" #bakery controlled value which cannot be seen until after resource creation
  vpc_id                = local.bakery_dev_vpc_id
  instance_ids          = module.Web.web_server_ids
  certificate_arn       = "arn:aws:acm:ca-central-1:660491123327:certificate/28397758-0568-43ef-97a1"
  bakery_traffic_port_1    = "9010"
  bakery_traffic_port_2    = "9011"
}

###Lifecycle-Manager Build
module "Lifecycle-Manager" {
  source = "../modules/lifecycle-manager/"

  EnvName               = local.Env
  AccountNumber         = "660491123327"
  snapshot_retention    = 5
}