provider "aws" {
  default_tags {
    tags = {
      Environment = "test"
      Project     = "web-server"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
