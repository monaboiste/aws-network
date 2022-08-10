locals {
  region                     = "eu-west-1"
  vpc_name                   = "monaboiste-vpc-${local.region}"
  availability_zones         = ["${local.region}a", "${local.region}b"]
  cidr_block                 = "10.0.0.0/16"
  public_subnets_cidr_block  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets_cidr_block = ["10.0.128.0/20", "10.0.144.0/20"]

  tags = {
    "Automation" : "git@github.com:monaboiste/aws-network.git infrastructure/terraform/${local.region}/vpc"
  }
}
