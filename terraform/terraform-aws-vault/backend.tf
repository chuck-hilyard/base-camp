terraform {
    backend "s3" {
        bucket = "terraform-backend-media-team-base-camp" 
        key = "terraform-aws-vault/terraform.tfstate" 
        region = "us-west-2"  
    }
}
