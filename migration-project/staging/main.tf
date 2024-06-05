terraform {
  required_version = ">=1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
    }
  }
  backend "s3" {
    bucket         = "bakery-staging-terraform-backend"
    key            = "bakery_staging_terraform.tfstate"
    region         = "ca-central-1"
  }
}

provider "aws" {
  region = "ca-central-1"
}

locals {
  Env                        = "staging"
  region                     = "ca-central-1"
  #bakery controlled network resources
  bakery_staging_vpc_id           = "vpc-0d2e3f7a979fde7b9" 
  bakery_staging_vpc_cidr         = "10.105.0.0/16"
  app_staging_aza_subnet_id    = "subnet-0204a200338a9dfe7"
  app_staging_azb_subnet_id    = "subnet-0d711710ee0d31eec"
  web_staging_aza_subnet_id    = "subnet-099427b98924f07c9"
  web_staging_azb_subnet_id    = "subnet-013112804325dc68f"
  data_staging_aza_subnet_id   = "subnet-03754a7e977dc7796"
  data_staging_azb_subnet_id   = "subnet-0f92b4c4130617778"
  app_staging_sg               = "sg-0a297ece83f66e780"
  web_staging_sg               = "sg-0ab445bbb2a9eb6b6"
  data_staging_sg              = "sg-047934a7c24c609be"
  mgmt_staging_sg              = "sg-0422936c110e6dd3e"

  #ssh keys for server access
  user_keys = [
    ""
  ]

  #RHEL 7 ami for instances
  rhel_ami = "ami-0f1c453d5ca1059f0"

}