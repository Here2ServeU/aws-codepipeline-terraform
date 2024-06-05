# Creating a Load Balancer
resource "aws_eip" "t2s_lb_eip" {
  # vpc = true
}

resource "aws_lb" "t2s-lb" {
  name               = "t2s-lb"
  internal           = false
  load_balancer_type = "application"

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet[0].id
    allocation_id = aws_eip.t2s_lb_eip.id  # Ensure you define this Elastic IP resource
  }

  subnet_mapping {
    subnet_id     = aws_subnet.private_subnet[1].id
    allocation_id = aws_eip.t2s_lb_eip.id  # Ensure you define this Elastic IP resource
  }

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet[2].id
    allocation_id = aws_eip.t2s_lb_eip.id  # Ensure you define this Elastic IP resource
  }

  tags = {
    Name = "t2s-lb"
  }
}


resource "aws_lb_listener" "t2s-demo" {
  load_balancer_arn = aws_lb.t2s-lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.t2s-demo-blue.id
    type             = "forward"
  }
  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}

resource "aws_lb_target_group" "t2s-demo-blue" {
  name                 = "demo-http-blue"
  port                 = "3000"
  protocol             = "TCP"
  target_type          = "ip"
  vpc_id               = aws_vpc.t2s_vpc.id
  deregistration_delay = "30"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "TCP"
    interval            = 30
  }
}
resource "aws_lb_target_group" "t2s-demo-green" {
  name                 = "demo-http-green"
  port                 = "3000"
  protocol             = "TCP"
  target_type          = "ip"
  vpc_id               = aws_vpc.t2s_vpc.id
  deregistration_delay = "30"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "TCP"
    interval            = 30
  }
}
