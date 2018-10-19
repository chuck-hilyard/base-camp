resource "aws_s3_bucket" "artifact_repository" {
  bucket        = "terraform-backend-media-team-dev-master"
  acl           = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  policy = <<HereDoc
{
    "Id": "Policy1539969783840",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1539969782489",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::terraform-backend-media-team-dev-master",
                "arn:aws:s3:::terraform-backend-media-team-dev-master/*"
            ],
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": "10.10.30.0"
                }
            },
            "Principal": "*"
        }
    ]
}
HereDoc
}
