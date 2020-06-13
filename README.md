# Description

This terraform module provisions Ubuntu Azure Devops Build agents in AWS.

It preinstalls dotnet-sdk, kubectl and docker.

Using the variables, you are able to change various configuration parameters.

```
variable "vpc_id" {
  description = "VPC id for the instances"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "List of cidr blocks for SSH access to the build agents"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "subnet_ids" {
  description = "List of cidr blocks for SSH access to the build agents"
  type        = list
}


variable "ami_id" {
  type        = string
  description = "ami id for the build agents"
  default     = "ami-0e342d72b12109f91"
}

variable "azuredevops_url" {
  type        = string
  description = "Azure devops url for your organisation"
}

variable "azuredevops_token" {
  type        = string
  description = "Azure devops personal access token for agent registration"
}

variable "azuredevops_pool" {
  type        = string
  description = "Azure devops pool name for the agents"
}

variable "dotnet_sdk_version" {
  type        = string
  description = "Dotnet sdk version to be pre-installed into the agents"
  default     = "3.1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "ebs_size" {
  type        = number
  description = "EBS size in GB for agent instances"
  default     = 32
}

variable "key_name" {
  type        = string
  description = "Key-Pair name for access into the agent instances"
}

variable "asg_max_size" {
  type        = number
  description = "Maximum size for ASG"
  default     = 1
}

variable "asg_min_size" {
  type        = number
  description = "Minimum size for ASG"
  default     = 1
}

variable "asg_desired_size" {
  type        = number
  description = "Desired size for ASG"
  default     = 1
}

```

You can check example folder for a sample usage.

Please check Microsoft Docs (https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops) for instructions that needs to be followed on Azure Devops part.
