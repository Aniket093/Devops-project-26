output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name #ECS Service module needs cluster name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs_logs.name #Task definitions need log group
}

