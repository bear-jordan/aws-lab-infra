# EC2 (k8s)
resource "aws_security_group" "aws_lab_k8s_sg" {
  name        = "aws_lab_k8s_sg"
  description = "Kubernetes security group"
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
      Name = "aws_lab_k8s_sg"
    }
  )
}

resource "aws_instance" "aws_lab_talos_controller" {
  count                  = var.controller_count
  ami                    = "ami-0c332b60cc8a1d564"
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_subnet_0.id
  vpc_security_group_ids = [aws_security_group.aws_lab_k8s_sg.id]

  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_talos_controller_${count.index}"
    }
  )
}

resource "aws_instance" "aws_lab_talos_worker" {
  count                  = var.worker_count
  ami                    = "ami-0c332b60cc8a1d564"
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.public_subnet_0.id
  vpc_security_group_ids = [aws_security_group.aws_lab_k8s_sg.id]

  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_talos_worker_${count.index}"
    }
  )
}


