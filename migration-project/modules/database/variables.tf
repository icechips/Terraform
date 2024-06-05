#local module variables
locals {
  # Project Related Vars
  ClientName = "bakery"
  App        = "adobe-commerce-database"
}

#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}

variable "database_subnet_ids" {
  type        = list(string)
  description = "subnet ids for database subnet group"
}

variable "instance_count" {
  type        = number
  description = "number of database instances"
}

variable "db_instance_class" {
  type        = string
  description = "instance class for database"
}

variable "engine_version" {
  type        = string
  description = "aurora mysql engine version"
}

variable "availability_zones" {
  type        = list(string)
  description = "azs used by the aurora cluster"
}

variable "database_name" {
  type        = string
  description = "name of database to setup"
}

variable "master_username" {
  type        = string
  description = "name of master db user"
}

variable "backup_retention_period_days" {
  type        = number
  description = "number opf days to retain db backups"
}

variable "preferred_backup_window_utc" {
  type        = string
  description = "backup window in UTC"
}

variable "apply_modifications_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
}

variable "db_security_group_ids" {
  type        = list(string)
  description = "security groups associated with the database"
}