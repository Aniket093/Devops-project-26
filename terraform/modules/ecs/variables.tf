variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

#ECS needs: networking, ALB integration, container image source
variable "ecs_security_group_id" {
  description = "ECS security group Id"
  type        = string
}

variable "public_subnet_1_id" {
  description = "Public subnet 1 Id"
  type        = string
}

variable "public_subnet_2_id" {
  description = "Public subnet 2 Id"
  type        = string
}

variable "target_group_arn" {
  description = "ALB Target group ARN"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}