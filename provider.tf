terraform {
  backend "s3" {
    bucket = "devdaeun-terraform-state"
    key = "terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-state-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-2"
}
