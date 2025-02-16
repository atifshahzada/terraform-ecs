output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "authorizer_id" {
  description = "ID of the API Gateway Cognito Authorizer"
  value       = aws_api_gateway_authorizer.auth.id
}

