#local module variables
locals {
  # Project Related Vars
  ClientName = "bakery"
  App        = "recipe"
}

#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}

variable "vpc_id" {
  type        = string
  description = "id of vpc to attach"
}