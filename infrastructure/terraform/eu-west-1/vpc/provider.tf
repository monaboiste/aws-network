provider "aws" {
  region = local.region
}

terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.24.0"
    }
  }

  backend "s3" {
    bucket         = "monaboiste-terraform-state-eu-west-1"
    key            = "vpc/monaboiste-vpc-eu-west-1/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "monaboiste-terraform-state-eu-west-1-locks"
    encrypt        = true
  }
}
