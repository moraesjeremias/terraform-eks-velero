output "kubernetes_cluster_name" {
  value       = google_container_cluster.velero_backup.name
  description = "GKE Backup Cluster Name"
  sensitive   = true
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.velero_backup.endpoint
  description = "GKE Backup Cluster Host"
}

output "kubernetes_cluster_name_recovery" {
  value       = google_container_cluster.velero_recovery.name
  description = "GKE Recovery Cluster Name"
  sensitive   = true
}

output "kubernetes_cluster_host_recovery" {
  value       = google_container_cluster.velero_recovery.endpoint
  description = "GKE Recovery Cluster Host"
}

output "region" {
  value       = var.region
  description = "GCP Region"
}

output "alt_region" {
  value       = var.alt_region
  description = "GCP Region"
}