locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  account_name = local.environment_vars.locals.account_name
  account_id   = local.environment_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
  environment  = local.environment_vars.locals.environment

  use_alternate_profile = (
    local.environment == "test" ||
    local.environment == "stage"
  )

  aws_profile = local.use_alternate_profile ? "personal" : ""
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${local.aws_region}"
  %{ if local.aws_profile != "" }
  profile = "${local.aws_profile}"
  %{ endif }
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.environment}-${local.account_id}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "tf-${local.account_id}-${local.aws_region}"
    profile        = local.aws_profile
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals
)
