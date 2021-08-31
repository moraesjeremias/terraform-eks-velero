# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.gcp_project}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.gcp_project}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

# VPC
resource "google_compute_network" "recovery_vpc" {
  name                    = "recovery-gke-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "recovery_subnet" {
  name          = "recovery-gke-subnet"
  region        = var.region
  network       = google_compute_network.recovery_vpc.name
  ip_cidr_range = "10.8.0.0/24"
}