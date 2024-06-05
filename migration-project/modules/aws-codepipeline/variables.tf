locals {
  # Project Related Vars
  ClientName    = "bakery"
  App           = "codepipeline"
}

#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}

variable "branch_name" {
  type        = string
  description = "repository branch to build from"
}

variable "connection_arn" {
  type        = string
  description = "aws github connection arn"
}

variable "full_repository_id" {
  type        = string
  description = "full github repo id"
}

variable "AccountNumber" {
  type        = string
  description = "AWS accounmt number for env"
}