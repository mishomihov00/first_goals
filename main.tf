resource "google_project_service" "cloudtrace" {
  project = var.project_id
  service = "cloudtrace.googleapis.com"
}

resource "google_project_service" "monitoring" {
  project = var.project_id
  service = "monitoring.googleapis.com"
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

resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "DevOps Email Channel"
  type         = "email"

  labels = {
    email_address = "mihail.mihov@limechain.tech"
  }
}

resource "google_monitoring_alert_policy" "high_cpu" {
  display_name = "High CPU Alert (GKE Containers)"
  combiner     = "OR"   # You can use AND if you want multiple conditions combined
  enabled      = true
  user_labels = {
    environment = "production"
  }

  # Tells GCP which channels to notify
  notification_channels = [
    google_monitoring_notification_channel.email_channel.id
  ]

  conditions {
    display_name = "High CPU usage"

    condition_threshold {
      # This filter checks the CPU metric for containers running in Kubernetes
      # Specifically k8s_container with 'core_usage_time' or 'usage_time' metric
      filter          = "metric.type=\"kubernetes.io/container/cpu/core_usage_time\" resource.type=\"k8s_container\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8   # 80% usage
      duration        = "60s" # Must exceed 80% for 1 minute
      trigger {
        count = 1  # How many time series must exceed the threshold to trigger
      }

      # Aggregation settings
      aggregations {
        alignment_period    = "60s"
        per_series_aligner  = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }
}