data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}
