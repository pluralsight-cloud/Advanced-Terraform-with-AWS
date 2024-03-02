module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${var.project_name}-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "web_server_target_group"
      }
    }
  }

  target_groups = {
    web_server_target_group = {
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = true
      create_attachment                 = false
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}
