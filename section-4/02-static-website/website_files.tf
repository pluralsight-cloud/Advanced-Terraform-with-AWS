resource "aws_s3_object" "index_html" {
  bucket       = module.s3_bucket.s3_bucket_id
  key          = "index.html"
  source       = "html/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = module.s3_bucket.s3_bucket_id
  key          = "error.html"
  source       = "html/error.html"
  content_type = "text/html"
}
