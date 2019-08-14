#arn:aws:iam::762858336698:role/service-role/s3crr_role_for_media-team-secrets_to_media-team-secrets-backup
#resource "aws_iam_service_linked_role" "secrets_replication_service_linked_role" {
#  description      = "media-team-secrets-replication-service-role"
#  aws_service_name = "s3.amazonaws.com"
#  #aws_service_name = "elasticbeanstalk.amazonaws.com"
#}

resource "aws_iam_role" "secrets_replication" {
  name = "media-team-secrets-replication"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy" "secrets_replication" { 
  name = "media-team-secrets-replication"
  path = "/"
  policy = <<HereDoc
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::media-team-secrets",
                "arn:aws:s3:::media-team-secrets/*"
            ]
        },
        {
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags",
                "s3:GetObjectVersionTagging"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::media-team-secrets-backup/*"
        }
    ]
}
HereDoc
}

resource "aws_iam_user" "secrets_user" {
  name = "media.secrets.user"
}

resource "aws_iam_access_key" "secrets_user" {
  user   = "${aws_iam_user.secrets_user.name}" 
}

resource "aws_iam_user_policy" "secrets_user" {
  name   = "${aws_iam_user.secrets_user.name}"
  user   = "${aws_iam_user.secrets_user.name}"
  policy = <<HereDoc 
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.secrets_source_user.arn}"
    }
  ]
}
HereDoc
}
