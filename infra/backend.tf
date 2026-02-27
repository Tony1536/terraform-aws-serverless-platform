terraform {
  backend "s3" {
    bucket         = "serverless-platform-dev-tfstate"
    key            = "serverless-platform/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "serverless-platform-dev-tflock"
    encrypt        = true
  }
}