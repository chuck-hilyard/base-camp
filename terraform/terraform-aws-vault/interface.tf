
// data sources
data "aws_route53_zone" "route53_zone" {
  name = "${var.fqdn}"
}
data "aws_acm_certificate" "load_balancer_certificate" {
  domain   = "*.${var.fqdn}"
  statuses = ["ISSUED"]
}
data "aws_security_group" "default_security_group" {
  name = "chilyard-generic-sg"
  vpc_id = "${var.vpc_id}"
}
data "aws_availability_zones" "available" {}
data "template_file" "instance_profile" {
  template = <<HereDoc
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ecsInstanceRole",
      "Effect": "Allow",
      "Action": [
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:Submit*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
HereDoc
}
data "template_file" "task_definition" {
  vars {
    aws_account_number = "${var.aws_account_number}"
    aws_region         = "${var.aws_region}"
    service_name       = "${var.service_name}"
    platform           = "${var.platform}"
    environment        = "${var.environment}"
    ENVIRONMENT        = "${var.environment == "dev" ? "sandbox" : "${var.environment}" }"
    CPU                = 512
    MEMORY             = 1024
  }
  template = <<HereDoc
[
  {
    "name": "$${service_name}-$${environment}-$${platform}",
    "image": "$${aws_account_number}.dkr.ecr.$${aws_region}.amazonaws.com/$${service_name}-$${environment}-$${platform}:latest",
    "cpu": $${CPU},
    "essential": true,
    "memory": $${MEMORY},
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080,
        "protocol": "tcp"
      }
    ],
    "command": [
      "/usr/bin/java", 
			"-javaagent:/newrelic/newrelic.jar",
      "-server", 
      "-Xms256m", 
      "-Xmx1g", 
      "-jar",
      "/app.jar",
      "--spring.profiles.active=$${ENVIRONMENT}",
      "--spring.cloud.config.label=$${platform}"
    ],
	  "devices": [
      {
        "hostPath": "/rl/data/logs",
        "containerPath": "/rl/data/logs",
        "permissions": "write"
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "application_logs",
        "containerPath": "/rl/data/logs",
        "readOnly": false
      }
    ]
  }
]
HereDoc
}
data "consul_keys" "common" {
  datacenter = "${var.environment}-${var.platform}"
  key {
    name = "ADAUTH"
    path = "tf_managed/common/ADAUTH"
  }
}

// inputs
variable "fqdn" { default = "" }
variable "environment" { default = "" }
variable "platform" { default = "" }
variable "aws_region" { default = "" }
variable "aws_account_number" { default = "" }
variable "vpc_id" { default = "" }
variable "key_name" { default = "" }
variable "service_name" { default = "" }
variable "security_group" { default = "" }
variable "subnets" { default = ["subnet-a295e6c5", "subnet-63b92c2a"] }
variable "lb_subnets" { default = ["subnet-8497e4e3", "subnet-cab32683"] }
variable "on_prem_dns" { default = "" } 
variable "ecs_optimized_image_id" { default = "" }
variable "web_subnets" { default = [] }
variable "app_subnets" { default = [] }
variable "admin_subnets" { default = [] }
variable "db_subnets" { default = [] }
variable "subnet_tier" { default = "app" }
variable "enable" { default = "" }
variable "sumo_access_id" { default = "" }
variable "sumo_access_key" { default = "" }
variable "newrelic_license" { default = "" }
variable "timezone" { default = "" }

// outputs
