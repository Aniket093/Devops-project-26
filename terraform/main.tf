# Calling VPC Module
module "vpc" {
  source = "./modules/vpc" #Terraform now: enters module folder--reads module resources--creates infrastructure

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_1_cidr = "10.0.1.0/24"
  public_subnet_2_cidr = "10.0.2.0/24"

  availability_zone_1 = "ap-south-1a"
  availability_zone_2 = "ap-south-1b"

}

# Calling SG Module
module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id #Take output from VPC module (from-output.tf) and pass it into Security module
  #Terraform automatically understands:VPC must be created BEFORE security groups
}

#Calling ECR Model
module "ecr" {
  source          = "./modules/ecr"
  repository_name = "nodejs-app"
}

#Calling ECS Model
module "ecs" {
  source       = "./modules/ecs"
  cluster_name = "nodejs-cluster"

  # Later added after ecr,alb,targetgroup creation
  ecs_security_group_id = module.security.ecs_security_group_id.id

  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id

  target_group_arn = module.alb.target_group_arn

  ecr_repository_url = module.ecr.repository_url
}

#Calling ALB Module
module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id

  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id

  alb_security_group_id = module.security.alb_security_group_id.id
}
# VPC module --> Security module --> ALB module --- Infrastructure becomes interconnected.
#Terraform automatically builds dependency graph.

#Structure completed after ECS
#Internet → ALB → Target Group → ECS Service → ECS Task (using image from ECR)