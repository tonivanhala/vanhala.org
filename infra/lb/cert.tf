resource "google_compute_managed_ssl_certificate" "website" {
  name        = "website-ssl-cert"
  managed {
    domains = [var.domain]
  }
}