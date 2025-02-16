variable "ecs_cluster_name" {}
variable "alb_listener_arn" {}

variable "blue_target_group_name" {
  description = "Name of the blue target group for ECS deployment"
  type        = string
}

variable "green_target_group_name" {
  description = "Name of the green target group for ECS deployment"
  type        = string
}

variable "codedeploy_role_arn" {
  description = "IAM role ARN for AWS CodeDeploy"
  type        = string
}

variable "app_name" {
  description = "Name of the CodeDeploy application"
  type        = string
}

variable "blue_service_name" {
  description = "ECS Service name for the blue deployment"
  type        = string
}

variable "green_service_name" {
  description = "ECS Service name for the green deployment"
  type        = string
}


