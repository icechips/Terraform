#local module variables
locals {
  # Project Related Vars
  ClientName = "bakery"
  App        = "bastion"
}

#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}

variable "ami" {
  type        = string
  description = "ami for server"
}

variable "instance_type" {
  type        = string
  description = "instance type for server"
}

variable "bastion_subnet" {
  type        = string
  description = "subent for server"
}

variable "bastion_sg_ids" {
  type        = list(string)
  description = "ssh keys to add to server"
}

variable "bastion_key_name" {
  type        = string
  description = "aws key pair name for bastion server"
}

variable "user_keys" {
  type        = list(string)
  description = "ssh keys to add to server"
}