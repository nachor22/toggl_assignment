#service account used by instances to discover consul datacenter
resource "google_service_account" "sa-consul" {
  account_id = "sa-consul"
  display_name = "sa-consul"
}

resource "google_project_iam_member" "consul-viewer" {
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.sa-consul.email}"
}
