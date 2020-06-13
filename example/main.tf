provider "aws" {
  region = "eu-central-1"
}

module "agent_provider" {
  source = "../"

  vpc_id             = "vpc-id"
  subnet_ids         = ["subnet-a", "subnet-b", "subnet-c"]
  azuredevops_url    = "https://dev.azure.com/your_organisation"
  azuredevops_token  = "token"
  azuredevops_pool   = "pool_name"
  key_name           = "aws_key_name"
  instance_type      = "t3.small"
  asg_max_size       = 2
  asg_min_size       = 2
  asg_desired_size   = 2
  dotnet_sdk_version = "2.2"
}
