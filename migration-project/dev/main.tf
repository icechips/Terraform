terraform {
  required_version = ">=1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
    }
  }
  backend "s3" {
    bucket         = "bakery-dev-terraform-backend"
    key            = "bakery_dev_terraform.tfstate"
    region         = "ca-central-1"
  }
}

provider "aws" {
  region = "ca-central-1"
}

locals {
  Env                    = "dev"
  region                 = "ca-central-1"
  #bakery controlled network resources
  bakery_dev_vpc_id         = "vpc-0d2e3f7a979fde7b9" 
  bakery_dev_vpc_cidr       = "10.105.0.0/16"
  app_dev_aza_subnet_id  = "subnet-0204a200338a9dfe7"
  app_dev_azb_subnet_id  = "subnet-0d711710ee0d31eec"
  web_dev_aza_subnet_id  = "subnet-099427b98924f07c9"
  web_dev_azb_subnet_id  = "subnet-013112804325dc68f"
  data_dev_aza_subnet_id = "subnet-03754a7e977dc7796"
  data_dev_azb_subnet_id = "subnet-0f92b4c4130617778"
  app_dev_sg             = "sg-0fb703e80f23d4b08"
  web_dev_sg             = "sg-055bb9cd63a98588b"
  data_dev_sg            = "sg-0d08b96c475c3ce6e"
  mgmt_dev_sg            = "sg-0e69f8fdab6f7af34"

  #ssh keys for server access
  user_keys = [
    ""
  ]

  #RHEL 7 ami for instances
  rhel_ami = "ami-0f1c453d5ca1059f0"
}