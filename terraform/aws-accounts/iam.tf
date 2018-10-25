
// jenkins user stuff
resource "aws_iam_user" "jenkins" {
  name = "media.jenkins"
}

resource "aws_iam_access_key" "jenkins" {
  user    = "${aws_iam_user.jenkins.name}"
}

resource "aws_iam_user_policy" "base_camp_user_policy_jenkins" {
  name = "base-camp-user-policy-jenkins"
  user = "${aws_iam_user.jenkins.name}"
policy = <<HereDoc
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
HereDoc
}


// terraform user stuff
resource "aws_iam_user" "terraform" {
  name = "media.terraform"
}
resource "aws_iam_user_policy" "base_camp_user_policy_terraform" {
  name = "base-camp-user-policy-terraform"
  user = "${aws_iam_user.terraform.name}"
policy = <<HereDoc
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
HereDoc
}

resource "aws_iam_access_key" "terraform" {
  user    = "${aws_iam_user.terraform.name}"
}

