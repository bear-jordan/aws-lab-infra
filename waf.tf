resource "aws_wafv2_web_acl" "my_waf" {
  name  = "my-waf-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "my-waf-metric"
    sampled_requests_enabled   = false
  }
}
