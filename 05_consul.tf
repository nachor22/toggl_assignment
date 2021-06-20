#consul servers cluster
#consul installation and execution using user-data
resource "google_compute_instance_template" "consul" {
  machine_type = "e2-small"

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
    boot              = true
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  tags = ["health-check-8500", "consul-node"]

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
    ssh-keys = "nachor22:${file("data/id_rsa.pub")}"
    user-data = file("userdata/userdata_consul.yaml")
  }

  service_account {
    email  = google_service_account.sa-consul.email
    scopes = ["cloud-platform"]
  }

}

resource "google_compute_instance_group_manager" "consul" {
  name               = "consul-gm"
  version {
    instance_template  = google_compute_instance_template.consul.id
  }
  named_port {
    name = "consul-ui"
    port = 8500
  }

  base_instance_name = "consul-gm"
  zone               = var.zone_consul
  target_size        = "3"
}
