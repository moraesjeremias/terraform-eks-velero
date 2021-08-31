gcp_project     = "gcp_project_name"
gcp_credentials = "/path/to/service-account.json"
region          = "us-central1"
zone            = "us-central1-c"
# you may find useful deploying a second kubernetes cluster in other region 
# in order not to request service quota increase for a certain region.
# Use an alternative region and zone instead.
alt_region    = "us-east1"
alt_zone      = "us-east1-a"
gke_num_nodes = 10