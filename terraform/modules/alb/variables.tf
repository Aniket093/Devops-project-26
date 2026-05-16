variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "public_subnet_1_id" {
  description = "Public subnet 1 ID"
  type = string
}

variable "public_subnet_2_id" {
  description = "Public subnet 2 ID"
  type = string
}

variable "alb_security_group_id" {
  description = "ALB security group ID"
  type = string
}
