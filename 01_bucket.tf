resource "google_storage_bucket" "public" {
  name        = "toggl-public"
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.public.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  source = "public/index.html"
  bucket = google_storage_bucket.public.name
  depends_on = [google_storage_default_object_access_control.public_rule]
}

resource "google_storage_bucket_object" "main" {
  name   = "main.js"
  source = "public/main.js"
  bucket = google_storage_bucket.public.name
  depends_on = [google_storage_default_object_access_control.public_rule]
}
