
resource "aws_s3_bucket" "codepipeline_release_artifacts" {
  count         = "${var.enable == "true" ? 1 : 0}"
  bucket        = "artifacts-${var.service_name}-release"
  acl           = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  policy = <<HereDoc
{
    "Id": "Policy1511988397119",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1511988395219",
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": [ "arn:aws:s3:::artifacts-${var.service_name}-release", "arn:aws:s3:::artifacts-${var.service_name}-release/*" ],
            "Principal": {
                "AWS": [
                     "arn:aws:iam::762858336698:role/JenkinsAccess"
                ]
            }
        }
    ]
}
HereDoc
}
