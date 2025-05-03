resource "aws_security_group" "aws_lab_nginx_sg" {
  name        = "aws_lab_nginx_sg"
  description = "Nginx security group"
  vpc_id      = aws_vpc.aws_lab_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
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
      Name = "aws_lab_nginx_sg"
    }
  )
}

resource "aws_instance" "hello_world_0" {
  ami           = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet_0.id

  user_data = <<-EOF
             #!/bin/bash
             sudo apt-get update
             sudo apt-get install -y nginx
             sudo systemctl start nginx
             sudo systemctl enable nginx
             echo '<!doctype html>
             <html lang="en"><h1>Home page!</h1></br>
             <h3>(Instance 0)</h3>
             </html>' | sudo tee /var/www/html/index.html
             EOF
}
