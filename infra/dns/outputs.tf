output "nameservers" {
  value = google_dns_managed_zone.website.name_servers
}
