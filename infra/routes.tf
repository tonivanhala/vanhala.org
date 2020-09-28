variable domain {}

resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_acm_certificate" "default" {
  provider = aws.acm

  domain_name = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      type = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "default" {
  provider = aws.acm

  certificate_arn = aws_acm_certificate.default.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name = var.domain
  type = "A"
  alias {
    name = aws_cloudfront_distribution.vanhalaorg_distribution.domain_name
    zone_id = aws_cloudfront_distribution.vanhalaorg_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
