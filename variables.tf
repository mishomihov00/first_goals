variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "calcium-vector-447111-n9"
}

variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "The GCP zone to deploy resources"
  type        = string
  default     = "europe-west1-b"
}

variable "credentials_file_path" {
  description = "Path to the GCP service account JSON key file"
  type        = string
  default     = "service_acc_key.json"
}


variable "initial_node_count" {
  description = "Initial number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "node_disk_size_gb" {
  description = "The size of the disk in GB"
  type        = number
  default     = 50
}