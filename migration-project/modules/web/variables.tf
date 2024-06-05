#local module variables
locals {
  # Project Related Vars
  ClientName = "bakery"
  App        = "web"

  #for multi az deployment
  SubnetID = [
    var.web_subnet_a,
    var.web_subnet_b
  ]
}

#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}

variable "server_count" {
  type        = string
  description = "Number of servers to launch"
}

variable "ami" {
  type        = string
  description = "ami for server"
}

variable "instance_type" {
  type        = string
  description = "instance type for server"
}

variable "web_subnet_a" {
  type        = string
  description = "Web subnet for aza"
}

variable "web_subnet_b" {
  type        = string
  description = "Web subnet for azb"
}

variable "web_sg_ids" {
  type        = list(string)
  description = "ssh keys to add to server"
}

variable "web_key_name" {
  type        = string
  description = "aws key pair name for web server"
}

variable "root_volume_size" {
  type        = string
  description = "size in GB of root block volume"
}

variable "user_keys" {
  type        = list(string)
  description = "ssh keys to add to server"
}