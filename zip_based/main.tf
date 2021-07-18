terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
}


resource "aws_s3_bucket" "aws_sam_deployment_bucket" {
  bucket = "aws-sam-deployment-bucket-test"

  # バージョニングを有効化する
  versioning {
    enabled = true
  }

  # サーバサイドの暗号化をデフォルトで有効化する
    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
}

resource "aws_cloudformation_stack" "sam" {
  name = "sam"
  template_body = file("template.yaml")
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    "Name" = "Terraform"
  }
}

data "aws_cloudformation_stack" "sam" {
  name = "sam"
  depends_on = [
    aws_cloudformation_stack.sam
  ]
}

resource "aws_cloudfront_distribution" "api_dist" {
  origin {
    domain_name = data.aws_cloudformation_stack.sam.outputs["HelloWorldApiDomain"]
    origin_id = "sam-api-gateway"

    custom_origin_config {
      https_port = 443
      http_port = 80
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  default_cache_behavior {
    allowed_methods = [ "GET", "HEAD" ]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "sam-api-gateway"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
      geo_restriction {
          restriction_type = "whitelist"
          locations = [ "JP" ]
      }
  }
  viewer_certificate {
      cloudfront_default_certificate = true
  }
}