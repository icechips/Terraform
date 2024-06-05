terraform {
  required_version = ">=1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
    }
  }
  backend "s3" {
    bucket         = "bakery-uat-terraform-backend"
    key            = "bakery_uat_terraform.tfstate"
    region         = "ca-central-1"
  }
}

provider "aws" {
  region = "ca-central-1"
}

locals {
  Env                    = "uat"
  region                 = "ca-central-1"
  #bakery controlled network resources
  bakery_uat_vpc_id         = "vpc-013e77f4289e1fa27" 
  bakery_uat_vpc_cidr       = "10.103.0.0/16"
  app_uat_aza_subnet_id  = "subnet-0de249e69d5f52ebb"
  app_uat_azb_subnet_id  = "subnet-02b7f615dccbc9d19"
  web_uat_aza_subnet_id  = "subnet-0fa2734aa4cf3cc01"
  web_uat_azb_subnet_id  = "subnet-04630eb798d93d15b"
  data_uat_aza_subnet_id = "subnet-06d9db59d94b62a8c"
  data_uat_azb_subnet_id = "subnet-0b22318dae06401fa"
  app_uat_sg             = "sg-058d88bccd32479bd"
  web_uat_sg             = "sg-0e33c8e6216cc41a1"
  data_uat_sg            = "sg-0020311c4400df92f"
  mgmt_uat_sg            = "sg-0de70ab26a86b7af7"

  #ssh keys for server access
  user_keys = [
    ""
  ]

  #RHEL 7 ami for instances
  rhel_ami = "ami-0f1c453d5ca1059f0"
}