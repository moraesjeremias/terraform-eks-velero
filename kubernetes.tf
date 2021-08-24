data "digitalocean_kubernetes_versions" "do_kubernetes_version" {
  version_prefix = "1.21."
}

resource "digitalocean_kubernetes_cluster" "velero_backup_cluster" {
  name         = "velero-backup-cluster"
  region       = "nyc1"
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.do_kubernetes_version.latest_version

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = "default"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 3
    max_nodes  = 5
  }

  tags = ["velero-backup-cluster"]

}

resource "digitalocean_kubernetes_cluster" "velero_recovery_cluster" {
  name         = "velero-recovery-cluster"
  region       = "nyc1"
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.do_kubernetes_version.latest_version

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = "default"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 3
    max_nodes  = 5
  }

  tags = ["velero_recovery_cluster"]

}
