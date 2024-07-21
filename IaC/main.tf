module "vpc" {
  source = "./modules/network"
}

module "iam" {
  source = "./modules/iam" 
}

module "emr" {
 source = "./modules/emr"
 release_label = var.release_label 
 service_role = module.iam.service_role
 instance_profile = module.iam.ec2_emr_instance_profile_arn
 log_uri_bucket = var.log_uri_bucket 
 aws_subnet = module.vpc.public_subnets_1
 vpc_id = module.vpc.vpc_id
}