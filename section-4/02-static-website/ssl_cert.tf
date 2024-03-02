resource "aws_acm_certificate" "cert" {
  domain_name               = data.aws_route53_zone.hosted_zone.name
  subject_alternative_names = ["*.${data.aws_route53_zone.hosted_zone.name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
}
