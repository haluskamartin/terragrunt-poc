terraform {
  source = "../../../../../terraform/modules/vpc"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
  environment        = local.environment_vars.locals.environment
  availability_zones = local.region_vars.locals.availability_zones
  aws_account_id     = local.environment_vars.locals.aws_account_id
  aws_region         = local.region_vars.locals.aws_region
  ec2_nat_gateway    = true
  private_subnet_az  = "${local.region_vars.locals.aws_region}a"
  private_subnets    = local.environment_vars.locals.private_subnets
  public_subnets     = local.environment_vars.locals.public_subnets
  vpc_cidr_block     = local.environment_vars.locals.vpc_cidr_block
  tags               = {
    Environment = local.environment_vars.locals.environment
    ManagedBy   = "terraform"
    Tribe       = "Infra"
    Product     = "Infra"
  }
}
