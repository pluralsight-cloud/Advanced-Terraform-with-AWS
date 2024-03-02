module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = var.project_name
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names
  public_subnets  = [for i in range(var.public_subnets_count) : cidrsubnet(var.vpc_cidr_block, 8, i)]
  private_subnets = [for i in range(var.private_subnets_count) : cidrsubnet(var.vpc_cidr_block, 8, i + var.public_subnets_count)]

  enable_nat_gateway = true
  single_nat_gateway = true
  # one_nat_gateway_per_az = false

  manage_default_security_group = false
}
