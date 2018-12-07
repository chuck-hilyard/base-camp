/*
*
* SECURITY
*
*/
/*
*resource "aws_security_group" "local_service_security_group" {
*  description = "controls direct access to local-service-ads"
*  vpc_id      = "${var.vpc_id}"
*  name        = "local-service-ads-cluster-${var.subnet_tier}-${var.environment}-${var.platform}"
*  revoke_rules_on_delete = true
*
*  ingress {
*    protocol  = "tcp"
*    from_port = 22
*    to_port   = 22
*
*    cidr_blocks = [
*      "${var.admin_cidr_ingress}",
*    ]
*  }
*
*  ingress {
*    protocol  = "tcp"
*    from_port = 8080
*    to_port   = 8080
*
*    #security_groups = [
*    #  "${aws_security_group.lb_sg.id}",
*    #]
*  }
*
*  egress {
*    from_port   = 0
*    to_port     = 0
*    protocol    = "-1"
*    cidr_blocks = ["0.0.0.0/0"]
*  }
*}
*/

/*
*resource "aws_security_group" "lb_sg" {
*  description = "controls access to the application ELB"
*  vpc_id = "${aws_vpc.main.id}"
*  name   = "tf-ecs-lbsg"
*  revoke_rules_on_delete = true
*
*  ingress {
*    protocol    = "tcp"
*    from_port   = 8080
*    to_port     = 8080
*    cidr_blocks = ["0.0.0.0/0"]
*  }
*
*  egress {
*    from_port = 0
*    to_port   = 0
*    protocol  = "-1"
*
*    cidr_blocks = [
*      "0.0.0.0/0",
*    ]
*  }
*}
*/

/*
*resource "aws_security_group" "instance_sg" {
*  description = "controls direct access to application instances"
*  vpc_id      = "${aws_vpc.main.id}"
*  name        = "local-service-ads-cluster-${var.subnet_tier}-${var.environment}-${var.platform}"
*
*  ingress {
*    protocol  = "tcp"
*    from_port = 22
*    to_port   = 22
*
*    cidr_blocks = [
*      "${var.admin_cidr_ingress}",
*    ]
*  }
*
*  ingress {
*    protocol  = "tcp"
*    from_port = 8080
*    to_port   = 8080
*
*    security_groups = [
*      "${aws_security_group.lb_sg.id}",
*    ]
*  }
*
*  egress {
*    from_port   = 0
*    to_port     = 0
*    protocol    = "-1"
*    cidr_blocks = ["0.0.0.0/0"]
*  }
*}
*/
