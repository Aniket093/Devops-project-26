provider "aws" {                    #Backend infrastructure is standalone initially.--Later main Terraform project uses remote backend.
  region = "ap-south-1"
}


#S3 Bucket --------Also need to define in providers.tf of main folder
resource "aws_s3_bucket" "terraform_state" {
  bucket = "aniket-ecs-terraform-state"
  
  tags = {
    Name = "Terraform state Bucket"
  }
}

#S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {                      #Versioning allows rollback.
        status = "Enabled"
    } 
}

#S3 Bucket server_side_encryption_configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#DynamoDB Table
resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"          #No capacity planning needed.
  hash_key = "LockID"


  attribute {
    name = "LockID"                         #Terraform uses DynamoDB row:to manage state locks.
    type = "S"
  }

  tags = {
    Name = "Terraform state lock table"
  }

}