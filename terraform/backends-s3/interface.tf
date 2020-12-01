
// inputs
variable "fqdn" { default = "" }
variable "environment" { default = "dev" }
variable "platform" { default = "usa" }
variable "aws_region" { default = "us-west-2" }
variable "vpc_id" { default = "vpc-e9be9a8e" }
variable "key_name" { default = "chilyard" }
variable "service_name" { default = "" }
variable "security_group" { default = "" }
variable "aws_account_number" { default = "762858336698" }
variable "subnet_tier" { default = "" }
variable "subnets" { default = [] }
variable "on_prem_dns" { default = "" }
variable "ecs_optimized_image_id" { default = "" }
variable "web_subnets" { default = [] }
variable "app_subnets" { default = [] }
variable "admin_subnets" { default = [] }
variable "db_subnets" { default = [] }
variable "enable" { default = "" }
variable "sumo_access_id" { default = "" }
variable "sumo_access_key" { default = "" }
variable "newrelic_license" { default = "" }

