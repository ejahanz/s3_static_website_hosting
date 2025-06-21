variable "aws_region" {
  default = "ap-southeast-2" # Required for ACM + CloudFront
}

variable "bucket_name" {
  description = "s3-static-site-bucket-12345"
  type        = string
}

variable "domain_name" {
  description = "The domain name to serve the website"
  type        = string
}