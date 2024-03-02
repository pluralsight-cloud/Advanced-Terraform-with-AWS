module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "${var.project_name}-autoscaling-group"

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]


  # Launch template
  launch_template_name        = "${var.project_name}-launch-template"
  launch_template_description = "Launch template for the project '${var.project_name}'"
  update_default_version      = true

  image_id      = data.aws_ami.this.id
  instance_type = var.instance_type

  security_groups = [module.web_server_sg.security_group_id]
  user_data       = filebase64("scripts/user-data.sh")

  target_group_arns = ["${module.alb.target_groups.web_server_target_group.arn}"]
}



module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
}
