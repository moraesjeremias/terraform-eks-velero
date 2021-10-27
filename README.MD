# Velero Terraform Backup

This repo aims to provide a follow guide to Velero Kubernetes backup and recovery.

## How to Reproduce

- First sing in into your cloud provider (GCP in this repo) and ger your [credentials]("https://cloud.google.com/docs/authentication/production#automatically").

Note: It's important that your service account has enough privileges to manage GKE, GCE and GCS resources

- [Enable Compute Engine API and Kubernetes Engine API]("https://learn.hashicorp.com/tutorials/terraform/gke?in=terraform/kubernetes#provision-the-gke-cluster")

- Fill the variables in `example.tfvar`

- Follow Velero Backup/Recovery [follow guide](./velero/README.MD)

### Notes
A GCP node pool name should be less than 40 characters otherwise you'll get a `400` error
