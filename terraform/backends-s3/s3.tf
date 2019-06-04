
resource "aws_s3_bucket" "s3_bucket_for_terraform_dev_mainline" {
  bucket        = "terraform-backend-media-team-dev-master"
  acl           = "private"
  force_destroy = false
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
            "Effect": "Deny",
            "Resource": [
              "arn:aws:s3:::terraform-backend-media-team-dev-master/*"
            ],
            "Principal": {
              "AWS": [
                "*"
              ]
            },
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": "35.165.90.83/24"
                }
            }
        }
    ]
}
HereDoc
}

resource "aws_s3_bucket" "s3_bucket_for_terraform_qa_mainline" {
  bucket        = "terraform-backend-media-team-qa-master"
  acl           = "private"
  force_destroy = false
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
            "Effect": "Deny",
            "Resource": [
                "arn:aws:s3:::terraform-backend-media-team-qa-master/*"
            ],
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": "35.165.90.83/24"
                }
            },
            "Principal": "*"
        }
    ]
}
HereDoc
}

resource "aws_s3_bucket" "s3_bucket_for_terraform_prod_mainline" {
  bucket        = "terraform-backend-media-team-prod-master"
  acl           = "private"
  force_destroy = false
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
            "Effect": "Deny",
            "Resource": [
                "arn:aws:s3:::terraform-backend-media-team-prod-master/*"
            ],
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": "35.165.90.83/24"
                }
            },
            "Principal": "*"
        }
    ]
}
HereDoc
}

resource "aws_s3_bucket" "secrets_source" {
  bucket        = "media-team-secrets"
  acl           = "private"
  force_destroy = false
  #logging       {}
  region        = "us-west-2"
  replication_configuration {
    role = "${aws_iam_role.secrets_replication.arn}"
    rules {
      status = "Enabled"
      destination {
        bucket = "${aws_s3_bucket.secrets_destination.arn}"
      }
    }
  }
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
            "Effect": "Deny",
            "Resource": [
                "arn:aws:s3:::media-team-secrets/*"
            ],
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": "35.165.90.83/24"
                }
            },
            "Principal": "*"
        }
    ]
}
HereDoc
}


resource "aws_s3_bucket" "secrets_destination" {
  provider      = "aws.can"
  bucket        = "media-team-secrets-backup"
  acl           = "private"
  force_destroy = false
  #logging       {}
  region        = "us-east-1"
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
            "Effect": "Deny",
            "Resource": [
                "arn:aws:s3:::media-team-secrets-backup/*"
            ],
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": "35.165.90.83/24"
                }
            },
            "Principal": "*"
        }
    ]
}
HereDoc
}


