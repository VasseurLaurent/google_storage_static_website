resource "google_storage_bucket" "bucket_website" {
  name          = var.website_url
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}