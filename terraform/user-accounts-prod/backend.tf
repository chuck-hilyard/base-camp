terraform {
    backend "s3" {
        bucket = "terraform-backend-media-team-base-camp" 
        key = "user-accounts-prod/terraform.tfstate" 
        region = "us-west-2"  
    }
}
