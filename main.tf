# Artifact Registry
resource "google_artifact_registry_repository" "registry" {
  location      = "asia-southeast2"
  repository_id = "python-app"
  description   = "thecapstone docker artifact registry"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}

# Push Image to Artifact Registry Service Account
resource "google_service_account" "registry-sa" {
  account_id = "push-registry"
}

resource "google_service_account_key" "registry-sa-key" {
  service_account_id = google_service_account.registry-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "registry-sa-member" {
  project = var.project
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.registry-sa.email}"
}
