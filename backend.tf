terraform {
  backend "s3" {
    bucket         = "terraform-project-backend-s3"
    key            = "tfstate"
    region         = "us-east-1"
    dynamodb_table = "DB-lock"
  }
}
