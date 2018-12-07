
// external elb
resource "aws_elb" "terraform_elb" {
  name = "${var.service_name}-${var.environment}-${var.platform}"
  internal = "false"
  // these are "web" subnets
  subnets = ["${var.web_subnets}"]
  security_groups = ["${data.aws_security_group.default_security_group.id}"]

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.load_balancer_certificate.arn}"
  }

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.load_balancer_certificate.arn}"
  }

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:8080"
    interval = 30
  }

  tags {
    Name = "${var.service_name}-${var.environment}-${var.platform}"
  }

}
