terraform {
  backend "s3" {
    bucket         = "terraform-backend-terraformbackends3bucket-cbgsm0d5zojc"
    key            = "testing"
    region         = "us-east-1"
    dynamodb_table = "terraform-backend-TerraformBackendDynamoDBTable-1XFKJYQG2G0XY"
  }
}
