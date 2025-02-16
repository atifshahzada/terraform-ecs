################################################################################
# Step 1: Define API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "dummy-data-api"
  description = "API Gateway for the Dummy Data Generator"
}

# Step 2: Create a Proxy Resource for Dynamic Routing
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

# Step 3: Create ANY Method to Handle All Requests
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"  # Using Cognito for Authentication
  authorizer_id = aws_api_gateway_authorizer.auth.id
}

# Step 4: Create Cognito Authorizer
resource "aws_api_gateway_authorizer" "auth" {
  name          = "cognito-auth"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.pool.arn]
}

# Step 5: API Gateway Integration with Internet-Facing ALB
resource "aws_api_gateway_integration" "alb" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.alb.dns_name}"  # Directly using ALB DNS
  #uri                     = "http://${var.alb_dns_name}"
  connection_type         = "INTERNET"
}

# Step 6: Deploy API Gateway
resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  aws_api_gateway_stage  = "prod"
}


################################################################################
/*
resource "aws_api_gateway_rest_api" "api" {
  name        = "dummy-data-api"
  description = "API Gateway for the Dummy Data Generator"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.auth.id
}

resource "aws_api_gateway_authorizer" "auth" {
  name          = "cognito-auth"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.pool.arn]
}

resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}
*/
