# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  aws_region         = "us-west-2"
  availability_zones = ["${local.aws_region}a", "${local.aws_region}b"]
}
