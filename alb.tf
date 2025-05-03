# Load Balancer
resource "aws_lb" "aws_lab_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aws_lab_nginx_sg.id]
  subnets            = [aws_subnet.public_subnet_0.id, aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]


  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_alb"
    }
  )
}

# Listener
resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.aws_lab_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

# WAF Association
resource "aws_wafv2_web_acl_association" "waf-alb" {
  resource_arn = aws_lb.aws_lab_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.aws_lab_waf.arn
}

# Target Group
resource "aws_lb_target_group" "nginx" {
  name     = "nginx"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.aws_lab_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "tg_attachment_a" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.hello_world_0.id
  port             = 80
}
