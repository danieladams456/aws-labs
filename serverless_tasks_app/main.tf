terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key = "serverless_tasks_app/main.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
