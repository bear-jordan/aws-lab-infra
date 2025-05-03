resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aws_lab_nginx_sg.id]
  subnets            = var.public_subnets
}

resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg_a.arn
  }
}

resource "aws_lb_target_group" "my_tg_a" {
  name     = "target-group-a"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.aws_lab_vpc.id
}

resource "aws_lb_target_group_attachment" "tg_attachment_a" {
  target_group_arn = aws_lb_target_group.my_tg_a.arn
  target_id        = aws_instance.hello_world_0.id
  port             = 80
}
