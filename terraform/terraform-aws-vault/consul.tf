
/*
* consul - https://hub.docker.com/_/consul/
*
* everything related to consul is contained within this file.  just drop into whichever ecs services need it
*
* TODO: change task_definition consul_cluster.id to something generic so that consul is a drop in feature
*
* update the following names (until the todo is fixed)
* cluster
* task_definition
* desired_count
*
*/
data "template_file" "consul_container_definition" {
  vars {
    aws_account_number  = "${var.aws_account_number}"
    aws_region          = "${var.aws_region}"
    service_name        = "${var.service_name}"
    platform            = "${var.platform}"
    environment         = "${var.environment}"
    ENVIRONMENT         = "${var.environment == "dev" ? "sandbox" : "${var.environment}" }"
    CPU                 = 256
    MEMORY              = 512
 }
  template = <<HereDoc
[
  {
    "name": "$${service_name}-$${environment}-$${platform}-consul",
    "image": "consul:latest",
    "cpu": $${CPU},
    "essential": true,
    "memory": $${MEMORY},
		"command": [
		  "consul",
		  "agent",
			"-join",
			"consul",
			"-bind",
			"{{ GetInterfaceIP \"eth0\" }}",
			"-datacenter",
      "$${environment}-$${platform}",
			"-data-dir",
      "/consul/data"
		]
  }
]
HereDoc
}


resource "aws_ecs_task_definition" "consul_ecs_task" {
  family                = "${var.service_name}-${var.environment}-${var.platform}-consul"
  container_definitions = "${data.template_file.consul_container_definition.rendered}"
  network_mode          = "host"
}
resource "aws_ecs_service" "consul_ecs_service" {
  name            = "${var.service_name}-${var.environment}-${var.platform}-consul"
  cluster         = "${aws_ecs_cluster.local_service_ads_cluster.id}"
  task_definition = "${aws_ecs_task_definition.consul_ecs_task.arn}"
  desired_count   = "${aws_ecs_service.local_service_ads_ecs_service.desired_count}"
  placement_constraints {
    type  = "distinctInstance"
  }
}

