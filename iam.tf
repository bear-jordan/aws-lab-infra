resource "aws_iam_user_policy_attachment" "query_editor_access" {
  user       = "bear"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftQueryEditorV2FullAccess"
}

# Grafana Role
resource "aws_iam_role_policy_attachment" "grafana_cloudwatch_logs" {
  role       = aws_iam_role.ec2_grafana_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role" "ec2_grafana_role" {
  name = "ec2-grafana-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "grafana_profile" {
  name = "grafana-instance-profile"
  role = aws_iam_role.ec2_grafana_role.name
}

