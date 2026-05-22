variable "aws_region" {                #defined in providers.tf 
  description = "aws_region"
  type        = string                 # value of this defined in tf.tfvars
}

#Environment Variable creation
variable "enviornment" {
  description = "Deploypment Enviornment"
  type = string
}



