output "securitygroup_id" {
  value = module.agent_provider.securitygroup_id
}

output "launch_template_id" {
  value = module.agent_provider.launch_template_id
}

output "asg_id" {
  value = module.agent_provider.asg_id
}
