terraform {
  source = "../../../../..//terraform/modules/rds"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  secret_vars      = yamldecode(sops_decrypt_file("secrets.yaml"))
}

dependency "network" {
  config_path = "../network"
}

dependency "ssm-manager" {
  config_path = "../ssm-manager"
}

inputs = {
  allocated_storage = 20
  app_environment   = local.environment_vars.locals.environment
  app_prefix        = "hg"
  aws_region        = local.region_vars.locals.aws_region
  db_username       = local.secret_vars.db_username
  db_password       = local.secret_vars.db_password
  db_port           = 5432
  engine            = "postgres"
  engine_version    = "14.17"
  ip_allowlist = [
    local.environment_vars.locals.vpc_cidr_block,
    "${dependency.ssm-manager.outputs.aws_instance_ssm_host_public_ip}/32",
    "35.81.7.11/32",      # vpn.treelineinteractive.com
    "122.15.1.49/32",     # Micros Contractor Access
    "14.99.194.9/32",                             # TODO: find out where this IP belongs to (MHaluska)
    "34.221.159.198/32",  # openVPN for DevOps
    "173.232.224.151/32", # NordLayer VPN
    "54.188.54.135/32",   # access for Sigma no.1
    "44.207.120.40/32",   # access for Sigma no.2
    "44.229.241.60/32",   # access for Sigma no.3
    "35.168.4.93/32",     # access for Sigma no.4
    "3.228.152.31/32"     # access for Sigma no.5
  ]
  public_subnets                       = dependency.network.outputs.public_subnets
  private_subnets                      = dependency.network.outputs.private_subnets
  rds_instance_class                   = "db.t4g.xlarge"
  vpc_id                               = dependency.network.outputs.vpc_id
  # READ REPLICA
  create_read_replica                  = true
  read_replica_instance_class          = "db.t4g.xlarge"
  read_replica_publicly_accessible     = true
  read_replica_backup_retention_period = 0
  read_replica_identifier              = "hg-prod-rds-postgres-read-replica"
}
