#db instance
#deploy db and register in consul using user-data
resource "google_compute_instance" "db" {
  name = "postgres"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "nachor22:${file("data/id_rsa.pub")}"
    user-data = file("userdata/userdata_db.yaml")
  }

  service_account {
    email  = google_service_account.sa-consul.email
    scopes = ["cloud-platform"]
  }
}
