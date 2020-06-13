resource "aws_security_group" "agent_sg" {
  name        = "azure_devops_agent_sg"
  description = "Allow traffic for activemq"
  vpc_id      = var.vpc_id

  # ingress {
  #     description = "TCP 61617"
  #     from_port = 0
  #     to_port = 65535
  #     protocol = "tcp"
  #     cidr_blocks = "${var.ingress_cidr_blocks}"
  # }

  # ingress {
  #     description = "TCP 8162"
  #     from_port = 8162
  #     to_port = 8162
  #     protocol = "tcp"
  #     cidr_blocks = "${var.ingress_cidr_blocks}"
  # }

  ingress {
    description = "TCP 22 (SSH)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
    # cidr_blocks = "${var.ssh_cidr_blocks}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "azure_devops_agent_sg"
  }
}

resource "aws_launch_template" "agent_lt" {
  name_prefix = "azure_devops_agent_lt"
  # image_id      = "ami-0bad2b43a871348da"
  image_id      = var.ami_id
  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.ebs_size
    }
  }
  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.agent_sg.id}"]

  user_data = base64encode(templatefile("${path.module}/bootstrap.sh", { url = "${var.azuredevops_url}", token = "${var.azuredevops_token}", pool = "${var.azuredevops_pool}", dotnet_sdk_version = "${var.dotnet_sdk_version}" }))
}

resource "aws_autoscaling_group" "agent_asg" {
  name                      = "azure_devops_agent_asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.asg_desired_size
  force_delete              = false
  vpc_zone_identifier       = var.subnet_ids

  launch_template {
    id      = aws_launch_template.agent_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Azure Devops Build Agent"
    propagate_at_launch = true
  }
}
