resource "aws_instance" "web" {
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"

  user_data              = filebase64("scripts/user_data.sh")
  vpc_security_group_ids = [aws_security_group.allow_http.id]
}


data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

data "aws_vpc" "this" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
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
    Name = "allow_http"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
