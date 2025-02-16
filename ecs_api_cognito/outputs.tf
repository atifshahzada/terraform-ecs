output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecs_cluster_id" {
  value = module.ecs.ecs_cluster_id
}

output "api_gateway_id" {
  value = module.api_gateway.api_gateway_id
}
