module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = [data.aws_route53_zone.hosted_zone.name]

  enabled             = true
  wait_for_deployment = false

  origin = {

    s3_origin = {
      domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    }
  }

  default_root_object = "index.html"

  default_cache_behavior = {
    target_origin_id       = "s3_origin"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "*"
      target_origin_id       = "s3_origin"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}


resource "aws_route53_record" "cdn" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = ""
  type    = "A"

  alias {
    name                   = module.cdn.cloudfront_distribution_domain_name
    zone_id                = module.cdn.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}
