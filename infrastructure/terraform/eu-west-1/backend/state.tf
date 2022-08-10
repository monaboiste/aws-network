locals {
  region     = "eu-west-1"
  state_name = "monaboiste-terraform-state-${local.region}"

  tags = {
    "Name" : local.state_name
    "Automation" : "git@github.com:monaboiste/aws-network.git infrastructure/terraform/${local.region}/backend"
  }
}

module "backend" {
  source = "../../module/backend"

  backend_state_name = local.state_name
  tags               = local.tags
}