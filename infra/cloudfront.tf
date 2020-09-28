locals {
  site_bucket_id = "vanhalaorg-site"
  vanhalaorg_origin_id = "vanhalaOrgS3Origin"
}

data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${local.site_bucket_id}/*"
    ]
  }
}

resource "aws_s3_bucket" "site_bucket" {
  bucket = local.site_bucket_id
  acl = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = "index.html"
  }
  tags = {
    vanhalaorg = ""
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {}

resource "aws_cloudfront_distribution" "vanhalaorg_distribution" {
  origin {
    domain_name = aws_s3_bucket.site_bucket.website_endpoint
    origin_id = local.vanhalaorg_origin_id
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port = "80"
      https_port = "443"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true
  http_version = "http2"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.vanhalaorg_origin_id

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 60
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    vanhalaorg = ""
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
