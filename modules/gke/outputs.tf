output "gke_cluster_name" {
  value = google_container_cluster.primary-cluster.name
}

output "gke_cluster_host" {
  value = google_container_cluster.primary-cluster.endpoint
}