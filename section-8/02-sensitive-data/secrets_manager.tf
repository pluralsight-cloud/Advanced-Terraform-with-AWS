resource "aws_db_instance" "mysql_secrets_manager" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "admin"
  parameter_group_name = "default.mysql5.7"
  password             = aws_secretsmanager_secret_version.secret.secret_string
}

resource "aws_secretsmanager_secret" "secret" {
  name = "mysql_admin_password"
}

data "aws_secretsmanager_random_password" "secret" {
  password_length     = 10
  exclude_punctuation = true
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret
  secret_string = aws_secretsmanager_random_password.random_password
}
