resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = "foo"
  password               = "foobarbaz"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.allow_mysql_access.id]
}

data "aws_vpc" "this" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_security_group" "allow_mysql_access" {
  name   = "allow_mysql_access"
  vpc_id = data.aws_vpc.this.id

  ingress {
    description = "Access MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mysql_access"
  }
}

resource "mysql_user" "jdoe" {
  user               = "jdoe"
  host               = "%"
  plaintext_password = "password"
}

resource "mysql_user" "test" {
  user               = "jdtestoe"
  host               = "%"
  plaintext_password = "password"
}

