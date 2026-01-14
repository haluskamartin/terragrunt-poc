terraform {
  source = "../../../../../terraform/modules/ecs"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

dependency "network" {
  config_path = "../../us-staging/network"
}

inputs = {
  access_logs_bucket                 = ""
  app_environment                    = local.environment_vars.locals.environment
  app_prefix                         = "hg"
  aws_account_id                     = local.environment_vars.locals.aws_account_id
  aws_ecs_task_definition_api_cpu    = 1024
  aws_ecs_task_definition_api_memory = 2048
  aws_region                         = local.region_vars.locals.aws_region
  desired_count_api                  = 1
  desired_count_scheduling           = 1
  domain_back_end                    = local.environment_vars.locals.domain_back_end
  health_check_enabled               = true
  health_check_interval              = 60
  health_check_path_api              = "/ping"
  health_check_path_scheduling       = "/scheduling/ping"
  health_check_timeout               = 45
  logs_retention_days                = 3
  subnet_private_id                  = dependency.network.outputs.subnet_private_id_0
  subnet_public_id_0                 = dependency.network.outputs.subnet_public_id_0
  subnet_public_id_1                 = dependency.network.outputs.subnet_public_id_1

  vpc_id             = dependency.network.outputs.vpc_id
  domain_hosted_zone = local.environment_vars.locals.domain_hosted_zone
  env_variables = [
    "DB_USERNAME",
    "DB_PASSWORD",
  ]
}
