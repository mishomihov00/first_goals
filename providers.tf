provider "google" {
  project = var.project_id      # Your GCP project ID
  region  = var.region          # Default region for resources
  zone    = var.zone            # Default zone for resources

  credentials = file(var.credentials_file_path) # Path to your service account JSON key file
}