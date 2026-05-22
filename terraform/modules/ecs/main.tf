#ECS Cluster creation
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights" #Enables-->CloudWatch metrics,ECS monitoring,performance visibility
    value = "enabled"
  }

  tags = {
    Name = var.cluster_name
  }
}

#CloudWatch Log Group creation
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${terraform.workspace}-nodejs-app"
  retention_in_days = 7 #Automatically deletes older logs.

  tags = {
    Name = "nodejs-app-logs"
  }
}

#ECS Task Execution Role creation --> Containers need AWS permissions---> pull images from ECR / send logs to CloudWatch
resource "aws_iam_role" "ecs_task_execution_id" { #Without IAM role: ECS cannot access AWS services
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#ECS Execution Policy creation
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" #AWS-managed policy enabling
  role       = aws_iam_role.ecs_task_execution_id.name

}

#Task Definition creation
resource "aws_ecs_task_definition" "app_task" {
  family                   = "${local.enviornment}-nodejs-app"
  network_mode             = "awsvpc"    #Recommended for Fargate -->ECS task gets-->its own ENI, its own private IP
  requires_compatibilities = ["FARGATE"] #Specify launch type --> Run serverless containers

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_id.arn #Task execution role ARN

  container_definitions = jsonencode([ #Container definitions
    {
      name      = "${local.enviornment}-nodejs-app"
      image     = "${var.ecr_repository_url}:latest" #ECR repository URL -->ECS pulls image from ECR automatically.
      essential = true

      portMappings = [ #Maps: container port--TO--task networking
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      logConfiguration = { #sends container logs to CloudWatch.
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

}

#ECS Service creation 
resource "aws_ecs_service" "app_service" {
  name            = "nodejs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app_task.arn

  desired_count = 2 #2 running containers
  launch_type   = "FARGATE"

  network_configuration {
    subnets = [
      var.public_subnet_1_id,
      var.public_subnet_2_id
    ]

    security_groups = [var.ecs_security_group_id]

    assign_public_ip = true
  }

  load_balancer { # connects : ALB <-> ECS Service. This is how traffic reaches containers.
    target_group_arn = var.target_group_arn

    container_name = "nodejs-app"
    container_port = 3000
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy] #IAM permissions created BEFORE ECS service.
}
