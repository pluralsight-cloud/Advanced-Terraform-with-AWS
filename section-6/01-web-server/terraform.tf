terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "terraform-backend-terraformbackends3bucket-unuq9fha8wr5"
    key            = "pipeline"
    region         = "us-east-1"
    dynamodb_table = "terraform-backend-TerraformBackendDynamoDBTable-1VA0KHIVXF0EL"
  }
}

provider "aws" {
  default_tags {
    tags = {
      "Environment" = "Test"
      "Project"     = "Terraform"
      "Operation"   = "Nokia"
    }
  }
}
