output registry-sa-key {
  value = google_service_account_key.registry-sa-key.private_key
  sensitive = true
}
