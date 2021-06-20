#api server with autoscaler
#userdata used to deploy app and register in consul
data "template_file" "ud-api" {
  template = file("userdata/userdata_api.yaml")
  #db host IP
  vars = {
    db_ip = google_compute_instance.db.network_interface.0.network_ip
  }
}

resource "google_compute_instance_template" "apiserver" {
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

  tags = ["health-check-80"]

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
    ssh-keys = "nachor22:${file("data/id_rsa.pub")}"
    user-data = data.template_file.ud-api.rendered
  }

  service_account {
    email  = google_service_account.sa-consul.email
    scopes = ["cloud-platform"]
  }

}

resource "google_compute_instance_group_manager" "api" {
  name               = "api-group-manager"
  version {
    instance_template  = google_compute_instance_template.apiserver.id
  }
  named_port {
    name = "http"
    port = 80
  }

  base_instance_name = "api-gm"
  zone               = var.zone
}

resource "google_compute_autoscaler" "api" {
  name   = "api-autoscaler"
  target = google_compute_instance_group_manager.api.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 120

    cpu_utilization {
      target = 0.75
    }
  }
}
