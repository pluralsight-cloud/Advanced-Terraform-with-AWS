terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment = "Test"
      Name        = "Working with Import"
    }
  }
}
