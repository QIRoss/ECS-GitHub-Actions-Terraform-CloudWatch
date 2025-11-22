terraform {
  backend "s3" {
    bucket         = "eloquent-ai-app-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    # profile        = "qiross"
    encrypt        = true
    dynamodb_table = "eloquent-ai-app-tfstate-lock"
  }
}