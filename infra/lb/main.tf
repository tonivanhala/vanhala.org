resource "google_compute_global_address" "website" {
  name = "website-ip-address"
}

resource "google_compute_backend_bucket" "website" {
  name        = "website-backend-bucket"
  bucket_name = var.backend-bucket
}

resource "google_compute_url_map" "website" {
    name            = "website-url-map"
    default_service = google_compute_backend_bucket.website.self_link
}

resource "google_compute_target_https_proxy" "website" {
  name             = "website-target-https-proxy"
  url_map          = google_compute_url_map.website.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.website.self_link]
}

resource "google_compute_global_forwarding_rule" "website" {
  name       = "website-global-forwarding-rule"
  target     = google_compute_target_https_proxy.website.self_link
  port_range = "443"
  ip_address = google_compute_global_address.website.address
}

