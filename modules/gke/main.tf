data "google_container_engine_versions" "gke_version" {
  location = var.region
  version_prefix = "1.27."
}

resource "google_service_account" "sa" {
  account_id   = "gke-read-from-acr"
  display_name = "GKE Read From ACR"
}

resource "google_project_iam_member" "allow_image_pull" {
  project = var.project
  role   = "roles/artifactregistry.admin"
  member = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_container_cluster" "primary-cluster" {
  name = "${var.project}-gke"
  location = var.region
  remove_default_node_pool = true
  initial_node_count = 1
  network = var.vpc
  subnetwork = var.subnet
  deletion_protection = false
  node_config {
    disk_size_gb = 10
  }
}

resource "google_container_node_pool" "primary-nodes" {
  name = google_container_cluster.primary-cluster.name
  location = var.region
  node_locations = var.node_locations
  cluster = google_container_cluster.primary-cluster.name

  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = var.gke_num_nodes

  node_config {
    service_account = google_service_account.sa.email 
    oauth_scopes = [
      "default"
    ]

    machine_type = "n1-standard-1"
    disk_size_gb = 10
    disk_type = "pd-standard"
    tags = ["gke-node", "${var.project}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
