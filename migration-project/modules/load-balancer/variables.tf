#local module variables
locals {
  # Project Related Vars
  ClientName = "bakery"
  App        = "alb"
}

#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}

variable "alb_security_groups" {
  type        = list(string)
  description = "security groups for the alb"
}

variable "subnet_ids" {
  type        = list(string)
  description = "subents for the alb"
}

variable "access_logs_bucket" {
  type        = string
  description = "bakery managed s3 bucket for access logs"
}

variable "access_logs_prefix" {
  type        = string
  description = "bakery managed s3 prefix for access logs"
}

variable "vpc_id" {
  type        = string
  description = "vpc id for the env"
}

variable "instance_ids" {
  type        = list(string)
  description = "web instance ids to attach"
}

variable "certificate_arn" {
  type        = string
  description = "listener certificate arn"
}

variable "bakery_traffic_port_1" {
  type        = string
  description = "custom traffic port for external bakery alb"
}

variable "bakery_traffic_port_2" {
  type        = string
  description = "custom traffic port for external bakery alb"
}