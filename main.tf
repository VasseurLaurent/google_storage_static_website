resource "google_storage_bucket" "website_bucket" {
  name                        = var.website_url
  location                    = var.location
  storage_class               = upper(var.storage_class)
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = false

  website {
    main_page_suffix = var.main_page_suffix
    not_found_page   = var.not_found_page
  }

  dynamic "cors" {
    for_each = var.cors
    content {
      max_age_seconds = cors.value["max_age_seconds"]
      method          = cors.value["methods"]
      origin          = cors.value["origins"]
      response_header = cors.value["response_header"]
    }
  }

  dynamic "logging" {
    for_each = var.log_bucket == null && var.create_log_bucket == false ? [] : [1]
    content {
      log_bucket = var.create_log_bucket == true ? google_storage_bucket.log_bucket[0].name : var.log_bucket
    }

  }

  labels = var.labels
}

resource "google_storage_bucket" "log_bucket" {
  count                       = var.create_log_bucket ? 1 : 0
  name                        = var.log_bucket == null ? replace("${var.website_url}-logs", ".", "-") : var.log_bucket
  location                    = var.location
  storage_class               = upper(var.storage_class)
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = var.logs_retention
    }
    action {
      type = "Delete"
    }
  }

  labels = var.labels
}


resource "google_storage_default_object_acl" "default_permission" {
  count  = var.website_default_public == true ? 1 : 0
  bucket = google_storage_bucket.website_bucket.name
  role_entity = [
    "READER:allUsers",
  ]
}

resource "google_compute_global_address" "global_address" {
  name = replace("${var.website_url}-globaladdress", ".", "-")
}

resource "google_compute_backend_bucket" "backend_website" {
  name        = replace("${var.website_url}-backendwebsite", ".", "-")
  description = "Backend for website ${var.website_url}"
  bucket_name = google_storage_bucket.website_bucket.name
  enable_cdn  = true
}

resource "google_compute_url_map" "loadbalancer" {
  name            = replace("${var.website_url}-urlmap", ".", "-")
  default_service = var.enable_https == true ? null : google_compute_backend_bucket.backend_website.self_link
  host_rule {
    hosts        = [var.website_url]
    path_matcher = "defaultbackend"
  }
  path_matcher {
    name            = "defaultbackend"
    default_service = google_compute_backend_bucket.backend_website.id
  }

  dynamic "default_url_redirect" {
    for_each = var.enable_https == true ? [1] : []
    content {
      https_redirect = true
      strip_query    = false
    }
  }
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = replace("${var.website_url}-httpfrontend", ".", "-")
  url_map = google_compute_url_map.loadbalancer.self_link
}

resource "google_compute_global_forwarding_rule" "default_frontend" {
  name                  = replace("${var.website_url}-defaultfrontend", ".", "-")
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.global_address.address
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.self_link
}

resource "google_compute_managed_ssl_certificate" "certificate" {
  count = var.enable_https == true ? 1 : 0
  name  = replace("${var.website_url}-certificate", ".", "-")
  managed {
    domains = [var.website_url]
  }
}

resource "google_compute_ssl_policy" "modern-ssl-policy" {
  count           = var.enable_https == true ? 1 : 0
  name            = replace("${var.website_url}-tlspolicy", ".", "-")
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

resource "google_compute_target_https_proxy" "https_proxy" {
  count            = var.enable_https == true ? 1 : 0
  name             = replace("${var.website_url}-httpsfrontend", ".", "-")
  url_map          = google_compute_url_map.loadbalancer.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.certificate[0].self_link]
  ssl_policy       = google_compute_ssl_policy.modern-ssl-policy[0].id
}

resource "google_compute_global_forwarding_rule" "default_https_frontend" {
  count                 = var.enable_https == true ? 1 : 0
  name                  = replace("${var.website_url}-defaulthttpsfrontend", ".", "-")
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.global_address.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.https_proxy[0].self_link

}
