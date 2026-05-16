variable "vpc_cidr" {
  description = "cidr block for vpc"
  type = string
}

variable "public_subnet_1_cidr" {
description = "cidr for public subnet 1"
type = string  
}

variable "public_subnet_2_cidr" {
description = "cidr for public subnet 2"
type = string  
}

variable "availability_zone_1" {
description = "Availability zone 1"
type = string  
}

variable "availability_zone_2" {
description = "Availability zone 2"
type = string  
}

