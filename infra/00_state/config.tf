terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}