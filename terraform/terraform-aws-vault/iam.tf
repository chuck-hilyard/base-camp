

// ACCESS ROLE
resource "aws_iam_role" "launch_config_access_role" {
  name = "${var.service_name}-${var.environment}-${var.platform}-launch-config-access-role"
  assume_role_policy = <<HereDoc
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
HereDoc
}

resource "aws_iam_role" "ecs_access_role" {
  name = "${var.service_name}-${var.environment}-${var.platform}-ecs-access-role"
  assume_role_policy = <<HereDoc
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
HereDoc
}


// ACCESS POLICY
resource "aws_iam_role_policy" "launch_config_access_policy" {
  name = "${var.service_name}-${var.environment}-${var.platform}-launch-config-access-policy"
  role = "${aws_iam_role.launch_config_access_role.name}"
  policy = <<HereDoc
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Resource": "*"
    }
  ]
}
HereDoc
}

// ECS SERVICE ACCESS POLICY
resource "aws_iam_role_policy" "ecs_service_access_policy" {
  name = "${var.service_name}-${var.environment}-${var.platform}-ecs-service-access-policy"
  role = "${aws_iam_role.ecs_access_role.name}"
  policy = <<HereDoc
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:*"
      ],
      "Resource": "*"
    }
  ]
}
HereDoc
}


// INSTANCE PROFILE
resource "aws_iam_instance_profile" "launch_config_instance_profile" {
  name = "${var.service_name}-${var.environment}-${var.platform}-launch-config-instance-profile"
  role = "${aws_iam_role.launch_config_access_role.name}"
}

resource "aws_iam_instance_profile" "ecs_service_instance_profile" {
  name = "${var.service_name}-${var.environment}-${var.platform}-ecs-instance-profile"
  role = "${aws_iam_role.ecs_access_role.name}"
}

// POLICY ATTACHMENTS
resource "aws_iam_role_policy_attachment" "launch_config_policy_attachment" {
  role       = "${aws_iam_role.launch_config_access_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_service_policy_attachment" {
  role       = "${aws_iam_role.ecs_access_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_ecr_repository_policy" "docker_repo_permissions" {
  repository = "${aws_ecr_repository.ecr_repo.name}"
  policy = <<HereDoc
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "new statement",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
    }
  ]
}
HereDoc
}
