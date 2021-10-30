output "public_ip" {
  description = "Public IP of the global address"
  value       = google_compute_global_address.global_address.address
}

output "website_bucket_name" {
  value       = google_storage_bucket.website_bucket.name
  description = "Website bucket name"
}

output "log_bucket_name" {
  value       = google_storage_bucket.log_bucket[0].name
  description = "Log bucket name"
}
