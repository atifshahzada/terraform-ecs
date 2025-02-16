variable "alb_name" {
  description = "The name of the Application Load Balancer (ALB)."
  type        = string
  default     = "dummy-api-alb"
}

variable "security_group_id" {
  description = "The ID of the security group associated with the ALB."
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs where the ALB will be deployed."
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC in which the ALB will be deployed."
  type        = string
}
