/*
* CAUTION: you probably don't need to edit anything here
*/

// backend configuration is handled via terraform wrapper
terraform {
  min_version = "0.11.3"
}

variable "aws_account_number" {
  description = "set the aws account number here"
}

variable "fqdn" {
  description = "set the subdomain where you'll be terraforming, eg \nmedia.dev.usa.reachlocalservices.com \nmedia.qa.usa.reachlocalservices.com \nmedia.stg.usa.reachlocalservices.com \nmedia.prod.can.reachlocalservices.com"
}

variable "environment" {
  description = "choose an environment {dev, qa, stg, prod}"
}

variable "platform" {
  description = "choose a platform {usa, can, jpn, aus, gbr, eur}"
}

variable "aws_region" {
  description = "choose the AWS region where you're terraforming.  **AWS access restrictions apply"
}

variable "vpc_id" {
  description = "the target vpc id where you're building"
}

variable "key_name" {
  description = "** AWS key pair - the following components require a key pair: autoscaling launch configs, elbs, and instances"
  default = "chilyard"
}

variable "aws_profile" {
  description = "the aws profile to use"
}
