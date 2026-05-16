output "repository_url" {
  value = aws_ecr_repository.app_repository.repository_url #resource creation name . output name 
}                                                          #GitHub Actions needs ECR URL

output "repository_name" {
  value = aws_ecr_repository.app_repository.name #ECS task definition needs image URL
}