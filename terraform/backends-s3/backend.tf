terraform {
    backend "s3" {
        bucket = "terraform-backend-media-team-base-camp" 
        key = "backends-s3/terraform.tfstate" 
        region = "us-west-2"  
    }
}
