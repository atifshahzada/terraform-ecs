resource "aws_codedeploy_app" "ecs" {
  compute_platform = "ECS"
  name             = "dummy-api-codedeploy"
}

resource "aws_codedeploy_deployment_group" "ecs" {
  app_name               = aws_codedeploy_app.ecs.name
  deployment_group_name  = "dummy-api-deployment-group"
  service_role_arn       = var.codedeploy_role_arn

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.blue_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = var.blue_target_group_name
      }

      target_group {
        name = var.green_target_group_name
      }

      prod_traffic_route {
        listener_arns = [var.alb_listener_arn]
      }
    }
  }
}

##################################################################

/*

resource "aws_codedeploy_deployment_group" "blue_green" {
  app_name               = var.app_name
  #app_name              = aws_codedeploy_app.api.name
  deployment_group_name  = "dummy-api-blue-green"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
    }
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }
}

*/

