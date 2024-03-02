

resource "aws_network_interface" "web" {
  subnet_id = tolist(module.vpc.public_subnets)[0]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"

  user_data              = filebase64("${path.module}/scripts/user_data.sh")
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  subnet_id              = tolist(module.vpc.public_subnets)[0]
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


