# Redshift
resource "aws_security_group" "aws_lab_redshift_sg" {
  name        = "aws_lab_redshift_sg"
  description = "Allow Redshift connections"
  vpc_id      = aws_vpc.aws_lab_vpc.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/16"]
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
      Name = "aws_lab_redshift_sg"
    }
  )
}

# Secrets
data "aws_secretsmanager_secret_version" "redshift_admin_secret" {
  secret_id = "prod/rs-admin"
}

locals {
  redshift_secret   = jsondecode(data.aws_secretsmanager_secret_version.redshift_admin_secret.secret_string)
  redshift_password = local.redshift_secret["password"]
  redshift_username = local.redshift_secret["username"]
}

# Database
resource "aws_redshiftserverless_namespace" "aws_lab_redshift_db" {
  namespace_name = "aws-lab"
  db_name        = "aws_lab"

  admin_username      = local.redshift_username
  admin_user_password = local.redshift_password

  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_redshift_db"
    }
  )
}

resource "aws_redshiftserverless_workgroup" "aws_lab_redshift_wg" {
  workgroup_name       = "aws-lab-redshift-wg"
  namespace_name       = aws_redshiftserverless_namespace.aws_lab_redshift_db.namespace_name
  base_capacity        = 8
  enhanced_vpc_routing = true
  publicly_accessible  = true

  security_group_ids = [aws_security_group.aws_lab_redshift_sg.id]
  subnet_ids = [
    aws_subnet.private_subnet_0.id,
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_redshift_wg"
    }
  )
}
