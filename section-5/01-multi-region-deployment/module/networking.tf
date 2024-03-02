data "aws_availability_zones" "available" {
  state = "available"
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "web_server"
  cidr = "10.0.0.0/16"

  azs = data.aws_availability_zones.available.names

  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  manage_default_security_group = false
  map_public_ip_on_launch       = true
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

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
