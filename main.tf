resource "google_project_service" "cloudtrace" {
  project = var.project_id
  service = "cloudtrace.googleapis.com"
}

resource "google_container_cluster" "primary" {
  name     = "microservices-demo-cluster"
  location = var.zone
  deletion_protection = false

  # Define the node pool
  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    disk_size_gb = var.node_disk_size_gb
  }

  cluster_autoscaling {
    enabled = true
    
    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 10
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 2
      maximum       = 20
    }
  }

  initial_node_count = var.initial_node_count
  ip_allocation_policy {}
}