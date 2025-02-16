resource "aws_ecs_cluster" "cluster" {
  name = "dummy-api-cluster"

  tags = {
    Name = "dummy-api-cluster"
  }
}

# IAM Task Execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_attach" {
  name       = "ecs-task-execution-attach"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Task Role 
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_ecs_task_definition" "task" {
  family                   = "dummy-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "dummy-api"
      image = "${var.ecr_repository_url}:latest"
      cpu   = 256
      memory = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# Security Group for ECS Service
resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Security group for ECS Service"
  vpc_id      = var.vpc_id

  # Allow inbound traffic ONLY from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_alb_sg.id]  # Only ALB can access the service
    #security_groups = [aws_security_group.lb_security_group.id]
  }

  # Allow all outbound traffic (e.g., accessing APIs, databases)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-service-sg"
  }
}

# Log Group for Service
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/dummy-api-service"
  retention_in_days = 30  # Adjust retention as needed

  tags = {
    Name = "dummy-api-service-log-group"
  }
}

resource "aws_ecs_service" "blue" {
  name            = "dummy-api-blue"
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  desired_count   = 2         # Active Service
  task_definition = aws_ecs_task_definition.task.arn

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "dummy-api"
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}

resource "aws_ecs_service" "green" {
  name            = "dummy-api-green"
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  desired_count   = 0            # Standby Service 
  task_definition = aws_ecs_task_definition.task.arn

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = "dummy-api"
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}
