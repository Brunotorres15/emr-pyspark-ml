module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "emr-spark-vpc-core"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b"]
  public_subnets  = ["10.0.0.0/24", "10.0.2.0/24"]

  #enable_nat_gateway = true
  #enable_vpn_gateway = true

  enable_dns_hostnames = true
  enable_dns_support = true

  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

output "vpc_id" {
value = module.vpc.vpc_id
}

output "public_subnets_1" {
    value = module.vpc.public_subnets[0]
}

output "public_subnets_2" {
    value = module.vpc.public_subnets[1]
}