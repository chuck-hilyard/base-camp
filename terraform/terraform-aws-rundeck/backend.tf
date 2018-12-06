terraform {
    backend "s3" {
        bucket = "terraform-backend-media-team-base-camp" 
        key = "terraform-rundeck/terraform.tfstate" 
        region = "us-west-2"  
    }
}
