# Load Balancer
resource "aws_lb" "aws_lab_alb" {
  name               = "aws-lab-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aws_lab_alb_sg.id]
  subnets            = [aws_subnet.public_subnet_0.id, aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]


  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_alb"
    }
  )
}

# Listener
resource "aws_lb_listener" "aws_lab_alb_listener" {
  load_balancer_arn = aws_lb.aws_lab_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_ingress_tg.arn
  }
}

# WAF Association
resource "aws_wafv2_web_acl_association" "waf-alb" {
  resource_arn = aws_lb.aws_lab_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.aws_lab_waf.arn
}


# Security group
resource "aws_security_group" "aws_lab_alb_sg" {
  name        = "aws_lab_alb_sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.aws_lab_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_alb_sg"
    }
  )
}
