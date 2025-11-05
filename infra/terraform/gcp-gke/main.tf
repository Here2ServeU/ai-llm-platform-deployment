
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.43" }
  }
}
provider "google" {
  project = var.project
  region  = var.region
}

resource "google_container_cluster" "gke" {
  name     = var.name
  location = var.region
  removal_policy = "ABANDON"
  initial_node_count = 1
  min_master_version = var.kubernetes_version
  node_config {
    machine_type = "e2-standard-4"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

output "kubeconfig" {
  value = "gcloud container clusters get-credentials ${var.name} --region ${var.region} --project ${var.project}"
}
