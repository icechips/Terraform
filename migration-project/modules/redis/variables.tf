#local module variables
locals {
  # Project Related Vars
  ClientName = "bakery"
  App        = "redis"
}

#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}

variable "redis_subnet_aza" {
  type        = string
  description = "Redis subnet for azA"
}

variable "redis_node_type" {
  type        = string
  description = "Redis node type"
}

variable "num_cache_nodes" {
  type        = number
  description = "Number of redis cache nodes"
}

variable "redis_parameter_group_name" {
  type        = string
  description = "Redis parameter group"
}

variable "redis_engine_version" {
  type        = string
  description = "Redis engine version"
}

variable "redis_security_group" {
  type        = string
  description = "Redis security group"
}