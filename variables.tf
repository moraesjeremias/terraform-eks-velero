variable "gcp_credentials" {
  type      = string
  sensitive = true
}

variable "gcp_project" {
  type      = string
  sensitive = true
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "location" {
  default = "US"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}
