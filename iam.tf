resource "aws_iam_user_policy_attachment" "query_editor_access" {
  user       = "bear"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftQueryEditorV2FullAccess"
}

