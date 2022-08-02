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
    bucket         = "monaboiste-terraform-state"
    key            = "eu-west-1/vpc/monaboiste-vpc/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "monaboiste-terraform-state-locks"
    encrypt        = true
  }
}
