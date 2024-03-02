
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

provider "aws" {
  region = "us-west-2"
  alias  = "oregon"
}
