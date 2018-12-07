
/*
* everything related to sumologic is contained within this file.  just drop into which ecs services need it
*
* TODO: change task_definition consul_cluster.id to something generic so that sumologic is a drop in feature
*
* update the following names (until the todo is fixed)
* cluster
* task_definition
* desired_count
*
*/
data "template_file" "sumocollector_container_definition" {
  vars {
    aws_account_number  = "${var.aws_account_number}"
    aws_region          = "${var.aws_region}"
    service_name        = "${var.service_name}"
    platform            = "${var.platform}"
    environment         = "${var.environment}"
    ENVIRONMENT         = "${var.environment == "dev" ? "sandbox" : "${var.environment}" }"
    SUMO_ACCESS_ID      = "${var.sumo_access_id}"
    SUMO_ACCESS_KEY     = "${var.sumo_access_key}"
    SUMO_COLLECTOR_NAME = "${var.service_name}"
    CPU                 = 256
    MEMORY              = 512
 }
  template = <<HereDoc
[
  {
    "name": "$${service_name}-$${environment}-$${platform}-sumologic",
    "image": "sumologic/collector:latest-file",
    "cpu": $${CPU},
    "essential": true,
    "memory": $${MEMORY},
    "mountPoints": [
      {
        "sourceVolume": "application_logs",
        "containerPath": "/tmp/clogs",
        "readOnly": true
      }
    ],
    "environment": [
      { "name": "SUMO_COLLECTOR_NAME_PREFIX", "value": "rl/$${environment}/$${platform}/$${service_name}-" }
    ],
    "command": [
      "$${SUMO_ACCESS_ID}",
      "$${SUMO_ACCESS_KEY}"
    ]
  }
]
HereDoc
}


resource "aws_ecs_task_definition" "sumocollector_ecs_task" {
  family                = "${var.service_name}-${var.environment}-${var.platform}-sumologic"
  container_definitions = "${data.template_file.sumocollector_container_definition.rendered}"
  network_mode          = "host"
  volume      = {
    name      = "application_logs"
    host_path = "/rl/data/logs"
  }
}
resource "aws_ecs_service" "sumocollector_ecs_service" {
  name            = "${var.service_name}-${var.environment}-${var.platform}-sumologic"
  cluster         = "${aws_ecs_cluster.local_service_ads_cluster.id}"
  task_definition = "${aws_ecs_task_definition.sumocollector_ecs_task.arn}"
  desired_count   = "${aws_ecs_service.local_service_ads_ecs_service.desired_count}"
  placement_constraints {
    type  = "distinctInstance"
  }
}

