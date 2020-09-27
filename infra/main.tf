terraform {
  backend "s3" {
    bucket = "vanhalaorg"
    key = "terraform-state/terraform.tfstate"
    region = "eu-north-1"
    encrypt = true
    dynamodb_table = "VanhalaOrgTerraformStateLock" # must contain primary key named LockID
  }
}

variable region {}

provider "aws" {
  region = var.region
}
