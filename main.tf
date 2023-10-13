# VPC MODULE
module "vpc" {
  source = "./modules/vpc"
  vpc_name = "thecapstone-vpc"
  vpc_description = "thecapstone vpc"
  vpc_project = var.project
  subnet_name = "${var.project}-subnet"
  subnet_ip_cidr_range = "10.10.0.0/24"
}

# GKE MODULE
# module "gke" {
#   source = "./modules/gke"
#   region = var.region
#   node_locations = ["asia-southeast2-b", "asia-southeast2-c"]
#   project = var.project
#   vpc = module.vpc.vpc_name
#   subnet = module.vpc.subnet_name
#   gke_num_nodes = 1
#   depends_on = [ module.vpc ]
# }

# Artifact Registry
resource "google_artifact_registry_repository" "registry-dev" {
  location      = "asia-southeast2"
  repository_id = "python-app-dev"
  description   = "thecapstone docker artifact registry"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}

resource "google_artifact_registry_repository" "registry-prod" {
  location      = "asia-southeast2"
  repository_id = "python-app-main"
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
