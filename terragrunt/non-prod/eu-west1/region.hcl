locals {
  aws_region         = "eu-west-1"
  availability_zones = ["${local.aws_region}a", "${local.aws_region}b"]
}
