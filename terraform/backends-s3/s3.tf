
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
                    "aws:SourceIp": ["34.210.37.81/32", "35.161.64.110/32", "35.165.90.83/32"]
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
                    "aws:SourceIp": ["34.210.37.81/32", "35.161.64.110/32", "35.165.90.83/32"]
                }
            },
            "Principal": "*"
        }
    ]
}
HereDoc
}

resource "aws_s3_bucket" "s3_bucket_for_terraform_stg_mainline" {
  bucket        = "terraform-backend-media-team-stg-master"
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
                "arn:aws:s3:::terraform-backend-media-team-stg-master/*"
            ],
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": ["34.210.37.81/32", "35.161.64.110/32", "35.165.90.83/32"]
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
                    "aws:SourceIp": ["13.238.238.77/32", "52.63.77.95/32", "52.65.25.10/32", "54.153.164.95/32", "54.206.93.112/32", "18.235.169.220/32", "34.239.97.199/32", "35.153.128.113/32", "50.19.198.211/32", "52.22.30.57/32", "18.185.11.136/32", "18.195.164.166/32", "18.195.87.25/32", "18.196.60.20/32", "35.156.209.89/32", "52.58.66.189/32", "34.210.208.50/32", "34.210.247.227/32", "34.215.198.187/32", "34.215.235.45/32", "34.217.221.182/32", "34.217.246.104/32", "35.155.193.78/32", "35.161.252.139/32", "35.161.98.222/32", "52.25.252.154/32", "54.71.145.162/32"]
                }
            },
            "Principal": "*"
        }
    ]
}
HereDoc
}


//MEDIA TEAM SECRETS

resource "aws_s3_bucket_public_access_block" "secrets_source_user" {
  bucket = "${aws_s3_bucket.secrets_source_user.id}"
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "secrets_source_user" {
  bucket        = "media-team-secrets-user"
  acl           = "private"
  force_destroy = false
  #logging       {}
  #region        = "us-west-2"
  replication_configuration {
    role = "${aws_iam_role.secrets_replication.arn}"
    rules {
      status = "Enabled"
      destination {
        bucket = "${aws_s3_bucket.secrets_destination_user.arn}"
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
                "arn:aws:s3:::media-team-secrets-user/*"
            ],
            "NotPrincipal": { 
              "AWS": [
                "arn:aws:iam::762858336698:role/AdminFA", 
                "arn:aws:iam::762858336698:user/media.terraform",
                "${aws_iam_user.secrets_user.arn}" 
              ]
            }
        }
    ]
}
HereDoc
}

/*
resource "aws_s3_bucket" "secrets_source_preprod" {
  bucket        = "media-team-secrets-user"
  acl           = "private"
  force_destroy = false
  #logging       {}
  #region        = "us-west-2"
  replication_configuration {
    role = "${aws_iam_role.secrets_replication.arn}"
    rules {
      status = "Enabled"
      destination {
        bucket = "${aws_s3_bucket.secrets_destination_preprod.arn}"
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
*/

/*
resource "aws_s3_bucket" "secrets_source_prod" {
  bucket        = "media-team-secrets-user"
  acl           = "private"
  force_destroy = false
  #logging       {}
  #region        = "us-west-2"
  replication_configuration {
    role = "${aws_iam_role.secrets_replication.arn}"
    rules {
      status = "Enabled"
      destination {
        bucket = "${aws_s3_bucket.secrets_destination_prod.arn}"
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
*/


resource "aws_s3_bucket" "secrets_destination_user" {
  provider      = "aws.can"
  bucket        = "media-team-secrets-user-backup"
  acl           = "private"
  force_destroy = false
  #logging       {}
  #region        = "us-east-1"
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
                "arn:aws:s3:::media-team-secrets-user-backup/*"
            ],
            "Principal": "*"
        },
        {
            "Sid": "Stmt1559834358936",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::media-team-secrets-user-backup",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::762858336698:user/media.terraform",
                    "${aws_iam_role.secrets_replication.arn}",
                    "arn:aws:iam::762858336698:role/AdminFA"
                ]
            }
        }
    ]
}
HereDoc
}

