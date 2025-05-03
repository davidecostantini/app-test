terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95"
    }
  }

  backend "s3" {
    bucket         = "tf-infrastructure-state-file"
    key            = "01_networking/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    use_lockfile   = true # This replaces DynamoDB locking
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}