variable "security_group_id" {}
variable "blue_target_group_arn" {}
variable "green_target_group_arn" {}

variable "ecr_repository_url" {
  description = "ECR repository URL for the ECS task"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs where ECS tasks will run"
  type        = list(string)
}


variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN for the ECS task"
  type        = string
}

variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}



