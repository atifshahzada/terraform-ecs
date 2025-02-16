variable "region" { 
    default = "us-east-1" 
}
variable "vpc_id" {

}

variable "alb_name" {
  description = "The name of the Application Load Balancer (ALB)."
  type        = string
}
variable "security_group_id" {}

variable "ecr_repository_url" {
  description = "ECR repository URL for the ECS task"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs where ECS tasks will run"
  type        = list(string)
}

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

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "alb_listener_arn" {
  description = "ARN of the ALB listener"
  type        = string
}

/*
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
*/

