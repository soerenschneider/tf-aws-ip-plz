# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket  = "soerenschneider-terraform"
    key     = "aws-ip-plz-prod/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
