#main AWS configurationa


required_providers {
  aws = {
    source = "aws"
  }
}


backend "s3" {
  bucket = " "
  key = "java-app/terraform.tfstate"
  region = "us-east-1"
}

provider "aws" {
  region = var.aws.region
}

#vpc module

module "vpc" {
  source = "./modules/vpc"

  environment = var.environment
  vpc_cidr = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs = var.availability_zones
}

#security moidules

module "security" {
  source = "./modules/security"

  environment = var.environment
  vpc_id = module.vpc.vpc_id
}



#RDS module 
module "rds" {
  source = "./modules/rds"

  environment = var.environment
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  security_group_ids = [module.security.db_security_group_id]
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}


# alb module

module "alb" {
  source = "./modules/alb"

  environment = var.environment
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}

# auto scaling group module

module "asg" {
  source = "./modules/asg"

  environment = var.environment
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_ids = [module.security.app_security_ids]
  target_group_srns = [module.alb.target_group_arns]
  instance_type = var.instance_type
  key_name = var.key_name
  min_size = var.asg_min_size
  max_size = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
}

# cloudwatch module

module "monitoring" {
  source = "./modules/monitoring"

  environment = var.environment
  rds_instance_id = module.rds.rds_instance_id
  asg_name = module.asg.asg_name
}





























