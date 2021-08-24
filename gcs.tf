resource "google_storage_bucket" "velero_bucket" {
  name          = "velero-bucket-${var.gcp_project}-gcs"
  location      = var.location
  force_destroy = true
}