output "securitygroup_id" {
  value = aws_security_group.agent_sg.id
}

output "launch_template_id" {
  value = aws_launch_template.agent_lt.id
}

output "asg_id" {
  value = aws_autoscaling_group.agent_asg.id
}
