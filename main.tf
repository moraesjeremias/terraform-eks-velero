terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.81.0"
    }
  }
}

provider "google" {
  project     = var.gcp_project
  region      = var.region
  zone        = var.zone
  credentials = var.gcp_credentials
}
