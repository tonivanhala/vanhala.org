terraform {
  backend "gcs" {
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.24.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

locals {
  domain = var.domain
}

module "dns" {
  source     = "./dns"
  domain     = local.domain
  lb-address = module.lb.ip-address
}

module "lb" {
  source         = "./lb"
  backend-bucket = module.storage.bucket-name
  domain         = local.domain
}

module "storage" {
  source   = "./storage"
  location = "EU"
}
