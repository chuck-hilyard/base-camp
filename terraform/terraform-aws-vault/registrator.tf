
/*
* registrator - https://hub.docker.com/r/gliderlabs/registrator/
*
* everything related to registrator is contained within this file.  just drop into whichever ecs services need it
*
* TODO: change task_definition consul_cluster.id to something generic so that registrator is a drop in feature
*
* update the following names (until the todo is fixed)
* cluster
* task_definition
* desired_count
*
*/
data "template_file" "registrator_container_definition" {
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
    "name": "$${service_name}-$${environment}-$${platform}-registrator",
    "image": "gliderlabs/registrator:latest",
    "cpu": $${CPU},
    "essential": true,
    "memory": $${MEMORY},
    "mountPoints": [
      {
        "sourceVolume": "docker_api",
        "containerPath": "/tmp/docker.sock"
      }
    ],
    "command": [
      "consul://localhost:8500"
    ]
  }
]
HereDoc
}


resource "aws_ecs_task_definition" "registrator_ecs_task" {
  family                = "${var.service_name}-${var.environment}-${var.platform}-registrator"
  container_definitions = "${data.template_file.registrator_container_definition.rendered}"
  network_mode          = "host"
	volume = {
    name      = "docker_api"
		host_path = "/var/run/docker.sock"
	}
}
resource "aws_ecs_service" "registrator_ecs_service" {
  name            = "${var.service_name}-${var.environment}-${var.platform}-registrator"
  cluster         = "${aws_ecs_cluster.local_service_ads_cluster.id}"
  task_definition = "${aws_ecs_task_definition.registrator_ecs_task.arn}"
  desired_count   = "${aws_ecs_service.local_service_ads_ecs_service.desired_count}"
  placement_constraints {
    type  = "distinctInstance"
  }
}

