
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
                    "aws:SourceIp": "52.9.42.1/24"
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
                    "aws:SourceIp": "52.9.42.1/24"
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
                    "aws:SourceIp": "52.9.42.1/24"
                }
            },
            "Principal": "*"
        }
    ]
}
HereDoc
}


//MEDIA TEAM SECRETS

resource "aws_s3_bucket_public_access_block" "secrets_source" {
  bucket = "${aws_s3_bucket.secrets_source.id}"
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
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
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
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
                    "aws:SourceIp": ["52.9.42.1/24", "10.0.0.0/8"]
                }
            },
            "Principal": "*"
        },
        {
            "Sid": "Stmt1559834358936",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::media-team-secrets",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::762858336698:user/media.vault",
                    "${aws_iam_role.secrets_replication.arn}",
                    "arn:aws:iam::762858336698:role/AdminFA"
                ]
            }
        },
        {
            "Sid": "Stmt1559834358936",
            "Effect": "Deny",
            "NotPrincipal": {
                "AWS": [
                    "arn:aws:iam::762858336698:role/AdminFA",
                    "arn:aws:iam::762858336698:user/media.vault",
                    "arn:aws:iam::762858336698:role/media-team-secrets-replication",
                    "arn:aws:iam::762858336698:user/test"
                ]
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::media-team-secrets/dev/*"
        },
        {
            "Sid": "Stmt1559834358937",
            "Effect": "Deny",
            "NotPrincipal": {
                "AWS": [
                    "arn:aws:iam::762858336698:role/AdminFA",
                    "arn:aws:iam::762858336698:user/media.vault",
                    "arn:aws:iam::762858336698:role/media-team-secrets-replication",
                    "arn:aws:iam::762858336698:user/test"
                ]
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::media-team-secrets/qa/*"
        },
        {
            "Sid": "Stmt1559834358938",
            "Effect": "Deny",
            "NotPrincipal": {
                "AWS": [
                    "arn:aws:iam::762858336698:role/AdminFA",
                    "arn:aws:iam::762858336698:user/media.vault",
                    "arn:aws:iam::762858336698:role/media-team-secrets-replication",
                    "arn:aws:iam::762858336698:user/test"
                ]
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::media-team-secrets/prod/*"
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
                    "aws:SourceIp": "52.9.42.1/24"
                }
            },
            "Principal": "*"
        },
        {
            "Sid": "Stmt1559834358936",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::media-team-secrets-backup",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::762858336698:user/media.vault",
                    "${aws_iam_role.secrets_replication.arn}",
                    "arn:aws:iam::762858336698:role/AdminFA"
                ]
            }
        }
    ]
}
HereDoc
}


