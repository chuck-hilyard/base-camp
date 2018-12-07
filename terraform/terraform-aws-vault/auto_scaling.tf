resource "aws_autoscaling_group" "local_service_ads_asg" {
  name = "${var.service_name}-${var.environment}-${var.platform}"
  min_size = 1
  max_size = 1
  desired_capacity = 1
  launch_configuration = "${aws_launch_configuration.terraform_launch_configuration.name}"
  vpc_zone_identifier = ["${var.app_subnets}"]
  load_balancers = ["${var.service_name}-${var.environment}-${var.platform}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.service_name}-${var.environment}-${var.platform}"
    propagate_at_launch = true
  }

}

