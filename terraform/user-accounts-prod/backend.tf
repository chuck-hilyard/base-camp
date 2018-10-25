terraform {
    backend "s3" {
        bucket = "terraform-backend-media-team-base-camp" 
        key = "aws-accounts/terraform.tfstate" 
        region = "us-west-2"  
    }
}
