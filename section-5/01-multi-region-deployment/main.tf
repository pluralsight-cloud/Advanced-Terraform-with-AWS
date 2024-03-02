module "web_server_virginia" {
  source = "./module"
  providers = {
    aws = aws.virginia
  }
}

module "web_server_oregon" {
  source = "./module"
  providers = {
    aws = aws.oregon
  }
}
