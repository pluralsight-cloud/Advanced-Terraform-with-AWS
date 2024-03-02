module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  attach_policy = true
  bucket        = data.aws_route53_zone.hosted_zone.name

  versioning = {
    enabled = true
  }

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
  block_public_policy     = false
  block_public_acls       = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  policy                  = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${module.s3_bucket.s3_bucket_arn}/*",
    ]
  }
}
