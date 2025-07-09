# 🛡️ AWS WAFv2 IP Set for Security Scanners
resource "aws_wafv2_ip_set" "security_scanners" {
  provider = aws.us_east_1
  
  name               = "security-scanners-${replace(var.domain_name, ".", "-")}"
  description        = "IP addresses for security scanning tools"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"

  # Common security scanner IP ranges
  addresses = [
    "64.41.200.0/24",     # SSL Labs
    "208.70.247.157/32",  # Mozilla Observatory
    "185.165.169.18/32",  # Security Headers
  ]

  tags = {
    Project = "StaticSite"
  }
}

# 🛡️ AWS WAFv2 Web ACL for CloudFront
resource "aws_wafv2_web_acl" "cloudfront_waf" {
  provider = aws.us_east_1  # WAF for CloudFront must be in us-east-1
  
  name        = "cloudfront-waf-${replace(var.domain_name, ".", "-")}"
  description = "WAF rules for CloudFront distribution"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  # Rule 0: Allow security scanners
  rule {
    name     = "AllowSecurityScanners"
    priority = 0

    action {
      allow {}
    }

    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.security_scanners.arn
          }
        }
        statement {
          byte_match_statement {
            search_string = "ssl labs"
            field_to_match {
              single_header {
                name = "user-agent"
              }
            }
            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
            positional_constraint = "CONTAINS"
          }
        }
        statement {
          byte_match_statement {
            search_string = "mozilla observatory"
            field_to_match {
              single_header {
                name = "user-agent"
              }
            }
            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
            positional_constraint = "CONTAINS"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowSecurityScanners"
      sampled_requests_enabled   = true
    }
  }

  # Rule 1: AWS Managed Core Rule Set
  rule {
    name     = "AWSManagedRulesCore"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCore"
      sampled_requests_enabled   = true
    }
  }

  # Rule 2: AWS Managed Known Bad Inputs Rule Set
  rule {
    name     = "AWSManagedRulesKnownBadInputs"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputs"
      sampled_requests_enabled   = true
    }
  }

  # Rule 3: Rate limiting rule
  rule {
    name     = "RateLimitRule"
    priority = 3

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000  # requests per 5-minute period
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Project = "StaticSite"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "CloudFrontWAF"
    sampled_requests_enabled   = true
  }
}
