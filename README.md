# Architecture Overview:
- 🪣 S3 Bucket with static site hosting
- 🌐 Route 53 Hosted Zone for your domain
- 🔐 ACM Certificate (for HTTPS)
- ☁️ CloudFront Distribution (for CDN + SSL)
- 🧭 Route 53 Record Set pointing your domain to CloudFront

# 🧱 Terraform Directory Structure
static-site/
├── main.tf
├── variables.tf
├── outputs.tf
├── index.html
└── README.md

# 🌐 Static Website on AWS with Terraform

Launch a secure, scalable, and global static site on AWS — all from code.

## ✨ Features

- ⚡ S3-hosted static site
- 🔐 HTTPS via ACM + CloudFront
- 🌍 Custom domain via Route 53
- 🧹 Fully destroyable in seconds
- 🆓 Built with Free Tier–friendly services

## 🛠️ Prerequisites

- AWS Account with Route 53 domain
- AWS CLI configured
- Terraform installed

## 🚀 Deploy

```bash
terraform init
terraform apply


🧨 Destroy
terraform destroy

