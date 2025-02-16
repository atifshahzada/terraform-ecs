module "alb" {
  source             = "./modules/alb"
  vpc_id            = var.vpc_id
  subnets    = var.subnets
  security_group_id = module.alb_sg.security_group_id
}

module "ecs" {
  source              = "./modules/ecs"
  subnets             = var.subnets                     # must use private subnet here [for demo pupose using public subnet]
  security_group_id   = module.ecs_sg.security_group_id
  blue_target_group_arn = module.alb.blue_target_group_arn
  green_target_group_arn = module.alb.green_target_group_arn
  ecr_repository_url  = var.ecr_repository_url
  execution_role_arn  = var.execution_role_arn
  task_role_arn       = var.task_role_arn
  cluster_id          = var.cluster_id
}

module "api_gateway" {
  source        = "./modules/api_gateway"
  api_name      = "dummy-data-api"  # Add the missing argument
  authorizer_id = module.cognito.authorizer_id  # Ensure Cognito module exists
  #alb_dns_name  = module.alb.alb_dns_name  # Ensure this variable is actually needed
}

module "cognito" {
  source      = "./modules/cognito"
  pool_name   = "dummy-api-user-pool"  # Required argument
  client_name = "dummy-api-client"     # Required argument
}

/*
module "code_deploy" {
  source                 = "./modules/code_deploy"
  ecs_cluster_name       = module.ecs.ecs_cluster_id
  ecs_service_name_blue  = module.ecs.blue_service_name
  ecs_service_name_green = module.ecs.green_service_name
  blue_target_group_arn  = module.alb.blue_target_group_arn
  green_target_group_arn = module.alb.green_target_group_arn
  alb_listener_arn       = module.alb.alb_listener_arn
}
*/
/*
module "code_deploy" {
  source                 = "./modules/code_deploy"
  ecs_cluster_name       = var.ecs_cluster_name
  alb_listener_arn       = var.alb_listener_arn
  blue_target_group_name = var.blue_target_group_name
  green_target_group_name = var.green_target_group_name
  codedeploy_role_arn    = var.codedeploy_role_arn
  app_name               = var.app_name
  blue_service_name      = var.blue_service_name
  green_service_name     = var.green_service_name
}
*/

module "code_deploy" {
  source                 = "./modules/code_deploy"
  ecs_cluster_name       = module.ecs.ecs_cluster_name
  alb_listener_arn       = module.alb.alb_listener_arn
  blue_target_group_name = module.alb.blue_target_group_name
  green_target_group_name = module.alb.green_target_group_name
  codedeploy_role_arn    = var.codedeploy_role_arn
  app_name               = var.app_name
  blue_service_name      = module.ecs.dummy-api-blue
  green_service_name     = module.ecs.dummy-api-green
}




