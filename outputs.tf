output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "kubeconfig" {
  value = google_container_cluster.primary.endpoint
}