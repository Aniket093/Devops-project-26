output "target_group_arn" {
  value = aws_lb_target_group.ecs_target_group.arn #ECS Service needs target group ARN
}

output "load_balancer_dns" {
  value = aws_lb.main.dns_name #We use ALB DNS to access app
}