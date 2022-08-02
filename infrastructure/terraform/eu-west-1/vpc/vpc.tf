module "vpc" {
  source                     = "../../module/vpc"
  vpc_name                   = local.vpc_name
  availability_zones         = local.availability_zones
  cidr_block                 = local.cidr_block
  private_subnets_cidr_block = local.private_subnets_cidr_block
  public_subnets_cidr_block  = local.public_subnets_cidr_block
  tags                       = local.tags
}
