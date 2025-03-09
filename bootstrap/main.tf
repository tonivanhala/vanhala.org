terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.24.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.1"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
  zone = var.zone
}

resource "random_id" "bucket-prefix" {
  byte_length = 8
  keepers = {
    project = var.project
  }
}

resource "google_storage_bucket" "state-bucket" {
  name          = "${random_id.bucket-prefix.hex}-tfstate"
  location      = "EU"
  force_destroy = true
  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"
  uniform_bucket_level_access = true
}
