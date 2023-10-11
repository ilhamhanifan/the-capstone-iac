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

