
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    mysql = {
      source  = "petoju/mysql"
      version = "3.0.43"
    }
  }
}


provider "mysql" {
  endpoint = aws_db_instance.default.address
  username = aws_db_instance.default.username
  password = aws_db_instance.default.password
}
