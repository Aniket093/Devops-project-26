#ALB creation
resource "aws_lb" "main" {
  alb_name = "${local.environment}-nodejs-alb"
  load_balancer_type = "application"
  internal           = false # Public ALB Accessible from internet.

  security_groups = [var.alb_security_group_id]
  subnets         = [var.public_subnet_1_id, var.public_subnet_2_id]

  enable_deletion_protection = false

  tags = {
    Name = "nodejs-alb"
  }
}

#ALB Target Group Creation
resource "aws_lb_target_group" "ecs_target_group" {
  name        = "ecs-target-group"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip" #Fargate tasks do NOT use EC2 instances directly.

  vpc_id = var.vpc_id

  health_check {
    path                = "/" #ALB continuously checks: 200=healthy
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "ecs_target_group"
  }
}

#ALB Listener Creation
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80 #ALB--> When traffic arrives on port 80 forward it to ECS target group
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

#flow
#Browser Request --> ALB Listener (port 80) --> Target Group --> ECS Tasks
