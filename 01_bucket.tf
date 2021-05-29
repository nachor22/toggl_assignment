resource "google_storage_bucket" "toggl_test_static_content" {
  name        = "toggl_test_static_content"
}

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  source = "public/index.html"
  bucket = google_storage_bucket.toggl_test_static_content.name
}

resource "google_storage_bucket_object" "main" {
  name   = "main.js"
  source = "public/main.js"
  bucket = google_storage_bucket.toggl_test_static_content.name
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.toggl_test_static_content.name
  role   = "READER"
  entity = "allUsers"
}

output "bucket_domain" {
  value = google_storage_bucket_object.index.media_link
}
