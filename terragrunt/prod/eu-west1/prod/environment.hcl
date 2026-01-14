locals {
  account_name                   = "five-iron-golf-prod"
  aws_account_id                 = "028221800395"
  domain_back_end                = "api.booking.fiveirongolf.com"
  domain_front_end               = "booking.fiveirongolf.com"
  domain_front_end_display       = "display.booking.fiveirongolf.com"
  domain_front_end_duckpin       = "booking.detroitduckpin.com"
  domain_front_end_duckpin_extra = "duckpin.fiveirongolf.com"
  domain_front_end_tournament    = "tournament.booking.fiveirongolf.com"
  domain_hosted_zone             = "booking.fiveirongolf.com"
  domain_metabase                = "bi.booking.fiveirongolf.com"
  duckpin_domain_hosted_zone     = "booking.detroitduckpin.com"
  duclpin_secondary_hosted_zone  = "duckpin.fiveirongolf.com"
  environment                    = "prod"
  private_subnets                = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets                 = ["10.0.101.0/24", "10.0.102.0/24"]
  vpc_cidr_block                 = "10.0.0.0/16"
}
