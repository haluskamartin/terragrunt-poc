locals {
  account_name       = "Martin Haluska"
  aws_account_id     = "335965712345"
  environment        = "test"
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  vpc_cidr_block     = "10.0.0.0/16"
}
