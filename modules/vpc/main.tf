resource "google_compute_network" "vpc" {
  name = var.vpc_name
  description = var.vpc_description
  auto_create_subnetworks = false
  project = var.vpc_project
}

resource "google_compute_subnetwork" "subnet" {
  name = var.subnet_name
  description = var.subnet_name
  network = google_compute_network.vpc.name
  ip_cidr_range = var.subnet_ip_cidr_range
}