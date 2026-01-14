locals {
  account_name       = "happygilmore"
  aws_account_id     = "244998874093"
  domain_back_end    = "api.dubai.staging.treeline.fiveirongolf.com"
  domain_front_end   = "dubai.staging.treeline.fiveirongolf.com"
  domain_hosted_zone = "treeline.fiveirongolf.com"
  environment        = "ae-staging"
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  vpc_cidr_block     = "10.0.0.0/16"
}
