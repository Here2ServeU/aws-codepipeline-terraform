resource "aws_ecs_task_definition" "t2s-demo" {
  family             = "t2s-demo"
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn
  task_role_arn      = aws_iam_role.ecs-task-role.arn
  cpu                = 256
  memory             = 512
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]

  container_definitions = <<DEFINITION
[
  {
    "essential": true,
    "image": "${aws_ecr_repository.t2s-demo.repository_url}",
    "name": "demo",
    "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
               "awslogs-group" : "t2s-demo",
               "awslogs-region": "${var.AWS_REGION}",
               "awslogs-stream-prefix": "ecs"
            }
     },
     "secrets": [],
     "environment": [],
     "healthCheck": {
       "command": [ "CMD-SHELL", "curl -f http://localhost:3000/ || exit 1" ],
       "interval": 30,
       "retries": 3,
       "timeout": 5
     }, 
     "portMappings": [
        {
           "containerPort": 3000,
           "hostPort": 3000,
           "protocol": "tcp"
        }
     ]
  }
]
DEFINITION

}

resource "aws_ecs_service" "t2s-demo" {
  name            = "t2s-demo"
  cluster         = aws_ecs_cluster.t2s-demo.id
  desired_count   = 1
  task_definition = aws_ecs_task_definition.t2s-demo.arn
  launch_type     = "FARGATE"
  depends_on      = [aws_lb_listener.t2s-demo]

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = [
      aws_subnet.public_subnet[0].id,  # Select the second element of the tuple
      aws_subnet.public_subnet[1].id,  # Select the third element of the tuple
      aws_subnet.public_subnet[2].id,  # Select the fourth element of the tuple
    ]
    security_groups  = [aws_security_group.ecs-t2s.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.t2s-demo-blue.id
    container_name   = "t2s-demo"
    container_port   = "3000"
  }
  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
    ]
  }
}

# security group
resource "aws_security_group" "ecs-t2s" {
  name        = "ECS t2s-demo"
  vpc_id      = aws_vpc.t2s_vpc.id
  description = "The ECS cluster demo for T2S"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

    # Add lifecycle configuration to ignore changes to all attributes
  lifecycle {
    ignore_changes = all
  }
}

# logs
resource "aws_cloudwatch_log_group" "t2s-demo" {
  name = "t2s-demo"

    # Add lifecycle configuration to ignore changes to all attributes
  lifecycle {
    ignore_changes = all
  }
}
