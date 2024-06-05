terraform {
  required_version = ">=1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
    }
  }
  backend "s3" {
    bucket         = "bakery-prod-terraform-backend"
    key            = "bakery_prod_terraform.tfstate"
    region         = "ca-central-1"
  }
}

provider "aws" {
  region = "ca-central-1"
}

locals {
  Env                        = "prod"
  region                     = "ca-central-1"
  #bakery controlled network resources
  bakery_prod_vpc_id           = "vpc-03b31d2440fc244a6" 
  bakery_prod_vpc_cidr         = "10.104.0.0/16"
  app_prod_aza_subnet_id    = "subnet-05be3b8650d36fc06"
  app_prod_azb_subnet_id    = "subnet-0350a4bc2a2b78a47"
  web_prod_aza_subnet_id    = "subnet-042a900936d2465ec"
  web_prod_azb_subnet_id    = "subnet-0735db94555b84dbc"
  data_prod_aza_subnet_id   = "subnet-0f4ee102d3278ce3a"
  data_prod_azb_subnet_id   = "subnet-0cf0e9b5365b1e3e0"
  app_prod_sg               = "sg-0c2f325502528aa5d"
  web_prod_sg               = "sg-02a0c2a853f610203"
  data_prod_sg              = "sg-00955ec4697b06323"
  mgmt_prod_sg              = "sg-059cc206baf00a318"

  #ssh keys for server access
  user_keys = [
    ""
  ]

  #RHEL 7 ami for instances
  rhel_ami = "ami-0f1c453d5ca1059f0"

}