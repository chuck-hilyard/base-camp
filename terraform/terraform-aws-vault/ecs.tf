
resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.service_name}-${var.environment}-${var.platform}"
}

resource "aws_ecs_cluster" "local_service_ads_cluster" {
 name = "${var.service_name}-${var.environment}-${var.platform}"
}

resource "aws_ecs_task_definition" "local_service_ads_ecs_task" {
  family                = "${var.service_name}-${var.environment}-${var.platform}"
  container_definitions = "${data.template_file.task_definition.rendered}"
  network_mode          = "host"
	volume = {
    name      = "application_logs"
    host_path = "/rl/data/logs"
   }
}

resource "aws_ecs_service" "local_service_ads_ecs_service" {
  name            = "${var.service_name}-${var.environment}-${var.platform}"
  cluster         = "${aws_ecs_cluster.local_service_ads_cluster.id}"
  task_definition = "${aws_ecs_task_definition.local_service_ads_ecs_task.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_access_role.arn}"
  load_balancer {
    elb_name = "${aws_elb.terraform_elb.id}"
    container_name   = "${var.service_name}-${var.environment}-${var.platform}"
    container_port   = "8080"
  }

  depends_on = [
    "aws_elb.terraform_elb"
  ]
}
