resource "aws_codecommit_repository" "source_code" {
  repository_name = "acg.terraform.web-server"
  description     = "Our super web server source code deployed with Terraform"
}

output "repoUrl" {
  value = aws_codecommit_repository.source_code.clone_url_http
}
