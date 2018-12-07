
/*
* CAUTION: TOP LEVEL CONFIGURATION
*
*/

provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

provider "aws" {
  region = "us-east-1"
  alias = "for_cert_use_only"
}

provider "consul" {
  address    = "consul-external.${var.fqdn}"
  scheme     = "https"
  datacenter = "${var.environment}-${var.platform}"
	version = "1.0.0"
}
