# GKE Backup Cluster
resource "google_container_cluster" "velero_backup" {
  name                     = "velero-backup"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "velero_backup_nodes" {
  name       = "${google_container_cluster.velero_backup.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.velero_backup.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.gcp_project
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.gcp_project}-gke", google_container_cluster.velero_backup.name]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# GKE Recovery Cluster
resource "google_container_cluster" "velero_recovery" {
  name                     = "velero-recovery"
  location                 = var.alt_region
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.recovery_vpc.name
  subnetwork = google_compute_subnetwork.recovery_subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "velero_recovery_nodes" {
  name       = "${google_container_cluster.velero_recovery.name}-node-pool"
  location   = var.alt_region
  cluster    = google_container_cluster.velero_recovery.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.gcp_project
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.gcp_project}-gke", google_container_cluster.velero_recovery.name]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
