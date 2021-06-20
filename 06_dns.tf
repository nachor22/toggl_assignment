resource "google_dns_managed_zone" "zone" {
  name        = "toggl-zone"
  dns_name    = "${var.dns_zone}."
  description = "DNS zone"
}

resource "google_dns_record_set" "toggl" {
  managed_zone = google_dns_managed_zone.zone.name
  name         = "toggl_test.${var.dns_zone}."
  type         = "A"
  rrdatas      = ["${google_compute_global_address.toggl.address}"]
  ttl          = 300
}

output "dns_nameservers" {
  value = google_dns_managed_zone.zone.name_servers
}
