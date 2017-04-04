terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key = "dual_alb/alb.tfstate"
    region = "us-east-1"
  }
}
