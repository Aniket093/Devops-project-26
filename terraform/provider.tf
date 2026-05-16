terraform {
  required_version = ">= 1.5.0" # provided terraform version

  backend "s3" {
    bucket         = "aniket-ecs-terraform-state" #BUCKET NAME STATED IN BACKEND/main.tf
    key            = "ecs-project/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Terraform downloads AWS plugin automatically.
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region # AWS region stated
}



