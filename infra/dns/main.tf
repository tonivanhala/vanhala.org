locals {
    domain-record = "${var.domain}."
}

resource "google_dns_managed_zone" "website" {
  name          = replace("${var.domain}", ".", "")
  dns_name      = local.domain-record
  force_destroy = "true"
}

resource "google_dns_record_set" "default" {
  name         = google_dns_managed_zone.website.dns_name
  managed_zone = google_dns_managed_zone.website.name
  type         = "A"
  ttl          = 300
  rrdatas = [
    var.lb-address
  ]
}
