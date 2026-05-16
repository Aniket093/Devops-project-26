#ECR Repository creation
resource "aws_ecr_repository" "app_repository" {
  name = var.repository_name

  image_tag_mutability = "MUTABLE" #Controls whether image tags can change.(MUTABLE=Allows overwriting tags.)
  # IMMUTABLE = for strict version safety.
  image_scanning_configuration {
    scan_on_push = true #VERY important security feature.AWS scans Docker images for--vulnerabilities,insecure packages,CVEs
  }

  tags = {
    Name = var.repository_name
  }
}

#Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "app_policy" {
  repository = aws_ecr_repository.app_repository.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images"

        selection = {
          tagStatus   = "any"                #Delete untagged images
          countType   = "imageCountMoreThan" #Count based on time since image was pushed
          countNumber = 10                   #Keep images pushed within the last 10 days
        }

        action = {
          type = "expire" #Expire/Remove the images
        }
      }
    ]
    }
  )
}

