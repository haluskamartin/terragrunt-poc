terraform {
  source = "../../../../../terraform/modules/ecs"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_name         = local.environment_vars.locals.environment
  env_type         = contains(["test"], local.env_name) ? "glb" : ""
  log_group_name   = "/ecs/${local.env_name}/${local.env_type}"
  name             = "daegon"
}

dependency "network" {
  config_path = "../network"
}

inputs = {
  name                               = local.name
  tags                               = {
    Environment = local.environment_vars.locals.environment
    ManagedBy   = "terraform"
    Tribe       = "Oddin"
    Product     = "Odds"
  }
  account_id                         = local.environment_vars.locals.aws_account_id
  region                             = local.region_vars.locals.aws_region
  vpc_id                             = dependency.network.outputs.vpc_id
  env_name                           = local.env_name
  env_type                           = local.env_type
  hosted_zone_id                     = ""
  zone_name                          = ""
  log_group_name                     = "${local.log_group_name}/${local.name}"
  access_logs_bucket                 = ""
  kafka_endpoints                    = ""
  kafka_topics                       = ""
  task_cpu                           = local.env_name == "prod" ? 512 : 256
  task_memory                        = local.env_name == "prod" ? 2048 : 512
  app_environment                    = local.environment_vars.locals.environment
  app_prefix                         = "hg"
  aws_ecs_task_definition_api_cpu    = 1024
  aws_ecs_task_definition_api_memory = 2048
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

  domain_hosted_zone = local.environment_vars.locals.domain_hosted_zone
  env_variables = [
    "DB_USERNAME",
    "DB_PASSWORD",
  ]
}
