variable "aws_region" {
  default = "ap-southeast-2" # Required for ACM + CloudFront
}

variable "bucket_name" {
  default = "cloudkraft-site" # Must be globally unique if not using regional endpoints
}

variable "domain_name" {
  default = "cloudkraft.n"
}