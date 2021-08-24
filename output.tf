output "kubernetes_cluster_name" {
  value       = google_container_cluster.velero_backup.name
  description = "GKE Cluster Name"
  sensitive   = true
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.velero_backup.endpoint
  description = "GKE Cluster Host"
}

output "region" {
  value       = var.region
  description = "GCP Region"
}
