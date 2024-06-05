### building of modules called form here ###

###keypair build
module "Keypair" {
  source = "../modules/ec2-keypair/"

  EnvName   = local.Env  
}

###Bastion Build
module "Bastion" {
  source = "../modules/bastion/"

  EnvName              = local.Env
  ami                  = local.rhel_ami
  instance_type        = "t3.small"
  bastion_subnet       = local.app_prod_aza_subnet_id
  bastion_sg_ids       = [local.mgmt_prod_sg]
  bastion_key_name     = module.Keypair.bastion_key_name
  user_keys            = local.user_keys
}

###Web Build
module "Web" {
  source = "../modules/web/"

  EnvName         = local.Env
  server_count    = "2"
  ami             = local.rhel_ami
  instance_type   = "t3.xlarge"
  web_subnet_a    = local.app_prod_aza_subnet_id
  web_subnet_b    = local.app_prod_azb_subnet_id
  web_sg_ids      = [local.mgmt_prod_sg,local.app_prod_sg]
  web_key_name    = module.Keypair.web_key_name
  user_keys       = local.user_keys
  root_volume_size = "128"
}

###ALB Build
#make sure to visit module before running, as there is some important notes there
module "ALB" {
  source = "../modules/load-balancer/"

  EnvName               = local.Env
  alb_security_groups   = [local.app_prod_sg,local.web_prod_sg,"sg-05228ffe54e2b353b"]
  subnet_ids            = [local.app_prod_aza_subnet_id,local.app_prod_azb_subnet_id]
  access_logs_bucket    = "pbmmaccel-logarchive-phase0-aescacentral1" #bakery controlled value which cannot be seen until after resource creation
  access_logs_prefix    = "311930630581/elb-bakery-prod-alb" #bakery controlled value which cannot be seen until after resource creation
  vpc_id                = local.bakery_prod_vpc_id
  instance_ids          = module.Web.web_server_ids
  certificate_arn       = "arn:aws:acm:ca-central-1:311930630581:certificate/acb1aaa5-fc02-469d"
  bakery_traffic_port_1    = "9016"
  bakery_traffic_port_2    = "9017"
}

###Lifecycle-Manager Build
module "Lifecycle-Manager" {
  source = "../modules/lifecycle-manager/"

  EnvName               = local.Env
  AccountNumber         = "311930630581"
  snapshot_retention    = 5
}

###Database build
module "Database" {
  source = "../modules/database/"

  EnvName                           = local.Env
  database_subnet_ids               = [local.data_prod_aza_subnet_id,local.data_prod_azb_subnet_id]
  instance_count                    = 2 #count of 1 will create one writer instance in the cluster, count of 2 will create one writer instance, and one reader instance. in seperate AZs
  db_instance_class                 = "db.t4g.medium"
  engine_version                    = "5.7.mysql_aurora.2.11.2"
  availability_zones                = ["ca-central-1a","ca-central-1b","ca-central-1d"] #ca-central-1d isnt available at creation time but gets addedd after automoatically. 
  database_name                     = "recipe_book"
  master_username                   = "bakery_admin"
  backup_retention_period_days      = 3
  preferred_backup_window_utc       = "10:00-12:00"
  apply_modifications_immediately   = true
  db_security_group_ids             = [local.mgmt_prod_sg,local.data_prod_sg]
}

###Redis Build
#make sure to visit module before running, as there is some important notes there
module "Redis" {
  source = "../modules/redis-cluster/"

  EnvName                      = local.Env
  redis_subnet_aza             = local.data_prod_aza_subnet_id
  redis_subnet_azb             = local.data_prod_azb_subnet_id
  redis_node_type              = "cache.t4g.small"
  num_replicas_per_shard       = 2
  num_shards                   = 1
  redis_parameter_group_name   = "default.redis7"
  redis_engine_version         = "7.0"
  redis_security_group         = local.data_prod_sg
}

###Opensearch Build
#make sure to visit module before running, as there is some important notes there
module "Opensearch" {
  source = "../modules/opensearch/"

  EnvName                         = "prod" #domain name too long for "staging"
  opensearch_engine_version       = "OpenSearch_1.2"
  opensearch_instance_type        = "t3.small.search"
  master_instance_type            = "t3.small.search"
  opensearch_instance_count       = 2 #number of data nodes, 3 master nodes are created as part of the module when master_enabled = true 
  multi_az                        = true
  master_enabled                  = true
  opensearch_log_type             = "INDEX_SLOW_LOGS"
  opensearch_volume_size          = 100
  opensearch_subnet_ids           = [local.app_prod_aza_subnet_id,local.app_prod_azb_subnet_id]
  opensearch_security_group_ids   = [local.mgmt_prod_sg,local.app_prod_sg]
}