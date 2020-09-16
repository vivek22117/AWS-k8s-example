####################################################
# AWS provider configuration                       #
####################################################
provider "aws" {
  region  = var.default_region
  profile = var.profile

  version = ">=2.57.0"
}


###########################################################
# Terraform configuration block is used to define backend #
# Interpolation sytanx is not allowed in Backend          #
###########################################################
terraform {
  required_version = ">= 0.12"

  required_providers {
    aws      = "~> 2.0"
    template = "~> 2.0"
    null     = "~> 2.0"
    local    = "~> 1.3"
  }

  backend "s3" {
    profile = "admin"
    region  = "us-east-1"
    encrypt = "true"
  }
}
