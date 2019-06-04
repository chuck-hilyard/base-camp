provider "aws" {
  region = "us-west-2"
  profile = "default"
}

provider "aws" {
  alias   = "can"
  region  = "us-east-1"
  profile = "default"
}
