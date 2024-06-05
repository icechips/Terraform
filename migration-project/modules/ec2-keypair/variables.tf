#local module variables
locals {
  # Project Related Vars
  ClientName  = "bakery"
  bastion_App = "bastion"
  web_App     = "web"
}

#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}