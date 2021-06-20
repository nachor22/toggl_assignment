#external IP
resource "google_compute_global_address" "toggl" {
  name = "toggl"
}

#forward port 80
resource "google_compute_global_forwarding_rule" "toggl" {
  name       = "toggl-port-80"
  ip_address = "${google_compute_global_address.toggl.address}"
  port_range = "80"
  target     = "${google_compute_target_http_proxy.toggl.self_link}"
}

resource "google_compute_target_http_proxy" "toggl" {
  name    = "toggl"
  url_map = "${google_compute_url_map.toggl.self_link}"
}

#paths definitions
resource "google_compute_url_map" "toggl" {
  name        = "toggl"
  default_service = google_compute_backend_bucket.public.self_link

  host_rule {
    hosts = ["*"]
    path_matcher = "toggl"
  }

  path_matcher {
    name            = "toggl"
    default_service = google_compute_backend_bucket.public.self_link

    path_rule {
      paths   = ["/api/*"]
      service = google_compute_backend_service.api.self_link
    }

    path_rule {
      paths   = ["/"]
      url_redirect {
        path_redirect = "index.html"
        strip_query = false
      }
    }

    path_rule {
      paths   = ["/ui/", "/ui/*", "/v1/*"]
      service = google_compute_backend_service.consul.self_link
    }

  }
}

#public backend bucket
resource "google_compute_backend_bucket" "public" {
  name        = "toggl-public"
  bucket_name = google_storage_bucket.public.name
  enable_cdn  = true
}

#api backend service and healthcheck
resource "google_compute_backend_service" "api" {
  name             = "api-backend"
  port_name        = "http"
  backend {
    group = google_compute_instance_group_manager.api.instance_group
  }

  health_checks = [google_compute_http_health_check.api.id]
}

resource "google_compute_http_health_check" "api" {
  name               = "api"
  request_path       = "/api/status"
  check_interval_sec = 1
  timeout_sec        = 1
  port = 80
}

#consul backend service and healthcheck
resource "google_compute_backend_service" "consul" {
  name             = "consul-backend"
  port_name        = "consul-ui"
  backend {
    group = google_compute_instance_group_manager.consul.instance_group
  }

  health_checks = [google_compute_http_health_check.consul.id]
}

resource "google_compute_http_health_check" "consul" {
  name               = "consul"
  request_path       = "/ui/"
  check_interval_sec = 1
  timeout_sec        = 1
  port = 8500
}

#firewall rules to allow healthchecks
resource "google_compute_firewall" "api_health" {
  name    = "api-firewall"
  network = "default"

  description = "allow Google health checks and network load balancers access"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["health-check-80"]
}

resource "google_compute_firewall" "consul_health" {
  name    = "consul-firewall"
  network = "default"

  description = "allow Google health checks and network load balancers access"

  allow {
    protocol = "tcp"
    ports    = ["8500"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["health-check-8500"]
}

#Output LB IP
output "lb_ip" {
  value = google_compute_global_address.toggl.address
}
