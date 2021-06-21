#db instance
#deploy db and register in consul using user-data
data "template_file" "ud-db" {
  template = file("userdata/userdata_db.yaml")
  #db pass
  vars = {
    db_pass = random_password.db_pass.result
  }
}

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
    user-data = data.template_file.ud-db.rendered
  }

  service_account {
    email  = google_service_account.sa-consul.email
    scopes = ["cloud-platform"]
  }
}

resource "random_password" "db_pass" {
  length           = 16
  special          = false
}
