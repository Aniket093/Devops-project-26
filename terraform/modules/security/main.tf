#ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Allow http & https traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Http Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Https Access" #Secure encrypted traffic.
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Allow traffic from anywhere on internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #This allows ALB to communicate outward.
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}


#ECS Security Group
resource "aws_security_group" "ecs_sg" {
  name = "${terraform.workspace}-ecs-security-group"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allowed traffic from ALB"
    from_port       = 3000 #Because later our Node.js app will run on--localhost:3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] #ONLY ALB can access ECS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-security-group"
  }

}