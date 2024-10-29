provider "aws" {
    region = "us-east-1"
}

# Fetch secret values from Secrets Manager
data "aws_secrets_manager" "my_example"{
    name="aws_creds_for_terraform"
}


data "aws_secretsmanager_secret_version" "my_latest" {
secret_id = data.aws_secrets_manager.my_example.id
}

# Parse the JSON to extract credentials
locals {
  my_creds=jsondecode(data.aws_secretsmanager_secret_version.my_latest.id)
}


provider "aws" {
    access_key = local.my_creds["AWS_ACCESS_KEY_ID"]
    secret_key = local.my_creds["AWS_SECRET_ACCESS_KEY"]
}

resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"
}

