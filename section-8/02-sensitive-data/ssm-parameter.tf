resource "aws_db_instance" "mysql_ssm_secret" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = data.aws_ssm_parameter.external_ssm.value
  parameter_group_name = "default.mysql5.7"
}

# data "aws_ssm_parameter" "external_ssm" {
#   name = "mytest"
# }

resource "aws_ssm_parameter" "ssm_secret" {
  name        = "/production/database/admin/password"
  description = "The parameter description"
  type        = "SecureString"
  value       = var.admin_password
}
